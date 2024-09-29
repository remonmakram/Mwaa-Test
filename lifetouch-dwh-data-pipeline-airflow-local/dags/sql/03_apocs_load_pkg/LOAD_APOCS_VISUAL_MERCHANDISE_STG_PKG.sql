
MERGE INTO ODS_STAGE.APOCS_VISUAL_MERCHANDISE_STG t USING
(SELECT VM_ID
,AUDIT_CREATE_DATE  
,AUDIT_CREATED_BY 
,AUDIT_MODIFIED_BY 
,AUDIT_MODIFY_DATE 
,BUSINESS_KEY 
,LOCKID 
,REVISION_NO
,STATUS 
,VISUAL_MERCH_DESCRIPTION
,VISUAL_MERCH_NAME
,VISUAL_MERCH_PAYMENT_MODE
,USE_SUBJECT_IMAGES 
,CLICK_SELECTION 
,CAMERA_POSE_SET 
,CAMERA_POSE_SET_DESC
,CAMERA_PROGRAM_CODE  
,CAMERA_TYPE
,EXTEND_PRE_PICTURE_DAY_PRICING 
,PHOTOGRAPH_NON_BUYERS 
,PREPAY_PAY_ONLY_ON_MLT   
FROM RAX_APP_USER.APOCS_VISUAL_MERCHANDISE_STG
) s
ON (t.vm_id = s.vm_id)
WHEN NOT MATCHED
THEN INSERT
(VM_ID
,AUDIT_CREATE_DATE  
,AUDIT_CREATED_BY 
,AUDIT_MODIFIED_BY 
,AUDIT_MODIFY_DATE 
,BUSINESS_KEY 
,LOCKID 
,REVISION_NO
,STATUS 
,VISUAL_MERCH_DESCRIPTION
,VISUAL_MERCH_NAME
,VISUAL_MERCH_PAYMENT_MODE
,USE_SUBJECT_IMAGES 
,CLICK_SELECTION 
,CAMERA_POSE_SET 
,CAMERA_POSE_SET_DESC
,CAMERA_PROGRAM_CODE  
,CAMERA_TYPE
,EXTEND_PRE_PICTURE_DAY_PRICING 
,PHOTOGRAPH_NON_BUYERS 
,PREPAY_PAY_ONLY_ON_MLT   
,ods_modify_date
)
VALUES
(s.VM_ID
,s.AUDIT_CREATE_DATE  
,s.AUDIT_CREATED_BY 
,s.AUDIT_MODIFIED_BY 
,s.AUDIT_MODIFY_DATE 
,s.BUSINESS_KEY 
,s.LOCKID 
,s.REVISION_NO
,s.STATUS 
,s.VISUAL_MERCH_DESCRIPTION
,s.VISUAL_MERCH_NAME
,s.VISUAL_MERCH_PAYMENT_MODE
,s.USE_SUBJECT_IMAGES 
,s.CLICK_SELECTION 
,s.CAMERA_POSE_SET 
,s.CAMERA_POSE_SET_DESC
,s.CAMERA_PROGRAM_CODE  
,s.CAMERA_TYPE
,s.EXTEND_PRE_PICTURE_DAY_PRICING 
,s.PHOTOGRAPH_NON_BUYERS 
,s.PREPAY_PAY_ONLY_ON_MLT  
,sysdate
)
WHEN MATCHED
THEN UPDATE SET
 t.audit_create_date = s.AUDIT_CREATE_DATE
