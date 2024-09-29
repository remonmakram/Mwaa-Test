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
/* drop table RAX_APP_USER.C$_0PS_SKU_EXT_REF_STG purge */
/* create table RAX_APP_USER.C$_0PS_SKU_EXT_REF_STG
(
	C1_ID	NUMBER NULL,
	C2_STOCK_KEEPING_UNIT_ID	NUMBER NULL,
	C3_EXTERNAL_ID	VARCHAR2(255) NULL,
	C4_REFERENCE_TYPE	VARCHAR2(255) NULL,
	C5_AUDIT_CREATE_DATE	DATE NULL,
	C6_AUDIT_MODIFY_DATE	DATE NULL,
	C7_EXTERNAL_TYPE	VARCHAR2(255) NULL
)
NOLOGGING */
/* select	
	SKU_EXTERNAL_REFERENCE.ID	   C1_ID,
	SKU_EXTERNAL_REFERENCE.STOCK_KEEPING_UNIT_ID	   C2_STOCK_KEEPING_UNIT_ID,
	SKU_EXTERNAL_REFERENCE.EXTERNAL_ID	   C3_EXTERNAL_ID,
	SKU_EXTERNAL_REFERENCE.REFERENCE_TYPE	   C4_REFERENCE_TYPE,
	SKU_EXTERNAL_REFERENCE.AUDIT_CREATE_DATE	   C5_AUDIT_CREATE_DATE,
	SKU_EXTERNAL_REFERENCE.AUDIT_MODIFY_DATE	   C6_AUDIT_MODIFY_DATE,
	SKU_EXTERNAL_REFERENCE.EXTERNAL_TYPE	   C7_EXTERNAL_TYPE
from	PS_OWN.SKU_EXTERNAL_REFERENCE   SKU_EXTERNAL_REFERENCE
where	(1=1) */
/* insert  into RAX_APP_USER.C$_0PS_SKU_EXT_REF_STG
(
	C1_ID,
	C2_STOCK_KEEPING_UNIT_ID,
	C3_EXTERNAL_ID,
	C4_REFERENCE_TYPE,
	C5_AUDIT_CREATE_DATE,
	C6_AUDIT_MODIFY_DATE,
	C7_EXTERNAL_TYPE
)
values
(
	:C1_ID,
	:C2_STOCK_KEEPING_UNIT_ID,
	:C3_EXTERNAL_ID,
	:C4_REFERENCE_TYPE,
	:C5_AUDIT_CREATE_DATE,
	:C6_AUDIT_MODIFY_DATE,
	:C7_EXTERNAL_TYPE
) */
/* TARGET CODE */
/*+ append */
/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0PS_SKU_EXT_REF_STG',
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


 /* drop table RAX_APP_USER.I$_PS_SKU_EXT_REF_STG2399001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_PS_SKU_EXT_REF_STG2399001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Create flow table I$ */



