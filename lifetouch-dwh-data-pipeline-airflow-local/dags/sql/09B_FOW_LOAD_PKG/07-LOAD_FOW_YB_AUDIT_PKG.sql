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
/* Drop work table */
/*-----------------------------------------------*/
/* TASK No. 5 */
/* Create work table */
/*-----------------------------------------------*/
/* TASK No. 6 */
/* Load data */
/* SOURCE CODE */
/* drop table RAX_APP_USER.C$_0FOW_YB_AUDIT_STG purge */
/* create table RAX_APP_USER.C$_0FOW_YB_AUDIT_STG
(
	C1_ID	NUMBER NULL,
	C2_APO_TAG	VARCHAR2(255) NULL,
	C3_EVENT_REF_ID	VARCHAR2(255) NULL,
	C4_AUDIT_DATE_CREATED	DATE NULL,
	C5_AUDIT_CREATED_BY	VARCHAR2(255) NULL,
	C6_PUBLISHED_AUDIT_ID	NUMBER NULL,
	C7_PUBLISHED_ATTRIBUTE_NAME	VARCHAR2(255) NULL,
	C8_PUBLISHED_ATTRIBUTE_VALUE	VARCHAR2(255) NULL
)
NOLOGGING */
/* select	
	YB_AUDIT.ID	   C1_ID,
	YB_AUDIT.APO_TAG	   C2_APO_TAG,
	YB_AUDIT.EVENT_REF_ID	   C3_EVENT_REF_ID,
	YB_AUDIT.AUDIT_DATE_CREATED	   C4_AUDIT_DATE_CREATED,
	YB_AUDIT.AUDIT_CREATED_BY	   C5_AUDIT_CREATED_BY,
	YB_AUDIT.PUBLISHED_AUDIT_ID	   C6_PUBLISHED_AUDIT_ID,
	YB_AUDIT.PUBLISHED_ATTRIBUTE_NAME	   C7_PUBLISHED_ATTRIBUTE_NAME,
	YB_AUDIT.PUBLISHED_ATTRIBUTE_VALUE	   C8_PUBLISHED_ATTRIBUTE_VALUE
from	FOW_OWN.YB_AUDIT   YB_AUDIT
where	(1=1)
And (YB_AUDIT.AUDIT_DATE_CREATED >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) */
/* insert  into RAX_APP_USER.C$_0FOW_YB_AUDIT_STG
(
	C1_ID,
	C2_APO_TAG,
	C3_EVENT_REF_ID,
	C4_AUDIT_DATE_CREATED,
	C5_AUDIT_CREATED_BY,
	C6_PUBLISHED_AUDIT_ID,
	C7_PUBLISHED_ATTRIBUTE_NAME,
	C8_PUBLISHED_ATTRIBUTE_VALUE
)
values
(
	:C1_ID,
	:C2_APO_TAG,
	:C3_EVENT_REF_ID,
	:C4_AUDIT_DATE_CREATED,
	:C5_AUDIT_CREATED_BY,
	:C6_PUBLISHED_AUDIT_ID,
	:C7_PUBLISHED_ATTRIBUTE_NAME,
	:C8_PUBLISHED_ATTRIBUTE_VALUE
) */
/* TARGET CODE */
/*+ append */
/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0FOW_YB_AUDIT_STG',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;

& /*-----------------------------------------------*/
/* TASK No. 9 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_FOW_YB_AUDIT_STG */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FOW_YB_AUDIT_STG';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 10 */
/* Create flow table I$ */


 /* create table RAX_APP_USER.I$_FOW_YB_AUDIT_STG
(
	ID		NUMBER NULL,
	APO_TAG		VARCHAR2(255) NULL,
	EVENT_REF_ID		VARCHAR2(255) NULL,
	AUDIT_DATE_CREATED		DATE NULL,
	AUDIT_CREATED_BY		VARCHAR2(255) NULL,
	PUBLISHED_AUDIT_ID		NUMBER NULL,
	PUBLISHED_ATTRIBUTE_NAME		VARCHAR2(255) NULL,
	PUBLISHED_ATTRIBUTE_VALUE		VARCHAR2(255) NULL,
	ODS_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create table RAX_APP_USER.I$_FOW_YB_AUDIT_STG
(
	ID		NUMBER NULL,
	APO_TAG		VARCHAR2(255) NULL,
	EVENT_REF_ID		VARCHAR2(255) NULL,
	AUDIT_DATE_CREATED		DATE NULL,
	AUDIT_CREATED_BY		VARCHAR2(255) NULL,
	PUBLISHED_AUDIT_ID		NUMBER NULL,
	PUBLISHED_ATTRIBUTE_NAME		VARCHAR2(255) NULL,
	PUBLISHED_ATTRIBUTE_VALUE		VARCHAR2(255) NULL,
	ODS_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Insert flow into I$ table */
