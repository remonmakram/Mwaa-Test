select	
	SUBJECT_ALIAS_TYPE.SUBJECT_ALIAS_TYPE_ID	   C1_SUBJECT_ALIAS_TYPE_ID,
	SUBJECT_ALIAS_TYPE.ALIAS_TYPE	   C2_ALIAS_TYPE,
	SUBJECT_ALIAS_TYPE.DESCRIPTION	   C3_DESCRIPTION,
	SUBJECT_ALIAS_TYPE.SYSTEM_MANAGED	   C4_SYSTEM_MANAGED
from	<schema_name>.SUBJECT_ALIAS_TYPE   SUBJECT_ALIAS_TYPE
where	(1=1)