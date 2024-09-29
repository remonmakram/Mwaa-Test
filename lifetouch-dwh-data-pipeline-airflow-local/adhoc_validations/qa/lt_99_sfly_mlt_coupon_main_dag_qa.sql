SELECT * FROM ODS_OWN.ODS_CDC_LOAD_STATUS
WHERE ODS_TABLE_NAME = 'SFLY_COUPON_MLT_V2_TMP'
--ODS_TABLE_NAME        |LAST_CDC_COMPLETION_DATE|CONTEXT_NAME|TIMEZONE_OFFSET|
------------------------+------------------------+------------+---------------+
--SFLY_COUPON_MLT_V2_TMP|     2024-09-02 06:57:43|QA          |               |

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET last_cdc_completion_date = TO_DATE(SUBSTR('2024-07-31 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
WHERE ods_table_name= 'SFLY_COUPON_MLT_V2_TMP'

-- run the dag

-- CHECK the files


SELECT count(*)
from	RAX_APP_USER.SFLY_COUPON_V2_TMP   SFLY_COUPON_V2_TMP

--COUNT(*)|
----------+
--   12384|

SELECT * FROM ODS_OWN.ODS_CDC_LOAD_STATUS
WHERE ODS_TABLE_NAME = 'SFLY_COUPON_MLT_V2_TMP'

--ODS_TABLE_NAME        |LAST_CDC_COMPLETION_DATE|CONTEXT_NAME|TIMEZONE_OFFSET|
------------------------+------------------------+------------+---------------+
--SFLY_COUPON_MLT_V2_TMP|     2024-09-02 09:26:02|QA          |               |

-----------------------------------------
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
   AND oh.audit_create_date BETWEEN TO_DATE(SUBSTR('2024-08-03 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
                                AND   TRUNC (SYSDATE)
                                    - 1 / (24 * 60 * 60)


SELECT DISTINCT tmp.subject_first_name,
       tmp.cust_email_address,
       tmp.payment_voucher_id,
       TO_CHAR (tmp.audit_create_date, 'MM/DD/YYYY')     AS audit_create_date,
       acct.STATE,
       a.SCHOOL_YEAR,
       sp.SUB_PROGRAM_NAME                               AS sub_program,
       tmp.order_type,
       TO_CHAR(e.photography_date,'MM/DD/YYYY') AS photography_date
  FROM rax_app_user.sfly_coupon_mlt_v2_tmp  tmp,
       ods_own.event                        e,
       ods_own.apo                          a,
       ods_own.sub_program                  sp,
       ods_own.ACCOUNT                      acct
 WHERE     1 = 1
       AND tmp.job_number = E.EVENT_REF_ID
       AND e.apo_oid = a.apo_oid
       AND a.account_oid = acct.account_oid
       AND a.sub_program_oid = sp.sub_program_oid

SELECT count(*)
from	RAX_APP_USER.SFLY_COUPON_V2_TMP   SFLY_COUPON_V2_TMP
