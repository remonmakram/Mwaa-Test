&

-- drop table  monthly_freight_analysis_num

BEGIN
    EXECUTE IMMEDIATE 'drop table monthly_freight_analysis_num';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;

&

create table  monthly_freight_analysis_num
as
   SELECT oid,
       SCHOOL_YEAR,
       SUB_PROGRAM_NAME,
       ACCOUNT_NAME,
       APO_ID,
       EVENT_REF_ID,
       SHIP_DATE,
       SHIP_NODE,
       SHIP_VIA,
       CARRIER_SERVICE_CODE,
       NUMBER_OF_CONTAINERS,
       ACTUAL_FREIGHT_CHARGE,
       carrier,
       ORDER_BUCKET,
       SHIP_ORDERS_TO,
       ORDERED_QUANTITY,
       SHIPPED_QUANTITY,
       ITEM_DESCRIPTION
     FROM (SELECT
                  oid,
       SCHOOL_YEAR,
       SUB_PROGRAM_NAME,
       ACCOUNT_NAME,
       APO_ID,
       EVENT_REF_ID,
       SHIP_DATE,
       SHIP_NODE,
       SHIP_VIA,
       CARRIER_SERVICE_CODE,
       NUMBER_OF_CONTAINERS,
       ACTUAL_FREIGHT_CHARGE,
       carrier,
       ORDER_BUCKET,
       SHIP_ORDERS_TO,
       ORDERED_QUANTITY,
       SHIPPED_QUANTITY,
       ITEM_DESCRIPTION,
                  ROW_NUMBER () OVER (ORDER BY oid) r
             FROM  dump_monthly_freight_analysis)
 WHERE r BETWEEN :v_freight_dump_ctr AND :v_freight_dump_ctr + :v_ep_dump_file_max - 1
