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
/* drop table RAX_APP_USER.C$_0PS_SU_DIGITL_CPN_STG purge */
/* create table RAX_APP_USER.C$_0PS_SU_DIGITL_CPN_STG
(
	C1_SU_DIGITAL_COUPON_ID	NUMBER(19) NULL,
	C2_COUPON_CODE	VARCHAR2(255) NULL,
	C3_SU_COUPON_BATCH	NUMBER(19) NULL,
	C4_MAX_REDEMPTIONS	NUMBER(8) NULL,
	C5_NUM_REDEMPTIONS	NUMBER(8) NULL,
	C6_REDEEM_DATE	DATE NULL,
	C7_AUDIT_CREATE_DATE	DATE NULL,
	C8_AUDIT_CREATED_BY	VARCHAR2(255) NULL,
	C9_AUDIT_MODIFY_DATE	DATE NULL,
	C10_AUDIT_MODIFIED_BY	VARCHAR2(255) NULL
)
NOLOGGING */
/* select	
	SU_DIGITAL_COUPON.SU_DIGITAL_COUPON_ID	   C1_SU_DIGITAL_COUPON_ID,
	SU_DIGITAL_COUPON.COUPON_CODE	   C2_COUPON_CODE,
	SU_DIGITAL_COUPON.SU_COUPON_BATCH	   C3_SU_COUPON_BATCH,
	SU_DIGITAL_COUPON.MAX_REDEMPTIONS	   C4_MAX_REDEMPTIONS,
	SU_DIGITAL_COUPON.NUM_REDEMPTIONS	   C5_NUM_REDEMPTIONS,
	SU_DIGITAL_COUPON.REDEEM_DATE	   C6_REDEEM_DATE,
	SU_DIGITAL_COUPON.AUDIT_CREATE_DATE	   C7_AUDIT_CREATE_DATE,
	SU_DIGITAL_COUPON.AUDIT_CREATED_BY	   C8_AUDIT_CREATED_BY,
	SU_DIGITAL_COUPON.AUDIT_MODIFY_DATE	   C9_AUDIT_MODIFY_DATE,
	SU_DIGITAL_COUPON.AUDIT_MODIFIED_BY	   C10_AUDIT_MODIFIED_BY
from	PS_OWN.SU_DIGITAL_COUPON   SU_DIGITAL_COUPON
where	(1=1)
And (NVL(SU_DIGITAL_COUPON.AUDIT_MODIFY_DATE, SU_DIGITAL_COUPON.AUDIT_CREATE_DATE) >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) */
/* insert  into RAX_APP_USER.C$_0PS_SU_DIGITL_CPN_STG
(
	C1_SU_DIGITAL_COUPON_ID,
	C2_COUPON_CODE,
	C3_SU_COUPON_BATCH,
	C4_MAX_REDEMPTIONS,
	C5_NUM_REDEMPTIONS,
	C6_REDEEM_DATE,
	C7_AUDIT_CREATE_DATE,
	C8_AUDIT_CREATED_BY,
	C9_AUDIT_MODIFY_DATE,
	C10_AUDIT_MODIFIED_BY
)
values
(
	:C1_SU_DIGITAL_COUPON_ID,
	:C2_COUPON_CODE,
	:C3_SU_COUPON_BATCH,
	:C4_MAX_REDEMPTIONS,
	:C5_NUM_REDEMPTIONS,
	:C6_REDEEM_DATE,
	:C7_AUDIT_CREATE_DATE,
	:C8_AUDIT_CREATED_BY,
	:C9_AUDIT_MODIFY_DATE,
	:C10_AUDIT_MODIFIED_BY
) */
/* TARGET CODE */
/*+ append */
/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0PS_SU_DIGITL_CPN_STG',
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


 /* drop table RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG2074001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG2074001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Create flow table I$ */



