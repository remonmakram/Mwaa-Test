select	
	AUTO_ORDER_LINE.ID	   C1_ID,
	AUTO_ORDER_LINE.VERSION	   C2_VERSION,
	AUTO_ORDER_LINE.ADDED_ON_EVENT	   C3_ADDED_ON_EVENT,
	AUTO_ORDER_LINE.AUTO_ADD_KEY	   C4_AUTO_ADD_KEY,
	AUTO_ORDER_LINE.CREATED_BY	   C5_CREATED_BY,
	AUTO_ORDER_LINE.DATE_CREATED	   C6_DATE_CREATED,
	AUTO_ORDER_LINE.DISCOUNT_PCT	   C7_DISCOUNT_PCT,
	AUTO_ORDER_LINE.ENABLED	   C8_ENABLED,
	AUTO_ORDER_LINE.ITEM_DESC	   C9_ITEM_DESC,
	AUTO_ORDER_LINE.ITEM_ID	   C10_ITEM_ID,
	AUTO_ORDER_LINE.LAST_UPDATED	   C11_LAST_UPDATED,
	AUTO_ORDER_LINE.LOOK_NO	   C12_LOOK_NO,
	AUTO_ORDER_LINE.OFFERING_ID	   C13_OFFERING_ID,
	AUTO_ORDER_LINE.ORDER_TYPE	   C14_ORDER_TYPE,
	AUTO_ORDER_LINE.QUANTITY	   C15_QUANTITY,
	AUTO_ORDER_LINE.UPDATED_BY	   C16_UPDATED_BY
from	<schema_name>.AUTO_ORDER_LINE   AUTO_ORDER_LINE
where	(1=1)
And (AUTO_ORDER_LINE.LAST_UPDATED >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap)
