DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STG_FOW_APO';  
      EXCEPTION  
         WHEN OTHERS THEN  
            IF SQLCODE != -942 THEN  
               RAISE;  
            END IF;   
      END;  
      create_query := 'create table RAX_APP_USER.C$_0STG_FOW_APO
                        (
                            C1_CAMERA_PLATFORM	VARCHAR2(255) NULL,
                            C2_CONFIRMED_LAB	VARCHAR2(255) NULL,
                            C3_COUNTRY	VARCHAR2(255) NULL,
                            C4_POSTAL_CODE	VARCHAR2(255) NULL,
                            C5_CITY	VARCHAR2(255) NULL,
                            C6_ADDRESS	VARCHAR2(255) NULL,
                            C7_COUNTY	VARCHAR2(255) NULL,
                            C8_VERSION	NUMBER(19) NULL,
                            C9_FINANCIAL_PROCESSING_SYSTEM	VARCHAR2(10) NULL,
                            C10_RISK_IND	NUMBER(1) NULL,
                            C11_LANGUAGE2	VARCHAR2(255) NULL,
                            C12_FULFILLING_LAB_SYSTEM	VARCHAR2(10) NULL,
                            C13_ENVELOPE_ID	VARCHAR2(20) NULL,
                            C14_SUBCATEGORY	VARCHAR2(255) NULL,
                            C15_ORIGINAL_BOOKING_REP	VARCHAR2(255) NULL,
                            C16_VALIDATION_ERROR	VARCHAR2(1024) NULL,
                            C17_ORIGINAL_BOOKING_REP_NAME	VARCHAR2(255) NULL,
                            C18_LOCK_ON_NAME	NUMBER(1) NULL,
                            C19_CATEGORY	VARCHAR2(255) NULL,
                            C20_EST_TO_BE_PHOTOED	VARCHAR2(255) NULL,
                            C21_MARKETING_CODE	VARCHAR2(255) NULL,
                            C22_OPERATIONS_REP_NAME	VARCHAR2(255) NULL,
                            C23_CONSUMER_ENQ_PHONE	VARCHAR2(255) NULL,
                            C24_ORDER_FORM	VARCHAR2(255) NULL,
                            C25_LANGUAGE	VARCHAR2(255) NULL,
                            C26_TERRITORY	VARCHAR2(255) NULL,
                            C27_SELLING_METHOD	VARCHAR2(255) NULL,
                            C28_LOC_CODE	VARCHAR2(255) NULL,
                            C29_LOW_GRADE	VARCHAR2(255) NULL,
                            C30_ACCOUNT_NAME	VARCHAR2(255) NULL,
                            C31_REMINDER_POSTCARD	NUMBER(1) NULL,
                            C32_RISK_TEXT	VARCHAR2(255) NULL,
                            C33_FAX	VARCHAR2(255) NULL,
                            C34_CREATED_BY	VARCHAR2(255) NULL,
                            C35_STATUS	VARCHAR2(255) NULL,
                            C36_REPORT_GRP	VARCHAR2(255) NULL,
                            C37_SERVICE_PRODUCT_SORT	VARCHAR2(255) NULL,
                            C38_SHIP_TO	VARCHAR2(255) NULL,
                            C39_PROCESSING_LAB	VARCHAR2(255) NULL,
                            C40_SCHOOL_YR_END	NUMBER(10) NULL,
                            C41_ID	NUMBER(19) NULL,
                            C42_PHOTO_LOCATION	VARCHAR2(255) NULL,
                            C43_APO_TAG	VARCHAR2(255) NULL,
                            C44_RISK_CODE	VARCHAR2(255) NULL,
                            C45_OFFER_ONLINE_ORDERING	NUMBER(1) NULL,
                            C46_PHONE_ORDER	VARCHAR2(255) NULL,
                            C47_BOOKING_YEAR	VARCHAR2(255) NULL,
                            C48_SALES_REP_CODE	VARCHAR2(255) NULL,
                            C49_DESCRIPTION	VARCHAR2(255) NULL,
                            C50_REVISION_NO	NUMBER(19) NULL,
                            C51_HIGH_GRADE	VARCHAR2(255) NULL,
                            C52_CONSUMER_MODEL	VARCHAR2(255) NULL,
                            C53_SUB_PROGRAM	VARCHAR2(255) NULL,
                            C54_PUBLISHED	NUMBER(1) NULL,
                            C55_PHONE	VARCHAR2(255) NULL,
                            C56_TAX_CERTIFICATE	VARCHAR2(255) NULL,
                            C57_BOOKING_OPP_ID	NUMBER(19) NULL,
                            C58_ORDER_FORM_ITEM_ID	VARCHAR2(255) NULL,
                            C59_DEFAULT_ORD_PKG	VARCHAR2(255) NULL,
                            C60_DATE_CREATED	TIMESTAMP(6) NULL,
                            C61_VISION_JOB	VARCHAR2(255) NULL,
                            C62_SVC_PROD_MODEL	VARCHAR2(255) NULL,
                            C63_BUS_CONTEXT_NAME	VARCHAR2(255) NULL,
                            C64_PROGRAM	VARCHAR2(255) NULL,
                            C65_NACAM_OVERALL	VARCHAR2(255) NULL,
                            C66_JOB_IDENTIFIER	VARCHAR2(255) NULL,
                            C67_TAX_EXEMPT	NUMBER(1) NULL,
                            C68_SALES_REP_NAME	VARCHAR2(255) NULL,
                            C69_UPDATED_BY	VARCHAR2(255) NULL,
                            C70_LAST_UPDATED	TIMESTAMP(6) NULL,
                            C71_ENROLLMENT_COUNT	NUMBER(10) NULL,
                            C72_TWO_WEEK_RETURN_MSG	NUMBER(1) NULL,
                            C73_CONSUMER_SORT	VARCHAR2(255) NULL,
                            C74_PROOF_EXPRESS	NUMBER(1) NULL,
                            C75_CONTACT	VARCHAR2(255) NULL,
                            C76_SERVICE_CENTER	VARCHAR2(255) NULL,
                            C77_CURRENCY	VARCHAR2(255) NULL,
                            C78_LAB_INSTRUCTIONS	VARCHAR2(255) NULL,
                            C79_LID	NUMBER(19) NULL,
                            C80_COPIED_FROM_ODS	VARCHAR2(1) NULL,
                            C81_CONTRACT_RECEIVED	TIMESTAMP(6) NULL,
                            C82_APO_TYPE	VARCHAR2(255) NULL,
                            C83_YB_PROGRAM	VARCHAR2(255) NULL,
                            C84_SALES_REP_EMAIL	VARCHAR2(255) NULL,
                            C85_FINALIZED_DATE	TIMESTAMP(6) NULL,
                            C86_COVER_RECEIVED	TIMESTAMP(6) NULL,
                            C87_SALE_TYPE	VARCHAR2(10) NULL,
                            C88_ENABLE_PRISM	NUMBER(19) NULL,
                            C89_BOOK_OFFERING	VARCHAR2(255) NULL,
                            C90_INCENTIVE_GRANTED	VARCHAR2(10) NULL,
                            C91_CONTRACT_STATUS	VARCHAR2(255) NULL,
                            C92_ALLOW_EXTRA_COVERAGE_DEADL	NUMBER(19) NULL,
                            C93_PRODUCT_RELEASE_COMPLETED_	VARCHAR2(255) NULL,
                            C94_PRODUCT_RELEASE_COMPLETED_	DATE NULL,
                            C95_COVER_DETAILS_PROVIDED	DATE NULL,
                            C96_COVER_APPROVED	DATE NULL,
                            C97_SIGNING_INFO	VARCHAR2(255) NULL,
                            C98_YB_ENROLLED	NUMBER(1) NULL,
                            C99_YB_ENROLLED_DATE	TIMESTAMP(6) NULL,
                            C100_LIFETOUCH_PHOTOGRAPHED	VARCHAR2(1) NULL
                        )
                        NOLOGGING';  
      EXECUTE IMMEDIATE create_query;  
   END;  
   