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
/* DELETE ODS_OWN.Account_Princpal */

DELETE FROM ODS_OWN.USER_ACCOUNT_PRINCIPAL T
      WHERE EXISTS
               (SELECT 1
                  FROM ODS_STAGE.AAR_USER_ACCOUNT_PRINCIPAL_XR            XR,
                       ODS_STAGE.AAR_RECORD_CHANGE_AUDIT_STG D
                 WHERE     XR.USER_ACCOUNT_PRINCIPAL_OID = T.USER_ACCOUNT_PRINCIPAL_OID
                       AND XR.ACCOUNT_PRINCIPAL_ID_KEY = D.KEY_VALUE
                       AND D.EVENT_TYPE = 'DELETE'
                       AND D.TABLE_NAME = 'ACCOUNT_PRINCIPAL'
                       AND d.ods_create_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap)
                       

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Delete Stage */

DELETE FROM ODS_STAGE.AAR_ACCOUNT_PRINCIPAL_STG T
      WHERE EXISTS
               (SELECT 1
                  FROM ODS_STAGE.AAR_RECORD_CHANGE_AUDIT_STG D
                 WHERE     T.ACCOUNT_PRINCIPAL_ID = D.KEY_VALUE
                       AND D.EVENT_TYPE = 'DELETE'
                       AND D.TABLE_NAME = 'ACCOUNT_PRINCIPAL'
                       AND d.ods_create_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap)

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Insert new rows */

 
insert into	ODS_STAGE.AAR_USER_ACCOUNT_PRINCIPAL_XR 
( 
	ACCOUNT_PRINCIPAL_ID_KEY 
	,USER_ACCOUNT_PRINCIPAL_OID,
	ODS_CREATE_DATE 
) 

select
    ACCOUNT_PRINCIPAL_ID_KEY   
  ,ODS_STAGE.USER_ACCOUNT_PRINCIPAL_OID_SEQ.nextval,
	sysdate 
FROM (	


select 	DISTINCT
	AAR_ACCOUNT_PRINCIPAL_STG.ACCOUNT_PRINCIPAL_ID ACCOUNT_PRINCIPAL_ID_KEY 
from	ODS_STAGE.AAR_USER_ACCOUNT_PRINCIPAL_XR   AAR_USER_ACCOUNT_PRINCIPAL_XR, ODS_STAGE.AAR_ACCOUNT_PRINCIPAL_STG   AAR_ACCOUNT_PRINCIPAL_STG
where		(1=1)	
 And (AAR_ACCOUNT_PRINCIPAL_STG.ACCOUNT_PRINCIPAL_ID=AAR_USER_ACCOUNT_PRINCIPAL_XR.ACCOUNT_PRINCIPAL_ID_KEY(+)and AAR_USER_ACCOUNT_PRINCIPAL_XR.ACCOUNT_PRINCIPAL_ID_KEY is null)





)    ODI_GET_FROM




&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Commit transaction */

/* commit */


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Drop flow table */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.I$_USER_ACCT_PRNCPL';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -942 THEN
            DBMS_OUTPUT.PUT_LINE('Table does not exist.');
        ELSE
            RAISE;
        END IF;
END;