create table RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG2074001
(
	SU_DIGITAL_COUPON_ID	NUMBER(19) NULL,
	COUPON_CODE	VARCHAR2(255) NULL,
	SU_COUPON_BATCH	NUMBER(19) NULL,
	MAX_REDEMPTIONS	NUMBER(8) NULL,
	NUM_REDEMPTIONS	NUMBER(8) NULL,
	REDEEM_DATE	DATE NULL,
	AUDIT_CREATE_DATE	DATE NULL,
	AUDIT_CREATED_BY	VARCHAR2(255) NULL,
	AUDIT_MODIFY_DATE	DATE NULL,
	AUDIT_MODIFIED_BY	VARCHAR2(255) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

& /*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert flow into I$ table */
/* DETECTION_STRATEGY = NOT_EXISTS */



insert into	RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG2074001
(
	SU_DIGITAL_COUPON_ID,
	COUPON_CODE,
	SU_COUPON_BATCH,
	MAX_REDEMPTIONS,
	NUM_REDEMPTIONS,
	REDEEM_DATE,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	IND_UPDATE
)
select 
SU_DIGITAL_COUPON_ID,
	COUPON_CODE,
	SU_COUPON_BATCH,
	MAX_REDEMPTIONS,
	NUM_REDEMPTIONS,
	REDEEM_DATE,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	IND_UPDATE
 from (


select 	 
	
	C1_SU_DIGITAL_COUPON_ID SU_DIGITAL_COUPON_ID,
	C2_COUPON_CODE COUPON_CODE,
	C3_SU_COUPON_BATCH SU_COUPON_BATCH,
	C4_MAX_REDEMPTIONS MAX_REDEMPTIONS,
	C5_NUM_REDEMPTIONS NUM_REDEMPTIONS,
	C6_REDEEM_DATE REDEEM_DATE,
	C7_AUDIT_CREATE_DATE AUDIT_CREATE_DATE,
	C8_AUDIT_CREATED_BY AUDIT_CREATED_BY,
	C9_AUDIT_MODIFY_DATE AUDIT_MODIFY_DATE,
	C10_AUDIT_MODIFIED_BY AUDIT_MODIFIED_BY,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0PS_SU_DIGITL_CPN_STG
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.PS_SU_DIGITAL_COUPON_STG T
	where	T.SU_DIGITAL_COUPON_ID	= S.SU_DIGITAL_COUPON_ID 
		 and ((T.COUPON_CODE = S.COUPON_CODE) or (T.COUPON_CODE IS NULL and S.COUPON_CODE IS NULL)) and
		((T.SU_COUPON_BATCH = S.SU_COUPON_BATCH) or (T.SU_COUPON_BATCH IS NULL and S.SU_COUPON_BATCH IS NULL)) and
		((T.MAX_REDEMPTIONS = S.MAX_REDEMPTIONS) or (T.MAX_REDEMPTIONS IS NULL and S.MAX_REDEMPTIONS IS NULL)) and
		((T.NUM_REDEMPTIONS = S.NUM_REDEMPTIONS) or (T.NUM_REDEMPTIONS IS NULL and S.NUM_REDEMPTIONS IS NULL)) and
		((T.REDEEM_DATE = S.REDEEM_DATE) or (T.REDEEM_DATE IS NULL and S.REDEEM_DATE IS NULL)) and
		((T.AUDIT_CREATE_DATE = S.AUDIT_CREATE_DATE) or (T.AUDIT_CREATE_DATE IS NULL and S.AUDIT_CREATE_DATE IS NULL)) and
		((T.AUDIT_CREATED_BY = S.AUDIT_CREATED_BY) or (T.AUDIT_CREATED_BY IS NULL and S.AUDIT_CREATED_BY IS NULL)) and
		((T.AUDIT_MODIFY_DATE = S.AUDIT_MODIFY_DATE) or (T.AUDIT_MODIFY_DATE IS NULL and S.AUDIT_MODIFY_DATE IS NULL)) and
		((T.AUDIT_MODIFIED_BY = S.AUDIT_MODIFIED_BY) or (T.AUDIT_MODIFIED_BY IS NULL and S.AUDIT_MODIFIED_BY IS NULL))
        )

& /*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_PS_SU_DIGITL_CPN_STG2074001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& /*-----------------------------------------------*/
/* TASK No. 14 */
/* Create Index on flow table */


 /* create index	RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG_IDX2074001
on		RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG2074001 (SU_DIGITAL_COUPON_ID)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG_IDX2074001
on		RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG2074001 (SU_DIGITAL_COUPON_ID)
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
and	ORIGIN 		= '(2074001)ODS_Project.LOAD_SU_DIGITAL_COUPON_INT'
and	ERR_TYPE 		= 'F'

& /*-----------------------------------------------*/
/* TASK No. 17 */
/* create error table */



-- create table RAX_APP_USER.E$_PS_SU_DIGITL_CPN_STG2074001
-- (
-- 	ODI_ROW_ID 		UROWID,
-- 	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
-- 	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
-- 	ODI_CHECK_DATE	DATE NULL, 
-- 	SU_DIGITAL_COUPON_ID	NUMBER(19) NULL,
-- 	COUPON_CODE	VARCHAR2(255) NULL,
-- 	SU_COUPON_BATCH	NUMBER(19) NULL,
-- 	MAX_REDEMPTIONS	NUMBER(8) NULL,
-- 	NUM_REDEMPTIONS	NUMBER(8) NULL,
-- 	REDEEM_DATE	DATE NULL,
-- 	AUDIT_CREATE_DATE	DATE NULL,
-- 	AUDIT_CREATED_BY	VARCHAR2(255) NULL,
-- 	AUDIT_MODIFY_DATE	DATE NULL,
-- 	AUDIT_MODIFIED_BY	VARCHAR2(255) NULL,
-- 	ODS_CREATE_DATE	DATE NULL,
-- 	ODS_MODIFY_DATE	DATE NULL,
-- 	ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
-- 	ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
-- 	ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
-- 	ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
-- 	ODI_SESS_NO		VARCHAR2(19 CHAR)
-- )

BEGIN
    EXECUTE IMMEDIATE 'create table RAX_APP_USER.E$_PS_SU_DIGITL_CPN_STG2074001
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	SU_DIGITAL_COUPON_ID	NUMBER(19) NULL,
	COUPON_CODE	VARCHAR2(255) NULL,
	SU_COUPON_BATCH	NUMBER(19) NULL,
	MAX_REDEMPTIONS	NUMBER(8) NULL,
	NUM_REDEMPTIONS	NUMBER(8) NULL,
	REDEEM_DATE	DATE NULL,
	AUDIT_CREATE_DATE	DATE NULL,
	AUDIT_CREATED_BY	VARCHAR2(255) NULL,
	AUDIT_MODIFY_DATE	DATE NULL,
	AUDIT_MODIFIED_BY	VARCHAR2(255) NULL,
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



delete from 	RAX_APP_USER.E$_PS_SU_DIGITL_CPN_STG2074001
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(2074001)ODS_Project.LOAD_SU_DIGITAL_COUPON_INT')

& /*-----------------------------------------------*/
/* TASK No. 19 */
/* Create index on PK */
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */


 /* create index 	RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG2074001
on	RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG2074001 (SU_DIGITAL_COUPON_ID) */ 


BEGIN
    EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG2074001
on	RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG2074001 (SU_DIGITAL_COUPON_ID)';
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
               SELECT 'RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG' INTO CheckTable FROM DUAL;
               SELECT 'ODS_STAGE.PS_SU_DIGITAL_COUPON_STG' INTO TargetTable FROM DUAL;

IF CheckTable = TargetTable THEN
   VariableCheckTable := CheckTable; 
ELSE
   VariableCheckTable := CheckTable || '2074001';
END IF;

execute immediate '
insert into RAX_APP_USER.E$_PS_SU_DIGITL_CPN_STG2074001
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
	SU_DIGITAL_COUPON_ID,
	COUPON_CODE,
	SU_COUPON_BATCH,
	MAX_REDEMPTIONS,
	NUM_REDEMPTIONS,
	REDEEM_DATE,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	''F'', 
	''ODI-15064: The primary key PS_SU_DIGITAL_COUPON_PK is not unique.'',
	''(2074001)ODS_Project.LOAD_SU_DIGITAL_COUPON_INT'',
	sysdate,
	''PS_SU_DIGITAL_COUPON_PK'',
	''PK'',	
	PS_SU_DIGITAL_COUPON_STG.SU_DIGITAL_COUPON_ID,
	PS_SU_DIGITAL_COUPON_STG.COUPON_CODE,
	PS_SU_DIGITAL_COUPON_STG.SU_COUPON_BATCH,
	PS_SU_DIGITAL_COUPON_STG.MAX_REDEMPTIONS,
	PS_SU_DIGITAL_COUPON_STG.NUM_REDEMPTIONS,
	PS_SU_DIGITAL_COUPON_STG.REDEEM_DATE,
	PS_SU_DIGITAL_COUPON_STG.AUDIT_CREATE_DATE,
	PS_SU_DIGITAL_COUPON_STG.AUDIT_CREATED_BY,
	PS_SU_DIGITAL_COUPON_STG.AUDIT_MODIFY_DATE,
	PS_SU_DIGITAL_COUPON_STG.AUDIT_MODIFIED_BY,
	PS_SU_DIGITAL_COUPON_STG.ODS_CREATE_DATE,
	PS_SU_DIGITAL_COUPON_STG.ODS_MODIFY_DATE
from	'
 || VariableCheckTable || 
' PS_SU_DIGITAL_COUPON_STG 
where	exists  (
		select	SUB1.SU_DIGITAL_COUPON_ID
		from 	' 
|| VariableCheckTable ||
'  SUB1
		where 	SUB1.SU_DIGITAL_COUPON_ID=PS_SU_DIGITAL_COUPON_STG.SU_DIGITAL_COUPON_ID
		group by 	SUB1.SU_DIGITAL_COUPON_ID
		having 	count(1) > 1
		)
';

END;

& /*-----------------------------------------------*/
/* TASK No. 21 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_PS_SU_DIGITL_CPN_STG2074001
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
	SU_DIGITAL_COUPON_ID,
	COUPON_CODE,
	SU_COUPON_BATCH,
	MAX_REDEMPTIONS,
	NUM_REDEMPTIONS,
	REDEEM_DATE,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column SU_DIGITAL_COUPON_ID cannot be null.',
	sysdate,
	'(2074001)ODS_Project.LOAD_SU_DIGITAL_COUPON_INT',
	'SU_DIGITAL_COUPON_ID',
	'NN',	
	SU_DIGITAL_COUPON_ID,
	COUPON_CODE,
	SU_COUPON_BATCH,
	MAX_REDEMPTIONS,
	NUM_REDEMPTIONS,
	REDEEM_DATE,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG2074001
where	SU_DIGITAL_COUPON_ID is null

& /*-----------------------------------------------*/
/* TASK No. 22 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_PS_SU_DIGITL_CPN_STG2074001
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
	SU_DIGITAL_COUPON_ID,
	COUPON_CODE,
	SU_COUPON_BATCH,
	MAX_REDEMPTIONS,
	NUM_REDEMPTIONS,
	REDEEM_DATE,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column COUPON_CODE cannot be null.',
	sysdate,
	'(2074001)ODS_Project.LOAD_SU_DIGITAL_COUPON_INT',
	'COUPON_CODE',
	'NN',	
	SU_DIGITAL_COUPON_ID,
	COUPON_CODE,
	SU_COUPON_BATCH,
	MAX_REDEMPTIONS,
	NUM_REDEMPTIONS,
	REDEEM_DATE,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG2074001
where	COUPON_CODE is null

& /*-----------------------------------------------*/
/* TASK No. 23 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_PS_SU_DIGITL_CPN_STG2074001
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
	SU_DIGITAL_COUPON_ID,
	COUPON_CODE,
	SU_COUPON_BATCH,
	MAX_REDEMPTIONS,
	NUM_REDEMPTIONS,
	REDEEM_DATE,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column SU_COUPON_BATCH cannot be null.',
	sysdate,
	'(2074001)ODS_Project.LOAD_SU_DIGITAL_COUPON_INT',
	'SU_COUPON_BATCH',
	'NN',	
	SU_DIGITAL_COUPON_ID,
	COUPON_CODE,
	SU_COUPON_BATCH,
	MAX_REDEMPTIONS,
	NUM_REDEMPTIONS,
	REDEEM_DATE,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG2074001
where	SU_COUPON_BATCH is null

& /*-----------------------------------------------*/
/* TASK No. 24 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_PS_SU_DIGITL_CPN_STG2074001
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
	SU_DIGITAL_COUPON_ID,
	COUPON_CODE,
	SU_COUPON_BATCH,
	MAX_REDEMPTIONS,
	NUM_REDEMPTIONS,
	REDEEM_DATE,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column MAX_REDEMPTIONS cannot be null.',
	sysdate,
	'(2074001)ODS_Project.LOAD_SU_DIGITAL_COUPON_INT',
	'MAX_REDEMPTIONS',
	'NN',	
	SU_DIGITAL_COUPON_ID,
	COUPON_CODE,
	SU_COUPON_BATCH,
	MAX_REDEMPTIONS,
	NUM_REDEMPTIONS,
	REDEEM_DATE,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG2074001
where	MAX_REDEMPTIONS is null

& /*-----------------------------------------------*/
/* TASK No. 25 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_PS_SU_DIGITL_CPN_STG2074001
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
	SU_DIGITAL_COUPON_ID,
	COUPON_CODE,
	SU_COUPON_BATCH,
	MAX_REDEMPTIONS,
	NUM_REDEMPTIONS,
	REDEEM_DATE,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column NUM_REDEMPTIONS cannot be null.',
	sysdate,
	'(2074001)ODS_Project.LOAD_SU_DIGITAL_COUPON_INT',
	'NUM_REDEMPTIONS',
	'NN',	
	SU_DIGITAL_COUPON_ID,
	COUPON_CODE,
	SU_COUPON_BATCH,
	MAX_REDEMPTIONS,
	NUM_REDEMPTIONS,
	REDEEM_DATE,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG2074001
where	NUM_REDEMPTIONS is null

& /*-----------------------------------------------*/
/* TASK No. 26 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_PS_SU_DIGITL_CPN_STG2074001
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
	SU_DIGITAL_COUPON_ID,
	COUPON_CODE,
	SU_COUPON_BATCH,
	MAX_REDEMPTIONS,
	NUM_REDEMPTIONS,
	REDEEM_DATE,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
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
	'(2074001)ODS_Project.LOAD_SU_DIGITAL_COUPON_INT',
	'AUDIT_CREATE_DATE',
	'NN',	
	SU_DIGITAL_COUPON_ID,
	COUPON_CODE,
	SU_COUPON_BATCH,
	MAX_REDEMPTIONS,
	NUM_REDEMPTIONS,
	REDEEM_DATE,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFY_DATE,
	AUDIT_MODIFIED_BY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG2074001
where	AUDIT_CREATE_DATE is null

& /*-----------------------------------------------*/
/* TASK No. 27 */
/* create index on error table */
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */


 /* create index 	RAX_APP_USER.E$_PS_SU_DIGITL_CPN_STG2074001
on	RAX_APP_USER.E$_PS_SU_DIGITL_CPN_STG2074001 (ODI_ROW_ID) */ 


BEGIN
    EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_PS_SU_DIGITL_CPN_STG2074001
on	RAX_APP_USER.E$_PS_SU_DIGITL_CPN_STG2074001 (ODI_ROW_ID)';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 28 */
/* delete errors from controlled table */



delete from	RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG2074001  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_PS_SU_DIGITL_CPN_STG2074001 E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)

