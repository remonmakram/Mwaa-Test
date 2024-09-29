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

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 4 */




/*-----------------------------------------------*/
/* TASK No. 5 */
/* Update Event_OID */

MERGE INTO ODS_STAGE.OGP_ORDER_STG d
     USING (SELECT e.EVENT_OID, s.ID
              FROM ODS_STAGE.OGP_ORDER_STG s, ods_own.event e
             WHERE REGEXP_SUBSTR (s.client_order_no, '[^_]+') =
                   e.EVENT_REF_ID
               AND s.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap) s
        ON (d.id = s.id)
WHEN MATCHED
THEN
    UPDATE SET d.event_oid = s.event_oid
    WHERE decode(s.event_oid,d.event_oid,1,0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Update Order_Type */

MERGE INTO ODS_STAGE.OGP_ORDER_STG d
     USING (SELECT ogp.id,
                   CASE
                       WHEN ogp.CLIENT_ORDER_NO LIKE '%\_O' ESCAPE '\'
                       THEN  'Order'
                       WHEN ogp.CLIENT_ORDER_NO LIKE '%\_C' ESCAPE '\'
                       THEN   'Cover'
                       WHEN ogp.CLIENT_ORDER_NO LIKE '%\_R' ESCAPE '\'
                       THEN  'Remake'
                   END
                       AS order_type
              FROM ODS_STAGE.OGP_ORDER_STG ogp
              WHERE ogp.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap
              ) s
        ON (d.id = s.id)
WHEN MATCHED
THEN
    UPDATE SET d.order_type = s.order_type
             WHERE DECODE (s.order_type, d.order_type, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 7 */
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
/* TASK No. 8 */
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
,'LOAD_OGP_ORDER_PKG'
,'010'
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
'LOAD_OGP_ORDER_PKG',
'010',
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
