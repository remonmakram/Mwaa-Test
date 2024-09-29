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
/* drop driver table */

BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_subject_apo';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;


&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* create driver table */

create table RAX_APP_USER.tmp_subject_apo as
select sa.subject_apo_oid, s.first_name as subject_first_name, s.last_name as subject_last_name
, s.grade, sa.pipeline_sub_status, sa.buyer_type
from ODS_OWN.subject_apo sa
, ODS_OWN.subject s
where 1=1
and sa.subject_oid = s.subject_oid
and sa.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* merge */

merge into MART.subject_apo t
using
( 
select subject_apo_oid,  subject_first_name, subject_last_name
, grade, pipeline_sub_status, buyer_type
from RAX_APP_USER.tmp_subject_apo 
) s
on
(   s.subject_apo_oid = t.subject_apo_oid
)
when matched then update
set t.subject_first_name = s.subject_first_name
, t.subject_last_name = s.subject_last_name
, t.grade = s.grade
, t.pipeline_sub_status = s.pipeline_sub_status
, t.buyer_type = s.buyer_type
, t.mart_modify_date = sysdate
where t.subject_first_name <> s.subject_first_name
or t.subject_last_name <> s.subject_last_name
or t.grade <> s.grade
or decode(t.pipeline_sub_status,s.pipeline_sub_status,1,0) = 0
or decode(t.buyer_type,s.buyer_type,1,0) = 0
when not matched then insert
( t.subject_apo_id
, t.subject_apo_oid
, t.subject_first_name
, t.subject_last_name
, t.grade
, t.pipeline_sub_status
, t.buyer_type
, t.mart_modify_date
, t.mart_create_date
)
values
( MART.subject_apo_id_seq.nextval
, s.subject_apo_oid
, s.subject_first_name
, s.subject_last_name
, s.grade
, s.pipeline_sub_status
, s.buyer_type
, sysdate
, sysdate
)

&


/*-----------------------------------------------*/
/* TASK No. 7 */
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
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/

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
,'LOAD_MART_SUBJECT_APO_PKG'
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
'LOAD_MART_SUBJECT_APO_PKG',
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


&


/*-----------------------------------------------*/
