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
/* MIP_CUSTOMER_ORDER_XR */

insert into ods_stage.mip_customer_order_xr
( CUSTOMER_ORDER_ID
, MIP_CUSTOMER_ORDER_OID
, ORDER_NO
, ODS_CREATE_DATE
)
select  CUSTOMER_ORDER_ID
, ods_stage.MIP_CUSTOMER_ORDER_OID_SEQ.nextval
, ORDER_NO
, sysdate
from ods_stage.mip_customer_order_stg s
where s.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap
and not exists
( 
select 1
from ods_stage.mip_customer_order_xr t
where s.customer_order_id = t.customer_order_id
)

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* MIP_CUSTOMER_ORDER */

merge into ods_own.mip_customer_order t using
(
select xr.mip_customer_order_oid
, stg.CUSTOMER_ORDER_ID
, stg.SHIPMENT_KEY
, stg.ORDER_NO
, stg.CUSTOMER_KEY
, stg.CUSTOMER_ORDER_MESSAGE_KEY
, stg.STATUS
, stg.S3_BUCKET
, stg.S3_KEY
, stg.PROCESSING_START_TIME
, stg.AUDIT_CREATE_DATE
, stg.AUDIT_MODIFIED_DATE
, stg.VERSION
, oh.order_header_oid
, ss.source_system_oid
from ods_stage.mip_customer_order_stg stg
, ods_stage.mip_customer_order_xr xr
, (select order_header_oid, order_no from ods_own.order_header where order_bucket not in ('CART','CANCELLED')) oh
, ods_own.source_system ss
where stg.customer_order_id = xr.customer_order_id
and stg.order_no = oh.order_no(+)
and 'MIP' = ss.source_system_short_name
and stg.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap
) s
on ( s.mip_customer_order_oid = t.mip_customer_order_oid )
when matched then update
set t.ORDER_HEADER_OID = s.ORDER_HEADER_OID
, t.SHIPMENT_KEY = s.SHIPMENT_KEY
, t.ORDER_NO = s.ORDER_NO
, t.CUSTOMER_KEY = s.CUSTOMER_KEY
, t.CUSTOMER_ORDER_MESSAGE_KEY = s.CUSTOMER_ORDER_MESSAGE_KEY
, t.STATUS = s.STATUS
, t.S3_BUCKET = s.S3_BUCKET
, t.S3_KEY = s.S3_KEY
, t.PROCESSING_START_TIME = s.PROCESSING_START_TIME
, t.AUDIT_CREATE_DATE = s.AUDIT_CREATE_DATE
, t.AUDIT_MODIFIED_DATE = s.AUDIT_MODIFIED_DATE
, t.VERSION = s.VERSION
, t.ODS_MODIFY_DATE = sysdate
where decode(t.ORDER_HEADER_OID,s.ORDER_HEADER_OID,1,0) = 0
or decode(t.SHIPMENT_KEY,s.SHIPMENT_KEY,1,0) = 0
or decode(t.ORDER_NO,s.ORDER_NO,1,0) = 0
or decode(t.CUSTOMER_KEY,s.CUSTOMER_KEY,1,0) = 0
or decode(t.CUSTOMER_ORDER_MESSAGE_KEY,s.CUSTOMER_ORDER_MESSAGE_KEY,1,0) = 0
or decode(t.STATUS,s.STATUS,1,0) = 0
or decode(t.S3_BUCKET,s.S3_BUCKET,1,0) = 0
or decode(t.S3_KEY,s.S3_KEY,1,0) = 0
or decode(t.PROCESSING_START_TIME,s.PROCESSING_START_TIME,1,0) = 0
or decode(t.AUDIT_CREATE_DATE,s.AUDIT_CREATE_DATE,1,0) = 0
or decode(t.AUDIT_MODIFIED_DATE,s.AUDIT_MODIFIED_DATE,1,0) = 0
or decode(t.VERSION,s.VERSION,1,0) = 0
when not matched then insert
( t.MIP_CUSTOMER_ORDER_OID
, t.ORDER_HEADER_OID
, t.CUSTOMER_ORDER_ID
, t.SHIPMENT_KEY
, t.ORDER_NO
, t.CUSTOMER_KEY
, t.CUSTOMER_ORDER_MESSAGE_KEY
, t.STATUS
, t.S3_BUCKET
, t.S3_KEY
, t.PROCESSING_START_TIME
, t.AUDIT_CREATE_DATE
, t.AUDIT_MODIFIED_DATE
, t.VERSION
, t.ODS_CREATE_DATE
, t.ODS_MODIFY_DATE
, t.SOURCE_SYSTEM_OID
)
values
( s.MIP_CUSTOMER_ORDER_OID
, s.ORDER_HEADER_OID
, s.CUSTOMER_ORDER_ID
, s.SHIPMENT_KEY
, s.ORDER_NO
, s.CUSTOMER_KEY
, s.CUSTOMER_ORDER_MESSAGE_KEY
, s.STATUS
, s.S3_BUCKET
, s.S3_KEY
, s.PROCESSING_START_TIME
, s.AUDIT_CREATE_DATE
, s.AUDIT_MODIFIED_DATE
, s.VERSION
, sysdate
, sysdate
, s.SOURCE_SYSTEM_OID
)

&


/*-----------------------------------------------*/
/* TASK No. 6 */
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
/* TASK No. 7 */
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
,'LOAD_MIP_CUSTOMER_ORDER_PKG'
,'004'
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
'LOAD_MIP_CUSTOMER_ORDER_PKG',
'004',
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
