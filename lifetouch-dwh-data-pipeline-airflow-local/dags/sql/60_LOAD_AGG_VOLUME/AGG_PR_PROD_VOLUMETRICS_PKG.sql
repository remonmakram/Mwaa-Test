/* TASK No. 1 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */
/* Delete <Target> Table before loading. */

DELETE  FROM  MART.AGG_PR_PROD_VOLUMETRICS_FACT

&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* Load Target Table */

INSERT INTO MART.AGG_PR_PROD_VOLUMETRICS_FACT
SELECT  
  t.season_name 
, XREF.PLANT_GROUP
, e.school_year
, t.fiscal_year
, t.fiscal_month_number 
, t.fiscal_week_number 
, t.month_number
, t.month_name
, t.sat_production_week_number
, m.sales_line_name 
, m.program_name
, m.sub_program_name
, e.spectrum_ind
, m.marketing_code_name
, e.selling_method_name
, sum(f.calculated_paid_order_qty) as calculated_paid_order
, sum(f.calculated_paid_order_qty + f.unpaid_order_qty) as Total_Order
, sum(f.shipped_order_qty) as Shipped_Order
, sum(CASE WHEN f.plant_receipt_date = '01-JAN-1900' 
           THEN f.calculated_paid_order_qty + f.unpaid_order_qty-f.shipped_order_qty
           ELSE 0
      END 
      ) as pre_picday_orders_not_rec
, sum(CASE WHEN f.plant_receipt_date <> '01-JAN-1900' 
           THEN f.calculated_paid_order_qty + f.unpaid_order_qty-f.shipped_order_qty
           ELSE 0
      END 
      ) as unshipped_orders       
, sum(f.calculated_paid_order_qty + f.unpaid_order_qty)-sum(f.shipped_order_qty) as Backlog_to_Orders
, sum(f.paid_order_qty)
, sum(f.unpaid_order_qty)
, sum(f.click_qty)
, sum(f.photo_session_qty)
, sum(CASE WHEN  E.SELLING_METHOD_NAME = 'PrePay'
           THEN  f.x_no_purchase_qty 
           ELSE 0
      END
     ) as X_Order  
, sum(CASE WHEN  E.SELLING_METHOD_NAME = 'PrePay' AND f.ship_date <> TO_DATE('01-01-1900','DD-MM-YYYY')
           THEN  f.x_no_purchase_qty 
           ELSE 0
      END
     ) as X_SHIPPED_ORDER  
, sum(CASE WHEN  E.SELLING_METHOD_NAME = 'PrePay' AND f.ship_date = TO_DATE('01-01-1900','DD-MM-YYYY')
           THEN  f.x_no_purchase_qty 
           ELSE 0
      END
     ) as X_UNSHIPPED_ORDER    
, TRUNC(SYSDATE)
, sum(CASE WHEN  E.SELLING_METHOD_NAME = 'Proof'
           THEN  f.x_no_purchase_qty 
           ELSE 0
      END
     ) AS PROOF_X_ORDERS
, sum(0) AS PREPAY_SPEC_X_ORDER  
, sum(CASE WHEN  E.SELLING_METHOD_NAME = 'Proof' AND f.ship_date <> TO_DATE('01-01-1900','DD-MM-YYYY')
           THEN  f.x_no_purchase_qty 
           ELSE 0
      END
     )  AS PROOF_X_SHIPPED_ORDER
, sum(0) AS PREPAY_SPEC_X_SHIPPED_ORDER
, sum(CASE WHEN  E.SELLING_METHOD_NAME = 'Proof' AND f.ship_date = TO_DATE('01-01-1900','DD-MM-YYYY')
           THEN  f.x_no_purchase_qty 
           ELSE 0
      END
     ) as PROOF_X_UNSHIPPED_ORDER
, sum(0) AS PREPAY_SPEC_X_UNSHIPPED_ORDER
FROM 
  MART.EVENT_SALES_FACT f,
  MART.EVENT e,
  MART.MARKETING m,
  MART.TIME t,
  MART.JOB_TICKET_ORGANIZATION_VW jt,
  MART.PLANT_NAME_XREF XREF     
where f.event_id = e.event_id
and f.marketing_id = m.marketing_id
and f.trans_date = t.date_key
and e.PLANT_NAME = XREF.PLANT_NAME
and (t.fiscal_year = (SELECT FISCAL_YEAR FROM TIME WHERE DATE_KEY = (SELECT TRUNC(SYSDATE) FROM DUAL)) 
     OR
     t.fiscal_year = (SELECT FISCAL_YEAR - 1 FROM TIME WHERE DATE_KEY = (SELECT TRUNC(SYSDATE) FROM DUAL)))  
and m.program_name <> 'Money Trans' 
and m.sub_program_name not in ('Commencements')
and substr(e.job_nbr,9,1) not in 'I'
and jt.organization_id = f.job_ticket_org_id
and jt.territory_code NOT IN ('LN')
group by  
  t.season_name 
, XREF.PLANT_GROUP
, e.school_year
, t.fiscal_year
, t.fiscal_month_number 
, t.fiscal_week_number 
, t.month_number
, t.month_name
, t.sat_production_week_number
, m.sales_line_name 
, m.program_name
, m.sub_program_name
, e.spectrum_ind
, m.marketing_code_name
, e.selling_method_name
, TRUNC(SYSDATE)

&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* Delete the Current Fiscal Week Records from AGG Table */

/*
DELETE FROM MART.AGG_PR_PROD_VOLUMETRICS_FACT
WHERE (FISCAL_YEAR,SAT_PRODUCTION_WEEK_NUMBER) 
IN (SELECT B.FISCAL_YEAR,
           A.SAT_PRODUCTION_WEEK_NUMBER       
           FROM
           (SELECT FISCAL_YEAR,SAT_PRODUCTION_WEEK_NUMBER,MIN(DATE_KEY) DATE_KEY FROM MART.TIME
            WHERE FISCAL_YEAR = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME  WHERE DATE_KEY = TRUNC(SYSDATE))
            AND SAT_PRODUCTION_WEEK_NUMBER = (SELECT DISTINCT SAT_PRODUCTION_WEEK_NUMBER FROM MART.TIME  
                                                                WHERE DATE_KEY = TRUNC(SYSDATE))
            GROUP BY FISCAL_YEAR,SAT_PRODUCTION_WEEK_NUMBER
            ORDER BY 3
            )A, 
            MART.TIME B
            WHERE A.DATE_KEY = B.DATE_KEY
            )
*/


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Update CDC Load Status */

UPDATE ODS.DW_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE DW_TABLE_NAME=:v_cdc_load_table_name

&


-- /*-----------------------------------------------*/
-- /* TASK No. 6 */
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
-- 'AGG_PR_PROD_VOLUMETRICS_PKG',
-- '022',
-- TO_DATE(
--              SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
-- TO_DATE (SUBSTR (:v_cdc_load_date_ODS_DM, 1, 19),
--                            'YYYY-MM-DD HH24:MI:SS'
--                           ),
-- :v_cdc_overlap,
-- SYSDATE)



-- &


/*-----------------------------------------------*/
