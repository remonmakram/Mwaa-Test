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
/* MIP_SFLY_INTEGRATION_XR */

insert into ods_stage.mip_sfly_integration_xr
( sfly_integration_id
,mip_sfly_integration_oid
,customer_order_id
,ods_create_date
)
select  sfly_integration_id
, ods_stage.mip_sfly_integration_oid_seq.nextval
, customer_order_id
, sysdate
from ods_stage.mip_sfly_integration_stg s
where s.ods_modify_date >= to_date(substr(:v_cdc_load_date, 1, 19), 'yyyy-mm-dd hh24:mi:ss') - :v_cdc_overlap
and not exists
( 
select 1
from ods_stage.mip_sfly_integration_xr t
where s.sfly_integration_id = t.sfly_integration_id
)

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* MIP_SFLY_INTEGRATION */

merge into ods_own.mip_sfly_integration t using
(
select xr.mip_sfly_integration_oid
,xr2.mip_customer_order_oid
,stg.sfly_integration_id
,stg.customer_order_id
,stg.image_render_asset_id
,stg.transaction_id
,stg.type
,stg.s3_bucket
,stg.s3_key
,stg.audit_create_date
,stg.audit_modified_date
,stg.version
, ss.source_system_oid
from ods_stage.mip_sfly_integration_stg stg
, ods_stage.mip_sfly_integration_xr xr
, ods_stage.mip_customer_order_xr xr2
, ods_own.source_system ss
where stg.sfly_integration_id = xr.sfly_integration_id
and stg.customer_order_id = xr2.customer_order_id(+)
and 'MIP' = ss.source_system_short_name
and stg.ods_modify_date >= to_date(substr(:v_cdc_load_date, 1, 19), 'yyyy-mm-dd hh24:mi:ss') - :v_cdc_overlap
) s
on ( s.mip_sfly_integration_oid = t.mip_sfly_integration_oid )
when matched then update
set t.customer_order_id = s.customer_order_id
, t.image_render_asset_id = s.image_render_asset_id
, t.transaction_id = s.transaction_id
, t.type = s.type
, t.s3_bucket = s.s3_bucket
, t.s3_key = s.s3_key
, t.audit_create_date = s.audit_create_date
, t.audit_modified_date = s.audit_modified_date
, t.version = s.version
, t.ods_modify_date = sysdate
where decode(t.customer_order_id,s.customer_order_id,1,0) = 0
or decode(t.image_render_asset_id,s.image_render_asset_id,1,0) = 0
or decode(t.transaction_id,s.transaction_id,1,0) = 0
or decode(t.type,s.type,1,0) = 0
or decode(t.s3_bucket,s.s3_bucket,1,0) = 0
or decode(t.s3_key,s.s3_key,1,0) = 0
or decode(t.audit_create_date,s.audit_create_date,1,0) = 0
or decode(t.audit_modified_date,s.audit_modified_date,1,0) = 0
or decode(t.version,s.version,1,0) = 0
when not matched then insert
(t.mip_sfly_integration_oid
,t.mip_customer_order_oid
,t.sfly_integration_id
,t.customer_order_id
,t.image_render_asset_id
,t.transaction_id
,t.type
,t.s3_bucket
,t.s3_key
,t.audit_create_date
,t.audit_modified_date
,t.version
,t.ods_create_date
,t.ods_modify_date
,t.source_system_oid
)
values
(s.mip_sfly_integration_oid
,s.mip_customer_order_oid
,s.sfly_integration_id
,s.customer_order_id
,s.image_render_asset_id
,s.transaction_id
,s.type
,s.s3_bucket
,s.s3_key
,s.audit_create_date
,s.audit_modified_date
,s.version
,sysdate
,sysdate
,s.source_system_oid
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
,'LOAD_MIP_SFLY_INTEGRATOIN_PKG'
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
'LOAD_MIP_SFLY_INTEGRATOIN_PKG',
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
