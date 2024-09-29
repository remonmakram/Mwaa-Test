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
/* drop temp table1 */

BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_merch_fact1';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;


&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* create temp table1 */

create table RAX_APP_USER.tmp_merch_fact1
(
        order_header_oid number,
        order_date date,
        order_bucket varchar2(100),
        item_id number,       
        charge_category varchar2(20),
        total_amt number,
        line_total number,
        order_qty number,
        ordered_qty number,
        charge_amt number,
        tax_amt number,
        mlt_multi_payment_id number,
        merch_junk_id number,
        apo_oid number,
        subject_oid number,
        line_total_undiscounted number,
        unit_price number
)

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* index temp table1 */

create unique index RAX_APP_USER.tmp_merch_fact1_ix on RAX_APP_USER.tmp_merch_fact1(order_header_oid)

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* insert into temp table1 */

insert into RAX_APP_USER.tmp_merch_fact1
( 
        order_header_oid,     
        order_date,
        order_bucket,
        item_id,       
        charge_category,
        total_amt,
        line_total,
        order_qty,
        ordered_qty,
        charge_amt,
        tax_amt, 
        mlt_multi_payment_id,
        merch_junk_id,
        apo_oid,
        subject_oid,
        line_total_undiscounted,
        unit_price
)
select oh.order_header_oid, oh.order_date, oh.order_bucket, -1 as item_id, '.' as charge_category, nvl(oh.total_amount, 0) as total_amt, 0 as line_total, 1 as order_qty, 0 as ordered_qty, 0 as charge_amt, oh.oms_tax as tax_amt, nvl(oh.mlt_multi_payment_id, 0) as mlt_multi_payment_id, mj.merch_junk_id, oh.apo_oid, nvl(cs.subject_oid, -1) as subject_oid,
0 as line_total_undiscounted,
0 as unit_price
from ODS_OWN.order_header oh,
MART.merch_junk mj,
ODS_OWN.capture_session cs
where 1=1
and oh.order_bucket in ('PAID', 'UNPAID')
and oh.source_system_oid <> 22
and mj.order_category = 'ORIGINAL_ORDER'
and oh.matched_capture_session_id = cs.capture_session_key(+)
and oh.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
union
select oh.order_header_oid, oh.order_date, oh.order_bucket, -1 as item_id, '.' as charge_category, nvl(oh.total_amount, 0) as total_amt, 0 as line_total, 1 as order_qty, 0 as ordered_qty, 0 as charge_amt, oh.oms_tax as tax_amt, nvl(oh.mlt_multi_payment_id, 0) as mlt_multi_payment_id, mj.merch_junk_id, oh.apo_oid, nvl(cs.subject_oid, -1) as subject_oid,
0 as line_total_undiscounted, 0 as unit_price
from ODS_OWN.order_header oh,
MART.merch_fact mf,
MART.merch_junk mj,
ODS_OWN.capture_session cs
where 1=1
and oh.order_header_oid = mf.order_header_oid
and mf.order_qty = 1
and oh.order_bucket not in ('PAID', 'UNPAID')
and oh.source_system_oid <> 22
and mj.order_category = 'ORIGINAL_ORDER'
and oh.matched_capture_session_id = cs.capture_session_key(+)
and oh.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap



&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* drop temp table tmp_apo_subject_userprofile */

BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_apo_subject_userprofile';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;


&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* create temp table tmp_apo_subject_userprofile */

create table RAX_APP_USER.tmp_apo_subject_userprofile as
select oh.apo_oid, oh.user_profile_oid, tmp.subject_oid, oh.order_header_oid, oh.order_date, oh.order_form_id, oh.order_channel_oid
from RAX_APP_USER.tmp_merch_fact1 tmp
, ODS_OWN.order_header oh
--, ODS_OWN.capture_session cs
--, ODS_OWN.subject s
where 1=1
and tmp.order_header_oid = oh.order_header_oid
and oh.source_system_oid <> 22
and oh.order_bucket =  'PAID'
--and cs.capture_session_key = oh.matched_capture_session_id
--and cs.subject_oid = s.subject_oid


