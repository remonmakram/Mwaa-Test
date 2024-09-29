
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table rax_app_user.fow_yb_feature_stg';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table rax_app_user.fow_yb_feature_stg (
FEATURE_ID           NUMBER,
  FEATURE_NAME         VARCHAR2(64),
  FOR_FLOW_ID          NUMBER,
  BOOKING_YEAR         VARCHAR2(255),
  FEATURE_TYPE         VARCHAR2(16),
  FEATURE_CATEGORY     VARCHAR2(16),
  UPDATE_CUTOFF_EVENT  VARCHAR2(64),
  DATE_CREATED         DATE,
  CREATED_BY           VARCHAR2(255),
  LAST_UPDATED         DATE,
  UPDATED_BY           VARCHAR2(255),
  ACTIVE               NUMBER)';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    