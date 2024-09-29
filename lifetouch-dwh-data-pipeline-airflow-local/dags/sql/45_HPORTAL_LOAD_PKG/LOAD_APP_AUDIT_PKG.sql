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

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 4 */




/*-----------------------------------------------*/
/* TASK No. 5 */
/* Drop work table */

/*
BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STG_APP_AUDIT ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  
/  

&
*/

/*-----------------------------------------------*/
/* TASK No. 6 */
/* Create work table */
/*
create table RAX_APP_USER.C$_0STG_APP_AUDIT
(
	C1_LIFETOUCH_ID	NUMBER NULL,
	C2_USER_ID	VARCHAR2(60) NULL,
	C3_USER_TYPE	VARCHAR2(25) NULL,
	C4_PROFILE_ID	VARCHAR2(60) NULL,
	C5_APP_AUDIT_OID	NUMBER NULL,
	C6_ACTION	VARCHAR2(60) NULL,
	C7_ACTION_TIME	TIMESTAMP(6) NULL
)
NOLOGGING

&
*/

/*-----------------------------------------------*/
/* TASK No. 7 */
/* Load data */

/* SOURCE CODE */
/*
select	
	AA.LIFETOUCH_ID	   C1_LIFETOUCH_ID,
	AA.USER_ID	   C2_USER_ID,
	AA.USER_TYPE	   C3_USER_TYPE,
	AA.PROFILE_ID	   C4_PROFILE_ID,
	AA.APP_AUDIT_OID	   C5_APP_AUDIT_OID,
	AA.ACTION	   C6_ACTION,
	AA.ACTION_TIME	   C7_ACTION_TIME
from	HPORTAL_OWN.APP_AUDIT   AA
where	(1=1)
And (AA.ACTION_TIME >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap
)





&
*/
/* TARGET CODE */
/*
insert into RAX_APP_USER.C$_0STG_APP_AUDIT
(
	C1_LIFETOUCH_ID,
	C2_USER_ID,
	C3_USER_TYPE,
	C4_PROFILE_ID,
	C5_APP_AUDIT_OID,
	C6_ACTION,
	C7_ACTION_TIME
)
values
(
	:C1_LIFETOUCH_ID,
	:C2_USER_ID,
	:C3_USER_TYPE,
	:C4_PROFILE_ID,
	:C5_APP_AUDIT_OID,
	:C6_ACTION,
	:C7_ACTION_TIME
)

&

*/
/*-----------------------------------------------*/
/* TASK No. 8 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0STG_APP_AUDIT',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;




&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Create target table  */


BEGIN  
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.STG_APP_AUDIT
(
	LIFETOUCH_ID	NUMBER NULL,
	USER_ID	VARCHAR2(60) NULL,
	USER_TYPE	VARCHAR2(25) NULL,
	PROFILE_ID	VARCHAR2(60) NULL,
	APP_AUDIT_OID	NUMBER NULL,
	ACTION	VARCHAR2(60) NULL,
	ACTION_TIME	TIMESTAMP(6) NULL
)';  
EXCEPTION  
   WHEN OTHERS THEN  
      NULL;
END;  

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Truncate target table */

truncate table RAX_APP_USER.STG_APP_AUDIT


&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert new rows */

 
insert into	RAX_APP_USER.STG_APP_AUDIT 
( 
	LIFETOUCH_ID,
	USER_ID,
	USER_TYPE,
	PROFILE_ID,
	APP_AUDIT_OID,
	ACTION,
	ACTION_TIME 
	 
) 

select
    LIFETOUCH_ID,
	USER_ID,
	USER_TYPE,
	PROFILE_ID,
	APP_AUDIT_OID,
	ACTION,
	ACTION_TIME   
   
