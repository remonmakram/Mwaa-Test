
-- drop table dump_monthly_freight_analysis
BEGIN
    EXECUTE IMMEDIATE 'drop table dump_monthly_freight_analysis';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;

&

CREATE TABLE dump_monthly_freight_analysis AS
SELECT
      ODS_APP_USER.FREIGHT_DUMP_PKG_SEQ.nextval as oid,
       s.SCHOOL_YEAR,
       s.SUB_PROGRAM_NAME,
       s.ACCOUNT_NAME,
       s.APO_ID,
       s.EVENT_REF_ID,
       s.SHIP_DATE,
       s.SHIP_NODE,
       s.SHIP_VIA,
       s.CARRIER_SERVICE_CODE,
       s.NUMBER_OF_CONTAINERS,
       s.ACTUAL_FREIGHT_CHARGE,
       s.carrier,
       o.ORDER_BUCKET,
       o.SHIP_ORDERS_TO,
       o.ORDERED_QUANTITY,
       o.SHIPPED_QUANTITY,
       o.ITEM_DESCRIPTION
  FROM freight_shipment_detail s, freight_order_detail o
 WHERE     1 = 1
       AND s.SHIPMENT_OID = o.SHIPMENT_OID
       AND s.SHIP_DATE  BETWEEN TRUNC (TRUNC (SYSDATE, 'MM') - 1, 'MM')
                                 AND TRUNC (SYSDATE, 'MM') - 1


