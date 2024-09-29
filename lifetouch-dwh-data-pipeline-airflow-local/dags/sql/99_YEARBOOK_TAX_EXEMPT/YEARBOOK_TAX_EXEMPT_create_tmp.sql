/*-----------------------------------------------*/
/* TASK No. 3 */
/* drop report table */


BEGIN
  EXECUTE IMMEDIATE 'drop table rax_app_user.yearbook_tax_exempt_export';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;
&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* create report table */


create table rax_app_user.yearbook_tax_exempt_export
as
SELECT   a.territory_code, a.lifetouch_id, a.apo_id,
         a.lpip_job_number, e.event_ref_id, acct.account_name,
         a.contract_received,
         CASE
            WHEN a.is_tax_exempt = 1
               THEN 'True'
            ELSE 'False'
         END AS is_tax_exempt,
         acct.state
    FROM ods_own.apo a,
         ods_own.sub_program sp,
         ods_own.event e,
         ods_own.ACCOUNT acct,
         ods_own.organization_vw vw
   WHERE a.sub_program_oid = sp.sub_program_oid
     AND a.apo_oid = e.apo_oid
     AND a.account_oid = acct.account_oid
     AND a.territory_code = vw.territory_code
     AND vw.business_unit_name != 'Test Organization'
     AND sp.sub_program_name = 'Yearbook'
     AND a.status = 'Active'
     AND a.school_year = :v_actuate_fiscal_year
