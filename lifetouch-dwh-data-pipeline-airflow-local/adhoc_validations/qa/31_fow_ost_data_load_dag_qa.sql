select * FROM ODS_STAGE.FOW_OFRING_MODEL_TAGS_STG
ORDER BY ods_modify_date DESC FETCH FIRST 10 ROWS ONLY

--OFFERING_MODEL_ID|TAGS_INTEGER|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
-------------------+------------+-------------------+-------------------+
--            12339|          15|2024-09-08 05:49:04|2024-09-08 05:49:04|
--            12341|         671|2024-09-08 05:49:04|2024-09-08 05:49:04|
--            12341|          16|2024-09-08 05:49:04|2024-09-08 05:49:04|
--            12341|          35|2024-09-08 05:49:04|2024-09-08 05:49:04|
--            12341|          68|2024-09-08 05:49:04|2024-09-08 05:49:04|
--            12339|         331|2024-09-08 05:49:04|2024-09-08 05:49:04|
--            12339|          22|2024-09-08 05:49:04|2024-09-08 05:49:04|
--            12339|         671|2024-09-08 05:49:04|2024-09-08 05:49:04|
--            12339|         155|2024-09-08 05:49:04|2024-09-08 05:49:04|
--            12339|          18|2024-09-08 05:49:04|2024-09-08 05:49:04|


select
ID,
	VERSION,
	ACTIVE,
	COMMISSION_MODEL_ID,
	CREATED_BY,
	DATE_CREATED,
	ENVELOPE_ID,
	FLYER_ID,
	INSERTS,
	LAST_UPDATED,
	NAME,
	PRICE_PROGRAM_NAME,
	TERRITORY,
	UPDATED_BY,
	VISUAL_MERCH_ID,
	IND_UPDATE
 from (
select
	C1_ID ID,
	C2_VERSION VERSION,
	C3_ACTIVE ACTIVE,
	C4_COMMISSION_MODEL_ID COMMISSION_MODEL_ID,
	C5_CREATED_BY CREATED_BY,
	C6_DATE_CREATED DATE_CREATED,
	C7_ENVELOPE_ID ENVELOPE_ID,
	C8_FLYER_ID FLYER_ID,
	C9_INSERTS INSERTS,
	C10_LAST_UPDATED LAST_UPDATED,
	C11_NAME NAME,
	C12_PRICE_PROGRAM_NAME PRICE_PROGRAM_NAME,
	C13_TERRITORY TERRITORY,
	C14_UPDATED_BY UPDATED_BY,
	C15_VISUAL_MERCH_ID VISUAL_MERCH_ID,
	'I' IND_UPDATE
from	RAX_APP_USER.C$_0FOW_FRNG_MDL_STG
where	(1=1)
) S
where NOT EXISTS
	( select 1 from ODS_STAGE.FOW_OFFERING_MODEL_STG T
	where	T.ID	= S.ID
		 and ((T.VERSION = S.VERSION) or (T.VERSION IS NULL and S.VERSION IS NULL)) and
		((T.ACTIVE = S.ACTIVE) or (T.ACTIVE IS NULL and S.ACTIVE IS NULL)) and
		((T.COMMISSION_MODEL_ID = S.COMMISSION_MODEL_ID) or (T.COMMISSION_MODEL_ID IS NULL and S.COMMISSION_MODEL_ID IS NULL)) and
		((T.CREATED_BY = S.CREATED_BY) or (T.CREATED_BY IS NULL and S.CREATED_BY IS NULL)) and
		((T.DATE_CREATED = S.DATE_CREATED) or (T.DATE_CREATED IS NULL and S.DATE_CREATED IS NULL)) and
		((T.ENVELOPE_ID = S.ENVELOPE_ID) or (T.ENVELOPE_ID IS NULL and S.ENVELOPE_ID IS NULL)) and
		((T.FLYER_ID = S.FLYER_ID) or (T.FLYER_ID IS NULL and S.FLYER_ID IS NULL)) and
		((T.INSERTS = S.INSERTS) or (T.INSERTS IS NULL and S.INSERTS IS NULL)) and
		((T.LAST_UPDATED = S.LAST_UPDATED) or (T.LAST_UPDATED IS NULL and S.LAST_UPDATED IS NULL)) and
		((T.NAME = S.NAME) or (T.NAME IS NULL and S.NAME IS NULL)) and
		((T.PRICE_PROGRAM_NAME = S.PRICE_PROGRAM_NAME) or (T.PRICE_PROGRAM_NAME IS NULL and S.PRICE_PROGRAM_NAME IS NULL)) and
		((T.TERRITORY = S.TERRITORY) or (T.TERRITORY IS NULL and S.TERRITORY IS NULL)) and
		((T.UPDATED_BY = S.UPDATED_BY) or (T.UPDATED_BY IS NULL and S.UPDATED_BY IS NULL)) and
		((T.VISUAL_MERCH_ID = S.VISUAL_MERCH_ID) or (T.VISUAL_MERCH_ID IS NULL and S.VISUAL_MERCH_ID IS NULL))
        )




