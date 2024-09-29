/******************************************  Ingestion Script Validations ******************************************
 * Check records are added to the airflow status table
 * check full load expriment as well
 * ******************************************************/

select count(*)
from ods_stage.air_asset_stg s
where ods_create_date > trunc(sysdate)
and not exists
(
select 1
from ods_own.air_asset t
where s.id = t.id
);


select count(*)
from ods_stage.AIR_CHECK_ME_STG s
where ods_create_date > trunc(sysdate)
and not exists
(
select 1
from ods_own.AIR_CHECK_ME t
where s.id = t.id
);


select count(*)
from ods_stage.AIR_IMAGE_GROUP_STG s
where ods_create_date > trunc(sysdate)
and not exists
(
select 1
from ods_own.AIR_IMAGE_GROUP t
where s.id = t.id
);


/* Check the watermark for the air tables */
SELECT max(cdc_completion_date),TABLE_NAME
                FROM ODS_OWN.AIRFLOW_PACKAGESTATS
                WHERE
                     SCHEMA_NAME = 'RAX_APP_USER'
                     and PROCESS_NAME LIKE  '%_AIR_%'
                     AND TABLE_NAME like 'AIR_%'
                    AND STEP = 'Cntrl'
                    AND completion_timestamp IS NOT NULL
                    GROUP BY TABLE_NAME
--                OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY
/*
                    MAX(CDC_COMPLETION_DATE)|TABLE_NAME                   |
------------------------+-----------------------------+
     2024-06-11 10:06:16|AIR_AF_ASSET_LND             |
     2024-06-11 10:06:52|AIR_AF_PHOTO_IMPORT_BATCH_LND|
     2024-06-11 10:06:53|AIR_AF_RECIPE_LND            |
     2024-06-11 10:06:21|AIR_AF_IMAGE_LND             |
     2024-06-11 10:07:04|AIR_AF_RETOUCH_REQUEST_LND   |
     2024-06-11 10:06:52|AIR_AF_TAG_LND               |
     2024-06-11 10:06:20|AIR_AF_ASSET_REQUEST_LND     |
     2024-06-11 10:06:43|AIR_AF_IMAGE_GROUP_LND       |
     2024-06-11 10:06:21|AIR_AF_CHECK_ME_LND          |
     */


 /* Check current sys date*/
SELECT SYSDATE FROM dual

 /* Check the columns to be updated*/
SELECT COLUMN_NAME, COLUMN_ID
            FROM ALL_TAB_COLS
            WHERE OWNER = 'ODS_STAGE'
             AND TABLE_NAME = 'AIR_ASSET_REQUEST_STG'
         AND COLUMN_NAME NOT IN ('ODS_CREATE_DATE', 'ODS_MODIFY_DATE', 'ASSET_REQUEST_BATCH_ID')
 ORDER BY COLUMN_ID


 /* Check that we have a new record added for the ingested data*/
 SELECT * FROM ODS_OWN.AIRFLOW_PACKAGESTATS
 WHERE PROCESS_NAME LIKE  '%_AIR_%'
 AND TABLE_NAME like 'AIR_%'
 AND SCHEMA_NAME = 'RAX_APP_USER'
 AND COMPLETION_TIMESTAMP > SYSDATE - INTERVAL '60' MINUTE
 ORDER BY COMPLETION_TIMESTAMP DESC


 /*check ingested tables are the same number*/
 SELECT count(DISTINCT TABLE_NAME),SCHEMA_NAME
 FROM ODS_OWN.AIRFLOW_PACKAGESTATS
 WHERE PROCESS_NAME LIKE  '%_AIR_%'
 AND TABLE_NAME like 'AIR_%'
 GROUP BY SCHEMA_NAME

 /* AIR_AF_ATTRIBUTE_LND and AIR_AF_ASSET_LND_TMP_PPA  not in the lf airflow dag so we can skip */


  /*check ingested tables are the same number*/
 SELECT DISTINCT TABLE_NAME,SCHEMA_NAME
 FROM ODS_OWN.AIRFLOW_PACKAGESTATS
 WHERE PROCESS_NAME LIKE  '%_AIR_%'
 AND TABLE_NAME like 'AIR_%' AND SCHEMA_NAME IN ('ODS_APP_USER','RAX_APP_USER')


 SELECT count(DISTINCT TABLE_NAME),SCHEMA_NAME
 FROM ODS_OWN.AIRFLOW_PACKAGESTATS
 WHERE PROCESS_NAME LIKE  '%_AIR_%'
 AND TABLE_NAME like 'AIR_%' AND SCHEMA_NAME IN ('ODS_APP_USER','RAX_APP_USER')
 GROUP BY SCHEMA_NAME

 /******************************************  Merge Script Validations ******************************************
 * Check the status table
 * ******************************************************/
 /* Check that we have a new record added for the ingested data*/
 SELECT * FROM ODS_OWN.AIRFLOW_PACKAGESTATS
 WHERE
-- PROCESS_NAME LIKE 'merge%' AND
  dag_id LIKE  'lt_53_air_dag'
 AND TABLE_NAME LIKE '%AIR%'
 AND SCHEMA_NAME = 'ODS_STAGE'
 AND COMPLETION_TIMESTAMP > SYSDATE - INTERVAL '60' MINUTE
 ORDER BY COMPLETION_TIMESTAMP DESC

  /******************************************  ODI Logic Execution ******************************************
 * Check the status table
 * ******************************************************/

  SELECT   *
 FROM RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT R_CDC
 WHERE TABLE_NAME LIKE '%AIR%'
--  AND CREATE_DATE > SYSDATE - INTERVAL '60' MINUTE
  AND (TABLE_NAME ='AIR_ASSET_REQUREST' OR SESS_NAME ='LOAD_AIR_ASSET_REQUEST_PKG')
  ORDER BY SESS_BEG  desc


 SELECT  sysdate, (O_CDC.LAST_CDC_COMPLETION_DATE-R_CDC.ORIG_LAST_CDC_COMPLETION_DATE ) * 1440 / 60 AS hrs_difference , (O_CDC.LAST_CDC_COMPLETION_DATE-R_CDC.ORIG_LAST_CDC_COMPLETION_DATE ) * 1440 AS minutes_difference ,R_CDC.*, O_CDC.LAST_CDC_COMPLETION_DATE
 FROM RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT R_CDC
 LEFT JOIN ods_own.ods_cdc_load_status O_CDC
 ON R_CDC.TABLE_NAME  = O_CDC.ODS_TABLE_NAME
 WHERE TABLE_NAME LIKE '%AIR%'
  AND CREATE_DATE > SYSDATE - INTERVAL '60' MINUTE


--  SELECT * FROM ods_own.ods_cdc_load_status
