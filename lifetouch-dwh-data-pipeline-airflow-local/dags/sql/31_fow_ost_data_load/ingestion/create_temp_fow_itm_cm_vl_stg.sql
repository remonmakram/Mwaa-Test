
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_ITM_CM_VL_STG';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0FOW_ITM_CM_VL_STG
(
	C1_ID	NUMBER(19) NULL,
	C2_VERSION	NUMBER(19) NULL,
	C3_PACKAGE_COMMISSION_MODEL_ID	NUMBER(19) NULL,
	C4_SKU_CODE	VARCHAR2(255) NULL,
	C5_VALUATION_TYPE	VARCHAR2(255) NULL,
	C6_VALUE	FLOAT(126) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    