/* DETECTION_STRATEGY = NOT_EXISTS */



insert into	RAX_APP_USER.I$_FOW_YB_AUDIT_STG
(
	ID,
	APO_TAG,
	EVENT_REF_ID,
	AUDIT_DATE_CREATED,
	AUDIT_CREATED_BY,
	PUBLISHED_AUDIT_ID,
	PUBLISHED_ATTRIBUTE_NAME,
	PUBLISHED_ATTRIBUTE_VALUE,
	IND_UPDATE
)
select 
ID,
	APO_TAG,
	EVENT_REF_ID,
	AUDIT_DATE_CREATED,
	AUDIT_CREATED_BY,
	PUBLISHED_AUDIT_ID,
	PUBLISHED_ATTRIBUTE_NAME,
	PUBLISHED_ATTRIBUTE_VALUE,
	IND_UPDATE
 from (


select 	 
	
	C1_ID ID,
	C2_APO_TAG APO_TAG,
	C3_EVENT_REF_ID EVENT_REF_ID,
	C4_AUDIT_DATE_CREATED AUDIT_DATE_CREATED,
	C5_AUDIT_CREATED_BY AUDIT_CREATED_BY,
	C6_PUBLISHED_AUDIT_ID PUBLISHED_AUDIT_ID,
	C7_PUBLISHED_ATTRIBUTE_NAME PUBLISHED_ATTRIBUTE_NAME,
	C8_PUBLISHED_ATTRIBUTE_VALUE PUBLISHED_ATTRIBUTE_VALUE,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0FOW_YB_AUDIT_STG
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.FOW_YB_AUDIT_STG T
	where	T.ID	= S.ID 
		 and ((T.APO_TAG = S.APO_TAG) or (T.APO_TAG IS NULL and S.APO_TAG IS NULL)) and
		((T.EVENT_REF_ID = S.EVENT_REF_ID) or (T.EVENT_REF_ID IS NULL and S.EVENT_REF_ID IS NULL)) and
		((T.AUDIT_DATE_CREATED = S.AUDIT_DATE_CREATED) or (T.AUDIT_DATE_CREATED IS NULL and S.AUDIT_DATE_CREATED IS NULL)) and
		((T.AUDIT_CREATED_BY = S.AUDIT_CREATED_BY) or (T.AUDIT_CREATED_BY IS NULL and S.AUDIT_CREATED_BY IS NULL)) and
		((T.PUBLISHED_AUDIT_ID = S.PUBLISHED_AUDIT_ID) or (T.PUBLISHED_AUDIT_ID IS NULL and S.PUBLISHED_AUDIT_ID IS NULL)) and
		((T.PUBLISHED_ATTRIBUTE_NAME = S.PUBLISHED_ATTRIBUTE_NAME) or (T.PUBLISHED_ATTRIBUTE_NAME IS NULL and S.PUBLISHED_ATTRIBUTE_NAME IS NULL)) and
		((T.PUBLISHED_ATTRIBUTE_VALUE = S.PUBLISHED_ATTRIBUTE_VALUE) or (T.PUBLISHED_ATTRIBUTE_VALUE IS NULL and S.PUBLISHED_ATTRIBUTE_VALUE IS NULL))
        )

& /*-----------------------------------------------*/
/* TASK No. 12 */
/* Create Index on flow table */


 /* create index	RAX_APP_USER.I$_FOW_YB_AUDIT_STG_IDX
on		RAX_APP_USER.I$_FOW_YB_AUDIT_STG (ID)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_FOW_YB_AUDIT_STG_IDX
on		RAX_APP_USER.I$_FOW_YB_AUDIT_STG (ID)
NOLOGGING';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_FOW_YB_AUDIT_STG',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& /*-----------------------------------------------*/
/* TASK No. 14 */
/* create check table */


 /* create table RAX_APP_USER.SNP_CHECK_TAB
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
) */ 


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
        IF SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 15 */
