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
/* drop table RAX_APP_USER.C$_0PS_SU_CPN_ATTR_STG purge */
/* create table RAX_APP_USER.C$_0PS_SU_CPN_ATTR_STG
(
	C1_SU_COUPON_ATTRIBUTE_ID	NUMBER(19) NULL,
	C2_SU_COUPON_BATCH	NUMBER(19) NULL,
	C3_TYPE	VARCHAR2(255) NULL,
	C4_VALUE	VARCHAR2(4000) NULL
)
NOLOGGING */
/* select	
	SU_COUPON_ATTRIBUTE.SU_COUPON_ATTRIBUTE_ID	   C1_SU_COUPON_ATTRIBUTE_ID,
	SU_COUPON_ATTRIBUTE.SU_COUPON_BATCH	   C2_SU_COUPON_BATCH,
	SU_COUPON_ATTRIBUTE.TYPE	   C3_TYPE,
	SU_COUPON_ATTRIBUTE.VALUE	   C4_VALUE
from	PS_OWN.SU_COUPON_ATTRIBUTE   SU_COUPON_ATTRIBUTE
where	(1=1) */
/* insert  into RAX_APP_USER.C$_0PS_SU_CPN_ATTR_STG
(
	C1_SU_COUPON_ATTRIBUTE_ID,
	C2_SU_COUPON_BATCH,
	C3_TYPE,
	C4_VALUE
)
values
(
	:C1_SU_COUPON_ATTRIBUTE_ID,
	:C2_SU_COUPON_BATCH,
	:C3_TYPE,
	:C4_VALUE
) */
/* TARGET CODE */
/*+ append */
/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0PS_SU_CPN_ATTR_STG',
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


 /* drop table RAX_APP_USER.I$_PS_SU_CPN_ATTR_STG2075001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_PS_SU_CPN_ATTR_STG2075001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Create flow table I$ */



