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
/* drop driver1 */

--drop table pwfs_task_driver1
BEGIN
   EXECUTE IMMEDIATE 'drop table pwfs_task_driver1';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* drop driver2 */

--drop table pwfs_task_driver2
BEGIN
   EXECUTE IMMEDIATE 'drop table pwfs_task_driver2';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* drop driver3 */

--drop table pwfs_task_driver3
BEGIN
   EXECUTE IMMEDIATE 'drop table pwfs_task_driver3';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* drop driver4 */

--drop table pwfs_task_driver4
BEGIN
   EXECUTE IMMEDIATE 'drop table pwfs_task_driver4';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* drop driver */

--drop table pwfs_task_driver
BEGIN
   EXECUTE IMMEDIATE 'drop table pwfs_task_driver';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* create driver1 */

create table pwfs_task_driver1 as
select distinct wf.source_system_identifier_2 as event_ref_id
from ods_stage.pwfs_work_flow_stg wf
, ods_stage.pwfs_task_stg t
where 1=1
and wf.id = t.workflow_id
and t.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - 1


&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* create driver2 */

create table pwfs_task_driver2 as
select distinct wf.source_system_identifier_2 as event_ref_id
from ods_own.pwfs_work_flow wf
, ods_own.pwfs_task t
where 1=1
and wf.work_flow_oid = t.work_flow_oid
and t.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - 1

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* create driver3 (task deletes) */

create table pwfs_task_driver3 as
select distinct wf.source_system_identifier_2 as event_ref_id
from ods_stage.pwfs_work_flow_stg wf
, ods_stage.pwfs_task_stg t
where 1=1
and wf.id = t.workflow_id
and exists
(
select 1
from ods_stage.pwfs_record_change_audit_stg d
where d.table_name = 'TASK'
and d.key_value = t.id
and d.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - 1
)

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* create driver4 (work_flow deletes) */

create table pwfs_task_driver4 as
select distinct wf.source_system_identifier_2 as event_ref_id
from ods_stage.pwfs_work_flow_stg wf
where 1=1
and exists
(
select 1
from ods_stage.pwfs_record_change_audit_stg d
where d.table_name = 'WORK_FLOW'
and d.key_value = wf.id
and d.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - 1
)

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* create driver */

create table pwfs_task_driver as
select event_ref_id
from pwfs_task_driver1
union
select event_ref_id
from pwfs_task_driver2
union
select event_ref_id
from pwfs_task_driver3
union
select event_ref_id
from pwfs_task_driver4

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* index driver */

create unique index pwfs_task_driver_pk on pwfs_task_driver(event_ref_id)

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* MERGE */