/* delete previous check sum */



delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS_STAGE'
and	ORIGIN 		= '(2468001)ODS_Project.LOAD_FOW_YB_AUDIT_STG_INT'
and	ERR_TYPE 		= 'F'

& /*-----------------------------------------------*/
/* TASK No. 16 */
/* create error table */


 /* create table RAX_APP_USER.E$_FOW_YB_AUDIT_STG
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	ID	NUMBER NULL,
	APO_TAG	VARCHAR2(255) NULL,
	EVENT_REF_ID	VARCHAR2(255) NULL,
	AUDIT_DATE_CREATED	DATE NULL,
	AUDIT_CREATED_BY	VARCHAR2(255) NULL,
	PUBLISHED_AUDIT_ID	NUMBER NULL,
	PUBLISHED_ATTRIBUTE_NAME	VARCHAR2(255) NULL,
	PUBLISHED_ATTRIBUTE_VALUE	VARCHAR2(255) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
	ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
	ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
	ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
	ODI_SESS_NO		VARCHAR2(19 CHAR)
) */ 


BEGIN
    EXECUTE IMMEDIATE 'create table RAX_APP_USER.E$_FOW_YB_AUDIT_STG
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	ID	NUMBER NULL,
	APO_TAG	VARCHAR2(255) NULL,
	EVENT_REF_ID	VARCHAR2(255) NULL,
	AUDIT_DATE_CREATED	DATE NULL,
	AUDIT_CREATED_BY	VARCHAR2(255) NULL,
	PUBLISHED_AUDIT_ID	NUMBER NULL,
	PUBLISHED_ATTRIBUTE_NAME	VARCHAR2(255) NULL,
	PUBLISHED_ATTRIBUTE_VALUE	VARCHAR2(255) NULL,
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
        IF SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 17 */
/* delete previous errors */



delete from 	RAX_APP_USER.E$_FOW_YB_AUDIT_STG
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(2468001)ODS_Project.LOAD_FOW_YB_AUDIT_STG_INT')

& /*-----------------------------------------------*/
/* TASK No. 18 */
/* Create index on AK */
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */


 /* create index 	FOW_YB_AUDIT_STG_UIX_flow
on	RAX_APP_USER.I$_FOW_YB_AUDIT_STG 
	(ID) */ 


BEGIN
    EXECUTE IMMEDIATE 'create index 	FOW_YB_AUDIT_STG_UIX_flow
on	RAX_APP_USER.I$_FOW_YB_AUDIT_STG 
	(ID)';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 19 */
/* insert AK errors */



insert into RAX_APP_USER.E$_FOW_YB_AUDIT_STG
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
	ID,
	APO_TAG,
	EVENT_REF_ID,
	AUDIT_DATE_CREATED,
	AUDIT_CREATED_BY,
	PUBLISHED_AUDIT_ID,
	PUBLISHED_ATTRIBUTE_NAME,
	PUBLISHED_ATTRIBUTE_VALUE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15063: The alternate key FOW_YB_AUDIT_STG_UIX is not unique.',
	'(2468001)ODS_Project.LOAD_FOW_YB_AUDIT_STG_INT',
	sysdate,
	'FOW_YB_AUDIT_STG_UIX',
	'AK',	
	FOW_YB_AUDIT_STG.ID,
	FOW_YB_AUDIT_STG.APO_TAG,
	FOW_YB_AUDIT_STG.EVENT_REF_ID,
	FOW_YB_AUDIT_STG.AUDIT_DATE_CREATED,
	FOW_YB_AUDIT_STG.AUDIT_CREATED_BY,
	FOW_YB_AUDIT_STG.PUBLISHED_AUDIT_ID,
	FOW_YB_AUDIT_STG.PUBLISHED_ATTRIBUTE_NAME,
	FOW_YB_AUDIT_STG.PUBLISHED_ATTRIBUTE_VALUE,
	FOW_YB_AUDIT_STG.ODS_CREATE_DATE,
	FOW_YB_AUDIT_STG.ODS_MODIFY_DATE
