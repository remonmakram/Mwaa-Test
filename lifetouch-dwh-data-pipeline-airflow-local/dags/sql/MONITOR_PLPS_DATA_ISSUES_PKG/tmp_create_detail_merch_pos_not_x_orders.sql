BEGIN
   EXECUTE IMMEDIATE 'drop table detail_merch_pos_not_x_orders';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;  

&

CREATE TABLE detail_merch_pos_not_x_orders AS
 SELECT not_posted.std_id,
         not_posted.tran_date,
         not_posted.tran_no,
         not_posted.pos_id,
         not_posted.order_type,
         'merch_post diff'     AS issue_with
    FROM (SELECT pos_id,
                std_id,
                tran_date,
                tran_no,
                order_type
           FROM detail_post d
          WHERE post_date IS NULL AND merch_sales <> 0 AND order_type <> 'x') not_posted
         LEFT OUTER JOIN merch_post a ON a.pos_id = not_posted.pos_id
   WHERE 
   a.pos_id IS NULL
  -- not_posted.tran_no='44wgvni4'
ORDER BY not_posted.tran_date, not_posted.std_id, not_posted.tran_no