,t.audit_created_by = s.AUDIT_CREATED_BY
,t.audit_modified_by = s.AUDIT_MODIFIED_BY
,t.audit_modify_date = s.AUDIT_MODIFY_DATE
,t.business_key = s.BUSINESS_KEY
,t.lockid = s.LOCKID 
,t.revision_no = s.REVISION_NO
,t.status = s.STATUS 
,t.visual_merch_description = s.VISUAL_MERCH_DESCRIPTION
,t.visual_merch_name = s.VISUAL_MERCH_NAME
,t.visual_merch_payment_mode = s.VISUAL_MERCH_PAYMENT_MODE
,t.use_subject_images = s.USE_SUBJECT_IMAGES 
,t.click_selection = s.CLICK_SELECTION 
,t.camera_pose_set = s.CAMERA_POSE_SET 
,t.camera_pose_set_desc = s.CAMERA_POSE_SET_DESC
,t.camera_program_code = s.CAMERA_PROGRAM_CODE  
,t.camera_type = s.CAMERA_TYPE
,t.extend_pre_picture_day_pricing = s.EXTEND_PRE_PICTURE_DAY_PRICING 
,t.photograph_non_buyers = s.PHOTOGRAPH_NON_BUYERS 
,t.prepay_pay_only_on_mlt = s.PREPAY_PAY_ONLY_ON_MLT  
,t.ods_modify_date = sysdate
where decode(t.audit_create_date , s.AUDIT_CREATE_DATE, 1, 0) = 0
or decode(t.audit_created_by , s.AUDIT_CREATED_BY, 1, 0) = 0
or decode(t.audit_modified_by , s.AUDIT_MODIFIED_BY, 1, 0) = 0
or decode(t.business_key , s.BUSINESS_KEY, 1, 0) = 0
or decode(t.lockid , s.LOCKID , 1, 0) = 0
or decode(t.revision_no , s.REVISION_NO, 1, 0) = 0
or decode(t.status , s.STATUS , 1, 0) = 0
or decode(t.visual_merch_description , s.VISUAL_MERCH_DESCRIPTION, 1, 0) = 0
or decode(t.visual_merch_name , s.VISUAL_MERCH_NAME, 1, 0) = 0
or decode(t.visual_merch_payment_mode , s.VISUAL_MERCH_PAYMENT_MODE, 1, 0) = 0
or decode(t.use_subject_images , s.USE_SUBJECT_IMAGES , 1, 0) = 0
or decode(t.click_selection , s.CLICK_SELECTION , 1, 0) = 0
or decode(t.camera_pose_set , s.CAMERA_POSE_SET , 1, 0) = 0
or decode(t.camera_pose_set_desc , s.CAMERA_POSE_SET_DESC, 1, 0) = 0
or decode(t.camera_program_code , s.CAMERA_PROGRAM_CODE  , 1, 0) = 0
or decode(t.camera_type , s.CAMERA_TYPE, 1, 0) = 0
or decode(t.extend_pre_picture_day_pricing , s.EXTEND_PRE_PICTURE_DAY_PRICING, 1, 0) = 0 
or decode(t.photograph_non_buyers , s.PHOTOGRAPH_NON_BUYERS , 1, 0) = 0
or decode(t.prepay_pay_only_on_mlt , s.PREPAY_PAY_ONLY_ON_MLT , 1, 0) = 0

&& /*-----------------------------------------------*/
/* TASK No. 8 */
/* Merge ODS_OWN */



merge into ods_own.visual_merch t using
(
select business_key
,USE_SUBJECT_IMAGES
,CLICK_SELECTION
,CAMERA_POSE_SET
,CAMERA_POSE_SET_DESC
,CAMERA_PROGRAM_CODE
,CAMERA_TYPE
,EXTEND_PRE_PICTURE_DAY_PRICING
,PHOTOGRAPH_NON_BUYERS
,PREPAY_PAY_ONLY_ON_MLT
from ods_stage.apocs_visual_merchandise_stg
where ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - 1
) s
on ( s.business_key = t.visual_merch_id )
when matched then update
set t.USE_SUBJECT_IMAGES = s.USE_SUBJECT_IMAGES
,t.CLICK_SELECTION = s.CLICK_SELECTION
,t.CAMERA_POSE_SET = s.CAMERA_POSE_SET
,t.CAMERA_POSE_SET_DESC = s.CAMERA_POSE_SET_DESC
,t.CAMERA_PROGRAM_CODE = s.CAMERA_PROGRAM_CODE
,t.CAMERA_TYPE = s.CAMERA_TYPE
,t.EXTEND_PRE_PICTURE_DAY_PRICING = s.EXTEND_PRE_PICTURE_DAY_PRICING
,t.PHOTOGRAPH_NON_BUYERS = s.PHOTOGRAPH_NON_BUYERS
,t.PREPAY_PAY_ONLY_ON_MLT = s.PREPAY_PAY_ONLY_ON_MLT
,t.ods_modify_date = sysdate
where decode(t.USE_SUBJECT_IMAGES , s.USE_SUBJECT_IMAGES, 1, 0) = 0
or decode(t.CLICK_SELECTION , s.CLICK_SELECTION, 1, 0) = 0
or decode(t.CAMERA_POSE_SET , s.CAMERA_POSE_SET, 1, 0) = 0
or decode(t.CAMERA_POSE_SET_DESC , s.CAMERA_POSE_SET_DESC, 1, 0) = 0
or decode(t.CAMERA_PROGRAM_CODE , s.CAMERA_PROGRAM_CODE, 1, 0) = 0
or decode(t.CAMERA_TYPE , s.CAMERA_TYPE, 1, 0) = 0
or decode(t.EXTEND_PRE_PICTURE_DAY_PRICING , s.EXTEND_PRE_PICTURE_DAY_PRICING, 1, 0) = 0
or decode(t.PHOTOGRAPH_NON_BUYERS , s.PHOTOGRAPH_NON_BUYERS, 1, 0) = 0
or decode(t.PREPAY_PAY_ONLY_ON_MLT , s.PREPAY_PAY_ONLY_ON_MLT, 1, 0) = 0

