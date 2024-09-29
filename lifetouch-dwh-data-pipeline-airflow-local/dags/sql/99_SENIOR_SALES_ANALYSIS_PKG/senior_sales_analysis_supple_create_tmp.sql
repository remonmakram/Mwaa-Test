BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.actuate_seniorsal_supple_stage';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* create report table */

create table RAX_APP_USER.actuate_seniorsal_supple_stage as
select t.fiscal_year
,  'ALL' AS  month
, decode(to_date(
:v_data_export_run_date_trigger_table_refresh,'yyyymmdd'),to_date('01/01/1900','MM/DD/YYYY'),trunc(sysdate - 1),to_date(
:v_data_export_run_date_trigger_table_refresh,'yyyymmdd')) as run_date
, o.company_name
, o.country_name
, m.sub_program_name
, i.merchandise_category
, i.item_group
, sum(f.net_sales_amt) as net_shipped_sales_amt
from consumer_sales_fact f
, organization o
, marketing m
, item i
, time t
, (select  fiscal_year, date_key from time
            where decode(to_date(
:v_data_export_run_date_trigger_table_refresh,'yyyymmdd'),to_date('01/01/1900','MM/DD/YYYY'),trunc(sysdate - 1),to_date(
:v_data_export_run_date_trigger_table_refresh,'yyyymmdd')) = date_key) cfy
where f.JOB_TICKET_ORG_ID = o.organization_id
and f.marketing_id = m.marketing_id
and f.ITEM_ID = i.item_id
and f.trans_date = t.date_key
and f.ship_date <> to_date('19000101', 'YYYYMMDD')
and t.fiscal_year = cfy.fiscal_year 
and f.trans_date <= cfy.date_key
and ('ALL' = 'ALL'  or t.month_name = 'ALL')
and f.source_system_name = 'YANTRA'
group by t.fiscal_year
, o.company_name
, o.country_name
, m.sub_program_name
, i.merchandise_category
, i.item_group
having sum(f.net_sales_amt) <> 0
