
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table rax_app_user.APOCS_EXTENDED_EVENT_STG';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'CREATE TABLE rax_app_user.APOCS_EXTENDED_EVENT_STG
(
  EXT_EVENT_ID                    NUMBER,
  AUDIT_CREATE_DATE               date,
  AUDIT_CREATED_BY                VARCHAR2(255 CHAR),
  AUDIT_MODIFIED_BY               VARCHAR2(255 CHAR),
  AUDIT_MODIFY_DATE               date,
  EXPECTED_SALES_AMT              number,
  JOB_CLASSIFICATION_NAME         VARCHAR2(255 CHAR),
  JOB_NBR                         VARCHAR2(255 CHAR) ,
  LIFETOUCH_ID                    VARCHAR2(255 CHAR),
  ACCOUNT_LT_PARTNER_KEY          VARCHAR2(255 CHAR),
  LT_ACCOUNT_PROGRAM_KEY          VARCHAR2(255 CHAR),
  MARKETING_CODE                  VARCHAR2(255 CHAR),
  ORDER_SALES_TAX_AMT             number,
  PAID_ORDER_QTY                  NUMBER,
  PHOTOGRAPHY_DATE                date,
  PLANT_RECEIPT_DATE              date,
  PROCESSING_LAB                  VARCHAR2(255 CHAR),
  PROGRAM_NAME                    VARCHAR2(255 CHAR),
  SCHOOL_YEAR                     NUMBER(10),
  SELLING_METHOD_NAME             VARCHAR2(255 CHAR),
  SHIP_DATE                       date,
  SHIPPED_ORDER_QTY               NUMBER,
  SOURCE_SYSTEM                   VARCHAR2(255 CHAR),
  STATUS                          VARCHAR2(255 CHAR),
  SUB_PROGRAM_NAME                VARCHAR2(255 CHAR),
  TERRITORY_LT_PARTNER_KEY        VARCHAR2(255 CHAR),
  TERRITORY_CODE                  VARCHAR2(255 CHAR),
  TRANSACTION_AMT                 number,
  UNPAID_ORDER_QTY                NUMBER,
  VISION_COMMIT_DATE              date,
  VISION_PHOTO_DATE_A             date,
  VISION_PHOTO_DATE_B             date,
  X_NO_PURCHASE_QTY               NUMBER(10),
  EVENT_IMAGE_COMPLETE            VARCHAR2(5 BYTE),
  AIR_ENABLED                     VARCHAR2(1 BYTE) ,
  YB_COVERENDSHEET_DEADLINE       VARCHAR2(255 BYTE),
  YB_COPIES                       VARCHAR2(255 BYTE),
  YB_PAGES                        VARCHAR2(255 BYTE),
  YB_FIRSTPAGE_DEADLINE           VARCHAR2(255 BYTE),
  YB_FINALPAGE_DEADLINE           VARCHAR2(255 BYTE),
  YB_ORDER_NO                     VARCHAR2(255 BYTE),
  EVENT_TYPE                      VARCHAR2(255 BYTE),
  EVENT_SEQUENCE                  NUMBER,
  YB_FINALIZED_DATE               VARCHAR2(255 BYTE),
  YB_COVERRECIEVED_DATE           VARCHAR2(255 BYTE),
  YB_ADDTNL_PAGE_DEADLINE1        VARCHAR2(255 BYTE),
  YB_ADDTNL_PAGE_DLINE1_PAGE_DUE  VARCHAR2(255 BYTE),
  YB_ADDTNL_PAGE_DEADLINE2        VARCHAR2(255 BYTE),
  YB_ADDTNL_PAGE_DLINE2_PAGE_DUE  VARCHAR2(255 BYTE),
  YB_ADDTNL_PAGE_DEADLINE3        VARCHAR2(255 BYTE),
  YB_ADDTNL_PAGE_DLINE3_PAGE_DUE  VARCHAR2(255 BYTE),
  YB_EXTRA_COVER_DLINE_PAGE_DUE   VARCHAR2(255 BYTE),
  YB_FINAL_PAGE_DLINE_PAGES_DUE   VARCHAR2(255 BYTE),
  YB_FINAL_QUANTITY_DEADLINE      VARCHAR2(255 BYTE),
  YB_EXTRA_COVERAGE_DEADLINE      VARCHAR2(255 BYTE),
  YB_ENHANCEMENT_DEADLINE         VARCHAR2(255 BYTE),
  COVER_DTLS_PROVIDED             VARCHAR2(255 BYTE),
  COVER_APPROVED                  VARCHAR2(255 BYTE),
  YB_CUTOUT_PAGES                 VARCHAR2(1 BYTE),
  EXPRESS_FREIGHT                 VARCHAR2(1 BYTE),
  YB_TAPE_PLACEMENT               VARCHAR2(255 BYTE),
  YB_SHIPPING_HANDLING            VARCHAR2(255 BYTE),
  YB_SHIPPING_CHARGE              VARCHAR2(255 BYTE)
, event_hold_status varchar2(255)
, event_hold_status_change_by varchar2(255)
, event_hold_status_date date
, proof_order_duedate date
)';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    