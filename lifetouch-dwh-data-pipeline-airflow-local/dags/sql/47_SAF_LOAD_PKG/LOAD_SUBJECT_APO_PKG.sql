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
/* drop d1 */

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_subject_apo_d1';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  


&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* create d1 */

create table RAX_APP_USER.tmp_subject_apo_d1 as
select distinct apo.apo_oid
, s.subject_oid
from ODS_OWN.capture_session cs
, ODS_OWN.subject s
, ODS_OWN.event e
, ODS_OWN.apo
where 1=1
and cs.subject_oid = s.subject_oid
and cs.event_oid = e.event_oid
and e.apo_oid = apo.apo_oid
and cs.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* drop d2 */

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_subject_apo_d2';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  


&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* create d2 */

create table RAX_APP_USER.tmp_subject_apo_d2 as
select distinct apo.apo_oid
, s.subject_oid
from ODS_OWN.capture_session cs
, ODS_OWN.subject s
, ODS_OWN.event e
, ODS_OWN.apo
where 1=1
and cs.subject_oid = s.subject_oid
and cs.event_oid = e.event_oid
and e.apo_oid = apo.apo_oid
and s.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* drop d3 */

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_subject_apo_d3';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  


&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* create d3 */

create table RAX_APP_USER.tmp_subject_apo_d3 as
select distinct apo.apo_oid
, s.subject_oid
from ODS_OWN.capture_session cs
, ODS_OWN.subject s
, ODS_OWN.event e
, ODS_OWN.apo
, ODS_OWN.order_header oh
where 1=1
and cs.subject_oid = s.subject_oid
and cs.capture_session_key = oh.matched_capture_session_id
and oh.event_oid = e.event_oid
and e.apo_oid = apo.apo_oid
and oh.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* driop d4 */


BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_subject_apo_d4';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* create d4 */

create table RAX_APP_USER.tmp_subject_apo_d4 as
select distinct apo.apo_oid
, s.subject_oid
from ODS_OWN.capture_session cs
, ODS_OWN.subject s
, ODS_OWN.event e
, ODS_OWN.apo
, ODS_OWN.order_header oh
, ODS_OWN.order_line ol
where 1=1
and cs.subject_oid = s.subject_oid
and cs.capture_session_key = oh.matched_capture_session_id
and oh.event_oid = e.event_oid
and e.apo_oid = apo.apo_oid
and oh.order_header_oid = ol.order_header_oid
and ol.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* drop d5 */



BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_subject_apo_d5';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  
&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* create d5 */

create table RAX_APP_USER.tmp_subject_apo_d5 as
select distinct apo.apo_oid
, s.subject_oid
from ODS_OWN.capture_session cs
, ODS_OWN.image i
, ODS_OWN.subject_image si
, ODS_OWN.subject s
, ODS_OWN.event e
, ODS_OWN.apo
where 1=1
and cs.capture_session_oid = i.capture_session_oid
and i.image_oid = si.image_image_oid
and si.subject_subject_oid = s.subject_oid
and cs.event_oid = e.event_oid
and e.apo_oid = apo.apo_oid
and si.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
and si.ods_create_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* drop driver */

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_subject_apo_driver';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  
&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* create driver */

create table RAX_APP_USER.tmp_subject_apo_driver as
select subject_oid
, apo_oid
from RAX_APP_USER.tmp_subject_apo_d1
union
select subject_oid
, apo_oid
from RAX_APP_USER.tmp_subject_apo_d2
union
select subject_oid
, apo_oid
from RAX_APP_USER.tmp_subject_apo_d3
union
select subject_oid
, apo_oid
from RAX_APP_USER.tmp_subject_apo_d4
union
select subject_oid
, apo_oid
from RAX_APP_USER.tmp_subject_apo_d5

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* delete some sub programs from driver */

delete from RAX_APP_USER.tmp_subject_apo_driver d
where exists
(
select 1
from ODS_OWN.apo
, ODS_OWN.sub_program sp
, ODS_OWN.program p
where d.apo_oid = apo.apo_oid
and apo.sub_program_oid = sp.sub_program_oid
and sp.program_oid = p.program_oid
and program_name in
('Unknown'
,'Senior/Studio Style'
)
)

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* index driver */

