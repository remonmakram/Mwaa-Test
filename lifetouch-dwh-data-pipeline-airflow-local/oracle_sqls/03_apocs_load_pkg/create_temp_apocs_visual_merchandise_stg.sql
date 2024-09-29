
                    DECLARE create_query CLOB;  
                    BEGIN  
                        BEGIN  
                            EXECUTE IMMEDIATE 'drop table rax_app_user.APOCS_VISUAL_MERCHANDISE_STG';  
                        EXCEPTION  
                            WHEN OTHERS THEN NULL;  
                        END;  
                        create_query := 'CREATE TABLE rax_app_user.APOCS_VISUAL_MERCHANDISE_STG
(
VM_ID                                   NUMBER
,AUDIT_CREATE_DATE                       date
,AUDIT_CREATED_BY                        VARCHAR2(255 CHAR)
,AUDIT_MODIFIED_BY                       VARCHAR2(255 CHAR)
,AUDIT_MODIFY_DATE                       date
,BUSINESS_KEY                            VARCHAR2(255 CHAR)
,LOCKID                                  NUMBER
,REVISION_NO                             VARCHAR2(255 CHAR)
,STATUS                                  VARCHAR2(255 CHAR)
,VISUAL_MERCH_DESCRIPTION                VARCHAR2(255 CHAR)
,VISUAL_MERCH_NAME                       VARCHAR2(255 CHAR)
,VISUAL_MERCH_PAYMENT_MODE               VARCHAR2(255 CHAR)
,USE_SUBJECT_IMAGES                      VARCHAR2(255 CHAR)
,CLICK_SELECTION                         VARCHAR2(255 CHAR)
,CAMERA_POSE_SET                         VARCHAR2(255 CHAR)
,CAMERA_POSE_SET_DESC                    VARCHAR2(255 CHAR)
,CAMERA_PROGRAM_CODE                     VARCHAR2(255 CHAR)
,CAMERA_TYPE                             VARCHAR2(255 CHAR)
,EXTEND_PRE_PICTURE_DAY_PRICING          CHAR(1)
,PHOTOGRAPH_NON_BUYERS                   CHAR(1)
,PREPAY_PAY_ONLY_ON_MLT                  CHAR(1)
)';
                        EXECUTE IMMEDIATE create_query;
                    END;  
                    