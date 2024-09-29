/* TASK No. 1 */
/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */
/*-----------------------------------------------*/
/* TASK No. 2 */
/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 2 */
/*-----------------------------------------------*/
/* TASK No. 3 */
/* Drop work table */
/*-----------------------------------------------*/
/* TASK No. 4 */
/* Create work table */
/*-----------------------------------------------*/
/* TASK No. 5 */
/* Load data */
/* SOURCE CODE */
/* drop table RAX_APP_USER.C$_0STG_PRICE_SET purge */
/* create table RAX_APP_USER.C$_0STG_PRICE_SET
(
	C1_DESCRIPTION	VARCHAR2(255) NULL,
	C2_TAX_INCLUSIVE	NUMBER(1) NULL,
	C3_NAME	VARCHAR2(255) NULL,
	C4_AUDIT_CREATE_DATE	TIMESTAMP(6) NULL,
	C5_PRICE_SET_ID	NUMBER(19) NULL,
	C6_AUDIT_MODIFY_DATE	TIMESTAMP(6) NULL,
	C7_CURRENCY	VARCHAR2(3) NULL
)
NOLOGGING */
/* select	
	PRICE_SET.DESCRIPTION	   C1_DESCRIPTION,
	PRICE_SET.TAX_INCLUSIVE	   C2_TAX_INCLUSIVE,
	PRICE_SET.NAME	   C3_NAME,
	PRICE_SET.AUDIT_CREATE_DATE	   C4_AUDIT_CREATE_DATE,
	PRICE_SET.PRICE_SET_ID	   C5_PRICE_SET_ID,
	PRICE_SET.AUDIT_MODIFY_DATE	   C6_AUDIT_MODIFY_DATE,
	PRICE_SET.CURRENCY	   C7_CURRENCY
from	PS_OWN.PRICE_SET   PRICE_SET
where	(1=1)
And (PRICE_SET.AUDIT_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - 1) */
/* insert  into RAX_APP_USER.C$_0STG_PRICE_SET
(
	C1_DESCRIPTION,
	C2_TAX_INCLUSIVE,
	C3_NAME,
	C4_AUDIT_CREATE_DATE,
	C5_PRICE_SET_ID,
	C6_AUDIT_MODIFY_DATE,
	C7_CURRENCY
)
values
(
	:C1_DESCRIPTION,
	:C2_TAX_INCLUSIVE,
	:C3_NAME,
	:C4_AUDIT_CREATE_DATE,
	:C5_PRICE_SET_ID,
	:C6_AUDIT_MODIFY_DATE,
	:C7_CURRENCY
) */
/* TARGET CODE */
/*+ append */
/*-----------------------------------------------*/
/* TASK No. 6 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0STG_PRICE_SET',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;

& /*-----------------------------------------------*/
/* TASK No. 8 */
/* Create target table  */



-- create table RAX_APP_USER.STG_PRICE_SET
-- (
-- 	DESCRIPTION	VARCHAR2(255) NULL,
-- 	TAX_INCLUSIVE	NUMBER(1) NULL,
-- 	NAME	VARCHAR2(255) NULL,
-- 	AUDIT_CREATE_DATE	TIMESTAMP(6) NULL,
-- 	PRICE_SET_ID	NUMBER(19) NULL,
-- 	AUDIT_MODIFY_DATE	TIMESTAMP(6) NULL,
-- 	CURRENCY	VARCHAR2(3) NULL
-- )

BEGIN
    EXECUTE IMMEDIATE 'create table RAX_APP_USER.STG_PRICE_SET
(
	DESCRIPTION	VARCHAR2(255) NULL,
	TAX_INCLUSIVE	NUMBER(1) NULL,
	NAME	VARCHAR2(255) NULL,
	AUDIT_CREATE_DATE	TIMESTAMP(6) NULL,
	PRICE_SET_ID	NUMBER(19) NULL,
	AUDIT_MODIFY_DATE	TIMESTAMP(6) NULL,
	CURRENCY	VARCHAR2(3) NULL
)
';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;

