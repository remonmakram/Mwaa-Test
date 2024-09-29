SELECT count(*) FROM RAX_APP_USER.LOOKUP_WOMS_STATUS_HISTORY

SELECT * FROM RAX_APP_USER.LKP_WOMS_PENDING_COMPS1


--INSERT INTO RAX_APP_USER.LKP_WOMS_PENDING_COMPS1 (WORK_ORDER_ID,WOMS_NODE,UNDERCLASS_PRODUCT_CODE) VALUES (0,0,0)
INSERT INTO ODS_STAGE.X1_WO_UNSHIPPED_HIST (PLATFORM_DETAIL,WORK_ORDER_ID,event_ref_id,ods_create_date,ods_modify_date,PENDING_CLASS_PRODUCT)
VALUES ('aaaa',-99,'bbb',sysdate,sysdate,'A')

-- run the dag


SELECT * FROM ODS_STAGE.X1_WO_SHIPPED_HIST
--PLATFORM_DETAIL|WORK_ORDER_ID|EVENT_REF_ID|JOB_TYPE|LID|ACCT_NAME|SHIP_PROPSL_RECEIVED|MAIL_RECEIVED|BATCH_ID|WORK_ORDER_ALIAS_ID|SUBJECT_COUNT|WORK_ORDER_FORM_PRT|RET|RET_QTY|RET_PRT|PKG|PKG_QTY|PKG_PRT|POS|POS_QTY|POS_PRT|DIGITAL_MEDIA1|DIGITAL_MEDIA1_QTY|DIGITAL_MEDIA1_PRT|DIGITAL_MEDIA2|DIGITAL_MEDIA2_QTY|DIGITAL_MEDIA2_PRT|LAMINATE|LAMINATE_QTY|LAMINATE_PRT|MAGNET|MAGNET_QTY|MAGNET_PRT|METALLIC|METALLIC_QTY|METALLIC_PRT|SPECIALITY|SPECIALITY_QTY|SPECIALITY_PRODUCED|INDIGO_PRODUCT1|INDIGO_PRODUCT1_QTY|INDIGO_PRODUCT1_PRODUCED|INDIGO_PRODUCT2|INDIGO_PRODUCT2_QTY|INDIGO_PRODUCT2_PRODUCED|PROOF_PRODUCT|PROOF_QTY|PROOF_PRODUCED|CLASS_DELIVERY|CLASS|CLASS_QTY|CLASS_PRT|DID|DID_QTY|DID_PRT|DSSK|DSSK_QTY|DSSK_PRT|EZP|EZP_QTY|EZP_PRT|SPECIAL_REQUEST|WORK_ORDER_STATUS|PROCESSING_COMMENT|SHIP_GOAL_DATE|WOMS_NODE|CHANGE_FLAG|MANUAL_DEACTIVATED_FLAG|PENDING_CLASS_PRODUCT|MANUALLY_SHIPPED|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |STATUS|STATUS_DATE|
-----------------+-------------+------------+--------+---+---------+--------------------+-------------+--------+-------------------+-------------+-------------------+---+-------+-------+---+-------+-------+---+-------+-------+--------------+------------------+------------------+--------------+------------------+------------------+--------+------------+------------+------+----------+----------+--------+------------+------------+----------+--------------+-------------------+---------------+-------------------+------------------------+---------------+-------------------+------------------------+-------------+---------+--------------+--------------+-----+---------+---------+---+-------+-------+----+--------+--------+---+-------+-------+---------------+-----------------+------------------+--------------+---------+-----------+-----------------------+---------------------+----------------+-------------------+-------------------+------+-----------+
--aaaa           |          -99|bbb         |        |   |         |                    |             |        |                   |             |                   |   |       |       |   |       |       |   |       |       |              |                  |                  |              |                  |                  |        |            |            |      |          |          |        |            |            |          |              |                   |               |                   |                        |               |                   |                        |             |         |              |              |     |         |         |   |       |       |    |        |        |   |       |       |               |                 |                  |              |         |C          |                       |A                    |                |2024-08-28 08:20:55|2024-08-28 08:20:55|      |           |


-- delete the test records

DELETE FROM ODS_STAGE.X1_WO_SHIPPED_HIST WHERE PLATFORM_DETAIL = 'aaaa'

DELETE FROM ODS_STAGE.X1_WO_UNSHIPPED_HIST WHERE PLATFORM_DETAIL = 'aaaa'

