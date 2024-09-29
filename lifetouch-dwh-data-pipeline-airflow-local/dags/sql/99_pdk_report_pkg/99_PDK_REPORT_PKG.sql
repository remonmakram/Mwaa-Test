/* TASK No. 1 */
/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 1 */
/*-----------------------------------------------*/
/* TASK No. 2 */
/* drop table stage1 */

/* drop table RAX_APP_USER.pdk_report_stage1 */

BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.pdk_report_stage1';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 3 */
/* CREATE  table pdk_report_stage1 */



CREATE TABLE RAX_APP_USER.pdk_report_stage1 as

  SELECT e.pdk_number,
         e.event_ref_id,
         (CASE WHEN i.sub_class = 'Fold' THEN ' ' ELSE i.manufacturer_item END)
            AS part_number,
         MAX (i.sub_class) sub_class            --,max(i.item_id) orig_item_id
                                    ,
         MAX (a.account_alias) account_alias,
         a.lifetouch_id,
         MAX (
            (CASE
                WHEN e.photography_date = TO_DATE ('19000101', 'yyyymmdd')
                THEN
                   NULL
                ELSE
                   TO_CHAR (e.photography_date, 'MM/DD/YYYY')
             END))
            AS pictdate,
         MAX (
            (CASE
                WHEN e.plant_receipt_date = TO_DATE ('19000101', 'yyyymmdd')
                THEN
                   NULL
                ELSE
                   TO_CHAR (e.plant_receipt_date, 'MM/DD/YYYY')
             END))
            AS received,
         MAX (TO_CHAR (ol.earliest_schedule_date, 'MM/DD/YYYY hh:mi:ss PM')) AS sent_date ,
         MAX (TO_CHAR (oh.last_user_modified_date, 'MM/DD/YYYY')) AS firstappr,
         MAX (TO_CHAR (oh.last_user_modified_date, 'MM/DD/YYYY')) AS curappr,
         MAX (TO_CHAR (oh.requested_ship_date, 'MM/DD/YYYY')) AS ship_by,
         MAX (
            CASE
               WHEN s.status = '1400'
               THEN
                  TO_CHAR (s.actual_shipment_date, 'MM/DD/YYYY')
               ELSE
                  NULL
            END)
            AS shipdate,
         MAX (' ') AS reprint,
         A.ENROLLMENT AS enroll,
         SUM (ol.ordered_quantity) AS qtyorder,
         SUM (sl.shipped_quantity) AS qtyship,
         s.tracking_no,
         s.ship_via,
         (CASE
             WHEN i.sub_class = 'SlipSheet' THEN i.manufacturer_item
             ELSE NULL
          END)
            AS slipsheet,
         SUM (
            CASE
               WHEN i.sub_class = 'SlipSheet' THEN ol.ordered_quantity
               ELSE 0
            END)
            AS slpshtqty,
         MAX (0) AS repqty,
         SUM (s.total_actual_charge) AS shipchrg,
         MAX (OH.SHIP_NODE) sentwhat,
         MAX (' ') AS chargeto,
         MAX (' ') AS reason,
         MAX (TO_CHAR (OH.REQUESTED_DELIVERY_DATE, 'MM/DD/YYYY'))
            requested_delivery_date,
         MAX (' ') AS flycreator,
         oh.scac || ' ' || oh.carrier_service_code AS shipmethod,
         MAX (e.selling_method) selling_method,
         MAX (' ') AS teaenv,
         (CASE WHEN i.sub_class = 'Fold' THEN ' ' ELSE i.manufacturer_item END)
            AS vispart,
         (CASE WHEN v.visual_merch_id = -1 THEN NULL ELSE v.visual_merch_id END)
            AS visual_merch_id,
         apo.PRICE_PROGRAM_NAME,
         MAX (CASE WHEN s.status = '1400' THEN 'Y' ELSE 'N' END)
            AS report_shipped_ind,
         MAX (draft_order_flag) draft_order_flag,
         oh.order_no,
         MAX (oh.order_status) order_status,
         MAX (apo.marketing_code) marketing_code,
         REPLACE(MAX (i.description), ',' ,';') item_description,
         MAX (
            CASE
               WHEN TRIM (s.status) <> '9000' THEN s.shipment_no
               ELSE NULL
            END)
            shipment_no,
         REPLACE (P.FIRST_NAME, ',', '') AS FIRST_NAME,
         REPLACE (P.LAST_NAME, ',', '') AS LAST_NAME,
         P.ADDRESS_LINE1,
         P.ADDRESS_LINE2,
         P.CITY,
         P.STATE,
         P.ZIP_CODE,
         OH.SHIP_ORDERS_TO,
         ot.order_type,
         APO.STATUS,
         APO.SCHOOL_YEAR,
         TO_CHAR (OH.ORDER_DATE, 'MM/DD/YYYY') ORDER_DATE,
         TO_CHAR (ol.earliest_schedule_date, 'MM/DD/YYYY') AS RELEASE_DATE,
         P.COUNTRY,
         I.ITEM_ID,
         OFFERING.PART_NUMBER AS OFFERING_PART_NUMBER,
         sub_program.sub_program_name,
         om.name,
         APO.apo_ID,
         CASE
            WHEN E.AUTO_PDK_DISABLED = 1 THEN 'YES'
            WHEN E.AUTO_PDK_DISABLED = 0 THEN 'NO'
            ELSE ''
         END
            AS AUTO_PDK_DISABLED,
         E.AUTO_PDK_DISABLED_REASON,
         E.AUTO_PDK_UPDATED_BY,
        APO.TERRITORY_CODE ,
        ORG.REGION_NAME  
    FROM ods_own.order_type ot,
         ods_own.order_header oh,
         ods_own.order_line ol,
         ods_own.item i,
         ods_own.apo,
         ods_own.account a,
         ods_own.visual_merch v,
         ods_own.price_program pp,
         ods_own.event e,
         ods_own.shipment_line sl,
         ods_own.shipment s,
         ODS_OWN.PERSON_INFO p,
         ODS_OWN.OFFERING OFFERING,
         ODS_OWN.OFFERING_MODEL om,
         ods_own.sub_program sub_program,
         ODS_OWN.ORGANIZATION_vw org,
         ods_own.data_center dc
   WHERE     (1 = 1)
         AND org.TERRITORY_CODE = apo.territory_code
         AND org.business_unit_name LIKE '%' || dc.data_center_name || '%'
         AND ot.order_type IN ('PDK_Order',
                               'FRN_Order',
                               'pFRN_Order',
                               'YBSales_Order')
         AND oh.order_type_oid = ot.order_type_oid
         AND oh.order_bucket <> 'CANCELLED'
         AND ol.order_header_oid = oh.order_header_oid
         AND i.item_oid = ol.item_oid
         AND apo.apo_oid = oh.apo_oid
         AND apo.apo_oid = OFFERING.apo_oid
         AND OFFERING.OFFERING_MODEL_OID = om.OFFERING_MODEL_OID(+)
         AND apo.sub_program_oid = sub_program.sub_program_oid
         AND a.account_oid = apo.account_oid
         AND apo.visual_merch_oid = v.visual_merch_oid(+)
         AND e.event_ref_id = oh.event_ref_id
         AND oh.price_program_oid = pp.price_program_oid(+)
         AND ol.order_line_oid = sl.order_line_oid(+)
         AND sl.shipment_oid = s.shipment_oid(+)
         AND s.PERSON_INFO_OID = p.PERSON_INFO_OID(+)
         --         AND OM.ACTIVE = 1
         --and p.first_name is not null
         --and p.last_name is not null
         AND TO_CHAR (OH.ORDER_DATE, 'YYYYMMDD') between 
                TO_CHAR (ADD_MONTHS (TRUNC (SYSDATE), -12), 'YYYYMMDD')  
           and   TO_CHAR (last_day(add_months(trunc(sysdate,'mm'),-10)), 'YYYYMMDD')
