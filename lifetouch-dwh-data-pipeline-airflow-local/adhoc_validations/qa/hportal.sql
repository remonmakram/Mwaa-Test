/******************************************  Metadata Validations ******************************************
 * Check records are added to the airflow status table
 * check full load expriment as well
 * ******************************************************/


SELECT * FROM RAX_APP_USER.C$_0STG_APP_AUDIT

SELECT * FROM RAX_APP_USER.STG_APP_AUDIT


SELECT * FROM RAX_APP_USER.I$_HP_APP_AUDIT_XR670001

SELECT * FROM RAX_APP_USER.I$_HOST_PORTAL_AUDIT673001

SELECT SYSDATE FROM dual

SELECT DISTINCT ROWS_INSERTED FROM ODS_OWN.AIRFLOW_PACKAGESTATS
 WHERE DAG_ID = 'lt_45_HPORTAL_LOAD_PKG_dag'


 SELECT * FROM ODS_OWN.AIRFLOW_PACKAGESTATS
 WHERE DAG_ID = 'lt_45_HPORTAL_LOAD_PKG_dag'
 AND COMPLETION_TIMESTAMP > SYSDATE - INTERVAL '60' MINUTE
 ORDER BY COMPLETION_TIMESTAMP DESC

SELECT   *
FROM ODS_OWN.ODS_CDC_LOAD_STATUS R_CDC
WHERE ODS_TABLE_NAME like 'HP_%' OR ODS_TABLE_NAME LIKE 'APP_%'


SELECT * FROM RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
     WHERE SESS_NAME IN ('LOAD_APP_AUDIT_PKG', 'LOAD_IMAGESTREAM_PKG') AND  CREATE_DATE > SYSDATE - INTERVAL '60' MINUTE


SELECT   (O_CDC.LAST_CDC_COMPLETION_DATE-R_CDC.ORIG_LAST_CDC_COMPLETION_DATE ) * 1440 AS minutes_difference ,O_CDC.*,R_CDC.*, O_CDC.LAST_CDC_COMPLETION_DATE
 FROM RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT R_CDC
 LEFT JOIN ods_own.ods_cdc_load_status O_CDC
 ON R_CDC.TABLE_NAME  = O_CDC.ODS_TABLE_NAME
 WHERE R_CDC.SESS_NAME IN ('LOAD_APP_AUDIT_PKG', 'LOAD_IMAGESTREAM_PKG')
  AND CREATE_DATE > SYSDATE - INTERVAL '60' MINUTE


SELECT owner, table_name, last_analyzed, stale_stats
FROM dba_tab_statistics
WHERE
table_name LIKE 'I$_HP_APP_AUDIT_XR670001'
and
owner='RAX_APP_USER';
  /******************************************  Data Validations ******************************************

 * ******************************************************/

SELECT ROW_NUMBER() OVER (ORDER BY ODS_CREATE_DATE desc) AS R, T.*
   FROM ODS_STAGE.HP_APP_AUDIT_XR T
--R  |HOST_PORTAL_AUDIT_OID|APP_AUDIT_OID|LIFETOUCH_ID|ODS_CREATE_DATE    |
-----+---------------------+-------------+------------+-------------------+
--  1|              2224195|      2185998|      413667|2024-07-25 08:13:39|
--  2|              2224196|      2185941|      413669|2024-07-25 08:13:39|
--  3|              2224197|      2186015|      413667|2024-07-25 08:13:39|
--  4|              2224198|      2186051|      413693|2024-07-25 08:13:39|
--  5|              2224199|      2186054|       34977|2024-07-25 08:13:39|
--  6|              2224200|      2186093|      413669|2024-07-25 08:13:39|
--  7|              2224201|      2186102|      413682|2024-07-25 08:13:39|
--  8|              2224202|      2186106|       34978|2024-07-25 08:13:39|


   SELECT  count(*)
   FROM ODS_STAGE.HP_APP_AUDIT_XR T

--COUNT(*)|
----------+
-- 2174711|

SELECT max(ODS_CREATE_DATE),sysdate FROM ODS_OWN.HOST_PORTAL_AUDIT
--MAX(ODS_CREATE_DATE)|SYSDATE            |
----------------------+-------------------+
-- 2024-07-25 08:13:40|2024-07-25 08:26:31|

