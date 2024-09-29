SELECT       LAYOUT_GROUP_ID                 
,AUDIT_CREATE_DATE            
,AUDIT_CREATED_BY               
,AUDIT_MODIFIED_BY             
,AUDIT_MODIFY_DATE            
,BUSINESS_KEY                   
,LAYOUTGROUPPREPICDAYSEQNO         
,LAYOUTID                          
,LOCKID                       
,PARENT_LAYOUTID                 
,TYPE                             
,VM_ID                        
,LAYOUTGROUPPOSTPICDAYSEQNO     
,PRERENDERING_CACHE_DAYS  
  FROM <schema_name>.LAYOUT_GROUP
 WHERE AUDIT_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - 1