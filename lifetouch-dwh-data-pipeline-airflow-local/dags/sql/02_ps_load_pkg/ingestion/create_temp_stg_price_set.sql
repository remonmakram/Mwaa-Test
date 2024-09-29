
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STG_PRICE_SET purge';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0STG_PRICE_SET
(
	C1_DESCRIPTION	VARCHAR2(255) NULL,
	C2_TAX_INCLUSIVE	NUMBER(1) NULL,
	C3_NAME	VARCHAR2(255) NULL,
	C4_AUDIT_CREATE_DATE	TIMESTAMP(6) NULL,
	C5_PRICE_SET_ID	NUMBER(19) NULL,
	C6_AUDIT_MODIFY_DATE	TIMESTAMP(6) NULL,
	C7_CURRENCY	VARCHAR2(3) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    