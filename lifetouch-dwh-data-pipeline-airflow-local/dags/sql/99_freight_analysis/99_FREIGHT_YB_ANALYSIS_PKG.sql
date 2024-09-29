/* TASK No. 1 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 2 */




/*-----------------------------------------------*/
/* TASK No. 3 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 3 */




/*-----------------------------------------------*/
/* TASK No. 4 */
/* Truncate Driver Table */

truncate table rax_app_user.freight_driver_yb

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Insert Shipments */

INSERT INTO freight_driver_yb
    SELECT DISTINCT s.shipment_oid
      FROM ods_own.sub_program    sp,
           ods_own.apo            a,
           ods_own.event          e,
           ods_Own.order_header   oh,
           ods_own.order_line     ol,
           ods_own.shipment_line  sl,
           ods_own.shipment       s
     WHERE     a.SUB_PROGRAM_OID = sp.SUB_PROGRAM_OID
           AND a.APO_OID = e.APO_OID
           AND e.EVENT_OID = oh.EVENT_OID
           AND oh.ORDER_HEADER_OID = ol.ORDER_HEADER_OID
           AND ol.ORDER_LINE_OID = sl.ORDER_LINE_OID
           AND sl.SHIPMENT_OID = s.SHIPMENT_OID
           AND sp.SUB_PROGRAM_NAME = 'Yearbook'
           AND s.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Insert Shipment Lines */

INSERT INTO freight_driver_yb dr
    SELECT DISTINCT s.shipment_oid
      FROM ods_own.sub_program    sp,
           ods_own.apo            a,
           ods_own.event          e,
           ods_Own.order_header   oh,
           ods_own.order_line     ol,
           ods_own.shipment_line  sl,
           ods_own.shipment       s
     WHERE     a.SUB_PROGRAM_OID = sp.SUB_PROGRAM_OID
           AND a.APO_OID = e.APO_OID
           AND e.EVENT_OID = oh.EVENT_OID
           AND oh.ORDER_HEADER_OID = ol.ORDER_HEADER_OID
           AND ol.ORDER_LINE_OID = sl.ORDER_LINE_OID
           AND sl.SHIPMENT_OID = s.SHIPMENT_OID
           AND sp.SUB_PROGRAM_NAME = 'Yearbook'
           AND sl.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap
and not exists (select 1 from rax_app_user.freight_driver_yb t where t.shipment_oid = sl.shipment_oid)

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Insert Shipment Containers */

INSERT INTO freight_driver_yb dr
    SELECT DISTINCT sc.shipment_oid
      FROM ods_own.sub_program    sp,
           ods_own.apo            a,
           ods_own.event          e,
           ods_Own.order_header   oh,
           ods_own.order_line     ol,
           ods_own.shipment_line  sl,
           ods_own.shipment       s,
           ods_own.shipment_container sc
     WHERE     a.SUB_PROGRAM_OID = sp.SUB_PROGRAM_OID
           AND a.APO_OID = e.APO_OID
           AND e.EVENT_OID = oh.EVENT_OID
           AND oh.ORDER_HEADER_OID = ol.ORDER_HEADER_OID
           AND ol.ORDER_LINE_OID = sl.ORDER_LINE_OID
           AND sl.SHIPMENT_OID = s.SHIPMENT_OID
           AND s.shipment_oid = sc.shipment_oid
           AND sp.SUB_PROGRAM_NAME = 'Yearbook'
           AND sc.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap
and not exists (select 1 from rax_app_user.freight_driver_yb t where t.shipment_oid = sc.shipment_oid)

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Merge into Freight_Shipment_Detail */

