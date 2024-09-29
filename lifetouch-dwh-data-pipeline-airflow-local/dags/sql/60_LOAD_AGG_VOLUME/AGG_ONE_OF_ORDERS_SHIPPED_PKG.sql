/* TASK No. 1 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */
/* Delete <Target> Table before loading. */

DELETE  FROM MART.AGG_ONE_OF_ORDERS_SHIPPED


&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* Load Target Table */

INSERT INTO MART.AGG_ONE_OF_ORDERS_SHIPPED
SELECT
OH.SHIP_NODE,
T.FISCAL_YEAR AS FISCAL_YEAR_SHIPPED,
T.SEASON_NAME AS SEASON_SHIPPED,
T.MONTH_NAME  AS MONTH_SHIPPED,
T.MONTH_NUMBER AS MONTH_NUMBER_SHIPPED,
T.SAT_PRODUCTION_WEEK_NUMBER AS FISCAL_WEEK_SHIPPED,
COUNT(OH.ORDER_STATUS) AS ONE_OF_ORDERS_COUNT,
SYSDATE AS MART_CREATE_DATE,
SYSDATE AS MART_MODIFY_DATE
FROM 
ODS_OWN.ONE_OF_ORDER_WIP ONE,
ODS_OWN.APO APO,
ODS_OWN.EVENT EVENT,
MART.TIME T,
ODS_OWN.ORDER_HEADER OH,
ODS_OWN.SOURCE_SYSTEM S
WHERE
ONE.APO_OID = APO.APO_OID
AND ONE.EVENT_OID = EVENT.EVENT_OID
AND ONE.IGNORE_FLAG = 'N'
AND ONE.ORDER_HEADER_OID = OH.ORDER_HEADER_OID
AND TRUNC(ONE.ORDER_SHIP_DATE) = T.DATE_KEY
AND T.FISCAL_YEAR >= (SELECT FISCAL_YEAR - 3 FROM MART.TIME WHERE DATE_KEY = (SELECT TRUNC(SYSDATE) FROM DUAL))
AND OH.SOURCE_SYSTEM_OID = S.SOURCE_SYSTEM_OID
AND S.SOURCE_SYSTEM_SHORT_NAME = 'OMS'
AND OH.SHIP_NODE IS NOT NULL 
AND OH.SHIP_NODE NOT IN ('Winnipeg')
GROUP BY
OH.SHIP_NODE,
T.FISCAL_YEAR,
T.SEASON_NAME,
T.MONTH_NAME,
T.MONTH_NUMBER,
T.SAT_PRODUCTION_WEEK_NUMBER
ORDER BY 1,2,5

&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* Update CDC Load Status */

UPDATE ODS.DW_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE DW_TABLE_NAME=:v_cdc_load_table_name

&


-- /*-----------------------------------------------*/
-- /* TASK No. 5 */
-- /* Insert Audit Record */

-- INSERT INTO ODS_ETL_OWNER.DW_CDC_LOAD_STATUS_AUDIT
-- (TABLE_NAME,
-- SESS_NO,                      
-- SESS_NAME,                    
-- SCEN_VERSION,                 
-- SESS_BEG,                     
-- ORIG_LAST_CDC_COMPLETION_DATE,
-- OVERLAP,
-- CREATE_DATE              
-- )
-- values (
-- :v_cdc_load_table_name,
-- :v_sess_no,
-- 'AGG_ONE_OF_ORDERS_SHIPPED_PKG',
-- '001',
-- TO_DATE(
--              SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
-- TO_DATE (SUBSTR (:v_cdc_load_date_ODS_DM, 1, 19),
--                            'YYYY-MM-DD HH24:MI:SS'
--                           ),
-- :v_cdc_overlap,
-- SYSDATE)



-- &


-- /*-----------------------------------------------*/
