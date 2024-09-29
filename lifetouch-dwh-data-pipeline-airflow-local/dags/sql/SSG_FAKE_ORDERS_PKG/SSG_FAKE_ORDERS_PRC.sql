/* TASK No. 1 */
/* drop table ODS_APP_USER.T_SSG_D  */

-- drop table RAX_APP_USER.T_SSG_D 
BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.T_SSG_D';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 2 */
/* create table ODS_APP_USER.T_SSG_D  */

create table RAX_APP_USER.T_SSG_D as
select
    E.EVENT_REF_ID
    ,min(gec.paid_order_qty) - sum(case when oh.order_bucket = 'PAID' then 1 else 0 end) NEEDED_PAID_QTY
    ,min(gec.unpaid_order_qty) - sum(case when oh.order_bucket = 'UNPAID' then 1 else 0 end) NEEDED_UNPAID_QTY
    ,sum(case when oh.order_bucket = 'PAID' then 1 else 0 end) oh_paid_qty
    ,sum(case when oh.order_bucket = 'UNPAID' then 1 else 0 end) oh_unpaid_qty
    ,min(gec.paid_order_qty) paid_order_qty
    ,min(gec.unpaid_order_qty) unpaid_order_qty
    ,0 as shipment_oid
from
    ODS_OWN.ORDER_HEADER oh
    ,ODS_OWN.ORDER_LINE ol
    ,ODS_OWN.SOURCE_SYSTEM ass
    ,ODS_OWN.SOURCE_SYSTEM ess
    ,ODS_OWN.EVENT e
    ,ODS_OWN.APO apo
    ,ODS_OWN.SUB_PROGRAM sp
    ,ods.gdt_event_curr gec
where (1=1)
and nvl(gec.ship_date,to_date('01011900','MMDDYYYY')) <> to_date('01011900','MMDDYYYY')
--and E.EVENT_REF_ID in ('BG015727G0','GE505270G0','OX305123G0')
and E.EVENT_OID=OH.EVENT_OID(+)
and APO.APO_OID=E.APO_OID(+)
and e.event_ref_id = gec.job_nbr
and APO.SUB_PROGRAM_OID=SP.SUB_PROGRAM_OID
and sp.sub_program_name = 'Classroom Groups'
and OH.ORDER_HEADER_OID=OL.ORDER_HEADER_OID(+)
and APO.SOURCE_SYSTEM_OID=ASS.SOURCE_SYSTEM_OID
and E.SOURCE_SYSTEM_OID=ESS.SOURCE_SYSTEM_OID
and ASS.SOURCE_SYSTEM_SHORT_NAME='APOCS'
and ESS.SOURCE_SYSTEM_SHORT_NAME='FOW'
and OH.ORDER_TYPE(+)='Bulk_Order'
and APO.SCHOOL_YEAR >= 2016
and OH.ORDER_BUCKET(+) in ('PAID','UNPAID')
group by
    E.EVENT_REF_ID
having
    (
    min(gec.paid_order_qty) - sum(case when oh.order_bucket = 'PAID' then 1 else 0 end) > 0
    or min(gec.unpaid_order_qty) - sum(case when oh.order_bucket = 'UNPAID' then 1 else 0 end) > 0)

&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* set shipment_oid  */

update RAX_APP_USER.T_SSG_D set shipment_oid = ods_stage.shipment_oid_seq.nextval

&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* drop table ODS_APP_USER.T_SSG_D2 */

-- drop table RAX_APP_USER.T_SSG_D2
BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.T_SSG_D2';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* create table ODS_APP_USER.T_SSG_D2 */

