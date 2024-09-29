
-- /* TASK No. 1 */

-- /* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 1 */




-- /*-----------------------------------------------*/
-- /* TASK No. 2 */

-- /* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 2 */




-- /*-----------------------------------------------*/
-- /* TASK No. 3 */
-- /* drop report table */

-- drop table RAX_APP_USER.actuate_ezprints_detail_stage

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 4 */
-- /* create report table */

-- create table RAX_APP_USER.actuate_ezprints_detail_stage as
-- select t.fiscal_year
-- , t.month_name
-- , t.fiscal_month_number
-- , o.country_name
-- ,o.AMS_BUSINESS_UNIT_NAME 
-- ,o.company_name
-- , case when f.source_entity_id = 49 then oec.type
--        when f.source_entity_id = 48 then orc.type
--        else 'N/A'
--   end
--   as type
-- , sum(f.revenue_amt) revenue
-- , sum(f.expense_amt) expense
-- from mart.ezdough_sales_fact f
-- , time t
-- , organization o
-- , marketing m
-- ,ods.ez_order_expense_curr oec
-- ,ods.ez_order_revenue_curr orc
-- , (select (case when to_number(:v_actuate_fiscal_year) = 9999 then fiscal_year else to_number(:v_actuate_fiscal_year) end) as fiscal_year from time
--             where trunc(sysdate - 7) = date_key) cfy
-- where f.ship_date = t.date_key
-- and f.job_ticket_org_id = o.organization_id
-- and f.source_entity_id in (48, 49)
-- and case when f.source_entity_id = 49 then f.source_system_key else null end = oec.order_expense_id(+)
-- and case when f.source_entity_id = 48 then f.source_system_key else null end = orc.order_revenue_id(+)
-- and t.fiscal_year = cfy.fiscal_year 
-- and f.marketing_id = m.marketing_id
-- group by t.fiscal_year
-- , t.fiscal_month_number
-- , t.month_name
-- , o.country_name
-- ,o.AMS_BUSINESS_UNIT_NAME 
-- ,o.company_name
-- , case when f.source_entity_id = 49 then oec.type
--        when f.source_entity_id = 48 then orc.type
--        else 'N/A'
--   end
-- having sum(f.revenue_amt) <> 0
-- or sum(f.expense_amt) <> 0
-- order by t.fiscal_year
-- , t.fiscal_month_number
-- , o.country_name
-- ,o.AMS_BUSINESS_UNIT_NAME 
-- ,o.company_name
-- , case when f.source_entity_id = 49 then oec.type
--        when f.source_entity_id = 48 then orc.type
--        else 'N/A'
--   end

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 5 */
-- /* Generate header */

-- create header	(FISCAL_YEAR,
-- 	MONTH_NAME,
-- 	FISCAL_MONTH_NUMBER,
-- 	COUNTRY_NAME,
-- 	AMS_BUSINESS_UNIT_NAME,
-- 	COMPANY_NAME,
-- 	TYPE,
-- 	REVENUE,
-- 	EXPENSE)

-- /*$$SNPS_START_KEYSNP$CRDWG_TABLESNP$CRTABLE_NAME=ezprints_detail.csvSNP$CRLOAD_FILE=/dw_export/PROD/ezprints_detail.csvSNP$CRFILE_FORMAT=DSNP$CRFILE_SEP_FIELD=0x002cSNP$CRFILE_SEP_LINE=0x000D0x000ASNP$CRFILE_FIRST_ROW=0SNP$CRFILE_ENC_FIELD="SNP$CRFILE_DEC_SEP=SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=FISCAL_YEARSNP$CRTYPE_NAME=STRINGSNP$CRORDER=1SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=MONTH_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=2SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=FISCAL_MONTH_NUMBERSNP$CRTYPE_NAME=STRINGSNP$CRORDER=3SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=COUNTRY_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=4SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=AMS_BUSINESS_UNIT_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=5SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=COMPANY_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=6SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=TYPESNP$CRTYPE_NAME=STRINGSNP$CRORDER=7SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=REVENUESNP$CRTYPE_NAME=STRINGSNP$CRORDER=8SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=EXPENSESNP$CRTYPE_NAME=STRINGSNP$CRORDER=9SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CR$$SNPS_END_KEY*/