create table RAX_APP_USER.I$_PS_SKU_EXT_REF_STG2399001
(
	ID	NUMBER NULL,
	STOCK_KEEPING_UNIT_ID	NUMBER NULL,
	EXTERNAL_ID	VARCHAR2(255) NULL,
	REFERENCE_TYPE	VARCHAR2(255) NULL,
	AUDIT_CREATE_DATE	DATE NULL,
	AUDIT_MODIFY_DATE	DATE NULL,
	EXTERNAL_TYPE	VARCHAR2(255) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

& /*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert flow into I$ table */
/* DETECTION_STRATEGY = NOT_EXISTS */



insert into	RAX_APP_USER.I$_PS_SKU_EXT_REF_STG2399001
(
	ID,
	STOCK_KEEPING_UNIT_ID,
	EXTERNAL_ID,
	REFERENCE_TYPE,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFY_DATE,
	EXTERNAL_TYPE,
	IND_UPDATE
)
select 
ID,
	STOCK_KEEPING_UNIT_ID,
	EXTERNAL_ID,
	REFERENCE_TYPE,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFY_DATE,
	EXTERNAL_TYPE,
	IND_UPDATE
 from (


select 	 
	
	C1_ID ID,
	C2_STOCK_KEEPING_UNIT_ID STOCK_KEEPING_UNIT_ID,
	C3_EXTERNAL_ID EXTERNAL_ID,
	C4_REFERENCE_TYPE REFERENCE_TYPE,
	C5_AUDIT_CREATE_DATE AUDIT_CREATE_DATE,
	C6_AUDIT_MODIFY_DATE AUDIT_MODIFY_DATE,
	C7_EXTERNAL_TYPE EXTERNAL_TYPE,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0PS_SKU_EXT_REF_STG
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.PS_SKU_EXT_REFERENCE_STG T
	where	T.ID	= S.ID 
		 and ((T.STOCK_KEEPING_UNIT_ID = S.STOCK_KEEPING_UNIT_ID) or (T.STOCK_KEEPING_UNIT_ID IS NULL and S.STOCK_KEEPING_UNIT_ID IS NULL)) and
		((T.EXTERNAL_ID = S.EXTERNAL_ID) or (T.EXTERNAL_ID IS NULL and S.EXTERNAL_ID IS NULL)) and
		((T.REFERENCE_TYPE = S.REFERENCE_TYPE) or (T.REFERENCE_TYPE IS NULL and S.REFERENCE_TYPE IS NULL)) and
		((T.AUDIT_CREATE_DATE = S.AUDIT_CREATE_DATE) or (T.AUDIT_CREATE_DATE IS NULL and S.AUDIT_CREATE_DATE IS NULL)) and
		((T.AUDIT_MODIFY_DATE = S.AUDIT_MODIFY_DATE) or (T.AUDIT_MODIFY_DATE IS NULL and S.AUDIT_MODIFY_DATE IS NULL)) and
		((T.EXTERNAL_TYPE = S.EXTERNAL_TYPE) or (T.EXTERNAL_TYPE IS NULL and S.EXTERNAL_TYPE IS NULL))
        )

& /*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_PS_SKU_EXT_REF_STG2399001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& /*-----------------------------------------------*/
/* TASK No. 14 */
/* Create Index on flow table */


 /* create index	RAX_APP_USER.I$_PS_SKU_EXT_REF_STG_IDX2399001
on		RAX_APP_USER.I$_PS_SKU_EXT_REF_STG2399001 (ID)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_PS_SKU_EXT_REF_STG_IDX2399001
on		RAX_APP_USER.I$_PS_SKU_EXT_REF_STG2399001 (ID)
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
and	ORIGIN 		= '(2399001)ODS_Project.LOAD_PS_SKU_EXT_REFERENCE_STG_INT'
and	ERR_TYPE 		= 'F'

& /*-----------------------------------------------*/
/* TASK No. 17 */
/* create error table */



-- create table RAX_APP_USER.E$_PS_SKU_EXT_REF_STG2399001
-- (
-- 	ODI_ROW_ID 		UROWID,
-- 	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
-- 	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
-- 	ODI_CHECK_DATE	DATE NULL, 
-- 	ID	NUMBER NULL,
-- 	STOCK_KEEPING_UNIT_ID	NUMBER NULL,
-- 	EXTERNAL_ID	VARCHAR2(255) NULL,
-- 	REFERENCE_TYPE	VARCHAR2(255) NULL,
-- 	AUDIT_CREATE_DATE	DATE NULL,
-- 	AUDIT_MODIFY_DATE	DATE NULL,
-- 	EXTERNAL_TYPE	VARCHAR2(255) NULL,
-- 	ODS_CREATE_DATE	DATE NULL,
-- 	ODS_MODIFY_DATE	DATE NULL,
-- 	ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
-- 	ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
-- 	ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
-- 	ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
-- 	ODI_SESS_NO		VARCHAR2(19 CHAR)
-- )

BEGIN
    EXECUTE IMMEDIATE 'create table RAX_APP_USER.E$_PS_SKU_EXT_REF_STG2399001
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	ID	NUMBER NULL,
	STOCK_KEEPING_UNIT_ID	NUMBER NULL,
	EXTERNAL_ID	VARCHAR2(255) NULL,
	REFERENCE_TYPE	VARCHAR2(255) NULL,
	AUDIT_CREATE_DATE	DATE NULL,
	AUDIT_MODIFY_DATE	DATE NULL,
	EXTERNAL_TYPE	VARCHAR2(255) NULL,
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



delete from 	RAX_APP_USER.E$_PS_SKU_EXT_REF_STG2399001
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(2399001)ODS_Project.LOAD_PS_SKU_EXT_REFERENCE_STG_INT')

& /*-----------------------------------------------*/
/* TASK No. 19 */
/* Create index on PK */
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */


 /* create index 	RAX_APP_USER.I$_PS_SKU_EXT_REF_STG2399001
on	RAX_APP_USER.I$_PS_SKU_EXT_REF_STG2399001 (ID) */ 


BEGIN
    EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.I$_PS_SKU_EXT_REF_STG2399001
on	RAX_APP_USER.I$_PS_SKU_EXT_REF_STG2399001 (ID)';
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
               SELECT 'RAX_APP_USER.I$_PS_SKU_EXT_REF_STG' INTO CheckTable FROM DUAL;
               SELECT 'ODS_STAGE.PS_SKU_EXT_REFERENCE_STG' INTO TargetTable FROM DUAL;

IF CheckTable = TargetTable THEN
   VariableCheckTable := CheckTable; 
ELSE
   VariableCheckTable := CheckTable || '2399001';
END IF;

execute immediate '
insert into RAX_APP_USER.E$_PS_SKU_EXT_REF_STG2399001
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
	STOCK_KEEPING_UNIT_ID,
	EXTERNAL_ID,
	REFERENCE_TYPE,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFY_DATE,
	EXTERNAL_TYPE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	''F'', 
	''ODI-15064: The primary key PS_SKU_EXT_REFERENCE_STG_PK is not unique.'',
	''(2399001)ODS_Project.LOAD_PS_SKU_EXT_REFERENCE_STG_INT'',
	sysdate,
	''PS_SKU_EXT_REFERENCE_STG_PK'',
	''PK'',	
	PS_SKU_EXT_REFERENCE_STG.ID,
	PS_SKU_EXT_REFERENCE_STG.STOCK_KEEPING_UNIT_ID,
	PS_SKU_EXT_REFERENCE_STG.EXTERNAL_ID,
	PS_SKU_EXT_REFERENCE_STG.REFERENCE_TYPE,
	PS_SKU_EXT_REFERENCE_STG.AUDIT_CREATE_DATE,
	PS_SKU_EXT_REFERENCE_STG.AUDIT_MODIFY_DATE,
	PS_SKU_EXT_REFERENCE_STG.EXTERNAL_TYPE,
	PS_SKU_EXT_REFERENCE_STG.ODS_CREATE_DATE,
	PS_SKU_EXT_REFERENCE_STG.ODS_MODIFY_DATE
from	'
 || VariableCheckTable || 
' PS_SKU_EXT_REFERENCE_STG 
where	exists  (
		select	SUB1.ID
		from 	' 
|| VariableCheckTable ||
'  SUB1
		where 	SUB1.ID=PS_SKU_EXT_REFERENCE_STG.ID
		group by 	SUB1.ID
		having 	count(1) > 1
		)
';

END;

& /*-----------------------------------------------*/
/* TASK No. 21 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_PS_SKU_EXT_REF_STG2399001
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
	STOCK_KEEPING_UNIT_ID,
	EXTERNAL_ID,
	REFERENCE_TYPE,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFY_DATE,
	EXTERNAL_TYPE,
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
	'(2399001)ODS_Project.LOAD_PS_SKU_EXT_REFERENCE_STG_INT',
	'ID',
	'NN',	
	ID,
	STOCK_KEEPING_UNIT_ID,
	EXTERNAL_ID,
	REFERENCE_TYPE,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFY_DATE,
	EXTERNAL_TYPE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PS_SKU_EXT_REF_STG2399001
where	ID is null

& /*-----------------------------------------------*/
/* TASK No. 22 */
/* create index on error table */
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */


 /* create index 	RAX_APP_USER.E$_PS_SKU_EXT_REF_STG2399001
on	RAX_APP_USER.E$_PS_SKU_EXT_REF_STG2399001 (ODI_ROW_ID) */ 


BEGIN
    EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_PS_SKU_EXT_REF_STG2399001
on	RAX_APP_USER.E$_PS_SKU_EXT_REF_STG2399001 (ODI_ROW_ID)';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 23 */
/* delete errors from controlled table */



delete from	RAX_APP_USER.I$_PS_SKU_EXT_REF_STG2399001  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_PS_SKU_EXT_REF_STG2399001 E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)

