select	
	LC.RECORD_TYPE	   C1_RECORD_TYPE,
	LC.HEADER_KEY	   C2_HEADER_KEY,
	LC.EXTN_TAX_CODE	   C3_EXTN_TAX_CODE,
	LC.CREATETS	   C4_CREATETS,
	LC.LINE_KEY	   C5_LINE_KEY,
	LC.REFERENCE	   C6_REFERENCE,
	LC.CHARGE_CATEGORY	   C7_CHARGE_CATEGORY,
	LC.CREATEPROGID	   C8_CREATEPROGID,
	LC.EXTN_IS_PERCENTAGE_DISCOUNT	   C9_EXTN_IS_PERCENTAGE_DISCOUNT,
	LC.ORIGINAL_CHARGEPERUNIT	   C10_ORIGINAL_CHARGEPERUNIT,
	LC.ORIGINAL_CHARGEPERLINE	   C11_ORIGINAL_CHARGEPERLINE,
	LC.EXTN_TDEBIT_AMOUNT	   C12_EXTN_TDEBIT_AMOUNT,
	LC.EXTN_TAX_INCLUSIVE	   C13_EXTN_TAX_INCLUSIVE,
	LC.EXTN_DISCOUNT_PERCENTAGE	   C14_EXTN_DISCOUNT_PERCENTAGE,
	LC.CHARGEPERUNIT	   C15_CHARGEPERUNIT,
	LC.CHARGEPERLINE	   C16_CHARGEPERLINE,
	LC.MODIFYUSERID	   C17_MODIFYUSERID,
	LC.MODIFYTS	   C18_MODIFYTS,
	LC.MODIFYPROGID	   C19_MODIFYPROGID,
	LC.CREATEUSERID	   C20_CREATEUSERID,
	LC.LINE_CHARGES_KEY	   C21_LINE_CHARGES_KEY,
	LC.EXTN_TAXABLE	   C22_EXTN_TAXABLE,
	LC.INVOICED_EXTENDED_CHARGE	   C23_INVOICED_EXTENDED_CHARGE,
	LC.CHARGEAMOUNT	   C24_CHARGEAMOUNT,
	LC.LOCKID	   C25_LOCKID,
	LC.EXTN_CHARGE_DESCRIPTION	   C26_EXTN_CHARGE_DESCRIPTION,
	LC.INVOICED_CHARGE_PER_LINE	   C27_INVOICED_CHARGE_PER_LINE,
	LC.CHARGE_NAME	   C28_CHARGE_NAME
from	<schema_name>.YFS_LINE_CHARGES   LC
where	(1=1)
And (LC.MODIFYTS >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap)
