BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.actuate_seniorsal_detail_stage';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Create report table  */

create table RAX_APP_USER.actuate_seniorsal_detail_stage as
SELECT country_name,
         company_name,
         fiscal_year,
         'ALL' AS month,
        decode(to_date(
:v_data_export_run_date_trigger_table_refresh,'yyyymmdd'),to_date('01/01/1900','MM/DD/YYYY'),trunc(sysdate - 1),to_date(
:v_data_export_run_date_trigger_table_refresh,'yyyymmdd')) as run_date,
         sub_program_name,
         program_name,
         MAX (
            CASE
               WHEN merchandise_category = 'Product' THEN photo_subj
               ELSE NULL
            END)
            AS photo_subj,
         MAX (
            CASE
               WHEN merchandise_category = 'Product' THEN order_subj
               ELSE NULL
            END)
            AS order_subj,
         MAX (
            CASE
               WHEN merchandise_category = 'Service' THEN net_sales
               ELSE NULL
            END)
            AS serv_net_sales,
           MAX (
              CASE
                 WHEN merchandise_category = 'Service' THEN net_sales
                 ELSE NULL
              END)
         / MAX (
              GREATEST (
                 (CASE
                     WHEN merchandise_category = 'Service' THEN photo_subj
                     ELSE NULL
                  END),
                 1))
            AS sit_avg,
         MAX (
            CASE WHEN merchandise_category = 'Service' THEN tax ELSE NULL END)
            AS serv_tax,
         MAX (
            CASE
               WHEN merchandise_category = 'Product' THEN net_sales
               ELSE NULL
            END)
            AS prod_net_sales,
           MAX (
              CASE
                 WHEN merchandise_category = 'Product' THEN net_sales
                 ELSE NULL
              END)
         / MAX (
              GREATEST (
                 (CASE
                     WHEN merchandise_category = 'Product' THEN order_subj
                     ELSE NULL
                  END),
                 1))
            AS order_avg,
         MAX (
            CASE WHEN merchandise_category = 'Product' THEN tax ELSE NULL END)
            AS prod_tax,
         MAX (
            CASE
               WHEN merchandise_category NOT IN ('Service', 'Product')
               THEN
                  net_sales
               ELSE
                  NULL
            END)
            AS other_net_sales,
         MAX (
            CASE
               WHEN merchandise_category NOT IN ('Service', 'Product') THEN tax
               ELSE NULL
            END)
            AS other_tax,
         SUM (net_paid_sales) AS net_paid_sales,
         SUM (territory_earnings) AS territory_earnings
    FROM (  SELECT o.country_name,
                   o.company_name,
                   m.sub_program_name,
                   m.program_name,
                   i.merchandise_category,
                   t.fiscal_year,
                   SUM (f.photographed_subject_qty) AS photo_subj,
                   SUM (f.order_shipped_subject_qty) AS order_subj,
                   SUM (f.NET_SALES_AMT) AS net_sales,
                   SUM (f.net_paid_sales_amt) AS net_paid_sales,
                   SUM (f.tax_amt) AS tax,
                   SUM (f.territory_earnings_amt) AS territory_earnings
              FROM mart.senior_sales_rollup_mv f,
                   item i,
                   marketing m,
                   organization o,
                   time t,
                   apo,
                   (SELECT  fiscal_year,
                           date_key
                      FROM time
                     WHERE decode(to_date(
:v_data_export_run_date_trigger_table_refresh,'yyyymmdd'),to_date('01/01/1900','MM/DD/YYYY'),trunc(sysdate - 1),to_date(
:v_data_export_run_date_trigger_table_refresh,'yyyymmdd')) = date_key) cfy
             WHERE     f.item_id = i.item_id
                   AND f.marketing_id = m.marketing_id
                   AND f.job_ticket_org_id = o.organization_id
                   AND f.trans_date = t.date_key
                   AND f.ship_date <> TO_DATE ('19000101', 'YYYYMMDD')
                   AND t.fiscal_year = cfy.fiscal_year
                   AND f.trans_date <= cfy.date_key
                   AND ('ALL' = 'ALL' OR t.month_name = 'ALL')
                   AND f.apo_id = apo.apo_id
          -- and apo.source_system_name = 'YANTRA'  -- removed 20140925
          GROUP BY o.country_name,
                   o.company_name,
                   m.sub_program_name,
                   m.program_name,
                   i.merchandise_category,
                   t.fiscal_year
            HAVING    SUM (f.NET_SALES_AMT) <> 0
                   OR SUM (f.net_paid_sales_amt) <> 0
                   OR SUM (f.tax_amt) <> 0
                   OR SUM (f.territory_earnings_amt) <> 0
                   OR SUM (f.photographed_subject_qty) <> 0
                   OR SUM (f.product_order_subject_qty) <> 0
                   OR SUM (f.order_shipped_subject_qty) <> 0)
GROUP BY country_name,
         company_name,
         program_name,
         sub_program_name,
         fiscal_year
ORDER BY 1 DESC,
         2,
         7,
         6,
         country_name,
         program_name,
         sub_program_name