/*-----------------------------------------------*/
/* TASK No. 49 */
/* PY measures from ESF */

merge into ODS_OWN.apy t
using
(
select a.lifetouch_id
, m.sub_program_name
, e.school_year
,sum(f.SHIPPED_ORDER_QTY) SHIPPED_ORDER_QTY
,sum(f.CALCULATED_PAID_ORDER_QTY) PAID_ORDER_QTY
,sum(f.TRANSACTION_AMT) GROSS_AMT
,sum(f.ORDER_SALES_AMT) NET_AMT
,sum(f.PHOTO_SESSION_QTY) PHOTO_SESSION_QTY
,0 SIT_QTY
,0 SIT_REVENUE_AMT
from event_sales_fact f
,event e
,account a
,marketing m
,time t
where f.event_id = e.event_id
and f.account_id = a.account_id
and f.marketing_id = m.marketing_id
and a.account_subcategory_name not in( 'HOUSE','House')
and e.job_classification_name <> 'Service Only'
and m.program_name not in ('Yearbook','Preschool')
and t.date_key = trunc(sysdate)
and e.school_year >= t.fiscal_year
and f.trans_date >= t.fiscal_year_begin_date
group by a.lifetouch_id
, m.sub_program_name
, e.school_year
) s
on
( s.lifetouch_id = t.lifetouch_id
and s.sub_program_name = t.sub_program_name
and (s.school_year + 1) = t.school_year
)
when matched then update
set t.PRIOR_YEAR_PKGS = s.shipped_order_qty
, t.PRIOR_YEAR_ORDER_SALES_AMT = s.net_amt
, t.PRIOR_YEAR_PAID_PKGS = s.paid_order_qty
, t.PRIOR_YEAR_PHOTO_SESSION_QTY = s.photo_session_qty
, t.PRIOR_YEAR_SIT_QTY = s.sit_qty
, t.PRIOR_YEAR_SIT_REVENUE_AMT = s.sit_revenue_amt
, t.PRIOR_YEAR_TRANSACTION_AMT = s.gross_amt
, t.ods_modify_date = sysdate
where decode(t.PRIOR_YEAR_PKGS, s.shipped_order_qty, 1,0) = 0
or decode(t.PRIOR_YEAR_ORDER_SALES_AMT, s.net_amt, 1,0) = 0
or decode(t.PRIOR_YEAR_PAID_PKGS, s.paid_order_qty, 1,0) = 0
or decode(t.PRIOR_YEAR_PHOTO_SESSION_QTY, s.photo_session_qty, 1,0) = 0
or decode(t.PRIOR_YEAR_SIT_QTY, s.sit_qty, 1,0) = 0
or decode(t.PRIOR_YEAR_SIT_REVENUE_AMT, s.sit_revenue_amt, 1,0) = 0
or decode(t.PRIOR_YEAR_TRANSACTION_AMT, s.gross_amt, 1,0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 50 */
/* PY measures from YBF */

merge into ODS_OWN.apy t
using
(
select a.lifetouch_id
, m.sub_program_name
, apo.school_year
,sum(f.COPY_QTY) SHIPPED_ORDER_QTY
,sum(f.COPY_QTY) PAID_ORDER_QTY
,sum(f.payments_received) GROSS_AMT
,sum(f.payments_received) NET_AMT
,0 PHOTO_SESSION_QTY
,0 SIT_QTY
,0 SIT_REVENUE_AMT
from yearbook_fact f
,apo
,account a
,marketing m
,time t
where f.apo_id = apo.apo_id
and f.account_id = a.account_id
and f.marketing_id = m.marketing_id
and a.account_subcategory_name not in( 'HOUSE','House')
and m.sub_program_name = 'Yearbook'
and t.date_key = trunc(sysdate)
and apo.school_year >= t.fiscal_year - 1
and f.trans_date >= t.fiscal_year_begin_date - 365
group by a.lifetouch_id
, m.sub_program_name
, apo.school_year
) s
on
( s.lifetouch_id = t.lifetouch_id
and s.sub_program_name = t.sub_program_name
and (s.school_year + 1) = t.school_year
)
when matched then update
set t.PRIOR_YEAR_PKGS = s.shipped_order_qty
, t.PRIOR_YEAR_ORDER_SALES_AMT = s.net_amt
, t.PRIOR_YEAR_PAID_PKGS = s.paid_order_qty
, t.PRIOR_YEAR_PHOTO_SESSION_QTY = s.photo_session_qty
, t.PRIOR_YEAR_SIT_QTY = s.sit_qty
, t.PRIOR_YEAR_SIT_REVENUE_AMT = s.sit_revenue_amt
, t.PRIOR_YEAR_TRANSACTION_AMT = s.gross_amt
, t.ods_modify_date = sysdate
where decode(t.PRIOR_YEAR_PKGS, s.shipped_order_qty, 1,0) = 0
or decode(t.PRIOR_YEAR_ORDER_SALES_AMT, s.net_amt, 1,0) = 0
or decode(t.PRIOR_YEAR_PAID_PKGS, s.paid_order_qty, 1,0) = 0
or decode(t.PRIOR_YEAR_PHOTO_SESSION_QTY, s.photo_session_qty, 1,0) = 0
or decode(t.PRIOR_YEAR_SIT_QTY, s.sit_qty, 1,0) = 0
or decode(t.PRIOR_YEAR_SIT_REVENUE_AMT, s.sit_revenue_amt, 1,0) = 0
or decode(t.PRIOR_YEAR_TRANSACTION_AMT, s.gross_amt, 1,0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 51 */
/* PY measures from SF for Seniors */

merge into ODS_OWN.apy t
using
(
select a.lifetouch_id
, m.sub_program_name
, f.school_year
,sum(f.ORDER_SUBJ_QTY) SHIPPED_ORDER_QTY
,sum(f.ORDER_SUBJ_QTY) PAID_ORDER_QTY
,sum(case when j.SALES_CATEGORY='Product' then f.PRICE_AMT else 0 end) GROSS_AMT
,sum(case when j.SALES_CATEGORY='Product' then f.PRICE_AMT else 0 end) NET_AMT
,0 PHOTO_SESSION_QTY
,sum(f.photo_subj_qty) SIT_QTY
,sum(case when j.SALES_CATEGORY='Service' then f.PRICE_AMT else 0 end) SIT_REVENUE_AMT
from summary_fact f
,account a
,marketing m
,summary_junk_dim j
,time t
where f.account_id = a.account_id
and f.marketing_id = m.marketing_id
and f.summary_junk_id = j.summary_junk_id
and a.account_subcategory_name not in( 'HOUSE','House')
and m.program_name = 'Seniors'
and t.date_key = trunc(sysdate)
and f.school_year >= t.fiscal_year - 1
and f.trans_date >= t.fiscal_year_begin_date - 500
group by a.lifetouch_id
, m.sub_program_name
, f.school_year
) s
on
( s.lifetouch_id = t.lifetouch_id
and s.sub_program_name = t.sub_program_name
and (s.school_year + 1) = t.school_year
)
when matched then update
set t.PRIOR_YEAR_PKGS = s.shipped_order_qty
, t.PRIOR_YEAR_ORDER_SALES_AMT = s.net_amt
, t.PRIOR_YEAR_PAID_PKGS = s.paid_order_qty
, t.PRIOR_YEAR_PHOTO_SESSION_QTY = s.photo_session_qty
, t.PRIOR_YEAR_SIT_QTY = s.sit_qty
, t.PRIOR_YEAR_SIT_REVENUE_AMT = s.sit_revenue_amt
, t.PRIOR_YEAR_TRANSACTION_AMT = s.gross_amt
, t.ods_modify_date = sysdate
where decode(t.PRIOR_YEAR_PKGS, s.shipped_order_qty, 1,0) = 0
or decode(t.PRIOR_YEAR_ORDER_SALES_AMT, s.net_amt, 1,0) = 0
or decode(t.PRIOR_YEAR_PAID_PKGS, s.paid_order_qty, 1,0) = 0
or decode(t.PRIOR_YEAR_PHOTO_SESSION_QTY, s.photo_session_qty, 1,0) = 0
or decode(t.PRIOR_YEAR_SIT_QTY, s.sit_qty, 1,0) = 0
or decode(t.PRIOR_YEAR_SIT_REVENUE_AMT, s.sit_revenue_amt, 1,0) = 0
or decode(t.PRIOR_YEAR_TRANSACTION_AMT, s.gross_amt, 1,0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 52 */
/* update no projection rule */

update ODS_OWN.apy
set no_projection_rule = 'Y'
where  no_projection_rule <> 'Y'
and exists
(
select 1
from mart.account a
where apy.lifetouch_id = a.lifetouch_id
and apy.school_year >= ( select fiscal_year from mart.time where date_key = trunc(sysdate) )
and (    a.Account_Category_Name In ('Administrative Group', 'Business/Commercial', 'House', 'OTH', 'SCHL', 'Unknown')
      or a.account_subcategory_name in ('Church')
      or (a.Account_Category_Name In ('Organization or Club', 'Other') And a.Enrollment_Count > 50000)
      or ((a.Account_Category_Name In ('School') Or a.Account_Subcategory_Name In ('Special School')) And a.Enrollment_Count > 10000)
      or (a.Account_Category_Name In ('Preschool') And a.Enrollment_Count > 5000)
      or (a.Account_Subcategory_Name in ('Post Secondary') and a.enrollment_count > 100000)
    )
)

&


/*-----------------------------------------------*/
/* TASK No. 53 */
/* update APY with Shrink and Projections */

merge into ODS_OWN.apy t
using
(
select apy2.apy_oid
,round(case when apy2.prior_year_pkgs is null then 0 else (apy2.prior_year_pkgs) *
                 nvl(sfrt.SHIPPED_ORDER_SHRINK_PCT,nvl(sfrr.SHIPPED_ORDER_SHRINK_PCT,nvl(sfra.SHIPPED_ORDER_SHRINK_PCT,0))) end,5) as SHRINK_PKGS
,round(case when apy2.prior_year_paid_pkgs is null then 0 else (apy2.prior_year_paid_pkgs) *
                 nvl(sfrt.PAID_ORDER_SHRINK_PCT,nvl(sfrr.PAID_ORDER_SHRINK_PCT,nvl(sfra.PAID_ORDER_SHRINK_PCT,0))) end,5) as SHRINK_PAID_PKGS
,round(case when apy2.prior_year_paid_pkgs is null then 0 else (apy2.prior_year_paid_pkgs) *
                 nvl(sfrt.GROSS_ORDER_AVG,nvl(sfrr.GROSS_ORDER_AVG,nvl(sfra.GROSS_ORDER_AVG,0))) *
                 nvl(sfrt.PAID_ORDER_SHRINK_PCT,nvl(sfrr.PAID_ORDER_SHRINK_PCT,nvl(sfra.PAID_ORDER_SHRINK_PCT,0))) end,5) as shrink_transaction_amt
,round(case when apy2.prior_year_paid_pkgs is null then 0 else (apy2.prior_year_paid_pkgs) *
                 nvl(sfrt.NET_ORDER_AVG,nvl(sfrr.NET_ORDER_AVG,nvl(sfra.NET_ORDER_AVG,0))) *
                 nvl(sfrt.PAID_ORDER_SHRINK_PCT,nvl(sfrr.PAID_ORDER_SHRINK_PCT,nvl(sfra.PAID_ORDER_SHRINK_PCT,0)))  end,5) as shrink_order_sales_amt
,round(case when apy2.prior_year_photo_session_qty is null then 0 else (apy2.prior_year_photo_session_qty) *
                 Nvl(sfrt.PHOTO_SESSION_SHRINK_PCT,Nvl(sfrr.PHOTO_SESSION_SHRINK_PCT,Nvl(sfra.PHOTO_SESSION_SHRINK_PCT,0))) end,5) as shrink_photo_session_qty
,0 as shrink_gross_amt
,0 as shrink_net_amt
,round(case when apy2.active_account_ind = 'I' then 0
            when apy2.no_projection_rule = 'Y' or apy2.selling_method_name = apy2.py_selling_methods then apy2.prior_year_pkgs
            else apy2.enrollment *  nvl(prcu.SHIPPED_PKGS_PROJECTION_RATE,0) end,5) as projected_pkgs
,round(case when apy2.active_account_ind = 'I' then 0
            when apy2.no_projection_rule = 'Y' or apy2.selling_method_name = apy2.py_selling_methods then apy2.prior_year_paid_pkgs
            else apy2.enrollment *  nvl(prcu.PAID_PKGS_PROJECTION_RATE,0) end,5) as projected_paid_pkgs
,round(case when apy2.active_account_ind = 'I' then 0
            when apy2.no_projection_rule = 'Y' or apy2.selling_method_name = apy2.py_selling_methods then apy2.prior_year_transaction_amt
            else apy2.enrollment *  nvl(prcu.GROSS_CASH_PROJECTION_RATE,0) end,5) as proj_transaction_amt
,round(case when apy2.active_account_ind = 'I' then 0
            when apy2.no_projection_rule = 'Y' or apy2.selling_method_name = apy2.py_selling_methods then apy2.prior_year_order_sales_amt
            else apy2.enrollment *  nvl(prcu.CASH_RETAINED_PROJECTION_RATE,0) end,5) as proj_order_sales_amt
,round(case when apy2.active_account_ind = 'I' then 0
            when apy2.no_projection_rule = 'Y' or apy2.selling_method_name = apy2.py_selling_methods then apy2.prior_year_sit_qty
            else apy2.enrollment *  nvl(prcu.sit_volume,0) end,5) as proj_sit_qty
,round(case when apy2.active_account_ind = 'I' then 0
            when apy2.no_projection_rule = 'Y' or apy2.selling_method_name = apy2.py_selling_methods then apy2.prior_year_sit_revenue_amt
            else apy2.enrollment *  nvl(prcu.SIT_DOLLAR,0) end,5) as proj_sit_revenue_amt
,round(case when apy2.active_account_ind = 'I' then 0
            when apy2.no_projection_rule = 'Y' or apy2.selling_method_name = apy2.py_selling_methods then apy2.prior_year_photo_session_qty
            else apy2.enrollment *  nvl(prcu.photo_session_qty_proj_rate,0) end,5) as proj_photo_session_qty
from
(
select o.region_name
, o.area_name
, sp.sub_program_id
, a.active_account_ind
, a.account_subcategory_name
, case when p.program_name = 'Senior/Studio Style' then a.nacam_seniors_class_name else a.nacam_overall_class_name end as nacam_classification_name
, case when sm.selling_method is not null then sm.selling_method
       when sp.sub_program_id = 1 and a.country = 'Canada' then 'Proof'
       when sp.sub_program_id = 1 and a.country <> 'Canada' then 'PrePay'
       when sp.sub_program_id in (2,5,6,8,21,22,23,10001,10003,10004,10005,10006,10007,10010,10011) then 'PrePay'
       when sp.sub_program_id in (7,10080) then 'PrePay'
       when sp.sub_program_id in (10,10002,10008,10012,10014) then 'YB Not Direct to Parent'
       when sp.sub_program_id in (11,1012,1094,10013,10016,10040,10060,10100,10120,10140) then 'Proof'
       when sp.sub_program_id = 10009 and a.country = 'Canada' then 'Proof'
       when sp.sub_program_id = 10009 and a.country <> 'Canada' then 'PrePay'
  else null -- there is only shrink for PrePay, Proof, and Spec.  Not sure why we bother with YB above - just copying from AMS ETL
  end as selling_method_name
, apy.*
from ODS_OWN.apy
, ODS_OWN.selling_method sm
, MART.organization o
, MART.account a
, ODS_OWN.sub_program sp
, ODS_OWN.program p
where apy.selling_methods = sm.selling_method(+)
and apy.booked_by_territory_code = o.territory_code(+)
and apy.lifetouch_id = a.lifetouch_id
and apy.sub_program_oid = sp.sub_program_oid
and sp.program_oid = p.program_oid
) apy2
, ods.shrink_rates sfrt
, ods.shrink_rates sfrr
, ods.shrink_rates sfra
, ods.selling_method_xref smxr
, ods.participation_rates_curr prcu
where 1=1
and apy2.school_YEAR = sfrt.FISCAL_YEAR(+)
and apy2.booked_by_TERRITORY_CODE = sfrt.TERRITORY_CODE(+)
and apy2.SUB_PROGRAM_ID = sfrt.SUB_PROGRAM_ID(+)
and apy2.SELLING_METHOD_NAME = sfrt.SELLING_METHOD_NAME(+)
and apy2.school_YEAR = sfrr.FISCAL_YEAR(+)
and apy2.REGION_NAME = sfrr.TERRITORY_CODE(+)
and apy2.SUB_PROGRAM_ID = sfrr.SUB_PROGRAM_ID(+)
and apy2.SELLING_METHOD_NAME = sfrr.SELLING_METHOD_NAME(+)
and apy2.school_YEAR = sfra.FISCAL_YEAR(+)
and apy2.AREA_NAME = sfra.TERRITORY_CODE(+)
and apy2.SUB_PROGRAM_ID = sfra.SUB_PROGRAM_ID(+)
and apy2.SELLING_METHOD_NAME = sfra.SELLING_METHOD_NAME(+)
and apy2.school_year = prcu.fiscal_year(+)
and apy2.booked_by_territory_code = prcu.organization_code(+)
and apy2.sub_program_id = prcu.sub_program_id(+)
and apy2.selling_method_name = smxr.selling_method_name(+)
and smxr.selling_method_code = prcu.selling_method_code(+) -- single character codes (N,D,P,S,F...)
and apy2.account_subcategory_name = prcu.account_subcategory_name(+)
and apy2.nacam_classification_name = prcu.NACAM_CLASSIFICATION_NAME(+)
) s
on ( t.apy_oid = s.apy_oid )
when matched then update
set t.PROJECTED_PAID_PKGS = s.projected_paid_pkgs
, t.PROJECTED_PKGS = s.projected_pkgs
, t.PROJ_ORDER_SALES_AMT = s.proj_order_sales_amt
, t.PROJ_PHOTO_SESSION_QTY = s.proj_photo_session_qty
, t.PROJ_SIT_QTY = s.proj_sit_qty
, t.PROJ_SIT_REVENUE_AMT = s.proj_sit_revenue_amt
, t.PROJ_TRANSACTION_AMT = s.proj_transaction_amt
, t.SHRINK_GROSS_AMT = s.shrink_gross_amt
, t.SHRINK_NET_AMT = s.shrink_net_amt
, t.SHRINK_ORDER_SALES_AMT = s.shrink_order_sales_amt
, t.SHRINK_PAID_PKGS = s.shrink_paid_pkgs
, t.SHRINK_PHOTO_SESSION_QTY = s.shrink_photo_session_qty
, t.SHRINK_PKGS = s.shrink_pkgs
, t.SHRINK_TRANSACTION_AMT = s.shrink_transaction_amt
, t.ods_modify_date = sysdate
where decode(t.PROJECTED_PAID_PKGS , s.projected_paid_pkgs,1,0) = 0
or decode(t.PROJECTED_PKGS , s.projected_pkgs,1,0) = 0
or decode(t.PROJ_ORDER_SALES_AMT , s.proj_order_sales_amt,1,0) = 0
or decode(t.PROJ_PHOTO_SESSION_QTY , s.proj_photo_session_qty,1,0) = 0
or decode(t.PROJ_SIT_QTY , s.proj_sit_qty,1,0) = 0
or decode(t.PROJ_SIT_REVENUE_AMT , s.proj_sit_revenue_amt,1,0) = 0
or decode(t.PROJ_TRANSACTION_AMT , s.proj_transaction_amt,1,0) = 0
or decode(t.SHRINK_GROSS_AMT , s.shrink_gross_amt,1,0) = 0
or decode(t.SHRINK_NET_AMT , s.shrink_net_amt,1,0) = 0
or decode(t.SHRINK_ORDER_SALES_AMT , s.shrink_order_sales_amt,1,0) = 0
or decode(t.SHRINK_PAID_PKGS , s.shrink_paid_pkgs,1,0) = 0
or decode(t.SHRINK_PHOTO_SESSION_QTY , s.shrink_photo_session_qty,1,0) = 0
or decode(t.SHRINK_PKGS , s.shrink_pkgs,1,0) = 0
or decode(t.SHRINK_TRANSACTION_AMT , s.shrink_transaction_amt,1,0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 54 */
/* Merge MART APY */

merge into MART.apy t
using
(
select apy.lifetouch_id
, apy.sub_program_name
, apy.school_year
, nvl(apy.at_risk_ind,'.') as at_risk_ind
, apy.booking_status
, nvl(apy.booked_by_territory_code,'.') as booked_by_territory_code
, nvl(e.vision_employee_code,'.') as vision_employee_code
, nvl(apy.selling_methods, 'Unknown') as selling_methods
, nvl(apy.py_selling_methods, 'Unknown') as py_selling_methods
, sp.sub_program_id
, nvl(me.employee_id,0) as employee_id
, nvl(apy.booked_by_firstname, '.') as booked_by_firstname
, nvl(apy.booked_by_lastname, '.') as booked_by_lastname
, apy.x_booking_status_id
, case when apy.booking_status in ('Lost') and bo.lost_reason_code is not null then bo.lost_reason_code else '.' end as lost_reason_code
, case when apy.booking_status in ('Lost') and bo.lost_reason_text is not null then bo.lost_reason_text else '.' end as lost_reason_text
, apy.most_Recent_agreement_status
from ODS_OWN.apy
, ods_own.employee e
, ODS_OWN.sub_program sp
, mart.employee me
, ods_own.booking_opportunity bo
where apy.booked_by_employee_oid = e.employee_oid(+)
and apy.sub_program_name = sp.sub_program_name
and e.employee_oid = me.employee_oid(+)
and apy.booking_opportunity_oid = bo.booking_opportunity_oid(+)
and sp.sub_program_id is not null -- needed for TDW as column not populated - need to fix that and remove...
and apy.school_year > 2022
and apy.ods_modify_date > sysdate - 10 -- need proper CDC
) s
on
( s.lifetouch_id = t.lifetouch_id
and s.sub_program_name = t.sub_program_name
and s.school_year = t.fiscal_year
)
when matched then update
set t.effective_date = sysdate
, t.at_risk_ind = s.at_risk_ind
, t.booking_status = s.booking_status
, t.territory_code = s.booked_by_territory_code
, t.vision_employee_code = s.vision_employee_code
, t.current_year_selling_methods = s.selling_methods
, t.prior_year_selling_methods = s.py_selling_methods
, t.sub_program_id = s.sub_program_id
, t.booked_by_rep_id = s.employee_id
, t.booked_by_firstname = s.booked_by_firstname
, t.booked_by_lastname = s.booked_by_lastname
, t.booked_by_territory_code = s.booked_by_territory_code
, t.lost_by_rep_id = case when s.booking_status = 'Lost' then s.employee_id else -1 end
, t.lost_by_firstname = case when s.booking_status = 'Lost' then s.booked_by_firstname else '.' end
, t.lost_by_lastname = case when s.booking_status = 'Lost' then s.booked_by_lastname else '.' end
, t.lost_by_territory_code = case when s.booking_status = 'Lost' then s.booked_by_territory_code else '.' end
, t.x_booking_status_id = s.x_booking_status_id
, t.lost_reason_code_name = s.lost_reason_code
, t.lost_reason_text_name = s.lost_reason_text
, t.most_Recent_agreement_status = s.most_Recent_agreement_status
where decode(t.at_risk_ind , s.at_risk_ind ,1,0) = 0
or decode(t.booking_status , s.booking_status ,1,0) = 0
or decode(t.territory_code , s.booked_by_territory_code ,1,0) = 0
or decode(t.vision_employee_code , s.vision_employee_code ,1,0) = 0
or decode(t.current_year_selling_methods , s.selling_methods ,1,0) = 0
or decode(t.prior_year_selling_methods , s.py_selling_methods ,1,0) = 0
or decode(t.sub_program_id , s.sub_program_id ,1,0) = 0
or decode(t.booked_by_rep_id , s.employee_id ,1,0) = 0
or decode(t.booked_by_firstname , s.booked_by_firstname ,1,0) = 0
or decode(t.booked_by_lastname , s.booked_by_lastname ,1,0) = 0
or decode(t.booked_by_territory_code , s.booked_by_territory_code ,1,0) = 0
or decode(t.lost_by_rep_id , case when s.booking_status = 'Lost' then s.employee_id else -1 end,1,0) = 0
or decode(t.lost_by_firstname , case when s.booking_status = 'Lost' then s.booked_by_firstname else '.' end,1,0) = 0
or decode(t.lost_by_lastname , case when s.booking_status = 'Lost' then s.booked_by_lastname else '.' end,1,0) = 0
or decode(t.lost_by_territory_code , case when s.booking_status = 'Lost' then s.booked_by_territory_code else '.' end,1,0) = 0
or decode(t.x_booking_status_id , s.x_booking_status_id ,1,0) = 0
or decode(t.lost_reason_code_name , s.lost_reason_code,1,0) = 0
or decode(t.lost_reason_text_name , s.lost_reason_text,1,0) = 0
or decode(t.most_Recent_agreement_status , s.most_Recent_agreement_status,1,0) = 0
when not matched then insert
(t.APY_ID
,t.EFFECTIVE_DATE
,t.LOAD_ID
,t.ACTIVE_IND
,t.LIFETOUCH_ID
,t.SUB_PROGRAM_NAME
,t.FISCAL_YEAR
,t.AT_RISK_IND
,t.BOOKING_STATUS
,t.TERRITORY_CODE
,t.VISION_EMPLOYEE_CODE
,t.CURRENT_YEAR_SELLING_METHODS
,t.PRIOR_YEAR_SELLING_METHODS
,t.SUB_PROGRAM_ID
,t.BOOKED_BY_REP_ID
,t.BOOKED_BY_FIRSTNAME
,t.BOOKED_BY_LASTNAME
,t.BOOKED_BY_TERRITORY_CODE
,t.LOST_BY_REP_ID
,t.LOST_BY_FIRSTNAME
,t.LOST_BY_LASTNAME
,t.LOST_BY_TERRITORY_CODE
,t.X_BOOKING_STATUS_ID
,t.bid_ind
,t.INCENTIVE_ACQUISITION_IND
,t.ACQUIRED_BUSINESS_NAME
,t.ACQUISITION_DATE
,t.RETENTION_CODE
,t.CURRENT_YEAR_MKT_CODES
,t.PRIOR_YEAR_MKT_CODES
,t.BOOKING_STATUS_REASON_ID
,t.LOST_TO_COMPETITOR_ID
,t.AT_RISK_REASON_ID
,t.AT_RISK_COMPETITOR_ID
,t.lost_reason_code_name
,t.lost_reason_text_name
,t.most_Recent_agreement_status
)
values
(mart.apy_id_seq.nextval
,sysdate
,1
,'A'
,s.lifetouch_id
,s.sub_program_name
,s.school_year
,s.at_risk_ind
,s.booking_status
,s.booked_by_territory_code
,s.vision_employee_code
,s.selling_methods
,s.py_selling_methods
,s.sub_program_id
,s.employee_id
,s.booked_by_firstname
,s.booked_by_lastname
,s.booked_by_territory_code
,case when s.booking_status = 'Lost' then s.employee_id else -1 end
,case when s.booking_status = 'Lost' then s.booked_by_firstname else '.' end
,case when s.booking_status = 'Lost' then s.booked_by_lastname else '.' end
,case when s.booking_status = 'Lost' then s.booked_by_territory_code else '.' end
,s.x_booking_status_id
,0
,'N'
,'NA'
,to_date('19000101','YYYYMMDD')
,'NA'
,'.'
,'.'
,0
,0
,0
,0
,s.lost_reason_code
,s.lost_reason_text
,s.most_Recent_agreement_status
)

&


/*-----------------------------------------------*/
/* TASK No. 55 */
/* drop abf_stage */

-- drop table abf_stage
BEGIN
   EXECUTE IMMEDIATE 'drop table abf_stage
';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 56 */
/* create abf_stage */

create table abf_stage as
select a.ACCOUNT_ID
, m.MARKETING_ID
, mapy.APY_ID
, ca.ASSIGNMENT_ID
, ca.effective_date as ASSIGNMENT_EFFECTIVE_DATE
, mapy.FISCAL_YEAR
, apy.x_booking_status_id as APY_BOOKING_STATUS_ID
, trunc(sysdate) as trans_date
, 1 as OCCURS
, nvl(apy.TO_BE_PHOTOGRAPHED,0) as to_be_photographed
, nvl(apy.prior_year_pkgs,0) as PRIOR_YEAR_JOB_PKGS
, nvl(apy.PROJECTED_PKGS,0) as projected_pkgs
, nvl(apy.PROJECTED_PAID_PKGS,0) as projected_paid_pkgs
, nvl(apy.PROJ_TRANSACTION_AMT,0) as proj_transaction_amt
, nvl(apy.PROJ_ORDER_SALES_AMT,0) as proj_order_sales_amt
, nvl(apy.PRIOR_YEAR_PAID_PKGS,0) as prior_year_paid_pkgs
, nvl(apy.PRIOR_YEAR_TRANSACTION_AMT,0) as prior_year_transaction_amt
, nvl(apy.PRIOR_YEAR_ORDER_SALES_AMT,0) as prior_year_order_sales_amt
, nvl(apy.SHRINK_PKGS,0) as shrink_pkgs
, nvl(apy.ENROLLMENT,0) as enrollment
, nvl(apy.prior_year_pkgs,0) as PRIOR_YEAR_ACCOUNT_PKGS
, nvl(apy.PROJ_SIT_QTY,0) as proj_sit_qty
, nvl(apy.PROJ_SIT_REVENUE_AMT,0) as proj_sit_revenue_amt
, nvl(apy.SHRINK_PAID_PKGS,0) as shrink_paid_pkgs
, nvl(apy.SHRINK_TRANSACTION_AMT,0) as shrink_transaction_amt
, nvl(apy.SHRINK_ORDER_SALES_AMT,0) as shrink_order_sales_amt
, nvl(apy.PRIOR_YEAR_SIT_QTY,0) as prior_year_sit_qty
, nvl(apy.PRIOR_YEAR_SIT_REVENUE_AMT,0) as prior_year_sit_revenue_amt
, nvl(apy.PROJ_PHOTO_SESSION_QTY,0) as proj_photo_session_qty
, nvl(apy.SHRINK_PHOTO_SESSION_QTY,0) as shrink_photo_session_qty
, nvl(apy.PRIOR_YEAR_PHOTO_SESSION_QTY,0) as prior_year_photo_session_qty
, nvl(apy.SHRINK_GROSS_AMT,0) as shrink_gross_amt
, nvl(apy.SHRINK_NET_AMT,0) as shrink_net_amt
from ODS_OWN.apy
, MART.account a
, mart.marketing m
, MART.apy mapy
, MART.x_current_assignment ca
where apy.lifetouch_id = a.lifetouch_id
and apy.sub_program_oid = m.sub_program_oid
and apy.lifetouch_id = mapy.lifetouch_id
and apy.sub_program_name = mapy.sub_program_name
and apy.school_year = mapy.fiscal_year
and m.program_id = ca.program_id
and apy.lifetouch_id = ca.lifetouch_id
and apy.school_year > 2022 -- 2022 and prior all load from AMS in old school script
and apy.ods_modify_date > sysdate - 10 -- need real CDC here

&


/*-----------------------------------------------*/
/* TASK No. 57 */
/* drop abf_stage2 */

-- drop table abf_stage2
BEGIN
   EXECUTE IMMEDIATE 'drop table abf_stage2
';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 58 */
/* create abf_stage2 */

create table abf_stage2 as
select cast(null as varchar2(3)) as record_status
, cast(null as number) as apy_booking_id
, abf_stage.*
from abf_stage
where 1=2

&


/*-----------------------------------------------*/
/* TASK No. 59 */
/* DEL to stage2 */

insert into abf_stage2
( record_status
, apy_booking_id
, ACCOUNT_ID
, MARKETING_ID
, APY_ID
, ASSIGNMENT_ID
, ASSIGNMENT_EFFECTIVE_DATE
, FISCAL_YEAR
, APY_BOOKING_STATUS_ID
, TRANS_DATE
, OCCURS
, TO_BE_PHOTOGRAPHED
, PRIOR_YEAR_JOB_PKGS
, PROJECTED_PKGS
, PROJECTED_PAID_PKGS
, PROJ_TRANSACTION_AMT
, PROJ_ORDER_SALES_AMT
, PRIOR_YEAR_PAID_PKGS
, PRIOR_YEAR_TRANSACTION_AMT
, PRIOR_YEAR_ORDER_SALES_AMT
, SHRINK_PKGS
, ENROLLMENT
, PRIOR_YEAR_ACCOUNT_PKGS
, PROJ_SIT_QTY
, PROJ_SIT_REVENUE_AMT
, SHRINK_PAID_PKGS
, SHRINK_TRANSACTION_AMT
, SHRINK_ORDER_SALES_AMT
, PRIOR_YEAR_SIT_QTY
, PRIOR_YEAR_SIT_REVENUE_AMT
, PROJ_PHOTO_SESSION_QTY
, SHRINK_PHOTO_SESSION_QTY
, PRIOR_YEAR_PHOTO_SESSION_QTY
, SHRINK_GROSS_AMT
, SHRINK_NET_AMT
)
select 'DEL'
, c.apy_booking_id
, c.ACCOUNT_ID
, c.MARKETING_ID
, c.APY_ID
, c.ASSIGNMENT_ID
, c.ASSIGNMENT_EFFECTIVE_DATE
, c.FISCAL_YEAR
, c.APY_BOOKING_STATUS_ID
, s.trans_date
, 0 as OCCURS
, 0 as TO_BE_PHOTOGRAPHED
, 0 as PRIOR_YEAR_JOB_PKGS
, 0 as PROJECTED_PKGS
, 0 as PROJECTED_PAID_PKGS
, 0 as PROJ_TRANSACTION_AMT
, 0 as PROJ_ORDER_SALES_AMT
, 0 as PRIOR_YEAR_PAID_PKGS
, 0 as PRIOR_YEAR_TRANSACTION_AMT
, 0 as PRIOR_YEAR_ORDER_SALES_AMT
, 0 as SHRINK_PKGS
, 0 as ENROLLMENT
, 0 as PRIOR_YEAR_ACCOUNT_PKGS
, 0 as PROJ_SIT_QTY
, 0 as PROJ_SIT_REVENUE_AMT
, 0 as SHRINK_PAID_PKGS
, 0 as SHRINK_TRANSACTION_AMT
, 0 as SHRINK_ORDER_SALES_AMT
, 0 as PRIOR_YEAR_SIT_QTY
, 0 as PRIOR_YEAR_SIT_REVENUE_AMT
, 0 as PROJ_PHOTO_SESSION_QTY
, 0 as SHRINK_PHOTO_SESSION_QTY
, 0 as PRIOR_YEAR_PHOTO_SESSION_QTY
, 0 as SHRINK_GROSS_AMT
, 0 as SHRINK_NET_AMT
from abf_stage s
, ODS.apy_booking_curr c
where s.apy_id = c.apy_id
and (   c.ACCOUNT_ID <> s.account_id
     or c.MARKETING_ID <> s.marketing_id
     or c.APY_ID <> s.apy_id
     or c.ASSIGNMENT_ID <> s.assignment_id
     or c.FISCAL_YEAR <> s.fiscal_year
     or c.APY_BOOKING_STATUS_ID <> s.apy_booking_status_id
    )
and (  0 <> c.OCCURS
    or 0 <> c.TO_BE_PHOTOGRAPHED
    or 0 <> c.PRIOR_YEAR_JOB_PKGS
    or 0 <> c.PROJECTED_PKGS
    or 0 <> c.PROJECTED_PAID_PKGS
    or 0 <> c.PROJ_TRANSACTION_AMT
    or 0 <> c.PROJ_ORDER_SALES_AMT
    or 0 <> c.PRIOR_YEAR_PAID_PKGS
    or 0 <> c.PRIOR_YEAR_TRANSACTION_AMT
    or 0 <> c.PRIOR_YEAR_ORDER_SALES_AMT
    or 0 <> c.SHRINK_PKGS
    or 0 <> c.ENROLLMENT
    or 0 <> c.PRIOR_YEAR_ACCOUNT_PKGS
    or 0 <> c.PROJ_SIT_QTY
    or 0 <> c.PROJ_SIT_REVENUE_AMT
    or 0 <> c.SHRINK_PAID_PKGS
    or 0 <> c.SHRINK_TRANSACTION_AMT
    or 0 <> c.SHRINK_ORDER_SALES_AMT
    or 0 <> c.PRIOR_YEAR_SIT_QTY
    or 0 <> c.PRIOR_YEAR_SIT_REVENUE_AMT
    or 0 <> c.PROJ_PHOTO_SESSION_QTY
    or 0 <> c.SHRINK_PHOTO_SESSION_QTY
    or 0 <> c.PRIOR_YEAR_PHOTO_SESSION_QTY
    or 0 <> c.SHRINK_GROSS_AMT
    or 0 <> c.SHRINK_NET_AMT
    )

&


/*-----------------------------------------------*/
/* TASK No. 60 */
/* NEW to stage2 */

insert into abf_stage2
( record_status
, apy_booking_id
, ACCOUNT_ID
, MARKETING_ID
, APY_ID
, ASSIGNMENT_ID
, ASSIGNMENT_EFFECTIVE_DATE
, FISCAL_YEAR
, APY_BOOKING_STATUS_ID
, TRANS_DATE
, OCCURS
, TO_BE_PHOTOGRAPHED
, PRIOR_YEAR_JOB_PKGS
, PROJECTED_PKGS
, PROJECTED_PAID_PKGS
, PROJ_TRANSACTION_AMT
, PROJ_ORDER_SALES_AMT
, PRIOR_YEAR_PAID_PKGS
, PRIOR_YEAR_TRANSACTION_AMT
, PRIOR_YEAR_ORDER_SALES_AMT
, SHRINK_PKGS
, ENROLLMENT
, PRIOR_YEAR_ACCOUNT_PKGS
, PROJ_SIT_QTY
, PROJ_SIT_REVENUE_AMT
, SHRINK_PAID_PKGS
, SHRINK_TRANSACTION_AMT
, SHRINK_ORDER_SALES_AMT
, PRIOR_YEAR_SIT_QTY
, PRIOR_YEAR_SIT_REVENUE_AMT
, PROJ_PHOTO_SESSION_QTY
, SHRINK_PHOTO_SESSION_QTY
, PRIOR_YEAR_PHOTO_SESSION_QTY
, SHRINK_GROSS_AMT
, SHRINK_NET_AMT
)
select 'NEW'
, mart.apy_booking_id_seq.nextval as apy_booking_id
, s.ACCOUNT_ID
, s.MARKETING_ID
, s.APY_ID
, s.ASSIGNMENT_ID
, s.ASSIGNMENT_EFFECTIVE_DATE
, s.FISCAL_YEAR
, s.APY_BOOKING_STATUS_ID
, s.trans_date
, s.OCCURS
, s.TO_BE_PHOTOGRAPHED
, s.PRIOR_YEAR_JOB_PKGS
, s.PROJECTED_PKGS
, s.PROJECTED_PAID_PKGS
, s.PROJ_TRANSACTION_AMT
, s.PROJ_ORDER_SALES_AMT
, s.PRIOR_YEAR_PAID_PKGS
, s.PRIOR_YEAR_TRANSACTION_AMT
, s.PRIOR_YEAR_ORDER_SALES_AMT
, s.SHRINK_PKGS
, s.ENROLLMENT
, s.PRIOR_YEAR_ACCOUNT_PKGS
, s.PROJ_SIT_QTY
, s.PROJ_SIT_REVENUE_AMT
, s.SHRINK_PAID_PKGS
, s.SHRINK_TRANSACTION_AMT
, s.SHRINK_ORDER_SALES_AMT
, s.PRIOR_YEAR_SIT_QTY
, s.PRIOR_YEAR_SIT_REVENUE_AMT
, s.PROJ_PHOTO_SESSION_QTY
, s.SHRINK_PHOTO_SESSION_QTY
, s.PRIOR_YEAR_PHOTO_SESSION_QTY
, s.SHRINK_GROSS_AMT
, s.SHRINK_NET_AMT
from abf_stage s
where not exists
(
select 1
from ODS.apy_booking_curr c
where s.apy_id = c.apy_id
and c.ACCOUNT_ID = s.account_id
and c.MARKETING_ID = s.marketing_id
and c.APY_ID = s.apy_id
and c.ASSIGNMENT_ID = s.assignment_id
and c.FISCAL_YEAR = s.fiscal_year
and c.APY_BOOKING_STATUS_ID = s.apy_booking_status_id
)

&


/*-----------------------------------------------*/
/* TASK No. 61 */
/* UPD to stage2 */

insert into abf_stage2
( record_status
, apy_booking_id
, ACCOUNT_ID
, MARKETING_ID
, APY_ID
, ASSIGNMENT_ID
, ASSIGNMENT_EFFECTIVE_DATE
, FISCAL_YEAR
, APY_BOOKING_STATUS_ID
, TRANS_DATE
, OCCURS
, TO_BE_PHOTOGRAPHED
, PRIOR_YEAR_JOB_PKGS
, PROJECTED_PKGS
, PROJECTED_PAID_PKGS
, PROJ_TRANSACTION_AMT
, PROJ_ORDER_SALES_AMT
, PRIOR_YEAR_PAID_PKGS
, PRIOR_YEAR_TRANSACTION_AMT
, PRIOR_YEAR_ORDER_SALES_AMT
, SHRINK_PKGS
, ENROLLMENT
, PRIOR_YEAR_ACCOUNT_PKGS
, PROJ_SIT_QTY
, PROJ_SIT_REVENUE_AMT
, SHRINK_PAID_PKGS
, SHRINK_TRANSACTION_AMT
, SHRINK_ORDER_SALES_AMT
, PRIOR_YEAR_SIT_QTY
, PRIOR_YEAR_SIT_REVENUE_AMT
, PROJ_PHOTO_SESSION_QTY
, SHRINK_PHOTO_SESSION_QTY
, PRIOR_YEAR_PHOTO_SESSION_QTY
, SHRINK_GROSS_AMT
, SHRINK_NET_AMT
)
select 'UPD'
, c.apy_booking_id
, s.ACCOUNT_ID
, s.MARKETING_ID
, s.APY_ID
, s.ASSIGNMENT_ID
, s.ASSIGNMENT_EFFECTIVE_DATE
, s.FISCAL_YEAR
, s.APY_BOOKING_STATUS_ID
, s.trans_date
, s.OCCURS
, s.TO_BE_PHOTOGRAPHED
, s.PRIOR_YEAR_JOB_PKGS
, s.PROJECTED_PKGS
, s.PROJECTED_PAID_PKGS
, s.PROJ_TRANSACTION_AMT
, s.PROJ_ORDER_SALES_AMT
, s.PRIOR_YEAR_PAID_PKGS
, s.PRIOR_YEAR_TRANSACTION_AMT
, s.PRIOR_YEAR_ORDER_SALES_AMT
, s.SHRINK_PKGS
, s.ENROLLMENT
, s.PRIOR_YEAR_ACCOUNT_PKGS
, s.PROJ_SIT_QTY
, s.PROJ_SIT_REVENUE_AMT
, s.SHRINK_PAID_PKGS
, s.SHRINK_TRANSACTION_AMT
, s.SHRINK_ORDER_SALES_AMT
, s.PRIOR_YEAR_SIT_QTY
, s.PRIOR_YEAR_SIT_REVENUE_AMT
, s.PROJ_PHOTO_SESSION_QTY
, s.SHRINK_PHOTO_SESSION_QTY
, s.PRIOR_YEAR_PHOTO_SESSION_QTY
, s.SHRINK_GROSS_AMT
, s.SHRINK_NET_AMT
from abf_stage s
, ODS.apy_booking_curr c
where s.apy_id = c.apy_id
and c.ACCOUNT_ID = s.account_id
and c.MARKETING_ID = s.marketing_id
and c.APY_ID = s.apy_id
and c.ASSIGNMENT_ID = s.assignment_id
and c.FISCAL_YEAR = s.fiscal_year
and c.APY_BOOKING_STATUS_ID = s.apy_booking_status_id
and (  s.occurs <> c.OCCURS
    or s.to_be_photographed <> c.TO_BE_PHOTOGRAPHED
    or s.prior_year_job_pkgs <> c.PRIOR_YEAR_JOB_PKGS
    or s.projected_pkgs <> c.PROJECTED_PKGS
    or s.projected_paid_pkgs <> c.PROJECTED_PAID_PKGS
    or s.proj_transaction_amt <> c.PROJ_TRANSACTION_AMT
    or s.proj_order_sales_amt <> c.PROJ_ORDER_SALES_AMT
    or s.prior_year_paid_pkgs <> c.PRIOR_YEAR_PAID_PKGS
    or s.prior_year_transaction_amt <> c.PRIOR_YEAR_TRANSACTION_AMT
    or s.prior_year_order_sales_amt <> c.PRIOR_YEAR_ORDER_SALES_AMT
    or s.shrink_pkgs <> c.SHRINK_PKGS
    or s.enrollment <> c.ENROLLMENT
    or s.prior_year_account_pkgs <> c.PRIOR_YEAR_ACCOUNT_PKGS
    or s.proj_sit_qty <> c.PROJ_SIT_QTY
    or s.proj_sit_revenue_amt <> c.PROJ_SIT_REVENUE_AMT
    or s.shrink_paid_pkgs <> c.SHRINK_PAID_PKGS
    or s.shrink_transaction_amt <> c.SHRINK_TRANSACTION_AMT
    or s.shrink_order_sales_amt <> c.SHRINK_ORDER_SALES_AMT
    or s.prior_year_sit_qty <> c.PRIOR_YEAR_SIT_QTY
    or s.prior_year_sit_revenue_amt <> c.PRIOR_YEAR_SIT_REVENUE_AMT
    or s.proj_photo_Session_qty <> c.PROJ_PHOTO_SESSION_QTY
    or s.shrink_photo_session_qty <> c.SHRINK_PHOTO_SESSION_QTY
    or s.prior_year_photo_session_qty <> c.PRIOR_YEAR_PHOTO_SESSION_QTY
    or s.shrink_gross_Amt <> c.SHRINK_GROSS_AMT
    or s.shrink_net_amt <> c.SHRINK_NET_AMT
    )

&


/*-----------------------------------------------*/
/* TASK No. 62 */
/* NEW to FACT */
BEGIN
   insert into MART.apy_booking_fact
   ( apy_booking_id
   , ACCOUNT_ID
   , MARKETING_ID
   , APY_ID
   , ASSIGNMENT_ID
   , ASSIGNMENT_EFFECTIVE_DATE
   , FISCAL_YEAR
   , APY_BOOKING_STATUS_ID
   , TRANS_DATE
   , OCCURS
   , TO_BE_PHOTOGRAPHED
   , PRIOR_YEAR_JOB_PKGS
   , PROJECTED_PKGS
   , PROJECTED_PAID_PKGS
   , PROJ_TRANSACTION_AMT
   , PROJ_ORDER_SALES_AMT
   , PRIOR_YEAR_PAID_PKGS
   , PRIOR_YEAR_TRANSACTION_AMT
   , PRIOR_YEAR_ORDER_SALES_AMT
   , SHRINK_PKGS
   , ENROLLMENT
   , PRIOR_YEAR_ACCOUNT_PKGS
   , PROJ_SIT_QTY
   , PROJ_SIT_REVENUE_AMT
   , SHRINK_PAID_PKGS
   , SHRINK_TRANSACTION_AMT
   , SHRINK_ORDER_SALES_AMT
   , PRIOR_YEAR_SIT_QTY
   , PRIOR_YEAR_SIT_REVENUE_AMT
   , PROJ_PHOTO_SESSION_QTY
   , SHRINK_PHOTO_SESSION_QTY
   , PRIOR_YEAR_PHOTO_SESSION_QTY
   , SHRINK_GROSS_AMT
   , SHRINK_NET_AMT
   )
   select s.apy_booking_id
   , s.ACCOUNT_ID
   , s.MARKETING_ID
   , s.APY_ID
   , s.ASSIGNMENT_ID
   , s.ASSIGNMENT_EFFECTIVE_DATE
   , s.FISCAL_YEAR
   , s.APY_BOOKING_STATUS_ID
   , s.trans_date
   , s.OCCURS
   , s.TO_BE_PHOTOGRAPHED
   , s.PRIOR_YEAR_JOB_PKGS
   , s.PROJECTED_PKGS
   , s.PROJECTED_PAID_PKGS
   , s.PROJ_TRANSACTION_AMT
   , s.PROJ_ORDER_SALES_AMT
   , s.PRIOR_YEAR_PAID_PKGS
   , s.PRIOR_YEAR_TRANSACTION_AMT
   , s.PRIOR_YEAR_ORDER_SALES_AMT
   , s.SHRINK_PKGS
   , s.ENROLLMENT
   , s.PRIOR_YEAR_ACCOUNT_PKGS
   , s.PROJ_SIT_QTY
   , s.PROJ_SIT_REVENUE_AMT
   , s.SHRINK_PAID_PKGS
   , s.SHRINK_TRANSACTION_AMT
   , s.SHRINK_ORDER_SALES_AMT
   , s.PRIOR_YEAR_SIT_QTY
   , s.PRIOR_YEAR_SIT_REVENUE_AMT
   , s.PROJ_PHOTO_SESSION_QTY
   , s.SHRINK_PHOTO_SESSION_QTY
   , s.PRIOR_YEAR_PHOTO_SESSION_QTY
   , s.SHRINK_GROSS_AMT
   , s.SHRINK_NET_AMT
   from abf_stage2 s
   where record_status = 'NEW';


   /*-----------------------------------------------*/
   /* TASK No. 63 */
   /* NEW to CURR */

   insert into ODS.apy_booking_curr
   ( apy_booking_id
   , ACCOUNT_ID
   , MARKETING_ID
   , APY_ID
   , ASSIGNMENT_ID
   , ASSIGNMENT_EFFECTIVE_DATE
   , FISCAL_YEAR
   , APY_BOOKING_STATUS_ID
   , TRANS_DATE
   , OCCURS
   , TO_BE_PHOTOGRAPHED
   , PRIOR_YEAR_JOB_PKGS
   , PROJECTED_PKGS
   , PROJECTED_PAID_PKGS
   , PROJ_TRANSACTION_AMT
   , PROJ_ORDER_SALES_AMT
   , PRIOR_YEAR_PAID_PKGS
   , PRIOR_YEAR_TRANSACTION_AMT
   , PRIOR_YEAR_ORDER_SALES_AMT
   , SHRINK_PKGS
   , ENROLLMENT
   , PRIOR_YEAR_ACCOUNT_PKGS
   , PROJ_SIT_QTY
   , PROJ_SIT_REVENUE_AMT
   , SHRINK_PAID_PKGS
   , SHRINK_TRANSACTION_AMT
   , SHRINK_ORDER_SALES_AMT
   , PRIOR_YEAR_SIT_QTY
   , PRIOR_YEAR_SIT_REVENUE_AMT
   , PROJ_PHOTO_SESSION_QTY
   , SHRINK_PHOTO_SESSION_QTY
   , PRIOR_YEAR_PHOTO_SESSION_QTY
   , SHRINK_GROSS_AMT
   , SHRINK_NET_AMT
   )
   select s.apy_booking_id
   , s.ACCOUNT_ID
   , s.MARKETING_ID
   , s.APY_ID
   , s.ASSIGNMENT_ID
   , s.ASSIGNMENT_EFFECTIVE_DATE
   , s.FISCAL_YEAR
   , s.APY_BOOKING_STATUS_ID
   , s.trans_date
   , s.OCCURS
   , s.TO_BE_PHOTOGRAPHED
   , s.PRIOR_YEAR_JOB_PKGS
   , s.PROJECTED_PKGS
   , s.PROJECTED_PAID_PKGS
   , s.PROJ_TRANSACTION_AMT
   , s.PROJ_ORDER_SALES_AMT
   , s.PRIOR_YEAR_PAID_PKGS
   , s.PRIOR_YEAR_TRANSACTION_AMT
   , s.PRIOR_YEAR_ORDER_SALES_AMT
   , s.SHRINK_PKGS
   , s.ENROLLMENT
   , s.PRIOR_YEAR_ACCOUNT_PKGS
   , s.PROJ_SIT_QTY
   , s.PROJ_SIT_REVENUE_AMT
   , s.SHRINK_PAID_PKGS
   , s.SHRINK_TRANSACTION_AMT
   , s.SHRINK_ORDER_SALES_AMT
   , s.PRIOR_YEAR_SIT_QTY
   , s.PRIOR_YEAR_SIT_REVENUE_AMT
   , s.PROJ_PHOTO_SESSION_QTY
   , s.SHRINK_PHOTO_SESSION_QTY
   , s.PRIOR_YEAR_PHOTO_SESSION_QTY
   , s.SHRINK_GROSS_AMT
   , s.SHRINK_NET_AMT
   from abf_stage2 s
   where record_status = 'NEW';

   COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END;
&


/*-----------------------------------------------*/
/* TASK No. 64 */
/* UPD and DEL to FACT */
BEGIN
   insert into MART.apy_booking_fact
   ( apy_booking_id
   , ACCOUNT_ID
   , MARKETING_ID
   , APY_ID
   , ASSIGNMENT_ID
   , ASSIGNMENT_EFFECTIVE_DATE
   , FISCAL_YEAR
   , APY_BOOKING_STATUS_ID
   , TRANS_DATE
   , OCCURS
   , TO_BE_PHOTOGRAPHED
   , PRIOR_YEAR_JOB_PKGS
   , PROJECTED_PKGS
   , PROJECTED_PAID_PKGS
   , PROJ_TRANSACTION_AMT
   , PROJ_ORDER_SALES_AMT
   , PRIOR_YEAR_PAID_PKGS
   , PRIOR_YEAR_TRANSACTION_AMT
   , PRIOR_YEAR_ORDER_SALES_AMT
   , SHRINK_PKGS
   , ENROLLMENT
   , PRIOR_YEAR_ACCOUNT_PKGS
   , PROJ_SIT_QTY
   , PROJ_SIT_REVENUE_AMT
   , SHRINK_PAID_PKGS
   , SHRINK_TRANSACTION_AMT
   , SHRINK_ORDER_SALES_AMT
   , PRIOR_YEAR_SIT_QTY
   , PRIOR_YEAR_SIT_REVENUE_AMT
   , PROJ_PHOTO_SESSION_QTY
   , SHRINK_PHOTO_SESSION_QTY
   , PRIOR_YEAR_PHOTO_SESSION_QTY
   , SHRINK_GROSS_AMT
   , SHRINK_NET_AMT
   )
   select s.apy_booking_id
   , s.ACCOUNT_ID
   , s.MARKETING_ID
   , s.APY_ID
   , s.ASSIGNMENT_ID
   , s.ASSIGNMENT_EFFECTIVE_DATE
   , s.FISCAL_YEAR
   , s.APY_BOOKING_STATUS_ID
   , s.trans_date
   , s.OCCURS - c.occurs
   , s.TO_BE_PHOTOGRAPHED - c.to_be_photographed
   , s.PRIOR_YEAR_JOB_PKGS - c.prior_year_job_pkgs
   , s.PROJECTED_PKGS - c.projected_pkgs
   , s.PROJECTED_PAID_PKGS - c.projected_paid_pkgs
   , s.PROJ_TRANSACTION_AMT - c.proj_transaction_amt
   , s.PROJ_ORDER_SALES_AMT - c.proj_order_sales_amt
   , s.PRIOR_YEAR_PAID_PKGS - c.prior_year_paid_pkgs
   , s.PRIOR_YEAR_TRANSACTION_AMT - c.prior_year_transaction_amt
   , s.PRIOR_YEAR_ORDER_SALES_AMT - c.prior_year_order_sales_amt
   , s.SHRINK_PKGS - c.shrink_pkgs
   , s.ENROLLMENT - c.enrollment
   , s.PRIOR_YEAR_ACCOUNT_PKGS - c.prior_year_account_pkgs
   , s.PROJ_SIT_QTY - c.proj_sit_qty
   , s.PROJ_SIT_REVENUE_AMT - c.proj_sit_revenue_amt
   , s.SHRINK_PAID_PKGS - c.shrink_paid_pkgs
   , s.SHRINK_TRANSACTION_AMT - c.shrink_transaction_amt
   , s.SHRINK_ORDER_SALES_AMT - c.shrink_order_sales_amt
   , s.PRIOR_YEAR_SIT_QTY - c.prior_year_sit_qty
   , s.PRIOR_YEAR_SIT_REVENUE_AMT - c.prior_year_sit_revenue_amt
   , s.PROJ_PHOTO_SESSION_QTY - c.proj_photo_session_qty
   , s.SHRINK_PHOTO_SESSION_QTY - c.shrink_photo_session_qty
   , s.PRIOR_YEAR_PHOTO_SESSION_QTY - c.prior_year_photo_session_qty
   , s.SHRINK_GROSS_AMT - c.shrink_gross_amt
   , s.SHRINK_NET_AMT - c.shrink_net_amt
   from abf_stage2 s
   , ODS.apy_booking_curr c
   where s.record_status in ('UPD','DEL')
   and s.apy_booking_id = c.apy_booking_id;


   /*-----------------------------------------------*/
   /* TASK No. 65 */
   /* UPD and DEL to CURR */

   merge into ODS.apy_booking_curr c
   using
   (
   select apy_booking_id
   , ACCOUNT_ID
   , MARKETING_ID
   , APY_ID
   , ASSIGNMENT_ID
   , ASSIGNMENT_EFFECTIVE_DATE
   , FISCAL_YEAR
   , APY_BOOKING_STATUS_ID
   , TRANS_DATE
   , OCCURS
   , TO_BE_PHOTOGRAPHED
   , PRIOR_YEAR_JOB_PKGS
   , PROJECTED_PKGS
   , PROJECTED_PAID_PKGS
   , PROJ_TRANSACTION_AMT
   , PROJ_ORDER_SALES_AMT
   , PRIOR_YEAR_PAID_PKGS
   , PRIOR_YEAR_TRANSACTION_AMT
   , PRIOR_YEAR_ORDER_SALES_AMT
   , SHRINK_PKGS
   , ENROLLMENT
   , PRIOR_YEAR_ACCOUNT_PKGS
   , PROJ_SIT_QTY
   , PROJ_SIT_REVENUE_AMT
   , SHRINK_PAID_PKGS
   , SHRINK_TRANSACTION_AMT
   , SHRINK_ORDER_SALES_AMT
   , PRIOR_YEAR_SIT_QTY
   , PRIOR_YEAR_SIT_REVENUE_AMT
   , PROJ_PHOTO_SESSION_QTY
   , SHRINK_PHOTO_SESSION_QTY
   , PRIOR_YEAR_PHOTO_SESSION_QTY
   , SHRINK_GROSS_AMT
   , SHRINK_NET_AMT
   from abf_stage2
   where record_status in ('UPD','DEL')
   ) s
   on ( s.apy_booking_id = c.apy_booking_id )
   when matched then update
   set c.OCCURS = s.occurs
   , c.TO_BE_PHOTOGRAPHED = s.to_be_photographed
   , c.PRIOR_YEAR_JOB_PKGS = s.prior_year_job_pkgs
   , c.PROJECTED_PKGS = s.projected_pkgs
   , c.PROJECTED_PAID_PKGS = s.projected_paid_pkgs
   , c.PROJ_TRANSACTION_AMT = s.proj_transaction_amt
   , c.PROJ_ORDER_SALES_AMT = s.proj_order_sales_amt
   , c.PRIOR_YEAR_PAID_PKGS = s.prior_year_paid_pkgs
   , c.PRIOR_YEAR_TRANSACTION_AMT = s.prior_year_transaction_amt
   , c.PRIOR_YEAR_ORDER_SALES_AMT = s.prior_year_order_sales_amt
   , c.SHRINK_PKGS = s.shrink_pkgs
   , c.ENROLLMENT = s.enrollment
   , c.PRIOR_YEAR_ACCOUNT_PKGS = s.prior_year_account_pkgs
   , c.PROJ_SIT_QTY = s.proj_sit_qty
   , c.PROJ_SIT_REVENUE_AMT = s.proj_sit_revenue_amt
   , c.SHRINK_PAID_PKGS = s.shrink_paid_pkgs
   , c.SHRINK_TRANSACTION_AMT = s.shrink_transaction_amt
   , c.SHRINK_ORDER_SALES_AMT = s.shrink_order_sales_amt
   , c.PRIOR_YEAR_SIT_QTY = s.prior_year_sit_qty
   , c.PRIOR_YEAR_SIT_REVENUE_AMT = s.prior_year_sit_revenue_amt
   , c.PROJ_PHOTO_SESSION_QTY = s.proj_photo_session_qty
   , c.SHRINK_PHOTO_SESSION_QTY = s.shrink_photo_session_qty
   , c.PRIOR_YEAR_PHOTO_SESSION_QTY = s.prior_year_photo_session_qty
   , c.SHRINK_GROSS_AMT = s.shrink_gross_amt
   , c.SHRINK_NET_AMT = s.shrink_net_amt;

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Rollback in case of any error
        ROLLBACK;
        RAISE;
END;

&


/*-----------------------------------------------*/
