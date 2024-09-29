select	
	RECORD_CHANGE_AUDIT.TABLE_NAME	   C1_TABLE_NAME,
	RECORD_CHANGE_AUDIT.KEY_VALUE	   C2_KEY_VALUE,
	RECORD_CHANGE_AUDIT.EVENT_TYPE	   C3_EVENT_TYPE,
	RECORD_CHANGE_AUDIT.EVENT_DETAIL	   C4_EVENT_DETAIL,
	RECORD_CHANGE_AUDIT.DATE_CREATED	   C5_DATE_CREATED,
	RECORD_CHANGE_AUDIT.KEY_VALUE2	   C6_KEY_VALUE2
from	<schema_name>.RECORD_CHANGE_AUDIT   RECORD_CHANGE_AUDIT
where	(1=1)
And (RECORD_CHANGE_AUDIT.DATE_CREATED  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap)
