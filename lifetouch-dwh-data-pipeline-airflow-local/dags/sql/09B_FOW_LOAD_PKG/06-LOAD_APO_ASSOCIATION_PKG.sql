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
/* Delete from stage */



DELETE FROM ODS_STAGE.FOW_APO_ASSOCIATION_STG stg
      WHERE EXISTS
                (SELECT 1
                   FROM ODS_STAGE.FOW_RECORD_CHANGE_AUDIT rca
                  WHERE     stg.ID = rca.KEY_VALUE
                        AND rca.TABLE_NAME = 'APO_ASSOCIATION'
                        AND rca.EVENT_TYPE = 'DELETE'
                        AND rca.ODS_MODIFY_DATE >=TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap)

& 
/*-----------------------------------------------*/
/* TASK No. 5 */
/* Delete from own */



DELETE FROM ODS_OWN.APO_ASSOCIATION aa
      WHERE EXISTS
                (SELECT 1
                   FROM ODS_STAGE.FOW_RECORD_CHANGE_AUDIT  rca,
                        ODS_STAGE.APO_ASSOCIATION_XR       xr
                  WHERE     xr.ID = rca.KEY_VALUE
                        AND xr.APO_ASSOCIATION_OID = aa.APO_ASSOCIATION_OID
                        AND rca.TABLE_NAME = 'APO_ASSOCIATION'
                        AND rca.EVENT_TYPE = 'DELETE'
                        AND rca.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap)

& 
/*-----------------------------------------------*/
/* TASK No. 6 */
/* Drop work table */
/*-----------------------------------------------*/
/* TASK No. 7 */
/* Create work table */
/*-----------------------------------------------*/
/* TASK No. 8 */
/* Load data */
/* SOURCE CODE */
/* drop table RAX_APP_USER.C$_0FOW_APO_ASSOCIATION_STG purge */
/* create table RAX_APP_USER.C$_0FOW_APO_ASSOCIATION_STG
(
	C1_ID	NUMBER NULL,
	C2_VERSION	NUMBER NULL,
	C3_APO_ID	NUMBER NULL,
	C4_ASSOCIATED_APO_TAG	VARCHAR2(255) NULL,
	C5_CREATED_BY	VARCHAR2(255) NULL,
	C6_DATE_CREATED	DATE NULL
)
NOLOGGING */
/* select	
	APO_ASSOCIATION.ID	   C1_ID,
	APO_ASSOCIATION.VERSION	   C2_VERSION,
	APO_ASSOCIATION.APO_ID	   C3_APO_ID,
	APO_ASSOCIATION.ASSOCIATED_APO_TAG	   C4_ASSOCIATED_APO_TAG,
	APO_ASSOCIATION.CREATED_BY	   C5_CREATED_BY,
	APO_ASSOCIATION.DATE_CREATED	   C6_DATE_CREATED
from	FOW_OWN.APO_ASSOCIATION   APO_ASSOCIATION
where	(1=1)
And (APO_ASSOCIATION.DATE_CREATED>= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap) */
/* insert  into RAX_APP_USER.C$_0FOW_APO_ASSOCIATION_STG
(
	C1_ID,
	C2_VERSION,
	C3_APO_ID,
	C4_ASSOCIATED_APO_TAG,
	C5_CREATED_BY,
	C6_DATE_CREATED
)
values
(
	:C1_ID,
	:C2_VERSION,
	:C3_APO_ID,
	:C4_ASSOCIATED_APO_TAG,
	:C5_CREATED_BY,
	:C6_DATE_CREATED
) */
/* TARGET CODE */
/*+ append */
/*-----------------------------------------------*/
/* TASK No. 9 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0FOW_APO_ASSOCIATION_STG',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;

& 
/*-----------------------------------------------*/
/* TASK No. 11 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& 
/*-----------------------------------------------*/
/* TASK No. 12 */
/* Create flow table I$ */


 /* create table RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG
(
	ID		NUMBER NULL,
	VERSION		NUMBER NULL,
	APO_ID		NUMBER NULL,
	ASSOCIATED_APO_TAG		VARCHAR2(255) NULL,
	CREATED_BY		VARCHAR2(255) NULL,
	DATE_CREATED		DATE NULL,
	ODS_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create table RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG
(
	ID		NUMBER NULL,
	VERSION		NUMBER NULL,
	APO_ID		NUMBER NULL,
	ASSOCIATED_APO_TAG		VARCHAR2(255) NULL,
	CREATED_BY		VARCHAR2(255) NULL,
	DATE_CREATED		DATE NULL,
	ODS_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& 
/*-----------------------------------------------*/
/* TASK No. 13 */
/* Insert flow into I$ table */
/* DETECTION_STRATEGY = NOT_EXISTS */