MERGE INTO freight_shipment_detail t
     USING (SELECT oms.SHIPMENT_OID,
                   oms.EVENT_REF_ID,
                   oms.SHIPMENT_NO,
                   bb.SHIP_NODE,
                   oms.SHIP_DATE,
                   oms.SHIP_VIA,
                   oms.CARRIER_SERVICE_CODE,
                   oms.CARRIER,
                   oms.ACTUAL_FREIGHT_CHARGE,
                   oms.cancelled
              FROM (  SELECT s.SHIPMENT_OID,
                             e.EVENT_REF_ID,
                             s.SHIPMENT_NO,
                             s.SHIP_DATE,
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
                             freight_driver_yb    dr
                       WHERE     1 = 1
                             AND a.APO_OID = e.APO_OID
                             AND e.event_OID = oh.event_OID
                             AND oh.ORDER_HEADER_OID = ol.ORDER_HEADER_OID
                             AND ol.ORDER_LINE_OID = sl.ORDER_LINE_OID
                             AND sl.SHIPMENT_OID = s.SHIPMENT_OID
                             AND s.SHIPMENT_OID = dr.SHIPMENT_OID
                    GROUP BY s.SHIPMENT_OID,
                             e.EVENT_REF_ID,
                             s.SHIPMENT_NO,
                             s.SHIP_DATE,
                             s.SHIP_NODE,
                             s.SHIP_VIA,
                             s.CARRIER_SERVICE_CODE,
                             TRIM (s.scac),
                             TRIM(s.status)) oms,
                   (  SELECT REGEXP_SUBSTR (bb.clientorderno, '[^_]+')
                                 AS BB_event_ref_id,
                             MAX (bb.FACILITYNAME)
                                 AS ship_node
                        FROM ODS_STAGE.BB_ORDER_STG bb
                       WHERE 1 = 1 AND bb.STATUSNAME = 'MANIFESTED'
                    GROUP BY REGEXP_SUBSTR (bb.clientorderno, '[^_]+')) bb
             WHERE oms.EVENT_REF_ID = bb.BB_EVENT_REF_ID) s
        ON (t.shipment_oid = s.shipment_oid)
WHEN NOT MATCHED
THEN
    INSERT     (shipment_oid,
                shipment_no,
                ship_date,
                Ship_node,
                ship_via,
                CARRIER_SERVICE_CODE,
                carrier,
                actual_freight_charge,
                cancelled,
                ods_create_date,
                ods_modify_date)
        VALUES (s.shipment_oid,
                s.shipment_no,
                s.ship_date,
                s.Ship_node,
                s.ship_via,
                s.CARRIER_SERVICE_CODE,
                s.carrier,
                s.actual_freight_charge,
                s.cancelled,
                SYSDATE,
                SYSDATE)