create unique index RAX_APP_USER.tmp_subject_apo_driver_pk on RAX_APP_USER.tmp_subject_apo_driver(subject_oid, apo_oid)

&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* drop sapo1 */

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_subject_apo1';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 
&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* create sapo1 */

create table RAX_APP_USER.tmp_subject_apo1 as
select apo.apo_oid
, s.subject_oid
, sum(case when (   e.event_type = 'SERVICEONLY' 
                 or e.rollover_job_ind = 'X' 
                 or apo.description like '%ROLLOVER%' 
                 or i.subjects_type = 'GROUP' 
                 or SP.SUB_PROGRAM_NAME = 'Service Non Rev' 
                 or ss.source_system_short_name = 'ODS'
                 or (iss.source_system_short_name = 'SM' and trim(i.lti_image_url) is null) -- SODS-1741
                ) then 0 
                  else 1 end) as image_qty
, min(case when (   e.event_type = 'SERVICEONLY' 
                 or e.rollover_job_ind = 'X' 
                 or apo.description like '%ROLLOVER%' 
                 or i.subjects_type = 'GROUP' 
                 or SP.SUB_PROGRAM_NAME = 'Service Non Rev' 
                 or ss.source_system_short_name = 'ODS'
                 or (iss.source_system_short_name = 'SM' and trim(i.lti_image_url) is null) -- SODS-1741
                ) then null 
                  else e.photography_date end) as photography_date
, count(distinct (case when (   e.event_type = 'SERVICEONLY' 
                             or e.rollover_job_ind = 'X' 
                             or apo.description like '%ROLLOVER%' 
                             or i.subjects_type = 'GROUP' 
                             or SP.SUB_PROGRAM_NAME = 'Service Non Rev' 
                             or ss.source_system_short_name = 'ODS'
                             or (iss.source_system_short_name = 'SM' and trim(i.lti_image_url) is null) -- SODS-1741
                            ) then null 
                              else cs.capture_session_oid end)) as capture_session_qty
, count(distinct (case when (   e.event_type = 'SERVICEONLY' 
                             or e.rollover_job_ind = 'X' 
                             or apo.description like '%ROLLOVER%' 
                             or i.subjects_type = 'GROUP' 
                             or SP.SUB_PROGRAM_NAME = 'Service Non Rev' 
                             or ss.source_system_short_name = 'ODS'
                             or (iss.source_system_short_name = 'SM' and trim(i.lti_image_url) is null) -- SODS-1741
                            ) then null 
                              else e.event_oid end)) as event_qty
from RAX_APP_USER.tmp_subject_apo_driver d
, ODS_OWN.capture_session cs
, ODS_OWN.image i
, ODS_OWN.subject_image si
, ODS_OWN.subject s
, ODS_OWN.event e
, ODS_OWN.apo
, ODS_OWN.source_system ss
, ODS_OWN.booking_opportunity bo
, ODS_OWN.sub_program sp
, ODS_OWN.source_system iss -- SODS-1741
where 1=1
and cs.capture_session_oid = i.capture_session_oid
and i.image_oid = si.image_image_oid
and si.subject_subject_oid = s.subject_oid
and cs.event_oid = e.event_oid
and e.apo_oid = apo.apo_oid
and apo.apo_oid = d.apo_oid
and apo.source_system_oid = ss.source_system_oid
and s.subject_oid = d.subject_oid
and APO.BOOKING_OPP_OID = BO.BOOKING_OPPORTUNITY_OID(+)
and BO.SUB_PROGRAM_OID = SP.SUB_PROGRAM_OID(+)
and i.source_system_oid = iss.source_system_oid -- SODS-174
group by apo.apo_oid
, s.subject_oid

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* indesx sapo1 */

create unique index RAX_APP_USER.tmp_subject_apo1_pk on RAX_APP_USER.tmp_subject_apo1(subject_oid, apo_oid)

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* drop sapo2 */


BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_subject_apo2';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 
&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* create sapo2 */

create table RAX_APP_USER.tmp_subject_apo2 as
select s1.apo_oid
, s1.subject_oid
, min(oh.order_date) as order_date
, count(distinct oc.channel_name) as channel_qty
, max(case when oh.order_bucket = 'PAID' then 'Y' else 'N' end) as paid_order_ind
, max(case when oh.order_type = 'Staff_Order' then 1 else 0 end) as package_qty
, count(*) as order_qty
, sum(case when oh.order_bucket = 'PAID' then 1 else 0 end) as paid_order_qty
, sum(oh.total_amount) as price_amount
from RAX_APP_USER.tmp_subject_apo1 s1
, ODS_OWN.capture_session cs
, ODS_OWN.subject s
, ODS_OWN.event e
, ODS_OWN.order_header oh
, ODS_OWN.order_channel oc
where 1=1
and s1.subject_oid = s.subject_oid
and cs.subject_oid = s.subject_oid
and cs.capture_session_key = oh.matched_capture_session_id
and oh.event_oid = e.event_oid
and s1.apo_oid = e.apo_oid
and oh.order_bucket in ('PAID','UNPAID')
and oh.order_channel_oid = oc.order_channel_oid
group by s1.apo_oid
, s1.subject_oid

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* index sapo2 */

create unique index RAX_APP_USER.tmp_subject_apo2_pk on RAX_APP_USER.tmp_subject_apo2(subject_oid, apo_oid)

&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* drop sapo3 */


BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_subject_apo3';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 
&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* create sapo3 */

create table RAX_APP_USER.tmp_subject_apo3 as
select s1.apo_oid
, s1.subject_oid
, s1.image_qty
, s1.photography_date
, cast(null as date) as second_photography_date
, s1.capture_session_qty
, s1.event_qty
, s2.order_date
, cast(null as date) as second_order_date
, s2.paid_order_ind
, nvl(s2.channel_qty,0) as channel_qty
, nvl(s2.order_qty,0) as order_qty
, cast('N' as char(1)) as complimentary_retake_ind
, cast('N' as char(1)) as pos_buyer_ind
, cast('N' as char(1)) as pos_ind
, nvl(s2.package_qty,0) as package_qty
, cast(0 as number) as sheet_qty
, cast(0 as number) as ordered_recipe_qty
, nvl(s2.paid_order_qty, 0) as paid_order_qty
, nvl(s2.price_amount, 0) as price_amount , cast('N' as char(1)) as digital_buyer_ind
from RAX_APP_USER.tmp_subject_apo1 s1
, RAX_APP_USER.tmp_subject_apo2 s2
where s1.apo_oid = s2.apo_oid(+)
and s1.subject_oid = s2.subject_oid(+)

&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* index sapo3 */

create unique index RAX_APP_USER.tmp_subject_apo3_pk on RAX_APP_USER.tmp_subject_apo3(subject_oid, apo_oid)

&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* drop sapo4 */


BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_subject_apo4';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 
&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* create sapo4 */

create table RAX_APP_USER.tmp_subject_apo4 as
select s3.apo_oid
, s3.subject_oid
, min(oh.order_date) as second_order_date
from RAX_APP_USER.tmp_subject_apo3 s3
, ODS_OWN.order_header oh
, ODS_OWN.capture_session cs
, ODS_OWN.event e
where 1=1
and s3.subject_oid = cs.subject_oid
and cs.capture_session_key = oh.matched_capture_session_id
and oh.event_oid = e.event_oid
and s3.apo_oid = e.apo_oid
and oh.order_bucket in ('PAID','UNPAID')
and oh.order_date > s3.order_date
group by s3.apo_oid
, s3.subject_oid

&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* index sapo4 */

create unique index RAX_APP_USER.tmp_subject_apo4_pk on RAX_APP_USER.tmp_subject_apo4(subject_oid, apo_oid)

&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* update sapo3 from sapo4 */

