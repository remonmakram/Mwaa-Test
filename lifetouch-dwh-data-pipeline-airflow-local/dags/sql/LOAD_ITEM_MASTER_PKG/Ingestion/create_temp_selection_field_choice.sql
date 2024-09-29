DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0IM_SELECTION_FIELD_CHOICE_ purge';  
      EXCEPTION  
         WHEN OTHERS THEN  
            IF SQLCODE != -942 THEN  
               RAISE;  
            END IF;   
      END;  
      create_query := 'create table RAX_APP_USER.C$_0IM_SELECTION_FIELD_CHOICE_ ( C1_ID	NUMBER NULL, C2_CHOICE_ID	VARCHAR2(255) NULL, C3_LABEL	VARCHAR2(255) NULL, C4_SELECTION_FIELD_ID	NUMBER NULL ) NOLOGGING';  
      EXECUTE IMMEDIATE create_query;  
   END;  
   