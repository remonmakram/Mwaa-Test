
MERGE INTO ODS_STAGE.APOCS_LL_THEME_ASSOC_STG t USING
(SELECT 
LOOK_LAYOUT_THEME_ASSOC_ID
,AUDIT_CREATE_DATE
,AUDIT_CREATED_BY
,AUDIT_MODIFIED_BY
,AUDIT_MODIFY_DATE
,BUSINESS_KEY  
,LOCKID 
,LOOK_LAYOUT_THEMEID
,LOOK_NO
,VM_ID
,IS_DEFAULT  
FROM rax_app_user.look_layout_theme_assoc
) s
ON (t.LOOK_LAYOUT_THEME_ASSOC_ID = s.LOOK_LAYOUT_THEME_ASSOC_ID)
WHEN NOT MATCHED
THEN INSERT
(LOOK_LAYOUT_THEME_ASSOC_ID
,AUDIT_CREATE_DATE
,AUDIT_CREATED_BY
,AUDIT_MODIFIED_BY
,AUDIT_MODIFY_DATE
,BUSINESS_KEY  
,LOCKID 
,LOOK_LAYOUT_THEMEID
,LOOK_NO
,VM_ID
,IS_DEFAULT
,ODS_CREATE_DATE   
,ODS_MODIFY_DATE
)
VALUES
(s.LOOK_LAYOUT_THEME_ASSOC_ID
,s.AUDIT_CREATE_DATE
,s.AUDIT_CREATED_BY
,s.AUDIT_MODIFIED_BY
,s.AUDIT_MODIFY_DATE
,s.BUSINESS_KEY  
,s.LOCKID 
,s.LOOK_LAYOUT_THEMEID
,s.LOOK_NO
,s.VM_ID
,s.IS_DEFAULT  
,sysdate
,sysdate
)
WHEN MATCHED
THEN UPDATE SET
t.AUDIT_CREATE_DATE = s.AUDIT_CREATE_DATE
,t.AUDIT_CREATED_BY = s.AUDIT_CREATED_BY
,t.AUDIT_MODIFIED_BY   =  s.AUDIT_MODIFIED_BY
,t.AUDIT_MODIFY_DATE  =  s.AUDIT_MODIFY_DATE
,t.BUSINESS_KEY  =    s.BUSINESS_KEY 
,t.LOCKID   =  s.LOCKID 
,t.LOOK_LAYOUT_THEMEID  =  s.LOOK_LAYOUT_THEMEID
,t.LOOK_NO =  s.LOOK_NO
,t.VM_ID  =   s.VM_ID
,t.IS_DEFAULT    = s .IS_DEFAULT
,t.ods_modify_date = sysdate
where decode(t.audit_create_date , s.AUDIT_CREATE_DATE, 1, 0) = 0
or decode(t.audit_created_by , s.AUDIT_CREATED_BY, 1, 0) = 0
or decode(t.audit_modified_by , s.AUDIT_MODIFIED_BY, 1, 0) = 0
or decode(t.business_key , s.BUSINESS_KEY, 1, 0) = 0     
or decode(t.lockid , s.LOCKID , 1, 0) = 0    
or decode(t.look_layout_themeid , s.LOOK_LAYOUT_THEMEID , 1, 0) = 0     
or decode(t.look_no , s.LOOK_NO , 1, 0) = 0   
or decode(t.vm_id , s.VM_ID , 1, 0) = 0      
or decode(t.is_default , s.IS_DEFAULT , 1, 0) = 0

&& /*-----------------------------------------------*/
/* TASK No. 8 */
/* merge into  ods_stage.apocs_ll_theme_assoc_xr */



merge into ods_stage.apocs_ll_theme_assoc_xr d
using (
select * from
    (  select
        xr.look_layout_theme_assoc_oid, 
		stg.look_layout_theme_assoc_id,
		stg.LOOK_LAYOUT_THEMEID,
		stg.VM_ID,
		sysdate as ODS_CREATE_DATE,
		sysdate as ods_modify_date
      from
         ods_stage.apocs_ll_theme_assoc_stg stg
        ,ods_stage.apocs_ll_theme_assoc_xr xr
       where (1=1)
        and stg.ods_modify_date >= to_date(substr(:v_cdc_load_date, 1, 19), 'yyyy-mm-dd hh24:mi:ss')  -:v_cdc_overlap
        and stg.look_layout_theme_assoc_id=xr.look_layout_theme_assoc_id(+)
     ) s
where not exists
	( select 1 from ods_stage.apocs_ll_theme_assoc_xr t 
	where  t.look_layout_theme_assoc_id = s.look_layout_theme_assoc_id
                                   and  ((t.look_layout_theme_assoc_oid = s.look_layout_theme_assoc_oid) or (t.look_layout_theme_assoc_oid is null and s.look_layout_theme_assoc_oid  is null))
		                           and((t.look_layout_theme_assoc_id = s.look_layout_theme_assoc_id) or (t.look_layout_theme_assoc_id is null and s.look_layout_theme_assoc_id is null))
								   and((t.LOOK_LAYOUT_THEMEID = s.LOOK_LAYOUT_THEMEID) or (t.LOOK_LAYOUT_THEMEID is null and s.LOOK_LAYOUT_THEMEID is null)) 
								   and((t.VM_ID = s.VM_ID) or (t.VM_ID is null and s.VM_ID is null)) 
	)
) s
on
  (s.look_layout_theme_assoc_id  =d.look_layout_theme_assoc_id)
