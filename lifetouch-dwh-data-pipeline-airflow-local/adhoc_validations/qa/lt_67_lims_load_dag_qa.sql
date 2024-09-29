select * FROM ods_own.layout_theme
ORDER BY ods_modify_date DESC FETCH FIRST 10 ROWS ONLY

--LAYOUT_THEME_OID|LAYOUT_THEME_ID|AUDIT_CREATE_DATE  |AUDIT_CREATED_BY |AUDIT_MODIFIED_BY|AUDIT_MODIFY_DATE  |EXTERNAL_KEY|NAME                    |ODS_CREATE_DATE    |ODS_MODIFY_DATE    |SOURCE_SYSTEM_OID|
------------------+---------------+-------------------+-----------------+-----------------+-------------------+------------+------------------------+-------------------+-------------------+-----------------+
--           17498|          44281|2024-09-05 15:40:55|lims.is-engr-user|lims.is-engr-user|2024-09-05 15:43:47|      103266|103266 NA               |2024-09-05 15:47:26|2024-09-15 06:43:06|              561|
--           17497|          44192|2024-09-05 15:41:26|lims.is-engr-user|lims.is-engr-user|2024-09-05 15:45:23|      103267|103267 NA               |2024-09-05 15:47:26|2024-09-05 15:47:26|              561|
--           17473|          44188|2024-09-05 11:23:37|lims.is-engr-user|lims.is-engr-user|2024-09-05 11:23:37|      103262|103262 Spring Collection|2024-09-05 11:49:03|2024-09-05 11:49:03|              561|
--           17480|          44183|2024-09-05 11:19:14|lims.is-engr-user|lims.is-engr-user|2024-09-05 11:39:30|      103252|103252 Neutral          |2024-09-05 11:49:03|2024-09-05 11:49:03|              561|
--           17479|          44184|2024-09-05 11:21:58|lims.is-engr-user|lims.is-engr-user|2024-09-05 11:21:58|      103255|103255 Spring Collection|2024-09-05 11:49:03|2024-09-05 11:49:03|              561|
--           17478|          44181|2024-09-05 11:17:53|lims.is-engr-user|lims.is-engr-user|2024-09-05 11:34:15|      103248|103248 Neutral          |2024-09-05 11:49:03|2024-09-05 11:49:03|              561|
--           17477|          44180|2024-09-05 11:17:26|lims.is-engr-user|lims.is-engr-user|2024-09-05 11:31:35|      103246|103246 Neutral          |2024-09-05 11:49:03|2024-09-05 11:49:03|              561|
--           17476|          44178|2024-09-05 11:16:41|lims.is-engr-user|lims.is-engr-user|2024-09-05 11:29:33|      103244|103244 Neutral          |2024-09-05 11:49:03|2024-09-05 11:49:03|              561|
--           17475|          44191|2024-09-05 11:24:23|lims.is-engr-user|lims.is-engr-user|2024-09-05 11:24:23|      103265|103265 Spring Collection|2024-09-05 11:49:03|2024-09-05 11:49:03|              561|
--           17474|          44177|2024-09-05 11:16:08|lims.is-engr-user|lims.is-engr-user|2024-09-05 11:28:24|      103243|103243 Neutral          |2024-09-05 11:49:03|2024-09-05 11:49:03|              561|

select * FROM ods_own.layout_theme WHERE LAYOUT_THEME_OID = 17498
--LAYOUT_THEME_OID|LAYOUT_THEME_ID|AUDIT_CREATE_DATE  |AUDIT_CREATED_BY |AUDIT_MODIFIED_BY|AUDIT_MODIFY_DATE  |EXTERNAL_KEY|NAME     |ODS_CREATE_DATE    |ODS_MODIFY_DATE    |SOURCE_SYSTEM_OID|
------------------+---------------+-------------------+-----------------+-----------------+-------------------+------------+---------+-------------------+-------------------+-----------------+
--           17498|          44281|2024-09-05 15:40:55|lims.is-engr-user|lims.is-engr-user|2024-09-05 15:43:47|      103266|103266 NA|2024-09-05 15:47:26|2024-09-15 06:43:06|              561|



delete FROM ods_own.layout_theme WHERE LAYOUT_THEME_OID = 17498

UPDATE ods_own.ods_cdc_load_status
SET last_cdc_completion_date = TO_DATE(SUBSTR('2024-09-01 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
WHERE ods_table_name= 'LM_LAYOUT_THEME_STG'


-- run the dag

select * FROM ods_own.layout_theme WHERE LAYOUT_THEME_OID = 17498
--LAYOUT_THEME_OID|LAYOUT_THEME_ID|AUDIT_CREATE_DATE  |AUDIT_CREATED_BY |AUDIT_MODIFIED_BY|AUDIT_MODIFY_DATE  |EXTERNAL_KEY|NAME     |ODS_CREATE_DATE    |ODS_MODIFY_DATE    |SOURCE_SYSTEM_OID|
------------------+---------------+-------------------+-----------------+-----------------+-------------------+------------+---------+-------------------+-------------------+-----------------+
--           17498|          44281|2024-09-05 15:40:55|lims.is-engr-user|lims.is-engr-user|2024-09-05 15:43:47|      103266|103266 NA|2024-09-15 09:25:18|2024-09-15 09:25:18|              561|