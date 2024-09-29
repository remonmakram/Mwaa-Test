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

-- drop table RAX_APP_USER.C$_0FOW_REFERENCE_STG purge

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 5 */
-- /* Create work table */

-- create table RAX_APP_USER.C$_0FOW_REFERENCE_STG
-- (
-- 	C1_ID	NUMBER(19) NULL,
-- 	C2_VERSION	NUMBER(19) NULL,
-- 	C3_CODE	VARCHAR2(255) NULL,
-- 	C4_CREATED_BY	VARCHAR2(255) NULL,
-- 	C5_DATE_CREATED	TIMESTAMP(6) NULL,
-- 	C6_DESCRIPTION	VARCHAR2(255) NULL,
-- 	C7_LAST_UPDATED	TIMESTAMP(6) NULL,
-- 	C8_NAME	VARCHAR2(255) NULL,
-- 	C9_PUBLISHABLE	NUMBER(1) NULL,
-- 	C10_SORT_ORDER	NUMBER(10) NULL,
-- 	C11_UPDATED_BY	VARCHAR2(255) NULL
-- )
-- NOLOGGING

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 6 */
-- /* Load data */

-- /* SOURCE CODE */


-- select	
-- 	REFERENCE.ID	   C1_ID,
-- 	REFERENCE.VERSION	   C2_VERSION,
-- 	REFERENCE.CODE	   C3_CODE,
-- 	REFERENCE.CREATED_BY	   C4_CREATED_BY,
-- 	REFERENCE.DATE_CREATED	   C5_DATE_CREATED,
-- 	REFERENCE.DESCRIPTION	   C6_DESCRIPTION,
-- 	REFERENCE.LAST_UPDATED	   C7_LAST_UPDATED,
-- 	REFERENCE.NAME	   C8_NAME,
-- 	REFERENCE.PUBLISHABLE	   C9_PUBLISHABLE,
-- 	REFERENCE.SORT_ORDER	   C10_SORT_ORDER,
-- 	REFERENCE.UPDATED_BY	   C11_UPDATED_BY
-- from	FOW_OWN.REFERENCE   REFERENCE
-- where	(1=1)
-- And (REFERENCE.LAST_UPDATED >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
-- )







-- &