&& /*-----------------------------------------------*/
/* TASK No. 9 */
/* Merge ODS_OWN CDC2 */



merge into ods_own.visual_merch t using
(
select a.business_key
,a.USE_SUBJECT_IMAGES
,a.CLICK_SELECTION
,a.CAMERA_POSE_SET
,a.CAMERA_POSE_SET_DESC
,a.CAMERA_PROGRAM_CODE
,a.CAMERA_TYPE
,a.EXTEND_PRE_PICTURE_DAY_PRICING
,a.PHOTOGRAPH_NON_BUYERS
,a.PREPAY_PAY_ONLY_ON_MLT
from ods_stage.apocs_visual_merchandise_stg a
, ods_own.visual_merch b
where a.business_key = b.visual_merch_id
and b.ods_create_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - 1
) s
on ( s.business_key = t.visual_merch_id )
when matched then update
set t.USE_SUBJECT_IMAGES = s.USE_SUBJECT_IMAGES
,t.CLICK_SELECTION = s.CLICK_SELECTION
,t.CAMERA_POSE_SET = s.CAMERA_POSE_SET
,t.CAMERA_POSE_SET_DESC = s.CAMERA_POSE_SET_DESC
,t.CAMERA_PROGRAM_CODE = s.CAMERA_PROGRAM_CODE
,t.CAMERA_TYPE = s.CAMERA_TYPE
,t.EXTEND_PRE_PICTURE_DAY_PRICING = s.EXTEND_PRE_PICTURE_DAY_PRICING
,t.PHOTOGRAPH_NON_BUYERS = s.PHOTOGRAPH_NON_BUYERS
,t.PREPAY_PAY_ONLY_ON_MLT = s.PREPAY_PAY_ONLY_ON_MLT
,t.ods_modify_date = sysdate
where decode(t.USE_SUBJECT_IMAGES , s.USE_SUBJECT_IMAGES, 1, 0) = 0
or decode(t.CLICK_SELECTION , s.CLICK_SELECTION, 1, 0) = 0
or decode(t.CAMERA_POSE_SET , s.CAMERA_POSE_SET, 1, 0) = 0
or decode(t.CAMERA_POSE_SET_DESC , s.CAMERA_POSE_SET_DESC, 1, 0) = 0
or decode(t.CAMERA_PROGRAM_CODE , s.CAMERA_PROGRAM_CODE, 1, 0) = 0
or decode(t.CAMERA_TYPE , s.CAMERA_TYPE, 1, 0) = 0
or decode(t.EXTEND_PRE_PICTURE_DAY_PRICING , s.EXTEND_PRE_PICTURE_DAY_PRICING, 1, 0) = 0
or decode(t.PHOTOGRAPH_NON_BUYERS , s.PHOTOGRAPH_NON_BUYERS, 1, 0) = 0
or decode(t.PREPAY_PAY_ONLY_ON_MLT , s.PREPAY_PAY_ONLY_ON_MLT, 1, 0) = 0

&& /*-----------------------------------------------*/
/* TASK No. 10 */
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
/* TASK No. 11 */
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
'LOAD_APOCS_VISUAL_MERCHANDISE_STG_PKG',
'001',
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
,'LOAD_APOCS_VISUAL_MERCHANDISE_STG_PKG'
,'001'
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