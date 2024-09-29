DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_TASK_STG purge';  
      EXCEPTION  
         WHEN OTHERS THEN  
            IF SQLCODE != -942 THEN  
               RAISE;  
            END IF;   
      END;  
      create_query := 'create table RAX_APP_USER.C$_0FOW_TASK_STG
                        (
                            C1_ID	NUMBER(19) NULL,
                            C2_VERSION	NUMBER(19) NULL,
                            C3_ASSIGNED_TO	VARCHAR2(255) NULL,
                            C4_CREATED_BY	VARCHAR2(255) NULL,
                            C5_DATE_CREATED	TIMESTAMP(6) NULL,
                            C6_DESCRIPTION	VARCHAR2(255) NULL,
                            C7_DUE_DATE	TIMESTAMP(6) NULL,
                            C8_DUE_DATE_OFFSET	NUMBER(10) NULL,
                            C9_LAST_UPDATED	TIMESTAMP(6) NULL,
                            C10_LID	NUMBER(19) NULL,
                            C11_NOTE	VARCHAR2(1024) NULL,
                            C12_PARENT_ID	NUMBER(19) NULL,
                            C13_REFERENCE_ID	NUMBER(19) NULL,
                            C14_STATUS	VARCHAR2(255) NULL,
                            C15_TASK_GROUP	VARCHAR2(255) NULL,
                            C16_TASK_LEVEL	VARCHAR2(255) NULL,
                            C17_TASK_TYPE	VARCHAR2(255) NULL,
                            C18_UPDATED_BY	VARCHAR2(255) NULL,
                            C19_TERRITORY_CODE	VARCHAR2(2) NULL,
                            C20_TASK_CATEGORY	VARCHAR2(255) NULL,
                            C21_LAST_TASK	NUMBER(1) NULL,
                            C22_TARGET_TAB	VARCHAR2(255) NULL,
                            C23_TASK_TEMPLATE_ID	NUMBER(19) NULL
                        )
                        NOLOGGING';  
      EXECUTE IMMEDIATE create_query;  
   END;  
   