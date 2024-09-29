
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table rax_app_user.APOCS_LOOK_STG';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'CREATE TABLE rax_app_user.APOCS_LOOK_STG
(
 LOOK_ID                    NUMBER
,AUDIT_CREATE_DATE          date
,AUDIT_CREATED_BY           VARCHAR2(255 CHAR)
,AUDIT_MODIFIED_BY          VARCHAR2(255 CHAR)
,AUDIT_MODIFY_DATE          date
,BUSINESS_KEY               VARCHAR2(255 CHAR)
,LOCKID                     VARCHAR2(255 CHAR)
,LOOK_DESC                  VARCHAR2(255 CHAR)
,LOOK_NO                    VARCHAR2(255 CHAR)
,LOOK_PREF_SEQ              VARCHAR2(255 CHAR)
,LAYOUT_GROUP_ID            NUMBER
)';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    