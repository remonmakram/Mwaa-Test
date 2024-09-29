/*-----------------------------------------------*/
/* TASK No. 3 */
/* drop report table */


BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.actuate_ezprints_detail_stage';
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

create table RAX_APP_USER.actuate_ezprints_detail_stage as
select t.fiscal_year
, t.month_name
, t.fiscal_month_number
, o.country_name
,o.AMS_BUSINESS_UNIT_NAME 
,o.company_name
, case when f.source_entity_id = 49 then oec.type
       when f.source_entity_id = 48 then orc.type
       else 'N/A'
  end
  as type
, sum(f.revenue_amt) revenue
, sum(f.expense_amt) expense
from mart.ezdough_sales_fact f
, time t
, organization o
, marketing m
,ods.ez_order_expense_curr oec
,ods.ez_order_revenue_curr orc
, (select (case when to_number(:v_actuate_fiscal_year) = 9999 then fiscal_year else to_number(:v_actuate_fiscal_year) end) as fiscal_year from time
            where trunc(sysdate - 7) = date_key) cfy
where f.ship_date = t.date_key
and f.job_ticket_org_id = o.organization_id
and f.source_entity_id in (48, 49)
and case when f.source_entity_id = 49 then f.source_system_key else null end = oec.order_expense_id(+)
and case when f.source_entity_id = 48 then f.source_system_key else null end = orc.order_revenue_id(+)
and t.fiscal_year = cfy.fiscal_year 
and f.marketing_id = m.marketing_id
group by t.fiscal_year
, t.fiscal_month_number
, t.month_name
, o.country_name
,o.AMS_BUSINESS_UNIT_NAME 
,o.company_name
, case when f.source_entity_id = 49 then oec.type
       when f.source_entity_id = 48 then orc.type
       else 'N/A'
  end
having sum(f.revenue_amt) <> 0
or sum(f.expense_amt) <> 0
order by t.fiscal_year
, t.fiscal_month_number
, o.country_name
,o.AMS_BUSINESS_UNIT_NAME 
,o.company_name
, case when f.source_entity_id = 49 then oec.type
       when f.source_entity_id = 48 then orc.type
       else 'N/A'
  end
