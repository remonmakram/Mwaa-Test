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
/* drop table RAX_APP_USER.C$_0PS_SU_CPN_BTCH_STG purge */
/* create table RAX_APP_USER.C$_0PS_SU_CPN_BTCH_STG
(
	C1_SU_COUPON_BATCH_ID	NUMBER(19) NULL,
	C2_DESCRIPTION	VARCHAR2(255) NULL,
	C3_BATCH_PREFIX	VARCHAR2(10) NULL,
	C4_START_DATE	DATE NULL,
	C5_END_DATE	DATE NULL,
	C6_COUPON_COUNT	NUMBER(8) NULL,
	C7_BATCH_TYPE	VARCHAR2(255) NULL,
	C8_EXPORTED	NUMBER(1) NULL,
	C9_AUDIT_CREATE_DATE	DATE NULL,
	C10_AUDIT_CREATED_BY	VARCHAR2(255) NULL,
	C11_AUDIT_MODIFY_DATE	DATE NULL,
	C12_AUDIT_MODIFIED_BY	VARCHAR2(255) NULL,
	C13_STACKABLE	NUMBER(1) NULL
)
NOLOGGING */
/* select	
	SU_COUPON_BATCH.SU_COUPON_BATCH_ID	   C1_SU_COUPON_BATCH_ID,
	SU_COUPON_BATCH.DESCRIPTION	   C2_DESCRIPTION,
	SU_COUPON_BATCH.BATCH_PREFIX	   C3_BATCH_PREFIX,
	SU_COUPON_BATCH.START_DATE	   C4_START_DATE,
	SU_COUPON_BATCH.END_DATE	   C5_END_DATE,
	SU_COUPON_BATCH.COUPON_COUNT	   C6_COUPON_COUNT,
	SU_COUPON_BATCH.BATCH_TYPE	   C7_BATCH_TYPE,
	SU_COUPON_BATCH.EXPORTED	   C8_EXPORTED,
	SU_COUPON_BATCH.AUDIT_CREATE_DATE	   C9_AUDIT_CREATE_DATE,
	SU_COUPON_BATCH.AUDIT_CREATED_BY	   C10_AUDIT_CREATED_BY,
	SU_COUPON_BATCH.AUDIT_MODIFY_DATE	   C11_AUDIT_MODIFY_DATE,
	SU_COUPON_BATCH.AUDIT_MODIFIED_BY	   C12_AUDIT_MODIFIED_BY,
	SU_COUPON_BATCH.STACKABLE	   C13_STACKABLE
from	PS_OWN.SU_COUPON_BATCH   SU_COUPON_BATCH
where	(1=1)
And (NVL(SU_COUPON_BATCH.AUDIT_MODIFY_DATE, SU_COUPON_BATCH.AUDIT_CREATE_DATE) >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) */
/* insert  into RAX_APP_USER.C$_0PS_SU_CPN_BTCH_STG
(
	C1_SU_COUPON_BATCH_ID,
	C2_DESCRIPTION,
	C3_BATCH_PREFIX,
	C4_START_DATE,
	C5_END_DATE,
	C6_COUPON_COUNT,
	C7_BATCH_TYPE,
	C8_EXPORTED,
	C9_AUDIT_CREATE_DATE,
	C10_AUDIT_CREATED_BY,
	C11_AUDIT_MODIFY_DATE,
	C12_AUDIT_MODIFIED_BY,
	C13_STACKABLE
)
values
(
	:C1_SU_COUPON_BATCH_ID,
	:C2_DESCRIPTION,
	:C3_BATCH_PREFIX,
	:C4_START_DATE,
	:C5_END_DATE,
	:C6_COUPON_COUNT,
	:C7_BATCH_TYPE,
	:C8_EXPORTED,
	:C9_AUDIT_CREATE_DATE,
	:C10_AUDIT_CREATED_BY,
	:C11_AUDIT_MODIFY_DATE,
	:C12_AUDIT_MODIFIED_BY,
	:C13_STACKABLE
) */
/* TARGET CODE */
/*+ append */
/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0PS_SU_CPN_BTCH_STG',
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


 /* drop table RAX_APP_USER.I$_PS_SU_CPN_BTCH_STG2071001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_PS_SU_CPN_BTCH_STG2071001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Create flow table I$ */



