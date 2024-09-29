/******************************************  Ingestion Script Validations ******************************************
 * Check records are added to the airflow status table
 * check full load expriment as well
 * ******************************************************/

/* Check the watermark for the air tables */
SELECT max(cdc_completion_date),TABLE_NAME
                FROM ODS_OWN.AIRFLOW_PACKAGESTATS
                WHERE
                     SCHEMA_NAME = 'RAX_APP_USER'
                     and PROCESS_NAME LIKE  '%_MIP_%'
                     AND TABLE_NAME like 'MIP_%'
                    AND STEP = 'Cntrl'
                    AND completion_timestamp IS NOT NULL
                    GROUP BY TABLE_NAME
--                OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY
--MAX(CDC_COMPLETION_DATE)|TABLE_NAME                 |
--------------------------+---------------------------+
--     2024-07-29 09:40:56|MIP_AF_CUSTOMER_ORDER_LND  |
--     2024-07-29 09:40:59|MIP_AF_SFLY_INTEGRATION_LND|


 /* Check current sys date*/
SELECT SYSDATE FROM dual


 /* Check that we have a new record added for the ingested data*/
 SELECT * FROM ODS_OWN.AIRFLOW_PACKAGESTATS
 WHERE PROCESS_NAME LIKE  '%_MIP_%'
 AND TABLE_NAME like 'MIP_%'
 AND SCHEMA_NAME = 'RAX_APP_USER'
 AND COMPLETION_TIMESTAMP > SYSDATE - INTERVAL '120' MINUTE
 ORDER BY COMPLETION_TIMESTAMP DESC


 /*check ingested tables are the same number*/
 SELECT count(DISTINCT TABLE_NAME),SCHEMA_NAME
 FROM ODS_OWN.AIRFLOW_PACKAGESTATS
 WHERE PROCESS_NAME LIKE  '%_MIP_%'
 AND TABLE_NAME like 'MIP_%'
 GROUP BY SCHEMA_NAME

 /* AIR_AF_ATTRIBUTE_LND and AIR_AF_ASSET_LND_TMP_PPA  not in the lf airflow dag so we can skip */


  /*check ingested tables are the same number*/
 SELECT DISTINCT TABLE_NAME,SCHEMA_NAME
 FROM ODS_OWN.AIRFLOW_PACKAGESTATS
 WHERE PROCESS_NAME LIKE  '%_MIP_%'
 AND TABLE_NAME like 'MIP_%' AND SCHEMA_NAME IN ('ODS_APP_USER','RAX_APP_USER')


 /******************************************  Merge Script Validations ******************************************
 * Check the status table
 * ******************************************************/
 /* Check that we have a new record added for the ingested data*/
 SELECT * FROM ODS_OWN.AIRFLOW_PACKAGESTATS
 WHERE
-- PROCESS_NAME LIKE 'merge%' AND
  dag_id LIKE  'lt_26_mip_dag'
 AND TABLE_NAME LIKE '%MIP%'
 AND SCHEMA_NAME = 'ODS_STAGE'
 AND COMPLETION_TIMESTAMP > SYSDATE - INTERVAL '120' MINUTE
 ORDER BY COMPLETION_TIMESTAMP DESC


-- PACKAGE_STATS_SK|PROCESS_NAME                                      |SCHEMA_NAME|TABLE_NAME              |STEP |DAG_ID       |START_TIMESTAMP    |COMPLETION_TIMESTAMP|CDC_COMPLETION_DATE|ROWS_INSERTED|ROWS_UPDATED|ROWS_DELETED|
------------------+--------------------------------------------------+-----------+------------------------+-----+-------------+-------------------+--------------------+-------------------+-------------+------------+------------+
--         2425336|MIP_Ingestion.merge_ODS_STAGE_SFLY_INTEGRATION_STG|ODS_STAGE  |MIP_SFLY_INTEGRATION_STG|Cntrl|lt_26_mip_dag|2024-07-29 04:57:07| 2024-07-29 04:57:10|2024-07-29 04:57:07|            2|           0|           0|
--         2425335|MIP_Ingestion.merge_ODS_STAGE_CUSTOMER_ORDER_STG  |ODS_STAGE  |MIP_CUSTOMER_ORDER_STG  |Cntrl|lt_26_mip_dag|2024-07-29 04:57:06| 2024-07-29 04:57:09|2024-07-29 04:57:06|            1|           0|           0|

