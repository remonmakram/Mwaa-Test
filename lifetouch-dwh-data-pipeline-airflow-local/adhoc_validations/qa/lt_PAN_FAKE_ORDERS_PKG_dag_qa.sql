
select
d2.ORDER_HEADER_OID  ORDER_HEADER_OID
,d2.ORDER_NO ORDER_NO
, null ORDER_FORM_ID
, null MATCHED_CAPTURE_SESSION_ID
, d2.event_ref_id EVENT_REF_ID
, null BATCH_ID
, case when d2.ORDER_BUCKET = 'PAID' then d2.amount else 0 end TOTAL_AMOUNT
, d2.apo_oid APO_OID
, ot.ORDER_TYPE_OID ORDER_TYPE_OID
, oc.ORDER_CHANNEL_OID ORDER_CHANNEL_OID
, d2.PRICE_PROGRAM_OID PRICE_PROGRAM_OID
, d2.EVENT_OID EVENT_OID
, null SHIP_NODE
, null DRAFT_ORDER_FLAG
, null HOLD_FLAG
, null HOLD_REASON_CODE
, null INVOICE_COMPLETE
, null IS_SHIP_COMPLETE
, null ORDER_CLOSED
, d2.ORDER_SHIP_DATE ORDER_DATE
, ot.ORDER_TYPE ORDER_TYPE
, null PAYMENT_STATUS
, null TAX
, null TAX_EXEMPTION_CERTIFICATE
, null TAX_EXEMPT_FLAG
, null TAX_JURISDICTION
, null SHIP_ORDERS_TO
, sysdate ODS_CREATE_DATE
, sysdate ODS_MODIFY_DATE
, myss.SOURCE_SYSTEM_OID SOURCE_SYSTEM_OID
, null STAFF_FLAG
, null CAPTURE_SESSION_QUANTITY
, null ROOM_QUANTITY
, null STAFF_QUANTITY
, null CURRENCY
, d2.TERRITORY_CODE TERRITORY_CODE
, 1 ORDER_SHIP_COMPLETE_IND
, null PERSON_INFO_OID
, null CYOP_IND
, null IMAGE_PREVIEW_ORDER_TYPE
, d2.ORDER_SHIP_DATE ORDER_SHIP_DATE
, d2.ORDER_BUCKET ORDER_BUCKET
, null LAST_USER_MODIFIED_DATE
, null REQUESTED_DELIVERY_DATE
, null SCAC
, null CARRIER_SERVICE_CODE
, null REQUESTED_SHIP_DATE
, null SUBJECT_FIRST_NAME
, null SUBJECT_MIDDLE_NAME
, null SUBJECT_LAST_NAME
, null SUBJECT_GRADE
, null RETAKE_NO
, null PARENT_RETAKE_NO
, null DONT_RELEASE_UNTIL_DATE
, os.ORDER_STATUS ORDER_STATUS
, null BATCHING_REQUIRED
, ' ' CUSTOMER_EMAILID
, null ORDER_BATCH_OID
, null OMS_CREATETS
, null CUSTOMER_PO_NO
, null BILL_TO_PERSON_INFO_OID
, null SHIP_TO_PERSON_INFO_OID
, null AUTOPACK_CODE
,'0001' DOCUMENT_TYPE
, os.ORDER_STATUS_OID ORDER_STATUS_OID
---- select *
from
RAX_APP_USER.T_PAN_D2 d2
, ODS_OWN.ORDER_TYPE ot
, ODS_OWN.ORDER_CHANNEL oc
, ODS_OWN.SOURCE_SYSTEM myss
, ODS_OWN.ORDER_STATUS os
where (1=1)
and ot.order_type = 'Bulk_Order'
and oc.CHANNEL_NAME = 'FOW'
and myss.SOURCE_SYSTEM_SHORT_NAME='ODS'
and os.ORDER_STATUS_CODE = '500' --Shipped