&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* index temp table tmp_apo_subject_userprofile */

create index RAX_APP_USER.tmp_apo_subject_userprofile_ix on RAX_APP_USER.tmp_apo_subject_userprofile(apo_oid, user_profile_oid, subject_oid)

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* drop temp table tmp_apo_subject */

BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_apo_subject';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* create temp table tmp_apo_subject */

create table RAX_APP_USER.tmp_apo_subject as
select tmp.apo_oid, tmp.subject_oid, min(oh.order_date) as min_order_date
from ODS_OWN.order_header oh
, RAX_APP_USER.tmp_apo_subject_userprofile tmp
, ODS_OWN.capture_session cs
, ODS_OWN.subject s
where 1=1
and oh.user_profile_oid = tmp.user_profile_oid
and cs.capture_session_key = oh.matched_capture_session_id
and cs.subject_oid = s.subject_oid
and s.subject_oid = tmp.subject_oid
and oh.order_bucket =  'PAID' 
group by tmp.apo_oid, tmp.subject_oid
having count(tmp.subject_oid) > 1

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* index temp table tmp_apo_subject */

create unique index RAX_APP_USER.tmp_apo_subject_ix on RAX_APP_USER.tmp_apo_subject(apo_oid, subject_oid)


&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* drop temp table tmp_subject_reorder */

BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_subject_reorder';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* create temp table tmp_subject_reorder */

create table RAX_APP_USER.tmp_subject_reorder as
select tmp_profile.order_header_oid, junk.merch_junk_id, tmp_profile.subject_oid
from RAX_APP_USER.tmp_apo_subject tmp_apo_subject
, RAX_APP_USER.tmp_apo_subject_userprofile tmp_profile
, RAX_APP_USER.tmp_merch_fact1 tmp1
, MART.merch_junk junk
where 1=1
and tmp_apo_subject.apo_oid = tmp_profile.apo_oid
and tmp_apo_subject.subject_oid = tmp_profile.subject_oid
and tmp_profile.order_date > tmp_apo_subject.min_order_date 
and tmp_profile.order_header_oid = tmp1.order_header_oid
and junk.order_category = 'SUBJECT_REORDER'
group by tmp_profile.order_header_oid, junk.merch_junk_id, tmp_profile.subject_oid

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* index temp table tmp_subject_reorder */

create unique index RAX_APP_USER.tmp_subject_reorder_ix on RAX_APP_USER.tmp_subject_reorder(order_header_oid)


&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* update tmp_merch_fact1 subject_reorder */

update
(
select t.merch_junk_id as target_merch_junk_id
, s.merch_junk_id as source_merch_junk_id
, t.subject_oid as target_subject_oid
, s.subject_oid as source_subject_oid
from RAX_APP_USER.tmp_merch_fact1 t
, RAX_APP_USER.tmp_subject_reorder s
where t.order_header_oid = s.order_header_oid
)
set target_merch_junk_id = source_merch_junk_id
, target_subject_oid = source_subject_oid

&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* drop temp table tmp_mlt_true_reorder */

BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_mlt_true_reorder';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* create temp_mlt_true_reorder */

create table RAX_APP_USER.tmp_mlt_true_reorder as
select tmp.apo_oid, tmp.subject_oid, tmp.user_profile_oid, min(oh.order_date) as min_order_date, min(trim(oh.order_form_id))  as min_order_form_id
from ODS_OWN.order_header oh
, RAX_APP_USER.tmp_apo_subject_userprofile tmp
, ODS_OWN.order_channel oc
, ODS_OWN.capture_session cs
, ODS_OWN.subject s
where 1=1
and oh.user_profile_oid = tmp.user_profile_oid
and oh.order_channel_oid = tmp.order_channel_oid
and oh.order_channel_oid = oc.order_channel_oid
and oc.channel_name = 'MLT'
and oh.order_bucket =  'PAID'
and cs.capture_session_key = oh.matched_capture_session_id
and cs.subject_oid = s.subject_oid
and s.subject_oid = tmp.subject_oid
group by tmp.apo_oid, tmp.subject_oid, tmp.user_profile_oid
having count(tmp.user_profile_oid) > 1

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* index temp table tmp_mlt_true_reorder */

