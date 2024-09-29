SELECT   (O_CDC.LAST_CDC_COMPLETION_DATE-R_CDC.ORIG_LAST_CDC_COMPLETION_DATE ) * 1440 AS minutes_difference ,R_CDC.*, O_CDC.LAST_CDC_COMPLETION_DATE
 FROM RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT R_CDC
 LEFT JOIN ods_own.ods_cdc_load_status O_CDC
 ON R_CDC.TABLE_NAME  = O_CDC.ODS_TABLE_NAME
 WHERE sess_name = '25_ORDER_TRACKING_DATA_LOAD'
  AND CREATE_DATE > SYSDATE - INTERVAL '120' MINUTE


 SELECT count(*) FROM ods_own.order_tracking

 SELECT * FROM ods_own.order_header


DELETE FROM ODS_STAGE.MLT_ORDER_STG WHERE ORDER_ID = 0

 INSERT INTO ODS_STAGE.MLT_ORDER_STG
 (
 ORDER_ID
,AUDIT_CREATE_DATE
,AUDIT_CREATED_BY
,AUDIT_MODIFIED_BY
,AUDIT_MODIFY_DATE
,PAYMENT_VOUCHER_ID
,POSTED_DATE
,PAYMENT_ID
,ORDER_TYPE
,APO_KEY
,ACCESS_CREDENTIAL
,CAPTURE_SESSION_ID
,SHIPPING_ADDRESS_ID
,CLICK_SELECTION
,COUPON_CODE
,PAYMENT_AMOUNT
,TAX_AMOUNT
,SUBJECT_FIRST_NAME
,SUBJECT_GRADE
,SUBJECT_LAST_NAME
,BACKGROUND_DESCRIPTION
,ACCOUNT_CITY
,ACCOUNT_COUNTRY
,ACCOUNT_NAME
,ACCOUNT_STATE
,JOB_NUMBER
,PAYMENT_ACCOUNT
,SELLING_METHOD_NAME
,ODS_CREATE_DATE
,ODS_MODIFY_DATE
 )
 SELECT 0,t.AUDIT_CREATE_DATE
,t.AUDIT_CREATED_BY
,t.AUDIT_MODIFIED_BY
,t.AUDIT_MODIFY_DATE
,t.PAYMENT_VOUCHER_ID
,sysdate
,t.PAYMENT_ID
,t.ORDER_TYPE
,t.APO_KEY
,t.ACCESS_CREDENTIAL
,t.CAPTURE_SESSION_ID
,t.SHIPPING_ADDRESS_ID
,t.CLICK_SELECTION
,t.COUPON_CODE
,t.PAYMENT_AMOUNT
,t.TAX_AMOUNT
,t.SUBJECT_FIRST_NAME
,t.SUBJECT_GRADE
,t.SUBJECT_LAST_NAME
,t.BACKGROUND_DESCRIPTION
,t.ACCOUNT_CITY
,t.ACCOUNT_COUNTRY
,t.ACCOUNT_NAME
,t.ACCOUNT_STATE
,t.JOB_NUMBER
,t.PAYMENT_ACCOUNT
,t.SELLING_METHOD_NAME
,TO_DATE(SUBSTR('2024-07-25 23:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
,TO_DATE(SUBSTR('2024-07-25 23:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
 FROM ODS_STAGE.MLT_ORDER_STG t
 WHERE ORDER_ID='200283318'

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
and o.ODS_MODIFY_DATE >= TO_DATE(SUBSTR('2024-07-25 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
and not exists
(
select 1
from ODS_OWN.order_tracking t2
where t2.source_system_key = to_char(o.payment_voucher_id)
and t2.source_system = 'MLT'
)


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
and o.ODS_MODIFY_DATE >= TO_DATE(SUBSTR('2024-07-25 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
and not exists
(
select 1
from ODS_OWN.order_tracking t2
where t2.source_system_key = to_char(o.order_form_id)
and t2.source_system = 'CSP'
)

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
and oh.ods_modify_date >= TO_DATE(SUBSTR('2024-07-25 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
group by oh.order_form_id
) s
on (s.order_form_id = t.source_system_key and 'CSP' = t.source_system)
when matched then update
set t.order_header_oid = s.order_header_oid
, t.oms_order_date = nvl(s.order_date, sysdate)
, t.status = 'Found in OMS'
, t.ods_modify_date = sysdate
where t.oms_order_date is null

delete from ods_own.order_tracking
where ods_create_date < sysdate - 30
and (oms_order_date is not null or ignore_flag = 'Y')

delete from ods_own.order_tracking
where ods_create_date < sysdate - 90

 -- OR run the dag

  SELECT count(*) FROM ods_own.order_tracking

  SELECT * FROM ods_own.order_tracking

  SELECT * FROM ODS_STAGE.MLT_ORDER_STG WHERE ORDER_ID = 0

-- CHECK counts; expected 1 record
 ----------------------------------------------------------------------------------------------------------------


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
and o.ODS_MODIFY_DATE >= TO_DATE(SUBSTR('2024-07-25 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
and not exists
(
select 1
from ODS_OWN.order_tracking t2
where t2.source_system_key = to_char(o.payment_voucher_id)
and t2.source_system = 'MLT'
)

 -- insert test record for order tracking
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
and o.ODS_MODIFY_DATE >= TO_DATE(SUBSTR('2024-07-25 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -.02
and not exists
(
select 1
from ODS_OWN.order_tracking t2
where t2.source_system_key = to_char(o.order_form_id)
and t2.source_system = 'CSP'
)

select oh.order_form_id
, min(oh.order_header_oid) as order_header_oid
, min(oh.order_date) as order_date
from ods_own.order_header oh
, ods_own.order_channel oc
where oh.order_channel_oid = oc.order_channel_oid
and oc.channel_name = 'CSP'
and oh.ods_modify_date >= TO_DATE(SUBSTR('2024-07-25 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -.02
group by oh.order_form_id