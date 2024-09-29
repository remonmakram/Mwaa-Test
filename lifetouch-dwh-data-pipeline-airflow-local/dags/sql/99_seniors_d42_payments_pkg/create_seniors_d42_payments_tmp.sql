/*-----------------------------------------------*/
/* TASK No. 5 */
/* Drop temp table */

BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.seniors_d42_payments_tmp';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&

/*-----------------------------------------------*/
/* TASK No. 6 */
/* create report table */

CREATE TABLE RAX_APP_USER.seniors_d42_payments_tmp AS
SELECT p.payment_reference2,
       TO_DATE (SUBSTR (p.cheque_reference, 1, 10), 'YYYY-MM-DD')
           AS ref_date,
       'DR'
           AS DR_CR,
       p.total_charged
           AS amount,
       p.payment_reference3,
       oh.order_no,
       a.territory_code
  FROM ods_own.order_header oh, ods_own.payment p, ods_own.apo a
 WHERE     oh.order_header_oid = p.order_header_oid
       AND oh.apo_oid = a.apo_oid
       AND p.payment_reference2 = 'D42'
       AND p.total_charged != 0
       AND TRUNC (p.createts) BETWEEN TRUNC (TRUNC (SYSDATE , 'MM') - 1, 'MM')
                                               AND TRUNC (SYSDATE, 'MM') - 1
UNION ALL
SELECT p.payment_reference2,
       TRUNC (p.modifyts)          AS ref_date,
       'CR'                        AS DR_CR,
       p.total_refunded_amount     AS amount,
       p.payment_reference3,
       oh.order_no,
       a.territory_code
  FROM ods_own.order_header oh, ods_own.payment p, ods_own.apo a
 WHERE     oh.order_header_oid = p.order_header_oid
       AND oh.apo_oid = a.apo_oid
       AND p.payment_reference2 = 'D42'
       AND p.total_refunded_amount != 0
       AND TRUNC (p.modifyts) BETWEEN TRUNC (TRUNC (SYSDATE , 'MM') - 1, 'MM')
                                                AND TRUNC (SYSDATE, 'MM') - 1
