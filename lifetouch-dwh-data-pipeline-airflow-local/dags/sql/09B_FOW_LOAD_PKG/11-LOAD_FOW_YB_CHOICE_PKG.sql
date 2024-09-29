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
/* drop table rax_app_user.fow_yb_choice_stg */
/* create table rax_app_user.fow_yb_choice_stg (
CHOICE_ID        NUMBER,
  CHOICE_NAME      VARCHAR2(64),
  ITEM_ID          NUMBER,
  TAG_ID           NUMBER,
  PAGES            NUMBER,
  SCHOOL_PRICING   NUMBER,
  DATE_CREATED     DATE,
  CREATED_BY       VARCHAR2(255),
  LAST_UPDATED     DATE,
  UPDATED_BY       VARCHAR2(255),
  ACTIVE           NUMBER) */
/* select 
  CHOICE_ID,     
  CHOICE_NAME,   
  ITEM_ID,       
  TAG_ID,        
  PAGES ,        
  SCHOOL_PRICING,
  DATE_CREATED , 
  CREATED_BY ,   
  LAST_UPDATED,  
  UPDATED_BY,    
  ACTIVE               
from FOW_OWN.YB_CHOICE
where last_updated >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap */
/* insert into rax_app_user.fow_yb_choice_stg (
  CHOICE_ID,     
  CHOICE_NAME,   
  ITEM_ID,       
  TAG_ID,        
  PAGES,         
  SCHOOL_PRICING,
  DATE_CREATED,  
  CREATED_BY,    
  LAST_UPDATED,  
  UPDATED_BY,    
  ACTIVE        
   )
values(
 :CHOICE_ID,     
 :CHOICE_NAME,   
 :ITEM_ID,       
 :TAG_ID,        
 :PAGES,         
 :SCHOOL_PRICING,
 :DATE_CREATED,  
 :CREATED_BY,    
 :LAST_UPDATED,  
 :UPDATED_BY,    
 :ACTIVE        
   ) */
/* TARGET CODE */
/*-----------------------------------------------*/
/* TASK No. 7 */
/* Merge into stage */



MERGE INTO ods_stage.fow_yb_choice_stg t
     USING rax_app_user.fow_yb_choice_stg s
        ON (s.choice_id = t.choice_id)
WHEN MATCHED
THEN
    UPDATE SET
        t.CHOICE_NAME = s.CHOICE_NAME,
        t.ITEM_ID = s.ITEM_ID,
        t.TAG_ID = s.TAG_ID,
        t.PAGES = s.PAGES,
        t.SCHOOL_PRICING = s.SCHOOL_PRICING,
        t.date_created = s.date_created,
        t.created_by = s.created_by,
        t.last_updated = s.last_updated,
        t.updated_by = s.updated_by,
        t.active = s.active,
        t.ods_modify_date = SYSDATE
             WHERE    DECODE (t.CHOICE_NAME, s.CHOICE_NAME, 1, 0) = 0
                   OR DECODE (t.ITEM_ID, s.ITEM_ID, 1, 0) = 0
                   OR DECODE (t.TAG_ID, s.TAG_ID, 1, 0) = 0
                   OR DECODE (t.PAGES, s.PAGES, 1, 0) = 0
                   OR DECODE (t.SCHOOL_PRICING, s.SCHOOL_PRICING, 1, 0) = 0
                   OR DECODE (t.date_created, s.date_created, 1, 0) = 0
                   OR DECODE (t.created_by, s.created_by, 1, 0) = 0
                   OR DECODE (t.last_updated, s.last_updated, 1, 0) = 0
                   OR DECODE (t.updated_by, s.updated_by, 1, 0) = 0
                   OR DECODE (t.active, s.active, 1, 0) = 0
WHEN NOT MATCHED
THEN
    INSERT     (CHOICE_ID,
                CHOICE_NAME,
                ITEM_ID,
                TAG_ID,
                PAGES,
                SCHOOL_PRICING,
                DATE_CREATED,
                CREATED_BY,
                LAST_UPDATED,
                UPDATED_BY,
                ACTIVE,
                ods_create_date,
                ods_modify_date)
        VALUES (s.CHOICE_ID,
                s.CHOICE_NAME,
                s.ITEM_ID,
                s.TAG_ID,
                s.PAGES,
                s.SCHOOL_PRICING,
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
'LOAD_FOW_YB_CHOICE_PKG',
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
,'LOAD_FOW_YB_CHOICE_PKG'
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