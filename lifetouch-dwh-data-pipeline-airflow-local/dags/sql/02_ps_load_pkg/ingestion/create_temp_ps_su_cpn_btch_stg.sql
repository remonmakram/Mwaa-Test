
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0PS_SU_CPN_BTCH_STG purge';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0PS_SU_CPN_BTCH_STG
(
	C1_SU_COUPON_BATCH_ID	NUMBER(19) NULL,
	C2_DESCRIPTION	VARCHAR2(255) NULL,
	C3_BATCH_PREFIX	VARCHAR2(10) NULL,
	C4_START_DATE	DATE NULL,
	C5_END_DATE	DATE NULL,
	C6_COUPON_COUNT	NUMBER(8) NULL,
	C7_BATCH_TYPE	VARCHAR2(255) NULL,
	C8_EXPORTED	NUMBER(1) NULL,
	C9_AUDIT_CREATE_DATE	DATE NULL,
	C10_AUDIT_CREATED_BY	VARCHAR2(255) NULL,
	C11_AUDIT_MODIFY_DATE	DATE NULL,
	C12_AUDIT_MODIFIED_BY	VARCHAR2(255) NULL,
	C13_STACKABLE	NUMBER(1) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    