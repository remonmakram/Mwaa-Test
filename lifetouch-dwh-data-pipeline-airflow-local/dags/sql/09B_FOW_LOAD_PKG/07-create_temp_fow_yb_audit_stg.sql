
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_YB_AUDIT_STG purge';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0FOW_YB_AUDIT_STG
(
	C1_ID	NUMBER NULL,
	C2_APO_TAG	VARCHAR2(255) NULL,
	C3_EVENT_REF_ID	VARCHAR2(255) NULL,
	C4_AUDIT_DATE_CREATED	DATE NULL,
	C5_AUDIT_CREATED_BY	VARCHAR2(255) NULL,
	C6_PUBLISHED_AUDIT_ID	NUMBER NULL,
	C7_PUBLISHED_ATTRIBUTE_NAME	VARCHAR2(255) NULL,
	C8_PUBLISHED_ATTRIBUTE_VALUE	VARCHAR2(255) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    