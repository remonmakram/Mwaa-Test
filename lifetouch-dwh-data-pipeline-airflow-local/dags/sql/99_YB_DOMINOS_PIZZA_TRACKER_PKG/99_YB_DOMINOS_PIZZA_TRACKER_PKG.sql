/* TASK No. 1 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 2 */




/*-----------------------------------------------*/
/* TASK No. 3 */
/* Insert Active Events */

MERGE INTO ods_stage.YB_DOMINO_STG t
     USING (SELECT e.event_oid, e.event_ref_id
  FROM ods_own.account          acct,
       ODS_OWN.ORGANIZATION_VW  org,
       ods_own.sub_program      sp,
       ods_own.apo              a,
       ods_own.event            e,
       ODS_OWN.DATA_CENTER      dc
 WHERE     a.ACCOUNT_OID = acct.ACCOUNT_OID
       AND a.SUB_PROGRAM_OID = sp.SUB_PROGRAM_OID
       AND a.TERRITORY_CODE = org.TERRITORY_CODE
       AND a.APO_OID = e.APO_OID
       AND a.STATUS = 'Active'
       AND e.STATUS = '1'
       -- AND acct.CATEGORY_NAME NOT IN ('House', 'Test')
       AND (   org.BUSINESS_UNIT_NAME =
               CASE
                   WHEN NVL (dc.DATA_CENTER_NAME, 'United States') =
                        'United States'
                   THEN
                       'United States School Groups'
                   ELSE
                       'Canada School Group'
               END
            OR org.BUSINESS_UNIT_NAME = 'Test Organization')
       AND sp.SUB_PROGRAM_NAME = 'Yearbook'
       AND a.SCHOOL_YEAR >= 2020) s
        ON (t.event_oid = s.event_oid)
WHEN NOT MATCHED
THEN
    INSERT     (event_oid,
                event_ref_id,
                ods_create_date,
                ods_modify_date)
        VALUES (s.event_oid,
                s.event_ref_id,
                SYSDATE,
                SYSDATE)

&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* Update Expected Arrival Date */

MERGE INTO ods_stage.YB_DOMINO_STG t
     USING (SELECT e.EVENT_OID,
                   ch.SCHED_SHIP_DATE + 7     AS expected_arrival_date
              FROM ODS_STAGE.LPIP_CONTRACT_HEADER_STAGE  ch,
                   ods_own.apo                           a,
                   ods_own.event                         e
             WHERE     ch.JOB_NUMBER = a.LPIP_JOB_NUMBER
                   AND ch.PUB_YEAR >= 2020
                   AND a.APO_OID = e.APO_OID) s
        ON (s.event_oid = t.event_oid)
WHEN MATCHED
THEN
    UPDATE SET
        t.expected_arrival_date = s.expected_arrival_date,
        t.ods_modify_date = SYSDATE
             WHERE DECODE (s.expected_arrival_date,
                           t.expected_arrival_date, 1,
                           0) =
                   0

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Update Submitted Date (non-Supplement) */

MERGE INTO ods_stage.YB_DOMINO_STG t
     USING (SELECT e.EVENT_OID,
                   GREATEST (a.COVER_RECEIVED,
                             e.YB_COMPLETE_COPY_DATE,
                             a.FINALIZED_DATE)
                       AS submitted
              FROM ods_own.event e, ods_own.apo a, ods_stage.YB_DOMINO_STG dr
             WHERE     e.APO_OID = a.APO_OID
                   AND e.EVENT_OID = dr.EVENT_OID
                   AND e.EVENT_TYPE != 'SUPPLEMENT') s
        ON (t.event_oid = s.event_oid)
