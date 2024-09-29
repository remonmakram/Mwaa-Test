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
/* Drop driver table */


 /* DROP TABLE RAX_APP_USER.CT_SUMMARY_DR */ 


BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.CT_SUMMARY_DR';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 5 */
/* CDC CT_Subject */


 /* CREATE TABLE RAX_APP_USER.CT_SUMMARY_DR
AS
   SELECT DISTINCT (APO_OID)
     FROM ODS_OWN.CT_SUBJECT S
    WHERE S.ODS_MODIFY_DATE>= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap */ 

CREATE TABLE RAX_APP_USER.CT_SUMMARY_DR
AS
   SELECT DISTINCT (APO_OID)
     FROM ODS_OWN.CT_SUBJECT S
    WHERE S.ODS_MODIFY_DATE>= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap

    

& /*-----------------------------------------------*/
/* TASK No. 6 */
/* CDC Subject_Batch */



INSERT INTO RAX_APP_USER.CT_SUMMARY_DR
   SELECT DISTINCT (APO_OID)
     FROM ODS_OWN.CT_SUBJECT S, ODS_OWN.CT_SUBJECT_BATCH SB
    WHERE     SB.CT_SUBJECT_OID = S.CT_SUBJECT_OID
          AND SB.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap
          AND NOT EXISTS (SELECT APO_OID FROM RAX_APP_USER.CT_SUMMARY_DR)

& /*-----------------------------------------------*/
/* TASK No. 7 */
/* CDC Subject */



INSERT INTO RAX_APP_USER.CT_SUMMARY_DR
   SELECT DISTINCT (APO_OID)
     FROM ODS_OWN.CT_SUBJECT S, ODS_OWN.SUBJECT OSUB
    WHERE     S.SUBJECT_OID = OSUB.SUBJECT_OID
          AND OSUB.ODS_MODIFY_DATE>= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap
          AND NOT EXISTS (SELECT APO_OID FROM RAX_APP_USER.CT_SUMMARY_DR)

& /*-----------------------------------------------*/
/* TASK No. 8 */
/* Merge into CT_Summary */



MERGE INTO ODS_OWN.CT_SUMMARY T
     USING (SELECT PHOTO.APO_ID,
                   PHOTO.APO_OID,
                   NVL (CT_PHOTO, 0)                   AS PHOTOGRAPHED,
                   NVL (STAFF.STAFF, 0)                AS STAFF,
                   NVL (CT_PHOTO - STAFF.STAFF, 0)     AS STUDENT,
                   NVL (CT_RET, 0)                     AS TOTAL_RETURN,
                   NVL ( (CT_RET / CT_PHOTO) * 100, 0) AS PERCENT_RET,
                   SS.SOURCE_SYSTEM_OID
              FROM (  SELECT A.APO_ID,
                             A.APO_OID,
                             COUNT (DISTINCT S.SUBJECT_OID) AS CT_PHOTO
                        FROM ODS_OWN.CT_BATCH         B,
                             ODS_OWN.APO              A,
                             ODS_OWN.EVENT            E,
                             ODS_OWN.CT_SUBJECT       S,
                             ODS_OWN.CT_SUBJECT_BATCH SB,
                             RAX_APP_USER.CT_SUMMARY_DR DR
                       WHERE     A.APO_OID = E.APO_OID
                             AND E.EVENT_OID = S.EVENT_OID
                             AND S.CT_SUBJECT_OID = SB.CT_SUBJECT_OID(+)
                             AND SB.CT_BATCH_OID = B.CT_BATCH_OID(+)
                             AND DR.APO_OID = S.APO_OID
                    GROUP BY A.APO_OID, A.APO_ID) PHOTO,
                   (  SELECT A.APO_ID, COUNT (DISTINCT S.SUBJECT_OID) AS STAFF
                        FROM ODS_OWN.CT_BATCH         B,
                             ODS_OWN.APO              A,
                             ODS_OWN.EVENT            E,
                             ODS_OWN.CT_SUBJECT       S,
                             ODS_OWN.CT_SUBJECT_BATCH SB,
                             ODS_OWN.SUBJECT          OSUB,
                             RAX_APP_USER.CT_SUMMARY_DR DR
                       WHERE     A.APO_OID = E.APO_OID
                             AND E.EVENT_OID = S.EVENT_OID
                             AND S.CT_SUBJECT_OID = SB.CT_SUBJECT_OID(+)
                             AND SB.CT_BATCH_OID = B.CT_BATCH_OID(+)
                             AND S.SUBJECT_OID = OSUB.SUBJECT_OID
                             AND DR.APO_OID = S.APO_OID
                             AND OSUB.STAFF_FLAG = 1
                    GROUP BY A.APO_ID) STAFF,
                   (  SELECT A.APO_ID, COUNT (DISTINCT S.SUBJECT_OID) AS CT_RET
                        FROM ODS_OWN.CT_BATCH         B,
                             ODS_OWN.APO              A,
                             ODS_OWN.EVENT            E,
                             ODS_OWN.CT_SUBJECT       S,
                             ODS_OWN.CT_SUBJECT_BATCH SB,
                             RAX_APP_USER.CT_SUMMARY_DR DR
                       WHERE     A.APO_OID = E.APO_OID
                             AND E.EVENT_OID = S.EVENT_OID
                             AND S.CT_SUBJECT_OID = SB.CT_SUBJECT_OID(+)
                             AND SB.CT_BATCH_OID = B.CT_BATCH_OID(+)
                             AND DR.APO_OID = S.APO_OID
                             AND SB.RETURNED_MATERIAL_TYPE IS NOT NULL
                    GROUP BY A.APO_ID) RET,
                   ODS_OWN.SOURCE_SYSTEM SS
             WHERE     PHOTO.APO_ID = RET.APO_ID(+)
                   AND PHOTO.APO_ID = STAFF.APO_ID(+)
                   AND SS.SOURCE_SYSTEM_SHORT_NAME = 'ODS') S
        ON (S.APO_OID = T.APO_OID)
WHEN NOT MATCHED
THEN
   INSERT     (APO_OID,
               TOTAL_PHOTOGRAPHED,
               STAFF_PACKAGES,
               STUDENT_PACKAGES,
               TOTAL_RETURN,
               PERCENTAGE_RETURNED,
               SOURCE_SYSTEM_OID,
               ODS_CREATE_DATE,
               ODS_MODIFY_DATE)
       VALUES (S.APO_OID,
               S.PHOTOGRAPHED,
               S.STAFF,
               S.STUDENT,
               S.TOTAL_RETURN,
               S.PERCENT_RET,
               S.SOURCE_SYSTEM_OID,
               SYSDATE,
               SYSDATE)
WHEN MATCHED
THEN
   UPDATE SET
      T.TOTAL_PHOTOGRAPHED = S.PHOTOGRAPHED,
      T.STAFF_PACKAGES = S.STAFF,
      T.STUDENT_PACKAGES = S.STUDENT,
      T.TOTAL_RETURN = S.TOTAL_RETURN,
      T.PERCENTAGE_RETURNED = S.PERCENT_RET,
      T.ODS_MODIFY_DATE = SYSDATE
           WHERE    DECODE (T.TOTAL_PHOTOGRAPHED, S.PHOTOGRAPHED, 1, 0) = 0
                 OR DECODE (T.STAFF_PACKAGES, S.STAFF, 1, 0) = 0
                 OR DECODE (T.STUDENT_PACKAGES, S.STUDENT, 1, 0) = 0
                 OR DECODE (T.TOTAL_RETURN, S.TOTAL_RETURN, 1, 0) = 0
                 OR DECODE (T.PERCENTAGE_RETURNED, S.PERCENT_RET, 1, 0) = 0

& /*-----------------------------------------------*/
/* TASK No. 9 */
/* Update CDC Load Status */
/*
UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/



UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
+ nvl((TIMEZONE_OFFSET/24), 0) 
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

& /*-----------------------------------------------*/
/* TASK No. 10 */
/* Insert CDC Audit Record */
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
'LOAD_CT_SUMMARY_PKG',
'001',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/



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
,'LOAD_CT_SUMMARY_PKG'
,'001'
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

& /*-----------------------------------------------*/
