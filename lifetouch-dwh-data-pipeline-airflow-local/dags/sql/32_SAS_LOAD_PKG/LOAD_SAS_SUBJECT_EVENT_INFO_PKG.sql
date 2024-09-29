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

-- drop table RAX_APP_USER.C$_0SAS_SUB_EVT_INF_STG purge

-- &


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Create work table */

-- create table RAX_APP_USER.C$_0SAS_SUB_EVT_INF_STG
-- (
-- 	C1_SUBJECT_ID	NUMBER(19) NULL,
-- 	C2_EVENT_IMAGE_FACT_ID	NUMBER(19) NULL,
-- 	C3_AUDIT_CREATE_DATE	TIMESTAMP(6) NULL,
-- 	C4_AUDIT_MODIFY_DATE	TIMESTAMP(6) NULL
-- )
-- NOLOGGING

-- &


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Load data */

/* SOURCE CODE */


-- select	
-- 	SUBJECT_EVENT_INFO.SUBJECT_ID	   C1_SUBJECT_ID,
-- 	SUBJECT_EVENT_INFO.EVENT_IMAGE_FACT_ID	   C2_EVENT_IMAGE_FACT_ID,
-- 	SUBJECT_EVENT_INFO.AUDIT_CREATE_DATE	   C3_AUDIT_CREATE_DATE,
-- 	SUBJECT_EVENT_INFO.AUDIT_MODIFY_DATE	   C4_AUDIT_MODIFY_DATE
-- from	SAS_SIT_OWN.SUBJECT_EVENT_INFO   SUBJECT_EVENT_INFO
-- where	(1=1)
-- And (SUBJECT_EVENT_INFO.AUDIT_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap)







-- &

