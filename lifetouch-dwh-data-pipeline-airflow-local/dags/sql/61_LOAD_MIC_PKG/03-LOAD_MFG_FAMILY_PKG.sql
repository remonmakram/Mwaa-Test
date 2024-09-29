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

--drop table RAX_APP_USER.I$_MFG_FAMILY_XR2123001 

BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_MFG_FAMILY_XR2123001';
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

create table RAX_APP_USER.I$_MFG_FAMILY_XR2123001
(
	MFG_FAMILY_OID	NUMBER NULL,
	NAME	VARCHAR2(255) NULL,
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
 


  


insert into	RAX_APP_USER.I$_MFG_FAMILY_XR2123001
(
	NAME,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	IND_UPDATE
)
select 
NAME,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	IND_UPDATE
 from (


select 	 
	
	MIC_MFG_FAMILY_STG.NAME NAME,
	SYSDATE ODS_CREATE_DATE,
	SYSDATE ODS_MODIFY_DATE,

	'I' IND_UPDATE

from	ODS_STAGE.MIC_MANUFACTURING_FAMILY_STG   MIC_MFG_FAMILY_STG, ODS_STAGE.MFG_FAMILY_XR   MFG_FAMILY_XR
where	(1=1)
 And (MIC_MFG_FAMILY_STG.NAME=MFG_FAMILY_XR.NAME(+)
AND MFG_FAMILY_XR.NAME IS NULL)
And (MIC_MFG_FAMILY_STG.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap)




) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.MFG_FAMILY_XR T
	where	T.NAME	= S.NAME 
		 and ((T.ODS_MODIFY_DATE = S.ODS_MODIFY_DATE) or (T.ODS_MODIFY_DATE IS NULL and S.ODS_MODIFY_DATE IS NULL))
        )

  
  

  



&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_MFG_FAMILY_XR2123001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_MFG_FAMILY_XR_IDX2123001
on		RAX_APP_USER.I$_MFG_FAMILY_XR2123001 (NAME)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Merge Rows */

merge into	ODS_STAGE.MFG_FAMILY_XR T
using	RAX_APP_USER.I$_MFG_FAMILY_XR2123001 S
on	(
		T.NAME=S.NAME
	)
when matched
then update set
	T.ODS_MODIFY_DATE	= S.ODS_MODIFY_DATE
	
when not matched
then insert
	(
	T.NAME,
	T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	,   T.MFG_FAMILY_OID
	)
values
	(
	S.NAME,
	S.ODS_CREATE_DATE,
	S.ODS_MODIFY_DATE
	,   ODS_STAGE.MFG_FAMILY_OID_SEQ.nextval
	)

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Drop flow table */

drop table RAX_APP_USER.I$_MFG_FAMILY_XR2123001 

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 13 */




/*-----------------------------------------------*/
/* TASK No. 14 */
/* Drop flow table */

--drop table RAX_APP_USER.I$_MFG_FAMILY2120001 

BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_MFG_FAMILY2120001';
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

