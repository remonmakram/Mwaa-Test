
select 	
	SNG_RECCUST_ACCT.COUNTRY_NAME	   COUNTRY_NAME,
	SNG_RECCUST_ACCT.COMPANY_NAME	   COMPANY_NAME,
	SNG_RECCUST_ACCT.AREA_NAME	   AREA_NAME,
	SNG_RECCUST_ACCT.REGION_NAME	   REGION_NAME,
	SNG_RECCUST_ACCT.TERRITORY_CODE	   TERRITORY_CODE,
	SNG_RECCUST_ACCT.TM_NAME	   TM_NAME,
	SNG_RECCUST_ACCT.SUB_PROGRAM_NAME	   SUB_PROGRAM_NAME,
	SNG_RECCUST_ACCT.PROGRAM_NAME	   PROGRAM_NAME,
	SNG_RECCUST_ACCT.ORDER_NO	   ORDER_NO,
	SNG_RECCUST_ACCT.PHOTOGRAPHY_LOCATION	   PHOTOGRAPHY_LOCATION,
	SNG_RECCUST_ACCT.STUDIO_CODE	   STUDIO_CODE,
	SNG_RECCUST_ACCT.ORDER_SALES_CHANNEL	   ORDER_SALES_CHANNEL,
	SNG_RECCUST_ACCT.TERRITORY_GROUP_CODE	   TERRITORY_GROUP_CODE,
	SNG_RECCUST_ACCT.SCHOOL_YEAR	   SCHOOL_YEAR,
	SNG_RECCUST_ACCT.ACCOUNT_NAME	   ACCOUNT_NAME,
	SNG_RECCUST_ACCT.LIFETOUCH_ID	   LIFETOUCH_ID,
	SNG_RECCUST_ACCT.ACCT_ADDRESS	   ACCT_ADDRESS,
	SNG_RECCUST_ACCT.AMOUNT_PAID	   AMOUNT_PAID,
	SNG_RECCUST_ACCT.SERVICE_SALES	   SERVICE_SALES,
	SNG_RECCUST_ACCT.PRODUCT_SALES	   PRODUCT_SALES,
	SNG_RECCUST_ACCT.TOTAL_SALES	   TOTAL_SALES,
	SNG_RECCUST_ACCT.AMOUNT_DUE	   AMOUNT_DUE,
	SNG_RECCUST_ACCT.DEPOSIT_AMT	   DEPOSIT_AMT,
	SNG_RECCUST_ACCT.AR_WRITEOFF_AMT	   AR_WRITEOFF_AMT,
	SNG_RECCUST_ACCT.OUT_OF_BALANCE_IND	   OUT_OF_BALANCE_IND
from	RAX_APP_USER.ACTUATE_RECCUST_DEPO_ACCT_STG   SNG_RECCUST_ACCT
where	
	(1=1)	
	