& /*-----------------------------------------------*/
/* TASK No. 9 */
/* Truncate target table */



truncate table RAX_APP_USER.STG_PRICE_SET

& /*-----------------------------------------------*/
/* TASK No. 10 */
/* Insert new rows */



insert into	RAX_APP_USER.STG_PRICE_SET 
( 
	DESCRIPTION,
	TAX_INCLUSIVE,
	NAME,
	AUDIT_CREATE_DATE,
	PRICE_SET_ID,
	AUDIT_MODIFY_DATE,
	CURRENCY 
	 
) 

select
    DESCRIPTION,
	TAX_INCLUSIVE,
	NAME,
	AUDIT_CREATE_DATE,
	PRICE_SET_ID,
	AUDIT_MODIFY_DATE,
	CURRENCY   
   
FROM (	


select 	
	C1_DESCRIPTION DESCRIPTION,
	C2_TAX_INCLUSIVE TAX_INCLUSIVE,
	C3_NAME NAME,
	C4_AUDIT_CREATE_DATE AUDIT_CREATE_DATE,
	C5_PRICE_SET_ID PRICE_SET_ID,
	C6_AUDIT_MODIFY_DATE AUDIT_MODIFY_DATE,
	C7_CURRENCY CURRENCY 
from	RAX_APP_USER.C$_0STG_PRICE_SET
where		(1=1)	






)    ODI_GET_FROM

& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Commit transaction */
/* commit */
/*-----------------------------------------------*/
/* TASK No. 1000007 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0STG_PRICE_SET purge */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STG_PRICE_SET purge';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert new rows */



insert into	ODS_STAGE.PS_PRICE_SET_XR 
( 
	PRICE_SET_ID 
	,PRICE_SET_OID 
) 

select
    PRICE_SET_ID   
  ,ODS_STAGE.PRICE_SET_OID_SEQ.nextval 
FROM (	


select 	DISTINCT
	STG_PRICE_SET.PRICE_SET_ID PRICE_SET_ID 
from	ODS_STAGE.PS_PRICE_SET_XR   PS_PRICE_SET_XR, RAX_APP_USER.STG_PRICE_SET   STG_PRICE_SET
where		(1=1)	
 And (STG_PRICE_SET.PRICE_SET_ID=PS_PRICE_SET_XR.PRICE_SET_ID(+)
and PS_PRICE_SET_XR.PRICE_SET_ID is null)





)    ODI_GET_FROM

& /*-----------------------------------------------*/
/* TASK No. 13 */
/* Commit transaction */
/* commit */
/*-----------------------------------------------*/
/* TASK No. 14 */
/* Set vID */
/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 14 */
/*-----------------------------------------------*/
/* TASK No. 15 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_PRICE_SET80001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_PRICE_SET80001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 16 */
/* Create flow table I$ */



