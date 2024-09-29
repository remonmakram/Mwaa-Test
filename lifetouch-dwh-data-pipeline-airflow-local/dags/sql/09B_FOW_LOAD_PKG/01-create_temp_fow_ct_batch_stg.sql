
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_CT_BATCH_STG purge';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0FOW_CT_BATCH_STG
(
	C1_ID	NUMBER(19) NULL,
	C2_BATCH_NAME	VARCHAR2(255) NULL,
	C3_DATE_CREATED	DATE NULL,
	C4_CREATED_BY	VARCHAR2(255) NULL,
	C5_UPDATED_BY	VARCHAR2(255) NULL,
	C6_LAST_UPDATED	DATE NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    