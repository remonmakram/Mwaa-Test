DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table rax_app_user.layout_theme';  
      EXCEPTION  
         WHEN OTHERS THEN NULL;  
      END;  
      create_query := 'CREATE TABLE rax_app_user.layout_theme
(
LAYOUT_THEME_ID NUMBER,
AUDIT_CREATE_DATE DATE,
AUDIT_CREATED_BY VARCHAR2(255),
AUDIT_MODIFIED_BY VARCHAR2(255),
AUDIT_MODIFY_DATE DATE,
EXTERNAL_KEY NUMBER,
NAME VARCHAR2(255)
)';  
      EXECUTE IMMEDIATE create_query;  
   END;  