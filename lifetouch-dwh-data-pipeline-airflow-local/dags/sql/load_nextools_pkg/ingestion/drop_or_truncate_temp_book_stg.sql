
BEGIN  
    EXECUTE IMMEDIATE 'TRUNCATE TABLE rax_app_user.nxtl_book_stg';  
EXCEPTION  
    WHEN OTHERS THEN NULL;  
END;  
            