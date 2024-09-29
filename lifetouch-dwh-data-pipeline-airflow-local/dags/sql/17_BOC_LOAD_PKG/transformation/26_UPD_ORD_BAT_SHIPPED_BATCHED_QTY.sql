/* TASK No. 1 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 2 */




/*-----------------------------------------------*/
/* TASK No. 3 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 3 */




/*-----------------------------------------------*/
/* TASK No. 4 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 4 */




/*-----------------------------------------------*/
/* TASK No. 5 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 5 */




/*-----------------------------------------------*/
/* TASK No. 6 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 6 */




/*-----------------------------------------------*/
/* TASK No. 7 */
/* Dropping table TEMP_ORDER_HEADER_OID_SHIPPED_QTY */

-- DROP TABLE TMP_ORD_HEAD_OID_SHIPPED_QTY
BEGIN  
   EXECUTE IMMEDIATE 'DROP TABLE TMP_ORD_HEAD_OID_SHIPPED_QTY';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Create table TEMP_ORDER_HEADER_OID_SHIPPED_QTY */


CREATE TABLE TMP_ORD_HEAD_OID_SHIPPED_QTY AS 
SELECT DISTINCT order_batch_oid
FROM ods_own.order_header
WHERE order_batch_OID IS NOT NULL
AND ODS_MODIFY_DATE   >= ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap)


-- CREATE TABLE TMP_ORD_HEAD_OID_SHIPPED_QTY(
--    order_batch_oid NUMBER
-- )

-- &

-- INSERT INTO TMP_ORD_HEAD_OID_SHIPPED_QTY(order_batch_oid)
-- SELECT DISTINCT order_batch_oid
-- FROM ods_own.order_header
-- WHERE order_batch_OID IS NOT NULL
-- AND ODS_MODIFY_DATE   >= ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap)

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* MERGE ORDER_BATCH_OID with NULL QTY from ORDER_HEADER */

MERGE
   INTO  TMP_ORD_HEAD_OID_SHIPPED_QTY T
   USING(
select distinct ORDER_BATCH_OID
from ods_own.order_batch 
where batched_order_qty is null
) S
   ON  ( T.ORDER_BATCH_OID = S.ORDER_BATCH_OID)
WHEN NOT MATCHED
   THEN
INSERT ( T.ORDER_BATCH_OID)
VALUES ( S.ORDER_BATCH_OID)

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Dropping table TEMP_ORDER_SHIPPED_QUANTITY */

-- DROP TABLE TEMP_ORD_SHIPPED_BATCHED_QTY

BEGIN  
   EXECUTE IMMEDIATE 'DROP TABLE TEMP_ORD_SHIPPED_BATCHED_QTY';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Creating table TEMP_ORDER_SHIPPED_QUANTITY */

CREATE TABLE TEMP_ORD_SHIPPED_BATCHED_QTY AS
SELECT ord.order_batch_oid,
  SUM (
  CASE
    WHEN ord.order_ship_complete_ind =1
    THEN 1
    ELSE 0
  END ) as SHIPPED_QUANTITY,
 SUM (
  CASE
    WHEN ord.ORDER_BUCKET in ('PAID','UNPAID','X')
    THEN 1
    ELSE 0
  END )  as BATCHED_ORDER_QTY,
  min(ord.ORDER_SHIP_DATE) ORDER_SHIP_DATE
 FROM ods_own.order_header ord,
  TMP_ORD_HEAD_OID_SHIPPED_QTY temp
WHERE ord.order_batch_oid           = temp.order_batch_oid
GROUP BY ord.order_batch_oid

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* MERGE Missing ORDER_BATCH_OID */

MERGE
   INTO  TEMP_ORD_SHIPPED_BATCHED_QTY T
   USING(
select distinct ORDER_BATCH_OID, '0' as SHIPPED_QUANTITY, '0' as BATCHED_ORDER_QTY
from ods_own.order_batch 
where batched_order_qty is null

) S
   ON  ( T.ORDER_BATCH_OID = S.ORDER_BATCH_OID)
WHEN NOT MATCHED
   THEN
INSERT ( T.ORDER_BATCH_OID,
         T.SHIPPED_QUANTITY,
         T.BATCHED_ORDER_QTY)
VALUES ( S.ORDER_BATCH_OID,
         S.SHIPPED_QUANTITY,
         S.BATCHED_ORDER_QTY)


&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Unique Index */

create unique index TEMP_ORD_SHIP_BATCH_QTY_UK on TEMP_ORD_SHIPPED_BATCHED_QTY(order_batch_oid)

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Update ORDER_BATCH table */

UPDATE 
(
select ob.shipped_order_qty as old_shipped_order_qty
,ob.batched_order_qty as old_batched_order_qty
,ob.ignore_flag as old_ignore_flag
,ob.ignore_reason as old_ignore_reason
,ob.ignore_date as old_ignore_date
,ob.order_ship_date as old_order_ship_date
,temp.shipped_quantity as new_shipped_order_qty
,temp.batched_order_qty as new_batched_order_qty
,temp.order_ship_date as new_order_ship_date
from TEMP_ORD_SHIPPED_BATCHED_QTY temp
, ods_own.order_batch ob
WHERE ob.order_batch_oid=temp.ORDER_BATCH_OID
)
SET old_shipped_order_qty = new_shipped_order_qty
,old_batched_order_qty = new_batched_order_qty 
,old_ignore_flag = case when old_ignore_flag = 'Y' or nvl(new_batched_order_qty,0) = 0 then 'Y' else 'N' end
,old_ignore_reason = case when old_ignore_flag = 'Y' then old_ignore_reason
                          when nvl(new_batched_order_qty,0) = 0 then 'No orders in order batch'
                          else null end
,old_ignore_date = case when old_ignore_flag = 'Y' then old_ignore_date
                        when nvl(new_batched_order_qty,0) = 0 then sysdate
                        else null end
,old_order_ship_date = new_order_ship_date 


&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* unignore batches that now have orders */

update ods_own.order_batch
set ignore_flag = 'N'
, ignore_reason = null
, ignore_date = null
, ignore_by_user = null
where ignore_flag = 'Y'
and ignore_reason = 'No orders in order batch'
and batched_order_qty > 0
and ods_modify_date >= ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap)

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name


&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Insert CDC Audit Record */

INSERT INTO RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
(TABLE_NAME,
SESS_NO,                      
SESS_NAME,                    
SCEN_VERSION,                 
SESS_BEG,                     
ORIG_LAST_CDC_COMPLETION_DATE,
OVERLAP,
CREATE_DATE              
)
values (
:v_cdc_load_table_name,
:v_sess_no,
'26_UPD_ORD_BAT_SHIPPED_BATCHED_QTY',
'007',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_ld_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          ),
:v_cdc_oms_overlap,
SYSDATE)

&


/*-----------------------------------------------*/
