/*-----------------------------------------------*/
/* TASK No. 4 */
/* drop table */


BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.POSTED_UNPOSTED_BATCHES';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* create table */

create table RAX_APP_USER.POSTED_UNPOSTED_BATCHES
(
  BEGIN_DATE          VARCHAR2(10 BYTE),
  END_DATE            VARCHAR2(10 BYTE),
  PAYMENT_TYPE   VARCHAR2(50 BYTE),
  PAYMENT_ID      NUMBER,
  LAST_MODIFIED          VARCHAR2(10 BYTE),
  LAST_MODIFIED_BY   VARCHAR2(50 BYTE),
  DATE_CREATED            VARCHAR2(10 BYTE),
  CREATED_BY   VARCHAR2(50 BYTE),
  AMOUNT          NUMBER(19,2),
  PAYMENT_DATE          VARCHAR2(10 BYTE),
  PAYMENT_BATCH_ID   NUMBER,
  CUSTOMER_ORDER_ID   NUMBER,
  PAYMENT_STATUS  VARCHAR2(50 BYTE),
  JOB_NUMBER  VARCHAR2(50 BYTE),
  CURRENCY_CODE  VARCHAR2(50 BYTE),
  SOURCE_SYSTEM VARCHAR2(50 BYTE)
)



&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* insert CSP */

INSERT INTO RAX_APP_USER.POSTED_UNPOSTED_BATCHES
 (
  BEGIN_DATE
, END_DATE
, PAYMENT_TYPE
, PAYMENT_ID
, LAST_MODIFIED
, LAST_MODIFIED_BY
, DATE_CREATED
, CREATED_BY
, AMOUNT
, PAYMENT_DATE
, PAYMENT_BATCH_ID
, CUSTOMER_ORDER_ID
, PAYMENT_STATUS
, JOB_NUMBER
, CURRENCY_CODE
, SOURCE_SYSTEM
)
select
    to_char(case when to_date(:v_data_export_last_month_begin_date,'YYYYMMDD') is null then to_date('19000101','YYYYMMDD') else to_date(:v_data_export_last_month_begin_date,'YYYYMMDD') end,'MM/DD/YYYY') BEGIN_DATE
    ,to_char(case when to_date(:v_data_export_last_month_end_date,'YYYYMMDD') is null then to_date('21000101','YYYYMMDD') else to_date(:v_data_export_last_month_end_date,'YYYYMMDD') end,'MM/DD/YYYY') END_DATE,
    pay.PAYMENT_TYPE
    ,pay.PAYMENT_ID
    ,to_char(pay.modified_on,'MM/DD/YYYY')  LAST_MODIFIED
    ,pay.modified_by LAST_MODIFIED_BY
    ,to_char(pay.created_on,'MM/DD/YYYY') DATE_CREATED
    ,pay.created_by CREATED_BY
    ,op.payment_amount AMOUNT
    ,to_char(op.posted_date,'MM/DD/YYYY') PAYMENT_DATE
    ,null PAYMENT_BATCH_ID
    ,o.order_id CUSTOMER_ORDER_ID
    ,pay.status PAYMENT_STATUS
    ,o.event_ref_id JOB_NUMBER
    ,pay.currency_code
    ,'CSP' as SOURCE_SYSTEM
from
    ods_stage.csp_payment_stg pay
    ,ods_stage.csp_order_payment_stg op
    ,ods_stage.csp_order_stg o
where (1=1)
    and op.posted_date >= case when to_date(:v_data_export_last_month_begin_date,'YYYYMMDD') is null then to_date('19000101','YYYYMMDD') else to_date(:v_data_export_last_month_begin_date,'YYYYMMDD') end
    and op.posted_date <= case when to_date(:v_data_export_last_month_end_date,'YYYYMMDD') is null then to_date('21000101','YYYMMDD') else to_date(:v_data_export_last_month_end_date,'YYYYMMDD') end
    and op.payment_id=pay.payment_id
    and op.order_id=o.order_id

