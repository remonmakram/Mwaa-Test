
BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.YEARBOOK_SALESADJUSTMENT_STAGE';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;
&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* create table */

create table RAX_APP_USER.YEARBOOK_SALESADJUSTMENT_STAGE as
SELECT e.EVENT_REF_ID,
       to_char(ea.RECOGNIZED_DATE ,'MM/DD/YYYY')        AS recognized_date,
       ea.PERFECT_ORDER_SALES_AMOUNT      AS sales,
       ea.ACCOUNT_COMMISSION_AMOUNT       AS account_commission,
       ea.CHARGEBACK_AMOUNT               AS charge_back,
       ea.TERRITORY_COMMISSION_AMOUNT     AS territory_commission,
       ea.ORDER_SH_AMOUNT                 AS order_shipping_handling,
       ea.WRITE_OFF_AMOUNT                AS write_off,
       ea.UPDATED_BY AS updated_by,
       ea.ADJUSTMENT_REASON AS reason,
       ea.NOTE AS note,
       a.apo_id AS apo_id
  FROM ods_own.sub_program       sp,
       ods_own.apo               a,
       ods_own.event             e,
       ods_own.event_adjustment  ea
 WHERE     sp.SUB_PROGRAM_OID = a.SUB_PROGRAM_OID
       AND a.APO_OID = e.APO_OID
       AND e.EVENT_OID = ea.EVENT_OID
       AND sp.SUB_PROGRAM_NAME = 'Yearbook'
       AND a.FINANCIAL_PROCESSING_SYSTEM = 'Spectrum'
       AND E.SCHOOL_YEAR >= (SELECT tt.FISCAL_YEAR - 4
                               FROM MART.TIME tt
                              WHERE tt.DATE_KEY = TRUNC (SYSDATE))
