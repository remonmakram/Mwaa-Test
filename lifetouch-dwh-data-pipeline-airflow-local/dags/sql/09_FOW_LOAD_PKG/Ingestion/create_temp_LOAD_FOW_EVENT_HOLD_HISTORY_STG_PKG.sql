DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.fow_event_hold_stg';  
      EXCEPTION  
         WHEN OTHERS THEN  
            IF SQLCODE != -942 THEN  
               RAISE;  
            END IF;   
      END;  
      create_query := 'create table RAX_APP_USER.fow_event_hold_stg
                        ( ID NUMBER NOT NULL
                        , VERSION NUMBER
                        , APO_ID NUMBER
                        , EVENT_ID NUMBER
                        , HOLD_STATUS VARCHAR2(16 BYTE)
                        , HOLD_REASON VARCHAR2(255 BYTE)
                        , CREATED_BY VARCHAR2(255 BYTE)
                        , DATE_CREATED date
                        )';  
      EXECUTE IMMEDIATE create_query;  
   END;  
   