
            DECLARE create_query CLOB;  
            BEGIN  
                BEGIN  
                    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.c$_0ybpy_jobinfo';  
                EXCEPTION  
                    WHEN OTHERS THEN NULL;  
                END;  
                create_query := 'create table RAX_APP_USER.C$_0YBPY_JOBINFO
(
	C1_ORDERID	NUMBER NULL,
	C2_CREATEDATE	DATE NULL,
	C3_LASTCHANGEDATE	DATE NULL
)
NOLOGGING';
                EXECUTE IMMEDIATE create_query;
            END;  
            