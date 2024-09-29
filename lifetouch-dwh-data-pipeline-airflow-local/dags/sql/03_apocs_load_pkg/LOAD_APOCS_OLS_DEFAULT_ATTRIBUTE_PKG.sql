

BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0APOCS_OLS_DEFATT_STG',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;

&& /*-----------------------------------------------*/
/* TASK No. 9 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_APOCS_OLS_DEFATT_STG */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_APOCS_OLS_DEFATT_STG';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&& /*-----------------------------------------------*/
/* TASK No. 10 */
/* Create flow table I$ */



create table RAX_APP_USER.I$_APOCS_OLS_DEFATT_STG
(
	OLS_DEFAULT_ATTRIBUTE_ID	NUMBER NULL,
	NAME	VARCHAR2(255) NULL,
	VALUE	VARCHAR2(255) NULL,
	OLS_DEFAULT_ID	NUMBER NULL,
	AUDIT_CREATE_DATE	DATE NULL,
	AUDIT_CREATED_BY	VARCHAR2(255) NULL,
	AUDIT_MODIFIED_BY	VARCHAR2(255) NULL,
	AUDIT_MODIFY_DATE	DATE NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL
	,IND_UPDATE		char(1)
)
 

&& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Insert flow into I$ table */
/*+ APPEND */



insert   into RAX_APP_USER.I$_APOCS_OLS_DEFATT_STG
	(
	OLS_DEFAULT_ATTRIBUTE_ID,
	NAME,
	VALUE,
	OLS_DEFAULT_ID,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFIED_BY,
	AUDIT_MODIFY_DATE
	,IND_UPDATE
	)


select 	 
	
	C1_OLS_DEFAULT_ATTRIBUTE_ID,
	C2_NAME,
	C3_VALUE,
	C4_OLS_DEFAULT_ID,
	C5_AUDIT_CREATE_DATE,
	C6_AUDIT_CREATED_BY,
	C7_AUDIT_MODIFIED_BY,
	C8_AUDIT_MODIFY_DATE,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0APOCS_OLS_DEFATT_STG
where	(1=1)






minus
select
	OLS_DEFAULT_ATTRIBUTE_ID,
	NAME,
	VALUE,
	OLS_DEFAULT_ID,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFIED_BY,
	AUDIT_MODIFY_DATE
	,'I'	IND_UPDATE
from	ODS_STAGE.APOCS_OLS_DEFATT_STG

&& /*-----------------------------------------------*/
/* TASK No. 12 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_APOCS_OLS_DEFATT_STG',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

&& /*-----------------------------------------------*/
/* TASK No. 13 */
/* Create Index on flow table */



create index	RAX_APP_USER.I$_APOCS_OLS_DEFATT_STG_IDX
on		RAX_APP_USER.I$_APOCS_OLS_DEFATT_STG (OLS_DEFAULT_ATTRIBUTE_ID)
 

&& /*-----------------------------------------------*/
/* TASK No. 14 */
/* create check table */




BEGIN  
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.SNP_CHECK_TAB
(
	CATALOG_NAME	VARCHAR2(100 CHAR) NULL ,
	SCHEMA_NAME	VARCHAR2(100 CHAR) NULL ,
	RESOURCE_NAME	VARCHAR2(100 CHAR) NULL,
	FULL_RES_NAME	VARCHAR2(100 CHAR) NULL,
	ERR_TYPE		VARCHAR2(1 CHAR) NULL,
	ERR_MESS		VARCHAR2(250 CHAR) NULL ,
	CHECK_DATE	DATE NULL,
	ORIGIN		VARCHAR2(100 CHAR) NULL,
	CONS_NAME	VARCHAR2(35 CHAR) NULL,
	CONS_TYPE		VARCHAR2(2 CHAR) NULL,
	ERR_COUNT		NUMBER(10) NULL
)';  
EXCEPTION  
   WHEN OTHERS THEN  
      NULL;
