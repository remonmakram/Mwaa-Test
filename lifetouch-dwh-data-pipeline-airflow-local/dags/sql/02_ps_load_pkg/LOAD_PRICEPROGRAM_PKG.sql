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
/* drop table RAX_APP_USER.C$_0STG_PRICE_PROGRAM */
/* create table RAX_APP_USER.C$_0STG_PRICE_PROGRAM
(
	C1_PRICE_PROGRAM_ID	NUMBER(19) NULL,
	C2_AUDIT_CREATE_DATE	TIMESTAMP(6) NULL,
	C3_AUDIT_MODIFY_DATE	TIMESTAMP(6) NULL,
	C4_DESCRIPTION	VARCHAR2(500) NULL,
	C5_NAME	VARCHAR2(255) NULL
)
NOLOGGING */
/* select	
	PRICE_PROGRAM.PRICE_PROGRAM_ID	   C1_PRICE_PROGRAM_ID,
	PRICE_PROGRAM.AUDIT_CREATE_DATE	   C2_AUDIT_CREATE_DATE,
	PRICE_PROGRAM.AUDIT_MODIFY_DATE	   C3_AUDIT_MODIFY_DATE,
	PRICE_PROGRAM.DESCRIPTION	   C4_DESCRIPTION,
	PRICE_PROGRAM.NAME	   C5_NAME
from	PS_OWN.PRICE_PROGRAM   PRICE_PROGRAM
where	(1=1)
And (PRICE_PROGRAM.AUDIT_MODIFY_DATE  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - 1) */
/* insert into RAX_APP_USER.C$_0STG_PRICE_PROGRAM
(
	C1_PRICE_PROGRAM_ID,
	C2_AUDIT_CREATE_DATE,
	C3_AUDIT_MODIFY_DATE,
	C4_DESCRIPTION,
	C5_NAME
)
values
(
	:C1_PRICE_PROGRAM_ID,
	:C2_AUDIT_CREATE_DATE,
	:C3_AUDIT_MODIFY_DATE,
	:C4_DESCRIPTION,
	:C5_NAME
) */
/* TARGET CODE */
/*-----------------------------------------------*/
/* TASK No. 6 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0STG_PRICE_PROGRAM',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;

& /*-----------------------------------------------*/
/* TASK No. 8 */
/* Create target table  */



-- create table RAX_APP_USER.STG_PRICE_PROGRAM
-- (
-- 	PRICE_PROGRAM_ID	NUMBER(19) NULL,
-- 	AUDIT_CREATE_DATE	TIMESTAMP(6) NULL,
-- 	AUDIT_MODIFY_DATE	TIMESTAMP(6) NULL,
-- 	DESCRIPTION	VARCHAR2(500) NULL,
-- 	NAME	VARCHAR2(255) NULL
-- )


BEGIN
    EXECUTE IMMEDIATE 'create table RAX_APP_USER.STG_PRICE_PROGRAM
