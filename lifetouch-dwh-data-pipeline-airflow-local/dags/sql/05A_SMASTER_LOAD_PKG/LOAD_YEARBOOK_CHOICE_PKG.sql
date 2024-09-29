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

MERGE INTO ods_stage.yearbook_choice_xr d
     USING (SELECT s.YEARBOOK_CHOICE_ID, s.SUBJECT_ID, s.APO_ID
              FROM ods_stage.sm_yearbook_choice_stg s
             WHERE s.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap ) s
        ON (s.yearbook_choice_id = d.sk_yearbook_choice_id)
WHEN NOT MATCHED
THEN
   INSERT     (yearbook_choice_oid,
               sk_yearbook_choice_id,
               sk_apo_id,
               sk_subject_id,
               ods_create_date,
               ods_modify_date)
       VALUES (ods_stage.yearbook_choice_oid_seq.NEXTVAL,
               s.yearbook_choice_id,
               s.apo_ID,
               s.subject_id,
               SYSDATE,
               SYSDATE)
WHEN MATCHED
THEN
   UPDATE SET
      d.sk_apo_id = s.apo_id,
      d.sk_subject_id = s.subject_id,
      d.ods_modify_date = SYSDATE
           WHERE    DECODE (s.apo_id, d.sk_apo_id, 1, 0) = 0
                 OR DECODE (s.subject_id, d.sk_subject_id, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Merge into Yearbook_Choice */

MERGE INTO ODS_OWN.YEARBOOK_CHOICE d
     USING (SELECT xr.YEARBOOK_CHOICE_OID,
                   sxr.SUBJECT_OID,
                   a.APO_oID,
                   ss.SOURCE_SYSTEM_OID,
                   stg.CHOICE_NUMBER,
                   stg.EXCLUDED,
                   stg.CONFIRMED,
                   stg.CHOICE_MADE_BY,
                   stg.IMAGE_LOOK_RECIPE_ID,
                   stg.CHOICE_MADE_WHEN,
                   stg.CHOICE_MADE_BY_ROLE
              FROM ODS_STAGE.SM_YEARBOOK_CHOICE_STG stg,
                   ODS_OWN.APO                      a,
                   ODS_STAGE.SUBJECT_XR             sxr,
                   ODS_STAGE.YEARBOOK_CHOICE_XR     xr,
                   ODS_OWN.SOURCE_SYSTEM            ss
             WHERE     stg.YEARBOOK_CHOICE_ID = xr.SK_YEARBOOK_CHOICE_ID
                   AND ss.SOURCE_SYSTEM_SHORT_NAME = 'SM'
                   AND stg.APO_ID = a.APO_ID(+)
                   AND stg.SUBJECT_ID = sxr.SUBJECT_ID(+)
                   AND stg.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap ) s
        ON (d.yearbook_choice_oid = s.yearbook_choice_oid)
WHEN MATCHED
THEN
   UPDATE SET
      d.subject_oid = s.subject_oid,
      d.apo_oid = s.apo_oid,
      d.choice_number = s.choice_number,
      d.excluded = s.excluded,
      d.confirmed = s.confirmed,
      d.choice_made_by = s.choice_made_by,
      d.IMAGE_LOOK_RECIPE_ID = s.IMAGE_LOOK_RECIPE_ID,
      d.choice_made_when = s.choice_made_when,
      d.choice_made_by_role = s.choice_made_by_role,
      d.ods_modify_date = SYSDATE
           WHERE    DECODE (s.subject_oid, d.subject_oid, 1, 0) = 0
                 OR DECODE (s.apo_oid, d.apo_oid, 1, 0) = 0
                 OR DECODE (s.choice_number, d.choice_number, 1, 0) = 0
                 OR DECODE (s.excluded, d.excluded, 1, 0) = 0
                 OR DECODE (s.confirmed, d.confirmed, 1, 0) = 0
                 OR DECODE (s.choice_made_by, d.choice_made_by, 1, 0) = 0
                 OR DECODE (s.IMAGE_LOOK_RECIPE_ID, d.IMAGE_LOOK_RECIPE_ID, 1,0) = 0
                 OR DECODE (s.choice_made_when, d.choice_made_when, 1, 0) = 0
                 OR DECODE (s.choice_made_by_role, d.choice_made_by_role, 1,0) = 0
WHEN NOT MATCHED
THEN
   INSERT     (YEARBOOK_CHOICE_OID,
               SUBJECT_OID,
               APO_OID,
               SOURCE_SYSTEM_OID,
               CHOICE_NUMBER,
               EXCLUDED,
               CONFIRMED,
               CHOICE_MADE_BY,
               IMAGE_LOOK_RECIPE_ID,
               CHOICE_MADE_WHEN,
               CHOICE_MADE_BY_ROLE,
               ODS_CREATE_DATE,
               ODS_MODIFY_DATE)
       VALUES (s.YEARBOOK_CHOICE_OID,
               s.SUBJECT_OID,
               s.APO_OID,
               s.SOURCE_SYSTEM_OID,
               s.CHOICE_NUMBER,
               s.EXCLUDED,
               s.CONFIRMED,
               s.CHOICE_MADE_BY,
               s.IMAGE_LOOK_RECIPE_ID,
               s.CHOICE_MADE_WHEN,
               s.CHOICE_MADE_BY_ROLE,
               SYSDATE,
               SYSDATE)

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Update APO_OID */

--
-- Handle late arriving APO
--
MERGE INTO ODS_OWN.YEARBOOK_CHOICE d
     USING (SELECT a.APO_OID, xr.YEARBOOK_CHOICE_OID
              FROM ods_own.apo                  a,
                   ODS_STAGE.YEARBOOK_CHOICE_XR xr,
                   ODS_OWN.YEARBOOK_CHOICE      yc
             WHERE     a.APO_ID = xr.SK_APO_ID
                   AND xr.yearbook_choice_oid = yc.yearbook_choice_oid
                   AND yc.APO_OID IS NULL
                   AND a.ODS_Create_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap) s
        ON (d.yearbook_choice_oid = s.yearbook_choice_oid)
WHEN MATCHED
THEN
   UPDATE SET d.apo_oid = s.apo_oid, d.ods_modify_date = SYSDATE
           WHERE d.apo_oid IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Update Subject_OID */

--
-- Handle late arriving Subject
--
MERGE INTO ODS_OWN.YEARBOOK_CHOICE d
     USING (SELECT sxr.subject_OID, xr.YEARBOOK_CHOICE_OID
              FROM ods_stage.subject_xr         sxr,
                   ODS_STAGE.YEARBOOK_CHOICE_XR xr,
                   ODS_OWN.YEARBOOK_CHOICE      yc
             WHERE     sxr.SUBJECT_ID = xr.SK_subject_ID
                   AND xr.yearbook_choice_oid = yc.yearbook_choice_oid
                   AND yc.subject_OID IS NULL
                   AND sxr.ODS_Create_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap) s
        ON (d.yearbook_choice_oid = s.yearbook_choice_oid)
WHEN MATCHED
THEN
   UPDATE SET d.subject_oid = s.subject_oid, d.ods_modify_date = SYSDATE
           WHERE d.subject_oid IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 9 */
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
,'LOAD_YEARBOOK_CHOICE_PKG'
,'006'
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
'LOAD_YEARBOOK_CHOICE_PKG',
'006',
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
