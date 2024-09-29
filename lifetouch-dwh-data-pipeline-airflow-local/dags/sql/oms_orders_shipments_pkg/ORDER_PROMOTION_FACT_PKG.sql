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
/* drop temp table  */



BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_order_promotion';
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

create table RAX_APP_USER.tmp_order_promotion
(
  promotion_code varchar2(100) , 
  order_header_oid number,  
  promotion_qty number,
  item_id number, 
  discount_amt number,
  charge_name varchar2(40),
  applied_qty number
)


&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* insert into temp table */

insert into RAX_APP_USER.tmp_order_promotion
( promotion_code
, order_header_oid
, promotion_qty
, item_id
, discount_amt
, charge_name
, applied_qty
)
select p.promotion_id as promotion_code, oh.order_header_oid, count(promotion_id) as promotion_qty, -1 as item_id, 0 as discount_amt,
'.' as charge_name, 0 as applied_qty
from ODS_OWN.promotion p
, ODS_OWN.order_header oh
, ODS_OWN.apo apo
where 1=1
and p.order_header_oid = oh.order_header_oid
and oh.apo_oid = apo.apo_oid
and apo.school_year > 2016
and p.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
group by p.promotion_id, oh.order_header_oid


&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* index temp table */

create index RAX_APP_USER.tmp_order_promotion_ix on RAX_APP_USER.tmp_order_promotion(promotion_code, order_header_oid)

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* insert into tmp_order_promotion */

insert into RAX_APP_USER.tmp_order_promotion
( promotion_code
, order_header_oid
, promotion_qty
, item_id
, discount_amt
, charge_name
, applied_qty
)
select '.' as promotion_code, oh.order_header_oid, 0 as promotion_qty, -1 as item_id, sum(hc.charge) as discount_amt, regexp_substr(hc.charge_name,'[^:]+',1,1) as charge_name
, count(oh.order_header_oid) as applied_qty
from ODS_OWN.header_charge hc
, ODS_OWN.order_header oh
where 1=1
and hc.order_header_oid = oh.order_header_oid
and hc.charge_category = 'Discounts'
and hc.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
group by oh.order_header_oid, regexp_substr(hc.charge_name,'[^:]+',1,1) 


&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* insert into temp */

insert into RAX_APP_USER.tmp_order_promotion
( promotion_code
, order_header_oid
, promotion_qty
, item_id
, discount_amt
, charge_name
, applied_qty
)
select '.' as promotion_code,  oh.order_header_oid, 0 as promotion_qty, nvl(mi.item_id, 0) as item_id, sum(lc.charge_amount) as discount_amt, regexp_substr(lc.charge_name,'[^:]+',1,1) as charge_name
, count(oh.order_header_oid) as applied_qty
from ODS_OWN.line_charge lc
, ODS_OWN.order_line ol
, ODS_OWN.order_header oh
, ODS_OWN.item item
, MART.item mi
where 1=1
and charge_category = 'Discounts'
and lc.order_line_oid = ol.order_line_oid
and oh.order_header_oid = ol.order_header_oid
and ol.item_oid = item.item_oid
and item.item_id = mi.item_code(+)
and lc.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
group by ol.order_header_oid, mi.item_id, regexp_substr(lc.charge_name,'[^:]+',1,1)

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* drop temp table1 */

BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_order_promotion1';
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
/* create temp table1 */

create table RAX_APP_USER.tmp_order_promotion1
as
select ma.account_id
, a.lifetouch_id
, mapo.apo_id
, me.event_id
, mm.marketing_id
, nvl(ms.subject_id, 1) as subject_id
, mo.organization_id as job_ticket_org_id
, ca.assignment_id
, ca.effective_date as assignment_effective_date
, mc.channel_id as order_channel_id
, oh.order_no
, up.account_email_address as email_address
, oh.order_date
, tmp.item_id
, tmp.promotion_code
, tmp.promotion_qty
, tmp.discount_amt
, tmp.charge_name
, tmp.applied_qty
, sysdate as mart_create_date
, Sysdate as mart_modify_date
from  RAX_APP_USER.tmp_order_promotion tmp
, ODS_OWN.order_header oh
, MART.order_header moh
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
, ODS_OWN.user_profile up
, ODS_OWN.capture_session cs
, MART.subject ms
where 1=1
and oh.order_header_oid = tmp.order_header_oid
and oh.order_no = moh.source_system_key(+)
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
and nvl(oh.user_profile_oid, -1) = up.user_profile_oid(+)
and nvl(oh.matched_capture_session_id, -1) = cs.capture_session_key(+)
and nvl(cs.subject_oid, -1) = ms.subject_oid(+)


&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* index temp1 */

create index RAX_APP_USER.tmp_order_promotion1_ix on RAX_APP_USER.tmp_order_promotion1(promotion_code, order_no)

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* merge into target fact table */

merge into MART.order_promotion_fact t
using ( select account_id, event_id, apo_id, marketing_id, subject_id, job_ticket_org_id, 
         assignment_id, assignment_effective_date, order_channel_id, order_no, email_address,
         item_id, promotion_code, promotion_qty, discount_amt, charge_name, applied_qty
         from RAX_APP_USER.tmp_order_promotion1) s
on (s.promotion_code= t.promotion_code and s.order_no = t.order_no and nvl(s.item_id, -1) = nvl(t.item_id, -1) and nvl(s.charge_name, '.') = nvl(t.charge_name, '.'))
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
, t.email_address = s.email_address
, t.promotion_qty = s.promotion_qty
, t.discount_amt = s.discount_amt
, t.applied_qty = s.applied_qty
, t.mart_modify_date = sysdate
where t.discount_amt <> s.discount_amt
or t.applied_qty <> s.applied_qty
or t.promotion_qty <> s.promotion_qty
or t.email_address <> s.email_address
or (t.email_address is null and s.email_address is not null)
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
when not matched then
insert
(
 t.order_promotion_id
, t.account_id
, t.apo_id
, t.event_id
, t.marketing_id
, t.subject_id
, t.job_ticket_org_id
, t.assignment_id
, t.assignment_effective_date
, t.order_channel_id
, t.order_no
, t.email_address
, t.item_id
, t.promotion_code
, t.promotion_qty
, t.discount_amt
, t.charge_name
, t.applied_qty
, t.mart_create_date
, t.mart_modify_date
)
values
(
 MART.order_promotion_id_seq.nextval
, s.account_id
, s.apo_id
, s.event_id
, s.marketing_id
, s.subject_id
, s.job_ticket_org_id
, s.assignment_id
, s.assignment_effective_date
, s.order_channel_id
, s.order_no
, s.email_address
, s.item_id
, s.promotion_code
, s.promotion_qty
, s.discount_amt
, s.charge_name
, s.applied_qty
, sysdate
, sysdate	
)


&


/*-----------------------------------------------*/
/* TASK No. 14 */
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
/* TASK No. 15 */
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
,'ORDER_PROMOTION_FACT_PKG'
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
'ORDER_PROMOTION_FACT_PKG',
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
