SELECT   (O_CDC.LAST_CDC_COMPLETION_DATE-R_CDC.ORIG_LAST_CDC_COMPLETION_DATE ) * 1440 AS minutes_difference ,R_CDC.*, O_CDC.LAST_CDC_COMPLETION_DATE
 FROM RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT R_CDC
 LEFT JOIN ods_own.ods_cdc_load_status O_CDC
 ON R_CDC.TABLE_NAME  = O_CDC.ODS_TABLE_NAME
 WHERE sess_name = '35_UPD_IMAGE_TRACKING'
  AND CREATE_DATE > SYSDATE - INTERVAL '15' MINUTE

--  MINUTES_DIFFERENCE                       |TABLE_NAME        |SESS_NO      |SESS_NAME            |SCEN_VERSION|SESS_BEG           |ORIG_LAST_CDC_COMPLETION_DATE|OVERLAP      |CREATE_DATE        |CONTEXT_NAME|TIMEZONE_OFFSET|LAST_CDC_COMPLETION_DATE|
-------------------------------------------+------------------+-------------+---------------------+------------+-------------------+-----------------------------+-------------+-------------------+------------+---------------+------------------------+
-- 1.66666666666666666666666666666666666667|UPD_IMAGE_TRACKING|1722250642919|35_UPD_IMAGE_TRACKING|002         |2024-07-29 05:57:22|          2024-07-29 05:55:42|0.02083333333|2024-07-29 05:57:22|            |               |     2024-07-29 05:57:22|
--5505.133333333333333333333333333333333334|UPD_IMAGE_TRACKING|1722250542545|35_UPD_IMAGE_TRACKING|002         |2024-07-29 05:55:42|          2024-07-25 10:12:14|0.02083333333|2024-07-29 05:55:42|            |               |     2024-07-29 05:57:22|

/******************************************  CDC Last Update Date For This Subpackage  ******************************************
 *
 * ******************************************************/
  SELECT max(SOURCE_CREATE_DATE) FROM ODS_OWN.IMAGE_TRACKING
--MAX(SOURCE_CREATE_DATE)|
-------------------------+
--    2016-01-14 00:00:00|

SELECT * FROM ODS_OWN.IMAGE_TRACKING ORDER BY ODS_MODIFY_DATE desc


--IMAGE_TRACKING_OID|SOURCE_SYSTEM|SOURCE_SYSTEM_KEY |EVENT_REF_ID|PLANT_NODE|SOURCE_CREATE_DATE |CIR_RECEIVE_DATE   |SUBJECT_MATCH_DATE|IGNORE_FLAG|IGNORE_DATE|IGNORE_REASON|IGNORE_BY_USER|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
--------------------+-------------+------------------+------------+----------+-------------------+-------------------+------------------+-----------+-----------+-------------+--------------+-------------------+-------------------+
--           1004812|FOX          |LN56Q300Q301001015|LN565300Q3  |Q         |2015-08-11 00:00:00|2017-10-09 12:36:00|                  |N          |           |             |              |2015-08-13 15:34:54|2024-07-29 07:05:31|
--           1004964|FOX          |LN56Q300Q301002715|LN565300Q3  |Q         |2015-08-11 00:00:00|2017-10-09 10:55:14|                  |N          |           |             |              |2015-08-13 15:34:54|2024-07-29 07:05:31|
--           1005064|FOX          |LN56Q300Q301001615|LN565300Q3  |Q         |2015-08-11 00:00:00|2017-10-09 12:36:06|                  |N          |           |             |              |2015-08-13 15:34:54|2024-07-29 07:05:31|
--           1005207|FOX          |LN56Q300Q301001115|LN565300Q3  |Q         |2015-08-11 00:00:00|2017-10-09 10:55:04|                  |N          |           |             |              |2015-08-13 15:34:54|2024-07-29 07:05:31|
--           1005212|FOX          |LN56Q300Q301001315|LN565300Q3  |Q         |2015-08-11 00:00:00|2017-10-09 12:35:54|                  |N          |           |             |              |2015-08-13 15:34:54|2024-07-29 07:05:31|
--           1005550|FOX          |LN56Q300Q301002815|LN565300Q3  |Q         |2015-08-11 00:00:00|2017-10-09 10:55:07|                  |N          |           |             |              |2015-08-13 15:34:54|2024-07-29 07:05:31|
--           1007428|FOX          |LN56Q300Q301002315|LN565300Q3  |Q         |2015-08-11 00:00:00|2017-10-09 10:55:05|                  |N          |           |             |              |2015-08-13 15:34:54|2024-07-29 07:05:31|





