SELECT * FROM RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
WHERE SESS_NAME IN ('99_FREIGHT_UC_ANALYSIS_PKG','99_FREIGHT_YB_ANALYSIS_PKG','99_FREIGHT_SR_ANALYSIS_PKG') AND  CREATE_DATE > SYSDATE - INTERVAL '120' MINUTE


SELECT   (O_CDC.LAST_CDC_COMPLETION_DATE-R_CDC.ORIG_LAST_CDC_COMPLETION_DATE ) * 1440 AS minutes_difference ,R_CDC.*, O_CDC.LAST_CDC_COMPLETION_DATE
 FROM RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT R_CDC
 LEFT JOIN ods_own.ods_cdc_load_status O_CDC
 ON R_CDC.TABLE_NAME  = O_CDC.ODS_TABLE_NAME
 WHERE SESS_NAME IN ('99_FREIGHT_UC_ANALYSIS_PKG','99_FREIGHT_YB_ANALYSIS_PKG','99_FREIGHT_SR_ANALYSIS_PKG')
  AND CREATE_DATE > SYSDATE - INTERVAL '70' MINUTE

------------------------------------------------------------- US Sub package ---------------------------------------------------------------------------------------

------------------------------------------------------------- SR Sub package ---------------------------------------------------------------------------------------
SELECT * FROM RAX_APP_USER.freight_order_detail ORDER BY ods_modify_date DESC FETCH FIRST 5 ROWS ONLY;

--SHIPMENT_OID|ORDER_BUCKET|SHIP_ORDERS_TO|ITEM_DESCRIPTION|ORDERED_QUANTITY|SHIPPED_QUANTITY|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
--------------+------------+--------------+----------------+----------------+----------------+-------------------+-------------------+
--    72764852|PAID        |Account       |Zoom            |               2|               2|2024-08-07 09:53:14|2024-08-07 09:53:14|
--    72764852|PAID        |Account       |Smythe Sewing   |               2|               2|2024-08-07 09:53:14|2024-08-07 09:53:14|
--    72764852|PAID        |Account       |Hard Cover      |               2|               2|2024-08-07 09:53:14|2024-08-07 09:53:14|
--    72764852|PAID        |Account       |Yearbook        |               2|               2|2024-08-07 09:53:14|2024-08-07 09:53:14|
--    72764852|PAID        |Account       |Stickys         |               2|               2|2024-08-07 09:53:14|2024-08-07 09:53:14|

SELECT count(*) FROM RAX_APP_USER.freight_order_detail
--COUNT(*)|
----------+
--  173875|

SELECT * FROM RAX_APP_USER.freight_order_detail WHERE SHIPMENT_OID ='72751104'
--SHIPMENT_OID|ORDER_BUCKET|SHIP_ORDERS_TO|ITEM_DESCRIPTION           |ORDERED_QUANTITY|SHIPPED_QUANTITY|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
------------+------------+--------------+---------------------------+----------------+----------------+-------------------+-------------------+
--    72751104|UNPAID      |Subject       |Platinum $20.11 Sit Session|               1|               1|2024-08-07 12:00:27|2024-08-07 12:00:27|


DELETE FROM RAX_APP_USER.freight_order_detail WHERE SHIPMENT_OID ='72751104'

SELECT count(*) FROM RAX_APP_USER.freight_order_detail

--COUNT(*)|
----------+
--  173874|

