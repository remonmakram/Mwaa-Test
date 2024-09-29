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
/* XR */

insert into ods_stage.mfg_finishing_code_xr t
( FINISHING_CODE_OID
, item_id
, finishing_code
, ods_create_date
, ods_modify_date
)
select ods_stage.MFG_FINISHING_CODE_OID_SEQ.nextval
, s.item_id
, s.finishing_code
, sysdate
, sysdate
from ods_stage.mic_item_finishing_code_stg s
where s.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap 
and not exists
( 
select 1
from ods_stage.mfg_finishing_code_xr t2
where s.item_id = t2.item_id
and s.finishing_code = t2.finishing_code
)

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* ODS */

insert into ods_own.mfg_finishing_code t
( FINISHING_CODE_OID
, item_id
, finishing_code
, source_system_oid
, ods_create_date
, ods_modify_date
)
select xr.FINISHING_CODE_OID
, s.item_id
, s.finishing_code
, ss.source_system_oid
, sysdate
, sysdate
from ods_stage.mic_item_finishing_code_stg s
, ods_own.source_system ss
, ods_stage.mfg_finishing_code_xr xr
where s.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap 
and ss.source_system_short_name = 'MI'
and s.item_id = xr.item_id
and s.finishing_code = xr.finishing_code
and not exists
( 
select 1
from ods_own.mfg_finishing_code t2
where s.item_id = t2.item_id
and s.finishing_code = t2.finishing_code
)

&


/*-----------------------------------------------*/
/* TASK No. 6 */
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
             SUBSTR('2024-06-04 09:55:50.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=#LIFETOUCH_PROJECT.v_cdc_load_table_name
AND CONTEXT_NAME = 'PROD'
*/

&


/*-----------------------------------------------*/
/* TASK No. 7 */
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
,'LOAD_MFG_FINISHING_CODE_PKG'
,'004'
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
#LIFETOUCH_PROJECT.v_cdc_load_table_name,
29842374200,
'LOAD_MFG_FINISHING_CODE_PKG',
'004',
TO_DATE(
             SUBSTR('2024-06-04 09:55:50.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR ('#LIFETOUCH_PROJECT.v_cdc_load_date', 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,#LIFETOUCH_PROJECT.v_cdc_overlap,
SYSDATE,
 'PROD')
*/


&


/*-----------------------------------------------*/
