/* TASK No. 1 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */
/* drop report table */

drop table RAX_APP_USER.actuate_counting_fee_new_stage

&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* create report table */

create table RAX_APP_USER.actuate_counting_fee_new_stage as
SELECT company_name
, decode(country_name,NULL,'.',country_name) country_name
, ams_business_unit_name
, area_name
, region_name
, territory_name
, territory_code
, bank_code, serial_nbr
, job_nbr
, cashtxn_amt
, cashtxn_date
, deposit_date
, photography_date
, case when ship_date = to_date('19000101','YYYYMMDD') then null else ship_date end as ship_date
, sellingmethod_desc
, count_fee_perc
 , DECODE (sellingmethod_desc,
               'PrePay', 'P',
               'Spec', 'S',
               'Proof', 'F'
              ) sellingmethodcode
, (DECODE (sellingmethod_desc,
                'PrePay', DECODE (SIGN (deposit_date - photography_date - 11),
                                  -1, 'Yes',
                                  'No'
                                 ),
                'Spec', DECODE (SIGN (deposit_date - ship_date - 41),
                                -1, 'Yes',
                                'No'
                               ),
                'Proof', CASE
                   WHEN ship_date= to_date('19000101','YYYYMMDD')
                      THEN 'NA'
                   ELSE 'Yes'
                END
               )
       ) AS count_fee_flag
,       (DECODE (sellingmethod_desc,
                'PrePay', (deposit_date - photography_date + 1),
                'Spec', (deposit_date - ship_date + 1),
                'Proof', 1,
                0
               )
       ) AS days_to_bank
, (DECODE (sellingmethod_desc,
                'PrePay', DECODE (SIGN (deposit_date - photography_date - 11),
                                  -1, cashtxn_amt * count_fee_perc,
                                  0
                                 ),
                'Spec', DECODE (SIGN (deposit_date - ship_date - 41),
                                -1, cashtxn_amt * count_fee_perc,
                                0
                               ),
                'Proof', CASE WHEN ship_date = to_date('19000101','YYYYMMDD')
                   THEN 0
                   ELSE cashtxn_amt * count_fee_perc
                END)
       ) AS count_fee_amt
