BEGIN
   EXECUTE IMMEDIATE 'drop table detail_post_header_child_diff';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&

CREATE TABLE detail_post_header_child_diff AS
SELECT dtl.std_id,
         main.host_no,
         main.std_status,
         dtl.tran_no,
         dtl.pos_id,
         dtl.pos_sit_no,
         dtl.tran_date,
         dtl.ORDER_TYPE,
         dtl.sit_cnt,
         dtl.tot_sales,
         merch.merch_pos_code_amt_sum,
         act1.act_pos_code_amt_sum,
         (  tot_sales
          - NVL (merch.merch_pos_code_amt_sum, 0)
          - NVL (act1.act_pos_code_amt_sum, 0))
             sales_diff,
         COUNT (*)
             nbr_rcds,
         dtl.port_sales,
         dtl.PC_SALES,
         dtl.disc,
         dtl.ship_sales
    FROM detail_post dtl
         JOIN std_main main ON dtl.std_id = main.std_id
         LEFT JOIN (SELECT act.pos_id, SUM (act.pos_code_amt) act_pos_code_amt_sum
             FROM act_pos_post act
                  JOIN (SELECT pos_id
           FROM detail_post
          WHERE post_date IS NULL)not_posted ON act.pos_id = not_posted.pos_id
         GROUP BY act.pos_id) act1 ON dtl.pos_id = act1.pos_id
         LEFT JOIN (SELECT merch.pos_id,
                  SUM (merch.pos_code_amt * merch.pos_code_qty)
                      merch_pos_code_amt_sum
             FROM merch_post merch
                  JOIN (SELECT pos_id
           FROM detail_post
          WHERE post_date IS NULL) not_posted ON merch.pos_id = not_posted.pos_id
         GROUP BY merch.pos_id)merch ON dtl.pos_id = merch.pos_id
   WHERE 
   dtl.post_date IS NULL
  -- dtl.pos_id='B46620112201323841420'
--where   post_date = '7-jun-2021'
GROUP BY dtl.std_id,
         main.std_status,
         main.host_no,
         dtl.tran_no,
         dtl.pos_id,
         dtl.pos_sit_no,
         dtl.tran_date,
         dtl.ORDER_TYPE,
         dtl.sit_cnt,
         merch.merch_pos_code_amt_sum,
         dtl.tot_sales,
         act1.act_pos_code_amt_sum,
         dtl.port_sales,
         dtl.PC_SALES,
         dtl.disc,
         dtl.ship_sales
  HAVING (  tot_sales
          - NVL (merch.merch_pos_code_amt_sum, 0)
          - NVL (act1.act_pos_code_amt_sum, 0)) <> 0
ORDER BY dtl.std_id, dtl.pos_id  