create table RAX_APP_USER.I$_MFG_FAMILY2120001
(
	MFG_FAMILY_OID	NUMBER NULL,
	NAME	VARCHAR2(255) NULL,
	ABBREVIATION	VARCHAR2(6) NULL,
	COMPONENT_TEMPLATE_ID	VARCHAR2(255) NULL,
	PROCESSING_STRATEGY	VARCHAR2(255) NULL,
	REVISION_NO	NUMBER NULL,
	STATUS	VARCHAR2(255) NULL,
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
 


  


insert into	RAX_APP_USER.I$_MFG_FAMILY2120001
(
	MFG_FAMILY_OID,
	NAME,
	ABBREVIATION,
	COMPONENT_TEMPLATE_ID,
	PROCESSING_STRATEGY,
	REVISION_NO,
	STATUS,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID,
	IND_UPDATE
)
select 
MFG_FAMILY_OID,
	NAME,
	ABBREVIATION,
	COMPONENT_TEMPLATE_ID,
	PROCESSING_STRATEGY,
	REVISION_NO,
	STATUS,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID,
	IND_UPDATE
 from (


select 	 
	
	MFG_FAMILY_XR.MFG_FAMILY_OID MFG_FAMILY_OID,
	MIC_MFG_FAMILY_STG.NAME NAME,
	MIC_MFG_FAMILY_STG.ABBREVIATION ABBREVIATION,
	MIC_MFG_FAMILY_STG.COMPONENT_TEMPLATE_ID COMPONENT_TEMPLATE_ID,
	MIC_MFG_FAMILY_STG.PROCESSING_STRATEGY PROCESSING_STRATEGY,
	MIC_MFG_FAMILY_STG.REVISION_NO REVISION_NO,
	MIC_MFG_FAMILY_STG.STATUS STATUS,
	SYSDATE ODS_CREATE_DATE,
	SYSDATE ODS_MODIFY_DATE,
	SOURCE_SYSTEM.SOURCE_SYSTEM_OID SOURCE_SYSTEM_OID,

	'I' IND_UPDATE

from	ODS_STAGE.MIC_MANUFACTURING_FAMILY_STG   MIC_MFG_FAMILY_STG, ODS_STAGE.MFG_FAMILY_XR   MFG_FAMILY_XR, ODS_OWN.SOURCE_SYSTEM   SOURCE_SYSTEM
where	(1=1)
 And (MIC_MFG_FAMILY_STG.NAME=MFG_FAMILY_XR.NAME (+))
And (MIC_MFG_FAMILY_STG.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap)
 And (SOURCE_SYSTEM.SOURCE_SYSTEM_SHORT_NAME = 'MI')




) S
where NOT EXISTS 
	( select 1 from ODS_OWN.MFG_FAMILY T
	where	T.MFG_FAMILY_OID	= S.MFG_FAMILY_OID 
		 and ((T.NAME = S.NAME) or (T.NAME IS NULL and S.NAME IS NULL)) and
		((T.ABBREVIATION = S.ABBREVIATION) or (T.ABBREVIATION IS NULL and S.ABBREVIATION IS NULL)) and
		((T.COMPONENT_TEMPLATE_ID = S.COMPONENT_TEMPLATE_ID) or (T.COMPONENT_TEMPLATE_ID IS NULL and S.COMPONENT_TEMPLATE_ID IS NULL)) and
		((T.PROCESSING_STRATEGY = S.PROCESSING_STRATEGY) or (T.PROCESSING_STRATEGY IS NULL and S.PROCESSING_STRATEGY IS NULL)) and
		((T.REVISION_NO = S.REVISION_NO) or (T.REVISION_NO IS NULL and S.REVISION_NO IS NULL)) and
		((T.STATUS = S.STATUS) or (T.STATUS IS NULL and S.STATUS IS NULL)) and
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
	tabname => 'I$_MFG_FAMILY2120001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_MFG_FAMILY_IDX2120001
on		RAX_APP_USER.I$_MFG_FAMILY2120001 (MFG_FAMILY_OID)
NOLOGGING

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
and	ORIGIN 		= '(2120001)ODS_Project.LOAD_MFG_FAMILY_INT'
and	ERR_TYPE 		= 'F'


&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* create error table */


-- create table RAX_APP_USER.E$_MFG_FAMILY2120001
-- (
-- 	ODI_ROW_ID 		UROWID,
-- 	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
-- 	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
-- 	ODI_CHECK_DATE	DATE NULL, 
-- 	MFG_FAMILY_OID	NUMBER NULL,
-- 	NAME	VARCHAR2(255) NULL,
-- 	ABBREVIATION	VARCHAR2(6) NULL,
-- 	COMPONENT_TEMPLATE_ID	VARCHAR2(255) NULL,
-- 	PROCESSING_STRATEGY	VARCHAR2(255) NULL,
-- 	REVISION_NO	NUMBER NULL,
-- 	STATUS	VARCHAR2(255) NULL,
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
    WHERE table_name = 'E$_MFG_FAMILY2120001' AND owner = 'RAX_APP_USER';  
  
    -- If the table does not exist, create it  
    IF table_exists = 0 THEN  
        EXECUTE IMMEDIATE '  
            create table RAX_APP_USER.E$_MFG_FAMILY2120001
			(
				ODI_ROW_ID 		UROWID,
				ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
				ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
				ODI_CHECK_DATE	DATE NULL, 
				MFG_FAMILY_OID	NUMBER NULL,
				NAME	VARCHAR2(255) NULL,
				ABBREVIATION	VARCHAR2(6) NULL,
				COMPONENT_TEMPLATE_ID	VARCHAR2(255) NULL,
				PROCESSING_STRATEGY	VARCHAR2(255) NULL,
				REVISION_NO	NUMBER NULL,
				STATUS	VARCHAR2(255) NULL,
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

delete from 	RAX_APP_USER.E$_MFG_FAMILY2120001
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(2120001)ODS_Project.LOAD_MFG_FAMILY_INT')


&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Create index on PK */

 
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */
-- create index 	RAX_APP_USER.I$_MFG_FAMILY2120001
-- on	RAX_APP_USER.I$_MFG_FAMILY2120001 (MFG_FAMILY_OID)

DECLARE  
    index_exists NUMBER;  
BEGIN  
    -- Check if there is an index on the specified column  
    SELECT COUNT(*)  
    INTO index_exists  
    FROM all_ind_columns  
    WHERE table_name = 'I$_MFG_FAMILY2120001'
      	AND column_name = 'MFG_FAMILY_OID'  
      	AND index_owner = 'RAX_APP_USER';  
  
    -- If no such index exists, create the index  
    IF index_exists = 0 THEN  
        EXECUTE IMMEDIATE '  
            create index 	RAX_APP_USER.I$_MFG_FAMILY2120001
			on	RAX_APP_USER.I$_MFG_FAMILY2120001 (MFG_FAMILY_OID)
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
               SELECT 'RAX_APP_USER.I$_MFG_FAMILY' INTO CheckTable FROM DUAL;
               SELECT 'ODS_OWN.MFG_FAMILY' INTO TargetTable FROM DUAL;

IF CheckTable = TargetTable THEN
   VariableCheckTable := CheckTable; 
ELSE
   VariableCheckTable := CheckTable || '2120001';
END IF;

execute immediate '
insert into RAX_APP_USER.E$_MFG_FAMILY2120001
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
	MFG_FAMILY_OID,
	NAME,
	ABBREVIATION,
	COMPONENT_TEMPLATE_ID,
	PROCESSING_STRATEGY,
	REVISION_NO,
	STATUS,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID
)
select	SYS_GUID(),
	29842373200, 
	rowid,
	''F'', 
	''ODI-15064: The primary key MFG_FAMILY_PK is not unique.'',
	''(2120001)ODS_Project.LOAD_MFG_FAMILY_INT'',
	sysdate,
	''MFG_FAMILY_PK'',
	''PK'',	
	MFG_FAMILY.MFG_FAMILY_OID,
	MFG_FAMILY.NAME,
	MFG_FAMILY.ABBREVIATION,
	MFG_FAMILY.COMPONENT_TEMPLATE_ID,
	MFG_FAMILY.PROCESSING_STRATEGY,
	MFG_FAMILY.REVISION_NO,
	MFG_FAMILY.STATUS,
	MFG_FAMILY.ODS_CREATE_DATE,
	MFG_FAMILY.ODS_MODIFY_DATE,
	MFG_FAMILY.SOURCE_SYSTEM_OID
from	'
 || VariableCheckTable || 
' MFG_FAMILY 
where	exists  (
		select	SUB1.MFG_FAMILY_OID
		from 	' 
|| VariableCheckTable ||
'  SUB1
		where 	SUB1.MFG_FAMILY_OID=MFG_FAMILY.MFG_FAMILY_OID
		group by 	SUB1.MFG_FAMILY_OID
		having 	count(1) > 1
		)
';

END;


&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_MFG_FAMILY2120001
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
	MFG_FAMILY_OID,
	NAME,
	ABBREVIATION,
	COMPONENT_TEMPLATE_ID,
	PROCESSING_STRATEGY,
	REVISION_NO,
	STATUS,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column MFG_FAMILY_OID cannot be null.',
	sysdate,
	'(2120001)ODS_Project.LOAD_MFG_FAMILY_INT',
	'MFG_FAMILY_OID',
	'NN',	
	MFG_FAMILY_OID,
	NAME,
	ABBREVIATION,
	COMPONENT_TEMPLATE_ID,
	PROCESSING_STRATEGY,
	REVISION_NO,
	STATUS,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID
from	RAX_APP_USER.I$_MFG_FAMILY2120001
where	MFG_FAMILY_OID is null



&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_MFG_FAMILY2120001
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
	MFG_FAMILY_OID,
	NAME,
	ABBREVIATION,
	COMPONENT_TEMPLATE_ID,
	PROCESSING_STRATEGY,
	REVISION_NO,
	STATUS,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column NAME cannot be null.',
	sysdate,
	'(2120001)ODS_Project.LOAD_MFG_FAMILY_INT',
	'NAME',
	'NN',	
	MFG_FAMILY_OID,
	NAME,
	ABBREVIATION,
	COMPONENT_TEMPLATE_ID,
	PROCESSING_STRATEGY,
	REVISION_NO,
	STATUS,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID
from	RAX_APP_USER.I$_MFG_FAMILY2120001
where	NAME is null



&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* create index on error table */

 
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */
-- create index 	RAX_APP_USER.E$_MFG_FAMILY2120001
-- on	RAX_APP_USER.E$_MFG_FAMILY2120001 (ODI_ROW_ID)
DECLARE  
    index_exists NUMBER;  
BEGIN  
    -- Check if there is an index on the specified column  
    SELECT COUNT(*)  
    INTO index_exists  
    FROM all_ind_columns  
    WHERE table_name = 'E$_MFG_FAMILY2120001'
      	AND column_name = 'ODI_ROW_ID'  
      	AND index_owner = 'RAX_APP_USER';  
  
    -- If no such index exists, create the index  
    IF index_exists = 0 THEN  
        EXECUTE IMMEDIATE '  
            create index 	RAX_APP_USER.E$_MFG_FAMILY2120001
			on	RAX_APP_USER.E$_MFG_FAMILY2120001 (ODI_ROW_ID)
        ';  
    END IF;  
END;


&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* delete errors from controlled table */

delete from	RAX_APP_USER.I$_MFG_FAMILY2120001  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_MFG_FAMILY2120001 E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)


&


/*-----------------------------------------------*/
/* TASK No. 29 */
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
	'MFG_FAMILY',
	'ODS_OWN.MFG_FAMILY2120001',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_MFG_FAMILY2120001 E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(2120001)ODS_Project.LOAD_MFG_FAMILY_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE


&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* Merge Rows */

merge into	ODS_OWN.MFG_FAMILY T
using	RAX_APP_USER.I$_MFG_FAMILY2120001 S
on	(
		T.MFG_FAMILY_OID=S.MFG_FAMILY_OID
	)
when matched
then update set
	T.NAME	= S.NAME,
	T.ABBREVIATION	= S.ABBREVIATION,
	T.COMPONENT_TEMPLATE_ID	= S.COMPONENT_TEMPLATE_ID,
	T.PROCESSING_STRATEGY	= S.PROCESSING_STRATEGY,
	T.REVISION_NO	= S.REVISION_NO,
	T.STATUS	= S.STATUS,
	T.ODS_MODIFY_DATE	= S.ODS_MODIFY_DATE,
	T.SOURCE_SYSTEM_OID	= S.SOURCE_SYSTEM_OID
	
when not matched
then insert
	(
	T.MFG_FAMILY_OID,
	T.NAME,
	T.ABBREVIATION,
	T.COMPONENT_TEMPLATE_ID,
	T.PROCESSING_STRATEGY,
	T.REVISION_NO,
	T.STATUS,
	T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE,
	T.SOURCE_SYSTEM_OID
	
	)
values
	(
	S.MFG_FAMILY_OID,
	S.NAME,
	S.ABBREVIATION,
	S.COMPONENT_TEMPLATE_ID,
	S.PROCESSING_STRATEGY,
	S.REVISION_NO,
	S.STATUS,
	S.ODS_CREATE_DATE,
	S.ODS_MODIFY_DATE,
	S.SOURCE_SYSTEM_OID
	
	)

&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 32 */
/* Drop flow table */

drop table RAX_APP_USER.I$_MFG_FAMILY2120001 

&


/*-----------------------------------------------*/
/* TASK No. 33 */
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
             SUBSTR('2024-06-04 09:55:45.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=#LIFETOUCH_PROJECT.v_cdc_load_table_name
AND CONTEXT_NAME = 'PROD'
*/

&


/*-----------------------------------------------*/
/* TASK No. 34 */
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
,'LOAD_MFG_FAMILY_PKG'
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
29842373200,
'LOAD_MFG_FAMILY_PKG',
'002',
TO_DATE(
             SUBSTR('2024-06-04 09:55:45.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR ('#LIFETOUCH_PROJECT.v_cdc_load_date', 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,#LIFETOUCH_PROJECT.v_cdc_overlap,
SYSDATE,
 'PROD')
*/


&


/*-----------------------------------------------*/