&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_USER_ACCT_PRNCPL
(
	USER_ACCOUNT_PRINCIPAL_OID	NUMBER NULL,
	USER_PROFILE_OID	NUMBER NULL,
	ACCOUNT_PRINCIPAL_ID	VARCHAR2(255) NULL,
	LIFETOUCH_AD_ACCOUNT	VARCHAR2(255) NULL,
	ODS_MODIFY_DATE	DATE NULL,
	ODS_CREATE_DATE	DATE NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Insert flow into I$ table */

insert /*+ APPEND */  into RAX_APP_USER.I$_USER_ACCT_PRNCPL
	(
	USER_ACCOUNT_PRINCIPAL_OID,
	USER_PROFILE_OID,
	ACCOUNT_PRINCIPAL_ID,
	LIFETOUCH_AD_ACCOUNT
	,IND_UPDATE
	)


select 	 
	DISTINCT
	AAR_USER_ACCOUNT_PRINCIPAL_XR.USER_ACCOUNT_PRINCIPAL_OID,
	USER_PROFILE.USER_PROFILE_OID,
	AAR_ACCOUNT_PRINCIPAL_STG.ACCOUNT_PRINCIPAL_ID,
	AAR_ACCOUNT_PRINCIPAL_STG.LIFETOUCH_AD_ACCOUNT,

	'I' IND_UPDATE

from	ODS_STAGE.AAR_USER_ACCOUNT_PRINCIPAL_XR   AAR_USER_ACCOUNT_PRINCIPAL_XR, ODS_STAGE.AAR_ACCOUNT_PRINCIPAL_STG   AAR_ACCOUNT_PRINCIPAL_STG, ODS_OWN.USER_PROFILE   USER_PROFILE, ODS_OWN.SOURCE_SYSTEM   SOURCE_SYSTEM
where	(1=1)
 And (AAR_ACCOUNT_PRINCIPAL_STG.ACCOUNT_PRINCIPAL_ID=AAR_USER_ACCOUNT_PRINCIPAL_XR.ACCOUNT_PRINCIPAL_ID_KEY)
AND (AAR_ACCOUNT_PRINCIPAL_STG.LIFETOUCH_USER_PROFILE_ID=USER_PROFILE.LIFETOUCH_USER_PROFILE_ID (+))
AND (USER_PROFILE.SOURCE_SYSTEM_OID=SOURCE_SYSTEM.SOURCE_SYSTEM_OID
OR
AAR_ACCOUNT_PRINCIPAL_STG.LIFETOUCH_USER_PROFILE_ID IS NULL)
And (SOURCE_SYSTEM.SOURCE_SYSTEM_SHORT_NAME = 'USRPFL')




minus
select
	USER_ACCOUNT_PRINCIPAL_OID,
	USER_PROFILE_OID,
	ACCOUNT_PRINCIPAL_ID,
	LIFETOUCH_AD_ACCOUNT
	,'I'	IND_UPDATE
from	ODS_OWN.USER_ACCOUNT_PRINCIPAL

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_USER_ACCT_PRNCPL',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&



/*-----------------------------------------------*/
/* TASK No. 12 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_USER_ACCT_PRNCPL_IDX
on		RAX_APP_USER.I$_USER_ACCT_PRNCPL (USER_ACCOUNT_PRINCIPAL_OID)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* drop table SNP_CHECK_TAB */

drop table RAX_APP_USER.SNP_CHECK_TAB

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* create check table */


create table RAX_APP_USER.SNP_CHECK_TAB
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
)
	

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* delete previous check sum */

delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS_OWN'
and	ORIGIN 		= '(1633001)ODS_Project.LOAD_USER_ACCOUNT_PRINCIPAL_INT'
and	ERR_TYPE 		= 'F'


&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* create error table */

BEGIN  
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.E$_USER_ACCT_PRNCPL
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	USER_ACCOUNT_PRINCIPAL_OID	NUMBER NULL,
	USER_PROFILE_OID	NUMBER NULL,
	ACCOUNT_PRINCIPAL_ID	VARCHAR2(255) NULL,
	LIFETOUCH_AD_ACCOUNT	VARCHAR2(255) NULL,
	ODS_MODIFY_DATE	DATE NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
	ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
	ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
	ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
	ODI_SESS_NO		VARCHAR2(19 CHAR)
)';  
EXCEPTION  
   WHEN OTHERS THEN  
      NULL;
END;


&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* delete previous errors */

delete from 	RAX_APP_USER.E$_USER_ACCT_PRNCPL
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(1633001)ODS_Project.LOAD_USER_ACCOUNT_PRINCIPAL_INT')



&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Create index on PK */

 
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX RAX_APP_USER.I$_USER_ACCT_PRNCPL_IDX ON RAX_APP_USER.I$_USER_ACCT_PRNCPL (USER_ACCOUNT_PRINCIPAL_OID)';
    DBMS_OUTPUT.PUT_LINE('Index created successfully.');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            DBMS_OUTPUT.PUT_LINE('Index already exists.');
        ELSE
            RAISE;
        END IF;
END;


&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* insert PK errors */

insert into RAX_APP_USER.E$_USER_ACCT_PRNCPL
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
	USER_ACCOUNT_PRINCIPAL_OID,
	USER_PROFILE_OID,
	ACCOUNT_PRINCIPAL_ID,
	LIFETOUCH_AD_ACCOUNT,
	ODS_MODIFY_DATE,
	ODS_CREATE_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15064: The primary key USER_ACCOUNT_PRINCIPAL_PK is not unique.',
	'(1633001)ODS_Project.LOAD_USER_ACCOUNT_PRINCIPAL_INT',
	sysdate,
	'USER_ACCOUNT_PRINCIPAL_PK',
	'PK',	
	USER_ACCT_PRNCPL.USER_ACCOUNT_PRINCIPAL_OID,
	USER_ACCT_PRNCPL.USER_PROFILE_OID,
	USER_ACCT_PRNCPL.ACCOUNT_PRINCIPAL_ID,
	USER_ACCT_PRNCPL.LIFETOUCH_AD_ACCOUNT,
	USER_ACCT_PRNCPL.ODS_MODIFY_DATE,
	USER_ACCT_PRNCPL.ODS_CREATE_DATE