FROM (	


select 	
	C1_LIFETOUCH_ID LIFETOUCH_ID,
	C2_USER_ID USER_ID,
	C3_USER_TYPE USER_TYPE,
	C4_PROFILE_ID PROFILE_ID,
	C5_APP_AUDIT_OID APP_AUDIT_OID,
	C6_ACTION ACTION,
	C7_ACTION_TIME ACTION_TIME 
from	RAX_APP_USER.C$_0STG_APP_AUDIT
where		(1=1)	






)    ODI_GET_FROM




&

--/*------------------ JUST FOR TESTING ---------------------------*/
--INSERT INTO RAX_APP_USER.STG_APP_AUDIT (APP_AUDIT_OID,LIFETOUCH_ID) values(0,0)
--
--
--&
/*-----------------------------------------------*/
/* TASK No. 13 */
/* Commit transaction */

/* commit */


/*-----------------------------------------------*/
/* TASK No. 1000009 */
/* Drop work table */

drop table RAX_APP_USER.C$_0STG_APP_AUDIT 

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 14 */




/*-----------------------------------------------*/
/* TASK No. 15 */
/* Drop flow table */


BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_HP_APP_AUDIT_XR670001 ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  


&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_HP_APP_AUDIT_XR670001
(
	HOST_PORTAL_AUDIT_OID	NUMBER NULL,
	APP_AUDIT_OID	NUMBER NULL,
	LIFETOUCH_ID	NUMBER NULL,
	ODS_CREATE_DATE	DATE NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_HP_APP_AUDIT_XR670001
(
	APP_AUDIT_OID,
	LIFETOUCH_ID,
	IND_UPDATE
)
select 
APP_AUDIT_OID,
	LIFETOUCH_ID,
	IND_UPDATE
 from (


select 	 
	DISTINCT
	STG.APP_AUDIT_OID APP_AUDIT_OID,
	STG.LIFETOUCH_ID LIFETOUCH_ID,

	'I' IND_UPDATE

from	RAX_APP_USER.STG_APP_AUDIT   STG, ODS_STAGE.HP_APP_AUDIT_XR   XR
where	(1=1)
 And (STG.APP_AUDIT_OID=XR.APP_AUDIT_OID(+) and XR.APP_AUDIT_OID is null)





) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.HP_APP_AUDIT_XR T
	where	T.APP_AUDIT_OID	= S.APP_AUDIT_OID 
		 and ((T.LIFETOUCH_ID = S.LIFETOUCH_ID) or (T.LIFETOUCH_ID IS NULL and S.LIFETOUCH_ID IS NULL))
        )

  
  

  



&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_HP_APP_AUDIT_XR670001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_HP_APP_AUDIT_XR_IDX670001
on		RAX_APP_USER.I$_HP_APP_AUDIT_XR670001 (APP_AUDIT_OID)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* Merge Rows */

merge into	ODS_STAGE.HP_APP_AUDIT_XR T
using	RAX_APP_USER.I$_HP_APP_AUDIT_XR670001 S
on	(
		T.APP_AUDIT_OID=S.APP_AUDIT_OID
	)
when matched
then update set
	T.LIFETOUCH_ID	= S.LIFETOUCH_ID
	, T.ODS_CREATE_DATE	= sysdate
when not matched
then insert
	(
	T.APP_AUDIT_OID,
	T.LIFETOUCH_ID
	,  T.HOST_PORTAL_AUDIT_OID,
	T.ODS_CREATE_DATE
	)
values
	(
	S.APP_AUDIT_OID,
	S.LIFETOUCH_ID
	,  ODS_STAGE.HOST_PORTAL_AUDIT_OID_SEQ.nextval,
	sysdate
	)

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 22 */
/* Drop flow table */

drop table RAX_APP_USER.I$_HP_APP_AUDIT_XR670001 

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 23 */




/*-----------------------------------------------*/
/* TASK No. 24 */
/* Drop flow table */


BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_HOST_PORTAL_AUDIT673001 ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  


