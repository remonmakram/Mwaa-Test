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
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 4 */




/*-----------------------------------------------*/
/* TASK No. 5 */
/* Drop flow table */

--drop table RAX_APP_USER.I$_MFG_ITEM_MERCH_XR2122001 

BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_MFG_ITEM_MERCH_XR2122001';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_MFG_ITEM_MERCH_XR2122001
(
	MFG_ITEM_MERCH_ITEM_OID	NUMBER NULL,
	ID	NUMBER NULL,
	MERCH_ITEM_ID	VARCHAR2(255) NULL,
	ITEM_ID	VARCHAR2(255) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_MFG_ITEM_MERCH_XR2122001
(
	ID,
	MERCH_ITEM_ID,
	ITEM_ID,
	IND_UPDATE
)
select 
ID,
	MERCH_ITEM_ID,
	ITEM_ID,
	IND_UPDATE
 from (


select 	 
	
	MIC_ITEM_MERCH_STG.ID ID,
	MIC_ITEM_MERCH_STG.MERCH_ITEM_ID MERCH_ITEM_ID,
	MIC_ITEM_MERCH_STG.ITEM_ID ITEM_ID,

	'I' IND_UPDATE

from	ODS_STAGE.MIC_ITEM_MERCH_ITEM_STG   MIC_ITEM_MERCH_STG, ODS_STAGE.MFG_ITEM_MERCH_ITEM_XR   MFG_ITEM_MERCH_ITEM_XR
where	(1=1)
 And (MIC_ITEM_MERCH_STG.ID=MFG_ITEM_MERCH_ITEM_XR.ID(+)
AND MFG_ITEM_MERCH_ITEM_XR.ID IS NULL)
And (MIC_ITEM_MERCH_STG.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap)




) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.MFG_ITEM_MERCH_ITEM_XR T
	where	T.ID	= S.ID 
		 and ((T.MERCH_ITEM_ID = S.MERCH_ITEM_ID) or (T.MERCH_ITEM_ID IS NULL and S.MERCH_ITEM_ID IS NULL)) and
		((T.ITEM_ID = S.ITEM_ID) or (T.ITEM_ID IS NULL and S.ITEM_ID IS NULL))
        )

  
  

  



&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_MFG_ITEM_MERCH_XR2122001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Create Index on flow table */

-- create index	RAX_APP_USER.I$_MFG_ITEM_MERCH_XR_IDX2122001
-- on		RAX_APP_USER.I$_MFG_ITEM_MERCH_XR2122001 (ID)
-- NOLOGGING
BEGIN
   EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_MFG_ITEM_MERCH_XR_IDX2122001 on RAX_APP_USER.I$_MFG_ITEM_MERCH_XR2122001 (ID) NOLOGGING';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -972 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Merge Rows */

merge into	ODS_STAGE.MFG_ITEM_MERCH_ITEM_XR T
using	RAX_APP_USER.I$_MFG_ITEM_MERCH_XR2122001 S
on	(
		T.ID=S.ID
	)
when matched
then update set
	T.MERCH_ITEM_ID	= S.MERCH_ITEM_ID,
	T.ITEM_ID	= S.ITEM_ID
	,  T.ODS_MODIFY_DATE	= SYSDATE
when not matched
then insert
	(
	T.ID,
	T.MERCH_ITEM_ID,
	T.ITEM_ID
	,   T.MFG_ITEM_MERCH_ITEM_OID,
	T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.ID,
	S.MERCH_ITEM_ID,
	S.ITEM_ID
	,   ODS_STAGE.MFG_ITEM_MERCH_ITEM_OID_SEQ.nextval,
	SYSDATE,
	SYSDATE
	)

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Drop flow table */

drop table RAX_APP_USER.I$_MFG_ITEM_MERCH_XR2122001 

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 13 */




/*-----------------------------------------------*/
/* TASK No. 14 */
/* Drop flow table */

--drop table RAX_APP_USER.I$_MFG_ITEM_MERCH_ITEM2118001 

BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_MFG_ITEM_MERCH_ITEM2118001';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_MFG_ITEM_MERCH_ITEM2118001
(
	MFG_ITEM_MERCH_ITEM_OID	NUMBER NULL,
	ID	NUMBER NULL,
	MERCH_ITEM_ID	VARCHAR2(255) NULL,
	ITEM_ID	VARCHAR2(255) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	SOURCE_SYSTEM_OID	NUMBER NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_MFG_ITEM_MERCH_ITEM2118001
(
	MFG_ITEM_MERCH_ITEM_OID,
	ID,
	MERCH_ITEM_ID,
	ITEM_ID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID,
	IND_UPDATE
)
select 
MFG_ITEM_MERCH_ITEM_OID,
	ID,
	MERCH_ITEM_ID,
	ITEM_ID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID,
	IND_UPDATE
 from (


select 	 
	
	MFG_ITEM_MERCH_ITEM_XR1.MFG_ITEM_MERCH_ITEM_OID MFG_ITEM_MERCH_ITEM_OID,
	MIC_ITEM_MERCH_STG.ID ID,
	MIC_ITEM_MERCH_STG.MERCH_ITEM_ID MERCH_ITEM_ID,
	MIC_ITEM_MERCH_STG.ITEM_ID ITEM_ID,
	SYSDATE ODS_CREATE_DATE,
	SYSDATE ODS_MODIFY_DATE,
	SOURCE_SYSTEM.SOURCE_SYSTEM_OID SOURCE_SYSTEM_OID,

	'I' IND_UPDATE

from	ODS_STAGE.MFG_ITEM_MERCH_ITEM_XR   MFG_ITEM_MERCH_ITEM_XR1, ODS_OWN.SOURCE_SYSTEM   SOURCE_SYSTEM, ODS_STAGE.MIC_ITEM_MERCH_ITEM_STG   MIC_ITEM_MERCH_STG
where	(1=1)
 And (MIC_ITEM_MERCH_STG.ID=MFG_ITEM_MERCH_ITEM_XR1.ID (+))
And (SOURCE_SYSTEM.SOURCE_SYSTEM_SHORT_NAME = 'MI')
 And (MIC_ITEM_MERCH_STG.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap)




) S
where NOT EXISTS 
	( select 1 from ODS_OWN.MFG_ITEM_MERCH_ITEM T
	where	T.MFG_ITEM_MERCH_ITEM_OID	= S.MFG_ITEM_MERCH_ITEM_OID 
		 and ((T.ID = S.ID) or (T.ID IS NULL and S.ID IS NULL)) and
		((T.MERCH_ITEM_ID = S.MERCH_ITEM_ID) or (T.MERCH_ITEM_ID IS NULL and S.MERCH_ITEM_ID IS NULL)) and
		((T.ITEM_ID = S.ITEM_ID) or (T.ITEM_ID IS NULL and S.ITEM_ID IS NULL)) and
		((T.ODS_MODIFY_DATE = S.ODS_MODIFY_DATE) or (T.ODS_MODIFY_DATE IS NULL and S.ODS_MODIFY_DATE IS NULL)) and
		((T.SOURCE_SYSTEM_OID = S.SOURCE_SYSTEM_OID) or (T.SOURCE_SYSTEM_OID IS NULL and S.SOURCE_SYSTEM_OID IS NULL))
        )

  
  

  



&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_MFG_ITEM_MERCH_ITEM2118001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Create Index on flow table */

-- create index	RAX_APP_USER.I$_MFG_ITEM_MERCH_ITEM_IDX2118001
-- on		RAX_APP_USER.I$_MFG_ITEM_MERCH_ITEM2118001 (MFG_ITEM_MERCH_ITEM_OID)
-- NOLOGGING
BEGIN
   EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_MFG_ITEM_MERCH_ITEM_IDX2118001 on RAX_APP_USER.I$_MFG_ITEM_MERCH_ITEM2118001 (MFG_ITEM_MERCH_ITEM_OID) NOLOGGING';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -972 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* create check table */


DECLARE  
    table_exists NUMBER;  
BEGIN  
    -- Check if the table exists  
    SELECT COUNT(*)  
    INTO table_exists  
    FROM all_tables  
    WHERE table_name = 'SNP_CHECK_TAB' AND owner = 'RAX_APP_USER';  
  
    -- If the table does not exist, create it  
    IF table_exists = 0 THEN  
        EXECUTE IMMEDIATE '  
            CREATE TABLE RAX_APP_USER.SNP_CHECK_TAB (  
                CATALOG_NAME  VARCHAR2(100 CHAR) NULL,  
                SCHEMA_NAME   VARCHAR2(100 CHAR) NULL,  
                RESOURCE_NAME VARCHAR2(100 CHAR) NULL,  
                FULL_RES_NAME VARCHAR2(100 CHAR) NULL,  
                ERR_TYPE      VARCHAR2(1 CHAR) NULL,  
                ERR_MESS      VARCHAR2(250 CHAR) NULL,  
                CHECK_DATE    DATE NULL,  
                ORIGIN        VARCHAR2(100 CHAR) NULL,  
                CONS_NAME     VARCHAR2(35 CHAR) NULL,  
                CONS_TYPE     VARCHAR2(2 CHAR) NULL,  
                ERR_COUNT     NUMBER(10) NULL  
            )  
        ';  
    END IF;  
END;
	

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* delete previous check sum */

delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS_OWN'
and	ORIGIN 		= '(2118001)ODS_Project.LOAD_MFG_ITEM_MERCH_ITEM_INT'
and	ERR_TYPE 		= 'F'


&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* create error table */


-- create table RAX_APP_USER.E$_MFG_ITEM_MERCH_ITEM2118001
-- (
-- 	ODI_ROW_ID 		UROWID,
-- 	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
-- 	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
-- 	ODI_CHECK_DATE	DATE NULL, 
-- 	MFG_ITEM_MERCH_ITEM_OID	NUMBER NULL,
-- 	ID	NUMBER NULL,
-- 	MERCH_ITEM_ID	VARCHAR2(255) NULL,
-- 	ITEM_ID	VARCHAR2(255) NULL,
-- 	ODS_CREATE_DATE	DATE NULL,
-- 	ODS_MODIFY_DATE	DATE NULL,
-- 	SOURCE_SYSTEM_OID	NUMBER NULL,
-- 	ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
-- 	ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
-- 	ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
-- 	ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
-- 	ODI_SESS_NO		VARCHAR2(19 CHAR)
-- )

DECLARE  
    table_exists NUMBER;  
BEGIN  
    -- Check if the table exists  
    SELECT COUNT(*)  
    INTO table_exists  
    FROM all_tables  
    WHERE table_name = 'E$_MFG_ITEM_MERCH_ITEM2118001' AND owner = 'RAX_APP_USER';  
  
    -- If the table does not exist, create it  
    IF table_exists = 0 THEN  
        EXECUTE IMMEDIATE '  
            create table RAX_APP_USER.E$_MFG_ITEM_MERCH_ITEM2118001
			(
				ODI_ROW_ID 		UROWID,
				ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
				ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
				ODI_CHECK_DATE	DATE NULL, 
				MFG_ITEM_MERCH_ITEM_OID	NUMBER NULL,
				ID	NUMBER NULL,
				MERCH_ITEM_ID	VARCHAR2(255) NULL,
				ITEM_ID	VARCHAR2(255) NULL,
				ODS_CREATE_DATE	DATE NULL,
				ODS_MODIFY_DATE	DATE NULL,
				SOURCE_SYSTEM_OID	NUMBER NULL,
				ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
				ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
				ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
				ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
				ODI_SESS_NO		VARCHAR2(19 CHAR)
			)  
        ';  
    END IF;  
END;



&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* delete previous errors */

delete from 	RAX_APP_USER.E$_MFG_ITEM_MERCH_ITEM2118001
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(2118001)ODS_Project.LOAD_MFG_ITEM_MERCH_ITEM_INT')


&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Create index on PK */

 
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */
-- create index 	RAX_APP_USER.I$_MFG_ITEM_MERCH_ITEM2118001
-- on	RAX_APP_USER.I$_MFG_ITEM_MERCH_ITEM2118001 (MFG_ITEM_MERCH_ITEM_OID)
DECLARE  
    index_exists NUMBER;  
BEGIN  
    -- Check if there is an index on the specified column  
    SELECT COUNT(*)  
    INTO index_exists  
    FROM all_ind_columns  
    WHERE table_name = 'I$_MFG_ITEM_MERCH_ITEM2118001'
      	AND column_name = 'MFG_ITEM_MERCH_ITEM_OID'  
      	AND index_owner = 'RAX_APP_USER';  
  
    -- If no such index exists, create the index  
    IF index_exists = 0 THEN  
        EXECUTE IMMEDIATE '  
            create index 	RAX_APP_USER.I$_MFG_ITEM_MERCH_ITEM2118001
			on	RAX_APP_USER.I$_MFG_ITEM_MERCH_ITEM2118001 (MFG_ITEM_MERCH_ITEM_OID)
        ';  
    END IF;  
END;


&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* insert PK errors */

DECLARE
               CheckTable                             VarChar2(60);
               TargetTable                            VarChar2(60);
               VariableCheckTable                     VarChar2(60);

BEGIN
               SELECT 'RAX_APP_USER.I$_MFG_ITEM_MERCH_ITEM' INTO CheckTable FROM DUAL;
               SELECT 'ODS_OWN.MFG_ITEM_MERCH_ITEM' INTO TargetTable FROM DUAL;

IF CheckTable = TargetTable THEN
   VariableCheckTable := CheckTable; 
ELSE
   VariableCheckTable := CheckTable || '2118001';
END IF;

execute immediate '
insert into RAX_APP_USER.E$_MFG_ITEM_MERCH_ITEM2118001
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
	MFG_ITEM_MERCH_ITEM_OID,
	ID,
	MERCH_ITEM_ID,
	ITEM_ID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID
)
select	SYS_GUID(),
	29842372200, 
	rowid,
	''F'', 
	''ODI-15064: The primary key MFG_ITEM_MERCH_ITEM_PK is not unique.'',
	''(2118001)ODS_Project.LOAD_MFG_ITEM_MERCH_ITEM_INT'',
	sysdate,
	''MFG_ITEM_MERCH_ITEM_PK'',
	''PK'',	
	MFG_ITEM_MERCH_ITEM.MFG_ITEM_MERCH_ITEM_OID,
	MFG_ITEM_MERCH_ITEM.ID,
	MFG_ITEM_MERCH_ITEM.MERCH_ITEM_ID,
	MFG_ITEM_MERCH_ITEM.ITEM_ID,
	MFG_ITEM_MERCH_ITEM.ODS_CREATE_DATE,
	MFG_ITEM_MERCH_ITEM.ODS_MODIFY_DATE,
	MFG_ITEM_MERCH_ITEM.SOURCE_SYSTEM_OID