,       (cashtxn_date - deposit_date) AS days_depdate_keydate
,        Fiscal_Year
  FROM (SELECT  /*+parallel(event,6) parallel(apo,6) parallel(event_payment,6) parallel(deposit,6) use_hash(APO,EVENT_PAYMENT,DEPOSIT)*/
                organization_4.organization_name AS company_name,
                 NULL AS country_name,
                 organization_3.organization_name AS ams_business_unit_name,
                 organization_2.organization_name AS area_name,
                 organization_1.organization_name AS region_name,
                 ORGANIZATION.organization_name AS territory_name,
                 event.territory_code, bank_account.bank_code,
                 deposit.sequence_number AS serial_nbr,
                 event.event_ref_id AS job_nbr,
                 SUM (event_payment.payment_amount) AS cashtxn_amt,
                 event_payment.payment_date AS cashtxn_date,
                 deposit.deposit_date, event.photography_date,
                 event.ship_date, event.selling_method AS sellingmethod_desc,
                 CASE
                    WHEN bank_code LIKE '%564'
                       THEN .004
                    WHEN bank_code LIKE '%572'
                       THEN .004
                    WHEN bank_code LIKE 'CP77%'
                       THEN .004
                    WHEN bank_code LIKE 'MP77%'
                       THEN .004
                    ELSE .012
                 END AS count_fee_perc,
                t2.fiscal_year AS Fiscal_Year
            FROM ods_own.org_relationship org_relationship_3,
                 ods_own.ORGANIZATION organization_4,
                 ods_own.ORGANIZATION organization_3,
                 ods_own.org_relationship org_relationship_2,
                 ods_own.ORGANIZATION organization_2,
                 ods_own.org_relationship org_relationship_1,
                 ods_own.ORGANIZATION organization_1,
                 ods_own.org_relationship org_relationship,
                 ods_own.ORGANIZATION ORGANIZATION,
                 ods_own.event event,
                 ods_own.event_payment event_payment,
                 ods_own.deposit deposit,
                 ods_own.bank_account bank_account,
                 ods_own.apo,
                 ods_own.sub_program,
                 ods_own.program,
                 mart.time t,
                 mart.time t2
           WHERE (org_relationship_3.parent_organization_oid =
                                               organization_4.organization_oid
                 )
             AND (organization_3.organization_oid =
                                     org_relationship_3.child_organization_oid
                 )
             AND (org_relationship_2.parent_organization_oid =
                                               organization_3.organization_oid
                 )
             AND (organization_2.organization_oid =
                                     org_relationship_2.child_organization_oid
                 )
             AND (org_relationship_1.parent_organization_oid =
                                               organization_2.organization_oid
                 )
             AND (organization_1.organization_oid =
                                     org_relationship_1.child_organization_oid
                 )
             AND (org_relationship.parent_organization_oid =
                                               organization_1.organization_oid
                 )
             AND (org_relationship.child_organization_oid =
                                                 ORGANIZATION.organization_oid
                 )
             AND (ORGANIZATION.org_code = event.territory_code)
               
             AND (event_payment.event_oid = event.event_oid)
             AND (event_payment.deposit_oid = deposit.deposit_oid)
             AND (deposit.bank_account_oid = bank_account.bank_account_oid)
             AND ods_own.apo.apo_oid(+) = ods_own.event.apo_oid

             AND ods_own.sub_program.sub_program_oid(+) =
                                                   ods_own.apo.sub_program_oid
             AND ods_own.program.program_oid(+) =
                                               ods_own.sub_program.program_oid
             AND (ORGANIZATION.org_type_level = 6)
             AND (organization_1.org_type_level = 5)
             AND (organization_2.org_type_level = 4)
             AND (organization_3.org_type_level = 3)
             AND (organization_4.org_type_level = 2)
             AND t.date_key = trunc(sysdate) - 6
             AND event_payment.ods_create_date >= t.fiscal_year_begin_date - interval '1' year
             AND event_payment.ods_create_date <= t.fiscal_year_end_date 
             AND trunc(event_payment.ods_create_date) = t2.date_key
             --AND cashtxn_code = 1
             AND ods_own.deposit.entry_type NOT IN ('CORRECTION', 'NSF')
             AND NVL (ods_own.program.program_name, 'NULL VALUE') <>
                                                                 'Money Trans'
             AND SUBSTR (bank_code, 1, 3) NOT IN ('NSS', 'JF0')
             AND SUBSTR (bank_code, 5, 1) = ' '
     --  and event.event_ref_id ='EVT2HR44F'
              AND event_payment.territory_account_type IN
                               ('Underclass', 'SpecialEvents', 'RemindTheX')
        GROUP BY organization_4.organization_name,
                 --  country_name,
                 organization_3.organization_name,
                 organization_2.organization_name,
                 organization_1.organization_name,
                 ORGANIZATION.organization_name,
                 event.territory_code,
                 bank_code,
                 deposit.sequence_number,
                 event.event_ref_id,
                 event_payment.payment_date,
                 deposit_date,
                 photography_date,
                 ship_date,
                 event.selling_method,
                 t2.fiscal_year,
                 CASE
                    WHEN bank_code LIKE '%564'
                       THEN .004
                    WHEN bank_code LIKE '%572'
                       THEN .004
                    WHEN bank_code LIKE 'CP77%'
                       THEN .004
                    WHEN bank_code LIKE 'MP77%'
                       THEN .004
                    ELSE .012
                 END)
 WHERE cashtxn_amt <> 0
AND area_name not like '%Canada%'



&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* grant permission */

grant select on rax_app_user.actuate_counting_fee_new_stage to ODS_SELECT_ROLE ,MART_USER


&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Generate header */

create header	(COUNTRY_NAME,
	COMPANY_NAME,
	AREA_NAME,
	REGION_NAME,
	TERRITORY_CODE,
	TERRITORY_NAME,
	JOB_NBR,
	AMS_BUSINESS_UNIT_NAME,
	BANK_CODE,
	DEPOSIT_DATE,
	PHOTOGRAPHY_DATE,
	SHIP_DATE,
	SELLINGMETHOD_DESC,
	SERIAL_NBR,
	CASHTXN_AMT,
	CASHTXN_DATE,
	COUNT_FEE_PERC,
	SELLINGMETHODCODE,
	COUNT_FEE_FLAG,
	DAYS_TO_BANK,
	COUNT_FEE_AMT,
	DAYS_DEPDATE_KEYDATE,
	FISCAL_YEAR)