-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 6 */
-- /* Insert new rows */

-- /* SOURCE CODE */


-- select 	
-- 	ACT_EZ.FISCAL_YEAR	   FISCAL_YEAR,
-- 	ACT_EZ.MONTH_NAME	   MONTH_NAME,
-- 	ACT_EZ.FISCAL_MONTH_NUMBER	   FISCAL_MONTH_NUMBER,
-- 	ACT_EZ.COUNTRY_NAME	   COUNTRY_NAME,
-- 	ACT_EZ.AMS_BUSINESS_UNIT_NAME	   AMS_BUSINESS_UNIT_NAME,
-- 	ACT_EZ.COMPANY_NAME	   COMPANY_NAME,
-- 	ACT_EZ.TYPE	   TYPE,
-- 	ACT_EZ.REVENUE	   REVENUE,
-- 	ACT_EZ.EXPENSE	   EXPENSE
-- from	RAX_APP_USER.ACTUATE_EZPRINTS_DETAIL_STAGE   ACT_EZ
-- where	
-- 	(1=1)	
	





-- /* Order the output by the UD1, UD2, UD3, UD4, UD5, UD6 Fields. */



-- &

-- /* TARGET CODE */
-- insert into "/dw_export/PROD/ezprints_detail.csv"
-- (
-- 	FISCAL_YEAR,
-- 	MONTH_NAME,
-- 	FISCAL_MONTH_NUMBER,
-- 	COUNTRY_NAME,
-- 	AMS_BUSINESS_UNIT_NAME,
-- 	COMPANY_NAME,
-- 	TYPE,
-- 	REVENUE,
-- 	EXPENSE
                     
-- )
-- values 
-- (
-- 	:FISCAL_YEAR,
-- 	:MONTH_NAME,
-- 	:FISCAL_MONTH_NUMBER,
-- 	:COUNTRY_NAME,
-- 	:AMS_BUSINESS_UNIT_NAME,
-- 	:COMPANY_NAME,
-- 	:TYPE,
-- 	:REVENUE,
-- 	:EXPENSE
                     
-- )
-- /*$$SNPS_START_KEYSNP$CRDWG_TABLESNP$CRTABLE_NAME=ezprints_detail.csvSNP$CRLOAD_FILE=/dw_export/PROD/ezprints_detail.csvSNP$CRFILE_FORMAT=DSNP$CRFILE_SEP_FIELD=0x002cSNP$CRFILE_SEP_LINE=0x000D0x000ASNP$CRFILE_FIRST_ROW=0SNP$CRFILE_ENC_FIELD="SNP$CRFILE_DEC_SEP=SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=FISCAL_YEARSNP$CRTYPE_NAME=STRINGSNP$CRORDER=1SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=MONTH_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=2SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=FISCAL_MONTH_NUMBERSNP$CRTYPE_NAME=STRINGSNP$CRORDER=3SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=COUNTRY_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=4SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=AMS_BUSINESS_UNIT_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=5SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=COMPANY_NAMESNP$CRTYPE_NAME=STRINGSNP$CRORDER=6SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=TYPESNP$CRTYPE_NAME=STRINGSNP$CRORDER=7SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=REVENUESNP$CRTYPE_NAME=STRINGSNP$CRORDER=8SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CRSNP$CRDWG_COLSNP$CRCOL_NAME=EXPENSESNP$CRTYPE_NAME=STRINGSNP$CRORDER=9SNP$CRLENGTH=50SNP$CRPRECISION=50SNP$CR$$SNPS_END_KEY*/



-- /*-----------------------------------------------*/
-- /* TASK No. 7 */

-- chmod 644 /dw_export/PROD/ezprints_detail.csv

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 8 */

-- mv /dw_export/PROD/ezprints_detail.csv /dw_export/PROD/finance/ezprints_detail/ezprints_detail:v_actuate_sysdate.csv

-- &


-- /*-----------------------------------------------*/