-- /* TARGET CODE */
-- insert /*+ append */ into RAX_APP_USER.C$_0FOW_REFERENCE_STG
-- (
-- 	C1_ID,
-- 	C2_VERSION,
-- 	C3_CODE,
-- 	C4_CREATED_BY,
-- 	C5_DATE_CREATED,
-- 	C6_DESCRIPTION,
-- 	C7_LAST_UPDATED,
-- 	C8_NAME,
-- 	C9_PUBLISHABLE,
-- 	C10_SORT_ORDER,
-- 	C11_UPDATED_BY
-- )
-- values
-- (
-- 	:C1_ID,
-- 	:C2_VERSION,
-- 	:C3_CODE,
-- 	:C4_CREATED_BY,
-- 	:C5_DATE_CREATED,
-- 	:C6_DESCRIPTION,
-- 	:C7_LAST_UPDATED,
-- 	:C8_NAME,
-- 	:C9_PUBLISHABLE,
-- 	:C10_SORT_ORDER,
-- 	:C11_UPDATED_BY
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0FOW_REFERENCE_STG',
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
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FOW_REFERENCE_STG1499001';  
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

create table RAX_APP_USER.I$_FOW_REFERENCE_STG1499001
(
	ID	NUMBER(19) NULL,
	VERSION	NUMBER(19) NULL,
	CODE	VARCHAR2(255) NULL,
	CREATED_BY	VARCHAR2(255) NULL,
	DATE_CREATED	TIMESTAMP(6) NULL,
	DESCRIPTION	VARCHAR2(255) NULL,
	LAST_UPDATED	TIMESTAMP(6) NULL,
	NAME	VARCHAR2(255) NULL,
	PUBLISHABLE	NUMBER(1) NULL,
	SORT_ORDER	NUMBER(10) NULL,
	UPDATED_BY	VARCHAR2(255) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_FOW_REFERENCE_STG1499001
(
	ID,
	VERSION,
	CODE,
	CREATED_BY,
	DATE_CREATED,
	DESCRIPTION,
	LAST_UPDATED,
	NAME,
	PUBLISHABLE,
	SORT_ORDER,
	UPDATED_BY,
	IND_UPDATE
)
select 
ID,
	VERSION,
	CODE,
	CREATED_BY,
	DATE_CREATED,
	DESCRIPTION,
	LAST_UPDATED,
	NAME,
	PUBLISHABLE,
	SORT_ORDER,
	UPDATED_BY,
	IND_UPDATE
 from (


select 	 
	
	C1_ID ID,
	C2_VERSION VERSION,
	C3_CODE CODE,
	C4_CREATED_BY CREATED_BY,
	C5_DATE_CREATED DATE_CREATED,
	C6_DESCRIPTION DESCRIPTION,
	C7_LAST_UPDATED LAST_UPDATED,
	C8_NAME NAME,
	C9_PUBLISHABLE PUBLISHABLE,
	C10_SORT_ORDER SORT_ORDER,
	C11_UPDATED_BY UPDATED_BY,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0FOW_REFERENCE_STG
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE_CA.FOW_REFERENCE_STG T
	where	T.ID	= S.ID 
		 and ((T.VERSION = S.VERSION) or (T.VERSION IS NULL and S.VERSION IS NULL)) and
		((T.CODE = S.CODE) or (T.CODE IS NULL and S.CODE IS NULL)) and
		((T.CREATED_BY = S.CREATED_BY) or (T.CREATED_BY IS NULL and S.CREATED_BY IS NULL)) and
		((T.DATE_CREATED = S.DATE_CREATED) or (T.DATE_CREATED IS NULL and S.DATE_CREATED IS NULL)) and
		((T.DESCRIPTION = S.DESCRIPTION) or (T.DESCRIPTION IS NULL and S.DESCRIPTION IS NULL)) and
		((T.LAST_UPDATED = S.LAST_UPDATED) or (T.LAST_UPDATED IS NULL and S.LAST_UPDATED IS NULL)) and
		((T.NAME = S.NAME) or (T.NAME IS NULL and S.NAME IS NULL)) and
		((T.PUBLISHABLE = S.PUBLISHABLE) or (T.PUBLISHABLE IS NULL and S.PUBLISHABLE IS NULL)) and
		((T.SORT_ORDER = S.SORT_ORDER) or (T.SORT_ORDER IS NULL and S.SORT_ORDER IS NULL)) and
		((T.UPDATED_BY = S.UPDATED_BY) or (T.UPDATED_BY IS NULL and S.UPDATED_BY IS NULL))
        )

  
  

  



&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_FOW_REFERENCE_STG1499001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Create Index on flow table */

BEGIN  
   EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_FOW_REFERENCE_STG_IDX1499001
						on RAX_APP_USER.I$_FOW_REFERENCE_STG1499001 (ID)
						NOLOGGING';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -972 THEN  
         RAISE;  
      END IF;  
END; 

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
where	SCHEMA_NAME	= 'ODS_STAGE_CA'
and	ORIGIN 		= '(1499001)ODS_Project.LOAD_FOW_REFERENCE_STG_INT'
and	ERR_TYPE 		= 'F'


&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* create error table */


BEGIN  
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.E$_FOW_REFERENCE_STG1499001
						(
							ODI_ROW_ID 		UROWID,
							ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
							ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
							ODI_CHECK_DATE	DATE NULL, 
							ID	NUMBER(19) NULL,
							VERSION	NUMBER(19) NULL,
							CODE	VARCHAR2(255) NULL,
							CREATED_BY	VARCHAR2(255) NULL,
							DATE_CREATED	TIMESTAMP(6) NULL,
							DESCRIPTION	VARCHAR2(255) NULL,
							LAST_UPDATED	TIMESTAMP(6) NULL,
							NAME	VARCHAR2(255) NULL,
							PUBLISHABLE	NUMBER(1) NULL,
							SORT_ORDER	NUMBER(10) NULL,
							UPDATED_BY	VARCHAR2(255) NULL,
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



&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* delete previous errors */

delete from 	RAX_APP_USER.E$_FOW_REFERENCE_STG1499001
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(1499001)ODS_Project.LOAD_FOW_REFERENCE_STG_INT')


&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Create index on PK */

 
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */
create index 	RAX_APP_USER.I$_FOW_REFERENCE_STG1499001
on	RAX_APP_USER.I$_FOW_REFERENCE_STG1499001 (ID)


&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* insert PK errors */

DECLARE
               CheckTable                             VarChar2(60);
               TargetTable                            VarChar2(60);
               VariableCheckTable                     VarChar2(60);

BEGIN
               SELECT 'RAX_APP_USER.I$_FOW_REFERENCE_STG' INTO CheckTable FROM DUAL;
               SELECT 'ODS_STAGE_CA.FOW_REFERENCE_STG' INTO TargetTable FROM DUAL;

IF CheckTable = TargetTable THEN
   VariableCheckTable := CheckTable; 
ELSE
   VariableCheckTable := CheckTable || '1499001';
END IF;

execute immediate '
insert into RAX_APP_USER.E$_FOW_REFERENCE_STG1499001
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
	VERSION,
	CODE,
	CREATED_BY,
	DATE_CREATED,
	DESCRIPTION,
	LAST_UPDATED,
	NAME,
	PUBLISHABLE,
	SORT_ORDER,
	UPDATED_BY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	''F'', 
	''ODI-15064: The primary key FOW_REFERENCE_STG_PK is not unique.'',
	''(1499001)ODS_Project.LOAD_FOW_REFERENCE_STG_INT'',
	sysdate,
	''FOW_REFERENCE_STG_PK'',
	''PK'',	
	FOW_REFERENCE_STG.ID,
	FOW_REFERENCE_STG.VERSION,
	FOW_REFERENCE_STG.CODE,
	FOW_REFERENCE_STG.CREATED_BY,
	FOW_REFERENCE_STG.DATE_CREATED,
	FOW_REFERENCE_STG.DESCRIPTION,
	FOW_REFERENCE_STG.LAST_UPDATED,
	FOW_REFERENCE_STG.NAME,
	FOW_REFERENCE_STG.PUBLISHABLE,
	FOW_REFERENCE_STG.SORT_ORDER,
	FOW_REFERENCE_STG.UPDATED_BY,
	FOW_REFERENCE_STG.ODS_CREATE_DATE,
	FOW_REFERENCE_STG.ODS_MODIFY_DATE
from	'
 || VariableCheckTable || 
' FOW_REFERENCE_STG 
where	exists  (
		select	SUB1.ID
		from 	' 
|| VariableCheckTable ||
'  SUB1
		where 	SUB1.ID=FOW_REFERENCE_STG.ID
		group by 	SUB1.ID
		having 	count(1) > 1
		)
';

END;


&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_FOW_REFERENCE_STG1499001
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
	VERSION,
	CODE,
	CREATED_BY,
	DATE_CREATED,
	DESCRIPTION,
	LAST_UPDATED,
	NAME,
	PUBLISHABLE,
	SORT_ORDER,
	UPDATED_BY,
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
	'(1499001)ODS_Project.LOAD_FOW_REFERENCE_STG_INT',
	'ID',
	'NN',	
	ID,
	VERSION,
	CODE,
	CREATED_BY,
	DATE_CREATED,
	DESCRIPTION,
	LAST_UPDATED,
	NAME,
	PUBLISHABLE,
	SORT_ORDER,
	UPDATED_BY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_FOW_REFERENCE_STG1499001
where	ID is null



&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* create index on error table */

 
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */
BEGIN  
   EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_FOW_REFERENCE_STG1499001 on	RAX_APP_USER.E$_FOW_REFERENCE_STG1499001 (ODI_ROW_ID)';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -955 THEN  
         RAISE;  
      END IF;  
END; 


&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* delete errors from controlled table */

delete from	RAX_APP_USER.I$_FOW_REFERENCE_STG1499001  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_FOW_REFERENCE_STG1499001 E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)


&


/*-----------------------------------------------*/
/* TASK No. 24 */
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
	'ODS_STAGE_CA',
	'FOW_REFERENCE_STG',
	'ODS_STAGE_CA.FOW_REFERENCE_STG1499001',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_FOW_REFERENCE_STG1499001 E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(1499001)ODS_Project.LOAD_FOW_REFERENCE_STG_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE


&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* Merge Rows */

merge into	ODS_STAGE_CA.FOW_REFERENCE_STG T
using	RAX_APP_USER.I$_FOW_REFERENCE_STG1499001 S
on	(
		T.ID=S.ID
	)
when matched
then update set
	T.VERSION	= S.VERSION,
	T.CODE	= S.CODE,
	T.CREATED_BY	= S.CREATED_BY,
	T.DATE_CREATED	= S.DATE_CREATED,
	T.DESCRIPTION	= S.DESCRIPTION,
	T.LAST_UPDATED	= S.LAST_UPDATED,
	T.NAME	= S.NAME,
	T.PUBLISHABLE	= S.PUBLISHABLE,
	T.SORT_ORDER	= S.SORT_ORDER,
	T.UPDATED_BY	= S.UPDATED_BY
	,          T.ODS_MODIFY_DATE	= sysdate
when not matched
then insert
	(
	T.ID,
	T.VERSION,
	T.CODE,
	T.CREATED_BY,
	T.DATE_CREATED,
	T.DESCRIPTION,
	T.LAST_UPDATED,
	T.NAME,
	T.PUBLISHABLE,
	T.SORT_ORDER,
	T.UPDATED_BY
	,           T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.ID,
	S.VERSION,
	S.CODE,
	S.CREATED_BY,
	S.DATE_CREATED,
	S.DESCRIPTION,
	S.LAST_UPDATED,
	S.NAME,
	S.PUBLISHABLE,
	S.SORT_ORDER,
	S.UPDATED_BY
	,           sysdate,
	sysdate
	)

&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 27 */
/* Drop flow table */

drop table RAX_APP_USER.I$_FOW_REFERENCE_STG1499001 

&


/*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */

drop table RAX_APP_USER.C$_0FOW_REFERENCE_STG purge

&


/*-----------------------------------------------*/
/* TASK No. 28 */
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
/* TASK No. 29 */
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
,'LOAD_FOW_REFERENCE_PKG'
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
'LOAD_FOW_REFERENCE_PKG',
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