SELECT ROW_NUMBER() OVER (ORDER BY ODS_CREATE_DATE desc) AS R, T.*
   FROM ODS_OWN.HOST_PORTAL_AUDIT T
--R  |HOST_PORTAL_AUDIT_OID|ACCOUNT_OID|USER_ID                      |ACTIVITY_DATE      |ACTIVITY_TYPE|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |SOURCE_SYSTEM_OID|USER_TYPE|PROFILE_ID                          |USER_ACCOUNT_PRINCIPAL_OID|
-----+---------------------+-----------+-----------------------------+-------------------+-------------+-------------------+-------------------+-----------------+---------+------------------------------------+--------------------------+
--  1|              2224235|     115430|test.qa4@yahoo.com           |2024-07-25 07:06:13|Login        |2024-07-25 08:13:40|2024-07-25 08:13:40|               10|EXTERNAL |ff11a78f-3a82-4d3f-93c0-622d9ed5c6f6|                    365426|
--  2|              2224188|      66760|test.qa4@yahoo.com           |2024-07-25 07:06:13|Login        |2024-07-25 08:13:40|2024-07-25 08:13:40|               10|EXTERNAL |ff11a78f-3a82-4d3f-93c0-622d9ed5c6f6|                    365426|
--  3|              2224128|     150892|test.qa4@yahoo.com           |2024-07-25 07:06:13|Login        |2024-07-25 08:13:40|2024-07-25 08:13:40|               10|EXTERNAL |ff11a78f-3a82-4d3f-93c0-622d9ed5c6f6|                    365426|
--  4|              2224189|     268659|test.qa4@yahoo.com           |2024-07-25 07:06:13|Login        |2024-07-25 08:13:40|2024-07-25 08:13:40|               10|EXTERNAL |ff11a78f-3a82-4d3f-93c0-622d9ed5c6f6|                    365426|
--  5|              2224262|     212494|test.qa4@yahoo.com           |2024-07-25 07:06:13|Login        |2024-07-25 08:13:40|2024-07-25 08:13:40|               10|EXTERNAL |ff11a78f-3a82-4d3f-93c0-622d9ed5c6f6|                    365426|
--  6|              2224169|     103297|test.qa4@yahoo.com           |2024-07-25 07:06:13|Login        |2024-07-25 08:13:40|2024-07-25 08:13:40|               10|EXTERNAL |ff11a78f-3a82-4d3f-93c0-622d9ed5c6f6|                    365426|
--  7|              2224190|     212495|test.qa4@yahoo.com           |2024-07-25 07:56:14|Login        |2024-07-25 08:13:40|2024-07-25 08:13:40|               10|EXTERNAL |ff11a78f-3a82-4d3f-93c0-622d9ed5c6f6|                    365426|
--  8|              2224219|     248921|test.qa4@yahoo.com           |2024-07-25 07:56:14|Login        |2024-07-25 08:13:40|2024-07-25 08:13:40|               10|EXTERNAL |ff11a78f-3a82-4d3f-93c0-622d9ed5c6f6|                    365426|
--  9|              2224170|     115430|test.qa4@yahoo.com           |2024-07-25 07:56:14|Login        |2024-07-25 08:13:40|2024-07-25 08:13:40|               10|EXTERNAL |ff11a78f-3a82-4d3f-93c0-622d9ed5c6f6|                    365426|


SELECT  count(*)
FROM ODS_OWN.HOST_PORTAL_AUDIT T

--COUNT(*)|
----------+
-- 2174711|
  --R  |HOST_PORTAL_AUDIT_OID|APP_AUDIT_OID|LIFETOUCH_ID|ODS_CREATE_DATE    |
-----+---------------------+-------------+------------+-------------------+
--  1|              2224195|      2185998|      413667
--delete FROM ODS_STAGE.HP_APP_AUDIT_XR WHERE HOST_PORTAL_AUDIT_OID = 2224195 AND APP_AUDIT_OID = 2185998 AND LIFETOUCH_ID = 413667

