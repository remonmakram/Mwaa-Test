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
/* Drop Staging Table */

-- drop table rax_app_user.layout_theme

-- &


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Create staging table */

-- CREATE TABLE rax_app_user.layout_theme
-- (
-- LAYOUT_THEME_ID NUMBER,
-- AUDIT_CREATE_DATE DATE,
-- AUDIT_CREATED_BY VARCHAR2(255),
-- AUDIT_MODIFIED_BY VARCHAR2(255),
-- AUDIT_MODIFY_DATE DATE,
-- EXTERNAL_KEY NUMBER,
-- NAME VARCHAR2(255)
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Load Staging table */

/* SOURCE CODE */
-- select
-- LAYOUT_THEME_ID
-- ,AUDIT_CREATE_DATE 
-- ,AUDIT_CREATED_BY
-- ,AUDIT_MODIFIED_BY
-- ,AUDIT_MODIFY_DATE 
-- ,EXTERNAL_KEY
-- ,NAME
-- FROM LM_OWN.LAYOUT_THEME
-- WHERE AUDIT_MODIFY_DATE >= to_date(substr(:v_cdc_load_date, 1, 19), 'yyyy-mm-dd hh24:mi:ss')  - 1

-- &

-- /* TARGET CODE */
-- insert into rax_app_user.layout_theme
-- (
-- LAYOUT_THEME_ID
-- ,AUDIT_CREATE_DATE 
-- ,AUDIT_CREATED_BY
-- ,AUDIT_MODIFIED_BY
-- ,AUDIT_MODIFY_DATE 
-- ,EXTERNAL_KEY
-- ,NAME
-- )
-- values 
-- (
-- :LAYOUT_THEME_ID
-- ,:AUDIT_CREATE_DATE 
-- ,:AUDIT_CREATED_BY
-- ,:AUDIT_MODIFIED_BY
-- ,:AUDIT_MODIFY_DATE 
-- ,:EXTERNAL_KEY
-- ,:NAME
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Merge into STG table */

MERGE INTO ODS_STAGE.LM_LAYOUT_THEME_STG t USING
(
SELECT 
LAYOUT_THEME_ID
,AUDIT_CREATE_DATE 
,AUDIT_CREATED_BY
,AUDIT_MODIFIED_BY
,AUDIT_MODIFY_DATE 
,EXTERNAL_KEY
,NAME
FROM 
rax_app_user.layout_theme
) s
ON (t.LAYOUT_THEME_ID = s.LAYOUT_THEME_ID)
WHEN NOT MATCHED
THEN INSERT
(
LAYOUT_THEME_ID
,AUDIT_CREATE_DATE 
,AUDIT_CREATED_BY
,AUDIT_MODIFIED_BY
,AUDIT_MODIFY_DATE 
,EXTERNAL_KEY
,NAME
,ODS_CREATE_DATE
,ODS_MODIFY_DATE
)
VALUES
(
s.LAYOUT_THEME_ID
,s.AUDIT_CREATE_DATE 
,s.AUDIT_CREATED_BY
,s.AUDIT_MODIFIED_BY
,s.AUDIT_MODIFY_DATE 
,s.EXTERNAL_KEY
,s.NAME
,sysdate
,sysdate
)
WHEN MATCHED
THEN UPDATE SET
t.audit_create_date = s.AUDIT_CREATE_DATE
,t.audit_created_by = s.AUDIT_CREATED_BY
,t.audit_modified_by   =  s.AUDIT_MODIFIED_BY
,t.audit_modify_date  =  s.AUDIT_MODIFY_DATE
,t.external_key  =   s.EXTERNAL_KEY
,t.name =  s.NAME
,t.ods_modify_date = sysdate
where decode(t.audit_create_date , s.AUDIT_CREATE_DATE, 1, 0) = 0
or decode(t.audit_created_by , s.AUDIT_CREATED_BY, 1, 0) = 0
or decode(t.audit_modified_by , s.AUDIT_MODIFIED_BY, 1, 0) = 0  
or decode(t.external_key , s.EXTERNAL_KEY , 1, 0) = 0      
or decode(t.name , s.NAME , 1, 0) = 0


&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* merge into  ods_stage.lm_layout_theme_xr */


merge into ods_stage.lm_layout_theme_xr d
using (
select * from
    (  select
        xr.layout_theme_oid, 
		stg.layout_theme_id, 
		stg.external_key,
		sysdate as ods_create_date,
		sysdate as ods_modify_date
      from
         ods_stage.lm_layout_theme_stg stg
        ,ods_stage.lm_layout_theme_xr xr
       where (1=1)
        and stg.ods_modify_date >= to_date(substr(:v_cdc_load_date, 1, 19), 'yyyy-mm-dd hh24:mi:ss')  -:v_cdc_overlap
        and stg.layout_theme_id=xr.layout_theme_id(+)
     ) s
where not exists
	( select 1 from ods_stage.lm_layout_theme_xr t 
	where  t.layout_theme_id = s.layout_theme_id
                                   and  ((t.layout_theme_oid = s.layout_theme_oid) or (t.layout_theme_oid is null and s.layout_theme_oid  is null))
		                           and((t.layout_theme_id = s.layout_theme_id) or (t.layout_theme_id is null and s.layout_theme_id is null))
								 and((t.external_key = s.external_key) or (t.external_key is null and s.external_key is null)) 
	)
) s
on
  (s.layout_theme_id  =d.layout_theme_id)
when matched
then update
set
  --d.layout_theme_oid = s.layout_theme_oid,
    d.external_key = s.external_key,
       d.ods_modify_date = s.ods_modify_date
when not matched then
insert (
  layout_theme_oid,
  layout_theme_id , 
  external_key,
 ods_create_date,
  ods_modify_date)
values (
  ods_stage.layout_theme_oid_seq.nextval,
  s.layout_theme_id,
  s.external_key,
  s.ods_create_date,
  s.ods_modify_date
  )

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* merge into  ods_own.layout_theme t  */

merge into ods_own.layout_theme t 
using (
select 
xr.layout_theme_oid
,ss.source_system_oid
,lta.AUDIT_CREATE_DATE
,lta.AUDIT_CREATED_BY
,lta.AUDIT_MODIFIED_BY
,lta.AUDIT_MODIFY_DATE
,lta.external_key
,lta.name
,lta.layout_theme_id
from ods_stage.lm_layout_theme_stg lta
, ods_stage.lm_layout_theme_xr xr
, ods_own.source_system ss
where  (1=1)
and lta.layout_theme_id = xr.layout_theme_id(+)
and ss.source_system_short_name = 'LIMS'
and lta.ods_modify_date >= to_date(substr(:v_cdc_load_date, 1, 19), 'yyyy-mm-dd hh24:mi:ss')  -:v_cdc_overlap
) s
on ( s.layout_theme_oid = t.layout_theme_oid )
when matched 
then update set 
 t.AUDIT_CREATE_DATE= s.AUDIT_CREATE_DATE
,t.AUDIT_CREATED_BY= s.AUDIT_CREATED_BY
,t.AUDIT_MODIFIED_BY= s.AUDIT_MODIFIED_BY
,t.AUDIT_MODIFY_DATE= s.AUDIT_MODIFY_DATE
,t.external_key= s.external_key
,t.layout_theme_id= s.layout_theme_id
,t.name = s.name
,t.ods_modify_date = sysdate
where decode(t.source_system_oid , s.source_system_oid, 1, 0) = 0
or decode(t.AUDIT_CREATE_DATE, s.AUDIT_CREATE_DATE, 1, 0) = 0
or decode(t.AUDIT_CREATED_BY, s.AUDIT_CREATED_BY, 1, 0) = 0
or decode(t.AUDIT_MODIFIED_BY, s.AUDIT_MODIFIED_BY, 1, 0) = 0
or decode(t.AUDIT_MODIFY_DATE, s.AUDIT_MODIFY_DATE, 1, 0) = 0
or decode(t.external_key, s.external_key, 1, 0) = 0
or decode(t.layout_theme_id, s.layout_theme_id, 1, 0) = 0
or decode(t.name , s.name, 1, 0) = 0
when not matched
then insert
(t.layout_theme_oid
,t.layout_theme_id
,t.source_system_oid
,t.ods_create_date
,t.ods_modify_date
,t.AUDIT_CREATE_DATE
,t.AUDIT_CREATED_BY
,t.AUDIT_MODIFIED_BY
,t.AUDIT_MODIFY_DATE
,t.external_key
,t.name
)
values
(s.layout_theme_oid
,s.layout_theme_id
,s.source_system_oid
,sysdate
,sysdate
,s.AUDIT_CREATE_DATE
,s.AUDIT_CREATED_BY
,s.AUDIT_MODIFIED_BY
,s.AUDIT_MODIFY_DATE
,s.external_key
,s.name
)

&


/*-----------------------------------------------*/
/* TASK No. 10 */
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
/* TASK No. 11 */
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
,'LOAD_LIMS_LAYOUT_THEME_PKG'
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
'LOAD_LIMS_LAYOUT_THEME_PKG',
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


&


/*-----------------------------------------------*/
