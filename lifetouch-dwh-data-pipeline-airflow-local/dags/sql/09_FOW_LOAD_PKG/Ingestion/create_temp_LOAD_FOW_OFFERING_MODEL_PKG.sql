DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_FRNG_MDL_STG';  
      EXCEPTION  
         WHEN OTHERS THEN  
            IF SQLCODE != -942 THEN  
               RAISE;  
            END IF;   
      END;  
      create_query := 'create table RAX_APP_USER.C$_0FOW_FRNG_MDL_STG
                        (
                            C1_ID	NUMBER(19) NULL,
                            C2_VERSION	NUMBER(19) NULL,
                            C3_ACTIVE	NUMBER(1) NULL,
                            C4_COMMISSION_MODEL_ID	NUMBER(19) NULL,
                            C5_CREATED_BY	VARCHAR2(255) NULL,
                            C6_DATE_CREATED	TIMESTAMP(6) NULL,
                            C7_ENVELOPE_ID	VARCHAR2(255) NULL,
                            C8_FLYER_ID	VARCHAR2(255) NULL,
                            C9_INSERTS	VARCHAR2(255) NULL,
                            C10_LAST_UPDATED	TIMESTAMP(6) NULL,
                            C11_NAME	VARCHAR2(255) NULL,
                            C12_PRICE_PROGRAM_NAME	VARCHAR2(255) NULL,
                            C13_TERRITORY	VARCHAR2(255) NULL,
                            C14_UPDATED_BY	VARCHAR2(255) NULL,
                            C15_VISUAL_MERCH_ID	VARCHAR2(255) NULL
                        )
                        NOLOGGING';  
      EXECUTE IMMEDIATE create_query;  
   END;  
   