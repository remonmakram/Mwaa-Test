/*-----------------------------------------------*/
/* TASK No. 19 */
/* drop bobs_sy (work table) */

-- drop table bobs
BEGIN
   EXECUTE IMMEDIATE 'drop table bobs';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&

-- drop table bobs_sy
BEGIN
   EXECUTE IMMEDIATE 'drop table bobs_sy';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* create bobs_sy (work table) */

create table bobs_sy as select school_year + :v_sy_offset as school_year from time where date_key = trunc(sysdate)

&

/*-----------------------------------------------*/
/* TASK No. 37 */
/* create bobs (work table) */

create table bobs as
select bo.booking_opportunity_oid
, bo.lifetouch_id
, sp.sub_program_name
, bo.school_year
, sp.sub_program_oid
, a.account_oid
, bs.x_booking_status_id
, bo.booking_status as sales_pipeline
, apy_py_bs.booking_status_name as py_booking_status_name
, bs.booking_status_name as booking_status
, bs.booking_group
, bs.bs_pecking_order
, sm.selling_method
, row_number() over (partition by bo.lifetouch_id, sp.sub_program_name, bo.school_year order by bs.bs_pecking_order desc) row_rank
, case when p.program_name = 'Senior/Studio Style' then ma.dw_grade_11_enrollment_qty else a.enrollment end as enrollment
, case when apy_py_bs.booking_group = 'Not Booked' then null else apy_py.selling_methods end as py_selling_methods
, ods_own.safe_to_number(bo.est_photoed) as est_photoed
, bo.territory_code
, bo.booking_employee_oid
, emp.first_name as booked_by_firstname
, emp.last_name as booked_by_lastname
, bo.risk_ind
, ss.source_system_oid
, bo.most_recent_agreement_status
from ODS_OWN.booking_opportunity bo
, ods_own.source_system ss
, ods_own.source_system ss2
, ODS_OWN.sub_program sp
, ODS_OWN.program p
, ODS_OWN.apy apy_py
, MART.x_booking_status apy_py_bs
, MART.x_booking_status bs
, ODS_OWN.selling_method sm
, ODS_OWN.account a
, MART.account ma
, ODS_OWN.employee emp
, bobs_sy
where 1=1
and ss.source_system_short_name = 'ODS'
and bo.source_system_oid = ss2.source_system_oid
and ss2.source_system_short_name = 'SF'
and bo.school_year > 2022 -- 2022 is the last year of AMS, that is not to be updated here
and bobs_sy.school_year = bo.school_year
and bo.sub_program_oid = sp.sub_program_oid
and sp.program_oid = p.program_oid
and bo.account_oid = apy_py.account_oid(+)
and bo.sub_program_oid = apy_py.sub_program_oid(+)
and (bo.school_year - 1) = apy_py.school_year(+)
and apy_py.x_booking_status_id = apy_py_bs.x_booking_status_id(+)
and (case when apy_py_bs.booking_group = 'Booked' then 'Lifetouch Account' else 'Non-Lifetouch Account' end) = bs.py_booking_group
and ( case when a.active_account_ind = 'I' then 'Closed' 
                  when bo.src_delete_flag = 'Y' then 'Identify' 
                  when sm.selling_method = 'Service Non Rev' then 'Identify'
                  when bo.lost_reason_code = 'Duplicate Opportunity' and bo.booking_status = 'Closed Lost' then 'Identify' -- DM-1343
                  else bo.booking_status end ) = bs.sales_pipeline
and bo.selling_method_oid = sm.selling_method_oid(+)
and bo.lifetouch_id = a.lifetouch_id
and bo.lifetouch_id = ma.lifetouch_id
and bo.booking_employee_oid = emp.employee_oid(+)


&


/*-----------------------------------------------*/
/* TASK No. 38 */
/* merge to APY */

