--mv /ora01/odi/data/:v_rnet_file_name_split4  /dw_export/PROD/finance/Reconnet/:v_rnet_file_name_split4

--mv /ora01/odi/data/:v_rnet_file_name_split4  /dw_export/PROD/finance/Reconnet/:v_rnet_file_name_split4

/*-----------------------------------------------*/
/* TASK No. 52 */
/* Increment CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
--SET LAST_CDC_COMPLETION_DATE=TO_DATE(:v_rnet_load_date,'YYYYMMDD') + 1
SET LAST_CDC_COMPLETION_DATE=CAST(TO_TIMESTAMP(:v_rnet_load_date, 'YYYY-MM-DD HH24:MI:SS.FF3') + INTERVAL '1' DAY AS DATE)
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name

&
