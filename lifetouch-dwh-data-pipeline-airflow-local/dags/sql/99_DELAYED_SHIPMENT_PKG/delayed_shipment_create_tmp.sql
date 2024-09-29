/*-----------------------------------------------*/
/* TASK No. 5 */
/* drop report table */

--BEGIN
--DBMS_STATS.GATHER_TABLE_STATS (
--    ownname =>	'RAX_APP_USER',
--    tabname =>	'actuate_delayed_shipment_stage',
--    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
--);
--END;
--
--&

BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.actuate_delayed_shipment_stage';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* create report table */

create table RAX_APP_USER.actuate_delayed_shipment_stage as
/* Formatted on 6/20/2017 3:41:34 AM (QP5 v5.269.14213.34769) */
  SELECT CASE
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
         END
            AS big_grouping,
         sdbx.serve_days_bin,
         sdbx.serve_days_bin_sort,
         FLOOR (SYSDATE - ol.createts) AS days_since_line_entered,
         CASE
            WHEN rel.createts IS NULL THEN 0
            ELSE FLOOR (SYSDATE - rel.createts)
         END
            AS days_since_release,
         CASE
            WHEN     (   st.status_name IN ('Verification Failed')
                      OR (    st.status_name IN ('Awaiting Verification',
                                                 'Verified')
                          AND (   oh.hold_reason_code IS NOT NULL
                               OR ol.hold_reason_code IS NOT NULL)))
                 AND (oh.entry_type = 'Call_Center')
            THEN
               'Likely actual hold - Call Center'
            ELSE
               CASE
                  WHEN     (   st.status_name IN ('Verification Failed')
                            OR (    st.status_name IN ('Awaiting Verification',
                                                       'Verified')
                                AND (   oh.hold_reason_code IS NOT NULL
                                     OR ol.hold_reason_code IS NOT NULL)))
                       AND (   oh.entry_type <> 'Call_Center'
                            OR oh.entry_type IS NULL)
                  THEN
                     'Likely actual hold - Lab'
                  ELSE
                     CASE
                        WHEN     st.status_name IN ('Back Ordered')
                             AND (   oh.hold_reason_code IS NOT NULL
                                  OR ol.hold_reason_code IS NOT NULL)
                        THEN
                           'Release refused and held'
                        ELSE
                           CASE
                              WHEN st.status_name IN ('Awaiting Verification',
                                                      'Verified',
                                                      'Back Ordered')
                              THEN
                                 'Pending release, no hold'
                              ELSE
                                 CASE
                                    WHEN     st.status_name IN ('Created')
                                         AND oh.entry_type = 'Call_Center'
                                    THEN
                                       'Unsubmitted - Call Center'
                                    ELSE
                                       CASE
                                          WHEN     st.status_name IN ('Created')
                                               AND (   oh.entry_type <>
                                                          'Call_Center'
                                                    OR oh.entry_type IS NULL)
                                          /*     then 'Unsubmitted - Lab' else  */
                                          THEN
                                             'Unsubmitted - ' || oh.entry_type
                                          ELSE
                                             CASE
                                                WHEN st.status_name IN ('Released')
                                                THEN
                                                   'Sent to lab, but no confirm'
                                                ELSE
                                                   CASE
                                                      WHEN st.status_name IN ('Release Acknowledged')
                                                      THEN
                                                         'Sent to lab, and confirmed'
                                                      ELSE
                                                         CASE
                                                            WHEN st.status_name IN ('Pending Shipment')
                                                            THEN
                                                               'Likely Shipped, but no message'
                                                            ELSE
                                                               st.status_name
                                                         END
                                                   END
                                             END
                                       END
                                 END
                           END
                     END
               END
         END
            AS detail_grouping,
         ol.createts AS line_create_date,
         rel.createts AS release_date,
         oh.enterprise_key,
         DECODE (oh.ship_node,
                 'Winnipeg', 'Winnipeg',
                 'Chatt/Chico/Muncie etc')
            AS lab,
         s.subject_id,
         s.first_name || ' ' || s.last_name subject_name,
         oh.order_no,
         ol.prime_line_no,
         rel.ship_advice_no,
         rel.shipnode_key,
         ors.status_quantity,
         st.status_name,
         ol.unit_price * ors.status_quantity AS extended_price,
         ol.ordered_qty,
         ol.item_id,
         ol.item_description,
         oh.hold_reason_code AS order_hold_reason,
         rel.hold_reason_code AS release_hold_reason,
         ol.hold_reason_code AS line_hold_reason,
        OL.CREATEUSERID AS CREATEUSERID 
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


