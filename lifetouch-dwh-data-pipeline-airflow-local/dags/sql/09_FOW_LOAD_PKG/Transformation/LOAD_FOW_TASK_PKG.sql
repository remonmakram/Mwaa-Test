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

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 4 */




/*-----------------------------------------------*/
/* TASK No. 5 */
/* Drop work table */

-- drop table RAX_APP_USER.C$_0FOW_TASK_STG purge

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 6 */
-- /* Create work table */

-- create table RAX_APP_USER.C$_0FOW_TASK_STG
-- (
-- 	C1_ID	NUMBER(19) NULL,
-- 	C2_VERSION	NUMBER(19) NULL,
-- 	C3_ASSIGNED_TO	VARCHAR2(255) NULL,
-- 	C4_CREATED_BY	VARCHAR2(255) NULL,
-- 	C5_DATE_CREATED	TIMESTAMP(6) NULL,
-- 	C6_DESCRIPTION	VARCHAR2(255) NULL,
-- 	C7_DUE_DATE	TIMESTAMP(6) NULL,
-- 	C8_DUE_DATE_OFFSET	NUMBER(10) NULL,
-- 	C9_LAST_UPDATED	TIMESTAMP(6) NULL,
-- 	C10_LID	NUMBER(19) NULL,
-- 	C11_NOTE	VARCHAR2(1024) NULL,
-- 	C12_PARENT_ID	NUMBER(19) NULL,
-- 	C13_REFERENCE_ID	NUMBER(19) NULL,
-- 	C14_STATUS	VARCHAR2(255) NULL,
-- 	C15_TASK_GROUP	VARCHAR2(255) NULL,
-- 	C16_TASK_LEVEL	VARCHAR2(255) NULL,
-- 	C17_TASK_TYPE	VARCHAR2(255) NULL,
-- 	C18_UPDATED_BY	VARCHAR2(255) NULL,
-- 	C19_TERRITORY_CODE	VARCHAR2(2) NULL,
-- 	C20_TASK_CATEGORY	VARCHAR2(255) NULL,
-- 	C21_LAST_TASK	NUMBER(1) NULL,
-- 	C22_TARGET_TAB	VARCHAR2(255) NULL,
-- 	C23_TASK_TEMPLATE_ID	NUMBER(19) NULL
-- )
-- NOLOGGING

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 7 */
-- /* Load data */

-- /* SOURCE CODE */


-- select	
-- 	TASK.ID	   C1_ID,
-- 	TASK.VERSION	   C2_VERSION,
-- 	TASK.ASSIGNED_TO	   C3_ASSIGNED_TO,
-- 	TASK.CREATED_BY	   C4_CREATED_BY,
-- 	TASK.DATE_CREATED	   C5_DATE_CREATED,
-- 	TASK.DESCRIPTION	   C6_DESCRIPTION,
-- 	TASK.DUE_DATE	   C7_DUE_DATE,
-- 	TASK.DUE_DATE_OFFSET	   C8_DUE_DATE_OFFSET,
-- 	TASK.LAST_UPDATED	   C9_LAST_UPDATED,
-- 	TASK.LID	   C10_LID,
-- 	TASK.NOTE	   C11_NOTE,
-- 	TASK.PARENT_ID	   C12_PARENT_ID,
-- 	TASK.REFERENCE_ID	   C13_REFERENCE_ID,
-- 	TASK.STATUS	   C14_STATUS,
-- 	TASK.TASK_GROUP	   C15_TASK_GROUP,
-- 	TASK.TASK_LEVEL	   C16_TASK_LEVEL,
-- 	TASK.TASK_TYPE	   C17_TASK_TYPE,
-- 	TASK.UPDATED_BY	   C18_UPDATED_BY,
-- 	TASK.TERRITORY_CODE	   C19_TERRITORY_CODE,
-- 	TASK.TASK_CATEGORY	   C20_TASK_CATEGORY,
-- 	TASK.LAST_TASK	   C21_LAST_TASK,
-- 	TASK.TARGET_TAB	   C22_TARGET_TAB,
-- 	TASK.TASK_TEMPLATE_ID	   C23_TASK_TEMPLATE_ID
-- from	FOW_OWN.TASK   TASK
-- where	(1=1)
-- And (TASK.LAST_UPDATED >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap)







-- &

