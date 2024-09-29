
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table rax_app_user.APOCS_AUTO_ADD_STG';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'CREATE TABLE rax_app_user.APOCS_AUTO_ADD_STG
(
AUTO_ADD_ID                NUMBER
,AUDIT_CREATE_DATE          date
,AUDIT_CREATED_BY           VARCHAR2(255 CHAR)
,AUDIT_MODIFIED_BY          VARCHAR2(255 CHAR)
,AUDIT_MODIFY_DATE          date
,BUSINESS_KEY               VARCHAR2(255 CHAR)
,ADD_TO_ORDER_TYPE          VARCHAR2(255 CHAR)
,ADDED_ON_EVENT             VARCHAR2(255 CHAR)
,DISCOUNT_PERCENT           VARCHAR2(255 CHAR)
,ITEM_DESC                  VARCHAR2(255 CHAR)
,ITEMID                     VARCHAR2(255 CHAR)
,LOCKID                     NUMBER
,LOOK_NO                    VARCHAR2(255 CHAR)
,VM_ID                      NUMBER
,ENABLE                     VARCHAR2(255)
,QUANTITY                   NUMBER
,APO_OVERRIDE_KEY           NUMBER
,FULFILLMENT_TYPE           VARCHAR2(255)
)';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    