GROUP BY e.pdk_number,
         e.event_ref_id,
         (CASE
             WHEN i.sub_class = 'Fold' THEN ' '
             ELSE i.manufacturer_item
          END),
         a.lifetouch_id,
         A.ENROLLMENT,
         s.tracking_no,
         s.ship_via,
         (CASE
             WHEN i.sub_class = 'SlipSheet' THEN i.manufacturer_item
             ELSE NULL
          END),
         oh.scac || ' ' || oh.carrier_service_code,
         (CASE
             WHEN i.sub_class = 'Fold' THEN ' '
             ELSE i.manufacturer_item
          END),
         v.visual_merch_id,
         apo.PRICE_PROGRAM_NAME,
         oh.order_no,
         REPLACE (P.FIRST_NAME, ',', ''),
         REPLACE (P.LAST_NAME, ',', ''),
         P.ADDRESS_LINE1,
         P.ADDRESS_LINE2,
         P.CITY,
         P.STATE,
         P.ZIP_CODE,
         OH.SHIP_ORDERS_TO,
         ot.order_type,
         APO.STATUS,
         APO.SCHOOL_YEAR,
         TO_CHAR (OH.ORDER_DATE, 'MM/DD/YYYY'),
         TO_CHAR (ol.earliest_schedule_date, 'MM/DD/YYYY'),
         P.COUNTRY,
         I.ITEM_ID,
         OFFERING.PART_NUMBER,
         sub_program.sub_program_name,
         om.name,
         APO.apo_ID,
         E.AUTO_PDK_DISABLED,
         E.AUTO_PDK_DISABLED_REASON,
         E.AUTO_PDK_UPDATED_BY,
        APO.TERRITORY_CODE ,
        ORG.REGION_NAME 
  HAVING SUM (ol.ordered_quantity) <> 0
ORDER BY event_ref_id

&

/*-----------------------------------------------*/
/* TASK No. 4 */
/* drop table stage2 */

/* drop table RAX_APP_USER.pdk_report_stage2 */

BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.pdk_report_stage2';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 5 */
/* create table pdk_report_stage2 */



CREATE TABLE RAX_APP_USER.pdk_report_stage2 as

  SELECT e.pdk_number,
         e.event_ref_id,
         (CASE WHEN i.sub_class = 'Fold' THEN ' ' ELSE i.manufacturer_item END)
            AS part_number,
         MAX (i.sub_class) sub_class            --,max(i.item_id) orig_item_id
                                    ,
         MAX (a.account_alias) account_alias,
         a.lifetouch_id,
         MAX (
            (CASE
                WHEN e.photography_date = TO_DATE ('19000101', 'yyyymmdd')
                THEN
                   NULL
                ELSE
                   TO_CHAR (e.photography_date, 'MM/DD/YYYY')
             END))
            AS pictdate,
         MAX (
            (CASE
                WHEN e.plant_receipt_date = TO_DATE ('19000101', 'yyyymmdd')
                THEN
                   NULL
                ELSE
                   TO_CHAR (e.plant_receipt_date, 'MM/DD/YYYY')
             END))
            AS received,
        MAX (TO_CHAR (ol.earliest_schedule_date, 'MM/DD/YYYY hh:mi:ss PM')) AS sent_date,
         MAX (TO_CHAR (oh.last_user_modified_date, 'MM/DD/YYYY')) AS firstappr,
         MAX (TO_CHAR (oh.last_user_modified_date, 'MM/DD/YYYY')) AS curappr,
         MAX (TO_CHAR (oh.requested_ship_date, 'MM/DD/YYYY')) AS ship_by,
         MAX (
            CASE
               WHEN s.status = '1400'
               THEN
                  TO_CHAR (s.actual_shipment_date, 'MM/DD/YYYY')
               ELSE
                  NULL
            END)
            AS shipdate,
         MAX (' ') AS reprint,
         A.ENROLLMENT AS enroll,
         SUM (ol.ordered_quantity) AS qtyorder,
         SUM (sl.shipped_quantity) AS qtyship,
         s.tracking_no,
         s.ship_via,
         (CASE
             WHEN i.sub_class = 'SlipSheet' THEN i.manufacturer_item
             ELSE NULL
          END)
            AS slipsheet,
         SUM (
            CASE
               WHEN i.sub_class = 'SlipSheet' THEN ol.ordered_quantity
               ELSE 0
            END)
            AS slpshtqty,
         MAX (0) AS repqty,
         SUM (s.total_actual_charge) AS shipchrg,
         MAX (OH.SHIP_NODE) sentwhat,
         MAX (' ') AS chargeto,
         MAX (' ') AS reason,
         MAX (TO_CHAR (OH.REQUESTED_DELIVERY_DATE, 'MM/DD/YYYY'))
            requested_delivery_date,
         MAX (' ') AS flycreator,
         oh.scac || ' ' || oh.carrier_service_code AS shipmethod,
         MAX (e.selling_method) selling_method,
         MAX (' ') AS teaenv,
         (CASE WHEN i.sub_class = 'Fold' THEN ' ' ELSE i.manufacturer_item END)
            AS vispart,
         (CASE WHEN v.visual_merch_id = -1 THEN NULL ELSE v.visual_merch_id END)
            AS visual_merch_id,
         apo.PRICE_PROGRAM_NAME,
         MAX (CASE WHEN s.status = '1400' THEN 'Y' ELSE 'N' END)
            AS report_shipped_ind,
         MAX (draft_order_flag) draft_order_flag,
         oh.order_no,
         MAX (oh.order_status) order_status,
         MAX (apo.marketing_code) marketing_code,
         REPLACE(MAX (i.description), ',' ,';') item_description,
         MAX (
            CASE
               WHEN TRIM (s.status) <> '9000' THEN s.shipment_no
               ELSE NULL
            END)
            shipment_no,
         REPLACE (P.FIRST_NAME, ',', '') AS FIRST_NAME,
         REPLACE (P.LAST_NAME, ',', '') AS LAST_NAME,
         P.ADDRESS_LINE1,
         P.ADDRESS_LINE2,
         P.CITY,
         P.STATE,
         P.ZIP_CODE,
         OH.SHIP_ORDERS_TO,
         ot.order_type,
         APO.STATUS,
         APO.SCHOOL_YEAR,
         TO_CHAR (OH.ORDER_DATE, 'MM/DD/YYYY') ORDER_DATE,
         TO_CHAR (ol.earliest_schedule_date, 'MM/DD/YYYY') AS RELEASE_DATE,
         P.COUNTRY,
         I.ITEM_ID,
         OFFERING.PART_NUMBER AS OFFERING_PART_NUMBER,
         sub_program.sub_program_name,
         om.name,
         APO.apo_ID,
         CASE
            WHEN E.AUTO_PDK_DISABLED = 1 THEN 'YES'
            WHEN E.AUTO_PDK_DISABLED = 0 THEN 'NO'
            ELSE ''
         END
            AS AUTO_PDK_DISABLED,
         E.AUTO_PDK_DISABLED_REASON,
         E.AUTO_PDK_UPDATED_BY,
        APO.TERRITORY_CODE ,
        ORG.REGION_NAME  
    FROM ods_own.order_type ot,
         ods_own.order_header oh,
         ods_own.order_line ol,
         ods_own.item i,
         ods_own.apo,
         ods_own.account a,
         ods_own.visual_merch v,
         ods_own.price_program pp,
         ods_own.event e,
         ods_own.shipment_line sl,
         ods_own.shipment s,
         ODS_OWN.PERSON_INFO p,
         ODS_OWN.OFFERING OFFERING,
         ODS_OWN.OFFERING_MODEL om,
         ods_own.sub_program sub_program,
         ODS_OWN.ORGANIZATION_vw org,
         ods_own.data_center dc
   WHERE     (1 = 1)
         AND org.TERRITORY_CODE = apo.territory_code
         AND org.business_unit_name LIKE '%' || dc.data_center_name || '%'
         AND ot.order_type IN ('PDK_Order',
                               'FRN_Order',
                               'pFRN_Order',
                               'YBSales_Order')
         AND oh.order_type_oid = ot.order_type_oid
         AND oh.order_bucket <> 'CANCELLED'
         AND ol.order_header_oid = oh.order_header_oid
         AND i.item_oid = ol.item_oid
         AND apo.apo_oid = oh.apo_oid
         AND apo.apo_oid = OFFERING.apo_oid
         AND OFFERING.OFFERING_MODEL_OID = om.OFFERING_MODEL_OID(+)
         AND apo.sub_program_oid = sub_program.sub_program_oid
         AND a.account_oid = apo.account_oid
         AND apo.visual_merch_oid = v.visual_merch_oid(+)
         AND e.event_ref_id = oh.event_ref_id
         AND oh.price_program_oid = pp.price_program_oid(+)
         AND ol.order_line_oid = sl.order_line_oid(+)
         AND sl.shipment_oid = s.shipment_oid(+)
         AND s.PERSON_INFO_OID = p.PERSON_INFO_OID(+)
         --         AND OM.ACTIVE = 1
         --and p.first_name is not null
         --and p.last_name is not null
         AND TO_CHAR (OH.ORDER_DATE, 'YYYYMMDD') between 
             TO_CHAR (ADD_MONTHS(TRUNC(SYSDATE,'mm'),-9), 'YYYYMMDD')
  and  TO_CHAR (last_day(ADD_MONTHS(TRUNC(SYSDATE,'mm'),-6)), 'YYYYMMDD')
GROUP BY e.pdk_number,
         e.event_ref_id,
         (CASE
             WHEN i.sub_class = 'Fold' THEN ' '
             ELSE i.manufacturer_item
          END),
         a.lifetouch_id,
         A.ENROLLMENT,
         s.tracking_no,
         s.ship_via,
         (CASE
             WHEN i.sub_class = 'SlipSheet' THEN i.manufacturer_item
             ELSE NULL
          END),
         oh.scac || ' ' || oh.carrier_service_code,
         (CASE
             WHEN i.sub_class = 'Fold' THEN ' '
             ELSE i.manufacturer_item
          END),
         v.visual_merch_id,
         apo.PRICE_PROGRAM_NAME,
         oh.order_no,
         REPLACE (P.FIRST_NAME, ',', ''),
         REPLACE (P.LAST_NAME, ',', ''),
         P.ADDRESS_LINE1,
         P.ADDRESS_LINE2,
         P.CITY,
         P.STATE,
         P.ZIP_CODE,
         OH.SHIP_ORDERS_TO,
         ot.order_type,
         APO.STATUS,
         APO.SCHOOL_YEAR,
         TO_CHAR (OH.ORDER_DATE, 'MM/DD/YYYY'),
         TO_CHAR (ol.earliest_schedule_date, 'MM/DD/YYYY'),
         P.COUNTRY,
         I.ITEM_ID,
         OFFERING.PART_NUMBER,
         sub_program.sub_program_name,
         om.name,
         APO.apo_ID,
         E.AUTO_PDK_DISABLED,
         E.AUTO_PDK_DISABLED_REASON,
         E.AUTO_PDK_UPDATED_BY,
        APO.TERRITORY_CODE ,
        ORG.REGION_NAME 
  HAVING SUM (ol.ordered_quantity) <> 0
ORDER BY event_ref_id

&

/*-----------------------------------------------*/
/* TASK No. 6 */
/* drop table stage3 */

/* drop table RAX_APP_USER.pdk_report_stage3 */

BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.pdk_report_stage3';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 7 */
/* Create table pdk_report_stage3 */



CREATE TABLE RAX_APP_USER.pdk_report_stage3 as

  SELECT e.pdk_number,
         e.event_ref_id,
         (CASE WHEN i.sub_class = 'Fold' THEN ' ' ELSE i.manufacturer_item END)
            AS part_number,
         MAX (i.sub_class) sub_class            --,max(i.item_id) orig_item_id
                                    ,
         MAX (a.account_alias) account_alias,
         a.lifetouch_id,
         MAX (
            (CASE
                WHEN e.photography_date = TO_DATE ('19000101', 'yyyymmdd')
                THEN
                   NULL
                ELSE
                   TO_CHAR (e.photography_date, 'MM/DD/YYYY')
             END))
            AS pictdate,
         MAX (
            (CASE
                WHEN e.plant_receipt_date = TO_DATE ('19000101', 'yyyymmdd')
                THEN
                   NULL
                ELSE
                   TO_CHAR (e.plant_receipt_date, 'MM/DD/YYYY')
             END))
            AS received,
        MAX (TO_CHAR (ol.earliest_schedule_date, 'MM/DD/YYYY hh:mi:ss PM')) AS sent_date,
         MAX (TO_CHAR (oh.last_user_modified_date, 'MM/DD/YYYY')) AS firstappr,
         MAX (TO_CHAR (oh.last_user_modified_date, 'MM/DD/YYYY')) AS curappr,
         MAX (TO_CHAR (oh.requested_ship_date, 'MM/DD/YYYY')) AS ship_by,
         MAX (
            CASE
               WHEN s.status = '1400'
               THEN
                  TO_CHAR (s.actual_shipment_date, 'MM/DD/YYYY')
               ELSE
                  NULL
            END)
            AS shipdate,
         MAX (' ') AS reprint,
         A.ENROLLMENT AS enroll,
         SUM (ol.ordered_quantity) AS qtyorder,
         SUM (sl.shipped_quantity) AS qtyship,
         s.tracking_no,
         s.ship_via,
         (CASE
             WHEN i.sub_class = 'SlipSheet' THEN i.manufacturer_item
             ELSE NULL
          END)
            AS slipsheet,
         SUM (
            CASE
               WHEN i.sub_class = 'SlipSheet' THEN ol.ordered_quantity
               ELSE 0
            END)
            AS slpshtqty,
         MAX (0) AS repqty,
         SUM (s.total_actual_charge) AS shipchrg,
         MAX (OH.SHIP_NODE) sentwhat,
         MAX (' ') AS chargeto,
         MAX (' ') AS reason,
         MAX (TO_CHAR (OH.REQUESTED_DELIVERY_DATE, 'MM/DD/YYYY'))
            requested_delivery_date,
         MAX (' ') AS flycreator,
         oh.scac || ' ' || oh.carrier_service_code AS shipmethod,
         MAX (e.selling_method) selling_method,
         MAX (' ') AS teaenv,
         (CASE WHEN i.sub_class = 'Fold' THEN ' ' ELSE i.manufacturer_item END)
            AS vispart,
         (CASE WHEN v.visual_merch_id = -1 THEN NULL ELSE v.visual_merch_id END)
            AS visual_merch_id,
         apo.PRICE_PROGRAM_NAME,
         MAX (CASE WHEN s.status = '1400' THEN 'Y' ELSE 'N' END)
            AS report_shipped_ind,
         MAX (draft_order_flag) draft_order_flag,
         oh.order_no,
         MAX (oh.order_status) order_status,
         MAX (apo.marketing_code) marketing_code,
         REPLACE(MAX (i.description), ',' ,';') item_description,
         MAX (
            CASE
               WHEN TRIM (s.status) <> '9000' THEN s.shipment_no
               ELSE NULL
            END)
            shipment_no,
         REPLACE (P.FIRST_NAME, ',', '') AS FIRST_NAME,
         REPLACE (P.LAST_NAME, ',', '') AS LAST_NAME,
         P.ADDRESS_LINE1,
         P.ADDRESS_LINE2,
         P.CITY,
         P.STATE,
         P.ZIP_CODE,
         OH.SHIP_ORDERS_TO,
         ot.order_type,
         APO.STATUS,
         APO.SCHOOL_YEAR,
         TO_CHAR (OH.ORDER_DATE, 'MM/DD/YYYY') ORDER_DATE,
         TO_CHAR (ol.earliest_schedule_date, 'MM/DD/YYYY') AS RELEASE_DATE,
         P.COUNTRY,
         I.ITEM_ID,
         OFFERING.PART_NUMBER AS OFFERING_PART_NUMBER,
         sub_program.sub_program_name,
         om.name,
         APO.apo_ID,
         CASE
            WHEN E.AUTO_PDK_DISABLED = 1 THEN 'YES'
            WHEN E.AUTO_PDK_DISABLED = 0 THEN 'NO'
            ELSE ''
         END
            AS AUTO_PDK_DISABLED,
         E.AUTO_PDK_DISABLED_REASON,
         E.AUTO_PDK_UPDATED_BY,
        APO.TERRITORY_CODE ,
        ORG.REGION_NAME  
    FROM ods_own.order_type ot,
         ods_own.order_header oh,
         ods_own.order_line ol,
         ods_own.item i,
         ods_own.apo,
         ods_own.account a,
         ods_own.visual_merch v,
         ods_own.price_program pp,
         ods_own.event e,
         ods_own.shipment_line sl,
         ods_own.shipment s,
         ODS_OWN.PERSON_INFO p,
         ODS_OWN.OFFERING OFFERING,
         ODS_OWN.OFFERING_MODEL om,
         ods_own.sub_program sub_program,
         ODS_OWN.ORGANIZATION_vw org,
         ods_own.data_center dc
   WHERE     (1 = 1)
         AND org.TERRITORY_CODE = apo.territory_code
         AND org.business_unit_name LIKE '%' || dc.data_center_name || '%'
         AND ot.order_type IN ('PDK_Order',
                               'FRN_Order',
                               'pFRN_Order',
                               'YBSales_Order')
         AND oh.order_type_oid = ot.order_type_oid
         AND oh.order_bucket <> 'CANCELLED'
         AND ol.order_header_oid = oh.order_header_oid
         AND i.item_oid = ol.item_oid
         AND apo.apo_oid = oh.apo_oid
         AND apo.apo_oid = OFFERING.apo_oid
         AND OFFERING.OFFERING_MODEL_OID = om.OFFERING_MODEL_OID(+)
         AND apo.sub_program_oid = sub_program.sub_program_oid
         AND a.account_oid = apo.account_oid
         AND apo.visual_merch_oid = v.visual_merch_oid(+)
         AND e.event_ref_id = oh.event_ref_id
         AND oh.price_program_oid = pp.price_program_oid(+)
         AND ol.order_line_oid = sl.order_line_oid(+)
         AND sl.shipment_oid = s.shipment_oid(+)
         AND s.PERSON_INFO_OID = p.PERSON_INFO_OID(+)
         --         AND OM.ACTIVE = 1
         --and p.first_name is not null
         --and p.last_name is not null
         AND TO_CHAR (OH.ORDER_DATE, 'YYYYMMDD') between 
               TO_CHAR (add_months(trunc(sysdate,'mm'),-5), 'YYYYMMDD') 
 and   TO_CHAR (last_day(add_months(trunc(sysdate,'mm'),-2)), 'YYYYMMDD')
GROUP BY e.pdk_number,
         e.event_ref_id,
         (CASE
             WHEN i.sub_class = 'Fold' THEN ' '
             ELSE i.manufacturer_item
          END),
         a.lifetouch_id,
         A.ENROLLMENT,
         s.tracking_no,
         s.ship_via,
         (CASE
             WHEN i.sub_class = 'SlipSheet' THEN i.manufacturer_item
             ELSE NULL
          END),
         oh.scac || ' ' || oh.carrier_service_code,
         (CASE
             WHEN i.sub_class = 'Fold' THEN ' '
             ELSE i.manufacturer_item
          END),
         v.visual_merch_id,
         apo.PRICE_PROGRAM_NAME,
         oh.order_no,
         REPLACE (P.FIRST_NAME, ',', ''),
         REPLACE (P.LAST_NAME, ',', ''),
         P.ADDRESS_LINE1,
         P.ADDRESS_LINE2,
         P.CITY,
         P.STATE,
         P.ZIP_CODE,
         OH.SHIP_ORDERS_TO,
         ot.order_type,
         APO.STATUS,
         APO.SCHOOL_YEAR,
         TO_CHAR (OH.ORDER_DATE, 'MM/DD/YYYY'),
         TO_CHAR (ol.earliest_schedule_date, 'MM/DD/YYYY'),
         P.COUNTRY,
         I.ITEM_ID,
         OFFERING.PART_NUMBER,
         sub_program.sub_program_name,
         om.name,
         APO.apo_ID,
         E.AUTO_PDK_DISABLED,
         E.AUTO_PDK_DISABLED_REASON,
         E.AUTO_PDK_UPDATED_BY,
        APO.TERRITORY_CODE ,
        ORG.REGION_NAME 
  HAVING SUM (ol.ordered_quantity) <> 0
ORDER BY event_ref_id

&

/*-----------------------------------------------*/
/* TASK No. 8 */
/* drop table stage4 */

/* drop table RAX_APP_USER.pdk_report_stage4 */

BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.pdk_report_stage4';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 9 */
/* create table pdk_report_stage4 */



