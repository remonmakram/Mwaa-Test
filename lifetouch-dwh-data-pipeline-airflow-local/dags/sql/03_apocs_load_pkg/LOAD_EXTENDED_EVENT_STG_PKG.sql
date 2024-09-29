
MERGE INTO ODS_STAGE.APOCS_EXTENDED_EVENT_STG d
     USING (SELECT EXT_EVENT_ID,
                   AUDIT_CREATE_DATE,
                   AUDIT_CREATED_BY,
                   AUDIT_MODIFIED_BY,
                   AUDIT_MODIFY_DATE,
                   EXPECTED_SALES_AMT,
                   JOB_CLASSIFICATION_NAME,
                   JOB_NBR,
                   LIFETOUCH_ID,
                   ACCOUNT_LT_PARTNER_KEY,
                   LT_ACCOUNT_PROGRAM_KEY,
                   MARKETING_CODE,
                   ORDER_SALES_TAX_AMT,
                   PAID_ORDER_QTY,
                   PHOTOGRAPHY_DATE,
                   PLANT_RECEIPT_DATE,
                   PROCESSING_LAB,
                   PROGRAM_NAME,
                   SCHOOL_YEAR,
                   SELLING_METHOD_NAME,
                   SHIP_DATE,
                   SHIPPED_ORDER_QTY,
                   SOURCE_SYSTEM,
                   STATUS,
                   SUB_PROGRAM_NAME,
                   TERRITORY_LT_PARTNER_KEY,
                   TERRITORY_CODE,
                   TRANSACTION_AMT,
                   UNPAID_ORDER_QTY,
                   VISION_COMMIT_DATE,
                   VISION_PHOTO_DATE_A,
                   VISION_PHOTO_DATE_B,
                   X_NO_PURCHASE_QTY,
                   EVENT_IMAGE_COMPLETE,
                   AIR_ENABLED,
                   YB_COVERENDSHEET_DEADLINE,
                   YB_COPIES,
                   YB_PAGES,
                   YB_FIRSTPAGE_DEADLINE,
                   YB_FINALPAGE_DEADLINE,
                   YB_ORDER_NO,
                   EVENT_TYPE,
                   EVENT_SEQUENCE,
                   YB_FINALIZED_DATE,
                   YB_COVERRECIEVED_DATE,
                   YB_ADDTNL_PAGE_DEADLINE1,
                   YB_ADDTNL_PAGE_DLINE1_PAGE_DUE,
                   YB_ADDTNL_PAGE_DEADLINE2,
                   YB_ADDTNL_PAGE_DLINE2_PAGE_DUE,
                   YB_ADDTNL_PAGE_DEADLINE3,
                   YB_ADDTNL_PAGE_DLINE3_PAGE_DUE,
                   YB_EXTRA_COVER_DLINE_PAGE_DUE,
                   YB_FINAL_PAGE_DLINE_PAGES_DUE,
                   YB_FINAL_QUANTITY_DEADLINE,
                   YB_EXTRA_COVERAGE_DEADLINE,
                   YB_ENHANCEMENT_DEADLINE,
                   COVER_DTLS_PROVIDED,
                   COVER_APPROVED,
                   YB_CUTOUT_PAGES,
                   EXPRESS_FREIGHT,
                   YB_TAPE_PLACEMENT,
                   YB_SHIPPING_HANDLING,
                   YB_SHIPPING_CHARGE
, event_hold_status 
, event_hold_status_change_by 
, event_hold_status_date
, proof_order_duedate
              FROM RAX_APP_USER.APOCS_EXTENDED_EVENT_STG) s
        ON (d.ext_event_id = s.ext_event_id)
