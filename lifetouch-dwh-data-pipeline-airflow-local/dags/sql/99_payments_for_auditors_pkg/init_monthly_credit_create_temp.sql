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

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 4 */




/*-----------------------------------------------*/
/* TASK No. 5 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 5 */




/*-----------------------------------------------*/
/* TASK No. 6 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 6 */




/*-----------------------------------------------*/
/* TASK No. 7 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 7 */




/*-----------------------------------------------*/
/* TASK No. 8 */
/* Drop Temp Table */


BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.monthly_ep_audit';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Create and load temp table */


CREATE TABLE rax_app_user.monthly_ep_audit AS
SELECT EVENT_PAYMENT.EVENT_PAYMENT_OID,
       EVENT_PAYMENT.PAYMENT_DATE,
       EVENT.LIFETOUCH_ID,
       EVENT.EVENT_REF_ID,
       SUB_PROGRAM.SUB_PROGRAM_NAME,
       EVENT_PAYMENT.SUBJECT_FIRST_NAME,
       EVENT_PAYMENT.SUBJECT_LAST_NAME,
       PAYMENT_TYPE.PAYMENT_CATEGORY,
       EVENT_PAYMENT.PAYMENT_AMOUNT,
       ORDER_HEADER.TAX     AS SRM_TAX,
       ORDER_HEADER.OMS_TAX,
       ORDER_HEADER.TAX_EXEMPT_FLAG
  FROM ODS_OWN.EVENT_PAYMENT  EVENT_PAYMENT,
       ODS_OWN.EVENT          EVENT,
       ODS_OWN.APO            APO,
       ODS_OWN.SUB_PROGRAM    SUB_PROGRAM,
       ODS_OWN.PAYMENT_TYPE   PAYMENT_TYPE,
       ODS_OWN.ORDER_HEADER   ORDER_HEADER
 WHERE     (EVENT_PAYMENT.PAYMENT_DATE  BETWEEN TRUNC (TRUNC (SYSDATE, 'MM') - 1, 'MM')
                                 AND TRUNC (SYSDATE, 'MM') - 1)
       AND (PAYMENT_TYPE.PAYMENT_CATEGORY IN ('CreditCard', 'Paypal','Venmo'))
       AND (EVENT_PAYMENT.PAYMENT_AMOUNT != 0)
       AND (EVENT_PAYMENT.EVENT_OID = EVENT.EVENT_OID)
       AND (EVENT.APO_OID = APO.APO_OID)
       AND (APO.SUB_PROGRAM_OID = SUB_PROGRAM.SUB_PROGRAM_OID)
       AND (EVENT_PAYMENT.PAYMENT_TYPE_OID =
            PAYMENT_TYPE.PAYMENT_TYPE_OID(+))
       AND (EVENT_PAYMENT.ORDER_HEADER_OID =
            ORDER_HEADER.ORDER_HEADER_OID(+))