--Expected TO see 2 NEW records IN ods_own.mip_sfly_integration AND 1 NEW RECORD IN ods_own.mip_customer_order
  /******************************************  ODI Logic Execution ******************************************
 * Check the status table
 * ******************************************************/

  SELECT   *
 FROM RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT R_CDC
 WHERE TABLE_NAME LIKE '%MIP%'
  AND CREATE_DATE > SYSDATE - INTERVAL '60' MINUTE
  AND (TABLE_NAME ='MIP_SFLY_INTEGRATION' OR TABLE_NAME ='MIP_CUSTOMER_ORDER')


 SELECT   (O_CDC.LAST_CDC_COMPLETION_DATE-R_CDC.ORIG_LAST_CDC_COMPLETION_DATE ) * 1440 AS minutes_difference ,R_CDC.*, O_CDC.LAST_CDC_COMPLETION_DATE
 FROM RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT R_CDC
 LEFT JOIN ods_own.ods_cdc_load_status O_CDC
 ON R_CDC.TABLE_NAME  = O_CDC.ODS_TABLE_NAME
 WHERE TABLE_NAME LIKE '%MIP%'
  AND CREATE_DATE > SYSDATE - INTERVAL '60' MINUTE



/*------------------------------ Data Validation -----------------------------------------------*/
select count(*)
from ods_stage.mip_customer_order_stg s
where ods_create_date > trunc(sysdate)
and not exists
(
select 1
from ods_own.mip_customer_order t
where s.CUSTOMER_ORDER_ID = t.CUSTOMER_ORDER_ID
);

select count(*)
from ods_stage.mip_customer_order_stg s
where ods_create_date > trunc(sysdate)
and not exists
(
select 1
from ODS_STAGE.mip_customer_order_xr t
where s.CUSTOMER_ORDER_ID = t.CUSTOMER_ORDER_ID
);


select count(*)
from ods_stage.mip_sfly_integration_stg s
where ods_create_date > trunc(sysdate)
and not exists
(
select 1
from ods_own.mip_sfly_integration t
where s.SFLY_INTEGRATION_ID = t.SFLY_INTEGRATION_ID
);


select count(*)
from ods_stage.mip_sfly_integration_stg s
where ods_create_date > trunc(sysdate)
and not exists
(
select 1
from ods_stage.mip_sfly_integration_xr t
where s.SFLY_INTEGRATION_ID = t.SFLY_INTEGRATION_ID
);

--Expected TO see 2 NEW records IN ods_own.mip_sfly_integration AND 1 NEW RECORD IN ods_own.mip_customer_order

SELECT * FROM ods_stage.mip_sfly_integration_stg WHERE ODS_MODIFY_DATE > SYSDATE - INTERVAL '30' MINUTE

--SFLY_INTEGRATION_ID|CUSTOMER_ORDER_ID|IMAGE_RENDER_ASSET_ID|TRANSACTION_ID                      |TYPE    |S3_BUCKET                                         |S3_KEY                                                                                             |AUDIT_CREATE_DATE  |AUDIT_MODIFIED_DATE|VERSION|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
---------------------+-----------------+---------------------+------------------------------------+--------+--------------------------------------------------+---------------------------------------------------------------------------------------------------+-------------------+-------------------+-------+-------------------+-------------------+
--           10020925|          4688208|             13876456|5266e81e-29d8-48d1-9bd5-185c090f3492|image   |lifetouch.shared.shutterfly.holdingbin.qa         |15FE754D-1FD9-42A5-A6B4-3E7A8CD6F9FF/LNSS/5266e81e-29d8-48d1-9bd5-185c090f3492/XXJHKV77-101073.jpeg|2024-07-29 09:42:26|2024-07-29 09:42:26|      0|2024-07-29 04:57:09|2024-07-29 04:57:09|
--           10020926|          4688208|                     |5266e81e-29d8-48d1-9bd5-185c090f3492|metadata|lifetouch.shared.shutterfly.holdingbin.metadata.qa|15FE754D-1FD9-42A5-A6B4-3E7A8CD6F9FF/LNSS/5266e81e-29d8-48d1-9bd5-185c090f3492/01:3HN6Z6.metadata  |2024-07-29 09:42:26|2024-07-29 09:42:26|      0|2024-07-29 04:57:09|2024-07-29 04:57:09|

