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

-- drop table rax_app_user.layout

-- &


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Create staging table */

-- CREATE TABLE rax_app_user.layout
-- (
-- LAYOUT_ID NUMBER
-- ,AUDIT_CREATE_DATE DATE
-- ,AUDIT_CREATED_BY VARCHAR2(255)
-- ,AUDIT_MODIFIED_BY VARCHAR2(255)
-- ,AUDIT_MODIFY_DATE DATE
-- ,CONTENT_AUTHOR	VARCHAR2(255)
-- ,CONTENT_DATE_CREATED DATE
-- ,DESCRIPTION	VARCHAR2(255)
-- ,EXTERNAL_KEY NUMBER
-- ,LAYOUT_FILE_PATH_NAME VARCHAR2(512)
-- ,LAYOUT_XML_CONTENT	CLOB
-- ,NAME	VARCHAR2(255)
-- ,PROVIDER_ID	VARCHAR2(255)
-- ,REQUIREMENT_FILE_NAME	VARCHAR2(255)
-- ,SCHEMA_VERSION	VARCHAR2(100)
-- ,STATUS_TYPE	VARCHAR2(255)
-- ,VOCABULARY_TYPE	VARCHAR2(255)
-- ,LAYOUT_THEME_ID NUMBER
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Load Staging table */

/* SOURCE CODE */
-- select
-- LAYOUT_ID 
-- ,AUDIT_CREATE_DATE
-- ,AUDIT_CREATED_BY 
-- ,AUDIT_MODIFIED_BY 
-- ,AUDIT_MODIFY_DATE 
-- ,CONTENT_AUTHOR	
-- ,CONTENT_DATE_CREATED 
-- ,DESCRIPTION
-- ,EXTERNAL_KEY 
-- ,LAYOUT_FILE_PATH_NAME
-- ,LAYOUT_XML_CONTENT
-- ,NAME
-- ,PROVIDER_ID
-- ,REQUIREMENT_FILE_NAME
-- ,SCHEMA_VERSION
-- ,STATUS_TYPE
-- ,VOCABULARY_TYPE
-- ,LAYOUT_THEME_ID
-- FROM LM_OWN.LAYOUT
-- WHERE AUDIT_MODIFY_DATE >= to_date(substr(:v_cdc_load_date, 1, 19), 'yyyy-mm-dd hh24:mi:ss')  - 1

-- &

-- /* TARGET CODE */
-- insert into rax_app_user.layout
-- (
-- LAYOUT_ID 
-- ,AUDIT_CREATE_DATE
-- ,AUDIT_CREATED_BY 
-- ,AUDIT_MODIFIED_BY 
-- ,AUDIT_MODIFY_DATE 
-- ,CONTENT_AUTHOR	
-- ,CONTENT_DATE_CREATED 
-- ,DESCRIPTION
-- ,EXTERNAL_KEY 
-- ,LAYOUT_FILE_PATH_NAME
-- ,LAYOUT_XML_CONTENT
-- ,NAME
-- ,PROVIDER_ID
-- ,REQUIREMENT_FILE_NAME
-- ,SCHEMA_VERSION
-- ,STATUS_TYPE
-- ,VOCABULARY_TYPE
-- ,LAYOUT_THEME_ID
-- )
-- values 
-- (
-- :LAYOUT_ID 
-- ,:AUDIT_CREATE_DATE
-- ,:AUDIT_CREATED_BY 
-- ,:AUDIT_MODIFIED_BY 
-- ,:AUDIT_MODIFY_DATE 
-- ,:CONTENT_AUTHOR	
-- ,:CONTENT_DATE_CREATED 
-- ,:DESCRIPTION
-- ,:EXTERNAL_KEY 
-- ,:LAYOUT_FILE_PATH_NAME
-- ,:LAYOUT_XML_CONTENT
-- ,:NAME
-- ,:PROVIDER_ID
-- ,:REQUIREMENT_FILE_NAME
-- ,:SCHEMA_VERSION
-- ,:STATUS_TYPE
-- ,:VOCABULARY_TYPE
-- ,:LAYOUT_THEME_ID

-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Merge into STG table */

MERGE INTO ODS_STAGE.LM_LAYOUT_STG t USING
(
SELECT 
LAYOUT_ID 
,AUDIT_CREATE_DATE
,AUDIT_CREATED_BY 
,AUDIT_MODIFIED_BY 
,AUDIT_MODIFY_DATE 
,CONTENT_AUTHOR	
,CONTENT_DATE_CREATED 
,DESCRIPTION
,EXTERNAL_KEY 
,LAYOUT_FILE_PATH_NAME
-- ,LAYOUT_XML_CONTENT
,NAME
,PROVIDER_ID
,REQUIREMENT_FILE_NAME
,SCHEMA_VERSION
,STATUS_TYPE
,VOCABULARY_TYPE
,LAYOUT_THEME_ID  
FROM 
rax_app_user.layout
) s
ON (t.LAYOUT_ID = s.LAYOUT_ID)
WHEN NOT MATCHED
THEN INSERT
(
LAYOUT_ID
,AUDIT_CREATE_DATE
,AUDIT_CREATED_BY
,AUDIT_MODIFIED_BY
,AUDIT_MODIFY_DATE
,CONTENT_AUTHOR
,CONTENT_DATE_CREATED
,DESCRIPTION
,EXTERNAL_KEY
,LAYOUT_FILE_PATH_NAME
-- ,LAYOUT_XML_CONTENT
,NAME
,PROVIDER_ID
,REQUIREMENT_FILE_NAME
,SCHEMA_VERSION
,STATUS_TYPE
,VOCABULARY_TYPE
,LAYOUT_THEME_ID
,ODS_CREATE_DATE
,ODS_MODIFY_DATE
)
VALUES
(
s.LAYOUT_ID
,s.AUDIT_CREATE_DATE
,s.AUDIT_CREATED_BY
,s.AUDIT_MODIFIED_BY
,s.AUDIT_MODIFY_DATE
,s.CONTENT_AUTHOR
,s.CONTENT_DATE_CREATED
,s.DESCRIPTION
,s.EXTERNAL_KEY
,s.LAYOUT_FILE_PATH_NAME
-- ,s.LAYOUT_XML_CONTENT
,s.NAME
,s.PROVIDER_ID
,s.REQUIREMENT_FILE_NAME
,s.SCHEMA_VERSION
,s.STATUS_TYPE
,s.VOCABULARY_TYPE
,s.LAYOUT_THEME_ID 
,sysdate
,sysdate
)
WHEN MATCHED
THEN UPDATE SET
t.audit_create_date = s.AUDIT_CREATE_DATE
,t.audit_created_by = s.AUDIT_CREATED_BY
,t.audit_modified_by   =  s.AUDIT_MODIFIED_BY
,t.audit_modify_date  =  s.AUDIT_MODIFY_DATE
,t.content_author  =    s.CONTENT_AUTHOR 
,t.content_date_created   =  s.CONTENT_DATE_CREATED 
,t.description =  s.DESCRIPTION
,t.external_key  =   s.EXTERNAL_KEY
,t.layout_file_path_name    = s.LAYOUT_FILE_PATH_NAME
-- ,t.layout_xml_content  =  s.LAYOUT_XML_CONTENT
,t.name =  s.NAME
,t.provider_id  =   s.PROVIDER_ID
,t.requirement_file_name    = s.REQUIREMENT_FILE_NAME
,t.schema_version    = s.SCHEMA_VERSION
,t.status_type    = s.STATUS_TYPE
,t.vocabulary_type    = s.VOCABULARY_TYPE
,t.layout_theme_id    = s.LAYOUT_THEME_ID
,t.ods_modify_date = sysdate
where decode(t.audit_create_date , s.AUDIT_CREATE_DATE, 1, 0) = 0
or decode(t.audit_created_by , s.AUDIT_CREATED_BY, 1, 0) = 0
or decode(t.audit_modified_by , s.AUDIT_MODIFIED_BY, 1, 0) = 0
or decode(t.content_author , s.CONTENT_AUTHOR, 1, 0) = 0     
or decode(t.content_date_created , s.CONTENT_DATE_CREATED , 1, 0) = 0      
or decode(t.description , s.DESCRIPTION , 1, 0) = 0   
or decode(t.external_key , s.EXTERNAL_KEY , 1, 0) = 0      
or decode(t.layout_file_path_name , s.LAYOUT_FILE_PATH_NAME , 1, 0) = 0    
--or decode(t.layout_xml_content , s.LAYOUT_XML_CONTENT , 1, 0) = 0 
or decode(t.name , s.NAME , 1, 0) = 0
or decode(t.provider_id , s.PROVIDER_ID , 1, 0) = 0  
or decode(t.requirement_file_name , s.REQUIREMENT_FILE_NAME , 1, 0) = 0 
or decode(t.schema_version , s.SCHEMA_VERSION , 1, 0) = 0 
or decode(t.status_type , s.STATUS_TYPE , 1, 0) = 0 
or decode(t.vocabulary_type , s.VOCABULARY_TYPE , 1, 0) = 0  
or decode(t.layout_theme_id , s.LAYOUT_THEME_ID , 1, 0) = 0  

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* merge into  ods_stage.lm_layout_xr */


merge into ods_stage.lm_layout_xr d
using (
select * from
    (  select
        xr.layout_oid,  
		stg.layout_id, 
		stg.layout_theme_id,
		stg.external_key,
		sysdate as ods_create_date,
		sysdate as ods_modify_date
      from
         ods_stage.lm_layout_stg stg
        ,ods_stage.lm_layout_xr xr
       where (1=1)
        and stg.ods_modify_date >= to_date(substr(:v_cdc_load_date, 1, 19), 'yyyy-mm-dd hh24:mi:ss')  -:v_cdc_overlap
        and stg.layout_id=xr.layout_id(+)
     ) s
where not exists
	( select 1 from ods_stage.lm_layout_xr t 
	where  t.layout_id = s.layout_id
                                   and  ((t.layout_oid = s.layout_oid) or (t.layout_oid is null and s.layout_oid  is null))
		                           and((t.layout_id = s.layout_id) or (t.layout_id is null and s.layout_id is null))
								 and((t.layout_theme_id = s.layout_theme_id) or (t.layout_theme_id is null and s.layout_theme_id is null)) 
								 and((t.external_key = s.external_key) or (t.external_key is null and s.external_key is null))
	)
) s
on
  (s.layout_id  =d.layout_id)
when matched
then update
set
  --d.layout_oid = s.layout_oid,
    d.layout_theme_id = s.layout_theme_id,
	 d.external_key = s.external_key,
       d.ods_modify_date = s.ods_modify_date
when not matched then
insert (
  layout_oid,
  layout_id , 
  layout_theme_id,
  external_key,
 ods_create_date,
  ods_modify_date)
values (
  ods_stage.layout_oid_seq.nextval,
  s.layout_id,
  s.layout_theme_id,
 s.external_key,
  s.ods_create_date,
  s.ods_modify_date
  )

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* merge into  ods_own.layout t  */

merge into ods_own.layout t 
using (
select 
xr.layout_oid
,ss.source_system_oid
,lta.AUDIT_CREATE_DATE
,lta.AUDIT_CREATED_BY
,lta.AUDIT_MODIFIED_BY
,lta.AUDIT_MODIFY_DATE
,lta.CONTENT_AUTHOR
,lta.CONTENT_DATE_CREATED
,lta.DESCRIPTION
,lta.external_key
,lta.LAYOUT_FILE_PATH_NAME
,lta.LAYOUT_XML_CONTENT
,lta.provider_id
,lta.name
,lta.REQUIREMENT_FILE_NAME
,lta.SCHEMA_VERSION
,lta.STATUS_TYPE
,lta.VOCABULARY_TYPE
,lta.LAYOUT_THEME_ID
,lt.layout_theme_oid
,to_char(substr(regexp_substr(lta.layout_xml_content, '<pose-preference>\w+'),18,999)) as pose_preference
from ods_stage.LM_LAYOUT_STG lta
, ods_stage.LM_LAYOUT_XR xr
, ods_own.source_system ss
,ods_own.LAYOUT_THEME lt
where  (1=1)
and lta.LAYOUT_ID = xr.LAYOUT_ID (+)
and xr.LAYOUT_THEME_ID=lt.LAYOUT_THEME_ID
and ss.source_system_short_name = 'LIMS'
and lta.ods_modify_date >= to_date(substr(:v_cdc_load_date, 1, 19), 'yyyy-mm-dd hh24:mi:ss')  -:v_cdc_overlap
) s
on ( s.LAYOUT_OID = t.LAYOUT_OID )
when matched then update set 
--t.source_system_oid = s.source_system_oid
t.AUDIT_CREATE_DATE= s.AUDIT_CREATE_DATE
,t.AUDIT_CREATED_BY= s.AUDIT_CREATED_BY
,t.AUDIT_MODIFIED_BY= s.AUDIT_MODIFIED_BY
,t.AUDIT_MODIFY_DATE= s.AUDIT_MODIFY_DATE
,t.CONTENT_AUTHOR= s.CONTENT_AUTHOR
,t.CONTENT_DATE_CREATED= s.CONTENT_DATE_CREATED
,t.DESCRIPTION= s.DESCRIPTION
,t.external_key= s.external_key
,t.LAYOUT_FILE_PATH_NAME= s.LAYOUT_FILE_PATH_NAME
,t.LAYOUT_XML_CONTENT= s.LAYOUT_XML_CONTENT
,t.provider_id= s.provider_id
,t.name= s.name
,t.REQUIREMENT_FILE_NAME = s.REQUIREMENT_FILE_NAME
,t.SCHEMA_VERSION = s.SCHEMA_VERSION
,t.STATUS_TYPE = s.STATUS_TYPE
,t.VOCABULARY_TYPE = s.VOCABULARY_TYPE
,t.layout_theme_oid=s.layout_theme_oid
,t.ods_modify_date = sysdate
,t.pose_preference = s.pose_preference
where decode(t.source_system_oid , s.source_system_oid, 1, 0) = 0
or decode(t.AUDIT_CREATE_DATE, s.AUDIT_CREATE_DATE, 1, 0) = 0
or decode(t.AUDIT_CREATED_BY, s.AUDIT_CREATED_BY, 1, 0) = 0
or decode(t.AUDIT_MODIFIED_BY, s.AUDIT_MODIFIED_BY, 1, 0) = 0
or decode(t.AUDIT_MODIFY_DATE, s.AUDIT_MODIFY_DATE, 1, 0) = 0
or decode(t.CONTENT_AUTHOR, s.CONTENT_AUTHOR, 1, 0) = 0
or decode(t.CONTENT_DATE_CREATED, s.CONTENT_DATE_CREATED, 1, 0) = 0
or decode(t.DESCRIPTION, s.DESCRIPTION, 1, 0) = 0
or decode(t.external_key, s.external_key, 1, 0) = 0
or decode(t.LAYOUT_FILE_PATH_NAME, s.LAYOUT_FILE_PATH_NAME, 1, 0) = 0
--or decode(t.LAYOUT_XML_CONTENT, s.LAYOUT_XML_CONTENT, 1, 0) = 0
or decode(t.provider_id, s.provider_id, 1, 0) = 0
or decode(t.name , s.name, 1, 0) = 0
or decode(t.REQUIREMENT_FILE_NAME, s.REQUIREMENT_FILE_NAME, 1, 0) = 0
or decode(t.SCHEMA_VERSION, s.SCHEMA_VERSION, 1, 0) = 0
or decode(t.STATUS_TYPE, s.STATUS_TYPE, 1, 0) = 0
or decode(t.VOCABULARY_TYPE, s.VOCABULARY_TYPE, 1, 0) = 0
or decode(t.layout_theme_oid, s.layout_theme_oid, 1, 0) = 0
or decode(t.pose_preference , s.pose_preference, 1, 0) = 0
when not matched
then insert
(
t.layout_oid
,t.layout_theme_oid
,t.source_system_oid
,t.ods_create_date
,t.ods_modify_date
,t.AUDIT_CREATE_DATE
,t.AUDIT_CREATED_BY
,t.AUDIT_MODIFIED_BY
,t.AUDIT_MODIFY_DATE
,t.CONTENT_AUTHOR
,t.CONTENT_DATE_CREATED
,t.DESCRIPTION
,t.LAYOUT_FILE_PATH_NAME
,t.LAYOUT_XML_CONTENT
,t.REQUIREMENT_FILE_NAME
,t.SCHEMA_VERSION
,t.STATUS_TYPE
,t.VOCABULARY_TYPE
,t.LAYOUT_THEME_ID
,t.external_key
,t.provider_id
,t.name
,t.pose_preference
)
values
(
s.layout_oid
,s.layout_theme_oid
,s.source_system_oid
,sysdate
,sysdate
,s.AUDIT_CREATE_DATE
,s.AUDIT_CREATED_BY
,s.AUDIT_MODIFIED_BY
,s.AUDIT_MODIFY_DATE
,s.CONTENT_AUTHOR
,s.CONTENT_DATE_CREATED
,s.DESCRIPTION
,s.LAYOUT_FILE_PATH_NAME
,s.LAYOUT_XML_CONTENT
,s.REQUIREMENT_FILE_NAME
,s.SCHEMA_VERSION
,s.STATUS_TYPE
,s.VOCABULARY_TYPE
,s.LAYOUT_THEME_ID
,s.external_key
,s.provider_id
,s.name
,s.pose_preference
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
,'LOAD_LIMS_LAYOUT_PKG'
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
'LOAD_LIMS_LAYOUT_PKG',
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
