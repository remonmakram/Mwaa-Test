

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.actuate_seniterrsal_act_stage';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 


&

/*-----------------------------------------------*/
/* TASK No. 6 */
/* create report table */

create table RAX_APP_USER.actuate_seniterrsal_act_stage  as
select o.country_name
, o.company_name
, o.area_name
, o.region_name
, o.territory_code
, main.location_code
, initcap(o.manager_first_name) || ' ' || initcap(o.manager_last_name) territory_manager
, NVL(a.account_name,'Territory Totals') account_name
, decode(a.account_name,null,9,0) acct_sort_order
, a.lifetouch_id
, a.account_id
, a.address_line_1
, a.city
, a.state
, a.postal_code
, main.fiscal_year
, decode(to_date(:v_data_export_run_date_trigger_table_refresh,'yyyymmdd'),to_date('01/01/1900','MM/DD/YYYY'),trunc(sysdate - 1),to_date(:v_data_export_run_date_trigger_table_refresh,'yyyymmdd')) as run_date
, item_group
, (case when group_level_3 = 'Service' then 1 
    else case when group_level_3 = 'Product' then 2
    else 99
    end end) as group_level_3_sort
, group_level_3
, sub_program_name
, program_name
, sum(shipped_Sales_amt) as shipped_Sales_amt
, sum(tax_amt) as tax_amt
, sum(ordered_qty) as ordered_qty
, sum(gross_ship_sales_amt) as gross_ship_sales_amt
, sum(gross_ship_paid_amt) as gross_ship_paid_amt
, sum(Terr_earnings_amt) as Terr_earnings_amt
from
  (select job_ticket_org_id
  , m.sub_program_name
  , m.program_name
  , account_id
  , apo.territory_group_code location_code
  , cfy.fiscal_year
  , item.merchandise_category as group_level_3
  ,  item.item_group 
  , sum(f.net_sales_amt)  as shipped_sales_amt
  , sum(f.tax_amt)  as tax_amt
  , sum(f.ordered_qty ) as ordered_qty
  , sum(f.price_amt  + f.tax_amt) as gross_ship_sales_amt
  , sum(f.payment_amt ) as gross_ship_paid_amt
  , sum(f.territory_earnings_amt) as terr_earnings_amt
  from mart.consumer_sales_fact f
    , item
    , marketing m
    , time t
    , mart.apo
, (select (case when to_number(:v_data_export_school_year_trigger_table_refresh) = 9999 then fiscal_year else to_number(:v_data_export_school_year_trigger_table_refresh) end) as fiscal_year, date_key from time
            where decode(to_date(:v_data_export_run_date_trigger_table_refresh,'yyyymmdd'),to_date('01/01/1900','MM/DD/YYYY'),trunc(sysdate - 1),to_date(:v_data_export_run_date_trigger_table_refresh,'yyyymmdd')) = date_key) cfy
   where f.item_id = item.item_id
      and f.trans_date <= cfy.date_key
      and f.trans_date = t.date_key
      and t.fiscal_year = cfy.fiscal_year
      and f.marketing_id = m.marketing_id
      and f.apo_id = apo.apo_id
      and f.ship_date <> to_date('19000101', 'YYYYMMDD')
   group by job_ticket_org_id
    , m.program_name
    , m.sub_program_name
    , account_id
    , apo.territory_group_code 
    , cfy.fiscal_year
  , item.merchandise_category
  , item.item_group 
  ) main
, account a
, organization o
where
      main.account_id = a.account_id(+) and
      main.job_ticket_org_id = o.organization_id
group by o.country_name
, o.company_name
, o.area_name
, o.region_name
, o.territory_code
, main.location_code
, initcap(o.manager_first_name) || ' ' || initcap(o.manager_last_name)
, program_name
, sub_program_name
, NVL(a.account_name,'Territory Totals')
, decode(a.account_name,null,9,0) 
, a.lifetouch_id
, a.account_id
, a.address_line_1
, a.city
, a.state
, a.postal_code
, main.fiscal_year
, trunc(sysdate)
, (case when group_level_3 = 'Service' then 1 
    else case when group_level_3 = 'Product' then 2
    else 99
    end end)
, group_level_3
, item_group
having sum(gross_ship_sales_amt) <> 0
   or sum(shipped_sales_amt) <> 0
   or sum(gross_ship_paid_Amt) <> 0
   or sum(Terr_earnings_amt) <> 0
   or sum(tax_amt) <> 0

&


