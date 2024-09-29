
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.fow_names_file_stg';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.fow_names_file_stg
(ID           NUMBER not null
,APO_ID       NUMBER
,COMMENTS     VARCHAR2(255 CHAR)
,CREATED_BY   VARCHAR2(255 CHAR)
,DATE_CREATED date
,FILE_NAME    VARCHAR2(255 CHAR)
,LAST_UPDATED date
,STATUS       VARCHAR2(255 CHAR)
,UPDATED_BY   VARCHAR2(255 CHAR)
,EVENT_ID     NUMBER
)';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    