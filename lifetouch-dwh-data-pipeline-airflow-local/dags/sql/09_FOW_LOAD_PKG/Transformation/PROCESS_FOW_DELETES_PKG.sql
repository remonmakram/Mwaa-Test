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
/* Flag FOW Deletes  */

MERGE INTO ODS_OWN.APO a
   USING (SELECT xr.apo_oid
            FROM  ODS_STAGE.FOW_RECORD_CHANGE_AUDIT aud,
                       ODS_STAGE.APO_XR xr
           WHERE 1 = 1
             AND aud.key_value = xr.fow_sk_id
             AND xr.system_of_record = 'FOW'
             AND aud.table_name = 'APO'
             AND aud.event_type = 'DELETE'
             AND aud.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap) s
   ON (a.apo_oid = s.apo_oid)
   WHEN MATCHED THEN
      UPDATE
         SET a.status = 'Deleted', a.ods_modify_date = SYSDATE
         WHERE a.status != 'Deleted'

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* delete from ODS_STAGE.FOW_APO_STAGE */

delete from ODS_STAGE.FOW_APO_STAGE z where z.APO_OID in ( 
select 
    apo_xr.APO_OID
from 
    ods_stage.FOW_RECORD_CHANGE_AUDIT rca 
    ,ODS_STAGE.APO_XR apo_xr
where (1=1)
    and rca.TABLE_NAME = 'APO'
    and rca.EVENT_TYPE = 'DELETE'
    and rca.KEY_VALUE = apo_xr.fow_sk_id 
    and apo_xr.SYSTEM_OF_RECORD = 'FOW'
)


&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* delete 
from ODS_STAGE.FOW_EVENT_STG */

delete 
from ODS_STAGE.FOW_EVENT_STG z where z.ID in ( 
select 
    e_xr.FOW_ID
from 
    ods_stage.FOW_RECORD_CHANGE_AUDIT rca 
    ,ODS_STAGE.EVENT_XR e_xr
where (1=1)
    and rca.TABLE_NAME = 'EVENT'
    and rca.EVENT_TYPE = 'DELETE'
    and rca.KEY_VALUE = e_xr.FOW_ID 
    and e_xr.SYSTEM_OF_RECORD = 'FOW'
    and not exists (select 1 from ODS_OWN.ORDER_HEADER oh where oh.EVENT_OID=e_xr.EVENT_OID)
    and not exists (select 1 from ODS_OWN.EVENT_PAYMENT ep where ep.EVENT_OID=e_xr.EVENT_OID)
    and not exists (select 1 from ODS_OWN.SALES_RECOGNITION sr where sr.EVENT_OID = e_xr.EVENT_OID)
)


&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Update ODS_STAGE.FOW_EVENT_STG  */

UPDATE ODS_STAGE.FOW_EVENT_STG z
   SET status = 'DELETED'
 WHERE     z.ID IN
               (SELECT e_xr.FOW_ID
                  FROM ods_stage.FOW_RECORD_CHANGE_AUDIT  rca,
                       ODS_STAGE.EVENT_XR                 e_xr
                 WHERE     (1 = 1)
                       AND rca.TABLE_NAME = 'EVENT'
                       AND rca.EVENT_TYPE = 'DELETE'
                       AND rca.KEY_VALUE = e_xr.FOW_ID
                       AND e_xr.SYSTEM_OF_RECORD = 'FOW')
       AND NVL (status, 'NULL') != 'DELETED'

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* delete 
from ODS_OWN.EVENT */

delete 
from ODS_OWN.EVENT z where z.EVENT_OID in ( 
select 
    e_xr.EVENT_OID
from 
    ods_stage.FOW_RECORD_CHANGE_AUDIT rca 
    ,ODS_STAGE.EVENT_XR e_xr
where (1=1)
    and rca.TABLE_NAME = 'EVENT'
    and rca.EVENT_TYPE = 'DELETE'
    and rca.KEY_VALUE = e_xr.FOW_ID 
    and e_xr.SYSTEM_OF_RECORD = 'FOW'
    and not exists (select 1 from ODS_OWN.ORDER_HEADER oh where oh.EVENT_OID=e_xr.EVENT_OID)
    and not exists (select 1 from ODS_OWN.EVENT_PAYMENT ep where ep.EVENT_OID=e_xr.EVENT_OID)
    and not exists (select 1 from ODS_OWN.SALES_RECOGNITION sr where sr.EVENT_OID = e_xr.EVENT_OID)
)


