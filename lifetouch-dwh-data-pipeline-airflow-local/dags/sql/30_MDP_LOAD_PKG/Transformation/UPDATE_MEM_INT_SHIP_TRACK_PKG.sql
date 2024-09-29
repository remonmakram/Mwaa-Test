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
/* Update Shipment Details - OMS3 */

-- this is for the MDP_ORDER_IDs we may have inserted last time and hadn't already matched to a shipment.  
-- this should help us assure we don't insert the shipment a second time.

merge into ods_own.mem_int_ship_track t
using
(
select d.mem_int_ship_track_oid
, sh.shipment_no
, sh.actual_shipment_date
from ods_own.shipment sh
, ods_stage.oms_shipment_xr sxr
, ods_own.mem_int_ship_track d
where sh.shipment_oid = sxr.shipment_oid
and d.shipment_key = sxr.shipment_key
and d.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - 1
and d.actual_shipment_date is null
) s
on ( t.mem_int_ship_track_oid = s.mem_int_ship_track_oid)
when matched then update
set t.shipment_no = s.shipment_no
, t.actual_shipment_date = s.actual_shipment_date




&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Update Shipment Details - OMS2 */

-- this is for the MDP_ORDER_IDs we may have inserted last time and hadn't already matched to a shipment.  
-- this should help us assure we don't insert the shipment a second time. (OMS2)

merge into ods_own.mem_int_ship_track t
using
(
select d.mem_int_ship_track_oid
, sh.shipment_no
, sh.actual_shipment_date
from ods_own.shipment sh
, ods_stage.oms2_shipment_xr sxr
, ods_own.mem_int_ship_track d
where sh.shipment_oid = sxr.shipment_oid
and d.shipment_key = sxr.shipment_key
and d.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - 1
and d.actual_shipment_date is null
) s
on ( t.mem_int_ship_track_oid = s.mem_int_ship_track_oid)
when matched then update
set t.shipment_no = s.shipment_no
, t.actual_shipment_date = s.actual_shipment_date

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Update MDP order_id */

-- this is for the just inserted rows sourced from shipment data that may already have an MDP order id

merge into ods_own.mem_int_ship_track t
using
(
select d.mem_int_ship_track_oid
, o.order_id
from ods_own.mem_int_ship_track d
, ods_stage.mdp_order_stg o
where d.order_no = o.order_no
and d.shipment_key = o.shipment_key
and d.shipment_key is not null
and d.order_id is null
and d.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
) s
on (t.mem_int_ship_track_oid = s.mem_int_ship_track_oid)
when matched then update
set t.order_id = s.order_id

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* MDP Stuff */

merge into ods_own.mem_int_ship_track t
using
(
select mo.ORDER_ID
,cast(mo.AUDIT_CREATE_DATE as date) as mdp_create_date
,cast(mo.PROCESSING_END_TIME as date) as mdp_processing_end_date
,mo.ORDER_NO
,mo.SHIPMENT_ID
,mo.OUTCOME
,mo.CUSTOMER_ORDER_MESSAGE_KEY
,mo.shipment_key
,ss.source_system_oid
from ods_own.mdp_order mo
, ods_own.source_system ss
where 1=1
and mo.shipment_id is not null
and mo.source in ('http', 'oms')
and ss.source_system_short_name = 'MDP'
and mo.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
) s
on ( s.order_id = t.order_id )
when matched then update
set T.SHIPMENT_ID = S.SHIPMENT_ID
, T.ORDER_NO = S.ORDER_NO
, T.MDP_CREATE_DATE = S.MDP_CREATE_DATE
, T.MDP_PROCESSING_END_DATE = S.MDP_PROCESSING_END_DATE
, T.MDP_OUTCOME = S.OUTCOME
, T.CUSTOMER_ORDER_MESSAGE_KEY = S.CUSTOMER_ORDER_MESSAGE_KEY
, t.shipment_key = s.shipment_key
, T.ODS_MODIFY_DATE = sysdate
, T.SOURCE_SYSTEM_OID = S.SOURCE_SYSTEM_OID
, T.MIP_INITIATED_DATE = case when s.outcome = 'unqualified' then s.MDP_PROCESSING_END_DATE else T.MIP_INITIATED_DATE end
, T.MIP_TRANSFERRED_DATE = case when s.outcome = 'unqualified' then s.MDP_PROCESSING_END_DATE else T.MIP_TRANSFERRED_DATE end
where decode(t.shipment_id,s.shipment_id,1,0) = 0
or decode(t.order_no,s.order_no,1,0) = 0
or decode(t.mdp_outcome,s.outcome,1,0) = 0
or decode(t.customer_order_message_key,s.customer_order_message_key,1,0) = 0
or decode(t.shipment_key,s.shipment_key,1,0) = 0
or nvl(t.mdp_create_date,to_date('19000101','YYYYMMDD') )<> nvl(s.mdp_create_date,to_date('19000101','YYYYMMDD'))
or nvl(t.mdp_processing_end_date,to_date('19000101','YYYYMMDD') )<> nvl(s.mdp_processing_end_date,to_date('19000101','YYYYMMDD'))
when not matched then insert
(t.MEM_INT_SHIP_TRACK_OID
,t.ORDER_ID
,t.MDP_CREATE_DATE
,t.MDP_PROCESSING_END_DATE
,t.ORDER_NO
,t.SHIPMENT_ID
,t.MDP_OUTCOME
,t.CUSTOMER_ORDER_MESSAGE_KEY
,t.shipment_key
,t.ODS_CREATE_DATE
,t.ODS_MODIFY_DATE
,t.SOURCE_SYSTEM_OID
,T.MIP_INITIATED_DATE
,T.MIP_TRANSFERRED_DATE
)
values
(ods_own.MEM_INT_SHIP_TRACK_OID_SEQ.nextval
,s.ORDER_ID
,s.MDP_CREATE_DATE
,s.MDP_PROCESSING_END_DATE
,s.ORDER_NO
,s.SHIPMENT_ID
,s.OUTCOME
,s.CUSTOMER_ORDER_MESSAGE_KEY
,s.shipment_key
,sysdate
,sysdate
,s.SOURCE_SYSTEM_OID
,case when s.outcome = 'unqualified' then s.MDP_PROCESSING_END_DATE else null end
,case when s.outcome = 'unqualified' then s.MDP_PROCESSING_END_DATE else null end
)



