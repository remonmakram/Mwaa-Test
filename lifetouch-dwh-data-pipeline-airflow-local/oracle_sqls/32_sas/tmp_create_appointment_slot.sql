DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0SAS_APPT_SLOT_STG purge';  
      EXCEPTION  
         WHEN OTHERS THEN NULL;  
      END;  
      create_query := 'create table RAX_APP_USER.C$_0SAS_APPT_SLOT_STG
         (
            C1_APPOINTMENT_SLOT_ID	NUMBER NULL,
            C2_PICTURE_DAY_ID	NUMBER NULL,
            C3_APPOINTMENT_TIME	TIMESTAMP(6) NULL,
            C4_SLOT_TYPE	VARCHAR2(1) NULL,
            C5_AUDIT_CREATE_DATE	TIMESTAMP(6) NULL,
            C6_AUDIT_CREATED_BY	VARCHAR2(255) NULL,
            C7_AUDIT_MODIFY_DATE	TIMESTAMP(6) NULL,
            C8_AUDIT_MODIFIED_BY	VARCHAR2(255) NULL
         )
	   ';
      EXECUTE IMMEDIATE create_query;  
   END;

