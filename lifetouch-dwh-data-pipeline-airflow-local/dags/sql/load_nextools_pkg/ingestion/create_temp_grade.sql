
            DECLARE create_query CLOB;  
            BEGIN  
                BEGIN  
                    EXECUTE IMMEDIATE 'DROP TABLE rax_app_user.c$_0nxtl_grade';  
                EXCEPTION  
                    WHEN OTHERS THEN NULL;  
                END;  
                create_query := 'create table RAX_APP_USER.C$_0NXTL_GRADE
(
	C1_GRADEID	NUMBER NULL,
	C2_CODE	VARCHAR2(3) NULL,
	C3_DESCRIPTION	VARCHAR2(50) NULL,
	C4_SORTORDER	NUMBER NULL
)
NOLOGGING';
                EXECUTE IMMEDIATE create_query;
            END;  
            