INSERT INTO ODS_OWN.IMAGE_TRACKING (IMAGE_TRACKING_OID,SOURCE_SYSTEM,SOURCE_SYSTEM_KEY,EVENT_REF_ID,SOURCE_CREATE_DATE) VALUES (0,'FOX','0',0,sysdate)


SELECT SOURCE_CREATE_DATE FROM ODS_OWN.IMAGE_TRACKING WHERE EVENT_REF_ID = '0'

--SOURCE_CREATE_DATE |
---------------------+
--2024-07-30 07:15:27|

/*put this in the sql file*/

INSERT INTO tmp_Image_Track_RollOver_Fix (EVENT_REF_ID,PLANT_RECEIPT_DATE) values('0',( TO_DATE(SUBSTR('2024-01-01 14:01:35', 1, 19), 'YYYY-MM-DD HH24:MI:SS') ))


/*run the dag*/

SELECT SOURCE_CREATE_DATE FROM ODS_OWN.IMAGE_TRACKING WHERE EVENT_REF_ID = '0'












/***************************************************************************************/
--LAST_CDC_COMPLETION_DATE|TYPE|
--------------------------+----+
--     2015-01-01 14:01:35|date|

--select count(*)
--from ODS_OWN.Event s
--where ods_create_date > trunc(sysdate)
--and not exists
--(
--select 1
--from ODS_OWN.IMAGE_TRACKING t
--where s.EVENT_OID = t.EVENT_REF_ID
--)

select distinct
IT.EVENT_REF_ID,
E.PLANT_RECEIPT_DATE
from ODS_OWN.IMAGE_TRACKING IT
join ODS_OWN.EVENT E on IT.EVENT_REF_ID = E.EVENT_REF_ID
where E.ROLLOVER_JOB_IND = 'X'
and IT.ODS_MODIFY_DATE >= ( TO_DATE(SUBSTR('2010-01-01 14:01:35', 1, 19), 'YYYY-MM-DD HH24:MI:SS') )

select distinct CIR.SOURCE_SYSTEM_CODE as SSK, CIR.AUDIT_CREATE_DATE as CIR_MATCH_DATE,CIR.ODS_MODIFY_DATE
from ODS_STAGE.CIR_IMAGE_GROUP CIR
join ODS_OWN.IMAGE_TRACKING IT
on CIR.SOURCE_SYSTEM_CODE = IT.SOURCE_SYSTEM_KEY
where IT.CIR_RECEIVE_DATE is null
and CIR.ODS_MODIFY_DATE >=  TO_DATE(SUBSTR('2017-01-01 14:01:35', 1, 19), 'YYYY-MM-DD HH24:MI:SS')


