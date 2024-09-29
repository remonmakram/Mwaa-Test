
/*-----------------------------------------------*/
/* TASK No. 6 */
/* Load data */

/* SOURCE CODE */
select	
	TAG_GROUP.ID	   C1_ID,
	TAG_GROUP.NAME	   C2_NAME,
	TAG_GROUP.ACTIVE_FLAG	   C3_ACTIVE_FLAG,
	TAG_GROUP.CREATED_BY	   C4_CREATED_BY,
	TAG_GROUP.UPDATED_BY	   C5_UPDATED_BY,
	TAG_GROUP.DATE_CREATED	   C6_DATE_CREATED,
	TAG_GROUP.LAST_UPDATED	   C7_LAST_UPDATED
from	<schema_name>.TAG_GROUP   TAG_GROUP
where	(1=1)
And (TAG_GROUP.LAST_UPDATED  >= ( TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))



