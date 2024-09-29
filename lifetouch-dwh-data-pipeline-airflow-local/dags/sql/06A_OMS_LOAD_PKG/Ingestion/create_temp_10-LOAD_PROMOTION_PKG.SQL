DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STG_PROMOTION ';  
      EXCEPTION  
         WHEN OTHERS THEN  
            IF SQLCODE != -942 THEN  
               RAISE;  
            END IF;   
      END;  
      create_query := 'create table RAX_APP_USER.C$_0STG_PROMOTION
                        (
                            C1_DESCRIPTION	VARCHAR2(100) NULL,
                            C2_PROMOTION_ID	VARCHAR2(100) NULL,
                            C3_ORDER_HEADER_KEY	VARCHAR2(24) NULL,
                            C4_PROMOTION_TYPE	VARCHAR2(100) NULL,
                            C5_DENIAL_REASON	VARCHAR2(100) NULL,
                            C6_MODIFYTS	DATE NULL,
                            C7_MODIFYUSERID	VARCHAR2(40) NULL,
                            C8_PROMOTION_APPLIED	CHAR(1) NULL,
                            C9_CREATETS	DATE NULL,
                            C10_CREATEUSERID	VARCHAR2(40) NULL,
                            C11_MODIFYPROGID	VARCHAR2(40) NULL,
                            C12_PROMOTION_KEY	VARCHAR2(24) NULL,
                            C13_CREATEPROGID	VARCHAR2(40) NULL,
                            C14_LOCKID	NUMBER(5) NULL
                        )
                        NOLOGGING';  
      EXECUTE IMMEDIATE create_query;  
END; 
