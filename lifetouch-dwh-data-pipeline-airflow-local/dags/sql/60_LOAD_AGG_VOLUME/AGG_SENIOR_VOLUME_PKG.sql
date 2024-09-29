/* TASK No. 1 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */
/* Delete <Target> Table before loading. */

DELETE  FROM  MART.AGG_SENIOR_VOLUME_FACT




&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* LOAD_DATA_MART.AGG_SENIOR_VOLUME_FACT */

INSERT INTO MART.AGG_SENIOR_VOLUME_FACT
SELECT /*+PARALLEL(F,12)*/ 
F.PLANT_NAME,
T.SEASON_NAME,
T.FISCAL_YEAR,
T.SAT_PRODUCTION_WEEK_NUMBER,
T.MONTH_NUMBER,
T.MONTH_NAME,
RG.RELEASE_GROUP,
RELEASE_CATEGORY,
SUM(F.RELEASE_QTY),
TRUNC(SYSDATE),
TRUNC(SYSDATE)
FROM
MART.RELEASE_FACT F,
MART.RELEASE_GROUP RG,
MART.TIME T
WHERE 
    F.SOURCE_SYSTEM_NAME = 'PCS/Spectrum'
AND TRUNC(F.SHIP_DATE) = T.DATE_KEY
AND F.RELEASE_GROUP_ID = RG.RELEASE_GROUP_ID
AND (T.FISCAL_YEAR = (SELECT FISCAL_YEAR FROM TIME WHERE DATE_KEY = (SELECT TRUNC(SYSDATE) FROM DUAL)) 
     OR
     T.FISCAL_YEAR = (SELECT FISCAL_YEAR - 1 FROM TIME WHERE DATE_KEY = (SELECT TRUNC(SYSDATE) FROM DUAL)))  
GROUP BY   
F.PLANT_NAME,
T.SEASON_NAME,
T.FISCAL_YEAR,
T.SAT_PRODUCTION_WEEK_NUMBER,
T.MONTH_NUMBER,
T.MONTH_NAME,
RG.RELEASE_GROUP,
RELEASE_CATEGORY,
TRUNC(SYSDATE),
TRUNC(SYSDATE)
ORDER BY 1,2,3

&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* Update CDC Load Status */

UPDATE ODS.DW_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE DW_TABLE_NAME=:v_cdc_load_table_name

&


-- /*-----------------------------------------------*/
-- /* TASK No. 5 */
-- /* Insert Audit Record */

-- INSERT INTO ODS_ETL_OWNER.DW_CDC_LOAD_STATUS_AUDIT
-- (TABLE_NAME,
-- SESS_NO,                      
-- SESS_NAME,                    
-- SCEN_VERSION,                 
-- SESS_BEG,                     
-- ORIG_LAST_CDC_COMPLETION_DATE,
-- OVERLAP,
-- CREATE_DATE              
-- )
-- values (
-- :v_cdc_load_table_name,
-- :v_sess_no,
-- 'AGG_SENIOR_VOLUME_PKG',
-- '002',
-- TO_DATE(
--              SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
-- TO_DATE (SUBSTR (:v_cdc_load_date_ODS_DM, 1, 19),
--                            'YYYY-MM-DD HH24:MI:SS'
--                           ),
-- :v_cdc_overlap,
-- SYSDATE)



-- &


/*-----------------------------------------------*/
