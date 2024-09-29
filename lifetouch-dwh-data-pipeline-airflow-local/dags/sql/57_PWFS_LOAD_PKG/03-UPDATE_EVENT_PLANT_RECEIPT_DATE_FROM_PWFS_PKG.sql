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

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 4 */




/*-----------------------------------------------*/
/* TASK No. 5 */
/* drop table temp_pwfs_prd */

--drop table RAX_APP_USER.temp_pwfs_prd
BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.temp_pwfs_prd';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* create table temp_pwfs_prd */

create table RAX_APP_USER.temp_pwfs_prd as
select wf.source_system_identifier_2 as event_ref_id
, min(from_tz(cast( wf.create_date as timestamp), 'UTC') at time zone :v_data_center_tz ) as plant_receipt_date
from ODS_STAGE.pwfs_work_flow_stg wf
, ODS_OWN.event e
where 1=1
and wf.source_system_identifier_2 = e.event_ref_id
and wf.ods_modify_date  > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - 1
group by wf.source_system_identifier_2



&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* create unique index */

create unique index temp_pwfs_prd_pk 
on RAX_APP_USER.temp_pwfs_prd(event_ref_id)

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Update event_plant_receipt_date staging table */

merge into ODS_STAGE.event_plant_receipt_date t
using
(
select wf.event_ref_id
, wf.plant_receipt_date
from RAX_APP_USER.temp_pwfs_prd wf
) s
on (s.event_ref_id = t.event_ref_id)
when matched then update
set t.pwfs_date = s.plant_receipt_date
, t.last_modify_date = sysdate
, t.system_of_record = 
(case when s.plant_receipt_date < 
           least(nvl(t.gdt_plant_receipt_date,to_date('25251231','YYYYMMDD'))
                ,nvl(t.capture_session_date,to_date('25251231','YYYYMMDD'))) 
      then 'PWFS' else t.system_of_record end)
where 1=1
and ((s.plant_receipt_date <> t.pwfs_date) or (t.pwfs_date is null))
when not matched then insert
( t.event_ref_id
, t.pwfs_date
, t.system_of_record
, t.last_modify_date
)
values
( s.event_ref_id
, s.plant_receipt_date
, 'PWFS'
, sysdate
)


&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* UPDATE EVENT */

merge into ODS_OWN.event t
using
(
select eprd.event_ref_id
, eprd.pwfs_date as plant_receipt_date
from ODS_STAGE.event_plant_receipt_date eprd
, ODS_OWN.event e
, ODS_OWN.source_system ss
where 1=1
and eprd.event_ref_id = e.event_ref_id
and e.source_system_oid = ss.source_system_oid
and ss.source_system_name = 'Field Operations Workbench'
and eprd.pwfs_date is not null
and eprd.system_of_record in ('PWFS')
and eprd.last_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
) s
on ( s.event_ref_id = t.event_ref_id )
when matched then update
set t.plant_receipt_date = s.plant_receipt_date
, t.ods_modify_date = sysdate
where 1=1
and ((s.plant_receipt_date <> t.plant_receipt_date) or (t.plant_receipt_date is null))

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* EVENT.AID_IND */

update ods_own.event t
set t.aid_ind = 'Y'
, t.ods_modify_date = sysdate
where nvl(t.aid_ind,'N') != 'Y'
and exists
(
select 1
from ods_stage.pwfs_work_flow_stg wf
where wf.source_system_identifier_4 = 'WirelessPDS'
and wf.ods_modify_date >  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - 1
and wf.source_system_identifier_2 = t.event_ref_id
)

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* EVENT.ASSET_UPLOAD_COMPLETE_DATE */

merge into ods_own.event t
using
(
select ue.event_id as event_ref_id
, from_tz(cast(ue.modified_date as timestamp), 'UTC') at time zone :v_data_center_tz as asset_upload_complete_date
from ods_stage.au_event_stg ue
where ue.status = 'COMPLETE'
-- and ue.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - 1
) s
on ( t.event_ref_id = s.event_ref_id )
when matched then update
set t.asset_upload_complete_date = s.asset_upload_complete_date
where t.asset_upload_complete_date is null

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* drop image_trans_meth_d  */

--drop table image_trans_meth_d
BEGIN
   EXECUTE IMMEDIATE 'drop table image_trans_meth_d';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* create driver table  image_trans_meth_d */

create table image_trans_meth_d as
select distinct event_id
from ods_stage.au_completed_batch_stg
where ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - 1

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* index driver table */

create unique index image_trans_meth_d_pk on image_trans_meth_d(event_id)

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* update event.image_transmission_method */

merge into ods_own.event t
using
(
select s.event_id
, max(case when s.media_id = 'DVD' then 'Web Uploader' else 'AID' end) as image_transmission_method
from ods_stage.au_completed_batch_stg s
, image_trans_meth_d d
where d.event_id = s.event_id
group by s.event_id
) s
on ( s.event_id = t.event_ref_id )
when matched then update
set t.image_transmission_method = s.image_transmission_method
, t.ods_modify_date = sysdate
where decode(t.image_transmission_method , s.image_transmission_method,1,0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 16 */
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
/* TASK No. 17 */
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
,'UPDATE_EVENT_PLANT_RECEIPT_DATE_FROM_PWFS_PKG'
,'008'
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
'UPDATE_EVENT_PLANT_RECEIPT_DATE_FROM_PWFS_PKG',
'008',
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