merge into ODS_OWN.apy t
using
(
select bobs.lifetouch_id
, bobs.sub_program_name
, bobs.school_year
, bobs.account_oid
, bobs.sub_program_oid
, bobs.booking_opportunity_oid
, bobs.enrollment
, bobs.py_selling_methods
, bobs.x_booking_status_id
, bobs.booking_status
, bobs.est_photoed
, bobs.territory_code
, bobs.booking_employee_oid
, bobs.booked_by_firstname
, bobs.booked_by_lastname
, bobs.risk_ind
, bobs.source_system_oid
, bobs.most_recent_agreement_status
, LISTAGG(bobs2.selling_method, ', ')
         WITHIN GROUP (ORDER BY bobs2.selling_method) as selling_methods
from bobs
, ( select distinct lifetouch_id, sub_program_name, school_year, x_booking_status_id, selling_method from bobs ) bobs2
where bobs.row_rank = 1
and bobs.lifetouch_id = bobs2.lifetouch_id
and bobs.sub_program_name = bobs2.sub_program_name
and bobs.school_year = bobs2.school_year
and bobs.school_year > 2022 -- 2022 is the last year of AMS, that is not to be updated here
and bobs.x_booking_status_id = bobs2.x_booking_status_id
group by bobs.lifetouch_id
, bobs.sub_program_name
, bobs.school_year
, bobs.account_oid
, bobs.sub_program_oid
, bobs.booking_opportunity_oid
, bobs.enrollment
, bobs.py_selling_methods
, bobs.x_booking_status_id
, bobs.booking_status
, bobs.est_photoed
, bobs.territory_code
, bobs.booking_employee_oid
, bobs.booked_by_firstname
, bobs.booked_by_lastname
, bobs.risk_ind
, bobs.source_system_oid
, bobs.most_recent_agreement_status
) s
on
( s.lifetouch_id = t.lifetouch_id
and s.sub_program_name = t.sub_program_name
and s.school_year = t.school_year
)
when matched then update
set t.account_oid = s.account_oid
, t.sub_program_oid = s.sub_program_oid
, t.booking_opportunity_oid = s.booking_opportunity_oid
, t.enrollment = s.enrollment
, t.py_selling_methods = s.py_selling_methods
, t.x_booking_status_id = s.x_booking_status_id
, t.booking_status = s.booking_status
, t.to_be_photographed = s.est_photoed
, t.booked_by_territory_code = s.territory_code
, t.booked_by_employee_oid = s.booking_employee_oid
, t.booked_by_firstname = s.booked_by_firstname
, t.booked_by_lastname = s.booked_by_lastname
, t.at_risk_ind = s.risk_ind
, t.selling_methods = s.selling_methods
, t.most_recent_agreement_status = s.most_recent_agreement_status
, t.ods_modify_date = sysdate
where decode( t.account_oid , s.account_oid, 1,0) = 0
or decode(t.sub_program_oid , s.sub_program_oid, 1,0) = 0
or decode(t.booking_opportunity_oid , s.booking_opportunity_oid, 1,0) = 0
or decode(t.enrollment , s.enrollment, 1,0) = 0
or decode(t.py_selling_methods , s.py_selling_methods, 1,0) = 0
or decode(t.x_booking_status_id , s.x_booking_status_id, 1,0) = 0
or decode(t.booking_status , s.booking_status, 1,0) = 0
or decode(t.to_be_photographed , s.est_photoed, 1,0) = 0
or decode(t.booked_by_territory_code , s.territory_code, 1,0) = 0
or decode(t.booked_by_employee_oid , s.booking_employee_oid, 1,0) = 0
or decode(t.selling_methods , s.selling_methods , 1,0) = 0
or decode(t.at_risk_ind , s.risk_ind , 1,0) = 0
or decode( t.most_recent_agreement_status , s.most_recent_agreement_status , 1,0) = 0
-- the listagg'd selling methods
when not matched then insert
( t.apy_oid
, t.lifetouch_id
, t.sub_program_name
, t.school_year
, t.account_oid
, t.sub_program_oid
, t.booking_opportunity_oid
, t.enrollment
, t.py_selling_methods
, t.x_booking_status_id
, t.booking_status
, t.to_be_photographed
, t.booked_by_territory_code
, t.booked_by_employee_oid
, t.booked_by_firstname
, t.booked_by_lastname
, t.selling_methods
, t.at_risk_ind
, t.ods_modify_date
, t.ods_create_date
, t.source_system_oid
, t.PRIOR_YEAR_PKGS
, t.PRIOR_YEAR_ORDER_SALES_AMT
, t.PRIOR_YEAR_PAID_PKGS
, t.PRIOR_YEAR_PHOTO_SESSION_QTY
, t.PRIOR_YEAR_SIT_QTY
, t.PRIOR_YEAR_SIT_REVENUE_AMT
, t.PRIOR_YEAR_TRANSACTION_AMT
, t.PROJECTED_PAID_PKGS
, t.PROJECTED_PKGS
, t.PROJ_ORDER_SALES_AMT
, t.PROJ_PHOTO_SESSION_QTY
, t.PROJ_SIT_QTY
, t.PROJ_SIT_REVENUE_AMT
, t.PROJ_TRANSACTION_AMT
, t.SHRINK_GROSS_AMT
, t.SHRINK_NET_AMT
, t.SHRINK_ORDER_SALES_AMT
, t.SHRINK_PAID_PKGS
, t.SHRINK_PHOTO_SESSION_QTY
, t.SHRINK_PKGS
, t.SHRINK_TRANSACTION_AMT
, t.most_Recent_agreement_status
)
values
( ODS_STAGE.apy_oid_seq.nextval
, s.lifetouch_id
, s.sub_program_name
, s.school_year
, s.account_oid
, s.sub_program_oid
, s.booking_opportunity_oid
, s.enrollment
, s.py_selling_methods
, s.x_booking_status_id
, s.booking_status
, s.est_photoed
, s.territory_code
, s.booking_employee_oid
, s.booked_by_firstname
, s.booked_by_lastname
, s.selling_methods
, s.risk_ind
, sysdate
, sysdate
, s.source_system_oid
, 0
, 0
, 0
, 0
, 0
, 0
, 0
, 0
, 0
, 0
, 0
, 0
, 0
, 0
, 0
, 0
, 0
, 0
, 0
, 0
, 0
, s.most_Recent_agreement_status
)