UPDATE ods_own.ods_cdc_load_status
SET last_cdc_completion_date = TO_DATE(SUBSTR('2020-08-07 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
WHERE ods_table_name= 'FREIGHT_ANALYSIS_SR'



-- Run Dag

SELECT count(*) FROM RAX_APP_USER.freight_order_detail
--COUNT(*)|
----------+
--  173875|

SELECT * FROM RAX_APP_USER.freight_order_detail WHERE SHIPMENT_OID ='72751104'

--SHIPMENT_OID|ORDER_BUCKET|SHIP_ORDERS_TO|ITEM_DESCRIPTION           |ORDERED_QUANTITY|SHIPPED_QUANTITY|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
--------------+------------+--------------+---------------------------+----------------+----------------+-------------------+-------------------+
--    72751104|UNPAID      |Subject       |Platinum $20.11 Sit Session|               1|               1|2024-08-07 12:19:03|2024-08-07 12:19:03|
---------------------------------------------------------------------

SELECT s.SHIPMENT_OID,
                     s.SHIPMENT_NO,
                     s.SHIP_DATE,
                     s.SHIP_NODE,
                     s.SHIP_VIA,
                     s.CARRIER_SERVICE_CODE,
                     TRIM(s.scac) as carrier,
                     SUM (DISTINCT s.ACTUAL_FREIGHT_CHARGE)
                         AS actual_freight_charge,
                     CASE WHEN TRIM (s.status) = '9000' THEN 'Y' ELSE NULL END
                         AS cancelled
                FROM ods_own.apo          a,
                     ODS_OWN.ORDER_HEADER oh,
                     ODS_OWN.ORDER_LINE   ol,
                     ODS_OWN.SHIPMENT_LINE sl,
                     ODS_OWN.SHIPMENT     s,
                     freight_driver_sr       dr
               WHERE     1 = 1
                     AND a.APO_OID = oh.APO_OID
                     AND oh.ORDER_HEADER_OID = ol.ORDER_HEADER_OID
                     AND ol.ORDER_LINE_OID = sl.ORDER_LINE_OID
                     AND sl.SHIPMENT_OID = s.SHIPMENT_OID
                     AND s.SHIPMENT_OID = dr.SHIPMENT_OID
            GROUP BY s.SHIPMENT_OID,
                     s.SHIPMENT_NO,
                     s.SHIP_DATE,
                     s.SHIP_NODE,
                     s.SHIP_VIA,
                     s.CARRIER_SERVICE_CODE,
                     trim(s.scac),
                     trim(s.status)

SELECT s.SHIPMENT_OID,
                     SUM (
                         CASE
                             WHEN i.fulfillment_type = 'Digital' or i.PRODUCT_LINE = 'Sit' THEN 1
                             ELSE 0
                         END)
                         AS digital,
                     SUM (
                         CASE
                             WHEN i.fulfillment_type = 'Physical' THEN 1
                             ELSE 0
                         END)
                         AS physical
                FROM
                     ods_own.order_line                  ol,
                     ods_own.item                        i,
                     ODS_OWN.SHIPMENT_LINE               sl,
                     ods_own.shipment                    s,
                     freight_driver_sr                   dr
               WHERE    1=1
                     AND ol.ITEM_OID = i.ITEM_OID
                     AND ol.ORDER_LINE_OID = sl.ORDER_LINE_OID
                     AND sl.SHIPMENT_OID = s.SHIPMENT_OID
                     AND s.SHIPMENT_OID = dr.SHIPMENT_OID
--and s.SHIPMENT_NO = '72764852'
            GROUP BY s.SHIPMENT_OID
              HAVING     SUM (
                             CASE
                                 WHEN i.fulfillment_type = 'Physical'  THEN 1
                                 ELSE 0
                             END) =
                         0
                     AND SUM (
                             CASE
                                 WHEN i.fulfillment_type = 'Digital' or i.PRODUCT_LINE = 'Sit' THEN 1
                                 ELSE 0
                             END) >
                         0

SELECT * FROM
                  (
                    SELECT sl.SHIPMENT_OID,
                     oh.ORDER_BUCKET,
                     oh.SHIP_ORDERS_TO,
                     i.DESCRIPTION                 AS item_description,
                     SUM (ol.ORDERED_QUANTITY)     AS ordered_quantity,
                     SUM (sl.SHIPPED_QUANTITY)     AS shipped_quantity
                FROM ODS_OWN.SHIPMENT_LINE sl,
                     ODS_OWN.ORDER_LINE   ol,
                     ODS_OWN.ORDER_HEADER oh,
                     ODS_OWN.ITEM         i,
                     freight_driver_sr       dr
               WHERE     sl.SHIPMENT_OID = dr.SHIPMENT_OID
                     AND sl.ORDER_LINE_OID = ol.ORDER_LINE_OID
                     AND ol.ORDER_HEADER_OID = oh.ORDER_HEADER_OID
                     AND ol.ITEM_OID = i.ITEM_OID
            GROUP BY sl.SHIPMENT_OID,
                     oh.ORDER_BUCKET,
                     oh.SHIP_ORDERS_TO,
                     i.DESCRIPTION)


 SELECT DISTINCT sl.shipment_oid
      FROM ods_own.shipment_line  sl,
           ODS_OWN.SHIPMENT       s,
           ods_own.source_system  ss
     WHERE     sl.SOURCE_SYSTEM_OID = ss.SOURCE_SYSTEM_OID
           AND sl.SHIPMENT_OID = s.SHIPMENT_OID
           AND ss.SOURCE_SYSTEM_SHORT_NAME = 'OMS2'
           AND sl.ods_modify_date > TO_DATE(SUBSTR('2024-08-06 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
           AND sl.SHIPMENT_OID = '72751104'
           AND NOT EXISTS
                   (SELECT 1
                      FROM rax_app_user.freight_driver_sr t
                     WHERE t.shipment_oid = sl.shipment_oid)



------------------------------------------------------------- US Sub package ---------------------------------------------------------------------------------------

--SCHOOL_YEAR|SUB_PROGRAM_NAME         |ACCOUNT_NAME                |APO_ID|EVENT_REF_ID|PHOTOGRAPHY_DATE|SHIPMENT_OID|SHIPMENT_NO|SHIP_DATE          |SHIP_NODE  |SHIP_VIA|CARRIER_SERVICE_CODE|NUMBER_OF_CONTAINERS|ACTUAL_FREIGHT_CHARGE|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |CARRIER|CANCELLED|TRACK_EXISTS|SHIP_TO_ZIP|
-------------+-------------------------+----------------------------+------+------------+----------------+------------+-----------+-------------------+-----------+--------+--------------------+--------------------+---------------------+-------------------+-------------------+-------+---------+------------+-----------+
--       2021|Prestige Senior Portraits|Secondary Test Jobs -13thMay|7K73  |            |                |    72750278|5319424    |2022-01-10 09:03:33|VirtualNode|        |Ground              |                    |                    0|2024-08-07 12:00:25|2024-08-07 12:19:02|FEDX   |D        |           0|           |
--       2023|Prestige Senior Portraits|Secondary Test Jobs -13thMay|7K32  |            |                |    72750321|5324615    |2022-01-13 09:13:23|Muncie     |        |Ground              |                    |                    0|2024-08-07 12:00:25|2024-08-07 12:19:02|MI     |         |           0|           |
--       2023|Prestige Senior Portraits|Secondary Test Jobs -13thMay|7WCZ  |            |                |    72750319|5322574    |2022-01-12 04:48:55|Muncie     |        |Ground              |                    |                    0|2024-08-07 12:00:25|2024-08-07 12:19:02|MI     |         |           0|           |
--       2022|Prestige Senior Portraits|Secondary Test Jobs -13thMay|7WT7  |            |                |    72750316|5321104    |2022-01-11 08:23:33|VirtualNode|        |Ground              |                    |                    0|2024-08-07 12:00:25|2024-08-07 12:19:02|FEDX   |D        |           0|           |
--       2021|Prestige Senior Portraits|Secondary Test Jobs -13thMay|7K73  |            |                |    72750298|5319654    |2022-01-10 12:17:56|Muncie     |        |Ground              |                    |                    0|2024-08-07 12:00:25|2024-08-07 12:19:02|MI     |         |           0|           |

SELECT count(*) FROM RAX_APP_USER.FREIGHT_SHIPMENT_DETAIL

--COUNT(*)|
----------+
--   59824|

SELECT * FROM RAX_APP_USER.FREIGHT_SHIPMENT_DETAIL WHERE SHIPMENT_OID= '72820677'
--SCHOOL_YEAR|SUB_PROGRAM_NAME|ACCOUNT_NAME                                     |APO_ID  |EVENT_REF_ID|PHOTOGRAPHY_DATE   |SHIPMENT_OID|SHIPMENT_NO|SHIP_DATE          |SHIP_NODE |SHIP_VIA|CARRIER_SERVICE_CODE|NUMBER_OF_CONTAINERS|ACTUAL_FREIGHT_CHARGE|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |CARRIER|CANCELLED|TRACK_EXISTS|SHIP_TO_ZIP|
-------------+----------------+-------------------------------------------------+--------+------------+-------------------+------------+-----------+-------------------+----------+--------+--------------------+--------------------+---------------------+-------------------+-------------------+-------+---------+------------+-----------+
--       2024|Fall Individuals|Test Account 27 more Tests Fall Individuals 23-24|FOW8PCN7|EVTZ737CP   |2024-08-02 00:00:00|    72820677|69334326   |2024-08-07 05:19:29|Muncie Lab|SHIP    |Ground              |                   1|                 6.21|2024-08-07 09:51:52|2024-08-07 09:52:36|UPSN   |         |           1|           |

DELETE FROM RAX_APP_USER.FREIGHT_SHIPMENT_DETAIL WHERE SHIPMENT_OID= '72820677'

SELECT count(*) FROM RAX_APP_USER.FREIGHT_SHIPMENT_DETAIL

--COUNT(*)|
----------+
--   59823|

UPDATE ods_own.ods_cdc_load_status
SET last_cdc_completion_date = TO_DATE(SUBSTR('2020-08-06 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
WHERE ods_table_name= 'FREIGHT_ANALYSIS_UC'


---- Run the dag

SELECT count(*) FROM RAX_APP_USER.FREIGHT_SHIPMENT_DETAIL

--COUNT(*)|
----------+
--   96649|

SELECT * FROM RAX_APP_USER.FREIGHT_SHIPMENT_DETAIL WHERE SHIPMENT_OID= '72820677'
--SCHOOL_YEAR|SUB_PROGRAM_NAME|ACCOUNT_NAME                                     |APO_ID  |EVENT_REF_ID|PHOTOGRAPHY_DATE   |SHIPMENT_OID|SHIPMENT_NO|SHIP_DATE          |SHIP_NODE |SHIP_VIA|CARRIER_SERVICE_CODE|NUMBER_OF_CONTAINERS|ACTUAL_FREIGHT_CHARGE|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |CARRIER|CANCELLED|TRACK_EXISTS|SHIP_TO_ZIP|
-------------+----------------+-------------------------------------------------+--------+------------+-------------------+------------+-----------+-------------------+----------+--------+--------------------+--------------------+---------------------+-------------------+-------------------+-------+---------+------------+-----------+
--       2024|Fall Individuals|Test Account 27 more Tests Fall Individuals 23-24|FOW8PCN7|EVTZ737CP   |2024-08-02 00:00:00|    72820677|69334326   |2024-08-07 05:19:29|Muncie Lab|SHIP    |Ground              |                   1|                 6.21|2024-08-07 12:22:43|2024-08-07 12:23:12|UPSN   |         |           1|           |

---------------------------------------------------------------------------------------------------------

 SELECT DISTINCT sc.shipment_oid
      FROM ods_own.sub_program    sp,
           ods_own.apo            a,
           ods_own.event          e,
           ods_Own.order_header   oh,
           ods_own.order_line     ol,
           ods_own.shipment_line  sl,
           ods_own.shipment       s,
           ods_own.shipment_container sc,
           ods_own.source_system ss
     WHERE     a.SUB_PROGRAM_OID = sp.SUB_PROGRAM_OID
           AND a.APO_OID = e.APO_OID
           AND e.EVENT_OID = oh.EVENT_OID
           AND oh.ORDER_HEADER_OID = ol.ORDER_HEADER_OID
           AND ol.ORDER_LINE_OID = sl.ORDER_LINE_OID
           AND sl.SHIPMENT_OID = s.SHIPMENT_OID
           AND sc.source_system_oid = ss.source_system_oid
           AND ss.source_system_short_name IN ('OMS','ODS')
           AND s.shipment_oid = sc.shipment_oid
           AND sp.SUB_PROGRAM_NAME != 'Yearbook'
           AND sc.ods_modify_date > TO_DATE(SUBSTR('2024-08-07 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
and not exists (select 1 from rax_app_user.freight_driver_uc t where t.shipment_oid = sc.shipment_oid)

SELECT s.SHIPMENT_OID,
                     s.SHIPMENT_NO,
                     s.SHIP_DATE,
                     s.SHIP_NODE,
                     s.SHIP_VIA,
                     s.CARRIER_SERVICE_CODE,
                     TRIM (s.scac)
                         AS carrier,
                     SUM (DISTINCT s.ACTUAL_FREIGHT_CHARGE)
                         AS actual_freight_charge,
                     CASE WHEN TRIM (s.status) = '9000' THEN 'Y' ELSE NULL END
                         AS cancelled
                FROM ods_own.apo          a,
                     ODS_OWN.EVENT        e,
                     ODS_OWN.ORDER_HEADER oh,
                     ODS_OWN.ORDER_LINE   ol,
                     ODS_OWN.SHIPMENT_LINE sl,
                     ODS_OWN.SHIPMENT     s,
                     freight_driver_uc    dr
               WHERE     1 = 1
                     AND a.APO_OID = e.APO_OID
                     AND e.event_OID = oh.event_OID
                     AND oh.ORDER_HEADER_OID = ol.ORDER_HEADER_OID
                     AND ol.ORDER_LINE_OID = sl.ORDER_LINE_OID
                     AND sl.SHIPMENT_OID = s.SHIPMENT_OID
                     AND s.SHIPMENT_OID = dr.SHIPMENT_OID
            GROUP BY s.SHIPMENT_OID,
                     s.SHIPMENT_NO,
                     s.SHIP_DATE,
                     s.SHIP_NODE,
                     s.SHIP_VIA,
                     s.CARRIER_SERVICE_CODE,
                     TRIM (s.scac),
                     TRIM (s.status)


SELECT s.SHIPMENT_OID, COUNT (*) AS number_of_containers
                FROM ODS_OWN.SHIPMENT          s,
                     ODS_OWN.SHIPMENT_CONTAINER sc,
                     freight_driver_uc            dr
               WHERE     s.SHIPMENT_OID = sc.SHIPMENT_OID
                     AND s.shipment_oid = dr.SHIPMENT_OID
            GROUP BY s.shipment_oid


SELECT DISTINCT  e.Event_ref_id,
                   a.SCHOOL_YEAR,
                   sp.SUB_PROGRAM_NAME,
                   e.PHOTOGRAPHY_DATE,
                   acct.ACCOUNT_NAME,
                   a.APO_ID
              FROM ods_own.apo          a,
                   ods_own.event        e,
                   ODS_OWN.SUB_PROGRAM  sp,
                   ods_own.account      acct,
                   freight_shipment_detail dtl,
                   freight_driver_uc dr
             WHERE     a.APO_OID = e.APO_OID
                   AND a.SUB_PROGRAM_OID = sp.SUB_PROGRAM_OID
                   AND a.ACCOUNT_OID = acct.ACCOUNT_OID
                   AND dtl.event_ref_id = e.event_ref_id
                   AND dtl.shipment_oid = dr.shipment_oid
                   AND dtl.ods_modify_date > TO_DATE(SUBSTR('2024-08-05 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')



SELECT shipment_oid,
                   CASE WHEN track > 0 THEN 1 ELSE 0 END     AS track_exists
              FROM (  SELECT dr.SHIPMENT_OID,
                             SUM (
                                   CASE
                                       WHEN trim(s.tracking_no) IS NULL THEN 0
                                       ELSE 1
                                   END
                                 + CASE
                                       WHEN trim(sc.tracking_no) IS NULL THEN 0
                                       ELSE 1
                                   END)
                                 AS track
                        FROM ODS_OWN.SHIPMENT          s,
                             ODS_OWN.SHIPMENT_CONTAINER sc,
                             freight_driver_uc         dr
                       WHERE     dr.SHIPMENT_OID = s.SHIPMENT_OID
                             AND s.SHIPMENT_OID = sc.SHIPMENT_OID(+)
                    GROUP BY dr.SHIPMENT_OID)


SELECT f.SHIPMENT_OID,
                   CASE
                       WHEN     f.carrier = 'FEDX'
                            AND f.track_exists = 0
                       THEN
                           'MI'
                       WHEN f.carrier = 'MI' AND f.track_exists != 0
                       THEN
                           'FEDX'
                       ELSE
                           f.carrier
                   END
                       AS carrier
              FROM RAX_APP_USER.freight_shipment_detail  f,
                   freight_driver_uc                     dr
             WHERE     f.SHIPMENT_OID = dr.SHIPMENT_OID
                   AND ship_node NOT IN ('Central Lab', 'VirtualNode')


SELECT distinct f.SHIPMENT_OID,
                   CASE
                       WHEN    s.TRACKING_NO LIKE 'MTE%'
                            OR s.TRACKING_NO LIKE 'NMY%'
                            OR sc.TRACKING_NO LIKE 'MTE%'
                            OR sc.TRACKING_NO LIKE 'NMY%'
                       THEN
                           'Perolator'
                       ELSE
                           f.carrier
                   END
                       AS carrier
              FROM freight_driver_uc           dr,
                   RAX_APP_USER.freight_shipment_detail  f,
                   ODS_OWN.SHIPMENT            s,
                   ODS_OWN.SHIPMENT_CONTAINER  sc
             WHERE     dr.SHIPMENT_OID = f.SHIPMENT_OID
                   AND dr.SHIPMENT_OID = s.SHIPMENT_OID
                   AND s.SHIPMENT_OID = sc.SHIPMENT_OID(+)
                   AND s.ship_node NOT IN ('Central Lab', 'VirtualNode')