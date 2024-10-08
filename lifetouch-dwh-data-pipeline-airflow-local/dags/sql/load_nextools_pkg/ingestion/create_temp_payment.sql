
            DECLARE create_query CLOB;  
            BEGIN  
                BEGIN  
                    EXECUTE IMMEDIATE 'DROP TABLE rax_app_user.c$_0nxtl_payment';  
                EXCEPTION  
                    WHEN OTHERS THEN NULL;  
                END;  
                create_query := 'create table RAX_APP_USER.C$_0NXTL_PAYMENT
(
	C1_ID	NUMBER NULL,
	C2_PERSONID	NUMBER NULL,
	C3_AMOUNT	NUMBER NULL,
	C4_TRANSACTIONDATE	DATE NULL,
	C5_PAYMENTTYPEID	NUMBER NULL,
	C6_ORIGINID	NUMBER NULL,
	C7_MEMO	VARCHAR2(100) NULL,
	C8_CREATEDUSER	VARCHAR2(50) NULL,
	C9_CREATEDDATE	DATE NULL,
	C10_LASTMODIFIEDUSER	VARCHAR2(50) NULL,
	C11_LASTMODIFIEDDATE	DATE NULL,
	C12_VERIFICATIONRESULTCODE	NUMBER NULL,
	C13_VERIFICATIONRESULTMESSAGE	VARCHAR2(200) NULL,
	C14_PNREF	VARCHAR2(50) NULL
)
NOLOGGING';
                EXECUTE IMMEDIATE create_query;
            END;  
            