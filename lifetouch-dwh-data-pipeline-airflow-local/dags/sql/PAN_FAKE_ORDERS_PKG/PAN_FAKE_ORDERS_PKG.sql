/* TASK No. 1 */
/* Drop t_pan_d */

BEGIN  
   EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.t_pan_d';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 2 */
/* Create t_pan_d */

CREATE TABLE t_pan_d
AS
    SELECT E.EVENT_REF_ID,
           E.EVENT_OID,
           A.APO_OID,
           A.TERRITORY_CODE,
           SP.SUB_PROGRAM_NAME,
           GOC.PACKAGE_NAME
               GDT_PACKAGE,
           I.DESCRIPTION,
           I.ITEM_OID,
           CASE WHEN pss.amount = 0 THEN 0.01 ELSE pss.amount END
               AMOUNT,              -- charge a penny if the offering is wrong
           gec.SHIP_DATE,
           GOC.PAID_PACKAGES
               GDT_PAID,
           GOC.UNPAID_PACKAGES
               GDT_UNPAID,
           0
               AS ODS_PAID,
           0
               AS ODS_UNPAID,
           0
               AS NEED_PAID,
           0
               AS NEED_UNPAID
      FROM ODS_OWN.SUB_PROGRAM           SP,
           ODS_OWN.APO                   A,
           ODS_OWN.EVENT                 E,
           ODS.GDT_OFFERING_DETAIL_CURR  GOC,
           ods.gdt_event_curr            gec,
           ODS_OWN.PRICE_PROGRAM         PP,
           ODS_OWN.PP_PRICE_SET          PPPS,
           ODS_OWN.PRICE_SET             PS,
           ODS_OWN.PRICE_SET_SKU         PSS,
           ods_own.item                  i,
           ods_own.source_system         ass,
           ods_own.source_system         ess
     WHERE     SP.SUB_PROGRAM_OID = A.SUB_PROGRAM_OID
           AND A.APO_OID = E.APO_OID
           AND E.EVENT_REF_ID = GOC.JOB_NBR
           AND e.event_ref_id = gec.job_nbr
           AND A.PRICE_PROGRAM_OID = PP.PRICE_PROGRAM_OID
           AND PP.PRICE_PROGRAM_OID = PPPS.PRICE_PROGRAM_OID
           AND PPPS.PRICE_SET_OID = PS.PRICE_SET_OID
           AND PS.PRICE_SET_OID = PSS.PRICE_SET_OID
           AND PSS.ITEM_OID = i.ITEM_OID
           AND E.SOURCE_SYSTEM_OID = ess.SOURCE_SYSTEM_OID
           AND A.SOURCE_SYSTEM_OID = ass.SOURCE_SYSTEM_OID
           AND ass.SOURCE_SYSTEM_short_NAME = 'APOCS'
           AND ess.SOURCE_SYSTEM_SHORT_NAME IN ('FOW', 'DW')
           AND A.FINANCIAL_PROCESSING_SYSTEM = 'Spectrum'
           AND SP.SUB_PROGRAM_NAME = 'Panoramic Groups'
           AND A.SCHOOL_YEAR >= 2018
           AND PSS.CHANNEL LIKE '%PAPER%'
           AND A.FULFILLING_LAB_SYSTEM != 'Prism'
           AND gec.ACTIVE_IND = 'A'
           AND GOC.ACTIVE_IND = 'A'
           AND NVL (gec.SHIP_DATE, TO_DATE ('01011900', 'MMDDYYYY')) !=
               TO_DATE ('01011900', 'MMDDYYYY')
           AND PSS.PRODUCT_CODE = GOC.PACKAGE_name
--and E.EVENT_REF_ID in( 'AA258002T0','RO468055T0')


&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* Populate ODS Order count */

