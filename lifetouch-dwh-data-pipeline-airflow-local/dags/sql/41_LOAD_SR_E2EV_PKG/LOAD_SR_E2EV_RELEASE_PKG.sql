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
/* New Releases / Holds */

merge into ods_own.senior_release_track t
using
(
select r.order_release_oid
, r.ship_advice_no
, r.hold_flag
, r.hold_reason_code
, ss.source_system_oid
from ods_own.order_release r
, ods_own.source_system ss
where ss.source_system_oid = r.source_system_oid
and ss.source_system_short_name = 'OMS2'
and r.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) s
on ( s.order_release_oid = t.order_release_oid )
when matched then update
set t.ship_advice_no = s.ship_advice_no
, t.hold_flag = s.hold_flag
, t.hold_reason_code = s.hold_reason_code
, t.ods_modify_date = sysdate
where decode(t.ship_advice_no,s.ship_advice_no,1,0) = 0
or decode(t.hold_flag,s.hold_flag,1,0) = 0
or decode(t.hold_reason_code,s.hold_reason_code,1,0) = 0
when not matched then insert
(t.order_release_oid
,t.ship_advice_no
,t.hold_flag
,t.hold_reason_code
,t.ods_create_date
,t.ods_modify_date
,t.source_system_oid
)
values
(s.order_release_oid
,s.ship_advice_no
,s.hold_flag
,s.hold_reason_code
,sysdate
,sysdate
,s.source_system_oid
)

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Released */

merge into ods_own.senior_release_track t
using
(
select r.order_release_oid
, ss.source_system_oid
, min(ors.status_date) as released_date
from ods_own.order_release r
, ods_own.source_system ss
, ods_own.order_release_status ors
where ss.source_system_oid = ors.source_system_oid
and ss.source_system_short_name = 'OMS2'
and r.order_release_oid = ors.order_release_oid
and '32' = substr(ors.status,1,2) -- released stati
and ors.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
group by r.order_release_oid
, ss.source_system_oid
) s
on ( s.order_release_oid = t.order_release_oid )
when matched then update
set t.released_date = s.released_date
, t.ods_modify_date = sysdate
where decode(t.released_date,s.released_date,1,0) = 0


&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Included in Shipment */

merge into ods_own.senior_release_track t
using
(
select r.order_release_oid
, ss.source_system_oid
, min(ors.status_date) as included_in_shipment_date
from ods_own.order_release r
, ods_own.source_system ss
, ods_own.order_release_status ors
where ss.source_system_oid = ors.source_system_oid
and ss.source_system_short_name = 'OMS2'
and r.order_release_oid = ors.order_release_oid
and '33' = substr(ors.status,1,2) -- included in shipment stati
and ors.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
group by r.order_release_oid
, ss.source_system_oid
) s
on ( s.order_release_oid = t.order_release_oid )
when matched then update
set t.included_in_shipment_date = s.included_in_shipment_date
, t.ods_modify_date = sysdate
where decode(t.included_in_shipment_date,s.included_in_shipment_date,1,0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Shipped */

merge into ods_own.senior_release_track t
using
(
select r.order_release_oid
, ss.source_system_oid
, min(ors.status_date) as shipped_date
from ods_own.order_release r
, ods_own.source_system ss
, ods_own.order_release_status ors
where ss.source_system_oid = ors.source_system_oid
and ss.source_system_short_name = 'OMS2'
and r.order_release_oid = ors.order_release_oid
and '37' = substr(ors.status,1,2) -- included in shipment stati
and ors.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
group by r.order_release_oid
, ss.source_system_oid
) s
on ( s.order_release_oid = t.order_release_oid )
when matched then update
set t.shipped_date = s.shipped_date
, t.ods_modify_date = sysdate
where decode(t.shipped_date,s.shipped_date,1,0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Cancel - order relese status */

merge into ods_own.senior_release_track t
using
(
select r.order_release_oid
, ss.source_system_oid
, min(ors.status_date) as cancel_date
from ods_own.order_release r
, ods_own.source_system ss
, ods_own.order_release_status ors
where ss.source_system_oid = ors.source_system_oid
and ss.source_system_short_name = 'OMS2'
and r.order_release_oid = ors.order_release_oid
and '90' = substr(ors.status,1,2) -- cancel stati
and ors.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
group by r.order_release_oid
, ss.source_system_oid
) s
on ( s.order_release_oid = t.order_release_oid )
when matched then update
set t.ignore_flag = 'Y'
, t.ignore_date = s.cancel_date
, t.ignore_reason = 'Order Release Cancelled'
, t.ignore_by_user = 'load_sr_e2ev_release_prc'
, t.ods_modify_date = sysdate
where t.ignore_flag = 'N'

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Cancel - Back Ordered from Node */

merge into ods_own.senior_release_track t
using
(
select r.order_release_oid
, ss.source_system_oid
, min(ors.status_date) as cancel_date
from ods_own.order_release r
, ods_own.source_system ss
, ods_own.order_release_status ors
where ss.source_system_oid = ors.source_system_oid
and ss.source_system_short_name = 'OMS2'
and r.order_release_oid = ors.order_release_oid
and '14' = substr(ors.status,1,2) -- backordered stati
and ors.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
group by r.order_release_oid
, ss.source_system_oid
) s
on ( s.order_release_oid = t.order_release_oid )
when matched then update
set t.ignore_flag = 'Y'
, t.ignore_date = s.cancel_date
, t.ignore_reason = 'Back Ordered from Node'
, t.ignore_by_user = 'load_sr_e2ev_release_prc'
, t.ods_modify_date = sysdate
where t.ignore_flag = 'N'

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Cancel - Do not produce item 9999 */

merge into ods_own.senior_release_track t
using
(
select distinct d.order_release_oid
from ods_own.senior_release_track d
, ods_own.order_release_status ors
, ods_own.order_line ol
, ods_own.item i
where d.order_release_oid = ors.order_release_oid
and ors.order_line_oid = ol.order_line_oid
and ol.item_oid = i.item_oid
and i.item_id = '9999' -- do not produce
and d.shipped_date is null
and d.ignore_flag = 'N'
and ors.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) s
on ( s.order_release_oid = t.order_release_oid )
when matched then update
set t.ignore_flag = 'Y'
, t.ignore_reason = 'Do Not Produce'
, t.ignore_by_user = 'load_sr_e2ev_release_prc'
, t.ods_modify_date = sysdate
where t.ignore_flag = 'N'

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* 90 DAY HAPPY PATH PURGE */

delete
-- select *
from
ods_own.senior_release_track
where (1=1)
and ODS_CREATE_DATE <= sysdate -90
and (released_date is not null
    and shipped_date is not null)


&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* 365 DAY  PURGE */

delete
-- select *
from
ods_own.senior_release_track
where (1=1)
and ODS_CREATE_DATE <= sysdate -365

&


/*-----------------------------------------------*/
/* TASK No. 13 */
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
/* TASK No. 14 */
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
,'LOAD_SR_E2EV_RELEASE_PKG'
,'003'
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
'LOAD_SR_E2EV_RELEASE_PKG',
'003',
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
