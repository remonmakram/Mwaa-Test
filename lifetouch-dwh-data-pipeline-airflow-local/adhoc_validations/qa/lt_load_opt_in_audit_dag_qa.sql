

--------------------------------------------------------------------------------------------------------------

SELECT * FROM ODS.DW_CDC_LOAD_STATUS
WHERE DW_TABLE_NAME = 'OPT_IN_AUDIT'
--ODS_TABLE_NAME        |LAST_CDC_COMPLETION_DATE|CONTEXT_NAME|TIMEZONE_OFFSET|
------------------------+------------------------+------------+---------------+
--SFLY_COUPON_MLT_V2_TMP|     2024-09-02 06:57:43|QA          |               |


SELECT * FROM RAX_APP_USER.DW_CDC_LOAD_STATUS_AUDIT
WHERE sess_name  = 'LOAD_OPT_IN_AUDIT_PKG'

SELECT * FROM ODS_OWN.AIRFLOW_PACKAGESTATS
WHERE PROCESS_NAME = 'lt_load_opt_in_audit_dag'

SELECT * FROM ods_own.ods_cdc_load_status
WHERE ODS_TABLE_NAME  = 'OPT_IN_AUDIT'

SELECT last_cdc_completion_date
FROM ods_own.ods_cdc_load_status
WHERE ods_table_name = 'OPT_IN_AUDIT'
AND context_name = 'QA'

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET last_cdc_completion_date = TO_DATE(SUBSTR('2024-07-31 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
WHERE ods_table_name= 'SFLY_COUPON_MLT_V2_TMP'

SELECT * FROM RAX_APP_USER.C$_0Y0LT_SUBJECT_OPT_IN_AUDIT

SELECT * FROM ODS.Y0LT_SUBJECT_OPT_IN_AUDIT ORDER BY EFFECTIVE_DATE DESC FETCH FIRST 5 ROWS ONLY;

SELECT * FROM ODS.Y0LT_SUBJECT_OPT_IN_AUDIT WHERE SUBJECT_OPT_IN_AUDIT_KEY ='20240828150431527027772'
--Y0LT_SUBJ_OPT_INT_ID|EFFECTIVE_DATE     |SUBJECT_OPT_IN_AUDIT_KEY|SUBJECT_KEY             |SUBJECT_ID|TCPA_OPT_IN_OLD|CASL_OPT_IN_OLD|TCPA_OPT_IN_NEW|CASL_OPT_IN_NEW|EMAIL_ADDRESS_OLD|PHONE_NUMBER_OLD|EMAIL_ADDRESS_NEW     |PHONE_NUMBER_NEW|CREATETS           |MODIFYTS           |CREATEUSERID    |MODIFYUSERID    |CREATEPROGID|MODIFYPROGID|LOCKID|ALT_EMAIL_ADDRESS_OLD|ALT_EMAIL_ADDRESS_NEW|ALTERNATE_PHONE_NUMBER_OLD|ALTERNATE_PHONE_NUMBER_NEW|
----------------------+-------------------+------------------------+------------------------+----------+---------------+---------------+---------------+---------------+-----------------+----------------+----------------------+----------------+-------------------+-------------------+----------------+----------------+------------+------------+------+---------------------+---------------------+--------------------------+--------------------------+
--                    |2024-09-02 07:44:58|20240828150431527027772 |20240828150431527027767 |D6288     |               |               |N              |N              |                 |                |ramyhelena@yopmail.com|                |2024-08-28 15:04:30|2024-08-28 15:04:30|spec.cc-ast-part|spec.cc-ast-part|Console     |Console     |     0|                     |                     |                          |                          |


SELECT count(*) FROM ODS.Y0LT_SUBJECT_OPT_IN_AUDIT
--COUNT(*)|
----------+
--    8958|


delete FROM ODS.Y0LT_SUBJECT_OPT_IN_AUDIT WHERE SUBJECT_OPT_IN_AUDIT_KEY ='20240828150431527027772'

SELECT count(*) FROM ODS.Y0LT_SUBJECT_OPT_IN_AUDIT

--COUNT(*)|
----------+
--    8957|


-- Run the dag

SELECT count(*) FROM ODS.Y0LT_SUBJECT_OPT_IN_AUDIT
--COUNT(*)|
----------+
--    8958|

SELECT * FROM ODS.Y0LT_SUBJECT_OPT_IN_AUDIT WHERE SUBJECT_OPT_IN_AUDIT_KEY ='20240828150431527027772'
--Y0LT_SUBJ_OPT_INT_ID|EFFECTIVE_DATE     |SUBJECT_OPT_IN_AUDIT_KEY|SUBJECT_KEY             |SUBJECT_ID|TCPA_OPT_IN_OLD|CASL_OPT_IN_OLD|TCPA_OPT_IN_NEW|CASL_OPT_IN_NEW|EMAIL_ADDRESS_OLD|PHONE_NUMBER_OLD|EMAIL_ADDRESS_NEW     |PHONE_NUMBER_NEW|CREATETS           |MODIFYTS           |CREATEUSERID    |MODIFYUSERID    |CREATEPROGID|MODIFYPROGID|LOCKID|ALT_EMAIL_ADDRESS_OLD|ALT_EMAIL_ADDRESS_NEW|ALTERNATE_PHONE_NUMBER_OLD|ALTERNATE_PHONE_NUMBER_NEW|
----------------------+-------------------+------------------------+------------------------+----------+---------------+---------------+---------------+---------------+-----------------+----------------+----------------------+----------------+-------------------+-------------------+----------------+----------------+------------+------------+------+---------------------+---------------------+--------------------------+--------------------------+
--                    |2024-09-03 03:55:37|20240828150431527027772 |20240828150431527027767 |D6288     |               |               |N              |N              |                 |                |ramyhelena@yopmail.com|                |2024-08-28 15:04:30|2024-08-28 15:04:30|spec.cc-ast-part|spec.cc-ast-part|Console     |Console     |     0|                     |                     |                          |                          |
