BEGIN
   EXECUTE IMMEDIATE 'drop table detail_post_adds_up';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&

CREATE TABLE detail_post_adds_up AS
SELECT dtl.std_id,
         main.host_no,
         main.std_status,
         dtl.tran_no,
         dtl.pos_id,
         dtl.pos_sit_no,
         dtl.tran_date,
         dtl.order_type,
         dtl.sit_cnt,
         dtl.tot_sales,
         dtl.ASSOC_DISC,
         COUNT (*)
             nbr_rcds,
         dtl.merch_sales,
         dtl.pc_sales,
         dtl.port_sales,
         dtl.disc,
         dtl.ship_sales,
         dtl.spec_sales,
         CASE
             WHEN dtl.order_type = 'x'
             THEN
                 (  tot_sales
                  - NVL (dtl.merch_sales, 0)
                  - NVL (dtl.PC_sales, 0)
                  - NVL (dtl.port_sales, 0)
                  - NVL (dtl.ship_sales, 0)
                  - NVL (dtl.spec_sales, 0)
                  - NVL (dtl.ASSOC_DISC, 0))
             ELSE
                 (  tot_sales
                  - NVL (dtl.merch_sales, 0)
                  - NVL (dtl.PC_sales, 0)
                  - NVL (dtl.port_sales, 0)
                  - NVL (dtl.ship_sales, 0)
                  - NVL (dtl.spec_sales, 0))
         END
             sales_diff
    FROM LPS_FIN_OWN.detail_post dtl JOIN LPS.STD_MAIN main ON dtl.std_id = main.std_id
   WHERE 
 --dtl.pos_id = 'B46620101201323841385'
dtl.post_date IS NULL
GROUP BY dtl.std_id,
         main.std_status,
         main.host_no,
         dtl.tran_no,
         dtl.pos_id,
         dtl.pos_sit_no,
         dtl.tran_date,
         dtl.order_type,
         dtl.sit_cnt,
         dtl.tot_sales,
         dtl.ASSOC_DISC,
         dtl.merch_sales,
         dtl.pc_sales,
         dtl.port_sales,
         dtl.spec_sales,
         dtl.disc,
         dtl.ship_sales
  HAVING CASE
             WHEN dtl.order_type = 'x'
             THEN
                 (  tot_sales
                  - NVL (dtl.merch_sales, 0)
                  - NVL (dtl.PC_sales, 0)
                  - NVL (dtl.port_sales, 0)
                  - NVL (dtl.ship_sales, 0)
                  - NVL (dtl.spec_sales, 0)
                  - NVL (dtl.ASSOC_DISC, 0))
             ELSE
                 (  tot_sales
                  - NVL (dtl.merch_sales, 0)
                  - NVL (dtl.PC_sales, 0)
                  - NVL (dtl.port_sales, 0)
                  - NVL (dtl.ship_sales, 0)
                  - NVL (dtl.spec_sales, 0))
         END <>
         0
ORDER BY dtl.std_id, dtl.pos_id