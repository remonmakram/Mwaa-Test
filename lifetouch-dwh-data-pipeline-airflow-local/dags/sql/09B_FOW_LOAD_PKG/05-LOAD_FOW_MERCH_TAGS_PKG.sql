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
/* drop table RAX_APP_USER.C$_0FOW_APO_MERCH_TAGS */
/* create table RAX_APP_USER.C$_0FOW_APO_MERCH_TAGS
(
	C1_APO_ID	NUMBER(19) NULL,
	C2_TAG_ID	NUMBER(19) NULL,
	C3_ID	NUMBER(19) NULL
)
NOLOGGING */
/* select	
	APO_MERCH_TAGS.APO_ID	   C1_APO_ID,
	APO_MERCH_TAGS.TAG_ID	   C2_TAG_ID,
	APO_MERCH_TAGS.ID	   C3_ID
from	FOW_OWN.APO_MERCH_TAGS   APO_MERCH_TAGS, FOW_OWN.APO   APO
where	(1=1)
And (APO.LAST_UPDATED >=  ( TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))
 And (APO_MERCH_TAGS.APO_ID=APO.ID) */
/* insert into RAX_APP_USER.C$_0FOW_APO_MERCH_TAGS
(
	C1_APO_ID,
	C2_TAG_ID,
	C3_ID
)
values
(
	:C1_APO_ID,
	:C2_TAG_ID,
	:C3_ID
) */
/* TARGET CODE */
/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0FOW_APO_MERCH_TAGS',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;

& /*-----------------------------------------------*/
/* TASK No. 9 */
/* Set vID */
/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 9 */
/*-----------------------------------------------*/
/* TASK No. 10 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_FOW_APO_MERCH_TAGS1068001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FOW_APO_MERCH_TAGS1068001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Create flow table I$ */


 /* create table RAX_APP_USER.I$_FOW_APO_MERCH_TAGS1068001
(
	APO_ID	NUMBER(19) NULL,
	TAG_ID	NUMBER(19) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	ID	NUMBER(19) NULL
	,IND_UPDATE		char(1)
)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create table RAX_APP_USER.I$_FOW_APO_MERCH_TAGS1068001
(
	APO_ID	NUMBER(19) NULL,
	TAG_ID	NUMBER(19) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	ID	NUMBER(19) NULL
	,IND_UPDATE		char(1)
)
NOLOGGING';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert flow into I$ table */
/* DETECTION_STRATEGY = NOT_EXISTS */



insert into	RAX_APP_USER.I$_FOW_APO_MERCH_TAGS1068001
(
	APO_ID,
	TAG_ID,
	ID,
	IND_UPDATE
)
select 
APO_ID,
	TAG_ID,
	ID,
	IND_UPDATE
 from (


select 	 
	
	C1_APO_ID APO_ID,
	C2_TAG_ID TAG_ID,
	C3_ID ID,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0FOW_APO_MERCH_TAGS
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.FOW_APO_MERCH_TAGS T
	where	T.APO_ID	= S.APO_ID
	and	T.TAG_ID	= S.TAG_ID
	and	T.ID	= S.ID 
		
        )

& /*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_FOW_APO_MERCH_TAGS1068001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& /*-----------------------------------------------*/
/* TASK No. 14 */
/* Create Index on flow table */


 /* create index	RAX_APP_USER.I$_FOW_APO_MERCH_TAGS_IDX1068001
on		RAX_APP_USER.I$_FOW_APO_MERCH_TAGS1068001 (APO_ID, TAG_ID, ID)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_FOW_APO_MERCH_TAGS_IDX1068001
on		RAX_APP_USER.I$_FOW_APO_MERCH_TAGS1068001 (APO_ID, TAG_ID, ID)
NOLOGGING';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 15 */
/* Merge Rows */



merge into	ODS_STAGE.FOW_APO_MERCH_TAGS T
using	RAX_APP_USER.I$_FOW_APO_MERCH_TAGS1068001 S
on	(
		T.APO_ID=S.APO_ID
	and		T.TAG_ID=S.TAG_ID
	and		T.ID=S.ID
	)
when matched
then update set
	
	T.ODS_MODIFY_DATE	= SYSDATE
when not matched
then insert
	(
	T.APO_ID,
	T.TAG_ID,
	T.ID
	,   T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.APO_ID,
	S.TAG_ID,
	S.ID
	,   SYSDATE,
	SYSDATE
	)

& /*-----------------------------------------------*/
/* TASK No. 16 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 17 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_FOW_APO_MERCH_TAGS1068001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FOW_APO_MERCH_TAGS1068001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0FOW_APO_MERCH_TAGS */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_APO_MERCH_TAGS';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 18 */
/* merge into ODS_STAGE.FOW_APO_TAG_XR  */



Merge Into ODS_STAGE.FOW_APO_TAG_XR T
Using (Select  Apo_Id, Tag_Id, ID
 From ODS_STAGE.Fow_Apo_Merch_Tags
  Where ODS_MODIFY_DATE> TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
)S
on(
T.APO_ID = S.APO_ID AND T.TAG_ID = S.TAG_ID and T.ID = S.ID	
)
when not matched
then insert(
  T. Apo_Id,
  T.Tag_Id,
  T.Apo_Tag_Oid,
  T.ODS_CREATE_DATE,
  T.ID
)
values
(
 S.Apo_Id,
 S.TAG_ID,    
 ODS_STAGE.ITEM_OID_SEQ.nextval,
 SYSDATE,
 S.ID
)

& /*-----------------------------------------------*/
/* TASK No. 19 */
/* Set vID */
/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 19 */
/*-----------------------------------------------*/
/* TASK No. 20 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_APO_TAG1518001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_APO_TAG1518001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 21 */
/* Create flow table I$ */


 /* create table RAX_APP_USER.I$_APO_TAG1518001
(
	APO_TAG_OID	NUMBER NULL,
	APO_OID	NUMBER NULL,
	TAG	VARCHAR2(255) NULL,
	TAG_GROUP	VARCHAR2(255) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	SOURCE_SYSTEM_OID	NUMBER NULL
	,IND_UPDATE		char(1)
)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create table RAX_APP_USER.I$_APO_TAG1518001
(
	APO_TAG_OID	NUMBER NULL,
	APO_OID	NUMBER NULL,
	TAG	VARCHAR2(255) NULL,
	TAG_GROUP	VARCHAR2(255) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	SOURCE_SYSTEM_OID	NUMBER NULL
	,IND_UPDATE		char(1)
)
NOLOGGING';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 22 */
/* Insert flow into I$ table */
/* DETECTION_STRATEGY = NOT_EXISTS */



insert into	RAX_APP_USER.I$_APO_TAG1518001
(
	APO_TAG_OID,
	APO_OID,
	TAG,
	TAG_GROUP,
	SOURCE_SYSTEM_OID,
	IND_UPDATE
)
select 
APO_TAG_OID,
	APO_OID,
	TAG,
	TAG_GROUP,
	SOURCE_SYSTEM_OID,
	IND_UPDATE
 from (


select 	 
	
	FOW_APO_TAG_XR.APO_TAG_OID APO_TAG_OID,
	APO.APO_OID APO_OID,
	TAG_TAG_STG.NAME TAG,
	TAG_GROUP_STG.NAME TAG_GROUP,
	SOURCE_SYSTEM.SOURCE_SYSTEM_OID SOURCE_SYSTEM_OID,

	'I' IND_UPDATE

from	ODS_STAGE.FOW_APO_MERCH_TAGS   FOW_APO_MERCH_TAGS, ODS_STAGE.FOW_APO_TAG_XR   FOW_APO_TAG_XR, ODS_STAGE.TAG_TAG_STG   TAG_TAG_STG, ODS_STAGE.TAG_GROUP_STG   TAG_GROUP_STG, ODS_STAGE.APO_XR   APO_XR, ODS_OWN.SOURCE_SYSTEM   SOURCE_SYSTEM, ODS_OWN.APO   APO
where	(1=1)
 And (FOW_APO_MERCH_TAGS.APO_ID=FOW_APO_TAG_XR.APO_ID (+) AND FOW_APO_MERCH_TAGS.TAG_ID=FOW_APO_TAG_XR.TAG_ID (+))
AND (FOW_APO_TAG_XR.APO_ID=APO_XR.FOW_SK_ID (+))
AND (TAG_TAG_STG.GROUP_ID=TAG_GROUP_STG.ID (+))
AND (APO_XR.APO_OID=APO.APO_OID (+))
AND (FOW_APO_MERCH_TAGS.TAG_ID=TAG_TAG_STG.ID (+))
And (FOW_APO_MERCH_TAGS.ODS_MODIFY_DATE  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap)
 And (SOURCE_SYSTEM.SOURCE_SYSTEM_SHORT_NAME='FOW')




) S
where NOT EXISTS 
	( select 1 from ODS_OWN.APO_TAG T
	where	T.APO_TAG_OID	= S.APO_TAG_OID 
		 and ((T.APO_OID = S.APO_OID) or (T.APO_OID IS NULL and S.APO_OID IS NULL)) and
		((T.TAG = S.TAG) or (T.TAG IS NULL and S.TAG IS NULL)) and
		((T.TAG_GROUP = S.TAG_GROUP) or (T.TAG_GROUP IS NULL and S.TAG_GROUP IS NULL)) and
		((T.SOURCE_SYSTEM_OID = S.SOURCE_SYSTEM_OID) or (T.SOURCE_SYSTEM_OID IS NULL and S.SOURCE_SYSTEM_OID IS NULL))
        )

& /*-----------------------------------------------*/
/* TASK No. 23 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_APO_TAG1518001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& /*-----------------------------------------------*/
/* TASK No. 24 */
/* Create Index on flow table */


 /* create index	RAX_APP_USER.I$_APO_TAG_IDX1518001
on		RAX_APP_USER.I$_APO_TAG1518001 (APO_TAG_OID)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_APO_TAG_IDX1518001
on		RAX_APP_USER.I$_APO_TAG1518001 (APO_TAG_OID)
NOLOGGING';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 25 */
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
/* TASK No. 26 */
/* delete previous check sum */



delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS_OWN'
and	ORIGIN 		= '(1518001)ODS_Project.LOAD_FOW_APO_TAGS_INT'
and	ERR_TYPE 		= 'F'

& /*-----------------------------------------------*/
/* TASK No. 27 */
/* create error table */


 /* create table RAX_APP_USER.E$_APO_TAG1518001
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	APO_TAG_OID	NUMBER NULL,
	APO_OID	NUMBER NULL,
	TAG	VARCHAR2(255) NULL,
	TAG_GROUP	VARCHAR2(255) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	SOURCE_SYSTEM_OID	NUMBER NULL,
	ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
	ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
	ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
	ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
	ODI_SESS_NO		VARCHAR2(19 CHAR)
) */ 


BEGIN
    EXECUTE IMMEDIATE 'create table RAX_APP_USER.E$_APO_TAG1518001
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	APO_TAG_OID	NUMBER NULL,
	APO_OID	NUMBER NULL,
	TAG	VARCHAR2(255) NULL,
	TAG_GROUP	VARCHAR2(255) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	SOURCE_SYSTEM_OID	NUMBER NULL,
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
/* TASK No. 28 */
/* delete previous errors */



delete from 	RAX_APP_USER.E$_APO_TAG1518001
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(1518001)ODS_Project.LOAD_FOW_APO_TAGS_INT')

& /*-----------------------------------------------*/
/* TASK No. 29 */
/* Create index on PK */
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */


 /* create index 	RAX_APP_USER.I$_APO_TAG1518001
on	RAX_APP_USER.I$_APO_TAG1518001 (APO_TAG_OID) */ 


BEGIN
    EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.I$_APO_TAG1518001
on	RAX_APP_USER.I$_APO_TAG1518001 (APO_TAG_OID)';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 30 */
/* insert PK errors */



DECLARE
               CheckTable                             VarChar2(60);
               TargetTable                            VarChar2(60);
               VariableCheckTable                     VarChar2(60);

BEGIN
               SELECT 'RAX_APP_USER.I$_APO_TAG' INTO CheckTable FROM DUAL;
               SELECT 'ODS_OWN.APO_TAG' INTO TargetTable FROM DUAL;

IF CheckTable = TargetTable THEN
   VariableCheckTable := CheckTable; 
ELSE
   VariableCheckTable := CheckTable || '1518001';
END IF;