create unique index RAX_APP_USER.tmp_mlt_true_reorder_ix on RAX_APP_USER.tmp_mlt_true_reorder(apo_oid, user_profile_oid, subject_oid)

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* drop temp table tmp_mlt_true_reorder1 */

BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_mlt_true_reorder1';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* create temp table tmp_mlt_true_reorder1 */

create table RAX_APP_USER.tmp_mlt_true_reorder1 as
select tmp_profile.order_header_oid, junk.merch_junk_id, tmp_profile.subject_oid
from RAX_APP_USER.tmp_mlt_true_reorder tmp_reorder
, RAX_APP_USER.tmp_apo_subject_userprofile tmp_profile
, RAX_APP_USER.tmp_merch_fact1 tmp1
, MART.merch_junk junk
where 1=1
and tmp_reorder.apo_oid = tmp_profile.apo_oid
and tmp_reorder.subject_oid = tmp_profile.subject_oid
and tmp_reorder.user_profile_oid = tmp_profile.user_profile_oid
and (tmp_profile.order_date > tmp_reorder.min_order_date or (tmp_profile.order_date = tmp_reorder.min_order_date
and to_number(tmp_profile.order_form_id) > tmp_reorder.min_order_form_id))
and tmp_profile.order_header_oid = tmp1.order_header_oid
and junk.order_category = 'TRUE_CUSTOMER_REORDER'
group by tmp_profile.order_header_oid, junk.merch_junk_id, tmp_profile.subject_oid

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* index temp table tmp_mlt_true_reorder1 */

create unique index RAX_APP_USER.tmp_mlt_true_reorder1_ix on RAX_APP_USER.tmp_mlt_true_reorder1(order_header_oid)



&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* update tmp_merch_fact1 true_customer_order */

update
(
select t.merch_junk_id as target_merch_junk_id
, s.merch_junk_id as source_merch_junk_id
, t.subject_oid as target_subject_oid
, s.subject_oid as source_subject_oid
from RAX_APP_USER.tmp_merch_fact1 t
, RAX_APP_USER.tmp_mlt_true_reorder1 s
where t.order_header_oid = s.order_header_oid
)
set target_merch_junk_id = source_merch_junk_id
, target_subject_oid = source_subject_oid

&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* drop index temp table1 */

BEGIN
   EXECUTE IMMEDIATE 'drop index RAX_APP_USER.tmp_merch_fact1_ix';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* create index temp table tmp_merch_fact1 */

create index RAX_APP_USER.tmp_merch_fact1_ix on RAX_APP_USER.tmp_merch_fact1(order_header_oid)

&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* insert into temp table1 from line */

