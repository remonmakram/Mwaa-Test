
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_YB_PRICING_STG purge';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0FOW_YB_PRICING_STG
(
	C1_ID	NUMBER NULL,
	C2_OFFERING_ID	NUMBER NULL,
	C3_PRICE_SET_NAME	VARCHAR2(255) NULL,
	C4_ITEM_ID	NUMBER NULL,
	C5_SCHOOL_PRICE	NUMBER NULL,
	C6_CONSUMER_PRICE	NUMBER NULL,
	C7_CHANNEL	VARCHAR2(255) NULL,
	C8_DATE_CREATED	TIMESTAMP(6) NULL,
	C9_CREATED_BY	VARCHAR2(1020) NULL,
	C10_NO_SHOW_INVOICE	NUMBER NULL,
	C11_QUANTITY	NUMBER NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    