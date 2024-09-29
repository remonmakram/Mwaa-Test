BEGIN
   EXECUTE IMMEDIATE 'drop table diff_in_ccp_nd_dP_not_in_CCP';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&

CREATE TABLE  diff_in_ccp_nd_dP_not_in_CCP  AS
SELECT not_posted.*,  'not in ccpricing' AS query_source
  FROM  (SELECT std_id,
                tran_no,
                tran_date,
                tot_sales
           FROM detail_post
          WHERE tran_date > '1-Nov-2021' AND post_date IS NULL) not_posted 
		  LEFT JOIN  (SELECT o.std_id,
                o.order_id,
                o.order_date,
                o.order_type,
                o.order_guid ,
                o.TOT_ORDER_SALE_PRICE,
                o.TOT_ORDER_SHIP_PRICE,
                NVL (o.ORDER_ADJUSTMENT_AMOUNT, 0)
                    AS ORDER_ADJUSTMENT_AMOUNT
           FROM CCPRICINGORDERHEADER o
          WHERE     o.order_date > '1-Nov-2021'
               -- AND o.order_type <> 'm'
                AND post_date IS NULL) ccpricing 
ON ccpricing.order_id = not_posted.tran_no
 WHERE 
ccpricing.order_id IS NULL
--not_posted.TRAN_NO ='440khopb'';  