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

-- drop table RAX_APP_USER.C$_0IM_SELECTION_FIELD_CHOICE_ purge

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 5 */
-- /* Create work table */

-- create table RAX_APP_USER.C$_0IM_SELECTION_FIELD_CHOICE_
-- (
-- 	C1_ID	NUMBER NULL,
-- 	C2_CHOICE_ID	VARCHAR2(255) NULL,
-- 	C3_LABEL	VARCHAR2(255) NULL,
-- 	C4_SELECTION_FIELD_ID	NUMBER NULL
-- )
-- NOLOGGING

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 6 */
-- /* Load data */

-- /* SOURCE CODE */


-- select	
-- 	SELECTION_FIELD_CHOICE.ID	   C1_ID,
-- 	SELECTION_FIELD_CHOICE.CHOICE_ID	   C2_CHOICE_ID,
-- 	SELECTION_FIELD_CHOICE.LABEL	   C3_LABEL,
-- 	SELECTION_FIELD_CHOICE.SELECTION_FIELD_ID	   C4_SELECTION_FIELD_ID
-- from	ITEM_MASTER_OWN.SELECTION_FIELD_CHOICE   SELECTION_FIELD_CHOICE, ITEM_MASTER_OWN.SELECTION_FIELD   SELECTION_FIELD
-- where	(1=1)
-- And (SELECTION_FIELD.LAST_UPDATED >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap)

--  And (SELECTION_FIELD_CHOICE.SELECTION_FIELD_ID=SELECTION_FIELD.ID)





-- &

