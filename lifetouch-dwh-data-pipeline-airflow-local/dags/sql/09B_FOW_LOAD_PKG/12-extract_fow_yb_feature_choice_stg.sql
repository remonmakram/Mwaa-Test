select 
FEATURE_ID,      
CHOICE_ID,       
FLOW_FILTER_ID,  
FEATURE_SEQUENCE,
FOW_CONFIGURABLE,
BOOKING_YEAR,    
DATE_CREATED ,   
CREATED_BY,      
LAST_UPDATED,    
UPDATED_BY              
from <schema_name>.YB_FEATURE_CHOICE
where last_updated >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap