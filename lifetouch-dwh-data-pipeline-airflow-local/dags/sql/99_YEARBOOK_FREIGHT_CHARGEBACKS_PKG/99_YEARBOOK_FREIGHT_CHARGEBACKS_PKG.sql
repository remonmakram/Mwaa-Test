/* TASK No. 1 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */
/* drop table */

-- drop table RAX_APP_USER.YB_FREIGHT_CHARGEBACKS

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 3 */
-- /* create table */

-- create table RAX_APP_USER.YB_FREIGHT_CHARGEBACKS as
-- select 
-- a.EVENT_REF_ID
-- ,min(a.SHIP_DATE) SHIP_DATE
-- ,sum(a.FREIGHT_CHARGE) FREIGHT_CHARGE
-- from
-- (select
-- e.EVENT_REF_ID
-- ,to_char(s.SHIP_DATE,'MM/DD/YYYY') SHIP_DATE
-- ,min(s.TOTAL_ACTUAL_CHARGE) FREIGHT_CHARGE
-- from
-- ODS_OWN.EVENT e
-- ,ODS_OWN.SUB_PROGRAM sp
-- ,ODS_OWN.ORDER_HEADER oh
-- ,ODS_OWN.ORDER_LINE ol
-- ,ODS_OWN.SHIPMENT_LINE sl
-- ,ODS_OWN.SHIPMENT s
-- ,ODS_OWN.APO apo
-- where (1=1)
-- and apo.SCHOOL_YEAR = 2017
-- --and e.EVENT_REF_ID in ('2321917','13156317')
-- and e.APO_OID=apo.APO_OID
-- and apo.SUB_PROGRAM_OID=sp.SUB_PROGRAM_OID
-- and sp.SUB_PROGRAM_NAME='Yearbook'
-- and apo.FINANCIAL_PROCESSING_SYSTEM='Spectrum'
-- and oh.EVENT_OID=e.EVENT_OID
-- and ol.ORDER_HEADER_OID=oh.ORDER_HEADER_OID
-- and sl.ORDER_LINE_OID=ol.ORDER_LINE_OID
-- and s.SHIPMENT_OID=sl.SHIPMENT_OID
-- group by
-- e.EVENT_REF_ID
-- ,to_char(s.SHIP_DATE,'MM/DD/YYYY')
-- order by
-- e.EVENT_REF_ID 
-- ,to_char(s.SHIP_DATE,'MM/DD/YYYY')) a
-- group by
-- a.EVENT_REF_ID



-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 4 */
-- /* Generate header */

-- create header	(EVENT_REF_ID,
-- 	SHIP_DATE,
-- 	FREIGHT_CHARGE)

-- /*$$SNPS_START_KEYSNP$CRDWG_TABLESNP$CRTABLE_NAME=YB_FREIGHT_CHARGEBACKS.csvSNP$CRLOAD_FILE=/dw_export/PROD/YB_FREIGHT_CHARGEBACKS.csvSNP$CRFILE_FORMAT=DSNP$CRFILE_SEP_FIELD=0x002cSNP$CRFILE_SEP_LINE=0x000D0x000ASNP$CRFILE_FIRST_ROW=0SNP$CRFILE_ENC_FIELD="SNP$CRFILE_DEC_SEP=SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=EVENT_REF_IDSNP$CRTYPE_NAME=STRINGSNP$CRORDER=1SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=SHIP_DATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=2SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=FREIGHT_CHARGESNP$CRTYPE_NAME=STRINGSNP$CRORDER=3SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CR$$SNPS_END_KEY*/


-- &


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Insert new rows */

/* SOURCE CODE */


-- select 	
-- 	YFC.EVENT_REF_ID	   EVENT_REF_ID,
-- 	YFC.SHIP_DATE	   SHIP_DATE,
-- 	YFC.FREIGHT_CHARGE	   FREIGHT_CHARGE
-- from	RAX_APP_USER.YB_FREIGHT_CHARGEBACKS   YFC
-- where	
-- 	(1=1)	
	





-- /* Order the output by the UD1, UD2, UD3, UD4, UD5, UD6 Fields. */
 
-- ORDER BY  EVENT_REF_ID
-- , SHIP_DATE
-- , FREIGHT_CHARGE










-- &

-- /* TARGET CODE */
-- insert into "/dw_export/PROD/YB_FREIGHT_CHARGEBACKS.csv"
-- (
-- 	EVENT_REF_ID,
-- 	SHIP_DATE,
-- 	FREIGHT_CHARGE
                     
-- )
-- values 
-- (
-- 	:EVENT_REF_ID,
-- 	:SHIP_DATE,
-- 	:FREIGHT_CHARGE
                     
-- )
/*$$SNPS_START_KEYSNP$CRDWG_TABLESNP$CRTABLE_NAME=YB_FREIGHT_CHARGEBACKS.csvSNP$CRLOAD_FILE=/dw_export/PROD/YB_FREIGHT_CHARGEBACKS.csvSNP$CRFILE_FORMAT=DSNP$CRFILE_SEP_FIELD=0x002cSNP$CRFILE_SEP_LINE=0x000D0x000ASNP$CRFILE_FIRST_ROW=0SNP$CRFILE_ENC_FIELD="SNP$CRFILE_DEC_SEP=SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=EVENT_REF_IDSNP$CRTYPE_NAME=STRINGSNP$CRORDER=1SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=SHIP_DATESNP$CRTYPE_NAME=STRINGSNP$CRORDER=2SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=FREIGHT_CHARGESNP$CRTYPE_NAME=STRINGSNP$CRORDER=3SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CR$$SNPS_END_KEY*/



/*-----------------------------------------------*/
/* TASK No. 6 */

-- chmod 644 /dw_export/PROD/YB_FREIGHT_CHARGEBACKS.csv

-- &


/*-----------------------------------------------*/
/* TASK No. 7 */

-- mv /dw_export/PROD/YB_FREIGHT_CHARGEBACKS.csv /dw_export/PROD/finance/yearbook_sales/YearbookFreightChargebacksByJob:v_data_export_run_date.csv

-- &


/*-----------------------------------------------*/
/* TASK No. 8 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 8 */




-- /*-----------------------------------------------*/
-- /* TASK No. 9 */
-- OdiFileDelete "-FILE=/dw_export/PROD/finance/yearbook_sales/YearbookFreightChargebacksByJob*.csv" "-RECURSE=NO" "-CASESENS=YES" "-NOFILE_ERROR=NO" "-TODATE=:v_30_day_file_delete_date"

-- &


/*-----------------------------------------------*/
