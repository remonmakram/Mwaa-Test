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
/* Drop table */

-- drop table rax_app_user.sfly_coupon_mlt_v2_tmp

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 6 */
-- /* Create table */

-- create table sfly_coupon_mlt_v2_tmp
-- (
--   JOB_NUMBER          VARCHAR2(10 BYTE),
--   SUBJECT_FIRST_NAME  VARCHAR2(50 CHAR),
--   CUST_EMAIL_ADDRESS  VARCHAR2(255 CHAR),
--   AUDIT_CREATE_DATE  DATE,
--   PAYMENT_VOUCHER_ID  NUMBER(19),
--  ORDER_TYPE VARCHAR2(10)
-- )

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 7 */
-- /* Load Data */

-- /* SOURCE CODE */
-- SELECT oh.job_number, oh.subject_first_name, p.cust_email_address,
--        oh.audit_create_date, oh.payment_voucher_id, oh.order_type
--   FROM mlt_own.payment p,
--        mlt_own.payment_attempt pa,
--        mlt_own.mlt_order oh,
--        mlt_own.order_line ol,
--        mlt_own.order_promotions op,
--        mlt_own.order_line_promotions olp
--  WHERE pa.payment_id = p.payment_id
--    AND oh.payment_id = p.payment_id
--    AND oh.order_id = ol.order_id
--    AND oh.order_id = op.order_id(+)
--    AND ol.order_line_id = olp.order_line_id(+)
--    -- Include only Approved Payments
--    AND pa.payment_status = 'APPROVED'
--    -- Include payments on Spec orders (order not sent to OMS)
--    AND (oh.order_type = 'PAYMENT' OR oh.posted_date IS NOT NULL)
--    -- Exclude DSSK orders
--    AND (   oh.payment_amount > 0
--         OR op.promotion_id IS NOT NULL
--         OR olp.promotion_id IS NOT NULL
--        )
--    AND oh.audit_create_date BETWEEN TRUNC (TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS'))
--                                 AND   TRUNC (SYSDATE)
--                                     - 1 / (24 * 60 * 60)


-- &

-- /* TARGET CODE */
-- insert into rax_app_user.sfly_coupon_mlt_v2_tmp (
-- job_number,
-- subject_first_name,
-- cust_email_address,
-- audit_create_date,
-- payment_voucher_id,
-- order_type)
-- values (
-- :JOB_NUMBER,
-- :SUBJECT_FIRST_NAME,
-- :CUST_EMAIL_ADDRESS,
-- :AUDIT_CREATE_DATE,
-- :PAYMENT_VOUCHER_ID,
-- :ORDER_TYPE)

-- &


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Drop table */

-- drop table sfly_coupon_v2_tmp

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 9 */
-- /* Create table */

-- create table sfly_coupon_v2_tmp as
-- SELECT DISTINCT tmp.subject_first_name,
--        tmp.cust_email_address,
--        tmp.payment_voucher_id,
--        TO_CHAR (tmp.audit_create_date, 'MM/DD/YYYY')     AS audit_create_date,
--        acct.STATE,
--        a.SCHOOL_YEAR,
--        sp.SUB_PROGRAM_NAME                               AS sub_program,
--        tmp.order_type,
--        TO_CHAR(e.photography_date,'MM/DD/YYYY') AS photography_date
--   FROM rax_app_user.sfly_coupon_mlt_v2_tmp  tmp,
--        ods_own.event                        e,
--        ods_own.apo                          a,
--        ods_own.sub_program                  sp,
--        ods_own.ACCOUNT                      acct
--  WHERE     1 = 1
--        AND tmp.job_number = E.EVENT_REF_ID
--        AND e.apo_oid = a.apo_oid
--        AND a.account_oid = acct.account_oid
--        AND a.sub_program_oid = sp.sub_program_oid

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 10 */
-- /* Grant select on tmp table */

-- grant select on sfly_coupon_v2_tmp to ods_select_role

-- &


/*-----------------------------------------------*/
/* TASK No. 11 */

-- rm -f /dw_export/PROD/SFLY_MLT_COUPON.csv

-- &


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Generate header */

-- create header	(SUBJECT_FIRST_NAME,
-- 	CUSTOMER_EMAILID,
-- 	ORDER_FORM_ID,
-- 	ORDER_DATE,
-- 	STATE,
-- 	SCHOOL_YEAR,
-- 	SUB_PROGRAM,
-- 	ORDER_TYPE,
-- 	PHOTOGRAPHY_DATE)

-- /*$$SNPS_START_KEYSNP$CRDWG_TABLESNP$CRTABLE_NAME=SFLY_MLT_COUPON.csvSNP$CRLOAD_FILE=/dw_export/PROD/SFLY_MLT_COUPON.csvSNP$CRFILE_FORMAT=DSNP$CRFILE_SEP_FIELD=0x002cSNP$CRFILE_SEP_LINE=0x000D0x000ASNP$CRFILE_FIRST_ROW=0SNP$CRFILE_ENC_FIELD="SNP$CRFILE_DEC_SEP=SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=SUBJECT_FIRST_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=1SNP$CRLENGTH=400SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=CUSTOMER_EMAILIDSNP$CRTYPE_NAME=STRINGSNP$CRORDER=2SNP$CRLENGTH=400SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=ORDER_FORM_IDSNP$CRTYPE_NAME=STRINGSNP$CRORDER=3SNP$CRLENGTH=400SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=ORDER_DATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=4SNP$CRLENGTH=400SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=STATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=5SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=SCHOOL_YEARSNP$CRTYPE_NAME=STRINGSNP$CRORDER=6SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=SUB_PROGRAMSNP$CRTYPE_NAME=STRINGSNP$CRORDER=7SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=ORDER_TYPESNP$CRTYPE_NAME=STRINGSNP$CRORDER=8SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=PHOTOGRAPHY_DATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=9SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CR$$SNPS_END_KEY*/


-- &


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Insert new rows */

/* SOURCE CODE */


-- select 	
-- 	SFLY_COUPON_V2_TMP.SUBJECT_FIRST_NAME	   SUBJECT_FIRST_NAME,
-- 	SFLY_COUPON_V2_TMP.CUST_EMAIL_ADDRESS	   CUSTOMER_EMAILID,
-- 	SFLY_COUPON_V2_TMP.PAYMENT_VOUCHER_ID	   ORDER_FORM_ID,
-- 	SFLY_COUPON_V2_TMP.AUDIT_CREATE_DATE	   ORDER_DATE,
-- 	SFLY_COUPON_V2_TMP.STATE	   STATE,
-- 	SFLY_COUPON_V2_TMP.SCHOOL_YEAR	   SCHOOL_YEAR,
-- 	SFLY_COUPON_V2_TMP.SUB_PROGRAM	   SUB_PROGRAM,
-- 	SFLY_COUPON_V2_TMP.ORDER_TYPE	   ORDER_TYPE,
-- 	SFLY_COUPON_V2_TMP.PHOTOGRAPHY_DATE	   PHOTOGRAPHY_DATE
-- from	RAX_APP_USER.SFLY_COUPON_V2_TMP   SFLY_COUPON_V2_TMP
-- where	
-- 	(1=1)	
	





/* Order the output by the UD1, UD2, UD3, UD4, UD5, UD6 Fields. */



-- &

/* TARGET CODE */
-- insert into "/dw_export/PROD/SFLY_MLT_COUPON.csv"
-- (
-- 	SUBJECT_FIRST_NAME,
-- 	CUSTOMER_EMAILID,
-- 	ORDER_FORM_ID,
-- 	ORDER_DATE,
-- 	STATE,
-- 	SCHOOL_YEAR,
-- 	SUB_PROGRAM,
-- 	ORDER_TYPE,
-- 	PHOTOGRAPHY_DATE
                     
-- )
-- values 
-- (
-- 	:SUBJECT_FIRST_NAME,
-- 	:CUSTOMER_EMAILID,
-- 	:ORDER_FORM_ID,
-- 	:ORDER_DATE,
-- 	:STATE,
-- 	:SCHOOL_YEAR,
-- 	:SUB_PROGRAM,
-- 	:ORDER_TYPE,
-- 	:PHOTOGRAPHY_DATE
                     
-- )

-- &
/*$$SNPS_START_KEYSNP$CRDWG_TABLESNP$CRTABLE_NAME=SFLY_MLT_COUPON.csvSNP$CRLOAD_FILE=/dw_export/PROD/SFLY_MLT_COUPON.csvSNP$CRFILE_FORMAT=DSNP$CRFILE_SEP_FIELD=0x002cSNP$CRFILE_SEP_LINE=0x000D0x000ASNP$CRFILE_FIRST_ROW=0SNP$CRFILE_ENC_FIELD="SNP$CRFILE_DEC_SEP=SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=SUBJECT_FIRST_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=1SNP$CRLENGTH=400SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=CUSTOMER_EMAILIDSNP$CRTYPE_NAME=STRINGSNP$CRORDER=2SNP$CRLENGTH=400SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=ORDER_FORM_IDSNP$CRTYPE_NAME=STRINGSNP$CRORDER=3SNP$CRLENGTH=400SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=ORDER_DATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=4SNP$CRLENGTH=400SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=STATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=5SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=SCHOOL_YEARSNP$CRTYPE_NAME=STRINGSNP$CRORDER=6SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=SUB_PROGRAMSNP$CRTYPE_NAME=STRINGSNP$CRORDER=7SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=ORDER_TYPESNP$CRTYPE_NAME=STRINGSNP$CRORDER=8SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=PHOTOGRAPHY_DATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=9SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CR$$SNPS_END_KEY*/



/*-----------------------------------------------*/
/* TASK No. 14 */

-- chmod 644 /dw_export/PROD/SFLY_MLT_COUPON.csv

-- &


/*-----------------------------------------------*/
/* TASK No. 15 */

-- mv /dw_export/PROD/SFLY_MLT_COUPON.csv /dw_export/PROD/SFLY/TO_SEND/sfly_mlt_coupon_:v_data_center_name_short:v_data_export_run_date.csv

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 16 */

-- mv /dw_export/PROD/SFLY/TO_SEND/sfly_mlt_coupon_:v_data_center_name_short:v_data_export_run_date.csv /dw_export/PROD/SFLY/SENT

-- &


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
+ nvl((TIMEZONE_OFFSET/24), 0) 
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

/*
UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/

&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Insert CDC Audit Record */

INSERT INTO RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
(TABLE_NAME,
SESS_NO,                      
SESS_NAME,                    
SCEN_VERSION,                 
SESS_BEG,                     
ORIG_LAST_CDC_COMPLETION_DATE,
OVERLAP,
CREATE_DATE,
CONTEXT_NAME,
TIMEZONE_OFFSET              
)
select 
:v_cdc_load_table_name
,:v_sess_no
,'99_SFLY_MLT_COUPON_PKG'
,'009'
,TO_DATE(SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
,TO_DATE (SUBSTR(:v_cdc_load_date, 1, 19),'YYYY-MM-DD HH24:MI:SS')
,:v_cdc_overlap
,SYSDATE
,:v_env
,TIMEZONE_OFFSET
from 
ODS_OWN.ODS_CDC_LOAD_STATUS
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

/*
INSERT INTO RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
(TABLE_NAME,
SESS_NO,                      
SESS_NAME,                    
SCEN_VERSION,                 
SESS_BEG,                     
ORIG_LAST_CDC_COMPLETION_DATE,
OVERLAP,
CREATE_DATE,
CONTEXT_NAME              
)
values (
:v_cdc_load_table_name,
:v_sess_no,
'99_SFLY_MLT_COUPON_PKG',
'009',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/





/*-----------------------------------------------*/