select * FROM ODS_STAGE.FOW_OFFERING_MODEL_STG
ORDER BY ods_modify_date DESC FETCH FIRST 10 ROWS ONLY
--ID   |VERSION|ACTIVE|COMMISSION_MODEL_ID|CREATED_BY |DATE_CREATED       |ENVELOPE_ID|FLYER_ID|INSERTS|LAST_UPDATED       |NAME                                |PRICE_PROGRAM_NAME                         |TERRITORY|UPDATED_BY |VISUAL_MERCH_ID|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
-------+-------+------+-------------------+-----------+-------------------+-----------+--------+-------+-------------------+------------------------------------+-------------------------------------------+---------+-----------+---------------+-------------------+-------------------+
--13163|      0|     0|              13157|fow.datagen|2017-03-23 18:42:34|61142      |54885   |57791  |2017-03-23 18:42:34|pauldev_MI_3_DoNotUse               |XPPGEN-738E7923-9A77-A1A8-34EC-5F53D28B8A66|MI       |fow.support|259888         |2017-03-23 19:37:46|2024-09-08 05:47:14|
--13177|      0|     0|              13171|fow.datagen|2017-03-27 10:13:16|61142      |54936   |57791  |2017-03-27 10:13:16|pauldev_MD_4_DoNotUse               |XPPGEN-EF9E9CFA-8B15-BAE5-DEBF-4D86855A968C|MD       |fow.support|260643         |2017-03-27 10:44:49|2024-09-08 05:47:14|
--13176|      0|     0|              13170|fow.datagen|2017-03-27 10:13:16|61142      |54885   |57791  |2017-03-27 10:13:16|pauldev_LN_4_DoNotUse               |XPPGEN-7686CA10-EB2D-3D72-5114-CEEC9A798857|LN       |fow.support|259888         |2017-03-27 10:44:49|2024-09-08 05:47:14|
--13148|      0|     0|              13142|fow.datagen|2017-03-22 09:45:17|61142      |54885   |57791  |2017-03-22 09:45:17|pauldev_MI_Base_03222017_DoNotUse   |XPPGEN-F460B3AC-3093-D239-D857-17E9444EBD32|MI       |fow.support|259888         |2017-03-22 09:52:00|2024-09-08 05:47:14|
--13149|      0|     0|              13143|fow.datagen|2017-03-22 09:45:17|61142      |54886   |57791  |2017-03-22 09:45:17|pauldev_LN_Premium_03222017_DoNotUse|XPPGEN-46A2BE05-5537-D2C6-2C2E-52E1FFF8EF29|LN       |fow.support|260484         |2017-03-22 09:52:00|2024-09-08 05:47:14|
--13171|      0|     0|              13165|fow.datagen|2017-03-24 10:15:29|61142      |54886   |57791  |2017-03-24 10:15:29|Bulk-OTM-FA-03242017_DoNotUse       |XPPGEN-062336F4-6655-4937-9650-96D433E2D227|FA       |fow.support|260484         |2017-03-24 10:48:33|2024-09-08 05:47:14|
--13170|      0|     0|              13164|fow.datagen|2017-03-24 10:15:29|61142      |54886   |57791  |2017-03-24 10:15:29|Bulk-OTM-LN-0324201_DoNotUse        |XPPGEN-8E5DA3A4-D51A-F476-7F87-7B7835386DE0|LN       |fow.support|260484         |2017-03-24 10:48:33|2024-09-08 05:47:14|
--13169|      0|     0|              13163|fow.datagen|2017-03-24 10:15:28|61142      |54885   |57791  |2017-03-24 10:15:28|Bulk-OTM-MI-0324201_DoNotUse        |XPPGEN-7093EECD-38DD-A75C-7ED8-7BC43DA9A1DC|MI       |fow.support|259888         |2017-03-24 10:48:33|2024-09-08 05:47:14|
--13165|      0|     0|              13159|fow.datagen|2017-03-23 18:42:35|61142      |54936   |57791  |2017-03-23 18:42:35|pauldev_MD_3_DoNotUse               |XPPGEN-DA17575C-CD00-A21C-5194-B8A55403AF02|MD       |fow.support|260643         |2017-03-23 19:37:46|2024-09-08 05:47:14|
--13164|      0|     0|              13158|fow.datagen|2017-03-23 18:42:35|61142      |54885   |57791  |2017-03-23 18:42:35|pauldev_LN_3_DoNotUse               |XPPGEN-24D0915C-7A34-5F09-4C15-11D142F66BC3|LN       |fow.support|259888         |2017-03-23 19:37:46|2024-09-08 05:47:14|



select * FROM ODS_STAGE.FOW_OFFERING_MODEL_STG WHERE id = 13163

--ID   |VERSION|ACTIVE|COMMISSION_MODEL_ID|CREATED_BY |DATE_CREATED       |ENVELOPE_ID|FLYER_ID|INSERTS|LAST_UPDATED       |NAME                 |PRICE_PROGRAM_NAME                         |TERRITORY|UPDATED_BY |VISUAL_MERCH_ID|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
-------+-------+------+-------------------+-----------+-------------------+-----------+--------+-------+-------------------+---------------------+-------------------------------------------+---------+-----------+---------------+-------------------+-------------------+
--13163|      0|     0|              13157|fow.datagen|2017-03-23 18:42:34|61142      |54885   |57791  |2017-03-23 18:42:34|pauldev_MI_3_DoNotUse|XPPGEN-738E7923-9A77-A1A8-34EC-5F53D28B8A66|MI       |fow.support|259888         |2017-03-23 19:37:46|2024-09-08 05:47:14|



DELETE FROM ODS_STAGE.FOW_OFFERING_MODEL_STG WHERE id = 13163

UPDATE ods_own.ods_cdc_load_status
SET last_cdc_completion_date = TO_DATE(SUBSTR('2017-01-01 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
WHERE ods_table_name= 'OST_TABLES'



-- run the dag

select * FROM ODS_STAGE.FOW_OFFERING_MODEL_STG WHERE id = 13163


--ID   |VERSION|ACTIVE|COMMISSION_MODEL_ID|CREATED_BY |DATE_CREATED       |ENVELOPE_ID|FLYER_ID|INSERTS|LAST_UPDATED       |NAME                 |PRICE_PROGRAM_NAME                         |TERRITORY|UPDATED_BY |VISUAL_MERCH_ID|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |
-------+-------+------+-------------------+-----------+-------------------+-----------+--------+-------+-------------------+---------------------+-------------------------------------------+---------+-----------+---------------+-------------------+-------------------+
--13163|      0|     0|              13157|fow.datagen|2017-03-23 18:42:34|61142      |54885   |57791  |2017-03-23 18:42:34|pauldev_MI_3_DoNotUse|XPPGEN-738E7923-9A77-A1A8-34EC-5F53D28B8A66|MI       |fow.support|259888         |2024-09-08 06:46:53|2024-09-08 06:46:53|