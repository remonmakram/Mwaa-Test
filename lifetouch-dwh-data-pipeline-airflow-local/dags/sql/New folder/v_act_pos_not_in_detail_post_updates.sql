SELECT LISTAGG (
             RPAD(POS_ID,30)
           || CHR (9)
            || RPAD( ISSUE_WITH,20)
          || CHR (10))
           AS one_line
 FROM  act_pos_not_in_detail_post