&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* update event.status when children present */

update ODS_OWN.EVENT t
set t.status = 'DELETED'
, t.ods_modify_date = sysdate
where t.status != 'DELETED'
and exists
(
select 1
from
    ods_stage.FOW_RECORD_CHANGE_AUDIT rca
    ,ODS_STAGE.EVENT_XR e_xr
where (1=1)
    and rca.TABLE_NAME = 'EVENT'
    and rca.EVENT_TYPE = 'DELETE'
    and rca.KEY_VALUE = e_xr.FOW_ID
    and e_xr.SYSTEM_OF_RECORD = 'FOW'
    and t.event_oid = e_xr.event_oid
)

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* merge into mart.event */

merge into mart.event t
using (
   select 
      e_xr.event_ref_id
from 
    ods_stage.fow_record_change_audit rca 
    ,ods_stage.event_xr e_xr
where (1=1)
    and rca.table_name = 'EVENT'
    and rca.event_type = 'DELETE'
    and rca.key_value = e_xr.fow_id
    and rca.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap
) s
on (t.job_nbr = s.event_ref_id)
when matched then update
set t.deleted_flag = 'Y'


&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* delete  from ODS_STAGE.EVENT_XR */

delete 
from ODS_STAGE.EVENT_XR z where z.EVENT_OID in ( 
select 
    e_xr.EVENT_OID
from 
    ods_stage.FOW_RECORD_CHANGE_AUDIT rca 
    ,ODS_STAGE.EVENT_XR e_xr
where (1=1)
    and rca.TABLE_NAME = 'EVENT'
    and rca.EVENT_TYPE = 'DELETE'
    and rca.KEY_VALUE = e_xr.FOW_ID 
    and e_xr.SYSTEM_OF_RECORD = 'FOW'
    and not exists (select 1 from ODS_OWN.ORDER_HEADER oh where oh.EVENT_OID=e_xr.EVENT_OID)
    and not exists (select 1 from ODS_OWN.EVENT_PAYMENT ep where ep.EVENT_OID=e_xr.EVENT_OID)
    and not exists (select 1 from ODS_OWN.SALES_RECOGNITION sr where sr.EVENT_OID = e_xr.EVENT_OID)
)

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* delete 
from ODS_STAGE.FOW_OFFERING_STG */

delete 
from ODS_STAGE.FOW_OFFERING_STG z where z.ID in ( 
select 
    rca.KEY_VALUE ID
--    o_xr.ID
from 
    ods_stage.FOW_RECORD_CHANGE_AUDIT rca 
--    ,ODS_STAGE.FOW_OFFERING_XR o_xr
where (1=1)
    and rca.TABLE_NAME = 'OFFERING'
    and rca.EVENT_TYPE = 'DELETE'
--    and rca.KEY_VALUE = o_xr.ID
)


&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* delete 
from ODS_OWN.OFFERING */

delete 
from ODS_OWN.OFFERING z where z.OFFERING_OID in ( 
select 
    o_xr.OFFERING_OID
-- select *
from 
    ods_stage.FOW_RECORD_CHANGE_AUDIT rca 
    ,ODS_STAGE.FOW_OFFERING_XR o_xr
where (1=1)
    and rca.TABLE_NAME = 'OFFERING'
    and rca.EVENT_TYPE = 'DELETE'
    and rca.KEY_VALUE = o_xr.ID
    and not exists (select 1 from ODS_OWN.AUTO_ORDER_LINE aol where aol.OFFERING_OID=o_xr.OFFERING_OID)
)

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* delete 
from ODS_STAGE.FOW_OFFERING_XR */

