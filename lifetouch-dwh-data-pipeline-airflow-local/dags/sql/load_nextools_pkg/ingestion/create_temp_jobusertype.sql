
            DECLARE create_query CLOB;  
            BEGIN  
                BEGIN  
                    EXECUTE IMMEDIATE 'DROP TABLE rax_app_user.c$_0nxtl_jobusertype';  
                EXCEPTION  
                    WHEN OTHERS THEN NULL;  
                END;  
                create_query := 'create table RAX_APP_USER.C$_0NXTL_JOBUSERTYPE
(
	C1_JOBUSERTYPEID	NUMBER NULL,
	C2_DESCRIPTION	VARCHAR2(500) NULL,
	C3_ROLERANK	NUMBER NULL,
	C4_ROLECODE	VARCHAR2(100) NULL
)
NOLOGGING';
                EXECUTE IMMEDIATE create_query;
            END;  
            