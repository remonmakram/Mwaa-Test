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
/* drop  table temp_event_capture_session_qty */


BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.temp_event_capture_session_qty';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  
&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* drop driver table */


BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.temp_event_cap_sess_qty_d';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  
&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* create driver table */

create table rax_app_user.temp_event_cap_sess_qty_d as
select 
event_oid
from (
select  cs.event_oid
from ods_own.capture_session cs
,ods_own.event e
where cs.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
and e.event_oid = cs.event_oid
and e.school_year >= to_char(trunc(sysdate),'YYYY') /* dont reset when degistered. 6 month buffer on school year */
and nvl(cs.event_oid,-1) <> -1
union
select  e.event_oid
from ods_own.event e
where e.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
and e.school_year >= to_char(trunc(sysdate),'YYYY') /* dont reset when degistered. 6 month buffer on school year */
and nvl(e.event_oid,-1) <> -1
) group by event_oid


&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* create table temp_event_capture_session_qty */

create table rax_app_user.temp_event_capture_session_qty as
select e.event_oid
, case when e.rollover_job_ind = 'X' then 0 else count(distinct cs.CAPTURE_SESSION_OID) end as capture_session_qty
from ods_own.capture_session cs
, ods_own.event e
, rax_app_user.temp_event_cap_sess_qty_d d
where e.event_oid = cs.event_oid
and e.event_oid = d.event_oid 
and e.school_year >= to_char(trunc(sysdate),'YYYY') /* dont reset when degistered. 6 month buffer on school year */
and exists
( 
select 1                                 -- only count capture_session if it has images
from ods_own.image i
, ods_own.source_system ss
where cs.capture_session_oid = i.capture_session_oid
and i.source_system_oid = ss.source_system_oid
and (ss.source_system_short_name <> 'SM' or (ss.source_system_short_name = 'SM' and trim(i.LTI_IMAGE_URL) is not null))
)
group by e.event_oid
,e.rollover_job_ind


&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* create index temp_event_capture_session_qty_pk */

create unique index rax_app_user.temp_event_capture_sess_qty_pk on rax_app_user.temp_event_capture_session_qty(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* upate event.capture_session_qty */

update 
(
select src.capture_session_qty as src_capture_session_qty
, trg.capture_session_qty as trg_capture_session_qty
, trg.ods_modify_date as trg_ods_modify_date
from ods_own.event trg
, rax_app_user.temp_event_capture_session_qty src
where trg.event_oid = src.event_oid
and (trg.capture_session_qty <> src.capture_session_qty
     or trg.capture_session_qty is null
    )
)
set trg_capture_session_qty = src_capture_session_qty
, trg_ods_modify_date = sysdate

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
,'UPDATE_EVENT_CAPTURE_SESSION_QTY_PKG'
,'006'
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
'UPDATE_EVENT_CAPTURE_SESSION_QTY_PKG',
'006',
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