when matched
then update
set
  --d.look_layout_theme_assoc_oid = s.look_layout_theme_assoc_oid,
    d.LOOK_LAYOUT_THEMEID = s.LOOK_LAYOUT_THEMEID,
	  d.VM_ID = s.VM_ID,
       d.ods_modify_date = s.ods_modify_date
when not matched then
insert (
  look_layout_theme_assoc_oid,
  look_layout_theme_assoc_id , 
  LOOK_LAYOUT_THEMEID,
   VM_ID ,
	ODS_CREATE_DATE,
  ods_modify_date)
values (
  ods_stage.l0ok_layout_them_assoc_oid_seq.nextval,
  s.look_layout_theme_assoc_id,
  s.LOOK_LAYOUT_THEMEID,
  s.VM_ID,
  s.ODS_CREATE_DATE,
  s.ods_modify_date
  )

&& /*-----------------------------------------------*/
/* TASK No. 9 */
/* merge into ods_own.look_layout_theme_assoc t */



merge into ods_own.look_layout_theme_assoc t 
USING (
select 
xr.look_layout_theme_assoc_oid
,ss.source_system_oid
,lta.business_key
,lta.look_layout_themeid
,lta.look_no
,lta.vm_id
,lta.is_default
,vm.visual_merch_oid
,ltxr.layout_theme_oid
from ods_stage.apocs_ll_theme_assoc_stg lta
, ods_stage.apocs_ll_theme_assoc_xr xr
, ods_own.source_system ss
, ods_stage.apocs_visual_merchandise_stg vms
, ods_own.visual_merch vm
, ods_stage.lm_layout_theme_xr ltxr
where  (1=1)
and lta.look_layout_theme_assoc_id = xr.look_layout_theme_assoc_id
and ss.source_system_short_name = 'APOCS'
and vm.visual_merch_id(+) = vms.business_key
and vms.vm_id(+) = lta.vm_id
and xr.look_layout_themeid = to_char(ltxr.external_key(+))
and lta.ods_modify_date >= to_date(substr(:v_cdc_load_date, 1, 19), 'yyyy-mm-dd hh24:mi:ss')  -:v_cdc_overlap
) s
on ( s.look_layout_theme_assoc_oid = t.look_layout_theme_assoc_oid )
when matched 
then update set 
--t.source_system_oid = s.source_system_oid
 t.business_key= s.business_key
,t.look_layout_themeid = s.look_layout_themeid
,t.look_no= s.look_no
,t.vm_id = s.vm_id
,t.is_default = s.is_default
,t.visual_merch_oid= s.visual_merch_oid
,t.layout_theme_oid= s.layout_theme_oid
,t.ods_modify_date = sysdate
where decode(t.source_system_oid , s.source_system_oid, 1, 0) = 0
or decode(t.business_key, s.business_key, 1, 0) = 0
or decode(t.look_layout_themeid , s.look_layout_themeid, 1, 0) = 0
or decode(t.look_no, s.look_no, 1, 0) = 0
or decode(t.vm_id , s.vm_id, 1, 0) = 0
or decode(t.is_default , s.is_default, 1, 0) = 0
or decode(t.visual_merch_oid, s.visual_merch_oid, 1, 0) = 0
or decode(t.layout_theme_oid, s.layout_theme_oid, 1, 0) = 0
when not matched
then insert
(t.look_layout_theme_assoc_oid
,t.source_system_oid
,t.ods_create_date
,t.ods_modify_date
,t.business_key
,t.look_layout_themeid
,t.look_no
,t.vm_id
,t.is_default
,t.visual_merch_oid
,t.layout_theme_oid
)
values
(s.look_layout_theme_assoc_oid
,s.source_system_oid
,sysdate
,sysdate
,s.business_key
,s.look_layout_themeid
,s.look_no
,s.vm_id
,s.is_default
,s.visual_merch_oid
,s.layout_theme_oid
)

&& /*-----------------------------------------------*/
/* TASK No. 10 */
/* merge into ods_own.look_layout_theme_assoc t */



merge into ods_own.look_layout_theme_assoc t
USING (
select
xr.look_layout_theme_assoc_oid
,vm.visual_merch_oid
from ods_stage.apocs_ll_theme_assoc_xr xr
, ods_stage.apocs_visual_merchandise_stg vms
, ods_own.visual_merch vm
where  (1=1)
and xr.vm_id = vms.vm_id
and vms.business_key = vm.visual_merch_id
and vm.ods_modify_date >= to_date(substr(:v_cdc_load_date, 1, 19), 'yyyy-mm-dd hh24:mi:ss')  -:v_cdc_overlap
) s
on ( s.look_layout_theme_assoc_oid = t.look_layout_theme_assoc_oid )
when matched
then update set
t.visual_merch_oid = s.visual_merch_oid
,t.ods_modify_date = sysdate
where t.visual_merch_oid is null

&& /*-----------------------------------------------*/
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

&& /*-----------------------------------------------*/
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
'LOAD_APOCS_LOOK_LAYOUT_THEME_ASSOC_PKG',
'003',
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
,'LOAD_APOCS_LOOK_LAYOUT_THEME_ASSOC_PKG'
,'003'
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