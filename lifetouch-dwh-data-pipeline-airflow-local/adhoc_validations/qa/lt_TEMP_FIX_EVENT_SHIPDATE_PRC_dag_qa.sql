SELECT count(*)
      FROM ODS_OWN.SUB_PROGRAM    sp,
           ods_own.apo            a,
           ods_own.event          e,
           ODS_OWN.ORDER_HEADER   oh,
           ODS_OWN.ORDER_LINE     ol,
           ODS_OWN.ITEM           i,
           ODS_OWN.SHIPMENT_LINE  sl,
           ods_own.shipment       s
     WHERE     sp.SUB_PROGRAM_OID = a.SUB_PROGRAM_OID
           AND a.APO_OID = e.APO_OID
           AND e.EVENT_OID = oh.EVENT_OID
           AND ol.ORDER_HEADER_OID = oh.ORDER_HEADER_OID
           AND ol.ITEM_OID = i.ITEM_OID
           AND ol.ORDER_LINE_OID = sl.ORDER_LINE_OID
           AND sl.SHIPMENT_OID = s.SHIPMENT_OID
           AND sp.SUB_PROGRAM_NAME = 'Yearbook'
           AND a.SCHOOL_YEAR >= 2020
           --and oh.TOTAL_AMOUNT > 0
           AND oh.ORDER_TYPE = 'YBYearbook_Order'
           AND i.DESCRIPTION = 'Yearbook'
           AND e.SHIP_DATE IS NOT NULL
           AND NOT EXISTS
                   (SELECT 1
                      FROM ODS_OWN.SALES_RECOGNITION sr
                     WHERE sr.EVENT_OID = e.EVENT_OID)
           AND NOT EXISTS
                   (SELECT 1
                      FROM SRM_OWN.EVENT_CHANGE_NOTIFICATION z
                     WHERE     (1 = 1)
                           AND z.processing_status IN
                                   ('Unprocessed', 'Retry')
                           AND z.EVENT_OID = E.EVENT_OID)


select * FROM ODS_OWN.SUB_PROGRAM
ORDER BY ODS_MODIFY_DATE DESC FETCH FIRST 10 ROWS ONLY

--SUB_PROGRAM_OID|SUB_PROGRAM_NAME       |PROGRAM_OID|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |SOURCE_SYSTEM_OID|SUB_PROGRAM_ID|
-----------------+-----------------------+-----------+-------------------+-------------------+-----------------+--------------+
--            263|Arun_Test- manual entry|        123|2024-08-07 02:36:39|2024-08-07 02:36:39|                1|         10006|
--            285|Candids                |        222|2024-03-28 07:29:28|2024-03-28 07:29:28|              221|              |
--             41|College Seniors        |         20|2016-02-16 09:45:27|2016-02-16 09:45:27|                1|         10318|
--            244|Deepak                 |        142|2016-01-28 11:05:50|2016-01-28 11:05:50|                1|         10169|
--            284|Service Non Rev        |        162|2016-01-28 11:05:50|2016-01-28 11:05:50|                1|         10170|
--             31|Sports                 |         16|2015-09-08 19:06:12|2015-09-08 19:06:12|                1|              |
--             24|Dance                  |         17|2015-09-08 18:49:26|2015-09-08 18:49:26|                1|         10006|
--             62|Commencements          |         21|2015-09-08 18:48:40|2015-09-08 18:48:40|                1|         10120|
--             33|Yearbook               |         11|2013-05-16 14:54:09|2014-08-14 15:47:15|                1|            10|
--            125|Pre Cap & Gown         |         12|2013-05-16 14:54:09|2013-10-01 09:11:52|                1|         10161|


select * FROM srm_own.EVENT_CHANGE_NOTIFICATION
ORDER BY last_updated DESC FETCH FIRST 10 ROWS ONLY

