/* TASK No. 1 */
/* Drop Temp Reporting Table */

/* drop table pas_data_for_qlik_temp */

BEGIN
    EXECUTE IMMEDIATE 'drop table pas_data_for_qlik_temp';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 2 */
/* Create Temp Reporting Table */
/* Formatted on 2018/01/11 11:13 (Formatter Plus v4.8.8) */



CREATE TABLE pas_data_for_qlik_temp AS
SELECT org.business_unit_name, org.region_name, org.area_name,
       a.territory_code, a.school_year, a.apo_id, a.lifetouch_id,
       a.description account_name, e.event_ref_id,
       sp.sub_program_name,
       CASE
          WHEN e.event_type = 'ORIGINAL_SENIOR'
             THEN 'ORIGINAL'
          ELSE e.event_type
       END AS event_type,
       e.photography_date AS photography_date, co.customer_order_oid,
       s.subject_oid, s.first_name, s.last_name, appt.appointment_oid,
       appt.status, co.order_number, co.audit_created_by,
       CASE
          WHEN co.audit_created_by = 'sas'
             THEN 1
          ELSE 0
       END AS order_created_by_pas,
       CASE
          WHEN co.audit_created_by != 'sas'
             THEN 1
          ELSE 0
       END AS order_created_by_fow,
       opromo.promotion_code opromo_sas_num,
       opromo.item_number opromo_oms_num,
       opromo_item.short_description AS opromo_item_desc,
       NVL (opromo.discount_amount * -1, 0) AS opromo_discount_amount,
       ol.item_number, NVL (ol.quantity, 0) AS quantity,
       NVL (ol.price, 0) AS price, i.short_description, i.description,
       i.product_line line_product_line,
       lpromo.promotion_code AS lpromo_sas_num,
       lpromo.item_number AS lpromo_oms_num,
       lpromo_item.short_description AS lpromo_item_desc,
       NVL (lpromo.discount_amount * -1, 0) AS lpromo_discount_amount,
       NVL (pay.amount, 0) payment,
       CASE
          WHEN pay.payment_method = 'CreditCard'
          AND pay.authorization_code IS NOT NULL
             THEN 'CreditCard'
          WHEN pay.payment_method = 'PayPal'
          AND pay.payment_service_id IS NOT NULL
             THEN 'PayPal'
       END AS payment_method,
       CASE
          WHEN co.customer_order_oid IS NOT NULL
             THEN CAST
                     ('SIT_ONLY' AS VARCHAR2 (10))
          ELSE CAST (NULL AS VARCHAR2 (10))
       END AS order_has_add_on,
       CASE
          WHEN appt.status = 'C'
             THEN 1
          ELSE 0
       END AS confirmed,
       CASE
          WHEN appt.status = 'S'
             THEN 1
          ELSE 0
       END AS scheduled, CAST (0 AS NUMBER) AS self_scheduled,
       CASE
          WHEN NVL (pay.amount, 0) > 0
             THEN 1
          ELSE 0
       END AS pay_online,
       CASE
          WHEN NVL (pay.amount, 0) > 0
             THEN 1
          ELSE 0
       END AS pay_online_flag,
       CASE
          WHEN NVL (pay.amount, 0) = 0
             THEN 1
          ELSE 0
       END AS pay_at_session,
       CASE
          WHEN NVL (pay.amount, 0) = 0
             THEN 1
          ELSE 0
       END AS pay_at_session_flag,
       CASE
          WHEN pay.payment_method = 'CreditCard'
          AND pay.authorization_code IS NOT NULL
             THEN 1
          ELSE 0
       END AS credit_card,
       CASE
          WHEN pay.payment_method = 'CreditCard'
          AND pay.authorization_code IS NOT NULL
             THEN 1
          ELSE 0
       END AS credit_card_flag,
       CASE
          WHEN pay.payment_method = 'PayPal'
          AND pay.payment_service_id IS NOT NULL
             THEN 1
          ELSE 0
       END AS paypal,
       CASE
          WHEN pay.payment_method = 'PayPal'
          AND pay.payment_service_id IS NOT NULL
             THEN 1
          ELSE 0
       END AS paypal_flag,
       CAST (0 AS NUMBER) AS conf_no_sit,
       CAST (0 AS NUMBER) AS sit_only,
       CAST (0 AS NUMBER) AS sit_w_add_on,
       CAST (0 AS NUMBER) AS promo_count,
       CAST (0 AS NUMBER) AS latest_is_confirmed,
       CAST (0 AS NUMBER) AS photographed_ind,
       SYSDATE AS ods_create_date
  FROM ods_own.apo a,
       ods_own.sub_program sp,
       ods_own.organization_vw org,
       ods_own.event e,
       ods_own.picture_day pd,
       ods_own.appointment_slot slot,
       ods_own.appointment appt,
       ods_own.subject s,
       ods_own.sas_customer_order co,
       ods_own.sas_customer_order_line ol,
       ods_own.item i,
       ods_own.sas_customer_order_promotion opromo,
       ods_own.item opromo_item,
       ods_own.sas_customer_order_line_promo lpromo,
       ods_own.item lpromo_item,
       ods_own.sas_payment pay
 WHERE a.apo_oid = e.apo_oid
   AND a.sub_program_oid = sp.sub_program_oid
   AND a.territory_code = org.territory_code
   AND e.event_oid = pd.event_oid
   AND pd.picture_day_oid = slot.picture_day_oid
   AND slot.appointment_slot_oid = appt.appointment_slot_oid
   AND appt.subject_oid = s.subject_oid
   AND appt.appointment_oid = co.appointment_oid(+)
   AND co.customer_order_oid = ol.customer_order_oid(+)
   AND ol.item_number = i.item_id(+)
   AND co.customer_order_oid = opromo.customer_order_oid(+)
   AND opromo.item_number = opromo_item.item_id(+)
   AND ol.customer_order_line_oid = lpromo.customer_order_line_oid(+)
   AND lpromo.item_number = lpromo_item.item_id(+)
   AND co.customer_order_oid = pay.customer_order_oid(+)
   AND appt.status NOT IN ('X', 'U')
   AND a.status = 'Active'
   AND s.active = 1
   AND NVL (co.deleted_ind(+), 'N') != 'Y'
   AND NVL (ol.deleted_ind(+), 'N') != 'Y'
   AND NVL (opromo.deleted_ind(+), 'N') != 'Y'
   AND NVL (lpromo.deleted_ind(+), 'N') != 'Y'
   AND (   pay.payment_oid IS NULL
        OR (    pay.payment_method = 'CreditCard'
            AND pay.authorization_code IS NOT NULL
           )
        OR (    pay.payment_method = 'PayPal'
            AND pay.payment_service_id IS NOT NULL
           )
       )
   AND a.school_year >= EXTRACT (YEAR FROM SYSDATE) - 3
UNION ALL
SELECT org.business_unit_name, org.region_name, org.area_name,
       a.territory_code, a.school_year, a.apo_id, a.lifetouch_id,
       a.description account_name, e.event_ref_id,
       sp.sub_program_name,
       CASE
          WHEN e.event_type = 'ORIGINAL_SENIOR'
             THEN 'ORIGINAL'
          ELSE e.event_type
       END AS event_type,
       e.photography_date AS photography_date, co.customer_order_oid,
       s.subject_oid, s.first_name, s.last_name, appt.appointment_oid,
       appt.status, co.order_number, co.audit_created_by,
       CASE
          WHEN co.audit_created_by = 'sas'
             THEN 1
          ELSE 0
       END AS order_created_by_pas,
       CASE
          WHEN co.audit_created_by != 'sas'
             THEN 1
          ELSE 0
       END AS order_created_by_fow,
       opromo.promotion_code opromo_sas_num,
       opromo.item_number opromo_oms_num,
       opromo_item.short_description AS opromo_item_desc,
       NVL (opromo.discount_amount * -1, 0) AS opromo_discount_amount,
       ol.item_number, NVL (ol.quantity, 0) AS quantity,
       NVL (ol.price, 0) AS price, i.short_description, i.description,
       i.product_line line_product_line,
       lpromo.promotion_code AS lpromo_sas_num,
       lpromo.item_number AS lpromo_oms_num,
       lpromo_item.short_description AS lpromo_item_desc,
       NVL (lpromo.discount_amount * -1, 0) AS lpromo_discount_amount,
       NVL (pay.amount, 0) payment,
       CASE
          WHEN pay.payment_method = 'CreditCard'
          AND pay.authorization_code IS NOT NULL
             THEN 'CreditCard'
          WHEN pay.payment_method = 'PayPal'
          AND pay.payment_service_id IS NOT NULL
             THEN 'PayPal'
       END AS payment_method,
       CASE
          WHEN co.customer_order_oid IS NOT NULL
             THEN CAST
                     ('SIT_ONLY' AS VARCHAR2 (10))
          ELSE CAST (NULL AS VARCHAR2 (10))
       END AS order_has_add_on,
       CASE
          WHEN appt.status = 'C'
             THEN 1
          ELSE 0
       END AS confirmed, 0 AS scheduled,
       CASE
          WHEN appt.status = 'S'
             THEN 1
          ELSE 0
       END AS self_scheduled,
       CASE
          WHEN NVL (pay.amount, 0) > 0
             THEN 1
          ELSE 0
       END AS pay_online,
       CASE
          WHEN NVL (pay.amount, 0) > 0
             THEN 1
          ELSE 0
       END AS pay_online_flag,
       CASE
          WHEN NVL (pay.amount, 0) = 0
             THEN 1
          ELSE 0
       END AS pay_at_session,
       CASE
          WHEN NVL (pay.amount, 0) = 0
             THEN 1
          ELSE 0
       END AS pay_at_session_flag,
       CASE
          WHEN pay.payment_method = 'CreditCard'
          AND pay.authorization_code IS NOT NULL
             THEN 1
          ELSE 0
       END AS credit_card,
       CASE
          WHEN pay.payment_method = 'CreditCard'
          AND pay.authorization_code IS NOT NULL
             THEN 1
          ELSE 0
       END AS credit_card_flag,
       CASE
          WHEN pay.payment_method = 'PayPal'
          AND pay.payment_service_id IS NOT NULL
             THEN 1
          ELSE 0
       END AS paypal,
       CASE
          WHEN pay.payment_method = 'PayPal'
          AND pay.payment_service_id IS NOT NULL
             THEN 1
          ELSE 0
       END AS paypal_flag,
       CAST (0 AS NUMBER) AS conf_no_sit,
       CAST (0 AS NUMBER) AS sit_only,
       CAST (0 AS NUMBER) AS sit_w_add_on,
       CAST (0 AS NUMBER) AS promo_count,
       CAST (0 AS NUMBER) AS latest_is_confirmed,
       CAST (0 AS NUMBER) AS photographed_ind,
       SYSDATE AS ods_create_date
  FROM ods_own.apo a,
       ods_own.sub_program sp,
       ods_own.organization_vw org,
       ods_own.event e,
       ods_own.appointment appt,
       ods_own.subject s,
       ods_own.sas_customer_order co,
       ods_own.sas_customer_order_line ol,
       ods_own.item i,
       ods_own.sas_customer_order_promotion opromo,
       ods_own.sas_customer_order_line_promo lpromo,
       ods_own.item opromo_item,
       ods_own.item lpromo_item,
       ods_own.sas_payment pay
 WHERE a.apo_oid = e.apo_oid
   AND a.sub_program_oid = sp.sub_program_oid
   AND a.territory_code = org.territory_code
   AND e.event_oid = appt.event_oid
   AND appt.subject_oid = s.subject_oid
   AND appt.appointment_oid = co.appointment_oid(+)
   AND co.customer_order_oid = ol.customer_order_oid(+)
   AND ol.item_number = i.item_id(+)
   AND co.customer_order_oid = opromo.customer_order_oid(+)
   AND opromo.item_number = opromo_item.item_id(+)
   AND ol.customer_order_line_oid = lpromo.customer_order_line_oid(+)
   AND lpromo.item_number = lpromo_item.item_id(+)
   AND co.customer_order_oid = pay.customer_order_oid(+)
   AND appt.status NOT IN ('X', 'U')
   AND appt.appointment_slot_oid IS NULL
   AND s.active = 1
   AND NVL (co.deleted_ind(+), 'N') != 'Y'
   AND NVL (ol.deleted_ind(+), 'N') != 'Y'
   AND NVL (opromo.deleted_ind(+), 'N') != 'Y'
   AND NVL (lpromo.deleted_ind(+), 'N') != 'Y'
   AND (   pay.payment_oid IS NULL
        OR (    pay.payment_method = 'CreditCard'
            AND pay.authorization_code IS NOT NULL
           )
        OR (    pay.payment_method = 'PayPal'
            AND pay.payment_service_id IS NOT NULL
           )
       )
   AND a.school_year >= EXTRACT (YEAR FROM SYSDATE) - 3

&

/*-----------------------------------------------*/
/* TASK No. 3 */
/* Update Order_has_Add_On_Flag */



MERGE INTO pas_data_for_qlik_temp t
   USING (SELECT DISTINCT customer_order_oid
                     FROM pas_data_for_qlik_temp temp
                    WHERE customer_order_oid IS NOT NULL
                      AND line_product_line = 'Charges') s
   ON (t.customer_order_oid = s.customer_order_oid)
   WHEN MATCHED THEN
      UPDATE
         SET order_has_add_on = 'ADD_ON'

&

/*-----------------------------------------------*/
/* TASK No. 4 */
/* Update conf_no_sit */



UPDATE pas_data_for_qlik_temp
   SET conf_no_sit = 1
 WHERE status = 'C' AND customer_order_oid IS NULL

&

/*-----------------------------------------------*/
/* TASK No. 5 */
/* Update sit_only */



UPDATE pas_data_for_qlik_temp
   SET sit_only = 1
 WHERE order_has_add_on = 'SIT_ONLY'

&

/*-----------------------------------------------*/
/* TASK No. 6 */
/* Update sit_w_add_on */



UPDATE pas_data_for_qlik_temp
   SET sit_w_add_on = 1
 WHERE order_has_add_on = 'ADD_ON'

&

/*-----------------------------------------------*/
/* TASK No. 7 */
/* Update latest_is_confirmed */



MERGE INTO pas_data_for_qlik_temp t
   USING (SELECT   a.subject_oid, MIN (a.status) status
              FROM (SELECT q.subject_oid, appt.status,
                           appt.audit_modify_date
                      FROM pas_data_for_qlik_temp q,
                           ods_own.appointment appt
                     WHERE q.subject_oid = appt.subject_oid
                       AND appt.status NOT IN ('X', 'U')) a,
                   (SELECT   subject_oid,
                             MAX (audit_modify_date)
                                                    audit_modify_date
                        FROM ods_own.appointment
                       WHERE status NOT IN ('X', 'U')
                    GROUP BY subject_oid) b
             WHERE a.subject_oid = b.subject_oid
               AND a.audit_modify_date = b.audit_modify_date
            HAVING MIN (a.status) = 'C'
          GROUP BY a.subject_oid) s
   ON (s.subject_oid = t.subject_oid)
   WHEN MATCHED THEN
      UPDATE
         SET latest_is_confirmed = 1

&

/*-----------------------------------------------*/
/* TASK No. 8 */
/* Drop Photographed Driver Table */

/* drop table pas_subject_driver */

BEGIN
    EXECUTE IMMEDIATE 'drop table pas_subject_driver';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 9 */
/* Create Photographed Driver Table */