WHEN NOT MATCHED
THEN
    INSERT     (EXT_EVENT_ID,
                AUDIT_CREATE_DATE,
                AUDIT_CREATED_BY,
                AUDIT_MODIFIED_BY,
                AUDIT_MODIFY_DATE,
                EXPECTED_SALES_AMT,
                JOB_CLASSIFICATION_NAME,
                JOB_NBR,
                LIFETOUCH_ID,
                ACCOUNT_LT_PARTNER_KEY,
                LT_ACCOUNT_PROGRAM_KEY,
                MARKETING_CODE,
                ORDER_SALES_TAX_AMT,
                PAID_ORDER_QTY,
                PHOTOGRAPHY_DATE,
                PLANT_RECEIPT_DATE,
                PROCESSING_LAB,
                PROGRAM_NAME,
                SCHOOL_YEAR,
                SELLING_METHOD_NAME,
                SHIP_DATE,
                SHIPPED_ORDER_QTY,
                SOURCE_SYSTEM,
                STATUS,
                SUB_PROGRAM_NAME,
                TERRITORY_LT_PARTNER_KEY,
                TERRITORY_CODE,
                TRANSACTION_AMT,
                UNPAID_ORDER_QTY,
                VISION_COMMIT_DATE,
                VISION_PHOTO_DATE_A,
                VISION_PHOTO_DATE_B,
                X_NO_PURCHASE_QTY,
                EVENT_IMAGE_COMPLETE,
                AIR_ENABLED,
                YB_COVERENDSHEET_DEADLINE,
                YB_COPIES,
                YB_PAGES,
                YB_FIRSTPAGE_DEADLINE,
                YB_FINALPAGE_DEADLINE,
                YB_ORDER_NO,
                EVENT_TYPE,
                EVENT_SEQUENCE,
                YB_FINALIZED_DATE,
                YB_COVERRECIEVED_DATE,
                YB_ADDTNL_PAGE_DEADLINE1,
                YB_ADDTNL_PAGE_DLINE1_PAGE_DUE,
                YB_ADDTNL_PAGE_DEADLINE2,
                YB_ADDTNL_PAGE_DLINE2_PAGE_DUE,
                YB_ADDTNL_PAGE_DEADLINE3,
                YB_ADDTNL_PAGE_DLINE3_PAGE_DUE,
                YB_EXTRA_COVER_DLINE_PAGE_DUE,
                YB_FINAL_PAGE_DLINE_PAGES_DUE,
                YB_FINAL_QUANTITY_DEADLINE,
                YB_EXTRA_COVERAGE_DEADLINE,
                YB_ENHANCEMENT_DEADLINE,
                COVER_DTLS_PROVIDED,
                COVER_APPROVED,
                YB_CUTOUT_PAGES,
                EXPRESS_FREIGHT,
                YB_TAPE_PLACEMENT,
                YB_SHIPPING_HANDLING,
                YB_SHIPPING_CHARGE,
                ODS_CREATE_DATE,
                ODS_MODIFY_DATE
, event_hold_status 
, event_hold_status_change_by 
, event_hold_status_date
, proof_order_duedate
)
        VALUES (s.EXT_EVENT_ID,
                s.AUDIT_CREATE_DATE,
                s.AUDIT_CREATED_BY,
                s.AUDIT_MODIFIED_BY,
                s.AUDIT_MODIFY_DATE,
                s.EXPECTED_SALES_AMT,
                s.JOB_CLASSIFICATION_NAME,
                s.JOB_NBR,
                s.LIFETOUCH_ID,
                s.ACCOUNT_LT_PARTNER_KEY,
                s.LT_ACCOUNT_PROGRAM_KEY,
                s.MARKETING_CODE,
                s.ORDER_SALES_TAX_AMT,
                s.PAID_ORDER_QTY,
                s.PHOTOGRAPHY_DATE,
                s.PLANT_RECEIPT_DATE,
                s.PROCESSING_LAB,
                s.PROGRAM_NAME,
                s.SCHOOL_YEAR,
                s.SELLING_METHOD_NAME,
                s.SHIP_DATE,
                s.SHIPPED_ORDER_QTY,
                s.SOURCE_SYSTEM,
                s.STATUS,
                s.SUB_PROGRAM_NAME,
                s.TERRITORY_LT_PARTNER_KEY,
                s.TERRITORY_CODE,
                s.TRANSACTION_AMT,
                s.UNPAID_ORDER_QTY,
                s.VISION_COMMIT_DATE,
                s.VISION_PHOTO_DATE_A,
                s.VISION_PHOTO_DATE_B,
                s.X_NO_PURCHASE_QTY,
                s.EVENT_IMAGE_COMPLETE,
                s.AIR_ENABLED,
                s.YB_COVERENDSHEET_DEADLINE,
                s.YB_COPIES,
                s.YB_PAGES,
                s.YB_FIRSTPAGE_DEADLINE,
                s.YB_FINALPAGE_DEADLINE,
                s.YB_ORDER_NO,
                s.EVENT_TYPE,
                s.EVENT_SEQUENCE,
                s.YB_FINALIZED_DATE,
                s.YB_COVERRECIEVED_DATE,
                s.YB_ADDTNL_PAGE_DEADLINE1,
                s.YB_ADDTNL_PAGE_DLINE1_PAGE_DUE,
                s.YB_ADDTNL_PAGE_DEADLINE2,
                s.YB_ADDTNL_PAGE_DLINE2_PAGE_DUE,
                s.YB_ADDTNL_PAGE_DEADLINE3,
                s.YB_ADDTNL_PAGE_DLINE3_PAGE_DUE,
                s.YB_EXTRA_COVER_DLINE_PAGE_DUE,
                s.YB_FINAL_PAGE_DLINE_PAGES_DUE,
                s.YB_FINAL_QUANTITY_DEADLINE,
                s.YB_EXTRA_COVERAGE_DEADLINE,
                s.YB_ENHANCEMENT_DEADLINE,
                s.COVER_DTLS_PROVIDED,
                s.COVER_APPROVED,
                s.YB_CUTOUT_PAGES,
                s.EXPRESS_FREIGHT,
                s.YB_TAPE_PLACEMENT,
                s.YB_SHIPPING_HANDLING,
                s.YB_SHIPPING_CHARGE,
                SYSDATE,
                SYSDATE
, s.event_hold_status 
, s.event_hold_status_change_by 
, s.event_hold_status_date
, s.proof_order_duedate
)
WHEN MATCHED
THEN
    UPDATE SET
        d.AUDIT_CREATE_DATE = s.AUDIT_CREATE_DATE,
        d.AUDIT_CREATED_BY = s.AUDIT_CREATED_BY,
        d.AUDIT_MODIFIED_BY = s.AUDIT_MODIFIED_BY,
        d.AUDIT_MODIFY_DATE = s.AUDIT_MODIFY_DATE,
        d.EXPECTED_SALES_AMT = s.EXPECTED_SALES_AMT,
        d.JOB_CLASSIFICATION_NAME = s.JOB_CLASSIFICATION_NAME,
        d.JOB_NBR = s.JOB_NBR,
        d.LIFETOUCH_ID = s.LIFETOUCH_ID,
        d.ACCOUNT_LT_PARTNER_KEY = s.ACCOUNT_LT_PARTNER_KEY,
        d.LT_ACCOUNT_PROGRAM_KEY = s.LT_ACCOUNT_PROGRAM_KEY,
        d.MARKETING_CODE = s.MARKETING_CODE,
        d.ORDER_SALES_TAX_AMT = s.ORDER_SALES_TAX_AMT,
        d.PAID_ORDER_QTY = s.PAID_ORDER_QTY,
        d.PHOTOGRAPHY_DATE = s.PHOTOGRAPHY_DATE,
        d.PLANT_RECEIPT_DATE = s.PLANT_RECEIPT_DATE,
        d.PROCESSING_LAB = s.PROCESSING_LAB,
        d.PROGRAM_NAME = s.PROGRAM_NAME,
        d.SCHOOL_YEAR = s.SCHOOL_YEAR,
        d.SELLING_METHOD_NAME = s.SELLING_METHOD_NAME,
        d.SHIP_DATE = s.SHIP_DATE,
        d.SHIPPED_ORDER_QTY = s.SHIPPED_ORDER_QTY,
        d.SOURCE_SYSTEM = s.SOURCE_SYSTEM,
        d.STATUS = s.STATUS,
        d.SUB_PROGRAM_NAME = s.SUB_PROGRAM_NAME,
        d.TERRITORY_LT_PARTNER_KEY = s.TERRITORY_LT_PARTNER_KEY,
        d.TERRITORY_CODE = s.TERRITORY_CODE,
        d.TRANSACTION_AMT = s.TRANSACTION_AMT,
        d.UNPAID_ORDER_QTY = s.UNPAID_ORDER_QTY,
        d.VISION_COMMIT_DATE = s.VISION_COMMIT_DATE,
        d.VISION_PHOTO_DATE_A = s.VISION_PHOTO_DATE_A,
        d.VISION_PHOTO_DATE_B = s.VISION_PHOTO_DATE_B,
        d.X_NO_PURCHASE_QTY = s.X_NO_PURCHASE_QTY,
        d.EVENT_IMAGE_COMPLETE = s.EVENT_IMAGE_COMPLETE,
        d.AIR_ENABLED = s.AIR_ENABLED,
        d.YB_COVERENDSHEET_DEADLINE = s.YB_COVERENDSHEET_DEADLINE,
        d.YB_COPIES = s.YB_COPIES,
        d.YB_PAGES = s.YB_PAGES,
        d.YB_FIRSTPAGE_DEADLINE = s.YB_FIRSTPAGE_DEADLINE,
        d.YB_FINALPAGE_DEADLINE = s.YB_FINALPAGE_DEADLINE,
        d.YB_ORDER_NO = s.YB_ORDER_NO,
        d.EVENT_TYPE = s.EVENT_TYPE,
        d.EVENT_SEQUENCE = s.EVENT_SEQUENCE,
        d.YB_FINALIZED_DATE = s.YB_FINALIZED_DATE,
        d.YB_COVERRECIEVED_DATE = s.YB_COVERRECIEVED_DATE,
        d.YB_ADDTNL_PAGE_DEADLINE1 = s.YB_ADDTNL_PAGE_DEADLINE1,
        d.YB_ADDTNL_PAGE_DLINE1_PAGE_DUE = s.YB_ADDTNL_PAGE_DLINE1_PAGE_DUE,
        d.YB_ADDTNL_PAGE_DEADLINE2 = s.YB_ADDTNL_PAGE_DEADLINE2,
        d.YB_ADDTNL_PAGE_DLINE2_PAGE_DUE = s.YB_ADDTNL_PAGE_DLINE2_PAGE_DUE,
        d.YB_ADDTNL_PAGE_DEADLINE3 = s.YB_ADDTNL_PAGE_DEADLINE3,
        d.YB_ADDTNL_PAGE_DLINE3_PAGE_DUE = s.YB_ADDTNL_PAGE_DLINE3_PAGE_DUE,
        d.YB_EXTRA_COVER_DLINE_PAGE_DUE = s.YB_EXTRA_COVER_DLINE_PAGE_DUE,
        d.YB_FINAL_PAGE_DLINE_PAGES_DUE = s.YB_FINAL_PAGE_DLINE_PAGES_DUE,
        d.YB_FINAL_QUANTITY_DEADLINE = s.YB_FINAL_QUANTITY_DEADLINE,
        d.YB_EXTRA_COVERAGE_DEADLINE = s.YB_EXTRA_COVERAGE_DEADLINE,
        d.YB_ENHANCEMENT_DEADLINE = s.YB_ENHANCEMENT_DEADLINE,
        d.COVER_DTLS_PROVIDED = s.COVER_DTLS_PROVIDED,
        d.COVER_APPROVED = s.COVER_APPROVED,
        d.YB_CUTOUT_PAGES = s.YB_CUTOUT_PAGES,
        d.EXPRESS_FREIGHT = s.EXPRESS_FREIGHT,
        d.YB_TAPE_PLACEMENT = s.YB_TAPE_PLACEMENT,
        d.YB_SHIPPING_HANDLING = s.YB_SHIPPING_HANDLING,
        d.YB_SHIPPING_CHARGE = s.YB_SHIPPING_CHARGE,
        d.ods_modify_date = SYSDATE
