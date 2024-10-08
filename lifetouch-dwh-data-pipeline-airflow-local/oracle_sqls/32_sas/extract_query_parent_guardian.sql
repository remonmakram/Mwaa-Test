select	
	PARENT_GUARDIAN.PARENT_GUARDIAN_ID	   C1_PARENT_GUARDIAN_ID,
	PARENT_GUARDIAN.ADDRESS_LINE_1	   C2_ADDRESS_LINE_1,
	PARENT_GUARDIAN.ADDRESS_LINE_2	   C3_ADDRESS_LINE_2,
	PARENT_GUARDIAN.AUDIT_CREATE_DATE	   C4_AUDIT_CREATE_DATE,
	PARENT_GUARDIAN.AUDIT_CREATED_BY	   C5_AUDIT_CREATED_BY,
	PARENT_GUARDIAN.AUDIT_MODIFIED_BY	   C6_AUDIT_MODIFIED_BY,
	PARENT_GUARDIAN.AUDIT_MODIFY_DATE	   C7_AUDIT_MODIFY_DATE,
	PARENT_GUARDIAN.CITY	   C8_CITY,
	PARENT_GUARDIAN.COUNTRY	   C9_COUNTRY,
	PARENT_GUARDIAN.COURTESY_TITLE	   C10_COURTESY_TITLE,
	PARENT_GUARDIAN.DAYTIME_PHONE	   C11_DAYTIME_PHONE,
	PARENT_GUARDIAN.EMAIL_ADDRESS	   C12_EMAIL_ADDRESS,
	PARENT_GUARDIAN.EMERGENCY_CONTACT	   C13_EMERGENCY_CONTACT,
	PARENT_GUARDIAN.FIRST_NAME	   C14_FIRST_NAME,
	PARENT_GUARDIAN.LAST_NAME	   C15_LAST_NAME,
	PARENT_GUARDIAN.MIDDLE_NAME	   C16_MIDDLE_NAME,
	PARENT_GUARDIAN.EVENING_PHONE	   C17_EVENING_PHONE,
	PARENT_GUARDIAN.POSTAL_CODE	   C18_POSTAL_CODE,
	PARENT_GUARDIAN.RELATIONSHIP	   C19_RELATIONSHIP,
	PARENT_GUARDIAN.STATE	   C20_STATE,
	PARENT_GUARDIAN.SUBJECT_ID	   C21_SUBJECT_ID
from	<schema_name>.PARENT_GUARDIAN   PARENT_GUARDIAN
where	(1=1)
And (nvl(PARENT_GUARDIAN.AUDIT_MODIFY_DATE,PARENT_GUARDIAN.AUDIT_CREATE_DATE) >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
)