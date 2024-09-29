/* TASK No. 1 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 2 */




/*-----------------------------------------------*/
/* TASK No. 3 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 3 */




/*-----------------------------------------------*/
/* TASK No. 4 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 4 */




/*-----------------------------------------------*/
/* TASK No. 5 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 5 */




/*-----------------------------------------------*/
/* TASK No. 6 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 6 */




/*-----------------------------------------------*/
/* TASK No. 7 */
/* Merge into XR */

MERGE INTO ODS_STAGE.sf_selling_method_xr t
     USING (SELECT s.DESCRIPTION, s.LOOKUPCODE
              FROM ODS_STAGE.sf_legacylookup_stg s
             WHERE     lookuptype = 'LTBookingOppSellingMethod'
                   AND ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (s.description = t.description)
WHEN NOT MATCHED
THEN
    INSERT     (selling_method_oid,
                description,
                lookupcode,
                ods_create_date,
                ods_modify_date)
        VALUES (
            ODS_STAGE.SELLING_METHOD_OID_SEQ.NEXTVAL,
            s.description,
            s.lookupcode,
            SYSDATE,
            SYSDATE)
WHEN MATCHED
THEN
    UPDATE SET t.lookupcode = s.lookupcode, t.ods_modify_date = SYSDATE
             WHERE DECODE (T.lookupcode, S.lookupcode, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Merge into Selling_Method */

MERGE INTO ODS_OWN.selling_method t
     USING (SELECT xr.SELLING_METHOD_OID,
                   xr.DESCRIPTION,
                   xr.LOOKUPCODE,
                   ss.source_system_oid
              FROM ODS_STAGE.sf_selling_method_xr  xr,
                   ods_own.source_system                 ss,
                   ODS_STAGE.SF_LEGACYLOOKUP_STG         stg
             WHERE     xr.LOOKUPCODE = stg.LOOKUPCODE
                   AND stg.LOOKUPTYPE = 'LTBookingOppSellingMethod'
                   AND xr.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
                   AND ss.SOURCE_SYSTEM_SHORT_NAME = 'SF') s
        ON (s.selling_method_oid = t.selling_method_oid)
WHEN NOT MATCHED
THEN
    INSERT     (SELLING_METHOD_OID,
                SELLING_METHOD,
                SOURCE_SYSTEM_OID,
                AMS_SELLING_METHOD_CODE,
                DESCRIPTION,
                ODS_CREATE_DATE,
                ODS_MODIFY_DATE,
                CREATED_BY,
                UPDATED_BY)
        VALUES (s.selling_method_oid,
                s.description,
                s.source_system_oid,
                s.lookupcode,
                s.description,
                SYSDATE,
                SYSDATE,
                'ODI_ETL',
                'ODI_ETL')
WHEN MATCHED
THEN
    UPDATE SET
        t.AMS_SELLING_METHOD_CODE = s.lookupcode, ods_modify_date = SYSDATE
             WHERE DECODE (s.lookupcode, t.AMS_SELLING_METHOD_CODE, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
+ nvl((TIMEZONE_OFFSET/24), 0) 
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

/*
UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR('2024-08-28 02:38:40.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Insert CDC Audit Record */

INSERT INTO RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
(TABLE_NAME,
SESS_NO,                      
SESS_NAME,                    
SCEN_VERSION,                 
SESS_BEG,                     
ORIG_LAST_CDC_COMPLETION_DATE,
OVERLAP,
CREATE_DATE,
CONTEXT_NAME,
TIMEZONE_OFFSET              
)
select 
:v_cdc_load_table_name
,:v_sess_no
,'LOAD_SF_LEGACYLOOKUP_STG_PKG'
,'008'
,TO_DATE(SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
,TO_DATE (SUBSTR(:v_cdc_load_date, 1, 19),'YYYY-MM-DD HH24:MI:SS')
,:v_cdc_overlap
,SYSDATE
,:v_env
,TIMEZONE_OFFSET
from 
ODS_OWN.ODS_CDC_LOAD_STATUS
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

/*
INSERT INTO RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
(TABLE_NAME,
SESS_NO,                      
SESS_NAME,                    
SCEN_VERSION,                 
SESS_BEG,                     
ORIG_LAST_CDC_COMPLETION_DATE,
OVERLAP,
CREATE_DATE,
CONTEXT_NAME              
)
values (
:v_cdc_load_table_name,
30601905200,
'LOAD_SF_LEGACYLOOKUP_STG_PKG',
'008',
TO_DATE(
             SUBSTR('2024-08-28 02:38:40.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/


&


/*-----------------------------------------------*/
