DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0OMS3_KIT_ITEM_STG';  
      EXCEPTION  
         WHEN OTHERS THEN  
            IF SQLCODE != -942 THEN  
               RAISE;  
            END IF;   
      END;  
      create_query := 'create table RAX_APP_USER.C$_0OMS3_KIT_ITEM_STG
                        (
                            C1_KIT_ITEM_KEY	VARCHAR2(24) NULL
                        )
                        NOLOGGING';  
      EXECUTE IMMEDIATE create_query;  
   END; 
