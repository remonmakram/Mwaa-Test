
DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0SAS_SUB_ALI_TYP_STG purge';  
      EXCEPTION  
         WHEN OTHERS THEN NULL;  
      END;  
      create_query := 'create table RAX_APP_USER.C$_0SAS_SUB_ALI_TYP_STG
         (
            C1_SUBJECT_ALIAS_TYPE_ID	NUMBER(19) NULL,
            C2_ALIAS_TYPE	VARCHAR2(50) NULL,
            C3_DESCRIPTION	VARCHAR2(50) NULL,
            C4_SYSTEM_MANAGED	NUMBER(1) NULL
         )
	   ';
      EXECUTE IMMEDIATE create_query;  
   END;

