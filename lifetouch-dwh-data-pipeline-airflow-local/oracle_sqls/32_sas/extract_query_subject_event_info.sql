select	
	SUBJECT_EVENT_INFO.SUBJECT_ID	   C1_SUBJECT_ID,
	SUBJECT_EVENT_INFO.EVENT_IMAGE_FACT_ID	   C2_EVENT_IMAGE_FACT_ID,
	SUBJECT_EVENT_INFO.AUDIT_CREATE_DATE	   C3_AUDIT_CREATE_DATE,
	SUBJECT_EVENT_INFO.AUDIT_MODIFY_DATE	   C4_AUDIT_MODIFY_DATE
from	<schema_name>.SUBJECT_EVENT_INFO   SUBJECT_EVENT_INFO
where	(1=1)
And (SUBJECT_EVENT_INFO.AUDIT_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap)
