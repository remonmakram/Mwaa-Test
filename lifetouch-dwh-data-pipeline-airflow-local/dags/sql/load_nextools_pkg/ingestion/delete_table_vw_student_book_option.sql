
BEGIN  
    EXECUTE IMMEDIATE 'DELETE FROM rax_app_user.nxtl_vw_student_book_option';
EXCEPTION  
    WHEN OTHERS THEN NULL;  
END;  
            