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
/* Drop Temp table */
/*-----------------------------------------------*/
/* TASK No. 5 */
/* Create Temp table */
/*-----------------------------------------------*/
/* TASK No. 6 */
/* Load Temp table */
/* SOURCE CODE */
/* drop table rax_app_user.fow_yb_flow_booking_year_stg */
/* create table rax_app_user.fow_yb_flow_booking_year_stg (
 FLOW_ID          NUMBER,
BOOKING_YEAR     VARCHAR2(255)
) */
/* select 
FLOW_ID,
BOOKING_YEAR  
from FOW_OWN.YB_FLOW_BOOKING_YEAR */
/* insert into rax_app_user.fow_yb_flow_booking_year_stg (
FLOW_ID,
BOOKING_YEAR
  )
values(
:FLOW_ID,
:BOOKING_YEAR ) */
/* TARGET CODE */
/*-----------------------------------------------*/
/* TASK No. 7 */
/* Merge into stage */



MERGE INTO ods_stage.fow_yb_flow_booking_year_stg t
     USING rax_app_user.fow_yb_flow_booking_year_stg s
        ON (s.flow_id = t.flow_id
                and s.booking_year = t.booking_year)
WHEN NOT MATCHED
THEN
    INSERT     (FLOW_ID,
                BOOKING_YEAR,
                ODS_CREATE_DATE,
                ODS_MODIFY_DATE)
        VALUES (s.FLOW_ID,
                s.BOOKING_YEAR,
                SYSDATE,
                SYSDATE)

& /*-----------------------------------------------*/
/* TASK No. 8 */
/* Update CDC Load Status */
/*
UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/



UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
+ nvl((TIMEZONE_OFFSET/24), 0) 
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

& /*-----------------------------------------------*/
/* TASK No. 9 */
/* Insert CDC Audit Record */
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
'LOAD_FOW_YB_FLOW_BOOKING_YEAR_PKG',
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
,'LOAD_FOW_YB_FLOW_BOOKING_YEAR_PKG'
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

& /*-----------------------------------------------*/





&