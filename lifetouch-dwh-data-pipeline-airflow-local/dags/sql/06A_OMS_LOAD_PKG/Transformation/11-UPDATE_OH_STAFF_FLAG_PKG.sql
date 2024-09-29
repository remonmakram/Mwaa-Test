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
/* drop temp_oh_staff_flag */

BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.temp_oh_staff_flag';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* create temp_oh_staff_flag */

create table rax_app_user.temp_oh_staff_flag as
select oh.order_header_oid
, min(NVL(s.staff_flag, 0)) as staff_flag
from ods_own.order_header oh
, ods_own.capture_session cs
, ods_own.image i
, ods_own.subject_image si
, ods_own.subject s
where oh.matched_capture_session_id = cs.lab_session_id
and cs.capture_session_oid = i.capture_session_oid
and i.image_oid = si.image_image_oid
and si.subject_subject_oid = s.subject_oid
and UPPER(TRIM(oh.order_type)) != 'Account_Order'
and s.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap /* only recently changed rows */
group by oh.order_header_oid



&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* create index on temp_oh_staff_flag */

create unique index rax_app_user.temp_oh_staff_flag_pk on rax_app_user.temp_oh_staff_flag(order_header_oid)

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* update order_header.staff_flag */

update 
(
select src.staff_flag as src_staff_flag
, trg.staff_flag as trg_staff_flag
, trg.ods_modify_date as trg_ods_modify_date
from ods_own.order_header trg
, rax_app_user.temp_oh_staff_flag src
where trg.order_header_oid = src.order_header_oid
and (trg.staff_flag <> src.staff_flag
     or trg.staff_flag is null
    )
)
set trg_staff_flag = src_staff_flag
, trg_ods_modify_date = sysdate

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

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
CONTEXT_NAME              
)
values (
:v_cdc_load_table_name,
:v_sess_no,
'UPDATE_OH_STAFF_FLAG_PKG',
'002',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          ),
:v_cdc_overlap,
SYSDATE,
 :v_env)

&


/*-----------------------------------------------*/