from	RAX_APP_USER.I$_FOW_YB_AUDIT_STG   FOW_YB_AUDIT_STG
where	exists  (
		select	SUB.ID
		from 	RAX_APP_USER.I$_FOW_YB_AUDIT_STG SUB
		where 	SUB.ID=FOW_YB_AUDIT_STG.ID
		group by 	SUB.ID
		having 	count(1) > 1
		)

& /*-----------------------------------------------*/
/* TASK No. 20 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_FOW_YB_AUDIT_STG
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
	ID,
	APO_TAG,
	EVENT_REF_ID,
	AUDIT_DATE_CREATED,
	AUDIT_CREATED_BY,
	PUBLISHED_AUDIT_ID,
	PUBLISHED_ATTRIBUTE_NAME,
	PUBLISHED_ATTRIBUTE_VALUE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column ID cannot be null.',
	sysdate,
	'(2468001)ODS_Project.LOAD_FOW_YB_AUDIT_STG_INT',
	'ID',
	'NN',	
	ID,
	APO_TAG,
	EVENT_REF_ID,
	AUDIT_DATE_CREATED,
	AUDIT_CREATED_BY,
	PUBLISHED_AUDIT_ID,
	PUBLISHED_ATTRIBUTE_NAME,
	PUBLISHED_ATTRIBUTE_VALUE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_FOW_YB_AUDIT_STG
where	ID is null

& /*-----------------------------------------------*/
/* TASK No. 21 */
/* create index on error table */
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */


 /* create index 	RAX_APP_USER.E$_FOW_YB_AUDIT_STG_IDX
on	RAX_APP_USER.E$_FOW_YB_AUDIT_STG (ODI_ROW_ID) */ 


BEGIN
    EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_FOW_YB_AUDIT_STG_IDX
on	RAX_APP_USER.E$_FOW_YB_AUDIT_STG (ODI_ROW_ID)';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 22 */
/* delete errors from controlled table */



delete from	RAX_APP_USER.I$_FOW_YB_AUDIT_STG  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_FOW_YB_AUDIT_STG E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)

& /*-----------------------------------------------*/
/* TASK No. 23 */
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
	'FOW_YB_AUDIT_STG',
	'ODS_STAGE.FOW_YB_AUDIT_STG',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_FOW_YB_AUDIT_STG E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(2468001)ODS_Project.LOAD_FOW_YB_AUDIT_STG_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE

& /*-----------------------------------------------*/
/* TASK No. 24 */
/* Flag rows for update */
/* DETECTION_STRATEGY = NOT_EXISTS */



update	RAX_APP_USER.I$_FOW_YB_AUDIT_STG
set	IND_UPDATE = 'U'
where	(ID)
	in	(
		select	ID
		from	ODS_STAGE.FOW_YB_AUDIT_STG
		)

& /*-----------------------------------------------*/
/* TASK No. 25 */
/* Flag useless rows */
/* DETECTION_STRATEGY = NOT_EXISTS */
/* Command skipped due to chosen DETECTION_STRATEGY */
/*-----------------------------------------------*/
/* TASK No. 26 */
/* Update existing rows */
/* DETECTION_STRATEGY = NOT_EXISTS */



update	ODS_STAGE.FOW_YB_AUDIT_STG T
set 	
	(
	T.APO_TAG,
	T.EVENT_REF_ID,
	T.AUDIT_DATE_CREATED,
	T.AUDIT_CREATED_BY,
	T.PUBLISHED_AUDIT_ID,
	T.PUBLISHED_ATTRIBUTE_NAME,
	T.PUBLISHED_ATTRIBUTE_VALUE
	) =
		(
		select	S.APO_TAG,
			S.EVENT_REF_ID,
			S.AUDIT_DATE_CREATED,
			S.AUDIT_CREATED_BY,
			S.PUBLISHED_AUDIT_ID,
			S.PUBLISHED_ATTRIBUTE_NAME,
			S.PUBLISHED_ATTRIBUTE_VALUE
		from	RAX_APP_USER.I$_FOW_YB_AUDIT_STG S
		where	T.ID	=S.ID
	    	 )
	,       T.ODS_MODIFY_DATE = sysdate

where	(ID)
	in	(
		select	ID
		from	RAX_APP_USER.I$_FOW_YB_AUDIT_STG
		where	IND_UPDATE = 'U'
		)

