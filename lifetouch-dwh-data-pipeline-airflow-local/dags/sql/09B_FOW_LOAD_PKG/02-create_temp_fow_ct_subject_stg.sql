
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_CT_SUBJECT_STG purge';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0FOW_CT_SUBJECT_STG
(
	C1_ID	NUMBER(19) NULL,
	C2_SUBJECT_OID	NUMBER(19) NULL,
	C3_ALTERNATE_NAMES	VARCHAR2(255) NULL,
	C4_DATE_CREATED	DATE NULL,
	C5_CREATED_BY	VARCHAR2(255) NULL,
	C6_UPDATED_BY	VARCHAR2(255) NULL,
	C7_LAST_UPDATED	DATE NULL,
	C8_APO_ID	VARCHAR2(30) NULL,
	C9_EVENT_REF_ID	VARCHAR2(40) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    