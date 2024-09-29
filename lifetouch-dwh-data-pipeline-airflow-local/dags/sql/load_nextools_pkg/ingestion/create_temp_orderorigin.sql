
            DECLARE create_query CLOB;  
            BEGIN  
                BEGIN  
                    EXECUTE IMMEDIATE 'DROP TABLE rax_app_user.c$_0nxtl_orderorigin';  
                EXCEPTION  
                    WHEN OTHERS THEN NULL;  
                END;  
                create_query := 'create table RAX_APP_USER.C$_0NXTL_ORDERORIGIN
(
	C1_ID	NUMBER NULL,
	C2_DESCRIPTION	VARCHAR2(50) NULL
)
NOLOGGING';
                EXECUTE IMMEDIATE create_query;
            END;  
            