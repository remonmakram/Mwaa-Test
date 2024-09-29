/*-----------------------------------------------*/
/* TASK No. 6 */
/* Drop temp table */
BEGIN
    EXECUTE IMMEDIATE 'drop table rax_app_user.late_recognitions';
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

Create table rax_app_user.late_recognitions as
    SELECT a.SCHOOL_YEAR,
gtd.GL_TRANSACTION_DETAIL_OID,
       sp.SUB_PROGRAM_NAME,
       a.APO_ID,
       e.EVENT_REF_ID,
       a.TERRITORY_CODE,
       sr.RECOGNIZED_DATE,
      gtd.AMOUNT as posted_amount,
       gtd.APO_TYPE_NAME,
       gtd.GL_ACCOUNT,
       gtd.GL_SUB_ACCOUNT,
       gtd.GL_ACCOUNTING_UNIT,
       gtd.GL_DESCRIPTION,
       gtd.TRANSMIT_DATE,
       gtd.profit_center
  FROM ODS_OWN.SUB_PROGRAM            sp,
       ods_own.apo                    a,
       ods_own.event                  e,
       ODS_OWN.SALES_RECOGNITION      sr,
       ODS_OWN.GL_TRANSACTION_DETAIL  gtd
WHERE     sp.SUB_PROGRAM_OID = a.SUB_PROGRAM_OID
       AND a.APO_OID = e.APO_OID
       AND e.EVENT_OID = sr.EVENT_OID
       AND sr.SALES_RECOGNITION_OID = gtd.SALES_RECOGNITION_OID
       AND TRUNC (sr.RECOGNIZED_DATE) = TRUNC (SYSDATE, 'MM') - 1
       AND TRUNC (gtd.TRANSMIT_DATE) - trunc(sr.recognized_date) > 1
