select *
from ODS_STAGE.data_export_trigger
where session_name = '99_SENIORS_PROOF_ORDERS_RELEASED_BYLAB_PKG'


select trans_date
from ODS_STAGE.data_export_trigger
where data_export_trigger_id = (select min(data_export_trigger_id)
from ODS_STAGE.data_export_trigger
where session_name = '99_SENIORS_PROOF_ORDERS_RELEASED_BYLAB_PKG'
and status = 'READY')

--TRANS_DATE|
------------+
--20200505  |

select plant_name
, program_name
, thru_date
, current_year
, sum(case when current_year = fiscal_year and release_category = 'Proof' then dtd else 0 end ) as cy_dtd_prf
, sum(case when current_year = fiscal_year and release_category = 'Order' then dtd else 0 end ) as cy_dtd_ord
, sum(case when current_year <> fiscal_year and release_category = 'Proof' then dtd else 0 end ) as py_dtd_prf
, sum(case when current_year <> fiscal_year and release_category = 'Order' then dtd else 0 end ) as py_dtd_ord
, sum(case when current_year = fiscal_year and release_category = 'Proof' then ytd else 0 end ) as cy_ytd_prf
, sum(case when current_year = fiscal_year and release_category = 'Order' then ytd else 0 end ) as cy_ytd_ord
, sum(case when current_year <> fiscal_year and release_category = 'Proof' then ytd else 0 end ) as py_ytd_prf
, sum(case when current_year <> fiscal_year and release_category = 'Order' then ytd else 0 end ) as py_ytd_ord
from (
select f.plant_name
, m.program_name
, rg.release_category
, cy.date_key as thru_date
, t.fiscal_year
, cy.fiscal_year current_year
, py.fiscal_year prior_year
, sum(case when t.date_key in (cy.date_key, cy.prior_year_equiv_date) then f.release_qty else 0 end) as dtd
, sum(f.release_qty) as ytd
from
 release_fact f
, release_group rg
, time t
, time cy
, time py
, marketing m
where f.release_group_id = rg.release_group_id
and rg.release_category in ('Proof','Order')
and f.trans_date = t.date_key
and cy.date_key = decode(to_date(
'20240801','yyyymmdd'),to_date('01/01/1900','MM/DD/YYYY'),trunc(sysdate - 1),to_date(
'20240818','yyyymmdd'))
and cy.prior_year_equiv_date = py.date_key
and (   (cy.fiscal_year = t.fiscal_year and f.trans_date between cy.fiscal_year_begin_date and cy.date_key)
     or (py.fiscal_year = t.fiscal_year and f.trans_date between py.fiscal_year_begin_date and cy.prior_year_equiv_date)
    )
and rg.release_group not in ('NA', 'Unknown')
and f.marketing_Id = m.marketing_id
and m.sales_line_id = 4  /* Seniors  */
group by f.plant_name
, m.program_name
, rg.release_category
, cy.date_key
, t.fiscal_year
, cy.fiscal_year
, py.fiscal_year
)
group by plant_name
, program_name
, thru_date
, current_year
order by plant_name
, program_name
, thru_date
, current_year


select
	count(*)
from	RAX_APP_USER.ACTUATE_SENIPRF_ORDREL_LAB_STG   ACT
where
	(1=1)