&

/*-----------------------------------------------*/
/* TASK No. 7 */
/* Not Rebooks with no opportunity */

insert into ODS_OWN.apy t
( t.apy_oid
, t.lifetouch_id
, t.sub_program_name
, t.school_year
, t.booking_status
, t.x_booking_status_id
, t.selling_methods
, t.account_oid
, t.sub_program_oid
, t.ods_create_date
, t.ods_modify_date
, t.source_system_oid
)
select ODS_STAGE.apy_oid_seq.nextval
, apy.lifetouch_id
, apy.sub_program_name
, bobs_sy.school_year
, bs.booking_status_name as booking_status
, bs.x_booking_status_id
, apy.selling_methods
, a.account_oid
, sp.sub_program_oid
, sysdate
, sysdate
, ss.source_system_oid
from ODS_OWN.apy
, MART.x_booking_status bs_py
, MART.x_booking_status bs
, bobs_sy
, ODS_OWN.account a
, ODS_OWN.sub_program sp
, ods_own.source_system ss
where apy.x_booking_status_id = bs_py.x_booking_status_id
and bs_py.booking_group = 'Booked'
and apy.school_year = bobs_sy.school_year - 1
and bobs_sy.school_year > 2022 -- 2022 is the last year of AMS, that is not to be updated here
and bs.x_booking_status_id = 3
and apy.lifetouch_id = a.lifetouch_id
and apy.sub_program_name = sp.sub_program_name
and a.active_account_ind = 'A'
and ss.source_system_short_name = 'ODS'
and not exists
(
select 1
from ODS_OWN.apy i_apy
where i_apy.lifetouch_id = apy.lifetouch_id
and i_apy.sub_program_name = apy.sub_program_name
and i_apy.school_year = bobs_sy.school_year
)

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* drop closed_no_opp */

