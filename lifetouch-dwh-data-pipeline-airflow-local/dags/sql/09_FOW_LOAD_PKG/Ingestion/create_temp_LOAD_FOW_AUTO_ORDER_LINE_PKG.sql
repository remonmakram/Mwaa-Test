DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_AUTO_ORDER_LINE_STG purge';  
      EXCEPTION  
         WHEN OTHERS THEN  
            IF SQLCODE != -942 THEN  
               RAISE;  
            END IF;   
      END;  
      create_query := 'create table RAX_APP_USER.C$_0FOW_AUTO_ORDER_LINE_STG
                        (
                            C1_ID	NUMBER(19) NULL,
                            C2_VERSION	NUMBER(19) NULL,
                            C3_ADDED_ON_EVENT	VARCHAR2(255) NULL,
                            C4_AUTO_ADD_KEY	VARCHAR2(255) NULL,
                            C5_CREATED_BY	VARCHAR2(255) NULL,
                            C6_DATE_CREATED	DATE NULL,
                            C7_DISCOUNT_PCT	FLOAT(126) NULL,
                            C8_ENABLED	NUMBER(1) NULL,
                            C9_ITEM_DESC	VARCHAR2(255) NULL,
                            C10_ITEM_ID	VARCHAR2(255) NULL,
                            C11_LAST_UPDATED	DATE NULL,
                            C12_LOOK_NO	VARCHAR2(255) NULL,
                            C13_OFFERING_ID	NUMBER(19) NULL,
                            C14_ORDER_TYPE	VARCHAR2(255) NULL,
                            C15_QUANTITY	NUMBER(10) NULL,
                            C16_UPDATED_BY	VARCHAR2(255) NULL
                        )
                        NOLOGGING';  
      EXECUTE IMMEDIATE create_query;  
   END;  
   