create table RAX_APP_USER.I$_PRICE_SET80001
(
	PRICE_SET_OID	NUMBER NULL,
	CURRENCY	VARCHAR2(3) NULL,
	DESCRIPTION	VARCHAR2(255) NULL,
	NAME	VARCHAR2(255) NULL,
	TAX_INCLUSIVE	NUMBER NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	SOURCE_SYSTEM_OID	NUMBER NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

& /*-----------------------------------------------*/
/* TASK No. 17 */
/* Insert flow into I$ table */
/* DETECTION_STRATEGY = NOT_EXISTS */



insert into	RAX_APP_USER.I$_PRICE_SET80001
(
	PRICE_SET_OID,
	CURRENCY,
	DESCRIPTION,
	NAME,
	TAX_INCLUSIVE,
	SOURCE_SYSTEM_OID,
	IND_UPDATE
)
select 
PRICE_SET_OID,
	CURRENCY,
	DESCRIPTION,
	NAME,
	TAX_INCLUSIVE,
	SOURCE_SYSTEM_OID,
	IND_UPDATE
 from (


select 	 
	
	PS_PRICE_SET_XR1.PRICE_SET_OID PRICE_SET_OID,
	STG_PRICE_SET.CURRENCY CURRENCY,
	STG_PRICE_SET.DESCRIPTION DESCRIPTION,
	STG_PRICE_SET.NAME NAME,
	STG_PRICE_SET.TAX_INCLUSIVE TAX_INCLUSIVE,
	SOURCE_SYSTEM.SOURCE_SYSTEM_OID SOURCE_SYSTEM_OID,

	'I' IND_UPDATE

from	ODS_OWN.SOURCE_SYSTEM   SOURCE_SYSTEM, RAX_APP_USER.STG_PRICE_SET   STG_PRICE_SET, ODS_STAGE.PS_PRICE_SET_XR   PS_PRICE_SET_XR1
where	(1=1)
 And (STG_PRICE_SET.PRICE_SET_ID=PS_PRICE_SET_XR1.PRICE_SET_ID)
And (SOURCE_SYSTEM.SOURCE_SYSTEM_SHORT_NAME='PS')




) S
where NOT EXISTS 
	( select 1 from ODS_OWN.PRICE_SET T
	where	T.PRICE_SET_OID	= S.PRICE_SET_OID 
		 and ((T.CURRENCY = S.CURRENCY) or (T.CURRENCY IS NULL and S.CURRENCY IS NULL)) and
		((T.DESCRIPTION = S.DESCRIPTION) or (T.DESCRIPTION IS NULL and S.DESCRIPTION IS NULL)) and
		((T.NAME = S.NAME) or (T.NAME IS NULL and S.NAME IS NULL)) and
		((T.TAX_INCLUSIVE = S.TAX_INCLUSIVE) or (T.TAX_INCLUSIVE IS NULL and S.TAX_INCLUSIVE IS NULL)) and
		((T.SOURCE_SYSTEM_OID = S.SOURCE_SYSTEM_OID) or (T.SOURCE_SYSTEM_OID IS NULL and S.SOURCE_SYSTEM_OID IS NULL))
        )

& /*-----------------------------------------------*/
/* TASK No. 18 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_PRICE_SET80001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& /*-----------------------------------------------*/
/* TASK No. 19 */
/* Create Index on flow table */


 /* create index	RAX_APP_USER.I$_PRICE_SET_IDX80001
on		RAX_APP_USER.I$_PRICE_SET80001 (PRICE_SET_OID)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_PRICE_SET_IDX80001
on		RAX_APP_USER.I$_PRICE_SET80001 (PRICE_SET_OID)
NOLOGGING';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 20 */
/* Merge Rows */



merge into	ODS_OWN.PRICE_SET T
using	RAX_APP_USER.I$_PRICE_SET80001 S
on	(
		T.PRICE_SET_OID=S.PRICE_SET_OID
	)
when matched
then update set
	T.CURRENCY	= S.CURRENCY,
	T.DESCRIPTION	= S.DESCRIPTION,
	T.NAME	= S.NAME,
	T.TAX_INCLUSIVE	= S.TAX_INCLUSIVE,
	T.SOURCE_SYSTEM_OID	= S.SOURCE_SYSTEM_OID
	,     T.ODS_MODIFY_DATE	= SYSDATE
when not matched
then insert
	(
	T.PRICE_SET_OID,
	T.CURRENCY,
	T.DESCRIPTION,
	T.NAME,
	T.TAX_INCLUSIVE,
	T.SOURCE_SYSTEM_OID
	,      T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.PRICE_SET_OID,
	S.CURRENCY,
	S.DESCRIPTION,
	S.NAME,
	S.TAX_INCLUSIVE,
	S.SOURCE_SYSTEM_OID
	,      SYSDATE,
	SYSDATE
	)

& /*-----------------------------------------------*/
/* TASK No. 21 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 22 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_PRICE_SET80001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_PRICE_SET80001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 23 */
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
/* TASK No. 24 */
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
'LOAD_PRICE_SET_PKG',
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
,'LOAD_PRICE_SET_PKG'
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