
            DECLARE create_query CLOB;  
            BEGIN  
                BEGIN  
                    EXECUTE IMMEDIATE 'DROP TABLE rax_app_user.c$_0nxtl_job';  
                EXCEPTION  
                    WHEN OTHERS THEN NULL;  
                END;  
                create_query := 'create table RAX_APP_USER.C$_0NXTL_JOB
(
	C1_JOBID	NUMBER NULL,
	C2_BOOKID	NUMBER NULL,
	C3_ORGANIZATIONID	NUMBER NULL,
	C4_JOBSTATUSID	NUMBER NULL,
	C5_HARDCOUNT	NUMBER NULL,
	C6_SOFTCOUNT	NUMBER NULL,
	C7_FINALCOUNTSUBMITDATE	DATE NULL,
	C8_FINALCOUNTSUBMITUSERID	NUMBER NULL,
	C9_JOBCODE	NUMBER NULL,
	C10_JOBNAME	VARCHAR2(64) NULL,
	C11_MESSAGE	VARCHAR2(500) NULL,
	C12_SCHOOLNAME	VARCHAR2(100) NULL,
	C13_TRIMSIZEID	NUMBER NULL,
	C14_PRINTTYPE	NUMBER NULL,
	C15_EXPORTTOCUSTOMDICTIONARY	NUMBER NULL,
	C16_YBPAYACTIVATIONDATE	DATE NULL,
	C17_YBPAYCLOSEDATE	DATE NULL,
	C18_ISTAXABLE	NUMBER NULL,
	C19_TAXRATE	NUMBER NULL,
	C20_PRICINGLASTMODIFEDDATE	DATE NULL,
	C21_ADVERTISEMENTPURCHASEBYDAT	DATE NULL,
	C22_ADVERTISEMENTSUBMITBYDATE	DATE NULL,
	C23_ISADBUILDERENABLED	NUMBER NULL
)
NOLOGGING';
                EXECUTE IMMEDIATE create_query;
            END;  
            