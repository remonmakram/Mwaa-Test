/*-----------------------------------------------*/
/* TASK No. 24 */
/* Load data */

/* SOURCE CODE */
select	
	TAG.ID	   C1_ID,
	TAG.GROUP_ID	   C2_GROUP_ID,
	TAG.NAME	   C3_NAME,
	TAG.SEQUENCE	   C4_SEQUENCE,
	TAG.ACTIVE_FLAG	   C5_ACTIVE_FLAG,
	TAG.CREATED_BY	   C6_CREATED_BY,
	TAG.UPDATED_BY	   C7_UPDATED_BY,
	TAG.DATE_CREATED	   C8_DATE_CREATED,
	TAG.LAST_UPDATED	   C9_LAST_UPDATED
from	<schema_name>.TAG   TAG
where	(1=1)
And (TAG.LAST_UPDATED >=   ( TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))