SELECT ol.ORDER_HEADER_OID, ol.ORDER_LINE_OID
      FROM (SELECT *
              FROM (SELECT OH.EVENT_REF_ID,
                           OH.ORDER_HEADER_OID,
                           pu.ORDER_BUCKET,
                           pu.CANCELLED_QTY                         CANCELLED_QTY,
                           RANK ()
                               OVER (
                                   PARTITION BY OH.EVENT_REF_ID,
                                                pu.ORDER_BUCKET,
                                                pu.item_oid
                                   ORDER BY OH.ORDER_HEADER_OID)    RANK
                      -- select *
                      FROM ODS_OWN.ORDER_HEADER   OH,
                           ODS_OWN.ORDER_LINE     ol,
                           (  SELECT d.event_ref_id,
                                     'PAID'                 ORDER_BUCKET,
                                     (-1 * d.NEED_PAID)     CANCELLED_QTY,
                                     d.item_oid
                                -- select *
                                FROM RAX_APP_USER.T_PAN_D d,
                                     (SELECT ROWNUM     id_p
                                        FROM all_objects
                                       WHERE ROWNUM <= 10000) var
                               WHERE (1 = 1)
                            GROUP BY d.event_ref_id,
                                     'PAID',
                                     (-1 * d.NEED_PAID),
                                     d.item_oid,
                                     var.id_p,
                                     d.need_paid
                              HAVING id_p <= (-1 * d.need_paid)
                            UNION
                              SELECT d.event_ref_id,
                                     'UNPAID'                 ORDER_BUCKET,
                                     (-1 * d.NEED_UNPAID)     CANCELLED_QTY,
                                     d.item_oid
                                -- select *
                                FROM RAX_APP_USER.T_PAN_D d,
                                     (SELECT ROWNUM     id_p
                                        FROM all_objects
                                       WHERE ROWNUM <= 10000) var
                               WHERE (1 = 1)
                            GROUP BY d.event_ref_id,
                                     'UNPAID',
                                     (-1 * d.NEED_UNPAID),
                                     d.item_oid,
                                     var.id_p,
                                     d.need_unpaid
                              HAVING id_p <= (-1 * d.need_unpaid)) pu,
                           ods_own.source_system  ss
                     WHERE     (1 = 1)
                           AND pu.EVENT_REF_ID = OH.EVENT_REF_ID
                           AND pu.ORDER_BUCKET = OH.ORDER_BUCKET
                           AND pu.ITEM_OID = ol.ITEM_OID
                           AND ol.ORDER_HEADER_OID = OH.ORDER_HEADER_OID
                           AND OH.SOURCE_SYSTEM_OID = ss.SOURCE_SYSTEM_OID
                           AND ss.SOURCE_SYSTEM_SHORT_NAME = 'ODS') a
             WHERE (1 = 1) AND A.RANK <= A.CANCELLED_QTY) b,
           ODS_OWN.ORDER_LINE  OL
     WHERE (1 = 1) AND B.ORDER_HEADER_OID = OL.ORDER_HEADER_OID



  Select
        canc.ORDER_LINE_OID
  From
    RAX_APP_USER.T_PAN_CANC canc

INSERT INTO RAX_APP_USER.T_PAN_CANC (ORDER_HEADER_OID,ORDER_LINE_OID) VALUES (0,134532549)

select * FROM ODS_OWN.ORDER_LINE
ORDER BY ODS_CREATE_DATE DESC FETCH FIRST 10 ROWS ONLY

