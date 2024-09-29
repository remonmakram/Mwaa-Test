DECLARE  
  create_query CLOB;  
BEGIN  
  BEGIN  
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0LTLPIADM_TBLENROLLMENT09';  
  EXCEPTION  
    WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
        RAISE;  
      END IF;  
  END;  
  
  create_query := 'create table RAX_APP_USER.C$_0LTLPIADM_TBLENROLLMENT09(' ||  
                  'C1_ENROLLMENTID NUMBER NULL, ' ||  
                  'C2_JOBNUMBER NUMBER NULL)';  
  
  EXECUTE IMMEDIATE create_query;  
END;  