merge into ods_own.prelab_event_tracking t
using
(
select e.event_oid
, e.event_ref_id
, max(nvl(parent_wf.work_flow_type, wf.work_flow_type)) as work_flow_type
, max(case when wf.user_task_allocation_id is not null then wf.user_task_allocation_id else e.processing_lab end) as processing_lab
, o.org_code as territory_code
, ss.source_system_oid
, min(case when task.task_type = 'WAIT_FOR_OPERATOR' then task.completed_on else null end) as WAIT_FOR_OPERATOR_date
, min(case when task.task_type = 'DVD_COPY' then task.completed_on else null end) as DVD_COPY_date
, min(case when task.task_type = 'DVD_UPLOAD' then task.completed_on else null end) as DVD_UPLOAD_date
, min(case when task.task_type = 'PRE_PROCESSING' then task.completed_on else null end) as PRE_PROCESSING_date
, min(case when task.task_type = 'IMAGE_ANALYSIS' then task.completed_on else null end) as IMAGE_ANALYSIS_date
, min(case when task.task_type = 'DATA_IMPORT' then task.completed_on else null end) as DATA_IMPORT_date
, min(case when task.task_type = 'IMAGE_ANALYSIS_VALIDATION' then task.completed_on else null end) as IMAGE_ANALYSIS_VALIDATION_date
, min(case when task.task_type = 'RE_IMAGE_ANALYSIS' then task.completed_on else null end) as RE_IMAGE_ANALYSIS_date
, min(case when task.task_type = 'TIMED_WAIT' then task.completed_on else null end) as TIMED_WAIT_date
, min(case when task.task_type = 'AUTO_MATCH' then task.completed_on else null end) as AUTO_MATCH_date
, min(case when task.task_type = 'MATCH_AND_TAG' then task.completed_on else null end) as MATCH_AND_TAG_date
, min(case when task.task_type = 'COLOR_ANALYSIS' then task.completed_on else null end) as COLOR_ANALYSIS_date
, min(case when task.task_type = 'COLOR_VALIDATION' then task.completed_on else null end) as COLOR_VALIDATION_date
, min(case when task.task_type = 'CROPPING_VALIDATION' then task.completed_on else null end) as CROPPING_VALIDATION_date
, min(case when task.task_type = 'EIC_READY' then task.completed_on else null end) as EIC_READY_date
, min(case when task.task_type = 'SM_CAPTURE_COLLECTION' then task.completed_on else null end) as SM_CAPTURE_COLLECTION_date
, min(case when task.task_type = 'SERVICE_RETOUCH' then task.completed_on else null end) as SERVICE_RETOUCH_date
, min(case when task.task_type = 'AUTO_ORDER_ENTRY' then task.completed_on else null end) as AUTO_ORDER_ENTRY_date
, min(case when task.task_type = 'OMS_ORDER_CREATION' then task.completed_on else null end) as OMS_ORDER_CREATION_date
from ods_own.event e
, ods_own.apo
, ods_own.organization o
, ods_own.source_system ss
, ods_own.pwfs_work_flow wf
, ods_own.pwfs_work_flow parent_wf
, ods_own.pwfs_task task
, pwfs_task_driver d -- use task.modified_date to get changed events events
where e.apo_oid = apo.apo_oid
and apo.organization_oid = o.organization_oid
and ss.source_system_short_name = 'PWFS'
and e.event_ref_id = wf.source_system_identifier_2
and wf.parent_id = parent_wf.work_flow_id(+)
and wf.work_flow_oid = task.work_flow_oid
and e.event_ref_id = d.event_ref_id
group by e.event_oid
, e.event_ref_id
, o.org_code
, ss.source_system_oid
) s
on ( t.event_oid = s.event_oid )
when matched then update
set t.processing_lab = s.processing_lab
,t.territory_code = s.territory_code
,t.WAIT_FOR_OPERATOR_DATE = s.WAIT_FOR_OPERATOR_DATE
,t.DVD_COPY_DATE = s.DVD_COPY_DATE
,t.DVD_UPLOAD_DATE = s.DVD_UPLOAD_DATE
,t.PRE_PROCESSING_DATE = s.PRE_PROCESSING_DATE
,t.IMAGE_ANALYSIS_DATE = s.IMAGE_ANALYSIS_DATE
,t.DATA_IMPORT_DATE = s.DATA_IMPORT_DATE
,t.IMAGE_ANALYSIS_VALIDATION_DATE = s.IMAGE_ANALYSIS_VALIDATION_DATE
,t.RE_IMAGE_ANALYSIS_DATE = s.RE_IMAGE_ANALYSIS_DATE
,t.TIMED_WAIT_DATE = s.TIMED_WAIT_DATE
,t.AUTO_MATCH_DATE = s.AUTO_MATCH_DATE
,t.MATCH_AND_TAG_DATE = s.MATCH_AND_TAG_DATE
,t.COLOR_ANALYSIS_DATE = s.COLOR_ANALYSIS_DATE
,t.COLOR_VALIDATION_DATE = s.COLOR_VALIDATION_DATE
,t.CROPPING_VALIDATION_DATE = s.CROPPING_VALIDATION_DATE
,t.EIC_READY_DATE = s.EIC_READY_DATE
,t.work_flow_type = s.work_flow_type
,t.SM_CAPTURE_COLLECTION_date = s.SM_CAPTURE_COLLECTION_date
,t.SERVICE_RETOUCH_date = s.SERVICE_RETOUCH_date
,t.AUTO_ORDER_ENTRY_date = s.AUTO_ORDER_ENTRY_date
,t.OMS_ORDER_CREATION_date = s.OMS_ORDER_CREATION_date
,t.ODS_MODIFY_DATE = sysdate
where decode(s.processing_lab,t.processing_lab,1,0) = 0
or decode(s.territory_code, t.territory_code,1,0) = 0
or decode(s.work_flow_type, t.work_flow_type,1,0) = 0
or t.WAIT_FOR_OPERATOR_DATE <> s.WAIT_FOR_OPERATOR_DATE
or (t.WAIT_FOR_OPERATOR_DATE is null and s.WAIT_FOR_OPERATOR_DATE is not null)
or (t.WAIT_FOR_OPERATOR_DATE is not null and s.WAIT_FOR_OPERATOR_DATE is null)
or t.DVD_COPY_DATE <> s.DVD_COPY_DATE
or (t.DVD_COPY_DATE is null and s.DVD_COPY_DATE is not null)
or (t.DVD_COPY_DATE is not null and s.DVD_COPY_DATE is null)
or t.DVD_UPLOAD_DATE <> s.DVD_UPLOAD_DATE
or (t.DVD_UPLOAD_DATE is null and s.DVD_UPLOAD_DATE is not null)
or (t.DVD_UPLOAD_DATE is not null and s.DVD_UPLOAD_DATE is null)
or t.PRE_PROCESSING_DATE <> s.PRE_PROCESSING_DATE
or (t.PRE_PROCESSING_DATE is null and s.PRE_PROCESSING_DATE is not null)
or (t.PRE_PROCESSING_DATE is not null and s.PRE_PROCESSING_DATE is null)
or t.IMAGE_ANALYSIS_DATE <> s.IMAGE_ANALYSIS_DATE
or (t.IMAGE_ANALYSIS_DATE is null and s.IMAGE_ANALYSIS_DATE is not null)
or (t.IMAGE_ANALYSIS_DATE is not null and s.IMAGE_ANALYSIS_DATE is null)
or t.DATA_IMPORT_DATE <> s.DATA_IMPORT_DATE
or (t.DATA_IMPORT_DATE is null and s.DATA_IMPORT_DATE is not null)
or (t.DATA_IMPORT_DATE is not null and s.DATA_IMPORT_DATE is null)
or t.IMAGE_ANALYSIS_VALIDATION_DATE <> s.IMAGE_ANALYSIS_VALIDATION_DATE
or (t.IMAGE_ANALYSIS_VALIDATION_DATE is null and s.IMAGE_ANALYSIS_VALIDATION_DATE is not null)
or (t.IMAGE_ANALYSIS_VALIDATION_DATE is not null and s.IMAGE_ANALYSIS_VALIDATION_DATE is null)
or t.RE_IMAGE_ANALYSIS_DATE <> s.RE_IMAGE_ANALYSIS_DATE
or (t.RE_IMAGE_ANALYSIS_DATE is null and s.RE_IMAGE_ANALYSIS_DATE is not null)
or (t.RE_IMAGE_ANALYSIS_DATE is not null and s.RE_IMAGE_ANALYSIS_DATE is null)
or t.TIMED_WAIT_DATE <> s.TIMED_WAIT_DATE
or (t.TIMED_WAIT_DATE is null and s.TIMED_WAIT_DATE is not null)
or (t.TIMED_WAIT_DATE is not null and s.TIMED_WAIT_DATE is null)
or t.AUTO_MATCH_DATE <> s.AUTO_MATCH_DATE
or (t.AUTO_MATCH_DATE is null and s.AUTO_MATCH_DATE is not null)
or (t.AUTO_MATCH_DATE is not null and s.AUTO_MATCH_DATE is null)
or t.MATCH_AND_TAG_DATE <> s.MATCH_AND_TAG_DATE
or (t.MATCH_AND_TAG_DATE is null and s.MATCH_AND_TAG_DATE is not null)
or (t.MATCH_AND_TAG_DATE is not null and s.MATCH_AND_TAG_DATE is null)
or t.COLOR_ANALYSIS_DATE <> s.COLOR_ANALYSIS_DATE
or (t.COLOR_ANALYSIS_DATE is null and s.COLOR_ANALYSIS_DATE is not null)
or (t.COLOR_ANALYSIS_DATE is not null and s.COLOR_ANALYSIS_DATE is null)
or t.COLOR_VALIDATION_DATE <> s.COLOR_VALIDATION_DATE
or (t.COLOR_VALIDATION_DATE is null and s.COLOR_VALIDATION_DATE is not null)
or (t.COLOR_VALIDATION_DATE is not null and s.COLOR_VALIDATION_DATE is null)
or t.CROPPING_VALIDATION_DATE <> s.CROPPING_VALIDATION_DATE
or (t.CROPPING_VALIDATION_DATE is null and s.CROPPING_VALIDATION_DATE is not null)
or (t.CROPPING_VALIDATION_DATE is not null and s.CROPPING_VALIDATION_DATE is null)
or t.EIC_READY_DATE <> s.EIC_READY_DATE
or (t.EIC_READY_DATE is null and s.EIC_READY_DATE is not null)
or (t.EIC_READY_DATE is not null and s.EIC_READY_DATE is null)
or t.SM_CAPTURE_COLLECTION_date <> s.SM_CAPTURE_COLLECTION_date
or (t.SM_CAPTURE_COLLECTION_date is null and s.SM_CAPTURE_COLLECTION_date is not null)
or (t.SM_CAPTURE_COLLECTION_date is not null and s.SM_CAPTURE_COLLECTION_date is null)
or t.SERVICE_RETOUCH_date <> s.SERVICE_RETOUCH_date
or (t.SERVICE_RETOUCH_date is null and s.SERVICE_RETOUCH_date is not null)
or (t.SERVICE_RETOUCH_date is not null and s.SERVICE_RETOUCH_date is null)
or t.AUTO_ORDER_ENTRY_date <> s.AUTO_ORDER_ENTRY_date
or (t.AUTO_ORDER_ENTRY_date is null and s.AUTO_ORDER_ENTRY_date is not null)
or (t.AUTO_ORDER_ENTRY_date is not null and s.AUTO_ORDER_ENTRY_date is null)
or t.OMS_ORDER_CREATION_date <> s.OMS_ORDER_CREATION_date
or (t.OMS_ORDER_CREATION_date is null and s.OMS_ORDER_CREATION_date is not null)
or (t.OMS_ORDER_CREATION_date is not null and s.OMS_ORDER_CREATION_date is null)
when not matched then insert
(t.event_oid
,t.event_ref_id
,t.work_flow_type
,t.processing_lab
,t.territory_code
,t.ODS_CREATE_DATE
,t.ODS_MODIFY_DATE
,t.source_system_oid
,t.WAIT_FOR_OPERATOR_DATE
,t.DVD_COPY_DATE
,t.DVD_UPLOAD_DATE
,t.PRE_PROCESSING_DATE
,t.IMAGE_ANALYSIS_DATE
,t.DATA_IMPORT_DATE
,t.IMAGE_ANALYSIS_VALIDATION_DATE
,t.RE_IMAGE_ANALYSIS_DATE
,t.TIMED_WAIT_DATE
,t.AUTO_MATCH_DATE
,t.MATCH_AND_TAG_DATE
,t.COLOR_ANALYSIS_DATE
,t.COLOR_VALIDATION_DATE
,t.CROPPING_VALIDATION_DATE
,t.EIC_READY_DATE
,t.sm_capture_collection_date
,t.service_retouch_date
,t.auto_order_entry_date
,t.oms_order_creation_date
)
values
(s.event_oid
,s.event_ref_id
,s.work_flow_type
,s.processing_lab
,s.territory_code
,sysdate
,sysdate
,s.source_system_oid
,s.WAIT_FOR_OPERATOR_DATE
,s.DVD_COPY_DATE
,s.DVD_UPLOAD_DATE
,s.PRE_PROCESSING_DATE
,s.IMAGE_ANALYSIS_DATE
,s.DATA_IMPORT_DATE
,s.IMAGE_ANALYSIS_VALIDATION_DATE
,s.RE_IMAGE_ANALYSIS_DATE
,s.TIMED_WAIT_DATE
,s.AUTO_MATCH_DATE
,s.MATCH_AND_TAG_DATE
,s.COLOR_ANALYSIS_DATE
,s.COLOR_VALIDATION_DATE
,s.CROPPING_VALIDATION_DATE
,s.EIC_READY_DATE
,s.sm_capture_collection_date
,s.service_retouch_date
,s.auto_order_entry_date
,s.oms_order_creation_date
)

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* drop holds driver1 */

