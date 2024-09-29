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
/* drop table RAX_APP_USER.C$_0STG_PP_PRICESET */
/* create table RAX_APP_USER.C$_0STG_PP_PRICESET
(
	C1_PRICE_PROGRAM_ID	NUMBER(19) NULL,
	C2_PRICE_SET_ID	NUMBER(19) NULL
)
NOLOGGING */
/* select	
	PRICE_PROGRAM_PRICE_SET.PRICE_PROGRAM_ID	   C1_PRICE_PROGRAM_ID,
	PRICE_PROGRAM_PRICE_SET.PRICE_SET_ID	   C2_PRICE_SET_ID
from	PS_OWN.PRICE_PROGRAM_PRICE_SET   PRICE_PROGRAM_PRICE_SET, PS_OWN.PRICE_PROGRAM   PRICE_PROGRAM
where	(1=1)
And (PRICE_PROGRAM.AUDIT_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - 1)
 And (PRICE_PROGRAM_PRICE_SET.PRICE_PROGRAM_ID=PRICE_PROGRAM.PRICE_PROGRAM_ID) */
/* insert into RAX_APP_USER.C$_0STG_PP_PRICESET
(
	C1_PRICE_PROGRAM_ID,
	C2_PRICE_SET_ID
)
values
(
	:C1_PRICE_PROGRAM_ID,
	:C2_PRICE_SET_ID
) */
/* TARGET CODE */
/*-----------------------------------------------*/
/* TASK No. 6 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0STG_PP_PRICESET',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;

& /*-----------------------------------------------*/
/* TASK No. 8 */
/* Create target table  */



-- create table RAX_APP_USER.STG_PP_PRICESET
-- (
-- 	PRICE_PROGRAM_ID	NUMBER(19) NULL,
-- 	PRICE_SET_ID	NUMBER(19) NULL
-- )

BEGIN
    EXECUTE IMMEDIATE 'create table RAX_APP_USER.STG_PP_PRICESET
