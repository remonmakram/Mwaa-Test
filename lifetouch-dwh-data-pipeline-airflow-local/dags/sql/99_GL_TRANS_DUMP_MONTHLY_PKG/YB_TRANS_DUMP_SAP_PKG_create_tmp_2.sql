BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.GL_TRANS_DTL_DUMP';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Create and load dump table */


CREATE TABLE RAX_APP_USER.GL_TRANS_DTL_DUMP

AS
   SELECT transaction_source,
          event_ref_id,
          gl_transaction_detail_oid,
          gl_transaction_oid,
          ods_create_date,
          ods_modify_date,
          gl_account_type,
          gl_debit_credit_ind,
          posting_date,
          amount,
          currency_code,
          country,
          sales_tax_state_code,
          territory_code,
          business_unit,
          program_name,
          sub_program_name,
          bank_code,
          gl_company,
          gl_account,
          gl_sub_account,
          gl_accounting_unit,
          gl_description,
          gl_program_code,
          event_payment_oid,
          sales_recognition_oid,
          matched_sales_recognition_oid,
          event_adjustment_oid,
          chargeback_fact_oid,
          gl_activity,
          inv_event_pay_oid,
          record_status,
          APO_TYPE
,company_code
,profit_center
,run_group
     FROM (SELECT transaction_source,
                  event_ref_id,
                  gl_transaction_detail_oid,
                  gl_transaction_oid,
                  ods_create_date,
                  ods_modify_date,
                  gl_account_type,
                  gl_debit_credit_ind,
                  posting_date,
                  amount,
                  currency_code,
                  country,
                  sales_tax_state_code,
                  territory_code,
                  business_unit,
                  program_name,
                  sub_program_name,
                  bank_code,
                  gl_company,
                  gl_account,
                  gl_sub_account,
                  gl_accounting_unit,
                  gl_description,
                  gl_program_code,
                  event_payment_oid,
                  sales_recognition_oid,
                  matched_sales_recognition_oid,
                  event_adjustment_oid,
                  chargeback_fact_oid,
                  gl_activity,
                  inv_event_pay_oid,
                  record_status,
                  APO_TYPE
,company_code
,profit_center
,run_group
             FROM RAX_APP_USER.gl_trans_dtl_dump_all)