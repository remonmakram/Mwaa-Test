
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FW_FRNG_MDL_SM_CM_STG';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0FW_FRNG_MDL_SM_CM_STG
(
	C1_ID	NUMBER(19) NULL,
	C2_BASIS	VARCHAR2(255) NULL,
	C3_VALUATION_TYPE	VARCHAR2(255) NULL,
	C4_VALUE	FLOAT(126) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    