MERGE INTO t_pan_d T
     USING (  SELECT E.EVENT_REF_ID,
                     I.DESCRIPTION
                         AS ORDER_ITEM_DESCRIPTION,
                     SUM (CASE WHEN OH.ORDER_BUCKET = 'PAID' THEN 1 ELSE 0 END)
                         OH_PAID_QTY,
                     SUM (
                         CASE WHEN OH.ORDER_BUCKET = 'UNPAID' THEN 1 ELSE 0 END)
                         OH_UNPAID_QTY
                FROM ODS_OWN.SUB_PROGRAM SP,
                     ODS_OWN.APO         A,
                     ODS_OWN.EVENT       E,
                     ODS_OWN.ORDER_HEADER OH,
                     ODS_OWN.ORDER_LINE  OL,
                     ODS_OWN.ITEM        I
               WHERE     SP.SUB_PROGRAM_OID = A.SUB_PROGRAM_OID
                     AND A.APO_OID = E.APO_OID
                     AND E.EVENT_OID = OH.EVENT_OID
                     AND OH.ORDER_HEADER_OID = OL.ORDER_HEADER_OID
                     AND OL.ITEM_OID = I.ITEM_OID
                     AND SP.SUB_PROGRAM_NAME = 'Panoramic Groups'
                     AND A.SCHOOL_YEAR >= 2016
                     AND A.FULFILLING_LAB_SYSTEM != 'Prism'
                     AND OH.ORDER_BUCKET(+) IN ('PAID', 'UNPAID')
            GROUP BY E.EVENT_REF_ID, I.DESCRIPTION) S
        ON (    S.EVENT_REF_ID = T.EVENT_REF_ID
            AND S.ORDER_ITEM_DESCRIPTION = T.DESCRIPTION)
WHEN MATCHED
THEN
    UPDATE SET T.ODS_PAID = S.OH_PAID_QTY, T.ODS_UNPAID = S.OH_UNPAID_QTY

&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* Populate needed order count */

UPDATE t_pan_d
   SET NEED_PAID = GDT_PAID - ODS_PAID, NEED_UNPAID = GDT_UNPAID - ODS_UNPAID

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Delete where no new or cancelled orders */

DELETE FROM t_pan_d
      WHERE NEED_PAID = 0 AND NEED_UNPAID = 0

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Drop Event level table */
BEGIN  
   EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.t_pan_shipment';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Create Event level table for Shipment_OID & date */

create table t_pan_shipment as select distinct event_ref_id, d.SHIP_DATE, 0 as shipment_oid from t_pan_d d

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Set Shipment_OID */

update RAX_APP_USER.t_pan_shipment set shipment_oid = ods_stage.shipment_oid_seq.nextval

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Drop t_pan_d2 table  */


BEGIN  
   EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.T_PAN_D2';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Create t_pan_d2 table */

