select *
from ODS_STAGE.data_export_trigger
where data_export_trigger_id = (select min(data_export_trigger_id)
from ODS_STAGE.data_export_trigger
where session_name = '99_DELAYED_SHIPMENT_PKG'
)

--DATA_EXPORT_TRIGGER_ID|SESSION_NAME           |TRANS_DATE|SCHOOL_YEAR|CREATE_DATE        |PROCESSED_DATE     |STATUS   |
------------------------+-----------------------+----------+-----------+-------------------+-------------------+---------+
--                 10050|99_DELAYED_SHIPMENT_PKG|20200505  |9999       |2024-08-08 04:32:26|2024-08-28 07:26:03|PROCESSED|

UPDATE ods_stage.data_export_trigger
SET status = 'READY',
PROCESSED_DATE = SYSDATE
WHERE session_name = '99_DELAYED_SHIPMENT_PKG'

select trans_date , DATA_EXPORT_TRIGGER_ID
from ODS_STAGE.data_export_trigger
where data_export_trigger_id = (select min(data_export_trigger_id)
from ODS_STAGE.data_export_trigger
where session_name = '99_DELAYED_SHIPMENT_PKG'
)
--TRANS_DATE|
------------+
--20200505  |


SELECT status from ODS_STAGE.data_export_trigger WHERE DATA_EXPORT_TRIGGER_ID =10050
--STATUS   |
-----------+
--PROCESSED|

SELECT count(*) FROM RAX_APP_USER.actuate_delayed_shipment_stage
--COUNT(*)|
----------+
--   20128|

SELECT count(*)
 FROM ods.y0yfs_order_line_curr ol,
         ods.y0yfs_order_rel_stat_curr ors,
         ods.y0yfs_status_curr st,
         ods.y0yfs_item_curr yi,
         mart.item mi,
         ods.serve_days_bin_xref sdbx,
         ods.y0yfs_order_header_curr oh,
         ods.y0lt_subject_curr s,
         ods.y0yfs_order_release_curr rel
   WHERE     ol.order_line_key = ors.order_line_key
         AND ors.status = st.status
         AND ors.status_quantity > 0
         AND st.status_name NOT IN ('Cancelled',
                                    'Shipped',
                                    'Reshipped',
                                    'Sit Executed',
                                    'Delivered',
                                    'Back Ordered From Node')
         AND st.process_type_key = 'ORDER_FULFILLMENT'
         AND ol.item_id = yi.item_id
         AND yi.item_id = mi.item_code
         AND (CASE
                 WHEN (SYSDATE - ol.createts) < 1
                 THEN
                    1
                 ELSE
                    CASE
                       WHEN (SYSDATE - ol.createts) > 499 THEN 499
                       ELSE FLOOR (SYSDATE - ol.createts)
                    END
              END) = sdbx.serve_days
         AND 14 = sdbx.release_group_id
         AND ol.order_header_key = oh.order_header_key
         AND oh.extn_subject_key = s.subject_key
         AND ors.order_release_key = rel.order_release_key(+)
         AND oh.enterprise_key <> 'PP'                         /* test data */
         AND mi.merchandise_category = 'Product'
         AND ol.ordered_qty > 0
         AND (SYSDATE - ol.createts) >= 7
         AND ol.item_id NOT IN ('0030', '0020') -- these items should be ignored per Rob Uhrick 20090513
         AND oh.EXTN_ORDER_PROGRAM_TYPE = 'Senior/Studio Style'
ORDER BY CASE
            WHEN st.status_name IN ('Verification Failed',
                                    'Awaiting Verification',
                                    'Verified',
                                    'Created',
                                    'Back Ordered',
                                    'Undeliverable')
            THEN
               'Business'
            ELSE
               CASE
                  WHEN st.status_name IN ('Released', 'Release Acknowledged')
                  THEN
                     'Lab'
                  ELSE
                     CASE
                        WHEN st.status_name IN ('Pending Shipment')
                        THEN
                           'System'
                        ELSE
                           'Unknown'
                     END
               END
         END,
        oh.enterprise_key,
         sdbx.serve_days_bin_sort DESC,
         FLOOR (SYSDATE - ol.createts) DESC


--COUNT(*)|
----------+
--   20128|
