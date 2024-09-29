/* TASK No. 1 */
/* Send missed shipment notification */

INSERT INTO srm_own.EVENT_CHANGE_NOTIFICATION (id,
                                               change_type,
                                               changed_oid,
                                               date_created,
                                               event_oid,
                                               event_ref_id,
                                               last_updated,
                                               processing_status,
                                               processing_attempts,
                                               amount,
                                               created_by)
    SELECT srm_own.EVENT_CHANGE_NOTIFICATION_SEQ.NEXTVAL
               id,
           'Shipment'
               change_type,
           s.shipment_oid
               changed_oid,
           SYSDATE
               date_created,
           e.event_oid
               event_oid,
           e.event_ref_id
               event_ref_id,
           SYSDATE
               last_updated,
           'Unprocessed'
               processing_status,
           0
               processing_attempts,
           0
               amount,
           'TEMP_FIX_EVENT_SHIPDATE_PRC'
               created_by
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

&


/*-----------------------------------------------*/