CREATE TABLE RAX_APP_USER.T_PAN_D2
AS
    SELECT ods_stage.order_header_oid_seq.NEXTVAL      ORDER_HEADER_OID,
           ods_stage.order_line_oid_seq.NEXTVAL        ORDER_LINE_OID,
           ods_stage.shipment_line_oid_seq.NEXTVAL     SHIPMENT_LINE_OID,
           s.SHIPMENT_OID                              SHIPMENT_OID,
           pu.ORDER_NO                                 ORDER_NO,
           e.event_ref_id                              EVENT_REF_ID,
           pu.AMOUNT,
           a.apo_oid                                   APO_OID,
           a.PRICE_PROGRAM_OID                         PRICE_PROGRAM_OID,
           e.EVENT_OID                                 EVENT_OID,
           a.TERRITORY_CODE                            TERRITORY_CODE,
           s.ship_date                                 ORDER_SHIP_DATE,
           pu.ORDER_BUCKET                             ORDER_BUCKET,
           pu.item_oid
      FROM ODS_OWN.EVENT   e,
           ODS_OWN.APO     a,
           t_pan_shipment  s,
           (  SELECT d.event_ref_id,
                     'PAID'         ORDER_BUCKET,
                        d.event_ref_id
                     || ':P:'
                     || d.GDT_PACKAGE
                     || ':'
                     || TO_CHAR (SYSTIMESTAMP, 'DDMMYYYYHH24MISS')
                     || ':'
                     || var.id_p    ORDER_NO,
                     d.AMOUNT,
                     d.ITEM_OID
                FROM RAX_APP_USER.T_pan_D       d,
                     RAX_APP_USER.T_PAN_SHIPMENT s,
                     (SELECT ROWNUM     id_p
                        FROM all_objects
                       WHERE ROWNUM <= 10000) var
               WHERE d.EVENT_REF_ID = s.EVENT_REF_ID
            GROUP BY d.event_ref_id,
                     'PAID',
                        d.event_ref_id
                     || ':P:'
                     || d.GDT_PACKAGE
                     || ':'
                     || TO_CHAR (SYSTIMESTAMP, 'DDMMYYYYHH24MISS')
                     || ':'
                     || var.id_p,
                     d.GDT_PACKAGE,
                     d.AMOUNT,
                     d.ITEM_OID,
                     s.shipment_oid,
                     var.id_p,
                     d.need_paid
              HAVING id_p <= d.need_paid
            UNION
              SELECT d.event_ref_id,
                     'UNPAID'         ORDER_BUCKET,
                        d.event_ref_id
                     || ':U:'
                     || d.GDT_PACKAGE
                     || ':'
                     || TO_CHAR (SYSTIMESTAMP, 'DDMMYYYYHH24MISS')
                     || ':'
                     || var.id_p    ORDER_NO,
                     d.AMOUNT,
                     d.ITEM_OID
                FROM RAX_APP_USER.T_pan_D       d,
                     RAX_APP_USER.T_PAN_SHIPMENT s,
                     (SELECT ROWNUM     id_p
                        FROM all_objects
                       WHERE ROWNUM <= 10000) var
               WHERE d.EVENT_REF_ID = s.EVENT_REF_ID
            GROUP BY d.event_ref_id,
                     'UNPAID',
                        d.event_ref_id
                     || ':U:'
                     || d.GDT_PACKAGE
                     || ':'
                     || TO_CHAR (SYSTIMESTAMP, 'DDMMYYYYHH24MISS')
                     || ':'
                     || var.id_p,
                     d.GDT_PACKAGE,
                     d.AMOUNT,
                     d.ITEM_OID,
                     s.shipment_oid,
                     var.id_p,
                     d.need_unpaid
              HAVING id_p <= d.need_unpaid) pu
     WHERE     e.event_ref_id = pu.event_ref_id
           AND e.event_ref_id = s.event_ref_id
           AND a.apo_oid = e.apo_oid


&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Drop t_pan_canc */

BEGIN  
   EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.t_pan_canc';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Create t_pan_canc */

CREATE TABLE RAX_APP_USER.T_PAN_CANC
AS
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

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* INSERT INTO ODS_OWN.ORDER_HEADER */

INSERT INTO ODS_OWN.ORDER_HEADER (
   ORDER_HEADER_OID, ORDER_NO, ORDER_FORM_ID, 
   MATCHED_CAPTURE_SESSION_ID, EVENT_REF_ID, BATCH_ID, 
   TOTAL_AMOUNT, APO_OID, ORDER_TYPE_OID, 
   ORDER_CHANNEL_OID, PRICE_PROGRAM_OID, EVENT_OID, 
   SHIP_NODE, DRAFT_ORDER_FLAG, HOLD_FLAG, 
   HOLD_REASON_CODE, INVOICE_COMPLETE, IS_SHIP_COMPLETE, 
   ORDER_CLOSED, ORDER_DATE, ORDER_TYPE, 
   PAYMENT_STATUS, TAX, TAX_EXEMPTION_CERTIFICATE, 
   TAX_EXEMPT_FLAG, TAX_JURISDICTION, SHIP_ORDERS_TO, 
   ODS_CREATE_DATE, ODS_MODIFY_DATE, SOURCE_SYSTEM_OID, 
   STAFF_FLAG, CAPTURE_SESSION_QUANTITY, ROOM_QUANTITY, 
   STAFF_QUANTITY, CURRENCY, TERRITORY_CODE, 
   ORDER_SHIP_COMPLETE_IND, PERSON_INFO_OID, CYOP_IND, 
   IMAGE_PREVIEW_ORDER_TYPE, ORDER_SHIP_DATE, ORDER_BUCKET, 
   LAST_USER_MODIFIED_DATE, REQUESTED_DELIVERY_DATE, SCAC, 
   CARRIER_SERVICE_CODE, REQUESTED_SHIP_DATE, SUBJECT_FIRST_NAME, 
   SUBJECT_MIDDLE_NAME, SUBJECT_LAST_NAME, SUBJECT_GRADE, 
   RETAKE_NO, PARENT_RETAKE_NO, DONT_RELEASE_UNTIL_DATE, 
   ORDER_STATUS, BATCHING_REQUIRED, CUSTOMER_EMAILID, 
   ORDER_BATCH_OID, OMS_CREATETS, CUSTOMER_PO_NO, 
   BILL_TO_PERSON_INFO_OID, SHIP_TO_PERSON_INFO_OID, AUTOPACK_CODE, 
DOCUMENT_TYPE,
   ORDER_STATUS_OID) 
