
BEGIN  
    EXECUTE IMMEDIATE 'TRUNCATE TABLE rax_app_user.nxtl_jobfinal_stg';  
EXCEPTION  
    WHEN OTHERS THEN NULL;  
END;  
            