END;

&& /*-----------------------------------------------*/
/* TASK No. 15 */
/* delete previous check sum */



delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS_STAGE'
and	ORIGIN 		= '(2323001)ODS_Project.LOAD_APOCS_OLS_DEFATT_STG_INT'
and	ERR_TYPE 		= 'F'

&& /*-----------------------------------------------*/
/* TASK No. 16 */
/* create error table */


BEGIN  
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.E$_APOCS_OLS_DEFATT_STG
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	OLS_DEFAULT_ATTRIBUTE_ID	NUMBER NULL,
	NAME	VARCHAR2(255) NULL,
	VALUE	VARCHAR2(255) NULL,
	OLS_DEFAULT_ID	NUMBER NULL,
	AUDIT_CREATE_DATE	DATE NULL,
	AUDIT_CREATED_BY	VARCHAR2(255) NULL,
	AUDIT_MODIFIED_BY	VARCHAR2(255) NULL,
	AUDIT_MODIFY_DATE	DATE NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
	ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
	ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
	ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
	ODI_SESS_NO		VARCHAR2(19 CHAR)
)';  
EXCEPTION  
   WHEN OTHERS THEN  
      NULL;
END;

&& /*-----------------------------------------------*/
/* TASK No. 17 */
/* delete previous errors */



delete from 	RAX_APP_USER.E$_APOCS_OLS_DEFATT_STG
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(2323001)ODS_Project.LOAD_APOCS_OLS_DEFATT_STG_INT')

&& /*-----------------------------------------------*/
/* TASK No. 18 */
/* Create index on AK */
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */




BEGIN  
   EXECUTE IMMEDIATE 'create index 	APOCS_OLS_DEFATT_STG_PK_flow
on	RAX_APP_USER.I$_APOCS_OLS_DEFATT_STG 
	(OLS_DEFAULT_ATTRIBUTE_ID)';  
EXCEPTION  
   WHEN OTHERS THEN  
      NULL;
END;

&& /*-----------------------------------------------*/
/* TASK No. 19 */
/* insert AK errors */



