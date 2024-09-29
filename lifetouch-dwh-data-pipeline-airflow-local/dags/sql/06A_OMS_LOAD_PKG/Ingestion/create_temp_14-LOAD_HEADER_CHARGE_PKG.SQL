DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STG_HEADER_CHARGE ';  
      EXCEPTION  
         WHEN OTHERS THEN  
            IF SQLCODE != -942 THEN  
               RAISE;  
            END IF;   
      END;  
      create_query := 'create table RAX_APP_USER.C$_0STG_HEADER_CHARGE
                        (
                            C1_CHARGE_NAME	VARCHAR2(40) NULL,
                            C2_HEADER_KEY	CHAR(24) NULL,
                            C3_CHARGE	NUMBER(15,2) NULL,
                            C4_EXTN_CHARGE_DESCRIPTION	VARCHAR2(100) NULL,
                            C5_MODIFYTS	DATE NULL,
                            C6_MODIFYPROGID	VARCHAR2(40) NULL,
                            C7_CHARGE_CATEGORY	VARCHAR2(20) NULL,
                            C8_EXTN_TAXABLE	CHAR(1) NULL,
                            C9_CREATEPROGID	VARCHAR2(40) NULL,
                            C10_MODIFYUSERID	VARCHAR2(40) NULL,
                            C11_REFERENCE	VARCHAR2(50) NULL,
                            C12_CREATETS	DATE NULL,
                            C13_EXTN_ACCOUNTING_TYPE	VARCHAR2(40) NULL,
                            C14_LOCKID	NUMBER(5) NULL,
                            C15_INVOICED_CHARGE	NUMBER(15,2) NULL,
                            C16_EXTN_TAX_INCLUSIVE	CHAR(1) NULL,
                            C17_EXTN_TCREDIT_PERCENTAGE	NUMBER(3) NULL,
                            C18_EXTN_TAX_CODE	VARCHAR2(20) NULL,
                            C19_CREATEUSERID	VARCHAR2(40) NULL,
                            C20_RECORD_TYPE	VARCHAR2(20) NULL,
                            C21_ORIGINAL_CHARGE	NUMBER(15,2) NULL,
                            C22_HEADER_CHARGES_KEY	CHAR(24) NULL
                        )
                        NOLOGGING';  
      EXECUTE IMMEDIATE create_query;  
END; 
