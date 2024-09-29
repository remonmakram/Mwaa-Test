/* TASK No. 1 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 2 */




/*-----------------------------------------------*/
/* TASK No. 3 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 3 */




/*-----------------------------------------------*/
/* TASK No. 4 */
/* Drop Pre-Driver Table */

BEGIN  
   EXECUTE IMMEDIATE 'drop table apo_online_orders_pre_dr';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Drop Driver Table */

BEGIN  
   EXECUTE IMMEDIATE 'DROP TABLE apo_online_orders_dr';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Get APO's with Events with modified orders  */

CREATE TABLE apo_online_orders_pre_dr
AS
SELECT DISTINCT a.apo_oid  FROM
ods_own.apo a, ods_own.event e, ods_own.order_header oh
WHERE a.apo_oid = e.apo_oid
AND e.event_oid = oh.event_oid
AND a.apo_oid != -1
AND oh.ods_modify_date
        >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Load into Driver table */

CREATE TABLE apo_online_orders_dr
AS
SELECT a.apo_oid, COUNT(*) AS online_orders  
FROM
  apo_online_orders_pre_dr a, 
  ods_own.event e, 
  ods_own.order_header oh, 
  ods_own.order_channel oc
WHERE a.apo_oid = e.apo_oid
AND e.event_oid = oh.event_oid
AND oh.order_channel_oid = oc.order_channel_oid
AND oc.channel_name IN ('MLT', 'Mobile', 'Solo', 'SAS')
AND oh.order_bucket != 'CANCELLED'
AND a.apo_oid != -1
GROUP BY a.apo_oid

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Drop Pre Driver Table */

DROP TABLE apo_online_orders_pre_dr

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Get APO's with no event and modified orders */

CREATE TABLE apo_online_orders_pre_dr
AS
SELECT DISTINCT a.apo_oid
  FROM ods_own.apo a,
       ods_own.order_header oh
 WHERE 1 = 1
   AND a.apo_oid = oh.apo_oid
   AND oh.event_oid = -1
   AND a.apo_oid != -1
   AND oh.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Insert into Driver table */

INSERT INTO apo_online_orders_dr
            (apo_oid, online_orders)
   SELECT   a.apo_oid, COUNT (*) AS online_orders
       FROM apo_online_orders_pre_dr a,
            ods_own.order_header oh,
            ods_own.order_channel oc
      WHERE 1 = 1
        AND a.apo_oid = oh.apo_oid
        AND oh.order_channel_oid = oc.order_channel_oid
        AND oh.order_bucket != 'CANCELLED'
        AND oc.channel_name IN ('MLT', 'Mobile', 'Solo', 'SAS')
        AND NOT EXISTS (SELECT 1
                          FROM apo_online_orders_dr dr
                         WHERE a.apo_oid = dr.apo_oid)
   GROUP BY a.apo_oid

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Merge Online Order QTY into APO */

MERGE INTO ods_own.apo a
   USING (SELECT apo_oid, online_orders
            FROM apo_online_orders_dr) s
   ON (s.apo_oid = a.apo_oid)
   WHEN MATCHED THEN
      UPDATE
         SET a.online_order_qty = s.online_orders,
                a.ods_modify_date = sysdate
         WHERE DECODE (s.online_orders, a.online_order_qty, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
+ nvl((TIMEZONE_OFFSET/24), 0) 
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

/*
UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Insert CDC Audit Record */

INSERT INTO RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
(TABLE_NAME,
SESS_NO,                      
SESS_NAME,                    
SCEN_VERSION,                 
SESS_BEG,                     
ORIG_LAST_CDC_COMPLETION_DATE,
OVERLAP,
CREATE_DATE,
CONTEXT_NAME,
TIMEZONE_OFFSET              
)
select 
:v_cdc_load_table_name
,:v_sess_no
,'UPDATE_APO_ONLINE_ORDERS_PKG'
,'001'
,TO_DATE(SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
,TO_DATE (SUBSTR(:v_cdc_load_date, 1, 19),'YYYY-MM-DD HH24:MI:SS')
,:v_cdc_overlap
,SYSDATE
,:v_env
,TIMEZONE_OFFSET
from 
ODS_OWN.ODS_CDC_LOAD_STATUS
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

/*
INSERT INTO RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
(TABLE_NAME,
SESS_NO,                      
SESS_NAME,                    
SCEN_VERSION,                 
SESS_BEG,                     
ORIG_LAST_CDC_COMPLETION_DATE,
OVERLAP,
CREATE_DATE,
CONTEXT_NAME              
)
values (
:v_cdc_load_table_name,
:v_sess_no,
'UPDATE_APO_ONLINE_ORDERS_PKG',
'001',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/


&


/*-----------------------------------------------*/
