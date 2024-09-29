/*-----------------------------------------------*/
/* TASK No. 2 */
/* DROP REPORT TABLE */

BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.ACTUATE_SRM_CUST_DEPO_STAGE';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* CREATE REPORT TABLE */

CREATE TABLE RAX_APP_USER.ACTUATE_SRM_CUST_DEPO_STAGE

AS
     SELECT O.ORG_CODE AS "Territory Code",
            E.LIFETOUCH_ID AS "Lifetouch ID",
            A.ACCOUNT_ALIAS AS "Account Name",
            APO.APO_ID AS "APO ID",
            E.SELLING_METHOD AS "Selling Method",
            SP.SUB_PROGRAM_NAME AS "Sub Program",
            E.EVENT_REF_ID AS "Event Ref ID",
            TO_CHAR (E.PHOTOGRAPHY_DATE, 'MM/DD/YYYY') AS "Photo Date",
            TO_CHAR (E.SHIP_DATE, 'MM/DD/YYYY') AS "Ship Date",
            E.TRANSACTION_AMT AS "Payment Amount",
            E.SHIPPED_SALES_AMT AS "Shipped Order Amount",
            E.RECOGNIZED_REVENUE_AMT AS "Recognized Revenue",
            E.TRANSACTION_AMT - E.RECOGNIZED_REVENUE_AMT AS "Customer Deposits",
            E.SCHOOL_YEAR AS "School Year"
       FROM ODS_OWN.EVENT E,
            ODS_OWN.APO,
            ODS_OWN.ORGANIZATION O,
            ODS_OWN.ACCOUNT A,
            ODS_OWN.SUB_PROGRAM SP
      WHERE     E.APO_OID = APO.APO_OID
            AND APO.ORGANIZATION_OID = O.ORGANIZATION_OID
            AND APO.ACCOUNT_OID = A.ACCOUNT_OID
            AND NVL (E.TRANSACTION_AMT, 0) <> NVL (E.RECOGNIZED_REVENUE_AMT, 0)
            AND (   (NVL (E.TRANSACTION_AMT, 0) <> 0)
                 OR (NVL (E.RECOGNIZED_REVENUE_AMT, 0) <> 0))
            AND APO.FINANCIAL_PROCESSING_SYSTEM = 'Spectrum'
            AND APO.SUB_PROGRAM_OID = SP.SUB_PROGRAM_OID
            AND SP.SUB_PROGRAM_NAME != 'Yearbook'
   ORDER BY O.ORG_CODE, E.LIFETOUCH_ID, E.EVENT_REF_ID