WHEN MATCHED
THEN
    UPDATE SET t.submitted = s.submitted, t.submitted_inherit = NULL, ods_modify_date = SYSDATE
             WHERE DECODE (s.submitted, t.submitted, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Update Submitted Date (Supplement) */

MERGE INTO ods_stage.YB_DOMINO_STG t
     USING (  SELECT e.EVENT_OID, MAX (tr.OUT_DATE) AS submitted
                FROM ODS_STAGE.LPIP_TRACKING_STG tr,
                     ODS_STAGE.YB_DOMINO_STG    dom,
                     ods_own.event              e,
                     ods_own.apo                a
               WHERE     e.EVENT_OID = dom.EVENT_OID
                     AND a.APO_OID = e.APO_OID
                     AND a.LPIP_JOB_NUMBER = tr.JOB_NUMBER
                     AND e.EVENT_TYPE = 'SUPPLEMENT'
                     AND tr.MATERIAL_CODE = 'SCDI'
                     AND tr.DEPT = 'CKIN'
                     AND tr.OUT_DATE IS NOT NULL
            GROUP BY e.EVENT_OID) s
        ON (t.event_oid = s.event_oid)
WHEN MATCHED
THEN
    UPDATE SET t.submitted = s.submitted
             WHERE DECODE (s.submitted, t.submitted, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Truncate Driver Tavle for QC Date */

TRUNCATE TABLE rax_app_user.yb_domino_driver

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Populate Driver Table */

INSERT INTO rax_app_user.yb_domino_driver
    (SELECT DISTINCT job_number
       FROM ODS_STAGE.LPIP_TRACKING_STG t, ods_own.apo a
      WHERE     t.JOB_NUMBER = a.LPIP_JOB_NUMBER
            -- DM-516 (JIRA Cancelled)
            AND a.COVER_RECEIVED IS NOT NULL
            AND a.FINALIZED_DATE IS NOT NULL
            AND t.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - 3/24
            AND NOT EXISTS
                    (SELECT a2.LPIP_JOB_NUMBER
                       FROM ods_own.apo a2, ods_own.event e
                      WHERE     a2.APO_OID = e.APO_OID
                            AND e.event_type = 'REORDER'
                            AND e.STATUS = '1'
                            AND a2.LPIP_JOB_NUMBER = t.JOB_NUMBER))

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Insert YB events into NULL Log Table */

INSERT INTO yb_domino_null_qc_log
    SELECT t.JOB_NUMBER,
           e.event_oid,
           t.TRACKING_PID,
           t.IN_DATE,
           dom.QUALITY_CHECK,
           r.REASON_CATEGORY,
           NVL (map.AREA, ext.area)     AS area,
           m.MATERIAL_CLASS,
           e.EVENT_TYPE,
           CAST (NULL AS DATE)          AS processed_date,
           SYSDATE                      AS ods_create_date
      FROM ODS_STAGE.LPIP_TRACKING_STG          t,
           RAX_APP_USER.YB_domino_driver        d,
           ODS_STAGE.LPIP_MATERIALS_STG         m,
           ODS_STAGE.LPIP_REMAKES_STG           r,
           ODS_STAGE.LPS_LAKE1_DEPT_YB_STG      map,
           ODS_STAGE.LPS_LAKE1_DEPT_YB_EXT_STG  ext,
           ODS_STAGE.YB_DOMINO_STG              dom,
           ods_own.event                        e,
           ods_own.apo                          a
     WHERE     t.JOB_NUMBER = d.JOB_NUMBER
           AND t.MATERIAL_CODE = m.MATERIAL_CODE
           AND t.JOB_NUMBER = r.JOB_NUMBER(+)
           AND t.PUB_YEAR = r.PUB_YEAR(+)
           AND t.SEQUENCE = r.SEQUENCE(+)
           AND t.RID = r.RID(+)
           AND t.DEPT = map.DEPT(+)
           AND t.PLANT = map.plant(+)
           AND t.DEPT = ext.DEPT(+)
           AND t.PLANT = ext.PLANT(+)
           AND t.JOB_NUMBER = a.LPIP_JOB_NUMBER
           AND a.APO_OID = e.APO_OID
           AND dom.EVENT_OID = e.EVENT_OID
           AND m.material_class IN ('G',
                                    'A',
                                    'ES',
                                    'CV',
                                    'E')
           AND NVL (r.REASON_CATEGORY, 'XX') NOT IN ('RR', 'RO', 'RP')
           AND NVL (map.AREA, ext.area) IN
                   ('DEV JOB HOLD', 'PREPRESS', 'YAS JOB HOLD')
           AND TRUNC (t.IN_DATE) > TRUNC (dom.QUALITY_CHECK)
           AND e.EVENT_TYPE = 'YEARBOOK'

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Flag YB Events to update */

UPDATE yb_domino_null_qc_log dr
   SET dr.PROCESSED_DATE = TO_DATE ('19000101', 'YYYYMMDD')
 WHERE dr.PROCESSED_DATE IS NULL


&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Update YB Events with NULL QC Date */

UPDATE ODS_STAGE.YB_DOMINO_STG d
   SET d.QUALITY_CHECK = NULL,
       d.QUALITY_CHECK_INHERIT = NULL,
       ods_modify_date = SYSDATE
 WHERE EXISTS
           (SELECT 1
              FROM yb_domino_null_qc_log dr
             WHERE     d.EVENT_OID = dr.EVENT_OID
                   AND dr.PROCESSED_DATE = TO_DATE ('19000101', 'YYYYMMDD'))

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Flag Updated YB Events */

UPDATE yb_domino_null_qc_log dr
   SET dr.PROCESSED_DATE = SYSDATE
 WHERE dr.PROCESSED_DATE = TO_DATE ('19000101', 'YYYYMMDD')

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Insert SUPL events into NULL Log Table */

INSERT INTO yb_domino_null_qc_log
SELECT t.JOB_NUMBER,
       e.event_oid,
       t.TRACKING_PID,
       t.IN_DATE,
       dom.QUALITY_CHECK,
       r.REASON_CATEGORY,
       NVL (map.AREA, ext.area)     AS area,
       m.MATERIAL_CLASS,
       e.EVENT_TYPE,
       CAST (NULL AS DATE)          AS processed_date,
       SYSDATE                      AS ods_create_date
  FROM ODS_STAGE.LPIP_TRACKING_STG          t,
       RAX_APP_USER.YB_domino_driver        d,
       ODS_STAGE.LPIP_MATERIALS_STG         m,
       ODS_STAGE.LPIP_REMAKES_STG           r,
       ODS_STAGE.LPS_LAKE1_DEPT_YB_STG      map,
       ODS_STAGE.LPS_LAKE1_DEPT_YB_EXT_STG  ext,
       ODS_STAGE.YB_DOMINO_STG              dom,
       ods_own.event                        e,
       ods_own.apo                          a
 WHERE     t.JOB_NUMBER = d.JOB_NUMBER
       AND t.MATERIAL_CODE = m.MATERIAL_CODE
       AND t.JOB_NUMBER = r.JOB_NUMBER(+)
       AND t.PUB_YEAR = r.PUB_YEAR(+)
       AND t.SEQUENCE = r.SEQUENCE(+)
       AND t.RID = r.RID(+)
       AND t.DEPT = map.DEPT(+)
       AND t.PLANT = map.plant(+)
       AND t.DEPT = ext.DEPT(+)
       AND t.PLANT = ext.PLANT(+)
       AND t.JOB_NUMBER = a.LPIP_JOB_NUMBER
       AND a.APO_OID = e.APO_OID
       AND dom.EVENT_OID = e.EVENT_OID
       AND m.material_class IN ('SP')
       AND NVL (r.REASON_CATEGORY, 'XX') NOT IN ('RR', 'RO', 'RP')
       AND NVL (map.AREA, ext.area) IN
               ('DEV JOB HOLD', 'PREPRESS', 'YAS JOB HOLD')
       AND TRUNC (t.IN_DATE) > TRUNC (dom.QUALITY_CHECK)
       AND e.EVENT_TYPE = 'SUPPLEMENT'

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Flag SUPL events to update */

UPDATE yb_domino_null_qc_log dr
   SET dr.PROCESSED_DATE = TO_DATE ('19000101', 'YYYYMMDD')
 WHERE dr.PROCESSED_DATE IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Update SUPL Events with NULL QC Date */

UPDATE ODS_STAGE.YB_DOMINO_STG d
   SET d.QUALITY_CHECK = NULL,
       d.QUALITY_CHECK_INHERIT = NULL,
       ods_modify_date = SYSDATE
 WHERE EXISTS
           (SELECT 1
              FROM yb_domino_null_qc_log dr
             WHERE     d.EVENT_OID = dr.EVENT_OID
                   AND dr.PROCESSED_DATE = TO_DATE ('19000101', 'YYYYMMDD'))

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Flag Updated SUPL Events */

UPDATE yb_domino_null_qc_log dr
   SET dr.PROCESSED_DATE = SYSDATE
 WHERE dr.PROCESSED_DATE = TO_DATE ('19000101', 'YYYYMMDD')

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Insert YB events into Set QC Log Table */

INSERT INTO yb_domino_set_qc_log
    SELECT t.JOB_NUMBER,
           e.event_oid,
           t.TRACKING_PID,
           t.IN_DATE,
           t.dept,
           NVL (map.AREA, ext.area)     AS area,
           m.MATERIAL_CLASS,
           t.SEQUENCE as seq,
           e.EVENT_TYPE,
           CAST (NULL AS DATE)          AS processed_date,
           SYSDATE                      AS ods_create_date
      FROM ODS_STAGE.LPIP_TRACKING_STG          t,
           RAX_APP_USER.YB_domino_driver        d,
           ODS_STAGE.LPIP_MATERIALS_STG         m,
           ODS_STAGE.LPS_LAKE1_DEPT_YB_STG      map,
           ODS_STAGE.LPS_LAKE1_DEPT_YB_EXT_STG  ext,
           ods_own.event                        e,
           ods_own.apo                          a
     WHERE     t.JOB_NUMBER = d.JOB_NUMBER
           AND t.MATERIAL_CODE = m.MATERIAL_CODE
           AND t.DEPT = map.DEPT(+)
           AND t.PLANT = map.plant(+)
           AND t.DEPT = ext.DEPT(+)
           AND t.PLANT = ext.PLANT(+)
           AND t.JOB_NUMBER = a.LPIP_JOB_NUMBER
           AND a.APO_OID = e.APO_OID
           AND m.material_class IN ('G',
                                    'A',
                                    'ES',
                                    'CV',
                                    'E')
           AND e.YB_COMPLETE_COPY_DATE IS NOT NULL
           AND e.EVENT_TYPE = 'YEARBOOK'
           AND NVL (map.AREA, ext.area) IN ('HOLD FOR RELEASE TO MFG')
           AND NOT EXISTS
                   (SELECT 1
                      FROM ODS_STAGE.LPIP_TRACKING_STG             tr1,
                           RAX_APP_USER.YB_domino_driver           d1,
                           RAX_APP_USER.LPS_LAKE1_DEPT_YB_STG      area_11,
                           RAX_APP_USER.LPS_LAKE1_DEPT_YB_EXT_STG  area_21
                     WHERE     tr1.JOB_NUMBER = d1.JOB_NUMBER
                           AND tr1.PLANT = area_11.PLANT(+)
                           AND tr1.DEPT = area_11.DEPT(+)
                           AND tr1.PLANT = area_21.PLANT(+)
                           AND tr1.DEPT = area_21.DEPT(+)
                           AND NVL (area_11.AREA, area_21.area) IN
                                   ('PREPRESS',
                                    'YAS JOB HOLD',
                                    'DEV JOB HOLD')
                           AND tr1.OUT_DATE IS NULL
                           AND t.JOB_NUMBER = tr1.JOB_NUMBER)

&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Flag Events to Update */

UPDATE yb_domino_set_qc_log dr
   SET dr.PROCESSED_DATE = TO_DATE ('19000101', 'YYYYMMDD')
 WHERE dr.PROCESSED_DATE IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Update YB events QC date */

MERGE INTO ODS_STAGE.YB_DOMINO_STG d
     USING (  SELECT event_oid, MAX (in_date) AS in_date
                FROM yb_domino_set_qc_log
               WHERE processed_date = TO_DATE ('19000101', 'YYYYMMDD')
            GROUP BY event_oid) s
        ON (d.event_oid = s.event_oid)
WHEN MATCHED
THEN
    UPDATE SET
        d.quality_check = s.in_date,
        d.quality_check_inherit = NULL,
        d.ods_modify_date = SYSDATE
             WHERE d.quality_check IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* Flag updated events */

UPDATE yb_domino_set_qc_log dr
   SET dr.PROCESSED_DATE = SYSDATE
 WHERE dr.PROCESSED_DATE = TO_DATE ('19000101', 'YYYYMMDD')

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* Insert SUPL events into Set QC Log Table */

INSERT INTO yb_domino_set_qc_log
    SELECT t.JOB_NUMBER,
           e.event_oid,
           t.TRACKING_PID,
           t.IN_DATE,
           t.dept,
           NVL (map.AREA, ext.area)     AS area,
           m.MATERIAL_CLASS,
           t.SEQUENCE                   AS seq,
           e.EVENT_TYPE,
           CAST (NULL AS DATE)          AS processed_date,
           SYSDATE                      AS ods_create_date
      FROM ODS_STAGE.LPIP_TRACKING_STG          t,
           RAX_APP_USER.YB_domino_driver        d,
           ODS_STAGE.LPIP_MATERIALS_STG         m,
           ODS_STAGE.LPS_LAKE1_DEPT_YB_STG      map,
           ODS_STAGE.LPS_LAKE1_DEPT_YB_EXT_STG  ext,
           ods_own.event                        e,
           ods_own.apo                          a
     WHERE     t.JOB_NUMBER = d.JOB_NUMBER
           AND t.MATERIAL_CODE = m.MATERIAL_CODE
           AND t.DEPT = map.DEPT(+)
           AND t.PLANT = map.plant(+)
           AND t.DEPT = ext.DEPT(+)
           AND t.PLANT = ext.PLANT(+)
           AND t.JOB_NUMBER = a.LPIP_JOB_NUMBER
           AND a.APO_OID = e.APO_OID
           AND m.material_class IN ('SP')
           AND e.YB_COMPLETE_COPY_DATE IS NOT NULL
           AND e.EVENT_TYPE = 'SUPPLEMENT'
           AND NVL (map.AREA, ext.area) IN ('HOLD FOR RELEASE TO MFG')
           AND NOT EXISTS
                   (SELECT 1
                      FROM ODS_STAGE.LPIP_TRACKING_STG             tr1,
                           RAX_APP_USER.YB_domino_driver           d1,
                           RAX_APP_USER.LPS_LAKE1_DEPT_YB_STG      area_11,
                           RAX_APP_USER.LPS_LAKE1_DEPT_YB_EXT_STG  area_21
                     WHERE     tr1.JOB_NUMBER = d1.JOB_NUMBER
                           AND tr1.PLANT = area_11.PLANT(+)
                           AND tr1.DEPT = area_11.DEPT(+)
                           AND tr1.PLANT = area_21.PLANT(+)
                           AND tr1.DEPT = area_21.DEPT(+)
                           AND NVL (area_11.AREA, area_21.area) IN
                                   ('PREPRESS',
                                    'YAS JOB HOLD',
                                    'DEV JOB HOLD')
                           AND tr1.OUT_DATE IS NULL
                           AND t.JOB_NUMBER = tr1.JOB_NUMBER)

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* Flag event to update */

UPDATE yb_domino_set_qc_log dr
   SET dr.PROCESSED_DATE = TO_DATE ('19000101', 'YYYYMMDD')
 WHERE dr.PROCESSED_DATE IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Update SUPL event QC date */

MERGE INTO ODS_STAGE.YB_DOMINO_STG d
     USING (  SELECT event_oid, MAX (in_date) AS in_date
                FROM yb_domino_set_qc_log
               WHERE processed_date = TO_DATE ('19000101', 'YYYYMMDD')
            GROUP BY event_oid) s
        ON (d.event_oid = s.event_oid)
WHEN MATCHED
THEN
    UPDATE SET
        d.quality_check = s.in_date,
        d.quality_check_inherit = NULL,
        d.ods_modify_date = SYSDATE
             WHERE d.quality_check IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* Flag updated events */

UPDATE yb_domino_set_qc_log dr
   SET dr.PROCESSED_DATE = SYSDATE
 WHERE dr.PROCESSED_DATE = TO_DATE ('19000101', 'YYYYMMDD')

&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* Drop tmp table */

drop table bb_wip_stg_curr

&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* Create and load tmp table */

create table bb_wip_stg_curr as
                     select * from ODS_STAGE.BB_WIP_STG
                     where ddate = to_char(trunc(sysdate),'YYYY-MM-DD')
                     AND componenttype = 'TEXT'

&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* Drop Domino_wip table */

drop table domino_wip

&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* Create and Load Domino_wip table */

CREATE TABLE domino_wip
AS
      SELECT wip.EVENT_OID, wip.COMPONENTSTATUS, MIN (wip.UPDATEDON) updatedon
        FROM (SELECT bb.*, ogp.ORDER_TYPE, ogp.EVENT_OID
                FROM BB_WIP_STG_curr bb, ODS_STAGE.OGP_ORDER_STG ogp
               WHERE     SUBSTR (bb.orderno,
                                 1,
                                   INSTR (bb.orderno,
                                          '.',
                                          1,
                                          2)
                                 - 1) = ogp.ORDER_NO
                     AND ogp.STATUS != 'CANCELED'
                     AND ogp.ORDER_TYPE != 'Cover') wip,
             ODS_STAGE.YB_DOMINO_STG dom,
             ods_own.event          e
       WHERE     1 = 1
             AND wip.EVENT_OID = dom.EVENT_OID
             AND wip.EVENT_OID = e.EVENT_OID
             AND e.SCHOOL_YEAR >= 2021
             AND componenttype = 'TEXT'
             AND componentstatus != 'CANCELLED'
             AND CASE
                     WHEN order_type = 'Order' AND itemcategoryno LIKE '%S1%'
                     THEN
                         1
                     WHEN order_type = 'Order' AND documentid = 'SUPPLEMENT'
                     THEN 1 
                     WHEN order_type = 'Remake'
                     THEN
                         1
                     ELSE
                         0
                 END =
                 1
    GROUP BY wip.EVENT_OID, wip.COMPONENTSTATUS

&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* Update Printing */

MERGE INTO ods_stage.YB_DOMINO_STG t
     USING (  SELECT ogp.EVENT_OID, MIN (ogp.AUDIT_CREATE_DATE) AS printing
                FROM ODS_STAGE.OGP_ORDER_STG ogp
               WHERE     1 = 1
                     AND ogp.STATUS NOT IN ('ERROR', 'CANCELED')
                     AND ogp.ORDER_TYPE = 'Order'
            GROUP BY ogp.event_oid) s
        ON (t.event_oid = s.event_oid)
WHEN MATCHED
THEN
    UPDATE SET
        t.printing = s.printing,
        t.ods_modify_date = SYSDATE,
        t.printing_inherit = NULL
             WHERE DECODE (t.printing, s.printing, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* Update Printed */

MERGE INTO ODS_STAGE.YB_DOMINO_STG t
     USING (  SELECT w.EVENT_OID, MIN (w.UPDATEDON) AS printed
                FROM domino_wip w, ODS_STAGE.YB_DOMINO_STG d
               WHERE     w.EVENT_OID = d.EVENT_OID
                     AND w.COMPONENTSTATUS IN ('PRINTED',
                                               'CC-CUT_COMPLETE',
                                               'CUT_COMPLETED',
                                               'CC-3_KNIFE')
            GROUP BY w.event_oid) s
        ON (t.event_oid = s.event_oid)
WHEN MATCHED
THEN
    UPDATE SET t.printed = s.printed, ods_modify_date = SYSDATE
             WHERE t.printed IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* Update Binding */

MERGE INTO ODS_STAGE.YB_DOMINO_STG t
     USING (  SELECT w.EVENT_OID, MIN (w.UPDATEDON) AS binding
                FROM domino_wip w, ODS_STAGE.YB_DOMINO_STG d
               WHERE     w.EVENT_OID = d.EVENT_OID
                     AND w.COMPONENTSTATUS IN  ('TA-SEWN',
                                           'BOUND',
                                           'BOUND-PERFECT_BOUND',
                                           'MC_ITEM_CONSOLIDATION',
                                           'FA-SADDLE_STICHED')
            GROUP BY w.event_oid) s
        ON (t.event_oid = s.event_oid)
WHEN MATCHED
THEN
    UPDATE SET t.binding = s.binding, ods_modify_date = SYSDATE
             WHERE t.binding IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 32 */
/* Update Preparing */

MERGE INTO ODS_STAGE.YB_DOMINO_STG t
     USING (  SELECT w.EVENT_OID, MIN (w.UPDATEDON) AS preparing
                FROM domino_wip w, ODS_STAGE.YB_DOMINO_STG d
               WHERE     w.EVENT_OID = d.EVENT_OID
                     AND w.COMPONENTSTATUS IN ('FA-STICKER_SMASHER',
                                           'FA-MITABOOK',
                                           'QC_COMPLETE',
                                           'OC',
                                           'BUNDLED',
                                           'INVENTORY',
                                           'PRE_SHIP')
            GROUP BY w.event_oid) s
        ON (t.event_oid = s.event_oid)
WHEN MATCHED
THEN
    UPDATE SET t.preparing = s.preparing, ods_modify_date = SYSDATE
             WHERE t.preparing IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 33 */
/* Update Shipping */

MERGE INTO ODS_STAGE.YB_DOMINO_STG t
     USING (  SELECT w.EVENT_OID, MIN (w.UPDATEDON) AS shipping
                FROM domino_wip w, ODS_STAGE.YB_DOMINO_STG d
               WHERE     w.EVENT_OID = d.EVENT_OID
                     AND w.COMPONENTSTATUS IN   (
                                           'SHIPPED',
                                           'MANIFESTED')
            GROUP BY w.event_oid) s
        ON (t.event_oid = s.event_oid)
WHEN MATCHED
THEN
    UPDATE SET t.shipping = s.shipping, ods_modify_date = SYSDATE
             WHERE t.shipping IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 34 */
/* Handle Cancelled Orders in BB */

MERGE INTO ods_stage.YB_DOMINO_STG t
     USING (  SELECT ogp.EVENT_OID,
                     SUM (
                         CASE
                             WHEN bb.COMPONENTSTATUS != 'CANCELLED' THEN 1
                             ELSE 0
                         END)
                         any_non_cancelled
                FROM ODS_STAGE.OGP_ORDER_STG ogp,
                     (SELECT *
                        FROM (SELECT bb.*,
                                     ROW_NUMBER ()
                                         OVER (
                                             PARTITION BY osk,
                                                          SUBSTR (
                                                              orderno,
                                                              1,
                                                                INSTR (orderno,
                                                                       '.',
                                                                       1,
                                                                       2)
                                                              - 1),
                                                          itemcategoryno,
                                                          facilityname,
                                                          componenttype
                                             ORDER BY ddate DESC)
                                         r
                                FROM ODS_STAGE.BB_WIP_STG bb)
                       WHERE     r = 1
                             AND componenttype = 'TEXT'
                             AND itemcategoryno LIKE '%S1%') bb
               WHERE SUBSTR (bb.orderno,
                             1,
                               INSTR (orderno,
                                      '.',
                                      1,
                                      2)
                             - 1) = ogp.ORDER_NO
            GROUP BY ogp.event_oid
              HAVING SUM (
                         CASE
                             WHEN bb.COMPONENTSTATUS != 'CANCELLED' THEN 1
                             ELSE 0
                         END) =
                     0) s
        ON (t.event_oid = s.event_oid)
WHEN MATCHED
THEN
    UPDATE SET
        t.printed = NULL,
        t.binding = NULL,
        t.preparing = NULL,
        t.shipping = NULL,
        t.ods_modify_date = SYSDATE
             WHERE    t.printed IS NOT NULL
                   OR t.binding IS NOT NULL
                   OR t.preparing IS NOT NULL
                   OR t.shipping IS NOT NULL

&


/*-----------------------------------------------*/
/* TASK No. 35 */
/* Handle Cancelled OGP Orders */

MERGE INTO ods_stage.YB_DOMINO_STG t
     USING (  SELECT event_oid,
                     SUM (CASE WHEN s.status != 'CANCELED' THEN 1 ELSE 0 END)
                         AS any_non_canceled
                FROM ODS_STAGE.OGP_ORDER_STG s
               WHERE s.ORDER_TYPE = 'Order'
            GROUP BY event_oid
              HAVING SUM (CASE WHEN s.status != 'CANCELED' THEN 1 ELSE 0 END) =
                     0) s
        ON (t.event_oid = s.event_oid)
WHEN MATCHED
THEN
    UPDATE SET t.printing = NULL, ods_modify_date = SYSDATE
             WHERE t.printing IS NOT NULL

&


/*-----------------------------------------------*/
/* TASK No. 36 */
/* Update Last ETL Run Date */

update ODS_STAGE.YB_DOMINO_STG
set last_etl_run_date = sysdate

&


/*-----------------------------------------------*/
/* TASK No. 37 */
/* Shipping Inherit */

UPDATE ODS_STAGE.YB_DOMINO_STG
   SET shipping = delivered,
       shipping_inherit = 'Y',
       ods_modify_date = SYSDATE
 WHERE delivered IS NOT NULL AND shipping IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 38 */
/* Preparing_Inherit */

UPDATE ODS_STAGE.YB_DOMINO_STG
   SET preparing = shipping,
       preparing_inherit = 'Y',
       ods_modify_date = SYSDATE
 WHERE shipping IS NOT NULL AND preparing IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 39 */
/* Binding Inherit */

UPDATE ODS_STAGE.YB_DOMINO_STG
   SET binding = preparing,
       binding_inherit = 'Y',
       ods_modify_date = SYSDATE
 WHERE preparing IS NOT NULL AND binding IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 40 */
/* Printed Inherit */

UPDATE ODS_STAGE.YB_DOMINO_STG
   SET printed = binding,
       printed_inherit = 'Y',
       ods_modify_date = SYSDATE
 WHERE binding IS NOT NULL AND printed IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 41 */
/* Printing Inherit */

UPDATE ODS_STAGE.YB_DOMINO_STG
   SET printing = printed,
       printing_inherit = 'Y',
       ods_modify_date = SYSDATE
 WHERE printed IS NOT NULL AND printing IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 42 */
/* Quality Check Inherit */

UPDATE ODS_STAGE.YB_DOMINO_STG
   SET quality_check = printing,
       quality_check_inherit = 'Y',
       ods_modify_date = SYSDATE
 WHERE printing IS NOT NULL AND quality_check IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 43 */
/* Submitted Inherit */

-- DM-516 (Cancelled)
UPDATE ODS_STAGE.YB_DOMINO_STG
   SET submitted = quality_check,
       submitted_inherit = 'Y',
       ods_modify_date = SYSDATE
 WHERE quality_check IS NOT NULL AND submitted IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 44 */
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
/* TASK No. 45 */
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
,'99_YB_DOMINOS_PIZZA_TRACKER_PKG'
,'013'
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
'99_YB_DOMINOS_PIZZA_TRACKER_PKG',
'013',
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
