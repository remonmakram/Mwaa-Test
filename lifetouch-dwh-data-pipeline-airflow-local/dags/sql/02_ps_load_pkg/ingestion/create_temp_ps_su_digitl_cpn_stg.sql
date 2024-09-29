
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0PS_SU_DIGITL_CPN_STG purge';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0PS_SU_DIGITL_CPN_STG
(
	C1_SU_DIGITAL_COUPON_ID	NUMBER(19) NULL,
	C2_COUPON_CODE	VARCHAR2(255) NULL,
	C3_SU_COUPON_BATCH	NUMBER(19) NULL,
	C4_MAX_REDEMPTIONS	NUMBER(8) NULL,
	C5_NUM_REDEMPTIONS	NUMBER(8) NULL,
	C6_REDEEM_DATE	DATE NULL,
	C7_AUDIT_CREATE_DATE	DATE NULL,
	C8_AUDIT_CREATED_BY	VARCHAR2(255) NULL,
	C9_AUDIT_MODIFY_DATE	DATE NULL,
	C10_AUDIT_MODIFIED_BY	VARCHAR2(255) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    