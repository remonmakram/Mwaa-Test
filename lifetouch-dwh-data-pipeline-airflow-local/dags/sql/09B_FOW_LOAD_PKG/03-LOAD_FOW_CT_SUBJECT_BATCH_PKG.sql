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
/* drop table RAX_APP_USER.C$_0FOW_CT_SBJ_BATCH_STG purge */
/* create table RAX_APP_USER.C$_0FOW_CT_SBJ_BATCH_STG
(
	C1_ID	NUMBER(19) NULL,
	C2_SUBJECT_ID	NUMBER(19) NULL,
	C3_BATCH_ID	NUMBER(19) NULL,
	C4_RETURNED_MATERIAL_TYPE	VARCHAR2(255) NULL,
	C5_BARCODE	VARCHAR2(255) NULL,
	C6_LAST_UPDATED	DATE NULL
)
NOLOGGING */
/* select	
	CT_SUBJECT_BATCH.ID	   C1_ID,
	CT_SUBJECT_BATCH.SUBJECT_ID	   C2_SUBJECT_ID,
	CT_SUBJECT_BATCH.BATCH_ID	   C3_BATCH_ID,
	CT_SUBJECT_BATCH.RETURNED_MATERIAL_TYPE	   C4_RETURNED_MATERIAL_TYPE,
	CT_SUBJECT_BATCH.BARCODE	   C5_BARCODE,
	CT_SUBJECT_BATCH.LAST_UPDATED	   C6_LAST_UPDATED
from	FOW_OWN.CT_SUBJECT_BATCH   CT_SUBJECT_BATCH
where	(1=1)
And (CT_SUBJECT_BATCH.LAST_UPDATED  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap) */
/* insert  into RAX_APP_USER.C$_0FOW_CT_SBJ_BATCH_STG
(
	C1_ID,
	C2_SUBJECT_ID,
	C3_BATCH_ID,
	C4_RETURNED_MATERIAL_TYPE,
	C5_BARCODE,
	C6_LAST_UPDATED
)
values
(
	:C1_ID,
	:C2_SUBJECT_ID,
	:C3_BATCH_ID,
	:C4_RETURNED_MATERIAL_TYPE,
	:C5_BARCODE,
	:C6_LAST_UPDATED
) */
/* TARGET CODE */
/*+ append */
/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0FOW_CT_SBJ_BATCH_STG',
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


 /* drop table RAX_APP_USER.I$_FOW_CT_SBJ_BATCH_STG2200001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FOW_CT_SBJ_BATCH_STG2200001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Create flow table I$ */


 /* create table RAX_APP_USER.I$_FOW_CT_SBJ_BATCH_STG2200001
(
	ID	NUMBER(19) NULL,
	SUBJECT_ID	NUMBER(19) NULL,
	BATCH_ID	NUMBER(19) NULL,
	RETURNED_MATERIAL_TYPE	VARCHAR2(255) NULL,
	BARCODE	VARCHAR2(255) NULL,
	LAST_UPDATED	DATE NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL
	,IND_UPDATE		char(1)
)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create table RAX_APP_USER.I$_FOW_CT_SBJ_BATCH_STG2200001
(
	ID	NUMBER(19) NULL,
	SUBJECT_ID	NUMBER(19) NULL,
	BATCH_ID	NUMBER(19) NULL,
	RETURNED_MATERIAL_TYPE	VARCHAR2(255) NULL,
	BARCODE	VARCHAR2(255) NULL,
	LAST_UPDATED	DATE NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL
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



insert into	RAX_APP_USER.I$_FOW_CT_SBJ_BATCH_STG2200001
(
	ID,
	SUBJECT_ID,
	BATCH_ID,
	RETURNED_MATERIAL_TYPE,
	BARCODE,
	LAST_UPDATED,
	IND_UPDATE
)
select 
ID,
	SUBJECT_ID,
	BATCH_ID,
	RETURNED_MATERIAL_TYPE,
	BARCODE,
	LAST_UPDATED,
	IND_UPDATE
 from (


select 	 
	
	C1_ID ID,
	C2_SUBJECT_ID SUBJECT_ID,
	C3_BATCH_ID BATCH_ID,
	C4_RETURNED_MATERIAL_TYPE RETURNED_MATERIAL_TYPE,
	C5_BARCODE BARCODE,
	C6_LAST_UPDATED LAST_UPDATED,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0FOW_CT_SBJ_BATCH_STG
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.FOW_CT_SUBJECT_BATCH_STG T
	where	T.ID	= S.ID 
		 and ((T.SUBJECT_ID = S.SUBJECT_ID) or (T.SUBJECT_ID IS NULL and S.SUBJECT_ID IS NULL)) and
		((T.BATCH_ID = S.BATCH_ID) or (T.BATCH_ID IS NULL and S.BATCH_ID IS NULL)) and
		((T.RETURNED_MATERIAL_TYPE = S.RETURNED_MATERIAL_TYPE) or (T.RETURNED_MATERIAL_TYPE IS NULL and S.RETURNED_MATERIAL_TYPE IS NULL)) and
		((T.BARCODE = S.BARCODE) or (T.BARCODE IS NULL and S.BARCODE IS NULL)) and
		((T.LAST_UPDATED = S.LAST_UPDATED) or (T.LAST_UPDATED IS NULL and S.LAST_UPDATED IS NULL))
        )

& /*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_FOW_CT_SBJ_BATCH_STG2200001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& /*-----------------------------------------------*/
/* TASK No. 14 */
/* Create Index on flow table */


 /* create index	RAX_APP_USER.I$_FOW_CT_SBJ_BATCH_STG_IDX2200001
on		RAX_APP_USER.I$_FOW_CT_SBJ_BATCH_STG2200001 (ID)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_FOW_CT_SBJ_BATCH_STG_IDX2200001
on		RAX_APP_USER.I$_FOW_CT_SBJ_BATCH_STG2200001 (ID)
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
and	ORIGIN 		= '(2200001)ODS_Project.LOAD_FOW_CT_SUBJECT_BATCH_STG_INT'
and	ERR_TYPE 		= 'F'

& /*-----------------------------------------------*/
/* TASK No. 17 */
/* create error table */


 /* create table RAX_APP_USER.E$_FOW_CT_SBJ_BATCH_STG2200001
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	ID	NUMBER(19) NULL,
	SUBJECT_ID	NUMBER(19) NULL,
	BATCH_ID	NUMBER(19) NULL,
	RETURNED_MATERIAL_TYPE	VARCHAR2(255) NULL,
	BARCODE	VARCHAR2(255) NULL,
	LAST_UPDATED	DATE NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
	ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
	ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
	ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
	ODI_SESS_NO		VARCHAR2(19 CHAR)
) */ 


