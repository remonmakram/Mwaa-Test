 SELECT   *
 FROM RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT R_CDC
 WHERE TABLE_NAME IN ('SUBJECT_APO','MART_SUBJECT','SUBJECT_ACTIVITY_FACT')
  AND CREATE_DATE > SYSDATE - INTERVAL '60' MINUTE
--  AND (TABLE_NAME ='AIR_ASSET_REQUREST' OR SESS_NAME ='LOAD_AIR_ASSET_REQUEST_PKG')


 SELECT   (O_CDC.LAST_CDC_COMPLETION_DATE-R_CDC.ORIG_LAST_CDC_COMPLETION_DATE ) * 1440 AS minutes_difference ,R_CDC.*, O_CDC.LAST_CDC_COMPLETION_DATE
 FROM RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT R_CDC
 LEFT JOIN ods_own.ods_cdc_load_status O_CDC
 ON R_CDC.TABLE_NAME  = O_CDC.ODS_TABLE_NAME
 WHERE TABLE_NAME IN ('SUBJECT_APO','MART_SUBJECT','SUBJECT_ACTIVITY_FACT')
  AND CREATE_DATE > SYSDATE - INTERVAL '60' MINUTE
  ORDER BY table_name DESC


------------------------------------------ Validate APO PKG --------------------------------------------------------------------------------

SELECT * FROM ODS_OWN.subject_apo ORDER BY ods_modify_date DESC FETCH FIRST 5 ROWS ONLY;

--SUBJECT_APO_OID|SUBJECT_OID|APO_OID  |PIPELINE_SUB_STATUS|SESSION_TYPE  |CHANNEL_TYPE  |BUYER_TYPE      |IMAGE_QTY|ORDERED_IMAGE_QTY|RECIPE_QTY|ORDERED_RECIPE_QTY|ORDER_DATE         |SECOND_ORDER_DATE  |PHOTOGRAPHY_DATE   |SECOND_PHOTOGRAPHY_DATE|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |PRICE_AMOUNT|PAID_ORDER_QTY|DIGITAL_BUYER_IND|FIRST_ORDER_HEADER_OID|SECOND_ORDER_HEADER_OID|
-----------------+-----------+---------+-------------------+--------------+--------------+----------------+---------+-----------------+----------+------------------+-------------------+-------------------+-------------------+-----------------------+-------------------+-------------------+------------+--------------+-----------------+----------------------+-----------------------+
--        2144381|  119486672| 90001062|Paid Buyer         |Single Session|Multi-Channel |None (Non-Buyer)|        1|                 |          |                 2|2022-01-19 08:31:06|2022-01-21 06:26:06|2024-07-03 00:00:00|                       |2021-08-26 10:08:37|2024-08-01 04:54:46|   111006.29|           917|N                |            1667575671|             1678315677|
--        2732415|  121098790|124385953|Unpaid Buyer       |Single Session|Single Channel|None (Non-Buyer)|        1|                 |          |                 0|2024-07-31 05:53:09|                   |2023-12-21 00:00:00|                       |2023-12-19 07:43:01|2024-07-31 07:54:36|           0|             0|Y                |           10525056849|                       |
--        2801645|  121186311|126036479|Paid Buyer         |Single Session|Multi-Channel |None (Non-Buyer)|        1|                 |          |                 2|2024-01-30 04:29:49|2024-02-20 07:48:51|2024-01-29 00:00:00|                       |2024-01-29 20:48:34|2024-07-31 04:40:16|      380.99|             9|Y                |            8187839398|             8441367342|
--        2832972|  121201987|127277546|Paid Buyer         |Single Session|Multi-Channel |None (Non-Buyer)|        3|                 |          |                41|2024-02-28 08:36:20|2024-02-28 08:36:21|2024-02-28 00:00:00|                       |2024-02-28 09:34:09|2024-07-30 12:39:21|     2837.52|            38|Y                |            8543857320|             8543857269|
--        2786470|  121179068|125783302|Paid Buyer         |Single Session|Multi-Channel |Sheet Builders  |        1|                 |          |                 2|2024-01-24 03:43:18|2024-07-19 10:10:00|2024-01-23 00:00:00|                       |2024-01-23 16:37:37|2024-07-30 08:39:09|      413.19|            14|N                |            8116012241|            10362058612|


