
MERGE INTO ODS_STAGE.APOCS_AUTO_ADD_STG t USING
(SELECT AUTO_ADD_ID       
,AUDIT_CREATE_DATE
,AUDIT_CREATED_BY  
,AUDIT_MODIFIED_BY   
,AUDIT_MODIFY_DATE  
,BUSINESS_KEY   
,ADD_TO_ORDER_TYPE   
,ADDED_ON_EVENT    
,DISCOUNT_PERCENT   
,ITEM_DESC   
,ITEMID      
,LOCKID       
,LOOK_NO   
,VM_ID      
,ENABLE      
,QUANTITY   
,APO_OVERRIDE_KEY  
,FULFILLMENT_TYPE   
FROM RAX_APP_USER.APOCS_AUTO_ADD_STG
) s
ON (t.auto_add_id = s.auto_add_id)
WHEN NOT MATCHED
THEN INSERT
(AUTO_ADD_ID       
,AUDIT_CREATE_DATE
,AUDIT_CREATED_BY  
,AUDIT_MODIFIED_BY   
,AUDIT_MODIFY_DATE  
,BUSINESS_KEY   
,ADD_TO_ORDER_TYPE   
,ADDED_ON_EVENT    
,DISCOUNT_PERCENT   
,ITEM_DESC   
,ITEMID      
,LOCKID       
,LOOK_NO   
,VM_ID      
,ENABLE      
,QUANTITY   
,APO_OVERRIDE_KEY  
,FULFILLMENT_TYPE    
,ods_modify_date
)
VALUES
(s.AUTO_ADD_ID       
,s.AUDIT_CREATE_DATE
,s.AUDIT_CREATED_BY  
,s.AUDIT_MODIFIED_BY   
,s.AUDIT_MODIFY_DATE  
,s.BUSINESS_KEY   
,s.ADD_TO_ORDER_TYPE   
,s.ADDED_ON_EVENT    
,s.DISCOUNT_PERCENT   
,s.ITEM_DESC   
,s.ITEMID      
,s.LOCKID       
,s.LOOK_NO   
,s.VM_ID      
,s.ENABLE      
,s.QUANTITY   
,s.APO_OVERRIDE_KEY  
,s.FULFILLMENT_TYPE   
,sysdate
)
WHEN MATCHED
THEN UPDATE SET
 t.audit_create_date = s.AUDIT_CREATE_DATE
,t.audit_created_by = s.AUDIT_CREATED_BY
,t.audit_modified_by = s.AUDIT_MODIFIED_BY
,t.audit_modify_date = s.AUDIT_MODIFY_DATE
,t.business_key = s.BUSINESS_KEY
,t.add_to_order_type = s.ADD_TO_ORDER_TYPE   
,t.added_on_event = s.ADDED_ON_EVENT    
,t.discount_percent = s.DISCOUNT_PERCENT   
,t.item_desc = s.ITEM_DESC   
,t.itemid = s.ITEMID      
,t.lockid = s.LOCKID       
,t.look_no = s.LOOK_NO   
,t.vm_id = s.VM_ID      
,t.enable = s.ENABLE      
,t.quantity = s.QUANTITY   
,t.apo_override_key = s.APO_OVERRIDE_KEY  
,t.fulfillment_type = s.FULFILLMENT_TYPE   
,t.ods_modify_date = sysdate
where decode(t.audit_create_date , s.AUDIT_CREATE_DATE, 1, 0) = 0
or decode(t.audit_created_by , s.AUDIT_CREATED_BY, 1, 0) = 0
or decode(t.audit_modified_by , s.AUDIT_MODIFIED_BY, 1, 0) = 0
or decode(t.business_key , s.BUSINESS_KEY, 1, 0) = 0
or decode(t.add_to_order_type , s.ADD_TO_ORDER_TYPE , 1, 0) = 0   
or decode(t.added_on_event , s.ADDED_ON_EVENT , 1, 0) = 0    
or decode(t.discount_percent , s.DISCOUNT_PERCENT , 1, 0) = 0   
or decode(t.item_desc , s.ITEM_DESC , 1, 0) = 0   
or decode(t.itemid,s.ITEMID , 1, 0) = 0      
or decode(t.lockid , s.LOCKID , 1, 0) = 0       
or decode(t.look_no , s.LOOK_NO , 1, 0) = 0   
or decode(t.vm_id , s.VM_ID , 1, 0) = 0      
or decode(t.enable , s.ENABLE , 1, 0) = 0      
or decode(t.quantity , s.QUANTITY , 1, 0) = 0   
or decode(t.apo_override_key , s.APO_OVERRIDE_KEY , 1, 0) = 0  
or decode(t.fulfillment_type , s.FULFILLMENT_TYPE    , 1, 0) = 0

&& /*-----------------------------------------------*/
/* TASK No. 8 */
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
/* TASK No. 9 */
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
'LOAD_APOCS_AUTO_ADD_STG_PKG',
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
,'LOAD_APOCS_AUTO_ADD_STG_PKG'
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