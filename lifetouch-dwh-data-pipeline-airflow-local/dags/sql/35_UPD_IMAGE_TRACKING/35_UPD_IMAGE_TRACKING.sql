/* TASK No. 1 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 2 */




/*-----------------------------------------------*/
/* TASK No. 3 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 3 */




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
/* Drop SM Temp Table */





BEGIN  
   EXECUTE IMMEDIATE 'Drop table TMP_SUBJECT_MASTER_MATCH_DATE';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Create SM Temp Table */

CREATE TABLE TMP_SUBJECT_MASTER_MATCH_DATE AS
select distinct IMAGE_IMPORT_GROUP || lpad(i.CAPTURE_SEQUENCE,4,'0')||to_number(substr(e.school_year, 3, 2)-1) as SSK
,max(I.ODS_CREATE_DATE) as S_MATCH_DATE
,CS.EVENT_OID
,substr(CS.JOB_ALPHA_NBR, 1, 10) as Job_Num
,i.ODS_MODIFY_DATE
from ODS_OWN.IMAGE I
join ODS_OWN.CAPTURE_SESSION CS on I.CAPTURE_SESSION_OID = CS.CAPTURE_SESSION_OID
join ODS_OWN.EVENT E on CS.EVENT_OID = E.EVENT_OID
where length(I.IMAGE_IMPORT_GROUP) = '12'
and substr(CS.JOB_ALPHA_NBR, 1, 10) != NULL
and I.ODS_MODIFY_DATE >= ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap)
group by IMAGE_IMPORT_GROUP || lpad(i.CAPTURE_SEQUENCE,4,'0')||to_number(substr(e.school_year, 3, 2)-1),CS.EVENT_OID,substr(CS.JOB_ALPHA_NBR, 1, 10),i.ODS_MODIFY_DATE

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Create Index for SM Driver */

CREATE UNIQUE INDEX TMP_SM_MATCH_DATE_IX on TMP_SUBJECT_MASTER_MATCH_DATE(SSK)

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Drop TMP table for -1 Event OID */



BEGIN  
   EXECUTE IMMEDIATE 'drop table TMP_SM_MATCH_MISSING_EVENTOID';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  
&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Create TMP table for -1 Event OID */

CREATE TABLE TMP_SM_MATCH_MISSING_EVENTOID AS
select tmp.SSK || to_number(substr(e.school_year, 3, 2)-1) as NEW_SSK, tmp.EVENT_OID, tmp.SSK as OLD_SSK
from TMP_SUBJECT_MASTER_MATCH_DATE tmp
join ODS_OWN.EVENT E on tmp.JOB_NUM = E.EVENT_REF_ID
where tmp.EVENT_OID = '-1'

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Update SM TMP table with new SSK */

UPDATE TMP_SUBJECT_MASTER_MATCH_DATE SM_TEMP
SET
(
SM_TEMP.SSK
)
=
(
SELECT
temp.NEW_SSK
FROM TMP_SM_MATCH_MISSING_EVENTOID temp
where SM_TEMP.SSK = temp.OLD_SSK and SM_TEMP.EVENT_OID = '-1'
)
where exists
(select 1 from TMP_SM_MATCH_MISSING_EVENTOID temp where SM_TEMP.SSK = temp.OLD_SSK and SM_TEMP.EVENT_OID = '-1')

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Update Image_Tracking with SM Date */

update
(
SELECT
S.S_MATCH_DATE
, t.subject_match_date as t_subject_match_date
, t.ods_modify_Date as t_ods_modify_date
FROM TMP_SUBJECT_MASTER_MATCH_DATE S
join ODS_OWN.IMAGE_TRACKING T on S.SSK = T.SOURCE_SYSTEM_KEY
)
set T_Subject_Match_Date = S_MATCH_DATE, T_ODS_MODIFY_DATE = SYSDATE

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Drop CIR Temp Table */


BEGIN  
   EXECUTE IMMEDIATE 'drop table TMP_CIR_MATCH_DATE';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  
&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Create CIR Temp table */

CREATE TABLE TMP_CIR_MATCH_DATE AS
select distinct CIR.SOURCE_SYSTEM_CODE as SSK, CIR.AUDIT_CREATE_DATE as CIR_MATCH_DATE
from ODS_STAGE.CIR_IMAGE_GROUP CIR
join ODS_OWN.IMAGE_TRACKING IT
on CIR.SOURCE_SYSTEM_CODE = IT.SOURCE_SYSTEM_KEY
where IT.CIR_RECEIVE_DATE is null
and CIR.ODS_MODIFY_DATE >= ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap)

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Create Index for CIR Driver */

CREATE UNIQUE INDEX TMP_CIR_MATCH_DATE_IX on TMP_CIR_MATCH_DATE(SSK)

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Update Image_Tracking with CIR Date */

update
(
SELECT
S.CIR_MATCH_DATE
, t.CIR_RECEIVE_DATE as t_CIR_RECEIVE_DATE
, t.ods_modify_Date as t_ods_modify_date
FROM TMP_CIR_MATCH_DATE S
join ODS_OWN.IMAGE_TRACKING T on S.SSK = T.SOURCE_SYSTEM_KEY
)
set T_CIR_RECEIVE_DATE = CIR_MATCH_DATE, T_ODS_MODIFY_DATE = SYSDATE

&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Drop Table tmp_Image_Track_RollOver_Fix */


BEGIN  
   EXECUTE IMMEDIATE 'drop table tmp_Image_Track_RollOver_Fix';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  
&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Create table tmp_Image_Track_RollOver_Fix */

Create table tmp_Image_Track_RollOver_Fix as
select distinct
IT.EVENT_REF_ID,
E.PLANT_RECEIPT_DATE
from ODS_OWN.IMAGE_TRACKING IT
join ODS_OWN.EVENT E on IT.EVENT_REF_ID = E.EVENT_REF_ID
where E.ROLLOVER_JOB_IND = 'X'
and IT.ODS_MODIFY_DATE >= ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap)

&

--/*--------------- TESTING -------------------*/
--INSERT INTO tmp_Image_Track_RollOver_Fix (EVENT_REF_ID,PLANT_RECEIPT_DATE) values('0',( TO_DATE(SUBSTR('2024-01-01 14:01:35', 1, 19), 'YYYY-MM-DD HH24:MI:SS') ))
--
--
--&
/*-----------------------------------------------*/
/* TASK No. 20 */
/* Update IMAGE_TRACKING with new Source_Create_Date for Rollovers */

UPDATE ODS_OWN.IMAGE_TRACKING IT
SET
(
IT.SOURCE_CREATE_DATE
)
=
(
SELECT
temp.PLANT_RECEIPT_DATE
FROM tmp_Image_Track_RollOver_Fix temp
where IT.EVENT_REF_ID = temp.EVENT_REF_ID
)
where exists
(select 1 from tmp_Image_Track_RollOver_Fix temp where IT.EVENT_REF_ID = temp.EVENT_REF_ID)

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name


&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* Insert CDC Audit Record */

INSERT INTO RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
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
'35_UPD_IMAGE_TRACKING',
'002',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_ld_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          ),
:v_cdc_oms_overlap,
SYSDATE)

&


/*-----------------------------------------------*/
