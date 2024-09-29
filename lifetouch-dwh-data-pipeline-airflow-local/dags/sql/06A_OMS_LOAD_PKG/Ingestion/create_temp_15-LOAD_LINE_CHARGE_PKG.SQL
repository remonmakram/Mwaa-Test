DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STG_LINE_CHARGE ';  
      EXCEPTION  
         WHEN OTHERS THEN  
            IF SQLCODE != -942 THEN  
               RAISE;  
            END IF;   
      END;  
      create_query := 'create table RAX_APP_USER.C$_0STG_LINE_CHARGE
                        (
                            C1_RECORD_TYPE	VARCHAR2(20) NULL,
                            C2_HEADER_KEY	CHAR(24) NULL,
                            C3_EXTN_TAX_CODE	VARCHAR2(20) NULL,
                            C4_CREATETS	DATE NULL,
                            C5_LINE_KEY	CHAR(24) NULL,
                            C6_REFERENCE	VARCHAR2(50) NULL,
                            C7_CHARGE_CATEGORY	VARCHAR2(20) NULL,
                            C8_CREATEPROGID	VARCHAR2(40) NULL,
                            C9_EXTN_IS_PERCENTAGE_DISCOUNT	CHAR(1) NULL,
                            C10_ORIGINAL_CHARGEPERUNIT	NUMBER(19,6) NULL,
                            C11_ORIGINAL_CHARGEPERLINE	NUMBER(15,2) NULL,
                            C12_EXTN_TDEBIT_AMOUNT	NUMBER(9,2) NULL,
                            C13_EXTN_TAX_INCLUSIVE	VARCHAR2(1) NULL,
                            C14_EXTN_DISCOUNT_PERCENTAGE	NUMBER(5,2) NULL,
                            C15_CHARGEPERUNIT	NUMBER(19,6) NULL,
                            C16_CHARGEPERLINE	NUMBER(15,2) NULL,
                            C17_MODIFYUSERID	VARCHAR2(40) NULL,
                            C18_MODIFYTS	DATE NULL,
                            C19_MODIFYPROGID	VARCHAR2(40) NULL,
                            C20_CREATEUSERID	VARCHAR2(40) NULL,
                            C21_LINE_CHARGES_KEY	CHAR(24) NULL,
                            C22_EXTN_TAXABLE	VARCHAR2(1) NULL,
                            C23_INVOICED_EXTENDED_CHARGE	NUMBER(15,2) NULL,
                            C24_CHARGEAMOUNT	NUMBER(15,2) NULL,
                            C25_LOCKID	NUMBER(5) NULL,
                            C26_EXTN_CHARGE_DESCRIPTION	VARCHAR2(100) NULL,
                            C27_INVOICED_CHARGE_PER_LINE	NUMBER(15,2) NULL,
                            C28_CHARGE_NAME	VARCHAR2(40) NULL
                        )
                        NOLOGGING';  
      EXECUTE IMMEDIATE create_query;  
END; 
