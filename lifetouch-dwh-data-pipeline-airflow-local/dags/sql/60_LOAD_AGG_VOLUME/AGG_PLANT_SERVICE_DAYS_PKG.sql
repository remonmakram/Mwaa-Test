/* TASK No. 1 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */
/* Delete <Target> Table before loading. */

DELETE  FROM MART.AGG_PLANT_SERVICE_DAYS

&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* Load Target Table */

INSERT INTO MART.AGG_PLANT_SERVICE_DAYS 
select plant_name,senior_program,release_group,release_category,thru_date,fiscal_year,serve_days_bin_sort,serve_days_bin,wtd_qty,
Round(wtd_pct_of_total*100,1) as wtd_pct_of_total,Round(cum_wtd_pct*100,1) as cum_wtd_pct,ytd_qty,
Round(ytd_pct_of_total*100,1) as ytd_pct_of_total,Round(cum_ytd_pct*100,1) as cum_ytd_pct
,SYSDATE
from
(select  plant_name
, senior_program
, release_group
, release_category
, thru_date
, fiscal_year
, serve_days_bin_sort
, serve_days_bin
, wtd_qty
, wtd_pct_of_total
, sum(wtd_pct_of_total) over (partition by plant_name, senior_program, release_category
                              order by plant_name, senior_program, release_category, serve_days_bin_sort
                              rows unbounded preceding
                             ) as cum_wtd_pct
, ytd_qty
, ytd_pct_of_total
, sum(ytd_pct_of_total) over (partition by plant_name, senior_program, release_category
                              order by plant_name, senior_program, release_category, serve_days_bin_sort
                              rows unbounded preceding
                             ) as cum_ytd_pct,SYSDATE
from
(
select 
 f.plant_name
, rg.release_group 
, rg.release_category
, cy.date_key as thru_date
, t.fiscal_year
, f.serve_days_bin_sort
, f.serve_days_bin
, case when m.sub_program_id in (11, 1012, 10013, 1094) then 'Prestige Senior Portraits' 
           else sub_program_name end as senior_program
, sum(case when t.production_week_number = cy.production_week_number then f.release_qty else 0 end) as wtd_qty
, ratio_to_report(sum(case when t.production_week_number = cy.production_week_number then f.release_qty else 0 end)) over
    (partition by f.plant_name, rg.release_category,
                case when m.sub_program_id in (11, 1012, 10013, 1094) then 'Prestige Senior Portraits' 
           else sub_program_name end )   as wtd_pct_of_total
, sum(f.release_qty) as ytd_qty
, ratio_to_report(sum(f.release_qty)) over
    (partition by f.plant_name, rg.release_category,
           case when m.sub_program_id in (11, 1012, 10013, 1094) then 'Prestige Senior Portraits' 
           else sub_program_name end ) as ytd_pct_of_total
from 
MART.RELEASE_FACT f,
MART.RELEASE_GROUP rg,
MART.TIME t,
MART.TIME cy,
MART.MARKETING m
where
    f.release_group_id = rg.release_group_id
and f.trans_date = t.date_key
and cy.date_key = decode(to_date(TO_CHAR(SYSDATE,'MM/DD/YYYY'),'MM/DD/YYYY'),to_date('01/01/1900','MM/DD/YYYY'),trunc(sysdate - 1),to_date(TO_CHAR(SYSDATE,'MM/DD/YYYY'),'MM/DD/YYYY'))-1
and cy.fiscal_year = t.fiscal_year
and f.trans_date between cy.fiscal_year_begin_date and cy.date_key
and f.ship_date <> to_date('19000101', 'YYYYMMDD')
and rg.release_category in  ('Proof', 'Order')
and f.marketing_id = m.marketing_id
group by 
  f.plant_name
, rg.release_group
, rg.release_category
, cy.date_key
, t.fiscal_year
, f.serve_days_bin_sort
, f.serve_days_bin
, case when m.sub_program_id in (11, 1012, 10013, 1094) then 'Prestige Senior Portraits' 
           else sub_program_name end 
)
order by 
 plant_name
, senior_program
, release_category
, thru_date
, fiscal_year
, serve_days_bin_sort
)

&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* Update CDC Load Status */

UPDATE ODS.DW_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE DW_TABLE_NAME=:v_cdc_load_table_name

&


-- /*-----------------------------------------------*/
-- /* TASK No. 5 */
-- /* Insert Audit Record */

-- INSERT INTO ODS_ETL_OWNER.DW_CDC_LOAD_STATUS_AUDIT
-- (TABLE_NAME,
-- SESS_NO,                      
-- SESS_NAME,                    
-- SCEN_VERSION,                 
-- SESS_BEG,                     
-- ORIG_LAST_CDC_COMPLETION_DATE,
-- OVERLAP,
-- CREATE_DATE              
-- )
-- values (
-- :v_cdc_load_table_name,
-- :v_sess_no,
-- 'AGG_PLANT_SERVICE_DAYS_PKG',
-- '001',
-- TO_DATE(
--              SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
-- TO_DATE (SUBSTR (:v_cdc_load_date_ODS_DM, 1, 19),
--                            'YYYY-MM-DD HH24:MI:SS'
--                           ),
-- :v_cdc_overlap,
-- SYSDATE)



-- &


-- /*-----------------------------------------------*/