delete 
from ODS_STAGE.FOW_OFFERING_XR z where z.OFFERING_OID in ( 
select 
    o_xr.OFFERING_OID
-- select *
from 
    ods_stage.FOW_RECORD_CHANGE_AUDIT rca 
    ,ODS_STAGE.FOW_OFFERING_XR o_xr
where (1=1)
    and rca.TABLE_NAME = 'OFFERING'
    and rca.EVENT_TYPE = 'DELETE'
    and rca.KEY_VALUE = o_xr.ID
    and not exists (select 1 from ODS_OWN.AUTO_ORDER_LINE aol where aol.OFFERING_OID=o_xr.OFFERING_OID)
)

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* delete 
from ODS_STAGE.FOW_AUTO_ORDER_LINE_STG */

delete 
from ODS_STAGE.FOW_AUTO_ORDER_LINE_STG z where z.ID in ( 
select 
    rca.KEY_VALUE ID
from 
    ods_stage.FOW_RECORD_CHANGE_AUDIT rca 
where (1=1)
    and rca.TABLE_NAME = 'AUTO_ORDER_LINE'
    and rca.EVENT_TYPE = 'DELETE'
)

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* delete 
from ODS_OWN.AUTO_ORDER_LINE */

delete 
from ODS_OWN.AUTO_ORDER_LINE z where z.AUTO_ORDER_LINE_OID in ( 
select 
    o_xr.AUTO_ORDER_LINE_OID
-- select *
from 
    ods_stage.FOW_RECORD_CHANGE_AUDIT rca 
    ,ODS_STAGE.FOW_AUTO_ORDER_LINE_XR o_xr
where (1=1)
    and rca.TABLE_NAME = 'AUTO_ORDER_LINE'
    and rca.EVENT_TYPE = 'DELETE'
    and rca.KEY_VALUE = o_xr.ID
)

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* delete 
from ODS_STAGE.FOW_AUTO_ORDER_LINE_XR */

delete 
from ODS_STAGE.FOW_AUTO_ORDER_LINE_XR z where z.AUTO_ORDER_LINE_OID in ( 
select 
    o_xr.AUTO_ORDER_LINE_OID
-- select *
from 
    ods_stage.FOW_RECORD_CHANGE_AUDIT rca 
    ,ODS_STAGE.FOW_AUTO_ORDER_LINE_XR o_xr
where (1=1)
    and rca.TABLE_NAME = 'AUTO_ORDER_LINE'
    and rca.EVENT_TYPE = 'DELETE'
    and rca.KEY_VALUE = o_xr.ID
)

&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* delete  from ods_stage.fow_apo_merch_tags */

delete 
from ods_stage.fow_apo_merch_tags z where z.ID in ( 
select 
    rca.key_value id
from 
    ods_stage.fow_record_change_audit rca 
where (1=1)
    and rca.TABLE_NAME = 'APO_MERCH_TAGS'
    and rca.EVENT_TYPE = 'DELETE'
)


&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* delete from ods_own.apo_tag  */

delete 
from ods_own.apo_tag z where z.apo_tag_oid in ( 
select 
    xr.apo_tag_oid
from 
    ods_stage.FOW_RECORD_CHANGE_AUDIT rca 
    , ODS_STAGE.FOW_APO_TAG_XR  xr
where (1=1)
    and rca.TABLE_NAME = 'APO_MERCH_TAGS'
    and rca.EVENT_TYPE = 'DELETE'
    and rca.KEY_VALUE = xr.ID
)

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* delete from ods_stage.apo_tag_xr */

delete 
from ODS_STAGE.FOW_APO_TAG_XR  z where z.apo_tag_oid in ( 
select 
    xr.apo_tag_oid
from 
    ods_stage.FOW_RECORD_CHANGE_AUDIT rca 
    ,ODS_STAGE.FOW_APO_TAG_XR xr
where (1=1)
    and rca.TABLE_NAME = 'APO_MERCH_TAGS'
    and rca.EVENT_TYPE = 'DELETE'
    and rca.KEY_VALUE = xr.ID
)

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* delete from ods_stage.fow_yb_offering_config_stg */

delete 
from ods_stage.fow_yb_offering_config_stg z where z.id in ( 
select 
    rca.key_value id
from 
    ods_stage.fow_record_change_audit rca 
where (1=1)
    and rca.table_name = 'YB_OFFERING_CONFIG'
    and rca.event_type = 'DELETE'
   and rca.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
)

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* delete from ods_own.yb_offering_config */