(
	PRICE_PROGRAM_ID	NUMBER(19) NULL,
	PRICE_SET_ID	NUMBER(19) NULL
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



truncate table RAX_APP_USER.STG_PP_PRICESET

& /*-----------------------------------------------*/
/* TASK No. 10 */
/* Insert new rows */



insert into	RAX_APP_USER.STG_PP_PRICESET 
( 
	PRICE_PROGRAM_ID,
	PRICE_SET_ID 
	 
) 

select
    PRICE_PROGRAM_ID,
	PRICE_SET_ID   
   
FROM (	


select 	
	C1_PRICE_PROGRAM_ID PRICE_PROGRAM_ID,
	C2_PRICE_SET_ID PRICE_SET_ID 
from	RAX_APP_USER.C$_0STG_PP_PRICESET
where		(1=1)	






)    ODI_GET_FROM

& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Commit transaction */
/* commit */
/*-----------------------------------------------*/
/* TASK No. 1000007 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0STG_PP_PRICESET */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STG_PP_PRICESET';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert new rows */



insert into	ODS_STAGE.PS_PP_PRICE_SET_XR 
( 
	PRICE_PROGRAM_ID,
	PRICE_SET_ID 
	,PP_PRICE_SET_OID 
) 

select
    PRICE_PROGRAM_ID,
	PRICE_SET_ID   
  ,ODS_STAGE.PP_PRICE_SET_OID_SEQ.nextval 
FROM (	


select 	
	STG_PP_PRICESET.PRICE_PROGRAM_ID PRICE_PROGRAM_ID,
	STG_PP_PRICESET.PRICE_SET_ID PRICE_SET_ID 
from	RAX_APP_USER.STG_PP_PRICESET   STG_PP_PRICESET, ODS_STAGE.PS_PP_PRICE_SET_XR   PS_PP_PRICE_SET_XR
where		(1=1)	
 And (STG_PP_PRICESET.PRICE_PROGRAM_ID=PS_PP_PRICE_SET_XR.PRICE_PROGRAM_ID(+)
AND STG_PP_PRICESET.PRICE_SET_ID=PS_PP_PRICE_SET_XR.PRICE_SET_ID(+)
AND PS_PP_PRICE_SET_XR.PRICE_PROGRAM_ID IS NULL
AND PS_PP_PRICE_SET_XR.PRICE_SET_ID IS NULL)





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


 /* drop table RAX_APP_USER.I$_PP_PRICE_SET1282001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_PP_PRICE_SET1282001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 16 */
/* Create flow table I$ */



create table RAX_APP_USER.I$_PP_PRICE_SET1282001
(
	PP_PRICE_SET_OID	NUMBER NULL,
	PRICE_PROGRAM_OID	NUMBER NULL,
	PRICE_SET_OID	NUMBER NULL,
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



insert into	RAX_APP_USER.I$_PP_PRICE_SET1282001
(
	PP_PRICE_SET_OID,
	PRICE_PROGRAM_OID,
	PRICE_SET_OID,
	SOURCE_SYSTEM_OID,
	IND_UPDATE
)
select 
PP_PRICE_SET_OID,
	PRICE_PROGRAM_OID,
	PRICE_SET_OID,
	SOURCE_SYSTEM_OID,
	IND_UPDATE
 from (


select 	 
	
	PS_PP_PRICE_SET_XR.PP_PRICE_SET_OID PP_PRICE_SET_OID,
	PS_PRICE_PROGRAM_XR.PRICE_PROGRAM_OID PRICE_PROGRAM_OID,
	PS_PRICE_SET_XR.PRICE_SET_OID PRICE_SET_OID,
	SOURCE_SYSTEM.SOURCE_SYSTEM_OID SOURCE_SYSTEM_OID,

	'I' IND_UPDATE

from	RAX_APP_USER.STG_PP_PRICESET   STG_PP_PRICESET, ODS_OWN.SOURCE_SYSTEM   SOURCE_SYSTEM, ODS_STAGE.PS_PP_PRICE_SET_XR   PS_PP_PRICE_SET_XR, ODS_STAGE.PS_PRICE_SET_XR   PS_PRICE_SET_XR, ODS_STAGE.PS_PRICE_PROGRAM_XR   PS_PRICE_PROGRAM_XR
where	(1=1)
 And (STG_PP_PRICESET.PRICE_SET_ID=PS_PP_PRICE_SET_XR.PRICE_SET_ID AND STG_PP_PRICESET.PRICE_PROGRAM_ID=PS_PP_PRICE_SET_XR.PRICE_PROGRAM_ID)
AND (PS_PP_PRICE_SET_XR.PRICE_SET_ID=PS_PRICE_SET_XR.PRICE_SET_ID)
AND (PS_PP_PRICE_SET_XR.PRICE_PROGRAM_ID=PS_PRICE_PROGRAM_XR.PRICE_PROGRAM_ID)
And (SOURCE_SYSTEM.SOURCE_SYSTEM_SHORT_NAME='PS')




) S
where NOT EXISTS 
	( select 1 from ODS_OWN.PP_PRICE_SET T
	where	T.PP_PRICE_SET_OID	= S.PP_PRICE_SET_OID 
		 and ((T.PRICE_PROGRAM_OID = S.PRICE_PROGRAM_OID) or (T.PRICE_PROGRAM_OID IS NULL and S.PRICE_PROGRAM_OID IS NULL)) and
		((T.PRICE_SET_OID = S.PRICE_SET_OID) or (T.PRICE_SET_OID IS NULL and S.PRICE_SET_OID IS NULL)) and
		((T.SOURCE_SYSTEM_OID = S.SOURCE_SYSTEM_OID) or (T.SOURCE_SYSTEM_OID IS NULL and S.SOURCE_SYSTEM_OID IS NULL))
        )

& /*-----------------------------------------------*/
/* TASK No. 18 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_PP_PRICE_SET1282001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& /*-----------------------------------------------*/
/* TASK No. 19 */
/* Create Index on flow table */


 /* create index	RAX_APP_USER.I$_PP_PRICE_SET_IDX1282001
on		RAX_APP_USER.I$_PP_PRICE_SET1282001 (PP_PRICE_SET_OID)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_PP_PRICE_SET_IDX1282001
on		RAX_APP_USER.I$_PP_PRICE_SET1282001 (PP_PRICE_SET_OID)
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



merge into	ODS_OWN.PP_PRICE_SET T
using	RAX_APP_USER.I$_PP_PRICE_SET1282001 S
on	(
		T.PP_PRICE_SET_OID=S.PP_PRICE_SET_OID
	)
when matched
then update set
	T.PRICE_PROGRAM_OID	= S.PRICE_PROGRAM_OID,
	T.PRICE_SET_OID	= S.PRICE_SET_OID,
	T.SOURCE_SYSTEM_OID	= S.SOURCE_SYSTEM_OID
	,   T.ODS_MODIFY_DATE	= SYSDATE
when not matched
then insert
	(
	T.PP_PRICE_SET_OID,
	T.PRICE_PROGRAM_OID,
	T.PRICE_SET_OID,
	T.SOURCE_SYSTEM_OID
	,    T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.PP_PRICE_SET_OID,
	S.PRICE_PROGRAM_OID,
	S.PRICE_SET_OID,
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


 /* drop table RAX_APP_USER.I$_PP_PRICE_SET1282001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_PP_PRICE_SET1282001';
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
'LOAD_PP_PRICESET_PKG',
'004',
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
,'LOAD_PP_PRICESET_PKG'
,'004'
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