-- /* TARGET CODE */
-- insert /*+ append */ into RAX_APP_USER.C$_0IM_SELECTION_FIELD_CHOICE_
-- (
-- 	C1_ID,
-- 	C2_CHOICE_ID,
-- 	C3_LABEL,
-- 	C4_SELECTION_FIELD_ID
-- )
-- values
-- (
-- 	:C1_ID,
-- 	:C2_CHOICE_ID,
-- 	:C3_LABEL,
-- 	:C4_SELECTION_FIELD_ID
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0IM_SELECTION_FIELD_CHOICE_',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;




&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Drop flow table */

-- drop table RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S 
BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S
(
	ID		NUMBER NULL,
	CHOICE_ID		VARCHAR2(255) NULL,
	LABEL		VARCHAR2(255) NULL,
	SELECTION_FIELD_ID		NUMBER NULL,
	ODS_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S
(
	ID,
	CHOICE_ID,
	LABEL,
	SELECTION_FIELD_ID,
	IND_UPDATE
)
select 
ID,
	CHOICE_ID,
	LABEL,
	SELECTION_FIELD_ID,
	IND_UPDATE
 from (


select 	 
	
	C1_ID ID,
	C2_CHOICE_ID CHOICE_ID,
	C3_LABEL LABEL,
	C4_SELECTION_FIELD_ID SELECTION_FIELD_ID,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0IM_SELECTION_FIELD_CHOICE_
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.IM_SELECTION_FIELD_CHOICE_STG T
	where	T.ID	= S.ID 
		 and ((T.CHOICE_ID = S.CHOICE_ID) or (T.CHOICE_ID IS NULL and S.CHOICE_ID IS NULL)) and
		((T.LABEL = S.LABEL) or (T.LABEL IS NULL and S.LABEL IS NULL)) and
		((T.SELECTION_FIELD_ID = S.SELECTION_FIELD_ID) or (T.SELECTION_FIELD_ID IS NULL and S.SELECTION_FIELD_ID IS NULL))
        )

  
  

  

 


&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Create Index on flow table */

-- create index	RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S
-- on		RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S (ID)
-- NOLOGGING
BEGIN
   EXECUTE IMMEDIATE 'create index RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S on RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S (ID) NOLOGGING';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -955 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_IM_SELECTION_FIELD_CHOICE_S',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* create check table */


BEGIN
   EXECUTE IMMEDIATE '  
            create table RAX_APP_USER.SNP_CHECK_TAB
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
			)  
        '; 
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -955 THEN
         RAISE;
      END IF;
END;
	

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* delete previous check sum */

delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS_STAGE'
and	ORIGIN 		= '(2474001)ODS_Project.LOAD_IM_SELECTION_FIELD_CHOICE_STG_INT'
and	ERR_TYPE 		= 'F'


&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* create error table */


BEGIN
   EXECUTE IMMEDIATE '  
            create table RAX_APP_USER.E$_IM_SELECTION_FIELD_CHOICE_S
			(
				ODI_ROW_ID 		UROWID,
				ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
				ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
				ODI_CHECK_DATE	DATE NULL, 
				ID	NUMBER NULL,
				CHOICE_ID	VARCHAR2(255) NULL,
				LABEL	VARCHAR2(255) NULL,
				SELECTION_FIELD_ID	NUMBER NULL,
				ODS_CREATE_DATE	DATE NULL,
				ODS_MODIFY_DATE	DATE NULL,
				ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
				ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
				ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
				ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
				ODI_SESS_NO		VARCHAR2(19 CHAR)
			)  
        '; 
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -955 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* delete previous errors */

delete from 	RAX_APP_USER.E$_IM_SELECTION_FIELD_CHOICE_S
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(2474001)ODS_Project.LOAD_IM_SELECTION_FIELD_CHOICE_STG_INT')


&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Create index on AK */

 
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */
-- create index 	IM_SELECTION_FIELD_CHOICE_PK_flow
-- on	RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S 
-- 	(ID)
BEGIN
   EXECUTE IMMEDIATE 'create index IM_SELECTION_FIELD_CHOICE_PK_flow on	RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S (ID)';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -972 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* insert AK errors */

insert into RAX_APP_USER.E$_IM_SELECTION_FIELD_CHOICE_S
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
	CHOICE_ID,
	LABEL,
	SELECTION_FIELD_ID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15063: The alternate key IM_SELECTION_FIELD_CHOICE_PK is not unique.',
	'(2474001)ODS_Project.LOAD_IM_SELECTION_FIELD_CHOICE_STG_INT',
	sysdate,
	'IM_SELECTION_FIELD_CHOICE_PK',
	'AK',	
	IM_SELECTION_FIELD_CHOICE_STG.ID,
	IM_SELECTION_FIELD_CHOICE_STG.CHOICE_ID,
	IM_SELECTION_FIELD_CHOICE_STG.LABEL,
	IM_SELECTION_FIELD_CHOICE_STG.SELECTION_FIELD_ID,
	IM_SELECTION_FIELD_CHOICE_STG.ODS_CREATE_DATE,
	IM_SELECTION_FIELD_CHOICE_STG.ODS_MODIFY_DATE
from	RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S   IM_SELECTION_FIELD_CHOICE_STG
where	exists  (
		select	SUB.ID
		from 	RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S SUB
		where 	SUB.ID=IM_SELECTION_FIELD_CHOICE_STG.ID
		group by 	SUB.ID
		having 	count(1) > 1
		)



&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_IM_SELECTION_FIELD_CHOICE_S
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
	CHOICE_ID,
	LABEL,
	SELECTION_FIELD_ID,
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
	'(2474001)ODS_Project.LOAD_IM_SELECTION_FIELD_CHOICE_STG_INT',
	'ID',
	'NN',	
	ID,
	CHOICE_ID,
	LABEL,
	SELECTION_FIELD_ID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S
where	ID is null



&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_IM_SELECTION_FIELD_CHOICE_S
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
	CHOICE_ID,
	LABEL,
	SELECTION_FIELD_ID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column CHOICE_ID cannot be null.',
	sysdate,
	'(2474001)ODS_Project.LOAD_IM_SELECTION_FIELD_CHOICE_STG_INT',
	'CHOICE_ID',
	'NN',	
	ID,
	CHOICE_ID,
	LABEL,
	SELECTION_FIELD_ID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S
where	CHOICE_ID is null



&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_IM_SELECTION_FIELD_CHOICE_S
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
	CHOICE_ID,
	LABEL,
	SELECTION_FIELD_ID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column LABEL cannot be null.',
	sysdate,
	'(2474001)ODS_Project.LOAD_IM_SELECTION_FIELD_CHOICE_STG_INT',
	'LABEL',
	'NN',	
	ID,
	CHOICE_ID,
	LABEL,
	SELECTION_FIELD_ID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S
where	LABEL is null



&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_IM_SELECTION_FIELD_CHOICE_S
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
	CHOICE_ID,
	LABEL,
	SELECTION_FIELD_ID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column SELECTION_FIELD_ID cannot be null.',
	sysdate,
	'(2474001)ODS_Project.LOAD_IM_SELECTION_FIELD_CHOICE_STG_INT',
	'SELECTION_FIELD_ID',
	'NN',	
	ID,
	CHOICE_ID,
	LABEL,
	SELECTION_FIELD_ID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S
where	SELECTION_FIELD_ID is null



&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* create index on error table */

 
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */
-- create index 	RAX_APP_USER.E$_IM_SELECTION_FIELD_CHOICE_S
-- on	RAX_APP_USER.E$_IM_SELECTION_FIELD_CHOICE_S (ODI_ROW_ID)
BEGIN
   EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_IM_SELECTION_FIELD_CHOICE_S on	RAX_APP_USER.E$_IM_SELECTION_FIELD_CHOICE_S (ODI_ROW_ID)';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -955 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* delete errors from controlled table */

delete from	RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_IM_SELECTION_FIELD_CHOICE_S E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)