--drop table pwfs_holds_driver1
BEGIN
   EXECUTE IMMEDIATE 'drop table pwfs_holds_driver1';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* create holds driver1 */

create table pwfs_holds_driver1 as
select distinct e.event_ref_id
from ods_own.prelab_event_tracking e
, ods_own.pwfs_work_flow wf
, ods_own.pwfs_hold h
, ods_own.pwfs_work_flow parent_wf
where e.event_ref_id = wf.source_system_identifier_2
and wf.work_flow_id = h.work_flow_id
and wf.parent_id = parent_wf.work_flow_id(+)
--and ( wf.work_flow_type in ('PRELAB_RETOUCH_ORDER','PRELAB_PDS_ORDER','PRELAB_PDS_EBRT_ORDER') or parent_wf.work_flow_type in --('PRELAB_RETOUCH_ORDER','PRELAB_PDS_ORDER','PRELAB_PDS_EBRT_ORDER') )
and h.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - 1


&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* drop holds driver2 */

--drop table pwfs_holds_driver2
BEGIN
   EXECUTE IMMEDIATE 'drop table pwfs_holds_driver2';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* create holds driver2 */

create table pwfs_holds_driver2 as
select d.event_ref_id
, max(h.src_create_date) as max_create_date
from  pwfs_holds_driver1 d
, ods_own.pwfs_work_flow wf
, ods_own.pwfs_hold h
, ods_own.pwfs_work_flow parent_wf
where d.event_ref_id = wf.source_system_identifier_2
and wf.work_flow_id = h.work_flow_id
and wf.parent_id = parent_wf.work_flow_id(+)
--and ( wf.work_flow_type in ('PRELAB_RETOUCH_ORDER','PRELAB_PDS_ORDER','PRELAB_PDS_EBRT_ORDER') or parent_wf.work_flow_type in --('PRELAB_RETOUCH_ORDER','PRELAB_PDS_ORDER','PRELAB_PDS_EBRT_ORDER') )
group by d.event_ref_id

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* drop holds driver3 */

