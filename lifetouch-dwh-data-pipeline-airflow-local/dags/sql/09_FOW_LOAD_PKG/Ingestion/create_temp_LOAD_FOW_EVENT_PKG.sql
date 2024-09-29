DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_EVENT_STG purge';  
      EXCEPTION  
         WHEN OTHERS THEN  
            IF SQLCODE != -942 THEN  
               RAISE;  
            END IF;   
      END;  
      create_query := 'create table RAX_APP_USER.C$_0FOW_EVENT_STG
                        (
                            C1_ID	NUMBER(19) NULL,
                            C2_VERSION	NUMBER(19) NULL,
                            C3_ACTIVE	NUMBER(1) NULL,
                            C4_APO_ID	NUMBER(19) NULL,
                            C5_CREATED_BY	VARCHAR2(255) NULL,
                            C6_DATE_CREATED	TIMESTAMP(6) NULL,
                            C7_DESCRIPTION	VARCHAR2(255) NULL,
                            C8_END_DATE	TIMESTAMP(6) NULL,
                            C9_EST_SUBJECTS	NUMBER(10) NULL,
                            C10_EVENT_GUID	VARCHAR2(255) NULL,
                            C11_EVENT_TYPE	VARCHAR2(255) NULL,
                            C12_EVENT_REF_ID	VARCHAR2(255) NULL,
                            C13_JOB_SEQUENCE	VARCHAR2(255) NULL,
                            C14_LAST_UPDATED	TIMESTAMP(6) NULL,
                            C15_PRIM_SORT	VARCHAR2(255) NULL,
                            C16_PUBLISHED	NUMBER(1) NULL,
                            C17_REVISION_NO	NUMBER(19) NULL,
                            C18_SEC_SORT	VARCHAR2(255) NULL,
                            C19_SHIP_TO	VARCHAR2(255) NULL,
                            C20_SHIP_TO_ADDRESS	VARCHAR2(255) NULL,
                            C21_START_DATE	TIMESTAMP(6) NULL,
                            C22_UPDATED_BY	VARCHAR2(255) NULL,
                            C23_PDK_NUMBER	VARCHAR2(255) NULL,
                            C24_ALTERNATE_PICTURE_DAY_TEXT	VARCHAR2(255) NULL,
                            C25_SPECIAL_INSTRUCTIONS	VARCHAR2(1024) NULL,
                            C26_STATUS	VARCHAR2(255) NULL,
                            C27_FLYER_TITLE	VARCHAR2(255) NULL,
                            C28_SHIP_TO_SATELLITE_CODE	VARCHAR2(255) NULL,
                            C29_YB_ARRIVAL_DATE	TIMESTAMP(6) NULL,
                            C30_COVER_ENDSHEET_DEADLINE	TIMESTAMP(6) NULL,
                            C31_FIRST_PAGE_DEADLINE	TIMESTAMP(6) NULL,
                            C32_FINAL_PAGE_DEADLINE	TIMESTAMP(6) NULL,
                            C33_CUT_OUT_PAGES	NUMBER(1) NULL,
                            C34_YB_EXTRA_COPIES	NUMBER(1) NULL,
                            C35_YB_PAGES	NUMBER(3) NULL,
                            C36_YB_COPIES	NUMBER(4) NULL,
                            C37_YB_SOFT_COVER_QTY	NUMBER(3) NULL,
                            C38_YB_HARD_COVER_QTY	NUMBER(3) NULL,
                            C39_YB_REORDER_CHARGE	NUMBER(3) NULL,
                            C40_INVOICE_TO	VARCHAR2(255) NULL,
                            C41_INVOICE_TO_ADDRESS	VARCHAR2(255) NULL,
                            C42_SHIPPING_HANDLING	VARCHAR2(255) NULL,
                            C43_SHIPPING_CHARGE	NUMBER NULL,
                            C44_PORTRAIT_PAGES	NUMBER(3) NULL,
                            C45_ACTIVITY_PAGES	NUMBER(3) NULL,
                            C46_SR_APPOINTMENT_DISTRIBUTIO	VARCHAR2(20) NULL,
                            C47_AUTO_PDK_DISABLED	NUMBER(22,1) NULL,
                            C48_AUTO_PDK_DISABLED_REASON	VARCHAR2(1020) NULL,
                            C49_AUTO_PDK_UPDATED_BY	VARCHAR2(1020) NULL,
                            C50_AUTO_PDK_UPDATED_DATE	TIMESTAMP(6) NULL,
                            C51_YB_DEPOSIT_PERCENT	NUMBER NULL,
                            C52_SCHOOL_PO_HEADER	VARCHAR2(50) NULL,
                            C53_RECEIVED_DATE	DATE NULL,
                            C54_PDKOFFSET	NUMBER NULL,
                            C55_SALE_TYPE	VARCHAR2(10) NULL,
                            C56_CLASS_PICTURE_RELEASE	NUMBER NULL,
                            C57_FINAL_QUANTITY_DEADLINE	DATE NULL,
                            C58_ADDITIONAL_PAGE_DEADLINE2	DATE NULL,
                            C59_ADDITIONAL_PAGE_DEADLINE3	DATE NULL,
                            C60_EXTRA_COVERAGE_DEADLINE	DATE NULL,
                            C61_ENHANCEMENT_DEADLINE	DATE NULL,
                            C62_FIRST_PAGE_DEADLINE_PP	NUMBER NULL,
                            C63_ADDITIONAL_PAGE_DEADLINE2_	NUMBER NULL,
                            C64_ADDITIONAL_PAGE_DEADLINE3_	NUMBER NULL,
                            C65_EXTRA_COVERAGE_DEADLINE_PP	NUMBER NULL,
                            C66_FINAL_PAGE_DEADLINE_PP	NUMBER NULL,
                            C67_EVENT_IMAGE_COMPLETE	NUMBER(1) NULL
                        )
                        NOLOGGING';  
      EXECUTE IMMEDIATE create_query;  
   END;  
 