SELECT * FROM ods_own.mip_sfly_integration
ORDER BY ODS_MODIFY_DATE desc

--MIP_SFLY_INTEGRATION_OID|MIP_CUSTOMER_ORDER_OID|SFLY_INTEGRATION_ID|CUSTOMER_ORDER_ID|IMAGE_RENDER_ASSET_ID|TRANSACTION_ID                      |TYPE    |S3_BUCKET                                         |S3_KEY                                                                                             |AUDIT_CREATE_DATE  |AUDIT_MODIFIED_DATE|VERSION|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |SOURCE_SYSTEM_OID|
--------------------------+----------------------+-------------------+-----------------+---------------------+------------------------------------+--------+--------------------------------------------------+---------------------------------------------------------------------------------------------------+-------------------+-------------------+-------+-------------------+-------------------+-----------------+
--                 9019986|               3382664|           10020926|          4688208|                     |5266e81e-29d8-48d1-9bd5-185c090f3492|metadata|lifetouch.shared.shutterfly.holdingbin.metadata.qa|15FE754D-1FD9-42A5-A6B4-3E7A8CD6F9FF/LNSS/5266e81e-29d8-48d1-9bd5-185c090f3492/01:3HN6Z6.metadata  |2024-07-29 09:42:26|2024-07-29 09:42:26|      0|2024-07-29 04:57:39|2024-07-29 04:57:39|              381|
--                 9019985|               3382664|           10020925|          4688208|             13876456|5266e81e-29d8-48d1-9bd5-185c090f3492|image   |lifetouch.shared.shutterfly.holdingbin.qa         |15FE754D-1FD9-42A5-A6B4-3E7A8CD6F9FF/LNSS/5266e81e-29d8-48d1-9bd5-185c090f3492/XXJHKV77-101073.jpeg|2024-07-29 09:42:26|2024-07-29 09:42:26|      0|2024-07-29 04:57:39|2024-07-29 04:57:39|              381|
--                 9019822|               3382569|           10020765|          4688104|                     |85596528-2f06-48d8-a04c-bd34de3b70d9|metadata|lifetouch.shared.shutterfly.holdingbin.metadata.qa|13EFDCCD-2E69-4161-8F4F-498BAB34C208/LNSS/85596528-2f06-48d8-a04c-bd34de3b70d9/LZ8YTRX.metadata    |2024-07-25 14:59:16|2024-07-25 14:59:16|      0|2024-07-29 04:41:50|2024-07-29 04:41:50|              381|
--                 9019823|               3382584|           10020766|          4688106|             13876369|2df40f38-ff87-498c-95e1-4dc985e25fda|image   |lifetouch.shared.shutterfly.holdingbin.qa         |71434249-2EED-4882-B8C7-395BC049CF5D/LNSS/2df40f38-ff87-498c-95e1-4dc985e25fda/36ZXNGX9-80037.jpeg |2024-07-25 17:53:32|2024-07-25 17:53:32|      0|2024-07-29 04:41:50|2024-07-29 04:41:50|              381|
--                 9019824|               3382584|           10020767|          4688106|                     |2df40f38-ff87-498c-95e1-4dc985e25fda|metadata|lifetouch.shared.shutterfly.holdingbin.metadata.qa|71434249-2EED-4882-B8C7-395BC049CF5D/LNSS/2df40f38-ff87-498c-95e1-4dc985e25fda/01:3HWT33.metadata  |2024-07-25 17:53:32|2024-07-25 17:53:32|      0|2024-07-29 04:41:50|2024-07-29 04:41:50|              381|

SELECT SFLY_INTEGRATION_ID,CUSTOMER_ORDER_ID,IMAGE_RENDER_ASSET_ID,TRANSACTION_ID,TYPE,S3_BUCKET,S3_KEY,AUDIT_CREATE_DATE,AUDIT_MODIFIED_DATE,VERSION FROM ods_stage.mip_sfly_integration_stg WHERE ODS_MODIFY_DATE > SYSDATE - INTERVAL '30' MINUTE
MINUS
SELECT SFLY_INTEGRATION_ID,CUSTOMER_ORDER_ID,IMAGE_RENDER_ASSET_ID,TRANSACTION_ID,TYPE,S3_BUCKET,S3_KEY,AUDIT_CREATE_DATE,AUDIT_MODIFIED_DATE,VERSION FROM ods_own.mip_sfly_integration WHERE ODS_MODIFY_DATE > SYSDATE - INTERVAL '30' MINUTE

