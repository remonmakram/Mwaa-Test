
DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0SAS_SUBSCR_TYP_STG purge';  
      EXCEPTION  
         WHEN OTHERS THEN NULL;  
      END;  
      create_query := 'create table RAX_APP_USER.C$_0SAS_SUBSCR_TYP_STG
         (
            C1_SUBSCRIPTION_TYPE_ID	NUMBER NULL,
            C2_SUBSCRIPTION_TYPE	VARCHAR2(15) NULL
         )
	   ';
      EXECUTE IMMEDIATE create_query;  
   END;

