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
/* drop ep_fact_driverdriver */

-- drop table rax_app_user.ep_fact_driver
BEGIN
   EXECUTE IMMEDIATE 'drop table rax_app_user.ep_fact_driver';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* create table ep_fact_driver */

create table rax_app_user.ep_fact_driver
as 
select event_payment_oid
, payment_date
, payment_amount
, payment_type_oid
, photographer_employee_oid
, event_oid
, deposit_oid
, source_system_oid
, subject_first_name
, subject_last_name
, subject_grade
, acct_comm_pmt_req_id
, territory_account_type
, refund_reason
, payment_source
, ods_create_date
from ods_own.event_payment
where ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap


&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* index ep_fact_driver */

create unique index rax_app_user.ep_fact_driver_pk on rax_app_user.ep_fact_driver(event_payment_oid)

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* drop ep_fact_temp */

-- drop table rax_app_user.ep_fact_temp
BEGIN
   EXECUTE IMMEDIATE 'drop table rax_app_user.ep_fact_temp';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* create ep_fact_temp */

create table rax_app_user.ep_fact_temp
as
select
 me.event_id
, mapo.apo_id
, mm.marketing_id
, mo.organization_id as job_ticket_org_id
, ca.assignment_id
, ca.effective_date as assignment_effective_date
, ma.account_id
, nvl(employee.employee_id, -1) as photographer_id
, nvl(driver.subject_first_name, '.') as subject_first_name
, nvl(driver.subject_last_name, '.') as subject_last_name
, nvl(driver.subject_grade, '.') as subject_grade
, nvl(mpt.payment_type_id, -1) as payment_type_id
, pat.payment_acct_type_id
, driver.event_payment_oid
, nvl(deposit.deposit_date, to_date('19000101','YYYYMMDD')) as deposit_date
, nvl(deposit.sequence_number, 0) as sequence_number
, nvl(ba.bank_code, '.') as bank_code
, driver.ods_create_date as trans_date
, driver.payment_amount
, driver.payment_date
, nvl(driver.refund_reason, '.') as refund_reason
, nvl(driver.payment_source, '.') as payment_source
from rax_app_user.ep_fact_driver driver
, ods_own.event e
, mart.event me
, ods_own.apo apo
, mart.apo mapo
, ods_own.account a
, mart.account ma
, ods_own.sub_program sp
, mart.marketing mm
, mart.current_assignment ca
, mart.organization  mo   
, mart.employee employee
, ods_own.payment_type pt
, mart.payment_type mpt
, mart.payment_acct_type pat
, ods_own.deposit deposit
, ods_own.bank_account ba
where nvl(driver.event_oid, -1) = e.event_oid
and nvl(e.event_ref_id,-1) = me.Job_nbr(+)
and nvl(e.apo_oid, -1) = apo.apo_oid(+)
and  nvl(apo.apo_id, -1) = mapo.apo_code(+)
and apo.account_oid = a.account_oid 
and nvl(a.lifetouch_id, -1) = ma.lifetouch_id(+)
and apo.sub_program_oid = sp.sub_program_oid  
and nvl(sp.sub_program_oid, -1) = mm.sub_program_oid(+)
and a.Lifetouch_Id = ca.Lifetouch_Id
and mm.program_id = ca.program_id
and nvl(apo.territory_code, -1) = mo.territory_code(+)
and nvl(driver.photographer_employee_oid, -1)=  employee.employee_oid
and driver.payment_type_oid = pt.payment_type_oid
and (case when pt.payment_type = 'Check' then 'CH'
                when pt.payment_type = 'Cash' then 'CA'
                when pt.payment_type = 'CashCheck' then 'CashCheck'
                when pt.payment_category = 'CreditCard'
                         then decode(pt.payment_type,'Visa','VI','MasterCard','MC'
                          ,'Discover','DI','AmericanExpress','AM','CreditCard')
                 when pt.payment_type = 'Paypal' then 'PAYPAL'
                 when pt.payment_type = 'RefundCheck' then 'RefundCheck'
                 else upper(pt.payment_type) end) = mpt.payment_type(+)
