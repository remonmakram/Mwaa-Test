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
/* drop table temp_non_did */

-- drop table rax_app_user.temp_non_did

BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.temp_non_did ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 
&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* create table temp_non_did */

create table rax_app_user.temp_non_did
as
select event_oid 
from ods_own.event 
where ods_modify_date >  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
and ship_date is not null




&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* delete from temp_non_did */

delete from rax_app_user.temp_non_did t
where exists (
     select 1 from ods_own.event_auxiliary_dates s
     where s.event_oid = t.event_oid and s.analysis_ship_date is not null
)


&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* create index temp_non_did_pk */

create unique index rax_app_user.temp_non_did_pk on rax_app_user.temp_non_did(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* drop table temp_non_did_dates */

-- drop table rax_app_user.temp_non_did_dates
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.temp_non_did_dates ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 
&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* create table temp_non_did_dates */

create table rax_app_user.temp_non_did_dates
as 
select e.event_oid
    , MIN(sp.ship_date) as non_did_ship_date   
from ods_own.order_line ol
        , ods_own.item i
        , ods_own.order_header oh
        , ods_own.shipment_line sl
        , ods_own.shipment sp
        , rax_app_user.temp_non_did d
        , ods_own.event e
        , ods_own.capture_session cs
        , ods_own.subject s
    where (1=1) 
    and e.event_oid = d.event_oid
    and oh.order_date >= to_date('20140101','YYYYMMDD')  
    and ol.item_oid = i.item_oid
    and ol.order_header_oid = oh.order_header_oid
    and ol.order_line_oid = sl.order_line_oid
    and sl.shipment_oid = sp.shipment_oid
    and substr(sp.status, 1, 4) in ('1400', '1500', '1600')
    --and i.item_id not in ('50047','50048')
    and ( i.fulfillment_type <> 'Digital' or i.fulfillment_type is null)
    and oh.event_ref_id = e.event_ref_id
    and oh.order_bucket in  ('PAID','UNPAID')
    and cs.capture_session_key = oh.matched_capture_session_id  
    and cs.subject_oid = s.subject_oid
    and s.staff_flag = 0
    group by e.event_oid

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* delete from temp_non_did 2 */

delete from rax_app_user.temp_non_did t
where exists (
     select 1 from ods_own.event event, ods_own.apo apo, ods_own.order_header oh
     , ods_own.sub_program sp
     where event.event_oid = t.event_oid
     and t.event_oid = oh.event_oid
     and oh.order_bucket in ('PAID','UNPAID')  
     and event.apo_oid = apo.apo_oid
     and apo.sub_program_oid = sp.sub_program_oid
     and sp.sub_program_name not in
    ('Panoramic Groups'
     ,'Classroom Groups')
)


&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* delete from temp_non_did 3 */

delete from rax_app_user.temp_non_did t
where exists (
     select 1 from rax_app_user.temp_non_did_dates s
     where s.event_oid = t.event_oid
)


&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* insert into temp_non_did_dates */

insert into rax_app_user.temp_non_did_dates
(
  event_oid,
  non_did_ship_date
)
select e.event_oid
    , e.ship_date as non_did_ship_date 
from rax_app_user.temp_non_did d
        , ods_own.event e
     where (1=1) 
    and e.event_oid = d.event_oid
  
   

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* create index temp_non_did_dates_pk */

create unique index rax_app_user.temp_non_did_dates_pk on temp_non_did_dates(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* drop table tmp_event_driver */

-- drop table rax_app_user.tmp_event_driver
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.tmp_event_driver ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* create table tmp_event_driver */

create table rax_app_user.tmp_event_driver
as
select e.event_oid, e.event_ref_id
from ods_own.event e, ods_own.order_header oh
where oh.event_ref_id = e.event_ref_id
and oh.ods_modify_date >  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
group by e.event_oid, e.event_ref_id

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* create index tmp_event_driver_pk */

create unique index rax_app_user.tmp_event_driver_pk on rax_app_user.tmp_event_driver(event_oid, event_ref_id)

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* drop table tmp_event_driver1 */

-- drop table rax_app_user.tmp_event_driver1
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.tmp_event_driver1 ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* create table tmp_event_driver1 */

create table rax_app_user.tmp_event_driver1
as
select event_oid, event_ref_id
from rax_app_user.tmp_event_driver

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* drop tmp_event_driver_batch */

-- drop table rax_app_user.tmp_event_driver_batch
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.tmp_event_driver_batch ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* create table tmp_event_driver_batch */

create table rax_app_user.tmp_event_driver_batch
as
select event_oid, event_ref_id
from rax_app_user.tmp_event_driver

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* delete from tmp_event_driver_batch */

delete from rax_app_user.tmp_event_driver_batch t
where exists (
     select 1 from ods_own.event_auxiliary_dates s
     where s.event_oid = t.event_oid and s.batch_order_ship_date is not null
)


&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* create  index tmp_event_driver_batch_pk */

create unique index rax_app_user.tmp_event_driver_batch_pk on rax_app_user.tmp_event_driver_batch(event_oid, event_ref_id)

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* drop table temp_batch_ship_date */

-- drop table rax_app_user.temp_batch_ship_date
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.temp_batch_ship_date ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* create table temp_batch_ship_date */

create table rax_app_user.temp_batch_ship_date
as
select driver.event_oid, min(oh.order_ship_date) as batch_order_ship_date
from rax_app_user.tmp_event_driver_batch driver
, ods_own.order_header oh
where  oh.event_ref_id = driver.event_ref_id
and oh.order_ship_date is not null
and oh.batch_id is not null
and oh.batch_id <> ' '
and oh.order_bucket in  ('PAID','UNPAID')
group by driver.event_oid

&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* create index temp_batch_ship_date_pk */

create unique index rax_app_user.temp_batch_ship_date_pk on rax_app_user.temp_batch_ship_date(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* delete from tmp_event_driver */

delete from rax_app_user.tmp_event_driver t
where exists (
     select 1 from ods_own.event_auxiliary_dates s
     where s.event_oid = t.event_oid and s.online_order_date is not null
)


&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* drop table temp_online_dates */

-- drop table rax_app_user.temp_online_dates
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.temp_online_dates ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* create table temp_online_dates */

create table rax_app_user.temp_online_dates
as
select driver.event_oid, min(oh.order_date) as online_order_date
from rax_app_user.tmp_event_driver driver
, ods_own.order_header oh
, ods_own.order_channel oc
where  oh.event_ref_id = driver.event_ref_id
and oh.order_channel_oid = oc.order_channel_oid
and oc.channel_name = 'MLT'
and oh.order_bucket in  ('PAID','UNPAID')
group by driver.event_oid

&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* create index temp_online_dates_pk */

create unique index temp_online_dates_pk on temp_online_dates(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* delete from tmp_event_driver1 */

delete from rax_app_user.tmp_event_driver1 t
where exists (
     select 1 from ods_own.event_auxiliary_dates s
     where s.event_oid = t.event_oid and s.paper_form_order_date is not null
)


&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* create index tmp_event_driver1_pk */

create unique index rax_app_user.tmp_event_driver1_pk on rax_app_user.tmp_event_driver1(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 32 */
/* drop table temp_paperform */

-- drop table rax_app_user.temp_paperform
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.temp_paperform ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 33 */
/* create table temp_paperform */

create table rax_app_user.temp_paperform
as
select driver.event_oid, min(oh.order_date) as paper_form_order_date, min(oh.order_ship_date) as paper_order_ship_date
from rax_app_user.tmp_event_driver1 driver
, ods_own.order_header oh
, ods_own.order_channel oc
where  oh.event_ref_id = driver.event_ref_id
and oh.order_bucket in  ('PAID','UNPAID')
and oh.order_channel_oid = oc.order_channel_oid
and oc.channel_name = 'BOC'
group by driver.event_oid

&


/*-----------------------------------------------*/
/* TASK No. 34 */
/* create index temp_paperform_pk */

create unique index rax_app_user.temp_paperform_pk on temp_paperform(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 35 */
/* drop table temp_pos_dates */

-- drop table rax_app_user.temp_pos_dates
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.temp_pos_dates ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 36 */
/* create table temp_pos_dates */

create table rax_app_user.temp_pos_dates
as
select e.event_oid, min(oh.order_ship_date) as proof_ship_date
from ods_own.event e,  ods_own.order_header oh
where  oh.event_ref_id = e.event_ref_id
and oh.order_bucket = 'X'
and oh.ods_modify_date >  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
group by e.event_oid

&


/*-----------------------------------------------*/
/* TASK No. 37 */
/* delete from temp_pos_dates */

delete from rax_app_user.temp_pos_dates t
where exists (
     select 1 from ods_own.event_auxiliary_dates s
     where s.event_oid = t.event_oid and s.proof_ship_date  is not null
)

&


/*-----------------------------------------------*/
/* TASK No. 38 */
/* create index temp_pos_dates_pk */

create unique index rax_app_user.temp_pos_dates_pk on temp_pos_dates(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 39 */
/* drop table tmp_event_driver2 */

-- drop table rax_app_user.tmp_event_driver2
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.tmp_event_driver2 ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 40 */
/* create table tmp_event_driver2 */

create table rax_app_user.tmp_event_driver2
as
select event_oid
from ods_own.event_payment 
where ods_modify_date >  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap and payment_amount > 0
group by event_oid

&


/*-----------------------------------------------*/
/* TASK No. 41 */
/* delete from tmp_event_driver2 */

delete from rax_app_user.tmp_event_driver2 t
where exists (
     select 1 from ods_own.event_auxiliary_dates s
     where s.event_oid = t.event_oid and s.paid_date  is not null
)

&


/*-----------------------------------------------*/
/* TASK No. 42 */
/* create index tmp_event_driver2_pk */

create unique index rax_app_user.tmp_event_driver2_pk on rax_app_user.tmp_event_driver2(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 43 */
/* drop table tmp_paid_date */

-- drop table rax_app_user.tmp_paid_date
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.tmp_paid_date ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 44 */
/* create table tmp_paid_date */

create table rax_app_user.tmp_paid_date
as
select min(ep.payment_date) as paid_date, ep.event_oid
from ods_own.event_payment ep
,rax_app_user.tmp_event_driver2 s
where ep.event_oid = s.event_oid
and ep.payment_amount > 0
group by ep.event_oid

&


/*-----------------------------------------------*/
/* TASK No. 45 */
/* create index tmp_paid_date_pk */

create unique index rax_app_user.tmp_paid_date_pk on tmp_paid_date(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 46 */
/* drop table gdt_event_driver */

-- drop table rax_app_user.gdt_event_driver
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.gdt_event_driver ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 47 */
/* create table gdt_event_driver */

create table rax_app_user.gdt_event_driver
as
select e.event_oid 
from ods_own.event e
where e.school_year > 2017
and e.apo_oid is null
union
select e.event_oid
from ods_own.event e, ods_own.apo apo
where e.apo_oid = apo.apo_oid
and apo.financial_processing_system not in ('Spectrum', 'OtherSRM')
and e.school_year > 2017


&


/*-----------------------------------------------*/
/* TASK No. 48 */
/* delete from gdt_event_driver */

delete from rax_app_user.gdt_event_driver t
where exists (
     select 1 from ods_own.event_auxiliary_dates s
     where s.event_oid = t.event_oid and s.paid_date  is not null
)

&


/*-----------------------------------------------*/
/* TASK No. 49 */
/* delete from gdt_event_driver_1 */

delete from rax_app_user.gdt_event_driver t
where exists (
    select 1 from rax_app_user.tmp_paid_date s
    where s.event_oid = t.event_oid	
)

&


/*-----------------------------------------------*/
/* TASK No. 50 */
/* create index gdt_event_driver_pk */

create unique index gdt_event_driver_pk on gdt_event_driver(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 51 */
/* insert into ods_app_user.tmp_paid_date */

insert into rax_app_user.tmp_paid_date
(
    paid_date, event_oid
)
select min(esf.trans_date), s.event_oid
from mart.event_sales_fact esf
, (select e.event_oid, f.event_id from mart.event_sales_fact f, rax_app_user.gdt_event_driver driver, 
   mart.event me, ods_own.event e
   where e.event_oid = driver.event_oid and f.trans_date > ( TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -2) and f.ship_date <> to_date('19000101', 'YYYYMMDD') 
and f.transaction_amt > 0 and f.event_id = me.event_id and me.job_nbr = e.event_ref_id
group by e.event_oid, f.event_id
  ) s
where esf.event_id = s.event_id
and esf.ship_date <> to_date('19000101', 'YYYYMMDD') 
and esf.transaction_amt > 0
group by s.event_oid



&


/*-----------------------------------------------*/
/* TASK No. 52 */
/* drop table tmp_event_driver3 */

-- drop table rax_app_user.tmp_event_driver3
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.tmp_event_driver3 ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 53 */
/* create table tmp_event_driver3 */

create table rax_app_user.tmp_event_driver3
as
select event_oid 
from ods_own.capture_session 
   where ods_modify_date >  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap  
  group by event_oid

&


/*-----------------------------------------------*/
/* TASK No. 54 */
/* delete from tmp_event_driver3 */

delete from rax_app_user.tmp_event_driver3 t
where exists (
     select 1 from ods_own.event_auxiliary_dates s
     where s.event_oid = t.event_oid and s.capture_session_date  is not null
)

&


/*-----------------------------------------------*/
/* TASK No. 55 */
/* create index tmp_event_driver3_pk */

create unique index rax_app_user.tmp_event_driver3_pk on rax_app_user.tmp_event_driver3(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 56 */
/* drop table tmp_cs_date */

-- drop table rax_app_user.tmp_cs_date
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.tmp_cs_date ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 57 */
/* create table tmp_cs_date */

create table rax_app_user.tmp_cs_date
as
select min(cs.ods_create_date) as capture_session_date, cs.event_oid
from ods_own.capture_session cs
, tmp_event_driver3 s
where cs.event_oid = s.event_oid
group by cs.event_oid

&


/*-----------------------------------------------*/
/* TASK No. 58 */
/* create index tmp_cs_date_pk */

create unique index rax_app_user.tmp_cs_date_pk on tmp_cs_date(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 59 */
/* drop tmp_event_driver4 */

-- drop table rax_app_user.tmp_event_driver4
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.tmp_event_driver4 ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 60 */
/* create tmp_event_driver4 */

create table rax_app_user.tmp_event_driver4
as
select ep.event_oid 
from ods_own.event_payment ep, ods_own.payment_type pt
where  ep.ods_modify_date >  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
and ep.payment_type_oid = pt.payment_type_oid
and pt.payment_type = 'Check'
group by event_oid



&


/*-----------------------------------------------*/
/* TASK No. 61 */
/* delete from tmp_event_driver4 */

delete from rax_app_user.tmp_event_driver4 t
where exists (
     select 1 from ods_own.event_auxiliary_dates s
     where s.event_oid = t.event_oid and s.check_payment_date is not null
)


&


/*-----------------------------------------------*/
/* TASK No. 62 */
/* create index tmp_event_driver4_pk */

create unique index rax_app_user.tmp_event_driver4_pk on rax_app_user.tmp_event_driver4(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 63 */
/* drop table check_date */

-- drop table rax_app_user.check_date
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.check_date ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 64 */
/* create table check_date */

create table rax_app_user.check_date
as
select min(ep.payment_date) as check_payment_date, ep.event_oid
from ods_own.event_payment ep
, tmp_event_driver4 s
, ods_own.payment_type pt
where ep.event_oid = s.event_oid
and ep.payment_type_oid = pt.payment_type_oid
and pt.payment_type = 'Check'
group by ep.event_oid

&


/*-----------------------------------------------*/
/* TASK No. 65 */
/* create index check_date_pk */

create unique index rax_app_user.check_date_pk on check_date(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 66 */
/* drop tmp_event_driver5 */

-- drop table rax_app_user.tmp_event_driver5
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.tmp_event_driver5 ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 67 */
/* create tmp_event_driver5 */

create table rax_app_user.tmp_event_driver5
as
select ep.event_oid 
from ods_own.event_payment ep, ods_own.payment_type pt
where  ep.ods_modify_date >  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
and ep.payment_type_oid = pt.payment_type_oid
and pt.payment_type = 'Cash'
group by event_oid

&


/*-----------------------------------------------*/
/* TASK No. 68 */
/* delete from tmp_event_driver5 */

delete from rax_app_user.tmp_event_driver5 t
where exists (
     select 1 from ods_own.event_auxiliary_dates s
     where s.event_oid = t.event_oid and s.cash_payment_date is not null
)


&


/*-----------------------------------------------*/
/* TASK No. 69 */
/* create index tmp_event_driver5_pk */

create unique index rax_app_user.tmp_event_driver5_pk on rax_app_user.tmp_event_driver5(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 70 */
/* drop table cash_date */

-- drop table rax_app_user.cash_date
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.cash_date ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 71 */
/* create table cash_date */

create table rax_app_user.cash_date
as
select min(ep.payment_date) as cash_payment_date, ep.event_oid
from ods_own.event_payment ep
, tmp_event_driver5 s
, ods_own.payment_type pt
where ep.event_oid = s.event_oid
and ep.payment_type_oid = pt.payment_type_oid
and pt.payment_type = 'Cash'
group by ep.event_oid

&


/*-----------------------------------------------*/
/* TASK No. 72 */
/* create index cash_date_pk */

create unique index rax_app_user.cash_date_pk on cash_date(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 73 */
/* drop tmp_event_driver6 */

-- drop table rax_app_user.tmp_event_driver6
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.tmp_event_driver6 ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 74 */
/* create tmp_event_driver6 */

create table rax_app_user.tmp_event_driver6
as 
select e.event_oid, e.event_ref_id
from ods_own.event e, ods_own.order_header oh
where oh.event_ref_id = e.event_ref_id
and oh.order_type = 'FRN_Order'
and oh.ods_modify_date >  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
group by e.event_oid, e.event_ref_id

&


/*-----------------------------------------------*/
/* TASK No. 75 */
/* delete from tmp_event_driver6 */

delete from rax_app_user.tmp_event_driver6 t
where exists (
     select 1 from ods_own.event_auxiliary_dates s
     where s.event_oid = t.event_oid and s.gfrn_order_date is not null
)


&


/*-----------------------------------------------*/
/* TASK No. 76 */
/* create index tmp_event_driver6_pk */

create unique index rax_app_user.tmp_event_driver6_pk on rax_app_user.tmp_event_driver6(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 77 */
/* drop table gfrn_order_date */

-- drop table rax_app_user.gfrn_order_date
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.gfrn_order_date ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 78 */
/* create table gfrn_order_date */

create table gfrn_order_date
as
select driver.event_oid, min(oh.order_date) as gfrn_order_date
from rax_app_user.tmp_event_driver6 driver
, ods_own.order_header oh
where  oh.event_ref_id = driver.event_ref_id
and oh.order_type = 'FRN_Order'
group by driver.event_oid

&


/*-----------------------------------------------*/
/* TASK No. 79 */
/* create index gfrn_order_date_pk */

create unique index rax_app_user.gfrn_order_date_pk on gfrn_order_date(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 80 */
/* drop tmp_event_driver7 */

-- drop table rax_app_user.tmp_event_driver7
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.tmp_event_driver7 ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 81 */
/* create tmp_event_driver7 */

create table rax_app_user.tmp_event_driver7
as 
select e.event_oid, e.event_ref_id
from ods_own.event e, ods_own.order_header oh
where oh.event_ref_id = e.event_ref_id
and oh.order_type = 'pFRN_Order'
and oh.ods_modify_date >  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
group by e.event_oid, e.event_ref_id

&


/*-----------------------------------------------*/
/* TASK No. 82 */
/* delete from tmp_event_driver7 */

delete from rax_app_user.tmp_event_driver7 t
where exists (
     select 1 from ods_own.event_auxiliary_dates s
     where s.event_oid = t.event_oid and s.pfrn_order_date is not null
)


&


/*-----------------------------------------------*/
/* TASK No. 83 */
/* create index tmp_event_driver7_pk */

create unique index rax_app_user.tmp_event_driver7_pk on rax_app_user.tmp_event_driver7(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 84 */
/* drop pfrn_order_date */

-- drop table rax_app_user.pfrn_order_date
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.pfrn_order_date ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 85 */
/* create pfrn_order_date */

create table rax_app_user.pfrn_order_date
as
select driver.event_oid, min(oh.order_date) as pfrn_order_date
from rax_app_user.tmp_event_driver7 driver
, ods_own.order_header oh
where  oh.event_ref_id = driver.event_ref_id
and oh.order_type = 'pFRN_Order'
group by driver.event_oid

&


/*-----------------------------------------------*/
/* TASK No. 86 */
/* create index pfrn_order_date_pk */

create unique index rax_app_user.pfrn_order_date_pk on pfrn_order_date(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 87 */
/* drop tmp_event_driver8 */

-- drop table rax_app_user.tmp_event_driver8
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.tmp_event_driver8 ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 88 */
/* create tmp_event_driver8 */

create table rax_app_user.tmp_event_driver8
as 
select d.event_oid, d.event_ref_id
from tmp_event_driver d, ods_own.order_header oh
where oh.event_ref_id = d.event_ref_id
and oh.order_type = 'PDK_Order'
and oh.ods_modify_date >  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
group by d.event_oid, d.event_ref_id

&


/*-----------------------------------------------*/
/* TASK No. 89 */
/* delete from tmp_event_driver8 */

delete from rax_app_user.tmp_event_driver8 t
where exists (
     select 1 from ods_own.event_auxiliary_dates s
     where s.event_oid = t.event_oid and s.flyer_order_date is not null
)


&


/*-----------------------------------------------*/
/* TASK No. 90 */
/* create index tmp_event_driver8_pk */

create unique index rax_app_user.tmp_event_driver8_pk on rax_app_user.tmp_event_driver8(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 91 */
/* drop flyer_order_date */

-- drop table rax_app_user.flyer_order_date
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.flyer_order_date ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 92 */
/* create flyer_order_date */

create table rax_app_user.flyer_order_date
as
select driver.event_oid, min(oh.order_date) as flyer_order_date
from rax_app_user.tmp_event_driver8 driver
, ods_own.order_header oh
where  oh.event_ref_id = driver.event_ref_id
and oh.order_type = 'PDK_Order'
group by driver.event_oid

&


/*-----------------------------------------------*/
/* TASK No. 93 */
/* create index flyer_order_date_pk */

create unique index rax_app_user.flyer_order_date_pk on flyer_order_date(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 94 */
/* drop tmp_event_driver9 */

-- drop table rax_app_user.tmp_event_driver9
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.tmp_event_driver9 ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 95 */
/* create tmp_event_driver9 */

create table rax_app_user.tmp_event_driver9
as 
select d.event_oid, d.event_ref_id
from tmp_event_driver d, ods_own.order_header oh
where oh.event_ref_id = d.event_ref_id
and oh.order_type = 'PDK_Order'
and oh.order_ship_date is not null
and oh.ods_modify_date >  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
group by d.event_oid, d.event_ref_id

&


/*-----------------------------------------------*/
/* TASK No. 96 */
/* delete from tmp_event_driver9 */

delete from rax_app_user.tmp_event_driver9 t
where exists (
     select 1 from ods_own.event_auxiliary_dates s
     where s.event_oid = t.event_oid and s.flyer_ship_date is not null
)


&


/*-----------------------------------------------*/
/* TASK No. 97 */
/* create index tmp_event_driver9_pk */

create unique index rax_app_user.tmp_event_driver9_pk on rax_app_user.tmp_event_driver9(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 98 */
/* drop flyer_ship_date */

-- drop table rax_app_user.flyer_ship_date
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.flyer_ship_date ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 99 */
/* create flyer_ship_date */

create table rax_app_user.flyer_ship_date
as
select driver.event_oid, min(oh.order_ship_date) as flyer_ship_date
from rax_app_user.tmp_event_driver9 driver
, ods_own.order_header oh
where  oh.event_ref_id = driver.event_ref_id
and oh.order_type = 'PDK_Order'
group by driver.event_oid

&


/*-----------------------------------------------*/
/* TASK No. 100 */
/* create index flyer_ship_date_pk */

create unique index rax_app_user.flyer_ship_date_pk on flyer_ship_date(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 101 */
/* drop table temp_events */

-- drop table rax_app_user.temp_events
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.temp_events ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 102 */
/* create table temp_events */

create table rax_app_user.temp_events
as
select event_oid
from rax_app_user.temp_non_did_dates did
union
select event_oid
from rax_app_user.temp_online_dates
union
select event_oid
from rax_app_user.temp_paperform
union
select event_oid
from rax_app_user.temp_pos_dates
union
select event_oid
from rax_app_user.tmp_paid_date
union
select event_oid
from rax_app_user.tmp_cs_date
union
select event_oid
from rax_app_user.check_date
union
select event_oid
from rax_app_user.cash_date
union
select event_oid
from rax_app_user.gfrn_order_date
union
select event_oid
from rax_app_user.pfrn_order_date
union
select event_oid
from rax_app_user.flyer_order_date
union
select event_oid
from rax_app_user.flyer_ship_date

&


/*-----------------------------------------------*/
/* TASK No. 103 */
/* create index temp_events_pk */

create unique index rax_app_user.temp_events_pk on temp_events(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 104 */
/* drop table temp_ead */

-- drop table rax_app_user.temp_ead
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.temp_ead ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 105 */
/* create table temp_ead */

create table rax_app_user.temp_ead
as
select e.event_oid, dd.non_did_ship_date as analysis_ship_date
, pd.paid_date, cd.capture_session_date, pos.proof_ship_date
, od.online_order_date, pf.paper_form_order_date, pf.paper_order_ship_date
, chd.check_payment_date, cad.cash_payment_date
, gfrn.gfrn_order_date, pfrn.pfrn_order_date
, fod.flyer_order_date, fsd.flyer_ship_date
, event.event_ref_id
, bsd.batch_order_ship_date
from rax_app_user.temp_events e
, rax_app_user.temp_non_did_dates dd
, rax_app_user.tmp_paid_date pd
, rax_app_user.tmp_cs_date cd
, rax_app_user.temp_pos_dates pos
, rax_app_user.temp_online_dates od
, rax_app_user.temp_paperform pf
, rax_app_user.check_date chd
, rax_app_user.cash_date cad
, rax_app_user.gfrn_order_date gfrn
, rax_app_user.pfrn_order_date pfrn
, rax_app_user.flyer_order_date fod
, rax_app_user.flyer_ship_date fsd
, ods_own.event event
, rax_app_user.temp_batch_ship_date bsd
where e.event_oid = dd.event_oid(+)
and e.event_oid = pd.event_oid(+)
and e.event_oid = cd.event_oid(+)
and e.event_oid = pos.event_oid(+)
and e.event_oid = od.event_oid(+)
and e.event_oid = pf.event_oid(+)
and e.event_oid = chd.event_oid(+)
and e.event_oid = cad.event_oid(+)
and e.event_oid = gfrn.event_oid(+)
and e.event_oid = pfrn.event_oid(+)
and e.event_oid = fod.event_oid(+)
and e.event_oid = fsd.event_oid(+)
and e.event_oid = bsd.event_oid(+)
and e.event_oid = event.event_oid

&


/*-----------------------------------------------*/
/* TASK No. 106 */
/* create index temp_ead_pk */

create unique index rax_app_user.temp_ead_pk on temp_ead(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 107 */
/* merge into ods_own.event_auxiliary_dates */

merge into ods_own.event_auxiliary_dates t
using 
(
  select event_oid, analysis_ship_date, paid_date, capture_session_date, proof_ship_date
, online_order_date, paper_form_order_date, event_ref_id, check_payment_date
, cash_payment_date, gfrn_order_date, pfrn_order_date, flyer_order_date, flyer_ship_date
, paper_order_ship_date, batch_order_ship_date
  from rax_app_user.temp_ead
)s
on (t.event_oid = s.event_oid)
when matched then update
set t.analysis_ship_date = nvl(t.analysis_ship_date, s.analysis_ship_date)
, t.paid_date = nvl(t.paid_date, s.paid_date)
, t.capture_session_date = nvl(t.capture_session_date, s.capture_session_date)
, t.proof_ship_date = nvl(t.proof_ship_date, s.proof_ship_date)
, t.online_order_date = nvl(t.online_order_date, s.online_order_date)
, t.paper_form_order_date = nvl(t.paper_form_order_date, s.paper_form_order_date)
, t.check_payment_date = nvl(t.check_payment_date, s.check_payment_date)
, t.cash_payment_date = nvl(t.cash_payment_date, s.cash_payment_date)
, t.gfrn_order_date = nvl(t.gfrn_order_date, s.gfrn_order_date)
, t.pfrn_order_date = nvl(t.pfrn_order_date, s.pfrn_order_date)
, t.flyer_order_date = nvl(t.flyer_order_date, s.flyer_order_date)
, t.flyer_ship_date = nvl(t.flyer_ship_date, s.flyer_ship_date)
, t.paper_order_ship_date = nvl(t.paper_order_ship_date, s.paper_order_ship_date)
, t.batch_order_ship_date = nvl(t.batch_order_ship_date, s.batch_order_ship_date)
, t.ods_modify_date = sysdate
when not matched then insert
(
  t.event_oid
, t.analysis_ship_date
, t.paid_date
, t.capture_session_date
, t.proof_ship_date
, t.online_order_date
, t.paper_form_order_date
, t.check_payment_date
, t.cash_payment_date
, t.gfrn_order_date
, t.pfrn_order_date
, t.flyer_order_date
, t.flyer_ship_date
, t.event_ref_id
, t.ods_create_date
, t.ods_modify_date
, t.paper_order_ship_date
, t.batch_order_ship_date
)
values
(
  s.event_oid
, s.analysis_ship_date
, s.paid_date
, s.capture_session_date
, s.proof_ship_date
, s.online_order_date
, s.paper_form_order_date
, s.check_payment_date
, s.cash_payment_date
, s.gfrn_order_date
, s.pfrn_order_date
, s.flyer_order_date
, s.flyer_ship_date
, s.event_ref_id
, sysdate
, sysdate
, s.paper_order_ship_date
, s.batch_order_ship_date
)

&


/*-----------------------------------------------*/
/* TASK No. 108 */
/* drop tmp_event */

-- drop table rax_app_user.tmp_event
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.tmp_event ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 109 */
/* create table tmp_event */

create table rax_app_user.tmp_event
as
select event_oid
from ods_own.event_payment 
where ods_modify_date >  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap and payment_amount > 0
group by event_oid


&


/*-----------------------------------------------*/
/* TASK No. 110 */
/* create index tmp_event_pk */

create unique index rax_app_user.tmp_event_pk on rax_app_user.tmp_event(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 111 */
/* drop table tmp_event1 */

-- drop table rax_app_user.tmp_event1
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.tmp_event1 ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 112 */
/* create table tmp_event1 */

create table rax_app_user.tmp_event1
as
select tmp.event_oid, sum(ep.payment_amount) as total_amount
from rax_app_user.tmp_event tmp, ods_own.event_payment ep
where tmp.event_oid = ep.event_oid
group by tmp.event_oid

&


/*-----------------------------------------------*/
/* TASK No. 113 */
/* create index ods_app_user.tmp_event1_pk */

create unique index rax_app_user.tmp_event1_pk on rax_app_user.tmp_event1(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 114 */
/* drop table tmp_event2 */

-- drop table rax_app_user.tmp_event2
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.tmp_event2 ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 115 */
/* create table tmp_event2 */

create table rax_app_user.tmp_event2
as
select event_oid
from rax_app_user.tmp_event1
where total_amount = 0

&


/*-----------------------------------------------*/
/* TASK No. 116 */
/* create index tmp_event2_pk */

create unique index rax_app_user.tmp_event2_pk on rax_app_user.tmp_event2(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 117 */
/* merge into event_auxiliary_dates */

merge into ods_own.event_auxiliary_dates t
using (
  select event_oid from rax_app_user.tmp_event2
)s
on (t.event_oid = s.event_oid)
when matched then update
set t.paid_date = null
, t.ods_modify_date = sysdate
where t.paid_date is not null

&


/*-----------------------------------------------*/
/* TASK No. 118 */
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
/* TASK No. 119 */
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
,'LOAD_EVENT_AUXILIARY_DATES_PKG'
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
'LOAD_EVENT_AUXILIARY_DATES_PKG',
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
