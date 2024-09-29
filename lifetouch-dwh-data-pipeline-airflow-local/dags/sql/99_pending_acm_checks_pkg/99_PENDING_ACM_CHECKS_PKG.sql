/* TASK No. 1 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */
/* drop report table */

drop table RAX_APP_USER.pending_acm_checks_stage



&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* create report table */

create table RAX_APP_USER.pending_acm_checks_stage as
select apo.territory_code
, p.program_name
, apo.selling_method
, apo.lifetouch_id
, apo.apo_id
, to_char(ae.act_comm_finalized_date,'MM/DD/YYYY') as finalized_date
, to_char(acpr.request_date,'MM/DD/YYYY') as request_date
, acpr.payment_amount
from srm_own.apo_extension ae
, ods_own.apo
, ods_own.acct_comm_pmt_req acpr
, ods_own.sub_program sp
, ods_own.program p
where 1=1
and apo.apo_oid = ae.apo_oid
and apo.apo_oid = acpr.apo_oid
and not exists
(
select 1
from ods_own.account_commission ac
where 1=1
and acpr.acct_comm_pmt_req_id = ac.acct_comm_pmt_req_id
and ac.ods_create_date < trunc(sysdate)
)
and apo.sub_program_oid = sp.sub_program_oid
and sp.program_oid = p.program_oid
and ae.act_comm_finalized in ('Pending','Finalized')
and trunc(ae.act_comm_finalized_date) = trunc(acpr.request_date)
and acpr.approval_status not in ('Declined')
and acpr.payment_request_type in ('StandardCheck','PrepaymentCheck')  
--and ae.act_comm_finalized_date between trunc(sysdate - 30) and trunc(sysdate) -- removed SODS-1379
order by apo.territory_code
, p.program_name
, apo.selling_method
, apo.lifetouch_id

&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* Generate header */

create header	(TERRITORY_CODE,
	PROGRAM_NAME,
	SELLING_METHOD,
	LIFETOUCH_IDS,
	APO_ID,
	FINALIZED_DATE,
	REQUEST_DATE,
	PAYMENT_AMOUNT)

/*$$SNPS_START_KEYSNP$CRDWG_TABLESNP$CRTABLE_NAME=pending_acm_checks.csvSNP$CRLOAD_FILE=/dw_export/PROD/pending_acm_checks.csvSNP$CRFILE_FORMAT=DSNP$CRFILE_SEP_FIELD=0x002cSNP$CRFILE_SEP_LINE=0x000D0x000ASNP$CRFILE_FIRST_ROW=0SNP$CRFILE_ENC_FIELD="SNP$CRFILE_DEC_SEP=SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=TERRITORY_CODESNP$CRTYPE_NAME=STRINGSNP$CRORDER=1SNP$CRLENGTH=255SNP$CRPRECISION=255SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=PROGRAM_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=2SNP$CRLENGTH=255SNP$CRPRECISION=255SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=SELLING_METHODSNP$CRTYPE_NAME=STRINGSNP$CRORDER=3SNP$CRLENGTH=255SNP$CRPRECISION=255SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=LIFETOUCH_IDSSNP$CRTYPE_NAME=STRINGSNP$CRORDER=4SNP$CRLENGTH=255SNP$CRPRECISION=255SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=APO_IDSNP$CRTYPE_NAME=STRINGSNP$CRORDER=5SNP$CRLENGTH=255SNP$CRPRECISION=255SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=FINALIZED_DATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=6SNP$CRLENGTH=255SNP$CRPRECISION=255SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=REQUEST_DATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=7SNP$CRLENGTH=255SNP$CRPRECISION=255SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=PAYMENT_AMOUNTSNP$CRTYPE_NAME=STRINGSNP$CRORDER=8SNP$CRLENGTH=255SNP$CRPRECISION=255SNP$CR$$SNPS_END_KEY*/


&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Insert new rows */

/* SOURCE CODE */