, d.event_hold_status = s.event_hold_status
, d.event_hold_status_change_by = s.event_hold_status_change_by
, d.event_hold_status_date = s.event_hold_status_date
, d.proof_order_duedate = s.proof_order_duedate
             WHERE    DECODE (s.AUDIT_CREATE_DATE, d.AUDIT_CREATE_DATE, 1, 0) =
                      0
                   OR DECODE (s.AUDIT_CREATED_BY, d.AUDIT_CREATED_BY, 1, 0) =
                      0
                   OR DECODE (s.AUDIT_MODIFIED_BY, d.AUDIT_MODIFIED_BY, 1, 0) =
                      0
                   OR DECODE (s.AUDIT_MODIFY_DATE, d.AUDIT_MODIFY_DATE, 1, 0) =
                      0
                   OR DECODE (s.EXPECTED_SALES_AMT,
                              d.EXPECTED_SALES_AMT, 1,
                              0) =
                      0
                   OR DECODE (s.JOB_CLASSIFICATION_NAME,
                              d.JOB_CLASSIFICATION_NAME, 1,
                              0) =
                      0
                   OR DECODE (s.JOB_NBR, d.JOB_NBR, 1, 0) = 0
                   OR DECODE (s.LIFETOUCH_ID, d.LIFETOUCH_ID, 1, 0) = 0
                   OR DECODE (s.ACCOUNT_LT_PARTNER_KEY,
                              d.ACCOUNT_LT_PARTNER_KEY, 1,
                              0) =
                      0
                   OR DECODE (s.LT_ACCOUNT_PROGRAM_KEY,
                              d.LT_ACCOUNT_PROGRAM_KEY, 1,
                              0) =
                      0
                   OR DECODE (s.MARKETING_CODE, d.MARKETING_CODE, 1, 0) = 0
                   OR DECODE (s.ORDER_SALES_TAX_AMT,
                              d.ORDER_SALES_TAX_AMT, 1,
                              0) =
                      0
                   OR DECODE (s.PAID_ORDER_QTY, d.PAID_ORDER_QTY, 1, 0) = 0
                   OR DECODE (s.PHOTOGRAPHY_DATE, d.PHOTOGRAPHY_DATE, 1, 0) =
                      0
                   OR DECODE (s.PLANT_RECEIPT_DATE,
                              d.PLANT_RECEIPT_DATE, 1,
                              0) =
                      0
                   OR DECODE (s.PROCESSING_LAB, d.PROCESSING_LAB, 1, 0) = 0
                   OR DECODE (s.PROGRAM_NAME, d.PROGRAM_NAME, 1, 0) = 0
                   OR DECODE (s.SCHOOL_YEAR, d.SCHOOL_YEAR, 1, 0) = 0
                   OR DECODE (s.SELLING_METHOD_NAME,
                              d.SELLING_METHOD_NAME, 1,
                              0) =
                      0
                   OR DECODE (s.SHIP_DATE, d.SHIP_DATE, 1, 0) = 0
                   OR DECODE (s.SHIPPED_ORDER_QTY, d.SHIPPED_ORDER_QTY, 1, 0) =
                      0
                   OR DECODE (s.SOURCE_SYSTEM, d.SOURCE_SYSTEM, 1, 0) = 0
                   OR DECODE (s.STATUS, d.STATUS, 1, 0) = 0
                   OR DECODE (s.SUB_PROGRAM_NAME, d.SUB_PROGRAM_NAME, 1, 0) =
                      0
                   OR DECODE (s.TERRITORY_LT_PARTNER_KEY,
                              d.TERRITORY_LT_PARTNER_KEY, 1,
                              0) =
                      0
                   OR DECODE (s.TERRITORY_CODE, d.TERRITORY_CODE, 1, 0) = 0
                   OR DECODE (s.TRANSACTION_AMT, d.TRANSACTION_AMT, 1, 0) = 0
                   OR DECODE (s.UNPAID_ORDER_QTY, d.UNPAID_ORDER_QTY, 1, 0) =
                      0
                   OR DECODE (s.VISION_COMMIT_DATE,
                              d.VISION_COMMIT_DATE, 1,
                              0) =
                      0
                   OR DECODE (s.VISION_PHOTO_DATE_A,
                              d.VISION_PHOTO_DATE_A, 1,
                              0) =
                      0
                   OR DECODE (s.VISION_PHOTO_DATE_B,
                              d.VISION_PHOTO_DATE_B, 1,
                              0) =
                      0
                   OR DECODE (s.X_NO_PURCHASE_QTY, d.X_NO_PURCHASE_QTY, 1, 0) =
                      0
                   OR DECODE (s.EVENT_IMAGE_COMPLETE,
                              d.EVENT_IMAGE_COMPLETE, 1,
                              0) =
                      0
                   OR DECODE (s.AIR_ENABLED, d.AIR_ENABLED, 1, 0) = 0
                   OR DECODE (s.YB_COVERENDSHEET_DEADLINE,
                              d.YB_COVERENDSHEET_DEADLINE, 1,
                              0) =
                      0
                   OR DECODE (s.YB_COPIES, d.YB_COPIES, 1, 0) = 0
                   OR DECODE (s.YB_PAGES, d.YB_PAGES, 1, 0) = 0
                   OR DECODE (s.YB_FIRSTPAGE_DEADLINE,
                              d.YB_FIRSTPAGE_DEADLINE, 1,
                              0) =
                      0
                   OR DECODE (s.YB_FINALPAGE_DEADLINE,
                              d.YB_FINALPAGE_DEADLINE, 1,
                              0) =
                      0
                   OR DECODE (s.YB_ORDER_NO, d.YB_ORDER_NO, 1, 0) = 0
                   OR DECODE (s.EVENT_TYPE, d.EVENT_TYPE, 1, 0) = 0
                   OR DECODE (s.EVENT_SEQUENCE, d.EVENT_SEQUENCE, 1, 0) = 0
                   OR DECODE (s.YB_FINALIZED_DATE, d.YB_FINALIZED_DATE, 1, 0) =
                      0
                   OR DECODE (s.YB_COVERRECIEVED_DATE,
                              d.YB_COVERRECIEVED_DATE, 1,
                              0) =
                      0
                   OR DECODE (s.YB_ADDTNL_PAGE_DEADLINE1,
                              d.YB_ADDTNL_PAGE_DEADLINE1, 1,
                              0) =
                      0
                   OR DECODE (s.YB_ADDTNL_PAGE_DLINE1_PAGE_DUE,
                              d.YB_ADDTNL_PAGE_DLINE1_PAGE_DUE, 1,
                              0) =
                      0
                   OR DECODE (s.YB_ADDTNL_PAGE_DEADLINE2,
                              d.YB_ADDTNL_PAGE_DEADLINE2, 1,
                              0) =
                      0
                   OR DECODE (s.YB_ADDTNL_PAGE_DLINE2_PAGE_DUE,
                              d.YB_ADDTNL_PAGE_DLINE2_PAGE_DUE, 1,
                              0) =
                      0
                   OR DECODE (s.YB_ADDTNL_PAGE_DEADLINE3,
                              d.YB_ADDTNL_PAGE_DEADLINE3, 1,
                              0) =
                      0
                   OR DECODE (s.YB_ADDTNL_PAGE_DLINE3_PAGE_DUE,
                              d.YB_ADDTNL_PAGE_DLINE3_PAGE_DUE, 1,
                              0) =
                      0
                   OR DECODE (s.YB_EXTRA_COVER_DLINE_PAGE_DUE,
                              d.YB_EXTRA_COVER_DLINE_PAGE_DUE, 1,
                              0) =
                      0
                   OR DECODE (s.YB_FINAL_PAGE_DLINE_PAGES_DUE,
                              d.YB_FINAL_PAGE_DLINE_PAGES_DUE, 1,
                              0) =
                      0
                   OR DECODE (s.YB_FINAL_QUANTITY_DEADLINE,
                              d.YB_FINAL_QUANTITY_DEADLINE, 1,
                              0) =
                      0
                   OR DECODE (s.YB_EXTRA_COVERAGE_DEADLINE,
                              d.YB_EXTRA_COVERAGE_DEADLINE, 1,
                              0) =
                      0
                   OR DECODE (s.YB_ENHANCEMENT_DEADLINE,
                              d.YB_ENHANCEMENT_DEADLINE, 1,
                              0) =
                      0
                   OR DECODE (s.COVER_DTLS_PROVIDED,
                              d.COVER_DTLS_PROVIDED, 1,
                              0) =
                      0
                   OR DECODE (s.COVER_APPROVED, d.COVER_APPROVED, 1, 0) = 0
                   OR DECODE (s.YB_CUTOUT_PAGES, d.YB_CUTOUT_PAGES, 1, 0) = 0
                   OR DECODE (s.EXPRESS_FREIGHT, d.EXPRESS_FREIGHT, 1, 0) = 0
                   OR DECODE (s.YB_TAPE_PLACEMENT, d.YB_TAPE_PLACEMENT, 1, 0) =
                      0
                   OR DECODE (s.YB_SHIPPING_HANDLING,
                              d.YB_SHIPPING_HANDLING, 1,
                              0) =
                      0
                   OR DECODE (s.YB_SHIPPING_CHARGE,
                              d.YB_SHIPPING_CHARGE, 1,
                              0) =
                      0
