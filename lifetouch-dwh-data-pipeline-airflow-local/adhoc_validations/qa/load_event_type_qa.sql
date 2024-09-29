SELECT * FROM ODS_OWN.EVENT_TYPE WHERE EVENT_TYPE IN ('OTHER')
--EVENT_TYPE_OID|EVENT_TYPE|JOB_CLASSIFICATION|SOURCE_SYSTEM_OID|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |CREATED_BY|UPDATED_BY|
----------------+----------+------------------+-----------------+-------------------+-------------------+----------+----------+
--             6|OTHER     |Other             |                5|2014-01-28 09:47:23|2014-01-28 09:47:23|ODI_ETL   |ODI_ETL   |

SELECT *  FROM ODS_OWN.EVENT_TYPE WHERE EVENT_TYPE_OID = '6'
--EVENT_TYPE_OID|EVENT_TYPE|JOB_CLASSIFICATION|SOURCE_SYSTEM_OID|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |CREATED_BY|UPDATED_BY|
----------------+----------+------------------+-----------------+-------------------+-------------------+----------+----------+
--             6|OTHER     |Other             |                5|2014-01-28 09:47:23|2014-01-28 09:47:23|ODI_ETL   |ODI_ETL   |


UPDATE ODS_OWN.EVENT_TYPE
SET JOB_CLASSIFICATION = 'test', SOURCE_SYSTEM_OID = 0 , UPDATED_BY= 'test'
WHERE EVENT_TYPE_OID = '6'


SELECT *  FROM ODS_OWN.EVENT_TYPE WHERE EVENT_TYPE_OID = '6'
--EVENT_TYPE_OID|EVENT_TYPE|JOB_CLASSIFICATION|SOURCE_SYSTEM_OID|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |CREATED_BY|UPDATED_BY|
----------------+----------+------------------+-----------------+-------------------+-------------------+----------+----------+
--             6|OTHER     |test              |                0|2014-01-28 09:47:23|2014-01-28 09:47:23|ODI_ETL   |test      |

         -- Run The dag

SELECT *  FROM ODS_OWN.EVENT_TYPE WHERE EVENT_TYPE_OID = '6'
--EVENT_TYPE_OID|EVENT_TYPE|JOB_CLASSIFICATION|SOURCE_SYSTEM_OID|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |CREATED_BY|UPDATED_BY|
----------------+----------+------------------+-----------------+-------------------+-------------------+----------+----------+
--             6|OTHER     |Other             |                5|2014-01-28 09:47:23|2024-08-08 06:25:01|ODI_ETL   |ODI_ETL   |


----------------------------------------------------------------------------------

SELECT * FROM ODS_STAGE.EVENT_TYPE_JOB_CLASS_MAPPING ORDER BY ods_modify_date DESC FETCH FIRST 50 ROWS ONLY;

select s.event_type    as event_type
         , s.job_classification    as job_classification
        , xr.event_type_oid    as event_type_oid
        , ss.source_system_oid   as source_system_oid
    from ODS_OWN.SOURCE_SYSTEM    ss , RAX_APP_USER.TMP_EVENT_TYPE_XR_STG s , ODS_STAGE.EVENT_TYPE_XR xr
    where ss.source_system_name='Data Warehouse' AND xr.event_type=s.event_type
-- EVENT_TYPE |JOB_CLASSIFICATION|EVENT_TYPE_OID|SOURCE_SYSTEM_OID|
-------------+------------------+--------------+-----------------+
--ORIGINAL   |Original          |             1|                5|
--RETAKE     |Retake            |             2|                5|
--CANDID     |Candid            |             3|                5|
--SERVICEONLY|Service Only      |             4|                5|
--HOUSE      |House Account     |             5|                5|
--OTHER      |Other             |             6|                5|