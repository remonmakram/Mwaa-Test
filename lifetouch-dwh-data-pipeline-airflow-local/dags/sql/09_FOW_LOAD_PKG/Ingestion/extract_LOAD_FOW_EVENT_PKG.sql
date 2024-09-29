select	
	EVENT.ID	   C1_ID,
	EVENT.VERSION	   C2_VERSION,
	EVENT.ACTIVE	   C3_ACTIVE,
	EVENT.APO_ID	   C4_APO_ID,
	EVENT.CREATED_BY	   C5_CREATED_BY,
	EVENT.DATE_CREATED	   C6_DATE_CREATED,
	EVENT.DESCRIPTION	   C7_DESCRIPTION,
	EVENT.END_DATE	   C8_END_DATE,
	EVENT.EST_SUBJECTS	   C9_EST_SUBJECTS,
	EVENT.EVENT_GUID	   C10_EVENT_GUID,
	EVENT.EVENT_TYPE	   C11_EVENT_TYPE,
	EVENT.EVENT_REF_ID	   C12_EVENT_REF_ID,
	EVENT.JOB_SEQUENCE	   C13_JOB_SEQUENCE,
	EVENT.LAST_UPDATED	   C14_LAST_UPDATED,
	EVENT.PRIM_SORT	   C15_PRIM_SORT,
	EVENT.PUBLISHED	   C16_PUBLISHED,
	EVENT.REVISION_NO	   C17_REVISION_NO,
	EVENT.SEC_SORT	   C18_SEC_SORT,
	EVENT.SHIP_TO	   C19_SHIP_TO,
	EVENT.SHIP_TO_ADDRESS	   C20_SHIP_TO_ADDRESS,
	EVENT.START_DATE	   C21_START_DATE,
	EVENT.UPDATED_BY	   C22_UPDATED_BY,
	EVENT.PDK_NUMBER	   C23_PDK_NUMBER,
	EVENT.ALTERNATE_PICTURE_DAY_TEXT	   C24_ALTERNATE_PICTURE_DAY_TEXT,
	EVENT.SPECIAL_INSTRUCTIONS	   C25_SPECIAL_INSTRUCTIONS,
	EVENT.STATUS	   C26_STATUS,
	EVENT.FLYER_TITLE	   C27_FLYER_TITLE,
	EVENT.SHIP_TO_SATELLITE_CODE	   C28_SHIP_TO_SATELLITE_CODE,
	EVENT.YB_ARRIVAL_DATE	   C29_YB_ARRIVAL_DATE,
	EVENT.COVER_ENDSHEET_DEADLINE	   C30_COVER_ENDSHEET_DEADLINE,
	EVENT.FIRST_PAGE_DEADLINE	   C31_FIRST_PAGE_DEADLINE,
	EVENT.FINAL_PAGE_DEADLINE	   C32_FINAL_PAGE_DEADLINE,
	EVENT.CUT_OUT_PAGES	   C33_CUT_OUT_PAGES,
	EVENT.YB_EXTRA_COPIES	   C34_YB_EXTRA_COPIES,
	EVENT.YB_PAGES	   C35_YB_PAGES,
	EVENT.YB_COPIES	   C36_YB_COPIES,
	EVENT.YB_SOFT_COVER_QTY	   C37_YB_SOFT_COVER_QTY,
	EVENT.YB_HARD_COVER_QTY	   C38_YB_HARD_COVER_QTY,
	EVENT.YB_REORDER_CHARGE	   C39_YB_REORDER_CHARGE,
	EVENT.INVOICE_TO	   C40_INVOICE_TO,
	EVENT.INVOICE_TO_ADDRESS	   C41_INVOICE_TO_ADDRESS,
	EVENT.SHIPPING_HANDLING	   C42_SHIPPING_HANDLING,
	EVENT.SHIPPING_CHARGE	   C43_SHIPPING_CHARGE,
	EVENT.PORTRAIT_PAGES	   C44_PORTRAIT_PAGES,
	EVENT.ACTIVITY_PAGES	   C45_ACTIVITY_PAGES,
	EVENT.SR_APPOINTMENT_DISTRIBUTION	   C46_SR_APPOINTMENT_DISTRIBUTIO,
	EVENT.AUTO_PDK_DISABLED	   C47_AUTO_PDK_DISABLED,
	EVENT.AUTO_PDK_DISABLED_REASON	   C48_AUTO_PDK_DISABLED_REASON,
	EVENT.AUTO_PDK_UPDATED_BY	   C49_AUTO_PDK_UPDATED_BY,
	EVENT.AUTO_PDK_UPDATED_DATE	   C50_AUTO_PDK_UPDATED_DATE,
	EVENT.YB_DEPOSIT_PERCENT	   C51_YB_DEPOSIT_PERCENT,
	EVENT.SCHOOL_PO_HEADER	   C52_SCHOOL_PO_HEADER,
	EVENT.RECEIVED_DATE	   C53_RECEIVED_DATE,
	EVENT.PDKOFFSET	   C54_PDKOFFSET,
	EVENT.SALE_TYPE	   C55_SALE_TYPE,
	EVENT.CLASS_PICTURE_RELEASE	   C56_CLASS_PICTURE_RELEASE,
	EVENT.FINAL_QUANTITY_DEADLINE	   C57_FINAL_QUANTITY_DEADLINE,
	EVENT.ADDITIONAL_PAGE_DEADLINE2	   C58_ADDITIONAL_PAGE_DEADLINE2,
	EVENT.ADDITIONAL_PAGE_DEADLINE3	   C59_ADDITIONAL_PAGE_DEADLINE3,
	EVENT.EXTRA_COVERAGE_DEADLINE	   C60_EXTRA_COVERAGE_DEADLINE,
	EVENT.ENHANCEMENT_DEADLINE	   C61_ENHANCEMENT_DEADLINE,
	EVENT.FIRST_PAGE_DEADLINE_PP	   C62_FIRST_PAGE_DEADLINE_PP,
	EVENT.ADDITIONAL_PAGE_DEADLINE2_PP	   C63_ADDITIONAL_PAGE_DEADLINE2_,
	EVENT.ADDITIONAL_PAGE_DEADLINE3_PP	   C64_ADDITIONAL_PAGE_DEADLINE3_,
	EVENT.EXTRA_COVERAGE_DEADLINE_PP	   C65_EXTRA_COVERAGE_DEADLINE_PP,
	EVENT.FINAL_PAGE_DEADLINE_PP	   C66_FINAL_PAGE_DEADLINE_PP,
	EVENT.EVENT_IMAGE_COMPLETE	   C67_EVENT_IMAGE_COMPLETE
from	<schema_name>.EVENT   EVENT
where	(1=1)
And (EVENT.LAST_UPDATED >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap)
