/* TASK No. 1 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 2 */




/*-----------------------------------------------*/
/* TASK No. 3 */
/* Drop Detail Post Adds Up Table */

-- drop table detail_post_adds_up

-- &


/*-----------------------------------------------*/
/* TASK No. 4 */
/* Create and  Detail Post Adds Up table */

-- CREATE TABLE detail_post_adds_up AS
-- SELECT dtl.std_id,
--          main.host_no,
--          main.std_status,
--          dtl.tran_no,
--          dtl.pos_id,
--          dtl.pos_sit_no,
--          dtl.tran_date,
--          dtl.order_type,
--          dtl.sit_cnt,
--          dtl.tot_sales,
--          dtl.ASSOC_DISC,
--          COUNT (*)
--              nbr_rcds,
--          dtl.merch_sales,
--          dtl.pc_sales,
--          dtl.port_sales,
--          dtl.disc,
--          dtl.ship_sales,
--          dtl.spec_sales,
--          CASE
--              WHEN dtl.order_type = 'x'
--              THEN
--                  (  tot_sales
--                   - NVL (dtl.merch_sales, 0)
--                   - NVL (dtl.PC_sales, 0)
--                   - NVL (dtl.port_sales, 0)
--                   - NVL (dtl.ship_sales, 0)
--                   - NVL (dtl.spec_sales, 0)
--                   - NVL (dtl.ASSOC_DISC, 0))
--              ELSE
--                  (  tot_sales
--                   - NVL (dtl.merch_sales, 0)
--                   - NVL (dtl.PC_sales, 0)
--                   - NVL (dtl.port_sales, 0)
--                   - NVL (dtl.ship_sales, 0)
--                   - NVL (dtl.spec_sales, 0))
--          END
--              sales_diff
--     FROM LPS_FIN_OWN.detail_post dtl JOIN LPS.STD_MAIN main ON dtl.std_id = main.std_id
--    WHERE 
--  --dtl.pos_id = 'B46620101201323841385'
-- dtl.post_date IS NULL
-- GROUP BY dtl.std_id,
--          main.std_status,
--          main.host_no,
--          dtl.tran_no,
--          dtl.pos_id,
--          dtl.pos_sit_no,
--          dtl.tran_date,
--          dtl.order_type,
--          dtl.sit_cnt,
--          dtl.tot_sales,
--          dtl.ASSOC_DISC,
--          dtl.merch_sales,
--          dtl.pc_sales,
--          dtl.port_sales,
--          dtl.spec_sales,
--          dtl.disc,
--          dtl.ship_sales
--   HAVING CASE
--              WHEN dtl.order_type = 'x'
--              THEN
--                  (  tot_sales
--                   - NVL (dtl.merch_sales, 0)
--                   - NVL (dtl.PC_sales, 0)
--                   - NVL (dtl.port_sales, 0)
--                   - NVL (dtl.ship_sales, 0)
--                   - NVL (dtl.spec_sales, 0)
--                   - NVL (dtl.ASSOC_DISC, 0))
--              ELSE
--                  (  tot_sales
--                   - NVL (dtl.merch_sales, 0)
--                   - NVL (dtl.PC_sales, 0)
--                   - NVL (dtl.port_sales, 0)
--                   - NVL (dtl.ship_sales, 0)
--                   - NVL (dtl.spec_sales, 0))
--          END <>
--          0
-- ORDER BY dtl.std_id, dtl.pos_id

-- &


/*-----------------------------------------------*/
/* TASK No. 5 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 5 */




/*-----------------------------------------------*/
/* TASK No. 6 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 6 */




/*-----------------------------------------------*/
/* TASK No. 9 */
/* Drop Detail Post Header Child Diff Table */

-- drop table detail_post_header_child_diff

-- &


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Create and  Detail Post Header Child Diff Table  */

