
            DECLARE create_query CLOB;  
            BEGIN  
                BEGIN  
                    EXECUTE IMMEDIATE 'DROP TABLE rax_app_user.c$_0nxtl_jobgrade';  
                EXCEPTION  
                    WHEN OTHERS THEN NULL;  
                END;  
                create_query := 'create table RAX_APP_USER.C$_0NXTL_JOBGRADE
(
	C1_JOBGRADEID	NUMBER NULL,
	C2_JOBID	NUMBER NULL,
	C3_GRADEID	NUMBER NULL
)
NOLOGGING';
                EXECUTE IMMEDIATE create_query;
            END;  
            