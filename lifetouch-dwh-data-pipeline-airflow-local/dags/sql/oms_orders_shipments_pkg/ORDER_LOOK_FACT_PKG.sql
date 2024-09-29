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
/* drop temp table */



BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_order_look';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -942 THEN
            DBMS_OUTPUT.PUT_LINE('Table does not exist.');
        ELSE
            RAISE;
        END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* create temp table */

create table RAX_APP_USER.tmp_order_look
as
Select ol.order_header_oid
, regexp_substr(oe.alias_id,'\S+$') as look_no
, count(oe.alias_id) as look_qty
, 1 as subject_id
, ol.item_oid
From ODS_OWN.order_line ol
,ODS_OWN.order_line_detail od
, ODS_OWN.order_line_element oe
, ODS_OWN.item i 
Where 1=1
and ol.order_line_oid = od.order_line_oid
And oe.order_Line_detail_oid = od.order_line_detail_oid
And oe.Element_Type = 'LOOKID' 
and oe.element_name <> 'Enhancement'
and ol.item_oid = i.item_oid
and i.chargeback_category not in (
'ImageAccessProduct'
,'ClassPics'
)
and oe.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
group by oe.alias_id, ol.order_header_oid, ol.item_oid


&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* drop temp table1 */

BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_order_look1';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -942 THEN
            DBMS_OUTPUT.PUT_LINE('Table does not exist.');
        ELSE
            RAISE;
        END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* create temp table1 */

create table RAX_APP_USER.tmp_order_look1
as
Select order_header_oid
, look_no
, sum(look_qty) as look_qty
, subject_id
, item_oid
From   RAX_APP_USER.tmp_order_look
group by look_no, order_header_oid, subject_id, item_oid


&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* index temp table1 */

create index RAX_APP_USER.tmp_order_look1_ix on RAX_APP_USER.tmp_order_look1(order_header_oid)

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* update subject_id */

merge into RAX_APP_USER.tmp_order_look1 tmp
    using 
(  
select tmplook.order_header_oid, tmplook.look_no, tmplook.item_oid, ms.subject_id
from RAX_APP_USER.tmp_order_look1 tmplook
, ODS_OWN.order_header oh
, ODS_OWN.capture_session cs
, MART.subject ms
where tmplook.order_header_oid = oh.order_header_oid
and oh.matched_capture_session_id = cs.capture_session_key
and cs.subject_oid = ms.subject_oid
)src
on (tmp.order_header_oid = src.order_header_oid and tmp.look_no = src.look_no and tmp.item_oid = src.item_oid)    
when matched then      
 update
 set 
 tmp.subject_id    =  src.subject_id

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* drop temp table2 */

BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_order_look2';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -942 THEN
            DBMS_OUTPUT.PUT_LINE('Table does not exist.');
        ELSE
            RAISE;
        END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* create temp table2 */

create table RAX_APP_USER.tmp_order_look2
as
select ma.account_id
, a.lifetouch_id
, mapo.apo_id
, apo.apo_id uk_apo_code
, me.event_id
, e.event_ref_id uk_job_nbr
, mm.marketing_id
, tmp.subject_id
, mo.organization_id as job_ticket_org_id
, ca.assignment_id
, ca.effective_date as assignment_effective_date
, mc.channel_id as order_channel_id
, tmp.order_header_oid
, oh.order_date
, tmp.look_no
, tmp.look_qty 
, moh.order_header_id
, mi.item_id
, 0 as order_qty
, sysdate as mart_create_date
, Sysdate as mart_modify_date
from  RAX_APP_USER.tmp_order_look1 tmp
, ODS_OWN.order_header oh
, MART.order_header moh
, ODS_OWN.capture_session cs
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
, ODS_OWN.item item
, MART.item mi
where 1=1
and oh.order_header_oid = tmp.order_header_oid
and oh.order_no = moh.source_system_key(+)
and oh.order_channel_oid = oc.order_channel_oid
and oc.channel_name = mc.channel_name
and cs.capture_session_key = oh.matched_capture_session_id
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
and tmp.item_oid = item.item_oid
and item.item_id = mi.item_code(+)