& /*-----------------------------------------------*/
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
	'ODS_STAGE',
	'PS_SU_DIGITL_CPN_STG',
	'ODS_STAGE.PS_SU_DIGITAL_COUPON_STG2074001',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_PS_SU_DIGITL_CPN_STG2074001 E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(2074001)ODS_Project.LOAD_SU_DIGITAL_COUPON_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE

& /*-----------------------------------------------*/
/* TASK No. 30 */
/* Merge Rows */



merge into	ODS_STAGE.PS_SU_DIGITAL_COUPON_STG T
using	RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG2074001 S
on	(
		T.SU_DIGITAL_COUPON_ID=S.SU_DIGITAL_COUPON_ID
	)
when matched
then update set
	T.COUPON_CODE	= S.COUPON_CODE,
	T.SU_COUPON_BATCH	= S.SU_COUPON_BATCH,
	T.MAX_REDEMPTIONS	= S.MAX_REDEMPTIONS,
	T.NUM_REDEMPTIONS	= S.NUM_REDEMPTIONS,
	T.REDEEM_DATE	= S.REDEEM_DATE,
	T.AUDIT_CREATE_DATE	= S.AUDIT_CREATE_DATE,
	T.AUDIT_CREATED_BY	= S.AUDIT_CREATED_BY,
	T.AUDIT_MODIFY_DATE	= S.AUDIT_MODIFY_DATE,
	T.AUDIT_MODIFIED_BY	= S.AUDIT_MODIFIED_BY
	,         T.ODS_MODIFY_DATE	= sysdate
