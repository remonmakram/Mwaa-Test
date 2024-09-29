SELECT count(*)
from	RAX_APP_USER.YEARBOOK_SALES

--COUNT(*)|
----------+
--    8948|


select count(*) from ods_app_user.multi_yb_orders
--COUNT(*)|
----------+
--       2|

select listagg(email_address, ',') within group (order by email_address) AS email_col
 from ODS_APP_USER.odi_email_to
WHERE package_name = '99_MULTI_MAIN_YB_ORDERS_PKG'  AND status = 'A'

--EMAIL_COL              |
-------------------------+
--ken.dady@shutterfly.com|


SELECT LISTAGG (
             RPAD( event_ref_id,17)
           || CHR (9)
           || TO_CHAR (ship_date, 'mm/dd/yyyy')
           || CHR (10))
           AS one_line
  FROM ods_app_user.multi_yb_orders
--  ONE_LINE                              |
----------------------------------------+
--EVT6DG74Z         ¶EVTB69Q9R         ¶|