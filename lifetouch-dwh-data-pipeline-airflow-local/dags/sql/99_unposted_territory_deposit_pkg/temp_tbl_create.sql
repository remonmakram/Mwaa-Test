-- drop table RAX_APP_USER.actuate_unpostedterrdep_stage 
BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.actuate_unpostedterrdep_stage';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* create  report table */

create table RAX_APP_USER.actuate_unpostedterrdep_stage  as
Select
    o.country_name,
    o.company_name,
    o.area_name,
    o.region_name,
    nvl(o.territory_code,'.') territory_code,
    tac.job_num job_number,
    bec.deposit_method_type,
    tac.account_name,
    tac.lifetouch_id,
    tac.commission_type,
    bec.seq_num batch_number,
    taec.amt deposit_amount,
    bec.deposit_date,
    bac.bank_account_code,
    trunc(bec.audit_create_date) create_date,
    bec.audit_created_by,
    taec.terr_emp_code photographer_id,
    nvl(taec.posting_error_message, decode(tac.unknown_account, 1, 'Unknown Account', 0, null)) as posting_error_message,
    trunc(sysdate) - trunc(bec.audit_create_date) as days_outstanding
from 
 ODS.rev_bank_entry_curr bec,
  ODS.rev_territory_account_curr tac,
  ODS.rev_terr_account_entry_curr taec,
 ODS.rev_bank_account_curr bac,
    time t,
    organization o,
    (select (case when  to_number(:v_actuate_fiscal_year) = 9999 then fiscal_year else  to_number(:v_actuate_fiscal_year) end) fiscal_year
                from time
               where trunc(sysdate) - 5 = date_key) cfy
where 
     bec.deposit_date = t.date_key
       and t.fiscal_year in (cfy.fiscal_year, cfy.fiscal_year-1) 
     and bec.bank_entry_id = taec.bank_entry_id
     and taec.territory_account_id = tac.territory_account_id
     and bec.bank_account_id = bac.bank_account_id
     and taec.posted_date is null
     and nvl(bec.AUTHORIZATION_STATUS,'Approved')='Approved'
     and (tac.PROGRAM_NAME<>'Preschools' or tac.PROGRAM_NAME is null) 
     and tac.territory_code = o.territory_code(+)
     and (o.area_name not in ('Area 61 United States','Area 62 United States') or o.area_name is null)
     and taec.active = 1
     and tac.active = 1
     and bec.active = 1