insert into RAX_APP_USER.E$_APOCS_OLS_DEFATT_STG
(
	ODI_PK,
	ODI_SESS_NO,
	ODI_ROW_ID,
	ODI_ERR_TYPE,
	ODI_ERR_MESS,
	ODI_ORIGIN,
	ODI_CHECK_DATE,
	ODI_CONS_NAME,
	ODI_CONS_TYPE,
	OLS_DEFAULT_ATTRIBUTE_ID,
	NAME,
	VALUE,
	OLS_DEFAULT_ID,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFIED_BY,
	AUDIT_MODIFY_DATE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15063: The alternate key APOCS_OLS_DEFATT_STG_PK is not unique.',
	'(2323001)ODS_Project.LOAD_APOCS_OLS_DEFATT_STG_INT',
	sysdate,
	'APOCS_OLS_DEFATT_STG_PK',
	'AK',	
	APOCS_OLS_DEFATT_STG.OLS_DEFAULT_ATTRIBUTE_ID,
	APOCS_OLS_DEFATT_STG.NAME,
	APOCS_OLS_DEFATT_STG.VALUE,
	APOCS_OLS_DEFATT_STG.OLS_DEFAULT_ID,
	APOCS_OLS_DEFATT_STG.AUDIT_CREATE_DATE,
	APOCS_OLS_DEFATT_STG.AUDIT_CREATED_BY,
	APOCS_OLS_DEFATT_STG.AUDIT_MODIFIED_BY,
	APOCS_OLS_DEFATT_STG.AUDIT_MODIFY_DATE,
	APOCS_OLS_DEFATT_STG.ODS_CREATE_DATE,
	APOCS_OLS_DEFATT_STG.ODS_MODIFY_DATE
from	RAX_APP_USER.I$_APOCS_OLS_DEFATT_STG   APOCS_OLS_DEFATT_STG
where	exists  (
		select	SUB.OLS_DEFAULT_ATTRIBUTE_ID
		from 	RAX_APP_USER.I$_APOCS_OLS_DEFATT_STG SUB
		where 	SUB.OLS_DEFAULT_ATTRIBUTE_ID=APOCS_OLS_DEFATT_STG.OLS_DEFAULT_ATTRIBUTE_ID
		group by 	SUB.OLS_DEFAULT_ATTRIBUTE_ID
		having 	count(1) > 1
		)

&& /*-----------------------------------------------*/
/* TASK No. 20 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_APOCS_OLS_DEFATT_STG
(
	ODI_PK,
	ODI_SESS_NO,
	ODI_ROW_ID,
	ODI_ERR_TYPE,
	ODI_ERR_MESS,
	ODI_CHECK_DATE,
	ODI_ORIGIN,
	ODI_CONS_NAME,
	ODI_CONS_TYPE,
	OLS_DEFAULT_ATTRIBUTE_ID,
	NAME,
	VALUE,
	OLS_DEFAULT_ID,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFIED_BY,
	AUDIT_MODIFY_DATE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column OLS_DEFAULT_ATTRIBUTE_ID cannot be null.',
	sysdate,
	'(2323001)ODS_Project.LOAD_APOCS_OLS_DEFATT_STG_INT',
	'OLS_DEFAULT_ATTRIBUTE_ID',
	'NN',	
	OLS_DEFAULT_ATTRIBUTE_ID,
	NAME,
	VALUE,
	OLS_DEFAULT_ID,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFIED_BY,
	AUDIT_MODIFY_DATE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_APOCS_OLS_DEFATT_STG
where	OLS_DEFAULT_ATTRIBUTE_ID is null

&& /*-----------------------------------------------*/
/* TASK No. 21 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_APOCS_OLS_DEFATT_STG
(
	ODI_PK,
	ODI_SESS_NO,
	ODI_ROW_ID,
	ODI_ERR_TYPE,
	ODI_ERR_MESS,
	ODI_CHECK_DATE,
	ODI_ORIGIN,
	ODI_CONS_NAME,
	ODI_CONS_TYPE,
	OLS_DEFAULT_ATTRIBUTE_ID,
	NAME,
	VALUE,
	OLS_DEFAULT_ID,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFIED_BY,
	AUDIT_MODIFY_DATE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column NAME cannot be null.',
	sysdate,
	'(2323001)ODS_Project.LOAD_APOCS_OLS_DEFATT_STG_INT',
	'NAME',
	'NN',	
	OLS_DEFAULT_ATTRIBUTE_ID,
	NAME,
	VALUE,
	OLS_DEFAULT_ID,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFIED_BY,
	AUDIT_MODIFY_DATE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_APOCS_OLS_DEFATT_STG
where	NAME is null

&& /*-----------------------------------------------*/
/* TASK No. 22 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_APOCS_OLS_DEFATT_STG
(
	ODI_PK,
	ODI_SESS_NO,
	ODI_ROW_ID,
	ODI_ERR_TYPE,
	ODI_ERR_MESS,
	ODI_CHECK_DATE,
	ODI_ORIGIN,
	ODI_CONS_NAME,
	ODI_CONS_TYPE,
	OLS_DEFAULT_ATTRIBUTE_ID,
	NAME,
	VALUE,
	OLS_DEFAULT_ID,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFIED_BY,
	AUDIT_MODIFY_DATE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column OLS_DEFAULT_ID cannot be null.',
	sysdate,
	'(2323001)ODS_Project.LOAD_APOCS_OLS_DEFATT_STG_INT',
	'OLS_DEFAULT_ID',
	'NN',	
	OLS_DEFAULT_ATTRIBUTE_ID,
	NAME,
	VALUE,
	OLS_DEFAULT_ID,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFIED_BY,
	AUDIT_MODIFY_DATE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_APOCS_OLS_DEFATT_STG
where	OLS_DEFAULT_ID is null

&& /*-----------------------------------------------*/
/* TASK No. 23 */
/* create index on error table */
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */




BEGIN  
   EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_APOCS_OLS_DEFATT_STG_IDX
on	RAX_APP_USER.E$_APOCS_OLS_DEFATT_STG (ODI_ROW_ID)';  
EXCEPTION  
   WHEN OTHERS THEN  
      NULL;
END;

&& /*-----------------------------------------------*/
/* TASK No. 24 */
/* delete errors from controlled table */



delete from	RAX_APP_USER.I$_APOCS_OLS_DEFATT_STG  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_APOCS_OLS_DEFATT_STG E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)

