
DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0SAS_SUB_EVT_INF_STG purge';  
      EXCEPTION  
         WHEN OTHERS THEN NULL;  
      END;  
      create_query := 'create table RAX_APP_USER.C$_0SAS_SUB_EVT_INF_STG
         (
            C1_SUBJECT_ID	NUMBER(19) NULL,
            C2_EVENT_IMAGE_FACT_ID	NUMBER(19) NULL,
            C3_AUDIT_CREATE_DATE	TIMESTAMP(6) NULL,
            C4_AUDIT_MODIFY_DATE	TIMESTAMP(6) NULL
         )
	   ';
      EXECUTE IMMEDIATE create_query;  
   END;