from	RAX_APP_USER.I$_USER_ACCT_PRNCPL   USER_ACCT_PRNCPL
where	exists  (
		select	SUB.USER_ACCOUNT_PRINCIPAL_OID
		from 	RAX_APP_USER.I$_USER_ACCT_PRNCPL SUB
		where 	SUB.USER_ACCOUNT_PRINCIPAL_OID=USER_ACCT_PRNCPL.USER_ACCOUNT_PRINCIPAL_OID
		group by 	SUB.USER_ACCOUNT_PRINCIPAL_OID
		having 	count(1) > 1
		)



&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_USER_ACCT_PRNCPL
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
	USER_ACCOUNT_PRINCIPAL_OID,
	USER_PROFILE_OID,
	ACCOUNT_PRINCIPAL_ID,
	LIFETOUCH_AD_ACCOUNT,
	ODS_MODIFY_DATE,
	ODS_CREATE_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column USER_ACCOUNT_PRINCIPAL_OID cannot be null.',
	sysdate,
	'(1633001)ODS_Project.LOAD_USER_ACCOUNT_PRINCIPAL_INT',
	'USER_ACCOUNT_PRINCIPAL_OID',
	'NN',	
	USER_ACCOUNT_PRINCIPAL_OID,
	USER_PROFILE_OID,
	ACCOUNT_PRINCIPAL_ID,
	LIFETOUCH_AD_ACCOUNT,
	ODS_MODIFY_DATE,
	ODS_CREATE_DATE
from	RAX_APP_USER.I$_USER_ACCT_PRNCPL
where	USER_ACCOUNT_PRINCIPAL_OID is null



&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* create index on error table */

 
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */

BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX RAX_APP_USER.E$_USER_ACCT_PRNCPL_IDX ON RAX_APP_USER.E$_USER_ACCT_PRNCPL (ODI_ROW_ID)';
    DBMS_OUTPUT.PUT_LINE('Index created successfully.');
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            DBMS_OUTPUT.PUT_LINE('Index already exists.');
        ELSE
            RAISE;
        END IF;
END;


&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* delete errors from controlled table */

delete from	RAX_APP_USER.I$_USER_ACCT_PRNCPL  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_USER_ACCT_PRNCPL E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)


&


/*-----------------------------------------------*/
/* TASK No. 22 */
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
	'ODS_OWN',
	'USER_ACCT_PRNCPL',
	'ODS_OWN.USER_ACCOUNT_PRINCIPAL',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_USER_ACCT_PRNCPL E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(1633001)ODS_Project.LOAD_USER_ACCOUNT_PRINCIPAL_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE


&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Merge Rows */

merge into ODS_OWN.USER_ACCOUNT_PRINCIPAL T
using RAX_APP_USER.I$_USER_ACCT_PRNCPL S
on (
		T.USER_ACCOUNT_PRINCIPAL_OID=S.USER_ACCOUNT_PRINCIPAL_OID
	)
when matched
then update set
	T.USER_PROFILE_OID = S.USER_PROFILE_OID,
	T.ACCOUNT_PRINCIPAL_ID = S.ACCOUNT_PRINCIPAL_ID,
	T.LIFETOUCH_AD_ACCOUNT = S.LIFETOUCH_AD_ACCOUNT
	, T.ODS_MODIFY_DATE  = sysdate
when not matched
then insert
	(
	T.USER_ACCOUNT_PRINCIPAL_OID,
	T.USER_PROFILE_OID,
	T.ACCOUNT_PRINCIPAL_ID,
	T.LIFETOUCH_AD_ACCOUNT
	, T.ODS_MODIFY_DATE,
	T.ODS_CREATE_DATE
	)
values
	(
	S.USER_ACCOUNT_PRINCIPAL_OID,
	S.USER_PROFILE_OID,
	S.ACCOUNT_PRINCIPAL_ID,
	S.LIFETOUCH_AD_ACCOUNT
	, sysdate,
	sysdate
	)

&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 25 */
/* Drop flow table */

drop table RAX_APP_USER.I$_USER_ACCT_PRNCPL 

&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
+ nvl((TIMEZONE_OFFSET/24), 0) 
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

/*
UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/

&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* Insert CDC Audit Record */

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
,'LOAD_ACCOUNT_PRINCIPAL_PKG'
,'006'
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
'LOAD_ACCOUNT_PRINCIPAL_PKG',
'006',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/


&


/*-----------------------------------------------*/
