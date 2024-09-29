
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STG_APOCS_EVENT';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0STG_APOCS_EVENT
(
	C1_BUSINESS_KEY	VARCHAR2(255) NULL,
	C2_AUDIT_MODIFY_DATE	TIMESTAMP(6) NULL,
	C3_AUDIT_MODIFIED_BY	VARCHAR2(255) NULL,
	C4_MAPPED_KEY	VARCHAR2(255) NULL,
	C5_EVENT_ID	VARCHAR2(255) NULL,
	C6_APO_ID	VARCHAR2(255) NULL,
	C7_AUDIT_CREATE_DATE	TIMESTAMP(6) NULL,
	C8_AUDIT_CREATED_BY	VARCHAR2(255) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    