create table RAX_APP_USER.I$_PS_SU_CPN_BTCH_STG2071001
(
	SU_COUPON_BATCH_ID	NUMBER(19) NULL,
	DESCRIPTION	VARCHAR2(255) NULL,
	BATCH_PREFIX	VARCHAR2(10) NULL,
	START_DATE	DATE NULL,
	END_DATE	DATE NULL,
	COUPON_COUNT	NUMBER(8) NULL,
	BATCH_TYPE	VARCHAR2(255) NULL,
	EXPORTED	NUMBER(1) NULL,
	AUDIT_CREATE_DATE	DATE NULL,
	AUDIT_CREATED_BY	VARCHAR2(255) NULL,
	AUDIT_MODIFY_DATE	DATE NULL,
	AUDIT_MODIFIED_BY	VARCHAR2(255) NULL,
	STACKABLE	NUMBER(1) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

& /*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert flow into I$ table */
/* DETECTION_STRATEGY = NOT_EXISTS */



insert into	RAX_APP_USER.I$_PS_SU_CPN_BTCH_STG2071001
(
	SU_COUPON_BATCH_ID,
	DESCRIPTION,
	BATCH_PREFIX,
	START_DATE,
	END_DATE,
	COUPON_COUNT,
	BATCH_TYPE,
	EXPORTED,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	STACKABLE,
	IND_UPDATE
)
select 
SU_COUPON_BATCH_ID,
	DESCRIPTION,
	BATCH_PREFIX,
	START_DATE,
	END_DATE,
	COUPON_COUNT,
	BATCH_TYPE,
	EXPORTED,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	STACKABLE,
	IND_UPDATE
 from (


select 	 
	
	C1_SU_COUPON_BATCH_ID SU_COUPON_BATCH_ID,
	C2_DESCRIPTION DESCRIPTION,
	C3_BATCH_PREFIX BATCH_PREFIX,
	C4_START_DATE START_DATE,
	C5_END_DATE END_DATE,
	C6_COUPON_COUNT COUPON_COUNT,
	C7_BATCH_TYPE BATCH_TYPE,
	C8_EXPORTED EXPORTED,
	C9_AUDIT_CREATE_DATE AUDIT_CREATE_DATE,
	C10_AUDIT_CREATED_BY AUDIT_CREATED_BY,
	C11_AUDIT_MODIFY_DATE AUDIT_MODIFY_DATE,
	C12_AUDIT_MODIFIED_BY AUDIT_MODIFIED_BY,
	C13_STACKABLE STACKABLE,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0PS_SU_CPN_BTCH_STG
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.PS_SU_COUPON_BATCH_STG T
	where	T.SU_COUPON_BATCH_ID	= S.SU_COUPON_BATCH_ID 
		 and ((T.DESCRIPTION = S.DESCRIPTION) or (T.DESCRIPTION IS NULL and S.DESCRIPTION IS NULL)) and
		((T.BATCH_PREFIX = S.BATCH_PREFIX) or (T.BATCH_PREFIX IS NULL and S.BATCH_PREFIX IS NULL)) and
		((T.START_DATE = S.START_DATE) or (T.START_DATE IS NULL and S.START_DATE IS NULL)) and
		((T.END_DATE = S.END_DATE) or (T.END_DATE IS NULL and S.END_DATE IS NULL)) and
		((T.COUPON_COUNT = S.COUPON_COUNT) or (T.COUPON_COUNT IS NULL and S.COUPON_COUNT IS NULL)) and
		((T.BATCH_TYPE = S.BATCH_TYPE) or (T.BATCH_TYPE IS NULL and S.BATCH_TYPE IS NULL)) and
		((T.EXPORTED = S.EXPORTED) or (T.EXPORTED IS NULL and S.EXPORTED IS NULL)) and
		((T.AUDIT_CREATE_DATE = S.AUDIT_CREATE_DATE) or (T.AUDIT_CREATE_DATE IS NULL and S.AUDIT_CREATE_DATE IS NULL)) and
		((T.AUDIT_CREATED_BY = S.AUDIT_CREATED_BY) or (T.AUDIT_CREATED_BY IS NULL and S.AUDIT_CREATED_BY IS NULL)) and
		((T.AUDIT_MODIFY_DATE = S.AUDIT_MODIFY_DATE) or (T.AUDIT_MODIFY_DATE IS NULL and S.AUDIT_MODIFY_DATE IS NULL)) and
		((T.AUDIT_MODIFIED_BY = S.AUDIT_MODIFIED_BY) or (T.AUDIT_MODIFIED_BY IS NULL and S.AUDIT_MODIFIED_BY IS NULL)) and
		((T.STACKABLE = S.STACKABLE) or (T.STACKABLE IS NULL and S.STACKABLE IS NULL))
        )

& /*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_PS_SU_CPN_BTCH_STG2071001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& /*-----------------------------------------------*/
/* TASK No. 14 */
/* Create Index on flow table */


 /* create index	RAX_APP_USER.I$_PS_SU_CPN_BTCH_STG_IDX2071001
on		RAX_APP_USER.I$_PS_SU_CPN_BTCH_STG2071001 (SU_COUPON_BATCH_ID)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_PS_SU_CPN_BTCH_STG_IDX2071001
on		RAX_APP_USER.I$_PS_SU_CPN_BTCH_STG2071001 (SU_COUPON_BATCH_ID)
NOLOGGING';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 15 */
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
/* TASK No. 16 */
/* delete previous check sum */



delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS_STAGE'
and	ORIGIN 		= '(2071001)ODS_Project.LOAD_SU_COUPON_BATCH_STG_INT'
and	ERR_TYPE 		= 'F'

& /*-----------------------------------------------*/
/* TASK No. 17 */
/* create error table */



-- create table RAX_APP_USER.E$_PS_SU_CPN_BTCH_STG2071001
-- (
-- 	ODI_ROW_ID 		UROWID,
-- 	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
-- 	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
-- 	ODI_CHECK_DATE	DATE NULL, 
-- 	SU_COUPON_BATCH_ID	NUMBER(19) NULL,
-- 	DESCRIPTION	VARCHAR2(255) NULL,
-- 	BATCH_PREFIX	VARCHAR2(10) NULL,
-- 	START_DATE	DATE NULL,
-- 	END_DATE	DATE NULL,
-- 	COUPON_COUNT	NUMBER(8) NULL,
-- 	BATCH_TYPE	VARCHAR2(255) NULL,
-- 	EXPORTED	NUMBER(1) NULL,
-- 	AUDIT_CREATE_DATE	DATE NULL,
-- 	AUDIT_CREATED_BY	VARCHAR2(255) NULL,
-- 	AUDIT_MODIFY_DATE	DATE NULL,
-- 	AUDIT_MODIFIED_BY	VARCHAR2(255) NULL,
-- 	STACKABLE	NUMBER(1) NULL,
-- 	ODS_CREATE_DATE	DATE NULL,
-- 	ODS_MODIFY_DATE	DATE NULL,
-- 	ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
-- 	ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
-- 	ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
-- 	ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
-- 	ODI_SESS_NO		VARCHAR2(19 CHAR)
-- )

BEGIN
    EXECUTE IMMEDIATE 'create table RAX_APP_USER.E$_PS_SU_CPN_BTCH_STG2071001
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	SU_COUPON_BATCH_ID	NUMBER(19) NULL,
	DESCRIPTION	VARCHAR2(255) NULL,
	BATCH_PREFIX	VARCHAR2(10) NULL,
	START_DATE	DATE NULL,
	END_DATE	DATE NULL,
	COUPON_COUNT	NUMBER(8) NULL,
	BATCH_TYPE	VARCHAR2(255) NULL,
	EXPORTED	NUMBER(1) NULL,
	AUDIT_CREATE_DATE	DATE NULL,
	AUDIT_CREATED_BY	VARCHAR2(255) NULL,
	AUDIT_MODIFY_DATE	DATE NULL,
	AUDIT_MODIFIED_BY	VARCHAR2(255) NULL,
	STACKABLE	NUMBER(1) NULL,
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
/* TASK No. 18 */
/* delete previous errors */



delete from 	RAX_APP_USER.E$_PS_SU_CPN_BTCH_STG2071001
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(2071001)ODS_Project.LOAD_SU_COUPON_BATCH_STG_INT')

& /*-----------------------------------------------*/
/* TASK No. 19 */
/* Create index on PK */
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */


 /* create index 	RAX_APP_USER.I$_PS_SU_CPN_BTCH_STG2071001
on	RAX_APP_USER.I$_PS_SU_CPN_BTCH_STG2071001 (SU_COUPON_BATCH_ID) */ 


BEGIN
    EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.I$_PS_SU_CPN_BTCH_STG2071001
on	RAX_APP_USER.I$_PS_SU_CPN_BTCH_STG2071001 (SU_COUPON_BATCH_ID)';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 20 */
/* insert PK errors */



DECLARE
               CheckTable                             VarChar2(60);
               TargetTable                            VarChar2(60);
               VariableCheckTable                     VarChar2(60);

BEGIN
               SELECT 'RAX_APP_USER.I$_PS_SU_CPN_BTCH_STG' INTO CheckTable FROM DUAL;
               SELECT 'ODS_STAGE.PS_SU_COUPON_BATCH_STG' INTO TargetTable FROM DUAL;

IF CheckTable = TargetTable THEN
   VariableCheckTable := CheckTable; 
ELSE
   VariableCheckTable := CheckTable || '2071001';
END IF;

execute immediate '
insert into RAX_APP_USER.E$_PS_SU_CPN_BTCH_STG2071001
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
	SU_COUPON_BATCH_ID,
	DESCRIPTION,
	BATCH_PREFIX,
	START_DATE,
	END_DATE,
	COUPON_COUNT,
	BATCH_TYPE,
	EXPORTED,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	STACKABLE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	''F'', 
	''ODI-15064: The primary key PS_SU_COUPON_BATCH_PK is not unique.'',
	''(2071001)ODS_Project.LOAD_SU_COUPON_BATCH_STG_INT'',
	sysdate,
	''PS_SU_COUPON_BATCH_PK'',
	''PK'',	
	PS_SU_COUPON_BATCH_STG.SU_COUPON_BATCH_ID,
	PS_SU_COUPON_BATCH_STG.DESCRIPTION,
	PS_SU_COUPON_BATCH_STG.BATCH_PREFIX,
	PS_SU_COUPON_BATCH_STG.START_DATE,
	PS_SU_COUPON_BATCH_STG.END_DATE,
	PS_SU_COUPON_BATCH_STG.COUPON_COUNT,
	PS_SU_COUPON_BATCH_STG.BATCH_TYPE,
	PS_SU_COUPON_BATCH_STG.EXPORTED,
	PS_SU_COUPON_BATCH_STG.AUDIT_CREATE_DATE,
	PS_SU_COUPON_BATCH_STG.AUDIT_CREATED_BY,
	PS_SU_COUPON_BATCH_STG.AUDIT_MODIFY_DATE,
	PS_SU_COUPON_BATCH_STG.AUDIT_MODIFIED_BY,
	PS_SU_COUPON_BATCH_STG.STACKABLE,
	PS_SU_COUPON_BATCH_STG.ODS_CREATE_DATE,
	PS_SU_COUPON_BATCH_STG.ODS_MODIFY_DATE
from	'
 || VariableCheckTable || 
' PS_SU_COUPON_BATCH_STG 
where	exists  (
		select	SUB1.SU_COUPON_BATCH_ID
		from 	' 
|| VariableCheckTable ||
'  SUB1
		where 	SUB1.SU_COUPON_BATCH_ID=PS_SU_COUPON_BATCH_STG.SU_COUPON_BATCH_ID
		group by 	SUB1.SU_COUPON_BATCH_ID
		having 	count(1) > 1
		)
';

END;

& /*-----------------------------------------------*/
/* TASK No. 21 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_PS_SU_CPN_BTCH_STG2071001
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
	SU_COUPON_BATCH_ID,
	DESCRIPTION,
	BATCH_PREFIX,
	START_DATE,
	END_DATE,
	COUPON_COUNT,
	BATCH_TYPE,
	EXPORTED,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	STACKABLE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column SU_COUPON_BATCH_ID cannot be null.',
	sysdate,
	'(2071001)ODS_Project.LOAD_SU_COUPON_BATCH_STG_INT',
	'SU_COUPON_BATCH_ID',
	'NN',	
	SU_COUPON_BATCH_ID,
	DESCRIPTION,
	BATCH_PREFIX,
	START_DATE,
	END_DATE,
	COUPON_COUNT,
	BATCH_TYPE,
	EXPORTED,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	STACKABLE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PS_SU_CPN_BTCH_STG2071001
where	SU_COUPON_BATCH_ID is null

& /*-----------------------------------------------*/
/* TASK No. 22 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_PS_SU_CPN_BTCH_STG2071001
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
	SU_COUPON_BATCH_ID,
	DESCRIPTION,
	BATCH_PREFIX,
	START_DATE,
	END_DATE,
	COUPON_COUNT,
	BATCH_TYPE,
	EXPORTED,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	STACKABLE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column EXPORTED cannot be null.',
	sysdate,
	'(2071001)ODS_Project.LOAD_SU_COUPON_BATCH_STG_INT',
	'EXPORTED',
	'NN',	
	SU_COUPON_BATCH_ID,
	DESCRIPTION,
	BATCH_PREFIX,
	START_DATE,
	END_DATE,
	COUPON_COUNT,
	BATCH_TYPE,
	EXPORTED,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	STACKABLE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PS_SU_CPN_BTCH_STG2071001
where	EXPORTED is null

& /*-----------------------------------------------*/
/* TASK No. 23 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_PS_SU_CPN_BTCH_STG2071001
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
	SU_COUPON_BATCH_ID,
	DESCRIPTION,
	BATCH_PREFIX,
	START_DATE,
	END_DATE,
	COUPON_COUNT,
	BATCH_TYPE,
	EXPORTED,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	STACKABLE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column AUDIT_CREATE_DATE cannot be null.',
	sysdate,
	'(2071001)ODS_Project.LOAD_SU_COUPON_BATCH_STG_INT',
	'AUDIT_CREATE_DATE',
	'NN',	
	SU_COUPON_BATCH_ID,
	DESCRIPTION,
	BATCH_PREFIX,
	START_DATE,
	END_DATE,
	COUPON_COUNT,
	BATCH_TYPE,
	EXPORTED,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	STACKABLE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PS_SU_CPN_BTCH_STG2071001
where	AUDIT_CREATE_DATE is null

& /*-----------------------------------------------*/
/* TASK No. 24 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_PS_SU_CPN_BTCH_STG2071001
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
	SU_COUPON_BATCH_ID,
	DESCRIPTION,
	BATCH_PREFIX,
	START_DATE,
	END_DATE,
	COUPON_COUNT,
	BATCH_TYPE,
	EXPORTED,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	STACKABLE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column STACKABLE cannot be null.',
	sysdate,
	'(2071001)ODS_Project.LOAD_SU_COUPON_BATCH_STG_INT',
	'STACKABLE',
	'NN',	
	SU_COUPON_BATCH_ID,
	DESCRIPTION,
	BATCH_PREFIX,
	START_DATE,
	END_DATE,
	COUPON_COUNT,
	BATCH_TYPE,
	EXPORTED,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	STACKABLE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PS_SU_CPN_BTCH_STG2071001
where	STACKABLE is null

& /*-----------------------------------------------*/
/* TASK No. 25 */
/* create index on error table */
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */


 /* create index 	RAX_APP_USER.E$_PS_SU_CPN_BTCH_STG2071001
on	RAX_APP_USER.E$_PS_SU_CPN_BTCH_STG2071001 (ODI_ROW_ID) */ 


BEGIN
    EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_PS_SU_CPN_BTCH_STG2071001
on	RAX_APP_USER.E$_PS_SU_CPN_BTCH_STG2071001 (ODI_ROW_ID)';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 26 */
/* delete errors from controlled table */



delete from	RAX_APP_USER.I$_PS_SU_CPN_BTCH_STG2071001  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_PS_SU_CPN_BTCH_STG2071001 E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)

