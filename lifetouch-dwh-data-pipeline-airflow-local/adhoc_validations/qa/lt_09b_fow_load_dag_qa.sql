select * FROM ODS_STAGE.FOW_YB_PRICING_STG
ORDER BY ods_modify_date DESC FETCH FIRST 10 ROWS ONLY

--ID    |OFFERING_ID|PRICE_SET_NAME      |ITEM_ID|SCHOOL_PRICE|CONSUMER_PRICE|CHANNEL|DATE_CREATED       |CREATED_BY |NO_SHOW_INVOICE|QUANTITY|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
--------+-----------+--------------------+-------+------------+--------------+-------+-------------------+-----------+---------------+--------+-------------------+-------------------+
--401815|      61731|XPT5569B41F347FFE7DF|  55046|           0|             0|PAPER  |2024-09-05 04:06:50|fow.datagen|              0|        |2024-09-05 04:45:15|2024-09-05 04:45:15|
--401824|      61731|XPT5569B41F347FFE7DF|  57777|           0|             0|PAPER  |2024-09-05 04:06:50|fow.datagen|              0|        |2024-09-05 04:45:15|2024-09-05 04:45:15|
--401823|      61731|XPTF51AEB9824470F12B|  57473|          13|            13|PAPER  |2024-09-05 04:06:50|fow.datagen|               |        |2024-09-05 04:45:15|2024-09-05 04:45:15|
--401822|      61731|XPT5569B41F347FFE7DF|  69236|           0|             0|PAPER  |2024-09-05 04:06:50|fow.datagen|              1|        |2024-09-05 04:45:15|2024-09-05 04:45:15|
--401821|      61731|XPTF51AEB9824470F12B|  57471|          15|            15|PAPER  |2024-09-05 04:06:50|fow.datagen|               |        |2024-09-05 04:45:15|2024-09-05 04:45:15|
--401820|      61731|XPT5569B41F347FFE7DF|  68242|           0|             0|PAPER  |2024-09-05 04:06:50|fow.datagen|              0|        |2024-09-05 04:45:15|2024-09-05 04:45:15|
--401819|      61731|XPT5569B41F347FFE7DF|  66032|           0|             0|PAPER  |2024-09-05 04:06:50|fow.datagen|              0|        |2024-09-05 04:45:15|2024-09-05 04:45:15|
--401818|      61731|XPT5569B41F347FFE7DF|  55011|           0|             0|PAPER  |2024-09-05 04:06:50|fow.datagen|              0|        |2024-09-05 04:45:15|2024-09-05 04:45:15|
--401817|      61731|XPT5569B41F347FFE7DF|  55020|           0|             0|PAPER  |2024-09-05 04:06:50|fow.datagen|              0|        |2024-09-05 04:45:15|2024-09-05 04:45:15|
--401816|      61731|XPT5569B41F347FFE7DF|  69221|           0|             0|PAPER  |2024-09-05 04:06:50|fow.datagen|              0|        |2024-09-05 04:45:15|2024-09-05 04:45:15|


select * FROM ODS_STAGE.FOW_YB_PRICING_STG WHERE ID = 401815
--ID    |OFFERING_ID|PRICE_SET_NAME      |ITEM_ID|SCHOOL_PRICE|CONSUMER_PRICE|CHANNEL|DATE_CREATED       |CREATED_BY |NO_SHOW_INVOICE|QUANTITY|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
--------+-----------+--------------------+-------+------------+--------------+-------+-------------------+-----------+---------------+--------+-------------------+-------------------+
--401815|      61731|XPT5569B41F347FFE7DF|  55046|           0|             0|PAPER  |2024-09-05 04:06:50|fow.datagen|              0|        |2024-09-05 04:45:15|2024-09-05 04:45:15|




delete FROM ODS_STAGE.FOW_YB_PRICING_STG WHERE ID = 401815

UPDATE ods_own.ods_cdc_load_status
SET last_cdc_completion_date = TO_DATE(SUBSTR('2024-09-05 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
WHERE ods_table_name= 'FOW_YB_PRICING_STG'


-- run the dag

select * FROM ODS_STAGE.FOW_YB_PRICING_STG WHERE ID = 401815
--ID    |OFFERING_ID|PRICE_SET_NAME      |ITEM_ID|SCHOOL_PRICE|CONSUMER_PRICE|CHANNEL|DATE_CREATED       |CREATED_BY |NO_SHOW_INVOICE|QUANTITY|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
--------+-----------+--------------------+-------+------------+--------------+-------+-------------------+-----------+---------------+--------+-------------------+-------------------+
--401815|      61731|XPT5569B41F347FFE7DF|  55046|           0|             0|PAPER  |2024-09-05 04:06:50|fow.datagen|              0|        |2024-09-09 09:07:13|2024-09-09 09:07:13|