execute immediate '
insert into RAX_APP_USER.E$_APO_TAG1518001
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
	APO_TAG_OID,
	APO_OID,
	TAG,
	TAG_GROUP,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	''F'', 
	''ODI-15064: The primary key APO_TAG_PK is not unique.'',
	''(1518001)ODS_Project.LOAD_FOW_APO_TAGS_INT'',
	sysdate,
	''APO_TAG_PK'',
	''PK'',	
	APO_TAG.APO_TAG_OID,
	APO_TAG.APO_OID,
	APO_TAG.TAG,
	APO_TAG.TAG_GROUP,
	APO_TAG.ODS_CREATE_DATE,
	APO_TAG.ODS_MODIFY_DATE,
	APO_TAG.SOURCE_SYSTEM_OID
from	'
 || VariableCheckTable || 
' APO_TAG 
where	exists  (
		select	SUB1.APO_TAG_OID
		from 	' 
|| VariableCheckTable ||
'  SUB1
		where 	SUB1.APO_TAG_OID=APO_TAG.APO_TAG_OID
		group by 	SUB1.APO_TAG_OID
		having 	count(1) > 1
		)
';

END;

& /*-----------------------------------------------*/
/* TASK No. 31 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_APO_TAG1518001
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
	APO_TAG_OID,
	APO_OID,
	TAG,
	TAG_GROUP,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column APO_TAG_OID cannot be null.',
	sysdate,
	'(1518001)ODS_Project.LOAD_FOW_APO_TAGS_INT',
	'APO_TAG_OID',
	'NN',	
	APO_TAG_OID,
	APO_OID,
	TAG,
	TAG_GROUP,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID
from	RAX_APP_USER.I$_APO_TAG1518001
where	APO_TAG_OID is null

& /*-----------------------------------------------*/
/* TASK No. 32 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_APO_TAG1518001
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
	APO_TAG_OID,
	APO_OID,
	TAG,
	TAG_GROUP,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column APO_OID cannot be null.',
	sysdate,
	'(1518001)ODS_Project.LOAD_FOW_APO_TAGS_INT',
	'APO_OID',
	'NN',	
	APO_TAG_OID,
	APO_OID,
	TAG,
	TAG_GROUP,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID
from	RAX_APP_USER.I$_APO_TAG1518001
where	APO_OID is null

& /*-----------------------------------------------*/
/* TASK No. 33 */
/* create index on error table */
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */


 /* create index 	RAX_APP_USER.E$_APO_TAG1518001
on	RAX_APP_USER.E$_APO_TAG1518001 (ODI_ROW_ID) */ 


BEGIN
    EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_APO_TAG1518001
on	RAX_APP_USER.E$_APO_TAG1518001 (ODI_ROW_ID)';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 34 */
/* delete errors from controlled table */



delete from	RAX_APP_USER.I$_APO_TAG1518001  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_APO_TAG1518001 E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)

& /*-----------------------------------------------*/
/* TASK No. 35 */
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
	'APO_TAG',
	'ODS_OWN.APO_TAG1518001',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_APO_TAG1518001 E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(1518001)ODS_Project.LOAD_FOW_APO_TAGS_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE

& /*-----------------------------------------------*/
/* TASK No. 36 */
/* Merge Rows */



merge into	ODS_OWN.APO_TAG T
using	RAX_APP_USER.I$_APO_TAG1518001 S
on	(
		T.APO_TAG_OID=S.APO_TAG_OID
	)
when matched
then update set
	T.APO_OID	= S.APO_OID,
	T.TAG	= S.TAG,
	T.TAG_GROUP	= S.TAG_GROUP,
	T.SOURCE_SYSTEM_OID	= S.SOURCE_SYSTEM_OID
	,    T.ODS_MODIFY_DATE	= sysdate
when not matched
then insert
	(
	T.APO_TAG_OID,
	T.APO_OID,
	T.TAG,
	T.TAG_GROUP,
	T.SOURCE_SYSTEM_OID
	,     T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.APO_TAG_OID,
	S.APO_OID,
	S.TAG,
	S.TAG_GROUP,
	S.SOURCE_SYSTEM_OID
	,     sysdate,
	sysdate
	)

& /*-----------------------------------------------*/
/* TASK No. 37 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 38 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_APO_TAG1518001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_APO_TAG1518001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 39 */
/* Drop driver table */


 /* drop table RAX_APP_USER.temp_apo_iap_ind_driver */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.temp_apo_iap_ind_driver';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 40 */
