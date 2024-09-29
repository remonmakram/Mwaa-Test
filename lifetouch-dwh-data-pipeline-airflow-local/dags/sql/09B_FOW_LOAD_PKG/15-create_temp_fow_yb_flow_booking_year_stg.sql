
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table rax_app_user.fow_yb_flow_booking_year_stg';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table rax_app_user.fow_yb_flow_booking_year_stg (
 FLOW_ID          NUMBER,
BOOKING_YEAR     VARCHAR2(255)
)';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    