& /*-----------------------------------------------*/
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
	'ODS_STAGE',
	'PS_SKU_EXT_REF_STG',
	'ODS_STAGE.PS_SKU_EXT_REFERENCE_STG2399001',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_PS_SKU_EXT_REF_STG2399001 E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(2399001)ODS_Project.LOAD_PS_SKU_EXT_REFERENCE_STG_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE

& /*-----------------------------------------------*/
/* TASK No. 25 */
/* Merge Rows */



merge into	ODS_STAGE.PS_SKU_EXT_REFERENCE_STG T
using	RAX_APP_USER.I$_PS_SKU_EXT_REF_STG2399001 S
on	(
		T.ID=S.ID
	)
when matched
then update set
	T.STOCK_KEEPING_UNIT_ID	= S.STOCK_KEEPING_UNIT_ID,
	T.EXTERNAL_ID	= S.EXTERNAL_ID,
	T.REFERENCE_TYPE	= S.REFERENCE_TYPE,
	T.AUDIT_CREATE_DATE	= S.AUDIT_CREATE_DATE,
	T.AUDIT_MODIFY_DATE	= S.AUDIT_MODIFY_DATE,
	T.EXTERNAL_TYPE	= S.EXTERNAL_TYPE
	,      T.ODS_MODIFY_DATE	= sysdate