create table RAX_APP_USER.T_SSG_D2 as
select
ods_stage.order_header_oid_seq.nextval ORDER_HEADER_OID
,ods_stage.order_line_oid_seq.nextval ORDER_LINE_OID
,ods_stage.shipment_line_oid_seq.nextval SHIPMENT_LINE_OID,
-- select
pu.SHIPMENT_OID SHIPMENT_OID
,pu.ORDER_NO ORDER_NO
, e.event_ref_id EVENT_REF_ID
, case when pss.amount = 0 then 0.01 else pss.amount end AMOUNT -- charge a penny if the offering is wrong
, apo.apo_oid APO_OID
, apo.PRICE_PROGRAM_OID PRICE_PROGRAM_OID
, e.EVENT_OID EVENT_OID
, apo.TERRITORY_CODE TERRITORY_CODE
, gec.ship_date ORDER_SHIP_DATE
, pu.ORDER_BUCKET ORDER_BUCKET
, i.item_id
---- select *
from
ODS_OWN.EVENT e
,ODS_OWN.APO apo
, ods_own.price_program pp
, ods_own.pp_price_set ppps
, ods_own.price_set ps
, ods_own.price_set_sku pss
, ods_own.stock_keeping_unit sku
, ods_own.item i
, ods.gdt_event_curr gec
, ods.gdt_offering_detail_curr godc
,    (select 
        d.event_ref_id
        ,'PAID' ORDER_BUCKET
        ,d.event_ref_id || ':P:' || TO_CHAR(SYSTIMESTAMP, 'DDMMYYYYHH24MISS') || ':' || var.id_p ORDER_NO
        ,d.shipment_oid
    from 
        RAX_APP_USER.T_SSG_D d
        ,(select rownum id_p from all_objects where rownum <= 10000) var
    where (1=1)
    group by
        d.event_ref_id
        ,'PAID' 
        ,d.event_ref_id || ':P:' || TO_CHAR(SYSTIMESTAMP, 'DDMMYYYYHH24MISS') || ':' || var.id_p
        ,d.shipment_oid
        ,var.id_p
        ,d.needed_paid_qty
    having 
        id_p <= d.needed_paid_qty
    UNION
    select 
        d.event_ref_id
        ,'UNPAID' ORDER_BUCKET
        ,d.event_ref_id || ':U:' || TO_CHAR(SYSTIMESTAMP, 'DDMMYYYYHH24MISS') || ':' || var.id_p ORDER_NO
        ,d.shipment_oid
    from 
        RAX_APP_USER.T_SSG_D d
        ,(select rownum id_p from all_objects where rownum <= 10000) var
    where (1=1)
    group by
        d.event_ref_id
        ,'UNPAID' 
        ,d.event_ref_id || ':U:' || TO_CHAR(SYSTIMESTAMP, 'DDMMYYYYHH24MISS') || ':' || var.id_p
        ,d.shipment_oid
        ,var.id_p
        ,d.needed_unpaid_qty
    having 
        id_p <= d.needed_unpaid_qty
    ) pu
where (1=1)
--and ((pu.ORDER_BUCKET = 'PAID' and pss.amount > 0) or (pu.ORDER_BUCKET = 'UNPAID')) 
and e.event_ref_id = pu.event_ref_id
and E.APO_OID=APO.APO_OID
and GEC.JOB_NBR=E.EVENT_REF_ID
and GEC.JOB_NBR=GODC.JOB_NBR
and GODC.PACKAGE_NAME = PSS.PRODUCT_CODE
and apo.price_program_oid = pp.price_program_oid(+) 
and pp.price_program_oid = ppps.price_program_oid(+)
and ppps.price_set_oid = ps.price_set_oid(+)
and ps.price_set_oid = pss.price_set_oid(+)
and pss.stock_keeping_unit_oid = sku.stock_keeping_unit_oid(+)
and sku.sku_code = i.item_id(+)
and pss.CHANNEL(+) like '%PAPER%'
and nvl(gec.ship_date,to_date('01011900','MMDDYYYY')) <> to_date('01011900','MMDDYYYY')



&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* drop table ODS_APP_USER.T_SSG_CANC */

-- drop table RAX_APP_USER.T_SSG_CANC
BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.T_SSG_CANC';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* create table ODS_APP_USER.T_SSG_CANC */

