DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_RCRD_CHG_AUD purge';  
      EXCEPTION  
         WHEN OTHERS THEN  
            IF SQLCODE != -942 THEN  
               RAISE;  
            END IF;   
      END;  
      create_query := 'create table RAX_APP_USER.C$_0FOW_RCRD_CHG_AUD
                        (
                            C1_TABLE_NAME	VARCHAR2(30) NULL,
                            C2_KEY_VALUE	VARCHAR2(255) NULL,
                            C3_EVENT_TYPE	VARCHAR2(10) NULL,
                            C4_EVENT_DETAIL	VARCHAR2(2000) NULL,
                            C5_DATE_CREATED	TIMESTAMP(6) NULL,
                            C6_KEY_VALUE2	VARCHAR2(255) NULL
                        )
                        NOLOGGING';  
      EXECUTE IMMEDIATE create_query;  
   END;  
   