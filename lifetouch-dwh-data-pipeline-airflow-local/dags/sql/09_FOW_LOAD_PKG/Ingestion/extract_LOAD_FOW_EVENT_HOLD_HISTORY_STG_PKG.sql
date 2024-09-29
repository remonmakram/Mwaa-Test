select ID
, VERSION
, APO_ID
, EVENT_ID
, HOLD_STATUS
, HOLD_REASON
, CREATED_BY
, DATE_CREATED
from <schema_name>.event_hold_history
where date_created >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap
