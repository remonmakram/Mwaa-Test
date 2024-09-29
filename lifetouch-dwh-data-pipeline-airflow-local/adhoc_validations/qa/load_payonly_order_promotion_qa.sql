 SELECT   *
 FROM RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT R_CDC
 WHERE SESS_NAME IN ('LOAD_PAYONLY_ORDER_PROMOTION_PKG')
  AND CREATE_DATE > SYSDATE - INTERVAL '1600' MINUTE


SELECT   (O_CDC.LAST_CDC_COMPLETION_DATE-R_CDC.ORIG_LAST_CDC_COMPLETION_DATE ) * 1440 AS minutes_difference ,R_CDC.*, O_CDC.LAST_CDC_COMPLETION_DATE
 FROM RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT R_CDC
 LEFT JOIN ods_own.ods_cdc_load_status O_CDC
 ON R_CDC.TABLE_NAME  = O_CDC.ODS_TABLE_NAME
 WHERE SESS_NAME IN ('LOAD_PAYONLY_ORDER_PROMOTION_PKG')
--  AND CREATE_DATE > SYSDATE - INTERVAL '60' MINUTE
  ORDER BY SESS_BEG DESC


 ------------------------------------------ Validate Data for the PKG --------------------------------------------------------------------------------

  SELECT max(ods_modify_date) FROM ODS_OWN.payonly_order_promotion
--  MAX(ODS_MODIFY_DATE)|
----------------------+
-- 2024-07-24 12:53:14|


  UPDATE ods_own.ods_cdc_load_status
SET last_cdc_completion_date = TO_DATE(SUBSTR('2020-04-01 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
WHERE ods_table_name= 'PAYONLY_ORDER_PROMOTION'

-- run the dag

  SELECT max(ods_modify_date) FROM ODS_OWN.payonly_order_promotion

--  MAX(ODS_MODIFY_DATE)|
----------------------+
-- 2024-08-08 07:06:18|

  SELECT sysdate FROM dual
--  SYSDATE            |
---------------------+
--2024-08-08 07:07:00|

  ----------------------------------------------------
   select p.order_id, p.item_oid, p2.event_payment_oid, p.amount as discount_amt, p.promotion_code, p.coupon_code
   from tmp_payonly_order_promo p
   , tmp_payonly_order_promo2 p2
   where p.order_id = p2.order_id

  select
    ep.event_payment_oid, mo.order_id
from
 tmp_payonly_order_promo p
, ODS_OWN.event_payment ep
, ODS_OWN.event e
, ODS_STAGE.wc_event_payment_xr2 epxr
, ODS_STAGE.wc_bank_entry_stg be
, ODS.mlt_mlt_order_curr mo
where 1=1
and ep.event_oid = e.event_oid
and ep.event_payment_oid = epxr.event_payment_oid
and epxr.bank_entry_id = be.bank_entry_id
and regexp_replace(regexp_replace(be.source_system_key, '-.*'),'[^0-9]') = mo.order_id
and e.event_ref_id = p.job_number
and mo.order_id = p.order_id
group by ep.event_payment_oid, mo.order_id


TRUNCATE TABLE tmp_payonly_order_promo

  insert into tmp_payonly_order_promo
(
   order_id
   ,item_oid
   ,job_number
   ,amount
   ,promotion_code
   ,coupon_code
)
select order_id, item_oid, job_number, amount, promotion_code, coupon_code
from (
            select mo.order_id, null as item_oid, mo.job_number, p.amount, p.promotion_code, p.coupon_code
            from ODS.mlt_mlt_order_curr mo
             , ODS.mlt_order_promotions_curr op
            , ODS_STAGE.mlt_promotion_stg p
             where mo.effective_date > TO_DATE(SUBSTR('2020-04-01 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
             and mo.selling_method_name = 'SPEC'
             and mo.order_id = op.order_id
             and op.promotion_id = p.promotion_id
             union
             select ol.order_id, item.item_oid, mo.job_number, p.amount, p.promotion_code, p.coupon_code
             from ODS.mlt_mlt_order_curr mo
             , ODS.mlt_order_line_curr ol
             , ODS.mlt_order_line_promos_curr op
             , ODS_STAGE.mlt_promotion_stg p
              , ODS_OWN.item item
              where mo.effective_date > TO_DATE(SUBSTR('2020-04-01 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
              and mo.selling_method_name = 'SPEC'
              and mo.order_id = ol.order_id
              and ol.order_line_id = op.order_line_id
              and op.promotion_id = p.promotion_id
              and ol.sku_code = item.item_id(+)
) s


   select mo.order_id, null as item_oid, mo.job_number, p.amount, p.promotion_code, p.coupon_code
            from ODS.mlt_mlt_order_curr mo
             , ODS.mlt_order_promotions_curr op
            , ODS_STAGE.mlt_promotion_stg p
             where mo.effective_date > TO_DATE(SUBSTR('2024-04-01 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
             and mo.selling_method_name = 'SPEC'
             and mo.order_id = op.order_id
             and op.promotion_id = p.promotion_id
             union
             select ol.order_id, item.item_oid, mo.job_number, p.amount, p.promotion_code, p.coupon_code
             from ODS.mlt_mlt_order_curr mo
             , ODS.mlt_order_line_curr ol
             , ODS.mlt_order_line_promos_curr op
             , ODS_STAGE.mlt_promotion_stg p
              , ODS_OWN.item item
              where mo.effective_date > TO_DATE(SUBSTR('2024-04-01 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
              and mo.selling_method_name = 'SPEC'
              and mo.order_id = ol.order_id
              and ol.order_line_id = op.order_line_id
              and op.promotion_id = p.promotion_id
              and ol.sku_code = item.item_id(+)


  select mo.order_id, null as item_oid, mo.job_number, p.amount, p.promotion_code, p.coupon_code ,mo.effective_date
            from ODS.mlt_mlt_order_curr mo
             , ODS.mlt_order_promotions_curr op
            , ODS_STAGE.mlt_promotion_stg p
             where mo.effective_date > TO_DATE(SUBSTR('2023-08-08 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
             and mo.selling_method_name = 'SPEC'
             and mo.order_id = op.order_id
             and op.promotion_id = p.promotion_id
             ORDER BY mo.effective_date DESC


             union
             select ol.order_id, item.item_oid, mo.job_number, p.amount, p.promotion_code, p.coupon_code,mo.effective_date
             from ODS.mlt_mlt_order_curr mo
             , ODS.mlt_order_line_curr ol
             , ODS.mlt_order_line_promos_curr op
             , ODS_STAGE.mlt_promotion_stg p
              , ODS_OWN.item item
              where mo.effective_date > TO_DATE(SUBSTR('2023-08-08 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
              and mo.selling_method_name = 'SPEC'
              and mo.order_id = ol.order_id
              and ol.order_line_id = op.order_line_id
              and op.promotion_id = p.promotion_id
              and ol.sku_code = item.item_id(+)
              ORDER BY mo.effective_date desc


  select
    ep.event_payment_oid, mo.order_id
from
 tmp_payonly_order_promo p
, ODS_OWN.event_payment ep
, ODS_OWN.event e
, ODS_STAGE.wc_event_payment_xr2 epxr
, ODS_STAGE.wc_bank_entry_stg be
, ODS.mlt_mlt_order_curr mo
where 1=1
and ep.event_oid = e.event_oid
and ep.event_payment_oid = epxr.event_payment_oid
and epxr.bank_entry_id = be.bank_entry_id
and regexp_replace(regexp_replace(be.source_system_key, '-.*'),'[^0-9]') = mo.order_id
and e.event_ref_id = p.job_number
and mo.order_id = p.order_id
group by ep.event_payment_oid, mo.order_id


  select p.order_id, p.item_oid, p2.event_payment_oid, p.amount as discount_amt, p.promotion_code, p.coupon_code
   from tmp_payonly_order_promo p
   , tmp_payonly_order_promo2 p2
   where p.order_id = p2.order_id