&& /*-----------------------------------------------*/
/* TASK No. 25 */
/* insert check sum into check table */



insert into RAX_APP_USER.SNP_CHECK_TAB
(
	SCHEMA_NAME,
	RESOURCE_NAME,
	FULL_RES_NAME,
	ERR_TYPE,
	ERR_MESS,
	CHECK_DATE,
	ORIGIN,
	CONS_NAME,
	CONS_TYPE,
	ERR_COUNT
)
select	
	'ODS_STAGE',
	'APOCS_OLS_DEFATT_STG',
	'ODS_STAGE.APOCS_OLS_DEFATT_STG',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_APOCS_OLS_DEFATT_STG E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(2323001)ODS_Project.LOAD_APOCS_OLS_DEFATT_STG_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE

&& /*-----------------------------------------------*/
/* TASK No. 26 */
/* Merge Rows */



merge into	ODS_STAGE.APOCS_OLS_DEFATT_STG T
using	RAX_APP_USER.I$_APOCS_OLS_DEFATT_STG S
on	(
		T.OLS_DEFAULT_ATTRIBUTE_ID=S.OLS_DEFAULT_ATTRIBUTE_ID
	)
when matched
then update set
	T.NAME	= S.NAME,
	T.VALUE	= S.VALUE,
	T.OLS_DEFAULT_ID	= S.OLS_DEFAULT_ID,
	T.AUDIT_CREATE_DATE	= S.AUDIT_CREATE_DATE,
	T.AUDIT_CREATED_BY	= S.AUDIT_CREATED_BY,
	T.AUDIT_MODIFIED_BY	= S.AUDIT_MODIFIED_BY,
	T.AUDIT_MODIFY_DATE	= S.AUDIT_MODIFY_DATE
	,       T.ODS_MODIFY_DATE	= sysdate
when not matched
then insert
	(
	T.OLS_DEFAULT_ATTRIBUTE_ID,
	T.NAME,
	T.VALUE,
	T.OLS_DEFAULT_ID,
	T.AUDIT_CREATE_DATE,
	T.AUDIT_CREATED_BY,
	T.AUDIT_MODIFIED_BY,
	T.AUDIT_MODIFY_DATE
	,        T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.OLS_DEFAULT_ATTRIBUTE_ID,
	S.NAME,
	S.VALUE,
	S.OLS_DEFAULT_ID,
	S.AUDIT_CREATE_DATE,
	S.AUDIT_CREATED_BY,
	S.AUDIT_MODIFIED_BY,
	S.AUDIT_MODIFY_DATE
	,        sysdate,
	sysdate
	)

&& /*-----------------------------------------------*/
/* TASK No. 27 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 28 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_APOCS_OLS_DEFATT_STG */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_APOCS_OLS_DEFATT_STG';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&& /*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0APOCS_OLS_DEFATT_STG purge */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0APOCS_OLS_DEFATT_STG purge';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&& /*-----------------------------------------------*/
/* TASK No. 29 */
/* merge into ods_stage.apocs_ols_defatt_xr */



