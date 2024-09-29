
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table rax_app_user.look_layout_theme_assoc';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'CREATE TABLE rax_app_user.LOOK_LAYOUT_THEME_ASSOC
(
LOOK_LAYOUT_THEME_ASSOC_ID NUMBER
,AUDIT_CREATE_DATE date
,AUDIT_CREATED_BY VARCHAR2(255)
,AUDIT_MODIFIED_BY VARCHAR2(255)
,AUDIT_MODIFY_DATE date
,BUSINESS_KEY   VARCHAR2(255)
,LOCKID NUMBER
,LOOK_LAYOUT_THEMEID VARCHAR2(255)
,LOOK_NO VARCHAR2(255)
,VM_ID  NUMBER
,IS_DEFAULT VARCHAR2(255)
)';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    