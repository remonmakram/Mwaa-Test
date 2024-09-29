
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0PACKAGE_ITEM';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0PACKAGE_ITEM
(
	C1_ITEM_ID	NUMBER(19) NULL,
	C2_MAX_PACKAGE_ID	NUMBER(19) NULL,
	C3_ITEM_ID	NUMBER(19) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    