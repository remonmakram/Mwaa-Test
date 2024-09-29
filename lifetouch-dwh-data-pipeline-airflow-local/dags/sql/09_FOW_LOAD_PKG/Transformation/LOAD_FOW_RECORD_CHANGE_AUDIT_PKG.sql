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

-- drop table RAX_APP_USER.C$_0FOW_RCRD_CHG_AUD purge

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 5 */
-- /* Create work table */

-- create table RAX_APP_USER.C$_0FOW_RCRD_CHG_AUD
-- (
-- 	C1_TABLE_NAME	VARCHAR2(30) NULL,
-- 	C2_KEY_VALUE	VARCHAR2(255) NULL,
-- 	C3_EVENT_TYPE	VARCHAR2(10) NULL,
-- 	C4_EVENT_DETAIL	VARCHAR2(2000) NULL,
-- 	C5_DATE_CREATED	TIMESTAMP(6) NULL,
-- 	C6_KEY_VALUE2	VARCHAR2(255) NULL
-- )
-- NOLOGGING

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 6 */
-- /* Load data */

-- /* SOURCE CODE */


-- select	
-- 	RECORD_CHANGE_AUDIT.TABLE_NAME	   C1_TABLE_NAME,
-- 	RECORD_CHANGE_AUDIT.KEY_VALUE	   C2_KEY_VALUE,
-- 	RECORD_CHANGE_AUDIT.EVENT_TYPE	   C3_EVENT_TYPE,
-- 	RECORD_CHANGE_AUDIT.EVENT_DETAIL	   C4_EVENT_DETAIL,
-- 	RECORD_CHANGE_AUDIT.DATE_CREATED	   C5_DATE_CREATED,
-- 	RECORD_CHANGE_AUDIT.KEY_VALUE2	   C6_KEY_VALUE2
-- from	FOW_OWN.RECORD_CHANGE_AUDIT   RECORD_CHANGE_AUDIT
-- where	(1=1)
-- And (RECORD_CHANGE_AUDIT.DATE_CREATED  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap)







-- &

