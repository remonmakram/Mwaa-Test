
            DECLARE create_query CLOB;  
            BEGIN  
                BEGIN  
                    EXECUTE IMMEDIATE 'DROP TABLE rax_app_user.c$_0nxtl_book';  
                EXCEPTION  
                    WHEN OTHERS THEN NULL;  
                END;  
                create_query := 'create table RAX_APP_USER.C$_0NXTL_BOOK
(
	C1_BOOKID	NUMBER NULL,
	C2_NAME	VARCHAR2(100) NULL,
	C3_BOOKSTATUSID	NUMBER NULL,
	C4_RELEASEDATE	DATE NULL,
	C5_BOOKTYPEID	NUMBER NULL,
	C6_PREFERENCEOPTIONID	NUMBER NULL,
	C7_YEARCODE	VARCHAR2(4) NULL,
	C8_MESSAGE	VARCHAR2(500) NULL
)
NOLOGGING';
                EXECUTE IMMEDIATE create_query;
            END;  
            