-- /* TARGET CODE */
-- insert /*+ append */ into RAX_APP_USER.C$_0FOW_TASK_STG
-- (
-- 	C1_ID,
-- 	C2_VERSION,
-- 	C3_ASSIGNED_TO,
-- 	C4_CREATED_BY,
-- 	C5_DATE_CREATED,
-- 	C6_DESCRIPTION,
-- 	C7_DUE_DATE,
-- 	C8_DUE_DATE_OFFSET,
-- 	C9_LAST_UPDATED,
-- 	C10_LID,
-- 	C11_NOTE,
-- 	C12_PARENT_ID,
-- 	C13_REFERENCE_ID,
-- 	C14_STATUS,
-- 	C15_TASK_GROUP,
-- 	C16_TASK_LEVEL,
-- 	C17_TASK_TYPE,
-- 	C18_UPDATED_BY,
-- 	C19_TERRITORY_CODE,
-- 	C20_TASK_CATEGORY,
-- 	C21_LAST_TASK,
-- 	C22_TARGET_TAB,
-- 	C23_TASK_TEMPLATE_ID
-- )
-- values
-- (
-- 	:C1_ID,
-- 	:C2_VERSION,
-- 	:C3_ASSIGNED_TO,
-- 	:C4_CREATED_BY,
-- 	:C5_DATE_CREATED,
-- 	:C6_DESCRIPTION,
-- 	:C7_DUE_DATE,
-- 	:C8_DUE_DATE_OFFSET,
-- 	:C9_LAST_UPDATED,
-- 	:C10_LID,
-- 	:C11_NOTE,
-- 	:C12_PARENT_ID,
-- 	:C13_REFERENCE_ID,
-- 	:C14_STATUS,
-- 	:C15_TASK_GROUP,
-- 	:C16_TASK_LEVEL,
-- 	:C17_TASK_TYPE,
-- 	:C18_UPDATED_BY,
-- 	:C19_TERRITORY_CODE,
-- 	:C20_TASK_CATEGORY,
-- 	:C21_LAST_TASK,
-- 	:C22_TARGET_TAB,
-- 	:C23_TASK_TEMPLATE_ID
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0FOW_TASK_STG',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;




&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Drop flow table */

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FOW_TASK_STG';  
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

create table RAX_APP_USER.I$_FOW_TASK_STG
(
	ID	NUMBER(19) NULL,
	VERSION	NUMBER(19) NULL,
	ASSIGNED_TO	VARCHAR2(255) NULL,
	CREATED_BY	VARCHAR2(255) NULL,
	DATE_CREATED	TIMESTAMP(6) NULL,
	DESCRIPTION	VARCHAR2(255) NULL,
	DUE_DATE	TIMESTAMP(6) NULL,
	DUE_DATE_OFFSET	NUMBER(10) NULL,
	LAST_UPDATED	TIMESTAMP(6) NULL,
	LID	NUMBER(19) NULL,
	NOTE	VARCHAR2(1024) NULL,
	PARENT_ID	NUMBER(19) NULL,
	REFERENCE_ID	NUMBER(19) NULL,
	STATUS	VARCHAR2(255) NULL,
	TASK_GROUP	VARCHAR2(255) NULL,
	TASK_LEVEL	VARCHAR2(255) NULL,
	TASK_TYPE	VARCHAR2(255) NULL,
	UPDATED_BY	VARCHAR2(255) NULL,
	TERRITORY_CODE	VARCHAR2(2) NULL,
	TASK_CATEGORY	VARCHAR2(255) NULL,
	LAST_TASK	NUMBER(1) NULL,
	TARGET_TAB	VARCHAR2(255) NULL,
	TASK_TEMPLATE_ID	NUMBER(19) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert flow into I$ table */

insert /*+ APPEND */  into RAX_APP_USER.I$_FOW_TASK_STG
	(
	ID,
	VERSION,
	ASSIGNED_TO,
	CREATED_BY,
	DATE_CREATED,
	DESCRIPTION,
	DUE_DATE,
	DUE_DATE_OFFSET,
	LAST_UPDATED,
	LID,
	NOTE,
	PARENT_ID,
	REFERENCE_ID,
	STATUS,
	TASK_GROUP,
	TASK_LEVEL,
	TASK_TYPE,
	UPDATED_BY,
	TERRITORY_CODE,
	TASK_CATEGORY,
	LAST_TASK,
	TARGET_TAB,
	TASK_TEMPLATE_ID
	,IND_UPDATE
	)


select 	 
	
	C1_ID,
	C2_VERSION,
	C3_ASSIGNED_TO,
	C4_CREATED_BY,
	C5_DATE_CREATED,
	C6_DESCRIPTION,
	C7_DUE_DATE,
	C8_DUE_DATE_OFFSET,
	C9_LAST_UPDATED,
	C10_LID,
	C11_NOTE,
	C12_PARENT_ID,
	C13_REFERENCE_ID,
	C14_STATUS,
	C15_TASK_GROUP,
	C16_TASK_LEVEL,
	C17_TASK_TYPE,
	C18_UPDATED_BY,
	C19_TERRITORY_CODE,
	C20_TASK_CATEGORY,
	C21_LAST_TASK,
	C22_TARGET_TAB,
	C23_TASK_TEMPLATE_ID,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0FOW_TASK_STG
where	(1=1)






minus
select
	ID,
	VERSION,
	ASSIGNED_TO,
	CREATED_BY,
	DATE_CREATED,
	DESCRIPTION,
	DUE_DATE,
	DUE_DATE_OFFSET,
	LAST_UPDATED,
	LID,
	NOTE,
	PARENT_ID,
	REFERENCE_ID,
	STATUS,
	TASK_GROUP,
	TASK_LEVEL,
	TASK_TYPE,
	UPDATED_BY,
	TERRITORY_CODE,
	TASK_CATEGORY,
	LAST_TASK,
	TARGET_TAB,
	TASK_TEMPLATE_ID
	,'I'	IND_UPDATE
from	ODS_STAGE.FOW_TASK_STG

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_FOW_TASK_STG',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_FOW_TASK_STG_IDX
on		RAX_APP_USER.I$_FOW_TASK_STG (ID)
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
and	ORIGIN 		= '(1477001)ODS_Project.LOAD_STAGING_FOW_TASK_INT'
and	ERR_TYPE 		= 'F'


&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* create error table */


BEGIN  
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.E$_FOW_TASK_STG
						(
							ODI_ROW_ID 		UROWID,
							ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
							ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
							ODI_CHECK_DATE	DATE NULL, 
							ID	NUMBER(19) NULL,
							VERSION	NUMBER(19) NULL,
							ASSIGNED_TO	VARCHAR2(255) NULL,
							CREATED_BY	VARCHAR2(255) NULL,
							DATE_CREATED	TIMESTAMP(6) NULL,
							DESCRIPTION	VARCHAR2(255) NULL,
							DUE_DATE	TIMESTAMP(6) NULL,
							DUE_DATE_OFFSET	NUMBER(10) NULL,
							LAST_UPDATED	TIMESTAMP(6) NULL,
							LID	NUMBER(19) NULL,
							NOTE	VARCHAR2(1024) NULL,
							PARENT_ID	NUMBER(19) NULL,
							REFERENCE_ID	NUMBER(19) NULL,
							STATUS	VARCHAR2(255) NULL,
							TASK_GROUP	VARCHAR2(255) NULL,
							TASK_LEVEL	VARCHAR2(255) NULL,
							TASK_TYPE	VARCHAR2(255) NULL,
							UPDATED_BY	VARCHAR2(255) NULL,
							TERRITORY_CODE	VARCHAR2(2) NULL,
							TASK_CATEGORY	VARCHAR2(255) NULL,
							LAST_TASK	NUMBER(1) NULL,
							TARGET_TAB	VARCHAR2(255) NULL,
							TASK_TEMPLATE_ID	NUMBER(19) NULL,
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

delete from 	RAX_APP_USER.E$_FOW_TASK_STG
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(1477001)ODS_Project.LOAD_STAGING_FOW_TASK_INT')


&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* create index on error table */

 
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */
BEGIN  
   EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_FOW_TASK_STG_IDX on	RAX_APP_USER.E$_FOW_TASK_STG (ODI_ROW_ID)';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -955 THEN  
         RAISE;  
      END IF;  
END;


&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* delete errors from controlled table */

delete from	RAX_APP_USER.I$_FOW_TASK_STG  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_FOW_TASK_STG E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)


&


/*-----------------------------------------------*/
/* TASK No. 21 */
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
	'FOW_TASK_STG',
	'ODS_STAGE.FOW_TASK_STG',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_FOW_TASK_STG E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(1477001)ODS_Project.LOAD_STAGING_FOW_TASK_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE


&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* Merge Rows */

merge into	ODS_STAGE.FOW_TASK_STG T
using	RAX_APP_USER.I$_FOW_TASK_STG S
on	(
		T.ID=S.ID
	)
when matched
then update set
	T.VERSION	= S.VERSION,
	T.ASSIGNED_TO	= S.ASSIGNED_TO,
	T.CREATED_BY	= S.CREATED_BY,
	T.DATE_CREATED	= S.DATE_CREATED,
	T.DESCRIPTION	= S.DESCRIPTION,
	T.DUE_DATE	= S.DUE_DATE,
	T.DUE_DATE_OFFSET	= S.DUE_DATE_OFFSET,
	T.LAST_UPDATED	= S.LAST_UPDATED,
	T.LID	= S.LID,
	T.NOTE	= S.NOTE,
	T.PARENT_ID	= S.PARENT_ID,
	T.REFERENCE_ID	= S.REFERENCE_ID,
	T.STATUS	= S.STATUS,
	T.TASK_GROUP	= S.TASK_GROUP,
	T.TASK_LEVEL	= S.TASK_LEVEL,
	T.TASK_TYPE	= S.TASK_TYPE,
	T.UPDATED_BY	= S.UPDATED_BY,
	T.TERRITORY_CODE	= S.TERRITORY_CODE,
	T.TASK_CATEGORY	= S.TASK_CATEGORY,
	T.LAST_TASK	= S.LAST_TASK,
	T.TARGET_TAB	= S.TARGET_TAB,
	T.TASK_TEMPLATE_ID	= S.TASK_TEMPLATE_ID
	,                      T.ODS_MODIFY_DATE	= sysdate
when not matched
then insert
	(
	T.ID,
	T.VERSION,
	T.ASSIGNED_TO,
	T.CREATED_BY,
	T.DATE_CREATED,
	T.DESCRIPTION,
	T.DUE_DATE,
	T.DUE_DATE_OFFSET,
	T.LAST_UPDATED,
	T.LID,
	T.NOTE,
	T.PARENT_ID,
	T.REFERENCE_ID,
	T.STATUS,
	T.TASK_GROUP,
	T.TASK_LEVEL,
	T.TASK_TYPE,
	T.UPDATED_BY,
	T.TERRITORY_CODE,
	T.TASK_CATEGORY,
	T.LAST_TASK,
	T.TARGET_TAB,
	T.TASK_TEMPLATE_ID
	,                       T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.ID,
	S.VERSION,
	S.ASSIGNED_TO,
	S.CREATED_BY,
	S.DATE_CREATED,
	S.DESCRIPTION,
	S.DUE_DATE,
	S.DUE_DATE_OFFSET,
	S.LAST_UPDATED,
	S.LID,
	S.NOTE,
	S.PARENT_ID,
	S.REFERENCE_ID,
	S.STATUS,
	S.TASK_GROUP,
	S.TASK_LEVEL,
	S.TASK_TYPE,
	S.UPDATED_BY,
	S.TERRITORY_CODE,
	S.TASK_CATEGORY,
	S.LAST_TASK,
	S.TARGET_TAB,
	S.TASK_TEMPLATE_ID
	,                       sysdate,
	sysdate
	)

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 24 */
/* Drop flow table */

drop table RAX_APP_USER.I$_FOW_TASK_STG 

&


/*-----------------------------------------------*/
/* TASK No. 1000009 */
/* Drop work table */

drop table RAX_APP_USER.C$_0FOW_TASK_STG purge

&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name


&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* Insert CDC Audit Record */

INSERT INTO RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
(TABLE_NAME,
SESS_NO,                      
SESS_NAME,                    
SCEN_VERSION,                 
SESS_BEG,                     
ORIG_LAST_CDC_COMPLETION_DATE,
OVERLAP,
CREATE_DATE              
)
values (
:v_cdc_load_table_name,
:v_sess_no,
'LOAD_FOW_TASK_PKG',
'003',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_ld_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          ),
:v_cdc_oms_overlap,
SYSDATE)

&


/*-----------------------------------------------*/
