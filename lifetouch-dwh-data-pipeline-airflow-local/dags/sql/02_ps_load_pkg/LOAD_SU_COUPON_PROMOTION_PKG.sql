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
/* drop table RAX_APP_USER.C$_0PS_SU_CPN_PROMO_STG purge */
/* create table RAX_APP_USER.C$_0PS_SU_CPN_PROMO_STG
(
	C1_SU_COUPON_PROMOTION_ID	NUMBER(19) NULL,
	C2_SU_COUPON_BATCH	NUMBER(19) NULL,
	C3_PROMOTION	NUMBER(19) NULL
)
NOLOGGING */
/* select	
	SU_COUPON_PROMOTION.SU_COUPON_PROMOTION_ID	   C1_SU_COUPON_PROMOTION_ID,
	SU_COUPON_PROMOTION.SU_COUPON_BATCH	   C2_SU_COUPON_BATCH,
	SU_COUPON_PROMOTION.PROMOTION	   C3_PROMOTION
from	PS_OWN.SU_COUPON_PROMOTION   SU_COUPON_PROMOTION
where	(1=1) */
/* insert  into RAX_APP_USER.C$_0PS_SU_CPN_PROMO_STG
(
	C1_SU_COUPON_PROMOTION_ID,
	C2_SU_COUPON_BATCH,
	C3_PROMOTION
)
values
(
	:C1_SU_COUPON_PROMOTION_ID,
	:C2_SU_COUPON_BATCH,
	:C3_PROMOTION
) */
/* TARGET CODE */
/*+ append */
/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0PS_SU_CPN_PROMO_STG',
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


 /* drop table RAX_APP_USER.I$_PS_SU_CPN_PROMO_STG2076001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_PS_SU_CPN_PROMO_STG2076001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Create flow table I$ */



