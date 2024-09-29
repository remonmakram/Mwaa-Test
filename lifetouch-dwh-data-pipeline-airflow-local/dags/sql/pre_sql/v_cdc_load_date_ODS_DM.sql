SELECT last_cdc_completion_date, 'date' as type
FROM ODS.DW_CDC_LOAD_STATUS
WHERE dw_table_name=:v_cdc_load_table_name