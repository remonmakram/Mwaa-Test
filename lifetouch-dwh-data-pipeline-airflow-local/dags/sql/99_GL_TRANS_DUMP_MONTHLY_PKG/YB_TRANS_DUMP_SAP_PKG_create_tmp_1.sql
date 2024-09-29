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

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 8 */




/*-----------------------------------------------*/
/* TASK No. 9 */
/* Drop GL_TRANS_DTL_DUMP_ALL */

BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.gl_trans_dtl_dump_all';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Create and load gl_trans_dtl_dmp_all */

/* LOAD_GL_TRANS_DTL_DMP_PRC */
CREATE TABLE RAX_APP_USER.gl_trans_dtl_dump_all
AS
   SELECT case when gtd.event_payment_oid is not null then 'Event_Payment'
                         when gtd.sales_recognition_oid is not null then 'Sales_Rec'
                         when gtd.matched_sales_recognition_oid is not null then 'Matched_Sales_Rec'
                         when gtd.event_adjustment_oid is not null then 'Event_Adj'
                         when gtd.chargeback_fact_oid is not null then 'Chargeback'
                         else 'Other'
                 end AS transaction_source,
          gtd.event_ref_id event_ref_id,
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
          gtd.apo_type_name as APO_TYPE
,gtd.company_code
,gtd.profit_center
,gtd.run_group
     FROM ODS_OWN.gl_transaction_detail gtd
    WHERE    1=1
          AND gtd.record_status != 'IGNORE'
          AND gtd.program_name = 'Yearbook'
            AND gtd.posting_date BETWEEN TRUNC (TRUNC (SYSDATE , 'MM') - 1, 'MM')
            AND TRUNC (SYSDATE, 'MM') - 1