(
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
)


&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* INSERT INTO ODS_OWN.ORDER_LINE  */

INSERT INTO ODS_OWN.ORDER_LINE (
   ORDER_LINE_OID, ORDER_HEADER_OID, ITEM_OID, 
   UNIT_PRICE, ORDERED_QUANTITY, LIST_PRICE, 
   RETAIL_PRICE, BUNDLE_PARENT_ORDER_LINE_OID, PACKAGE_REF, 
   SHIPPED_QTY, SORT_SEQ_NO, TAX_INCLUSIVE_IND, 
   EST_TAX_AMOUNT, HOLD_FLAG, LINE_SEQ_NO, 
   ODS_CREATE_DATE, ODS_MODIFY_DATE, SOURCE_SYSTEM_OID, 
   ESTIMATED_ACCOUNT_COMMISSION, KIT_CODE, SI_ADDITIONAL_QTY, 
   SI_SHIP_DATE, GCP_ROOM_NEGS, EST_TAX_RATE, 
   LINE_TOTAL, EST_PRETAX_AMOUNT, EARLIEST_SCHEDULE_DATE) 
(
select
   d2.ORDER_LINE_OID  ORDER_LINE_OID
   , d2.ORDER_HEADER_OID ORDER_HEADER_OID
   , item.ITEM_OID ITEM_OID
   , case when d2.ORDER_BUCKET = 'PAID' then d2.amount else 0 end UNIT_PRICE
   , 1 ORDERED_QUANTITY
   , case when d2.ORDER_BUCKET = 'PAID' then d2.amount else 0 end LIST_PRICE
   , case when d2.ORDER_BUCKET = 'PAID' then d2.amount else 0 end RETAIL_PRICE
   , null BUNDLE_PARENT_ORDER_LINE_OID
   , null PACKAGE_REF
   , 1 SHIPPED_QTY
   , 1 SORT_SEQ_NO
   , null TAX_INCLUSIVE_IND
   , null EST_TAX_AMOUNT
   , null HOLD_FLAG
   , '1.1' LINE_SEQ_NO
   , sysdate ODS_CREATE_DATE
   , sysdate ODS_MODIFY_DATE
   , myss.SOURCE_SYSTEM_OID SOURCE_SYSTEM_OID
   , null ESTIMATED_ACCOUNT_COMMISSION
   , null KIT_CODE
   , null SI_ADDITIONAL_QTY
   , null SI_SHIP_DATE
   , null GCP_ROOM_NEGS
   , null EST_TAX_RATE
   , case when d2.ORDER_BUCKET = 'PAID' then d2.amount else 0 end LINE_TOTAL
   , null EST_PRETAX_AMOUNT
   , null EARLIEST_SCHEDULE_DATE
---- select *
from
RAX_APP_USER.T_PAN_D2 d2
, ODS_OWN.ITEM item
, ODS_OWN.SOURCE_SYSTEM myss
where (1=1)
and item.item_oid=d2.item_oid
and myss.SOURCE_SYSTEM_SHORT_NAME='ODS'
)


&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* INSERT INTO ODS_OWN.SHIPMENT */

