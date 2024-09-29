


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Drop Temp Table */

BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.monthly_ep_audit_num';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;


&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Create and load temp table */

CREATE TABLE RAX_APP_USER.MONTHLY_EP_AUDIT_NUM
AS
SELECT EVENT_PAYMENT_OID,
       PAYMENT_DATE,
       LIFETOUCH_ID,
       EVENT_REF_ID,
       SUB_PROGRAM_NAME,
       SUBJECT_FIRST_NAME,
       SUBJECT_LAST_NAME,
       PAYMENT_CATEGORY,
       PAYMENT_AMOUNT,
       SRM_TAX,
       OMS_TAX,
       TAX_EXEMPT_FLAG
  FROM (SELECT EVENT_PAYMENT_OID,
               PAYMENT_DATE,
               LIFETOUCH_ID,
               EVENT_REF_ID,
               SUB_PROGRAM_NAME,
               SUBJECT_FIRST_NAME,
               SUBJECT_LAST_NAME,
               PAYMENT_CATEGORY,
               PAYMENT_AMOUNT,
               SRM_TAX,
               OMS_TAX,
               TAX_EXEMPT_FLAG,
               ROW_NUMBER () OVER (ORDER BY event_payment_oid)     r
          FROM RAX_APP_USER.MONTHLY_EP_AUDIT)
 WHERE r BETWEEN :v_ep_auditors_ctr AND :v_ep_auditors_ctr + :v_ep_dump_file_max - 1

