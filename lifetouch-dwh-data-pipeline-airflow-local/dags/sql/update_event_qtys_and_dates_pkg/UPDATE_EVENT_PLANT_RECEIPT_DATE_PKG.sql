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
/* Merge GDT Events into stage */

merge into ODS_STAGE.event_plant_receipt_date t
using
(
select job_nbr as event_ref_id
, plant_receipt_date
from ODS.gdt_event_curr
where 1=1
and plant_receipt_date is not null
and plant_receipt_date <> to_date('19000101','YYYYMMDD')
and effective_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
) g
on ( g.event_ref_id = t.event_ref_id )
when matched then update
set t.gdt_plant_receipt_date = g.plant_receipt_date
, t.last_modify_date = sysdate
where t.gdt_plant_receipt_date <> g.plant_receipt_date
or t.gdt_plant_receipt_date is null
when not matched then insert
( t.event_ref_id
, t.gdt_plant_receipt_date
, t.last_modify_date
)
values
( g.event_ref_id
, g.plant_receipt_date
, sysdate
)


&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Merge Capture Session Date into stage */

merge into ODS_STAGE.event_plant_receipt_date t
using
(
select ei.event_ref_id
, trunc(min(csi.ods_create_date)) as capture_session_date
from ODS_OWN.capture_session csi
, ods_own.event ei
where 1=1
and csi.event_oid = ei.event_oid
and csi.event_oid <> -1 
and csi.ods_create_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
group by ei.event_ref_id
) cs
on ( cs.event_ref_id = t.event_ref_id )
when matched then update
set t.capture_session_date = cs.capture_session_date
, t.last_modify_date = sysdate
where t.capture_session_date is null
when not matched then insert
( t.event_ref_id
, t.capture_session_date
, t.last_modify_date
)
values
( cs.event_ref_id
, cs.capture_session_date
, sysdate
)


&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Non-FOW system of record */

-- Non-FOW events with a GDT date must use GDT date
update ODS_STAGE.event_plant_receipt_date eprd
set eprd.system_of_record = 'GDT'
, eprd.last_modify_date = sysdate
where 1=1
and eprd.gdt_plant_receipt_date is not null
and (eprd.system_of_record <> 'GDT' or eprd.system_of_record is null)
and eprd.last_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
and exists
(
select 1
from ODS_OWN.event e
, ODS_OWN.source_system ss
where eprd.event_ref_id = e.event_ref_id
and e.source_system_oid = ss.source_system_oid
and ss.source_system_name <> 'Field Operations Workbench'
)


&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* FOW with GDT System of Record */

update ODS_STAGE.event_plant_receipt_date eprd
set eprd.system_of_record = 'GDT'
, eprd.last_modify_date = sysdate
where 1=1
and eprd.gdt_plant_receipt_date is not null
and (eprd.system_of_record <> 'GDT' or eprd.system_of_record is null)
and eprd.gdt_plant_receipt_date <= nvl(eprd.capture_session_date,to_date('25250101','YYYYMMDD'))
and eprd.last_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
and exists
(
select 1
from ODS_OWN.event e
, ODS_OWN.source_system ss
where eprd.event_ref_id = e.event_ref_id
and e.source_system_oid = ss.source_system_oid
and ss.source_system_name = 'Field Operations Workbench'
)


&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* FOW with Capture Session System of Record */

update ODS_STAGE.event_plant_receipt_date eprd
set eprd.system_of_record = 'Capture Session Date'
, eprd.last_modify_date = sysdate
where 1=1
and eprd.capture_session_date is not null
and (eprd.system_of_record <> 'Capture Session Date' or eprd.system_of_record is null)
and eprd.capture_session_date < least(nvl(eprd.gdt_plant_receipt_date,to_date('25250101','YYYYMMDD')),nvl(eprd.pwfs_date,to_date('25250101','YYYYMMDD')))
and eprd.last_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
and exists
(
select 1
from ODS_OWN.event e
, ODS_OWN.source_system ss
where eprd.event_ref_id = e.event_ref_id
and e.source_system_oid = ss.source_system_oid
and ss.source_system_name = 'Field Operations Workbench'
)

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Update plant_receipt_date for FOW events. */

merge into ODS_OWN.event t
using
(
select eprd.event_ref_id
, (case when eprd.system_of_record = 'GDT' then eprd.gdt_plant_receipt_date
/* request from Diane Hatfield and Ross Marble to subtract 3 days because this will happen a lot on GDT Proof and the receipt was likely 3 days earlier */
           when eprd.system_of_record = 'Capture Session Date' and e.selling_method = 'Proof' and apo.fulfilling_lab_system IN ('Prism') then eprd.capture_session_date
           when eprd.system_of_record = 'Capture Session Date' and e.selling_method = 'Proof' and apo.fulfilling_lab_system NOT IN ('Prism') then eprd.capture_session_date - 3  
           when eprd.system_of_record = 'Capture Session Date' then eprd.capture_session_date
           else null end) as plant_receipt_date
from ODS_STAGE.event_plant_receipt_date eprd
, ODS_OWN.event e
, ODS_OWN.source_system ss
, ODS_OWN.apo apo
where 1=1
and eprd.event_ref_id = e.event_ref_id
and e.source_system_oid = ss.source_system_oid
and e.apo_oid = apo.apo_oid
and ss.source_system_name = 'Field Operations Workbench'
and eprd.system_of_record in ('GDT','Capture Session Date')
and eprd.last_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
) s
on ( s.event_ref_id = t.event_ref_id )
when matched then update
set t.plant_receipt_date = s.plant_receipt_date
    , t.ods_modify_date = sysdate
where s.plant_receipt_date is not null
and (t.plant_receipt_date <> s.plant_receipt_date or t.plant_receipt_date is null)

&


/*-----------------------------------------------*/
/* TASK No. 10 */
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
/* TASK No. 11 */
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
,'UPDATE_EVENT_PLANT_RECEIPT_DATE_PKG'
,'010'
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
'UPDATE_EVENT_PLANT_RECEIPT_DATE_PKG',
'010',
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