/* TARGET CODE */
-- insert /*+ append */ into RAX_APP_USER.C$_0SAS_SUB_EVT_INF_STG
-- (
-- 	C1_SUBJECT_ID,
-- 	C2_EVENT_IMAGE_FACT_ID,
-- 	C3_AUDIT_CREATE_DATE,
-- 	C4_AUDIT_MODIFY_DATE
-- )
-- values
-- (
-- 	:C1_SUBJECT_ID,
-- 	:C2_EVENT_IMAGE_FACT_ID,
-- 	:C3_AUDIT_CREATE_DATE,
-- 	:C4_AUDIT_MODIFY_DATE
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0SAS_SUB_EVT_INF_STG',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;




&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 9 */




/*-----------------------------------------------*/
/* TASK No. 10 */
/* Drop flow table */

-- drop table RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG1396001

BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG1396001';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;


&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG1396001
(
	SUBJECT_ID	NUMBER(19) NULL,
	EVENT_IMAGE_FACT_ID	NUMBER(19) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	AUDIT_CREATE_DATE	TIMESTAMP(6) NULL,
	AUDIT_MODIFY_DATE	TIMESTAMP(6) NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG1396001
(
	SUBJECT_ID,
	EVENT_IMAGE_FACT_ID,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFY_DATE,
	IND_UPDATE
)
select 
SUBJECT_ID,
	EVENT_IMAGE_FACT_ID,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFY_DATE,
	IND_UPDATE
 from (


select 	 
	
	C1_SUBJECT_ID SUBJECT_ID,
	C2_EVENT_IMAGE_FACT_ID EVENT_IMAGE_FACT_ID,
	C3_AUDIT_CREATE_DATE AUDIT_CREATE_DATE,
	C4_AUDIT_MODIFY_DATE AUDIT_MODIFY_DATE,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0SAS_SUB_EVT_INF_STG
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.SAS_SUBJECT_EVENT_INFO_STG T
	where	T.SUBJECT_ID	= S.SUBJECT_ID
	and	T.EVENT_IMAGE_FACT_ID	= S.EVENT_IMAGE_FACT_ID 
		 and ((T.AUDIT_CREATE_DATE = S.AUDIT_CREATE_DATE) or (T.AUDIT_CREATE_DATE IS NULL and S.AUDIT_CREATE_DATE IS NULL)) and
		((T.AUDIT_MODIFY_DATE = S.AUDIT_MODIFY_DATE) or (T.AUDIT_MODIFY_DATE IS NULL and S.AUDIT_MODIFY_DATE IS NULL))
        )

  
  

  



&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_SAS_SUB_EVT_INF_STG1396001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Create Index on flow table */

-- create index	c
-- on		RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG1396001 (SUBJECT_ID, EVENT_IMAGE_FACT_ID)
-- NOLOGGING

BEGIN
  EXECUTE IMMEDIATE 'create index RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG1396001
on   RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG1396001 (SUBJECT_ID, EVENT_IMAGE_FACT_ID)';
EXCEPTION
  WHEN OTHERS THEN
   -- Handle the case where the identifier is too long (ORA-00972)
   IF SQLCODE = -972 or  SQLCODE = -1408 or SQLCODE = -955  THEN
     DBMS_OUTPUT.PUT_LINE('Identifier is too long. Skipping creation of index.');
   ELSE
     RAISE;
   END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* create check table */

BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.SNP_CHECK_TAB';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&

-- create table RAX_APP_USER.SNP_CHECK_TAB
-- (
-- 	CATALOG_NAME	VARCHAR2(100 CHAR) NULL ,
-- 	SCHEMA_NAME	VARCHAR2(100 CHAR) NULL ,
-- 	RESOURCE_NAME	VARCHAR2(100 CHAR) NULL,
-- 	FULL_RES_NAME	VARCHAR2(100 CHAR) NULL,
-- 	ERR_TYPE		VARCHAR2(1 CHAR) NULL,
-- 	ERR_MESS		VARCHAR2(250 CHAR) NULL ,
-- 	CHECK_DATE	DATE NULL,
-- 	ORIGIN		VARCHAR2(100 CHAR) NULL,
-- 	CONS_NAME	VARCHAR2(35 CHAR) NULL,
-- 	CONS_TYPE		VARCHAR2(2 CHAR) NULL,
-- 	ERR_COUNT		NUMBER(10) NULL
-- )

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
END;


&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* delete previous check sum */

delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS_STAGE'
and	ORIGIN 		= '(1396001)ODS_Project.LOAD_SAS_SUBJECT_EVENT_INFO_STG_INT'
and	ERR_TYPE 		= 'F'


&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* create error table */

BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.E$_SAS_SUB_EVT_INF_STG1396001';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&

create table RAX_APP_USER.E$_SAS_SUB_EVT_INF_STG1396001
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	SUBJECT_ID	NUMBER(19) NULL,
	EVENT_IMAGE_FACT_ID	NUMBER(19) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	AUDIT_CREATE_DATE	TIMESTAMP(6) NULL,
	AUDIT_MODIFY_DATE	TIMESTAMP(6) NULL,
	ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
	ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
	ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
	ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
	ODI_SESS_NO		VARCHAR2(19 CHAR)
)



&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* delete previous errors */

delete from 	RAX_APP_USER.E$_SAS_SUB_EVT_INF_STG1396001
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(1396001)ODS_Project.LOAD_SAS_SUBJECT_EVENT_INFO_STG_INT')


&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Create index on PK */

 
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */
-- create index 	RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG1396001
-- on	RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG1396001 (SUBJECT_ID,
-- 		EVENT_IMAGE_FACT_ID)

BEGIN
  EXECUTE IMMEDIATE 'create index RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG1396001
on   RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG1396001 (SUBJECT_ID, EVENT_IMAGE_FACT_ID)';
EXCEPTION
  WHEN OTHERS THEN
   -- Handle the case where the identifier is too long (ORA-00972)
   IF SQLCODE = -972 or  SQLCODE = -1408 or SQLCODE = -955  THEN
     DBMS_OUTPUT.PUT_LINE('Identifier is too long. Skipping creation of index.');
   ELSE
     RAISE;
   END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* insert PK errors */

DECLARE
               CheckTable                             VarChar2(60);
               TargetTable                            VarChar2(60);
               VariableCheckTable                     VarChar2(60);

BEGIN
               SELECT 'RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG' INTO CheckTable FROM DUAL;
               SELECT 'ODS_STAGE.SAS_SUBJECT_EVENT_INFO_STG' INTO TargetTable FROM DUAL;

IF CheckTable = TargetTable THEN
   VariableCheckTable := CheckTable; 
ELSE
   VariableCheckTable := CheckTable || '1396001';
END IF;

execute immediate '
insert into RAX_APP_USER.E$_SAS_SUB_EVT_INF_STG1396001
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
	SUBJECT_ID,
	EVENT_IMAGE_FACT_ID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	''F'', 
	''ODI-15064: The primary key SUBJECT_EVENT_INFO_PK is not unique.'',
	''(1396001)ODS_Project.LOAD_SAS_SUBJECT_EVENT_INFO_STG_INT'',
	sysdate,
	''SUBJECT_EVENT_INFO_PK'',
	''PK'',	
	SAS_SUB_EVT_INF_STG.SUBJECT_ID,
	SAS_SUB_EVT_INF_STG.EVENT_IMAGE_FACT_ID,
	SAS_SUB_EVT_INF_STG.ODS_CREATE_DATE,
	SAS_SUB_EVT_INF_STG.ODS_MODIFY_DATE,
	SAS_SUB_EVT_INF_STG.AUDIT_CREATE_DATE,
	SAS_SUB_EVT_INF_STG.AUDIT_MODIFY_DATE
from	'
 || VariableCheckTable || 
' SAS_SUB_EVT_INF_STG 
where	exists  (
		select	SUB1.SUBJECT_ID,
			SUB1.EVENT_IMAGE_FACT_ID
		from 	' 
|| VariableCheckTable ||
'  SUB1
		where 	SUB1.SUBJECT_ID=SAS_SUB_EVT_INF_STG.SUBJECT_ID
			and SUB1.EVENT_IMAGE_FACT_ID=SAS_SUB_EVT_INF_STG.EVENT_IMAGE_FACT_ID
		group by 	SUB1.SUBJECT_ID,
			SUB1.EVENT_IMAGE_FACT_ID
		having 	count(1) > 1
		)
';

END;


&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* Create index on AK */

 
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */
-- create index 	SAS_SUBJECT_EVENT_INFO_PK_flow
-- on	RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG1396001 
-- 	(SUBJECT_ID,
-- 			EVENT_IMAGE_FACT_ID)

BEGIN
  EXECUTE IMMEDIATE 'create index SAS_SUBJECT_EVENT_INFO_PK_flow
on   RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG1396001 (SUBJECT_ID, EVENT_IMAGE_FACT_ID)';
EXCEPTION
  WHEN OTHERS THEN
   -- Handle the case where the identifier is too long (ORA-00972)
   IF SQLCODE = -972 or  SQLCODE = -1408 or SQLCODE = -955  THEN
     DBMS_OUTPUT.PUT_LINE('Identifier is too long. Skipping creation of index.');
   ELSE
     RAISE;
   END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* insert AK errors */

DECLARE
               CheckTable                             VarChar2(60);
               TargetTable                            VarChar2(60);
               VariableCheckTable                VarChar2(60);

BEGIN
               SELECT 'RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG' INTO CheckTable FROM DUAL;
               SELECT 'ODS_STAGE.SAS_SUBJECT_EVENT_INFO_STG' INTO TargetTable FROM DUAL;

IF CheckTable = TargetTable THEN
   VariableCheckTable := CheckTable; 
ELSE
   VariableCheckTable := CheckTable || '1396001';
END IF;

execute immediate '
insert into RAX_APP_USER.E$_SAS_SUB_EVT_INF_STG1396001
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
	SUBJECT_ID,
	EVENT_IMAGE_FACT_ID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	''F'', 
	''ODI-15063: The alternate key SAS_SUBJECT_EVENT_INFO_PK is not unique.'',
	''(1396001)ODS_Project.LOAD_SAS_SUBJECT_EVENT_INFO_STG_INT'',
	sysdate,
	''SAS_SUBJECT_EVENT_INFO_PK'',
	''AK'',	
	SAS_SUB_EVT_INF_STG.SUBJECT_ID,
	SAS_SUB_EVT_INF_STG.EVENT_IMAGE_FACT_ID,
	SAS_SUB_EVT_INF_STG.ODS_CREATE_DATE,
	SAS_SUB_EVT_INF_STG.ODS_MODIFY_DATE,
	SAS_SUB_EVT_INF_STG.AUDIT_CREATE_DATE,
	SAS_SUB_EVT_INF_STG.AUDIT_MODIFY_DATE
from              '	
 || VariableCheckTable || 
' SAS_SUB_EVT_INF_STG
where	exists  (
		select	SUB.SUBJECT_ID,
			SUB.EVENT_IMAGE_FACT_ID
		from 	'
 || VariableCheckTable || 
' SUB
		where 	SUB.SUBJECT_ID=SAS_SUB_EVT_INF_STG.SUBJECT_ID
			and SUB.EVENT_IMAGE_FACT_ID=SAS_SUB_EVT_INF_STG.EVENT_IMAGE_FACT_ID
		group by 	SUB.SUBJECT_ID,
			SUB.EVENT_IMAGE_FACT_ID
		having 	count(1) > 1
		)
 ';

END;

/*  Checked Datastore =RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG  */
/*  Integration Datastore =RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG   */
/*  Target Datastore =ODS_STAGE.SAS_SUBJECT_EVENT_INFO_STG */



&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_SAS_SUB_EVT_INF_STG1396001
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
	SUBJECT_ID,
	EVENT_IMAGE_FACT_ID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column SUBJECT_ID cannot be null.',
	sysdate,
	'(1396001)ODS_Project.LOAD_SAS_SUBJECT_EVENT_INFO_STG_INT',
	'SUBJECT_ID',
	'NN',	
	SUBJECT_ID,
	EVENT_IMAGE_FACT_ID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFY_DATE
from	RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG1396001
where	SUBJECT_ID is null



&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_SAS_SUB_EVT_INF_STG1396001
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
	SUBJECT_ID,
	EVENT_IMAGE_FACT_ID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column EVENT_IMAGE_FACT_ID cannot be null.',
	sysdate,
	'(1396001)ODS_Project.LOAD_SAS_SUBJECT_EVENT_INFO_STG_INT',
	'EVENT_IMAGE_FACT_ID',
	'NN',	
	SUBJECT_ID,
	EVENT_IMAGE_FACT_ID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFY_DATE
from	RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG1396001
where	EVENT_IMAGE_FACT_ID is null



&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* create index on error table */

 
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */
-- create index 	RAX_APP_USER.E$_SAS_SUB_EVT_INF_STG1396001
-- on	RAX_APP_USER.E$_SAS_SUB_EVT_INF_STG1396001 (ODI_ROW_ID)

BEGIN
  EXECUTE IMMEDIATE 'create index RAX_APP_USER.E$_SAS_SUB_EVT_INF_STG1396001
on   RAX_APP_USER.E$_SAS_SUB_EVT_INF_STG1396001 (ODI_ROW_ID)';
EXCEPTION
  WHEN OTHERS THEN
   -- Handle the case where the identifier is too long (ORA-00972)
   IF SQLCODE = -972 or  SQLCODE = -1408 or SQLCODE = -955  THEN
     DBMS_OUTPUT.PUT_LINE('Identifier is too long. Skipping creation of index.');
   ELSE
     RAISE;
   END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* delete errors from controlled table */

delete from	RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG1396001  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_SAS_SUB_EVT_INF_STG1396001 E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)