and (case when driver.territory_account_type ='Reorder' then 'Reorder'
	    when driver.territory_account_type='Underclass' then 'Underclass' 
	    when driver.territory_account_type='Acquisition' then 'Acquisition'
	    when driver.territory_account_type='IDepot' then 'IDepot'
	    when driver.territory_account_type='UnidentifiedMoney' then 'Unidentified Money'
	    when driver.territory_account_type='SpecialEvents'  then 'Special Events'
	    when driver.territory_account_type='Publishing' then 'Publishing'
	    when driver.territory_account_type='Service'  then 'Service'
	    when driver.territory_account_type='OutsideProcessing' then 'Outside Processing'
	    when driver.territory_account_type='RemindTheX' then 'RemindTheX'
	    when driver.territory_account_type='JobHold' then 'Job Hold'
	    when driver.territory_account_type='SmilestonesCompCAD' then 'Smilestones Composite Canada'
	    when driver.territory_account_type='SmilestonesOrdersCAD' then 'Smilestones Orders Canada'
	    when driver.territory_account_type='GMITSitFeesCAD' then 'GMIT Sit Fees Canada'
	    when driver.territory_account_type='GMITOrdersCAD' then 'GMIT Orders Canada'
	    when driver.territory_account_type='IDepotCAD' then 'IDepot Canada'
	    when driver.territory_account_type='ServiceCAD' then 'Service Canada'
            else 'Unknown' end
        ) = pat.payment_acct_type_name
and driver.deposit_oid = deposit.deposit_oid(+)
and deposit.bank_account_oid = ba.bank_account_oid(+)


&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* index ep_fact_temp */

create unique index rax_app_user.ep_fact_temp_pk on rax_app_user.ep_fact_temp(event_payment_oid)

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* merge into mart.event_payment_fact */

merge into mart.event_payment_fact t
using (
 select  * from rax_app_user.ep_fact_temp
) s
on (t.event_payment_oid = s.event_payment_oid)
when matched then update
set
  t.photographer_id = s.photographer_id 
, t.subject_first_name = s.subject_first_name
, t.subject_last_name = s.subject_last_name
, t.subject_grade = s.subject_grade
, t.payment_type_id = s.payment_type_id
, t.payment_acct_type_id = s.payment_acct_type_id
, t.deposit_date = s.deposit_date
, t.sequence_number = s.sequence_number
, t.bank_code = s.bank_code
, t.payment_amount = s.payment_amount
, t.payment_date = s.payment_date
, t.event_id = s.event_id
, t.apo_id = s.apo_id
, t.marketing_id = s.marketing_id
, t.job_ticket_org_id = s.job_ticket_org_id
, t.assignment_id = s.assignment_id
, t.assignment_effective_date   = s.assignment_effective_date
, t.account_id = s.account_id
, t.refund_reason = s.refund_reason
, t.payment_source = s.payment_source
where t.photographer_id <> s.photographer_id 
or t.subject_first_name <> s.subject_first_name
or t.subject_last_name <> s.subject_last_name
or t.subject_grade <> s.subject_grade
or t.payment_type_id <> s.payment_type_id
or t.payment_acct_type_id <> s.payment_acct_type_id
or t.deposit_date <> s.deposit_date
or t.sequence_number <> s.sequence_number
or t.bank_code <> s.bank_code
--or t.payment_amount <> s.payment_amount
or t.payment_date <> s.payment_date
or t.event_id <> s.event_id
or t.apo_id <> s.apo_id
or t.marketing_id <> s.marketing_id
or t.job_ticket_org_id <> s.job_ticket_org_id
or t.assignment_id <> s.assignment_id
or t.assignment_effective_date   <> s.assignment_effective_date
or t.account_id <> s.account_id
or t.refund_reason <> s.refund_reason
or t.payment_source <> s.payment_source
when not matched then
insert
(
 t.event_payment_id
, t.job_ticket_org_id
, t.assignment_id
, t.assignment_effective_date   
, t.account_id
, t.marketing_id
, t.photographer_id  
, t.apo_id
, t.event_id
, t.subject_first_name
, t.subject_last_name
, t.subject_grade
, t.payment_type_id
, t.payment_acct_type_id
, t.event_payment_oid
, t.deposit_date
, t.sequence_number
, t.bank_code
, t.trans_date
, t.payment_amount
, t.payment_date  
, t.refund_reason
, t.payment_source    
)
values
(
  mart.event_payment_fact_id_seq.nextval
, s.job_ticket_org_id
, s.assignment_id
, s.assignment_effective_date   
, s.account_id
, s.marketing_id
, s.photographer_id  
, s.apo_id
, s.event_id
, s.subject_first_name
, s.subject_last_name
, s.subject_grade
, s.payment_type_id
, s.payment_acct_type_id
, s.event_payment_oid
, s.deposit_date
, s.sequence_number
, s.bank_code
, s.trans_date
, s.payment_amount
, s.payment_date      
, s.refund_reason
, s.payment_source
)

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
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
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
,'LOAD_EVENT_PAYMENT_FACT_PKG'
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
'LOAD_EVENT_PAYMENT_FACT_PKG',
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
