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
/* drop stage */
/*-----------------------------------------------*/
/* TASK No. 5 */
/* create stage */
/*-----------------------------------------------*/
/* TASK No. 6 */
/* select and load stage */
/* SOURCE CODE */
/* drop table RAX_APP_USER.fow_names_file_stg */
/* create table RAX_APP_USER.fow_names_file_stg
(ID           NUMBER not null
,APO_ID       NUMBER
,COMMENTS     VARCHAR2(255 CHAR)
,CREATED_BY   VARCHAR2(255 CHAR)
,DATE_CREATED date
,FILE_NAME    VARCHAR2(255 CHAR)
,LAST_UPDATED date
,STATUS       VARCHAR2(255 CHAR)
,UPDATED_BY   VARCHAR2(255 CHAR)
,EVENT_ID     NUMBER
) */
/* select ID 
,APO_ID    
,COMMENTS    
,CREATED_BY  
,DATE_CREATED 
,FILE_NAME  
,LAST_UPDATED 
,STATUS       
,UPDATED_BY   
,EVENT_ID    
from fow_own.names_file
where last_updated >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap */
/* insert into RAX_APP_USER.fow_names_file_stg
( ID 
,APO_ID    
,COMMENTS    
,CREATED_BY  
,DATE_CREATED 
,FILE_NAME  
,LAST_UPDATED 
,STATUS       
,UPDATED_BY   
,EVENT_ID   
)
values
( :ID
, :APO_ID    
, :COMMENTS    
, :CREATED_BY  
, :DATE_CREATED 
, :FILE_NAME  
, :LAST_UPDATED 
, :STATUS       
, :UPDATED_BY   
, :EVENT_ID   
) */
/* TARGET CODE */
/*-----------------------------------------------*/
/* TASK No. 7 */
/* index stage */



create unique index RAX_APP_USER.fow_names_file_stg_uk on RAX_APP_USER.fow_names_file_stg(id)

& /*-----------------------------------------------*/
/* TASK No. 8 */
/* merge to target */



merge into ODS_STAGE.fow_names_file_stg t
using RAX_APP_USER.fow_names_file_stg s
on (s.id = t.id)
when matched then update
set t.APO_ID = s.apo_id
, t.COMMENTS = s.comments    
, t.CREATED_BY = s.created_by  
, t.DATE_CREATED = s.date_created 
, t.FILE_NAME = s.file_name  
, t.LAST_UPDATED = s.last_updated 
, t.STATUS = s.status       
, t.UPDATED_BY = s.updated_by   
, t.EVENT_ID = s.event_id   
, t.ods_modify_date = sysdate
where decode(t.APO_ID , s.apo_id,1,0) = 0
or decode(t.COMMENTS , s.comments,1,0) = 0
or decode(t.CREATED_BY , s.created_by,1,0) = 0
or decode(t.DATE_CREATED , s.date_created,1,0) = 0
or decode(t.FILE_NAME , s.file_name,1,0) = 0
or decode(t.LAST_UPDATED , s.last_updated,1,0) = 0
or decode(t.STATUS , s.status,1,0) = 0
or decode(t.UPDATED_BY , s.updated_by,1,0) = 0
or decode(t.EVENT_ID , s.event_id,1,0) = 0
when not matched then insert
(t.ID 
,t.APO_ID    
,t.COMMENTS    
,t.CREATED_BY  
,t.DATE_CREATED 
,t.FILE_NAME  
,t.LAST_UPDATED 
,t.STATUS       
,t.UPDATED_BY   
,t.EVENT_ID   
,t.ods_modify_date
)
values
(s.ID 
,s.APO_ID
,s.COMMENTS
,s.CREATED_BY
,s.DATE_CREATED
,s.FILE_NAME
,s.LAST_UPDATED
,s.STATUS
,s.UPDATED_BY
,s.EVENT_ID
,sysdate
)

& /*-----------------------------------------------*/
/* TASK No. 9 */
/* xr table */