-- drop table closed_no_opp
BEGIN
   EXECUTE IMMEDIATE 'drop table closed_no_opp';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* create closed_no_opp */

create table closed_no_opp as
select a.lifetouch_id
, m.sub_program_name
, f.fiscal_year as school_year
, b.x_booking_status_id
, b.booking_status_name
from apy_booking_fact f
, account a
, x_booking_status b
, marketing m
, bobs_sy
where f.account_id = a.account_id
and f.apy_booking_status_id = b.x_booking_status_id
and F.MARKETING_ID = m.marketing_id
and f.fiscal_year = bobs_sy.school_year
and a.active_account_ind = 'I'
group by a.lifetouch_id
, m.program_id
, m.sub_program_id
, m.sub_program_name
, f.fiscal_year
, b.x_booking_status_id
, b.booking_status_name
having sum(f.occurs) <> 0
and b.booking_status_name not in ('Closed')

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* index closed_no_opp */

create unique index closed_no_opp_pk on closed_no_opp
( lifetouch_id
, sub_program_name
, school_year
)

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* merge closed to APY */

merge into ODS_OWN.apy t
using
(
select c.lifetouch_id
, c.sub_program_name
, c.school_year
, bs.booking_status_name as booking_status
, bs.x_booking_status_id
, a.account_oid
, sp.sub_program_oid
, ss.source_system_oid
from closed_no_opp c
, MART.x_booking_status old_bs
, MART.x_booking_status bs
, ODS_OWN.account a
, ODS_OWN.sub_program sp
, ods_own.source_system ss
where c.school_year > 2022 -- 2022 is the last year of AMS, that is not to be updated here
and bs.booking_status_name = 'Closed'
and c.x_booking_status_id = old_bs.x_booking_status_id
and bs.py_booking_group = old_bs.py_booking_group
and c.lifetouch_id = a.lifetouch_id
and c.sub_program_name = sp.sub_program_name
and ss.source_system_short_name = 'ODS'
) s
on
( t.lifetouch_id = s.lifetouch_id
and t.sub_program_name = s.sub_program_name
and t.school_year = s.school_year
)
when matched then update
set t.booking_status = s.booking_status
, t.x_booking_status_id = s.x_booking_status_id
, t.ods_modify_date = sysdate
where decode(t.booking_status , s.booking_status,1,0) = 0
or decode(t.x_booking_status_id , s.x_booking_status_id,1,0) = 0
when not matched then insert
( t.apy_oid
, t.lifetouch_id
, t.sub_program_name
, t.school_year
, t.booking_status
, t.x_booking_status_id
, t.account_oid
, t.sub_program_oid
, t.ods_create_date
, t.ods_modify_date
, t.source_system_oid
)
values
( ODS_STAGE.apy_oid_seq.nextval
, s.lifetouch_id
, s.sub_program_name
, s.school_year
, s.booking_status
, s.x_booking_status_id
, s.account_oid
, s.sub_program_oid
, sysdate
, sysdate
, s.source_system_oid
)

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* drop booked_no_opp */

-- drop table booked_missing_opp
BEGIN
   EXECUTE IMMEDIATE 'drop table booked_missing_opp';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* create booked_no_opp */