&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_HOST_PORTAL_AUDIT673001
(
	HOST_PORTAL_AUDIT_OID	NUMBER NULL,
	ACCOUNT_OID	NUMBER NULL,
	USER_ID	VARCHAR2(60) NULL,
	ACTIVITY_DATE	DATE NULL,
	ACTIVITY_TYPE	VARCHAR2(60) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	SOURCE_SYSTEM_OID	NUMBER NULL,
	USER_TYPE	VARCHAR2(25) NULL,
	PROFILE_ID	VARCHAR2(60) NULL,
	USER_ACCOUNT_PRINCIPAL_OID	NUMBER NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_HOST_PORTAL_AUDIT673001
(
	HOST_PORTAL_AUDIT_OID,
	ACCOUNT_OID,
	USER_ID,
	ACTIVITY_DATE,
	ACTIVITY_TYPE,
	SOURCE_SYSTEM_OID,
	USER_TYPE,
	PROFILE_ID,
	USER_ACCOUNT_PRINCIPAL_OID,
	IND_UPDATE
)
select 
HOST_PORTAL_AUDIT_OID,
	ACCOUNT_OID,
	USER_ID,
	ACTIVITY_DATE,
	ACTIVITY_TYPE,
	SOURCE_SYSTEM_OID,
	USER_TYPE,
	PROFILE_ID,
	USER_ACCOUNT_PRINCIPAL_OID,
	IND_UPDATE
 from (


select 	 
	
	XR.HOST_PORTAL_AUDIT_OID HOST_PORTAL_AUDIT_OID,
	ACCOUNT.ACCOUNT_OID ACCOUNT_OID,
	STG.USER_ID USER_ID,
	STG.ACTION_TIME ACTIVITY_DATE,
	STG.ACTION ACTIVITY_TYPE,
	SOURCE_SYSTEM.SOURCE_SYSTEM_OID SOURCE_SYSTEM_OID,
	STG.USER_TYPE USER_TYPE,
	STG.PROFILE_ID PROFILE_ID,
	USER_ACCT_PRNCPL.USER_ACCOUNT_PRINCIPAL_OID USER_ACCOUNT_PRINCIPAL_OID,

	'I' IND_UPDATE

from	RAX_APP_USER.STG_APP_AUDIT   STG, ODS_STAGE.HP_APP_AUDIT_XR   XR, ODS_OWN.ACCOUNT   ACCOUNT, ODS_OWN.SOURCE_SYSTEM   SOURCE_SYSTEM, ODS_OWN.USER_ACCOUNT_PRINCIPAL   USER_ACCT_PRNCPL
where	(1=1)
 And (STG.APP_AUDIT_OID=XR.APP_AUDIT_OID)
AND (STG.LIFETOUCH_ID=ACCOUNT.LIFETOUCH_ID (+))
AND (STG.PROFILE_ID=USER_ACCT_PRNCPL.ACCOUNT_PRINCIPAL_ID (+))
And (SOURCE_SYSTEM.SOURCE_SYSTEM_SHORT_NAME='HP')




) S
where NOT EXISTS 
	( select 1 from ODS_OWN.HOST_PORTAL_AUDIT T
	where	T.HOST_PORTAL_AUDIT_OID	= S.HOST_PORTAL_AUDIT_OID 
		 and ((T.ACCOUNT_OID = S.ACCOUNT_OID) or (T.ACCOUNT_OID IS NULL and S.ACCOUNT_OID IS NULL)) and
		((T.USER_ID = S.USER_ID) or (T.USER_ID IS NULL and S.USER_ID IS NULL)) and
		((T.ACTIVITY_TYPE = S.ACTIVITY_TYPE) or (T.ACTIVITY_TYPE IS NULL and S.ACTIVITY_TYPE IS NULL)) and
		((T.SOURCE_SYSTEM_OID = S.SOURCE_SYSTEM_OID) or (T.SOURCE_SYSTEM_OID IS NULL and S.SOURCE_SYSTEM_OID IS NULL)) and
		((T.USER_TYPE = S.USER_TYPE) or (T.USER_TYPE IS NULL and S.USER_TYPE IS NULL)) and
		((T.PROFILE_ID = S.PROFILE_ID) or (T.PROFILE_ID IS NULL and S.PROFILE_ID IS NULL)) and
		((T.USER_ACCOUNT_PRINCIPAL_OID = S.USER_ACCOUNT_PRINCIPAL_OID) or (T.USER_ACCOUNT_PRINCIPAL_OID IS NULL and S.USER_ACCOUNT_PRINCIPAL_OID IS NULL))
        )

  
  

  



&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_HOST_PORTAL_AUDIT673001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_HOST_PORTAL_AUDIT_IDX673001
on		RAX_APP_USER.I$_HOST_PORTAL_AUDIT673001 (HOST_PORTAL_AUDIT_OID)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* Merge Rows */

merge into	ODS_OWN.HOST_PORTAL_AUDIT T
using	RAX_APP_USER.I$_HOST_PORTAL_AUDIT673001 S
on	(
		T.HOST_PORTAL_AUDIT_OID=S.HOST_PORTAL_AUDIT_OID
	)
when matched
then update set
	T.ACCOUNT_OID	= S.ACCOUNT_OID,
	T.USER_ID	= S.USER_ID,
	T.ACTIVITY_TYPE	= S.ACTIVITY_TYPE,
	T.SOURCE_SYSTEM_OID	= S.SOURCE_SYSTEM_OID,
	T.USER_TYPE	= S.USER_TYPE,
	T.PROFILE_ID	= S.PROFILE_ID,
	T.USER_ACCOUNT_PRINCIPAL_OID	= S.USER_ACCOUNT_PRINCIPAL_OID
	,       T.ODS_MODIFY_DATE	= sysdate
when not matched
then insert
	(
	T.HOST_PORTAL_AUDIT_OID,
	T.ACCOUNT_OID,
	T.USER_ID,
	T.ACTIVITY_DATE,
	T.ACTIVITY_TYPE,
	T.SOURCE_SYSTEM_OID,
	T.USER_TYPE,
	T.PROFILE_ID,
	T.USER_ACCOUNT_PRINCIPAL_OID
	,         T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.HOST_PORTAL_AUDIT_OID,
	S.ACCOUNT_OID,
	S.USER_ID,
	S.ACTIVITY_DATE,
	S.ACTIVITY_TYPE,
	S.SOURCE_SYSTEM_OID,
	S.USER_TYPE,
	S.PROFILE_ID,
	S.USER_ACCOUNT_PRINCIPAL_OID
	,         sysdate,
	sysdate
	)

&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 31 */
/* Drop flow table */

drop table RAX_APP_USER.I$_HOST_PORTAL_AUDIT673001 

&


/*-----------------------------------------------*/
/* TASK No. 32 */
/* Update CDC Load Status */

/*
UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR('2024-06-11 06:05:19.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
+ nvl((TIMEZONE_OFFSET/24), 0) 
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

&


/*-----------------------------------------------*/
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
CONTEXT_NAME,
TIMEZONE_OFFSET              
)
select 
:v_cdc_load_table_name
,29896963200
,'LOAD_APP_AUDIT_PKG'
,'003'
,TO_DATE(SUBSTR('2024-06-11 06:05:19.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
,TO_DATE (SUBSTR(:v_cdc_load_date, 1, 19),'YYYY-MM-DD HH24:MI:SS')
,:v_cdc_overlap
,SYSDATE
,:v_env
,TIMEZONE_OFFSET
from 
ODS_OWN.ODS_CDC_LOAD_STATUS
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

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
CONTEXT_NAME              
)
values (
:v_cdc_load_table_name,
:v_sess_no,
'LOAD_APP_AUDIT_PKG',
'003',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)


&


/*-----------------------------------------------*/