--ID      |CHANGE_TYPE |CHANGED_OID|DATE_CREATED       |EVENT_OID|EVENT_REF_ID|LAST_ERROR                                                                                                                                                                                                                                                     |LAST_PROCESSING_ATTEMPT|LAST_UPDATED       |PROCESSING_ATTEMPTS|PROCESSING_STATUS|AMOUNT|CREATED_BY                        |UPDATED_BY   |
----------+------------+-----------+-------------------+---------+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------+-------------------+-------------------+-----------------+------+----------------------------------+-------------+
--32768168|Shipment    |   72765779|2024-09-23 02:56:50|  8966514|EVTR62KM4   |Recognition failed with Tax Calculation issue for event reference Id EVTR62KM4 - Tax calculation failed for event reference Id: EVTR62KM4 - Client received SOAP Fault from server: No tax areas were found during the lookup. The address fields are inconsist|    2024-09-23 04:00:01|2024-09-23 04:00:01|                  2|Retry            |     0|TEMP_FIX_EVENT_SHIPDATE_PRC       |srm.batchuser|
--32768167|Shipment    |   72765727|2024-09-23 02:56:50|  8964508|EVTK9FFWT   |Recognition failed with Tax Calculation issue for event reference Id EVTK9FFWT - Tax calculation failed for event reference Id: EVTK9FFWT - Client received SOAP Fault from server: No tax areas were found during the lookup. The address fields are inconsist|    2024-09-23 04:00:01|2024-09-23 04:00:01|                  2|Retry            |     0|TEMP_FIX_EVENT_SHIPDATE_PRC       |srm.batchuser|
--32768166|Shipment    |   72765806|2024-09-23 02:56:50|  8966405|EVT2HKNFD   |Recognition failed with Tax Calculation issue for event reference Id EVT2HKNFD - Tax calculation failed for event reference Id: EVT2HKNFD - Client received SOAP Fault from server: No tax areas were found during the lookup. The address fields are inconsist|    2024-09-23 04:00:00|2024-09-23 04:00:00|                  2|Retry            |     0|TEMP_FIX_EVENT_SHIPDATE_PRC       |srm.batchuser|
--32768165|Shipment    |   72769961|2024-09-23 02:56:50|  8968813|EVT7D3M63   |Recognition failed with Tax Calculation issue for event reference Id EVT7D3M63 - Tax calculation failed for event reference Id: EVT7D3M63 - Client received SOAP Fault from server: No tax areas were found during the lookup. The address fields are inconsist|    2024-09-23 04:00:00|2024-09-23 04:00:00|                  2|Retry            |     0|TEMP_FIX_EVENT_SHIPDATE_PRC       |srm.batchuser|
--32768171|Shipment    |   72769957|2024-09-23 03:56:51|  8970339|EVTBKHJRX   |Recognition failed with Tax Calculation issue for event reference Id EVTBKHJRX - Tax calculation failed for event reference Id: EVTBKHJRX - Client received SOAP Fault from server: No tax areas were found during the lookup. The address fields are inconsist|    2024-09-23 04:00:00|2024-09-23 04:00:00|                  1|Retry            |     0|TEMP_FIX_EVENT_SHIPDATE_PRC       |srm.batchuser|
--32768164|Shipment    |   72765774|2024-09-23 02:56:50|  8964502|EVTQW82NB   |Recognition failed with Tax Calculation issue for event reference Id EVTQW82NB - Tax calculation failed for event reference Id: EVTQW82NB - Client received SOAP Fault from server: No tax areas were found during the lookup. The address fields are inconsist|    2024-09-23 04:00:00|2024-09-23 04:00:00|                  2|Retry            |     0|TEMP_FIX_EVENT_SHIPDATE_PRC       |srm.batchuser|
--32768159|Shipment    |   72770027|2024-09-23 02:56:50|  8970850|EVTMPJ38F   |Recognition failed with Tax Calculation issue for event reference Id EVTMPJ38F - Tax calculation failed for event reference Id: EVTMPJ38F - Client received SOAP Fault from server: No tax areas were found during the lookup. The address fields are inconsist|    2024-09-23 04:00:00|2024-09-23 04:00:00|                  2|Retry            |     0|TEMP_FIX_EVENT_SHIPDATE_PRC       |srm.batchuser|
--32768160|Shipment    |   72770027|2024-09-23 02:56:50|  8970850|EVTMPJ38F   |Recognition failed with Tax Calculation issue for event reference Id EVTMPJ38F - Tax calculation failed for event reference Id: EVTMPJ38F - Client received SOAP Fault from server: No tax areas were found during the lookup. The address fields are inconsist|    2024-09-23 04:00:00|2024-09-23 04:00:00|                  2|Retry            |     0|TEMP_FIX_EVENT_SHIPDATE_PRC       |srm.batchuser|
--32768161|Shipment    |   72769976|2024-09-23 02:56:50|  8968811|EVTJ2RXSC   |Recognition failed with Tax Calculation issue for event reference Id EVTJ2RXSC - Tax calculation failed for event reference Id: EVTJ2RXSC - Client received SOAP Fault from server: No tax areas were found during the lookup. The address fields are inconsist|    2024-09-23 04:00:00|2024-09-23 04:00:00|                  2|Retry            |     0|TEMP_FIX_EVENT_SHIPDATE_PRC       |srm.batchuser|
--32768169|EventPayment|    3544082|2024-09-23 03:04:50|  8674117|LN648106Y0  |School Year is invalid for Event Reference Id: LN648106Y0.  School year must not be null and must be in the current or previous school year.  Cannot conduct sales recognition for this event.                                                                 |    2024-09-23 04:00:00|2024-09-23 04:00:00|                  1|Retry            | 16.13|LOAD_EVENT_CHANGE_NOTIFICATION_PKG|srm.batchuser|




