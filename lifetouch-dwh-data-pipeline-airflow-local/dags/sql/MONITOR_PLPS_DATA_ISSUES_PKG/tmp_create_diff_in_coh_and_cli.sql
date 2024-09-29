BEGIN
   EXECUTE IMMEDIATE 'drop table diff_in_coh_and_cli';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&

CREATE TABLE diff_in_coh_and_cli AS
  SELECT ccheader.order_guid,
         ccheader.std_id,
         ccheader.order_date,
         ccheader.order_type,
         ccheader.order_id,
         SUM (ccheader.tot_sales - ccdetail.sales_price)
             AS sales_diff,
         'CCpricingorderheader total not equal ccpricinglineitem'
             AS query_source
    FROM (  
           SELECT o.order_guid,
                  o.std_id,
                 o.order_date,
                 o.order_type,
                 o.order_id,
            SUM (o.tot_order_sale_price + o.tot_order_ship_price) as tot_sales
            FROM ccpricingorderheader o
           WHERE o.order_date > '1-oct-2020' AND o.post_date IS NULL
           GROUP BY o.order_guid,
                  o.std_id,
                 o.order_date,
                 o.order_type,
                 o.order_id
        ) ccheader JOIN 
        (  SELECT l.order_guid, SUM (l.sale_price * l.quantity) sales_price
             --  select *
            from CCPRICINGLINEITEM l            
            left join ccpricingorderheader o ON l.order_guid = o.order_guid
            WHERE o.order_date > '1-oct-2020'
              AND o.post_date IS NULL
              AND l.line_item_price_type NOT IN ('TAX', 'TAX_ADJUSTMENT','DELIVERY_FEE')
         GROUP BY l.order_guid, order_id) ccdetail ON ccdetail.order_guid = ccheader.order_guid
GROUP BY ccheader.order_guid,
         ccheader.std_id,
         ccheader.order_date,
         ccheader.order_type,
         ccheader.order_id
  HAVING SUM (ccheader.tot_sales - ccdetail.sales_price) <> 0