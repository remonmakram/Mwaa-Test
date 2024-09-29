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
/* drop table RAX_APP_USER.C$_0FOW_CT_SUBJECT_STG purge */
/* create table RAX_APP_USER.C$_0FOW_CT_SUBJECT_STG
(
	C1_ID	NUMBER(19) NULL,
	C2_SUBJECT_OID	NUMBER(19) NULL,
	C3_ALTERNATE_NAMES	VARCHAR2(255) NULL,
	C4_DATE_CREATED	DATE NULL,
	C5_CREATED_BY	VARCHAR2(255) NULL,
	C6_UPDATED_BY	VARCHAR2(255) NULL,
	C7_LAST_UPDATED	DATE NULL,
	C8_APO_ID	VARCHAR2(30) NULL,
	C9_EVENT_REF_ID	VARCHAR2(40) NULL
)
NOLOGGING */
/* select	
	CT_SUBJECT.ID	   C1_ID,
	CT_SUBJECT.SUBJECT_OID	   C2_SUBJECT_OID,
	CT_SUBJECT.ALTERNATE_NAMES	   C3_ALTERNATE_NAMES,
	CT_SUBJECT.DATE_CREATED	   C4_DATE_CREATED,
	CT_SUBJECT.CREATED_BY	   C5_CREATED_BY,
	CT_SUBJECT.UPDATED_BY	   C6_UPDATED_BY,
	CT_SUBJECT.LAST_UPDATED	   C7_LAST_UPDATED,
	CT_SUBJECT.APO_ID	   C8_APO_ID,
	CT_SUBJECT.EVENT_REF_ID	   C9_EVENT_REF_ID
from	FOW_OWN.CT_SUBJECT   CT_SUBJECT
where	(1=1)
And (NVL(CT_SUBJECT.LAST_UPDATED, CT_SUBJECT.DATE_CREATED) >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap) */
/* insert  into RAX_APP_USER.C$_0FOW_CT_SUBJECT_STG
(
	C1_ID,
	C2_SUBJECT_OID,
	C3_ALTERNATE_NAMES,
	C4_DATE_CREATED,
	C5_CREATED_BY,
	C6_UPDATED_BY,
	C7_LAST_UPDATED,
	C8_APO_ID,
	C9_EVENT_REF_ID
)
values
(
	:C1_ID,
	:C2_SUBJECT_OID,
	:C3_ALTERNATE_NAMES,
	:C4_DATE_CREATED,
	:C5_CREATED_BY,
	:C6_UPDATED_BY,
	:C7_LAST_UPDATED,
	:C8_APO_ID,
	:C9_EVENT_REF_ID
) */
/* TARGET CODE */
/*+ append */
/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0FOW_CT_SUBJECT_STG',
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


 /* drop table RAX_APP_USER.I$_FOW_CT_SUBJECT_STG2198001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FOW_CT_SUBJECT_STG2198001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Create flow table I$ */


 /* create table RAX_APP_USER.I$_FOW_CT_SUBJECT_STG2198001
(
	ID	NUMBER(19) NULL,
	SUBJECT_OID	NUMBER(19) NULL,
	ALTERNATE_NAMES	VARCHAR2(255) NULL,
	DATE_CREATED	DATE NULL,
	CREATED_BY	VARCHAR2(255) NULL,
	UPDATED_BY	VARCHAR2(255) NULL,
	LAST_UPDATED	DATE NULL,
	APO_ID	VARCHAR2(30) NULL,
	EVENT_REF_ID	VARCHAR2(40) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL
	,IND_UPDATE		char(1)
)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create table RAX_APP_USER.I$_FOW_CT_SUBJECT_STG2198001
(
	ID	NUMBER(19) NULL,
	SUBJECT_OID	NUMBER(19) NULL,
	ALTERNATE_NAMES	VARCHAR2(255) NULL,
	DATE_CREATED	DATE NULL,
	CREATED_BY	VARCHAR2(255) NULL,
	UPDATED_BY	VARCHAR2(255) NULL,
	LAST_UPDATED	DATE NULL,
	APO_ID	VARCHAR2(30) NULL,
	EVENT_REF_ID	VARCHAR2(40) NULL,
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



insert into	RAX_APP_USER.I$_FOW_CT_SUBJECT_STG2198001
(
	ID,
	SUBJECT_OID,
	ALTERNATE_NAMES,
	DATE_CREATED,
	CREATED_BY,
	UPDATED_BY,
	LAST_UPDATED,
	APO_ID,
	EVENT_REF_ID,
	IND_UPDATE
)
select 
ID,
	SUBJECT_OID,
	ALTERNATE_NAMES,
	DATE_CREATED,
	CREATED_BY,
	UPDATED_BY,
	LAST_UPDATED,
	APO_ID,
	EVENT_REF_ID,
	IND_UPDATE
 from (


select 	 
	
	C1_ID ID,
	C2_SUBJECT_OID SUBJECT_OID,
	C3_ALTERNATE_NAMES ALTERNATE_NAMES,
	C4_DATE_CREATED DATE_CREATED,
	C5_CREATED_BY CREATED_BY,
	C6_UPDATED_BY UPDATED_BY,
	C7_LAST_UPDATED LAST_UPDATED,
	C8_APO_ID APO_ID,
	C9_EVENT_REF_ID EVENT_REF_ID,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0FOW_CT_SUBJECT_STG
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.FOW_CT_SUBJECT_STG T
	where	T.ID	= S.ID 
		 and ((T.SUBJECT_OID = S.SUBJECT_OID) or (T.SUBJECT_OID IS NULL and S.SUBJECT_OID IS NULL)) and
		((T.ALTERNATE_NAMES = S.ALTERNATE_NAMES) or (T.ALTERNATE_NAMES IS NULL and S.ALTERNATE_NAMES IS NULL)) and
		((T.DATE_CREATED = S.DATE_CREATED) or (T.DATE_CREATED IS NULL and S.DATE_CREATED IS NULL)) and
		((T.CREATED_BY = S.CREATED_BY) or (T.CREATED_BY IS NULL and S.CREATED_BY IS NULL)) and
		((T.UPDATED_BY = S.UPDATED_BY) or (T.UPDATED_BY IS NULL and S.UPDATED_BY IS NULL)) and
		((T.LAST_UPDATED = S.LAST_UPDATED) or (T.LAST_UPDATED IS NULL and S.LAST_UPDATED IS NULL)) and
		((T.APO_ID = S.APO_ID) or (T.APO_ID IS NULL and S.APO_ID IS NULL)) and
		((T.EVENT_REF_ID = S.EVENT_REF_ID) or (T.EVENT_REF_ID IS NULL and S.EVENT_REF_ID IS NULL))
        )

& /*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_FOW_CT_SUBJECT_STG2198001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& /*-----------------------------------------------*/
/* TASK No. 14 */
/* Create Index on flow table */


 /* create index	RAX_APP_USER.I$_FOW_CT_SUBJECT_STG_IDX2198001
on		RAX_APP_USER.I$_FOW_CT_SUBJECT_STG2198001 (ID)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_FOW_CT_SUBJECT_STG_IDX2198001
on		RAX_APP_USER.I$_FOW_CT_SUBJECT_STG2198001 (ID)
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
and	ORIGIN 		= '(2198001)ODS_Project.LOAD_FOW_CT_SUBJECT_STG_INT'
and	ERR_TYPE 		= 'F'

& /*-----------------------------------------------*/
/* TASK No. 17 */
/* create error table */


 /* create table RAX_APP_USER.E$_FOW_CT_SUBJECT_STG2198001
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	ID	NUMBER(19) NULL,
	SUBJECT_OID	NUMBER(19) NULL,
	ALTERNATE_NAMES	VARCHAR2(255) NULL,
	DATE_CREATED	DATE NULL,
	CREATED_BY	VARCHAR2(255) NULL,
	UPDATED_BY	VARCHAR2(255) NULL,
	LAST_UPDATED	DATE NULL,
	APO_ID	VARCHAR2(30) NULL,
	EVENT_REF_ID	VARCHAR2(40) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
	ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
	ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
	ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
	ODI_SESS_NO		VARCHAR2(19 CHAR)
) */ 