insert into	RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG
(
	ID,
	VERSION,
	APO_ID,
	ASSOCIATED_APO_TAG,
	CREATED_BY,
	DATE_CREATED,
	IND_UPDATE
)
select 
ID,
	VERSION,
	APO_ID,
	ASSOCIATED_APO_TAG,
	CREATED_BY,
	DATE_CREATED,
	IND_UPDATE
 from (


select 	 
	
	C1_ID ID,
	C2_VERSION VERSION,
	C3_APO_ID APO_ID,
	C4_ASSOCIATED_APO_TAG ASSOCIATED_APO_TAG,
	C5_CREATED_BY CREATED_BY,
	C6_DATE_CREATED DATE_CREATED,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0FOW_APO_ASSOCIATION_STG
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.FOW_APO_ASSOCIATION_STG T
	where	T.ID	= S.ID 
		 and ((T.VERSION = S.VERSION) or (T.VERSION IS NULL and S.VERSION IS NULL)) and
		((T.APO_ID = S.APO_ID) or (T.APO_ID IS NULL and S.APO_ID IS NULL)) and
		((T.ASSOCIATED_APO_TAG = S.ASSOCIATED_APO_TAG) or (T.ASSOCIATED_APO_TAG IS NULL and S.ASSOCIATED_APO_TAG IS NULL)) and
		((T.CREATED_BY = S.CREATED_BY) or (T.CREATED_BY IS NULL and S.CREATED_BY IS NULL)) and
		((T.DATE_CREATED = S.DATE_CREATED) or (T.DATE_CREATED IS NULL and S.DATE_CREATED IS NULL))
        )

& 
/*-----------------------------------------------*/
/* TASK No. 14 */
/* Create Index on flow table */


 /* create index	RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG_IDX
on		RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG (ID)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG_IDX
on		RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG (ID)
NOLOGGING';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& 
/*-----------------------------------------------*/
/* TASK No. 15 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_FOW_APO_ASSOCIATION_STG',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& 
/*-----------------------------------------------*/
/* TASK No. 16 */
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
    

& 
/*-----------------------------------------------*/
/* TASK No. 17 */
/* delete previous check sum */



delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS_STAGE'
and	ORIGIN 		= '(2450001)ODS_Project.LOAD_FOW_APO_ASSOCIATION_STG_INT'
and	ERR_TYPE 		= 'F'

&
 /*-----------------------------------------------*/
/* TASK No. 18 */
/* create error table */


 /* create table RAX_APP_USER.E$_FOW_APO_ASSOCIATION_STG
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	ID	NUMBER NULL,
	VERSION	NUMBER NULL,
	APO_ID	NUMBER NULL,
	ASSOCIATED_APO_TAG	VARCHAR2(255) NULL,
	CREATED_BY	VARCHAR2(255) NULL,
	DATE_CREATED	DATE NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
	ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
	ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
	ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
	ODI_SESS_NO		VARCHAR2(19 CHAR)
) */ 


BEGIN
    EXECUTE IMMEDIATE 'create table RAX_APP_USER.E$_FOW_APO_ASSOCIATION_STG
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	ID	NUMBER NULL,
	VERSION	NUMBER NULL,
	APO_ID	NUMBER NULL,
	ASSOCIATED_APO_TAG	VARCHAR2(255) NULL,
	CREATED_BY	VARCHAR2(255) NULL,
	DATE_CREATED	DATE NULL,
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
/* TASK No. 19 */
/* delete previous errors */



delete from 	RAX_APP_USER.E$_FOW_APO_ASSOCIATION_STG
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(2450001)ODS_Project.LOAD_FOW_APO_ASSOCIATION_STG_INT')

& 
/*-----------------------------------------------*/
/* TASK No. 20 */
/* Create index on PK */
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */


 /* create index 	RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG_IDX
on	RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG (ID) */ 


BEGIN
    EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG_IDX
on	RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG (ID)';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

&
 /*-----------------------------------------------*/
