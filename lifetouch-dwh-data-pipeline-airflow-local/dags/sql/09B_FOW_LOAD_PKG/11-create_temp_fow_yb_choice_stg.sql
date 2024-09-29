
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table rax_app_user.fow_yb_choice_stg';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table rax_app_user.fow_yb_choice_stg (
CHOICE_ID        NUMBER,
  CHOICE_NAME      VARCHAR2(64),
  ITEM_ID          NUMBER,
  TAG_ID           NUMBER,
  PAGES            NUMBER,
  SCHOOL_PRICING   NUMBER,
  DATE_CREATED     DATE,
  CREATED_BY       VARCHAR2(255),
  LAST_UPDATED     DATE,
  UPDATED_BY       VARCHAR2(255),
  ACTIVE           NUMBER)';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    