BEGIN
    EXECUTE IMMEDIATE 'create table RAX_APP_USER.E$_FOW_CT_SUBJECT_STG2198001
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	ID	NUMBER(19) NULL,
	SUBJECT_OID	NUMBER(19) NULL,
	ALTERNATE_NAMES	VARCHAR2(255) NULL,
	DATE_CREATED	DATE NULL,
	CREATED_BY	VARCHAR2(255) NULL,
	UPDATED_BY	VARCHAR2(255) NULL,
	LAST_UPDATED	DATE NULL,
	APO_ID	VARCHAR2(30) NULL,
	EVENT_REF_ID	VARCHAR2(40) NULL,
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



delete from 	RAX_APP_USER.E$_FOW_CT_SUBJECT_STG2198001
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(2198001)ODS_Project.LOAD_FOW_CT_SUBJECT_STG_INT')

& /*-----------------------------------------------*/
/* TASK No. 19 */
/* Create index on PK */
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */


 /* create index 	RAX_APP_USER.I$_FOW_CT_SUBJECT_STG2198001
on	RAX_APP_USER.I$_FOW_CT_SUBJECT_STG2198001 (ID) */ 


BEGIN
    EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.I$_FOW_CT_SUBJECT_STG2198001
on	RAX_APP_USER.I$_FOW_CT_SUBJECT_STG2198001 (ID)';
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
               SELECT 'RAX_APP_USER.I$_FOW_CT_SUBJECT_STG' INTO CheckTable FROM DUAL;
               SELECT 'ODS_STAGE.FOW_CT_SUBJECT_STG' INTO TargetTable FROM DUAL;