& /*-----------------------------------------------*/
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
	'PS_SU_CPN_BTCH_STG',
	'ODS_STAGE.PS_SU_COUPON_BATCH_STG2071001',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_PS_SU_CPN_BTCH_STG2071001 E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(2071001)ODS_Project.LOAD_SU_COUPON_BATCH_STG_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE

& /*-----------------------------------------------*/
/* TASK No. 28 */
/* Merge Rows */



merge into	ODS_STAGE.PS_SU_COUPON_BATCH_STG T
using	RAX_APP_USER.I$_PS_SU_CPN_BTCH_STG2071001 S
on	(
		T.SU_COUPON_BATCH_ID=S.SU_COUPON_BATCH_ID
	)
when matched
then update set
	T.DESCRIPTION	= S.DESCRIPTION,
	T.BATCH_PREFIX	= S.BATCH_PREFIX,
	T.START_DATE	= S.START_DATE,
	T.END_DATE	= S.END_DATE,
	T.COUPON_COUNT	= S.COUPON_COUNT,
	T.BATCH_TYPE	= S.BATCH_TYPE,
	T.EXPORTED	= S.EXPORTED,
	T.AUDIT_CREATE_DATE	= S.AUDIT_CREATE_DATE,
	T.AUDIT_CREATED_BY	= S.AUDIT_CREATED_BY,
	T.AUDIT_MODIFY_DATE	= S.AUDIT_MODIFY_DATE,
	T.AUDIT_MODIFIED_BY	= S.AUDIT_MODIFIED_BY,
	T.STACKABLE	= S.STACKABLE
	,            T.ODS_MODIFY_DATE	= sysdate