or decode( d.event_hold_status , s.event_hold_status, 1, 0) = 0
or decode(d.event_hold_status_change_by , s.event_hold_status_change_by, 1, 0) = 0
or decode(d.event_hold_status_date , s.event_hold_status_date, 1, 0) = 0
or decode(d.proof_order_duedate , s.proof_order_duedate, 1, 0) = 0

&& /*-----------------------------------------------*/
/* TASK No. 8 */
/* update ods_own.event */



merge into ods_own.event t
using
(
select job_nbr as event_ref_id
, event_hold_status 
, event_hold_status_change_by 
, event_hold_status_date
, proof_order_duedate
from ods_stage.apocs_extended_event_stg
where ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap
) s
on ( s.event_ref_id = t.event_ref_id )
when matched then update
set t.event_hold_status = s.event_hold_status
, t.event_hold_status_change_by = s.event_hold_status_change_by
, t.event_hold_status_date = s.event_hold_status_date
, t.prf_order_due_date = s.proof_order_duedate
, t.ods_modify_date = sysdate
where decode( t.event_hold_status , s.event_hold_status, 1, 0) = 0
or decode(t.event_hold_status_change_by , s.event_hold_status_change_by, 1, 0) = 0
or decode(t.event_hold_status_date , s.event_hold_status_date, 1, 0) = 0
or decode(t.prf_order_due_date , s.proof_order_duedate, 1, 0) = 0

