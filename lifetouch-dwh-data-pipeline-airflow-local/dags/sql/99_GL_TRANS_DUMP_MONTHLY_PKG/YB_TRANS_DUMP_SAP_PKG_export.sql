select 	
	GL_TRANS_DTL_DUMP.TRANSACTION_SOURCE	   TRANSACTION_SOURCE,
	GL_TRANS_DTL_DUMP.EVENT_REF_ID	   EVENT_REF_ID,
	GL_TRANS_DTL_DUMP.GL_TRANSACTION_DETAIL_OID	   GL_TRANSACTION_DETAIL_OID,
	GL_TRANS_DTL_DUMP.GL_TRANSACTION_OID	   GL_TRANSACTION_OID,
	GL_TRANS_DTL_DUMP.ODS_CREATE_DATE	   ODS_CREATE_DATE,
	GL_TRANS_DTL_DUMP.ODS_MODIFY_DATE	   ODS_MODIFY_DATE,
	GL_TRANS_DTL_DUMP.GL_ACCOUNT_TYPE	   GL_ACCOUNT_TYPE,
	GL_TRANS_DTL_DUMP.GL_DEBIT_CREDIT_IND	   GL_DEBIT_CREDIT_IND,
	GL_TRANS_DTL_DUMP.POSTING_DATE	   POSTING_DATE,
	GL_TRANS_DTL_DUMP.AMOUNT	   AMOUNT,
	GL_TRANS_DTL_DUMP.CURRENCY_CODE	   CURRENCY_CODE,
	GL_TRANS_DTL_DUMP.COUNTRY	   COUNTRY,
	GL_TRANS_DTL_DUMP.SALES_TAX_STATE_CODE	   SALES_TAX_STATE_CODE,
	GL_TRANS_DTL_DUMP.TERRITORY_CODE	   TERRITORY_CODE,
	GL_TRANS_DTL_DUMP.BUSINESS_UNIT	   BUSINESS_UNIT,
	GL_TRANS_DTL_DUMP.PROGRAM_NAME	   PROGRAM_NAME,
	GL_TRANS_DTL_DUMP.SUB_PROGRAM_NAME	   SUB_PROGRAM_NAME,
	GL_TRANS_DTL_DUMP.BANK_CODE	   BANK_CODE,
	GL_TRANS_DTL_DUMP.GL_COMPANY	   GL_COMPANY,
	GL_TRANS_DTL_DUMP.GL_ACCOUNT	   GL_ACCOUNT,
	GL_TRANS_DTL_DUMP.GL_SUB_ACCOUNT	   GL_SUB_ACCOUNT,
	GL_TRANS_DTL_DUMP.GL_ACCOUNTING_UNIT	   GL_ACCOUNTING_UNIT,
	GL_TRANS_DTL_DUMP.GL_DESCRIPTION	   GL_DESCRIPTION,
	GL_TRANS_DTL_DUMP.GL_PROGRAM_CODE	   GL_PROGRAM_CODE,
	GL_TRANS_DTL_DUMP.EVENT_PAYMENT_OID	   EVENT_PAYMENT_OID,
	GL_TRANS_DTL_DUMP.SALES_RECOGNITION_OID	   SALES_RECOGNITION_OID,
	GL_TRANS_DTL_DUMP.MATCHED_SALES_RECOGNITION_OID	   MATCHED_SALES_RECOGNITION_OID,
	GL_TRANS_DTL_DUMP.EVENT_ADJUSTMENT_OID	   EVENT_ADJUSTMENT_OID,
	GL_TRANS_DTL_DUMP.CHARGEBACK_FACT_OID	   CHARGEBACK_FACT_OID,
	GL_TRANS_DTL_DUMP.GL_ACTIVITY	   GL_ACTIVITY,
	GL_TRANS_DTL_DUMP.INV_EVENT_PAY_OID	   INV_EVENT_PAY_OID,
	GL_TRANS_DTL_DUMP.RECORD_STATUS	   RECORD_STATUS,
	GL_TRANS_DTL_DUMP.APO_TYPE	   APO_TYPE,
	GL_TRANS_DTL_DUMP.COMPANY_CODE	   COMPANY_CODE,
	GL_TRANS_DTL_DUMP.PROFIT_CENTER	   PROFIT_CENTER,
	GL_TRANS_DTL_DUMP.RUN_GROUP	   RUN_GROUP
from	RAX_APP_USER.GL_TRANS_DTL_DUMP   GL_TRANS_DTL_DUMP
where	
	(1=1)	