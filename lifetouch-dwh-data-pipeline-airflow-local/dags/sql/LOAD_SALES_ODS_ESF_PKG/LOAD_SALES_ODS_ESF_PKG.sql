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

-- OdiStartScen "-SCEN_NAME=LOAD_SALES_ODS_ESF_PRC" "-SCEN_VERSION=-1" "-SYNC_MODE=1"

-- &


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Drop work table */

-- drop table RAX_APP_USER.C$_0ODS_ESF_SUMMARY

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0ODS_ESF_SUMMARY';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Create work table */

create table RAX_APP_USER.C$_0ODS_ESF_SUMMARY
(
	C1_EVENT_REF_ID	VARCHAR2(40) NULL,
	C2_SHIP_DATE	DATE NULL,
	C3_PAID_ORDER_QTY	NUMBER NULL,
	C4_CALCULATED_PAID_ORDER_QTY	NUMBER NULL,
	C5_PERFECT_ORDER_SALES_AMT	NUMBER NULL,
	C6_SHIPPED_ORDER_QTY	NUMBER NULL,
	C7_UNPAID_ORDER_QTY	NUMBER NULL,
	C8_X_NO_PURCHASE_QTY	NUMBER NULL,
	C9_TRANSACTION_AMOUNT	NUMBER NULL,
	C10_ACCT_CMSN_PAID_AMT	NUMBER NULL,
	C11_ORDER_SALES_AMT	NUMBER NULL,
	C12_ORDER_SALES_TAX_AMT	NUMBER NULL,
	C13_TERRITORY_CMSN_AMT	NUMBER NULL,
	C14_TERRITORY_CHARGEBACK_AMT	NUMBER NULL,
	C15_IMAGE_QTY	NUMBER NULL,
	C16_PROOF_QTY	NUMBER NULL,
	C17_ODS_CREATE_DATE	DATE NULL,
	C18_ODS_MODIFY_DATE	DATE NULL,
	C19_CAPTURE_SESSION_QTY	NUMBER NULL,
	C20_STAFF_CAPTURE_SESSION_QTY	NUMBER NULL,
	C21_CLICK_QTY	NUMBER NULL,
	C22_EST_ACCT_CMSN_AMT	NUMBER NULL,
	C23_TOT_EST_ACCT_CMSN_AMT	NUMBER NULL
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Load data */

/* SOURCE CODE */
-- select	
-- 	STG_SODS_ESF.EVENT_REF_ID	   C1_EVENT_REF_ID,
-- 	STG_SODS_ESF.SHIP_DATE	   C2_SHIP_DATE,
-- 	STG_SODS_ESF.PAID_ORDER_QTY	   C3_PAID_ORDER_QTY,
-- 	STG_SODS_ESF.CALCULATED_PAID_ORDER_QTY	   C4_CALCULATED_PAID_ORDER_QTY,
-- 	STG_SODS_ESF.PERFECT_ORDER_SALES_AMT	   C5_PERFECT_ORDER_SALES_AMT,
-- 	STG_SODS_ESF.SHIPPED_ORDER_QTY	   C6_SHIPPED_ORDER_QTY,
-- 	STG_SODS_ESF.UNPAID_ORDER_QTY	   C7_UNPAID_ORDER_QTY,
-- 	STG_SODS_ESF.X_NO_PURCHASE_QTY	   C8_X_NO_PURCHASE_QTY,
-- 	STG_SODS_ESF.TRANSACTION_AMOUNT	   C9_TRANSACTION_AMOUNT,
-- 	STG_SODS_ESF.ACCT_CMSN_PAID_AMT	   C10_ACCT_CMSN_PAID_AMT,
-- 	STG_SODS_ESF.ORDER_SALES_AMT	   C11_ORDER_SALES_AMT,
-- 	STG_SODS_ESF.ORDER_SALES_TAX_AMT	   C12_ORDER_SALES_TAX_AMT,
-- 	STG_SODS_ESF.TERRITORY_CMSN_AMT	   C13_TERRITORY_CMSN_AMT,
-- 	STG_SODS_ESF.TERRITORY_CHARGEBACK_AMT	   C14_TERRITORY_CHARGEBACK_AMT,
-- 	STG_SODS_ESF.IMAGE_QTY	   C15_IMAGE_QTY,
-- 	STG_SODS_ESF.PROOF_QTY	   C16_PROOF_QTY,
-- 	STG_SODS_ESF.ODS_CREATE_DATE	   C17_ODS_CREATE_DATE,
-- 	STG_SODS_ESF.ODS_MODIFY_DATE	   C18_ODS_MODIFY_DATE,
-- 	STG_SODS_ESF.CAPTURE_SESSION_QTY	   C19_CAPTURE_SESSION_QTY,
-- 	STG_SODS_ESF.STAFF_CAPTURE_SESSION_QTY	   C20_STAFF_CAPTURE_SESSION_QTY,
-- 	STG_SODS_ESF.CLICK_QTY	   C21_CLICK_QTY,
-- 	STG_SODS_ESF.EST_ACCT_CMSN_AMT	   C22_EST_ACCT_CMSN_AMT,
-- 	STG_SODS_ESF.TOT_EST_ACCT_CMSN_AMT	   C23_TOT_EST_ACCT_CMSN_AMT
-- from	RAX_APP_USER.STG_SODS_ESF   STG_SODS_ESF
-- where	(1=1)
-- And (STG_SODS_ESF.ODS_MODIFY_DATE >= TO_DATE(SUBSTR('#WAREHOUSE_PROJECT.v_cdc_load_date', 1, 19), 'YYYY-MM-DD HH24:MI:SS') - #WAREHOUSE_PROJECT.v_cdc_sales_ods_overlap)





-- &

/* TARGET CODE */
insert into RAX_APP_USER.C$_0ODS_ESF_SUMMARY
(
	C1_EVENT_REF_ID,
	C2_SHIP_DATE,
	C3_PAID_ORDER_QTY,
	C4_CALCULATED_PAID_ORDER_QTY,
	C5_PERFECT_ORDER_SALES_AMT,
	C6_SHIPPED_ORDER_QTY,
	C7_UNPAID_ORDER_QTY,
	C8_X_NO_PURCHASE_QTY,
	C9_TRANSACTION_AMOUNT,
	C10_ACCT_CMSN_PAID_AMT,
	C11_ORDER_SALES_AMT,
	C12_ORDER_SALES_TAX_AMT,
	C13_TERRITORY_CMSN_AMT,
	C14_TERRITORY_CHARGEBACK_AMT,
	C15_IMAGE_QTY,
	C16_PROOF_QTY,
	C17_ODS_CREATE_DATE,
	C18_ODS_MODIFY_DATE,
	C19_CAPTURE_SESSION_QTY,
	C20_STAFF_CAPTURE_SESSION_QTY,
	C21_CLICK_QTY,
	C22_EST_ACCT_CMSN_AMT,
	C23_TOT_EST_ACCT_CMSN_AMT
)select	
	STG_SODS_ESF.EVENT_REF_ID	   C1_EVENT_REF_ID,
	STG_SODS_ESF.SHIP_DATE	   C2_SHIP_DATE,
	STG_SODS_ESF.PAID_ORDER_QTY	   C3_PAID_ORDER_QTY,
	STG_SODS_ESF.CALCULATED_PAID_ORDER_QTY	   C4_CALCULATED_PAID_ORDER_QTY,
	STG_SODS_ESF.PERFECT_ORDER_SALES_AMT	   C5_PERFECT_ORDER_SALES_AMT,
	STG_SODS_ESF.SHIPPED_ORDER_QTY	   C6_SHIPPED_ORDER_QTY,
	STG_SODS_ESF.UNPAID_ORDER_QTY	   C7_UNPAID_ORDER_QTY,
	STG_SODS_ESF.X_NO_PURCHASE_QTY	   C8_X_NO_PURCHASE_QTY,
	STG_SODS_ESF.TRANSACTION_AMOUNT	   C9_TRANSACTION_AMOUNT,
	STG_SODS_ESF.ACCT_CMSN_PAID_AMT	   C10_ACCT_CMSN_PAID_AMT,
	STG_SODS_ESF.ORDER_SALES_AMT	   C11_ORDER_SALES_AMT,
	STG_SODS_ESF.ORDER_SALES_TAX_AMT	   C12_ORDER_SALES_TAX_AMT,
	STG_SODS_ESF.TERRITORY_CMSN_AMT	   C13_TERRITORY_CMSN_AMT,
	STG_SODS_ESF.TERRITORY_CHARGEBACK_AMT	   C14_TERRITORY_CHARGEBACK_AMT,
	STG_SODS_ESF.IMAGE_QTY	   C15_IMAGE_QTY,
	STG_SODS_ESF.PROOF_QTY	   C16_PROOF_QTY,
	STG_SODS_ESF.ODS_CREATE_DATE	   C17_ODS_CREATE_DATE,
	STG_SODS_ESF.ODS_MODIFY_DATE	   C18_ODS_MODIFY_DATE,
	STG_SODS_ESF.CAPTURE_SESSION_QTY	   C19_CAPTURE_SESSION_QTY,
	STG_SODS_ESF.STAFF_CAPTURE_SESSION_QTY	   C20_STAFF_CAPTURE_SESSION_QTY,
	STG_SODS_ESF.CLICK_QTY	   C21_CLICK_QTY,
	STG_SODS_ESF.EST_ACCT_CMSN_AMT	   C22_EST_ACCT_CMSN_AMT,
	STG_SODS_ESF.TOT_EST_ACCT_CMSN_AMT	   C23_TOT_EST_ACCT_CMSN_AMT
from	RAX_APP_USER.STG_SODS_ESF   STG_SODS_ESF
where	(1=1)
And (STG_SODS_ESF.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_sales_ods_overlap)

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0ODS_ESF_SUMMARY',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;




&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Drop flow table */

-- drop table RAX_APP_USER.I$_ODS_ESF_SUMMARY 
BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_ODS_ESF_SUMMARY';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_ODS_ESF_SUMMARY
(
	ODS_ESF_SUMMARY_ID		NUMBER NULL,
	EFFECTIVE_DATE		DATE NULL,
	LOAD_ID		NUMBER NULL,
	ACTIVE_IND		VARCHAR2(5) NULL,
	EVENT_REF_ID		VARCHAR2(40) NULL,
	SHIP_DATE		DATE NULL,
	PAID_ORDER_QTY		NUMBER NULL,
	CALCULATED_PAID_ORDER_QTY		NUMBER NULL,
	PERFECT_ORDER_SALES_AMT		NUMBER NULL,
	SHIPPED_ORDER_QTY		NUMBER NULL,
	UNPAID_ORDER_QTY		NUMBER NULL,
	X_NO_PURCHASE_QTY		NUMBER NULL,
	TRANSACTION_AMOUNT		NUMBER NULL,
	ACCT_CMSN_PAID_AMT		NUMBER NULL,
	ORDER_SALES_AMT		NUMBER NULL,
	ORDER_SALES_TAX_AMT		NUMBER NULL,
	TERRITORY_CMSN_AMT		NUMBER NULL,
	TERRITORY_CHARGEBACK_AMT		NUMBER NULL,
	IMAGE_QTY		NUMBER NULL,
	PROOF_QTY		NUMBER NULL,
	ODS_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	CAPTURE_SESSION_QTY		NUMBER NULL,
	STAFF_CAPTURE_SESSION_QTY		NUMBER NULL,
	CLICK_QTY		NUMBER NULL,
	EST_ACCT_CMSN_AMT		NUMBER NULL,
	TOT_EST_ACCT_CMSN_AMT		NUMBER NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_ODS_ESF_SUMMARY
(
	EVENT_REF_ID,
	SHIP_DATE,
	PAID_ORDER_QTY,
	CALCULATED_PAID_ORDER_QTY,
	PERFECT_ORDER_SALES_AMT,
	SHIPPED_ORDER_QTY,
	UNPAID_ORDER_QTY,
	X_NO_PURCHASE_QTY,
	TRANSACTION_AMOUNT,
	ACCT_CMSN_PAID_AMT,
	ORDER_SALES_AMT,
	ORDER_SALES_TAX_AMT,
	TERRITORY_CMSN_AMT,
	TERRITORY_CHARGEBACK_AMT,
	IMAGE_QTY,
	PROOF_QTY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	CAPTURE_SESSION_QTY,
	STAFF_CAPTURE_SESSION_QTY,
	CLICK_QTY,
	EST_ACCT_CMSN_AMT,
	TOT_EST_ACCT_CMSN_AMT,
	IND_UPDATE
)
select 
EVENT_REF_ID,
	SHIP_DATE,
	PAID_ORDER_QTY,
	CALCULATED_PAID_ORDER_QTY,
	PERFECT_ORDER_SALES_AMT,
	SHIPPED_ORDER_QTY,
	UNPAID_ORDER_QTY,
	X_NO_PURCHASE_QTY,
	TRANSACTION_AMOUNT,
	ACCT_CMSN_PAID_AMT,
	ORDER_SALES_AMT,
	ORDER_SALES_TAX_AMT,
	TERRITORY_CMSN_AMT,
	TERRITORY_CHARGEBACK_AMT,
	IMAGE_QTY,
	PROOF_QTY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	CAPTURE_SESSION_QTY,
	STAFF_CAPTURE_SESSION_QTY,
	CLICK_QTY,
	EST_ACCT_CMSN_AMT,
	TOT_EST_ACCT_CMSN_AMT,
	IND_UPDATE
 from (


select 	 
	
	C1_EVENT_REF_ID EVENT_REF_ID,
	C2_SHIP_DATE SHIP_DATE,
	C3_PAID_ORDER_QTY PAID_ORDER_QTY,
	C4_CALCULATED_PAID_ORDER_QTY CALCULATED_PAID_ORDER_QTY,
	C5_PERFECT_ORDER_SALES_AMT PERFECT_ORDER_SALES_AMT,
	C6_SHIPPED_ORDER_QTY SHIPPED_ORDER_QTY,
	C7_UNPAID_ORDER_QTY UNPAID_ORDER_QTY,
	C8_X_NO_PURCHASE_QTY X_NO_PURCHASE_QTY,
	C9_TRANSACTION_AMOUNT TRANSACTION_AMOUNT,
	C10_ACCT_CMSN_PAID_AMT ACCT_CMSN_PAID_AMT,
	C11_ORDER_SALES_AMT ORDER_SALES_AMT,
	C12_ORDER_SALES_TAX_AMT ORDER_SALES_TAX_AMT,
	C13_TERRITORY_CMSN_AMT TERRITORY_CMSN_AMT,
	C14_TERRITORY_CHARGEBACK_AMT TERRITORY_CHARGEBACK_AMT,
	C15_IMAGE_QTY IMAGE_QTY,
	C16_PROOF_QTY PROOF_QTY,
	C17_ODS_CREATE_DATE ODS_CREATE_DATE,
	C18_ODS_MODIFY_DATE ODS_MODIFY_DATE,
	C19_CAPTURE_SESSION_QTY CAPTURE_SESSION_QTY,
	C20_STAFF_CAPTURE_SESSION_QTY STAFF_CAPTURE_SESSION_QTY,
	C21_CLICK_QTY CLICK_QTY,
	C22_EST_ACCT_CMSN_AMT EST_ACCT_CMSN_AMT,
	C23_TOT_EST_ACCT_CMSN_AMT TOT_EST_ACCT_CMSN_AMT,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0ODS_ESF_SUMMARY
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS.ODS_ESF_SUMMARY T
	where	T.EVENT_REF_ID	= S.EVENT_REF_ID
	and	T.SHIP_DATE	= S.SHIP_DATE 
		 and ((T.PAID_ORDER_QTY = S.PAID_ORDER_QTY) or (T.PAID_ORDER_QTY IS NULL and S.PAID_ORDER_QTY IS NULL)) and
		((T.CALCULATED_PAID_ORDER_QTY = S.CALCULATED_PAID_ORDER_QTY) or (T.CALCULATED_PAID_ORDER_QTY IS NULL and S.CALCULATED_PAID_ORDER_QTY IS NULL)) and
		((T.PERFECT_ORDER_SALES_AMT = S.PERFECT_ORDER_SALES_AMT) or (T.PERFECT_ORDER_SALES_AMT IS NULL and S.PERFECT_ORDER_SALES_AMT IS NULL)) and
		((T.SHIPPED_ORDER_QTY = S.SHIPPED_ORDER_QTY) or (T.SHIPPED_ORDER_QTY IS NULL and S.SHIPPED_ORDER_QTY IS NULL)) and
		((T.UNPAID_ORDER_QTY = S.UNPAID_ORDER_QTY) or (T.UNPAID_ORDER_QTY IS NULL and S.UNPAID_ORDER_QTY IS NULL)) and
		((T.X_NO_PURCHASE_QTY = S.X_NO_PURCHASE_QTY) or (T.X_NO_PURCHASE_QTY IS NULL and S.X_NO_PURCHASE_QTY IS NULL)) and
		((T.TRANSACTION_AMOUNT = S.TRANSACTION_AMOUNT) or (T.TRANSACTION_AMOUNT IS NULL and S.TRANSACTION_AMOUNT IS NULL)) and
		((T.ACCT_CMSN_PAID_AMT = S.ACCT_CMSN_PAID_AMT) or (T.ACCT_CMSN_PAID_AMT IS NULL and S.ACCT_CMSN_PAID_AMT IS NULL)) and
		((T.ORDER_SALES_AMT = S.ORDER_SALES_AMT) or (T.ORDER_SALES_AMT IS NULL and S.ORDER_SALES_AMT IS NULL)) and
		((T.ORDER_SALES_TAX_AMT = S.ORDER_SALES_TAX_AMT) or (T.ORDER_SALES_TAX_AMT IS NULL and S.ORDER_SALES_TAX_AMT IS NULL)) and
		((T.TERRITORY_CMSN_AMT = S.TERRITORY_CMSN_AMT) or (T.TERRITORY_CMSN_AMT IS NULL and S.TERRITORY_CMSN_AMT IS NULL)) and
		((T.TERRITORY_CHARGEBACK_AMT = S.TERRITORY_CHARGEBACK_AMT) or (T.TERRITORY_CHARGEBACK_AMT IS NULL and S.TERRITORY_CHARGEBACK_AMT IS NULL)) and
		((T.IMAGE_QTY = S.IMAGE_QTY) or (T.IMAGE_QTY IS NULL and S.IMAGE_QTY IS NULL)) and
		((T.PROOF_QTY = S.PROOF_QTY) or (T.PROOF_QTY IS NULL and S.PROOF_QTY IS NULL)) and
		((T.ODS_CREATE_DATE = S.ODS_CREATE_DATE) or (T.ODS_CREATE_DATE IS NULL and S.ODS_CREATE_DATE IS NULL)) and
		((T.ODS_MODIFY_DATE = S.ODS_MODIFY_DATE) or (T.ODS_MODIFY_DATE IS NULL and S.ODS_MODIFY_DATE IS NULL)) and
		((T.CAPTURE_SESSION_QTY = S.CAPTURE_SESSION_QTY) or (T.CAPTURE_SESSION_QTY IS NULL and S.CAPTURE_SESSION_QTY IS NULL)) and
		((T.STAFF_CAPTURE_SESSION_QTY = S.STAFF_CAPTURE_SESSION_QTY) or (T.STAFF_CAPTURE_SESSION_QTY IS NULL and S.STAFF_CAPTURE_SESSION_QTY IS NULL)) and
		((T.CLICK_QTY = S.CLICK_QTY) or (T.CLICK_QTY IS NULL and S.CLICK_QTY IS NULL)) and
		((T.EST_ACCT_CMSN_AMT = S.EST_ACCT_CMSN_AMT) or (T.EST_ACCT_CMSN_AMT IS NULL and S.EST_ACCT_CMSN_AMT IS NULL)) and
		((T.TOT_EST_ACCT_CMSN_AMT = S.TOT_EST_ACCT_CMSN_AMT) or (T.TOT_EST_ACCT_CMSN_AMT IS NULL and S.TOT_EST_ACCT_CMSN_AMT IS NULL))
        )

  
  

  

 


&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_ODS_ESF_SUMMARY_IDX
on		RAX_APP_USER.I$_ODS_ESF_SUMMARY (EVENT_REF_ID, SHIP_DATE)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_ODS_ESF_SUMMARY',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* create check table */


-- create table RAX_APP_USER.SNP_CHECK_TAB
-- (
-- 	CATALOG_NAME	VARCHAR2(100 CHAR) NULL ,
-- 	SCHEMA_NAME	VARCHAR2(100 CHAR) NULL ,
-- 	RESOURCE_NAME	VARCHAR2(100 CHAR) NULL,
-- 	FULL_RES_NAME	VARCHAR2(100 CHAR) NULL,
-- 	ERR_TYPE		VARCHAR2(1 CHAR) NULL,
-- 	ERR_MESS		VARCHAR2(250 CHAR) NULL ,
-- 	CHECK_DATE	DATE NULL,
-- 	ORIGIN		VARCHAR2(100 CHAR) NULL,
-- 	CONS_NAME	VARCHAR2(35 CHAR) NULL,
-- 	CONS_TYPE		VARCHAR2(2 CHAR) NULL,
-- 	ERR_COUNT		NUMBER(10) NULL
-- )

BEGIN
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.SNP_CHECK_TAB
(
	CATALOG_NAME	VARCHAR2(100 CHAR) NULL ,
	SCHEMA_NAME	VARCHAR2(100 CHAR) NULL ,
	RESOURCE_NAME	VARCHAR2(100 CHAR) NULL,
	FULL_RES_NAME	VARCHAR2(100 CHAR) NULL,
	ERR_TYPE		VARCHAR2(1 CHAR) NULL,
	ERR_MESS		VARCHAR2(250 CHAR) NULL ,
	CHECK_DATE	DATE NULL,
	ORIGIN		VARCHAR2(100 CHAR) NULL,
	CONS_NAME	VARCHAR2(35 CHAR) NULL,
	CONS_TYPE		VARCHAR2(2 CHAR) NULL,
	ERR_COUNT		NUMBER(10) NULL
)';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -955 THEN
         RAISE;
      END IF;
END;

	

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* delete previous check sum */

delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS'
and	ORIGIN 		= '(210003)Warehouse_Project.LOAD_ODS_ESF_SUMMARY_INT'
and	ERR_TYPE 		= 'F'


&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* create error table */


-- create table RAX_APP_USER.E$_ODS_ESF_SUMMARY
-- (
-- 	ODI_ROW_ID 		UROWID,
-- 	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
-- 	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
-- 	ODI_CHECK_DATE	DATE NULL, 
-- 	ODS_ESF_SUMMARY_ID	NUMBER NULL,
-- 	EFFECTIVE_DATE	DATE NULL,
-- 	LOAD_ID	NUMBER NULL,
-- 	ACTIVE_IND	VARCHAR2(5) NULL,
-- 	EVENT_REF_ID	VARCHAR2(40) NULL,
-- 	SHIP_DATE	DATE NULL,
-- 	PAID_ORDER_QTY	NUMBER NULL,
-- 	CALCULATED_PAID_ORDER_QTY	NUMBER NULL,
-- 	PERFECT_ORDER_SALES_AMT	NUMBER NULL,
-- 	SHIPPED_ORDER_QTY	NUMBER NULL,
-- 	UNPAID_ORDER_QTY	NUMBER NULL,
-- 	X_NO_PURCHASE_QTY	NUMBER NULL,
-- 	TRANSACTION_AMOUNT	NUMBER NULL,
-- 	ACCT_CMSN_PAID_AMT	NUMBER NULL,
-- 	ORDER_SALES_AMT	NUMBER NULL,
-- 	ORDER_SALES_TAX_AMT	NUMBER NULL,
-- 	TERRITORY_CMSN_AMT	NUMBER NULL,
-- 	TERRITORY_CHARGEBACK_AMT	NUMBER NULL,
-- 	IMAGE_QTY	NUMBER NULL,
-- 	PROOF_QTY	NUMBER NULL,
-- 	ODS_CREATE_DATE	DATE NULL,
-- 	ODS_MODIFY_DATE	DATE NULL,
-- 	CAPTURE_SESSION_QTY	NUMBER NULL,
-- 	STAFF_CAPTURE_SESSION_QTY	NUMBER NULL,
-- 	CLICK_QTY	NUMBER NULL,
-- 	EST_ACCT_CMSN_AMT	NUMBER NULL,
-- 	TOT_EST_ACCT_CMSN_AMT	NUMBER NULL,
-- 	ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
-- 	ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
-- 	ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
-- 	ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
-- 	ODI_SESS_NO		VARCHAR2(19 CHAR)
-- )


BEGIN
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.E$_ODS_ESF_SUMMARY
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	ODS_ESF_SUMMARY_ID	NUMBER NULL,
	EFFECTIVE_DATE	DATE NULL,
	LOAD_ID	NUMBER NULL,
	ACTIVE_IND	VARCHAR2(5) NULL,
	EVENT_REF_ID	VARCHAR2(40) NULL,
	SHIP_DATE	DATE NULL,
	PAID_ORDER_QTY	NUMBER NULL,
	CALCULATED_PAID_ORDER_QTY	NUMBER NULL,
	PERFECT_ORDER_SALES_AMT	NUMBER NULL,
	SHIPPED_ORDER_QTY	NUMBER NULL,
	UNPAID_ORDER_QTY	NUMBER NULL,
	X_NO_PURCHASE_QTY	NUMBER NULL,
	TRANSACTION_AMOUNT	NUMBER NULL,
	ACCT_CMSN_PAID_AMT	NUMBER NULL,
	ORDER_SALES_AMT	NUMBER NULL,
	ORDER_SALES_TAX_AMT	NUMBER NULL,
	TERRITORY_CMSN_AMT	NUMBER NULL,
	TERRITORY_CHARGEBACK_AMT	NUMBER NULL,
	IMAGE_QTY	NUMBER NULL,
	PROOF_QTY	NUMBER NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	CAPTURE_SESSION_QTY	NUMBER NULL,
	STAFF_CAPTURE_SESSION_QTY	NUMBER NULL,
	CLICK_QTY	NUMBER NULL,
	EST_ACCT_CMSN_AMT	NUMBER NULL,
	TOT_EST_ACCT_CMSN_AMT	NUMBER NULL,
	ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
	ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
	ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
	ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
	ODI_SESS_NO		VARCHAR2(19 CHAR)
)';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -955 THEN
         RAISE;
      END IF;
END;



&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* delete previous errors */

delete from 	RAX_APP_USER.E$_ODS_ESF_SUMMARY
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(210003)Warehouse_Project.LOAD_ODS_ESF_SUMMARY_INT')


&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Create index on PK */

 
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */
-- create index 	RAX_APP_USER.I$_ODS_ESF_SUMMARY_IDX
-- on	RAX_APP_USER.I$_ODS_ESF_SUMMARY (EVENT_REF_ID,
-- 		SHIP_DATE)

BEGIN
   EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.I$_ODS_ESF_SUMMARY_IDX
on	RAX_APP_USER.I$_ODS_ESF_SUMMARY (EVENT_REF_ID,
		SHIP_DATE)';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE!= -955 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* insert PK errors */

insert into RAX_APP_USER.E$_ODS_ESF_SUMMARY
(
	ODI_PK,
	ODI_SESS_NO,
	ODI_ROW_ID,
	ODI_ERR_TYPE,
	ODI_ERR_MESS,
	ODI_ORIGIN,
	ODI_CHECK_DATE,
	ODI_CONS_NAME,
	ODI_CONS_TYPE,
	ODS_ESF_SUMMARY_ID,
	EFFECTIVE_DATE,
	LOAD_ID,
	ACTIVE_IND,
	EVENT_REF_ID,
	SHIP_DATE,
	PAID_ORDER_QTY,
	CALCULATED_PAID_ORDER_QTY,
	PERFECT_ORDER_SALES_AMT,
	SHIPPED_ORDER_QTY,
	UNPAID_ORDER_QTY,
	X_NO_PURCHASE_QTY,
	TRANSACTION_AMOUNT,
	ACCT_CMSN_PAID_AMT,
	ORDER_SALES_AMT,
	ORDER_SALES_TAX_AMT,
	TERRITORY_CMSN_AMT,
	TERRITORY_CHARGEBACK_AMT,
	IMAGE_QTY,
	PROOF_QTY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	CAPTURE_SESSION_QTY,
	STAFF_CAPTURE_SESSION_QTY,
	CLICK_QTY,
	EST_ACCT_CMSN_AMT,
	TOT_EST_ACCT_CMSN_AMT
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15064: The primary key PK_ODS_ESF_SUMMARY is not unique.',
	'(210003)Warehouse_Project.LOAD_ODS_ESF_SUMMARY_INT',
	sysdate,
	'PK_ODS_ESF_SUMMARY',
	'PK',	
	ODS_ESF_SUMMARY.ODS_ESF_SUMMARY_ID,
	ODS_ESF_SUMMARY.EFFECTIVE_DATE,
	ODS_ESF_SUMMARY.LOAD_ID,
	ODS_ESF_SUMMARY.ACTIVE_IND,
	ODS_ESF_SUMMARY.EVENT_REF_ID,
	ODS_ESF_SUMMARY.SHIP_DATE,
	ODS_ESF_SUMMARY.PAID_ORDER_QTY,
	ODS_ESF_SUMMARY.CALCULATED_PAID_ORDER_QTY,
	ODS_ESF_SUMMARY.PERFECT_ORDER_SALES_AMT,
	ODS_ESF_SUMMARY.SHIPPED_ORDER_QTY,
	ODS_ESF_SUMMARY.UNPAID_ORDER_QTY,
	ODS_ESF_SUMMARY.X_NO_PURCHASE_QTY,
	ODS_ESF_SUMMARY.TRANSACTION_AMOUNT,
	ODS_ESF_SUMMARY.ACCT_CMSN_PAID_AMT,
	ODS_ESF_SUMMARY.ORDER_SALES_AMT,
	ODS_ESF_SUMMARY.ORDER_SALES_TAX_AMT,
	ODS_ESF_SUMMARY.TERRITORY_CMSN_AMT,
	ODS_ESF_SUMMARY.TERRITORY_CHARGEBACK_AMT,
	ODS_ESF_SUMMARY.IMAGE_QTY,
	ODS_ESF_SUMMARY.PROOF_QTY,
	ODS_ESF_SUMMARY.ODS_CREATE_DATE,
	ODS_ESF_SUMMARY.ODS_MODIFY_DATE,
	ODS_ESF_SUMMARY.CAPTURE_SESSION_QTY,
	ODS_ESF_SUMMARY.STAFF_CAPTURE_SESSION_QTY,
	ODS_ESF_SUMMARY.CLICK_QTY,
	ODS_ESF_SUMMARY.EST_ACCT_CMSN_AMT,
	ODS_ESF_SUMMARY.TOT_EST_ACCT_CMSN_AMT
from	RAX_APP_USER.I$_ODS_ESF_SUMMARY   ODS_ESF_SUMMARY
where	exists  (
		select	SUB.EVENT_REF_ID,
			SUB.SHIP_DATE
		from 	RAX_APP_USER.I$_ODS_ESF_SUMMARY SUB
		where 	SUB.EVENT_REF_ID=ODS_ESF_SUMMARY.EVENT_REF_ID
			and SUB.SHIP_DATE=ODS_ESF_SUMMARY.SHIP_DATE
		group by 	SUB.EVENT_REF_ID,
			SUB.SHIP_DATE
		having 	count(1) > 1
		)



&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* Create index on AK */

 
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */
create index 	ODS_ESF_SUMMARY_IX0_flow
on	RAX_APP_USER.I$_ODS_ESF_SUMMARY 
	(ODS_ESF_SUMMARY_ID)


&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* insert AK errors */

insert into RAX_APP_USER.E$_ODS_ESF_SUMMARY
(
	ODI_PK,
	ODI_SESS_NO,
	ODI_ROW_ID,
	ODI_ERR_TYPE,
	ODI_ERR_MESS,
	ODI_ORIGIN,
	ODI_CHECK_DATE,
	ODI_CONS_NAME,
	ODI_CONS_TYPE,
	ODS_ESF_SUMMARY_ID,
	EFFECTIVE_DATE,
	LOAD_ID,
	ACTIVE_IND,
	EVENT_REF_ID,
	SHIP_DATE,
	PAID_ORDER_QTY,
	CALCULATED_PAID_ORDER_QTY,
	PERFECT_ORDER_SALES_AMT,
	SHIPPED_ORDER_QTY,
	UNPAID_ORDER_QTY,
	X_NO_PURCHASE_QTY,
	TRANSACTION_AMOUNT,
	ACCT_CMSN_PAID_AMT,
	ORDER_SALES_AMT,
	ORDER_SALES_TAX_AMT,
	TERRITORY_CMSN_AMT,
	TERRITORY_CHARGEBACK_AMT,
	IMAGE_QTY,
	PROOF_QTY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	CAPTURE_SESSION_QTY,
	STAFF_CAPTURE_SESSION_QTY,
	CLICK_QTY,
	EST_ACCT_CMSN_AMT,
	TOT_EST_ACCT_CMSN_AMT
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15063: The alternate key ODS_ESF_SUMMARY_IX0 is not unique.',
	'(210003)Warehouse_Project.LOAD_ODS_ESF_SUMMARY_INT',
	sysdate,
	'ODS_ESF_SUMMARY_IX0',
	'AK',	
	ODS_ESF_SUMMARY.ODS_ESF_SUMMARY_ID,
	ODS_ESF_SUMMARY.EFFECTIVE_DATE,
	ODS_ESF_SUMMARY.LOAD_ID,
	ODS_ESF_SUMMARY.ACTIVE_IND,
	ODS_ESF_SUMMARY.EVENT_REF_ID,
	ODS_ESF_SUMMARY.SHIP_DATE,
	ODS_ESF_SUMMARY.PAID_ORDER_QTY,
	ODS_ESF_SUMMARY.CALCULATED_PAID_ORDER_QTY,
	ODS_ESF_SUMMARY.PERFECT_ORDER_SALES_AMT,
	ODS_ESF_SUMMARY.SHIPPED_ORDER_QTY,
	ODS_ESF_SUMMARY.UNPAID_ORDER_QTY,
	ODS_ESF_SUMMARY.X_NO_PURCHASE_QTY,
	ODS_ESF_SUMMARY.TRANSACTION_AMOUNT,
	ODS_ESF_SUMMARY.ACCT_CMSN_PAID_AMT,
	ODS_ESF_SUMMARY.ORDER_SALES_AMT,
	ODS_ESF_SUMMARY.ORDER_SALES_TAX_AMT,
	ODS_ESF_SUMMARY.TERRITORY_CMSN_AMT,
	ODS_ESF_SUMMARY.TERRITORY_CHARGEBACK_AMT,
	ODS_ESF_SUMMARY.IMAGE_QTY,
	ODS_ESF_SUMMARY.PROOF_QTY,
	ODS_ESF_SUMMARY.ODS_CREATE_DATE,
	ODS_ESF_SUMMARY.ODS_MODIFY_DATE,
	ODS_ESF_SUMMARY.CAPTURE_SESSION_QTY,
	ODS_ESF_SUMMARY.STAFF_CAPTURE_SESSION_QTY,
	ODS_ESF_SUMMARY.CLICK_QTY,
	ODS_ESF_SUMMARY.EST_ACCT_CMSN_AMT,
	ODS_ESF_SUMMARY.TOT_EST_ACCT_CMSN_AMT
from	RAX_APP_USER.I$_ODS_ESF_SUMMARY   ODS_ESF_SUMMARY
where	exists  (
		select	SUB.ODS_ESF_SUMMARY_ID
		from 	RAX_APP_USER.I$_ODS_ESF_SUMMARY SUB
		where 	SUB.ODS_ESF_SUMMARY_ID=ODS_ESF_SUMMARY.ODS_ESF_SUMMARY_ID
		group by 	SUB.ODS_ESF_SUMMARY_ID
		having 	count(1) > 1
		)



&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Create index on AK */

 
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */
-- create index 	ODS_ESF_SUMMARY_IX1_flow
-- on	RAX_APP_USER.I$_ODS_ESF_SUMMARY 
-- 	(EVENT_REF_ID,
-- 			SHIP_DATE)

BEGIN
   EXECUTE IMMEDIATE 'create index 	ODS_ESF_SUMMARY_IX1_flow
on	RAX_APP_USER.I$_ODS_ESF_SUMMARY 
	(EVENT_REF_ID,
			SHIP_DATE)';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE!= -955 THEN
         RAISE;
      END IF;
END;



&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* insert AK errors */

insert into RAX_APP_USER.E$_ODS_ESF_SUMMARY
(
	ODI_PK,
	ODI_SESS_NO,
	ODI_ROW_ID,
	ODI_ERR_TYPE,
	ODI_ERR_MESS,
	ODI_ORIGIN,
	ODI_CHECK_DATE,
	ODI_CONS_NAME,
	ODI_CONS_TYPE,
	ODS_ESF_SUMMARY_ID,
	EFFECTIVE_DATE,
	LOAD_ID,
	ACTIVE_IND,
	EVENT_REF_ID,
	SHIP_DATE,
	PAID_ORDER_QTY,
	CALCULATED_PAID_ORDER_QTY,
	PERFECT_ORDER_SALES_AMT,
	SHIPPED_ORDER_QTY,
	UNPAID_ORDER_QTY,
	X_NO_PURCHASE_QTY,
	TRANSACTION_AMOUNT,
	ACCT_CMSN_PAID_AMT,
	ORDER_SALES_AMT,
	ORDER_SALES_TAX_AMT,
	TERRITORY_CMSN_AMT,
	TERRITORY_CHARGEBACK_AMT,
	IMAGE_QTY,
	PROOF_QTY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	CAPTURE_SESSION_QTY,
	STAFF_CAPTURE_SESSION_QTY,
	CLICK_QTY,
	EST_ACCT_CMSN_AMT,
	TOT_EST_ACCT_CMSN_AMT
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15063: The alternate key ODS_ESF_SUMMARY_IX1 is not unique.',
	'(210003)Warehouse_Project.LOAD_ODS_ESF_SUMMARY_INT',
	sysdate,
	'ODS_ESF_SUMMARY_IX1',
	'AK',	
	ODS_ESF_SUMMARY.ODS_ESF_SUMMARY_ID,
	ODS_ESF_SUMMARY.EFFECTIVE_DATE,
	ODS_ESF_SUMMARY.LOAD_ID,
	ODS_ESF_SUMMARY.ACTIVE_IND,
	ODS_ESF_SUMMARY.EVENT_REF_ID,
	ODS_ESF_SUMMARY.SHIP_DATE,
	ODS_ESF_SUMMARY.PAID_ORDER_QTY,
	ODS_ESF_SUMMARY.CALCULATED_PAID_ORDER_QTY,
	ODS_ESF_SUMMARY.PERFECT_ORDER_SALES_AMT,
	ODS_ESF_SUMMARY.SHIPPED_ORDER_QTY,
	ODS_ESF_SUMMARY.UNPAID_ORDER_QTY,
	ODS_ESF_SUMMARY.X_NO_PURCHASE_QTY,
	ODS_ESF_SUMMARY.TRANSACTION_AMOUNT,
	ODS_ESF_SUMMARY.ACCT_CMSN_PAID_AMT,
	ODS_ESF_SUMMARY.ORDER_SALES_AMT,
	ODS_ESF_SUMMARY.ORDER_SALES_TAX_AMT,
	ODS_ESF_SUMMARY.TERRITORY_CMSN_AMT,
	ODS_ESF_SUMMARY.TERRITORY_CHARGEBACK_AMT,
	ODS_ESF_SUMMARY.IMAGE_QTY,
	ODS_ESF_SUMMARY.PROOF_QTY,
	ODS_ESF_SUMMARY.ODS_CREATE_DATE,
	ODS_ESF_SUMMARY.ODS_MODIFY_DATE,
	ODS_ESF_SUMMARY.CAPTURE_SESSION_QTY,
	ODS_ESF_SUMMARY.STAFF_CAPTURE_SESSION_QTY,
	ODS_ESF_SUMMARY.CLICK_QTY,
	ODS_ESF_SUMMARY.EST_ACCT_CMSN_AMT,
	ODS_ESF_SUMMARY.TOT_EST_ACCT_CMSN_AMT
from	RAX_APP_USER.I$_ODS_ESF_SUMMARY   ODS_ESF_SUMMARY
where	exists  (
		select	SUB.EVENT_REF_ID,
			SUB.SHIP_DATE
		from 	RAX_APP_USER.I$_ODS_ESF_SUMMARY SUB
		where 	SUB.EVENT_REF_ID=ODS_ESF_SUMMARY.EVENT_REF_ID
			and SUB.SHIP_DATE=ODS_ESF_SUMMARY.SHIP_DATE
		group by 	SUB.EVENT_REF_ID,
			SUB.SHIP_DATE
		having 	count(1) > 1
		)



&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_ODS_ESF_SUMMARY
(
	ODI_PK,
	ODI_SESS_NO,
	ODI_ROW_ID,
	ODI_ERR_TYPE,
	ODI_ERR_MESS,
	ODI_CHECK_DATE,
	ODI_ORIGIN,
	ODI_CONS_NAME,
	ODI_CONS_TYPE,
	ODS_ESF_SUMMARY_ID,
	EFFECTIVE_DATE,
	LOAD_ID,
	ACTIVE_IND,
	EVENT_REF_ID,
	SHIP_DATE,
	PAID_ORDER_QTY,
	CALCULATED_PAID_ORDER_QTY,
	PERFECT_ORDER_SALES_AMT,
	SHIPPED_ORDER_QTY,
	UNPAID_ORDER_QTY,
	X_NO_PURCHASE_QTY,
	TRANSACTION_AMOUNT,
	ACCT_CMSN_PAID_AMT,
	ORDER_SALES_AMT,
	ORDER_SALES_TAX_AMT,
	TERRITORY_CMSN_AMT,
	TERRITORY_CHARGEBACK_AMT,
	IMAGE_QTY,
	PROOF_QTY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	CAPTURE_SESSION_QTY,
	STAFF_CAPTURE_SESSION_QTY,
	CLICK_QTY,
	EST_ACCT_CMSN_AMT,
	TOT_EST_ACCT_CMSN_AMT
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column EVENT_REF_ID cannot be null.',
	sysdate,
	'(210003)Warehouse_Project.LOAD_ODS_ESF_SUMMARY_INT',
	'EVENT_REF_ID',
	'NN',	
	ODS_ESF_SUMMARY_ID,
	EFFECTIVE_DATE,
	LOAD_ID,
	ACTIVE_IND,
	EVENT_REF_ID,
	SHIP_DATE,
	PAID_ORDER_QTY,
	CALCULATED_PAID_ORDER_QTY,
	PERFECT_ORDER_SALES_AMT,
	SHIPPED_ORDER_QTY,
	UNPAID_ORDER_QTY,
	X_NO_PURCHASE_QTY,
	TRANSACTION_AMOUNT,
	ACCT_CMSN_PAID_AMT,
	ORDER_SALES_AMT,
	ORDER_SALES_TAX_AMT,
	TERRITORY_CMSN_AMT,
	TERRITORY_CHARGEBACK_AMT,
	IMAGE_QTY,
	PROOF_QTY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	CAPTURE_SESSION_QTY,
	STAFF_CAPTURE_SESSION_QTY,
	CLICK_QTY,
	EST_ACCT_CMSN_AMT,
	TOT_EST_ACCT_CMSN_AMT
from	RAX_APP_USER.I$_ODS_ESF_SUMMARY
where	EVENT_REF_ID is null



&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_ODS_ESF_SUMMARY
(
	ODI_PK,
	ODI_SESS_NO,
	ODI_ROW_ID,
	ODI_ERR_TYPE,
	ODI_ERR_MESS,
	ODI_CHECK_DATE,
	ODI_ORIGIN,
	ODI_CONS_NAME,
	ODI_CONS_TYPE,
	ODS_ESF_SUMMARY_ID,
	EFFECTIVE_DATE,
	LOAD_ID,
	ACTIVE_IND,
	EVENT_REF_ID,
	SHIP_DATE,
	PAID_ORDER_QTY,
	CALCULATED_PAID_ORDER_QTY,
	PERFECT_ORDER_SALES_AMT,
	SHIPPED_ORDER_QTY,
	UNPAID_ORDER_QTY,
	X_NO_PURCHASE_QTY,
	TRANSACTION_AMOUNT,
	ACCT_CMSN_PAID_AMT,
	ORDER_SALES_AMT,
	ORDER_SALES_TAX_AMT,
	TERRITORY_CMSN_AMT,
	TERRITORY_CHARGEBACK_AMT,
	IMAGE_QTY,
	PROOF_QTY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	CAPTURE_SESSION_QTY,
	STAFF_CAPTURE_SESSION_QTY,
	CLICK_QTY,
	EST_ACCT_CMSN_AMT,
	TOT_EST_ACCT_CMSN_AMT
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column SHIP_DATE cannot be null.',
	sysdate,
	'(210003)Warehouse_Project.LOAD_ODS_ESF_SUMMARY_INT',
	'SHIP_DATE',
	'NN',	
	ODS_ESF_SUMMARY_ID,
	EFFECTIVE_DATE,
	LOAD_ID,
	ACTIVE_IND,
	EVENT_REF_ID,
	SHIP_DATE,
	PAID_ORDER_QTY,
	CALCULATED_PAID_ORDER_QTY,
	PERFECT_ORDER_SALES_AMT,
	SHIPPED_ORDER_QTY,
	UNPAID_ORDER_QTY,
	X_NO_PURCHASE_QTY,
	TRANSACTION_AMOUNT,
	ACCT_CMSN_PAID_AMT,
	ORDER_SALES_AMT,
	ORDER_SALES_TAX_AMT,
	TERRITORY_CMSN_AMT,
	TERRITORY_CHARGEBACK_AMT,
	IMAGE_QTY,
	PROOF_QTY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	CAPTURE_SESSION_QTY,
	STAFF_CAPTURE_SESSION_QTY,
	CLICK_QTY,
	EST_ACCT_CMSN_AMT,
	TOT_EST_ACCT_CMSN_AMT
from	RAX_APP_USER.I$_ODS_ESF_SUMMARY
where	SHIP_DATE is null



&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* create index on error table */

 
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */
-- create index 	RAX_APP_USER.E$_ODS_ESF_SUMMARY_IDX
-- on	RAX_APP_USER.E$_ODS_ESF_SUMMARY (ODI_ROW_ID)

BEGIN
   EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_ODS_ESF_SUMMARY_IDX
on	RAX_APP_USER.E$_ODS_ESF_SUMMARY (ODI_ROW_ID)';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE!= -955 THEN
         RAISE;
      END IF;
END;


&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* delete errors from controlled table */

delete from	RAX_APP_USER.I$_ODS_ESF_SUMMARY  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_ODS_ESF_SUMMARY E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)


&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* insert check sum into check table */

insert into RAX_APP_USER.SNP_CHECK_TAB
(
	SCHEMA_NAME,
	RESOURCE_NAME,
	FULL_RES_NAME,
	ERR_TYPE,
	ERR_MESS,
	CHECK_DATE,
	ORIGIN,
	CONS_NAME,
	CONS_TYPE,
	ERR_COUNT
)
select	
	'ODS',
	'ODS_ESF_SUMMARY',
	'ODS.ODS_ESF_SUMMARY',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_ODS_ESF_SUMMARY E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(210003)Warehouse_Project.LOAD_ODS_ESF_SUMMARY_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE


&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* Flag rows for update */

/* DETECTION_STRATEGY = NOT_EXISTS */


update	RAX_APP_USER.I$_ODS_ESF_SUMMARY
set	IND_UPDATE = 'U'
where	(EVENT_REF_ID, SHIP_DATE)
	in	(
		select	EVENT_REF_ID,
			SHIP_DATE
		from	ODS.ODS_ESF_SUMMARY
		)



&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* Flag useless rows */

/* DETECTION_STRATEGY = NOT_EXISTS */

/* Command skipped due to chosen DETECTION_STRATEGY */



/*-----------------------------------------------*/
/* TASK No. 32 */
/* Update existing rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
update	ODS.ODS_ESF_SUMMARY T
set 	
	(
	T.PAID_ORDER_QTY,
	T.CALCULATED_PAID_ORDER_QTY,
	T.PERFECT_ORDER_SALES_AMT,
	T.SHIPPED_ORDER_QTY,
	T.UNPAID_ORDER_QTY,
	T.X_NO_PURCHASE_QTY,
	T.TRANSACTION_AMOUNT,
	T.ACCT_CMSN_PAID_AMT,
	T.ORDER_SALES_AMT,
	T.ORDER_SALES_TAX_AMT,
	T.TERRITORY_CMSN_AMT,
	T.TERRITORY_CHARGEBACK_AMT,
	T.IMAGE_QTY,
	T.PROOF_QTY,
	T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE,
	T.CAPTURE_SESSION_QTY,
	T.STAFF_CAPTURE_SESSION_QTY,
	T.CLICK_QTY,
	T.EST_ACCT_CMSN_AMT,
	T.TOT_EST_ACCT_CMSN_AMT
	) =
		(
		select	S.PAID_ORDER_QTY,
			S.CALCULATED_PAID_ORDER_QTY,
			S.PERFECT_ORDER_SALES_AMT,
			S.SHIPPED_ORDER_QTY,
			S.UNPAID_ORDER_QTY,
			S.X_NO_PURCHASE_QTY,
			S.TRANSACTION_AMOUNT,
			S.ACCT_CMSN_PAID_AMT,
			S.ORDER_SALES_AMT,
			S.ORDER_SALES_TAX_AMT,
			S.TERRITORY_CMSN_AMT,
			S.TERRITORY_CHARGEBACK_AMT,
			S.IMAGE_QTY,
			S.PROOF_QTY,
			S.ODS_CREATE_DATE,
			S.ODS_MODIFY_DATE,
			S.CAPTURE_SESSION_QTY,
			S.STAFF_CAPTURE_SESSION_QTY,
			S.CLICK_QTY,
			S.EST_ACCT_CMSN_AMT,
			S.TOT_EST_ACCT_CMSN_AMT
		from	RAX_APP_USER.I$_ODS_ESF_SUMMARY S
		where	T.EVENT_REF_ID	=S.EVENT_REF_ID
		and	T.SHIP_DATE	=S.SHIP_DATE
	    	 )
	,                     T.EFFECTIVE_DATE = sysdate,
	T.LOAD_ID = 1,
	T.ACTIVE_IND = 'A'

where	(EVENT_REF_ID, SHIP_DATE)
	in	(
		select	EVENT_REF_ID,
			SHIP_DATE
		from	RAX_APP_USER.I$_ODS_ESF_SUMMARY
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 33 */
/* Insert new rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
insert into 	ODS.ODS_ESF_SUMMARY T
	(
	EVENT_REF_ID,
	SHIP_DATE,
	PAID_ORDER_QTY,
	CALCULATED_PAID_ORDER_QTY,
	PERFECT_ORDER_SALES_AMT,
	SHIPPED_ORDER_QTY,
	UNPAID_ORDER_QTY,
	X_NO_PURCHASE_QTY,
	TRANSACTION_AMOUNT,
	ACCT_CMSN_PAID_AMT,
	ORDER_SALES_AMT,
	ORDER_SALES_TAX_AMT,
	TERRITORY_CMSN_AMT,
	TERRITORY_CHARGEBACK_AMT,
	IMAGE_QTY,
	PROOF_QTY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	CAPTURE_SESSION_QTY,
	STAFF_CAPTURE_SESSION_QTY,
	CLICK_QTY,
	EST_ACCT_CMSN_AMT,
	TOT_EST_ACCT_CMSN_AMT
	,                       ODS_ESF_SUMMARY_ID,
	EFFECTIVE_DATE,
	LOAD_ID,
	ACTIVE_IND
	)
select 	EVENT_REF_ID,
	SHIP_DATE,
	PAID_ORDER_QTY,
	CALCULATED_PAID_ORDER_QTY,
	PERFECT_ORDER_SALES_AMT,
	SHIPPED_ORDER_QTY,
	UNPAID_ORDER_QTY,
	X_NO_PURCHASE_QTY,
	TRANSACTION_AMOUNT,
	ACCT_CMSN_PAID_AMT,
	ORDER_SALES_AMT,
	ORDER_SALES_TAX_AMT,
	TERRITORY_CMSN_AMT,
	TERRITORY_CHARGEBACK_AMT,
	IMAGE_QTY,
	PROOF_QTY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	CAPTURE_SESSION_QTY,
	STAFF_CAPTURE_SESSION_QTY,
	CLICK_QTY,
	EST_ACCT_CMSN_AMT,
	TOT_EST_ACCT_CMSN_AMT
	,                       ODS.ODS_ESF_SUMMARY_ID_SEQ.nextval,
	sysdate,
	1,
	'A'
from	RAX_APP_USER.I$_ODS_ESF_SUMMARY S



where	IND_UPDATE = 'I'



&


/*-----------------------------------------------*/
/* TASK No. 34 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 35 */
/* Drop flow table */

drop table RAX_APP_USER.I$_ODS_ESF_SUMMARY 

&


/*-----------------------------------------------*/
/* TASK No. 1000009 */
/* Drop work table */

drop table RAX_APP_USER.C$_0ODS_ESF_SUMMARY 

-- &


/*-----------------------------------------------*/
/* TASK No. 36 */

-- OdiStartScen "-SCEN_NAME=UPDATE_EVENT_FROM_ESF_SUMMARY_PRC" "-SCEN_VERSION=-1" "-SYNC_MODE=1"

-- &


/*-----------------------------------------------*/
/* TASK No. 37 */
/* Update CDC Load Status */

-- UPDATE ODS.DW_CDC_LOAD_STATUS
-- SET LAST_CDC_COMPLETION_DATE=TO_DATE(
--              SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
-- WHERE DW_TABLE_NAME = :v_cdc_load_table_name

-- &


/*-----------------------------------------------*/