&


/*-----------------------------------------------*/
/* TASK No. 27 */
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
	'SAS_SUB_EVT_INF_STG',
	'ODS_STAGE.SAS_SUBJECT_EVENT_INFO_STG1396001',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_SAS_SUB_EVT_INF_STG1396001 E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(1396001)ODS_Project.LOAD_SAS_SUBJECT_EVENT_INFO_STG_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE


&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* Merge Rows */

merge into	ODS_STAGE.SAS_SUBJECT_EVENT_INFO_STG T
using	RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG1396001 S
on	(
		T.SUBJECT_ID=S.SUBJECT_ID
	and		T.EVENT_IMAGE_FACT_ID=S.EVENT_IMAGE_FACT_ID
	)
when matched
then update set
	T.AUDIT_CREATE_DATE	= S.AUDIT_CREATE_DATE,
	T.AUDIT_MODIFY_DATE	= S.AUDIT_MODIFY_DATE
	,  T.ODS_MODIFY_DATE	= sysdate
when not matched
then insert
	(
	T.SUBJECT_ID,
	T.EVENT_IMAGE_FACT_ID,
	T.AUDIT_CREATE_DATE,
	T.AUDIT_MODIFY_DATE
	,    T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.SUBJECT_ID,
	S.EVENT_IMAGE_FACT_ID,
	S.AUDIT_CREATE_DATE,
	S.AUDIT_MODIFY_DATE
	,    sysdate,
	sysdate
	)

&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 30 */
/* Drop flow table */

-- drop table RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG1396001

BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_SAS_SUB_EVT_INF_STG1396001';
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

-- drop table RAX_APP_USER.C$_0SAS_SUB_EVT_INF_STG purge

BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0SAS_SUB_EVT_INF_STG purge';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 31 */
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
/* TASK No. 32 */
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
,'LOAD_SAS_SUBJECT_EVENT_INFO_PKG'
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
'LOAD_SAS_SUBJECT_EVENT_INFO_PKG',
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