-- CREATE TABLE detail_post_header_child_diff AS
-- SELECT dtl.std_id,
--          main.host_no,
--          main.std_status,
--          dtl.tran_no,
--          dtl.pos_id,
--          dtl.pos_sit_no,
--          dtl.tran_date,
--          dtl.ORDER_TYPE,
--          dtl.sit_cnt,
--          dtl.tot_sales,
--          merch.merch_pos_code_amt_sum,
--          act1.act_pos_code_amt_sum,
--          (  tot_sales
--           - NVL (merch.merch_pos_code_amt_sum, 0)
--           - NVL (act1.act_pos_code_amt_sum, 0))
--              sales_diff,
--          COUNT (*)
--              nbr_rcds,
--          dtl.port_sales,
--          dtl.PC_SALES,
--          dtl.disc,
--          dtl.ship_sales
--     FROM detail_post dtl
--          JOIN std_main main ON dtl.std_id = main.std_id
--          LEFT JOIN (SELECT act.pos_id, SUM (act.pos_code_amt) act_pos_code_amt_sum
--              FROM act_pos_post act
--                   JOIN (SELECT pos_id
--            FROM detail_post
--           WHERE post_date IS NULL)not_posted ON act.pos_id = not_posted.pos_id
--          GROUP BY act.pos_id) act1 ON dtl.pos_id = act1.pos_id
--          LEFT JOIN (SELECT merch.pos_id,
--                   SUM (merch.pos_code_amt * merch.pos_code_qty)
--                       merch_pos_code_amt_sum
--              FROM merch_post merch
--                   JOIN (SELECT pos_id
--            FROM detail_post
--           WHERE post_date IS NULL) not_posted ON merch.pos_id = not_posted.pos_id
--          GROUP BY merch.pos_id)merch ON dtl.pos_id = merch.pos_id
--    WHERE 
--    dtl.post_date IS NULL
--   -- dtl.pos_id='B46620112201323841420'
-- --where   post_date = '7-jun-2021'
-- GROUP BY dtl.std_id,
--          main.std_status,
--          main.host_no,
--          dtl.tran_no,
--          dtl.pos_id,
--          dtl.pos_sit_no,
--          dtl.tran_date,
--          dtl.ORDER_TYPE,
--          dtl.sit_cnt,
--          merch.merch_pos_code_amt_sum,
--          dtl.tot_sales,
--          act1.act_pos_code_amt_sum,
--          dtl.port_sales,
--          dtl.PC_SALES,
--          dtl.disc,
--          dtl.ship_sales
--   HAVING (  tot_sales
--           - NVL (merch.merch_pos_code_amt_sum, 0)
--           - NVL (act1.act_pos_code_amt_sum, 0)) <> 0
-- ORDER BY dtl.std_id, dtl.pos_id

-- &


/*-----------------------------------------------*/
/* TASK No. 11 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 11 */




/*-----------------------------------------------*/
/* TASK No. 12 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 12 */




/*-----------------------------------------------*/
/* TASK No. 15 */
/* Drop  PLPS DETAIL ACT POS POST NOT X ORDERS Table */

-- drop table detail_act_pos_not_x_orders

-- &


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Create and Detail Act Pos Post Not X Orders Table  */

-- CREATE TABLE  detail_act_pos_not_x_orders AS
-- SELECT not_posted.std_id,
--          not_posted.tran_date,
--          not_posted.tran_no,
--          not_posted.order_type,
--          'act_pos_post diff'     AS issue_with
--     FROM (SELECT pos_id,
--                 std_id,
--                 tran_date,
--                 tran_no,
--                 order_type
--            FROM detail_post
--           WHERE     post_date IS NULL
--                 AND (pc_sales <> 0 OR spec_sales <> 0 OR port_sales <> 0)
--                 AND order_type <> 'x') NOT_POSTED
--          LEFT OUTER JOIN act_pos_post a ON a.pos_id = not_posted.pos_id
--    WHERE
--    a.pos_id IS NULL
--    --not_posted.tran_no='447j4476'
-- ORDER BY not_posted.tran_date, not_posted.std_id, not_posted.tran_no

-- &


/*-----------------------------------------------*/
/* TASK No. 17 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 17 */




/*-----------------------------------------------*/
/* TASK No. 18 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 18 */




/*-----------------------------------------------*/
/* TASK No. 21 */
/* Drop Detail Merch Pos Not X Orders Table */

-- drop table detail_merch_pos_not_x_orders

-- &


/*-----------------------------------------------*/
/* TASK No. 22 */
/* Create and   Detail Merch Pos Not X Orders table */

-- CREATE TABLE detail_merch_pos_not_x_orders AS
--  SELECT not_posted.std_id,
--          not_posted.tran_date,
--          not_posted.tran_no,
--          not_posted.pos_id,
--          not_posted.order_type,
--          'merch_post diff'     AS issue_with
--     FROM (SELECT pos_id,
--                 std_id,
--                 tran_date,
--                 tran_no,
--                 order_type
--            FROM detail_post d
--           WHERE post_date IS NULL AND merch_sales <> 0 AND order_type <> 'x') not_posted
--          LEFT OUTER JOIN merch_post a ON a.pos_id = not_posted.pos_id
--    WHERE 
--    a.pos_id IS NULL
--   -- not_posted.tran_no='44wgvni4'
-- ORDER BY not_posted.tran_date, not_posted.std_id, not_posted.tran_no

-- &


/*-----------------------------------------------*/
/* TASK No. 23 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 23 */




/*-----------------------------------------------*/
/* TASK No. 24 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 24 */




/*-----------------------------------------------*/
/* TASK No. 27 */
/* Drop Act Pos Not In  Detail Post Table */

-- drop table act_pos_not_in_detail_post

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 28 */
-- /* Create and  Act Pos Not In  Detail Post Table  */

-- CREATE TABLE act_pos_not_in_detail_post AS
-- SELECT act_pos.pos_id, 'act_pos_post diff' AS issue_with
--   FROM  (SELECT DISTINCT pos_id
--            FROM act_pos_post) ACT_POS LEFT OUTER JOIN detail_post d ON d.pos_id = act_pos.pos_id
--  WHERE 
--  d.pos_id IS  NULL 
-- --d.pos_id='P0003010120095600'
--  AND act_pos.pos_id LIKE 'P%'

-- &


/*-----------------------------------------------*/
/* TASK No. 29 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 29 */




/*-----------------------------------------------*/
/* TASK No. 30 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 30 */




/*-----------------------------------------------*/
/* TASK No. 31 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 31 */




/*-----------------------------------------------*/
/* TASK No. 32 */

-- OdiSendMail "-MAILHOST=LTIVRS1.LIFETOUCH.NET" "-FROM=ODI_EMAIL-PROD@Lifetouch.com" "-SUBJECT=PLPS Data Error - Orders in Act pos post which are not in Detail post" "-TO=:v_error_email_to"
-- Data Center - :v_US_data_center

-- PLPS Data Error in the last 24 hours:

-- POS_ID                                                  ISSUE_WITH
-- --:v_act_pos_not_in_detail_post_updates

-- The source for this package is in:
-- ODS_Project -> LPS_Folder -> MONITOR_PLPS_DATA_ISSUES_PKG

-- Please feel free to enhance, improve, or refine as you see fit.

-- &


/*-----------------------------------------------*/
/* TASK No. 33 */
/* Drop Merch Pos Not In Detail Post Table */

-- drop table merch_pos_not_in_detail_post

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 34 */
-- /* Create and  Merch Pos Not In Detail Post Table  */

-- CREATE TABLE merch_pos_not_in_detail_post AS
-- SELECT merch_pos.pos_id, 'merch_post diff' AS issue_with
--   FROM  (SELECT DISTINCT pos_id
--            FROM merch_post) merch_pos LEFT OUTER JOIN detail_post d ON d.pos_id = merch_pos.pos_id
--  WHERE d.pos_id IS NULL AND merch_pos.pos_id LIKE 'P%'

-- &


/*-----------------------------------------------*/
/* TASK No. 35 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 35 */




/*-----------------------------------------------*/
/* TASK No. 36 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 36 */




/*-----------------------------------------------*/
/* TASK No. 39 */
/* Drop Order Guid In Cli Not In Clh Table */

-- drop table order_guid_in_cli_not_in_clh

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 40 */
-- /* Create and rder Guid In Cli Not In Clh table */

-- CREATE TABLE order_guid_in_cli_not_in_clh AS
-- /*SELECT ccdetail.order_guid,
--        'ccpricinglineitem not in CCpricingorderheader'     AS query_source
--   FROM  (SELECT DISTINCT order_guid
--            FROM ccpricinglineitem
--         ) ccdetail
--  WHERE 
--  ccdetail.order_guid ='000002df-5546-420d-b2d8-d7f8f9a4e3d5'*/

--  SELECT ccdetail.order_guid,
--        'ccpricinglineitem not in CCpricingorderheader'     AS query_source
--   FROM  (SELECT DISTINCT order_guid
--            FROM ccpricinglineitem
--         ) ccdetail
--  WHERE ccdetail.order_guid NOT IN (SELECT order_guid FROM  (SELECT o.order_guid
--            FROM ccpricingorderheader o-- where o.order_date > '1-oct-2020'
--                                       ) ccheader)

-- &


/*-----------------------------------------------*/
/* TASK No. 41 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 41 */




/*-----------------------------------------------*/
/* TASK No. 42 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 42 */




/*-----------------------------------------------*/
/* TASK No. 45 */
/* Drop Order Guid In Coh Not In Cli Table */

-- drop table order_guid_in_coh_not_in_cli

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 46 */
-- /* Create and   Order Guid In Coh Not In Cli table */

-- CREATE TABLE order_guid_in_coh_not_in_cli AS
--  /*  SELECT ccheader.order_guid,ccheader.std_id  ,ccheader.order_date,
--        'ccpricinglineitem not in CCpricingorderheader'     AS query_source
--   FROM  (SELECT o.order_guid,
--                 o.std_id,
--                 o.order_date
--            FROM ccpricingorderheader o-- where o.order_date > '1-oct-2020'
--         ) ccheader
--  WHERE 
--  ccheader.order_guid ='00003be4-30af-43fa-b0ea-bb60a773643b'
--  and ccheader.order_date > '1-jan-2022'*/



-- SELECT ccheader.order_guid,ccheader.std_id  ,ccheader.order_date,
--        'ccpricinglineitem not in CCpricingorderheader'     AS query_source
--   FROM  (SELECT o.order_guid,
--                 o.std_id,
--                 o.order_date
--            FROM ccpricingorderheader o-- where o.order_date > '1-oct-2020'
--         ) ccheader
--  WHERE ccheader.order_guid NOT IN (SELECT order_guid FROM (SELECT DISTINCT order_guid
--            FROM ccpricinglineitem
--         ) ccdetail)
--  and ccheader.order_date > '1-jan-2022' 

