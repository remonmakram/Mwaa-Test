DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.C$_0CHILD_ORD_INFO_STG';  
      EXCEPTION  
         WHEN OTHERS THEN NULL;  
      END;  
      create_query := 'create table RAX_APP_USER.C$_0CHILD_ORD_INFO_STG
               (
                  C1_CHILD_ORDER_INFO_KEY	CHAR(24) NULL,
                  C2_PARENT_ORDER_HEADER_KEY	CHAR(24) NULL,
                  C3_PARENT_ORDER_LINE_KEY	CHAR(24) NULL,
                  C4_STATUS	VARCHAR2(40) NULL,
                  C5_MULTIPLICITY	VARCHAR2(40) NULL,
                  C6_ROLE_INFO	VARCHAR2(40) NULL,
                  C7_GROUP_INFO	VARCHAR2(40) NULL,
                  C8_TOTAL_CHILD_ORDERS	NUMBER(5) NULL,
                  C9_SUBJECT_COUNT	NUMBER(5) NULL,
                  C10_ITEM_ID	VARCHAR2(40) NULL,
                  C11_AVAILABLE_DATE	DATE NULL,
                  C12_CREATETS	DATE NULL,
                  C13_MODIFYTS	DATE NULL,
                  C14_CREATEUSERID	VARCHAR2(40) NULL,
                  C15_MODIFYUSERID	VARCHAR2(40) NULL,
                  C16_CREATEPROGID	VARCHAR2(40) NULL,
                  C17_MODIFYPROGID	VARCHAR2(40) NULL,
                  C18_LOCKID	NUMBER(5) NULL
               )';  
      EXECUTE IMMEDIATE create_query;  
   END;  