&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* index temp table2 */

create index RAX_APP_USER.tmp_order_look2_ix on RAX_APP_USER.tmp_order_look2(order_header_oid, look_no, item_id)

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* insert into temp table2 */

insert into RAX_APP_USER.tmp_order_look2
(   account_id,
    lifetouch_id,
    apo_id,
    uk_apo_code,
    event_id,
    uk_job_nbr,
    marketing_id,
    subject_id,
    job_ticket_org_id,
    assignment_id,
    assignment_effective_date,
    order_channel_id,
    order_header_oid,
    order_date,
    look_no,
    look_qty,
    order_header_id,
    item_id,
    order_qty,
    mart_create_date,
    mart_modify_date
) 
select account_id,
    lifetouch_id,
    apo_id,
    uk_apo_code,
    event_id,
    uk_job_nbr,
    marketing_id,
    subject_id,
    job_ticket_org_id,
    assignment_id,
    assignment_effective_date,
    order_channel_id,
    order_header_oid,
    order_date,
    -1,
    0,
    order_header_id,
    -1,
    1,
    mart_create_date,
    mart_modify_date
from RAX_APP_USER.tmp_order_look2
group by account_id, lifetouch_id, apo_id, uk_apo_code, event_id, uk_job_nbr, marketing_id, subject_id, job_ticket_org_id, assignment_id, assignment_effective_date, order_channel_id, order_header_oid, order_date, order_header_id, mart_create_date,mart_modify_date

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* insert into apo dim */

insert all      
       when apo_id is null
       then
           into MART.apo(apo_id, apo_code, source_system_name, school_year, selling_method_name, plant_name, photography_date, lifetouch_id, marketing_code, territory_code, apy_id, description, price_program_name, photography_location, studio_code, internet_order_offered_ind,territory_group_code, student_id_ind)
            values(mart.apo_id_seq.nextval,uk_apo_code,'.','0','.',
                 '.',TO_DATE('01-01-1900','DD-MM-YYYY'),0,'.',
                 '.',0,'.','.','.',
                 '.','.','.','.') 
          select distinct apo_id, uk_apo_code, 'apo' as dim_type
          from RAX_APP_USER.tmp_order_look2 s
          where not exists ( select * from MART.apo apo where s.uk_apo_code = apo.apo_code)
          

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* insert event dim */

insert all       
       when event_id is null
       then 
            into MART.event(event_id, job_nbr, source_system,  school_year, season_name, selling_method_name, job_nbr_char9,
                                    job_nbr_char10, bid_ind, pdk_ind, pdk_partnbr,retake_ind,retake_nbr,shipped_ind, paid_ind,                                			            prejob_ind, cmsn_status_code,plant_code,plant_name, source_system_event_id,projection_job_ind,
                                    job_ticket_only_ind,service_only_ind, outside_job_ind,related_jobs_code, job_classification_name,
                                    photography_date,plant_receipt_date,ship_date, first_deposit_date, vision_commit_date,
                                    final_date, bull_flag, vision_flag,lifetouch_id,location_code, marketing_code,flyer, cancel_ind,
                                    alpha_sort_code, alpha_plus_code, print_album_code, staff_composite_code, group_composite_later_code,
                                    group_composite_name_code, camera_type, pvl_needed_ind, job_delayed_ind, barcoded_services_ind,
                                    territory_code, apy_id, sub_program_name,fiscal_year, apy_bid_ind, at_risk_ind,booking_status,
                                    vision_employee_code,incentive_acquisition_ind, acquired_business_name, acquisition_date,
                                    retention_code, current_year_selling_methods,prior_year_selling_methods, current_year_mkt_codes,
                                    prior_year_mkt_codes, event_booking_status,booking_status_reason_id, lost_to_competitor_id,
                                    at_risk_reason_id, at_risk_competitor_id,pvl_ind,rollover_job_ind, setcode,  vision_photo_date_a,
                                    vision_photo_date_b)
                          values (ods.event_id_seq.nextval, uk_job_nbr,  '.',  0, '.',  '.',  '.', '.', '.', '.', '.', '.', 0, '.', '.', '.', '.', '.',  '.', 0, '.',  '.',  '.',
                                    '.', '.', '.',  to_date('01-01-1900','DD-MM-YYYY'),  to_date('01-01-1900','DD-MM-YYYY'),
                                    to_date('01-01-1900','DD-MM-YYYY'),  to_date('01-01-1900','DD-MM-YYYY'),
                                    to_date('01-01-1900','DD-MM-YYYY'),  to_date('01-01-1900','DD-MM-YYYY'),
                                    '.',  '.', 0, '.', '.', '.', '.', '.', '.', '.', '.', '.', '.',  '.', '.', '.', '.', '.', 0, '.', 0, '.', '.',  '.', '.',  '.', '.',
                                    to_date('01-01-1900','DD-MM-YYYY'), '.',  '.', '.',  '.', '.', '.', 0, 0, 0, 0, '.',  '.', '.',
                                    to_date('01-01-1900','DD-MM-YYYY'),  to_date('01-01-1900','DD-MM-YYYY')
                                 )
               select distinct event_id,uk_job_nbr,'EVENT' as dim_type 
               from RAX_APP_USER.tmp_order_look2 s
               where not exists (select * from MART.event event
                                                  where s.uk_job_nbr = event.job_nbr)






