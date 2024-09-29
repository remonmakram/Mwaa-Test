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
/* Insert MLT Orders */

insert into ODS_OWN.ORDER_TRACKING T
(SOURCE_SYSTEM
,SOURCE_SYSTEM_KEY
,SOURCE_ORDER_DATE
,EVENT_REF_ID
,ORDER_TRACKING_OID
,STATUS
,ODS_CREATE_DATE
,ODS_MODIFY_DATE
)
select 'MLT' as SOURCE_SYSTEM
,to_char(o.payment_voucher_id) as SOURCE_SYSTEM_KEY
,o.audit_create_date as SOURCE_ORDER_DATE
,o.job_number
,ODS_STAGE.ORDER_TRACKING_SEQ.nextval
,'Posted in MLT' as status
,SYSDATE
,SYSDATE
from ODS_STAGE.MLT_ORDER_STG o
where 1=1
and o.order_type not in ('PAYMENT') -- pay onlys aren't orders
and o.posted_date is not null -- the null ones were not sent - abandoned carts
and o.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
and not exists
(
select 1
from ODS_OWN.order_tracking t2
where t2.source_system_key = to_char(o.payment_voucher_id)
and t2.source_system = 'MLT'
)


&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Update MLT Orders */

merge into ods_own.order_tracking t
using
(
select oh.order_form_id
, min(oh.order_header_oid) as order_header_oid
, min(oh.order_date) as order_date
from ods_own.order_header oh
, ods_own.order_channel oc
where oh.order_channel_oid = oc.order_channel_oid 
and oc.channel_name = 'MLT'
and oh.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
group by oh.order_form_id
) s
on (s.order_form_id = t.source_system_key and 'MLT' = t.source_system)
when matched then update
set t.order_header_oid = s.order_header_oid
, t.oms_order_date = nvl(s.order_date, sysdate)
, t.status = 'Found in OMS'
, t.ods_modify_date = sysdate
where t.oms_order_date is null 

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Insert CSP Orders */

insert into ODS_OWN.ORDER_TRACKING T
(SOURCE_SYSTEM
,SOURCE_SYSTEM_KEY
,SOURCE_ORDER_DATE
,EVENT_REF_ID
,oms_order_date
,ORDER_TRACKING_OID
,STATUS
,ODS_CREATE_DATE
,ODS_MODIFY_DATE
)
select 'CSP' as SOURCE_SYSTEM
,to_char(o.order_form_id) as SOURCE_SYSTEM_KEY
,from_tz(cast(o.posted_date as timestamp), 'UTC') at time zone 'US/Central' as SOURCE_ORDER_DATE
,o.event_ref_id
,oh.order_date as oms_order_date
,ODS_STAGE.ORDER_TRACKING_SEQ.nextval
,case when oh.order_date is null then 'Posted in CSP' else 'Found in OMS' end as status
,SYSDATE
,SYSDATE
from ODS_STAGE.CSP_ORDER_STG o
, ods_own.order_header oh
where 1=1
and o.order_status = 'RELEASED'-- pay onlys aren't orders
and o.posted_date is not null 
and o.order_form_id = oh.order_form_id(+)
and o.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
and not exists
(
select 1
from ODS_OWN.order_tracking t2
where t2.source_system_key = to_char(o.order_form_id)
and t2.source_system = 'CSP'
)


&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Update CSP Orders */

merge into ods_own.order_tracking t
using
(
select oh.order_form_id
, min(oh.order_header_oid) as order_header_oid
, min(oh.order_date) as order_date
from ods_own.order_header oh
, ods_own.order_channel oc
where oh.order_channel_oid = oc.order_channel_oid 
and oc.channel_name = 'CSP'
and oh.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
group by oh.order_form_id
) s
on (s.order_form_id = t.source_system_key and 'CSP' = t.source_system)
when matched then update
set t.order_header_oid = s.order_header_oid
, t.oms_order_date = nvl(s.order_date, sysdate)
, t.status = 'Found in OMS'
, t.ods_modify_date = sysdate
where t.oms_order_date is null 

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* 30 Day Happy Path Purge */

delete from ods_own.order_tracking
where ods_create_date < sysdate - 30
and (oms_order_date is not null or ignore_flag = 'Y')

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* 90 Day Unhappy Path Purge */

delete from ods_own.order_tracking
where ods_create_date < sysdate - 90

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
,'25_ORDER_TRACKING_DATA_LOAD'
,'014'
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
'25_ORDER_TRACKING_DATA_LOAD',
'014',
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
