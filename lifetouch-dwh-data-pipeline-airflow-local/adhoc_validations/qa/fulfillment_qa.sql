
SELECT * FROM RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
WHERE SESS_NAME IN ('LOAD_LT_FULFILLMENT_BATCH_PKG') AND  CREATE_DATE > SYSDATE - INTERVAL '60' MINUTE

SELECT last_cdc_completion_date FROM ods_own.ods_cdc_load_status
WHERE  ods_table_name = 'LT_FULFILLMENT_BATCH'


SELECT * FROM ODS_OWN.AIRFLOW_PACKAGESTATS
 WHERE DAG_ID = 'lt_fulfillment_batch_dag'
 AND COMPLETION_TIMESTAMP > SYSDATE - INTERVAL '60' MINUTE
 ORDER BY COMPLETION_TIMESTAMP DESC

SELECT   (O_CDC.LAST_CDC_COMPLETION_DATE-R_CDC.ORIG_LAST_CDC_COMPLETION_DATE ) * 1440 AS minutes_difference ,R_CDC.*, O_CDC.LAST_CDC_COMPLETION_DATE
 FROM RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT R_CDC
 LEFT JOIN ods_own.ods_cdc_load_status O_CDC
 ON R_CDC.TABLE_NAME  = O_CDC.ODS_TABLE_NAME
 WHERE SESS_NAME IN ('LOAD_LT_FULFILLMENT_BATCH_PKG')
  AND CREATE_DATE > SYSDATE - INTERVAL '60' MINUTE

-- SELECT * FROM RAX_APP_USER.I$_LT_FULFILL_BATCH2260001


  SELECT * FROM ODS_OWN.LT_FULFILLMENT_BATCH ORDER BY ODS_MODIFY_DATE DESC FETCH FIRST 5 ROWS ONLY
--
--FULFILLMENT_BATCH_OID|ORDER_BATCH_OID|SHIP_NODE               |BATCH_ID    |AVAILABLE_DATE     |STATUS              |PACK_LIST_TYPE|RETOUCHING_FLAG|MODIFYTS           |MODIFYPROGID          |ORDER_COUNT_BOC|BOC_BATCH_CREATETS|SERVICE_RECOVERY|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |SOURCE_SYSTEM_OID|BATCH_TYPE|
-----------------------+---------------+------------------------+------------+-------------------+--------------------+--------------+---------------+-------------------+----------------------+---------------+------------------+----------------+-------------------+-------------------+-----------------+----------+
--                 5443|           9252|                        |LN656423Q0_2|2017-04-12 17:05:23|Hold                |PORTRAIT      |01             |2017-04-12 16:45:23|CLOSEBATCH_AGENT      |              1|                  |N               |2018-11-09 12:16:01|2024-08-04 08:43:15|                2|          |
--                 5093|           9196|                        |XX656718Q0_1|2016-11-30 16:32:21|Y                   |PORTRAIT      |01             |2016-11-30 17:24:30|BULK_SHIP_CREATE_AGENT|             21|                  |N               |2018-11-09 12:16:01|2024-08-04 08:43:15|                2|          |
--                 5094|           9199|                        |XX656720Q0_1|2016-11-30 16:41:01|Y                   |PORTRAIT      |01             |2016-11-30 17:24:30|BULK_SHIP_CREATE_AGENT|             21|                  |N               |2018-11-09 12:16:01|2024-08-04 08:43:15|                2|          |
--                 5095|           9254|                        |XX656742YP_5|2016-12-01 07:38:26|Y                   |PORTRAIT      |01             |2016-12-01 07:54:30|BULK_SHIP_CREATE_AGENT|              2|                  |N               |2018-11-09 12:16:01|2024-08-04 08:43:15|                2|          |
--                 5100|           9258|                        |XX656713QP_2|2016-12-01 11:09:30|Y                   |PORTRAIT      |01             |2016-12-01 11:24:30|BULK_SHIP_CREATE_AGENT|             19|                  |N               |2018-11-09 12:16:01|2024-08-04 08:43:15|                2|          |

  SELECT * FROM ODS_STAGE.OMS_LT_FULFILLMENT_BATCH_XR ORDER BY ODS_MODIFY_DATE DESC FETCH FIRST 5 ROWS ONLY

--  FULFILLMENT_BATCH_OID|FULFILLMENT_BATCH_KEY  |ORDER_BATCH_ID|OMS_ORDER_BATCH_ID|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
-----------------------+-----------------------+--------------+------------------+-------------------+-------------------+
--                 3079|20190425115703872088567|              |EVT9JPQQ8_3       |2021-05-11 09:18:33|2021-05-11 09:18:33|

    SELECT * FROM ODS_STAGE.OMS3_LT_FULFILLMENT_BATCH_STG ORDER BY ODS_MODIFY_DATE DESC FETCH FIRST 5 ROWS ONLY
