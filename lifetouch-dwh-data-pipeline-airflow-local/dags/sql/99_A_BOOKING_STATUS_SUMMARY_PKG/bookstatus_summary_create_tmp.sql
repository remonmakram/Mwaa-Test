/*-----------------------------------------------*/
/* TASK No. 4 */
/* drop report table */

drop table RAX_APP_USER.actuate_bookstatsumm_stage

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* create report table */

create table RAX_APP_USER.actuate_bookstatsumm_stage as
SELECT asaf.program_id
, asaf.sales_line_id
, asaf.sub_program_id
, asaf.SUB_PROGRAM_NAME
, cov.TERRITORY_CODE
, cov.REGION_NAME
, cov.AREA_NAME
, cov.COUNTRY_NAME
, decode(cov.area_name,'Area 61','Pre-School','Area 62','Pre-School',cov.COMPANY_NAME) company_name
, cov.sales_rep_EMPLOYEE_CODE as sales_rep_code
, initcap(cov.sales_rep_name) sales_rep_name
, asaf.FISCAL_YEAR
, (asaf.fiscal_year - 1) || '-' || substr(asaf.fiscal_year,3,2) as school_year
, decode(to_date(:v_actuate_sysdate,'yyyymmdd'),to_date('19000101','yyyymmdd'),trunc(sysdate - 1),to_date(:v_actuate_sysdate,'yyyymmdd')) run_date
, SUM(asaf.Prior_year_accounts) as Prior_year_accounts
, SUM(asaf.rebooked_accounts)  as rebooked_accounts
, SUM(asaf.not_rebooked_accounts)  as not_rebooked_accounts
, SUM(asaf.new_accounts) as new_accounts
, sum(asaf.new_acquisition_accts) as new_acquisition_accts
, SUM(asaf.lost_accounts * -1) as lost_accounts
, SUM(asaf.booked_accounts) as booked_accounts
, SUM(asaf.booked_accounts_prior_week) as booked_accounts_prior_week
, SUM(asaf.ly_Prior_year_accounts) as ly_Prior_year_accounts
, SUM(asaf.ly_rebooked_accounts)  as ly_rebooked_accounts
, Sum(asaf.bid_accts) bid_accts
, sum(asaf.not_rebk_risk_accts) not_rebk_risk_accts
, sum(asaf.booked_risk_accts) booked_risk_accts
, SUM(asaf.prior_year_acct_pkgs) as prior_year_pkgs
, SUM(asaf.rebooked_pkgs) as rebooked_pkgs
, SUM(asaf.not_rebooked_pkgs) as not_rebooked_pkgs
, SUM(asaf.new_pkgs) as new_pkgs
, SUM(asaf.lost_pkgs * -1) as lost_pkgs
, SUM(asaf.new_pkgs + asaf.rebooked_pkgs + asaf.projected_pkgs_adj + asaf.shrink_pkgs) as booked_projected_pkgs
, SUM(asaf.new_pkgs_prior_week + asaf.rebooked_pkgs_prior_week + asaf.proj_pkgs_adj_prior_week + asaf.shrink_pkgs_prior_week) as booked_pkgs_prior_week
, SUM(asaf.projected_pkgs_adj) as projected_adj_pkgs
, sum(asaf.shrink_pkgs) shrink_pkgs
, SUM(asaf.ly_prior_year_acct_pkgs) as ly_prior_year_pkgs
, SUM(asaf.ly_rebooked_pkgs) as ly_rebooked_pkgs
, SUM(asaf.bid_pkgs) bid_pkgs
, sum(asaf.not_rebk_risk_pkgs) not_rebk_risk_pkgs
, sum(asaf.occurs) occurs
, 0 as all_flag
FROM CURRENT_assignment cov
, ( select
/*+ parallel(f,8) parallel(apy,8) parallel(a,8) */
      m.program_id
    , m.sales_line_id
    , m.sub_program_id
    , m.sub_program_name
    , f.fiscal_year fiscal_year
    , f.assignment_id
    ,sum(f.occurs) occurs
    ,SUM(case when bs.booking_status_name in ('Not Rebooked', 'Lost', 'Rebooked') and bs.PY_BOOKING_GROUP = 'Lifetouch Account'
                 then f.OCCURS else 0 end) as Prior_year_accounts
    ,SUM(CASE WHEN bs.booking_status_name = 'Rebooked'  THEN f.OCCURS ELSE 0 END) as rebooked_accounts
    ,SUM(CASE WHEN bs.booking_status_name = 'Not Rebooked'  THEN f.OCCURS ELSE 0 END) as not_rebooked_accounts
    ,SUM(CASE WHEN bs.booking_status_name = 'Not Rebooked' and apy.bid_ind = 'Y' THEN f.OCCURS ELSE 0 END) as bid_accts
    ,SUM(CASE WHEN bs.booking_status_name = 'Not Rebooked' and apy.at_risk_ind = 'Y' THEN f.OCCURS ELSE 0 END) as not_rebk_risk_accts
    ,SUM(CASE WHEN bs.booking_group = 'Booked' and apy.at_risk_ind = 'Y' THEN f.OCCURS ELSE 0 END) as booked_risk_accts
    ,SUM(CASE WHEN bs.booking_status_name = 'New Booked'  THEN f.OCCURS ELSE 0 END) as new_accounts
    ,SUM(CASE WHEN bs.booking_status_name = 'New Booked' and apy.incentive_acquisition_ind='Y' then f.OCCURS else 0 end) new_acquisition_accts
    ,SUM(CASE WHEN bs.booking_status_name = 'Lost' and bs.PY_BOOKING_GROUP = 'Lifetouch Account' THEN f.OCCURS ELSE 0 END) as lost_accounts
    ,SUM(CASE WHEN bs.booking_status_name = 'Lost' THEN f.proj_order_sales_amt ELSE 0 END) as ly_lost_cashretain
    ,SUM(CASE WHEN bs.booking_status_name in ('New Booked', 'Rebooked')
                 THEN f.OCCURS ELSE 0 END) as booked_accounts
    ,SUM(CASE WHEN bs.booking_status_name in ('New Booked', 'Rebooked') and
                f.trans_date < trunc(cfy.week_ending - 7)
                  THEN f.OCCURS ELSE 0 END) as booked_accounts_prior_week
    , sum(0) ly_prior_year_accounts
    , sum(0) ly_rebooked_accounts
    ,sum(f.projected_pkgs) projected_pkgs
    ,sum(f.prior_year_job_pkgs) prior_year_job_pkgs
    ,sum(f.prior_year_account_pkgs) prior_year_acct_pkgs
    ,SUM(CASE WHEN bs.booking_status_name = 'Rebooked' THEN f.prior_year_account_pkgs ELSE 0 END) as rebooked_pkgs
    ,SUM(CASE WHEN bs.booking_status_name = 'Not Rebooked'  and apy.bid_ind = 'Y' THEN f.prior_year_account_pkgs ELSE 0 END) as bid_pkgs
    ,SUM(CASE WHEN bs.booking_status_name = 'Not Rebooked'  and apy.at_risk_ind = 'Y' THEN f.PROJECTED_PKGS ELSE 0 END) as not_rebk_risk_pkgs
    ,SUM(CASE WHEN bs.booking_status_name = 'Not Rebooked' THEN f.prior_year_account_pkgs ELSE 0 END) as not_rebooked_pkgs
    ,SUM(CASE WHEN bs.booking_status_name = 'New Booked' THEN f.PROJECTED_PKGS ELSE 0 END) as new_pkgs
    ,SUM(CASE WHEN bs.booking_status_name = 'Lost' and bs.PY_BOOKING_GROUP = 'Lifetouch Account' THEN f.PROJECTED_PKGS ELSE 0 END) as lost_pkgs
     ,SUM(CASE WHEN bs.booking_status_name = 'Lost' THEN f.proj_order_sales_amt ELSE 0 END) as ly_lost_cashretain
     ,sum(CASE WHEN bs.booking_status_name = 'Rebooked' THEN f.projected_pkgs - f.prior_year_account_pkgs else 0 end) projected_pkgs_adj
    , sum(CASE WHEN bs.booking_status_name = 'Rebooked' THEN f.shrink_pkgs else 0 end) shrink_pkgs
    , SUM(CASE WHEN (bs.booking_status_name in ('Rebooked') and
               f.trans_date < trunc(cfy.week_ending - 7) )
                 THEN f.prior_year_account_pkgs ELSE 0 END) as rebooked_pkgs_prior_week
    , SUM(CASE WHEN (bs.booking_status_name in ('New Booked') and
               f.trans_date < trunc(cfy.week_ending - 7) )
                 THEN f.PROJECTED_PKGS ELSE 0 END) as new_pkgs_prior_week
    , SUM(CASE WHEN  bs.booking_status_name = 'Rebooked' and f.trans_date < trunc(cfy.week_ending - 7)
                 THEN f.shrink_pkgs ELSE 0 END) as shrink_pkgs_prior_week
    , SUM(CASE WHEN  f.trans_date < trunc(cfy.week_ending - 7)
                 THEN f.projected_pkgs ELSE 0 END) as proj_pkgs_prior_week
    , SUM(CASE WHEN bs.booking_status_name in ('Rebooked')  and f.trans_date < trunc(cfy.week_ending - 7)
                 THEN f.projected_pkgs - f.prior_year_account_pkgs ELSE 0 END) as proj_pkgs_adj_prior_week
    ,sum(0) ly_prior_year_acct_pkgs
    ,SUM(0) as ly_rebooked_pkgs
    from apy_booking_FACT f
    , x_booking_status bs
    , marketing m
    , apy apy
    , account a
    , (select (case when to_number(:v_actuate_fiscal_year) = 9999 then fiscal_year else to_number(:v_actuate_fiscal_year) end) fiscal_year, date_key, week_ending
                from time
               where decode(to_date(:v_actuate_sysdate,'yyyymmdd'),to_date('19000101','yyyymmdd'),trunc(sysdate - 1),to_date(:v_actuate_sysdate,'yyyymmdd')) = date_key
             ) cfy
    where f.marketing_id = m.marketing_id
    and f.apy_booking_status_id = bs.x_booking_status_id
    and f.apy_id = apy.apy_id
    and apy.active_ind = 'A'
    and f.account_id = a.account_id
    and a.active_account_ind = 'A'
    and a.account_subcategory_name not in ('House Account', 'HOUSE', 'House')
    and f.fiscal_year in (cfy.fiscal_year, cfy.fiscal_year + 1)
    and f.trans_date <= cfy.date_key
    group by
      m.program_id
     , m.sales_line_id
     , m.sub_program_id
    , m.sub_program_name
    , f.fiscal_year
    , f.assignment_id
having sum(f.occurs) > 0
 union all
select
/*+ parallel(f,8) parallel(apy,8) parallel(a,8) */
      m.program_id
     , m.sales_line_id
    , m.sub_program_id
    , m.sub_program_name
    , (f.fiscal_year + 1) fiscal_year
    , f.assignment_id
    ,sum(0) occurs
    ,SUM(0) as Prior_year_accounts
    ,SUM(0) as rebooked_accounts
    ,SUM(0) as not_rebooked_accounts
    ,SUM(0) as bid_accts
    ,SUM(0) as not_rebk_risk_accts
    ,SUM(0) as booked_risk_accts
    ,SUM(0) as new_accounts
    ,SUM(0) as new_acquisition_accts
    ,SUM(0) as lost_accounts
    ,SUM(0) as ly_lost_cashretain
    ,SUM(0) as booked_accounts
    ,SUM(0) as booked_accounts_prior_week
    ,SUM(case when f.trans_date <= cfy.prior_year_equiv_date and
                 bs.booking_status_name in ('Not Rebooked', 'Lost', 'Rebooked') and bs.PY_BOOKING_GROUP = 'Lifetouch Account'
                 then f.OCCURS else 0 end) as ly_prior_year_accounts
    ,SUM(CASE WHEN bs.booking_status_name = 'Rebooked'  and f.trans_date <= cfy.prior_year_equiv_date THEN f.OCCURS ELSE 0 END) as ly_rebooked_accounts
    ,sum(0) projected_pkgs
    ,sum(0) prior_year_job_pkgs
    ,sum(0) prior_year_acct_pkgs
    ,SUM(0) as rebooked_pkgs
    ,SUM(0) as bid_pkgs
    ,SUM(0) as not_rebk_risk_pkgs
    ,SUM(0) as not_rebooked_pkgs
    ,SUM(0) as new_pkgs
    ,SUM(0) as lost_pkgs
    ,SUM(0) as ly_lost_cashretain
    , sum(0) as projected_pkgs_adj
    , sum(0) shrink_pkgs
    , sum(0) rebooked_pkgs_prior_week
    , sum(0) new_pkgs_prior_week
    , sum(0) shrink_pkgs_pkgs_prior_week
    , sum(0) proj_pkgs_prior_week
    , sum(0)  proj_pkgs_adj_prior_week
    ,sum(CASE WHEN f.trans_date <= cfy.prior_year_equiv_date and bs.py_booking_group = 'Lifetouch Account' THEN f.prior_year_account_pkgs else 0 end) ly_prior_year_acct_pkgs
    ,SUM(CASE WHEN bs.booking_status_name = 'Rebooked' and f.trans_date <= cfy.prior_year_equiv_date THEN  f.prior_year_account_pkgs ELSE 0 END) as ly_rebooked_pkgs
    from apy_booking_FACT f
    , x_booking_status bs
    , marketing m
    , apy apy
    , account a
    , (select (case when to_number(:v_actuate_fiscal_year) = 9999 then fiscal_year else to_number(:v_actuate_fiscal_year) end) fiscal_year, date_key,  prior_year_equiv_date
                from time
               where decode(to_date(:v_actuate_sysdate,'yyyymmdd'),to_date('19000101','yyyymmdd'),trunc(sysdate - 1),to_date(:v_actuate_sysdate,'yyyymmdd')) = date_key
             ) cfy
    where f.marketing_id = m.marketing_id
    and f.apy_booking_status_id = bs.x_booking_status_id
    and f.apy_id = apy.apy_id
    and apy.active_ind = 'A'
    and f.account_id = a.account_id
    and a.active_account_ind = 'A'
    and a.account_subcategory_name not in ('House Account', 'HOUSE', 'House')
    and f.fiscal_year in (cfy.fiscal_year, cfy.fiscal_year - 1)
    and f.trans_date <= cfy.date_key
    group by
      m.program_id
     , m.sales_line_id
     , m.sub_program_id
    , m.sub_program_name
    , (f.fiscal_year + 1)
    , f.assignment_id
having sum(f.occurs) > 0
  ) asaf
WHERE
asaf.ASSIGNMENT_ID = cov.assignment_ID
and upper(cov.REGION_NAME) not in ('REGION 61','REGION 62','REGION 63','REGION 64','REGION 91','REGION 99','UNKNOWN')
and asaf.sub_program_name not in ('Money Trans','Unclassified')
-- and ((asaf.program_id <> 11) or (asaf.program_id = 11 and asaf.sub_program_id in (10016, 10060)))  /* exclude  Seniors, except seniors lite, GMIT */
GROUP BY asaf.program_id
, asaf.sales_line_id
, asaf.sub_program_id
, asaf.SUB_PROGRAM_NAME
, cov.TERRITORY_CODE
, cov.REGION_NAME
, cov.AREA_NAME
, cov.COUNTRY_NAME
, decode(cov.area_name,'Area 61','Pre-School','Area 62','Pre-School',cov.COMPANY_NAME)
, cov.sales_rep_EMPLOYEE_CODE
, initcap(cov.sales_rep_name)
, asaf.FISCAL_YEAR
, (asaf.fiscal_year - 1) || '-' || substr(asaf.fiscal_year,3,2)
having sum(asaf.occurs) > 0
