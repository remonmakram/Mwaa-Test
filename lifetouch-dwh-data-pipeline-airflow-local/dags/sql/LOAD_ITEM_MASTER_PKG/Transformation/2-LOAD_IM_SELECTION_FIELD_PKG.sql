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

-- drop table RAX_APP_USER.C$_0IM_SELECTION_FIELD_STG purge

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 5 */
-- /* Create work table */

-- create table RAX_APP_USER.C$_0IM_SELECTION_FIELD_STG
-- (
-- 	C1_ID	NUMBER NULL,
-- 	C2_CREATED_BY	VARCHAR2(255) NULL,
-- 	C3_DATE_CREATED	DATE NULL,
-- 	C4_DEFAULT_VALUE	VARCHAR2(255) NULL,
-- 	C5_LAB_TYPE	VARCHAR2(255) NULL,
-- 	C6_LABEL	VARCHAR2(255) NULL,
-- 	C7_LAST_UPDATED	DATE NULL,
-- 	C8_LENGTH	NUMBER NULL,
-- 	C9_MAX	VARCHAR2(255) NULL,
-- 	C10_MIN	VARCHAR2(255) NULL,
-- 	C11_NAME	VARCHAR2(255) NULL,
-- 	C12_REGEXP	VARCHAR2(255) NULL,
-- 	C13_REQUIRED_BY_LAB	NUMBER NULL,
-- 	C14_SELECTION_TEMPLATE_ID	NUMBER NULL,
-- 	C15_TARGET	VARCHAR2(255) NULL,
-- 	C16_TYPE	VARCHAR2(255) NULL,
-- 	C17_UPDATED_BY	VARCHAR2(255) NULL,
-- 	C18_SORT_SEQUENCE	NUMBER NULL
-- )
-- NOLOGGING

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 6 */
-- /* Load data */

-- /* SOURCE CODE */


-- select	
-- 	SELECTION_FIELD.ID	   C1_ID,
-- 	SELECTION_FIELD.CREATED_BY	   C2_CREATED_BY,
-- 	SELECTION_FIELD.DATE_CREATED	   C3_DATE_CREATED,
-- 	SELECTION_FIELD.DEFAULT_VALUE	   C4_DEFAULT_VALUE,
-- 	SELECTION_FIELD.LAB_TYPE	   C5_LAB_TYPE,
-- 	SELECTION_FIELD.LABEL	   C6_LABEL,
-- 	SELECTION_FIELD.LAST_UPDATED	   C7_LAST_UPDATED,
-- 	SELECTION_FIELD.LENGTH	   C8_LENGTH,
-- 	SELECTION_FIELD.MAX	   C9_MAX,
-- 	SELECTION_FIELD.MIN	   C10_MIN,
-- 	SELECTION_FIELD.NAME	   C11_NAME,
-- 	SELECTION_FIELD.REGEXP	   C12_REGEXP,
-- 	SELECTION_FIELD.REQUIRED_BY_LAB	   C13_REQUIRED_BY_LAB,
-- 	SELECTION_FIELD.SELECTION_TEMPLATE_ID	   C14_SELECTION_TEMPLATE_ID,
-- 	SELECTION_FIELD.TARGET	   C15_TARGET,
-- 	SELECTION_FIELD.TYPE	   C16_TYPE,
-- 	SELECTION_FIELD.UPDATED_BY	   C17_UPDATED_BY,
-- 	SELECTION_FIELD.SORT_SEQUENCE	   C18_SORT_SEQUENCE
-- from	ITEM_MASTER_OWN.SELECTION_FIELD   SELECTION_FIELD
-- where	(1=1)
-- And (SELECTION_FIELD.LAST_UPDATED >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap)







-- -- &

