select 
  CHOICE_ID,     
  CHOICE_NAME,   
  ITEM_ID,       
  TAG_ID,        
  PAGES ,        
  SCHOOL_PRICING,
  DATE_CREATED , 
  CREATED_BY ,   
  LAST_UPDATED,  
  UPDATED_BY,    
  ACTIVE               
from <schema_name>.YB_CHOICE
where last_updated >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap