
            DECLARE create_query CLOB;  
            BEGIN  
                BEGIN  
                    EXECUTE IMMEDIATE 'DROP TABLE rax_app_user.c$_0nxtl_bookoption';  
                EXCEPTION  
                    WHEN OTHERS THEN NULL;  
                END;  
                create_query := 'create table RAX_APP_USER.C$_0NXTL_BOOKOPTION
(
	C1_BOOKOPTIONID	NUMBER NULL,
	C2_DESCRIPTION	VARCHAR2(255) NULL,
	C3_NAME	VARCHAR2(30) NULL,
	C4_BOOKOPTIONTYPE	NUMBER NULL,
	C5_DISPLAYORDER	NUMBER NULL
)
NOLOGGING';
                EXECUTE IMMEDIATE create_query;
            END;  
            