when not matched
then insert
	(
	T.SU_COUPON_BATCH_ID,
	T.DESCRIPTION,
	T.BATCH_PREFIX,
	T.START_DATE,
	T.END_DATE,
	T.COUPON_COUNT,
	T.BATCH_TYPE,
	T.EXPORTED,
	T.AUDIT_CREATE_DATE,
	T.AUDIT_CREATED_BY,
	T.AUDIT_MODIFY_DATE,
	T.AUDIT_MODIFIED_BY,
	T.STACKABLE
	,             T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.SU_COUPON_BATCH_ID,
	S.DESCRIPTION,
	S.BATCH_PREFIX,
	S.START_DATE,
	S.END_DATE,
	S.COUPON_COUNT,
	S.BATCH_TYPE,
	S.EXPORTED,
	S.AUDIT_CREATE_DATE,
	S.AUDIT_CREATED_BY,
	S.AUDIT_MODIFY_DATE,
	S.AUDIT_MODIFIED_BY,
	S.STACKABLE
	,             sysdate,
	sysdate
	)

& /*-----------------------------------------------*/
/* TASK No. 29 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 30 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_PS_SU_CPN_BTCH_STG2071001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_PS_SU_CPN_BTCH_STG2071001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0PS_SU_CPN_BTCH_STG purge */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0PS_SU_CPN_BTCH_STG purge';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 31 */
/* Load ps_coupon_batch_xr table */



