 BEGIN
   EXECUTE IMMEDIATE 'drop table all_mer_child_rec_idf_pos_ids';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&

CREATE TABLE  all_mer_child_rec_idf_pos_ids AS
SELECT merch.*
  FROM merch_post merch JOIN (  SELECT dtl.std_id,
                  dtl.pos_id,
                  dtl.pos_sit_no,
                  dtl.tran_date,
                  dtl.sit_cnt,
                  dtl.tot_sales,
                  dtl.MERCH_SALES,
                  merch.merch_pos_code_amt_sum,
                  act1.act_pos_code_amt_sum,
                  inact_pos_code_amt_sum,
                  (  tot_sales
                   - NVL (merch.merch_pos_code_amt_sum, 0)
                   - NVL (act1.act_pos_code_amt_sum, 0)
                   - NVL (inact_pos_code_amt_sum, 0))
                      sales_diff,
                  COUNT (*)
                      nbr_rcds,
                  dtl.port_sales
             FROM detail_post dtl
                  LEFT JOIN (  SELECT act.pos_id, SUM (act.pos_code_amt) act_pos_code_amt_sum
             FROM act_pos_post act
                  JOIN   (SELECT pos_id
           FROM detail_post
          WHERE post_date IS NULL) not_posted ON act.pos_id = not_posted.pos_id
         GROUP BY act.pos_id) act1 ON dtl.pos_id = act1.pos_id
                  LEFT JOIN  (  SELECT inact.pos_id, SUM (inact.pos_code_amt) inact_pos_code_amt_sum
             FROM inact_pos_post inact
                  JOIN   (SELECT pos_id
           FROM detail_post
          WHERE post_date IS NULL) not_posted ON inact.pos_id = not_posted.pos_id
         GROUP BY inact.pos_id) inact1 ON dtl.pos_id = inact1.pos_id
                  LEFT JOIN (  SELECT merch.pos_id,
                  SUM (merch.pos_code_amt * merch.pos_code_qty)
                      merch_pos_code_amt_sum
             FROM merch_post merch
                  JOIN   (SELECT pos_id
           FROM detail_post
          WHERE post_date IS NULL) not_posted ON merch.pos_id = not_posted.pos_id
         GROUP BY merch.pos_id) merch ON dtl.pos_id = merch.pos_id
            WHERE dtl.post_date IS NULL
         GROUP BY dtl.std_id,
                  dtl.pos_id,
                  dtl.pos_sit_no,
                  dtl.tran_date,
                  dtl.sit_cnt,
                  merch.merch_pos_code_amt_sum,
                  dtl.tot_sales,
                  dtl.merch_sales,
                  act1.act_pos_code_amt_sum,
                  inact_pos_code_amt_sum,
                  dtl.port_sales
           HAVING (  tot_sales
                   - NVL (merch.merch_pos_code_amt_sum, 0)
                   - NVL (act1.act_pos_code_amt_sum, 0)
                   - NVL (inact_pos_code_amt_sum, 0))  <> 0
         ORDER BY dtl.std_id, dtl.pos_id) diffs1 ON merch.pos_id = diffs1.pos_id
        -- where diffs1.pos_id ='P00932023091844xlgd4i' --';  