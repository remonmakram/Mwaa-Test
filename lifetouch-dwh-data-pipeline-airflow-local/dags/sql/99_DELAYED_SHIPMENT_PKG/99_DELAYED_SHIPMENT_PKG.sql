/*-----------------------------------------------*/
/* TASK No. 11 */
/* Mark Trigger Processed */

update ODS_STAGE.data_export_trigger
set status = 'PROCESSED'
, processed_date = sysdate
where data_export_trigger_id = :v_data_export_trigger_table_id
