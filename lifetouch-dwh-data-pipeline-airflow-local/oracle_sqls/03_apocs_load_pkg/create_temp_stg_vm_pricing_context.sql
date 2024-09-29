
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STG_VM_PRICING_CONTEXT';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0STG_VM_PRICING_CONTEXT
(
	C1_CREATETS	DATE NULL,
	C2_CREATEUSERID	VARCHAR2(40) NULL,
	C3_MODIFYPROGID	VARCHAR2(40) NULL,
	C4_PRICING_CONTEXT_REF	VARCHAR2(60) NULL,
	C5_VISUAL_MERCH_KEY	VARCHAR2(24) NULL,
	C6_CREATEPROGID	VARCHAR2(40) NULL,
	C7_PRICING_CONTEXT_ID	VARCHAR2(40) NULL,
	C8_PRICING_CONTEXT_TYPE	VARCHAR2(40) NULL,
	C9_LOCKID	NUMBER(5) NULL,
	C10_VM_PRICING_CONTEXT_KEY	CHAR(24) NULL,
	C11_MODIFYTS	DATE NULL,
	C12_MODIFYUSERID	VARCHAR2(40) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    