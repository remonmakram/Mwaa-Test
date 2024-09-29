
DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0SAS_SUB_ALIAS_STG purge';  
      EXCEPTION  
         WHEN OTHERS THEN NULL;  
      END;  
      create_query := 'create table RAX_APP_USER.C$_0SAS_SUB_ALIAS_STG
         (
            C1_SUBJECT_ALIAS_ID	NUMBER(19) NULL,
            C2_ALIAS	VARCHAR2(50) NULL,
            C3_AUDIT_CREATE_DATE	TIMESTAMP(6) NULL,
            C4_AUDIT_CREATED_BY	VARCHAR2(255) NULL,
            C5_AUDIT_MODIFIED_BY	VARCHAR2(255) NULL,
            C6_AUDIT_MODIFY_DATE	TIMESTAMP(6) NULL,
            C7_SOURCE_SYSTEM_ID	VARCHAR2(50) NULL,
            C8_SUBJECT_ID	NUMBER(19) NULL,
            C9_SUBJECT_ALIAS_TYPE_ID	NUMBER(19) NULL
         )
	   ';
      EXECUTE IMMEDIATE create_query;  
   END;

