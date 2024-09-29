
            DECLARE create_query CLOB;  
            BEGIN  
                BEGIN  
                    EXECUTE IMMEDIATE 'DROP TABLE rax_app_user.c$_0nxtl_jobusersurveyanswer';  
                EXCEPTION  
                    WHEN OTHERS THEN NULL;  
                END;  
                create_query := 'create table RAX_APP_USER.C$_0NXTL_JOBUSERSURVEYANSWER
(
	C1_JOBUSERSURVEYANSWERID	NUMBER NULL,
	C2_JOBUSERID	NUMBER NULL,
	C3_QUESTIONID	NUMBER NULL,
	C4_ANSWERSELECTION	NUMBER NULL,
	C5_ANSWERTEXT	VARCHAR2(200) NULL,
	C6_ANSWERDATE	DATE NULL
)
NOLOGGING';
                EXECUTE IMMEDIATE create_query;
            END;  
            