--drop table pwfs_holds_driver3
BEGIN
   EXECUTE IMMEDIATE 'drop table pwfs_holds_driver3';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* create holds driver3 */

create table pwfs_holds_driver3 as
select d.event_ref_id
, max(h.hold_oid) as hold_oid
from  pwfs_holds_driver2 d
, ods_own.pwfs_work_flow wf
, ods_own.pwfs_hold h
, ods_own.pwfs_work_flow parent_wf
where d.event_ref_id = wf.source_system_identifier_2
and wf.work_flow_id = h.work_flow_id
and wf.parent_id = parent_wf.work_flow_id(+)
--and ( wf.work_flow_type in ('PRELAB_RETOUCH_ORDER','PRELAB_PDS_ORDER','PRELAB_PDS_EBRT_ORDER') or parent_wf.work_flow_type in --('PRELAB_RETOUCH_ORDER','PRELAB_PDS_ORDER','PRELAB_PDS_EBRT_ORDER') )
and h.src_create_date = d.max_create_date
group by d.event_ref_id

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* Drop holds driver4 */

--drop table pwfs_holds_driver4
BEGIN
   EXECUTE IMMEDIATE 'drop table pwfs_holds_driver4';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Create holds driver4 */

-- Last reason create date on highest hold
--
create table pwfs_holds_driver4 as
select d.event_ref_id, d.hold_oid,  max(hr.src_create_date) as src_create_date
from pwfs_holds_driver3 d
, ods_own.pwfs_work_flow wf
, ods_own.pwfs_hold h
, ods_own.pwfs_hold_reason hr
, ods_own.pwfs_work_flow parent_wf
where d.event_ref_id = wf.source_system_identifier_2
and wf.work_flow_id = h.work_flow_id
and wf.parent_id = parent_wf.work_flow_id(+)
--and ( wf.work_flow_type in ('PRELAB_RETOUCH_ORDER','PRELAB_PDS_ORDER','PRELAB_PDS_EBRT_ORDER')
-- or parent_wf.work_flow_type in ('PRELAB_RETOUCH_ORDER','PRELAB_PDS_ORDER','PRELAB_PDS_EBRT_ORDER') )
and d.hold_oid = h.hold_oid
and d.hold_oid = hr.hold_oid(+)
group by d.event_ref_id, d.hold_oid

