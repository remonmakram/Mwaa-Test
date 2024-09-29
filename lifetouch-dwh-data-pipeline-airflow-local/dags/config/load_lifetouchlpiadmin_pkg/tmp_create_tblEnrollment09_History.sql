DECLARE  
  create_query CLOB;  
BEGIN  
  BEGIN  
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0LTLPIADM_TBLENRLMNT09_HIST';  
  EXCEPTION  
    WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
        RAISE;  
      END IF;  
  END;  
  
  create_query := 'create table RAX_APP_USER.C$_0LTLPIADM_TBLENRLMNT09_HIST(' ||  
                  'C1_ENROLLMENTHISTORYID NUMBER NULL, ' ||  
                  'C2_ENROLLMENTID NUMBER NULL, ' ||  
                  'C3_PROGRAMDESCRIPTION VARCHAR2(64) NULL, ' ||  
                  'C4_WEBSITE NUMBER NULL, ' ||  
                  'C5_ADVISERFIRSTNAME VARCHAR2(32) NULL, ' ||  
                  'C6_ADVISERLASTNAME VARCHAR2(32) NULL, ' ||  
                  'C7_ADVISEREMAIL VARCHAR2(64) NULL, ' ||  
                  'C8_ADVISERUSERNAME VARCHAR2(10) NULL, ' ||  
                  'C9_ADVISERPASSWORD VARCHAR2(10) NULL, ' ||  
                  'C10_SALESREPNAME VARCHAR2(64) NULL, ' ||  
                  'C11_SALESREPEMAIL VARCHAR2(64) NULL, ' ||  
                  'C12_SALESREPUSERNAME VARCHAR2(10) NULL, ' ||  
                  'C13_SALESREPPASSWORD VARCHAR2(10) NULL, ' ||  
                  'C14_SALESREPTERRITORYCODE VARCHAR2(5) NULL, ' ||  
                  'C15_ENROLLMENTSTATUSID NUMBER NULL, ' ||  
                  'C16_COMPLETEDBY NUMBER NULL, ' ||  
                  'C17_COMPLETEDDATE DATE NULL, ' ||  
                  'C18_COMPLETEDTIME DATE NULL)';  
  
  EXECUTE IMMEDIATE create_query;  
END;  
