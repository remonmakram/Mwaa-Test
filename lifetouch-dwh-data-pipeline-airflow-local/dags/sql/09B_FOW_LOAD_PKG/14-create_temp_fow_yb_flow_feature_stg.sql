
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table rax_app_user.fow_yb_flow_feature_stg';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table rax_app_user.fow_yb_flow_feature_stg (
 FLOW_ID          NUMBER,
  FEATURE_ID       NUMBER,
  FLOW_FILTER_ID   NUMBER,
  FLOW_SEQUENCE    NUMBER,
  BOOKING_YEAR     VARCHAR2(255),
  DATE_CREATED     DATE,
  CREATED_BY       VARCHAR2(255),
  LAST_UPDATED     DATE,
  UPDATED_BY       VARCHAR2(255))';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    