insert into RAX_APP_USER.tmp_merch_fact1
( 
        order_header_oid,     
        order_date,
        order_bucket,
        item_id,       
        charge_category,
        total_amt,
        line_total,
        order_qty,
        ordered_qty,
        charge_amt,
        tax_amt,
        mlt_multi_payment_id,
        merch_junk_id, 
        apo_oid,
        subject_oid,
        line_total_undiscounted,
        unit_price
)
select oh.order_header_oid, oh.order_date, oh.order_bucket, mi.item_id, '.' as charge_category, 0 as total_amt, 
sum(ol.line_total) as line_total, 0 as order_qty, sum(ol.ordered_quantity) as ordered_qty, 0 as charge_amt, 0 as tax_amt,
0 as mlt_multi_payment_id, 0 as merch_junk_id,  oh.apo_oid, s.subject_oid,
sum(case when oh.order_bucket = 'CANCELLED' then 0 else    case when nvl(ol.list_price, 0) = 0 then ol.unit_price * ol.ordered_quantity else ol.list_price * ol.ordered_quantity end end) as line_total_undiscounted, min(ol.unit_price)
from ODS_OWN.order_Line ol ,ODS_OWN.order_header oh
, ODS_OWN.item item
, MART.item mi
, ODS_OWN.capture_session cs
, ODS_OWN.subject s
where 1=1
and ol.order_header_oid = oh.order_header_oid
and ol.item_oid = item.item_oid
and item.item_id = mi.item_code(+)
and oh.order_bucket in ('PAID', 'UNPAID')
and oh.source_system_oid <> 22
and ol.bundle_parent_order_line_oid is null
and oh.matched_capture_session_id = cs.capture_session_key(+)
and cs.subject_oid = s.subject_oid(+)
and ol.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
group by oh.order_header_oid, oh.order_no, oh.order_date, oh.order_bucket, mi.item_id, oh.apo_oid, s.subject_oid
union
select oh.order_header_oid, oh.order_date, oh.order_bucket, mi.item_id, '.' as charge_category, 0 as total_amt, 
sum(ol.line_total) as line_total, 0 as order_qty, sum(ol.ordered_quantity) as ordered_qty, 0 as charge_amt, 0 as tax_amt,
0 as mlt_multi_payment_id, 0 as merch_junk_id,  oh.apo_oid, s.subject_oid, sum(case when oh.order_bucket = 'CANCELLED' then 0 else case when nvl(ol.list_price, 0) = 0 then ol.unit_price * ol.ordered_quantity else ol.list_price * ol.ordered_quantity end end) as line_total_undiscounted, min(ol.unit_price)
from ODS_OWN.order_Line ol ,ODS_OWN.order_header oh
, ODS_OWN.item item
, MART.item mi
, MART.merch_fact mf
, ODS_OWN.capture_session cs
, ODS_OWN.subject s
where 1=1
and ol.order_header_oid = oh.order_header_oid
and oh.order_header_oid = mf.order_header_oid
and mf.order_qty = 1
and ol.item_oid = item.item_oid
and item.item_id = mi.item_code(+)
and oh.order_bucket not in ('PAID', 'UNPAID')
and oh.source_system_oid <> 22
and ol.bundle_parent_order_line_oid is null
and oh.matched_capture_session_id = cs.capture_session_key(+)
and cs.subject_oid = s.subject_oid(+)
and ol.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
group by oh.order_header_oid, oh.order_no, oh.order_date, oh.order_bucket, mi.item_id, oh.apo_oid, s.subject_oid


&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* insert into temp table1 from header charge */

insert into RAX_APP_USER.tmp_merch_fact1
( 
       order_header_oid,       
        order_date,
        order_bucket,
        item_id,       
        charge_category,
        total_amt,
        line_total,
        order_qty,
        ordered_qty,
        charge_amt,
        tax_amt,
        mlt_multi_payment_id,
        merch_junk_id,
        apo_oid,
        subject_oid,
        line_total_undiscounted,
        unit_price
)
select oh.order_header_oid, oh.order_date, oh.order_bucket, -1 as item_id, hc.charge_category, 0 as total_amt, 
0 as line_total, 0 as order_qty, 0 as ordered_qty, case when hc.charge_category = 'Discounts' then -sum(hc.charge) else sum(hc.charge) end as charge_amt, 0 as tax_amt,
0 as mlt_multi_payment_id, 0 as merch_junk_id,  oh.apo_oid, s.subject_oid, 0 as line_total_undiscounted,
0 as unit_price
from ODS_OWN.header_charge hc, ODS_OWN.order_header oh
, ODS_OWN.capture_session cs
, ODS_OWN.subject s
where 1=1
and hc.order_header_oid = oh.order_header_oid
and hc.charge_category in ('Charges', 'Discounts')
and oh.order_bucket in ('PAID', 'UNPAID')
and oh.source_system_oid <> 22
and hc.charge > 0
and oh.matched_capture_session_id = cs.capture_session_key(+)
and cs.subject_oid = s.subject_oid(+)
and hc.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
group by oh.order_header_oid, oh.order_no, oh.order_date, oh.order_bucket, hc.charge_category,  oh.apo_oid, s.subject_oid

&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* insert into temp table1 from line charge */

