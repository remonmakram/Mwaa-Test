BEGIN
  EXECUTE IMMEDIATE 'drop table rax_app_user.multi_yb_orders';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;


&



CREATE TABLE rax_app_user.multi_yb_orders AS
SELECT dr.event_ref_id, e.ship_date
  FROM (  SELECT event_ref_id, COUNT (*)
            FROM (SELECT DISTINCT e.EVENT_REF_ID,
                                  oh.ORDER_TYPE,
                                  oh.ORDER_BUCKET,
                                  oh.ORDER_NO
                    FROM ODS_OWN.SUB_PROGRAM    sp,
                         ODS_OWN.ACCOUNT        acct,
                         ODS_OWN.ORGANIZATION_VW org,
                         ods_own.apo            a,
                         ods_own.event          e,
                         ODS_OWN.ORDER_HEADER   oh,
                         ods_own.order_line     ol,
                         ods_own.item           i
                   WHERE     sp.SUB_PROGRAM_OID = a.SUB_PROGRAM_OID
                         AND a.ACCOUNT_OID = acct.ACCOUNT_OID
                         AND a.TERRITORY_CODE = org.TERRITORY_CODE
                         AND a.APO_OID = e.APO_OID
                         AND e.EVENT_REF_ID = oh.EVENT_REF_ID
                         AND oh.ORDER_HEADER_OID = ol.ORDER_HEADER_OID
                         AND ol.ITEM_OID = i.ITEM_OID
                         AND sp.SUB_PROGRAM_NAME = 'Yearbook'
                         AND i.DESCRIPTION = 'Yearbook'
                         AND a.SCHOOL_YEAR >= 2021
                         AND acct.CATEGORY_NAME NOT IN ('House', 'Test')
                         AND org.BUSINESS_UNIT_NAME != ('Test Organization')
                         AND oh.ORDER_TYPE = 'YBYearbook_Order'
                         AND   (CASE
                                    WHEN oh.ORDER_BUCKET = 'CANCELLED' THEN 1
                                    ELSE 0
                                END)
                             + (CASE
                                    WHEN oh.ORDER_STATUS = 'Cancelled' THEN 1
                                    ELSE 0
                                END) =
                             0)
        GROUP BY event_ref_id
          HAVING COUNT (*) > 1) dr,
       ods_own.event  e
 WHERE dr.EVENT_REF_ID = e.EVENT_REF_ID AND e.status = '1'

