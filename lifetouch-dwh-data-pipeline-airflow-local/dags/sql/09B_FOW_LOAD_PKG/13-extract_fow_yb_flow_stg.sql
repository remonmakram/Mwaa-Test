select 
FLOW_ID,     
FLOW_NAME,    
BOOKING_YEAR, 
DATE_CREATED, 
CREATED_BY,   
LAST_UPDATED, 
UPDATED_BY,   
ACTIVE       
from <schema_name>.YB_FLOW
where last_updated >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap