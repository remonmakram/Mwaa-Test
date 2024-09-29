BEGIN
    EXECUTE IMMEDIATE 'drop table rax_app_user.uc_lawson_refunds';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Create and load temp table */

create table rax_app_user.uc_lawson_refunds as
SELECT APO.SCHOOL_YEAR,
       APO.APO_ID,
       EVENT.TERRITORY_CODE,
       SUB_PROGRAM.SUB_PROGRAM_NAME,
       EVENT.EVENT_REF_ID,
       EVENT_PAYMENT.PAYMENT_AMOUNT     AS REFUND_AMOUNT,
       EVENT_PAYMENT.CARDHOLDER_NAME,
       EVENT_PAYMENT.CHECK_NUMBER,
       EVENT_PAYMENT.RECORD_STATUS,
       EVENT_PAYMENT.PAYMENT_DATE
  FROM ODS_OWN.EVENT          EVENT,
       ODS_OWN.EVENT_PAYMENT  EVENT_PAYMENT,
       ODS_OWN.PAYMENT_TYPE   PAYMENT_TYPE,
       ODS_OWN.SUB_PROGRAM    SUB_PROGRAM,
       ODS_OWN.APO            APO
 WHERE     (SUB_PROGRAM.SUB_PROGRAM_NAME != 'Yearbook')
       AND (EVENT_PAYMENT.ODS_CREATE_DATE BETWEEN TRUNC (
                                                        TRUNC (SYSDATE, 'MM')
                                                      - 1,
                                                      'MM')
                                              AND TRUNC (SYSDATE, 'MM') - 1)
       AND (EVENT_PAYMENT.PAYMENT_AMOUNT != 0)
       AND (PAYMENT_TYPE.PAYMENT_TYPE = 'RefundCheck')
       AND (EVENT_PAYMENT.EVENT_OID = EVENT.EVENT_OID)
       AND (EVENT_PAYMENT.PAYMENT_TYPE_OID = PAYMENT_TYPE.PAYMENT_TYPE_OID)
       AND (EVENT.APO_OID = APO.APO_OID)
       AND (APO.SUB_PROGRAM_OID = SUB_PROGRAM.SUB_PROGRAM_OID)
       union all
       SELECT APO.SCHOOL_YEAR,
       APO.APO_ID,
       EVENT.TERRITORY_CODE,
       SUB_PROGRAM.SUB_PROGRAM_NAME,
       EVENT.EVENT_REF_ID,
       pr.PAYMENT_AMOUNT     AS REFUND_AMOUNT,
       EVENT_PAYMENT.CARDHOLDER_NAME,
       EVENT_PAYMENT.CHECK_NUMBER,
       EVENT_PAYMENT.RECORD_STATUS,
       trunc(EVENT_PAYMENT.ODS_MODIFY_DATE)
  FROM ODS_OWN.EVENT          EVENT,
       ODS_OWN.EVENT_PAYMENT  EVENT_PAYMENT,
       ODS_OWN.PAYMENT_TYPE   PAYMENT_TYPE,
       ODS_OWN.SUB_PROGRAM    SUB_PROGRAM,
       ODS_OWN.APO            APO,
       ODS_OWN.ACCT_COMM_PMT_REQ pr
 WHERE     (SUB_PROGRAM.SUB_PROGRAM_NAME != 'Yearbook')
       AND (EVENT_PAYMENT.ODS_MODIFY_DATE BETWEEN TRUNC (
                                                        TRUNC (SYSDATE, 'MM')
                                                      - 1,
                                                      'MM')
                                              AND TRUNC (SYSDATE, 'MM') - 1)
       AND (EVENT_PAYMENT.PAYMENT_AMOUNT = 0)
       AND (PAYMENT_TYPE.PAYMENT_TYPE = 'RefundCheck')
       AND (EVENT_PAYMENT.EVENT_OID = EVENT.EVENT_OID)
       AND (EVENT_PAYMENT.PAYMENT_TYPE_OID = PAYMENT_TYPE.PAYMENT_TYPE_OID)
       AND (EVENT.APO_OID = APO.APO_OID)
       AND (APO.SUB_PROGRAM_OID = SUB_PROGRAM.SUB_PROGRAM_OID)
       and pr.ACCT_COMM_PMT_REQ_ID = EVENT_PAYMENT.ACCT_COMM_PMT_REQ_ID


