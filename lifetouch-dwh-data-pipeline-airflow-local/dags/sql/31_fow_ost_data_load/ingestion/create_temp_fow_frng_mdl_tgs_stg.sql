
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_FRNG_MDL_TGS_STG';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0FOW_FRNG_MDL_TGS_STG
(
	C1_OFFERING_MODEL_ID	NUMBER(19) NULL,
	C2_TAGS_INTEGER	NUMBER(10) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    