-- /* TARGET CODE */
-- insert /*+ append */ into RAX_APP_USER.C$_0IM_SELECTION_FIELD_STG
-- (
-- 	C1_ID,
-- 	C2_CREATED_BY,
-- 	C3_DATE_CREATED,
-- 	C4_DEFAULT_VALUE,
-- 	C5_LAB_TYPE,
-- 	C6_LABEL,
-- 	C7_LAST_UPDATED,
-- 	C8_LENGTH,
-- 	C9_MAX,
-- 	C10_MIN,
-- 	C11_NAME,
-- 	C12_REGEXP,
-- 	C13_REQUIRED_BY_LAB,
-- 	C14_SELECTION_TEMPLATE_ID,
-- 	C15_TARGET,
-- 	C16_TYPE,
-- 	C17_UPDATED_BY,
-- 	C18_SORT_SEQUENCE
-- )
-- values
-- (
-- 	:C1_ID,
-- 	:C2_CREATED_BY,
-- 	:C3_DATE_CREATED,
-- 	:C4_DEFAULT_VALUE,
-- 	:C5_LAB_TYPE,
-- 	:C6_LABEL,
-- 	:C7_LAST_UPDATED,
-- 	:C8_LENGTH,
-- 	:C9_MAX,
-- 	:C10_MIN,
-- 	:C11_NAME,
-- 	:C12_REGEXP,
-- 	:C13_REQUIRED_BY_LAB,
-- 	:C14_SELECTION_TEMPLATE_ID,
-- 	:C15_TARGET,
-- 	:C16_TYPE,
-- 	:C17_UPDATED_BY,
-- 	:C18_SORT_SEQUENCE
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0IM_SELECTION_FIELD_STG',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;




&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Drop flow table */

-- drop table RAX_APP_USER.I$_IM_SELECTION_FIELD_STG 
BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_IM_SELECTION_FIELD_STG ';  
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

create table RAX_APP_USER.I$_IM_SELECTION_FIELD_STG
(
	ID	NUMBER NULL,
	CREATED_BY	VARCHAR2(255) NULL,
	DATE_CREATED	DATE NULL,
	DEFAULT_VALUE	VARCHAR2(255) NULL,
	LAB_TYPE	VARCHAR2(255) NULL,
	LABEL	VARCHAR2(255) NULL,
	LAST_UPDATED	DATE NULL,
	LENGTH	NUMBER NULL,
	MAX	VARCHAR2(255) NULL,
	MIN	VARCHAR2(255) NULL,
	NAME	VARCHAR2(255) NULL,
	REGEXP	VARCHAR2(255) NULL,
	REQUIRED_BY_LAB	NUMBER NULL,
	SELECTION_TEMPLATE_ID	NUMBER NULL,
	TARGET	VARCHAR2(255) NULL,
	TYPE	VARCHAR2(255) NULL,
	UPDATED_BY	VARCHAR2(255) NULL,
	SORT_SEQUENCE	NUMBER NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Insert flow into I$ table */

insert /*+ APPEND */  into RAX_APP_USER.I$_IM_SELECTION_FIELD_STG
	(
	ID,
	CREATED_BY,
	DATE_CREATED,
	DEFAULT_VALUE,
	LAB_TYPE,
	LABEL,
	LAST_UPDATED,
	LENGTH,
	MAX,
	MIN,
	NAME,
	REGEXP,
	REQUIRED_BY_LAB,
	SELECTION_TEMPLATE_ID,
	TARGET,
	TYPE,
	UPDATED_BY,
	SORT_SEQUENCE
	,IND_UPDATE
	)


select 	 
	
	C1_ID,
	C2_CREATED_BY,
	C3_DATE_CREATED,
	C4_DEFAULT_VALUE,
	C5_LAB_TYPE,
	C6_LABEL,
	C7_LAST_UPDATED,
	C8_LENGTH,
	C9_MAX,
	C10_MIN,
	C11_NAME,
	C12_REGEXP,
	C13_REQUIRED_BY_LAB,
	C14_SELECTION_TEMPLATE_ID,
	C15_TARGET,
	C16_TYPE,
	C17_UPDATED_BY,
	C18_SORT_SEQUENCE,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0IM_SELECTION_FIELD_STG
where	(1=1)






minus
select
	ID,
	CREATED_BY,
	DATE_CREATED,
	DEFAULT_VALUE,
	LAB_TYPE,
	LABEL,
	LAST_UPDATED,
	LENGTH,
	MAX,
	MIN,
	NAME,
	REGEXP,
	REQUIRED_BY_LAB,
	SELECTION_TEMPLATE_ID,
	TARGET,
	TYPE,
	UPDATED_BY,
	SORT_SEQUENCE
	,'I'	IND_UPDATE
from	ODS_STAGE.IM_SELECTION_FIELD_STG

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_IM_SELECTION_FIELD_STG',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Create Index on flow table */

-- create index	RAX_APP_USER.I$_IM_SELECTION_FIELD_STG_IDX
-- on		RAX_APP_USER.I$_IM_SELECTION_FIELD_STG (ID)
-- NOLOGGING

BEGIN
   EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_IM_SELECTION_FIELD_STG_IDX on RAX_APP_USER.I$_IM_SELECTION_FIELD_STG (ID) NOLOGGING';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -955 THEN
         RAISE;
      END IF;
END;

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
and	ORIGIN 		= '(2473001)ODS_Project.LOAD_IM_SELECTION_FIELD_STG_INT'
and	ERR_TYPE 		= 'F'


&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* create error table */




BEGIN
   EXECUTE IMMEDIATE '  
            create table RAX_APP_USER.E$_IM_SELECTION_FIELD_STG
			(
				ODI_ROW_ID 		UROWID,
				ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
				ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
				ODI_CHECK_DATE	DATE NULL, 
				ID	NUMBER NULL,
				CREATED_BY	VARCHAR2(255) NULL,
				DATE_CREATED	DATE NULL,
				DEFAULT_VALUE	VARCHAR2(255) NULL,
				LAB_TYPE	VARCHAR2(255) NULL,
				LABEL	VARCHAR2(255) NULL,
				LAST_UPDATED	DATE NULL,
				LENGTH	NUMBER NULL,
				MAX	VARCHAR2(255) NULL,
				MIN	VARCHAR2(255) NULL,
				NAME	VARCHAR2(255) NULL,
				REGEXP	VARCHAR2(255) NULL,
				REQUIRED_BY_LAB	NUMBER NULL,
				SELECTION_TEMPLATE_ID	NUMBER NULL,
				TARGET	VARCHAR2(255) NULL,
				TYPE	VARCHAR2(255) NULL,
				UPDATED_BY	VARCHAR2(255) NULL,
				SORT_SEQUENCE	NUMBER NULL,
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

delete from 	RAX_APP_USER.E$_IM_SELECTION_FIELD_STG
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(2473001)ODS_Project.LOAD_IM_SELECTION_FIELD_STG_INT')


&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Create index on AK */

 
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */
-- create index 	IM_SELECTION_FIELD_STG_PK_flow
-- on	RAX_APP_USER.I$_IM_SELECTION_FIELD_STG 
-- 	(ID)
BEGIN
   EXECUTE IMMEDIATE 'create index IM_SELECTION_FIELD_STG_PK_flow on RAX_APP_USER.I$_IM_SELECTION_FIELD_STG (ID)';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -955 and SQLCODE != -1408  and SQLCODE != -06512 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* insert AK errors */

insert into RAX_APP_USER.E$_IM_SELECTION_FIELD_STG
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
	CREATED_BY,
	DATE_CREATED,
	DEFAULT_VALUE,
	LAB_TYPE,
	LABEL,
	LAST_UPDATED,
	LENGTH,
	MAX,
	MIN,
	NAME,
	REGEXP,
	REQUIRED_BY_LAB,
	SELECTION_TEMPLATE_ID,
	TARGET,
	TYPE,
	UPDATED_BY,
	SORT_SEQUENCE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15063: The alternate key IM_SELECTION_FIELD_STG_PK is not unique.',
	'(2473001)ODS_Project.LOAD_IM_SELECTION_FIELD_STG_INT',
	sysdate,
	'IM_SELECTION_FIELD_STG_PK',
	'AK',	
	IM_SELECTION_FIELD_STG.ID,
	IM_SELECTION_FIELD_STG.CREATED_BY,
	IM_SELECTION_FIELD_STG.DATE_CREATED,
	IM_SELECTION_FIELD_STG.DEFAULT_VALUE,
	IM_SELECTION_FIELD_STG.LAB_TYPE,
	IM_SELECTION_FIELD_STG.LABEL,
	IM_SELECTION_FIELD_STG.LAST_UPDATED,
	IM_SELECTION_FIELD_STG.LENGTH,
	IM_SELECTION_FIELD_STG.MAX,
	IM_SELECTION_FIELD_STG.MIN,
	IM_SELECTION_FIELD_STG.NAME,
	IM_SELECTION_FIELD_STG.REGEXP,
	IM_SELECTION_FIELD_STG.REQUIRED_BY_LAB,
	IM_SELECTION_FIELD_STG.SELECTION_TEMPLATE_ID,
	IM_SELECTION_FIELD_STG.TARGET,
	IM_SELECTION_FIELD_STG.TYPE,
	IM_SELECTION_FIELD_STG.UPDATED_BY,
	IM_SELECTION_FIELD_STG.SORT_SEQUENCE,
	IM_SELECTION_FIELD_STG.ODS_CREATE_DATE,
	IM_SELECTION_FIELD_STG.ODS_MODIFY_DATE
from	RAX_APP_USER.I$_IM_SELECTION_FIELD_STG   IM_SELECTION_FIELD_STG
where	exists  (
		select	SUB.ID
		from 	RAX_APP_USER.I$_IM_SELECTION_FIELD_STG SUB
		where 	SUB.ID=IM_SELECTION_FIELD_STG.ID
		group by 	SUB.ID
		having 	count(1) > 1
		)



&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_IM_SELECTION_FIELD_STG
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
	CREATED_BY,
	DATE_CREATED,
	DEFAULT_VALUE,
	LAB_TYPE,
	LABEL,
	LAST_UPDATED,
	LENGTH,
	MAX,
	MIN,
	NAME,
	REGEXP,
	REQUIRED_BY_LAB,
	SELECTION_TEMPLATE_ID,
	TARGET,
	TYPE,
	UPDATED_BY,
	SORT_SEQUENCE,
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
	'(2473001)ODS_Project.LOAD_IM_SELECTION_FIELD_STG_INT',
	'ID',
	'NN',	
	ID,
	CREATED_BY,
	DATE_CREATED,
	DEFAULT_VALUE,
	LAB_TYPE,
	LABEL,
	LAST_UPDATED,
	LENGTH,
	MAX,
	MIN,
	NAME,
	REGEXP,
	REQUIRED_BY_LAB,
	SELECTION_TEMPLATE_ID,
	TARGET,
	TYPE,
	UPDATED_BY,
	SORT_SEQUENCE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_IM_SELECTION_FIELD_STG
where	ID is null



&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_IM_SELECTION_FIELD_STG
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
	CREATED_BY,
	DATE_CREATED,
	DEFAULT_VALUE,
	LAB_TYPE,
	LABEL,
	LAST_UPDATED,
	LENGTH,
	MAX,
	MIN,
	NAME,
	REGEXP,
	REQUIRED_BY_LAB,
	SELECTION_TEMPLATE_ID,
	TARGET,
	TYPE,
	UPDATED_BY,
	SORT_SEQUENCE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column LAB_TYPE cannot be null.',
	sysdate,
	'(2473001)ODS_Project.LOAD_IM_SELECTION_FIELD_STG_INT',
	'LAB_TYPE',
	'NN',	
	ID,
	CREATED_BY,
	DATE_CREATED,
	DEFAULT_VALUE,
	LAB_TYPE,
	LABEL,
	LAST_UPDATED,
	LENGTH,
	MAX,
	MIN,
	NAME,
	REGEXP,
	REQUIRED_BY_LAB,
	SELECTION_TEMPLATE_ID,
	TARGET,
	TYPE,
	UPDATED_BY,
	SORT_SEQUENCE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_IM_SELECTION_FIELD_STG
where	LAB_TYPE is null



&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_IM_SELECTION_FIELD_STG
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
	CREATED_BY,
	DATE_CREATED,
	DEFAULT_VALUE,
	LAB_TYPE,
	LABEL,
	LAST_UPDATED,
	LENGTH,
	MAX,
	MIN,
	NAME,
	REGEXP,
	REQUIRED_BY_LAB,
	SELECTION_TEMPLATE_ID,
	TARGET,
	TYPE,
	UPDATED_BY,
	SORT_SEQUENCE,
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
	'(2473001)ODS_Project.LOAD_IM_SELECTION_FIELD_STG_INT',
	'LABEL',
	'NN',	
	ID,
	CREATED_BY,
	DATE_CREATED,
	DEFAULT_VALUE,
	LAB_TYPE,
	LABEL,
	LAST_UPDATED,
	LENGTH,
	MAX,
	MIN,
	NAME,
	REGEXP,
	REQUIRED_BY_LAB,
	SELECTION_TEMPLATE_ID,
	TARGET,
	TYPE,
	UPDATED_BY,
	SORT_SEQUENCE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_IM_SELECTION_FIELD_STG
where	LABEL is null



&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_IM_SELECTION_FIELD_STG
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
	CREATED_BY,
	DATE_CREATED,
	DEFAULT_VALUE,
	LAB_TYPE,
	LABEL,
	LAST_UPDATED,
	LENGTH,
	MAX,
	MIN,
	NAME,
	REGEXP,
	REQUIRED_BY_LAB,
	SELECTION_TEMPLATE_ID,
	TARGET,
	TYPE,
	UPDATED_BY,
	SORT_SEQUENCE,
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
	'(2473001)ODS_Project.LOAD_IM_SELECTION_FIELD_STG_INT',
	'NAME',
	'NN',	
	ID,
	CREATED_BY,
	DATE_CREATED,
	DEFAULT_VALUE,
	LAB_TYPE,
	LABEL,
	LAST_UPDATED,
	LENGTH,
	MAX,
	MIN,
	NAME,
	REGEXP,
	REQUIRED_BY_LAB,
	SELECTION_TEMPLATE_ID,
	TARGET,
	TYPE,
	UPDATED_BY,
	SORT_SEQUENCE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_IM_SELECTION_FIELD_STG
where	NAME is null



&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_IM_SELECTION_FIELD_STG
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
	CREATED_BY,
	DATE_CREATED,
	DEFAULT_VALUE,
	LAB_TYPE,
	LABEL,
	LAST_UPDATED,
	LENGTH,
	MAX,
	MIN,
	NAME,
	REGEXP,
	REQUIRED_BY_LAB,
	SELECTION_TEMPLATE_ID,
	TARGET,
	TYPE,
	UPDATED_BY,
	SORT_SEQUENCE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column REQUIRED_BY_LAB cannot be null.',
	sysdate,
	'(2473001)ODS_Project.LOAD_IM_SELECTION_FIELD_STG_INT',
	'REQUIRED_BY_LAB',
	'NN',	
	ID,
	CREATED_BY,
	DATE_CREATED,
	DEFAULT_VALUE,
	LAB_TYPE,
	LABEL,
	LAST_UPDATED,
	LENGTH,
	MAX,
	MIN,
	NAME,
	REGEXP,
	REQUIRED_BY_LAB,
	SELECTION_TEMPLATE_ID,
	TARGET,
	TYPE,
	UPDATED_BY,
	SORT_SEQUENCE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_IM_SELECTION_FIELD_STG
where	REQUIRED_BY_LAB is null



&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_IM_SELECTION_FIELD_STG
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
	CREATED_BY,
	DATE_CREATED,
	DEFAULT_VALUE,
	LAB_TYPE,
	LABEL,
	LAST_UPDATED,
	LENGTH,
	MAX,
	MIN,
	NAME,
	REGEXP,
	REQUIRED_BY_LAB,
	SELECTION_TEMPLATE_ID,
	TARGET,
	TYPE,
	UPDATED_BY,
	SORT_SEQUENCE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column SELECTION_TEMPLATE_ID cannot be null.',
	sysdate,
	'(2473001)ODS_Project.LOAD_IM_SELECTION_FIELD_STG_INT',
	'SELECTION_TEMPLATE_ID',
	'NN',	
	ID,
	CREATED_BY,
	DATE_CREATED,
	DEFAULT_VALUE,
	LAB_TYPE,
	LABEL,
	LAST_UPDATED,
	LENGTH,
	MAX,
	MIN,
	NAME,
	REGEXP,
	REQUIRED_BY_LAB,
	SELECTION_TEMPLATE_ID,
	TARGET,
	TYPE,
	UPDATED_BY,
	SORT_SEQUENCE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_IM_SELECTION_FIELD_STG
where	SELECTION_TEMPLATE_ID is null



&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_IM_SELECTION_FIELD_STG
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
	CREATED_BY,
	DATE_CREATED,
	DEFAULT_VALUE,
	LAB_TYPE,
	LABEL,
	LAST_UPDATED,
	LENGTH,
	MAX,
	MIN,
	NAME,
	REGEXP,
	REQUIRED_BY_LAB,
	SELECTION_TEMPLATE_ID,
	TARGET,
	TYPE,
	UPDATED_BY,
	SORT_SEQUENCE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column TARGET cannot be null.',
	sysdate,
	'(2473001)ODS_Project.LOAD_IM_SELECTION_FIELD_STG_INT',
	'TARGET',
	'NN',	
	ID,
	CREATED_BY,
	DATE_CREATED,
	DEFAULT_VALUE,
	LAB_TYPE,
	LABEL,
	LAST_UPDATED,
	LENGTH,
	MAX,
	MIN,
	NAME,
	REGEXP,
	REQUIRED_BY_LAB,
	SELECTION_TEMPLATE_ID,
	TARGET,
	TYPE,
	UPDATED_BY,
	SORT_SEQUENCE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_IM_SELECTION_FIELD_STG
where	TARGET is null



&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_IM_SELECTION_FIELD_STG
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
	CREATED_BY,
	DATE_CREATED,
	DEFAULT_VALUE,
	LAB_TYPE,
	LABEL,
	LAST_UPDATED,
	LENGTH,
	MAX,
	MIN,
	NAME,
	REGEXP,
	REQUIRED_BY_LAB,
	SELECTION_TEMPLATE_ID,
	TARGET,
	TYPE,
	UPDATED_BY,
	SORT_SEQUENCE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column TYPE cannot be null.',
	sysdate,
	'(2473001)ODS_Project.LOAD_IM_SELECTION_FIELD_STG_INT',
	'TYPE',
	'NN',	
	ID,
	CREATED_BY,
	DATE_CREATED,
	DEFAULT_VALUE,
	LAB_TYPE,
	LABEL,
	LAST_UPDATED,
	LENGTH,
	MAX,
	MIN,
	NAME,
	REGEXP,
	REQUIRED_BY_LAB,
	SELECTION_TEMPLATE_ID,
	TARGET,
	TYPE,
	UPDATED_BY,
	SORT_SEQUENCE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_IM_SELECTION_FIELD_STG
where	TYPE is null



&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* create index on error table */

 
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */
-- create index 	RAX_APP_USER.E$_IM_SELECTION_FIELD_STG_IDX
-- on	RAX_APP_USER.E$_IM_SELECTION_FIELD_STG (ODI_ROW_ID)

BEGIN
   EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_IM_SELECTION_FIELD_STG_IDX on RAX_APP_USER.E$_IM_SELECTION_FIELD_STG (ODI_ROW_ID)';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -955 THEN
         RAISE;
      END IF;
END;


&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* delete errors from controlled table */

delete from	RAX_APP_USER.I$_IM_SELECTION_FIELD_STG  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_IM_SELECTION_FIELD_STG E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)


&


/*-----------------------------------------------*/
/* TASK No. 30 */
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
	'IM_SELECTION_FIELD_STG',
	'ODS_STAGE.IM_SELECTION_FIELD_STG',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_IM_SELECTION_FIELD_STG E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(2473001)ODS_Project.LOAD_IM_SELECTION_FIELD_STG_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE


&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* Merge Rows */

merge into	ODS_STAGE.IM_SELECTION_FIELD_STG T
using	RAX_APP_USER.I$_IM_SELECTION_FIELD_STG S
on	(
		T.ID=S.ID
	)
when matched
then update set
	T.CREATED_BY	= S.CREATED_BY,
	T.DATE_CREATED	= S.DATE_CREATED,
	T.DEFAULT_VALUE	= S.DEFAULT_VALUE,
	T.LAB_TYPE	= S.LAB_TYPE,
	T.LABEL	= S.LABEL,
	T.LAST_UPDATED	= S.LAST_UPDATED,
	T.LENGTH	= S.LENGTH,
	T.MAX	= S.MAX,
	T.MIN	= S.MIN,
	T.NAME	= S.NAME,
	T.REGEXP	= S.REGEXP,
	T.REQUIRED_BY_LAB	= S.REQUIRED_BY_LAB,
	T.SELECTION_TEMPLATE_ID	= S.SELECTION_TEMPLATE_ID,
	T.TARGET	= S.TARGET,
	T.TYPE	= S.TYPE,
	T.UPDATED_BY	= S.UPDATED_BY,
	T.SORT_SEQUENCE	= S.SORT_SEQUENCE
	,                 T.ODS_MODIFY_DATE	= sysdate
when not matched
then insert
	(
	T.ID,
	T.CREATED_BY,
	T.DATE_CREATED,
	T.DEFAULT_VALUE,
	T.LAB_TYPE,
	T.LABEL,
	T.LAST_UPDATED,
	T.LENGTH,
	T.MAX,
	T.MIN,
	T.NAME,
	T.REGEXP,
	T.REQUIRED_BY_LAB,
	T.SELECTION_TEMPLATE_ID,
	T.TARGET,
	T.TYPE,
	T.UPDATED_BY,
	T.SORT_SEQUENCE
	,                  T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.ID,
	S.CREATED_BY,
	S.DATE_CREATED,
	S.DEFAULT_VALUE,
	S.LAB_TYPE,
	S.LABEL,
	S.LAST_UPDATED,
	S.LENGTH,
	S.MAX,
	S.MIN,
	S.NAME,
	S.REGEXP,
	S.REQUIRED_BY_LAB,
	S.SELECTION_TEMPLATE_ID,
	S.TARGET,
	S.TYPE,
	S.UPDATED_BY,
	S.SORT_SEQUENCE
	,                  sysdate,
	sysdate
	)

&


/*-----------------------------------------------*/
/* TASK No. 32 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 33 */
/* Drop flow table */

-- drop table RAX_APP_USER.I$_IM_SELECTION_FIELD_STG 
BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_IM_SELECTION_FIELD_STG';  
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

-- drop table RAX_APP_USER.C$_0IM_SELECTION_FIELD_STG purge
BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0IM_SELECTION_FIELD_STG purge';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 34 */
/* merge into ods_stage.im_selection_field_xr */

merge into ods_stage.im_selection_field_xr t
using (
      select id, selection_template_id
      from ods_stage.im_selection_field_stg
      where ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap 
)s
on (s.id = t.id)
when matched then 
update 
set
  t.selection_template_id = s.selection_template_id
where t.selection_template_id <> s.selection_template_id
when not matched then 
insert 
(
 t.selection_field_oid
,t.id
,t.selection_template_id
,t.ods_create_date
,t.ods_modify_date
)
values
(
ods_stage.selection_field_oid_seq.nextval
,s.id
,s.selection_template_id
,sysdate
,sysdate
)


&


/*-----------------------------------------------*/
/* TASK No. 35 */
/* merge into ods_own.selection_field */

merge into ods_own.selection_field t
using(
  select stg.default_value, stg.lab_type, stg.label, stg.last_updated, stg.length, stg.max, stg.min, stg.name, stg.regexp, stg.required_by_lab,  stg.selection_template_id, stg.target, stg.type, stg.updated_by, stg.sort_sequence, xr.selection_field_oid, ss.source_system_oid
  from ods_stage.im_selection_field_stg stg, ods_stage.im_selection_field_xr xr, ods_own.source_system ss
  where stg.id = xr.id
   and ss.source_system_short_name = 'IM'
  and stg.ods_modify_date>= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap
)s
on (t.selection_field_oid = s.selection_field_oid)
when matched then update
set t.default_value = s.default_value
, t.lab_type = s.lab_type
, t.label = s.label
, t.last_updated = s.last_updated
, t.length = s.length
, t.max = s.max
, t.min = s.min
, t.name = s.name
, t.regexp = s.regexp
, t.required_by_lab = s.required_by_lab
, t.selection_template_id = s.selection_template_id
, t.target = s.target
, t.type = s.type
, t.updated_by = s.updated_by
, t.sort_sequence = s.sort_sequence
, t.ods_modify_date = sysdate
where decode (s.default_value, t.default_value, 1, 0) = 0 
or t.lab_type <> s.lab_type
or t.label <> s.label
or t.last_updated <> s.last_updated or (t.last_updated is null and s.last_updated  is not null)
or decode (s.length, t.length, 1, 0) = 0 
or decode (s.max, t.max, 1, 0) = 0 
or decode (s.min, t.min, 1, 0) = 0  
or t.name <> s.name
or decode (s.regexp, t.regexp, 1, 0) = 0  
or t.required_by_lab <> s.required_by_lab
or t.selection_template_id <> s.selection_template_id
or t.target <> s.target
or t.type <> s.type
or decode (s.updated_by, t.updated_by, 1, 0) = 0 
or decode (s.sort_sequence, t.sort_sequence, 1, 0) = 0  
when not matched then 
insert 
(
 t.selection_field_oid
, t.default_value
, t.lab_type
, t.label
, t.last_updated
, t.length
, t.max
, t.min
, t.name
, t.regexp
, t.required_by_lab 
, t.selection_template_id 
, t.target
, t.type
, t.updated_by
, t.sort_sequence
, t.source_system_oid
, t.ods_create_date
, t.ods_modify_date
)
values
(
 s.selection_field_oid
, s.default_value
, s.lab_type
, s.label
, s.last_updated
, s.length
, s.max
, s.min
, s.name
, s.regexp
, s.required_by_lab 
, s.selection_template_id 
, s.target
, s.type
, s.updated_by
, s.sort_sequence
, s.source_system_oid
, sysdate
, sysdate
)

&


/*-----------------------------------------------*/
/* TASK No. 36 */
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
/* TASK No. 37 */
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
,'LOAD_IM_SELECTION_FIELD_PKG'
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
'LOAD_IM_SELECTION_FIELD_PKG',
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
