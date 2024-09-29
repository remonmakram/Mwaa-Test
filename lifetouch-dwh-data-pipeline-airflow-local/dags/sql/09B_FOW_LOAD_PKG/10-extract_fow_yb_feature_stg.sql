select 
FEATURE_ID,         
FEATURE_NAME,       
FOR_FLOW_ID,        
BOOKING_YEAR,       
FEATURE_TYPE,       
FEATURE_CATEGORY,   
UPDATE_CUTOFF_EVENT,
DATE_CREATED,       
CREATED_BY,         
LAST_UPDATED,       
UPDATED_BY,         
ACTIVE               
from <schema_name>.YB_FEATURE
where last_updated >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap