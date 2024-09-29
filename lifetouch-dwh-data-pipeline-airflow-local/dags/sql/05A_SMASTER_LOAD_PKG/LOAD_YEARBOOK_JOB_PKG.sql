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
/* Merge into XR */

MERGE INTO ODS_STAGE.YEARBOOK_JOB_XR d
     USING (SELECT stg.YEARBOOK_JOB_ID, stg.APO_ID
              FROM ODS_STAGE.SM_YEARBOOK_JOB_STG stg
             WHERE stg.ODS_MODIFY_DATE >= 
                       TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap) s
        ON (d.sk_yearbook_job_id = s.yearbook_job_id)
WHEN MATCHED
THEN
   UPDATE SET d.sk_apo_id = s.apo_id, ods_modify_date = SYSDATE
           WHERE DECODE (s.apo_id, d.sk_apo_id, 1, 0) = 0
WHEN NOT MATCHED
THEN
   INSERT     (YEARBOOK_JOB_OID,
               SK_YEARBOOK_JOB_ID,
               SK_APO_ID,
               ODS_CREATE_DATE,
               ODS_MODIFY_DATE)
       VALUES (ods_stage.yearbook_job_oid_seq.NEXTVAL,
               s.yearbook_job_id,
               s.apo_id,
               SYSDATE,
               SYSDATE)

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Merge into Yearbook_Job */

MERGE INTO ODS_OWN.YEARBOOK_JOB d
     USING (SELECT xr.YEARBOOK_JOB_OID,
                   a.APO_OID,
                   ss.SOURCE_SYSTEM_OID,
                   stg.YB_DELIVERY_METHOD,
                   stg.YB_CHOICE_SUBMIT_DATE,
                   stg.YB_CHOICE_STATUS,
                   stg.YB_JOB_SUBMITTED_BY
              FROM ODS_STAGE.SM_YEARBOOK_JOB_STG stg,
                   ODS_STAGE.YEARBOOK_JOB_XR     xr,
                   ods_own.apo                   a,
                   ODS_OWN.SOURCE_SYSTEM         ss
             WHERE     stg.YEARBOOK_JOB_ID = xr.SK_YEARBOOK_JOB_ID
                   AND xr.SK_APO_ID = a.APO_ID(+)
                   AND ss.SOURCE_SYSTEM_SHORT_NAME = 'SM'
                   AND stg.ODS_MODIFY_DATE >= 
                            TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap) s
        ON (d.yearbook_job_oid = s.yearbook_job_oid)
WHEN MATCHED
THEN
   UPDATE SET
      d.apo_oid = s.apo_oid,
      d.yb_delivery_method = s.yb_delivery_method,
      d.yb_choice_submit_date = s.yb_choice_submit_date,
      d.yb_choice_status = s.yb_choice_status,
      d.YB_JOB_SUBMITTED_BY = s.YB_JOB_SUBMITTED_BY,
      d.ods_modify_date = SYSDATE
           WHERE    DECODE (s.apo_oid, d.apo_oid, 1, 0) = 0
                 OR DECODE (s.yb_delivery_method, d.yb_delivery_method, 1, 0) =
                       0
                 OR DECODE (s.yb_choice_submit_date,
                            d.yb_choice_submit_date, 1,
                            0) = 0
                 OR DECODE (s.yb_choice_status, d.yb_choice_status, 1, 0) = 0
                 OR DECODE (s.YB_JOB_SUBMITTED_BY,
                            d.YB_JOB_SUBMITTED_BY, 1,
                            0) = 0
WHEN NOT MATCHED
THEN
   INSERT     (YEARBOOK_JOB_OID,
               APO_OID,
               SOURCE_SYSTEM_OID,
               YB_DELIVERY_METHOD,
               YB_CHOICE_SUBMIT_DATE,
               YB_CHOICE_STATUS,
               YB_JOB_SUBMITTED_BY,
               ODS_CREATE_DATE,
               ODS_MODIFY_DATE)
       VALUES (s.YEARBOOK_JOB_OID,
               s.APO_OID,
               s.SOURCE_SYSTEM_OID,
               s.YB_DELIVERY_METHOD,
               s.YB_CHOICE_SUBMIT_DATE,
               s.YB_CHOICE_STATUS,
               s.YB_JOB_SUBMITTED_BY,
               SYSDATE,
               SYSDATE)

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Update APO_OID */

--
-- Handle late arriving APO
--
MERGE INTO ODS_OWN.YEARBOOK_JOB d
     USING (SELECT a.APO_OID, xr.YEARBOOK_JOB_OID
              FROM ods_own.apo                  a,
                   ODS_STAGE.YEARBOOK_JOB_XR xr,
                   ODS_OWN.YEARBOOK_JOB      yj
             WHERE     a.APO_ID = xr.SK_APO_ID
                   AND xr.yearbook_job_oid = yj.yearbook_job_oid
                   AND yj.APO_OID IS NULL
                   AND a.ODS_Create_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap) s
        ON (d.yearbook_job_oid = s.yearbook_job_oid)
WHEN MATCHED
THEN
   UPDATE SET d.apo_oid = s.apo_oid, d.ods_modify_date = SYSDATE
           WHERE d.apo_oid IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 8 */
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
,'LOAD_YEARBOOK_JOB_PKG'
,'005'
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
:v_sess_no,
'LOAD_YEARBOOK_JOB_PKG',
'005',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/


&


/*-----------------------------------------------*/