BEGIN
    EXECUTE IMMEDIATE 'create table RAX_APP_USER.E$_FOW_CT_SBJ_BATCH_STG2200001
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	ID	NUMBER(19) NULL,
	SUBJECT_ID	NUMBER(19) NULL,
	BATCH_ID	NUMBER(19) NULL,
	RETURNED_MATERIAL_TYPE	VARCHAR2(255) NULL,
	BARCODE	VARCHAR2(255) NULL,
	LAST_UPDATED	DATE NULL,
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



delete from 	RAX_APP_USER.E$_FOW_CT_SBJ_BATCH_STG2200001
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(2200001)ODS_Project.LOAD_FOW_CT_SUBJECT_BATCH_STG_INT')

& /*-----------------------------------------------*/
/* TASK No. 19 */
/* Create index on PK */
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */


 /* create index 	RAX_APP_USER.I$_FOW_CT_SBJ_BATCH_STG2200001
on	RAX_APP_USER.I$_FOW_CT_SBJ_BATCH_STG2200001 (ID) */ 


BEGIN
    EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.I$_FOW_CT_SBJ_BATCH_STG2200001
on	RAX_APP_USER.I$_FOW_CT_SBJ_BATCH_STG2200001 (ID)';
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
               SELECT 'RAX_APP_USER.I$_FOW_CT_SBJ_BATCH_STG' INTO CheckTable FROM DUAL;
               SELECT 'ODS_STAGE.FOW_CT_SUBJECT_BATCH_STG' INTO TargetTable FROM DUAL;

IF CheckTable = TargetTable THEN
   VariableCheckTable := CheckTable; 
ELSE
   VariableCheckTable := CheckTable || '2200001';
END IF;

execute immediate '
insert into RAX_APP_USER.E$_FOW_CT_SBJ_BATCH_STG2200001
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
	SUBJECT_ID,
	BATCH_ID,
	RETURNED_MATERIAL_TYPE,
	BARCODE,
	LAST_UPDATED,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	''F'', 
	''ODI-15064: The primary key SYS_C003187322 is not unique.'',
	''(2200001)ODS_Project.LOAD_FOW_CT_SUBJECT_BATCH_STG_INT'',
	sysdate,
	''SYS_C003187322'',
	''PK'',	
	FOW_CT_SUBJECT_BATCH_STG.ID,
	FOW_CT_SUBJECT_BATCH_STG.SUBJECT_ID,
	FOW_CT_SUBJECT_BATCH_STG.BATCH_ID,
	FOW_CT_SUBJECT_BATCH_STG.RETURNED_MATERIAL_TYPE,
	FOW_CT_SUBJECT_BATCH_STG.BARCODE,
	FOW_CT_SUBJECT_BATCH_STG.LAST_UPDATED,
	FOW_CT_SUBJECT_BATCH_STG.ODS_CREATE_DATE,
	FOW_CT_SUBJECT_BATCH_STG.ODS_MODIFY_DATE
from	'
 || VariableCheckTable || 
' FOW_CT_SUBJECT_BATCH_STG 
where	exists  (
		select	SUB1.ID
		from 	' 
|| VariableCheckTable ||
'  SUB1
		where 	SUB1.ID=FOW_CT_SUBJECT_BATCH_STG.ID
		group by 	SUB1.ID
		having 	count(1) > 1
		)
';

END;

& /*-----------------------------------------------*/
/* TASK No. 21 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_FOW_CT_SBJ_BATCH_STG2200001
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
	SUBJECT_ID,
	BATCH_ID,
	RETURNED_MATERIAL_TYPE,
	BARCODE,
	LAST_UPDATED,
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
	'(2200001)ODS_Project.LOAD_FOW_CT_SUBJECT_BATCH_STG_INT',
	'ID',
	'NN',	
	ID,
	SUBJECT_ID,
	BATCH_ID,
	RETURNED_MATERIAL_TYPE,
	BARCODE,
	LAST_UPDATED,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_FOW_CT_SBJ_BATCH_STG2200001
where	ID is null

& /*-----------------------------------------------*/
/* TASK No. 22 */
/* create index on error table */
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */


 /* create index 	RAX_APP_USER.E$_FOW_CT_SBJ_BATCH_STG2200001
on	RAX_APP_USER.E$_FOW_CT_SBJ_BATCH_STG2200001 (ODI_ROW_ID) */ 


BEGIN
    EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_FOW_CT_SBJ_BATCH_STG2200001
on	RAX_APP_USER.E$_FOW_CT_SBJ_BATCH_STG2200001 (ODI_ROW_ID)';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 23 */
/* delete errors from controlled table */



delete from	RAX_APP_USER.I$_FOW_CT_SBJ_BATCH_STG2200001  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_FOW_CT_SBJ_BATCH_STG2200001 E
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
	'FOW_CT_SBJ_BATCH_STG',
	'ODS_STAGE.FOW_CT_SUBJECT_BATCH_STG2200001',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_FOW_CT_SBJ_BATCH_STG2200001 E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(2200001)ODS_Project.LOAD_FOW_CT_SUBJECT_BATCH_STG_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE

& /*-----------------------------------------------*/
/* TASK No. 25 */
/* Merge Rows */



merge into	ODS_STAGE.FOW_CT_SUBJECT_BATCH_STG T
using	RAX_APP_USER.I$_FOW_CT_SBJ_BATCH_STG2200001 S
on	(
		T.ID=S.ID
	)
when matched
then update set
	T.SUBJECT_ID	= S.SUBJECT_ID,
	T.BATCH_ID	= S.BATCH_ID,
	T.RETURNED_MATERIAL_TYPE	= S.RETURNED_MATERIAL_TYPE,
	T.BARCODE	= S.BARCODE,
	T.LAST_UPDATED	= S.LAST_UPDATED
	,     T.ODS_MODIFY_DATE	= sysdate
when not matched
then insert
	(
	T.ID,
	T.SUBJECT_ID,
	T.BATCH_ID,
	T.RETURNED_MATERIAL_TYPE,
	T.BARCODE,
	T.LAST_UPDATED
	,      T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.ID,
	S.SUBJECT_ID,
	S.BATCH_ID,
	S.RETURNED_MATERIAL_TYPE,
	S.BARCODE,
	S.LAST_UPDATED
	,      sysdate,
	sysdate
	)

& /*-----------------------------------------------*/
/* TASK No. 26 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 27 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_FOW_CT_SBJ_BATCH_STG2200001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FOW_CT_SBJ_BATCH_STG2200001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0FOW_CT_SBJ_BATCH_STG purge */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_CT_SBJ_BATCH_STG purge';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 28 */
/* Load ct_subject_batch_xr */



MERGE INTO ODS_STAGE.CT_SUBJECT_BATCH_XR XR
     USING (SELECT ID, SUBJECT_ID, BATCH_ID
              FROM ODS_STAGE.FOW_CT_SUBJECT_BATCH_STG S
             WHERE S.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap) S
        ON (S.ID = XR.ID)
WHEN NOT MATCHED
THEN
   INSERT     (ID,
               CT_SUBJECT_BATCH_OID,
               SUBJECT_ID,
               BATCH_ID,
               ODS_CREATE_DATE,
               ODS_MODIFY_DATE)
       VALUES (S.ID,
               ODS_STAGE.CT_SUBJECT_BATCH_OID_SEQ.NEXTVAL,
               S.SUBJECT_ID,
               S.BATCH_ID,
               SYSDATE,
               SYSDATE)
WHEN MATCHED
THEN
   UPDATE SET
      XR.SUBJECT_ID = S.SUBJECT_ID,
      XR.BATCH_ID = S.BATCH_ID,
      XR.ODS_MODIFY_DATE = SYSDATE
           WHERE    DECODE (S.SUBJECT_ID, XR.SUBJECT_ID, 1, 0) = 0
                 OR DECODE (S.BATCH_ID, XR.BATCH_ID, 1, 0) = 0

& /*-----------------------------------------------*/
/* TASK No. 29 */
/* Load ct_subject_batch */



MERGE INTO ODS_OWN.CT_SUBJECT_BATCH T
     USING (SELECT XR.CT_SUBJECT_BATCH_OID,
                   BXR.CT_BATCH_OID,
                   SXR.CT_SUBJECT_OID,
                   STG.RETURNED_MATERIAL_TYPE,
                   STG.BARCODE,
                   SS.SOURCE_SYSTEM_OID
              FROM ODS_STAGE.CT_SUBJECT_BATCH_XR      XR,
                   ODS_STAGE.FOW_CT_SUBJECT_BATCH_STG STG,
                   ODS_STAGE.CT_SUBJECT_XR            SXR,
                   ODS_STAGE.CT_BATCH_XR              BXR,
                   ODS_OWN.SOURCE_SYSTEM              SS
             WHERE     XR.ID = STG.ID
                   AND XR.SUBJECT_ID = SXR.ID(+)
                   AND XR.BATCH_ID = BXR.ID(+)
                   AND SS.SOURCE_SYSTEM_SHORT_NAME = 'FOW'
                   AND STG.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap) S
        ON (S.CT_SUBJECT_BATCH_OID = T.CT_SUBJECT_BATCH_OID)
WHEN NOT MATCHED
THEN
   INSERT     (CT_SUBJECT_BATCH_OID,
               CT_SUBJECT_OID,
               CT_BATCH_OID,
               RETURNED_MATERIAL_TYPE,
               BARCODE,
               SOURCE_SYSTEM_OID,
               ODS_CREATE_DATE,
               ODS_MODIFY_DATE)
       VALUES (S.CT_SUBJECT_BATCH_OID,
               S.CT_SUBJECT_OID,
               S.CT_BATCH_OID,
               S.RETURNED_MATERIAL_TYPE,
               S.BARCODE,
               S.SOURCE_SYSTEM_OID,
               SYSDATE,
               SYSDATE)
WHEN MATCHED
THEN
   UPDATE SET
      T.ct_subject_OID = S.ct_subject_OID,
      T.ct_batch_OID = S.ct_batch_OID,
      T.returned_material_type = S.returned_material_type,
      T.barcode = S.barcode,
      T.ODS_MODIFY_DATE = SYSDATE
           WHERE    DECODE (T.ct_subject_OID, S.ct_subject_OID, 1, 0) = 0
                 OR DECODE (T.ct_batch_OID, S.ct_batch_OID, 1, 0) = 0
                 OR DECODE (T.returned_material_type, S.returned_material_type, 1, 0) = 0
                 OR DECODE (T.barcode, S.barcode, 1, 0) = 0

& /*-----------------------------------------------*/
/* TASK No. 30 */
/* Fix ct_subject_oid */



MERGE INTO ODS_OWN.CT_SUBJECT_BATCH T
     USING (SELECT SB.CT_SUBJECT_BATCH_OID, SXR.CT_SUBJECT_OID
              FROM ODS_OWN.CT_SUBJECT_BATCH      SB,
                   ODS_STAGE.CT_SUBJECT_BATCH_XR SBXR,
                   ODS_STAGE.CT_SUBJECT_XR       SXR
             WHERE     SB.CT_SUBJECT_BATCH_OID = SBXR.CT_SUBJECT_BATCH_OID
                   AND SBXR.SUBJECT_ID = SXR.ID
                   AND SB.CT_SUBJECT_OID IS NULL) S
        ON (T.CT_SUBJECT_BATCH_OID = S.CT_SUBJECT_BATCH_OID)
WHEN MATCHED
THEN
   UPDATE SET
      T.CT_SUBJECT_OID = S.CT_SUBJECT_OID, T.ODS_modify_DATE = SYSDATE
           WHERE DECODE (T.CT_SUBJECT_OID, S.CT_SUBJECT_OID, 1, 0) = 0

& /*-----------------------------------------------*/
/* TASK No. 31 */
/* Fix ct_batch_oid */



MERGE INTO ODS_OWN.CT_SUBJECT_BATCH T
     USING (SELECT SB.CT_SUBJECT_BATCH_OID, BXR.CT_BATCH_OID
              FROM ODS_OWN.CT_SUBJECT_BATCH      SB,
                   ODS_STAGE.CT_SUBJECT_BATCH_XR SBXR,
                   ODS_STAGE.CT_BATCH_XR         BXR
             WHERE     SB.CT_SUBJECT_BATCH_OID = SBXR.CT_SUBJECT_BATCH_OID
                   AND SBXR.BATCH_ID = BXR.ID
                   AND SB.CT_BATCH_OID IS NULL) S
        ON (T.CT_SUBJECT_BATCH_OID = S.CT_SUBJECT_BATCH_OID)
WHEN MATCHED
THEN
   UPDATE SET T.CT_BATCH_OID = S.CT_BATCH_OID, T.ODS_MODIFY_DATE = SYSDATE
           WHERE DECODE (T.CT_BATCH_OID, S.CT_BATCH_OID, 1, 0) = 0

& /*-----------------------------------------------*/
/* TASK No. 32 */
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
/* TASK No. 33 */
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
'LOAD_FOW_CT_SUBJECT_BATCH_PKG',
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
,'LOAD_FOW_CT_SUBJECT_BATCH_PKG'
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

& /*-----------------------------------------------*/





&