merge into ods_stage.apocs_ols_defatt_xr d
using (
select * from
    (  select
        xr.ols_default_attribute_oid, stg.ols_default_attribute_id, stg.ols_default_id, sysdate as ods_create_date, sysdate as ods_modify_date
      from
        ods_stage.apocs_ols_defatt_stg stg
        ,ods_stage.apocs_ols_defatt_xr xr
       where (1=1)
        and stg.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
        and stg.ols_default_attribute_id=xr.ols_default_attribute_id(+)
     ) s
where not exists
	( select 1 from ods_stage.apocs_ols_defatt_xr t 
	where  t.ols_default_attribute_id = s.ols_default_attribute_id
                                   and  ((t.ols_default_attribute_oid = s.ols_default_attribute_oid) or (t.ols_default_attribute_oid is null and s.ols_default_attribute_oid                                       is null)) and
		((t.ols_default_id = s.ols_default_id) or (t.ols_default_id is null and s.ols_default_id is null)) and
		((t.ols_default_attribute_id = s.ols_default_attribute_id) or (t.ols_default_attribute_id is null and s.ols_default_attribute_id is null)) 
	)
) s
on
  (s.ols_default_attribute_id  =d.ols_default_attribute_id)
when matched
then update
set
  d.ols_default_attribute_oid = s.ols_default_attribute_oid,
  d.ols_default_id = s.ols_default_id,
  d.ods_modify_date = s.ods_modify_date
when not matched then
insert (
  ols_default_attribute_oid, ols_default_attribute_id , 
  ols_default_id, ods_create_date, ods_modify_date)
VALUES (
  ods_stage.APOCS_OLS_DEFATT_OID_SEQ.nextval, s.ols_default_attribute_id,
  s.ols_default_id, s.ods_create_date, s.ods_modify_date
  )

&& /*-----------------------------------------------*/
/* TASK No. 30 */
/* merge into ods_own.ols_default_attribute */



merge into ods_own.ols_default_attribute t
using (
   select xr.ols_default_attribute_oid, stg.name, stg.value, ols_default_xr .ols_default_oid, ss.source_system_oid, stg.audit_create_date
   , stg.audit_created_by, stg.audit_modify_date, stg.audit_modified_by, sysdate as ods_create_date, sysdate as ods_modify_date
   from ods_stage.apocs_ols_defatt_stg stg 
        ,ods_stage.apocs_ols_defatt_xr xr 
        ,ods_stage.apocs_ols_default_xr ols_default_xr 
        ,ods_own.source_system ss 
     where (1=1)
        and stg.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
        and ss.source_system_short_name ='APOCS'
        and stg.ols_default_attribute_id = xr.ols_default_attribute_id(+) 
        and xr.ols_default_id= ols_default_xr.ols_default_id
)s
on (t.ols_default_attribute_oid = s.ols_default_attribute_oid)
when matched then update
set t.name = s.name
, t.value = s.value
, t.ols_default_oid = s.ols_default_oid 
, t.source_system_oid = s.source_system_oid
, t.audit_create_date = s.audit_create_date
, t.audit_created_by = s.audit_created_by
, t.audit_modify_date = s.audit_modify_date
, t.audit_modified_by = s.audit_modified_by
, t.ods_modify_date = s.ods_modify_date
where t.name<> s.name
or t.value <> s.value
or (t.value is null and s.value is not null)
or t.ols_default_oid <> s.ols_default_oid
or t.source_system_oid <> s.source_system_oid
or (t.source_system_oid is null and s.source_system_oid is not null)
or  t.audit_create_date <> s.audit_create_date
or (t.audit_create_date is null and s.audit_create_date is not null)
or t.audit_created_by <> s.audit_created_by
or (t.audit_created_by is null and s.audit_created_by is not null)
or t.audit_modify_date <> s.audit_modify_date
or (t.audit_modify_date is null and s.audit_modify_date is not null)
or t.audit_modified_by <> s.audit_modified_by
or (t.audit_modified_by is null and s.audit_modified_by is not null)
when not matched then
insert
(
  t.ols_default_attribute_oid
, t.name
, t.value
, t.ols_default_oid
, t.source_system_oid
, t.audit_create_date
, t.audit_created_by
, t.audit_modify_date
, t.audit_modified_by
, t.ods_create_date
, t.ods_modify_date
)
values
(
  s.ols_default_attribute_oid
, s.name
, s.value
, s.ols_default_oid
, s.source_system_oid
, s.audit_create_date
, s.audit_created_by
, s.audit_modify_date
, s.audit_modified_by
, s.ods_create_date
, s.ods_modify_date
)