CREATE TABLE RAX_APP_USER.pdk_report_stage4 as

  SELECT e.pdk_number,
         e.event_ref_id,
         (CASE WHEN i.sub_class = 'Fold' THEN ' ' ELSE i.manufacturer_item END)
            AS part_number,
         MAX (i.sub_class) sub_class            --,max(i.item_id) orig_item_id
                                    ,
         MAX (a.account_alias) account_alias,
         a.lifetouch_id,
         MAX (
            (CASE
                WHEN e.photography_date = TO_DATE ('19000101', 'yyyymmdd')
                THEN
                   NULL
                ELSE
                   TO_CHAR (e.photography_date, 'MM/DD/YYYY')
             END))
            AS pictdate,
         MAX (
            (CASE
                WHEN e.plant_receipt_date = TO_DATE ('19000101', 'yyyymmdd')
                THEN
                   NULL
                ELSE
                   TO_CHAR (e.plant_receipt_date, 'MM/DD/YYYY')
             END))
            AS received,
         MAX (TO_CHAR (ol.earliest_schedule_date, 'MM/DD/YYYY hh:mi:ss PM')) AS sent_date,
         MAX (TO_CHAR (oh.last_user_modified_date, 'MM/DD/YYYY')) AS firstappr,
         MAX (TO_CHAR (oh.last_user_modified_date, 'MM/DD/YYYY')) AS curappr,
         MAX (TO_CHAR (oh.requested_ship_date, 'MM/DD/YYYY')) AS ship_by,
         MAX (
            CASE
               WHEN s.status = '1400'
               THEN
                  TO_CHAR (s.actual_shipment_date, 'MM/DD/YYYY')
               ELSE
                  NULL
            END)
            AS shipdate,
         MAX (' ') AS reprint,
         A.ENROLLMENT AS enroll,
         SUM (ol.ordered_quantity) AS qtyorder,
         SUM (sl.shipped_quantity) AS qtyship,
         s.tracking_no,
         s.ship_via,
         (CASE
             WHEN i.sub_class = 'SlipSheet' THEN i.manufacturer_item
             ELSE NULL
          END)
            AS slipsheet,
         SUM (
            CASE
               WHEN i.sub_class = 'SlipSheet' THEN ol.ordered_quantity
               ELSE 0
            END)
            AS slpshtqty,
         MAX (0) AS repqty,
         SUM (s.total_actual_charge) AS shipchrg,
         MAX (OH.SHIP_NODE) sentwhat,
         MAX (' ') AS chargeto,
         MAX (' ') AS reason,
         MAX (TO_CHAR (OH.REQUESTED_DELIVERY_DATE, 'MM/DD/YYYY'))
            requested_delivery_date,
         MAX (' ') AS flycreator,
         oh.scac || ' ' || oh.carrier_service_code AS shipmethod,
         MAX (e.selling_method) selling_method,
         MAX (' ') AS teaenv,
         (CASE WHEN i.sub_class = 'Fold' THEN ' ' ELSE i.manufacturer_item END)
            AS vispart,
         (CASE WHEN v.visual_merch_id = -1 THEN NULL ELSE v.visual_merch_id END)
            AS visual_merch_id,
         apo.PRICE_PROGRAM_NAME,
         MAX (CASE WHEN s.status = '1400' THEN 'Y' ELSE 'N' END)
            AS report_shipped_ind,
         MAX (draft_order_flag) draft_order_flag,
         oh.order_no,
         MAX (oh.order_status) order_status,
         MAX (apo.marketing_code) marketing_code,
         REPLACE(MAX (i.description), ',' ,';') item_description,
         MAX (
            CASE
               WHEN TRIM (s.status) <> '9000' THEN s.shipment_no
               ELSE NULL
            END)
            shipment_no,
         REPLACE (P.FIRST_NAME, ',', '') AS FIRST_NAME,
         REPLACE (P.LAST_NAME, ',', '') AS LAST_NAME,
         P.ADDRESS_LINE1,
         P.ADDRESS_LINE2,
         P.CITY,
         P.STATE,
         P.ZIP_CODE,
         OH.SHIP_ORDERS_TO,
         ot.order_type,
         APO.STATUS,
         APO.SCHOOL_YEAR,
         TO_CHAR (OH.ORDER_DATE, 'MM/DD/YYYY') ORDER_DATE,
         TO_CHAR (ol.earliest_schedule_date, 'MM/DD/YYYY') AS RELEASE_DATE,
         P.COUNTRY,
         I.ITEM_ID,
         OFFERING.PART_NUMBER AS OFFERING_PART_NUMBER,
         sub_program.sub_program_name,
         om.name,
         APO.apo_ID,
         CASE
            WHEN E.AUTO_PDK_DISABLED = 1 THEN 'YES'
            WHEN E.AUTO_PDK_DISABLED = 0 THEN 'NO'
            ELSE ''
         END
            AS AUTO_PDK_DISABLED,
         E.AUTO_PDK_DISABLED_REASON,
         E.AUTO_PDK_UPDATED_BY,
        APO.TERRITORY_CODE ,
        ORG.REGION_NAME  
    FROM ods_own.order_type ot,
         ods_own.order_header oh,
         ods_own.order_line ol,
         ods_own.item i,
         ods_own.apo,
         ods_own.account a,
         ods_own.visual_merch v,
         ods_own.price_program pp,
         ods_own.event e,
         ods_own.shipment_line sl,
         ods_own.shipment s,
         ODS_OWN.PERSON_INFO p,
         ODS_OWN.OFFERING OFFERING,
         ODS_OWN.OFFERING_MODEL om,
         ods_own.sub_program sub_program,
         ODS_OWN.ORGANIZATION_vw org,
         ods_own.data_center dc
   WHERE     (1 = 1)
         AND org.TERRITORY_CODE = apo.territory_code
         AND org.business_unit_name LIKE '%' || dc.data_center_name || '%'
         AND ot.order_type IN ('PDK_Order',
                               'FRN_Order',
                               'pFRN_Order',
                               'YBSales_Order')
         AND oh.order_type_oid = ot.order_type_oid
         AND oh.order_bucket <> 'CANCELLED'
         AND ol.order_header_oid = oh.order_header_oid
         AND i.item_oid = ol.item_oid
         AND apo.apo_oid = oh.apo_oid
         AND apo.apo_oid = OFFERING.apo_oid
         AND OFFERING.OFFERING_MODEL_OID = om.OFFERING_MODEL_OID(+)
         AND apo.sub_program_oid = sub_program.sub_program_oid
         AND a.account_oid = apo.account_oid
         AND apo.visual_merch_oid = v.visual_merch_oid(+)
         AND e.event_ref_id = oh.event_ref_id
         AND oh.price_program_oid = pp.price_program_oid(+)
         AND ol.order_line_oid = sl.order_line_oid(+)
         AND sl.shipment_oid = s.shipment_oid(+)
         AND s.PERSON_INFO_OID = p.PERSON_INFO_OID(+)
         --         AND OM.ACTIVE = 1
         --and p.first_name is not null
         --and p.last_name is not null
         AND TO_CHAR (OH.ORDER_DATE, 'YYYYMMDD') between 
               TO_CHAR (add_months(trunc(sysdate,'mm'),-1), 'YYYYMMDD')
 and   TO_CHAR (TRUNC (SYSDATE),'YYYYMMDD') 
