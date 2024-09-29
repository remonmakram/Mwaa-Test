
MERGE INTO ODS_STAGE.APOCS_LOOK_STG t USING
(SELECT LOOK_ID        
,AUDIT_CREATE_DATE      
,AUDIT_CREATED_BY   
,AUDIT_MODIFIED_BY
,AUDIT_MODIFY_DATE   
,BUSINESS_KEY    
,LOCKID         
,LOOK_DESC   
,LOOK_NO             
,LOOK_PREF_SEQ     
,LAYOUT_GROUP_ID 
FROM RAX_APP_USER.APOCS_LOOK_STG
) s
ON (t.look_id = s.look_id)
WHEN NOT MATCHED
THEN INSERT
(LOOK_ID        
,AUDIT_CREATE_DATE      
,AUDIT_CREATED_BY   
,AUDIT_MODIFIED_BY
,AUDIT_MODIFY_DATE   
,BUSINESS_KEY    
,LOCKID         
,LOOK_DESC   
,LOOK_NO             
,LOOK_PREF_SEQ     
,LAYOUT_GROUP_ID 
,ods_modify_date
)
VALUES
(s.LOOK_ID        
,s.AUDIT_CREATE_DATE      
,s.AUDIT_CREATED_BY   
,s.AUDIT_MODIFIED_BY
,s.AUDIT_MODIFY_DATE   
,s.BUSINESS_KEY    
,s.LOCKID         
,s.LOOK_DESC   
,s.LOOK_NO             
,s.LOOK_PREF_SEQ     
,s.LAYOUT_GROUP_ID 
,sysdate
)
WHEN MATCHED
THEN UPDATE SET
 t.audit_create_date = s.AUDIT_CREATE_DATE
,t.audit_created_by = s.AUDIT_CREATED_BY
,t.audit_modified_by = s.AUDIT_MODIFIED_BY
,t.audit_modify_date = s.AUDIT_MODIFY_DATE
,t.business_key = s.BUSINESS_KEY
,t.lockid =  s.LOCKID         
,t.look_desc = s.LOOK_DESC   
,t.look_no = s.LOOK_NO             
,t.look_pref_seq = s.LOOK_PREF_SEQ     
,t.layout_group_id = s.LAYOUT_GROUP_ID 
,t.ods_modify_date = sysdate
where decode(t.audit_create_date , s.AUDIT_CREATE_DATE, 1, 0) = 0
or decode(t.audit_created_by , s.AUDIT_CREATED_BY, 1, 0) = 0
or decode(t.audit_modified_by , s.AUDIT_MODIFIED_BY, 1, 0) = 0
or decode(t.business_key , s.BUSINESS_KEY, 1, 0) = 0
or decode(t.lockid ,  s.LOCKID , 1, 0) = 0         
or decode(t.look_desc , s.LOOK_DESC , 1, 0) = 0   
or decode(t.look_no , s.LOOK_NO , 1, 0) = 0             
or decode(t.look_pref_seq , s.LOOK_PREF_SEQ , 1, 0) = 0   
or decode(t.layout_group_id , s.LAYOUT_GROUP_ID , 1, 0) = 0

&& /*-----------------------------------------------*/
/* TASK No. 8 */
/* XR */



insert into ods_stage.apocs_look_xr
( look_id
, look_oid
, ods_modify_date
)
select look_id
, ods_stage.look_oid_seq.nextval
, sysdate
from ods_stage.apocs_look_stg s
where ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - 1
and not exists
(
select 1
from ods_stage.apocs_look_xr xr
where xr.look_id = s.look_id
)

&& /*-----------------------------------------------*/
/* TASK No. 9 */
/* ODS_OWN */



merge into ods_own.look t using
(
select xr.look_oid
,ss.source_system_oid
,l.LOOK_DESC
,l.LOOK_NO
,l.LOOK_PREF_SEQ
,lg.LAYOUT_GROUP_OID
from ods_stage.apocs_look_stg l
, ods_stage.apocs_look_xr xr
, ods_own.source_system ss
, ods_stage.apocs_layout_group_xr lg
where l.look_id = xr.look_id
and ss.source_system_short_name = 'APOCS'
and l.layout_group_id = lg.layout_group_id(+)
and l.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - 1
) s
on ( s.look_oid = t.look_oid )
when matched then update
set t.source_system_oid = s.source_system_oid
,t.LOOK_DESC = s.look_desc
,t.LOOK_NO = s.look_no
,t.LOOK_PREF_SEQ  = s.look_pref_seq
,t.LAYOUT_GROUP_OID = s.layout_group_oid
,t.ods_modify_date = sysdate
where decode(t.source_system_oid , s.source_system_oid, 1, 0) = 0
or decode(t.look_desc, s.look_desc, 1, 0) = 0
or decode(t.look_no, s.look_no, 1, 0) = 0
or decode(t.look_pref_seq, s.look_pref_seq, 1, 0) = 0
or decode(t.layout_group_oid, s.layout_group_oid, 1, 0) = 0
when not matched then insert
(t.look_oid
,t.source_system_oid
,t.ods_create_date
,t.ods_modify_date
,t.LOOK_DESC
,t.LOOK_NO
,t.LOOK_PREF_SEQ
,t.LAYOUT_GROUP_OID
)
values
(s.look_oid
,s.source_system_oid
,sysdate
,sysdate
,s.LOOK_DESC
,s.LOOK_NO
,s.LOOK_PREF_SEQ
,s.LAYOUT_GROUP_OID
)

&& /*-----------------------------------------------*/
/* TASK No. 10 */
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

&& /*-----------------------------------------------*/
/* TASK No. 11 */
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
'LOAD_APOCS_LOOK_STG_PKG',
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
,'LOAD_APOCS_LOOK_STG_PKG'
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

&& /*-----------------------------------------------*/





&&