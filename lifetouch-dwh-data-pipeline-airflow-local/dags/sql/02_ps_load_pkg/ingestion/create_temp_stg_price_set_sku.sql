
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STG_PRICE_SET_SKU';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0STG_PRICE_SET_SKU
(
	C1_CHANNEL	VARCHAR2(20) NULL,
	C2_AMOUNT	NUMBER(10,2) NULL,
	C3_PRICE_SET_ID	NUMBER(19) NULL,
	C4_PRODUCT_CODE	VARCHAR2(10) NULL,
	C5_PRICE_SET_SKU_ID	NUMBER(19) NULL,
	C6_STOCK_KEEPING_UNIT_ID	NUMBER(19) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    