
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_CT_SBJ_BATCH_STG purge';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0FOW_CT_SBJ_BATCH_STG
(
	C1_ID	NUMBER(19) NULL,
	C2_SUBJECT_ID	NUMBER(19) NULL,
	C3_BATCH_ID	NUMBER(19) NULL,
	C4_RETURNED_MATERIAL_TYPE	VARCHAR2(255) NULL,
	C5_BARCODE	VARCHAR2(255) NULL,
	C6_LAST_UPDATED	DATE NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    