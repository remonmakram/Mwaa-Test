select ID 
,APO_ID    
,COMMENTS    
,CREATED_BY  
,DATE_CREATED 
,FILE_NAME  
,LAST_UPDATED 
,STATUS       
,UPDATED_BY   
,EVENT_ID    
from <schema_name>.names_file
where last_updated >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap