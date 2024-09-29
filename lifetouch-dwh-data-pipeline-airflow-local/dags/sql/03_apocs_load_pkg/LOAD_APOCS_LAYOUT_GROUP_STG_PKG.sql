
MERGE INTO ODS_STAGE.APOCS_LAYOUT_GROUP_STG t USING
(SELECT LAYOUT_GROUP_ID
,AUDIT_CREATE_DATE
,AUDIT_CREATED_BY
,AUDIT_MODIFIED_BY
,AUDIT_MODIFY_DATE
,BUSINESS_KEY
,LAYOUTGROUPPREPICDAYSEQNO
,LAYOUTID
,LOCKID
,PARENT_LAYOUTID
,TYPE
,VM_ID
,LAYOUTGROUPPOSTPICDAYSEQNO
,PRERENDERING_CACHE_DAYS
FROM RAX_APP_USER.APOCS_LAYOUT_GROUP_STG
) s
ON (t.layout_group_id = s.layout_group_id)
WHEN NOT MATCHED
THEN INSERT
(LAYOUT_GROUP_ID
,AUDIT_CREATE_DATE
,AUDIT_CREATED_BY
,AUDIT_MODIFIED_BY
,AUDIT_MODIFY_DATE
,BUSINESS_KEY
,LAYOUTGROUPPREPICDAYSEQNO
,LAYOUTID
,LOCKID
,PARENT_LAYOUTID
,TYPE
,VM_ID
,LAYOUTGROUPPOSTPICDAYSEQNO
,PRERENDERING_CACHE_DAYS
,ods_modify_date
)
VALUES
(s.LAYOUT_GROUP_ID
,s.AUDIT_CREATE_DATE
,s.AUDIT_CREATED_BY
,s.AUDIT_MODIFIED_BY
,s.AUDIT_MODIFY_DATE
,s.BUSINESS_KEY
,s.LAYOUTGROUPPREPICDAYSEQNO
,s.LAYOUTID
,s.LOCKID
,s.PARENT_LAYOUTID
,s.TYPE
,s.VM_ID
,s.LAYOUTGROUPPOSTPICDAYSEQNO
,s.PRERENDERING_CACHE_DAYS
,sysdate
)
WHEN MATCHED
THEN UPDATE SET
 t.audit_create_date = s.AUDIT_CREATE_DATE
,t.audit_created_by = s.AUDIT_CREATED_BY
,t.audit_modified_by = s.AUDIT_MODIFIED_BY
,t.audit_modify_date = s.AUDIT_MODIFY_DATE
,t.business_key = s.BUSINESS_KEY
,t.LAYOUTGROUPPREPICDAYSEQNO = s.LAYOUTGROUPPREPICDAYSEQNO
,t.layoutid = s.LAYOUTID
,t.lockid = s.LOCKID
,t.parent_layoutid = s.PARENT_LAYOUTID
,t.type = s.TYPE
,t.vm_id = s.VM_ID
,t.LAYOUTGROUPPOSTPICDAYSEQNO = s.LAYOUTGROUPPOSTPICDAYSEQNO
,t.PRERENDERING_CACHE_DAYS = s.PRERENDERING_CACHE_DAYS
,t.ods_modify_date = sysdate
where decode(t.audit_create_date , s.AUDIT_CREATE_DATE, 1, 0) = 0
or decode(t.audit_created_by , s.AUDIT_CREATED_BY, 1, 0) = 0
or decode(t.audit_modified_by , s.AUDIT_MODIFIED_BY, 1, 0) = 0
or decode(t.business_key , s.BUSINESS_KEY, 1, 0) = 0
or decode(t.LAYOUTGROUPPREPICDAYSEQNO , s.LAYOUTGROUPPREPICDAYSEQNO, 1, 0) = 0
or decode(t.layoutid , s.LAYOUTID, 1, 0) = 0
or decode(t.lockid , s.LOCKID, 1, 0) = 0
or decode(t.parent_layoutid , s.PARENT_LAYOUTID, 1, 0) = 0
or decode(t.type , s.TYPE, 1, 0) = 0
or decode(t.vm_id , s.VM_ID, 1, 0) = 0
or decode(t.LAYOUTGROUPPOSTPICDAYSEQNO , s.LAYOUTGROUPPOSTPICDAYSEQNO, 1, 0) = 0
or decode(t.PRERENDERING_CACHE_DAYS , s.PRERENDERING_CACHE_DAYS, 1, 0) = 0
or decode(t.PRERENDERING_CACHE_DAYS , s.PRERENDERING_CACHE_DAYS, 1, 0) = 0

&& /*-----------------------------------------------*/
/* TASK No. 8 */
/* XR */