create table RAX_APP_USER.I$_PS_SU_CPN_ATTR_STG2075001
(
	SU_COUPON_ATTRIBUTE_ID	NUMBER(19) NULL,
	SU_COUPON_BATCH	NUMBER(19) NULL,
	TYPE	VARCHAR2(255) NULL,
	VALUE	VARCHAR2(4000) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

& /*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert flow into I$ table */
/* DETECTION_STRATEGY = NOT_EXISTS */



insert into	RAX_APP_USER.I$_PS_SU_CPN_ATTR_STG2075001
(
	SU_COUPON_ATTRIBUTE_ID,
	SU_COUPON_BATCH,
	TYPE,
	VALUE,
	IND_UPDATE
)
select 
SU_COUPON_ATTRIBUTE_ID,
	SU_COUPON_BATCH,
	TYPE,
	VALUE,
	IND_UPDATE
 from (


select 	 
	
	C1_SU_COUPON_ATTRIBUTE_ID SU_COUPON_ATTRIBUTE_ID,
	C2_SU_COUPON_BATCH SU_COUPON_BATCH,
	C3_TYPE TYPE,
	C4_VALUE VALUE,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0PS_SU_CPN_ATTR_STG
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.PS_SU_COUPON_ATTRIBUTE_STG T
	where	T.SU_COUPON_ATTRIBUTE_ID	= S.SU_COUPON_ATTRIBUTE_ID 
		 and ((T.SU_COUPON_BATCH = S.SU_COUPON_BATCH) or (T.SU_COUPON_BATCH IS NULL and S.SU_COUPON_BATCH IS NULL)) and
		((T.TYPE = S.TYPE) or (T.TYPE IS NULL and S.TYPE IS NULL)) and
		((T.VALUE = S.VALUE) or (T.VALUE IS NULL and S.VALUE IS NULL))
        )

& /*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_PS_SU_CPN_ATTR_STG2075001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& /*-----------------------------------------------*/
/* TASK No. 14 */
/* Create Index on flow table */


 /* create index	RAX_APP_USER.I$_PS_SU_CPN_ATTR_STG_IDX2075001
on		RAX_APP_USER.I$_PS_SU_CPN_ATTR_STG2075001 (SU_COUPON_ATTRIBUTE_ID)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_PS_SU_CPN_ATTR_STG_IDX2075001
on		RAX_APP_USER.I$_PS_SU_CPN_ATTR_STG2075001 (SU_COUPON_ATTRIBUTE_ID)
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
and	ORIGIN 		= '(2075001)ODS_Project.LOAD_SU_COUPON_ATTRIBUTE_INT'
and	ERR_TYPE 		= 'F'

& /*-----------------------------------------------*/
/* TASK No. 17 */
/* create error table */

-- create table RAX_APP_USER.E$_PS_SU_CPN_ATTR_STG2075001
-- (
-- 	ODI_ROW_ID 		UROWID,
-- 	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
-- 	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
-- 	ODI_CHECK_DATE	DATE NULL, 
-- 	SU_COUPON_ATTRIBUTE_ID	NUMBER(19) NULL,
-- 	SU_COUPON_BATCH	NUMBER(19) NULL,
-- 	TYPE	VARCHAR2(255) NULL,
-- 	VALUE	VARCHAR2(4000) NULL,
-- 	ODS_CREATE_DATE	DATE NULL,
-- 	ODS_MODIFY_DATE	DATE NULL,
-- 	ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
-- 	ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
-- 	ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
-- 	ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
-- 	ODI_SESS_NO		VARCHAR2(19 CHAR)
-- )


BEGIN
    EXECUTE IMMEDIATE 'create table RAX_APP_USER.E$_PS_SU_CPN_ATTR_STG2075001
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	SU_COUPON_ATTRIBUTE_ID	NUMBER(19) NULL,
	SU_COUPON_BATCH	NUMBER(19) NULL,
	TYPE	VARCHAR2(255) NULL,
	VALUE	VARCHAR2(4000) NULL,
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



delete from 	RAX_APP_USER.E$_PS_SU_CPN_ATTR_STG2075001
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(2075001)ODS_Project.LOAD_SU_COUPON_ATTRIBUTE_INT')

& /*-----------------------------------------------*/
/* TASK No. 19 */
/* Create index on PK */
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */


 /* create index 	RAX_APP_USER.I$_PS_SU_CPN_ATTR_STG2075001
on	RAX_APP_USER.I$_PS_SU_CPN_ATTR_STG2075001 (SU_COUPON_ATTRIBUTE_ID) */ 


BEGIN
    EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.I$_PS_SU_CPN_ATTR_STG2075001
on	RAX_APP_USER.I$_PS_SU_CPN_ATTR_STG2075001 (SU_COUPON_ATTRIBUTE_ID)';
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
               SELECT 'RAX_APP_USER.I$_PS_SU_CPN_ATTR_STG' INTO CheckTable FROM DUAL;
               SELECT 'ODS_STAGE.PS_SU_COUPON_ATTRIBUTE_STG' INTO TargetTable FROM DUAL;

IF CheckTable = TargetTable THEN
   VariableCheckTable := CheckTable; 
ELSE
   VariableCheckTable := CheckTable || '2075001';
END IF;

execute immediate '
insert into RAX_APP_USER.E$_PS_SU_CPN_ATTR_STG2075001
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
	SU_COUPON_ATTRIBUTE_ID,
	SU_COUPON_BATCH,
	TYPE,
	VALUE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	''F'', 
	''ODI-15064: The primary key PS_SU_COUPON_ATTRIBUTE_PK is not unique.'',
	''(2075001)ODS_Project.LOAD_SU_COUPON_ATTRIBUTE_INT'',
	sysdate,
	''PS_SU_COUPON_ATTRIBUTE_PK'',
	''PK'',	
	PS_SU_COUPON_ATTRIBUTE_STG.SU_COUPON_ATTRIBUTE_ID,
	PS_SU_COUPON_ATTRIBUTE_STG.SU_COUPON_BATCH,
	PS_SU_COUPON_ATTRIBUTE_STG.TYPE,
	PS_SU_COUPON_ATTRIBUTE_STG.VALUE,
	PS_SU_COUPON_ATTRIBUTE_STG.ODS_CREATE_DATE,
	PS_SU_COUPON_ATTRIBUTE_STG.ODS_MODIFY_DATE
from	'
 || VariableCheckTable || 
' PS_SU_COUPON_ATTRIBUTE_STG 
where	exists  (
		select	SUB1.SU_COUPON_ATTRIBUTE_ID
		from 	' 
|| VariableCheckTable ||
'  SUB1
		where 	SUB1.SU_COUPON_ATTRIBUTE_ID=PS_SU_COUPON_ATTRIBUTE_STG.SU_COUPON_ATTRIBUTE_ID
		group by 	SUB1.SU_COUPON_ATTRIBUTE_ID
		having 	count(1) > 1
		)
';

END;

& /*-----------------------------------------------*/
/* TASK No. 21 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_PS_SU_CPN_ATTR_STG2075001
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
	SU_COUPON_ATTRIBUTE_ID,
	SU_COUPON_BATCH,
	TYPE,
	VALUE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column SU_COUPON_ATTRIBUTE_ID cannot be null.',
	sysdate,
	'(2075001)ODS_Project.LOAD_SU_COUPON_ATTRIBUTE_INT',
	'SU_COUPON_ATTRIBUTE_ID',
	'NN',	
	SU_COUPON_ATTRIBUTE_ID,
	SU_COUPON_BATCH,
	TYPE,
	VALUE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PS_SU_CPN_ATTR_STG2075001
where	SU_COUPON_ATTRIBUTE_ID is null

& /*-----------------------------------------------*/
/* TASK No. 22 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_PS_SU_CPN_ATTR_STG2075001
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
	SU_COUPON_ATTRIBUTE_ID,
	SU_COUPON_BATCH,
	TYPE,
	VALUE,
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
	'(2075001)ODS_Project.LOAD_SU_COUPON_ATTRIBUTE_INT',
	'SU_COUPON_BATCH',
	'NN',	
	SU_COUPON_ATTRIBUTE_ID,
	SU_COUPON_BATCH,
	TYPE,
	VALUE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PS_SU_CPN_ATTR_STG2075001
where	SU_COUPON_BATCH is null

& /*-----------------------------------------------*/
/* TASK No. 23 */
/* create index on error table */
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */


 /* create index 	RAX_APP_USER.E$_PS_SU_CPN_ATTR_STG2075001
on	RAX_APP_USER.E$_PS_SU_CPN_ATTR_STG2075001 (ODI_ROW_ID) */ 


BEGIN
    EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_PS_SU_CPN_ATTR_STG2075001
on	RAX_APP_USER.E$_PS_SU_CPN_ATTR_STG2075001 (ODI_ROW_ID)';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 24 */
/* delete errors from controlled table */



delete from	RAX_APP_USER.I$_PS_SU_CPN_ATTR_STG2075001  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_PS_SU_CPN_ATTR_STG2075001 E
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
	'PS_SU_CPN_ATTR_STG',
	'ODS_STAGE.PS_SU_COUPON_ATTRIBUTE_STG2075001',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_PS_SU_CPN_ATTR_STG2075001 E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(2075001)ODS_Project.LOAD_SU_COUPON_ATTRIBUTE_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE

& /*-----------------------------------------------*/
/* TASK No. 26 */
/* Merge Rows */



merge into	ODS_STAGE.PS_SU_COUPON_ATTRIBUTE_STG T
using	RAX_APP_USER.I$_PS_SU_CPN_ATTR_STG2075001 S
on	(
		T.SU_COUPON_ATTRIBUTE_ID=S.SU_COUPON_ATTRIBUTE_ID
	)
when matched
then update set
	T.SU_COUPON_BATCH	= S.SU_COUPON_BATCH,
	T.TYPE	= S.TYPE,
	T.VALUE	= S.VALUE
	,   T.ODS_MODIFY_DATE	= sysdate
when not matched
then insert
	(
	T.SU_COUPON_ATTRIBUTE_ID,
	T.SU_COUPON_BATCH,
	T.TYPE,
	T.VALUE
	,    T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.SU_COUPON_ATTRIBUTE_ID,
	S.SU_COUPON_BATCH,
	S.TYPE,
	S.VALUE
	,    sysdate,
	sysdate
	)

& /*-----------------------------------------------*/
/* TASK No. 27 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 28 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_PS_SU_CPN_ATTR_STG2075001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_PS_SU_CPN_ATTR_STG2075001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0PS_SU_CPN_ATTR_STG purge */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0PS_SU_CPN_ATTR_STG purge';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 29 */
/* LOAD PS_COUPON_ATTRIBUTE_XR */



MERGE INTO ods_stage.ps_coupon_attribute_xr d
   USING (SELECT stg.su_coupon_attribute_id, stg.su_coupon_batch
            FROM ods_stage.ps_su_coupon_attribute_stg stg
           WHERE stg.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
   ON (s.su_coupon_attribute_id = d.sk_coupon_attribute_id)
   WHEN MATCHED THEN
      UPDATE
         SET d.sk_coupon_batch_id = s.su_coupon_batch,
             d.ods_modify_date = SYSDATE
         WHERE DECODE (d.sk_coupon_batch_id,
                       s.su_coupon_batch, 1,
                       0
                      ) = 0
   WHEN NOT MATCHED THEN
      INSERT (coupon_attribute_oid, sk_coupon_attribute_id,
              sk_coupon_batch_id, ods_create_date, ods_modify_date)
      VALUES (ods_stage.coupon_attribute_oid_seq.NEXTVAL,
              s.su_coupon_attribute_id, s.su_coupon_batch, SYSDATE,
              SYSDATE)

& /*-----------------------------------------------*/
/* TASK No. 30 */
/* Load Coupon_Attribute */



MERGE INTO ods_own.coupon_attribute d
   USING (SELECT xr.coupon_attribute_oid, cb_xr.coupon_batch_oid,
                 stg.TYPE, stg.VALUE
            FROM ods_stage.ps_su_coupon_attribute_stg stg,
                 ods_stage.ps_coupon_attribute_xr xr,
                 ods_stage.ps_coupon_batch_xr cb_xr,
                 ods_own.source_system ss
           WHERE stg.su_coupon_attribute_id =
                                             xr.sk_coupon_attribute_id
             AND stg.su_coupon_batch = cb_xr.sk_coupon_batch_id
             AND ss.source_system_short_name = 'PS'
             AND stg.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
   ON (d.coupon_attribute_oid = s.coupon_attribute_oid)
   WHEN MATCHED THEN
      UPDATE
         SET d.coupon_batch_oid = s.coupon_batch_oid, d.TYPE = s.TYPE,
             d.VALUE = s.VALUE, d.ods_modify_date = SYSDATE
         WHERE    DECODE (d.coupon_batch_oid,
                          s.coupon_batch_oid, 1,
                          0
                         ) = 0
               OR DECODE (d.TYPE, s.TYPE, 1, 0) = 0
               OR DECODE (d.VALUE, s.VALUE, 1, 0) = 0
   WHEN NOT MATCHED THEN
      INSERT (coupon_attribute_oid, coupon_batch_oid, VALUE, TYPE,
              ods_create_date, ods_modify_date)
      VALUES (s.coupon_attribute_oid, s.coupon_batch_oid, s.VALUE,
              s.TYPE, SYSDATE, SYSDATE)

& /*-----------------------------------------------*/
/* TASK No. 31 */
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
/* TASK No. 32 */
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
'LOAD_SU_COUPON_ATTRIBUTE_PKG',
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
,'LOAD_SU_COUPON_ATTRIBUTE_PKG'
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