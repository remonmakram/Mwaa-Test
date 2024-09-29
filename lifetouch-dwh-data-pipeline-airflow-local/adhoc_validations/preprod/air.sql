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
where s.id = t.id AND ods_create_date > trunc(sysdate)
);


select count(*)
from ods_stage.AIR_CHECK_ME_STG s
where ods_create_date > trunc(sysdate)
and not exists
(
select 1
from ods_own.AIR_CHECK_ME t
where s.id = t.id AND ods_create_date > trunc(sysdate)
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


  SELECT * FROM ODS_STAGE.AIR_IMAGE_GROUP_XR
  ORDER BY ODS_MODIFY_DATE  DESC FETCH FIRST 10 ROWS ONLY

--  IMAGE_GROUP_OID|ID                                  |ASSET_ID                            |ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
-----------------+------------------------------------+------------------------------------+-------------------+-------------------+
--        9152867|332c0525-d224-4263-a531-3bb761b97bb3|114d9756-4c9c-4a10-84ca-77cc7d7d86cb|2024-09-17 05:21:01|2024-09-17 05:21:01|
--        9152876|c34f2a2a-035d-41eb-b7f1-96b810cd32e1|4ad17331-54d0-4976-99b7-d855e7fe22fe|2024-09-17 05:21:01|2024-09-17 05:21:01|
--        9152875|8405dab8-a493-4099-933e-76ae3bb26bf6|5bc6d977-6b44-40b9-90a3-b5d4ec0b0b7e|2024-09-17 05:21:01|2024-09-17 05:21:01|
--        9152874|7d9ba7ab-48eb-4412-a6a9-02d70795e96b|039c5ce8-e4cd-4d0c-a692-7df9b639fd81|2024-09-17 05:21:01|2024-09-17 05:21:01|
--        9152873|671f9d44-3360-4dcc-907a-64ac5569c92e|5bc6d977-6b44-40b9-90a3-b5d4ec0b0b7e|2024-09-17 05:21:01|2024-09-17 05:21:01|
--        9152872|d7d0b961-ef1f-4216-aa2b-ee5dcb5e0a8a|7c0f723a-a997-477f-a871-1b484c00783d|2024-09-17 05:21:01|2024-09-17 05:21:01|
--        9152871|7a2b64b2-bdd8-4c53-b6e6-b4060cce9007|7c0f723a-a997-477f-a871-1b484c00783d|2024-09-17 05:21:01|2024-09-17 05:21:01|
--        9152870|ffa491fb-dbef-4224-9215-bba984d822f6|a6fb02aa-71ed-4ee1-9076-899259c412cb|2024-09-17 05:21:01|2024-09-17 05:21:01|
--        9152869|b085b548-90cc-4d71-9745-77c25c1a2e92|a6fb02aa-71ed-4ee1-9076-899259c412cb|2024-09-17 05:21:01|2024-09-17 05:21:01|
--        9152868|85af507b-9a11-49a6-b9a5-f460a53449d7|114d9756-4c9c-4a10-84ca-77cc7d7d86cb|2024-09-17 05:21:01|2024-09-17 05:21:01|



  SELECT * FROM ODS_STAGE.AIR_IMAGE_GROUP_XR  WHERE ID = '332c0525-d224-4263-a531-3bb761b97bb3'

--  IMAGE_GROUP_OID|ID                                  |ASSET_ID                            |ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
-----------------+------------------------------------+------------------------------------+-------------------+-------------------+
--        9152867|332c0525-d224-4263-a531-3bb761b97bb3|114d9756-4c9c-4a10-84ca-77cc7d7d86cb|2024-09-17 05:21:01|2024-09-17 05:21:01|

DELETE FROM ODS_STAGE.AIR_IMAGE_GROUP_XR  WHERE ID = '332c0525-d224-4263-a531-3bb761b97bb3'


UPDATE ods_own.ods_cdc_load_status
SET last_cdc_completion_date = TO_DATE(SUBSTR('2024-09-15 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
WHERE ods_table_name= 'AIR_IMAGE_MODIFY_DATE'

-- run the dag

SELECT * FROM ODS_STAGE.AIR_IMAGE_GROUP_XR  WHERE ID = '332c0525-d224-4263-a531-3bb761b97bb3'
--IMAGE_GROUP_OID|ID                                  |ASSET_ID                            |ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
-----------------+------------------------------------+------------------------------------+-------------------+-------------------+
--        9156417|332c0525-d224-4263-a531-3bb761b97bb3|114d9756-4c9c-4a10-84ca-77cc7d7d86cb|2024-09-17 06:06:18|2024-09-17 06:06:18|