update
(
select s3.second_order_date as target_order_date
, s4.second_order_date as source_order_date
from RAX_APP_USER.tmp_subject_apo3 s3
, RAX_APP_USER.tmp_subject_apo4 s4
where s3.subject_oid = s4.subject_oid
and s3.apo_oid = s4.apo_oid
)
set target_order_date = source_order_date

&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* drop sapo5 */


BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_subject_apo5';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 
&


/*-----------------------------------------------*/
/* TASK No. 32 */
/* create sapo5 */

create table RAX_APP_USER.tmp_subject_apo5 as
select s3.apo_oid
, s3.subject_oid
, min(e.photography_date) as second_photography_date
from RAX_APP_USER.tmp_subject_apo3 s3
, ODS_OWN.capture_session cs
, ODS_OWN.event e
where 1=1
and s3.subject_oid = cs.subject_oid
and cs.event_oid = e.event_oid
and s3.apo_oid = e.apo_oid
and e.photography_date > s3.photography_date
group by s3.apo_oid
, s3.subject_oid

&


/*-----------------------------------------------*/
/* TASK No. 33 */
/* index sapo5 */

create unique index RAX_APP_USER.tmp_subject_apo5_pk on RAX_APP_USER.tmp_subject_apo5(subject_oid, apo_oid)

&


/*-----------------------------------------------*/
/* TASK No. 34 */
/* update sapo3 from sapo5 */

update
(
select s3.second_photography_date as target_photography_date
, s5.second_photography_date as source_photography_date
from RAX_APP_USER.tmp_subject_apo3 s3
, RAX_APP_USER.tmp_subject_apo5 s5
where s3.subject_oid = s5.subject_oid
and s3.apo_oid = s5.apo_oid
)
set target_photography_date = source_photography_date

&


/*-----------------------------------------------*/
/* TASK No. 35 */
/* drop sapo6 */


BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_subject_apo6';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 
&


/*-----------------------------------------------*/
/* TASK No. 36 */
/* create sapo6 */

create table RAX_APP_USER.tmp_subject_apo6 as
select s3.apo_oid
, s3.subject_oid
, min('Y') as complimentary_retake_ind
from RAX_APP_USER.tmp_subject_apo3 s3
, ODS_OWN.order_header oh
, ODS_OWN.capture_session cs
, ODS_OWN.event e
where 1=1
and s3.subject_oid = cs.subject_oid
and cs.capture_session_key = oh.matched_capture_session_id
and oh.event_oid = e.event_oid
and s3.apo_oid = e.apo_oid
and s3.second_order_date is not null
and oh.order_bucket in ('UNPAID')
and oh.order_date > s3.order_date
group by s3.apo_oid
, s3.subject_oid

&


/*-----------------------------------------------*/
/* TASK No. 37 */
/* index sapo6 */

create unique index RAX_APP_USER.tmp_subject_apo6_pk on RAX_APP_USER.tmp_subject_apo6(subject_oid, apo_oid)

&


/*-----------------------------------------------*/
/* TASK No. 38 */
/* update sapo3 from sapo6 */

update
(
select s3.complimentary_retake_ind as target_retake_ind
, s6.complimentary_retake_ind as source_retake_ind
from RAX_APP_USER.tmp_subject_apo3 s3
, RAX_APP_USER.tmp_subject_apo6 s6
where s3.subject_oid = s6.subject_oid
and s3.apo_oid = s6.apo_oid
)
set target_retake_ind = source_retake_ind

&


/*-----------------------------------------------*/
/* TASK No. 39 */
/* drop sapo7 */


BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_subject_apo7';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 
&


/*-----------------------------------------------*/
/* TASK No. 40 */
/* create sapo7 */

create table RAX_APP_USER.tmp_subject_apo7 as
select s3.apo_oid
, s3.subject_oid
, min('Y') as pos_buyer_ind
from RAX_APP_USER.tmp_subject_apo3 s3
, ODS_OWN.order_header oh
, ODS_OWN.capture_session cs
, ODS_OWN.event e
where 1=1
and s3.subject_oid = cs.subject_oid
and cs.capture_session_key = oh.matched_capture_session_id
and oh.event_oid = e.event_oid
and s3.apo_oid = e.apo_oid
and s3.order_date is not null
and oh.order_bucket in ('X')
and oh.order_ship_date < s3.order_date
group by s3.apo_oid
, s3.subject_oid

&


/*-----------------------------------------------*/
/* TASK No. 41 */
/* index sapo7 */

create unique index RAX_APP_USER.tmp_subject_apo7_pk on RAX_APP_USER.tmp_subject_apo7(subject_oid, apo_oid)

&


/*-----------------------------------------------*/
/* TASK No. 42 */
/* update sapo3 from sapo7 */

update
(
select s3.pos_buyer_ind as target_pos_buyer_ind
, s7.pos_buyer_ind as source_pos_buyer_ind
from RAX_APP_USER.tmp_subject_apo3 s3
, RAX_APP_USER.tmp_subject_apo7 s7
where s3.subject_oid = s7.subject_oid
and s3.apo_oid = s7.apo_oid
)
set target_pos_buyer_ind = source_pos_buyer_ind

&


/*-----------------------------------------------*/
/* TASK No. 43 */
/* drop sapo8 */
BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_subject_apo8';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 


&


/*-----------------------------------------------*/
/* TASK No. 44 */
/* create sapo8 */

create table RAX_APP_USER.tmp_subject_apo8 as
select s3.apo_oid
, s3.subject_oid
, sum(case when i.sku_category = 'PACKAGE' then ol.ordered_quantity else 0 end) as package_qty
, sum(case when (i.sku_category <> 'PACKAGE') then ol.ordered_quantity else 0 end) as sheet_qty
from RAX_APP_USER.tmp_subject_apo3 s3
, ODS_OWN.order_header oh
, ODS_OWN.order_line ol
, ODS_OWN.item i
, ODS_OWN.capture_session cs
, ODS_OWN.event e
where 1=1
and s3.subject_oid = cs.subject_oid
and cs.capture_session_key = oh.matched_capture_session_id
and oh.order_header_oid = ol.order_header_oid
and ol.item_oid = i.item_oid
and (ol.list_price > 0 or i.sku_category = 'PACKAGE')
and oh.event_oid = e.event_oid
and s3.apo_oid = e.apo_oid
and oh.order_bucket in ('PAID', 'UNPAID')
group by s3.apo_oid
, s3.subject_oid

&


/*-----------------------------------------------*/
/* TASK No. 45 */
/* index sapo8 */

create unique index RAX_APP_USER.tmp_subject_apo8_pk on RAX_APP_USER.tmp_subject_apo8(subject_oid, apo_oid)

&


/*-----------------------------------------------*/
/* TASK No. 46 */
/* update sapo3 from sapo8 */

update
(
select s3.package_qty as target_package_qty
, s8.package_qty as source_package_qty
, s3.sheet_qty as target_sheet_qty
, s8.sheet_qty as source_sheet_qty
from RAX_APP_USER.tmp_subject_apo3 s3
, RAX_APP_USER.tmp_subject_apo8 s8
where s3.subject_oid = s8.subject_oid
and s3.apo_oid = s8.apo_oid
)
set target_package_qty = source_package_qty
, target_sheet_qty = source_sheet_qty

&


/*-----------------------------------------------*/
/* TASK No. 47 */
/* drop sapo9 */


BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_subject_apo9';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 
&


/*-----------------------------------------------*/
/* TASK No. 48 */
/* create sapo9 */

create table RAX_APP_USER.tmp_subject_apo9 as
select s3.apo_oid
, s3.subject_oid
, count(Distinct Oe.Alias_Id) As Ordered_Recipe_Qty
from RAX_APP_USER.tmp_subject_apo3 s3
, ODS_OWN.order_header oh
, ODS_OWN.order_line ol
, ODS_OWN.order_line_detail od
, ODS_OWN.order_line_element oe
, ODS_OWN.capture_session cs
, ODS_OWN.event e
, ODS_OWN.item i
where 1=1
and s3.subject_oid = cs.subject_oid
and cs.capture_session_key = oh.matched_capture_session_id
and oh.event_oid = e.event_oid
and s3.apo_oid = e.apo_oid
and oh.order_bucket in ('PAID','UNPAID')
and oh.order_header_oid = ol.order_header_oid
and ol.order_line_oid = od.order_line_oid
and oe.order_line_detail_oid = od.order_line_detail_oid
and oe.element_type = 'LOOKID'
and ol.item_oid = i.item_oid
and i.chargeback_category not in (
'ImageAccessProduct'
,'ClassPics'
)
group by s3.apo_oid
, s3.subject_oid

&


/*-----------------------------------------------*/
/* TASK No. 49 */
/* index sapo9 */

create unique index RAX_APP_USER.tmp_subject_apo9_pk on RAX_APP_USER.tmp_subject_apo9(subject_oid, apo_oid)

&


/*-----------------------------------------------*/
/* TASK No. 50 */
/* update sapo3 from sapo9 */

update
(
select s3.ordered_recipe_qty as target_ordered_recipe_qty
, s9.ordered_recipe_qty as source_ordered_recipe_qty
from RAX_APP_USER.tmp_subject_apo3 s3
, RAX_APP_USER.tmp_subject_apo9 s9
where s3.subject_oid = s9.subject_oid
and s3.apo_oid = s9.apo_oid
)
set target_ordered_recipe_qty = source_ordered_recipe_qty

&


/*-----------------------------------------------*/
/* TASK No. 51 */
/* drop sapo10 */


BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_subject_apo10';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 
&


/*-----------------------------------------------*/
/* TASK No. 52 */
/* create sapo10 */

create table RAX_APP_USER.tmp_subject_apo10 as
select s3.apo_oid
, s3.subject_oid
, min('Y') as digital_buyer_ind
from RAX_APP_USER.tmp_subject_apo3 s3
, ODS_OWN.order_header oh
, ODS_OWN.order_line ol
, ODS_OWN.capture_session cs
, ODS_OWN.event e
, ODS_OWN.item i
where 1=1
and s3.subject_oid = cs.subject_oid
and cs.capture_session_key = oh.matched_capture_session_id
and oh.event_oid = e.event_oid
and s3.apo_oid = e.apo_oid
and oh.order_bucket in ('PAID','UNPAID')
and oh.order_header_oid = ol.order_header_oid
and ol.item_oid = i.item_oid
and i.fulfillment_type = 'Digital'
group by s3.apo_oid
, s3.subject_oid

&


/*-----------------------------------------------*/
/* TASK No. 53 */
/* index sapo10 */

create unique index RAX_APP_USER.tmp_subject_apo10_pk on RAX_APP_USER.tmp_subject_apo10(subject_oid, apo_oid)

&


/*-----------------------------------------------*/
/* TASK No. 54 */
/* update sapo3 from sapo10 */

update
(
select s3.digital_buyer_ind as target_digital_buyer_ind
, s10.digital_buyer_ind as source_digital_buyer_ind
from RAX_APP_USER.tmp_subject_apo3 s3
, RAX_APP_USER.tmp_subject_apo10 s10
where s3.subject_oid = s10.subject_oid
and s3.apo_oid = s10.apo_oid
)
set target_digital_buyer_ind = source_digital_buyer_ind

&


/*-----------------------------------------------*/
/* TASK No. 55 */
/* drop tsapo11 */


BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_subject_apo11';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 
&


/*-----------------------------------------------*/
/* TASK No. 56 */
/* create sapo11 */

create table RAX_APP_USER.tmp_subject_apo11 as
select s3.apo_oid
, s3.subject_oid
, min('Y') as pos_ind
from RAX_APP_USER.tmp_subject_apo3 s3
, ODS_OWN.order_header oh
, ODS_OWN.capture_session cs
, ODS_OWN.event e
where 1=1
and s3.subject_oid = cs.subject_oid
and cs.capture_session_key = oh.matched_capture_session_id
and oh.event_oid = e.event_oid
and s3.apo_oid = e.apo_oid
and oh.order_bucket = 'X'
group by s3.apo_oid
, s3.subject_oid

&


/*-----------------------------------------------*/
/* TASK No. 57 */
/* index sapo11 */

create unique index RAX_APP_USER.tmp_subject_apo11_pk on RAX_APP_USER.tmp_subject_apo11(subject_oid, apo_oid)

&


/*-----------------------------------------------*/
/* TASK No. 58 */
/* update sapo3 from sapo11 */

update
(
select s3.pos_ind as target_pos_ind
, s11.pos_ind as source_pos_ind
from RAX_APP_USER.tmp_subject_apo3 s3
, RAX_APP_USER.tmp_subject_apo11 s11
where s3.subject_oid = s11.subject_oid
and s3.apo_oid = s11.apo_oid
)
set target_pos_ind = source_pos_ind

&


/*-----------------------------------------------*/
/* TASK No. 59 */
/* merge subject_apo using sapo3 */

merge into ODS_OWN.subject_apo t
using
( 
select apo_oid
, subject_oid
, image_qty
, photography_date
, second_photography_date
, capture_session_qty
, event_qty
, order_date
, second_order_date
, paid_order_ind
, channel_qty
, order_qty 
, case when channel_qty = 1 then 'Single Channel'
       when channel_qty > 1 then 'Multi-Channel'
       else 'None (Non-Buyer)'
  end as channel_type
, case when capture_session_qty = 1 then 'Single Session'
       when complimentary_retake_ind = 'Y' then 'Complimentary Retake'
       when capture_session_qty > 1 and event_qty = 1 then 'Multi-Session Same Picture Day'
       when capture_session_qty > 1 and event_qty > 1 then 'Multi-Session on Multiple Picture Days'
       else 'None'
  end as session_type
, case when pos_buyer_ind = 'Y' and paid_order_ind = 'Y' then 'Paid POS Buyer'
       when pos_buyer_ind = 'Y' and paid_order_ind <> 'Y' then 'Unpaid POS Buyer'
       when order_date is not null and paid_order_ind = 'Y' then 'Paid Buyer'
       when order_date is not null and paid_order_ind <> 'Y' then 'Unpaid Buyer'
       when image_qty > 0 and pos_buyer_ind = 'N' and pos_ind = 'Y' then 'POS Non-Buyer'
       when image_qty > 0 then 'Non-Buyer'
       else 'Not Photographed'
  end as pipeline_sub_status
, case when package_qty = 1 and sheet_qty = 0 then 'Package'
       when package_qty = 0 and sheet_qty = 1 then 'Single Sheet'
       when package_qty = 0 and sheet_qty > 1 then 'Sheet Builders'
       when package_qty > 0 and package_qty + sheet_qty > 1 then 'Package Plus'
       else 'None (Non-Buyer)'
  end as buyer_type
, ordered_recipe_qty
, paid_order_qty
, price_amount
, digital_buyer_ind
from RAX_APP_USER.tmp_subject_apo3 
) s
on
(   s.subject_oid = t.subject_oid
and s.apo_oid = t.apo_oid
)
when matched then update
set t.image_qty = s.image_qty
, t.photography_date = s.photography_date
, t.second_photography_date = s.second_photography_date
, t.order_date = s.order_date
, t.second_order_date = s.second_order_date
, t.channel_type = s.channel_type
, t.session_type = s.session_type
, t.pipeline_sub_status = s.pipeline_sub_status
, t.buyer_type = s.buyer_type
, t.ordered_recipe_qty = s.ordered_recipe_qty
, t.paid_order_qty = s.paid_order_qty
, t.price_amount = s.price_amount
, t.digital_buyer_ind = s.digital_buyer_ind
, t.ods_modify_date = sysdate
where decode(t.image_qty,s.image_qty,1,0) = 0
or t.photography_date <> s.photography_date or (t.photography_date is null and s.photography_date is not null)
or t.second_photography_date <> s.second_photography_date or (t.second_photography_date is null and s.second_photography_date is not null)
or t.order_date <> s.order_date or (t.order_date is null and s.order_date is not null)
or t.second_order_date <> s.second_order_date or (t.second_order_date is null and s.second_order_date is not null)
or decode(t.channel_type,s.channel_type,1,0) = 0
or decode(t.session_type,s.session_type,1,0) = 0
or decode(t.pipeline_sub_status,s.pipeline_sub_status,1,0) = 0
or decode(t.buyer_type,s.buyer_type,1,0) = 0
or decode(t.ordered_recipe_qty,s.ordered_recipe_qty,1,0) = 0
or decode(t.paid_order_qty,s.paid_order_qty,1,0) = 0
or decode(t.price_amount,s.price_amount,1,0) = 0
or t.digital_buyer_ind <> s.digital_buyer_ind or (t.digital_buyer_ind is null and s.digital_buyer_ind is not null)
when not matched then insert
( t.subject_apo_oid
, t.subject_oid
, t.apo_oid
, t.photography_date
, t.second_photography_date
, t.image_qty 
, t.order_date
, t.second_order_date
, t.channel_type
, t.session_type
, t.pipeline_sub_status
, t.buyer_type
, t.ordered_recipe_qty
, t.paid_order_qty
, t.price_amount
, t.digital_buyer_ind
, t.ods_modify_date
, t.ods_create_date
)
values
( ODS_OWN.subject_apo_seq.nextval
, s.subject_oid
, s.apo_oid
, s.photography_date
, s.second_photography_date
, s.image_qty
, s.order_date
, s.second_order_date
, s.channel_type
, s.session_type
, s.pipeline_sub_status
, s.buyer_type
, s.ordered_recipe_qty
, s.paid_order_qty
, s.price_amount
, s.digital_buyer_ind
, sysdate
, sysdate
)

