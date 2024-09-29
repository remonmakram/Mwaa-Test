SELECT oh.job_number, oh.subject_first_name, p.cust_email_address,
       oh.audit_create_date, oh.payment_voucher_id, oh.order_type
  FROM mlt_own.payment p,
       mlt_own.payment_attempt pa,
       mlt_own.mlt_order oh,
       mlt_own.order_line ol,
       mlt_own.order_promotions op,
       mlt_own.order_line_promotions olp
 WHERE pa.payment_id = p.payment_id
   AND oh.payment_id = p.payment_id
   AND oh.order_id = ol.order_id
   AND oh.order_id = op.order_id(+)
   AND ol.order_line_id = olp.order_line_id(+)
   -- Include only Approved Payments
   AND pa.payment_status = 'APPROVED'
   -- Include payments on Spec orders (order not sent to OMS)
   AND (oh.order_type = 'PAYMENT' OR oh.posted_date IS NOT NULL)
   -- Exclude DSSK orders
   AND (   oh.payment_amount > 0
        OR op.promotion_id IS NOT NULL
        OR olp.promotion_id IS NOT NULL
       )
   AND oh.audit_create_date BETWEEN TRUNC (TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS'))
                                AND   TRUNC (SYSDATE)
                                    - 1 / (24 * 60 * 60)