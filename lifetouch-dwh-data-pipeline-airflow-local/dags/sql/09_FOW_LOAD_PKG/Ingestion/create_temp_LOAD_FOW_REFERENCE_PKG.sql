DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_REFERENCE_STG purge';  
      EXCEPTION  
         WHEN OTHERS THEN  
            IF SQLCODE != -942 THEN  
               RAISE;  
            END IF;   
      END;  
      create_query := 'create table RAX_APP_USER.C$_0FOW_REFERENCE_STG
                        (
                            C1_ID	NUMBER(19) NULL,
                            C2_VERSION	NUMBER(19) NULL,
                            C3_CODE	VARCHAR2(255) NULL,
                            C4_CREATED_BY	VARCHAR2(255) NULL,
                            C5_DATE_CREATED	TIMESTAMP(6) NULL,
                            C6_DESCRIPTION	VARCHAR2(255) NULL,
                            C7_LAST_UPDATED	TIMESTAMP(6) NULL,
                            C8_NAME	VARCHAR2(255) NULL,
                            C9_PUBLISHABLE	NUMBER(1) NULL,
                            C10_SORT_ORDER	NUMBER(10) NULL,
                            C11_UPDATED_BY	VARCHAR2(255) NULL
                        )
                        NOLOGGING';  
      EXECUTE IMMEDIATE create_query;  
   END;  
   