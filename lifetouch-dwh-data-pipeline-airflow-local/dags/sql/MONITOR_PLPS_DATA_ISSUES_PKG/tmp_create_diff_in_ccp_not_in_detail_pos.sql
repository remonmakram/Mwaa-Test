BEGIN
   EXECUTE IMMEDIATE 'drop table diff_in_ccp_not_in_detail_pos';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&     

CREATE TABLE diff_in_ccp_not_in_detail_pos AS
SELECT ccpricing.*, 'In CCpricing but not in detail_post' AS query_source
  FROM  (SELECT o.std_id,
                o.order_id,
                o.order_date,
                o.order_type,
                o.TOT_ORDER_SALE_PRICE,
                o.TOT_ORDER_SHIP_PRICE,
                NVL (o.ORDER_ADJUSTMENT_AMOUNT, 0)
                    AS ORDER_ADJUSTMENT_AMOUNT
           FROM CCPRICINGORDERHEADER o
          WHERE     o.order_date > '1-Nov-2021'
                AND o.order_type <> 'm'
                AND post_date IS NULL--  and o.std_id = 'P0411'
                                     ) ccpricing  
  LEFT JOIN  (SELECT std_id,
                tran_no,
                tran_date,
                tot_sales
           FROM detail_post
          WHERE tran_date > '1-Nov-2021' AND post_date IS NULL-- and std_id = 'P0411'
                                                              )not_posted  ON not_posted.tran_no = ccpricing.order_id
 WHERE 
 not_posted.tran_no IS NULL
 --ccpricing.ORDER_ID='440khopb' 