INSERT INTO ODS_OWN.SHIPMENT (
   SHIPMENT_OID, PERSON_INFO_OID, SHIPMENT_NO, 
   SHIP_DATE, SORT_TYPE, ROOM_BOARD_URL, 
   ROOM_BOARD_ITEM_ID, SHIP_NODE, TRACKING_NO, 
   STATUS, ACTUAL_SHIPMENT_DATE, ACTUAL_DELIVERY_DATE, 
   ODS_CREATE_DATE, ODS_MODIFY_DATE, SOURCE_SYSTEM_OID, 
   SHIP_VIA, TOTAL_ACTUAL_CHARGE, ACTUAL_FREIGHT_CHARGE) 
(
select
   d2.SHIPMENT_OID SHIPMENT_OID
   , null PERSON_INFO_OID
   , d2.SHIPMENT_OID SHIPMENT_NO
   , d2.ORDER_SHIP_DATE SHIP_DATE
   , null SORT_TYPE
   , null ROOM_BOARD_URL
   , null ROOM_BOARD_ITEM_ID
   , null SHIP_NODE
   , null TRACKING_NO
   , null STATUS
   , d2.ORDER_SHIP_DATE ACTUAL_SHIPMENT_DATE
   , d2.ORDER_SHIP_DATE ACTUAL_DELIVERY_DATE
   , sysdate ODS_CREATE_DATE
   , sysdate ODS_MODIFY_DATE
   , myss.SOURCE_SYSTEM_OID SOURCE_SYSTEM_OID
   , null SHIP_VIA
   , null TOTAL_ACTUAL_CHARGE
   , null ACTUAL_FREIGHT_CHARGE
---- select *
from

( select SHIPMENT_OID, ORDER_SHIP_DATE from RAX_APP_USER.T_PAN_D2 group by SHIPMENT_OID, ORDER_SHIP_DATE) d2
, ODS_OWN.SOURCE_SYSTEM myss
where (1=1)
and myss.SOURCE_SYSTEM_SHORT_NAME='ODS'
)


&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* INSERT INTO ODS_OWN.SHIPMENT_LINE */

INSERT INTO ODS_OWN.SHIPMENT_LINE (
   SHIPMENT_LINE_OID, SHIPMENT_OID, ORDER_LINE_OID, 
   SHIPPED_QUANTITY, RELEASE_NO, SHIPMENT_LINE_NO, 
   SHIPMENT_SUB_LINE_NO, UOM, SHIP_ADVICE_NO, 
   ODS_CREATE_DATE, ODS_MODIFY_DATE, SOURCE_SYSTEM_OID, 
   ROOM_QTY, CAPTURE_SESSION_QTY) 
(
select
   d2.SHIPMENT_LINE_OID SHIPMENT_LINE_OID
   , d2.SHIPMENT_OID SHIPMENT_OID
   , d2.ORDER_LINE_OID ORDER_LINE_OID
   , 1 SHIPPED_QUANTITY
   , 1 RELEASE_NO
   , 1 SHIPMENT_LINE_NO
   , 0 SHIPMENT_SUB_LINE_NO
   , 'EACH' UOM
   , null SHIP_ADVICE_NO
   , sysdate ODS_CREATE_DATE
   , sysdate ODS_MODIFY_DATE
   , myss.SOURCE_SYSTEM_OID SOURCE_SYSTEM_OID
   , null ROOM_QTY
   , null CAPTURE_SESSION_QTY
---- select *
from
RAX_APP_USER.T_PAN_D2 d2
, ODS_OWN.SOURCE_SYSTEM myss
where (1=1)
and myss.SOURCE_SYSTEM_SHORT_NAME='ODS'
)


&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* CANCEL ORDER_HEADER */

MERGE INTO ODS_OWN.ORDER_HEADER d
USING (
  Select
        canc.ORDER_HEADER_OID
  From 
    RAX_APP_USER.T_PAN_CANC canc
  ) s
ON
  (d.ORDER_HEADER_OID = s.ORDER_HEADER_OID)
WHEN MATCHED
THEN
UPDATE SET
  d.ORDER_BUCKET = 'CANCELLED'
  ,d.TOTAL_AMOUNT = 0
  ,d.ODS_MODIFY_DATE = sysdate


&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* CANCEL ORDER_LINE */

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

&


/*-----------------------------------------------*/