from	'
 || VariableCheckTable || 
' MFG_ITEM_MERCH_ITEM 
where	exists  (
		select	SUB1.MFG_ITEM_MERCH_ITEM_OID
		from 	' 
|| VariableCheckTable ||
'  SUB1
		where 	SUB1.MFG_ITEM_MERCH_ITEM_OID=MFG_ITEM_MERCH_ITEM.MFG_ITEM_MERCH_ITEM_OID
		group by 	SUB1.MFG_ITEM_MERCH_ITEM_OID
		having 	count(1) > 1
		)
';

END;


&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_MFG_ITEM_MERCH_ITEM2118001
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
	MFG_ITEM_MERCH_ITEM_OID,
	ID,
	MERCH_ITEM_ID,
	ITEM_ID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column ID cannot be null.',
	sysdate,
	'(2118001)ODS_Project.LOAD_MFG_ITEM_MERCH_ITEM_INT',
	'ID',
	'NN',	
	MFG_ITEM_MERCH_ITEM_OID,
	ID,
	MERCH_ITEM_ID,
	ITEM_ID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID
from	RAX_APP_USER.I$_MFG_ITEM_MERCH_ITEM2118001
where	ID is null



&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* create index on error table */

 
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */
-- create index 	RAX_APP_USER.E$_MFG_ITEM_MERCH_ITEM2118001
-- on	RAX_APP_USER.E$_MFG_ITEM_MERCH_ITEM2118001 (ODI_ROW_ID)
DECLARE  
    index_exists NUMBER;  
