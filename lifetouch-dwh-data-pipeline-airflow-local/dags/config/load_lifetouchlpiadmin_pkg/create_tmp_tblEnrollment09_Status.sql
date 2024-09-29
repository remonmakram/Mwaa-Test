DECLARE  
  create_query CLOB;  
BEGIN  
  BEGIN  
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0LTLPIADM_TBLENRLMNT09_STAT';  
  EXCEPTION  
    WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
        RAISE;  
      END IF;  
  END;  
  
  create_query := 'create table RAX_APP_USER.C$_0LTLPIADM_TBLENRLMNT09_STAT( ' ||  
                  'C1_ENROLLMENTSTATUSID NUMBER NULL, ' ||  
                  'C2_ENROLLMENTSTATUSDESCRIPTION VARCHAR2(32) NULL)';  
  
  EXECUTE IMMEDIATE create_query;  
END;  