create table RAX_APP_USER.I$_PS_SU_CPN_PROMO_STG2076001
(
	SU_COUPON_PROMOTION_ID	NUMBER(19) NULL,
	SU_COUPON_BATCH	NUMBER(19) NULL,
	PROMOTION	NUMBER(19) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

& /*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert flow into I$ table */
/* DETECTION_STRATEGY = NOT_EXISTS */



insert into	RAX_APP_USER.I$_PS_SU_CPN_PROMO_STG2076001
(
	SU_COUPON_PROMOTION_ID,
	SU_COUPON_BATCH,
	PROMOTION,
	IND_UPDATE
)
select 
SU_COUPON_PROMOTION_ID,
	SU_COUPON_BATCH,
	PROMOTION,
	IND_UPDATE
 from (


select 	 
	
	C1_SU_COUPON_PROMOTION_ID SU_COUPON_PROMOTION_ID,
	C2_SU_COUPON_BATCH SU_COUPON_BATCH,
	C3_PROMOTION PROMOTION,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0PS_SU_CPN_PROMO_STG
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.PS_SU_COUPON_PROMOTION_STG T
	where	T.SU_COUPON_PROMOTION_ID	= S.SU_COUPON_PROMOTION_ID 
		 and ((T.SU_COUPON_BATCH = S.SU_COUPON_BATCH) or (T.SU_COUPON_BATCH IS NULL and S.SU_COUPON_BATCH IS NULL)) and
		((T.PROMOTION = S.PROMOTION) or (T.PROMOTION IS NULL and S.PROMOTION IS NULL))
        )

& /*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_PS_SU_CPN_PROMO_STG2076001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& /*-----------------------------------------------*/
/* TASK No. 14 */
/* Create Index on flow table */


 /* create index	RAX_APP_USER.I$_PS_SU_CPN_PROMO_STG_IDX2076001
on		RAX_APP_USER.I$_PS_SU_CPN_PROMO_STG2076001 (SU_COUPON_PROMOTION_ID)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_PS_SU_CPN_PROMO_STG_IDX2076001
on		RAX_APP_USER.I$_PS_SU_CPN_PROMO_STG2076001 (SU_COUPON_PROMOTION_ID)
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
and	ORIGIN 		= '(2076001)ODS_Project.LOAD_SU_COUPON_PROMOTION_INT'
and	ERR_TYPE 		= 'F'

& /*-----------------------------------------------*/
/* TASK No. 17 */
/* create error table */



-- create table RAX_APP_USER.E$_PS_SU_CPN_PROMO_STG2076001
-- (
-- 	ODI_ROW_ID 		UROWID,
-- 	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
-- 	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
-- 	ODI_CHECK_DATE	DATE NULL, 
-- 	SU_COUPON_PROMOTION_ID	NUMBER(19) NULL,
-- 	SU_COUPON_BATCH	NUMBER(19) NULL,
-- 	PROMOTION	NUMBER(19) NULL,
-- 	ODS_CREATE_DATE	DATE NULL,
-- 	ODS_MODIFY_DATE	DATE NULL,
-- 	ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
-- 	ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
-- 	ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
-- 	ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
-- 	ODI_SESS_NO		VARCHAR2(19 CHAR)
-- )

BEGIN
    EXECUTE IMMEDIATE 'create table RAX_APP_USER.E$_PS_SU_CPN_PROMO_STG2076001
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	SU_COUPON_PROMOTION_ID	NUMBER(19) NULL,
	SU_COUPON_BATCH	NUMBER(19) NULL,
	PROMOTION	NUMBER(19) NULL,
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



delete from 	RAX_APP_USER.E$_PS_SU_CPN_PROMO_STG2076001
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(2076001)ODS_Project.LOAD_SU_COUPON_PROMOTION_INT')

& /*-----------------------------------------------*/
/* TASK No. 19 */
/* Create index on PK */
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */


 /* create index 	RAX_APP_USER.I$_PS_SU_CPN_PROMO_STG2076001
on	RAX_APP_USER.I$_PS_SU_CPN_PROMO_STG2076001 (SU_COUPON_PROMOTION_ID) */ 


BEGIN
    EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.I$_PS_SU_CPN_PROMO_STG2076001
on	RAX_APP_USER.I$_PS_SU_CPN_PROMO_STG2076001 (SU_COUPON_PROMOTION_ID)';
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
               SELECT 'RAX_APP_USER.I$_PS_SU_CPN_PROMO_STG' INTO CheckTable FROM DUAL;
               SELECT 'ODS_STAGE.PS_SU_COUPON_PROMOTION_STG' INTO TargetTable FROM DUAL;

IF CheckTable = TargetTable THEN
   VariableCheckTable := CheckTable; 
ELSE
   VariableCheckTable := CheckTable || '2076001';
END IF;

execute immediate '
insert into RAX_APP_USER.E$_PS_SU_CPN_PROMO_STG2076001
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
	SU_COUPON_PROMOTION_ID,
	SU_COUPON_BATCH,
	PROMOTION,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	''F'', 
	''ODI-15064: The primary key PS_SU_COUPON_PROMOTION_PK is not unique.'',
	''(2076001)ODS_Project.LOAD_SU_COUPON_PROMOTION_INT'',
	sysdate,
	''PS_SU_COUPON_PROMOTION_PK'',
	''PK'',	
	PS_SU_COUPON_PROMOTION_STG.SU_COUPON_PROMOTION_ID,
	PS_SU_COUPON_PROMOTION_STG.SU_COUPON_BATCH,
	PS_SU_COUPON_PROMOTION_STG.PROMOTION,
	PS_SU_COUPON_PROMOTION_STG.ODS_CREATE_DATE,
	PS_SU_COUPON_PROMOTION_STG.ODS_MODIFY_DATE
from	'
 || VariableCheckTable || 
' PS_SU_COUPON_PROMOTION_STG 
where	exists  (
		select	SUB1.SU_COUPON_PROMOTION_ID
		from 	' 
|| VariableCheckTable ||
'  SUB1
		where 	SUB1.SU_COUPON_PROMOTION_ID=PS_SU_COUPON_PROMOTION_STG.SU_COUPON_PROMOTION_ID
		group by 	SUB1.SU_COUPON_PROMOTION_ID
		having 	count(1) > 1
		)
';

END;

& /*-----------------------------------------------*/
/* TASK No. 21 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_PS_SU_CPN_PROMO_STG2076001
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
	SU_COUPON_PROMOTION_ID,
	SU_COUPON_BATCH,
	PROMOTION,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column SU_COUPON_PROMOTION_ID cannot be null.',
	sysdate,
	'(2076001)ODS_Project.LOAD_SU_COUPON_PROMOTION_INT',
	'SU_COUPON_PROMOTION_ID',
	'NN',	
	SU_COUPON_PROMOTION_ID,
	SU_COUPON_BATCH,
	PROMOTION,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PS_SU_CPN_PROMO_STG2076001
where	SU_COUPON_PROMOTION_ID is null

& /*-----------------------------------------------*/
/* TASK No. 22 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_PS_SU_CPN_PROMO_STG2076001
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
	SU_COUPON_PROMOTION_ID,
	SU_COUPON_BATCH,
	PROMOTION,
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
	'(2076001)ODS_Project.LOAD_SU_COUPON_PROMOTION_INT',
	'SU_COUPON_BATCH',
	'NN',	
	SU_COUPON_PROMOTION_ID,
	SU_COUPON_BATCH,
	PROMOTION,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PS_SU_CPN_PROMO_STG2076001
where	SU_COUPON_BATCH is null

& /*-----------------------------------------------*/
/* TASK No. 23 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_PS_SU_CPN_PROMO_STG2076001
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
	SU_COUPON_PROMOTION_ID,
	SU_COUPON_BATCH,
	PROMOTION,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column PROMOTION cannot be null.',
	sysdate,
	'(2076001)ODS_Project.LOAD_SU_COUPON_PROMOTION_INT',
	'PROMOTION',
	'NN',	
	SU_COUPON_PROMOTION_ID,
	SU_COUPON_BATCH,
	PROMOTION,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PS_SU_CPN_PROMO_STG2076001
where	PROMOTION is null

& /*-----------------------------------------------*/
/* TASK No. 24 */
/* create index on error table */
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */


 /* create index 	RAX_APP_USER.E$_PS_SU_CPN_PROMO_STG2076001
on	RAX_APP_USER.E$_PS_SU_CPN_PROMO_STG2076001 (ODI_ROW_ID) */ 


BEGIN
    EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_PS_SU_CPN_PROMO_STG2076001
on	RAX_APP_USER.E$_PS_SU_CPN_PROMO_STG2076001 (ODI_ROW_ID)';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 25 */
/* delete errors from controlled table */



delete from	RAX_APP_USER.I$_PS_SU_CPN_PROMO_STG2076001  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_PS_SU_CPN_PROMO_STG2076001 E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)