-- /* TARGET CODE */
-- insert /*+ append */ into RAX_APP_USER.C$_0FOW_RCRD_CHG_AUD
-- (
-- 	C1_TABLE_NAME,
-- 	C2_KEY_VALUE,
-- 	C3_EVENT_TYPE,
-- 	C4_EVENT_DETAIL,
-- 	C5_DATE_CREATED,
-- 	C6_KEY_VALUE2
-- )
-- values
-- (
-- 	:C1_TABLE_NAME,
-- 	:C2_KEY_VALUE,
-- 	:C3_EVENT_TYPE,
-- 	:C4_EVENT_DETAIL,
-- 	:C5_DATE_CREATED,
-- 	:C6_KEY_VALUE2
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0FOW_RCRD_CHG_AUD',
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

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FOW_RCRD_CHG_AUD1726001';  
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

create table RAX_APP_USER.I$_FOW_RCRD_CHG_AUD1726001
(
	TABLE_NAME	VARCHAR2(30) NULL,
	KEY_VALUE	VARCHAR2(255) NULL,
	EVENT_TYPE	VARCHAR2(10) NULL,
	EVENT_DETAIL	VARCHAR2(2000) NULL,
	DATE_CREATED	TIMESTAMP(6) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	KEY_VALUE2	VARCHAR2(255) NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_FOW_RCRD_CHG_AUD1726001
(
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	KEY_VALUE2,
	IND_UPDATE
)
select 
TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	KEY_VALUE2,
	IND_UPDATE
 from (


select 	 
	
	C1_TABLE_NAME TABLE_NAME,
	C2_KEY_VALUE KEY_VALUE,
	C3_EVENT_TYPE EVENT_TYPE,
	C4_EVENT_DETAIL EVENT_DETAIL,
	C5_DATE_CREATED DATE_CREATED,
	C6_KEY_VALUE2 KEY_VALUE2,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0FOW_RCRD_CHG_AUD
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.FOW_RECORD_CHANGE_AUDIT T
	where	T.TABLE_NAME	= S.TABLE_NAME
	and	T.KEY_VALUE	= S.KEY_VALUE 
		 and ((T.EVENT_TYPE = S.EVENT_TYPE) or (T.EVENT_TYPE IS NULL and S.EVENT_TYPE IS NULL)) and
		((T.EVENT_DETAIL = S.EVENT_DETAIL) or (T.EVENT_DETAIL IS NULL and S.EVENT_DETAIL IS NULL)) and
		((T.DATE_CREATED = S.DATE_CREATED) or (T.DATE_CREATED IS NULL and S.DATE_CREATED IS NULL)) and
		((T.KEY_VALUE2 = S.KEY_VALUE2) or (T.KEY_VALUE2 IS NULL and S.KEY_VALUE2 IS NULL))
        )

  
  

  



&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_FOW_RCRD_CHG_AUD1726001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_FOW_RCRD_CHG_AUD_IDX1726001
on		RAX_APP_USER.I$_FOW_RCRD_CHG_AUD1726001 (TABLE_NAME, KEY_VALUE)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 15 */
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
      IF SQLCODE != -955 THEN  
         RAISE;  
      END IF;  
END;
	

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* delete previous check sum */

delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS_STAGE'
and	ORIGIN 		= '(1726001)ODS_Project.LOAD_FOW_RECORD_CHANGE_AUDIT_STG_INT'
and	ERR_TYPE 		= 'F'


&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* create error table */


BEGIN  
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.E$_FOW_RCRD_CHG_AUD1726001
						(
							ODI_ROW_ID 		UROWID,
							ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
							ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
							ODI_CHECK_DATE	DATE NULL, 
							TABLE_NAME	VARCHAR2(30) NULL,
							KEY_VALUE	VARCHAR2(255) NULL,
							EVENT_TYPE	VARCHAR2(10) NULL,
							EVENT_DETAIL	VARCHAR2(2000) NULL,
							DATE_CREATED	TIMESTAMP(6) NULL,
							ODS_CREATE_DATE	DATE NULL,
							ODS_MODIFY_DATE	DATE NULL,
							KEY_VALUE2	VARCHAR2(255) NULL,
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



&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* delete previous errors */

delete from 	RAX_APP_USER.E$_FOW_RCRD_CHG_AUD1726001
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(1726001)ODS_Project.LOAD_FOW_RECORD_CHANGE_AUDIT_STG_INT')


&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Create index on PK */

 
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */
BEGIN  
   EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.I$_FOW_RCRD_CHG_AUD1726001 on	RAX_APP_USER.I$_FOW_RCRD_CHG_AUD1726001 (TABLE_NAME, KEY_VALUE)';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -955 AND SQLCODE != -1408 THEN  
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
               SELECT 'RAX_APP_USER.I$_FOW_RCRD_CHG_AUD' INTO CheckTable FROM DUAL;
               SELECT 'ODS_STAGE.FOW_RECORD_CHANGE_AUDIT' INTO TargetTable FROM DUAL;

IF CheckTable = TargetTable THEN
   VariableCheckTable := CheckTable; 
ELSE
   VariableCheckTable := CheckTable || '1726001';
END IF;

execute immediate '
insert into RAX_APP_USER.E$_FOW_RCRD_CHG_AUD1726001
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
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	KEY_VALUE2
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	''F'', 
	''ODI-15064: The primary key FOW_RECORD_CHANGE_AUDIT_PK is not unique.'',
	''(1726001)ODS_Project.LOAD_FOW_RECORD_CHANGE_AUDIT_STG_INT'',
	sysdate,
	''FOW_RECORD_CHANGE_AUDIT_PK'',
	''PK'',	
	FOW_RECORD_CHANGE_AUDIT.TABLE_NAME,
	FOW_RECORD_CHANGE_AUDIT.KEY_VALUE,
	FOW_RECORD_CHANGE_AUDIT.EVENT_TYPE,
	FOW_RECORD_CHANGE_AUDIT.EVENT_DETAIL,
	FOW_RECORD_CHANGE_AUDIT.DATE_CREATED,
	FOW_RECORD_CHANGE_AUDIT.ODS_CREATE_DATE,
	FOW_RECORD_CHANGE_AUDIT.ODS_MODIFY_DATE,
	FOW_RECORD_CHANGE_AUDIT.KEY_VALUE2
from	'
 || VariableCheckTable || 
' FOW_RECORD_CHANGE_AUDIT 
where	exists  (
		select	SUB1.TABLE_NAME,
			SUB1.KEY_VALUE
		from 	' 
|| VariableCheckTable ||
'  SUB1
		where 	SUB1.TABLE_NAME=FOW_RECORD_CHANGE_AUDIT.TABLE_NAME
			and SUB1.KEY_VALUE=FOW_RECORD_CHANGE_AUDIT.KEY_VALUE
		group by 	SUB1.TABLE_NAME,
			SUB1.KEY_VALUE
		having 	count(1) > 1
		)
';

END;


&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_FOW_RCRD_CHG_AUD1726001
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
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	KEY_VALUE2
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column TABLE_NAME cannot be null.',
	sysdate,
	'(1726001)ODS_Project.LOAD_FOW_RECORD_CHANGE_AUDIT_STG_INT',
	'TABLE_NAME',
	'NN',	
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	KEY_VALUE2
from	RAX_APP_USER.I$_FOW_RCRD_CHG_AUD1726001
where	TABLE_NAME is null



&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_FOW_RCRD_CHG_AUD1726001
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
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	KEY_VALUE2
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column KEY_VALUE cannot be null.',
	sysdate,
	'(1726001)ODS_Project.LOAD_FOW_RECORD_CHANGE_AUDIT_STG_INT',
	'KEY_VALUE',
	'NN',	
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	KEY_VALUE2
from	RAX_APP_USER.I$_FOW_RCRD_CHG_AUD1726001
where	KEY_VALUE is null



&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_FOW_RCRD_CHG_AUD1726001
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
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	KEY_VALUE2
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column EVENT_TYPE cannot be null.',
	sysdate,
	'(1726001)ODS_Project.LOAD_FOW_RECORD_CHANGE_AUDIT_STG_INT',
	'EVENT_TYPE',
	'NN',	
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	KEY_VALUE2
from	RAX_APP_USER.I$_FOW_RCRD_CHG_AUD1726001
where	EVENT_TYPE is null



&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_FOW_RCRD_CHG_AUD1726001
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
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	KEY_VALUE2
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column DATE_CREATED cannot be null.',
	sysdate,
	'(1726001)ODS_Project.LOAD_FOW_RECORD_CHANGE_AUDIT_STG_INT',
	'DATE_CREATED',
	'NN',	
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	KEY_VALUE2
from	RAX_APP_USER.I$_FOW_RCRD_CHG_AUD1726001
where	DATE_CREATED is null



&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* create index on error table */

 
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */
BEGIN  
   EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_FOW_RCRD_CHG_AUD1726001 on RAX_APP_USER.E$_FOW_RCRD_CHG_AUD1726001 (ODI_ROW_ID)';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -955 THEN  
         RAISE;  
      END IF;  
END;


&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* delete errors from controlled table */

delete from	RAX_APP_USER.I$_FOW_RCRD_CHG_AUD1726001  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_FOW_RCRD_CHG_AUD1726001 E
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
	'FOW_RCRD_CHG_AUD',
	'ODS_STAGE.FOW_RECORD_CHANGE_AUDIT1726001',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_FOW_RCRD_CHG_AUD1726001 E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(1726001)ODS_Project.LOAD_FOW_RECORD_CHANGE_AUDIT_STG_INT'
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

merge into	ODS_STAGE.FOW_RECORD_CHANGE_AUDIT T
using	RAX_APP_USER.I$_FOW_RCRD_CHG_AUD1726001 S
on	(
		T.TABLE_NAME=S.TABLE_NAME
	and		T.KEY_VALUE=S.KEY_VALUE
	)
when matched
then update set
	T.EVENT_TYPE	= S.EVENT_TYPE,
	T.EVENT_DETAIL	= S.EVENT_DETAIL,
	T.DATE_CREATED	= S.DATE_CREATED,
	T.KEY_VALUE2	= S.KEY_VALUE2
	,    T.ODS_MODIFY_DATE	= SYSDATE
when not matched
then insert
	(
	T.TABLE_NAME,
	T.KEY_VALUE,
	T.EVENT_TYPE,
	T.EVENT_DETAIL,
	T.DATE_CREATED,
	T.KEY_VALUE2
	,      T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.TABLE_NAME,
	S.KEY_VALUE,
	S.EVENT_TYPE,
	S.EVENT_DETAIL,
	S.DATE_CREATED,
	S.KEY_VALUE2
	,      SYSDATE,
	SYSDATE
	)

&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 30 */
/* Drop flow table */

drop table RAX_APP_USER.I$_FOW_RCRD_CHG_AUD1726001 

&


/*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */

drop table RAX_APP_USER.C$_0FOW_RCRD_CHG_AUD purge

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
,'LOAD_FOW_RECORD_CHANGE_AUDIT_PKG'
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
'LOAD_FOW_RECORD_CHANGE_AUDIT_PKG',
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