delete 
from ods_own.yb_offering_config z where z.yb_offering_config_oid in ( 
select 
    xr.yb_offering_config_oid
from 
    ods_stage.fow_record_change_audit rca 
    , ods_stage.yb_offering_config_xr   xr
where (1=1)
    and rca.table_name = 'YB_OFFERING_CONFIG'
    and rca.event_type = 'DELETE'
    and rca.key_value = xr.ID
    and rca.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
)

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* delete from ods_stage.yb_offering_config_xr  */

delete 
from ods_stage.yb_offering_config_xr   z where z.yb_offering_config_oid in ( 
select 
    xr.yb_offering_config_oid
from 
    ods_stage.fow_record_change_audit rca 
    ,ods_stage.yb_offering_config_xr xr
where (1=1)
    and rca.table_name = 'YB_OFFERING_CONFIG'
    and rca.event_type = 'DELETE'
    and rca.key_value = xr.id
    and rca.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
)

&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* delete from ods_stage.fow_yb_flow_stg */

delete 
from ods_stage.fow_yb_flow_stg z where z.flow_id in ( 
select 
    rca.key_value id
from 
    ods_stage.fow_record_change_audit rca 
where (1=1)
    and rca.table_name = 'YB_FLOW'
    and rca.event_type = 'DELETE'
   and rca.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
)

&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* delete from ods_stage.fow_yb_flow_booking_year_stg */

delete 
from ods_stage.fow_yb_flow_booking_year_stg z where (z.flow_id, z.booking_year) in ( 
select 
    rca.key_value, rca.key_value2
from 
    ods_stage.fow_record_change_audit rca 
where (1=1)
    and rca.table_name = 'YB_FLOW_BOOKING_YEAR'
    and rca.event_type = 'DELETE'
   and rca.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
)

&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* delete from ods_stage.fow_yb_flow_feature_stg */

delete 
from ods_stage.fow_yb_flow_feature_stg z where (z.flow_id, z.feature_id) in ( 
select 
    rca.key_value, rca.key_value2
from 
    ods_stage.fow_record_change_audit rca 
where (1=1)
    and rca.table_name = 'YB_FLOW_FEATURE'
    and rca.event_type = 'DELETE'
   and rca.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
)

&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* delete from ods_stage.fow_yb_feature_stg */

delete 
from ods_stage.fow_yb_feature_stg z where z.feature_id in ( 
select 
    rca.key_value id
from 
    ods_stage.fow_record_change_audit rca 
where (1=1)
    and rca.table_name = 'YB_FEATURE'
    and rca.event_type = 'DELETE'
   and rca.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
)

&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* delete from ods_stage.fow_yb_feature_choice_stg */

delete 
from ods_stage.fow_yb_feature_choice_stg z where (z.feature_id, z.choice_id) in ( 
select 
    rca.key_value, rca.key_value2
from 
    ods_stage.fow_record_change_audit rca 
where (1=1)
    and rca.table_name = 'YB_FLOW_FEATURE'
    and rca.event_type = 'DELETE'
   and rca.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
)

&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* delete from ods_stage.fow_yb_choice_stg */

delete 
from ods_stage.fow_yb_choice_stg z where z.choice_id in ( 
select 
    rca.key_value id
from 
    ods_stage.fow_record_change_audit rca 
where (1=1)
    and rca.table_name = 'YB_CHOICE'
    and rca.event_type = 'DELETE'
   and rca.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
)

&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* Delete from CA Stage */

