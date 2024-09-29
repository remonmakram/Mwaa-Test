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
/* drop temp table */

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_oh_order_form';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* create temp table */

create table RAX_APP_USER.tmp_oh_order_form
as
select stg.payment_id
from  ODS_STAGE.mlt_order_stg stg
where stg.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -1
having count(stg.payment_id) > 1
group by stg.payment_id

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* index temp table */

create unique index RAX_APP_USER.tmp_oh_order_form_ix on RAX_APP_USER.tmp_oh_order_form(payment_id)

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* drop temp table1 */

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_oh_order_form1';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* create temp table1 */

create table RAX_APP_USER.tmp_oh_order_form1
as
select oh.order_header_oid, tmp.payment_id
from  RAX_APP_USER.tmp_oh_order_form tmp,
ODS_STAGE.mlt_order_stg stg,
ODS_OWN.order_header oh
where tmp.payment_id = stg.payment_id
 and oh.order_form_id = to_char(stg.payment_voucher_id)




&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* index temp table1 */

create unique index RAX_APP_USER.tmp_oh_order_form1_ix on RAX_APP_USER.tmp_oh_order_form1(order_header_oid)

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* update ods_own.order_header */

update 
(
select t.mlt_multi_payment_id as target_mlt_multi_payment_id, s.payment_id as src_mlt_multi_payment_id,
t.ods_modify_date as target_ods_modify_date
from ODS_OWN.order_header t
, RAX_APP_USER.tmp_oh_order_form1 s
where t.order_header_oid = s.order_header_oid
and (t.mlt_multi_payment_id <> s.payment_id
     or t.mlt_multi_payment_id is null
    )
)
set target_mlt_multi_payment_id= src_mlt_multi_payment_id,
target_ods_modify_date = SYSDATE


&


/*-----------------------------------------------*/
/* TASK No. 11 */
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
/* TASK No. 12 */
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
,'UPDATE_OH_MLT_MULTI_PAYMENT_ID_PKG'
,'002'
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
'UPDATE_OH_MLT_MULTI_PAYMENT_ID_PKG',
'002',
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
