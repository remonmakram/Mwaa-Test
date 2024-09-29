
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_APO_MERCH_TAGS';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0FOW_APO_MERCH_TAGS
(
	C1_APO_ID	NUMBER(19) NULL,
	C2_TAG_ID	NUMBER(19) NULL,
	C3_ID	NUMBER(19) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    