--FULFILLMENT_BATCH_KEY   |BATCH_ID       |AVAILABLE_DATE     |STATUS    |PACK_LIST_TYPE|RETOUCHING_FLAG|CREATETS           |MODIFYTS           |CREATEUSERID      |MODIFYUSERID              |CREATEPROGID      |MODIFYPROGID              |LOCKID|ORDER_COUNT_BOC|SHIP_NODE               |BOC_BATCH_CREATETS |SERVICE_RECOVERY|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |BATCH_TYPE|
--------------------------+---------------+-------------------+----------+--------------+---------------+-------------------+-------------------+------------------+--------------------------+------------------+--------------------------+------+---------------+------------------------+-------------------+----------------+-------------------+-------------------+----------+
--202103250856301320295627|BATCHIDp05     |2024-08-04 09:52:15|BOC_CLOSED|PORTRAIT      |01             |2021-03-25 08:56:30|2024-08-04 09:42:14|v-parminder.singh |CloseBatchAgentForConsumer|SterlingHttpTester|CloseBatchAgentForConsumer|   651|              4|Shakopee Lab            |2021-03-25 08:56:30|N               |2021-05-11 09:18:32|2024-08-04 09:58:52|          |
--202104151140041344699051|BRTDEV05_1     |2024-08-04 10:11:58|BOC_CLOSED|PORTRAIT      |01             |2021-04-15 11:40:03|2024-08-04 09:51:57|BOCServer         |BOCCloseBatchAgent        |BOCServer         |CLOSEBATCH_AGENT          |   250|             12|                        |2020-03-31 12:51:11|N               |2021-05-11 09:18:32|2024-08-04 09:58:52|LATE_BATCH|
--202103220722301317710075|testtest-2-3   |2024-08-04 10:11:58|BOC_CLOSED|PORTRAIT      |01             |2021-03-22 07:22:30|2024-08-04 09:51:57|spec.dev-all      |BOCCloseBatchAgent        |SterlingHttpTester|CLOSEBATCH_AGENT          |   774|              3|                        |2021-02-25 00:00:00|N               |2021-05-11 09:18:32|2024-08-04 09:58:52|          |
--20191118101253892331242 |EVT82NS93_103_4|2024-08-04 10:11:57|BOC_CLOSED|PORTRAIT      |01             |2019-11-18 10:12:52|2024-08-04 09:51:57|SterlingHttpTester|BOCCloseBatchAgent        |SterlingHttpTester|CLOSEBATCH_AGENT          |    91|              2|                        |2019-11-18 10:12:52|Y               |2021-05-11 09:18:32|2024-08-04 09:58:52|          |
--20190517043824875152645 |LN807100X0_1705|2024-08-04 10:02:14|BOC_CLOSED|PORTRAIT      |01             |2019-05-17 04:38:24|2024-08-04 09:52:14|BOCServer         |CloseBatchAgentForConsumer|BOCServer         |CloseBatchAgentForConsumer|   338|              4|Minneapolis Lab         |2019-05-17 04:38:24|N               |2021-05-11 09:18:32|2024-08-04 09:58:52|          |


SELECT * FROM ODS_STAGE.OMS3_LT_FULFILLMENT_BATCH_STG WHERE FULFILLMENT_BATCH_KEY = '20190425115703872088567'


SELECT count(*) FROM ODS_OWN.LT_FULFILLMENT_BATCH
--COUNT(*)|
----------+
--   23061|

  SELECT * FROM ODS_OWN.LT_FULFILLMENT_BATCH WHERE FULFILLMENT_BATCH_OID= '46711' AND ORDER_BATCH_OID ='719266'
--FULFILLMENT_BATCH_OID|ORDER_BATCH_OID|SHIP_NODE               |BATCH_ID     |AVAILABLE_DATE     |STATUS|PACK_LIST_TYPE|RETOUCHING_FLAG|MODIFYTS           |MODIFYPROGID       |ORDER_COUNT_BOC|BOC_BATCH_CREATETS |SERVICE_RECOVERY|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |SOURCE_SYSTEM_OID|BATCH_TYPE |
-----------------------+---------------+------------------------+-------------+-------------------+------+--------------+---------------+-------------------+-------------------+---------------+-------------------+----------------+-------------------+-------------------+-----------------+-----------+
--                46711|         719266|Shakopee Lab            |EVTPNH948_995|2024-08-04 04:07:50|Y     |PORTRAIT      |01             |2024-08-04 04:23:44|MICIntegrationAgent|              2|2024-08-04 00:00:00|N               |2024-08-04 06:15:56|2024-08-04 09:29:27|                2|EVENT_BATCH|


 DELETE FROM ODS_OWN.LT_FULFILLMENT_BATCH WHERE FULFILLMENT_BATCH_OID= '46711' AND ORDER_BATCH_OID ='719266'