IF CheckTable = TargetTable THEN
   VariableCheckTable := CheckTable; 
ELSE
   VariableCheckTable := CheckTable || '2198001';
END IF;

execute immediate '
insert into RAX_APP_USER.E$_FOW_CT_SUBJECT_STG2198001
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
	SUBJECT_OID,
	ALTERNATE_NAMES,
	DATE_CREATED,
	CREATED_BY,
	UPDATED_BY,
	LAST_UPDATED,
	APO_ID,
	EVENT_REF_ID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	''F'', 
	''ODI-15064: The primary key SYS_C003187321 is not unique.'',
	''(2198001)ODS_Project.LOAD_FOW_CT_SUBJECT_STG_INT'',
	sysdate,
	''SYS_C003187321'',
	''PK'',	
	FOW_CT_SUBJECT_STG.ID,
	FOW_CT_SUBJECT_STG.SUBJECT_OID,
	FOW_CT_SUBJECT_STG.ALTERNATE_NAMES,
	FOW_CT_SUBJECT_STG.DATE_CREATED,
	FOW_CT_SUBJECT_STG.CREATED_BY,
	FOW_CT_SUBJECT_STG.UPDATED_BY,
	FOW_CT_SUBJECT_STG.LAST_UPDATED,
	FOW_CT_SUBJECT_STG.APO_ID,
	FOW_CT_SUBJECT_STG.EVENT_REF_ID,
	FOW_CT_SUBJECT_STG.ODS_CREATE_DATE,
	FOW_CT_SUBJECT_STG.ODS_MODIFY_DATE
from	'
 || VariableCheckTable || 
' FOW_CT_SUBJECT_STG 
where	exists  (
		select	SUB1.ID
		from 	' 
|| VariableCheckTable ||
'  SUB1
		where 	SUB1.ID=FOW_CT_SUBJECT_STG.ID
		group by 	SUB1.ID
		having 	count(1) > 1
		)
';

END;

& /*-----------------------------------------------*/
/* TASK No. 21 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_FOW_CT_SUBJECT_STG2198001
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
	SUBJECT_OID,
	ALTERNATE_NAMES,
	DATE_CREATED,
	CREATED_BY,
	UPDATED_BY,
	LAST_UPDATED,
	APO_ID,
	EVENT_REF_ID,
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
	'(2198001)ODS_Project.LOAD_FOW_CT_SUBJECT_STG_INT',
	'ID',
	'NN',	
	ID,
	SUBJECT_OID,
	ALTERNATE_NAMES,
	DATE_CREATED,
	CREATED_BY,
	UPDATED_BY,
	LAST_UPDATED,
	APO_ID,
	EVENT_REF_ID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_FOW_CT_SUBJECT_STG2198001
where	ID is null

& /*-----------------------------------------------*/
/* TASK No. 22 */
/* create index on error table */
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */


 /* create index 	RAX_APP_USER.E$_FOW_CT_SUBJECT_STG2198001
on	RAX_APP_USER.E$_FOW_CT_SUBJECT_STG2198001 (ODI_ROW_ID) */ 


BEGIN
    EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_FOW_CT_SUBJECT_STG2198001
on	RAX_APP_USER.E$_FOW_CT_SUBJECT_STG2198001 (ODI_ROW_ID)';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 23 */
/* delete errors from controlled table */



delete from	RAX_APP_USER.I$_FOW_CT_SUBJECT_STG2198001  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_FOW_CT_SUBJECT_STG2198001 E
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
	'FOW_CT_SUBJECT_STG',
	'ODS_STAGE.FOW_CT_SUBJECT_STG2198001',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_FOW_CT_SUBJECT_STG2198001 E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(2198001)ODS_Project.LOAD_FOW_CT_SUBJECT_STG_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE

& /*-----------------------------------------------*/
/* TASK No. 25 */
/* Merge Rows */



merge into	ODS_STAGE.FOW_CT_SUBJECT_STG T
using	RAX_APP_USER.I$_FOW_CT_SUBJECT_STG2198001 S
on	(
		T.ID=S.ID
	)
when matched
then update set
	T.SUBJECT_OID	= S.SUBJECT_OID,
	T.ALTERNATE_NAMES	= S.ALTERNATE_NAMES,
	T.DATE_CREATED	= S.DATE_CREATED,
	T.CREATED_BY	= S.CREATED_BY,
	T.UPDATED_BY	= S.UPDATED_BY,
	T.LAST_UPDATED	= S.LAST_UPDATED,
	T.APO_ID	= S.APO_ID,
	T.EVENT_REF_ID	= S.EVENT_REF_ID
	,        T.ODS_MODIFY_DATE	= sysdate
when not matched
then insert
	(
	T.ID,
	T.SUBJECT_OID,
	T.ALTERNATE_NAMES,
	T.DATE_CREATED,
	T.CREATED_BY,
	T.UPDATED_BY,
	T.LAST_UPDATED,
	T.APO_ID,
	T.EVENT_REF_ID
	,         T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.ID,
	S.SUBJECT_OID,
	S.ALTERNATE_NAMES,
	S.DATE_CREATED,
	S.CREATED_BY,
	S.UPDATED_BY,
	S.LAST_UPDATED,
	S.APO_ID,
	S.EVENT_REF_ID
	,         sysdate,
	sysdate
	)

& /*-----------------------------------------------*/
/* TASK No. 26 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 27 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_FOW_CT_SUBJECT_STG2198001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FOW_CT_SUBJECT_STG2198001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0FOW_CT_SUBJECT_STG purge */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_CT_SUBJECT_STG purge';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 28 */
/* Load ct_subject_xr */



MERGE INTO ODS_STAGE.CT_SUBJECT_XR XR
     USING (SELECT ID, APO_ID, EVENT_REF_ID
              FROM ODS_STAGE.FOW_CT_SUBJECT_STG S
             WHERE S.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap) S
        ON (S.ID = XR.ID)
WHEN NOT MATCHED
THEN
   INSERT     (ID,
               CT_SUBJECT_OID,
               APO_ID,
               EVENT_REF_ID,
               ODS_CREATE_DATE,
               ODS_MODIFY_DATE)
       VALUES (S.ID,
               ODS_STAGE.CT_SUBJECT_OID_SEQ.NEXTVAL,
               S.APO_ID,
               S.EVENT_REF_ID,
               SYSDATE,
               SYSDATE)
WHEN MATCHED
THEN
   UPDATE SET
      XR.APO_ID = S.APO_ID,
      XR.EVENT_REF_ID = S.EVENT_REF_ID,
      XR.ODS_MODIFY_DATE = SYSDATE
           WHERE    DECODE (S.APO_ID, XR.APO_ID, 1, 0) = 0
                 OR DECODE (S.EVENT_REF_ID, XR.EVENT_REF_ID, 1, 0) = 0

& /*-----------------------------------------------*/
/* TASK No. 29 */
/* Load ct_subject */



