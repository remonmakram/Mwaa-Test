
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_FRNG_MDL_CM_STG';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0FOW_FRNG_MDL_CM_STG
(
	C1_ID	NUMBER(19) NULL,
	C2_VERSION	NUMBER(19) NULL,
	C3_BAD_CHECK_ALLOWANCE	FLOAT(126) NULL,
	C4_GUARANTEED_MINIMUM	FLOAT(126) NULL,
	C5_PAY_ON_SHIP_TO_HOME	NUMBER(1) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    