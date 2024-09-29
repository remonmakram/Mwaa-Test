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
/* drop table rax_app_user.fow_yb_feature_stg */
/* create table rax_app_user.fow_yb_feature_stg (
FEATURE_ID           NUMBER,
  FEATURE_NAME         VARCHAR2(64),
  FOR_FLOW_ID          NUMBER,
  BOOKING_YEAR         VARCHAR2(255),
  FEATURE_TYPE         VARCHAR2(16),
  FEATURE_CATEGORY     VARCHAR2(16),
  UPDATE_CUTOFF_EVENT  VARCHAR2(64),
  DATE_CREATED         DATE,
  CREATED_BY           VARCHAR2(255),
  LAST_UPDATED         DATE,
  UPDATED_BY           VARCHAR2(255),
  ACTIVE               NUMBER) */
/* select 
FEATURE_ID,         
FEATURE_NAME,       
FOR_FLOW_ID,        
BOOKING_YEAR,       
FEATURE_TYPE,       
FEATURE_CATEGORY,   
UPDATE_CUTOFF_EVENT,
DATE_CREATED,       
CREATED_BY,         
LAST_UPDATED,       
UPDATED_BY,         
ACTIVE               
from FOW_OWN.YB_FEATURE
where last_updated >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap */
/* insert into rax_app_user.fow_yb_feature_stg (
FEATURE_ID,         
FEATURE_NAME,       
FOR_FLOW_ID,        
BOOKING_YEAR,       
FEATURE_TYPE,       
FEATURE_CATEGORY,   
UPDATE_CUTOFF_EVENT,
DATE_CREATED,       
CREATED_BY,         
LAST_UPDATED,       
UPDATED_BY,         
ACTIVE            )
values(
:FEATURE_ID,         
:FEATURE_NAME,       
:FOR_FLOW_ID,        
:BOOKING_YEAR,       
:FEATURE_TYPE,       
:FEATURE_CATEGORY,   
:UPDATE_CUTOFF_EVENT,
:DATE_CREATED,       
:CREATED_BY,         
:LAST_UPDATED,       
:UPDATED_BY,         
:ACTIVE       ) */
/* TARGET CODE */
/*-----------------------------------------------*/
/* TASK No. 7 */
/* Merge into stage */



MERGE INTO ods_stage.fow_yb_feature_stg t
     USING rax_app_user.fow_yb_feature_stg s
        ON (s.FEATURE_ID = t.FEATURE_ID)
WHEN MATCHED
THEN
    UPDATE SET
        t.FEATURE_NAME = s.FEATURE_NAME,
        t.FOR_FLOW_ID = s.FOR_FLOW_ID,
        t.BOOKING_YEAR = s.BOOKING_YEAR,
        t.FEATURE_TYPE = s.FEATURE_TYPE,
        t.FEATURE_CATEGORY = s.FEATURE_CATEGORY,
        t.UPDATE_CUTOFF_EVENT = s.UPDATE_CUTOFF_EVENT,
        t.date_created = s.date_created,
        t.created_by = s.created_by,
        t.last_updated = s.last_updated,
        t.updated_by = s.updated_by,
        t.active = s.active,
        t.ods_modify_date = SYSDATE
             WHERE    DECODE (t.FEATURE_NAME, s.FEATURE_NAME, 1, 0) = 0
                   OR DECODE (t.FOR_FLOW_ID, s.FOR_FLOW_ID, 1, 0) = 0
                   OR DECODE (t.BOOKING_YEAR, s.BOOKING_YEAR, 1, 0) = 0
                   OR DECODE (t.FEATURE_TYPE, s.FEATURE_TYPE, 1, 0) = 0
                   OR DECODE (t.FEATURE_CATEGORY, s.FEATURE_CATEGORY, 1, 0) =
                      0
                   OR DECODE (t.UPDATE_CUTOFF_EVENT,
                              s.UPDATE_CUTOFF_EVENT, 1,
                              0) =
                      0
                   OR DECODE (t.date_created, s.date_created, 1, 0) = 0
                   OR DECODE (t.created_by, s.created_by, 1, 0) = 0
                   OR DECODE (t.last_updated, s.last_updated, 1, 0) = 0
                   OR DECODE (t.updated_by, s.updated_by, 1, 0) = 0
                   OR DECODE (t.active, s.active, 1, 0) = 0
WHEN NOT MATCHED
THEN
    INSERT     (FEATURE_ID,
                FEATURE_NAME,
                FOR_FLOW_ID,
                BOOKING_YEAR,
                FEATURE_TYPE,
                FEATURE_CATEGORY,
                UPDATE_CUTOFF_EVENT,
                DATE_CREATED,
                CREATED_BY,
                LAST_UPDATED,
                UPDATED_BY,
                ACTIVE,
                ODS_CREATE_DATE,
                ODS_MODIFY_DATE)
        VALUES (s.FEATURE_ID,
                s.FEATURE_NAME,
                s.FOR_FLOW_ID,
                s.BOOKING_YEAR,
                s.FEATURE_TYPE,
                s.FEATURE_CATEGORY,
                s.UPDATE_CUTOFF_EVENT,
                s.DATE_CREATED,
                s.CREATED_BY,
                s.LAST_UPDATED,
                s.UPDATED_BY,
                s.ACTIVE,
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
'LOAD_FOW_YB_FEATURE_PKG',
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
,'LOAD_FOW_YB_FEATURE_PKG'
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