SELECT count(*) FROM ODS_OWN.LT_FULFILLMENT_BATCH
--COUNT(*)|
----------+
--   23061|

-- UPDATE ods_own.ods_cdc_load_status
--SET last_cdc_completion_date = TO_DATE(SUBSTR('2024-08-03 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
--WHERE  ods_table_name = 'LT_FULFILLMENT_BATCH'


UPDATE ods_own.ods_cdc_load_status
SET last_cdc_completion_date = TO_DATE(SUBSTR('2024-08-03 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
WHERE ods_table_name= 'LT_FULFILLMENT_BATCH'


-- Run the DAG


SELECT count(*) FROM ODS_OWN.LT_FULFILLMENT_BATCH
--COUNT(*)|
----------+
--   23061|

SELECT * FROM ODS_OWN.LT_FULFILLMENT_BATCH WHERE FULFILLMENT_BATCH_OID= '46711' AND ORDER_BATCH_OID ='719266'
--FULFILLMENT_BATCH_OID|ORDER_BATCH_OID|SHIP_NODE               |BATCH_ID     |AVAILABLE_DATE     |STATUS|PACK_LIST_TYPE|RETOUCHING_FLAG|MODIFYTS           |MODIFYPROGID       |ORDER_COUNT_BOC|BOC_BATCH_CREATETS |SERVICE_RECOVERY|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |SOURCE_SYSTEM_OID|BATCH_TYPE |
-----------------------+---------------+------------------------+-------------+-------------------+------+--------------+---------------+-------------------+-------------------+---------------+-------------------+----------------+-------------------+-------------------+-----------------+-----------+
--                46711|         719266|Shakopee Lab            |EVTPNH948_995|2024-08-04 04:07:50|Y     |PORTRAIT      |01             |2024-08-04 04:23:44|MICIntegrationAgent|              2|2024-08-04 00:00:00|N               |2024-08-04 06:15:56|2024-08-04 10:13:15|                2|EVENT_BATCH|


---------------------------------------------------------------------------------------------------------------------------------------------
select
	SYS_GUID(),
	:v_sess_no,
	rowid,
	'F',
	'ODI-15066: The column SOURCE_SYSTEM_OID cannot be null.',
	sysdate,
	'(2260001)ODS_Project.LOAD_LT_FULFILLMENT_BATCH_INT',
	'SOURCE_SYSTEM_OID',
	'NN',
	FULFILLMENT_BATCH_OID,
	ORDER_BATCH_OID,
	SHIP_NODE,
	BATCH_ID,
	AVAILABLE_DATE,
	STATUS,
	PACK_LIST_TYPE,
	RETOUCHING_FLAG,
	MODIFYTS,
	MODIFYPROGID,
	ORDER_COUNT_BOC,
	BOC_BATCH_CREATETS,
	SERVICE_RECOVERY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID,
	BATCH_TYPE
from	RAX_APP_USER.I$_LT_FULFILL_BATCH2260001
where	SOURCE_SYSTEM_OID is NULL


  select
FULFILLMENT_BATCH_OID,
	ORDER_BATCH_OID,
	SHIP_NODE,
	BATCH_ID,
	AVAILABLE_DATE,
	STATUS,
	PACK_LIST_TYPE,
	RETOUCHING_FLAG,
	MODIFYTS,
	MODIFYPROGID,
	ORDER_COUNT_BOC,
	BOC_BATCH_CREATETS,
	SERVICE_RECOVERY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID,
	BATCH_TYPE,
	IND_UPDATE
 from (
select
	OMS_LT_FULFILLMENT_BATCH_XR.FULFILLMENT_BATCH_OID FULFILLMENT_BATCH_OID,
	ORDER_BATCH.ORDER_BATCH_OID ORDER_BATCH_OID,
	LT_FULFILLMENT_BATCH_STG.SHIP_NODE SHIP_NODE,
	LT_FULFILLMENT_BATCH_STG.BATCH_ID BATCH_ID,
	LT_FULFILLMENT_BATCH_STG.AVAILABLE_DATE AVAILABLE_DATE,
	LT_FULFILLMENT_BATCH_STG.STATUS STATUS,
	LT_FULFILLMENT_BATCH_STG.PACK_LIST_TYPE PACK_LIST_TYPE,
	LT_FULFILLMENT_BATCH_STG.RETOUCHING_FLAG RETOUCHING_FLAG,
	LT_FULFILLMENT_BATCH_STG.MODIFYTS MODIFYTS,
	LT_FULFILLMENT_BATCH_STG.MODIFYPROGID MODIFYPROGID,
	LT_FULFILLMENT_BATCH_STG.ORDER_COUNT_BOC ORDER_COUNT_BOC,
	LT_FULFILLMENT_BATCH_STG.BOC_BATCH_CREATETS BOC_BATCH_CREATETS,
	LT_FULFILLMENT_BATCH_STG.SERVICE_RECOVERY SERVICE_RECOVERY,
	SYSDATE ODS_CREATE_DATE,
	SYSDATE ODS_MODIFY_DATE,
	SOURCE_SYSTEM.SOURCE_SYSTEM_OID SOURCE_SYSTEM_OID,
	LT_FULFILLMENT_BATCH_STG.BATCH_TYPE BATCH_TYPE,
	'I' IND_UPDATE
from	ODS_STAGE.OMS3_LT_FULFILLMENT_BATCH_STG   LT_FULFILLMENT_BATCH_STG, ODS_OWN.SOURCE_SYSTEM   SOURCE_SYSTEM, ODS_STAGE.OMS_LT_FULFILLMENT_BATCH_XR   OMS_LT_FULFILLMENT_BATCH_XR, ODS_OWN.ORDER_BATCH   ORDER_BATCH
where	(1=1)
 And (TRIM(LT_FULFILLMENT_BATCH_STG.FULFILLMENT_BATCH_KEY)=OMS_LT_FULFILLMENT_BATCH_XR.FULFILLMENT_BATCH_KEY (+))
AND (LT_FULFILLMENT_BATCH_STG.BATCH_ID=ORDER_BATCH.BATCH_ID (+))
And (SOURCE_SYSTEM.SOURCE_SYSTEM_SHORT_NAME = 'OMS')
 And (LT_FULFILLMENT_BATCH_STG.ODS_MODIFY_DATE >= TO_DATE(SUBSTR('2024-08-04 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS'))
 AND OMS_LT_FULFILLMENT_BATCH_XR.FULFILLMENT_BATCH_OID= '135'
) S
where NOT EXISTS
	( select 1 from ODS_OWN.LT_FULFILLMENT_BATCH T
	where	T.FULFILLMENT_BATCH_OID	= S.FULFILLMENT_BATCH_OID
		 and ((T.ORDER_BATCH_OID = S.ORDER_BATCH_OID) or (T.ORDER_BATCH_OID IS NULL and S.ORDER_BATCH_OID IS NULL)) and
		((T.SHIP_NODE = S.SHIP_NODE) or (T.SHIP_NODE IS NULL and S.SHIP_NODE IS NULL)) and
		((T.BATCH_ID = S.BATCH_ID) or (T.BATCH_ID IS NULL and S.BATCH_ID IS NULL)) and
		((T.AVAILABLE_DATE = S.AVAILABLE_DATE) or (T.AVAILABLE_DATE IS NULL and S.AVAILABLE_DATE IS NULL)) and
		((T.STATUS = S.STATUS) or (T.STATUS IS NULL and S.STATUS IS NULL)) and
		((T.PACK_LIST_TYPE = S.PACK_LIST_TYPE) or (T.PACK_LIST_TYPE IS NULL and S.PACK_LIST_TYPE IS NULL)) and
		((T.RETOUCHING_FLAG = S.RETOUCHING_FLAG) or (T.RETOUCHING_FLAG IS NULL and S.RETOUCHING_FLAG IS NULL)) and
		((T.MODIFYTS = S.MODIFYTS) or (T.MODIFYTS IS NULL and S.MODIFYTS IS NULL)) and
		((T.MODIFYPROGID = S.MODIFYPROGID) or (T.MODIFYPROGID IS NULL and S.MODIFYPROGID IS NULL)) and
		((T.ORDER_COUNT_BOC = S.ORDER_COUNT_BOC) or (T.ORDER_COUNT_BOC IS NULL and S.ORDER_COUNT_BOC IS NULL)) and
		((T.BOC_BATCH_CREATETS = S.BOC_BATCH_CREATETS) or (T.BOC_BATCH_CREATETS IS NULL and S.BOC_BATCH_CREATETS IS NULL)) and
		((T.SERVICE_RECOVERY = S.SERVICE_RECOVERY) or (T.SERVICE_RECOVERY IS NULL and S.SERVICE_RECOVERY IS NULL)) and
		((T.ODS_MODIFY_DATE = S.ODS_MODIFY_DATE) or (T.ODS_MODIFY_DATE IS NULL and S.ODS_MODIFY_DATE IS NULL)) and
		((T.SOURCE_SYSTEM_OID = S.SOURCE_SYSTEM_OID) or (T.SOURCE_SYSTEM_OID IS NULL and S.SOURCE_SYSTEM_OID IS NULL)) and
		((T.BATCH_TYPE = S.BATCH_TYPE) or (T.BATCH_TYPE IS NULL and S.BATCH_TYPE IS NULL))
        )