insert into RAX_APP_USER.tmp_merch_fact1
( 
       order_header_oid,
        order_date,
        order_bucket, 
        item_id,       
        charge_category,
        total_amt,
        line_total,
        order_qty,
        ordered_qty,
        charge_amt,
        tax_amt,
        mlt_multi_payment_id,
        merch_junk_id,
        apo_oid,
        subject_oid,
        line_total_undiscounted,
        unit_price
)
select oh.order_header_oid, oh.order_date, oh.order_bucket, mi.item_id, lc.charge_category, 0 as total_amt, 
0 as line_total, 0 as order_qty, 0 as ordered_qty, case when lc.charge_category = 'Discounts' then -sum(lc.charge_amount) else sum(lc.charge_amount) end as charge_amt, 0 as tax_amt,
0 as mlt_multi_payment_id, 0 as merch_junk_id,  oh.apo_oid, s.subject_oid, 0 as line_total_undiscounted,
0 as unit_price
from ODS_OWN.line_charge lc, ODS_OWN.order_header oh,
ODS_OWN.order_line ol
, ODS_OWN.item item
, MART.item mi
, ODS_OWN.capture_session cs
, ODS_OWN.subject s
where 1=1
and lc.order_line_oid = ol.order_line_oid
and ol.order_header_oid = oh.order_header_oid
and lc.charge_category in ('Charges', 'Discounts')
and ol.item_oid = item.item_oid
and item.item_id = mi.item_code(+)
and oh.order_bucket in ('PAID', 'UNPAID')
and oh.source_system_oid <> 22
and lc.charge_amount > 0
and oh.matched_capture_session_id = cs.capture_session_key(+)
and cs.subject_oid = s.subject_oid(+)
and lc.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
group by oh.order_header_oid, oh.order_no, oh.order_date, oh.order_bucket, mi.item_id, lc.charge_category,  oh.apo_oid, s.subject_oid


&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* drop temp table2 */

BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_merch_fact2';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* create temp table2 */

create table RAX_APP_USER.tmp_merch_fact2
as
select ma.account_id
, mapo.apo_id
, me.event_id
, mm.marketing_id
, mo.organization_id as job_ticket_org_id
, ca.assignment_id
, ca.effective_date as assignment_effective_date
, mc.channel_id as order_channel_id
, tmp.order_header_oid
, tmp.order_date
, tmp.order_bucket
, tmp.item_id
, tmp.charge_category
, tmp.total_amt
, tmp.line_total
, tmp.order_qty
, tmp.ordered_qty
, tmp.charge_amt
, tmp.tax_amt
, tmp.mlt_multi_payment_id
, tmp.merch_junk_id
, nvl(msa.subject_apo_id, -1) as subject_apo_id
, tmp.line_total_undiscounted
, nvl(oh.order_ship_date, to_date('19000101','YYYYMMDD')) as order_ship_date
, nvl(oh.mlt_order_type, '.') as mlt_order_type
, tmp.unit_price
, sysdate as mart_create_date
, Sysdate as mart_modify_date
from  RAX_APP_USER.tmp_merch_fact1 tmp
, ODS_OWN.order_header oh
, ODS_OWN.event e
, MART.event me
, ODS_OWN.account a
, ODS_OWN.apo apo
, MART.apo mapo
, MART.account ma
, ODS_OWN.sub_program sp
, MART.marketing mm
, MART.current_assignment ca
, MART.organization  mo   
, ODS_OWN.order_channel oc
, MART.channel mc
, ODS_OWN.subject_apo sa
, MART.subject_apo msa
where 1=1
and oh.order_header_oid = tmp.order_header_oid
and oh.order_channel_oid = oc.order_channel_oid
and oc.channel_name = mc.channel_name
and oh.event_oid = e.event_oid
and nvl(e.event_ref_id,-1) = me.Job_nbr(+)
and oh.apo_oid = apo.apo_Oid
and  nvl(apo.apo_id, -1) = mapo.apo_code(+)
and apo.account_oid = a.account_oid 
and nvl(a.lifetouch_id, -1) = ma.lifetouch_id(+)
and apo.sub_program_oid = sp.sub_program_oid  
and nvl(sp.sub_program_oid, -1) = mm.sub_program_oid(+)
and a.Lifetouch_Id = ca.Lifetouch_Id
and mm.program_id = ca.program_id
and nvl(apo.territory_code, -1) = mo.territory_code(+)
and tmp.apo_oid = sa.apo_oid(+)
and nvl(tmp.subject_oid, -1) = sa.subject_oid(+)
and sa.subject_apo_oid = msa.subject_apo_oid(+)




