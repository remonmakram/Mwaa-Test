
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STG_VM_BUSINESS_CONTEXT';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0STG_VM_BUSINESS_CONTEXT
(
	C1_CREATETS	DATE NULL,
	C2_CREATEUSERID	VARCHAR2(40) NULL,
	C3_MODIFYPROGID	VARCHAR2(40) NULL,
	C4_VISUAL_MERCH_KEY	CHAR(24) NULL,
	C5_CREATEPROGID	VARCHAR2(40) NULL,
	C6_VM_BUSINESS_CONTEXT_KEY	CHAR(24) NULL,
	C7_LOCKID	NUMBER(5) NULL,
	C8_VM_BUSINESS_CONTEXT_NAME	VARCHAR2(40) NULL,
	C9_ENTRY_MODE	VARCHAR2(40) NULL,
	C10_MODIFYTS	DATE NULL,
	C11_MODIFYUSERID	VARCHAR2(40) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    