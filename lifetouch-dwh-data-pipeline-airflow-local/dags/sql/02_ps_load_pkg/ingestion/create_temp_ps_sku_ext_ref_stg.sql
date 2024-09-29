
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0PS_SKU_EXT_REF_STG purge';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0PS_SKU_EXT_REF_STG
(
	C1_ID	NUMBER NULL,
	C2_STOCK_KEEPING_UNIT_ID	NUMBER NULL,
	C3_EXTERNAL_ID	VARCHAR2(255) NULL,
	C4_REFERENCE_TYPE	VARCHAR2(255) NULL,
	C5_AUDIT_CREATE_DATE	DATE NULL,
	C6_AUDIT_MODIFY_DATE	DATE NULL,
	C7_EXTERNAL_TYPE	VARCHAR2(255) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    