MERGE INTO ods_stage.ps_coupon_batch_xr d
   USING (SELECT s.su_coupon_batch_id
            FROM ods_stage.ps_su_coupon_batch_stg s
           WHERE s.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
   ON (s.su_coupon_batch_id = d.sk_coupon_batch_id)
   WHEN NOT MATCHED THEN
      INSERT (coupon_batch_oid, sk_coupon_batch_id, ods_create_date,
              ods_modify_date)
      VALUES (ods_stage.coupon_batch_oid_seq.NEXTVAL,
              s.su_coupon_batch_id, SYSDATE, SYSDATE)

& /*-----------------------------------------------*/
/* TASK No. 32 */
/* Load Coupon_Batch Table */



MERGE INTO ods_own.coupon_batch d
   USING (SELECT *
            FROM (SELECT xr.coupon_batch_oid, stg.description,
                         stg.batch_prefix, stg.start_date,
                         stg.end_date, stg.coupon_count,
                         stg.batch_type, stg.exported, stg.stackable,
                         ss.source_system_oid,
                         stg.su_coupon_batch_id,
                         SYSDATE AS ods_create_date,
                         SYSDATE AS ods_modify_date
                    FROM ods_stage.ps_su_coupon_batch_stg stg,
                         ods_stage.ps_coupon_batch_xr xr,
                         ods_own.source_system ss
                   WHERE stg.su_coupon_batch_id =
                                                 xr.sk_coupon_batch_id
                     AND ss.source_system_short_name = 'PS'
                     AND stg.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s) s
   ON (d.coupon_batch_oid = s.coupon_batch_oid)
   WHEN MATCHED THEN
      UPDATE
         SET d.description = s.description,
             d.batch_prefix = s.batch_prefix,
             d.start_date = s.start_date, d.end_date = s.end_date,
             d.coupon_count = s.coupon_count,
             d.batch_type = s.batch_type, d.exported = s.exported,
             d.stackable = s.stackable,
             d.coupon_batch_id = s.su_coupon_batch_id,
             d.ods_modify_date = s.ods_modify_date
         WHERE    DECODE (s.description, d.description, 1, 0) = 0
               OR DECODE (s.batch_prefix, d.batch_prefix, 1, 0) = 0
               OR DECODE (s.start_date, d.start_date, 1, 0) = 0
               OR DECODE (s.end_date, d.end_date, 1, 0) = 0
               OR DECODE (s.coupon_count, d.coupon_count, 1, 0) = 0
               OR DECODE (s.batch_type, d.batch_type, 1, 0) = 0
               OR DECODE (s.exported, d.exported, 1, 0) = 0
               OR DECODE (s.stackable, d.stackable, 1, 0) = 0
               OR DECODE (s.su_coupon_batch_id, d.coupon_batch_id, 1, 0) = 0
   WHEN NOT MATCHED THEN
      INSERT (coupon_batch_oid, batch_type, coupon_count, end_date,
              start_date, batch_prefix, description, exported,
              stackable, ods_create_date, ods_modify_date, coupon_batch_id)
      VALUES (s.coupon_batch_oid, s.batch_type, s.coupon_count,
              s.end_date, s.start_date, s.batch_prefix, s.description,
              s.exported, s.stackable, s.ods_create_date,
              s.ods_modify_date, s.su_coupon_batch_id)

& /*-----------------------------------------------*/
/* TASK No. 33 */
/* Update Coupon Promotion (late arriving parent) */



MERGE INTO ods_own.coupon_promotion d
   USING (SELECT cb.coupon_batch_oid, cp.coupon_promotion_oid
            FROM ods_own.coupon_promotion cp,
                 ods_own.coupon_batch cb,
                 ods_stage.ps_coupon_batch_xr cbxr,
                 ods_stage.ps_coupon_promotion_xr cpxr
           WHERE cb.coupon_batch_oid = cbxr.coupon_batch_oid
             AND cbxr.sk_coupon_batch_id = cpxr.sk_coupon_batch_id
             AND cpxr.coupon_promotion_oid = cp.coupon_promotion_oid
             AND cp.coupon_batch_oid IS NULL
             AND cb.ods_modify_date>= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
   ON (d.coupon_promotion_oid = s.coupon_promotion_oid)
   WHEN MATCHED THEN
      UPDATE
         SET d.coupon_batch_oid = s.coupon_batch_oid,
             d.ods_modify_date = SYSDATE

& /*-----------------------------------------------*/
/* TASK No. 34 */
/* Update Digital_Coupon (late ariving parent) */



MERGE INTO ods_own.digital_coupon d
   USING (SELECT cb.coupon_batch_oid, dc.digital_coupon_oid
            FROM ods_own.coupon_batch cb,
                 ods_own.digital_coupon dc,
                 ods_stage.ps_digital_coupon_xr dxr,
                 ods_stage.ps_coupon_batch_xr cbxr
           WHERE cb.coupon_batch_oid = cbxr.coupon_batch_oid
             AND cbxr.sk_coupon_batch_id = dxr.sk_coupon_batch_id
             AND dxr.digital_coupon_oid = dc.digital_coupon_oid
             AND dc.coupon_batch_oid IS NULL
             AND cb.ods_modify_date>= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
   ON (d.digital_coupon_oid = s.digital_coupon_oid)
   WHEN MATCHED THEN
      UPDATE
         SET d.coupon_batch_oid = s.coupon_batch_oid,
             d.ods_modify_date = SYSDATE

& /*-----------------------------------------------*/
/* TASK No. 35 */
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
/* TASK No. 36 */
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
'LOAD_SU_COUPON_BATCH_PKG',
'002',
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
,'LOAD_SU_COUPON_BATCH_PKG'
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

& /*-----------------------------------------------*/





&