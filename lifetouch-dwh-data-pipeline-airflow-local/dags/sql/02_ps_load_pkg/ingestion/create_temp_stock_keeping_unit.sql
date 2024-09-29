
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STOCK_KEEPING_UNIT';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0STOCK_KEEPING_UNIT
(
	C1_TAX_PRODUCT_CODE	VARCHAR2(32) NULL,
	C2_UPGRADE_TYPE	VARCHAR2(20) NULL,
	C3_SKU_CODE	VARCHAR2(255) NULL,
	C4_NAME	VARCHAR2(255) NULL,
	C5_LOOK_COUNT	NUMBER(22) NULL,
	C6_DESCRIPTION	VARCHAR2(255) NULL,
	C7_PERSONALIZABLE	NUMBER(22) NULL,
	C8_PRODUCT_LINE	VARCHAR2(255) NULL,
	C9_DISPLAY_GROUP	VARCHAR2(20) NULL,
	C10_CATEGORY	VARCHAR2(7) NULL,
	C11_IMAGE_COUNT	NUMBER(22) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    