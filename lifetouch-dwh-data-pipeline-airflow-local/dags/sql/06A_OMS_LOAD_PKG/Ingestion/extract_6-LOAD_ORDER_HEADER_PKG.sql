select	
	S.APO_KEY	   C1_APO_KEY,
	S.DESCRIPTION	   C2_DESCRIPTION,
	S.ACCOUNT_ID	   C3_ACCOUNT_ID,
	S.GRAD_YEAR	   C4_GRAD_YEAR,
	S.STATUS	   C5_STATUS,
	substr(S.ACCOUNT_NAME,1,40)	   C6_ACCOUNT_NAME,
	S.PROGRAM_TYPE	   C7_PROGRAM_TYPE,
	S.PRICE_PROGRAM_NAME	   C8_PRICE_PROGRAM_NAME,
	S.PHOTOGRAPHY_LOCATION	   C9_PHOTOGRAPHY_LOCATION,
	S.GLOSSIES_REQD	   C10_GLOSSIES_REQD,
	S.YEARBOOK_POSE_REQD	   C11_YEARBOOK_POSE_REQD,
	S.PUBLISHER	   C12_PUBLISHER,
	S.OTHER_PUBLISHER	   C13_OTHER_PUBLISHER,
	S.SHIP_PROOFS_TO	   C14_SHIP_PROOFS_TO,
	S.SHIP_ORDERS_TO	   C15_SHIP_ORDERS_TO,
	S.SHIP_GLOSSIES_TO	   C16_SHIP_GLOSSIES_TO,
	S.SHIP_PROOFS_STUDIO_CODE	   C17_SHIP_PROOFS_STUDIO_CODE,
	S.SHIP_ORDERS_STUDIO_CODE	   C18_SHIP_ORDERS_STUDIO_CODE,
	S.SHIP_GLOSSIES_STUDIO_CODE	   C19_SHIP_GLOSSIES_STUDIO_CODE,
	S.TERRITORY_GROUP_ID	   C20_TERRITORY_GROUP_ID,
	S.SHIP_PROOFS_STUDIO_ATTN	   C21_SHIP_PROOFS_STUDIO_ATTN,
	S.SHIP_ORDERS_STUDIO_ATTN	   C22_SHIP_ORDERS_STUDIO_ATTN,
	S.SHIP_GLOSSIES_STUDIO_ATTN	   C23_SHIP_GLOSSIES_STUDIO_ATTN,
	S.COMMISSION_PER_CUST	   C24_COMMISSION_PER_CUST,
	S.COMMISSION_PERCENTAGE	   C25_COMMISSION_PERCENTAGE,
	S.COMMISSION_GUARANTEED	   C26_COMMISSION_GUARANTEED,
	S.COMMISSION_SPECIAL	   C27_COMMISSION_SPECIAL,
	S.ORDER_RETURN_MSG_REQD	   C28_ORDER_RETURN_MSG_REQD,
	S.ORDER_REMINDER_REQD	   C29_ORDER_REMINDER_REQD,
	S.ORDER_ASSIST_REQD	   C30_ORDER_ASSIST_REQD,
	S.INCLUDE_ORDER_FORM	   C31_INCLUDE_ORDER_FORM,
	S.INCLUDE_RETURN_ENVELOPE	   C32_INCLUDE_RETURN_ENVELOPE,
	S.ORDER_BY_PHONE_NO	   C33_ORDER_BY_PHONE_NO,
	S.ORDER_ENQUIRY_NO	   C34_ORDER_ENQUIRY_NO,
	S.YEARBOOK_POSESTYLE_1	   C35_YEARBOOK_POSESTYLE_1,
	S.YEARBOOK_POSESTYLE_2	   C36_YEARBOOK_POSESTYLE_2,
	S.YEARBOOK_POSESTYLE_OTHER1	   C37_YEARBOOK_POSESTYLE_OTHER1,
	S.YEARBOOK_POSESTYLE_OTHER2	   C38_YEARBOOK_POSESTYLE_OTHER2,
	S.YEARBOOK_BACKGROUND1	   C39_YEARBOOK_BACKGROUND1,
	S.YEARBOOK_BACKGROUND2	   C40_YEARBOOK_BACKGROUND2,
	S.YEARBOOK_BGROUND_OTHER1	   C41_YEARBOOK_BGROUND_OTHER1,
	S.YEARBOOK_BGROUND_OTHER2	   C42_YEARBOOK_BGROUND_OTHER2,
	S.YEARBOOK_OUTFIT1	   C43_YEARBOOK_OUTFIT1,
	S.YEARBOOK_OUTFIT2	   C44_YEARBOOK_OUTFIT2,
	S.YEARBOOK_OUTFIT_OTHER1	   C45_YEARBOOK_OUTFIT_OTHER1,
	S.YEARBOOK_OUTFIT_OTHER2	   C46_YEARBOOK_OUTFIT_OTHER2,
	S.YEARBOOK_SPL_INST	   C47_YEARBOOK_SPL_INST,
	S.GLOSSIES_OUTPUT	   C48_GLOSSIES_OUTPUT,
	S.GLOSSIES_PAPER_DEADLINE	   C49_GLOSSIES_PAPER_DEADLINE,
	S.GLOSSIES_DEL_DEADLINE	   C50_GLOSSIES_DEL_DEADLINE,
	S.MULTIPLE_IMAGES_OPTION	   C51_MULTIPLE_IMAGES_OPTION,
	S.PRINTABLE_FRAMES	   C52_PRINTABLE_FRAMES,
	S.TERRITORY_ID	   C53_TERRITORY_ID,
	S.STUDIO_ID	   C54_STUDIO_ID,
	S.PROCESSING_LAB	   C55_PROCESSING_LAB,
	S.PUBLISHER_ADDRESS_LINE1	   C56_PUBLISHER_ADDRESS_LINE1,
	S.PUBLISHER_ADDRESS_LINE2	   C57_PUBLISHER_ADDRESS_LINE2,
	S.PUBLISHER_ADDRESS_LINE3	   C58_PUBLISHER_ADDRESS_LINE3,
	S.PUBLISHER_CITY	   C59_PUBLISHER_CITY,
	S.PUBLISHER_STATE	   C60_PUBLISHER_STATE,
	S.PUBLISHER_ZIP_CODE	   C61_PUBLISHER_ZIP_CODE,
	S.PUBLISHER_COUNTRY	   C62_PUBLISHER_COUNTRY,
	S.PUBLISHER_PHONENO	   C63_PUBLISHER_PHONENO,
	S.PUBLISHER_FAXNO	   C64_PUBLISHER_FAXNO,
	S.PUBLISHER_EMAIL	   C65_PUBLISHER_EMAIL,
	S.PUBLISHER_CONTACT_PERSON	   C66_PUBLISHER_CONTACT_PERSON,
	S.ACCOUNT_ADDRESS_LINE1	   C67_ACCOUNT_ADDRESS_LINE1,
	S.ACCOUNT_ADDRESS_LINE2	   C68_ACCOUNT_ADDRESS_LINE2,
	S.ACCOUNT_ADDRESS_LINE3	   C69_ACCOUNT_ADDRESS_LINE3,
	S.ACCOUNT_CITY	   C70_ACCOUNT_CITY,
	S.ACCOUNT_STATE	   C71_ACCOUNT_STATE,
	S.ACCOUNT_ZIP_CODE	   C72_ACCOUNT_ZIP_CODE,
	S.ACCOUNT_COUNTRY	   C73_ACCOUNT_COUNTRY,
	S.ACCOUNT_PHONENO	   C74_ACCOUNT_PHONENO,
	S.ACCOUNT_CONTACT_PERSON	   C75_ACCOUNT_CONTACT_PERSON,
	S.ACCOUNT_FAXNO	   C76_ACCOUNT_FAXNO,
	S.ACCOUNT_EMAIL	   C77_ACCOUNT_EMAIL,
	S.PUBLISHER_ACCT_NO	   C78_PUBLISHER_ACCT_NO,
	S.VISION_JOB_NO	   C79_VISION_JOB_NO,
	S.CURRENCY	   C80_CURRENCY,
	S.CREATETS	   C81_CREATETS,
	S.MODIFYTS	   C82_MODIFYTS,
	S.CREATEUSERID	   C83_CREATEUSERID,
	S.MODIFYUSERID	   C84_MODIFYUSERID,
	S.CREATEPROGID	   C85_CREATEPROGID,
	S.MODIFYPROGID	   C86_MODIFYPROGID,
	S.LOCKID	   C87_LOCKID,
	S.APO_ID	   C88_APO_ID,
	S.CONFIRMED_PROCESSING_LAB	   C89_CONFIRMED_PROCESSING_LAB,
	S.PHOTOTRACKER_DEL_DATE	   C90_PHOTOTRACKER_DEL_DATE,
	S.SOLO_ACCESS	   C91_SOLO_ACCESS,
	S.ESTIMATED_ENROLLMENT	   C92_ESTIMATED_ENROLLMENT,
	S.TERRITORY_NOTES	   C93_TERRITORY_NOTES,
	S.SELLER_FOR_ORDER	   C94_SELLER_FOR_ORDER,
	S.LAB_REVISION_NO	   C95_LAB_REVISION_NO,
	S.LAB_NOTES	   C96_LAB_NOTES,
	S.BOYS_GOWN_COLOR_1	   C97_BOYS_GOWN_COLOR_1,
	S.BOYS_TASSEL_COLOR_1	   C98_BOYS_TASSEL_COLOR_1,
	S.GIRLS_GOWN_COLOR_1	   C99_GIRLS_GOWN_COLOR_1,
	S.GIRLS_TASSEL_COLOR_1	   C100_GIRLS_TASSEL_COLOR_1,
	S.BOYS_GOWN_COLOR_2	   C101_BOYS_GOWN_COLOR_2,
	S.BOYS_TASSEL_COLOR_2	   C102_BOYS_TASSEL_COLOR_2,
	S.GIRLS_GOWN_COLOR_2	   C103_GIRLS_GOWN_COLOR_2,
	S.GIRLS_TASSEL_COLOR_2	   C104_GIRLS_TASSEL_COLOR_2,
	S.NO_OF_PROOF_SETS	   C105_NO_OF_PROOF_SETS,
	S.NO_OF_GLOSSY_SETS	   C106_NO_OF_GLOSSY_SETS,
	S.STUDENT_ID_REQD	   C107_STUDENT_ID_REQD,
	S.TAX_EXEMPT_CERTIFICATE_NUMBER	   C108_TAX_EXEMPT_CERTIFICATE_NU,
	S.TAX_EXEMPT	   C109_TAX_EXEMPT,
	S.SELECT_ORDER_BY_PHONE_NO	   C110_SELECT_ORDER_BY_PHONE_NO,
	S.SELECT_ORDER_ENQUIRY_NO	   C111_SELECT_ORDER_ENQUIRY_NO,
	S.IS_PROOF_EXPRESS	   C112_IS_PROOF_EXPRESS,
	S.GUARANTEED_DOLLAR_AMOUNT	   C113_GUARANTEED_DOLLAR_AMOUNT,
	S.GRAD_ANNOUNCE_POSTER_INS	   C114_GRAD_ANNOUNCE_POSTER_INS,
	S.CUSTOM_LANGUAGE	   C115_CUSTOM_LANGUAGE,
	S.YB_SELECTION_ONLINE	   C116_YB_SELECTION_ONLINE,
	S.ORDER_FORM_ITEM_ID	   C117_ORDER_FORM_ITEM_ID,
	S.SUB_PROGRAM_TYPE	   C118_SUB_PROGRAM_TYPE,
	S.MARKETING_CODE	   C119_MARKETING_CODE,
	S.FLYER_ID	   C120_FLYER_ID,
	S.SORT_TYPE	   C121_SORT_TYPE,
	S.ENVELOPE_TYPE	   C122_ENVELOPE_TYPE,
	S.VISUAL_MERCH_KEY	   C123_VISUAL_MERCH_KEY,
	S.VISUAL_MERCH_ID	   C124_VISUAL_MERCH_ID,
	S.REVISION_NO	   C125_REVISION_NO,
	S.COMP_PROD_CODE	   C126_COMP_PROD_CODE,
	S.COMP_DLVRY_TYPE	   C127_COMP_DLVRY_TYPE,
	S.GRP_PROD_CODE	   C128_GRP_PROD_CODE,
	S.GRP_DLVRY_TYPE	   C129_GRP_DLVRY_TYPE,
	S.MODEL_GRADE	   C130_MODEL_GRADE,
	S.MODEL_ETHNICITY	   C131_MODEL_ETHNICITY,
	S.MODEL_GENDER	   C132_MODEL_GENDER,
	S.SERVICE_CENTER	   C133_SERVICE_CENTER,
	S.EVENT_IMAGE_COMPLETE	   C134_EVENT_IMAGE_COMPLETE,
	S.SHIP_TO_ACCOUNT_BUFFER_DAYS	   C135_SHIP_TO_ACCOUNT_BUFFER_DA,
	S.ORIGINAL_ORDER_FORM_DUE_DATE	   C136_ORIGINAL_ORDER_FORM_DUE_D,
	S.RETAKE_ORDER_FORM_DUE_DATE	   C137_RETAKE_ORDER_FORM_DUE_DAT,
	S.EXTERNAL_SYNC_FLAG	   C138_EXTERNAL_SYNC_FLAG,
	S.FULFILLING_LAB_SYSTEM	   C139_FULFILLING_LAB_SYSTEM,
	S.FINANCIAL_PROCESSING_SYSTEM	   C140_FINANCIAL_PROCESSING_SYST,
	S.ORIGINAL_BOOKING_REP	   C141_ORIGINAL_BOOKING_REP,
	S.ORIGINAL_BOOKING_REP_NAME	   C142_ORIGINAL_BOOKING_REP_NAME,
	S.SHIP_TO_SATELLITE_LOCATION	   C143_SHIP_TO_SATELLITE_LOCATIO,
	S.CLASS_PICTURE_RELEASE_DATE	   C144_CLASS_PICTURE_RELEASE_DAT
from	<schema_name>.LT_APO   S
where	(1=1)
And (S.MODIFYTS >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap)