/*$$SNPS_START_KEYSNP$CRDWG_TABLESNP$CRTABLE_NAME=counting_fee_new.csvSNP$CRLOAD_FILE=/dw_export/PROD/counting_fee_new.csvSNP$CRFILE_FORMAT=DSNP$CRFILE_SEP_FIELD=0x002cSNP$CRFILE_SEP_LINE=0x000D0x000ASNP$CRFILE_FIRST_ROW=0SNP$CRFILE_ENC_FIELD="SNP$CRFILE_DEC_SEP=SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=COUNTRY_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=1SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=COMPANY_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=2SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=AREA_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=3SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=REGION_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=4SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=TERRITORY_CODESNP$CRTYPE_NAME=STRINGSNP$CRORDER=5SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=TERRITORY_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=6SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=JOB_NBRSNP$CRTYPE_NAME=STRINGSNP$CRORDER=7SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=AMS_BUSINESS_UNIT_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=8SNP$CRLENGTH=100SNP$CRPRECISION=100SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=BANK_CODESNP$CRTYPE_NAME=STRINGSNP$CRORDER=9SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=DEPOSIT_DATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=10SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=PHOTOGRAPHY_DATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=11SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=SHIP_DATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=12SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=SELLINGMETHOD_DESCSNP$CRTYPE_NAME=STRINGSNP$CRORDER=13SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=SERIAL_NBRSNP$CRTYPE_NAME=STRINGSNP$CRORDER=14SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=CASHTXN_AMTSNP$CRTYPE_NAME=STRINGSNP$CRORDER=15SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=CASHTXN_DATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=16SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=COUNT_FEE_PERCSNP$CRTYPE_NAME=STRINGSNP$CRORDER=17SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=SELLINGMETHODCODESNP$CRTYPE_NAME=STRINGSNP$CRORDER=18SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=COUNT_FEE_FLAGSNP$CRTYPE_NAME=STRINGSNP$CRORDER=19SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=DAYS_TO_BANKSNP$CRTYPE_NAME=STRINGSNP$CRORDER=20SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=COUNT_FEE_AMTSNP$CRTYPE_NAME=STRINGSNP$CRORDER=21SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=DAYS_DEPDATE_KEYDATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=22SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=FISCAL_YEARSNP$CRTYPE_NAME=STRINGSNP$CRORDER=23SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CR$$SNPS_END_KEY*/


&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Insert new rows */

/* SOURCE CODE */


select 	
	case when ACT_COUNT.COUNTRY_NAME ='.' then ' '
else ACT_COUNT.COUNTRY_NAME end	   COUNTRY_NAME,
	ACT_COUNT.COMPANY_NAME	   COMPANY_NAME,
	ACT_COUNT.AREA_NAME	   AREA_NAME,
	ACT_COUNT.REGION_NAME	   REGION_NAME,
	ACT_COUNT.TERRITORY_CODE	   TERRITORY_CODE,
	ACT_COUNT.TERRITORY_NAME	   TERRITORY_NAME,
	ACT_COUNT.JOB_NBR	   JOB_NBR,
	ACT_COUNT.AMS_BUSINESS_UNIT_NAME	   AMS_BUSINESS_UNIT_NAME,
	ACT_COUNT.BANK_CODE	   BANK_CODE,
	to_char(ACT_COUNT.DEPOSIT_DATE,'MM/DD/YYYY')	   DEPOSIT_DATE,
	to_char(ACT_COUNT.PHOTOGRAPHY_DATE,'MM/DD/YYYY')	   PHOTOGRAPHY_DATE,
	to_char( ACT_COUNT.SHIP_DATE,'MM/DD/YYYY')	   SHIP_DATE,
	ACT_COUNT.SELLINGMETHOD_DESC	   SELLINGMETHOD_DESC,
	ACT_COUNT.SERIAL_NBR	   SERIAL_NBR,
	ACT_COUNT.CASHTXN_AMT	   CASHTXN_AMT,
	to_char(ACT_COUNT.CASHTXN_DATE,'MM/DD/YYYY')	   CASHTXN_DATE,
	ACT_COUNT.COUNT_FEE_PERC	   COUNT_FEE_PERC,
	ACT_COUNT.SELLINGMETHODCODE	   SELLINGMETHODCODE,
	ACT_COUNT.COUNT_FEE_FLAG	   COUNT_FEE_FLAG,
	ACT_COUNT.DAYS_TO_BANK	   DAYS_TO_BANK,
	ACT_COUNT.COUNT_FEE_AMT	   COUNT_FEE_AMT,
	ACT_COUNT.DAYS_DEPDATE_KEYDATE	   DAYS_DEPDATE_KEYDATE,
	ACT_COUNT.FISCAL_YEAR	   FISCAL_YEAR
from	RAX_APP_USER.ACTUATE_COUNTING_FEE_NEW_STAGE   ACT_COUNT
where	
	(1=1)	
	





/* Order the output by the UD1, UD2, UD3, UD4, UD5, UD6 Fields. */



&