delete 
from ods_stage_ca.FOW_EVENT_STG z where z.ID in ( 
select 
    e_xr.FOW_CA_ID
from 
    ods_stage_ca.FOW_RECORD_CHANGE_AUDIT rca 
    ,ODS_STAGE.EVENT_XR e_xr
where (1=1)
    and rca.TABLE_NAME = 'EVENT'
    and rca.EVENT_TYPE = 'DELETE'
    and rca.KEY_VALUE = e_xr.FOW_CA_ID 
    and e_xr.SYSTEM_OF_RECORD = 'FOW'
    and e_xr.fow_id is NULL
    and not exists (select 1 from ODS_OWN.ORDER_HEADER oh where oh.EVENT_OID=e_xr.EVENT_OID)
    and not exists (select 1 from ODS_OWN.EVENT_PAYMENT ep where ep.EVENT_OID=e_xr.EVENT_OID)
    and not exists (select 1 from ODS_OWN.SALES_RECOGNITION sr where sr.EVENT_OID = e_xr.EVENT_OID)
)

&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* Update CA Stage */

UPDATE ods_stage_ca.FOW_EVENT_STG z
   SET status = 'DELETED'
 WHERE     z.ID IN
               (SELECT e_xr.FOW_CA_ID
                  FROM ods_stage_ca.FOW_RECORD_CHANGE_AUDIT  rca,
                       ODS_STAGE.EVENT_XR                 e_xr
                 WHERE     (1 = 1)
                       AND rca.TABLE_NAME = 'EVENT'
                       AND rca.EVENT_TYPE = 'DELETE'
                       AND rca.KEY_VALUE = e_xr.FOW_CA_ID
		       and e_xr.fow_id is NULL
                       AND e_xr.SYSTEM_OF_RECORD = 'FOW')
       AND NVL (status, 'NULL') != 'DELETED'

&


/*-----------------------------------------------*/
/* TASK No. 32 */
/* Delete from Event */

delete 
from ODS_OWN.EVENT z where z.EVENT_OID in ( 
select 
    e_xr.EVENT_OID
from 
    ods_stage_ca.FOW_RECORD_CHANGE_AUDIT rca 
    ,ODS_STAGE.EVENT_XR e_xr
where (1=1)
    and rca.TABLE_NAME = 'EVENT'
    and rca.EVENT_TYPE = 'DELETE'
    and rca.KEY_VALUE = e_xr.FOW_CA_ID 
    and e_xr.fow_id is NULL
    and e_xr.SYSTEM_OF_RECORD = 'FOW'
    and not exists (select 1 from ODS_OWN.ORDER_HEADER oh where oh.EVENT_OID=e_xr.EVENT_OID)
    and not exists (select 1 from ODS_OWN.EVENT_PAYMENT ep where ep.EVENT_OID=e_xr.EVENT_OID)
    and not exists (select 1 from ODS_OWN.SALES_RECOGNITION sr where sr.EVENT_OID = e_xr.EVENT_OID)
)

&


/*-----------------------------------------------*/
/* TASK No. 33 */
/* Update Event */

update ODS_OWN.EVENT t
set t.status = 'DELETED'
, t.ods_modify_date = sysdate
where t.status != 'DELETED'
and exists
(
select 1
from
    ods_stage_ca.FOW_RECORD_CHANGE_AUDIT rca
    ,ODS_STAGE.EVENT_XR e_xr
where (1=1)
    and rca.TABLE_NAME = 'EVENT'
    and rca.EVENT_TYPE = 'DELETE'
    and rca.KEY_VALUE = e_xr.FOW_CA_ID
    and e_xr.fow_id is NULL
    and e_xr.SYSTEM_OF_RECORD = 'FOW'
    and t.event_oid = e_xr.event_oid
)

&


/*-----------------------------------------------*/
/* TASK No. 34 */
/* Update MART Event */

merge into mart.event t
using (
   select 
      e_xr.event_ref_id
from 
    ods_stage_ca.fow_record_change_audit rca 
    ,ods_stage.event_xr e_xr
where (1=1)
    and rca.table_name = 'EVENT'
    and rca.event_type = 'DELETE'
    and e_xr.fow_id is NULL
    and rca.key_value = e_xr.fow_ca_id
    and rca.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap
) s
on (t.job_nbr = s.event_ref_id)
when matched then update
set t.deleted_flag = 'Y'

&


/*-----------------------------------------------*/
/* TASK No. 35 */
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
/* TASK No. 36 */
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
,'PROCESS_FOW_DELETES_PKG'
,'012'
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
'PROCESS_FOW_DELETES_PKG',
'012',
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
