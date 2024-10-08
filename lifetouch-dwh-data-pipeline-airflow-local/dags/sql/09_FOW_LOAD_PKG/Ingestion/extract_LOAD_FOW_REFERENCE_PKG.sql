select	
	REFERENCE.ID	   C1_ID,
	REFERENCE.VERSION	   C2_VERSION,
	REFERENCE.CODE	   C3_CODE,
	REFERENCE.CREATED_BY	   C4_CREATED_BY,
	REFERENCE.DATE_CREATED	   C5_DATE_CREATED,
	REFERENCE.DESCRIPTION	   C6_DESCRIPTION,
	REFERENCE.LAST_UPDATED	   C7_LAST_UPDATED,
	REFERENCE.NAME	   C8_NAME,
	REFERENCE.PUBLISHABLE	   C9_PUBLISHABLE,
	REFERENCE.SORT_ORDER	   C10_SORT_ORDER,
	REFERENCE.UPDATED_BY	   C11_UPDATED_BY
from	<schema_name>.REFERENCE   REFERENCE
where	(1=1)
And (REFERENCE.LAST_UPDATED >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
)