-- &


/*-----------------------------------------------*/
/* TASK No. 47 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 47 */




/*-----------------------------------------------*/
/* TASK No. 48 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 48 */




/*-----------------------------------------------*/
/* TASK No. 51 */
/* Drop Diff In Coh And Cli Table */

-- drop table diff_in_coh_and_cli

-- &


/*-----------------------------------------------*/
/* TASK No. 52 */
/* Create and Diff In Coh And Cli table */

-- CREATE TABLE diff_in_coh_and_cli AS
--   SELECT ccheader.order_guid,
--          ccheader.std_id,
--          ccheader.order_date,
--          ccheader.order_type,
--          ccheader.order_id,
--          SUM (ccheader.tot_sales - ccdetail.sales_price)
--              AS sales_diff,
--          'CCpricingorderheader total not equal ccpricinglineitem'
--              AS query_source
--     FROM (  
--            SELECT o.order_guid,
--                   o.std_id,
--                  o.order_date,
--                  o.order_type,
--                  o.order_id,
--             SUM (o.tot_order_sale_price + o.tot_order_ship_price) as tot_sales
--             FROM ccpricingorderheader o
--            WHERE o.order_date > '1-oct-2020' AND o.post_date IS NULL
--            GROUP BY o.order_guid,
--                   o.std_id,
--                  o.order_date,
--                  o.order_type,
--                  o.order_id
--         ) ccheader JOIN 
--         (  SELECT l.order_guid, SUM (l.sale_price * l.quantity) sales_price
--              --  select *
--             from CCPRICINGLINEITEM l            
--             left join ccpricingorderheader o ON l.order_guid = o.order_guid
--             WHERE o.order_date > '1-oct-2020'
--               AND o.post_date IS NULL
--               AND l.line_item_price_type NOT IN ('TAX', 'TAX_ADJUSTMENT','DELIVERY_FEE')
--          GROUP BY l.order_guid, order_id) ccdetail ON ccdetail.order_guid = ccheader.order_guid
-- GROUP BY ccheader.order_guid,
--          ccheader.std_id,
--          ccheader.order_date,
--          ccheader.order_type,
--          ccheader.order_id
--   HAVING SUM (ccheader.tot_sales - ccdetail.sales_price) <> 0

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 53 */

-- /* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 53 */




-- /*-----------------------------------------------*/
-- /* TASK No. 54 */

-- /* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 54 */




-- /*-----------------------------------------------*/
-- /* TASK No. 57 */
-- /* Drop Promo Code Missing Revenue Share Table */

-- drop table promo_code_miss_rev_share

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 58 */
-- /* Create and Promo Code Missing Revenue Share table */

-- CREATE TABLE promo_code_miss_rev_share AS
-- SELECT promo_code.order_guid,
--        promo_code.promo_code,
--        'groupon missing from REVENUE_SHARE'     AS issue_with
--   --select *
--   FROM  (SELECT o.order_guid,
--                 pp.promo_code,
--                 SUBSTR (pp.PROMO_CODE, 1, 5)     AS core
--            FROM ccpricingorderheader  o
--                 JOIN ccpricingpromo pp ON pp.order_guid = o.order_guid
--           WHERE post_date IS NULL AND LENGTH (pp.promo_code) > 8--and std_id = 'P0004'
-- 		  ) promo_code 
--        JOIN REF_DAILY_DEAL_CODES r ON r.DD_PROMO_CODE = promo_code.core
--        LEFT OUTER JOIN REVENUE_SHARE d ON d.order_guid = promo_code.order_guid
--  WHERE 
-- d.order_guid IS  NULL
-- --d.order_guid='f371ad44-73f0-494d-9f3d-14e68e9db454'
--  AND r.dd_active = 'Yes'
-- --and merch_pos.pos_id like 'P%'

-- &


/*-----------------------------------------------*/
/* TASK No. 59 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 59 */




/*-----------------------------------------------*/
/* TASK No. 60 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 60 */




/*-----------------------------------------------*/
/* TASK No. 63 */
/* Drop Std Org Load Incorrect Table */

-- drop table std_org_load_incorrect

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 64 */
-- /* Create and Std Org Load Incorrect table */

-- CREATE TABLE std_org_load_incorrect AS
--  SELECT *
--   FROM STD_ORGANIZATION
--  WHERE     mgr_no <> SUBSTR (std_org, 21, 3)
--     AND SUBSTR (std_org, 7, 5) = 'V0001'
--       -- AND SUBSTR (std_org, 7, 5) <>  'V0001'
--        AND mgr_no NOT IN (199,
--                           999,
--                           919,
--                           969)

-- &


/*-----------------------------------------------*/
/* TASK No. 65 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 65 */




/*-----------------------------------------------*/
/* TASK No. 66 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 66 */




/*-----------------------------------------------*/
/* TASK No. 69 */
/* Drop Order Code New Prod Ccpricing Table */