------------------------------
SELECT * FROM  ODS_STAGE.X1_WO_UNSHIPPED_HIST FETCH FIRST 5 ROWS ONLY

SELECT * FROM ODS_STAGE.X1_WO_SHIPPED_HIST

SELECT * FROM ODS_STAGE.X1_WO_UNSHIPPED_HIST_X

SELECT * FROM ODS_STAGE.X1_WO_UNSHIPPED_HIST_X FETCH FIRST 5 ROWS ONLY

SELECT * FROM ODS_ETL_OWNER.DW_CDC_LOAD_STATUS_AUDIT
WHERE SESS_NAME = 'PROCESS_X1WO_WOMS_ISSUES_PKG' ORDER BY CREATE_DATE desc

SELECT
DISTINCT WOD.WORK_ORDER_ID,WOD.WOMS_NODE,OMS.UNDERCLASS_PRODUCT_CODE
FROM
ODS_STAGE.X1_WO_UNSHIPPED_HIST TEMP,
ODS_STAGE.WOMS_WORK_ORDER_DETAIL_STG WOD,
ODS_STAGE.WOMS_ITEM_ID_REFERENCE_STG ITEM,
ODS_STAGE.WOMS_XREF_OMS_PROD_STG OMS,
ODS_STAGE.WOMS_STATUS_STAGE STAT
WHERE 1 = 1
         AND TEMP.WORK_ORDER_ID = WOD.WORK_ORDER_ID
         AND TEMP.WOMS_NODE  = WOD.WOMS_NODE
         AND WOD.ITEM_ID_REFERENCE_ID = ITEM.ITEM_ID_REFERENCE_ID
         AND ITEM.XREF_OMS_PROD_ID = OMS.XREF_OMS_PROD_ID
         AND WOD.STATUS_ID = STAT.STATUS_ID
         AND WOD.WOMS_NODE = STAT.SOURCE_NODE
         --AND ITEM.ITEM_ID_REFERENCE_ID IN (51,52,53,5)
         --AND WOD.STATUS_ID NOT IN (4,7,8,9,10)
         AND STAT.CODE NOT IN ('CA','LC','LS','SA')
         AND TEMP.MANUAL_DEACTIVATED_FLAG IS NULL
         AND TEMP.CLASS_QTY IS NOT NULL
         AND WOD.ODS_CREATE_DATE >= (SELECT MIN(DATE_KEY) FROM MART.TIME
                                                                   WHERE FISCAL_YEAR = (SELECT FISCAL_YEAR FROM MART.TIME
                                                                                                            WHERE DATE_KEY = TRUNC(SYSDATE))-1)



SELECT
    DISTINCT
    X.WORK_ORDER_ID,X.WOMS_NODE,
    CASE WHEN T.WORK_ORDER_ID IS NOT NULL THEN  'Y' ELSE NULL END PENDING_CLASS_PRODUCT,
    CASE WHEN SH.SHIPPED IS NOT NULL THEN 'Y' ELSE NULL END MANUALLY_SHIPPED
    FROM
      ODS_STAGE.X1_WO_UNSHIPPED_HIST X,
     (SELECT * FROM RAX_APP_USER.LKP_WOMS_PENDING_COMPS2
        WHERE (WORK_ORDER_ID,WOMS_NODE)
                IN (
                SELECT WORK_ORDER_ID,WOMS_NODE FROM
                (
                SELECT WORK_ORDER_ID,WOMS_NODE,COUNT(UNDERCLASS_PRODUCT_CODE)
                FROM
                RAX_APP_USER.LKP_WOMS_PENDING_COMPS2
                GROUP BY WORK_ORDER_ID,WOMS_NODE
                HAVING COUNT(UNDERCLASS_PRODUCT_CODE) = 1
                ORDER BY WORK_ORDER_ID,WOMS_NODE ASC
                )
                    )
            AND UNDERCLASS_PRODUCT_CODE IN ('CMP','G08')
    ) T,
    RAX_APP_USER.LOOKUP_WOMS_STATUS_HISTORY SH
    WHERE 1 = 1
    AND X.WORK_ORDER_ID = T.WORK_ORDER_ID(+)
    AND X.WOMS_NODE = T.WOMS_NODE(+)
    AND X.WORK_ORDER_ID = SH.WORK_ORDER_ID(+)
    AND X.WOMS_NODE = SH.WOMS_NODE(+)
    AND X.MANUAL_DEACTIVATED_FLAG IS NULL
    ORDER BY 2 ASC