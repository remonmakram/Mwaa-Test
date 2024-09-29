
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0APOCS_OLS_DEFAULT_STG purge';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0APOCS_OLS_DEFAULT_STG
(
	C1_OLS_DEFAULT_ID	NUMBER NULL,
	C2_ORDER_TYPE	VARCHAR2(255) NULL,
	C3_SKU_ID	NUMBER NULL,
	C4_APO_ID	NUMBER NULL,
	C5_AUDIT_CREATE_DATE	DATE NULL,
	C6_AUDIT_CREATED_BY	VARCHAR2(255) NULL,
	C7_AUDIT_MODIFIED_BY	VARCHAR2(255) NULL,
	C8_AUDIT_MODIFY_DATE	DATE NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    