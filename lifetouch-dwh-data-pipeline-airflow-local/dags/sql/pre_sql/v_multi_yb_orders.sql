SELECT LISTAGG (
             RPAD( event_ref_id,17)
           || CHR (9)
           || TO_CHAR (ship_date, 'mm/dd/yyyy')
           || CHR (10))
           AS one_line
  FROM ods_app_user.multi_yb_orders