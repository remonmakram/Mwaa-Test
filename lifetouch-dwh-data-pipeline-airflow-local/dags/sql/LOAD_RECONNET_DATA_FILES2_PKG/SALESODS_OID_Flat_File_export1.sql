select 	
	PAYMENT.CURRENCY	   CURRENCY,
	:v_rnet_corp_acct_ind
/*BANK_ACCOUNT.CORP_ACCOUNT_IND*/	   ACCT_TYPE,
	TO_CHAR(DEPOSIT.SEQUENCE_NUMBER)	   SEQUENCE_NBR,
	BANK_ACCOUNT.BANK_CODE	   BANK_CODE,
	CASE DEPOSIT.ENTRY_TYPE WHEN 'CORRECTION' THEN '2' WHEN 'NSF' THEN '4' ELSE '1' END	   TRAN_CODE,
	TO_CHAR(DEPOSIT.DEPOSIT_DATE, 'YYYYMMDD')	   DEPOSIT_DATE,
	TO_CHAR(PAYMENT.ODS_CREATE_DATE, 'YYYYMMDD')	   POST_DATE,
	LTRIM(TO_CHAR(NVL(PAYMENT.PAYMENT_AMOUNT,0),'9999990.00'))	   DEPOSIT_AMT,
	EVENT.EVENT_REF_ID	   JOB_NBR,
	CASE WHEN EVENT.PHOTOGRAPHY_DATE = TO_DATE('01-JAN-1900', 'DD-MON-YYYY') THEN '00000000' ELSE TO_CHAR(EVENT.PHOTOGRAPHY_DATE, 'YYYYMMDD') END	   PHOTO_DATE,
	EMPLOYEE.VISION_EMPLOYEE_CODE	   PHOTOGRAPHER,
	ACCOUNT.ACCOUNT_ALIAS	   ACCOUNT_NAME,
	DECODE(UPPER(NVL(DEPOSIT.VENDOR, DEPOSIT.UPSTREAM_SOURCE_SYSTEM)), 'WEBCASH', UPPER(DEPOSIT.ENTERED_BY_USER),UPPER(NVL(DEPOSIT.VENDOR, DEPOSIT.UPSTREAM_SOURCE_SYSTEM)))	   WC_USER_ID,
	DEPOSIT.PAY_PROCESSOR_TX_ID	   PAY_PROCESSOR_TX_ID,
	PAYMENT.EVENT_PAYMENT_OID	   EVENT_PAYMENT_OID,
	NVL(APO.APO_TYPE,'N/A')	   APO_TYPE
from	ODS_OWN.DEPOSIT   DEPOSIT, ODS_OWN.EVENT_PAYMENT   PAYMENT, ODS_OWN.EVENT   EVENT, ODS_OWN.BANK_ACCOUNT   BANK_ACCOUNT, ODS_OWN.SOURCE_SYSTEM   SOURCE_SYSTEM, ODS_OWN.APO   APO, ODS_OWN.ACCOUNT   ACCOUNT, ODS_OWN.EMPLOYEE   EMPLOYEE
where	
	(1=1)	
	
 And (PAYMENT.PHOTOGRAPHER_EMPLOYEE_OID=EMPLOYEE.EMPLOYEE_OID (+))
AND (EVENT.APO_OID=APO.APO_OID)
AND (PAYMENT.SOURCE_SYSTEM_OID=SOURCE_SYSTEM.SOURCE_SYSTEM_OID)
AND (PAYMENT.EVENT_OID=EVENT.EVENT_OID)
AND (DEPOSIT.BANK_ACCOUNT_OID=BANK_ACCOUNT.BANK_ACCOUNT_OID)
AND (DEPOSIT.DEPOSIT_OID=PAYMENT.DEPOSIT_OID)
AND (APO.ACCOUNT_OID=ACCOUNT.ACCOUNT_OID)
And (TRUNC(PAYMENT.ODS_CREATE_DATE) = TO_DATE(:v_rnet_load_date,'YYYYMMDD'))
 And (SOURCE_SYSTEM.SOURCE_SYSTEM_SHORT_NAME in ('WEBCASH'))
 And (PAYMENT.CURRENCY = :v_rnet_currency_type)
 And ((APO.FINANCIAL_PROCESSING_SYSTEM = 'Spectrum'  or payment.TERRITORY_ACCOUNT_TYPE = 'Publishing'))
 And (TO_CHAR(PAYMENT.ODS_CREATE_DATE,'HH24:MI:SS') <> '11:11:11')
 And (BANK_ACCOUNT.CORP_ACCOUNT_IND = :v_rnet_corp_acct_ind)
