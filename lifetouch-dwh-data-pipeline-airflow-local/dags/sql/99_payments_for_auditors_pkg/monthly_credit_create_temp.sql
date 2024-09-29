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
/* TASK No. 10 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 10 */




/*-----------------------------------------------*/
/* TASK No. 11 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 11 */




/*-----------------------------------------------*/
/* TASK No. 12 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 12 */




/*-----------------------------------------------*/
/* TASK No. 13 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 13 */




/*-----------------------------------------------*/
/* TASK No. 14 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 14 */




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