GROUP BY e.pdk_number,
         e.event_ref_id,
         (CASE
             WHEN i.sub_class = 'Fold' THEN ' '
             ELSE i.manufacturer_item
          END),
         a.lifetouch_id,
         A.ENROLLMENT,
         s.tracking_no,
         s.ship_via,
         (CASE
             WHEN i.sub_class = 'SlipSheet' THEN i.manufacturer_item
             ELSE NULL
          END),
         oh.scac || ' ' || oh.carrier_service_code,
         (CASE
             WHEN i.sub_class = 'Fold' THEN ' '
             ELSE i.manufacturer_item
          END),
         v.visual_merch_id,
         apo.PRICE_PROGRAM_NAME,
         oh.order_no,
         REPLACE (P.FIRST_NAME, ',', ''),
         REPLACE (P.LAST_NAME, ',', ''),
         P.ADDRESS_LINE1,
         P.ADDRESS_LINE2,
         P.CITY,
         P.STATE,
         P.ZIP_CODE,
         OH.SHIP_ORDERS_TO,
         ot.order_type,
         APO.STATUS,
         APO.SCHOOL_YEAR,
         TO_CHAR (OH.ORDER_DATE, 'MM/DD/YYYY'),
         TO_CHAR (ol.earliest_schedule_date, 'MM/DD/YYYY'),
         P.COUNTRY,
         I.ITEM_ID,
         OFFERING.PART_NUMBER,
         sub_program.sub_program_name,
         om.name,
         APO.apo_ID,
         E.AUTO_PDK_DISABLED,
         E.AUTO_PDK_DISABLED_REASON,
         E.AUTO_PDK_UPDATED_BY,
        APO.TERRITORY_CODE ,
        ORG.REGION_NAME 
  HAVING SUM (ol.ordered_quantity) <> 0
ORDER BY event_ref_id

&

/*-----------------------------------------------*/
/* TASK No. 10 */
/* drop report table */

/* drop table RAX_APP_USER.pdk_report_stage */

BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.pdk_report_stage';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 11 */
/* CREATE REPORT FINAL TABLE */



CREATE TABLE RAX_APP_USER.pdk_report_stage as
select  *  from RAX_APP_USER.pdk_report_stage1
union all
select  *  from RAX_APP_USER.pdk_report_stage2
union all
select  *  from RAX_APP_USER.pdk_report_stage3
union all
select  *  from RAX_APP_USER.pdk_report_stage4

&


