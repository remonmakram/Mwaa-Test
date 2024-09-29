
            DECLARE create_query CLOB;  
            BEGIN  
                BEGIN  
                    EXECUTE IMMEDIATE 'DROP TABLE rax_app_user.c$_0nxtl_jobuser';  
                EXCEPTION  
                    WHEN OTHERS THEN NULL;  
                END;  
                create_query := 'create table RAX_APP_USER.C$_0NXTL_JOBUSER
(
	C1_JOBID	NUMBER NULL,
	C2_JOBUSERID	NUMBER NULL,
	C3_JOBUSERTYPEID	NUMBER NULL,
	C4_STARTDATE	DATE NULL,
	C5_LASTSIGNIN	DATE NULL,
	C6_SIGNINCOUNT	NUMBER NULL,
	C7_ISACTIVE	NUMBER NULL,
	C8_LEGALACCEPTED	NUMBER NULL,
	C9_FIRSTNAME	VARCHAR2(50) NULL,
	C10_LASTNAME	VARCHAR2(50) NULL,
	C11_LOGINNAME	VARCHAR2(50) NULL,
	C12_EMAILADDRESS	VARCHAR2(250) NULL,
	C13_EMPLOYEEID	VARCHAR2(20) NULL,
	C14_PAGEACCESSTYPE	NUMBER NULL,
	C15_ACCOUNTPRINCIPALID	VARCHAR2(64) NULL,
	C16_INVITATIONID	VARCHAR2(64) NULL,
	C17_ISUSERMANAGED	NUMBER NULL
)
NOLOGGING';
                EXECUTE IMMEDIATE create_query;
            END;  
            