/* TASK No. 21 */
/* insert PK errors */



insert into RAX_APP_USER.E$_FOW_APO_ASSOCIATION_STG
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
	VERSION,
	APO_ID,
	ASSOCIATED_APO_TAG,
	CREATED_BY,
	DATE_CREATED,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15064: The primary key PK_APO_ASSOCIATION is not unique.',
	'(2450001)ODS_Project.LOAD_FOW_APO_ASSOCIATION_STG_INT',
	sysdate,
	'PK_APO_ASSOCIATION',
	'PK',	
	FOW_APO_ASSOCIATION_STG.ID,
	FOW_APO_ASSOCIATION_STG.VERSION,
	FOW_APO_ASSOCIATION_STG.APO_ID,
	FOW_APO_ASSOCIATION_STG.ASSOCIATED_APO_TAG,
	FOW_APO_ASSOCIATION_STG.CREATED_BY,
	FOW_APO_ASSOCIATION_STG.DATE_CREATED,
	FOW_APO_ASSOCIATION_STG.ODS_CREATE_DATE,
	FOW_APO_ASSOCIATION_STG.ODS_MODIFY_DATE
from	RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG   FOW_APO_ASSOCIATION_STG
where	exists  (
		select	SUB.ID
		from 	RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG SUB
		where 	SUB.ID=FOW_APO_ASSOCIATION_STG.ID
		group by 	SUB.ID
		having 	count(1) > 1
		)

& /*-----------------------------------------------*/
/* TASK No. 22 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_FOW_APO_ASSOCIATION_STG
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
	VERSION,
	APO_ID,
	ASSOCIATED_APO_TAG,
	CREATED_BY,
	DATE_CREATED,
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
	'(2450001)ODS_Project.LOAD_FOW_APO_ASSOCIATION_STG_INT',
	'ID',
	'NN',	
	ID,
	VERSION,
	APO_ID,
	ASSOCIATED_APO_TAG,
	CREATED_BY,
	DATE_CREATED,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG
where	ID is null

& /*-----------------------------------------------*/
/* TASK No. 23 */
/* create index on error table */
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */


 /* create index 	RAX_APP_USER.E$_FOW_APO_ASSOCIATION_STG_IDX
on	RAX_APP_USER.E$_FOW_APO_ASSOCIATION_STG (ODI_ROW_ID) */ 


BEGIN
    EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_FOW_APO_ASSOCIATION_STG_IDX
on	RAX_APP_USER.E$_FOW_APO_ASSOCIATION_STG (ODI_ROW_ID)';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 24 */
/* delete errors from controlled table */



delete from	RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_FOW_APO_ASSOCIATION_STG E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)

& /*-----------------------------------------------*/
/* TASK No. 25 */
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
	'FOW_APO_ASSOCIATION_STG',
	'ODS_STAGE.FOW_APO_ASSOCIATION_STG',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_FOW_APO_ASSOCIATION_STG E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(2450001)ODS_Project.LOAD_FOW_APO_ASSOCIATION_STG_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE

& /*-----------------------------------------------*/
/* TASK No. 26 */
/* Flag rows for update */
/* DETECTION_STRATEGY = NOT_EXISTS */



update	RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG
set	IND_UPDATE = 'U'
where	(ID)
	in	(
		select	ID
		from	ODS_STAGE.FOW_APO_ASSOCIATION_STG
		)

& /*-----------------------------------------------*/
/* TASK No. 27 */
/* Flag useless rows */
/* DETECTION_STRATEGY = NOT_EXISTS */
/* Command skipped due to chosen DETECTION_STRATEGY */
/*-----------------------------------------------*/
/* TASK No. 28 */
/* Update existing rows */
/* DETECTION_STRATEGY = NOT_EXISTS */



update	ODS_STAGE.FOW_APO_ASSOCIATION_STG T
set 	
	(
	T.VERSION,
	T.APO_ID,
	T.ASSOCIATED_APO_TAG,
	T.CREATED_BY,
	T.DATE_CREATED
	) =
		(
		select	S.VERSION,
			S.APO_ID,
			S.ASSOCIATED_APO_TAG,
			S.CREATED_BY,
			S.DATE_CREATED
		from	RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG S
		where	T.ID	=S.ID
	    	 )
	,     T.ODS_MODIFY_DATE = sysdate