when not matched
then insert
	(
	T.ID,
	T.STOCK_KEEPING_UNIT_ID,
	T.EXTERNAL_ID,
	T.REFERENCE_TYPE,
	T.AUDIT_CREATE_DATE,
	T.AUDIT_MODIFY_DATE,
	T.EXTERNAL_TYPE
	,       T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.ID,
	S.STOCK_KEEPING_UNIT_ID,
	S.EXTERNAL_ID,
	S.REFERENCE_TYPE,
	S.AUDIT_CREATE_DATE,
	S.AUDIT_MODIFY_DATE,
	S.EXTERNAL_TYPE
	,       sysdate,
	sysdate
	)

& /*-----------------------------------------------*/
/* TASK No. 26 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 27 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_PS_SKU_EXT_REF_STG2399001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_PS_SKU_EXT_REF_STG2399001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0PS_SKU_EXT_REF_STG purge */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0PS_SKU_EXT_REF_STG purge';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 28 */
/* merge into ps_sku_ext_reference_xr */



merge into ods_stage.ps_sku_ext_reference_xr t
using (
    select id, stock_keeping_unit_id from ods_stage.ps_sku_ext_reference_stg
    where ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
) s
on (t.id = s.id)
when matched then update
set t.stock_keeping_unit_id = s.stock_keeping_unit_id
, t.ods_modify_date = sysdate
where decode (t.stock_keeping_unit_id, s.stock_keeping_unit_id, 1, 0) = 0
when not matched then 
insert
(
 t.sku_external_reference_oid
, t.id
, t.stock_keeping_unit_id
, t.ods_create_date
, t.ods_modify_date
)   
values
(
  ods_stage.sku_external_reference_oid_seq.nextval
, s.id
, s.stock_keeping_unit_id
, sysdate
, sysdate
)

& /*-----------------------------------------------*/
/* TASK No. 29 */
/* merge into sku_external_reference */



merge into ods_own.sku_external_reference t
using (
    select xr.sku_external_reference_oid, sku_xr.stock_keeping_unit_oid,
                 stg.external_id, stg.reference_type, stg.external_type
            FROM ods_stage.ps_sku_ext_reference_stg stg,
                 ods_stage.ps_sku_ext_reference_xr xr,
                 ods_stage.ps_stock_keeping_unit_xr sku_xr,
                 ods_own.source_system ss
           WHERE stg.id = xr.id
             AND stg.stock_keeping_unit_id = sku_xr.stock_keeping_unit_id
             AND ss.source_system_short_name = 'PS'
             AND stg.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
) s
on (t.sku_external_reference_oid = s.sku_external_reference_oid)
when matched then update
set t.stock_keeping_unit_oid = s.stock_keeping_unit_oid
, t.external_id = s.external_id
, t.reference_type = s.reference_type
, t.external_type = s.external_type
, t.ods_modify_date = sysdate
where decode (t.stock_keeping_unit_oid, s.stock_keeping_unit_oid, 1, 0) = 0
or decode (t.external_id, s.external_id, 1, 0) = 0
or decode (t.reference_type, s.reference_type, 1, 0) = 0
or decode (t.external_type, s.external_type, 1, 0) = 0
when not matched then 
insert (
t.sku_external_reference_oid
, t.stock_keeping_unit_oid
, t.external_id
, t.reference_type
, t.external_type
, t.ods_create_date
, t.ods_modify_date
)
values
(
s.sku_external_reference_oid
, s.stock_keeping_unit_oid
, s.external_id
, s.reference_type
, s.external_type
, sysdate
, sysdate
)

& /*-----------------------------------------------*/
/* TASK No. 30 */
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
/* TASK No. 31 */
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
'LOAD_SKU_EXTERNAL_REFERENCE_PKG',
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
,'LOAD_SKU_EXTERNAL_REFERENCE_PKG'
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