(
	PRICE_PROGRAM_ID	NUMBER(19) NULL,
	AUDIT_CREATE_DATE	TIMESTAMP(6) NULL,
	AUDIT_MODIFY_DATE	TIMESTAMP(6) NULL,
	DESCRIPTION	VARCHAR2(500) NULL,
	NAME	VARCHAR2(255) NULL
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



truncate table RAX_APP_USER.STG_PRICE_PROGRAM

& /*-----------------------------------------------*/
/* TASK No. 10 */
/* Insert new rows */



insert into	RAX_APP_USER.STG_PRICE_PROGRAM 
( 
	PRICE_PROGRAM_ID,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFY_DATE,
	DESCRIPTION,
	NAME 
	 
) 

select
    PRICE_PROGRAM_ID,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFY_DATE,
	DESCRIPTION,
	NAME   
   
FROM (	


select 	
	C1_PRICE_PROGRAM_ID PRICE_PROGRAM_ID,
	C2_AUDIT_CREATE_DATE AUDIT_CREATE_DATE,
	C3_AUDIT_MODIFY_DATE AUDIT_MODIFY_DATE,
	C4_DESCRIPTION DESCRIPTION,
	C5_NAME NAME 
from	RAX_APP_USER.C$_0STG_PRICE_PROGRAM
where		(1=1)	






)    ODI_GET_FROM

& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Commit transaction */
/* commit */
/*-----------------------------------------------*/
/* TASK No. 1000007 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0STG_PRICE_PROGRAM */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STG_PRICE_PROGRAM';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert new rows */
/*and not exists (select 1 from 
ODS_STAGE.PS_PRICE_PROGRAM_XR z
where z.name=STG_PRICE_PROGRAM.name) */



insert into	ODS_STAGE.PS_PRICE_PROGRAM_XR 
( 
	NAME,
	PRICE_PROGRAM_ID 
	,PRICE_PROGRAM_OID 
) 

select
    NAME,
	PRICE_PROGRAM_ID   
  ,ODS_STAGE.PRICE_PROGRAM_OID_SEQ.nextval 
FROM (	


select 	
	STG_PRICE_PROGRAM.NAME NAME,
	STG_PRICE_PROGRAM.PRICE_PROGRAM_ID PRICE_PROGRAM_ID 
from	ODS_STAGE.PS_PRICE_PROGRAM_XR   PS_PRICE_PROGRAM_XR, RAX_APP_USER.STG_PRICE_PROGRAM   STG_PRICE_PROGRAM
where		(1=1)	
 And (STG_PRICE_PROGRAM.PRICE_PROGRAM_ID=PS_PRICE_PROGRAM_XR.PRICE_PROGRAM_ID(+)
and PS_PRICE_PROGRAM_XR.PRICE_PROGRAM_ID is null
)





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


 /* drop table RAX_APP_USER.I$_PRICE_PROGRAM1279001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_PRICE_PROGRAM1279001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 16 */
/* Create flow table I$ */



create table RAX_APP_USER.I$_PRICE_PROGRAM1279001
(
	PRICE_PROGRAM_OID	NUMBER NULL,
	PRICE_PROGRAM_NAME	VARCHAR2(255) NULL,
	PRICE_PROGRAM_DESCRIPTION	VARCHAR2(500) NULL,
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



insert into	RAX_APP_USER.I$_PRICE_PROGRAM1279001
(
	PRICE_PROGRAM_OID,
	PRICE_PROGRAM_NAME,
	PRICE_PROGRAM_DESCRIPTION,
	SOURCE_SYSTEM_OID,
	IND_UPDATE
)
select 
PRICE_PROGRAM_OID,
	PRICE_PROGRAM_NAME,
	PRICE_PROGRAM_DESCRIPTION,
	SOURCE_SYSTEM_OID,
	IND_UPDATE
 from (


select 	 
	
	PS_PRICE_PROGRAM_XR.PRICE_PROGRAM_OID PRICE_PROGRAM_OID,
	STG_PRICE_PROGRAM.NAME PRICE_PROGRAM_NAME,
	STG_PRICE_PROGRAM.DESCRIPTION PRICE_PROGRAM_DESCRIPTION,
	SOURCE_SYSTEM.SOURCE_SYSTEM_OID SOURCE_SYSTEM_OID,

	'I' IND_UPDATE

from	RAX_APP_USER.STG_PRICE_PROGRAM   STG_PRICE_PROGRAM, ODS_OWN.SOURCE_SYSTEM   SOURCE_SYSTEM, ODS_STAGE.PS_PRICE_PROGRAM_XR   PS_PRICE_PROGRAM_XR
where	(1=1)
 And (STG_PRICE_PROGRAM.NAME=PS_PRICE_PROGRAM_XR.NAME)
And (SOURCE_SYSTEM.SOURCE_SYSTEM_SHORT_NAME='PS')




) S
where NOT EXISTS 
	( select 1 from ODS_OWN.PRICE_PROGRAM T
	where	T.PRICE_PROGRAM_OID	= S.PRICE_PROGRAM_OID 
		 and ((T.PRICE_PROGRAM_NAME = S.PRICE_PROGRAM_NAME) or (T.PRICE_PROGRAM_NAME IS NULL and S.PRICE_PROGRAM_NAME IS NULL)) and
		((T.PRICE_PROGRAM_DESCRIPTION = S.PRICE_PROGRAM_DESCRIPTION) or (T.PRICE_PROGRAM_DESCRIPTION IS NULL and S.PRICE_PROGRAM_DESCRIPTION IS NULL)) and
		((T.SOURCE_SYSTEM_OID = S.SOURCE_SYSTEM_OID) or (T.SOURCE_SYSTEM_OID IS NULL and S.SOURCE_SYSTEM_OID IS NULL))
        )

& /*-----------------------------------------------*/
/* TASK No. 18 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_PRICE_PROGRAM1279001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& /*-----------------------------------------------*/
/* TASK No. 19 */
/* Create Index on flow table */


 /* create index	RAX_APP_USER.I$_PRICE_PROGRAM_IDX1279001
on		RAX_APP_USER.I$_PRICE_PROGRAM1279001 (PRICE_PROGRAM_OID)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_PRICE_PROGRAM_IDX1279001
on		RAX_APP_USER.I$_PRICE_PROGRAM1279001 (PRICE_PROGRAM_OID)
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



merge into	ODS_OWN.PRICE_PROGRAM T
using	RAX_APP_USER.I$_PRICE_PROGRAM1279001 S
on	(
		T.PRICE_PROGRAM_OID=S.PRICE_PROGRAM_OID
	)
when matched
then update set
	T.PRICE_PROGRAM_NAME	= S.PRICE_PROGRAM_NAME,
	T.PRICE_PROGRAM_DESCRIPTION	= S.PRICE_PROGRAM_DESCRIPTION,
	T.SOURCE_SYSTEM_OID	= S.SOURCE_SYSTEM_OID
	,   T.ODS_MODIFY_DATE	= SYSDATE
when not matched
then insert
	(
	T.PRICE_PROGRAM_OID,
	T.PRICE_PROGRAM_NAME,
	T.PRICE_PROGRAM_DESCRIPTION,
	T.SOURCE_SYSTEM_OID
	,    T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.PRICE_PROGRAM_OID,
	S.PRICE_PROGRAM_NAME,
	S.PRICE_PROGRAM_DESCRIPTION,
	S.SOURCE_SYSTEM_OID
	,    SYSDATE,
	SYSDATE
	)

& /*-----------------------------------------------*/
/* TASK No. 21 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 22 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_PRICE_PROGRAM1279001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_PRICE_PROGRAM1279001';
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
'LOAD_PRICEPROGRAM_PKG',
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
,'LOAD_PRICEPROGRAM_PKG'
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