&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* MIP Stuff */

merge into ods_own.mem_int_ship_track t
using
(
select mco.order_no
,min(mco.audit_create_date) as mip_initiated_date
,min(case when mco.status in ('transferred') then  from_tz(cast(mco.audit_modified_date as timestamp), 'UTC') at time zone 'US/Central' else null end) as mip_transferred_date
,min(case when mco.status = 'failed' then from_tz(cast(mco.audit_modified_date as timestamp), 'UTC') at time zone 'US/Central' else null end) as mip_failed_date
,max(mco.status) as status
from ods_own.mip_customer_order mco
where 1=1
and mco.shipment_key is not null
and mco.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
group by mco.order_no
) s
on ( s.order_no = t.order_no )
when matched then update
set T.STATUS = S.STATUS
, T.MIP_INITIATED_DATE = S.MIP_INITIATED_DATE
, T.MIP_TRANSFERRED_DATE = case when t.mip_transferred_date is null then S.MIP_TRANSFERRED_DATE else t.mip_transferred_date end
, T.MIP_FAILED_DATE = S.MIP_FAILED_DATE
, t.mdp_processing_end_date = case when t.mdp_processing_end_date is null then S.MIP_INITIATED_DATE else t.mdp_processing_end_date end
where t.ignore_flag = 'N'
and t.mip_transferred_date is null
and (decode(t.status,s.status,1,0) = 0
or nvl(T.MIP_INITIATED_DATE,to_date('19000101','YYYYMMDD') )<> nvl(S.MIP_INITIATED_DATE,to_date('19000101','YYYYMMDD'))
or nvl(T.MIP_TRANSFERRED_DATE,to_date('19000101','YYYYMMDD') )<> nvl(case when t.mip_transferred_date is null then S.MIP_TRANSFERRED_DATE else t.mip_transferred_date end,to_date('19000101','YYYYMMDD'))
or nvl(T.MIP_FAILED_DATE,to_date('19000101','YYYYMMDD') )<> nvl(S.MIP_FAILED_DATE,to_date('19000101','YYYYMMDD'))
or t.mdp_processing_end_date is null
)

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* 90 DAY HAPPY PATH PURGE */

delete
-- select *
from
ods_own.mem_int_ship_track
where (1=1)
and ODS_CREATE_DATE <= sysdate -90
and mip_transferred_date is not null

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* 365 DAY  PURGE */

delete
-- select *
from
ods_own.mem_int_ship_track
where (1=1)
and ODS_CREATE_DATE <= sysdate -365

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
             SUBSTR('2024-06-17 13:09:37.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
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
,'UPDATE_MEM_INT_SHIP_TRACK_PKG'
,'005'
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
'UPDATE_MEM_INT_SHIP_TRACK_PKG',
'005',
TO_DATE(
             SUBSTR('2024-06-17 13:09:37.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/


&


/*-----------------------------------------------*/
