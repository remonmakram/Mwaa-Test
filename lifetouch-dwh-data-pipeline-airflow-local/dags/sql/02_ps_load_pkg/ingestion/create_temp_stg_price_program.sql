
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STG_PRICE_PROGRAM';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0STG_PRICE_PROGRAM
(
	C1_PRICE_PROGRAM_ID	NUMBER(19) NULL,
	C2_AUDIT_CREATE_DATE	TIMESTAMP(6) NULL,
	C3_AUDIT_MODIFY_DATE	TIMESTAMP(6) NULL,
	C4_DESCRIPTION	VARCHAR2(500) NULL,
	C5_NAME	VARCHAR2(255) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    