where	(ID)
	in	(
		select	ID
		from	RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG
		where	IND_UPDATE = 'U'
		)

& /*-----------------------------------------------*/
/* TASK No. 29 */
/* Insert new rows */
/* DETECTION_STRATEGY = NOT_EXISTS */



insert into 	ODS_STAGE.FOW_APO_ASSOCIATION_STG T
	(
	ID,
	VERSION,
	APO_ID,
	ASSOCIATED_APO_TAG,
	CREATED_BY,
	DATE_CREATED
	,      ODS_CREATE_DATE,
	ODS_MODIFY_DATE
	)
select 	ID,
	VERSION,
	APO_ID,
	ASSOCIATED_APO_TAG,
	CREATED_BY,
	DATE_CREATED
	,      sysdate,
	sysdate
from	RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG S



where	IND_UPDATE = 'I'

& /*-----------------------------------------------*/
/* TASK No. 30 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 31 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FOW_APO_ASSOCIATION_STG';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 1000010 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0FOW_APO_ASSOCIATION_STG purge */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_APO_ASSOCIATION_STG purge';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 32 */
/* Load APO_Association_XR */



MERGE INTO ODS_STAGE.APO_ASSOCIATION_XR d
     USING (SELECT id, apo_id, associated_apo_tag
              FROM ODS_STAGE.FOW_APO_ASSOCIATION_STG
             WHERE ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (s.id = d.id)
WHEN MATCHED
THEN
    UPDATE SET
        d.apo_id = s.apo_id,
        d.associated_apo_tag = s.associated_apo_tag,
        d.ods_modify_date = SYSDATE
             WHERE    DECODE (s.apo_id, d.apo_id, 1, 0) = 0
                   OR DECODE (s.associated_apo_tag,d.associated_apo_tag, 1,0) =0
WHEN NOT MATCHED
THEN
    INSERT     (apo_association_oid,
                id,
                apo_id,
                associated_apo_tag,
                ods_create_date,
                ods_modify_date)
        VALUES (ods_stage.apo_association_oid_seq.NEXTVAL,
                s.id,
                s.apo_id,
                s.associated_apo_tag,
                SYSDATE,
                SYSDATE)

& /*-----------------------------------------------*/
/* TASK No. 33 */
/* Load APO_Association */



MERGE INTO ODS_OWN.APO_ASSOCIATION d
     USING (SELECT xr.APO_ASSOCIATION_OID,
                   parent_apo.APO_OID     parent_apo_oid,
                   child_apo.APO_OID      child_apo_oid,
                   stg.VERSION,
                   ss.source_system_oid
              FROM ODS_STAGE.FOW_APO_ASSOCIATION_STG  stg,
                   ODS_STAGE.APO_ASSOCIATION_XR       xr,
                   ODS_STAGE.APO_XR                   parent_apo,
                   ODS_STAGE.APO_XR                   child_apo,
                   ods_own.source_system              ss
             WHERE     stg.ID = xr.ID
                   AND xr.APO_ID = parent_apo.fow_sk_ID
                   AND xr.ASSOCIATED_APO_TAG = child_apo.apo_ID
                   AND ss.source_system_short_name = 'FOW'
                   AND stg.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (d.apo_association_oid = s.apo_association_oid)
WHEN MATCHED
THEN
    UPDATE SET
        d.parent_apo_oid = s.parent_apo_oid,
        d.child_apo_oid = s.child_apo_oid,
        d.version = s.version,
        d.ods_modify_date = SYSDATE
             WHERE    DECODE (s.parent_apo_oid, d.parent_apo_oid, 1, 0) = 0
                   OR DECODE (s.child_apo_oid, d.child_apo_oid, 1, 0) = 0
                   OR DECODE (s.version, d.version, 1, 0) = 0
WHEN NOT MATCHED
THEN
    INSERT     (apo_association_oid,
                parent_apo_oid,
                child_apo_oid,
                version,
                ods_create_date,
                ods_modify_date,
                source_system_oid)
        VALUES (s.apo_association_oid,
                s.parent_apo_oid,
                s.child_apo_oid,
                s.version,
                SYSDATE,
                SYSDATE,
                s.source_system_oid)

& /*-----------------------------------------------*/
/* TASK No. 34 */
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
/* TASK No. 35 */
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
'LOAD_APO_ASSOCIATION_PKG',
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
,'LOAD_APO_ASSOCIATION_PKG'
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