/* Create Driver table */


 /* CREATE TABLE RAX_APP_USER.TEMP_APO_IAP_IND_DRIVER (
APO_OID number,
IND char(1)
) */ 


BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE RAX_APP_USER.TEMP_APO_IAP_IND_DRIVER (
APO_OID number,
IND char(1)
)';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 41 */
/* INSERT INTO TEMP_APO_IAP_IND_DRIVER */



INSERT INTO RAX_APP_USER.TEMP_APO_IAP_IND_DRIVER
SELECT APO_XR.APO_OID, max((CASE WHEN TAG_ID='211' THEN 'Y' ELSE 'N' END))
FROM ODS_STAGE.FOW_APO_MERCH_TAGS FOW_APO_MERCH_TAGS, ODS_STAGE.APO_XR APO_XR
WHERE FOW_APO_MERCH_TAGS.APO_ID = APO_XR.FOW_SK_ID AND FOW_APO_MERCH_TAGS.TAG_ID IN ('211', '231') AND FOW_APO_MERCH_TAGS.ODS_MODIFY_DATE> TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
group by APO_XR.APO_OID

& /*-----------------------------------------------*/
/* TASK No. 42 */
/* Update APO */



MERGE INTO ODS_OWN.APO APO
USING
(
SELECT APO_OID,IND FROM RAX_APP_USER.TEMP_APO_IAP_IND_DRIVER where IND is not null 
) driver
ON
( 
 APO.APO_OID=driver.APO_OID
)
WHEN MATCHED THEN UPDATE
SET APO.IMAGE_ACCESS_PRODUCT_IND=driver.IND ,
ODS_MODIFY_DATE=SYSDATE

& /*-----------------------------------------------*/
/* TASK No. 43 */
/* Repair APO_TAG.APO_OID */



merge into RAX_APP_USER.E$_APO_TAG   c 
using (
    select o.apo_OID, e.ODI_PK         
    from 
        RAX_APP_USER.E$_APO_TAG  E
     , ODS_STAGE.FOW_APO_TAG_XR  F
     ,ODS_OWN.Apo  O
     ,ods_stage.apo_xr xr
    where (1=1) 
    And F.APO_TAG_Oid = E.APO_TAG_Oid
    And O.Apo_Id = Xr.Apo_Id
    and F.Apo_Id = Xr.Fow_Sk_Id
    and nvl(o.APO_OID,-11111) <> nvl(e.APO_OID,-11111)
) s
   on (c.ODI_PK = s.ODI_PK)
when matched then update
set 
c.APO_OID = s.APO_OID

& /*-----------------------------------------------*/
/* TASK No. 44 */
/* drop driver table */


 /* drop table rax_app_user.fow_merch_tag_driver */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table rax_app_user.fow_merch_tag_driver';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 45 */
/* create driver table */


 /* create table rax_app_user.fow_merch_tag_driver 
as
select stg.* from ods_stage.fow_apo_tag_xr xr, ods_stage.fow_apo_merch_tags stg
where xr.apo_id = stg.apo_id and xr.tag_id = stg.tag_id
and stg.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap
and not exists(
  select 1 from ods_own.apo_tag
  where apo_tag_oid = xr.apo_tag_oid
) */ 


create table rax_app_user.fow_merch_tag_driver 
as
select stg.* from ods_stage.fow_apo_tag_xr xr, ods_stage.fow_apo_merch_tags stg
where xr.apo_id = stg.apo_id and xr.tag_id = stg.tag_id
and stg.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap
and not exists(
  select 1 from ods_own.apo_tag
  where apo_tag_oid = xr.apo_tag_oid
)
    

& /*-----------------------------------------------*/
/* TASK No. 46 */
/* merge into ods_stage */



merge into ods_stage.fow_apo_merch_tags t
using (
 select * from rax_app_user.fow_merch_tag_driver 
)s
on(s.apo_id = t.apo_id and s.tag_id = t.tag_id)
when matched then update set
ods_modify_date = sysdate

& /*-----------------------------------------------*/
/* TASK No. 47 */
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
/* TASK No. 48 */
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
'LOAD_FOW_MERCH_TAGS_PKG',
'006',
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
,'LOAD_FOW_MERCH_TAGS_PKG'
,'006'
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