&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* Drop table holds5 */

--drop table pwfs_holds_driver5
BEGIN
   EXECUTE IMMEDIATE 'drop table pwfs_holds_driver5';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* Create holds driver5 */

-- Highest reason oid on create date
--
create table pwfs_holds_driver5 as
select d.event_ref_id, d.hold_oid,  max(hr.hold_reason_oid) as hold_reason_oid
from pwfs_holds_driver4 d
, ods_own.pwfs_work_flow wf
, ods_own.pwfs_hold h
, ods_own.pwfs_hold_reason hr
, ods_own.pwfs_work_flow parent_wf
where d.event_ref_id = wf.source_system_identifier_2
and wf.work_flow_id = h.work_flow_id
and wf.parent_id = parent_wf.work_flow_id(+)
--and ( wf.work_flow_type in ('PRELAB_RETOUCH_ORDER','PRELAB_PDS_ORDER','PRELAB_PDS_EBRT_ORDER')
-- or parent_wf.work_flow_type in ('PRELAB_RETOUCH_ORDER','PRELAB_PDS_ORDER','PRELAB_PDS_EBRT_ORDER') )
and d.hold_oid = h.hold_oid
and d.src_create_date = hr.src_create_date(+)
group by d.event_ref_id, d.hold_oid

&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* drop holds driver */

