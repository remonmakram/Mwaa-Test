
BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.actuate_reccust_depo_acct_stg';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;
&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* create report table */

create table RAX_APP_USER.actuate_reccust_depo_acct_stg as
select 
/*+ index( oh ORDER_HEADER_CIX6)   PARALLEL(f, 8)  PARALLEL(oh, 8)  PARALLEL(a, 8)    */
   o.country_name
,  o.company_name
,  o.area_name
,  o.region_name
,  o.territory_code 
, Initcap(o.manager_first_name || ' ' || o.manager_last_name ) as tm_name 
, m.sub_program_name
, m.program_name
, oh.source_system_key as order_no 
, oh.photography_location
, oh.studio_code
, oh.order_sales_channel
, apo.territory_group_code
, apo.SCHOOL_YEAR
, a.account_name
, a.lifetouch_id
, initcap(a.address_line_1 || ' ' || a.city || ', ' || a.state || ' ' || a.postal_code) as acct_address
, sum(f.payment_amt) as amount_paid 
, sum(case when i.merchandise_category = 'Service' and f.ship_date <> to_date('19000101', 'YYYYMMDD') then (f.price_amt + f.tax_amt) else 0 end) as service_sales 
, sum(case when i.merchandise_category <> 'Service' and f.ship_date <> to_date('19000101', 'YYYYMMDD') then (f.price_amt + f.tax_amt) else 0 end) as product_sales 
, sum(case when f.ship_date <> to_date('19000101', 'YYYYMMDD') then (f.price_amt + f.tax_amt) else 0 end) as total_sales 
, case when sum(case when f.ship_date <> to_date('19000101', 'YYYYMMDD') then (f.price_amt + f.tax_amt) else 0 end) - (sum(f.payment_amt) + sum(f.AR_WRITEOFF_AMT)) >= 0 then
          sum(case when f.ship_date <> to_date('19000101', 'YYYYMMDD') then (f.price_amt + f.tax_amt) else 0 end) - (sum(f.payment_amt) + sum(f.AR_WRITEOFF_AMT)) else 0 end as amount_due 
, case when sum(case when f.ship_date <> to_date('19000101', 'YYYYMMDD') then (f.price_amt + f.tax_amt) else 0 end) - (sum(f.payment_amt) + sum(f.AR_WRITEOFF_AMT)) <= 0 then
          (sum(f.payment_amt) + sum(f.AR_WRITEOFF_AMT)) - sum(case when f.ship_date <> to_date('19000101', 'YYYYMMDD') then (f.price_amt + f.tax_amt) else 0 end) else 0 end as deposit_amt 
, sum(f.AR_WRITEOFF_AMT) as AR_WRITEOFF_AMT           
, oh.OUT_OF_BALANCE_IND
from mart.consumer_sales_fact f 
, order_header oh 
, marketing m 
, organization o 
, item i 
, account a
, mart.apo
where f.order_header_id = oh.order_header_id 
and f.marketing_id = m.marketing_id 
and m.program_name = 'Seniors'
and o.country_name in ('CANADA','United States')
and f.job_ticket_org_id = o.organization_id 
and f.item_id = i.item_id 
--and oh.pay_status not in ('PAID','Paid')
and oh.source_system_name = 'YANTRA' 
and f.account_id = a.account_id
and f.apo_id = apo.apo_id
and f.source_system_name = 'YANTRA'
and oh.OUT_OF_BALANCE_IND = 'Y'  --284214
--and o.territory_code = 'CM'
--and oh.source_system_key in   ('2B6YZ2' ,'2GHBR9' ,'FVRYY' ,'29MZ69','2B6YZ2','3NF3W8', '3NFFKZ','3NG28Z','3NG2V9','3NGRX2','3V2G4Y','3V2KF7'                  )
and apo.SCHOOL_YEAR >= 2008
group by
    o.country_name
,  o.company_name
,  o.area_name
,  o.region_name
,  o.territory_code 
, Initcap(o.manager_first_name || ' ' || o.manager_last_name )
, m.program_name
, m.sub_program_name 
, oh.source_system_key 
, oh.photography_location
, oh.studio_code
, oh.order_sales_channel
, apo.territory_group_code
, apo.SCHOOL_YEAR
, a.account_name
, a.lifetouch_id
, initcap(a.address_line_1 || ' ' || a.city || ', ' || a.state || ' ' || a.postal_code)
, oh.OUT_OF_BALANCE_IND
having
 (sum(case when f.ship_date <> to_date('19000101', 'YYYYMMDD') then (f.price_amt + f.tax_amt) else 0 end)  - (sum(f.payment_amt) + sum(f.AR_WRITEOFF_AMT))) <> 0
--and sum(f.AR_WRITEOFF_AMT) <> 0
order by 
 apo.SCHOOL_YEAR
, oh.source_system_key
 ,oh.OUT_OF_BALANCE_IND
