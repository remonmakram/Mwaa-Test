
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0PS_STOCK_KEEPING_UNIT_XR';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0PS_STOCK_KEEPING_UNIT_XR
(
	C1_STOCK_KEEPING_UNIT_ID	NUMBER(22) NULL,
	C2_SKU_CODE	VARCHAR2(255) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    