--drop table pwfs_holds_driver
BEGIN
   EXECUTE IMMEDIATE 'drop table pwfs_holds_driver';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* create holds driver */

create table pwfs_holds_driver as
select d.event_ref_id
, h.src_create_date as hold_date
, case when nvl(h.released_on,to_date('20991231','YYYYMMDD')) = to_date('20991231','YYYYMMDD') then null else h.released_on end as hold_released_date
, hr.comments as hold_comments
, hr.reason as hold_reason
, hr.src_create_date as hold_reason_create_date
, hr.created_by as hold_reason_created_by
, h.deleted_ind as deleted_ind
from pwfs_holds_driver5  d
, ods_own.pwfs_work_flow wf
, ods_own.pwfs_hold h
, ods_own.pwfs_hold_reason hr
, ods_own.pwfs_work_flow parent_wf
where d.event_ref_id = wf.source_system_identifier_2
and wf.work_flow_id = h.work_flow_id
and wf.parent_id = parent_wf.work_flow_id(+)
--and ( wf.work_flow_type in ('PRELAB_RETOUCH_ORDER','PRELAB_PDS_ORDER','PRELAB_PDS_EBRT_ORDER')
-- or parent_wf.work_flow_type in ('PRELAB_RETOUCH_ORDER','PRELAB_PDS_ORDER','PRELAB_PDS_EBRT_ORDER') )
and d.hold_oid = h.hold_oid
and d.hold_oid = hr.hold_oid(+)
and d.hold_reason_oid = hr.hold_reason_oid(+)

