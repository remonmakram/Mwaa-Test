DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_FRNG_STG';  
      EXCEPTION  
         WHEN OTHERS THEN  
            IF SQLCODE != -942 THEN  
               RAISE;  
            END IF;   
      END;  
      create_query := 'create table RAX_APP_USER.C$_0FOW_FRNG_STG
                        (
                            C1_ID	NUMBER NULL,
                            C2_VERSION	NUMBER NULL,
                            C3_APO_ID	NUMBER NULL,
                            C4_COMPOSITE_CODE	VARCHAR2(255) NULL,
                            C5_COMPOSITE_DELIVERY_METHOD	VARCHAR2(255) NULL,
                            C6_CREATED_BY	VARCHAR2(255) NULL,
                            C7_DATE_CREATED	DATE NULL,
                            C8_DEFAULT_SERVICE_LOOK	VARCHAR2(255) NULL,
                            C9_ENVELOPE_TYPE	VARCHAR2(255) NULL,
                            C10_GROUP_CODE	VARCHAR2(255) NULL,
                            C11_GROUP_DELIVERY_METHOD	VARCHAR2(255) NULL,
                            C12_LAST_UPDATED	DATE NULL,
                            C13_MODEL_ETHNICITY	VARCHAR2(255) NULL,
                            C14_MODEL_GENDER	VARCHAR2(255) NULL,
                            C15_MODEL_GRADE	VARCHAR2(255) NULL,
                            C16_PRICE_PROGRAM_ID	VARCHAR2(255) NULL,
                            C17_STAFF_PACKAGE	NUMBER NULL,
                            C18_STYLE	VARCHAR2(255) NULL,
                            C19_UPDATED_BY	VARCHAR2(255) NULL,
                            C20_VISUAL_MERCH_ID	VARCHAR2(255) NULL,
                            C21_YEAR_BOOK_LOOK	VARCHAR2(255) NULL,
                            C22_COMMISSION_TYPE	VARCHAR2(255) NULL,
                            C23_COMMISSION_RATE	NUMBER NULL,
                            C24_NO_TOUCH_YEARBOOK_LOOK	VARCHAR2(255) NULL,
                            C25_MINIMUM_REQUIREMENTS	NUMBER NULL,
                            C26_FLYER_ID	VARCHAR2(255) NULL,
                            C27_PART_NUMBER	VARCHAR2(255) NULL,
                            C28_FLYER_SIZE	VARCHAR2(255) NULL,
                            C29_FLYER_STYLE	VARCHAR2(255) NULL,
                            C30_LAYOUT_CODE	VARCHAR2(255) NULL,
                            C31_PAYMENT_MESSAGE_TEXT	VARCHAR2(255) NULL,
                            C32_CREDIT_CARD_ALLOWED	NUMBER NULL,
                            C33_CHECK_PAYABLE_TO	VARCHAR2(255) NULL,
                            C34_SMALL_NOTICE_TEXT	VARCHAR2(255) NULL,
                            C35_ADDITIONAL_INFO_TEXT	VARCHAR2(255) NULL,
                            C36_ADDITIONAL_INFO_PROOF_TEXT	VARCHAR2(255) NULL,
                            C37_FAMILY_PLAN_VERBIAGE	VARCHAR2(255) NULL,
                            C38_PAYMENT_DUE_TIMING_TEXT	VARCHAR2(255) NULL,
                            C39_SPANISH_CAPTION_CODE1	VARCHAR2(255) NULL,
                            C40_SPANISH_CAPTION_CODE2	VARCHAR2(255) NULL,
                            C41_SPANISH_CAPTION_CODE3	VARCHAR2(255) NULL,
                            C42_INSERT_NO	VARCHAR2(255) NULL,
                            C43_INSERT_TYPE	VARCHAR2(255) NULL,
                            C44_MASCOT	VARCHAR2(255) NULL,
                            C45_PAYMENT_METHOD	VARCHAR2(255) NULL,
                            C46_POST_PIC_DAY_CUST_INQ_PHON	VARCHAR2(255) NULL,
                            C47_POST_PIC_DAY_CUST_INQ_PHON	VARCHAR2(255) NULL,
                            C48_PRE_PIC_DAY_CUST_INQ_PHONE	VARCHAR2(255) NULL,
                            C49_PRE_PIC_DAY_CUST_INQ_PHONE	VARCHAR2(255) NULL,
                            C50_THEME	VARCHAR2(255) NULL,
                            C51_OFFERING_TEMPLATE_ID	NUMBER NULL,
                            C52_CASUAL_CODE	VARCHAR2(255) NULL,
                            C53_CUSTOMER_SERVICE_EMAIL	VARCHAR2(255) NULL,
                            C54_CUSTOMER_SERVICE_HOURS	VARCHAR2(255) NULL
                        )
                        NOLOGGING';  
      EXECUTE IMMEDIATE create_query;  
   END;  
