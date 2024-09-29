BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.spectrum_senior_payment_stg';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;
&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* create report table */

create table RAX_APP_USER.spectrum_senior_payment_stg  as
SELECT AP.APO_ID,
OH.ORDER_NO,
S.FIRST_NAME,
S.LAST_NAME,
PY.TOTAL_CHARGED     AS "PAYMENT_AMOUNT",
PY.PAYMENT_TYPE,
PY.CREATETS  AS  "DATE_PAYMENT_POSTED"
FROM ODS_OWN.PAYMENT     PY,
ODS_OWN.ORDER_HEADER OH,
ODS_OWN.APO         AP,
ODS_OWN.SUBJECT     S,
ODS_OWN.SUB_PROGRAM SP,
ODS_OWN.PROGRAM     P
WHERE     1 = 1
AND PY.ORDER_HEADER_OID = OH.ORDER_HEADER_OID
AND OH.APO_OID = AP.APO_OID
AND OH.SUBJECT_OID = S.SUBJECT_OID
AND P.PROGRAM_OID = SP.PROGRAM_OID
AND PY.PAYMENT_TYPE IN ('CASH', 'CHECK')
AND P.PROGRAM_OID = 20
AND PY.ODS_CREATE_DATE BETWEEN add_months(trunc(sysdate,'mm'),-1) AND  last_day(add_months(trunc(sysdate,'mm'),-1))
GROUP BY AP.APO_ID,
OH.ORDER_NO,
S.FIRST_NAME,
S.LAST_NAME,
PY.TOTAL_CHARGED,
PY.PAYMENT_TYPE,
PY.CREATETS

&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* grant permission */

grant select on rax_app_user.actuate_counting_fee_new_stage to ODS_SELECT_ROLE ,MART_USER