CREATE TABLE pas_subject_driver
AS
SELECT DISTINCT external_subject_id, s.subject_oid FROM pas_data_for_qlik_temp t, ods_own.subject s
WHERE t.subject_oid = s.subject_oid

&

/*-----------------------------------------------*/
/* TASK No. 10 */
/* Update Photographed_Ind */



MERGE INTO pas_data_for_qlik_temp t
   USING (SELECT   dr.subject_oid, SUM (occurs)
              FROM mart.subject_activity_fact saf,
                   mart.pipeline_status ps,
                   mart.subject s,
                   mart.marketing m,
                   pas_subject_driver dr
             WHERE saf.pipeline_status_id = ps.pipeline_status_id
               AND saf.subject_id = s.subject_id
               AND saf.marketing_id = m.marketing_id
               AND s.extn_subject_id = dr.external_subject_id
               AND m.program_name = 'Seniors'
               AND ps.photograph_status = 'Photographed'
            --      and S.SUBJECT_OID = 347689802
          HAVING   SUM (occurs) = 1
          GROUP BY dr.subject_oid) s
   ON (t.subject_oid = s.subject_oid)
   WHEN MATCHED THEN
      UPDATE
         SET photographed_ind = 1

&

/*-----------------------------------------------*/
/* TASK No. 11 */
/* Rollup to Order Header level */



UPDATE pas_data_for_qlik_temp
   SET order_created_by_pas = 0,
       order_created_by_fow = 0,
       pay_online = 0,
       pay_at_session = 0,
       credit_card = 0,
       paypal = 0,
       sit_only = 0,
       sit_w_add_on = 0,
       payment = 0,
       opromo_discount_amount = 0
 WHERE ROWID NOT IN (SELECT   MIN (ROWID)
                         FROM pas_data_for_qlik_temp
                     GROUP BY customer_order_oid)

&

/*-----------------------------------------------*/
/* TASK No. 12 */
/* Rollup to Subject Appointment level */



UPDATE pas_data_for_qlik_temp
   SET confirmed = 0,
       scheduled = 0,
       conf_no_sit = 0
 WHERE ROWID NOT IN (SELECT   MIN (ROWID)
                         FROM pas_data_for_qlik_temp
                     GROUP BY subject_oid, appointment_oid)

&

/*-----------------------------------------------*/
/* TASK No. 13 */
/* Rollup to Subject level */



UPDATE pas_data_for_qlik_temp
   SET latest_is_confirmed = 0,
         photographed_ind = 0
 WHERE ROWID NOT IN (SELECT   MIN (ROWID)
                         FROM pas_data_for_qlik_temp
                     GROUP BY subject_oid)

&

/*-----------------------------------------------*/
/* TASK No. 14 */
/* Update promo_count */



UPDATE pas_data_for_qlik_temp
   SET promo_count = 1
 WHERE opromo_discount_amount <> 0 OR lpromo_discount_amount <> 0

&

/*-----------------------------------------------*/
/* TASK No. 15 */
/* Update pay_at_session_* columns */



UPDATE pas_data_for_qlik_temp
   SET pay_at_session = 0,
       pay_at_session_flag = 0
 WHERE customer_order_oid IS NULL

&

/*-----------------------------------------------*/
/* TASK No. 16 */
/* Drop reporting table */

drop table pas_data_for_qlik

&

/*-----------------------------------------------*/
/* TASK No. 17 */
/* Rename temp table to reporting table */



ALTER TABLE pas_data_for_qlik_temp RENAME TO pas_data_for_qlik

&

/*-----------------------------------------------*/
/* TASK No. 18 */
/* Grant Privs */



GRANT SELECT ON pas_data_for_qlik TO ODS_USER

&

/*-----------------------------------------------*/
/* TASK No. 19 */
/* Grant privs 2 */



-- GRANT SELECT ON RAX_APP_USER.PAS_DATA_FOR_QLIK TO gdhankhar

-- &

/*-----------------------------------------------*/