& /*-----------------------------------------------*/
/* TASK No. 27 */
/* Insert new rows */
/* DETECTION_STRATEGY = NOT_EXISTS */



insert into 	ODS_STAGE.FOW_YB_AUDIT_STG T
	(
	ID,
	APO_TAG,
	EVENT_REF_ID,
	AUDIT_DATE_CREATED,
	AUDIT_CREATED_BY,
	PUBLISHED_AUDIT_ID,
	PUBLISHED_ATTRIBUTE_NAME,
	PUBLISHED_ATTRIBUTE_VALUE
	,        ODS_CREATE_DATE,
	ODS_MODIFY_DATE
	)
select 	ID,
	APO_TAG,
	EVENT_REF_ID,
	AUDIT_DATE_CREATED,
	AUDIT_CREATED_BY,
	PUBLISHED_AUDIT_ID,
	PUBLISHED_ATTRIBUTE_NAME,
	PUBLISHED_ATTRIBUTE_VALUE
	,        sysdate,
	sysdate
from	RAX_APP_USER.I$_FOW_YB_AUDIT_STG S



where	IND_UPDATE = 'I'

& /*-----------------------------------------------*/
/* TASK No. 28 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 29 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_FOW_YB_AUDIT_STG */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FOW_YB_AUDIT_STG';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0FOW_YB_AUDIT_STG purge */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_YB_AUDIT_STG purge';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 30 */
/* load ods_stage.fow_yb_audit_xr */



merge into ods_stage.fow_yb_audit_xr t
using (
      select id, apo_tag, event_ref_id
      from ods_stage.fow_yb_audit_stg
      where ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap 
)s
on (s.id = t.id)
when not matched then 
insert 
(
 t.yb_audit_oid
,t.id
,t.apo_tag
,t.event_ref_id
,t.ods_create_date
,t.ods_modify_date
)
values
(
ods_stage.yb_audit_oid_seq.nextval
,s.id
,s.apo_tag
,s.event_ref_id
,sysdate
,sysdate
)

& /*-----------------------------------------------*/
/* TASK No. 31 */
/* load ods_own.yb_audit */



merge into ods_own.yb_audit t
using (
  select xr.yb_audit_oid, apo.apo_oid, event.event_oid, stg.audit_date_created, stg.published_attribute_name, stg.published_attribute_value, ss.source_system_oid
  from ods_stage.fow_yb_audit_stg stg, ods_stage.fow_yb_audit_xr xr, ods_own.apo apo, ods_own.event event, ods_own.source_system ss
  where xr.id = stg.id
  and stg.apo_tag = apo.apo_id(+)
  and stg.event_ref_id = event.event_ref_id(+)
  and ss.source_system_short_name = 'FOW'
  and stg.ods_modify_date>= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap
)s
on (t.yb_audit_oid = s.yb_audit_oid)
when matched then update
set t.apo_oid = s.apo_oid
,t.event_oid = s.event_oid
,t.audit_date_created = s.audit_date_created
,t.published_attribute_name = s.published_attribute_name
,t.published_attribute_value = s.published_attribute_value
,t.source_system_oid = s.source_system_oid
,t.ods_modify_date = sysdate
where  t.apo_oid <> s.apo_oid
        or (t.apo_oid is null and s.apo_oid is not null)
        or t.event_oid <> s.event_oid
        or (t.event_oid is null and s.event_oid is not null)
        or t.audit_date_created <> s.audit_date_created
        or t.published_attribute_name <> s.published_attribute_name
        or t.published_attribute_value <> s.published_attribute_value
when not matched then 
insert
(
 t.yb_audit_oid
,t.apo_oid
,t.event_oid
,t.audit_date_created
,t.published_attribute_name
,t.published_attribute_value
,t.source_system_oid
,t.ods_create_date
,t.ods_modify_date
)
values
(
 s.yb_audit_oid
,s.apo_oid
,s.event_oid
,s.audit_date_created
,s.published_attribute_name
,s.published_attribute_value
,s.source_system_oid
,sysdate
,sysdate
)

& /*-----------------------------------------------*/
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

& /*-----------------------------------------------*/
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
'LOAD_FOW_YB_AUDIT_PKG',
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
,'LOAD_FOW_YB_AUDIT_PKG'
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