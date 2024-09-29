
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table rax_app_user.fow_yb_flow_stg';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table rax_app_user.fow_yb_flow_stg (
 FLOW_ID          NUMBER,
  FLOW_NAME        VARCHAR2(64 BYTE),
  BOOKING_YEAR     VARCHAR2(255 BYTE),
  DATE_CREATED     DATE,
  CREATED_BY       VARCHAR2(255 BYTE),
  LAST_UPDATED     DATE,
  UPDATED_BY       VARCHAR2(255 BYTE),
  ACTIVE           NUMBER)';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    