when not matched
then insert
	(
	T.SU_DIGITAL_COUPON_ID,
	T.COUPON_CODE,
	T.SU_COUPON_BATCH,
	T.MAX_REDEMPTIONS,
	T.NUM_REDEMPTIONS,
	T.REDEEM_DATE,
	T.AUDIT_CREATE_DATE,
	T.AUDIT_CREATED_BY,
	T.AUDIT_MODIFY_DATE,
	T.AUDIT_MODIFIED_BY
	,          T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.SU_DIGITAL_COUPON_ID,
	S.COUPON_CODE,
	S.SU_COUPON_BATCH,
	S.MAX_REDEMPTIONS,
	S.NUM_REDEMPTIONS,
	S.REDEEM_DATE,
	S.AUDIT_CREATE_DATE,
	S.AUDIT_CREATED_BY,
	S.AUDIT_MODIFY_DATE,
	S.AUDIT_MODIFIED_BY
	,          sysdate,
	sysdate
	)

& /*-----------------------------------------------*/
/* TASK No. 31 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 32 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG2074001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_PS_SU_DIGITL_CPN_STG2074001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0PS_SU_DIGITL_CPN_STG purge */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0PS_SU_DIGITL_CPN_STG purge';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 33 */
/* Load PS_Digital_Coupon_XR */