SELECT count(*) FROM ODS_OWN.subject_apo

--COUNT(*)|
----------+
--  579822|

SELECT * FROM ODS_OWN.subject_apo WHERE SUBJECT_OID = '119486672' AND APO_OID = '90001062'
--SUBJECT_APO_OID|SUBJECT_OID|APO_OID |PIPELINE_SUB_STATUS|SESSION_TYPE  |CHANNEL_TYPE |BUYER_TYPE      |IMAGE_QTY|ORDERED_IMAGE_QTY|RECIPE_QTY|ORDERED_RECIPE_QTY|ORDER_DATE         |SECOND_ORDER_DATE  |PHOTOGRAPHY_DATE   |SECOND_PHOTOGRAPHY_DATE|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |PRICE_AMOUNT|PAID_ORDER_QTY|DIGITAL_BUYER_IND|FIRST_ORDER_HEADER_OID|SECOND_ORDER_HEADER_OID|
-----------------+-----------+--------+-------------------+--------------+-------------+----------------+---------+-----------------+----------+------------------+-------------------+-------------------+-------------------+-----------------------+-------------------+-------------------+------------+--------------+-----------------+----------------------+-----------------------+
--        2144381|  119486672|90001062|Paid Buyer         |Single Session|Multi-Channel|None (Non-Buyer)|        1|                 |          |                 2|2022-01-19 08:31:06|2022-01-21 06:26:06|2024-07-03 00:00:00|                       |2021-08-26 10:08:37|2024-08-01 04:54:46|   111006.29|           917|N                |            1667575671|             1678315677|

DELETE FROM ODS_OWN.subject_apo WHERE SUBJECT_OID = '119486672' AND APO_OID = '90001062'

SELECT count(*) FROM ODS_OWN.subject_apo
--COUNT(*)|
----------+
--  579821|

SELECT * FROM ODS_OWN.subject_apo WHERE SUBJECT_OID = '119486672' AND APO_OID = '90001062'
--SUBJECT_APO_OID|SUBJECT_OID|APO_OID|PIPELINE_SUB_STATUS|SESSION_TYPE|CHANNEL_TYPE|BUYER_TYPE|IMAGE_QTY|ORDERED_IMAGE_QTY|RECIPE_QTY|ORDERED_RECIPE_QTY|ORDER_DATE|SECOND_ORDER_DATE|PHOTOGRAPHY_DATE|SECOND_PHOTOGRAPHY_DATE|ODS_CREATE_DATE|ODS_MODIFY_DATE|PRICE_AMOUNT|PAID_ORDER_QTY|DIGITAL_BUYER_IND|FIRST_ORDER_HEADER_OID|SECOND_ORDER_HEADER_OID|
-----------------+-----------+-------+-------------------+------------+------------+----------+---------+-----------------+----------+------------------+----------+-----------------+----------------+-----------------------+---------------+---------------+------------+--------------+-----------------+----------------------+-----------------------+

