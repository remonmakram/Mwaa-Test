DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STG_KIT_ITEM';  
      EXCEPTION  
         WHEN OTHERS THEN  
            IF SQLCODE != -942 THEN  
               RAISE;  
            END IF;   
      END;  
      create_query := 'create table RAX_APP_USER.C$_0STG_KIT_ITEM
                        (
                            C1_MODIFYUSERID	VARCHAR2(40) NULL,
                            C2_ITEM_KEY	CHAR(24) NULL,
                            C3_CREATEPROGID	VARCHAR2(40) NULL,
                            C4_KIT_ITEM_KEY	CHAR(24) NULL,
                            C5_COMPONENT_ITEM_KEY	CHAR(24) NULL,
                            C6_MODIFYTS	DATE NULL,
                            C7_KIT_QUANTITY	NUMBER(14,4) NULL,
                            C8_MODIFYPROGID	VARCHAR2(40) NULL,
                            C9_CREATETS	DATE NULL,
                            C10_LOCKID	NUMBER(5) NULL,
                            C11_CREATEUSERID	VARCHAR2(40) NULL
                        )
                        NOLOGGING';  
      EXECUTE IMMEDIATE create_query;  
   END; 