& /*-----------------------------------------------*/
/* TASK No. 26 */
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
	'PS_SU_CPN_PROMO_STG',
	'ODS_STAGE.PS_SU_COUPON_PROMOTION_STG2076001',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_PS_SU_CPN_PROMO_STG2076001 E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(2076001)ODS_Project.LOAD_SU_COUPON_PROMOTION_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE

& /*-----------------------------------------------*/
/* TASK No. 27 */
/* Merge Rows */



merge into	ODS_STAGE.PS_SU_COUPON_PROMOTION_STG T
using	RAX_APP_USER.I$_PS_SU_CPN_PROMO_STG2076001 S
on	(
		T.SU_COUPON_PROMOTION_ID=S.SU_COUPON_PROMOTION_ID
	)
when matched
then update set
	T.SU_COUPON_BATCH	= S.SU_COUPON_BATCH,
	T.PROMOTION	= S.PROMOTION
	,  T.ODS_MODIFY_DATE	= sysdate
when not matched
then insert
	(
	T.SU_COUPON_PROMOTION_ID,
	T.SU_COUPON_BATCH,
	T.PROMOTION
	,   T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.SU_COUPON_PROMOTION_ID,
	S.SU_COUPON_BATCH,
	S.PROMOTION
	,   sysdate,
	sysdate
	)

