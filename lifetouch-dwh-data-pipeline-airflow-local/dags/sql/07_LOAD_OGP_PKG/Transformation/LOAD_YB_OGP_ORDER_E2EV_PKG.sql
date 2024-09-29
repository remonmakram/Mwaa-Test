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
/* Merge into YB_OGP_Order_E2EV */

MERGE INTO ODS_APP_USER.YB_OGP_ORDER_E2EV d
     USING (SELECT stg.ID,
                   CASE
                       WHEN status = 'ORDER_RECV' THEN audit_modify_date
                       ELSE NULL
                   END
                       AS order_recv,
                   CASE
                       WHEN status = 'ROUTED' THEN audit_modify_date
                       ELSE NULL
                   END
                       AS Routed,
                   CASE
                       WHEN status = 'UPLOADED' THEN audit_modify_date
                       ELSE NULL
                   END
                       AS UPLOADED,
                   CASE
                       WHEN status = 'IMAGES_RECV' THEN audit_modify_date
                       ELSE NULL
                   END
                       AS IMAGES_RECV,
                   CASE
                       WHEN status = 'PROCESSING' THEN audit_modify_date
                       ELSE NULL
                   END
                       AS processing,
                   CASE
                       WHEN status = 'READY_TO_SHIP' THEN audit_modify_date
                       ELSE NULL
                   END
                       AS READY_TO_SHIP,
                   CASE
                       WHEN status = 'DONE_PROC' THEN audit_modify_date
                       ELSE NULL
                   END
                       AS DONE_PROC,
                   CASE
                       WHEN status = 'COMPLETE' THEN audit_modify_date
                       ELSE NULL
                   END
                       AS COMPLETE,
                   CASE
                       WHEN status = 'SHIPPED' THEN audit_modify_date
                       ELSE NULL
                   END
                       AS SHIPPED,
                   CASE
                       WHEN status = 'CANCELED' THEN audit_modify_date
                       ELSE NULL
                   END
                       AS CANCELED,
                   stg.CLIENT_ORDER_NO,
                   SUBSTR (stg.client_order_no, 3)
                       AS event,
                   CASE SUBSTR (stg.client_order_no, 1, 2)
                       WHEN 'O_' THEN 'ORDER'
                       WHEN 'C_' THEN 'COVER'
                       ELSE 'UNKNOWN'
                   END
                       AS order_type,
                   stg.STATUS,
                   stg.AUDIT_MODIFY_DATE,
                   stg.UPLOADED_DATE
              FROM ODS_STAGE.OGP_ORDER_STG stg
             WHERE stg.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap) s
        ON (d.id = s.id)