&


/*-----------------------------------------------*/
/* TASK No. 26 */
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
	'IM_SELECTION_FIELD_CHOICE_STG',
	'ODS_STAGE.IM_SELECTION_FIELD_CHOICE_STG',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_IM_SELECTION_FIELD_CHOICE_S E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(2474001)ODS_Project.LOAD_IM_SELECTION_FIELD_CHOICE_STG_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE


&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* Flag rows for update */

/* DETECTION_STRATEGY = NOT_EXISTS */


update	RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S
set	IND_UPDATE = 'U'
where	(ID)
	in	(
		select	ID
		from	ODS_STAGE.IM_SELECTION_FIELD_CHOICE_STG
		)



&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* Flag useless rows */

/* DETECTION_STRATEGY = NOT_EXISTS */

/* Command skipped due to chosen DETECTION_STRATEGY */



/*-----------------------------------------------*/
/* TASK No. 29 */
/* Update existing rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
update	ODS_STAGE.IM_SELECTION_FIELD_CHOICE_STG T
set 	
	(
	T.CHOICE_ID,
	T.LABEL,
	T.SELECTION_FIELD_ID
	) =
		(
		select	S.CHOICE_ID,
			S.LABEL,
			S.SELECTION_FIELD_ID
		from	RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S S
		where	T.ID	=S.ID
	    	 )
	,   T.ODS_MODIFY_DATE = sysdate

where	(ID)
	in	(
		select	ID
		from	RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* Insert new rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
insert into 	ODS_STAGE.IM_SELECTION_FIELD_CHOICE_STG T
	(
	ID,
	CHOICE_ID,
	LABEL,
	SELECTION_FIELD_ID
	,    ODS_CREATE_DATE,
	ODS_MODIFY_DATE
	)
select 	ID,
	CHOICE_ID,
	LABEL,
	SELECTION_FIELD_ID
	,    sysdate,
	sysdate
from	RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S S



where	IND_UPDATE = 'I'



&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 32 */
/* Drop flow table */

-- drop table RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S 
BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_IM_SELECTION_FIELD_CHOICE_S';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */

-- drop table RAX_APP_USER.C$_0IM_SELECTION_FIELD_CHOICE_ purge
BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0IM_SELECTION_FIELD_CHOICE_ purge';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 33 */
/* merge into ods_stage.im_selection_field_choice_xr */

merge into ods_stage.im_selection_field_choice_xr t
using (
      select id, selection_field_id
      from ods_stage.im_selection_field_choice_stg
      where ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap 
)s
on (s.id = t.id)
when matched then 
update 
set
  t.selection_field_id = s.selection_field_id
where t.selection_field_id <> s.selection_field_id
when not matched then 
insert 
(
 t.selection_field_choice_oid
,t.id
,t.selection_field_id
,t.ods_create_date
,t.ods_modify_date
)
values
(
ods_stage.selection_field_choice_oid_seq.nextval
,s.id
,s.selection_field_id
,sysdate
,sysdate
)


&


/*-----------------------------------------------*/
/* TASK No. 34 */
/* merge into ods_own.selection_field_choice */

merge into ods_own.selection_field_choice t
using(
  select stg.choice_id, stg.label, stg.selection_field_id, ss.source_system_oid, xr.selection_field_choice_oid, xr1.selection_field_oid
  from ods_stage.im_selection_field_choice_stg stg, ods_stage.im_selection_field_choice_xr xr, ods_own.source_system ss, ods_stage.im_selection_field_xr xr1
  where stg.id = xr.id
   and ss.source_system_short_name = 'IM'
   and stg.selection_field_id = xr1.id
  and stg.ods_modify_date>= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap
)s
on (t.selection_field_choice_oid = s.selection_field_choice_oid)
when matched then update
set t.choice_id = s.choice_id
, t.label = s.label
, t.selection_field_oid = s.selection_field_oid
, t.ods_modify_date = sysdate
where s.choice_id <> t.choice_id
or t.label <> s.label
or decode (t.selection_field_oid, s.selection_field_oid, 1, 0) = 0 
when not matched then 
insert 
(
 t.selection_field_choice_oid
, t.choice_id
, t.label
, t.selection_field_oid
, t.source_system_oid
, t.ods_create_date
, t.ods_modify_date
)
values
(
 s.selection_field_choice_oid
, s.choice_id
, s.label
, s.selection_field_oid
, s.source_system_oid
, sysdate
, sysdate
)

&


/*-----------------------------------------------*/
/* TASK No. 35 */
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
/* TASK No. 36 */
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
,'LOAD_IM_SELECTION_FIELD_CHOICE_PKG'
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
'LOAD_IM_SELECTION_FIELD_CHOICE_PKG',
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


&


/*-----------------------------------------------*/