& /*-----------------------------------------------*/
/* TASK No. 28 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 29 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_PS_SU_CPN_PROMO_STG2076001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_PS_SU_CPN_PROMO_STG2076001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0PS_SU_CPN_PROMO_STG purge */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0PS_SU_CPN_PROMO_STG purge';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 30 */
/* Load Coupon Promotion XR */



MERGE INTO ods_stage.ps_coupon_promotion_xr d
   USING (SELECT s.su_coupon_promotion_id, s.su_coupon_batch,
                 promotion
            FROM ods_stage.ps_su_coupon_promotion_stg s
           WHERE s.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
   ON (s.su_coupon_promotion_id = d.sk_coupon_promotion_id)
   WHEN MATCHED THEN
      UPDATE
         SET d.sk_coupon_batch_id = s.su_coupon_batch,
             d.sk_promotion_id = s.promotion,
             d.ods_modify_date = SYSDATE
         WHERE    DECODE (d.sk_coupon_batch_id, s.su_coupon_batch, 1,0) = 0
               OR DECODE (d.sk_promotion_id, s.promotion, 1, 0) = 0
   WHEN NOT MATCHED THEN
      INSERT (coupon_promotion_oid, sk_coupon_promotion_id,
              sk_coupon_batch_id, sk_promotion_id, ods_create_date,
              ods_modify_date)
      VALUES (ods_stage.coupon_promotion_oid_seq.NEXTVAL,
              s.su_coupon_promotion_id, s.su_coupon_batch,
              s.promotion, SYSDATE, SYSDATE)

& /*-----------------------------------------------*/
/* TASK No. 31 */
/* Load Coupon Promotion Table */



MERGE INTO ods_own.coupon_promotion d
   USING (SELECT *
            FROM (SELECT xr.coupon_promotion_oid,
                         b_xr.coupon_batch_oid,
                         p_xr.promotion_master_oid,
                         SYSDATE AS ods_create_date,
                         SYSDATE AS ods_modify_date
                    FROM ods_stage.ps_su_coupon_promotion_stg s,
                         ods_stage.ps_coupon_promotion_xr xr,
                         ods_stage.promotion_master_xr p_xr,
                         ods_stage.ps_coupon_batch_xr b_xr,
                         ods_own.source_system ss
                   WHERE s.su_coupon_promotion_id =
                                             xr.sk_coupon_promotion_id
                     AND s.su_coupon_batch = b_xr.sk_coupon_batch_id(+)
                     AND s.promotion = p_xr.ps_promotion_id(+)
                     AND p_xr.system_of_record(+) = 'PS'
                     AND ss.source_system_short_name = 'PS'
                     AND s.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap)) s
   ON (d.coupon_promotion_oid = s.coupon_promotion_oid)
   WHEN MATCHED THEN
      UPDATE
         SET d.promotion_master_oid = s.promotion_master_oid,
             d.coupon_batch_oid = s.coupon_batch_oid,
             d.ods_modify_date = s.ods_modify_date
         WHERE    DECODE (d.promotion_master_oid,
                          s.promotion_master_oid, 1,
                          0
                         ) = 0
               OR DECODE (d.coupon_batch_oid,
                          s.coupon_batch_oid, 1,
                          0
                         ) = 0
   WHEN NOT MATCHED THEN
      INSERT (coupon_promotion_oid, promotion_master_oid,
              coupon_batch_oid, ods_create_date, ods_modify_date)
      VALUES (s.coupon_promotion_oid, s.promotion_master_oid,
              s.coupon_batch_oid, s.ods_create_date,
              s.ods_modify_date)

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
'LOAD_SU_COUPON_PROMOTION_PKG',
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
,'LOAD_SU_COUPON_PROMOTION_PKG'
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