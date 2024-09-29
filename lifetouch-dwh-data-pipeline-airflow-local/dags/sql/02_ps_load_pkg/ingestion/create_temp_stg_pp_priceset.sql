
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STG_PP_PRICESET';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0STG_PP_PRICESET
(
	C1_PRICE_PROGRAM_ID	NUMBER(19) NULL,
	C2_PRICE_SET_ID	NUMBER(19) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    