select 	
	ACM_CHECKS.TERRITORY_CODE	   TERRITORY_CODE,
	ACM_CHECKS.PROGRAM_NAME	   PROGRAM_NAME,
	ACM_CHECKS.SELLING_METHOD	   SELLING_METHOD,
	ACM_CHECKS.LIFETOUCH_ID	   LIFETOUCH_IDS,
	ACM_CHECKS.APO_ID	   APO_ID,
	ACM_CHECKS.FINALIZED_DATE	   FINALIZED_DATE,
	ACM_CHECKS.REQUEST_DATE	   REQUEST_DATE,
	ACM_CHECKS.PAYMENT_AMOUNT	   PAYMENT_AMOUNT
from	RAX_APP_USER.PENDING_ACM_CHECKS_STAGE   ACM_CHECKS
where	
	(1=1)	
	





/* Order the output by the UD1, UD2, UD3, UD4, UD5, UD6 Fields. */



&

/* TARGET CODE */
insert into "/dw_export/PROD/pending_acm_checks.csv"
(
	TERRITORY_CODE,
	PROGRAM_NAME,
	SELLING_METHOD,
	LIFETOUCH_IDS,
	APO_ID,
	FINALIZED_DATE,
	REQUEST_DATE,
	PAYMENT_AMOUNT
                     
)
values 
(
	:TERRITORY_CODE,
	:PROGRAM_NAME,
	:SELLING_METHOD,
	:LIFETOUCH_IDS,
	:APO_ID,
	:FINALIZED_DATE,
	:REQUEST_DATE,
	:PAYMENT_AMOUNT
                     
)
/*$$SNPS_START_KEYSNP$CRDWG_TABLESNP$CRTABLE_NAME=pending_acm_checks.csvSNP$CRLOAD_FILE=/dw_export/PROD/pending_acm_checks.csvSNP$CRFILE_FORMAT=DSNP$CRFILE_SEP_FIELD=0x002cSNP$CRFILE_SEP_LINE=0x000D0x000ASNP$CRFILE_FIRST_ROW=0SNP$CRFILE_ENC_FIELD="SNP$CRFILE_DEC_SEP=SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=TERRITORY_CODESNP$CRTYPE_NAME=STRINGSNP$CRORDER=1SNP$CRLENGTH=255SNP$CRPRECISION=255SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=PROGRAM_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=2SNP$CRLENGTH=255SNP$CRPRECISION=255SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=SELLING_METHODSNP$CRTYPE_NAME=STRINGSNP$CRORDER=3SNP$CRLENGTH=255SNP$CRPRECISION=255SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=LIFETOUCH_IDSSNP$CRTYPE_NAME=STRINGSNP$CRORDER=4SNP$CRLENGTH=255SNP$CRPRECISION=255SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=APO_IDSNP$CRTYPE_NAME=STRINGSNP$CRORDER=5SNP$CRLENGTH=255SNP$CRPRECISION=255SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=FINALIZED_DATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=6SNP$CRLENGTH=255SNP$CRPRECISION=255SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=REQUEST_DATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=7SNP$CRLENGTH=255SNP$CRPRECISION=255SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=PAYMENT_AMOUNTSNP$CRTYPE_NAME=STRINGSNP$CRORDER=8SNP$CRLENGTH=255SNP$CRPRECISION=255SNP$CR$$SNPS_END_KEY*/



/*-----------------------------------------------*/
/* TASK No. 6 */

OdiOSCommand
sed -i 's/_/ /g' /dw_export/PROD/pending_acm_checks.csv

&


/*-----------------------------------------------*/
/* TASK No. 7 */

chmod 644 /dw_export/PROD/pending_acm_checks.csv

&


/*-----------------------------------------------*/
/* TASK No. 8 */

mv /dw_export/PROD/pending_acm_checks.csv /dw_export/PROD/finance/pending_acm_checks/pending_acm_checks_:v_data_export_run_date.csv

&


/*-----------------------------------------------*/
/* TASK No. 9 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 9 */




/*-----------------------------------------------*/
/* TASK No. 10 */

OdiFileDelete "-FILE=/dw_export/PROD/pending_acm_checks/pending_acm_checks*.csv" "-RECURSE=NO" "-CASESENS=YES" "-NOFILE_ERROR=NO" "-TODATE=:v_2_day_file_delete_date"

&


/*-----------------------------------------------*/