UPDATE ods_own.ods_cdc_load_status
SET last_cdc_completion_date = TO_DATE(SUBSTR('2024-07-31 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
WHERE ods_table_name= 'SUBJECT_APO'

--
---- Run Dag
--

SELECT count(*) FROM ODS_OWN.subject_apo
--COUNT(*)|
----------+
--  579822|

SELECT * FROM ODS_OWN.subject_apo WHERE SUBJECT_OID = '119486672' AND APO_OID = '90001062'

--SUBJECT_APO_OID|SUBJECT_OID|APO_OID |PIPELINE_SUB_STATUS|SESSION_TYPE  |CHANNEL_TYPE |BUYER_TYPE      |IMAGE_QTY|ORDERED_IMAGE_QTY|RECIPE_QTY|ORDERED_RECIPE_QTY|ORDER_DATE         |SECOND_ORDER_DATE  |PHOTOGRAPHY_DATE   |SECOND_PHOTOGRAPHY_DATE|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |PRICE_AMOUNT|PAID_ORDER_QTY|DIGITAL_BUYER_IND|FIRST_ORDER_HEADER_OID|SECOND_ORDER_HEADER_OID|
-----------------+-----------+--------+-------------------+--------------+-------------+----------------+---------+-----------------+----------+------------------+-------------------+-------------------+-------------------+-----------------------+-------------------+-------------------+------------+--------------+-----------------+----------------------+-----------------------+
--        2999582|  119486672|90001062|Paid Buyer         |Single Session|Multi-Channel|None (Non-Buyer)|        1|                 |          |                 2|2022-01-19 08:31:06|2022-01-21 06:26:06|2024-07-03 00:00:00|                       |2024-08-01 05:09:21|2024-08-01 05:09:22|   111006.29|           917|N                |            1667575671|             1678315677|

------------------------------------------ Validate Mart Subject PKG --------------------------------------------------------------------------------

SELECT * FROM RAX_APP_USER.subject_activity_STAGE2

SELECT * FROM MART.subject_activity_FACT ORDER BY MART_MODIFY_DATE DESC FETCH FIRST 5 ROWS ONLY;

SELECT * FROM ODS_STAGE.subject_activity_CURR ORDER BY MODIFY_DATE DESC FETCH FIRST 5 ROWS ONLY;


--SUBJECT_ACTIVITY_CURR_ID|SUBJECT_APO_OID|ACCOUNT_ID|SUBJECT_ID|APO_ID  |MARKETING_ID|JOB_TICKET_ORG_ID|ASSIGNMENT_ID|ASSIGNMENT_EFFECTIVE_DATE|TRANS_DATE         |PHOTOGRAPHY_DATE   |PIPELINE_STATUS_ID|YEARBOOK_STATUS_NAME|SUBJECT_JUNK_ID|SUBJECT_ACTIVITY_JUNK_ID|ORDER_DATE         |SECOND_PHOTOGRAPHY_DATE|SECOND_ORDER_DATE  |IMAGE_QTY|ORDERED_IMAGE_QTY|OCCURS|RECIPE_QTY|ORDERED_RECIPE_QTY|MODIFY_DATE        |CREATE_DATE        |PRICE_AMOUNT|PAID_ORDER_QTY|
--------------------------+---------------+----------+----------+--------+------------+-----------------+-------------+-------------------------+-------------------+-------------------+------------------+--------------------+---------------+------------------------+-------------------+-----------------------+-------------------+---------+-----------------+------+----------+------------------+-------------------+-------------------+------------+--------------+
--                  877109|        2732415|  20802852| 681346455|10405417|         275|              120|     41275577|      2023-02-13 11:24:56|2024-07-31 00:00:00|2023-12-21 00:00:00|               165|N/A                 |           1035|                     146|2024-07-31 05:53:09|    1900-01-01 00:00:00|1900-01-01 00:00:00|        1|                0|     1|         0|                 0|2024-07-31 07:55:05|2024-07-31 07:55:05|           0|             0|
--                  877115|        2801645|  27982923| 681346452|10411511|         281|           880007|     48391755|      2023-06-28 10:10:05|2024-07-31 00:00:00|2024-01-29 00:00:00|               164|N/A                 |           1039|                      96|2024-01-30 04:29:49|    1900-01-01 00:00:00|2024-02-20 07:48:51|        1|                0|     1|         0|                 2|2024-07-31 04:40:21|2024-07-31 04:40:21|      380.99|             9|
--                  877103|        2832972|  20802852| 679477420|10415376|         275|              120|     41275577|      2023-02-13 11:24:56|2024-07-29 00:00:00|2024-02-28 00:00:00|               164|N/A                 |           1037|                      96|2024-02-28 08:36:20|    1900-01-01 00:00:00|2024-02-28 08:36:21|        3|                0|     1|         0|                41|2024-07-30 12:39:25|2024-07-29 15:34:26|     2837.52|            38|
--                  877102|        2786470|  20802852| 679477419|10410620|     5555649|              120|     41275827|      2023-02-13 11:24:56|2024-07-29 00:00:00|2024-01-23 00:00:00|               164|N/A                 |           1032|                     174|2024-01-24 03:43:18|    1900-01-01 00:00:00|2024-07-19 10:10:00|        1|                0|     1|         0|                 2|2024-07-30 08:39:14|2024-07-29 15:34:26|      413.19|            14|
--                  877104|        2897056|  20802837| 679477421|10424128|         275|              120|     41276030|      2023-02-13 11:24:56|2024-07-29 00:00:00|2024-05-15 00:00:00|               164|N/A                 |           1037|                     146|2024-07-15 14:10:01|    1900-01-01 00:00:00|2024-07-15 15:10:00|        1|                0|     1|         0|                 2|2024-07-30 08:39:14|2024-07-29 15:34:26|     1465.82|            36|

SELECT count(*) FROM ODS_STAGE.subject_activity_CURR
--COUNT(*)|
----------+
--  435861|

SELECT * FROM ODS_STAGE.subject_activity_CURR WHERE SUBJECT_APO_OID='2732415' AND SUBJECT_ID='681346455' AND APO_ID ='10405417'

--SUBJECT_ACTIVITY_CURR_ID|SUBJECT_APO_OID|ACCOUNT_ID|SUBJECT_ID|APO_ID  |MARKETING_ID|JOB_TICKET_ORG_ID|ASSIGNMENT_ID|ASSIGNMENT_EFFECTIVE_DATE|TRANS_DATE         |PHOTOGRAPHY_DATE   |PIPELINE_STATUS_ID|YEARBOOK_STATUS_NAME|SUBJECT_JUNK_ID|SUBJECT_ACTIVITY_JUNK_ID|ORDER_DATE         |SECOND_PHOTOGRAPHY_DATE|SECOND_ORDER_DATE  |IMAGE_QTY|ORDERED_IMAGE_QTY|OCCURS|RECIPE_QTY|ORDERED_RECIPE_QTY|MODIFY_DATE        |CREATE_DATE        |PRICE_AMOUNT|PAID_ORDER_QTY|
------------------------+---------------+----------+----------+--------+------------+-----------------+-------------+-------------------------+-------------------+-------------------+------------------+--------------------+---------------+------------------------+-------------------+-----------------------+-------------------+---------+-----------------+------+----------+------------------+-------------------+-------------------+------------+--------------+
--                  877109|        2732415|  20802852| 681346455|10405417|         275|              120|     41275577|      2023-02-13 11:24:56|2024-07-31 00:00:00|2023-12-21 00:00:00|               165|N/A                 |           1035|                     146|2024-07-31 05:53:09|    1900-01-01 00:00:00|1900-01-01 00:00:00|        1|                0|     1|         0|                 0|2024-07-31 07:55:05|2024-07-31 07:55:05|           0|             0|

DELETE FROM   ODS_STAGE.subject_activity_CURR  WHERE SUBJECT_APO_OID='2732415' AND SUBJECT_ID='681346455' AND APO_ID ='10405417'


SELECT count(*) FROM ODS_STAGE.subject_activity_CURR
--COUNT(*)|
----------+
--  435860|

UPDATE ods_own.ods_cdc_load_status
SET last_cdc_completion_date = TO_DATE(SUBSTR('2024-07-31 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
WHERE ods_table_name= 'SUBJECT_ACTIVITY_FACT'

SELECT * FROM ODS_STAGE.subject_activity_CURR WHERE SUBJECT_APO_OID='2732415' AND SUBJECT_ID='681346455' AND APO_ID ='10405417'
--SUBJECT_ACTIVITY_CURR_ID|SUBJECT_APO_OID|ACCOUNT_ID|SUBJECT_ID|APO_ID|MARKETING_ID|JOB_TICKET_ORG_ID|ASSIGNMENT_ID|ASSIGNMENT_EFFECTIVE_DATE|TRANS_DATE|PHOTOGRAPHY_DATE|PIPELINE_STATUS_ID|YEARBOOK_STATUS_NAME|SUBJECT_JUNK_ID|SUBJECT_ACTIVITY_JUNK_ID|ORDER_DATE|SECOND_PHOTOGRAPHY_DATE|SECOND_ORDER_DATE|IMAGE_QTY|ORDERED_IMAGE_QTY|OCCURS|RECIPE_QTY|ORDERED_RECIPE_QTY|MODIFY_DATE|CREATE_DATE|PRICE_AMOUNT|PAID_ORDER_QTY|
--------------------------+---------------+----------+----------+------+------------+-----------------+-------------+-------------------------+----------+----------------+------------------+--------------------+---------------+------------------------+----------+-----------------------+-----------------+---------+-----------------+------+----------+------------------+-----------+-----------+------------+--------------+

--
---- Run Dag
--

SELECT count(*) FROM ODS_STAGE.subject_activity_CURR

--COUNT(*)|
----------+
--  435861|

SELECT * FROM ODS_STAGE.subject_activity_CURR WHERE SUBJECT_APO_OID='2732415' AND SUBJECT_ID='681346455' AND APO_ID ='10405417'

--SUBJECT_ACTIVITY_CURR_ID|SUBJECT_APO_OID|ACCOUNT_ID|SUBJECT_ID|APO_ID  |MARKETING_ID|JOB_TICKET_ORG_ID|ASSIGNMENT_ID|ASSIGNMENT_EFFECTIVE_DATE|TRANS_DATE         |PHOTOGRAPHY_DATE   |PIPELINE_STATUS_ID|YEARBOOK_STATUS_NAME|SUBJECT_JUNK_ID|SUBJECT_ACTIVITY_JUNK_ID|ORDER_DATE         |SECOND_PHOTOGRAPHY_DATE|SECOND_ORDER_DATE  |IMAGE_QTY|ORDERED_IMAGE_QTY|OCCURS|RECIPE_QTY|ORDERED_RECIPE_QTY|MODIFY_DATE        |CREATE_DATE        |PRICE_AMOUNT|PAID_ORDER_QTY|
--------------------------+---------------+----------+----------+--------+------------+-----------------+-------------+-------------------------+-------------------+-------------------+------------------+--------------------+---------------+------------------------+-------------------+-----------------------+-------------------+---------+-----------------+------+----------+------------------+-------------------+-------------------+------------+--------------+
--                  877109|        2732415|  20802852| 681346455|10405417|         275|              120|     41275577|      2023-02-13 11:24:56|2024-07-31 00:00:00|2023-12-21 00:00:00|               165|N/A                 |           1035|                     146|2024-07-31 05:53:09|    1900-01-01 00:00:00|1900-01-01 00:00:00|        1|                0|     1|         0|                 0|2024-07-31 07:55:05|2024-07-31 07:55:05|           0|             0|

  ------------------------------------------ Validate Mart Subject PKG --------------------------------------------------------------------------------
SELECT distinct load_id FROM MART.SUBJECT

SELECT count(*) FROM Mart.subject
--COUNT(*) |
-----------+
--362328369|


SELECT * FROM MART.subject ORDER BY EFFECTIVE_DATE DESC FETCH FIRST 5 ROWS ONLY;
--SUBJECT_ID|EFFECTIVE_DATE     |LOAD_ID   |ACTIVE_IND|SOURCE_SYSTEM_KEY|SOURCE_SYSTEM_NAME|LIFETOUCH_ID|SUBJECT_TYPE|SUBJECT_FIRST_NAME|SUBJECT_LAST_NAME|SUBJECT_MIDDLE_NAME|GRADE|TEACHER_NBR|TEACHER_NAME|LINE|HOMEROOM|PERIOD|ADDRESS_LINE1  |ADDRESS_LINE2|CITY        |STATE|POSTAL_CODE|HOME_PHONE|WORK_PHONE|PARENT_NAME|EMAIL_ADDRESS|MALE_FEMALE_CODE|MAJOR|MINOR|SQUADRON|CLASS|WIN_YEARBOOK_POSE_SELECTION1|WIN_YEARBOOK_POSE_SELECTION2|STU_YEARBOOK_POSE_SELECTION1|STU_YEARBOOK_POSE_SELECTION2|EXTN_SUBJECT_ID                     |STATUS|SUBJECT_OID|PHONE_NUMBER|
------------+-------------------+----------+----------+-----------------+------------------+------------+------------+------------------+-----------------+-------------------+-----+-----------+------------+----+--------+------+---------------+-------------+------------+-----+-----------+----------+----------+-----------+-------------+----------------+-----+-----+--------+-----+----------------------------+----------------------------+----------------------------+----------------------------+------------------------------------+------+-----------+------------+
-- 681346454|2024-07-31 08:40:29|6760548102|A         |2063545032       |SM                |          -1|.           |Anthony           |Johnson          |.                  |.    |.          |            |.   |.       |.     |11000 VIKING DR|             |EDEN PRAIRIE|MN   |55344      |.         |.         |.          |             |M               |     |     |        |     |                            |                            |                            |                            |                                    |Active|  122523946|            |
-- 681346453|2024-07-31 07:54:50|6760548102|A         |11356826         |SM                |          -1|Student     |Marie             |Kelly            |.                  |.    |.          |            |.   |.       |.     |11000 VIKING DR|             |EDEN PRAIRIE|MN   |55344      |.         |.         |.          |t@gmail.com  |F               |     |     |        |     |                            |                            |                            |                            |                                    |Active|  121179188|888-888-8888|
-- 681346455|2024-07-31 07:54:50|6760548102|.         |11260068         |SM                |          -1|Student     |THOMAS J          |BREITWEISER      |.                  |003  |211        |            |.   |8001    |03    |.              |.            |.           |.    |.          |.         |.         |.          |             |                |     |     |        |     |                            |                            |                            |                            |ac99a75c-6d8c-4115-9ceb-f5cbe9977df3|.     |  121098790|.           |
-- 681346450|2024-07-31 04:40:18|6760548102|.         |2063295032       |SM                |          -1|Student     |Austin            |Perf_Test_10363  |.                  |003  |.          |            |.   |.       |.     |.              |.            |.           |.    |.          |.         |.         |.          |             |                |     |     |        |     |                            |                            |                            |                            |                                    |.     |  122523943|.           |
-- 681346451|2024-07-31 04:40:18|6760548102|.         |2063295033       |SM                |          -1|Student     |Jacob             |Perf_Test_10387  |.                  |001  |.          |            |.   |.       |.     |.              |.            |.           |.    |.          |.         |.         |.          |             |                |     |     |        |     |                            |                            |                            |                            |                                    |.     |  122523944|.           |

SELECT * FROM MART.subject WHERE LOAD_ID ='6760548102' AND SUBJECT_OID ='122523946'

--SUBJECT_ID|EFFECTIVE_DATE     |LOAD_ID   |ACTIVE_IND|SOURCE_SYSTEM_KEY|SOURCE_SYSTEM_NAME|LIFETOUCH_ID|SUBJECT_TYPE|SUBJECT_FIRST_NAME|SUBJECT_LAST_NAME|SUBJECT_MIDDLE_NAME|GRADE|TEACHER_NBR|TEACHER_NAME|LINE|HOMEROOM|PERIOD|ADDRESS_LINE1  |ADDRESS_LINE2|CITY        |STATE|POSTAL_CODE|HOME_PHONE|WORK_PHONE|PARENT_NAME|EMAIL_ADDRESS|MALE_FEMALE_CODE|MAJOR|MINOR|SQUADRON|CLASS|WIN_YEARBOOK_POSE_SELECTION1|WIN_YEARBOOK_POSE_SELECTION2|STU_YEARBOOK_POSE_SELECTION1|STU_YEARBOOK_POSE_SELECTION2|EXTN_SUBJECT_ID|STATUS|SUBJECT_OID|PHONE_NUMBER|
------------+-------------------+----------+----------+-----------------+------------------+------------+------------+------------------+-----------------+-------------------+-----+-----------+------------+----+--------+------+---------------+-------------+------------+-----+-----------+----------+----------+-----------+-------------+----------------+-----+-----+--------+-----+----------------------------+----------------------------+----------------------------+----------------------------+---------------+------+-----------+------------+
-- 681346454|2024-07-31 08:40:29|6760548102|A         |2063545032       |SM                |          -1|.           |Anthony           |Johnson          |.                  |.    |.          |            |.   |.       |.     |11000 VIKING DR|             |EDEN PRAIRIE|MN   |55344      |.         |.         |.          |             |M               |     |     |        |     |                            |                            |                            |                            |               |Active|  122523946|            |

DELETE FROM mart.SUBJECT s WHERE LOAD_ID ='6760548102' AND SUBJECT_OID ='122523946'


UPDATE ods_own.ods_cdc_load_status
SET last_cdc_completion_date = TO_DATE(SUBSTR('2024-07-31 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
WHERE ods_table_name= 'MART_SUBJECT'

SELECT count(*) FROM Mart.subject
--COUNT(*)
-----------
--362328368


-- RUN the DAG
SELECT count(*) FROM Mart.subject

--COUNT(*) |
-----------+
--362328369|

SELECT * FROM MART.subject WHERE LOAD_ID ='6760548102' AND SUBJECT_OID ='122523946'

--SUBJECT_ID|EFFECTIVE_DATE     |LOAD_ID   |ACTIVE_IND|SOURCE_SYSTEM_KEY|SOURCE_SYSTEM_NAME|LIFETOUCH_ID|SUBJECT_TYPE|SUBJECT_FIRST_NAME|SUBJECT_LAST_NAME|SUBJECT_MIDDLE_NAME|GRADE|TEACHER_NBR|TEACHER_NAME|LINE|HOMEROOM|PERIOD|ADDRESS_LINE1  |ADDRESS_LINE2|CITY        |STATE|POSTAL_CODE|HOME_PHONE|WORK_PHONE|PARENT_NAME|EMAIL_ADDRESS|MALE_FEMALE_CODE|MAJOR|MINOR|SQUADRON|CLASS|WIN_YEARBOOK_POSE_SELECTION1|WIN_YEARBOOK_POSE_SELECTION2|STU_YEARBOOK_POSE_SELECTION1|STU_YEARBOOK_POSE_SELECTION2|EXTN_SUBJECT_ID|STATUS|SUBJECT_OID|PHONE_NUMBER|
------------+-------------------+----------+----------+-----------------+------------------+------------+------------+------------------+-----------------+-------------------+-----+-----------+------------+----+--------+------+---------------+-------------+------------+-----+-----------+----------+----------+-----------+-------------+----------------+-----+-----+--------+-----+----------------------------+----------------------------+----------------------------+----------------------------+---------------+------+-----------+------------+
-- 681346459|2024-08-01 04:38:50|6760548102|A         |2063545032       |SM                |          -1|.           |Anthony           |Johnson          |.                  |.    |.          |            |.   |.       |.     |11000 VIKING DR|             |EDEN PRAIRIE|MN   |55344      |.         |.         |.          |             |M               |     |     |        |     |                            |                            |                            |                            |               |Active|  122523946|            |
 -----------------------------------------------------------------------------------------------------------------------

        SELECT
    sysdate effective_date
    ,6760548102 as load_id
    ,CASE s.active
        WHEN 1 THEN 'A'
        WHEN 0 THEN 'I'
        ELSE '.'
     END as active_ind
    ,XR.SUBJECT_ID source_system_key
    ,ss.source_system_short_name source_system_name
    ,-1 as lifetouch_id
    ,CASE staff_flag
        WHEN '1' THEN 'Staff'
        WHEN '0' THEN 'Student'
        ELSE '.'
     END as subject_type
    ,NVL (s.first_name, '.') as subject_first_name
    ,NVL (s.last_name, '.') as subject_last_name
    ,NVL (s.middle_name, '.') as subject_middle_name
    ,NVL (s.grade, '.') as grade
    ,NVL (s.teacher_nbr, '.') as teacher_nbr
    ,s.teacher_first_name || ' ' || (CASE s.teacher_middle_name WHEN NULL THEN NULL ELSE s.teacher_middle_name || ' ' END) || s.teacher_last_name as teacher_name
    ,'.' as line
    ,NVL (s.home_room, '.') as homeroom
    ,NVL (s.period, '.') as period
    ,NVL (s.address_line_1, '.') as address_line1
    ,NVL (s.address_line_2, '.') as address_line2
    ,NVL (s.city, '.') as city
    ,NVL (s.state, '.') as state
    ,NVL (s.postal_code, NVL (s.zip, '.')) as postal_code
    ,'.' as home_phone
    ,'.' as work_phone
    ,'.' as parent_name
    ,s.email_address as email_address
    ,s.gender_code as male_female_code
    ,s.major as major
    ,s.minor as minor
    ,substr(s.squadron,1,20) as squadron
    ,substr(s.external_subject_id,1,40) as extn_subject_id
    ,CASE s.active
         WHEN 1 THEN 'Active'
         WHEN 0 THEN 'Inactive'
         ELSE '.' END as status
    ,s.subject_oid as subject_oid
    ,NVL (s.phone_number, '.')  as phone_number
FROM
    ODS_OWN.subject s
    ,ODS_OWN.source_system ss
    ,ODS_STAGE.SUBJECT_XR xr
    ,late_subject_dim d
WHERE (1=1)
    and s.source_system_oid = ss.source_system_oid
    and S.SUBJECT_OID = XR.SUBJECT_OID
    and d.subject_oid = s.subject_oid
    and XR.SUBJECT_ID is not null
    and xr.SYSTEM_OF_RECORD = 'SM'
    AND