&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* index holds driver */

create unique index pwfs_holds_driver_pk on pwfs_holds_driver(event_ref_id)

&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* update holds */

merge into ods_own.prelab_event_tracking t 
using pwfs_holds_driver s
on ( t.event_ref_id = s.event_ref_id )
when matched then update
set t.hold_date = case when s.deleted_ind = 'Y' then null else s.hold_date end
, t.hold_released_date = case when s.deleted_ind = 'Y' then null else s.hold_released_date end
, t.ods_modify_date = sysdate
, t.hold_reason = case when s.deleted_ind = 'Y' then null else s.hold_reason end
, t.hold_comments = case when s.deleted_ind = 'Y' then null else s.hold_comments end
, t.hold_reason_create_date = case when s.deleted_ind = 'Y' then null else s.hold_reason_create_date end
, t.hold_reason_created_by = case when s.deleted_ind = 'Y' then null else s.hold_reason_created_by end
where decode(t.hold_date, case when s.deleted_ind = 'Y' then null else s.hold_date end,1,0) = 0
or decode(t.hold_released_date, case when s.deleted_ind = 'Y' then null else s.hold_released_date end,1,0) = 0
or decode(t.hold_reason , case when s.deleted_ind = 'Y' then null else s.hold_reason end ,1,0) = 0
or decode(t.hold_comments , case when s.deleted_ind = 'Y' then null else s.hold_comments end ,1,0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* copy 4 dates from event to prelab_event_tracking */

merge into ods_own.prelab_event_tracking t
using 
(
select event_oid
, plant_Receipt_date
, photography_date
, first_boc_start_date
, first_boc_close_date
from ods_own.event
where ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - 1
) s
on ( s.event_oid = t.event_oid )
when matched then update
set t.plant_receipt_date = s.plant_receipt_date
, t.photography_date = s.photography_date
, t.first_boc_start_date = s.first_boc_start_date
, t.first_boc_close_date = s.first_boc_close_date
where decode( t.plant_receipt_date , s.plant_receipt_date,1,0) = 0
or decode( t.photography_date , s.photography_date,1,0) = 0
or decode( t.first_boc_start_date , s.first_boc_start_date,1,0) = 0
or decode( t.first_boc_close_date , s.first_boc_close_date,1,0) = 0


&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* Legacy UC Fox Events */

merge into ods_own.prelab_event_tracking t
using
(
select e.event_oid
, e.event_ref_id
, apo.processing_lab
, e.photography_date
, e.plant_receipt_date
, e.first_boc_start_date
, e.first_boc_close_date
, eif.event_image_completion_date
, e.source_system_oid
from ods_own.event e
, ods_own.apo
, ( select event_Ref_id, min(event_image_completion_date) as event_image_completion_date, count(distinct event_image_completion_date) as eic_qty, count(*) as eic_num_rows
    from ods_own.sm_event_image_fact group by event_ref_id) eif
, mart.organization o
, ods_own.data_center dc
where e.apo_oid = apo.apo_oid
and e.event_ref_id = eif.event_ref_id(+)
and apo.territory_code = o.territory_code
and e.plant_receipt_date is not null
and e.plant_receipt_date  <> to_date('19000101','YYYYMMDD')
and apo.fulfilling_lab_system = 'FOX'
and o.ams_business_unit_name like ('%' || dc.data_center_name || '%')
and apo.apo_type is null
and apo.status = 'Active'
and e.status = '1'
and e.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - 1
) s
on ( s.event_ref_id = t.event_ref_id )
when matched then update
set t.photography_date = s.photography_date
, t.plant_receipt_date = s.plant_receipt_date
, t.first_boc_start_date = s.first_boc_start_date
, t.first_boc_close_date = s.first_boc_close_date
, t.eic_ready_date = s.event_image_completion_date
, t.ods_modify_date = sysdate
where decode(t.photography_date , s.photography_date,1,0) = 0
or decode(t.plant_receipt_date , s.plant_receipt_date,1,0) = 0
or decode(t.first_boc_start_date , s.first_boc_start_date,1,0) = 0
or decode(t.first_boc_close_date , s.first_boc_close_date,1,0) = 0
or decode(t.eic_ready_date , s.event_image_completion_date,1,0) = 0
when not matched then insert
( t.event_oid
, t.event_ref_id
, t.processing_lab
, t.photography_date
, t.plant_Receipt_date
, t.first_boc_start_date
, t.first_boc_close_date
, t.eic_ready_date
, t.source_system_oid
, t.ods_create_date
, t.ods_modify_date
)
values
( s.event_oid
, s.event_ref_id
, s.processing_lab
, s.photography_date
, s.plant_Receipt_date
, s.first_boc_start_date
, s.first_boc_close_date
, s.event_image_completion_date
, s.source_system_oid
, sysdate
, sysdate
)

&


/*-----------------------------------------------*/
/* TASK No. 32 */
/* Update Ignore Flag when All Wflw deleted for an Event */

MERGE INTO ODS_OWN.PRELAB_EVENT_TRACKING TGT
USING (
SELECT EVENT_OID FROM ODS_OWN.PRELAB_EVENT_TRACKING
WHERE EIC_READY_DATE IS NULL
AND ODS_CREATE_DATE > SYSDATE - 365
AND EVENT_REF_ID NOT IN (SELECT DISTINCT SOURCE_SYSTEM_IDENTIFIER_2 FROM ODS_OWN.PWFS_WORK_FLOW WHERE ODS_CREATE_DATE > SYSDATE - 365)
AND IGNORE_FLAG = 'N'
)SRC
ON (TGT.EVENT_OID = SRC.EVENT_OID)
WHEN MATCHED THEN
UPDATE SET
TGT.IGNORE_FLAG = 'Y',
TGT.IGNORE_DATE = SYSDATE,
TGT.IGNORE_REASON = 'All Workflows Deleted',
TGT.IGNORE_BY_USER = 'ETL Process'

&


/*-----------------------------------------------*/
/* TASK No. 33 */
/* Update Ignore Flag when an wflw is created for Ignored Event */

MERGE INTO ODS_OWN.PRELAB_EVENT_TRACKING TGT
USING (
SELECT EVENT_OID FROM ODS_OWN.PRELAB_EVENT_TRACKING
WHERE EIC_READY_DATE IS NULL
AND ODS_CREATE_DATE > SYSDATE - 180
AND ODS_CREATE_DATE > '01-APR-2020' -- Avoid flipping Flags when Trigger Issues persisted at src.
AND EVENT_REF_ID IN (SELECT DISTINCT SOURCE_SYSTEM_IDENTIFIER_2 FROM ODS_OWN.PWFS_WORK_FLOW WHERE ODS_CREATE_DATE > SYSDATE - 365)
AND IGNORE_FLAG = 'Y'
AND TERRITORY_CODE NOT IN ('LN')
)SRC
ON (TGT.EVENT_OID = SRC.EVENT_OID)
WHEN MATCHED THEN
UPDATE SET
TGT.IGNORE_FLAG = 'N',
TGT.IGNORE_DATE = SYSDATE,
TGT.IGNORE_REASON = 'Wflw created - Fliped from Y to N',
TGT.IGNORE_BY_USER = 'ETL Process'

&


/*-----------------------------------------------*/
/* TASK No. 34 */
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
/* TASK No. 35 */
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
,'UPDATE_PRELAB_EVENT_TRACKING_PKG'
,'018'
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
'UPDATE_PRELAB_EVENT_TRACKING_PKG',
'018',
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
