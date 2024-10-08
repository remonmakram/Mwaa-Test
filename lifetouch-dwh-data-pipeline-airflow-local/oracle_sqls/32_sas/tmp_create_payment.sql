
DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0SAS_PAYMENT_STG purge';  
      EXCEPTION  
         WHEN OTHERS THEN NULL;  
      END;  
      create_query := 'create table RAX_APP_USER.C$_0SAS_PAYMENT_STG
         (
            C1_PAYMENT_ID	NUMBER(10) NULL,
            C2_AMOUNT	NUMBER(19,2) NULL,
            C3_AUDIT_CREATE_DATE	TIMESTAMP(6) NULL,
            C4_AUDIT_CREATED_BY	VARCHAR2(255) NULL,
            C5_AUDIT_MODIFIED_BY	VARCHAR2(255) NULL,
            C6_AUDIT_MODIFY_DATE	TIMESTAMP(6) NULL,
            C7_BML_AUTH_CODE	VARCHAR2(50) NULL,
            C8_BML_ORDER_ID	VARCHAR2(16) NULL,
            C9_BML_STATUS	VARCHAR2(20) NULL,
            C10_BML_ERROR_DESC	VARCHAR2(500) NULL,
            C11_BML_ERROR_NO	VARCHAR2(50) NULL,
            C12_BML_ERROR_STEP	VARCHAR2(20) NULL,
            C13_CUSTOMER_EMAIL_ADDRESS	VARCHAR2(255) NULL,
            C14_CUSTOMER_IP_ADDRESS	VARCHAR2(255) NULL,
            C15_BML_PROMO_CODE	VARCHAR2(20) NULL,
            C16_BML_REASON_CODE	VARCHAR2(50) NULL,
            C17_BILLING_CITY	VARCHAR2(35) NULL,
            C18_BILLING_COUNTRY	VARCHAR2(2) NULL,
            C19_BILLING_FIRSTNAME	VARCHAR2(40) NULL,
            C20_BILLING_LASTNAME	VARCHAR2(40) NULL,
            C21_BILLING_LINE1	VARCHAR2(50) NULL,
            C22_BILLING_LINE2	VARCHAR2(50) NULL,
            C23_BILLING_PHONE_NUMBER	VARCHAR2(10) NULL,
            C24_BILLING_POSTAL_CODE	VARCHAR2(35) NULL,
            C25_BILLING_STATE_PROVINCE	VARCHAR2(35) NULL,
            C26_AUTHORIZATION_CODE	VARCHAR2(10) NULL,
            C27_CARD_EXPIRY_MONTH	NUMBER(10) NULL,
            C28_CARD_EXPIRY_YEAR	NUMBER(10) NULL,
            C29_FAILURE_CODE	VARCHAR2(9) NULL,
            C30_FAILURE_REASON	VARCHAR2(100) NULL,
            C31_CARD_USER_NAME	VARCHAR2(100) NULL,
            C32_CARD_LAST_DIGITS	VARCHAR2(4) NULL,
            C33_PAYMENT_SERVICE_ID	VARCHAR2(20) NULL,
            C34_REFERENCE_TRANSACTION_ID	VARCHAR2(12) NULL,
            C35_PAYMENT_METHOD	VARCHAR2(20) NULL,
            C36_CREDIT_CARD_TYPE_ID	NUMBER(10) NULL,
            C37_PAYMENT_OPTION_ID	NUMBER(10) NULL,
            C38_CUSTOMER_ORDER_ID	NUMBER(10) NULL,
            C39_EXTERNAL_PAYMENT_ID	VARCHAR2(19) NULL,
            C40_PAYPAL_PAYER_ID	VARCHAR2(20) NULL,
            C41_PAYPAL_PAYER_EMAIL	VARCHAR2(128) NULL
         )
	   ';
      EXECUTE IMMEDIATE create_query;  
   END;