AND CIR.SOURCE_SYSTEM_CODE IN (
SELECT SSK FROM (

SELECT count(*),SSK FROM (
select distinct CIR.SOURCE_SYSTEM_CODE as SSK, CIR.AUDIT_CREATE_DATE as CIR_MATCH_DATE
from ODS_STAGE.CIR_IMAGE_GROUP CIR
join ODS_OWN.IMAGE_TRACKING IT
on CIR.SOURCE_SYSTEM_CODE = IT.SOURCE_SYSTEM_KEY
where IT.CIR_RECEIVE_DATE is null
and CIR.ODS_MODIFY_DATE >=  TO_DATE(SUBSTR('2017-01-01 14:01:35', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
)
GROUP BY SSK
HAVING count(*) >1

)
)

update
(
SELECT
S.CIR_MATCH_DATE
, t.CIR_RECEIVE_DATE as t_CIR_RECEIVE_DATE
, t.ods_modify_Date as t_ods_modify_date
FROM TMP_CIR_MATCH_DATE2 S
join ODS_OWN.IMAGE_TRACKING T on S.SSK = T.SOURCE_SYSTEM_KEY
)
set T_CIR_RECEIVE_DATE = CIR_MATCH_DATE, T_ODS_MODIFY_DATE = SYSDATE



SELECT
temp.PLANT_RECEIPT_DATE
FROM ODS_OWN.IMAGE_TRACKING IT,tmp_Image_Track_RollOver_Fix temp
where IT.EVENT_REF_ID = temp.EVENT_REF_ID

  SELECT * FROM ODS_OWN.IMAGE_TRACKING ORDER BY SOURCE_CREATE_DATE desc
--IMAGE_TRACKING_OID|SOURCE_SYSTEM|SOURCE_SYSTEM_KEY |EVENT_REF_ID|PLANT_NODE|SOURCE_CREATE_DATE |CIR_RECEIVE_DATE|SUBJECT_MATCH_DATE|IGNORE_FLAG|IGNORE_DATE|IGNORE_REASON|IGNORE_BY_USER|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
--------------------+-------------+------------------+------------+----------+-------------------+----------------+------------------+-----------+-----------+-------------+--------------+-------------------+-------------------+
--           1014560|FOX          |XX56Q404YP01002515|XX565404YP  |Q         |2016-01-14 00:00:00|                |                  |N          |           |             |              |2016-01-14 16:02:47|2016-01-14 16:02:47|
--           1014561|FOX          |XX56Q404YP01002415|XX565404YP  |Q         |2016-01-14 00:00:00|                |                  |N          |           |             |              |2016-01-14 16:02:47|2016-01-14 16:02:47|
--           1014581|FOX          |XX56Q404YP01001315|XX565404YP  |Q         |2016-01-14 00:00:00|                |                  |N          |           |             |              |2016-01-14 16:02:47|2016-01-14 16:02:47|
--           1014580|FOX          |XX56Q404YP01001415|XX565404YP  |Q         |2016-01-14 00:00:00|                |                  |N          |           |             |              |2016-01-14 16:02:47|2016-01-14 16:02:47|
--           1014579|FOX          |XX56Q404YP01001515|XX565404YP  |Q         |2016-01-14 00:00:00|                |                  |N          |           |             |              |2016-01-14 16:02:47|2016-01-14 16:02:47|
--           1014578|FOX          |XX56Q404YP01000815|XX565404YP  |Q         |2016-01-14 00:00:00|                |                  |N          |           |             |              |2016-01-14 16:02:47|2016-01-14 16:02:47|
--           1014577|FOX          |XX56Q404YP01002615|XX565404YP  |Q         |2016-01-14 00:00:00|                |                  |N          |           |             |              |2016-01-14 16:02:47|2016-01-14 16:02:47|
--           1014576|FOX          |XX56Q404YP01002015|XX565404YP  |Q         |2016-01-14 00:00:00|                |                  |N          |           |             |              |2016-01-14 16:02:47|2016-01-14 16:02:47|
--           1014575|FOX          |XX56Q404YP01000715|XX565404YP  |Q         |2016-01-14 00:00:00|                |                  |N          |           |             |              |2016-01-14 16:02:47|2016-01-14 16:02:47|
--           1014574|FOX          |XX56Q404YP01000915|XX565404YP  |Q         |2016-01-14 00:00:00|                |                  |N          |           |             |              |2016-01-14 16:02:47|2016-01-14 16:02:47|


  SELECT * FROM ODS_OWN.IMAGE_TRACKING WHERE EVENT_REF_ID = 'XX565404YP' AND SOURCE_SYSTEM_KEY ='XX56Q404YP01002515'

--IMAGE_TRACKING_OID|SOURCE_SYSTEM|SOURCE_SYSTEM_KEY |EVENT_REF_ID|PLANT_NODE|SOURCE_CREATE_DATE |CIR_RECEIVE_DATE|SUBJECT_MATCH_DATE|IGNORE_FLAG|IGNORE_DATE|IGNORE_REASON|IGNORE_BY_USER|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
--------------------+-------------+------------------+------------+----------+-------------------+----------------+------------------+-----------+-----------+-------------+--------------+-------------------+-------------------+
--           1014560|FOX          |XX56Q404YP01002515|XX565404YP  |Q         |2016-01-14 00:00:00|                |                  |N          |           |             |              |2016-01-14 16:02:47|2016-01-14 16:02:47|


UPDATE ODS_OWN.IMAGE_TRACKING
SET SOURCE_CREATE_DATE = TO_DATE(SUBSTR('2024-01-01 14:01:35', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
--, ODS_MODIFY_DATE  = TO_DATE(SUBSTR('2025-07-07 07:20:10', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
 WHERE EVENT_REF_ID = 'XX565404YP' AND SOURCE_SYSTEM_KEY ='XX56Q404YP01002515'

 SELECT * FROM ODS_OWN.IMAGE_TRACKING WHERE EVENT_REF_ID = 'XX565404YP' AND SOURCE_SYSTEM_KEY ='XX56Q404YP01002515'
--IMAGE_TRACKING_OID|SOURCE_SYSTEM|SOURCE_SYSTEM_KEY |EVENT_REF_ID|PLANT_NODE|SOURCE_CREATE_DATE |CIR_RECEIVE_DATE|SUBJECT_MATCH_DATE|IGNORE_FLAG|IGNORE_DATE|IGNORE_REASON|IGNORE_BY_USER|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
--------------------+-------------+------------------+------------+----------+-------------------+----------------+------------------+-----------+-----------+-------------+--------------+-------------------+-------------------+
--           1119341|FOX          |XX64Q307QP01003415|CH189849H1  |Q         |2024-01-01 14:01:35|                |                  |N          |           |             |              |2015-08-31 09:18:18|2024-01-01 14:01:35|

SELECT last_cdc_completion_date, 'date' as type FROM ods_own.ods_cdc_load_status WHERE ods_table_name= 'UPD_IMAGE_TRACKING' and context_name = 'QA'

--LAST_CDC_COMPLETION_DATE|TYPE|
--------------------------+----+
--     2024-07-29 05:57:22|date|

UPDATE ods_own.ods_cdc_load_status
SET last_cdc_completion_date = TO_DATE(SUBSTR('2017-07-29 14:01:35', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
WHERE ods_table_name= 'UPD_IMAGE_TRACKING' and context_name = 'QA'

SELECT last_cdc_completion_date, 'date' as type FROM ods_own.ods_cdc_load_status WHERE ods_table_name= 'UPD_IMAGE_TRACKING' and context_name = 'DEV'
--LAST_CDC_COMPLETION_DATE|TYPE|
--------------------------+----+
--     2015-01-01 14:01:35|date|


/* RUN DAG*/


SELECT * FROM ODS_OWN.IMAGE_TRACKING WHERE EVENT_REF_ID = 'CH189849H1'

/************************************************************/

SELECT max(ODS_MODIFY_DATE) FROM ODS_OWN.IMAGE WHERE length(IMAGE_IMPORT_GROUP) = '12'

SELECT substr(JOB_ALPHA_NBR, 1, 10) FROM ODS_OWN.CAPTURE_SESSION

--CREATE TABLE TMP_SUBJECT_MASTER_MATCH_DATE AS
select distinct IMAGE_IMPORT_GROUP || lpad(i.CAPTURE_SEQUENCE,4,'0')||to_number(substr(e.school_year, 3, 2)-1) as SSK
,max(I.ODS_CREATE_DATE) as S_MATCH_DATE
,CS.EVENT_OID
,substr(CS.JOB_ALPHA_NBR, 1, 10) as Job_Num
,i.ODS_MODIFY_DATE
from ODS_OWN.IMAGE I
join ODS_OWN.CAPTURE_SESSION CS on I.CAPTURE_SESSION_OID = CS.CAPTURE_SESSION_OID
join ODS_OWN.EVENT E on CS.EVENT_OID = E.EVENT_OID
where length(I.IMAGE_IMPORT_GROUP) = '12'
and substr(CS.JOB_ALPHA_NBR, 1, 10) != NULL
and I.ODS_MODIFY_DATE >= ( TO_DATE(SUBSTR('1900-01-01 14:01:35', 1, 19), 'YYYY-MM-DD HH24:MI:SS') - .0233)
group by IMAGE_IMPORT_GROUP || lpad(i.CAPTURE_SEQUENCE,4,'0')||to_number(substr(e.school_year, 3, 2)-1),CS.EVENT_OID,substr(CS.JOB_ALPHA_NBR, 1, 10),i.ODS_MODIFY_DATE
ORDER BY I.ODS_MODIFY_DATE DESC


select distinct
IT.EVENT_REF_ID,
E.PLANT_RECEIPT_DATE
from ODS_OWN.IMAGE_TRACKING IT
join ODS_OWN.EVENT E on IT.EVENT_REF_ID = E.EVENT_REF_ID
where E.ROLLOVER_JOB_IND = 'X'
and IT.ODS_MODIFY_DATE >= ( TO_DATE(SUBSTR('2024-01-01 14:01:35', 1, 19), 'YYYY-MM-DD HH24:MI:SS') - .0233)


INSERT INTO tmp_Image_Track_RollOver_Fix (EVENT_REF_ID,PLANT_RECEIPT_DATE) values('LN565313Q0',)

SELECT * FROM ODS_OWN.IMAGE_TRACKING ORDER BY ODS_MODIFY_DATE

SELECT * FROM ODS_OWN.IMAGE_TRACKING WHERE EVENT_REF_ID = 'LN565313Q0'

--IMAGE_TRACKING_OID|SOURCE_SYSTEM|SOURCE_SYSTEM_KEY |EVENT_REF_ID|PLANT_NODE|SOURCE_CREATE_DATE |CIR_RECEIVE_DATE|SUBJECT_MATCH_DATE|IGNORE_FLAG|IGNORE_DATE|IGNORE_REASON|IGNORE_BY_USER|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
--------------------+-------------+------------------+------------+----------+-------------------+----------------+------------------+-----------+-----------+-------------+--------------+-------------------+-------------------+
--           1008358|FOX          |LN56Q313Q001002815|LN565313Q0  |Q         |2015-06-09 00:00:00|                |                  |N          |           |             |              |2015-08-13 15:34:54|2015-08-13 15:34:54|
--           1008363|FOX          |LN56Q312Q002000815|LN565312Q0  |Q         |2015-06-09 00:00:00|                |                  |N          |           |             |              |2015-08-13 15:34:54|2015-08-13 15:34:54|
--           1008368|FOX          |LN56Q312Q001001315|LN565312Q0  |Q         |2015-06-09 00:00:00|                |                  |N          |           |             |              |2015-08-13 15:34:54|2015-08-13 15:34:54|
--           1007955|FOX          |LN56Q761QP02001615|LN565761QP  |Q         |2015-06-04 00:00:00|                |                  |N          |           |             |              |2015-08-13 15:34:54|2015-08-13 15:34:54|
--           1007957|FOX          |LN56Q761QP02001715|LN565761QP  |Q         |2015-06-04 00:00:00|                |                  |N          |           |             |              |2015-08-13 15:34:54|2015-08-13 15:34:54|
--           1007959|FOX          |LN56Q759QP01002415|LN565759QP  |Q         |2015-06-04 00:00:00|                |                  |N          |           |             |              |2015-08-13 15:34:54|2015-08-13 15:34:54|


--CREATE TABLE TMP_SM_MATCH_MISSING_EVENTOID AS
select tmp.SSK || to_number(substr(e.school_year, 3, 2)-1) as NEW_SSK, tmp.EVENT_OID, tmp.SSK as OLD_SSK
from TMP_SUBJECT_MASTER_MATCH_DATE tmp
join ODS_OWN.EVENT E on tmp.JOB_NUM = E.EVENT_REF_ID
where tmp.EVENT_OID = '-1'

INSERT INTO TMP_SUBJECT_MASTER_MATCH_DATE(SSK,EVENT_OID,JOB_NUM,ODS_MODIFY_DATE) values(0,-1,'LN651630Y0',sysdate)


-- Run the dag

SELECT max(ODS_MODIFY_DATE),max(SOURCE_CREATE_DATE) FROM ODS_OWN.IMAGE_TRACKING

SELECT * FROM tmp_Image_Track_RollOver_Fix

SELECT * FROM TMP_SUBJECT_MASTER_MATCH_DATE

SELECT * FROM TMP_SM_MATCH_MISSING_EVENTOID


UPDATE TMP_SUBJECT_MASTER_MATCH_DATE SM_TEMP
SET
(
SM_TEMP.SSK
)
=
(
SELECT
temp.NEW_SSK
FROM TMP_SM_MATCH_MISSING_EVENTOID temp
where SM_TEMP.SSK = temp.OLD_SSK and SM_TEMP.EVENT_OID = '-1'
)
where exists
(select 1 from TMP_SM_MATCH_MISSING_EVENTOID temp where SM_TEMP.SSK = temp.OLD_SSK and SM_TEMP.EVENT_OID = '-1')


SELECT max(SOURCE_CREATE_DATE) FROM ODS_OWN.IMAGE_TRACKING

SELECT * FROM TMP_SUBJECT_MASTER_MATCH_DATE WHERE EVENT_OID = '-1'

select tmp.SSK || to_number(substr(e.school_year, 3, 2)-1) as NEW_SSK, tmp.EVENT_OID, tmp.SSK as OLD_SSK
from TMP_SUBJECT_MASTER_MATCH_DATE tmp
join ODS_OWN.EVENT E on tmp.JOB_NUM = E.EVENT_REF_ID
where tmp.EVENT_OID = '-1'

SELECT * FROM TMP_SM_MATCH_MISSING_EVENTOID where

SELECT
temp.NEW_SSK
FROM TMP_SM_MATCH_MISSING_EVENTOID temp
where SM_TEMP.SSK = temp.OLD_SSK and SM_TEMP.EVENT_OID = '-1'


select distinct CIR.SOURCE_SYSTEM_CODE as SSK, CIR.AUDIT_CREATE_DATE as CIR_MATCH_DATE
from ODS_STAGE.CIR_IMAGE_GROUP CIR
join ODS_OWN.IMAGE_TRACKING IT
on CIR.SOURCE_SYSTEM_CODE = IT.SOURCE_SYSTEM_KEY
where IT.CIR_RECEIVE_DATE is null
and CIR.ODS_MODIFY_DATE >= ( TO_DATE(SUBSTR('2017-01-01 14:01:35', 1, 19), 'YYYY-MM-DD HH24:MI:SS') - .0233)

  select tmp.SSK || to_number(substr(e.school_year, 3, 2)-1) as NEW_SSK, tmp.EVENT_OID, tmp.SSK as OLD_SSK
from TMP_SUBJECT_MASTER_MATCH_DATE tmp
join ODS_OWN.EVENT E on tmp.JOB_NUM = E.EVENT_REF_ID
where tmp.EVENT_OID = '-1'
