
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0APOCS_RECORD_CHANGE_AUDIT purge';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0APOCS_RECORD_CHANGE_AUDIT
(
	C1_TABLE_NAME	VARCHAR2(30) NULL,
	C2_KEY_VALUE	VARCHAR2(255) NULL,
	C3_EVENT_TYPE	VARCHAR2(10) NULL,
	C4_EVENT_DETAIL	VARCHAR2(2000) NULL,
	C5_DATE_CREATED	DATE NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    