&& /*-----------------------------------------------*/
/* TASK No. 9 */
/* Update CDC Load Status */
/*
UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/



UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
+ nvl((TIMEZONE_OFFSET/24), 0) 
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

&& /*-----------------------------------------------*/
/* TASK No. 10 */
/* Insert CDC Audit Record */
/*
INSERT INTO RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
(TABLE_NAME,
SESS_NO,                      
SESS_NAME,                    
SCEN_VERSION,                 
SESS_BEG,                     
ORIG_LAST_CDC_COMPLETION_DATE,
OVERLAP,
CREATE_DATE,
CONTEXT_NAME              
)
values (
:v_cdc_load_table_name,
:v_sess_no,
'LOAD_EXTENDED_EVENT_STG_PKG',
'004',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/



INSERT INTO RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
(TABLE_NAME,
SESS_NO,                      
SESS_NAME,                    
SCEN_VERSION,                 
SESS_BEG,                     
ORIG_LAST_CDC_COMPLETION_DATE,
OVERLAP,
CREATE_DATE,
CONTEXT_NAME,
TIMEZONE_OFFSET              
)
select 
:v_cdc_load_table_name
,:v_sess_no
,'LOAD_EXTENDED_EVENT_STG_PKG'
,'004'
,TO_DATE(SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
,TO_DATE (SUBSTR(:v_cdc_load_date, 1, 19),'YYYY-MM-DD HH24:MI:SS')
,:v_cdc_overlap
,SYSDATE
,:v_env
,TIMEZONE_OFFSET
from 
ODS_OWN.ODS_CDC_LOAD_STATUS
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

&& /*-----------------------------------------------*/





&&