merge into ODS_STAGE.names_file_xr t
using
(
select nf.id
, apo.apo_tag as apo_id
, event.event_ref_id
from ods_stage.fow_names_file_stg nf
, ods_stage.fow_apo_stage apo
, ods_stage.fow_event_stg event
where nf.apo_id = apo.id(+)
and nf.event_id = event.id(+)
and nf.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap
) s
on (s.id = t.id)
when matched then update
set t.APO_ID = s.apo_id
, t.EVENT_REF_ID = s.event_ref_id
where decode(t.APO_ID , s.apo_id,1,0) = 0
or decode(t.EVENT_REF_ID , s.event_ref_id,1,0) = 0
when not matched then insert
(t.ID
,t.APO_ID
,t.EVENT_REF_ID
,t.names_file_oid
)
values
(s.ID
,s.APO_ID
,s.EVENT_REF_ID
,ods_stage.names_file_oid_seq.nextval
)

& /*-----------------------------------------------*/
/* TASK No. 10 */
/* merge to ods_own.names_file */



merge into ODS_OWN.names_file t
using 
(
select xr.names_file_oid
, nf.comments
, nf.created_by
, nf.date_created
, nf.file_name
, nf.last_updated
, nf.status
, nf.updated_by
, e.event_oid
, apo.apo_oid
, xr.event_ref_id
, xr.apo_id
, ss.source_system_oid
from ods_stage.fow_names_file_stg nf
, ods_stage.names_file_xr xr
, ods_own.event e
, ods_own.apo
, ods_own.source_system ss
where nf.id = xr.id
and xr.event_ref_id = e.event_ref_id(+)
and xr.apo_id = apo.apo_id(+)
and 'FOW' = ss.source_system_short_name
and nf.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap
) s
on (s.names_file_oid = t.names_file_oid)
when matched then update
set t.COMMENTS = s.comments    
, t.CREATED_BY = s.created_by  
, t.DATE_CREATED = s.date_created 
, t.FILE_NAME = s.file_name  
, t.LAST_UPDATED = s.last_updated 
, t.STATUS = s.status       
, t.UPDATED_BY = s.updated_by   
, t.EVENT_OID = s.event_oid   
, t.APO_OID = s.apo_oid   
, t.EVENT_REF_ID = s.event_ref_id   
, t.APO_ID = s.apo_id   
, t.source_system_oid = s.source_system_oid
, t.ods_modify_date = sysdate
where decode(t.COMMENTS , s.comments,1,0) = 0
or decode(t.CREATED_BY , s.created_by,1,0) = 0
or decode(t.DATE_CREATED , s.date_created,1,0) = 0
or decode(t.FILE_NAME , s.file_name,1,0) = 0
or decode(t.LAST_UPDATED , s.last_updated,1,0) = 0
or decode(t.STATUS , s.status,1,0) = 0
or decode(t.UPDATED_BY , s.updated_by,1,0) = 0
or decode(t.EVENT_OID , s.event_oid,1,0) = 0
or decode(t.APO_OID , s.apo_oid,1,0) = 0
or decode(t.EVENT_REF_ID , s.event_ref_id,1,0) = 0
or decode(t.APO_ID , s.apo_id,1,0) = 0
when not matched then insert
( t.NAMES_FILE_OID 
, t.COMMENTS
, t.CREATED_BY
, t.DATE_CREATED
, t.FILE_NAME
, t.LAST_UPDATED
, t.STATUS
, t.UPDATED_BY
, t.EVENT_OID
, t.APO_OID
, t.EVENT_REF_ID
, t.APO_ID
, t.source_system_oid
, t.ods_modify_date
, t.ods_create_date
)
values
( s.NAMES_FILE_OID
, s.COMMENTS 
, s.CREATED_BY 
, s.DATE_CREATED 
, s.FILE_NAME 
, s.LAST_UPDATED 
, s.STATUS 
, s.UPDATED_BY 
, s.EVENT_OID 
, s.APO_OID 
, s.EVENT_REF_ID 
, s.APO_ID 
, s.source_system_oid 
,sysdate
,sysdate
)

& /*-----------------------------------------------*/
/* TASK No. 11 */
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
/* TASK No. 12 */
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
'LOAD_FOW_NAMES_FILE_PKG',
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
,'LOAD_FOW_NAMES_FILE_PKG'
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