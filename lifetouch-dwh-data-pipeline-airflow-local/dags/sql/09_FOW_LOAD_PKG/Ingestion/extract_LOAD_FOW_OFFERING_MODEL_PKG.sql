select	
	OFFERING_MODEL.ID	   C1_ID,
	OFFERING_MODEL.VERSION	   C2_VERSION,
	OFFERING_MODEL.ACTIVE	   C3_ACTIVE,
	OFFERING_MODEL.COMMISSION_MODEL_ID	   C4_COMMISSION_MODEL_ID,
	OFFERING_MODEL.CREATED_BY	   C5_CREATED_BY,
	OFFERING_MODEL.DATE_CREATED	   C6_DATE_CREATED,
	OFFERING_MODEL.ENVELOPE_ID	   C7_ENVELOPE_ID,
	OFFERING_MODEL.FLYER_ID	   C8_FLYER_ID,
	OFFERING_MODEL.INSERTS	   C9_INSERTS,
	OFFERING_MODEL.LAST_UPDATED	   C10_LAST_UPDATED,
	OFFERING_MODEL.NAME	   C11_NAME,
	OFFERING_MODEL.PRICE_PROGRAM_NAME	   C12_PRICE_PROGRAM_NAME,
	OFFERING_MODEL.TERRITORY	   C13_TERRITORY,
	OFFERING_MODEL.UPDATED_BY	   C14_UPDATED_BY,
	OFFERING_MODEL.VISUAL_MERCH_ID	   C15_VISUAL_MERCH_ID
from	<schema_name>.OFFERING_MODEL   OFFERING_MODEL
where	(1=1)
And (OFFERING_MODEL.LAST_UPDATED >=   ( TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))
