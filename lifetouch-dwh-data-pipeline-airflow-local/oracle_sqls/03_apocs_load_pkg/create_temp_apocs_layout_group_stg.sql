
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table rax_app_user.APOCS_LAYOUT_GROUP_STG';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'CREATE TABLE rax_app_user.APOCS_LAYOUT_GROUP_STG
(
  LAYOUT_GROUP_ID                     NUMBER
,AUDIT_CREATE_DATE                   date
,AUDIT_CREATED_BY                    VARCHAR2(255 CHAR)
,AUDIT_MODIFIED_BY                   VARCHAR2(255 CHAR)
,AUDIT_MODIFY_DATE                   date
,BUSINESS_KEY                        VARCHAR2(255 CHAR)
,LAYOUTGROUPPREPICDAYSEQNO           VARCHAR2(255 CHAR)
,LAYOUTID                            VARCHAR2(255 CHAR)
,LOCKID                              NUMBER
,PARENT_LAYOUTID                     VARCHAR2(255 CHAR)
,TYPE                                VARCHAR2(255 CHAR)
,VM_ID                               NUMBER
,LAYOUTGROUPPOSTPICDAYSEQNO          VARCHAR2(255 CHAR)
,PRERENDERING_CACHE_DAYS             NUMBER
)';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    