create table RAX_APP_USER.T_SSG_CANC as
select ol.ORDER_HEADER_OID,ol.ORDER_LINE_OID from (
    select * from ( 
        select 
            OH.EVENT_REF_ID
            ,OH.ORDER_HEADER_OID
            ,pu.ORDER_BUCKET
            ,pu.CANCELLED_QTY CANCELLED_QTY
            ,rank() over (partition by OH.EVENT_REF_ID,pu.ORDER_BUCKET order by OH.ORDER_HEADER_OID) rank
        -- select *
        from
            ODS_OWN.ORDER_HEADER OH
        ,    (select 
                d.event_ref_id
                ,'PAID' ORDER_BUCKET
                ,(-1 * d.NEEDED_PAID_QTY) CANCELLED_QTY 
            -- select *
            from 
                RAX_APP_USER.T_SSG_D d
                ,(select rownum id_p from all_objects where rownum <= 10000) var
            where (1=1)
            group by
                d.event_ref_id
                ,'PAID' 
                ,(-1 * d.NEEDED_PAID_QTY)  
                ,var.id_p
                ,d.needed_paid_qty
            having 
                id_p <= (-1 * d.needed_paid_qty)
            UNION
            select 
                d.event_ref_id
                ,'UNPAID' ORDER_BUCKET
                ,(-1 * d.NEEDED_UNPAID_QTY) CANCELLED_QTY 
            from 
                RAX_APP_USER.T_SSG_D d
                ,(select rownum id_p from all_objects where rownum <= 10000) var
            where (1=1)
            group by
                d.event_ref_id
                ,'UNPAID' 
                ,(-1 * d.NEEDED_UNPAID_QTY)  
                ,var.id_p
                ,d.needed_unpaid_qty
            having 
                id_p <= (-1 * d.needed_unpaid_qty)
            ) pu

        where (1=1)
        and pu.EVENT_REF_ID=OH.EVENT_REF_ID
        and pu.ORDER_BUCKET=OH.ORDER_BUCKET
        ) a
    where (1=1)
        and A.RANK <= A.CANCELLED_QTY
    ) b
    ,ODS_OWN.ORDER_LINE OL
where (1=1)
    and B.ORDER_HEADER_OID = OL.ORDER_HEADER_OID


&


/*-----------------------------------------------*/
/* TASK No. 8 */
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
RAX_APP_USER.T_SSG_D2 d2
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
/* TASK No. 9 */
/* INSERT INTO ODS_OWN.ORDER_LINE */

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
RAX_APP_USER.T_SSG_D2 d2
, ODS_OWN.ITEM item
, ODS_OWN.SOURCE_SYSTEM myss
where (1=1)
and item.item_id=d2.item_id
and myss.SOURCE_SYSTEM_SHORT_NAME='ODS'
)


&


/*-----------------------------------------------*/
/* TASK No. 10 */
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

( select SHIPMENT_OID, ORDER_SHIP_DATE from RAX_APP_USER.T_SSG_D2 group by SHIPMENT_OID, ORDER_SHIP_DATE) d2
, ODS_OWN.SOURCE_SYSTEM myss
where (1=1)
and myss.SOURCE_SYSTEM_SHORT_NAME='ODS'
)


&


/*-----------------------------------------------*/
/* TASK No. 11 */
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
RAX_APP_USER.T_SSG_D2 d2
, ODS_OWN.SOURCE_SYSTEM myss
where (1=1)
and myss.SOURCE_SYSTEM_SHORT_NAME='ODS'
)


&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Cancel ORDER_HEADER */

MERGE INTO ODS_OWN.ORDER_HEADER d
USING (
  Select
        canc.ORDER_HEADER_OID
  From 
    RAX_APP_USER.T_SSG_CANC canc
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
/* TASK No. 13 */
/* Cancel ORDER_LINE */

MERGE INTO ODS_OWN.ORDER_LINE d
USING (
  Select
        canc.ORDER_LINE_OID
  From 
    RAX_APP_USER.T_SSG_CANC canc
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
