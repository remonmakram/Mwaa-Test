SELECT *
                FROM RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
                WHERE SESS_NAME = '99_YB_DOMINOS_PIZZA_TRACKER_PKG'

SELECT * FROM ODS_OWN.ODS_CDC_LOAD_STATUS
WHERE ODS_TABLE_NAME = 'YB_DOMINO_STG'


SELECT * FROM ODS_STAGE.YB_DOMINO_STG WHERE quality_check IS NOT NULL AND submitted IS NULL
ORDER BY ODS_MODIFY_DATE


SELECT event_oid,
                     SUM (CASE WHEN s.status != 'CANCELED' THEN 1 ELSE 0 END)
                         AS any_non_canceled
                FROM ODS_STAGE.OGP_ORDER_STG s
               WHERE s.ORDER_TYPE = 'Order'
            GROUP BY event_oid
              HAVING SUM (CASE WHEN s.status != 'CANCELED' THEN 1 ELSE 0 END) =
                     0

SELECT * FROM ods_stage.YB_DOMINO_STG WHERE printing IS NOT NULL ORDER BY ODS_MODIFY_DATE DESC


SELECT * FROM ods_stage.YB_DOMINO_STG WHERE EVENT_OID = '8742306'
--EVENT_OID|EVENT_REF_ID|EXPECTED_ARRIVAL_DATE|SUBMITTED          |QUALITY_CHECK      |PRINTING           |PRINTED|BINDING|PREPARING|SHIPPING|DELIVERED|LAST_ETL_RUN_DATE  |ODS_CREATE_DATE    |ODS_MODIFY_DATE    |SUBMITTED_INHERIT|QUALITY_CHECK_INHERIT|PRINTING_INHERIT|BINDING_INHERIT|PREPARING_INHERIT|SHIPPING_INHERIT|PRINTED_INHERIT|
-----------+------------+---------------------+-------------------+-------------------+-------------------+-------+-------+---------+--------+---------+-------------------+-------------------+-------------------+-----------------+---------------------+----------------+---------------+-----------------+----------------+---------------+
--  8742485|EVTF6SHC3   |  2021-03-12 00:00:00|2021-01-21 11:09:21|2021-01-21 11:09:21|2021-01-21 17:09:21|       |       |         |        |         |2024-08-19 06:46:18|2021-03-12 12:21:11|2024-08-19 06:46:18|Y                |Y                    |                |               |                 |                |               |

UPDATE ods_stage.YB_DOMINO_STG SET QUALITY_CHECK_INHERIT = 'Y',shipping_inherit = 'N', PRINTING = NULL,BINDING=NULL,PREPARING=NULL,SHIPPING=NULL,DELIVERED = SYSDATE WHERE EVENT_OID = '8742306'


SELECT * FROM ods_stage.YB_DOMINO_STG WHERE delivered IS NOT NULL AND shipping IS NULL

SELECT * FROM ods_stage.YB_DOMINO_STG WHERE EVENT_OID = '8742306'
--EVENT_OID|EVENT_REF_ID|EXPECTED_ARRIVAL_DATE|SUBMITTED          |QUALITY_CHECK      |PRINTING|PRINTED            |BINDING|PREPARING|SHIPPING|DELIVERED          |LAST_ETL_RUN_DATE  |ODS_CREATE_DATE    |ODS_MODIFY_DATE    |SUBMITTED_INHERIT|QUALITY_CHECK_INHERIT|PRINTING_INHERIT|BINDING_INHERIT|PREPARING_INHERIT|SHIPPING_INHERIT|PRINTED_INHERIT|
-----------+------------+---------------------+-------------------+-------------------+--------+-------------------+-------+---------+--------+-------------------+-------------------+-------------------+-------------------+-----------------+---------------------+----------------+---------------+-----------------+----------------+---------------+
--  8742306|EVT6HQKW3   |  2021-03-12 00:00:00|2021-01-21 00:00:00|2024-08-19 07:03:15|        |2024-08-19 07:03:15|       |         |        |2024-08-19 07:19:01|2024-08-19 07:13:59|2021-03-12 12:21:11|2024-08-19 07:17:12|N                |Y                    |Y               |Y              |Y                |N               |Y              |

--UPDATE ODS_STAGE.YB_DOMINO_STG
--   SET shipping = delivered,
--       shipping_inherit = 'Y',
--       ods_modify_date = SYSDATE
-- WHERE delivered IS NOT NULL AND shipping IS NULL


-- RUN the DAG

SELECT * FROM ods_stage.YB_DOMINO_STG WHERE EVENT_OID = '8742306'

--EVENT_OID|EVENT_REF_ID|EXPECTED_ARRIVAL_DATE|SUBMITTED          |QUALITY_CHECK      |PRINTING           |PRINTED            |BINDING            |PREPARING          |SHIPPING           |DELIVERED          |LAST_ETL_RUN_DATE  |ODS_CREATE_DATE    |ODS_MODIFY_DATE    |SUBMITTED_INHERIT|QUALITY_CHECK_INHERIT|PRINTING_INHERIT|BINDING_INHERIT|PREPARING_INHERIT|SHIPPING_INHERIT|PRINTED_INHERIT|
-----------+------------+---------------------+-------------------+-------------------+-------------------+-------------------+-------------------+-------------------+-------------------+-------------------+-------------------+-------------------+-------------------+-----------------+---------------------+----------------+---------------+-----------------+----------------+---------------+
--  8742306|EVT6HQKW3   |  2021-03-12 00:00:00|2021-01-21 00:00:00|2024-08-19 07:03:15|2024-08-19 07:03:15|2024-08-19 07:03:15|2024-08-19 07:19:01|2024-08-19 07:19:01|2024-08-19 07:19:01|2024-08-19 07:19:01|2024-08-19 07:20:09|2021-03-12 12:21:11|2024-08-19 07:20:10|N                |Y                    |Y               |Y              |Y                |Y               |Y              |