select * FROM ODS_OWN.SALES_RECOGNITION WHERE EVENT_OID = '8966514'

select * FROM srm_own.EVENT_CHANGE_NOTIFICATION WHERE ID = '32768168'
--ID      |CHANGE_TYPE|CHANGED_OID|DATE_CREATED       |EVENT_OID|EVENT_REF_ID|LAST_ERROR                                                                                                                                                                                                                                                     |LAST_PROCESSING_ATTEMPT|LAST_UPDATED       |PROCESSING_ATTEMPTS|PROCESSING_STATUS|AMOUNT|CREATED_BY                 |UPDATED_BY   |
----------+-----------+-----------+-------------------+---------+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------+-------------------+-------------------+-----------------+------+---------------------------+-------------+
--32768168|Shipment   |   72765779|2024-09-23 02:56:50|  8966514|EVTR62KM4   |Recognition failed with Tax Calculation issue for event reference Id EVTR62KM4 - Tax calculation failed for event reference Id: EVTR62KM4 - Client received SOAP Fault from server: No tax areas were found during the lookup. The address fields are inconsist|    2024-09-23 04:00:01|2024-09-23 04:00:01|                  2|Retry            |     0|TEMP_FIX_EVENT_SHIPDATE_PRC|srm.batchuser|

select * FROM SRM_OWN.EVENT_CHANGE_NOTIFICATION WHERE EVENT_OID = '8966514' AND ID = '32768168'
--ID      |CHANGE_TYPE|CHANGED_OID|DATE_CREATED       |EVENT_OID|EVENT_REF_ID|LAST_ERROR                                                                                                                                                                                                                                                     |LAST_PROCESSING_ATTEMPT|LAST_UPDATED       |PROCESSING_ATTEMPTS|PROCESSING_STATUS|AMOUNT|CREATED_BY                 |UPDATED_BY   |
----------+-----------+-----------+-------------------+---------+------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+-----------------------+-------------------+-------------------+-----------------+------+---------------------------+-------------+
--32768168|Shipment   |   72765779|2024-09-23 02:56:50|  8966514|EVTR62KM4   |Recognition failed with Tax Calculation issue for event reference Id EVTR62KM4 - Tax calculation failed for event reference Id: EVTR62KM4 - Client received SOAP Fault from server: No tax areas were found during the lookup. The address fields are inconsist|    2024-09-23 04:00:01|2024-09-23 04:00:01|                  2|Retry            |     0|TEMP_FIX_EVENT_SHIPDATE_PRC|srm.batchuser|

--delete FROM SRM_OWN.EVENT_CHANGE_NOTIFICATION WHERE EVENT_OID = '8966514' AND ID = '32768168'
--
--
--delete FROM srm_own.EVENT_CHANGE_NOTIFICATION WHERE ID = '32768168'

--UPDATE ods_own.ods_cdc_load_status
--SET last_cdc_completion_date = TO_DATE(SUBSTR('2024-09-16 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
--WHERE ods_table_name= 'OMS2_LT_IMAGE_STG'


-- run the dag

select * FROM ODS_STAGE.OMS2_LT_IMAGE_STG WHERE IMAGE_ID = '055d72fc-37d9-4001-bde0-8a3e3cdae31e'
--LAYOUT_THEME_OID|LAYOUT_THEME_ID|AUDIT_CREATE_DATE  |AUDIT_CREATED_BY |AUDIT_MODIFIED_BY|AUDIT_MODIFY_DATE  |EXTERNAL_KEY|NAME     |ODS_CREATE_DATE    |ODS_MODIFY_DATE    |SOURCE_SYSTEM_OID|
------------------+---------------+-------------------+-----------------+-----------------+-------------------+------------+---------+-------------------+-------------------+-----------------+
--           17498|          44281|2024-09-05 15:40:55|lims.is-engr-user|lims.is-engr-user|2024-09-05 15:43:47|      103266|103266 NA|2024-09-15 09:25:18|2024-09-15 09:25:18|              561|