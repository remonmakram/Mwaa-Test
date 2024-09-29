
BEGIN  
    EXECUTE IMMEDIATE 'TRUNCATE TABLE rax_app_user.nxtl_payment_stg';  
EXCEPTION  
    WHEN OTHERS THEN NULL;  
END;  
            