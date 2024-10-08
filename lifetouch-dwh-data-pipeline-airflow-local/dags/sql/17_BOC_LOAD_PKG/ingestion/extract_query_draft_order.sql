select	
	DRAFT_ORDER.DRAFT_ORDER_ID	   C1_DRAFT_ORDER_ID,
	DRAFT_ORDER.CREATEDATE	   C2_CREATEDATE,
	DRAFT_ORDER.CREATEDBY	   C3_CREATEDBY,
	DRAFT_ORDER.MODIFIEDBY	   C4_MODIFIEDBY,
	DRAFT_ORDER.MODIFYDATE	   C5_MODIFYDATE,
	DRAFT_ORDER.EMAIL_ADDRESS	   C6_EMAIL_ADDRESS,
	DRAFT_ORDER.EVENT_REF_ID	   C7_EVENT_REF_ID,
	DRAFT_ORDER.MATCH_TYPE	   C8_MATCH_TYPE,
	DRAFT_ORDER.ORDER_FORM_ID	   C9_ORDER_FORM_ID,
	DRAFT_ORDER.ORDER_TYPE	   C10_ORDER_TYPE,
	DRAFT_ORDER.PARENT_FIRST_NAME	   C11_PARENT_FIRST_NAME,
	DRAFT_ORDER.PARENT_LAST_NAME	   C12_PARENT_LAST_NAME,
	DRAFT_ORDER.PARENT_PHONE_NUMBER	   C13_PARENT_PHONE_NUMBER,
	DRAFT_ORDER.REQUIRES_ATTENTION	   C14_REQUIRES_ATTENTION,
	DRAFT_ORDER.SESSION_ID	   C15_SESSION_ID,
	DRAFT_ORDER.SHIPPING_AMOUNT	   C16_SHIPPING_AMOUNT,
	DRAFT_ORDER.SOURCE_SYSTEM_ID	   C17_SOURCE_SYSTEM_ID,
	DRAFT_ORDER.STATUS	   C18_STATUS,
	DRAFT_ORDER.SUBJECT_ALPHA_NUMBER	   C19_SUBJECT_ALPHA_NUMBER,
	DRAFT_ORDER.SUBJECT_FIRST_NAME	   C20_SUBJECT_FIRST_NAME,
	DRAFT_ORDER.SUBJECT_GRADE	   C21_SUBJECT_GRADE,
	DRAFT_ORDER.SUBJECT_LAST_NAME	   C22_SUBJECT_LAST_NAME,
	DRAFT_ORDER.UNPAID	   C23_UNPAID,
	DRAFT_ORDER.BILL_TO_ADDRESS	   C24_BILL_TO_ADDRESS,
	DRAFT_ORDER.SHIP_TO_ADDRESS	   C25_SHIP_TO_ADDRESS,
	DRAFT_ORDER.SM_SUBJECT_FIRST_NAME	   C26_SM_SUBJECT_FIRST_NAME,
	DRAFT_ORDER.SM_SUBJECT_LAST_NAME	   C27_SM_SUBJECT_LAST_NAME,
	DRAFT_ORDER.EXCEPTION_REASON	   C28_EXCEPTION_REASON,
	DRAFT_ORDER.ORDER_BATCH_ID	   C29_ORDER_BATCH_ID,
	DRAFT_ORDER.EVENT_ID	   C30_EVENT_ID,
	DRAFT_ORDER.MATCHED_EVENT_ID	   C31_MATCHED_EVENT_ID,
	DRAFT_ORDER.ORIG_DRAFT_ORDER_ID	   C32_ORIG_DRAFT_ORDER_ID,
	DRAFT_ORDER.PRICING_CONTEXT	   C33_PRICING_CONTEXT,
	DRAFT_ORDER.GENERATED	   C34_GENERATED,
	DRAFT_ORDER.ORIG_RETAKE_NUMBER	   C35_ORIG_RETAKE_NUMBER,
	DRAFT_ORDER.PROCESSED_AMOUNT	   C36_PROCESSED_AMOUNT,
	DRAFT_ORDER.EXTERNAL_ORDER_NUMBER	   C37_EXTERNAL_ORDER_NUMBER,
	DRAFT_ORDER.MATCHING_REQUIRED	   C38_MATCHING_REQUIRED,
	DRAFT_ORDER.BATCHING_REQUIRED	   C39_BATCHING_REQUIRED,
	DRAFT_ORDER.ORDER_PROCESSING_TYPE	   C40_ORDER_PROCESSING_TYPE
from	<schema_name>.DRAFT_ORDER   DRAFT_ORDER
where	(1=1)
And (DRAFT_ORDER.MODIFYDATE >=  ( TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))