&


/*-----------------------------------------------*/
/* TASK No. 32 */
/* index temp table2 */

create index RAX_APP_USER.tmp_merch_fact2_ix on RAX_APP_USER.tmp_merch_fact2(order_header_oid, charge_category, item_id)

&


/*-----------------------------------------------*/
/* TASK No. 33 */
/* merge into fact table */

merge into MART.merch_fact t
using ( select account_id, event_id, apo_id, marketing_id, job_ticket_org_id, 
         assignment_id, assignment_effective_date, order_channel_id, order_header_oid, order_bucket, 
         item_id,  charge_category, total_amt, line_total, order_qty, ordered_qty, order_date,
         charge_amt, tax_amt, mlt_multi_payment_id, merch_junk_id, subject_apo_id, line_total_undiscounted,
         order_ship_date, mlt_order_type, unit_price
         from RAX_APP_USER.tmp_merch_fact2) s
on (s.order_header_oid= t.order_header_oid and s.charge_category= t.charge_category and nvl(s.item_id, -1) = nvl(t.item_id, -1) )
when matched then
update 
set t.account_id = s.account_id
, t.apo_id = s.apo_id
, t.event_id = s.event_id
, t.marketing_id = s.marketing_id
, t.job_ticket_org_id = s.job_ticket_org_id
, t.assignment_id = s.assignment_id
, t.assignment_effective_date = s.assignment_effective_date
, t.order_channel_id = s.order_channel_id
, t.order_bucket = s.order_bucket
, t.order_date = s.order_date
, t.total_amt = s.total_amt
, t.line_total = s.line_total
, t.order_qty = s.order_qty
, t.ordered_qty = s.ordered_qty
, t.charge_amt = s.charge_amt
, t.tax_amt = s.tax_amt
, t.mlt_multi_payment_id = s.mlt_multi_payment_id
, t.merch_junk_id = s.merch_junk_id
, t.subject_apo_id = s.subject_apo_id
, t.line_total_undiscounted = s.line_total_undiscounted
, t.order_ship_date = s.order_ship_date
, t.mlt_order_type = s.mlt_order_type
, t.unit_price = s.unit_price
, t.mart_modify_date = sysdate
where t.tax_amt <> s.tax_amt
or t.mlt_multi_payment_id <> s.mlt_multi_payment_id
or t.merch_junk_id <> s.merch_junk_id
or t.charge_amt <> s.charge_amt
or t.ordered_qty <> s.ordered_qty
or t.order_qty <> s.order_qty
or t.line_total  <> s.line_total 
or t.total_amt <> s.total_amt
or t.order_date <> s.order_date
or t.order_bucket <> s.order_bucket
or t.order_channel_id <> s.order_channel_id
or t.assignment_effective_date <> s.assignment_effective_date
or (t.assignment_effective_date is null and s.assignment_effective_date is not null)
or t.assignment_id <> s.assignment_id
or t.job_ticket_org_id <> s.job_ticket_org_id
or t.marketing_id <> s.marketing_id
or t.event_id <> s.event_id
or t.apo_id <> s.apo_id
or t.account_id <> s.account_id
or t.subject_apo_id <> s.subject_apo_id
or (t.subject_apo_id is null and s.subject_apo_id is not null)
or (t.line_total_undiscounted is null and s.line_total_undiscounted is not null)
or t.line_total_undiscounted <> s.line_total_undiscounted
or (t.order_ship_date is null and s.order_ship_date is not null)
or (t.order_ship_date <> s.order_ship_date)
or (t.mlt_order_type is null and s.mlt_order_type is not null)
or (t.mlt_order_type <> s.mlt_order_type)
or (t.unit_price is null and s.unit_price is not null)
or t.unit_price <> s.unit_price
when not matched then
insert
(
 t.merch_fact_id
, t.account_id
, t.apo_id
, t.event_id
, t.marketing_id
, t.job_ticket_org_id
, t.assignment_id
, t.assignment_effective_date
, t.order_channel_id
, t.order_header_oid
, t.order_bucket
, t.order_date
, t.item_id
, t.charge_category
, t.total_amt
, t.line_total
, t.order_qty
, t.ordered_qty
, t.charge_amt
, t.tax_amt
, t.mlt_multi_payment_id
, t.merch_junk_id
, t.subject_apo_id
, t.line_total_undiscounted
, t.order_ship_date
, t.mlt_order_type
, t.unit_price
, t.mart_create_date
, t.mart_modify_date
)
values
(
 MART.merch_fact_id_seq.nextval
, s.account_id
, s.apo_id
, s.event_id
, s.marketing_id
, s.job_ticket_org_id
, s.assignment_id
, s.assignment_effective_date
, s.order_channel_id
, s.order_header_oid
, s.order_bucket
, s.order_date
, s.item_id
, s.charge_category
, s.total_amt
, s.line_total
, s.order_qty
, s.ordered_qty
, s.charge_amt
, s.tax_amt
, s.mlt_multi_payment_id
, s.merch_junk_id
, s.subject_apo_id
, s.line_total_undiscounted
, s.order_ship_date
, s.mlt_order_type
, s.unit_price
, sysdate
, sysdate	
)