-- drop table order_code_new_prod_ccpricing

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 70 */
-- /* Create and Order Code New Prod Ccpricing table */

-- CREATE TABLE order_code_new_prod_ccpricing AS
-- select 'new products' as New_Products, l.* 
-- from ccpricingorderheader o
-- join ccpricinglineitem l on l.order_guid = o.order_guid   
-- where  o.order_date > '1-jan-2022' 
-- --o.order_date > '1-jan-2018' --
-- and order_code > 90
-- --and o.ORDER_GUID='8c72a28e-6f7f-4490-a827-962552e95693' --

-- &


/*-----------------------------------------------*/
/* TASK No. 71 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 71 */




/*-----------------------------------------------*/
/* TASK No. 72 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 72 */




/*-----------------------------------------------*/
/* TASK No. 75 */
/* Drop Diff In Ccp And Detail Post Table */

-- drop table diff_in_ccp_nd_dP_not_in_CCP

-- &


/*-----------------------------------------------*/
/* TASK No. 76 */
/* Create and Diff In Ccp And Detail Post table */

-- CREATE TABLE  diff_in_ccp_nd_dP_not_in_CCP  AS
-- SELECT not_posted.*,  'not in ccpricing' AS query_source
--   FROM  (SELECT std_id,
--                 tran_no,
--                 tran_date,
--                 tot_sales
--            FROM detail_post
--           WHERE tran_date > '1-Nov-2021' AND post_date IS NULL) not_posted 
-- 		  LEFT JOIN  (SELECT o.std_id,
--                 o.order_id,
--                 o.order_date,
--                 o.order_type,
--                 o.order_guid ,
--                 o.TOT_ORDER_SALE_PRICE,
--                 o.TOT_ORDER_SHIP_PRICE,
--                 NVL (o.ORDER_ADJUSTMENT_AMOUNT, 0)
--                     AS ORDER_ADJUSTMENT_AMOUNT
--            FROM CCPRICINGORDERHEADER o
--           WHERE     o.order_date > '1-Nov-2021'
--                -- AND o.order_type <> 'm'
--                 AND post_date IS NULL) ccpricing 
-- ON ccpricing.order_id = not_posted.tran_no
--  WHERE 
-- ccpricing.order_id IS NULL
-- --not_posted.TRAN_NO ='440khopb'

-- &


/*-----------------------------------------------*/
/* TASK No. 77 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 77 */




/*-----------------------------------------------*/
/* TASK No. 78 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 78 */




/*-----------------------------------------------*/
/* TASK No. 81 */
/* Drop Diff In Ccp Not In Detail PosTable */

-- drop table diff_in_ccp_not_in_detail_pos

-- &


/*-----------------------------------------------*/
/* TASK No. 82 */
/* Create and Diff In Ccp Not In Detail Pos table */

-- CREATE TABLE diff_in_ccp_not_in_detail_pos AS
-- SELECT ccpricing.*, 'In CCpricing but not in detail_post' AS query_source
--   FROM  (SELECT o.std_id,
--                 o.order_id,
--                 o.order_date,
--                 o.order_type,
--                 o.TOT_ORDER_SALE_PRICE,
--                 o.TOT_ORDER_SHIP_PRICE,
--                 NVL (o.ORDER_ADJUSTMENT_AMOUNT, 0)
--                     AS ORDER_ADJUSTMENT_AMOUNT
--            FROM CCPRICINGORDERHEADER o
--           WHERE     o.order_date > '1-Nov-2021'
--                 AND o.order_type <> 'm'
--                 AND post_date IS NULL--  and o.std_id = 'P0411'
--                                      ) ccpricing  
--   LEFT JOIN  (SELECT std_id,
--                 tran_no,
--                 tran_date,
--                 tot_sales
--            FROM detail_post
--           WHERE tran_date > '1-Nov-2021' AND post_date IS NULL-- and std_id = 'P0411'
--                                                               )not_posted  ON not_posted.tran_no = ccpricing.order_id
--  WHERE 
--  not_posted.tran_no IS NULL
--  --ccpricing.ORDER_ID='440khopb'
 

-- &


/*-----------------------------------------------*/
/* TASK No. 83 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 83 */




/*-----------------------------------------------*/
/* TASK No. 84 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 84 */




/*-----------------------------------------------*/
/* TASK No. 87 */
/* Drop Diff In Ccpricing Detail PosTable */

-- drop table diff_in_ccpricing_detail_post

-- &


/*-----------------------------------------------*/
/* TASK No. 88 */
/* Create and  Diff In Ccpricing Detail Pos table */

-- CREATE TABLE diff_in_ccpricing_detail_post AS
--  SELECT *
--     FROM (  SELECT ccpricing.std_id,
--                    ccpricing.order_date,
--                    ccpricing.order_id,
--                    ccpricing.order_type,
--                    ccpricing.STUDIO_SOFTWARE_VERSION,
--                    CASE
--                        WHEN ccpricing.STUDIO_SOFTWARE_VERSION >= '5.3.7-RC37'
--                        THEN
--                            SUM (
--                                  ccpricing.TOT_ORDER_SALE_PRICE
--                                + ccpricing.TOT_ORDER_SHIP_PRICE)
--                        ELSE
--                            SUM (
--                                  ccpricing.TOT_ORDER_SALE_PRICE
--                                + ccpricing.TOT_ORDER_SHIP_PRICE
--                                + ccpricing.ORDER_ADJUSTMENT_AMOUNT)
--                    END
--                        ccpricing_tot_537--, sum(ccpricing.TOT_ORDER_SALE_PRICE + ccpricing.TOT_ORDER_SHIP_PRICE + ccpricing.ORDER_ADJUSTMENT_AMOUNT) as ccpricing_tot
--                                         ,
--                    SUM (not_posted.tot_sales)
--                        AS detail_tot,
--                    CASE
--                        WHEN ccpricing.STUDIO_SOFTWARE_VERSION >= '5.3.7-RC37'
--                        THEN
--                            SUM (
--                                  (  ccpricing.TOT_ORDER_SALE_PRICE
--                                   + ccpricing.TOT_ORDER_SHIP_PRICE)
--                                - not_posted.tot_sales)
--                        ELSE
--                            SUM (
--                                  (  ccpricing.TOT_ORDER_SALE_PRICE
--                                   + ccpricing.TOT_ORDER_SHIP_PRICE
--                                   + ccpricing.ORDER_ADJUSTMENT_AMOUNT)
--                                - not_posted.tot_sales)
--                    END
--                        sale_diff--, sum((ccpricing.TOT_ORDER_SALE_PRICE + ccpricing.TOT_ORDER_SHIP_PRICE + ccpricing.ORDER_ADJUSTMENT_AMOUNT) -  not_posted.tot_sales) as sale_diff
--                                 ,
--                    'ccpricing diff'
--                        AS issue_with
--               FROM (SELECT o.std_id,
--                 o.order_id,
--                 o.order_date,
--                 o.order_type,
--                 o.TOT_ORDER_SALE_PRICE,
--                 o.TOT_ORDER_SHIP_PRICE,
--                 NVL (o.ORDER_ADJUSTMENT_AMOUNT, 0)
--                     AS ORDER_ADJUSTMENT_AMOUNT,
--                 o.STUDIO_SOFTWARE_VERSION
--            FROM CCPRICINGORDERHEADER o
--           WHERE     (o.post_date IS NULL OR o.post_date <> '')
--                 AND o.order_type <> 'm'
--                 AND o.order_date > TRUNC (SYSDATE) - 30) ccpricing
--                    JOIN 
--         (SELECT std_id,
--                 tran_no,
--                 tran_date,
--                 tot_sales
--            FROM detail_post
--           --  where   post_date is null
--           WHERE post_date IS NULL) not_posted
--                        ON (    not_posted.std_id = ccpricing.std_id
--                            AND not_posted.tran_no = ccpricing.order_id)
--           GROUP BY ccpricing.std_id,
--                    ccpricing.order_date,
--                    ccpricing.order_id,
--                    ccpricing.order_type,
--                    ccpricing.STUDIO_SOFTWARE_VERSION) a
--    WHERE 
--    sale_diff <> 0
--    --a.ORDER_ID='456kb2sc'
-- ORDER BY order_date

-- &


/*-----------------------------------------------*/
/* TASK No. 89 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 89 */




/*-----------------------------------------------*/
/* TASK No. 90 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 90 */




/*-----------------------------------------------*/
/* TASK No. 93 */
/* Drop ALL ACT CHILD REC IDF POS IDS Table */

-- drop table all_act_child_rec_idf_pos_ids

-- &


/*-----------------------------------------------*/
/* TASK No. 94 */
/* Create and ALL ACT CHILD REC IDF POS IDS Table  */

-- CREATE TABLE  all_act_child_rec_idf_pos_ids  AS
-- SELECT act.*
--   FROM act_pos_post act JOIN (  SELECT dtl.std_id,
--                   dtl.pos_id,
--                   dtl.pos_sit_no,
--                   dtl.tran_date,
--                   dtl.sit_cnt,
--                   dtl.tot_sales,
--                   merch.merch_pos_code_amt_sum,
--                   act1.act_pos_code_amt_sum,
--                   inact_pos_code_amt_sum,
--                   (  tot_sales
--                    - NVL (merch.merch_pos_code_amt_sum, 0)
--                    - NVL (act1.act_pos_code_amt_sum, 0)
--                    - NVL (inact_pos_code_amt_sum, 0))
--                       sales_diff,
--                   COUNT (*)
--                       nbr_rcds,
--                   dtl.port_sales
--              FROM detail_post dtl
--                   LEFT JOIN (  SELECT act.pos_id, SUM (act.pos_code_amt) act_pos_code_amt_sum
--              FROM act_pos_post act
--                   JOIN  (SELECT pos_id
--            FROM detail_post
--           WHERE post_date IS NULL) not_posted ON act.pos_id = not_posted.pos_id
--          GROUP BY act.pos_id) act1 ON dtl.pos_id = act1.pos_id
--                   LEFT JOIN (  SELECT inact.pos_id, SUM (inact.pos_code_amt) inact_pos_code_amt_sum
--              FROM inact_pos_post inact
--                   JOIN  (SELECT pos_id
--            FROM detail_post
--           WHERE post_date IS NULL) not_posted ON inact.pos_id = not_posted.pos_id
--          GROUP BY inact.pos_id) inact1 ON dtl.pos_id = inact1.pos_id
--                   LEFT JOIN (  SELECT merch.pos_id,
--                   SUM (merch.pos_code_amt * merch.pos_code_qty)
--                       merch_pos_code_amt_sum
--              FROM merch_post merch
--                   JOIN  (SELECT pos_id
--            FROM detail_post
--           WHERE post_date IS NULL) not_posted ON merch.pos_id = not_posted.pos_id
--          GROUP BY merch.pos_id) merch ON dtl.pos_id = merch.pos_id
--             WHERE dtl.post_date IS NULL
--          GROUP BY dtl.std_id,
--                   dtl.pos_id,
--                   dtl.pos_sit_no,
--                   dtl.tran_date,
--                   dtl.sit_cnt,
--                   merch.merch_pos_code_amt_sum,
--                   dtl.tot_sales,
--                   act1.act_pos_code_amt_sum,
--                   inact_pos_code_amt_sum,
--                   dtl.port_sales
--            HAVING (  tot_sales
--                    - NVL (merch.merch_pos_code_amt_sum, 0)
--                    - NVL (act1.act_pos_code_amt_sum, 0)
--                   - NVL (inact_pos_code_amt_sum, 0) )  <> 0
--          ORDER BY dtl.std_id, dtl.pos_id) diffs1 ON act.pos_id = diffs1.pos_id
--       --   where act.pos_id ='P00142023091743tz2out' ---

-- &


/*-----------------------------------------------*/
/* TASK No. 95 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 95 */




/*-----------------------------------------------*/
/* TASK No. 96 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 96 */




/*-----------------------------------------------*/
/* TASK No. 99 */
/* Drop ALL MER CHILD REC IDF POS IDS Table */

-- drop table all_mer_child_rec_idf_pos_ids

-- &


/*-----------------------------------------------*/
/* TASK No. 100 */
/* Create and ALL MER CHILD REC IDF POS IDS Table  */

-- CREATE TABLE  all_mer_child_rec_idf_pos_ids AS
-- SELECT merch.*
--   FROM merch_post merch JOIN (  SELECT dtl.std_id,
--                   dtl.pos_id,
--                   dtl.pos_sit_no,
--                   dtl.tran_date,
--                   dtl.sit_cnt,
--                   dtl.tot_sales,
--                   dtl.MERCH_SALES,
--                   merch.merch_pos_code_amt_sum,
--                   act1.act_pos_code_amt_sum,
--                   inact_pos_code_amt_sum,
--                   (  tot_sales
--                    - NVL (merch.merch_pos_code_amt_sum, 0)
--                    - NVL (act1.act_pos_code_amt_sum, 0)
--                    - NVL (inact_pos_code_amt_sum, 0))
--                       sales_diff,
--                   COUNT (*)
--                       nbr_rcds,
--                   dtl.port_sales
--              FROM detail_post dtl
--                   LEFT JOIN (  SELECT act.pos_id, SUM (act.pos_code_amt) act_pos_code_amt_sum
--              FROM act_pos_post act
--                   JOIN   (SELECT pos_id
--            FROM detail_post
--           WHERE post_date IS NULL) not_posted ON act.pos_id = not_posted.pos_id
--          GROUP BY act.pos_id) act1 ON dtl.pos_id = act1.pos_id
--                   LEFT JOIN  (  SELECT inact.pos_id, SUM (inact.pos_code_amt) inact_pos_code_amt_sum
--              FROM inact_pos_post inact
--                   JOIN   (SELECT pos_id
--            FROM detail_post
--           WHERE post_date IS NULL) not_posted ON inact.pos_id = not_posted.pos_id
--          GROUP BY inact.pos_id) inact1 ON dtl.pos_id = inact1.pos_id
--                   LEFT JOIN (  SELECT merch.pos_id,
--                   SUM (merch.pos_code_amt * merch.pos_code_qty)
--                       merch_pos_code_amt_sum
--              FROM merch_post merch
--                   JOIN   (SELECT pos_id
--            FROM detail_post
--           WHERE post_date IS NULL) not_posted ON merch.pos_id = not_posted.pos_id
--          GROUP BY merch.pos_id) merch ON dtl.pos_id = merch.pos_id
--             WHERE dtl.post_date IS NULL
--          GROUP BY dtl.std_id,
--                   dtl.pos_id,
--                   dtl.pos_sit_no,
--                   dtl.tran_date,
--                   dtl.sit_cnt,
--                   merch.merch_pos_code_amt_sum,
--                   dtl.tot_sales,
--                   dtl.merch_sales,
--                   act1.act_pos_code_amt_sum,
--                   inact_pos_code_amt_sum,
--                   dtl.port_sales
--            HAVING (  tot_sales
--                    - NVL (merch.merch_pos_code_amt_sum, 0)
--                    - NVL (act1.act_pos_code_amt_sum, 0)
--                    - NVL (inact_pos_code_amt_sum, 0))  <> 0
--          ORDER BY dtl.std_id, dtl.pos_id) diffs1 ON merch.pos_id = diffs1.pos_id
--         -- where diffs1.pos_id ='P00932023091844xlgd4i' --

