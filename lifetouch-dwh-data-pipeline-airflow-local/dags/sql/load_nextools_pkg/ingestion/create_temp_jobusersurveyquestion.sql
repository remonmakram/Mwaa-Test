
            DECLARE create_query CLOB;  
            BEGIN  
                BEGIN  
                    EXECUTE IMMEDIATE 'DROP TABLE rax_app_user.c$_0nxtl_jobusersurveyquestion';  
                EXCEPTION  
                    WHEN OTHERS THEN NULL;  
                END;  
                create_query := 'create table RAX_APP_USER.C$_0NXTL_JOBUSERSURVEYQUESTION
(
	C1_QUESTIONID	NUMBER NULL,
	C2_QUESTION	VARCHAR2(1024) NULL
)
NOLOGGING';
                EXECUTE IMMEDIATE create_query;
            END;  
            