--ORDER_LINE_OID|UNIT_PRICE|ORDERED_QUANTITY|LIST_PRICE|RETAIL_PRICE|ORDER_HEADER_OID|ITEM_OID |BUNDLE_PARENT_ORDER_LINE_OID|PACKAGE_REF|SHIPPED_QTY|SORT_SEQ_NO|TAX_INCLUSIVE_IND|EST_TAX_AMOUNT|HOLD_FLAG|LINE_SEQ_NO|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |SOURCE_SYSTEM_OID|ESTIMATED_ACCOUNT_COMMISSION|KIT_CODE|SI_ADDITIONAL_QTY|SI_SHIP_DATE|GCP_ROOM_NEGS|EST_TAX_RATE|LINE_TOTAL|EST_PRETAX_AMOUNT|EARLIEST_SCHEDULE_DATE|SI_ORDERED_QTY|SI_SHIPPED_QTY|SHIP_NODE_OID|MULTI_ORDERED_QTY|MULTI_SHIPPED_QTY|
----------------+----------+----------------+----------+------------+----------------+---------+----------------------------+-----------+-----------+-----------+-----------------+--------------+---------+-----------+-------------------+-------------------+-----------------+----------------------------+--------+-----------------+------------+-------------+------------+----------+-----------------+----------------------+--------------+--------------+-------------+-----------------+-----------------+
--     134532549|         0|               1|         0|           0|     11249986318|282053500|                            |           |          1|999        |                 |              |N        |1.1        |2024-09-23 04:29:47|2024-09-23 04:29:47|                2|                            |PK      |                 |            |             |            |         0|                 |   2024-09-23 03:40:26|              |              |          163|                 |                 |
--     134532556|         0|               1|         0|           0|     11249986317| 50288637|                            |S15        |          0|10         |                 |              |N        |1.1        |2024-09-23 04:29:47|2024-09-23 04:29:47|                2|                            |PK      |                 |            |             |            |         0|                 |   2024-09-23 03:50:59|              |              |         2216|                 |                 |
--     134532550|         0|               1|         0|           0|     11253415179| 50288637|                            |S15        |          0|10         |                 |              |N        |1.1        |2024-09-23 04:29:47|2024-09-23 04:29:47|                2|                            |PK      |                 |            |             |            |         0|                 |   2024-09-23 03:50:59|              |              |         2216|                 |                 |
--     134532511|         0|               1|         0|           0|     11249986311|    46605|                   134532536|F          |          0|70         |                 |              |N        |9.1        |2024-09-23 03:37:53|2024-09-23 04:29:47|                2|                            |PK      |                 |            |             |            |         0|                 |   2024-09-23 03:14:01|              |              |         2216|                 |                 |
--     134532504|         0|               1|         0|           0|     11249986314|    46621|                   134532505|A          |          0|20         |                 |              |N        |5.1        |2024-09-23 03:37:53|2024-09-23 04:29:47|                2|                            |PK      |                 |            |             |            |         0|                 |   2024-09-23 03:14:35|              |              |         2216|                 |                 |
--     134532522|         0|               1|         0|           0|     11249986314|    46605|                   134532505|A          |          0|70         |                 |              |N        |4.1        |2024-09-23 03:37:53|2024-09-23 04:29:47|                2|                            |PK      |                 |            |             |            |         0|                 |   2024-09-23 03:14:35|              |              |         2216|                 |                 |
--     134532542|         0|               1|         0|           0|     11249986314|    46613|                   134532505|A          |          0|80         |                 |              |N        |3.1        |2024-09-23 03:37:53|2024-09-23 04:29:47|                2|                            |PK      |                 |            |             |            |         0|                 |   2024-09-23 03:14:35|              |              |         2216|                 |                 |
--     134532513|         0|               1|         0|           0|     11249986311|    87682|                   134532517|A          |          0|40         |                 |              |N        |6.1        |2024-09-23 03:37:53|2024-09-23 04:29:47|                2|                            |PK      |                 |            |             |            |         0|                 |   2024-09-23 03:14:01|              |              |         2216|                 |                 |
--     134532541|         0|               1|         0|           0|     11249986311|    46608|                   134532517|A          |          0|90         |                 |              |N        |2.1        |2024-09-23 03:37:53|2024-09-23 04:29:47|                2|                            |PK      |                 |            |             |            |         0|                 |   2024-09-23 03:14:00|              |              |         2216|                 |                 |
--     134532512|         0|               1|         0|           0|     11249986311|    46621|                   134532517|A          |          0|20         |                 |              |N        |5.1        |2024-09-23 03:37:53|2024-09-23 04:29:47|                2|                            |PK      |                 |            |             |            |         0|                 |   2024-09-23 03:14:01|              |              |         2216|                 |                 |
--


select * FROM ODS_OWN.ORDER_LINE WHERE ORDER_LINE_OID = '134532549'

