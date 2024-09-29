SELECT TO_CHAR(last_cdc_completion_date, 'YYYYMMDD'), 'date' as type
FROM ods_own.ods_cdc_load_status
WHERE ods_table_name= :v_cdc_load_table_name