-- &


/*-----------------------------------------------*/
/* TASK No. 101 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 101 */




/*-----------------------------------------------*/
/* TASK No. 102 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 102 */




/*-----------------------------------------------*/
/* TASK No. 105 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 105 */




/*-----------------------------------------------*/
/* TASK No. 106 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 106 */




/*-----------------------------------------------*/
/* TASK No. 107 */
/* Drop ccpricinglineitem is null Table */

-- drop table CCPricingLineItem_is_nul

-- &


/*-----------------------------------------------*/
/* TASK No. 108 */
/* Create and ccpricinglineitem is null table */

-- CREATE TABLE CCPricingLineItem_is_nul AS
-- select * from CCPricingLineItem
-- where SBASE_CODE  IS NULL

-- &


/*-----------------------------------------------*/
/* TASK No. 109 */
/* prepare attachment */

-- OdiSqlUnload "-FILE=:v_ccpli_filename" "-DRIVER=oracle.jdbc.OracleDriver" "-URL=jdbc:oracle:thin:@slprdb5052-scan.lifetouch.net:2001/lps_prod_plps.oracle.lifetouch.net" "-USER=lps" "-PASS=<@=snpRef.getInfo("SRC_ENCODED_PASS") @>" "-FILE_FORMAT=VARIABLE" "-FIELD_SEP=," "-ROW_SEP=\r\n" "-DATE_FORMAT=yyyy/MM/dd HH:mm:ss" "-CHARSET_ENCODING=ISO8859_1" "-XML_CHARSET_ENCODING=ISO-8859-1" "-FETCH_SIZE=5000"


-- select
-- 'ORDER_GUID'
-- ,'SEQ_NO'
-- ,'ORDERABLE_UNIT'
-- ,'ORDERED_FRAME'
-- ,'TEMPLATE_RULE' 
-- ,'QUANTITY'
-- ,'SHEET_COUNT'   
-- ,'LIST_PRICE'
-- ,'SALE_PRICE' 
-- ,'LINE_ITEM_PRICE_TYPE'
-- ,'LINEITEM_DESC'  
-- ,'PRODUCT_GUID' 
-- ,'ITEM_GUID'
-- ,'DISC_FLAG'
-- ,'DISC_DESC'
-- ,'DISC_PROMOCODE'  
-- ,'DISC_IS_SUPP'  
-- ,'DISC_TYPE'
-- ,'ORDER_CODE'   
-- ,'SBASE_CODE'  
-- ,'PRICE_GROUP_UUID'   
-- ,'ORDER_BUNDLE_UUID'  
-- ,'ORDERED_FRAME_SKU' 
-- ,'PRICE_GROUP_PARENT_UUID'
-- ,'PRIMARY_SKU'
-- ,'SECONDARY_SKU'
-- from dual
-- UNION
-- SELECT
-- ORDER_GUID
-- ,to_char(SEQ_NO)
-- ,ORDERABLE_UNIT
-- ,ORDERED_FRAME
-- ,TEMPLATE_RULE
-- ,to_char(QUANTITY)
-- ,to_char(SHEET_COUNT)   
-- ,to_char(LIST_PRICE)
-- ,to_char(SALE_PRICE)  
-- ,LINE_ITEM_PRICE_TYPE
-- ,LINEITEM_DESC  
-- ,PRODUCT_GUID 
-- ,ITEM_GUID
-- ,DISC_FLAG
-- ,DISC_DESC
-- ,DISC_PROMOCODE   
-- ,to_char(DISC_IS_SUPP)   
-- ,DISC_TYPE
-- ,to_char(ORDER_CODE) 
-- ,to_char(SBASE_CODE)
-- ,PRICE_GROUP_UUID   
-- ,ORDER_BUNDLE_UUID  
-- ,ORDERED_FRAME_SKU
-- ,PRICE_GROUP_PARENT_UUID
-- ,PRIMARY_SKU
-- ,SECONDARY_SKU
-- FROM CCPricingLineItem_is_nul order by 1 desc


-- &


/*-----------------------------------------------*/
/* TASK No. 110 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 110 */




/*-----------------------------------------------*/
/* TASK No. 111 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 111 */




/*-----------------------------------------------*/
