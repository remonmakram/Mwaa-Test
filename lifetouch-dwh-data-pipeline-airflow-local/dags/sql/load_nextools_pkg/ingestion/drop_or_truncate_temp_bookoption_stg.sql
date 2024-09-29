
BEGIN  
    EXECUTE IMMEDIATE 'TRUNCATE TABLE rax_app_user.nxtl_bookoption_stg';  
EXCEPTION  
    WHEN OTHERS THEN NULL;  
END;  
            