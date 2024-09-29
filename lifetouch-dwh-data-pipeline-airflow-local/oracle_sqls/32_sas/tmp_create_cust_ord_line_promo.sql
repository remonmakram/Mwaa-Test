DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0SAS_COL_PROMO_STG purge';  
      EXCEPTION  
         WHEN OTHERS THEN NULL;  
      END;  
      create_query := 'create table RAX_APP_USER.C$_0SAS_COL_PROMO_STG
         (
            C1_CUSTOMER_ORDER_LINE_ID	NUMBER(10) NULL,
            C2_PROMOTION_CODE	VARCHAR2(4) NULL,
            C3_DISCOUNT_AMOUNT	NUMBER(19,2) NULL,
            C4_CUSTOMER_ORDER_LINE_PROMO_I	NUMBER(19) NULL,
            C5_ITEM_NUMBER	VARCHAR2(16) NULL,
            C6_DELETED_IND	VARCHAR2(1) NULL,
            C7_AUDIT_CREATE_DATE	TIMESTAMP(6) NULL,
            C8_AUDIT_MODIFY_DATE	TIMESTAMP(6) NULL
         )
	   ';
      EXECUTE IMMEDIATE create_query;  
   END;

