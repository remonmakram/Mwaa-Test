
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0PS_SU_CPN_PROMO_STG purge';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'create table RAX_APP_USER.C$_0PS_SU_CPN_PROMO_STG
(
	C1_SU_COUPON_PROMOTION_ID	NUMBER(19) NULL,
	C2_SU_COUPON_BATCH	NUMBER(19) NULL,
	C3_PROMOTION	NUMBER(19) NULL
)
NOLOGGING';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    