WHEN NOT MATCHED
THEN
    INSERT     (ID,
                EVENT,
                ORDER_TYPE,
                ORDER_RECV,
                ROUTED,
                UPLOADED,
                IMAGES_RECV,
                PROCESSING,
                READY_TO_SHIP,
                DONE_PROC,
                COMPLETE,
                SHIPPED,
                CANCELED,
                IGNORE_FLAG,
                IGNORE_DATE,
                IGNORE_REASON,
                IGNORE_BY_USER,
                ODS_CREATE_DATE,
                ODS_MODIFY_DATE)
        VALUES (s.id,
                s.event,
                s.order_type,
                s.order_recv,
                s.routed,
                s.uploaded,
                s.images_recv,
                s.processing,
                s.ready_to_ship,
                s.done_proc,
                s.complete,
                s.shipped,
                s.canceled,
                NULL,
                NULL,
                NULL,
                NULL,
                SYSDATE,
                SYSDATE)
                when matched then update set 
                d.order_recv = s.order_recv,
                d.routed = s.routed,
                d.uploaded = s.uploaded,
                d.images_recv = s.images_recv,
                d.processing = s.processing,
                d.ready_to_ship = s.ready_to_ship,
                d.done_proc = s.done_proc,
                d.complete = s.complete,
                d.shipped = s.shipped,
                d.canceled = s.canceled,
                d.ods_modify_date = sysdate
             where   decode(s.order_recv,d.order_recv,1,0) = 0
             or  decode(s.routed,d.routed,1,0) = 0
             or  decode(s.uploaded,d.uploaded,1,0) = 0
             or  decode(s.images_recv,d.images_recv,1,0) = 0
             or  decode(s.processing,d.processing,1,0) = 0
             or  decode(s.ready_to_ship,d.ready_to_ship,1,0) = 0
             or  decode(s.done_proc,d.done_proc,1,0) = 0
             or  decode(s.complete,d.complete,1,0) = 0
             or  decode(s.shipped,d.shipped,1,0) = 0
             or  decode(s.canceled,d.canceled,1,0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Ignore Canceled */

UPDATE ODS_APP_USER.YB_OGP_ORDER_E2EV
   SET ignore_flag = 'Y',
       ignore_reason = 'Order Cancelled',
       ignore_date = SYSDATE,
       ignore_by_user = 'LOAD_YB_OGP_ORDER_E2EV_PRC',
       ods_modify_date = sysdate
 WHERE canceled IS NOT NULL AND NVL(ignore_flag,'N') <> 'Y'
and ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Infer upstream date - Complete */

UPDATE ODS_APP_USER.YB_OGP_ORDER_E2EV
   SET complete = SHIPPED, ods_modify_date = SYSDATE
 WHERE     1 = 1
       AND SHIPPED IS NOT NULL
       AND complete IS NULL
       AND NVL (ignore_flag, 'N') = 'N'
       and ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Infer upstream date - Done_Proc */

UPDATE ODS_APP_USER.YB_OGP_ORDER_E2EV
   SET done_proc = complete, ods_modify_date = SYSDATE
 WHERE     1 = 1
       AND complete IS NOT NULL
       AND done_proc IS NULL
       AND NVL (ignore_flag, 'N') = 'N'
       and ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Infer upstream date - Ready_to_Ship */

UPDATE ODS_APP_USER.YB_OGP_ORDER_E2EV
   SET ready_to_ship = done_proc, ods_modify_date = SYSDATE
 WHERE     1 = 1
       AND done_proc IS NOT NULL
       AND ready_to_ship IS NULL
       AND NVL (ignore_flag, 'N') = 'N'
       and ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Infer upstream date - Processing */

UPDATE ODS_APP_USER.YB_OGP_ORDER_E2EV
   SET processing = ready_to_ship, ods_modify_date = SYSDATE
 WHERE     1 = 1
       AND ready_to_ship IS NOT NULL
       AND processing IS NULL
       AND NVL (ignore_flag, 'N') = 'N'
       and ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Infer upstream date - Images_Recv */

UPDATE ODS_APP_USER.YB_OGP_ORDER_E2EV
   SET images_recv = processing, ods_modify_date = SYSDATE
 WHERE     1 = 1
       AND processing IS NOT NULL
       AND images_recv IS NULL
       AND NVL (ignore_flag, 'N') = 'N'
       and ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Infer upstream date - Uploaded */

UPDATE ODS_APP_USER.YB_OGP_ORDER_E2EV
   SET uploaded = images_recv, ods_modify_date = SYSDATE
 WHERE     1 = 1
       AND images_recv IS NOT NULL
       AND uploaded IS NULL
       AND NVL (ignore_flag, 'N') = 'N'
       and ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Infer upstream date - Routed */

UPDATE ODS_APP_USER.YB_OGP_ORDER_E2EV
   SET routed = uploaded, ods_modify_date = SYSDATE
 WHERE     1 = 1
       AND uploaded IS NOT NULL
       AND routed IS NULL
       AND NVL (ignore_flag, 'N') = 'N'
       and ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Infer upstream date - Order_Recv */

UPDATE ODS_APP_USER.YB_OGP_ORDER_E2EV
   SET order_recv = routed, ods_modify_date = SYSDATE
 WHERE     1 = 1
       AND routed IS NOT NULL
       AND order_recv IS NULL
       AND NVL (ignore_flag, 'N') = 'N'
       and ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap

&


/*-----------------------------------------------*/
/* TASK No. 14 */
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
/* TASK No. 15 */
/* Insert CDC Audit Record */

INSERT INTO ODS_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
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
,'LOAD_YB_OGP_ORDER_E2EV_PKG'
,'002'
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
'LOAD_YB_OGP_ORDER_E2EV_PKG',
'002',
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
