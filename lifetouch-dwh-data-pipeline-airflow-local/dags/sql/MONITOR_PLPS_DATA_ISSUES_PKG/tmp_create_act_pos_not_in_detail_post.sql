
 BEGIN
   EXECUTE IMMEDIATE 'drop table act_pos_not_in_detail_post';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
      
&      

CREATE TABLE act_pos_not_in_detail_post AS
SELECT act_pos.pos_id, 'act_pos_post diff' AS issue_with
  FROM  (SELECT DISTINCT pos_id
           FROM act_pos_post) ACT_POS LEFT OUTER JOIN detail_post d ON d.pos_id = act_pos.pos_id
 WHERE 
 d.pos_id IS  NULL 
--d.pos_id='P0003010120095600'
 AND act_pos.pos_id LIKE 'P%'