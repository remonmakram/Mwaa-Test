
DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0SAS_SUB_RELATN_STG purge';  
      EXCEPTION  
         WHEN OTHERS THEN NULL;  
      END;  
      create_query := 'create table RAX_APP_USER.C$_0SAS_SUB_RELATN_STG
         (
            C1_RELATIONSHIP_ID	NUMBER NULL,
            C2_RELATIONSHIP	VARCHAR2(255) NULL
         )
	   ';
      EXECUTE IMMEDIATE create_query;  
   END;