MERGE INTO ODS_OWN.CT_SUBJECT T
     USING (SELECT XR.CT_SUBJECT_OID,
                   A.APO_OID,
                   E.EVENT_OID,
                   STG.ALTERNATE_NAMES,
                   STG.SUBJECT_OID,
                   SS.SOURCE_SYSTEM_OID
              FROM ODS_STAGE.CT_SUBJECT_XR      XR,
                   ODS_STAGE.FOW_CT_SUBJECT_STG STG,
                   ODS_OWN.APO                  A,
                   ODS_OWN.EVENT                E,
                   ODS_OWN.SOURCE_SYSTEM        SS
             WHERE     XR.ID = STG.ID
                   AND XR.APO_ID = A.APO_ID(+)
                   AND XR.EVENT_REF_ID = E.EVENT_REF_ID(+)
                   AND SS.SOURCE_SYSTEM_SHORT_NAME = 'FOW'
                   AND STG.ODS_MODIFY_DATE  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap) S
        ON (S.CT_SUBJECT_OID = T.CT_SUBJECT_OID)
WHEN NOT MATCHED
THEN
   INSERT     (CT_SUBJECT_OID,
               APO_OID,
               EVENT_OID,
               ALTERNATE_NAMES,
               SUBJECT_OID,
               SOURCE_SYSTEM_OID,
               ODS_CREATE_DATE,
               ODS_MODIFY_DATE)
       VALUES (S.CT_SUBJECT_OID,
               S.APO_OID,
               S.EVENT_OID,
               S.ALTERNATE_NAMES,
               S.SUBJECT_OID,
               S.SOURCE_SYSTEM_OID,
               SYSDATE,
               SYSDATE)
WHEN MATCHED
THEN
   UPDATE SET
      T.APO_OID = S.APO_OID,
      T.EVENT_OID = S.EVENT_OID,
      T.ALTERNATE_NAMES = S.ALTERNATE_NAMES,
      T.SUBJECT_OID = S.SUBJECT_OID,
      T.ODS_MODIFY_DATE = SYSDATE
           WHERE    DECODE (T.APO_OID, S.APO_OID, 1, 0) = 0
                 OR DECODE (T.EVENT_OID, S.EVENT_OID, 1, 0) = 0
                 OR DECODE (T.SUBJECT_OID, S.SUBJECT_OID, 1, 0) = 0
                 OR DECODE (T.ALTERNATE_NAMES, S.ALTERNATE_NAMES, 1, 0) = 0

& /*-----------------------------------------------*/
/* TASK No. 30 */
/* Fix APO_OID */



MERGE INTO ODS_OWN.CT_SUBJECT T
     USING (SELECT S.CT_SUBJECT_OID, A.APO_OID
              FROM ODS_OWN.APO             A,
                   ODS_STAGE.CT_SUBJECT_XR XR,
                   ODS_OWN.CT_SUBJECT      S
             WHERE     A.APO_ID = XR.APO_ID
                   AND XR.CT_SUBJECT_OID = S.CT_SUBJECT_OID
                   AND S.APO_OID IS NULL) S
        ON (T.CT_SUBJECT_OID = S.CT_SUBJECT_OID)
WHEN MATCHED
THEN
   UPDATE SET T.APO_OID = S.APO_OID, T.ODS_MODIFY_DATE = SYSDATE
           WHERE DECODE (T.APO_OID, S.APO_OID, 1, 0) = 0

& /*-----------------------------------------------*/
/* TASK No. 31 */
/* Fix Event_OID */



MERGE INTO ODS_OWN.CT_SUBJECT T
     USING (SELECT S.CT_SUBJECT_OID, e.event_OID
              FROM ODS_OWN.event             e,
                   ODS_STAGE.CT_SUBJECT_XR XR,
                   ODS_OWN.CT_SUBJECT      S
             WHERE     e.event_ref_id = XR.event_ref_id
                   AND XR.CT_SUBJECT_OID = S.CT_SUBJECT_OID
                   AND S.event_oid IS NULL) S
        ON (T.CT_SUBJECT_OID = S.CT_SUBJECT_OID)
WHEN MATCHED
THEN
   UPDATE SET T.event_OID = S.event_OID, T.ODS_MODIFY_DATE = SYSDATE
           WHERE DECODE (T.event_OID, S.event_OID, 1, 0) = 0

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
'LOAD_FOW_CT_SUBJECT_PKG',
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
,'LOAD_FOW_CT_SUBJECT_PKG'
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