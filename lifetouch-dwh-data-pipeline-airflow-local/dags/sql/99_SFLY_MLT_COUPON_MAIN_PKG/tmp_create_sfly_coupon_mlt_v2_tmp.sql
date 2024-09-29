

DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table rax_app_user.sfly_coupon_mlt_v2_tmp';  
      EXCEPTION  
         WHEN OTHERS THEN NULL;  
      END;  
      create_query := 'create table sfly_coupon_mlt_v2_tmp
(
  JOB_NUMBER          VARCHAR2(10 BYTE),
  SUBJECT_FIRST_NAME  VARCHAR2(50 CHAR),
  CUST_EMAIL_ADDRESS  VARCHAR2(255 CHAR),
  AUDIT_CREATE_DATE  DATE,
  PAYMENT_VOUCHER_ID  NUMBER(19),
 ORDER_TYPE VARCHAR2(10)
)';  
      EXECUTE IMMEDIATE create_query;  
   END;  