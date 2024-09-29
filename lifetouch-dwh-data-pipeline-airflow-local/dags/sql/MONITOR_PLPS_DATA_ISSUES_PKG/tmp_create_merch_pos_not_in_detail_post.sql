BEGIN
   EXECUTE IMMEDIATE 'drop table merch_pos_not_in_detail_post';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;  

&

CREATE TABLE merch_pos_not_in_detail_post AS
SELECT merch_pos.pos_id, 'merch_post diff' AS issue_with
  FROM  (SELECT DISTINCT pos_id
           FROM merch_post) merch_pos LEFT OUTER JOIN detail_post d ON d.pos_id = merch_pos.pos_id
 WHERE d.pos_id IS NULL AND merch_pos.pos_id LIKE 'P%' 