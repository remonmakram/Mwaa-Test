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
/* drop ep_trans_dtl_dump_all */


BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.ep_trans_dtl_dump_all';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;
&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* CREATE AND LOAD EP_TRANS_DTL_DMP */

CREATE TABLE EP_TRANS_DTL_DUMP_ALL
AS
 SELECT 'Event_Payment' AS transaction_source,
           ep.event_ref_id event_ref_id,
           gtd.gl_transaction_detail_oid,
           gtd.gl_transaction_oid,
           gtd.ods_create_date,
           gtd.ods_modify_date,
           gtd.gl_account_type,
           gtd.gl_debit_credit_ind,
           gtd.posting_date,
           gtd.amount,
           gtd.currency_code,
           gtd.country,
           gtd.sales_tax_state_code,
           gtd.territory_code,
           gtd.business_unit,
           gtd.program_name,
           gtd.sub_program_name,
           gtd.bank_code,
           gtd.gl_company,
           gtd.gl_account,
          gtd.gl_sub_account,
           gtd.gl_accounting_unit,
           REGEXP_REPLACE (gtd.gl_description, '[^[:alnum:] ]*', '')
              gl_description,
           gtd.gl_program_code,
           gtd.event_payment_oid,
           gtd.sales_recognition_oid,
           gtd.matched_sales_recognition_oid,
           gtd.event_adjustment_oid,
           gtd.chargeback_fact_oid,
           gtd.gl_activity,
           gtd.inv_event_pay_oid,
           gtd.record_status,
           AP.APO_TYPE
      FROM ods_own.gl_transaction_detail gtd,
           ODS_OWN.EVENT e,
           ODS_OWN.APO AP,
           ods_own.event_payment ep
     WHERE     gtd.event_payment_oid IS NOT NULL
           AND GTD.EVENT_OID = E.EVENT_OID
           AND E.APO_OID = AP.APO_OID
           AND gtd.event_payment_oid = ep.event_payment_oid(+)
           AND gtd.record_status != 'IGNORE'
           AND gtd.transmit_date IS NOT NULL
            AND gtd.posting_date BETWEEN TRUNC (TRUNC (SYSDATE, 'MM') - 1, 'MM')
            AND TRUNC (SYSDATE, 'MM') - 1