&


/*-----------------------------------------------*/
/* TASK No. 60 */
/* Update first_order_header_oid */

merge into ods_own.subject_apo t
using
(
select sapo.subject_apo_oid
, min(oh.order_header_oid) as first_order_header_oid
from ods_own.subject_apo sapo
, ods_own.order_header oh
, ODS_OWN.capture_session cs
, ODS_OWN.event e
where sapo.order_date = oh.order_date
and sapo.apo_oid = e.apo_oid
and sapo.subject_oid = cs.subject_oid
and cs.capture_session_key = oh.matched_capture_session_id
and oh.event_oid = e.event_oid
and oh.order_bucket in ('PAID','UNPAID')
and sapo.order_date is not null
and sapo.first_order_header_oid is null
and sapo.ods_modify_date >  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
group by sapo.subject_apo_oid
) s
on ( s.subject_apo_oid = t.subject_apo_oid )
when matched then update
set t.first_order_header_oid = s.first_order_header_oid
, t.ods_modify_date = sysdate
where t.first_order_header_oid is null

&


/*-----------------------------------------------*/
/* TASK No. 61 */
/* update second_order_header_oid */

merge into ods_own.subject_apo t
using
(
select sapo.subject_apo_oid
, min(oh.order_header_oid) as second_order_header_oid
from ods_own.subject_apo sapo
, ods_own.order_header oh
, ODS_OWN.capture_session cs
, ODS_OWN.event e
where sapo.second_order_date = oh.order_date
and sapo.apo_oid = e.apo_oid
and sapo.subject_oid = cs.subject_oid
and cs.capture_session_key = oh.matched_capture_session_id
and oh.event_oid = e.event_oid
and oh.order_bucket in ('PAID','UNPAID')
and sapo.second_order_date is not null
and sapo.second_order_header_oid is null
and sapo.ods_modify_date >  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
group by sapo.subject_apo_oid
) s
on ( s.subject_apo_oid = t.subject_apo_oid )
when matched then update
set t.second_order_header_oid = s.second_order_header_oid
, t.ods_modify_date = sysdate
where t.second_order_header_oid is null

&


/*-----------------------------------------------*/
/* TASK No. 62 */
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
/* TASK No. 63 */
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
,'LOAD_SUBJECT_APO_PKG'
,'016'
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
'LOAD_SUBJECT_APO_PKG',
'016',
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