--delete FROM ODS_STAGE.HP_APP_AUDIT_XR WHERE LIFETOUCH_ID=0
--
--
--INSERT INTO ODS_STAGE.HP_APP_AUDIT_XR (HOST_PORTAL_AUDIT_OID,APP_AUDIT_OID,LIFETOUCH_ID) values(0,0,0)
--delete FROM RAX_APP_USER.STG_APP_AUDIT WHERE APP_AUDIT_OID=0

delete FROM ODS_STAGE.HP_APP_AUDIT_XR WHERE APP_AUDIT_OID = 0

/*--------- ADD This in the transformation code --------------------------------*/

--/*------------------ JUST FOR TESTING ---------------------------*/
--INSERT INTO RAX_APP_USER.STG_APP_AUDIT (APP_AUDIT_OID,LIFETOUCH_ID) values(0,0)
--
--
--&
INSERT INTO RAX_APP_USER.STG_APP_AUDIT (APP_AUDIT_OID,LIFETOUCH_ID) values(0,0)



SELECT  count(*)
FROM ODS_STAGE.HP_APP_AUDIT_XR T


SELECT ROW_NUMBER() OVER (ORDER BY ODS_CREATE_DATE desc) AS R, T.*
FROM ODS_STAGE.HP_APP_AUDIT_XR T
WHERE LIFETOUCH_ID = 413667

--COUNT(*)|
----------+
-- 2174715|

SELECT * FROM ODS_STAGE.HP_APP_AUDIT_XR WHERE APP_AUDIT_OID = 2185998

SELECT * FROM RAX_APP_USER.STG_APP_AUDIT WHERE APP_AUDIT_OID = 0

SELECT * FROM ODS_STAGE.HP_APP_AUDIT_XR WHERE APP_AUDIT_OID = 0

-- Run the dag

SELECT * FROM ODS_STAGE.HP_APP_AUDIT_XR WHERE APP_AUDIT_OID = 0

SELECT * FROM ODS_STAGE.HP_APP_AUDIT_XR ORDER BY ODS_CREATE_DATE desc

-------------------------------------------------------------------

SELECT * FROM ODS_STAGE.HP_APP_AUDIT_XR WHERE APP_AUDIT_OID = 0

SELECT * FROM RAX_APP_USER.STG_APP_AUDIT WHERE APP_AUDIT_OID = 0

SELECT * FROM ODS_OWN.HOST_PORTAL_AUDIT WHERE HOST_PORTAL_AUDIT_OID = 0

--SELECT * FROM RAX_APP_USER.I$_HP_APP_AUDIT_XR670001

merge into	ODS_STAGE.HP_APP_AUDIT_XR T
using	RAX_APP_USER.I$_HP_APP_AUDIT_XR670001 S
on	(
		T.APP_AUDIT_OID=S.APP_AUDIT_OID
	)
when matched
then update set
	T.LIFETOUCH_ID	= S.LIFETOUCH_ID
	, T.ODS_CREATE_DATE	= sysdate
when not matched
then insert
	(
	T.APP_AUDIT_OID,
	T.LIFETOUCH_ID
	,  T.HOST_PORTAL_AUDIT_OID,
	T.ODS_CREATE_DATE
	)
values
	(
	S.APP_AUDIT_OID,
	S.LIFETOUCH_ID
	,  ODS_STAGE.HOST_PORTAL_AUDIT_OID_SEQ.nextval,
	sysdate
	)

select
APP_AUDIT_OID,
	LIFETOUCH_ID,
	IND_UPDATE
 from (
select
	DISTINCT
	STG.APP_AUDIT_OID APP_AUDIT_OID,
	STG.LIFETOUCH_ID LIFETOUCH_ID,
	'I' IND_UPDATE

from	RAX_APP_USER.STG_APP_AUDIT   STG, ODS_STAGE.HP_APP_AUDIT_XR   XR
where	(1=1)
 And (STG.APP_AUDIT_OID=XR.APP_AUDIT_OID(+) and XR.APP_AUDIT_OID is null)
) S
where NOT EXISTS
	( select 1 from ODS_STAGE.HP_APP_AUDIT_XR T
	where	T.APP_AUDIT_OID	= S.APP_AUDIT_OID
		 and ((T.LIFETOUCH_ID = S.LIFETOUCH_ID) or (T.LIFETOUCH_ID IS NULL and S.LIFETOUCH_ID IS NULL))
        )