insert into ods_stage.apocs_layout_group_xr
( layout_group_id
, layout_group_oid
, ods_modify_date
)
select layout_group_id
, ods_stage.layout_group_oid_seq.nextval
, sysdate
from ods_stage.apocs_layout_group_stg s
where ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - 1
and not exists
(
select 1
from ods_stage.apocs_layout_group_xr xr
where xr.layout_group_id = s.layout_group_id
)

&& /*-----------------------------------------------*/
/* TASK No. 9 */
/* ODS_OWN */



merge into ods_own.layout_group t using
(
select xr.layout_group_oid
,ss.source_system_oid
,lg.BUSINESS_KEY
,lg.LAYOUTGROUPPREPICDAYSEQNO
,lg.LAYOUTID
,lg.PARENT_LAYOUTID
,lg.TYPE
,lg.LAYOUTGROUPPOSTPICDAYSEQNO
,lg.PRERENDERING_CACHE_DAYS
,max(vm.visual_merch_oid) as visual_merch_oid
from ods_stage.apocs_layout_group_stg lg
, ods_stage.apocs_layout_group_xr xr
, ods_own.source_system ss
, ods_stage.apocs_visual_merchandise_stg vms
, ods_own.visual_merch vm
where lg.layout_group_id = xr.layout_group_id
and ss.source_system_short_name = 'APOCS'
and lg.vm_id = vms.vm_id(+)
and vms.business_key = vm.visual_merch_id(+)
and lg.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - 1
group by xr.layout_group_oid
,ss.source_system_oid
,lg.BUSINESS_KEY
,lg.LAYOUTGROUPPREPICDAYSEQNO
,lg.LAYOUTID
,lg.PARENT_LAYOUTID
,lg.TYPE
,lg.LAYOUTGROUPPOSTPICDAYSEQNO
,lg.PRERENDERING_CACHE_DAYS
) s
on ( s.layout_group_oid = t.layout_group_oid )
when matched then update
set t.source_system_oid = s.source_system_oid
,t.BUSINESS_KEY= s.business_key
,t.LAYOUTGROUPPREPICDAYSEQNO = s.LAYOUTGROUPPREPICDAYSEQNO
,t.LAYOUTID= s.layoutid
,t.PARENT_LAYOUTID = s.parent_layoutid
,t.TYPE = s.type
,t.visual_merch_oid= s.visual_merch_oid
,t.LAYOUTGROUPPOSTPICDAYSEQNO= s.LAYOUTGROUPPOSTPICDAYSEQNO
,t.PRERENDERING_CACHE_DAYS= s.PRERENDERING_CACHE_DAYS
,t.ods_modify_date = sysdate
where decode(t.source_system_oid , s.source_system_oid, 1, 0) = 0
or decode(t.BUSINESS_KEY, s.business_key, 1, 0) = 0
or decode(t.LAYOUTGROUPPREPICDAYSEQNO , s.LAYOUTGROUPPREPICDAYSEQNO, 1, 0) = 0
or decode(t.LAYOUTID, s.layoutid, 1, 0) = 0
or decode(t.PARENT_LAYOUTID , s.parent_layoutid, 1, 0) = 0
or decode(t.TYPE , s.type, 1, 0) = 0
or decode(t.visual_merch_oid, s.visual_merch_oid, 1, 0) = 0
or decode(t.LAYOUTGROUPPOSTPICDAYSEQNO, s.LAYOUTGROUPPOSTPICDAYSEQNO, 1, 0) = 0
or decode(t.PRERENDERING_CACHE_DAYS, s.PRERENDERING_CACHE_DAYS, 1, 0) = 0
when not matched then insert
(t.layout_group_oid
,t.source_system_oid
,t.ods_create_date
,t.ods_modify_date
,t.BUSINESS_KEY
,t.LAYOUTGROUPPREPICDAYSEQNO
,t.LAYOUTID
,t.PARENT_LAYOUTID
,t.TYPE
,t.visual_merch_oid
,t.LAYOUTGROUPPOSTPICDAYSEQNO
,t.PRERENDERING_CACHE_DAYS
)
values
(s.layout_group_oid
,s.source_system_oid
,sysdate
,sysdate
,s.BUSINESS_KEY
,s.LAYOUTGROUPPREPICDAYSEQNO
,s.LAYOUTID
,s.PARENT_LAYOUTID
,s.TYPE
,s.visual_merch_oid
,s.LAYOUTGROUPPOSTPICDAYSEQNO
,s.PRERENDERING_CACHE_DAYS
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
'LOAD_APOCS_LAYOUT_GROUP_STG_PKG',
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
,'LOAD_APOCS_LAYOUT_GROUP_STG_PKG'
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