BEGIN  
    -- Check if there is an index on the specified column  
    SELECT COUNT(*)  
    INTO index_exists  
    FROM all_ind_columns  
    WHERE table_name = 'E$_MFG_ITEM_MERCH_ITEM2118001'
      	AND column_name = 'ODI_ROW_ID'  
      	AND index_owner = 'RAX_APP_USER';  
  
    -- If no such index exists, create the index  
    IF index_exists = 0 THEN  
        EXECUTE IMMEDIATE '  
            create index 	RAX_APP_USER.E$_MFG_ITEM_MERCH_ITEM2118001
			on	RAX_APP_USER.E$_MFG_ITEM_MERCH_ITEM2118001 (ODI_ROW_ID)
        ';  
    END IF;  
END;


&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* delete errors from controlled table */

delete from	RAX_APP_USER.I$_MFG_ITEM_MERCH_ITEM2118001  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_MFG_ITEM_MERCH_ITEM2118001 E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)


&


/*-----------------------------------------------*/
/* TASK No. 28 */
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
	'ODS_OWN',
	'MFG_ITEM_MERCH_ITEM',
	'ODS_OWN.MFG_ITEM_MERCH_ITEM2118001',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_MFG_ITEM_MERCH_ITEM2118001 E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(2118001)ODS_Project.LOAD_MFG_ITEM_MERCH_ITEM_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE


&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* Merge Rows */

merge into	ODS_OWN.MFG_ITEM_MERCH_ITEM T
using	RAX_APP_USER.I$_MFG_ITEM_MERCH_ITEM2118001 S
on	(
		T.MFG_ITEM_MERCH_ITEM_OID=S.MFG_ITEM_MERCH_ITEM_OID
	)
when matched
then update set
	T.ID	= S.ID,
	T.MERCH_ITEM_ID	= S.MERCH_ITEM_ID,
	T.ITEM_ID	= S.ITEM_ID,
	T.ODS_MODIFY_DATE	= S.ODS_MODIFY_DATE,
	T.SOURCE_SYSTEM_OID	= S.SOURCE_SYSTEM_OID
	
when not matched
then insert
	(
	T.MFG_ITEM_MERCH_ITEM_OID,
	T.ID,
	T.MERCH_ITEM_ID,
	T.ITEM_ID,
	T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE,
	T.SOURCE_SYSTEM_OID
	
	)
values
	(
	S.MFG_ITEM_MERCH_ITEM_OID,
	S.ID,
	S.MERCH_ITEM_ID,
	S.ITEM_ID,
	S.ODS_CREATE_DATE,
	S.ODS_MODIFY_DATE,
	S.SOURCE_SYSTEM_OID
	
	)

&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 31 */
/* Drop flow table */

drop table RAX_APP_USER.I$_MFG_ITEM_MERCH_ITEM2118001 

&


/*-----------------------------------------------*/
/* TASK No. 32 */
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
             SUBSTR('2024-06-04 09:55:36.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=#LIFETOUCH_PROJECT.v_cdc_load_table_name
AND CONTEXT_NAME = 'PROD'
*/

&


/*-----------------------------------------------*/
/* TASK No. 33 */
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
,'LOAD_MFG_ITEM_MERCH_ITEM_PKG'
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
#LIFETOUCH_PROJECT.v_cdc_load_table_name,
29842372200,
'LOAD_MFG_ITEM_MERCH_ITEM_PKG',
'002',
TO_DATE(
             SUBSTR('2024-06-04 09:55:36.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR ('#LIFETOUCH_PROJECT.v_cdc_load_date', 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,#LIFETOUCH_PROJECT.v_cdc_overlap,
SYSDATE,
 'PROD')
*/


&


/*-----------------------------------------------*/
