DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STG_PERSON_INFO';  
      EXCEPTION  
         WHEN OTHERS THEN  
            IF SQLCODE != -942 THEN  
               RAISE;  
            END IF;   
      END;  
      create_query := 'create table RAX_APP_USER.C$_0STG_PERSON_INFO
                        (
                            C1_EMAILID	VARCHAR2(150) NULL,
                            C2_ERROR_TXT	VARCHAR2(1000) NULL,
                            C3_LATITUDE	NUMBER(11,8) NULL,
                            C4_MIDDLE_NAME	VARCHAR2(40) NULL,
                            C5_ADDRESS_LINE5	VARCHAR2(70) NULL,
                            C6_PERSON_INFO_KEY	CHAR(24) NULL,
                            C7_FIRST_NAME	VARCHAR2(64) NULL,
                            C8_TAX_GEO_CODE	VARCHAR2(40) NULL,
                            C9_COMPANY	VARCHAR2(50) NULL,
                            C10_ADDRESS_LINE6	VARCHAR2(70) NULL,
                            C11_ADDRESS_LINE4	VARCHAR2(70) NULL,
                            C12_CITY	VARCHAR2(35) NULL,
                            C13_TITLE	VARCHAR2(10) NULL,
                            C14_HTTP_URL	VARCHAR2(255) NULL,
                            C15_CREATEPROGID	VARCHAR2(40) NULL,
                            C16_VERIFICATION_STATUS	CHAR(15) NULL,
                            C17_STATE	VARCHAR2(35) NULL,
                            C18_MODIFYPROGID	VARCHAR2(40) NULL,
                            C19_BEEPER	CHAR(40) NULL,
                            C20_PREFERRED_SHIP_ADDRESS	CHAR(1) NULL,
                            C21_ADDRESS_LINE2	VARCHAR2(70) NULL,
                            C22_MOBILE_PHONE	CHAR(40) NULL,
                            C23_LOCKID	NUMBER(5) NULL,
                            C24_IS_COMMERCIAL_ADDRESS	CHAR(1) NULL,
                            C25_LAST_NAME	VARCHAR2(64) NULL,
                            C26_TIME_ZONE	VARCHAR2(15) NULL,
                            C27_ALTERNATE_EMAILID	VARCHAR2(150) NULL,
                            C28_MODIFYUSERID	VARCHAR2(40) NULL,
                            C29_ADDRESS_LINE1	VARCHAR2(70) NULL,
                            C30_ZIP_CODE	VARCHAR2(35) NULL,
                            C31_CREATETS	DATE NULL,
                            C32_OTHER_PHONE	CHAR(40) NULL,
                            C33_COUNTRY	VARCHAR2(40) NULL,
                            C34_USE_COUNT	NUMBER(5) NULL,
                            C35_SUFFIX	VARCHAR2(40) NULL,
                            C36_EVENING_PHONE	CHAR(40) NULL,
                            C37_DAY_PHONE	CHAR(40) NULL,
                            C38_DEPARTMENT	VARCHAR2(40) NULL,
                            C39_DAY_FAX_NO	CHAR(40) NULL,
                            C40_CREATEUSERID	VARCHAR2(40) NULL,
                            C41_JOB_TITLE	VARCHAR2(40) NULL,
                            C42_IS_ADDRESS_VERIFIED	CHAR(1) NULL,
                            C43_ADDRESS_LINE3	VARCHAR2(70) NULL,
                            C44_LONGITUDE	NUMBER(11,8) NULL,
                            C45_MODIFYTS	DATE NULL,
                            C46_EVENING_FAX_NO	CHAR(40) NULL,
                            C47_PERSON_ID	CHAR(35) NULL
                        )
                        NOLOGGING';  
      EXECUTE IMMEDIATE create_query;  
   END; 