/* TARGET CODE */
insert into "/dw_export/PROD/counting_fee_new.csv"
(
	COUNTRY_NAME,
	COMPANY_NAME,
	AREA_NAME,
	REGION_NAME,
	TERRITORY_CODE,
	TERRITORY_NAME,
	JOB_NBR,
	AMS_BUSINESS_UNIT_NAME,
	BANK_CODE,
	DEPOSIT_DATE,
	PHOTOGRAPHY_DATE,
	SHIP_DATE,
	SELLINGMETHOD_DESC,
	SERIAL_NBR,
	CASHTXN_AMT,
	CASHTXN_DATE,
	COUNT_FEE_PERC,
	SELLINGMETHODCODE,
	COUNT_FEE_FLAG,
	DAYS_TO_BANK,
	COUNT_FEE_AMT,
	DAYS_DEPDATE_KEYDATE,
	FISCAL_YEAR
                     
)
values 
(
	:COUNTRY_NAME,
	:COMPANY_NAME,
	:AREA_NAME,
	:REGION_NAME,
	:TERRITORY_CODE,
	:TERRITORY_NAME,
	:JOB_NBR,
	:AMS_BUSINESS_UNIT_NAME,
	:BANK_CODE,
	:DEPOSIT_DATE,
	:PHOTOGRAPHY_DATE,
	:SHIP_DATE,
	:SELLINGMETHOD_DESC,
	:SERIAL_NBR,
	:CASHTXN_AMT,
	:CASHTXN_DATE,
	:COUNT_FEE_PERC,
	:SELLINGMETHODCODE,
	:COUNT_FEE_FLAG,
	:DAYS_TO_BANK,
	:COUNT_FEE_AMT,
	:DAYS_DEPDATE_KEYDATE,
	:FISCAL_YEAR
                     
)
/*$$SNPS_START_KEYSNP$CRDWG_TABLESNP$CRTABLE_NAME=counting_fee_new.csvSNP$CRLOAD_FILE=/dw_export/PROD/counting_fee_new.csvSNP$CRFILE_FORMAT=DSNP$CRFILE_SEP_FIELD=0x002cSNP$CRFILE_SEP_LINE=0x000D0x000ASNP$CRFILE_FIRST_ROW=0SNP$CRFILE_ENC_FIELD="SNP$CRFILE_DEC_SEP=SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=COUNTRY_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=1SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=COMPANY_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=2SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=AREA_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=3SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=REGION_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=4SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=TERRITORY_CODESNP$CRTYPE_NAME=STRINGSNP$CRORDER=5SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=TERRITORY_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=6SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=JOB_NBRSNP$CRTYPE_NAME=STRINGSNP$CRORDER=7SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=AMS_BUSINESS_UNIT_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=8SNP$CRLENGTH=100SNP$CRPRECISION=100SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=BANK_CODESNP$CRTYPE_NAME=STRINGSNP$CRORDER=9SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=DEPOSIT_DATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=10SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=PHOTOGRAPHY_DATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=11SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=SHIP_DATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=12SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=SELLINGMETHOD_DESCSNP$CRTYPE_NAME=STRINGSNP$CRORDER=13SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=SERIAL_NBRSNP$CRTYPE_NAME=STRINGSNP$CRORDER=14SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=CASHTXN_AMTSNP$CRTYPE_NAME=STRINGSNP$CRORDER=15SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=CASHTXN_DATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=16SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=COUNT_FEE_PERCSNP$CRTYPE_NAME=STRINGSNP$CRORDER=17SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=SELLINGMETHODCODESNP$CRTYPE_NAME=STRINGSNP$CRORDER=18SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=COUNT_FEE_FLAGSNP$CRTYPE_NAME=STRINGSNP$CRORDER=19SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=DAYS_TO_BANKSNP$CRTYPE_NAME=STRINGSNP$CRORDER=20SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=COUNT_FEE_AMTSNP$CRTYPE_NAME=STRINGSNP$CRORDER=21SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=DAYS_DEPDATE_KEYDATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=22SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=FISCAL_YEARSNP$CRTYPE_NAME=STRINGSNP$CRORDER=23SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CR$$SNPS_END_KEY*/



/*-----------------------------------------------*/
/* TASK No. 7 */

chmod 644 /dw_export/PROD/counting_fee_new.csv

&


/*-----------------------------------------------*/
/* TASK No. 8 */

mv /dw_export/PROD/counting_fee_new.csv /dw_export/PROD/finance/counting_fee_new/counting_fee_new:v_actuate_sysdate.csv

&


/*-----------------------------------------------*/