SELECT * FROM ods_stage.mip_customer_order_stg WHERE ODS_MODIFY_DATE > SYSDATE - INTERVAL '30' MINUTE

--CUSTOMER_ORDER_ID|SHIPMENT_KEY|ORDER_NO |CUSTOMER_KEY                        |CUSTOMER_ORDER_MESSAGE_KEY          |STATUS     |S3_BUCKET     |S3_KEY        |PROCESSING_START_TIME|AUDIT_CREATE_DATE  |AUDIT_MODIFIED_DATE|VERSION|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
-------------------+------------+---------+------------------------------------+------------------------------------+-----------+--------------+--------------+---------------------+-------------------+-------------------+-------+-------------------+-------------------+
--          4688208|            |01:3HN6Z6|15FE754D-1FD9-42A5-A6B4-3E7A8CD6F9FF|5266e81e-29d8-48d1-9bd5-185c090f3492|transferred|NOT_APPLICABLE|NOT_APPLICABLE|  2024-07-29 09:42:25|2024-07-29 09:42:26|2024-07-29 09:42:26|      1|2024-07-29 04:57:08|2024-07-29 04:57:08|

SELECT * FROM ods_own.mip_customer_order
ORDER BY ODS_MODIFY_DATE DESC

--MIP_CUSTOMER_ORDER_OID|ORDER_HEADER_OID|CUSTOMER_ORDER_ID|SHIPMENT_KEY|ORDER_NO |CUSTOMER_KEY                        |CUSTOMER_ORDER_MESSAGE_KEY          |STATUS     |S3_BUCKET      |S3_KEY                                                                                   |PROCESSING_START_TIME|AUDIT_CREATE_DATE  |AUDIT_MODIFIED_DATE|VERSION|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |SOURCE_SYSTEM_OID|
------------------------+----------------+-----------------+------------+---------+------------------------------------+------------------------------------+-----------+---------------+-----------------------------------------------------------------------------------------+---------------------+-------------------+-------------------+-------+-------------------+-------------------+-----------------+
--               3382664|     10496548495|          4688208|            |01:3HN6Z6|15FE754D-1FD9-42A5-A6B4-3E7A8CD6F9FF|5266e81e-29d8-48d1-9bd5-185c090f3492|transferred|NOT_APPLICABLE |NOT_APPLICABLE                                                                           |  2024-07-29 09:42:25|2024-07-29 09:42:26|2024-07-29 09:42:26|      1|2024-07-29 04:57:30|2024-07-29 04:57:30|              381|
--               3382614|     10308123592|          4688136|            |01:3HJRZ7|4794ecf6-64a8-4c4e-8fb6-fb0e80613c8e|47403a89-a5d7-444a-94a9-61c1cd464081|transferred|qa-mip-order-lt|4794ecf6-64a8-4c4e-8fb6-fb0e80613c8e.47403a89-a5d7-444a-94a9-61c1cd464081.01:3HJRZ7.order|  2024-07-26 10:51:40|2024-07-26 10:51:40|2024-07-26 10:52:50|      1|2024-07-29 04:41:38|2024-07-29 04:41:38|              381|
--               3382615|     10308123597|          4688137|            |01:3HJR74|cd403409-6c39-4c18-aab6-27fe5bcd4206|baa0421b-7be7-4f54-a631-dc8a71f5994d|transferred|qa-mip-order-lt|cd403409-6c39-4c18-aab6-27fe5bcd4206.baa0421b-7be7-4f54-a631-dc8a71f5994d.01:3HJR74.order|  2024-07-26 10:51:40|2024-07-26 10:51:40|2024-07-26 10:52:50|      1|2024-07-29 04:41:38|2024-07-29 04:41:38|              381|
--               3382616|     10308123591|          4688139|            |01:3HJRQ7|199ee243-967a-4c20-b148-4276135113b2|3bce434c-adaf-4c29-bacf-75a3601bc5e0|transferred|qa-mip-order-lt|199ee243-967a-4c20-b148-4276135113b2.3bce434c-adaf-4c29-bacf-75a3601bc5e0.01:3HJRQ7.order|  2024-07-26 10:51:41|2024-07-26 10:51:41|2024-07-26 10:52:50|      1|2024-07-29 04:41:38|2024-07-29 04:41:38|              381|