/* TASK No. 1 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 2 */




/*-----------------------------------------------*/
/* TASK No. 3 */
/* Update_X1_WO_SHIPPED_HIST */

MERGE INTO ODS_STAGE.X1_WO_SHIPPED_HIST T
USING
    (
    SELECT 
    SHPD.WORK_ORDER_ID,
    SHPD.WOMS_NODE,
    ST.DESCRIPTION,
    ST.CODE,
    MAX(SH.STATUS_CHANGE_TS) STATUS_CHANGE_TS
    FROM     
    ODS_STAGE.X1_WO_SHIPPED_HIST SHPD,
    ODS_STAGE.WOMS_WORK_ORDER_DETAIL_STG WOD,
    ODS_STAGE.WOMS_STATUS_HISTORY_STG SH,
    ODS_STAGE.WOMS_STATUS_STAGE ST
    WHERE 1 = 1
    AND SHPD.WORK_ORDER_ID = WOD.WORK_ORDER_ID
    AND SHPD.WOMS_NODE = WOD.WOMS_NODE  
    AND WOD.WORK_ORDER_DETAIL_ID = SH.WORK_ORDER_DETAIL_ID
    AND WOD.WOMS_NODE = SH.WOMS_NODE
    AND SH.STATUS_ID = ST.STATUS_ID
    AND SH.WOMS_NODE = ST.SOURCE_NODE
    AND ST.CODE = 'SA'       
    AND SHPD.CHANGE_FLAG NOT IN ('C')
    AND SHPD.WORK_ORDER_STATUS NOT IN ('Error')  
    AND SHPD.ODS_MODIFY_DATE >=  ( SELECT LAST_CDC_COMPLETION_DATE 
                                   FROM ODS.DW_CDC_LOAD_STATUS
                                   WHERE DW_TABLE_NAME = 'UPDATE_X1_WO_SHIPPED_HIST') - .010     
    AND SH.ODS_MODIFY_DATE >= (SELECT MIN(DATE_KEY) FROM MART.TIME
                               WHERE FISCAL_YEAR = (SELECT FISCAL_YEAR FROM MART.TIME 
                                                    WHERE DATE_KEY = TRUNC(SYSDATE))-1)
    AND WOD.ODS_MODIFY_DATE >= (SELECT MIN(DATE_KEY) FROM MART.TIME
                               WHERE FISCAL_YEAR = (SELECT FISCAL_YEAR FROM MART.TIME 
                                                    WHERE DATE_KEY = TRUNC(SYSDATE))-1)
    GROUP BY
    SHPD.WORK_ORDER_ID,
    SHPD.WOMS_NODE,
    ST.DESCRIPTION,
    ST.CODE         
    )S
    ON (T.WORK_ORDER_ID = S.WORK_ORDER_ID AND
        T.WOMS_NODE = S.WOMS_NODE
        AND T.WORK_ORDER_STATUS NOT IN ('Error')  
        )
        WHEN MATCHED THEN UPDATE
        SET
        T.STATUS = S.DESCRIPTION,
        T.STATUS_DATE = S.STATUS_CHANGE_TS

&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* Update_Shipped_WO_With_Pending_ClassPic */

