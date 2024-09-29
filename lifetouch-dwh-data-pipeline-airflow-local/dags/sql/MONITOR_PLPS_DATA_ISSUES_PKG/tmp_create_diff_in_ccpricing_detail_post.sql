BEGIN
   EXECUTE IMMEDIATE 'drop table diff_in_ccpricing_detail_post';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;      

&

CREATE TABLE diff_in_ccpricing_detail_post AS
 SELECT *
    FROM (  SELECT ccpricing.std_id,
                   ccpricing.order_date,
                   ccpricing.order_id,
                   ccpricing.order_type,
                   ccpricing.STUDIO_SOFTWARE_VERSION,
                   CASE
                       WHEN ccpricing.STUDIO_SOFTWARE_VERSION >= '5.3.7-RC37'
                       THEN
                           SUM (
                                 ccpricing.TOT_ORDER_SALE_PRICE
                               + ccpricing.TOT_ORDER_SHIP_PRICE)
                       ELSE
                           SUM (
                                 ccpricing.TOT_ORDER_SALE_PRICE
                               + ccpricing.TOT_ORDER_SHIP_PRICE
                               + ccpricing.ORDER_ADJUSTMENT_AMOUNT)
                   END
                       ccpricing_tot_537--, sum(ccpricing.TOT_ORDER_SALE_PRICE + ccpricing.TOT_ORDER_SHIP_PRICE + ccpricing.ORDER_ADJUSTMENT_AMOUNT) as ccpricing_tot
                                        ,
                   SUM (not_posted.tot_sales)
                       AS detail_tot,
                   CASE
                       WHEN ccpricing.STUDIO_SOFTWARE_VERSION >= '5.3.7-RC37'
                       THEN
                           SUM (
                                 (  ccpricing.TOT_ORDER_SALE_PRICE
                                  + ccpricing.TOT_ORDER_SHIP_PRICE)
                               - not_posted.tot_sales)
                       ELSE
                           SUM (
                                 (  ccpricing.TOT_ORDER_SALE_PRICE
                                  + ccpricing.TOT_ORDER_SHIP_PRICE
                                  + ccpricing.ORDER_ADJUSTMENT_AMOUNT)
                               - not_posted.tot_sales)
                   END
                       sale_diff--, sum((ccpricing.TOT_ORDER_SALE_PRICE + ccpricing.TOT_ORDER_SHIP_PRICE + ccpricing.ORDER_ADJUSTMENT_AMOUNT) -  not_posted.tot_sales) as sale_diff
                                ,
                   'ccpricing diff'
                       AS issue_with
              FROM (SELECT o.std_id,
                o.order_id,
                o.order_date,
                o.order_type,
                o.TOT_ORDER_SALE_PRICE,
                o.TOT_ORDER_SHIP_PRICE,
                NVL (o.ORDER_ADJUSTMENT_AMOUNT, 0)
                    AS ORDER_ADJUSTMENT_AMOUNT,
                o.STUDIO_SOFTWARE_VERSION
           FROM CCPRICINGORDERHEADER o
          WHERE     (o.post_date IS NULL OR o.post_date <> '')
                AND o.order_type <> 'm'
                AND o.order_date > TRUNC (SYSDATE) - 30) ccpricing
                   JOIN 
        (SELECT std_id,
                tran_no,
                tran_date,
                tot_sales
           FROM detail_post
          --  where   post_date is null
          WHERE post_date IS NULL) not_posted
                       ON (    not_posted.std_id = ccpricing.std_id
                           AND not_posted.tran_no = ccpricing.order_id)
          GROUP BY ccpricing.std_id,
                   ccpricing.order_date,
                   ccpricing.order_id,
                   ccpricing.order_type,
                   ccpricing.STUDIO_SOFTWARE_VERSION) a
   WHERE 
   sale_diff <> 0
   --a.ORDER_ID='456kb2sc'
ORDER BY order_date