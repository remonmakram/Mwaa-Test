
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_APO_ASSOCIATION_STG purge';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0FOW_APO_ASSOCIATION_STG
(
	C1_ID	NUMBER NULL,
	C2_VERSION	NUMBER NULL,
	C3_APO_ID	NUMBER NULL,
	C4_ASSOCIATED_APO_TAG	VARCHAR2(255) NULL,
	C5_CREATED_BY	VARCHAR2(255) NULL,
	C6_DATE_CREATED	DATE NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    