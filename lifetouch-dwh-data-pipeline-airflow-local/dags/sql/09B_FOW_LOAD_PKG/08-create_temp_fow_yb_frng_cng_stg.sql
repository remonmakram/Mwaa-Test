
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_YB_FRNG_CNG_STG';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0FOW_YB_FRNG_CNG_STG
(
	C1_ID	NUMBER NULL,
	C2_OFFERING_ID	NUMBER NULL,
	C3_CONFIG_NAME	VARCHAR2(255) NULL,
	C4_CONFIG_VALUE	VARCHAR2(255) NULL,
	C5_DATE_CREATED	TIMESTAMP(6) NULL,
	C6_CREATED_BY	VARCHAR2(255) NULL,
	C7_TYPE	CHAR(50) NULL,
	C8_LAST_UPDATED	DATE NULL,
	C9_UPDATED_BY	VARCHAR2(255) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    