&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* merge into target fact table */

merge into MART.order_look_fact t
using ( select account_id, apo_id, event_id, marketing_id, subject_id, job_ticket_org_id, assignment_id,
            assignment_effective_date, order_channel_id, order_header_oid, order_date, look_no, look_qty,
            order_header_id, item_id, order_qty
         from RAX_APP_USER.tmp_order_look2) s
on (s.order_header_oid = t.order_header_oid and s.look_no = t.look_no and s.item_id = t.item_id)
when matched then
update 
set t.account_id = s.account_id
, t.apo_id = s.apo_id
, t.event_id = s.event_id
, t.marketing_id = s.marketing_id
, t.subject_id = s.subject_id
, t.job_ticket_org_id = s.job_ticket_org_id
, t.assignment_id = s.assignment_id
, t.assignment_effective_date = s.assignment_effective_date
, t.order_channel_id = s.order_channel_id
, t.order_date = s.order_date
, t.look_qty = s.look_qty
, t.order_qty = s.order_qty
, t.order_header_id = s.order_header_id
, t.mart_modify_date = sysdate
where t.look_qty <> s.look_qty
or t.order_date <> s.order_date
or (t.order_date is null and s.order_date is not null)
or t.order_channel_id <> s.order_channel_id
or t.assignment_effective_date <> s.assignment_effective_date
or (t.assignment_effective_date is null and s.assignment_effective_date is not null)
or t.assignment_id <> s.assignment_id
or t.job_ticket_org_id <> s.job_ticket_org_id
or t.subject_id <> s.subject_id
or t.marketing_id <> s.marketing_id
or t.event_id <> s.event_id
or t.apo_id <> s.apo_id
or t.account_id <> s.account_id
or t.order_header_id <> s.order_header_id
or t.order_qty <> s.order_qty
when not matched then
insert
(
 t.order_look_id
, t.account_id
, t.apo_id
, t.event_id
, t.marketing_id
, t.subject_id
, t.job_ticket_org_id
, t.assignment_id
, t.assignment_effective_date
, t.order_channel_id
, t.order_header_oid
, t.order_date
, t.look_no
, t.look_qty
, t.item_id
, t.order_header_id
, t.order_qty
, t.mart_create_date
, t.mart_modify_date
)
values
(
 MART.order_look_id_seq.nextval
, s.account_id
, s.apo_id
, s.event_id
, s.marketing_id
, s.subject_id
, s.job_ticket_org_id
, s.assignment_id
, s.assignment_effective_date
, s.order_channel_id
, s.order_header_oid
, s.order_date
, s.look_no
, s.look_qty
, s.item_id
, s.order_header_id
, s.order_qty
, sysdate
, sysdate	
)


&


/*-----------------------------------------------*/
/* TASK No. 17 */
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
/* TASK No. 18 */
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
,'ORDER_LOOK_FACT_PKG'
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
'ORDER_LOOK_FACT_PKG',
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