--ORDER_LINE_OID|UNIT_PRICE|ORDERED_QUANTITY|LIST_PRICE|RETAIL_PRICE|ORDER_HEADER_OID|ITEM_OID |BUNDLE_PARENT_ORDER_LINE_OID|PACKAGE_REF|SHIPPED_QTY|SORT_SEQ_NO|TAX_INCLUSIVE_IND|EST_TAX_AMOUNT|HOLD_FLAG|LINE_SEQ_NO|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |SOURCE_SYSTEM_OID|ESTIMATED_ACCOUNT_COMMISSION|KIT_CODE|SI_ADDITIONAL_QTY|SI_SHIP_DATE|GCP_ROOM_NEGS|EST_TAX_RATE|LINE_TOTAL|EST_PRETAX_AMOUNT|EARLIEST_SCHEDULE_DATE|SI_ORDERED_QTY|SI_SHIPPED_QTY|SHIP_NODE_OID|MULTI_ORDERED_QTY|MULTI_SHIPPED_QTY|
----------------+----------+----------------+----------+------------+----------------+---------+----------------------------+-----------+-----------+-----------+-----------------+--------------+---------+-----------+-------------------+-------------------+-----------------+----------------------------+--------+-----------------+------------+-------------+------------+----------+-----------------+----------------------+--------------+--------------+-------------+-----------------+-----------------+
--     134532549|         0|               1|         0|           0|     11249986318|282053500|                            |           |          1|999        |                 |              |N        |1.1        |2024-09-23 04:29:47|2024-09-23 04:29:47|                2|                            |PK      |                 |            |             |            |         0|                 |   2024-09-23 03:40:26|              |              |          163|                 |                 |

SELECT ordered_quantity,ODS_CREATE_DATE, ODS_MODIFY_DATE FROM ODS_OWN.ORDER_LINE WHERE ORDER_LINE_OID = '134532549'
--ORDERED_QUANTITY|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
------------------+-------------------+-------------------+
--               1|2024-09-23 04:29:47|2024-09-23 04:29:47|


MERGE INTO ODS_OWN.ORDER_LINE d
USING (
  Select
        canc.ORDER_LINE_OID
  From
    RAX_APP_USER.T_PAN_CANC canc
  ) s
ON
  (d.ORDER_LINE_OID = s.ORDER_LINE_OID)
WHEN MATCHED
THEN
UPDATE SET
  d.ordered_quantity = 0
  ,d.LINE_TOTAL = 0
  ,d.ODS_MODIFY_DATE = sysdate


  SELECT ordered_quantity,ODS_CREATE_DATE, ODS_MODIFY_DATE FROM ODS_OWN.ORDER_LINE WHERE ORDER_LINE_OID = '134532549'

--  ORDERED_QUANTITY|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
------------------+-------------------+-------------------+
--               0|2024-09-23 04:29:47|2024-09-23 06:04:31|

-- run the dag

SELECT ordered_quantity,ODS_CREATE_DATE, ODS_MODIFY_DATE FROM ODS_OWN.ORDER_LINE WHERE ORDER_LINE_OID = '134532549'

--UPDATE ods_own.ods_cdc_load_status
--SET last_cdc_completion_date = TO_DATE(SUBSTR('2024-09-16 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
--WHERE ods_table_name= 'OMS2_LT_IMAGE_STG'


-- run the dag

select * FROM ODS_STAGE.OMS2_LT_IMAGE_STG WHERE IMAGE_ID = '055d72fc-37d9-4001-bde0-8a3e3cdae31e'
--LAYOUT_THEME_OID|LAYOUT_THEME_ID|AUDIT_CREATE_DATE  |AUDIT_CREATED_BY |AUDIT_MODIFIED_BY|AUDIT_MODIFY_DATE  |EXTERNAL_KEY|NAME     |ODS_CREATE_DATE    |ODS_MODIFY_DATE    |SOURCE_SYSTEM_OID|
------------------+---------------+-------------------+-----------------+-----------------+-------------------+------------+---------+-------------------+-------------------+-----------------+
--           17498|          44281|2024-09-05 15:40:55|lims.is-engr-user|lims.is-engr-user|2024-09-05 15:43:47|      103266|103266 NA|2024-09-15 09:25:18|2024-09-15 09:25:18|              561|