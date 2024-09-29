DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.C$_0BOC_DRAFT_ORD_STG';  
      EXCEPTION  
         WHEN OTHERS THEN NULL;  
      END;  
      create_query := 'create table RAX_APP_USER.C$_0BOC_DRAFT_ORD_STG ( C1_DRAFT_ORDER_ID	NUMBER(19) NULL, C2_CREATEDATE	TIMESTAMP(6) NULL, C3_CREATEDBY	VARCHAR2(255) NULL, C4_MODIFIEDBY	VARCHAR2(255) NULL, C5_MODIFYDATE	TIMESTAMP(6) NULL, C6_EMAIL_ADDRESS	VARCHAR2(255) NULL, C7_EVENT_REF_ID	VARCHAR2(255) NULL, C8_MATCH_TYPE	VARCHAR2(255) NULL, C9_ORDER_FORM_ID	VARCHAR2(255) NULL, C10_ORDER_TYPE	VARCHAR2(255) NULL, C11_PARENT_FIRST_NAME	VARCHAR2(255) NULL, C12_PARENT_LAST_NAME	VARCHAR2(255) NULL, C13_PARENT_PHONE_NUMBER	VARCHAR2(255) NULL, C14_REQUIRES_ATTENTION	NUMBER(1) NULL, C15_SESSION_ID	VARCHAR2(255) NULL, C16_SHIPPING_AMOUNT	VARCHAR2(255) NULL, C17_SOURCE_SYSTEM_ID	VARCHAR2(255) NULL, C18_STATUS	VARCHAR2(255) NULL, C19_SUBJECT_ALPHA_NUMBER	VARCHAR2(255) NULL, C20_SUBJECT_FIRST_NAME	VARCHAR2(255) NULL, C21_SUBJECT_GRADE	VARCHAR2(255) NULL, C22_SUBJECT_LAST_NAME	VARCHAR2(255) NULL, C23_UNPAID	NUMBER(1) NULL, C24_BILL_TO_ADDRESS	NUMBER(19) NULL, C25_SHIP_TO_ADDRESS	NUMBER(19) NULL, C26_SM_SUBJECT_FIRST_NAME	VARCHAR2(255) NULL, C27_SM_SUBJECT_LAST_NAME	VARCHAR2(255) NULL, C28_EXCEPTION_REASON	VARCHAR2(255) NULL, C29_ORDER_BATCH_ID	NUMBER(19) NULL, C30_EVENT_ID	NUMBER(19) NULL, C31_MATCHED_EVENT_ID	NUMBER(19) NULL, C32_ORIG_DRAFT_ORDER_ID	NUMBER(19) NULL, C33_PRICING_CONTEXT	VARCHAR2(25) NULL, C34_GENERATED	NUMBER(1) NULL, C35_ORIG_RETAKE_NUMBER	VARCHAR2(20) NULL, C36_PROCESSED_AMOUNT	VARCHAR2(20) NULL, C37_EXTERNAL_ORDER_NUMBER	VARCHAR2(100) NULL, C38_MATCHING_REQUIRED	NUMBER(1) NULL, C39_BATCHING_REQUIRED	NUMBER(1) NULL, C40_ORDER_PROCESSING_TYPE	VARCHAR2(50) NULL )';  
      EXECUTE IMMEDIATE create_query;
   END;  