create table booked_missing_opp as
select abf.lifetouch_id
, abf.sub_program_name
, abf.fiscal_year as school_year
, abf.booking_status_name
, abf.x_booking_status_id
from
(
select a.lifetouch_id
, m.sub_program_name
, f.fiscal_year
, b.booking_status_name
, b.x_booking_status_id
, sum(f.occurs)
from apy_booking_fact f
, account a
, x_booking_status b
, marketing m
, bobs_sy
where f.account_id = a.account_id
and f.apy_booking_status_id = b.x_booking_status_id
and F.MARKETING_ID = m.marketing_id
and (b.booking_group = 'Booked' or b.booking_status_name = 'Lost')
and f.fiscal_year = bobs_sy.school_year
group by a.lifetouch_id
, m.program_id
, m.sub_program_id
, m.sub_program_name
, f.fiscal_year
, b.booking_status_name
, b.x_booking_status_id
having sum(f.occurs) <> 0
) abf
where not exists
(
select 1
from ods_own.booking_opportunity bo
, ods_own.sub_program sp
, ods_own.source_system ss
where bo.sub_program_oid = sp.sub_program_oid
and bo.source_system_oid = ss.source_system_oid
and ss.source_system_short_name = 'SF'
and abf.lifetouch_id = bo.lifetouch_id
and abf.sub_program_name = sp.sub_program_name
and abf.fiscal_year = bo.school_year
)

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* index booked_no_opp */

create unique index booked_missing_opp_pk on booked_missing_opp
( lifetouch_id
, sub_program_name
, school_year
)

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* merge to APY */

merge into ODS_OWN.apy t
using
(
select c.lifetouch_id
, c.sub_program_name
, c.school_year
, bs.booking_status_name as booking_status
, bs.x_booking_status_id
, a.account_oid
, sp.sub_program_oid
, ss.source_system_oid
from booked_missing_opp c
, MART.x_booking_status old_bs
, MART.x_booking_status bs
, ODS_OWN.account a
, ODS_OWN.sub_program sp
, ods_own.source_system ss
where c.school_year > 2022 -- 2022 is the last year of AMS, that is not to be updated here
and bs.sales_pipeline = 'Identify'
and c.x_booking_status_id = old_bs.x_booking_status_id
and bs.py_booking_group = old_bs.py_booking_group
and c.lifetouch_id = a.lifetouch_id
and c.sub_program_name = sp.sub_program_name
and ss.source_system_short_name = 'ODS'
) s
on
( t.lifetouch_id = s.lifetouch_id
and t.sub_program_name = s.sub_program_name
and t.school_year = s.school_year
)
when matched then update
set t.booking_status = s.booking_status
, t.x_booking_status_id = s.x_booking_status_id
, t.ods_modify_date = sysdate
where decode(t.booking_status , s.booking_status,1,0) = 0
or decode(t.x_booking_status_id , s.x_booking_status_id,1,0) = 0
when not matched then insert
( t.apy_oid
, t.lifetouch_id
, t.sub_program_name
, t.school_year
, t.booking_status
, t.x_booking_status_id
, t.account_oid
, t.sub_program_oid
, t.ods_create_date
, t.ods_modify_date
, t.source_system_oid
)
values
( ODS_STAGE.apy_oid_seq.nextval
, s.lifetouch_id
, s.sub_program_name
, s.school_year
, s.booking_status
, s.x_booking_status_id
, s.account_oid
, s.sub_program_oid
, sysdate
, sysdate
, s.source_system_oid
)

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Correct the generated not rebooks where prior year is unbooked */

merge into ods_own.apy t using
(
select apy.apy_oid
from ods_own.apy
, ods_own.apy py_apy
, mart.x_booking_status py_apy_bs
, bobs_sy
where apy.lifetouch_id = py_apy.lifetouch_id
and apy.school_year - 1 = py_apy.school_year
and apy.sub_program_name = py_apy.sub_program_name
and py_apy.x_booking_status_id = py_apy_bs.x_booking_status_id
and apy.school_year = bobs_sy.school_year
and apy.booking_status = 'Not Rebooked'
and py_apy_bs.booking_group = 'Not Booked'
) s
on ( s.apy_oid = t.apy_oid )
when matched then update
set booking_status = 'Prospect'
, x_booking_status_id = 48
, ods_modify_date = sysdate

&