&


/*-----------------------------------------------*/
/* TASK No. 34 */
/* drop table tmp_sa */

BEGIN
   EXECUTE IMMEDIATE 'drop table rax_app_user.tmp_sa';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 35 */
/* create table tmp_sa */

create table rax_app_user.tmp_sa
as
select subject_apo_id, subject_apo_oid
from mart.subject_apo
where mart_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap

&


/*-----------------------------------------------*/
/* TASK No. 36 */
/* create index tmp_sa_pk */

create unique index rax_app_user.tmp_sa_pk on tmp_sa(subject_apo_oid)

&


/*-----------------------------------------------*/
/* TASK No. 37 */
/* drop table tmp_sa1 */

BEGIN
   EXECUTE IMMEDIATE 'drop table rax_app_user.tmp_sa1';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 38 */
/* create table tmp_sa1 */

create table rax_app_user.tmp_sa1
as
select oh.order_header_oid, tmp.subject_apo_id, mf.merch_fact_id
from ods_own.subject_apo sa
, ods_own.order_header oh
, ods_own.capture_session cs
, rax_app_user.tmp_sa tmp
, mart.merch_fact mf
where 1=1
and sa.subject_apo_oid = tmp.subject_apo_oid
and sa.apo_oid = oh.apo_oid
and oh.MATCHED_CAPTURE_SESSION_ID = cs.capture_session_key
and cs.subject_oid = sa.subject_oid
and mf.order_header_oid = oh.order_header_oid
and mf.subject_apo_id = '-1'

&


/*-----------------------------------------------*/
/* TASK No. 39 */
/* create index tmp_sa1_pk */

create unique index rax_app_user.tmp_sa1_pk on tmp_sa1(merch_fact_id, subject_apo_id)

&


/*-----------------------------------------------*/
/* TASK No. 40 */
/* merge into mart.merch_fact */

merge into mart.merch_fact t
using (
    select merch_fact_id, subject_apo_id from tmp_sa1
    )s
on (t.merch_fact_id = s.merch_fact_id)
when matched then 
update
set t.subject_apo_id = s.subject_apo_id
, t.mart_modify_date = sysdate

&


/*-----------------------------------------------*/
/* TASK No. 41 */
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
/* TASK No. 42 */
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
,'MERCH_FACT_PKG'
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
'MERCH_FACT_PKG',
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