WHEN MATCHED
THEN
    UPDATE SET
        t.shipment_no = s.shipment_no,
        t.ship_date = s.ship_date,
        t.ship_node = s.ship_node,
        t.ship_via = s.ship_via,
        t.carrier = s.carrier,
        t.carrier_service_code = s.carrier_service_code,
        t.actual_freight_charge = s.actual_freight_charge,
        t.cancelled = s.cancelled,
        t.ods_modify_date = SYSDATE
             WHERE    DECODE (s.shipment_no, t.shipment_no, 1, 0) = 0
                   OR DECODE (s.ship_date, t.ship_date, 1, 0) = 0
                   OR DECODE (s.ship_node, t.ship_node, 1, 0) = 0
                   OR DECODE (s.ship_via, t.ship_via, 1, 0) = 0
                   OR DECODE (s.carrier, t.carrier, 1, 0) = 0
                   OR DECODE (s.carrier_service_code,
                              t.carrier_service_code, 1,
                              0) =
                      0
                   OR DECODE (s.actual_freight_charge,
                              t.actual_freight_charge, 1,
                              0) =
                      0
                   OR DECODE (s.cancelled, t.cancelled, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Merge # Containers */

MERGE INTO RAX_APP_USER.freight_shipment_detail d
     USING (  SELECT s.SHIPMENT_OID, COUNT (*) AS number_of_containers
                FROM ODS_OWN.SHIPMENT          s,
                     ODS_OWN.SHIPMENT_CONTAINER sc,
                     freight_driver_yb            dr
               WHERE     s.SHIPMENT_OID = sc.SHIPMENT_OID
                     AND s.shipment_oid = dr.SHIPMENT_OID
            GROUP BY s.shipment_oid) s
        ON (d.shipment_oid = s.shipment_oid)
WHEN MATCHED
THEN
    UPDATE SET
        d.number_of_containers = s.number_of_containers,
        d.ods_modify_date = SYSDATE
             WHERE DECODE (s.number_of_containers,
                           d.number_of_containers, 1,
                           0) =
                   0

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Merge Event_Ref_ID */

MERGE INTO RAX_APP_USER.freight_shipment_detail d
     USING (  SELECT MAX (e.EVENT_REF_ID) AS event_ref_id, sl.shipment_oid
                FROM ods_own.apo                a,
                     ODS_OWN.SUB_PROGRAM        sp,
                     ods_own.account            acct,
                     ods_own.event              e,
                     ODS_OWN.ORDER_HEADER       oh,
                     ODS_OWN.ORDER_LINE         ol,
                     ODS_OWN.SHIPMENT_LINE      sl,
                     rax_app_user.freight_driver_yb dr,
                     freight_shipment_detail dtl
               WHERE     a.SUB_PROGRAM_OID = sp.SUB_PROGRAM_OID
                     AND a.ACCOUNT_OID = acct.ACCOUNT_OID
                     AND a.APO_OID = e.APO_OID
                     AND e.EVENT_OID = oh.EVENT_OID
                     AND oh.ORDER_HEADER_OID = ol.ORDER_HEADER_OID
                     AND ol.ORDER_LINE_OID = sl.ORDER_LINE_OID
                     AND sl.SHIPMENT_OID = dr.SHIPMENT_OID
                     and dr.SHIPMENT_OID = dtl.SHIPMENT_OID
                     AND dtl.event_ref_id is null
                     and dtl.apo_id is null
            GROUP BY sl.shipment_oid) s
        ON (d.shipment_oid = s.shipment_oid)
WHEN MATCHED
THEN
    UPDATE SET d.event_ref_id = s.event_ref_id, d.ods_modify_date = SYSDATE
             WHERE DECODE (s.event_ref_id, d.event_ref_id, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Merge Event Level Attributes */

MERGE INTO RAX_APP_USER.freight_shipment_detail d
     USING (SELECT DISTINCT e.Event_ref_id,
                   a.SCHOOL_YEAR,
                   sp.SUB_PROGRAM_NAME,
                   e.PHOTOGRAPHY_DATE,
                   acct.ACCOUNT_NAME,
                   a.APO_ID
              FROM ods_own.apo          a,
                   ods_own.event        e,
                   ODS_OWN.SUB_PROGRAM  sp,
                   ods_own.account      acct,
                   freight_driver_yb dr,
                   freight_shipment_detail dtl
             WHERE     a.APO_OID = e.APO_OID
                   AND a.SUB_PROGRAM_OID = sp.SUB_PROGRAM_OID
                   AND a.ACCOUNT_OID = acct.ACCOUNT_OID
                   AND dtl.event_ref_id = e.event_ref_id
                   AND dtl.shipment_oid = dr.shipment_oid
                   AND dtl.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap
                 ) s
        ON (d.event_ref_id = s.event_ref_id)
WHEN MATCHED
THEN
    UPDATE SET
        d.school_year = s.school_year,
        d.sub_program_name = s.sub_program_name,
        d.apo_id = s.apo_id,
        d.photography_date = s.photography_date,
        d.account_name = s.account_name,
        d.ods_modify_date = SYSDATE
             WHERE    DECODE (s.school_year, d.school_year, 1, 0) = 0
                   OR DECODE (s.sub_program_name, d.sub_program_name, 1, 0) =
                      0
                   OR DECODE (s.apo_id, d.apo_id, 1, 0) = 0
                   OR DECODE (s.photography_date, d.photography_date, 1, 0) =
                      0
                   OR DECODE (s.account_name, d.account_name, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Zero out Non YB Orders on School Shipment */

   MERGE INTO freight_shipment_detail d
     USING (SELECT DISTINCT dr.SHIPMENT_OID
              FROM freight_driver_yb      dr,
                   ODS_OWN.SHIPMENT_LINE  sl,
                   ODS_OWN.ORDER_LINE     ol,
                   ODS_OWN.ORDER_HEADER   oh,
                   freight_shipment_detail dtl
             WHERE     dr.SHIPMENT_OID = sl.SHIPMENT_OID
                   AND sl.ORDER_LINE_OID = ol.ORDER_LINE_OID
                   AND ol.ORDER_HEADER_OID = oh.ORDER_HEADER_OID
                   and dr.SHIPMENT_OID = dtl.SHIPMENT_OID
                   and dtl.SUB_PROGRAM_NAME = 'Yearbook'
                   AND oh.ORDER_TYPE IN
                           ('YBExtraBkSpec_Order',
                            'YBCompliment_Order',
                            'YBIncentive_Order')) s
        ON (d.shipment_oid = s.shipment_oid)
WHEN MATCHED
THEN
    UPDATE SET d.actual_freight_charge = 0
    where d.sub_program_name = 'Yearbook'

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Merge Track_Exists */

MERGE INTO RAX_APP_USER.freight_shipment_detail t
     USING (SELECT shipment_oid,
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
                             freight_driver_yb         dr
                       WHERE     dr.SHIPMENT_OID = s.SHIPMENT_OID
                             AND s.SHIPMENT_OID = sc.SHIPMENT_OID(+)
                    GROUP BY dr.SHIPMENT_OID)) s
        ON (t.shipment_oid = s.shipment_oid)
WHEN MATCHED
THEN
    UPDATE SET t.track_exists = s.track_exists, t.ods_modify_date = SYSDATE
             WHERE DECODE (s.track_exists, t.track_exists, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Modify Carrier */

MERGE INTO RAX_APP_USER.freight_shipment_detail t
     USING (SELECT f.SHIPMENT_OID,
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
                   freight_driver_yb                     dr
             WHERE     f.SHIPMENT_OID = dr.SHIPMENT_OID
                   AND ship_node NOT IN ('Central Lab', 'VirtualNode')) s
        ON (t.shipment_oid = s.shipment_oid)
WHEN MATCHED
THEN
    UPDATE SET t.carrier = s.carrier, t.ods_modify_date = SYSDATE
             WHERE DECODE (s.carrier, t.carrier, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Set Purolator carrier based on Tracking_No */

 MERGE INTO rax_app_user.freight_shipment_detail t
     USING (SELECT distinct f.SHIPMENT_OID,
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
              FROM freight_driver_yb           dr,
                   RAX_APP_USER.freight_shipment_detail  f,
                   ODS_OWN.SHIPMENT            s,
                   ODS_OWN.SHIPMENT_CONTAINER  sc
             WHERE     dr.SHIPMENT_OID = f.SHIPMENT_OID
                   AND dr.SHIPMENT_OID = s.SHIPMENT_OID
                   AND s.SHIPMENT_OID = sc.SHIPMENT_OID(+)
                   AND s.ship_node NOT IN ('Central Lab', 'VirtualNode')) s
        ON (t.shipment_oid = s.shipment_oid)
WHEN MATCHED
THEN
    UPDATE SET t.carrier = s.carrier, t.ods_modify_date = sysdate
    WHERE DECODE (s.carrier, t.carrier, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Merge into Freight_Order_Detail */

MERGE INTO freight_order_detail t
     USING (SELECT * FROM (  SELECT sl.SHIPMENT_OID,
                     oh.ORDER_BUCKET,
                     oh.SHIP_ORDERS_TO,
                     i.DESCRIPTION                 AS item_description,
                     SUM (ol.ORDERED_QUANTITY)     AS ordered_quantity,
                     SUM (sl.SHIPPED_QUANTITY)     AS shipped_quantity
                FROM ODS_OWN.SHIPMENT_LINE sl,
                     ODS_OWN.ORDER_LINE   ol,
                     ODS_OWN.ORDER_HEADER oh,
                     ODS_OWN.ITEM         i,
                     freight_driver_yb       dr
               WHERE     sl.SHIPMENT_OID = dr.SHIPMENT_OID
                     AND sl.ORDER_LINE_OID = ol.ORDER_LINE_OID
                     AND ol.ORDER_HEADER_OID = oh.ORDER_HEADER_OID
                     AND ol.ITEM_OID = i.ITEM_OID
            GROUP BY sl.SHIPMENT_OID,
                     oh.ORDER_BUCKET,
                     oh.SHIP_ORDERS_TO,
                     i.DESCRIPTION)) s
        ON (    t.shipment_oid = s.shipment_oid
            AND t.order_bucket = s.order_bucket
            AND t.ship_orders_to = s.ship_orders_to
            AND t.item_description = s.item_description)
WHEN MATCHED
THEN
    UPDATE SET
        t.ordered_quantity = s.ordered_quantity,
        t.shipped_quantity = s.shipped_quantity,
        t.ods_modify_date = SYSDATE
             WHERE    DECODE (s.ordered_quantity, t.ordered_quantity, 1, 0) =
                      0
                   OR DECODE (s.shipped_quantity, t.shipped_quantity, 1, 0) =
                      0
WHEN NOT MATCHED
THEN
    INSERT     (shipment_oid,
                order_bucket,
                ship_orders_to,
                item_description,
                ordered_quantity,
                shipped_quantity,
                ods_create_date,
                ods_modify_date)
        VALUES (s.shipment_oid,
                s.order_bucket,
                s.ship_orders_to,
                s.item_description,
                s.ordered_quantity,
                s.shipped_quantity,
                SYSDATE,
                SYSDATE)

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Set Purolator carrier based on Tracking_No */

 MERGE INTO rax_app_user.freight_shipment_detail t
     USING (SELECT distinct f.SHIPMENT_OID,
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
              FROM freight_driver_yb           dr,
                   RAX_APP_USER.freight_shipment_detail  f,
                   ODS_OWN.SHIPMENT            s,
                   ODS_OWN.SHIPMENT_CONTAINER  sc
             WHERE     dr.SHIPMENT_OID = f.SHIPMENT_OID
                   AND dr.SHIPMENT_OID = s.SHIPMENT_OID
                   AND s.SHIPMENT_OID = sc.SHIPMENT_OID(+)
                   AND s.ship_node NOT IN ('Central Lab', 'VirtualNode')) s
        ON (t.shipment_oid = s.shipment_oid)
WHEN MATCHED
THEN
    UPDATE SET t.carrier = s.carrier, t.ods_modify_date = sysdate
    WHERE DECODE (s.carrier, t.carrier, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
+ nvl((TIMEZONE_OFFSET/24), 0) 
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

/*
UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Insert CDC Audit Record */

INSERT INTO RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
(TABLE_NAME,
SESS_NO,                      
SESS_NAME,                    
SCEN_VERSION,                 
SESS_BEG,                     
ORIG_LAST_CDC_COMPLETION_DATE,
OVERLAP,
CREATE_DATE,
CONTEXT_NAME,
TIMEZONE_OFFSET              
)
select 
:v_cdc_load_table_name
,:v_sess_no
,'99_FREIGHT_YB_ANALYSIS_PKG'
,'010'
,TO_DATE(SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
,TO_DATE (SUBSTR(:v_cdc_load_date, 1, 19),'YYYY-MM-DD HH24:MI:SS')
,:v_cdc_overlap
,SYSDATE
,:v_env
,TIMEZONE_OFFSET
from 
ODS_OWN.ODS_CDC_LOAD_STATUS
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

/*
INSERT INTO RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
(TABLE_NAME,
SESS_NO,                      
SESS_NAME,                    
SCEN_VERSION,                 
SESS_BEG,                     
ORIG_LAST_CDC_COMPLETION_DATE,
OVERLAP,
CREATE_DATE,
CONTEXT_NAME              
)
values (
:v_cdc_load_table_name,
:v_sess_no,
'99_FREIGHT_YB_ANALYSIS_PKG',
'010',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/


&


/*-----------------------------------------------*/
