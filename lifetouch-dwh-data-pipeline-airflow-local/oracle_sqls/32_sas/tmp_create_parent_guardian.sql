DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0SAS_PAR_GUAR_STG purge';  
      EXCEPTION  
         WHEN OTHERS THEN NULL;  
      END;  
      create_query := 'create table RAX_APP_USER.C$_0SAS_PAR_GUAR_STG
         (
            C1_PARENT_GUARDIAN_ID	NUMBER(19) NULL,
            C2_ADDRESS_LINE_1	VARCHAR2(50) NULL,
            C3_ADDRESS_LINE_2	VARCHAR2(50) NULL,
            C4_AUDIT_CREATE_DATE	TIMESTAMP(6) NULL,
            C5_AUDIT_CREATED_BY	VARCHAR2(255) NULL,
            C6_AUDIT_MODIFIED_BY	VARCHAR2(255) NULL,
            C7_AUDIT_MODIFY_DATE	TIMESTAMP(6) NULL,
            C8_CITY	VARCHAR2(30) NULL,
            C9_COUNTRY	VARCHAR2(2) NULL,
            C10_COURTESY_TITLE	VARCHAR2(50) NULL,
            C11_DAYTIME_PHONE	VARCHAR2(20) NULL,
            C12_EMAIL_ADDRESS	VARCHAR2(320) NULL,
            C13_EMERGENCY_CONTACT	NUMBER(1) NULL,
            C14_FIRST_NAME	VARCHAR2(50) NULL,
            C15_LAST_NAME	VARCHAR2(50) NULL,
            C16_MIDDLE_NAME	VARCHAR2(50) NULL,
            C17_EVENING_PHONE	VARCHAR2(20) NULL,
            C18_POSTAL_CODE	VARCHAR2(10) NULL,
            C19_RELATIONSHIP	VARCHAR2(50) NULL,
            C20_STATE	VARCHAR2(10) NULL,
            C21_SUBJECT_ID	NUMBER(19) NULL
         )
	   ';
      EXECUTE IMMEDIATE create_query;  
   END;