MERGE INTO ODS_STAGE.X1_WO_SHIPPED_HIST T
USING
    (
    SELECT 
    SHPD.WORK_ORDER_ID,
    SHPD.WOMS_NODE,    
    MAX(SH.STATUS_CHANGE_TS) STATUS_CHANGE_TS
    FROM     
    ODS_STAGE.X1_WO_SHIPPED_HIST SHPD,
    ODS_STAGE.WOMS_WORK_ORDER_DETAIL_STG WOD,
    ODS_STAGE.WOMS_STATUS_HISTORY_STG SH,
    ODS_STAGE.WOMS_STATUS_STAGE ST
    WHERE 1 = 1
    AND SHPD.WORK_ORDER_ID = WOD.WORK_ORDER_ID
    AND SHPD.WOMS_NODE = WOD.WOMS_NODE  
    AND WOD.WORK_ORDER_DETAIL_ID = SH.WORK_ORDER_DETAIL_ID
    AND WOD.WOMS_NODE = SH.WOMS_NODE
    AND SH.STATUS_ID = ST.STATUS_ID
    AND SH.WOMS_NODE = ST.SOURCE_NODE       
    AND SHPD.CHANGE_FLAG = 'C'        
    AND SHPD.STATUS IS NULL 
    AND SHPD.ODS_MODIFY_DATE >=  ( SELECT LAST_CDC_COMPLETION_DATE 
                                    FROM ODS.DW_CDC_LOAD_STATUS
                                    WHERE DW_TABLE_NAME = 'UPDATE_X1_WO_SHIPPED_HIST') - .010                                            
    AND SH.ODS_MODIFY_DATE >= (SELECT MIN(DATE_KEY) FROM MART.TIME
                               WHERE FISCAL_YEAR = (SELECT FISCAL_YEAR FROM MART.TIME 
                                                    WHERE DATE_KEY = TRUNC(SYSDATE))-1)
    AND WOD.ODS_MODIFY_DATE >= (SELECT MIN(DATE_KEY) FROM MART.TIME
                               WHERE FISCAL_YEAR = (SELECT FISCAL_YEAR FROM MART.TIME 
                                                    WHERE DATE_KEY = TRUNC(SYSDATE))-1)                                                    
    GROUP BY
    SHPD.WORK_ORDER_ID,
    SHPD.WOMS_NODE
    )S
    ON (T.WORK_ORDER_ID = S.WORK_ORDER_ID AND
        T.WOMS_NODE = S.WOMS_NODE
        AND T.WORK_ORDER_STATUS NOT IN ('Error')  
        )
        WHEN MATCHED THEN UPDATE
        SET
        T.STATUS = 'Shipped Acknowledged',
        T.STATUS_DATE = S.STATUS_CHANGE_TS

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Update Shipped WO with Status for  - Late arriving Records  */

--  Status arrives Later at WOMS StatusTable but gets update to WO,WOD tables early.
--  To make sure we populate Status column to the Shipped WO execute the below code.


MERGE INTO ODS_STAGE.X1_WO_SHIPPED_HIST T
USING
    (
    SELECT 
    SHPD.WORK_ORDER_ID,
    SHPD.WOMS_NODE,
    WO.STATUS,    
    MAX(WO.AUDIT_MODIFY_DATE) STATUS_CHANGE_TS
    FROM     
    ODS_STAGE.X1_WO_SHIPPED_HIST SHPD,
    ODS_STAGE.WOMS_WORK_ORDER_STG WO
    WHERE 1 = 1
    AND SHPD.WORK_ORDER_ID = WO.WORK_ORDER_ID
    AND SHPD.WOMS_NODE = WO.WOMS_NODE  
    AND SHPD.WORK_ORDER_STATUS NOT IN ('Error') 
    AND WO.STATUS IN ('Shipped Acknowledged')  
    AND SHPD.STATUS IS NULL    
    AND SHPD.ODS_MODIFY_DATE >=  (SELECT LAST_CDC_COMPLETION_DATE 
                                   FROM ODS.DW_CDC_LOAD_STATUS
                                   WHERE DW_TABLE_NAME = 'UPDATE_X1_WO_SHIPPED_HIST') - 15    
    GROUP BY
    SHPD.WORK_ORDER_ID,
    SHPD.WOMS_NODE,
    WO.STATUS                                                                
    )S
    ON (T.WORK_ORDER_ID = S.WORK_ORDER_ID AND
        T.WOMS_NODE = S.WOMS_NODE
        AND T.WORK_ORDER_STATUS NOT IN ('Error')  
        )
        WHEN MATCHED THEN UPDATE
        SET
        T.STATUS = S.STATUS,
        T.STATUS_DATE = S.STATUS_CHANGE_TS

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Update CDC Load Status */

UPDATE ODS.DW_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE DW_TABLE_NAME=:v_cdc_load_table_name

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Insert Audit Record */

INSERT INTO RAX_APP_USER.DW_CDC_LOAD_STATUS_AUDIT
(TABLE_NAME,
SESS_NO,                      
SESS_NAME,                    
SCEN_VERSION,                 
SESS_BEG,                     
ORIG_LAST_CDC_COMPLETION_DATE,
OVERLAP,
CREATE_DATE              
)
values (
:v_cdc_load_table_name,
:v_sess_no,
'UPDATE_X1_WORK_ORDER_SHIPPED_PKG',
'002',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date_ODS_DM, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          ),
:v_cdc_overlap,
SYSDATE)



&


/*-----------------------------------------------*/