MERGE INTO ods_stage.ps_digital_coupon_xr d
   USING (SELECT stg.su_digital_coupon_id, stg.su_coupon_batch
            FROM ods_stage.ps_su_digital_coupon_stg stg
           WHERE stg.ods_modify_date>=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
   ON (s.su_digital_coupon_id = d.sk_digital_coupon_id)
   WHEN MATCHED THEN
      UPDATE
         SET d.sk_coupon_batch_id = s.su_coupon_batch,
             d.ods_modify_date = SYSDATE
         WHERE DECODE (d.sk_coupon_batch_id, s.su_coupon_batch, 1, 0) = 0
   WHEN NOT MATCHED THEN
      INSERT (digital_coupon_oid, sk_digital_coupon_id,
              sk_coupon_batch_id, ods_create_date, ods_modify_date)
      VALUES (ods_stage.coupon_promotion_oid_seq.NEXTVAL,
              s.su_digital_coupon_id, s.su_coupon_batch, SYSDATE,
              SYSDATE)

& /*-----------------------------------------------*/
/* TASK No. 34 */
/* Load Digital_Coupon */



MERGE INTO ods_own.digital_coupon d
   USING (SELECT *
            FROM (SELECT xr.digital_coupon_oid,
                         cb_xr.coupon_batch_oid, stg.coupon_code,
                         stg.max_redemptions, stg.num_redemptions,
                         stg.redeem_date
                    FROM ods_stage.ps_digital_coupon_xr xr,
                         ods_stage.ps_su_digital_coupon_stg stg,
                         ods_stage.ps_coupon_batch_xr cb_xr,
                         ods_own.source_system ss
                   WHERE xr.sk_digital_coupon_id =
                                              stg.su_digital_coupon_id
                     AND stg.su_coupon_batch = cb_xr.sk_coupon_batch_id(+)
                     AND ss.source_system_short_name = 'PS'
                     AND stg.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap)) s
   ON (d.digital_coupon_oid = s.digital_coupon_oid)
   WHEN MATCHED THEN
      UPDATE
         SET d.coupon_batch_oid = s.coupon_batch_oid,
             d.coupon_code = s.coupon_code,
             d.max_redemptions = s.max_redemptions,
             d.num_redemptions = s.num_redemptions,
             d.redeem_date = s.redeem_date,
             d.ods_modify_date = SYSDATE
         WHERE    DECODE (d.coupon_batch_oid,
                          s.coupon_batch_oid, 1, 0) = 0
               OR DECODE (d.coupon_code, s.coupon_code, 1, 0) = 0
               OR DECODE (d.max_redemptions, s.max_redemptions, 1, 0) = 0
               OR DECODE (d.num_redemptions, s.num_redemptions, 1, 0) = 0
               OR DECODE (d.redeem_date, s.redeem_date, 1, 0) = 0
   WHEN NOT MATCHED THEN
      INSERT (digital_coupon_oid, coupon_batch_oid, redeem_date,
              num_redemptions, coupon_code, max_redemptions,
              ods_create_date, ods_modify_date)
      VALUES (s.digital_coupon_oid, s.coupon_batch_oid, s.redeem_date,
              s.num_redemptions, s.coupon_code, s.max_redemptions,
              SYSDATE, SYSDATE)

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
'LOAD_SU_DIGITAL_COUPON_PKG',
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
,'LOAD_SU_DIGITAL_COUPON_PKG'
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

& /*-----------------------------------------------*/





&