&& /*-----------------------------------------------*/
/* TASK No. 31 */
/* merge into ods_own.ols_default_attribute for repair */



merge into ods_own.ols_default_attribute t
using (
   select xr.ols_default_attribute_oid, stg.name, stg.value, ols_default_xr .ols_default_oid, ss.source_system_oid, stg.audit_create_date
   , stg.audit_created_by, stg.audit_modify_date, stg.audit_modified_by, sysdate as ods_create_date, sysdate as ods_modify_date
   from ods_stage.apocs_ols_defatt_stg stg 
        ,ods_stage.apocs_ols_defatt_xr xr 
        ,ods_stage.apocs_ols_default_xr ols_default_xr 
        ,ods_own.source_system ss 
     where (1=1)
        and ols_default_xr .ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
        and ss.source_system_short_name ='APOCS'
        and stg.ols_default_attribute_id = xr.ols_default_attribute_id(+) 
        and xr.ols_default_id= ols_default_xr.ols_default_id
)s
on (t.ols_default_attribute_oid = s.ols_default_attribute_oid)
when matched then update
set t.name = s.name
, t.value = s.value
, t.ols_default_oid = s.ols_default_oid 
, t.source_system_oid = s.source_system_oid
, t.audit_create_date = s.audit_create_date
, t.audit_created_by = s.audit_created_by
, t.audit_modify_date = s.audit_modify_date
, t.audit_modified_by = s.audit_modified_by
, t.ods_modify_date = s.ods_modify_date
where t.name<> s.name
or t.value <> s.value
or (t.value is null and s.value is not null)
or t.ols_default_oid <> s.ols_default_oid
or t.source_system_oid <> s.source_system_oid
or (t.source_system_oid is null and s.source_system_oid is not null)
or  t.audit_create_date <> s.audit_create_date
or (t.audit_create_date is null and s.audit_create_date is not null)
or t.audit_created_by <> s.audit_created_by
or (t.audit_created_by is null and s.audit_created_by is not null)
or t.audit_modify_date <> s.audit_modify_date
or (t.audit_modify_date is null and s.audit_modify_date is not null)
or t.audit_modified_by <> s.audit_modified_by
or (t.audit_modified_by is null and s.audit_modified_by is not null)
when not matched then
insert
(
  t.ols_default_attribute_oid
, t.name
, t.value
, t.ols_default_oid
, t.source_system_oid
, t.audit_create_date
, t.audit_created_by
, t.audit_modify_date
, t.audit_modified_by
, t.ods_create_date
, t.ods_modify_date
)
values
(
  s.ols_default_attribute_oid
, s.name
, s.value
, s.ols_default_oid
, s.source_system_oid
, s.audit_create_date
, s.audit_created_by
, s.audit_modify_date
, s.audit_modified_by
, s.ods_create_date
, s.ods_modify_date
)

&& /*-----------------------------------------------*/
/* TASK No. 32 */
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
/* TASK No. 33 */
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
'LOAD_APOCS_OLS_DEFAULT_ATTRIBUTE_PKG',
'002',
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
,'LOAD_APOCS_OLS_DEFAULT_ATTRIBUTE_PKG'
,'002'
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