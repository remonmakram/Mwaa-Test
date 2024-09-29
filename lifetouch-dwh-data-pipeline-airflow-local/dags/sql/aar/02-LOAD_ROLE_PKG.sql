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
/* Delete from ODS_OWN.Role */

DELETE FROM ODS_OWN.USER_ROLE T
      WHERE EXISTS
               (SELECT 1
                  FROM ODS_STAGE.AAR_USER_ROLE_XR            XR,
                       ODS_STAGE.AAR_RECORD_CHANGE_AUDIT_STG D
                 WHERE     XR.USER_ROLE_OID = T.USER_ROLE_OID
                       AND XR.ROLE_ID_KEY = D.KEY_VALUE
                       AND D.EVENT_TYPE = 'DELETE'
                       AND D.TABLE_NAME = 'ROLE'
                       AND d.ods_create_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap)

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Delete from Stage */

DELETE FROM ODS_STAGE.AAR_ROLE_STG T
      WHERE EXISTS
               (SELECT 1
                  FROM ODS_STAGE.AAR_RECORD_CHANGE_AUDIT_STG D
                 WHERE     T.ROLE_ID = D.KEY_VALUE
                       AND D.EVENT_TYPE = 'DELETE'
                       AND D.TABLE_NAME = 'ROLE'
                       AND d.ods_create_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap)

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Merge into XR */

MERGE INTO ods_stage.aar_user_role_xr d
     USING (SELECT role_id,
                   REGEXP_SUBSTR (s.ROLE_NAME, '\d+$') AS lifetouch_id
              FROM ods_stage.aar_role_stg s
             WHERE s.ods_modify_date
                   >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap) s
        ON (s.role_id = d.role_id_key)
WHEN NOT MATCHED
THEN
    INSERT     (user_role_oid,
                role_id_key,
                lifetouch_id,
                ods_create_date)
        VALUES (ods_stage.USER_ROLE_OID_SEQ.NEXTVAL,
                role_id,
                lifetouch_id,
                SYSDATE)
WHEN MATCHED
THEN
    UPDATE SET
        d.lifetouch_id = s.lifetouch_id
             WHERE DECODE (s.lifetouch_id, d.lifetouch_id, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Drop flow table */

BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_USER_ROLE';
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
/* TASK No. 8 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_USER_ROLE
(
	USER_ROLE_OID	NUMBER NULL,
	ACCOUNT_OID	NUMBER NULL,
	ROLE_ID	NUMBER NULL,
	ROLE_NAME	VARCHAR2(255) NULL,
	SCHEME	VARCHAR2(64) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	USER_ACCOUNT_PRINCIPAL_OID	NUMBER NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Insert flow into I$ table */

insert /*+ APPEND */  into RAX_APP_USER.I$_USER_ROLE
	(
	USER_ROLE_OID,
	ACCOUNT_OID,
	ROLE_ID,
	ROLE_NAME,
	SCHEME,
	USER_ACCOUNT_PRINCIPAL_OID
	,IND_UPDATE
	)


select 	 
	
	AAR_USER_ROLE_XR.USER_ROLE_OID,
	ACCOUNT.ACCOUNT_OID,
	AAR_ROLE_STG.ROLE_ID,
	AAR_ROLE_STG.ROLE_NAME,
	AAR_ROLE_STG.SCHEME,
	USER_ACCT_PRNCPL.USER_ACCOUNT_PRINCIPAL_OID,

	'I' IND_UPDATE

from	ODS_STAGE.AAR_USER_ROLE_XR   AAR_USER_ROLE_XR, ODS_STAGE.AAR_ROLE_STG   AAR_ROLE_STG, ODS_OWN.ACCOUNT   ACCOUNT, ODS_OWN.USER_ACCOUNT_PRINCIPAL   USER_ACCT_PRNCPL
where	(1=1)
 And (AAR_USER_ROLE_XR.ROLE_ID_KEY=AAR_ROLE_STG.ROLE_ID)
AND (AAR_USER_ROLE_XR.LIFETOUCH_ID=ACCOUNT.LIFETOUCH_ID (+))
AND (AAR_ROLE_STG.ACCOUNT_PRINCIPAL_ID=USER_ACCT_PRNCPL.ACCOUNT_PRINCIPAL_ID)





minus
select
	USER_ROLE_OID,
	ACCOUNT_OID,
	ROLE_ID,
	ROLE_NAME,
	SCHEME,
	USER_ACCOUNT_PRINCIPAL_OID
	,'I'	IND_UPDATE
from	ODS_OWN.USER_ROLE

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_USER_ROLE',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_USER_ROLE_IDX
on		RAX_APP_USER.I$_USER_ROLE (USER_ROLE_OID)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* drop table SNP_CHECK_TAB */

drop table RAX_APP_USER.SNP_CHECK_TAB

&


/*-----------------------------------------------*/
/* TASK No. 13 */
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
/* TASK No. 14 */
/* delete previous check sum */

delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS_OWN'
and	ORIGIN 		= '(1636001)ODS_Project.LOAD_USER_ROLE_INT'
and	ERR_TYPE 		= 'F'


&
/*-----------------------------------------------*/
/* TASK No. 16 */
/* drop error table */

drop table RAX_APP_USER.E$_USER_ROLE


&



/*-----------------------------------------------*/
/* TASK No. 15 */
/* create error table */
BEGIN  
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.E$_USER_ROLE
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	USER_ROLE_OID	NUMBER NULL,
	ACCOUNT_OID	NUMBER NULL,
	ROLE_ID	NUMBER NULL,
	ROLE_NAME	VARCHAR2(255) NULL,
	SCHEME	VARCHAR2(64) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	USER_ACCOUNT_PRINCIPAL_OID	NUMBER NULL,
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
/* TASK No. 16 */
/* delete previous errors */

delete from 	RAX_APP_USER.E$_USER_ROLE
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(1636001)ODS_Project.LOAD_USER_ROLE_INT')


&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Create index on PK */

 
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX RAX_APP_USER.I$_USER_ROLE_IDX ON RAX_APP_USER.I$_USER_ROLE (USER_ROLE_OID)';
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

insert into RAX_APP_USER.E$_USER_ROLE
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
	USER_ROLE_OID,
	ACCOUNT_OID,
	ROLE_ID,
	ROLE_NAME,
	SCHEME,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	USER_ACCOUNT_PRINCIPAL_OID
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15064: The primary key USER_ROLE_PK is not unique.',
	'(1636001)ODS_Project.LOAD_USER_ROLE_INT',
	sysdate,
	'USER_ROLE_PK',
	'PK',	
	USER_ROLE.USER_ROLE_OID,
	USER_ROLE.ACCOUNT_OID,
	USER_ROLE.ROLE_ID,
	USER_ROLE.ROLE_NAME,
	USER_ROLE.SCHEME,
	USER_ROLE.ODS_CREATE_DATE,
	USER_ROLE.ODS_MODIFY_DATE,
	USER_ROLE.USER_ACCOUNT_PRINCIPAL_OID
from	RAX_APP_USER.I$_USER_ROLE   USER_ROLE
where	exists  (
		select	SUB.USER_ROLE_OID
		from 	RAX_APP_USER.I$_USER_ROLE SUB
		where 	SUB.USER_ROLE_OID=USER_ROLE.USER_ROLE_OID
		group by 	SUB.USER_ROLE_OID
		having 	count(1) > 1
		)



&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_USER_ROLE
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
	USER_ROLE_OID,
	ACCOUNT_OID,
	ROLE_ID,
	ROLE_NAME,
	SCHEME,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	USER_ACCOUNT_PRINCIPAL_OID
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column USER_ROLE_OID cannot be null.',
	sysdate,
	'(1636001)ODS_Project.LOAD_USER_ROLE_INT',
	'USER_ROLE_OID',
	'NN',	
	USER_ROLE_OID,
	ACCOUNT_OID,
	ROLE_ID,
	ROLE_NAME,
	SCHEME,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	USER_ACCOUNT_PRINCIPAL_OID
from	RAX_APP_USER.I$_USER_ROLE
where	USER_ROLE_OID is null



&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* create index on error table */

BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX RAX_APP_USER.E$_USER_ROLE_IDX ON RAX_APP_USER.E$_USER_ROLE (ODI_ROW_ID)';
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

delete from	RAX_APP_USER.I$_USER_ROLE  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_USER_ROLE E
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
	'USER_ROLE',
	'ODS_OWN.USER_ROLE',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_USER_ROLE E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(1636001)ODS_Project.LOAD_USER_ROLE_INT'
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

merge into	ODS_OWN.USER_ROLE T
using	RAX_APP_USER.I$_USER_ROLE S
on	(
		T.USER_ROLE_OID=S.USER_ROLE_OID
	)
when matched
then update set
	T.ACCOUNT_OID	= S.ACCOUNT_OID,
	T.ROLE_ID	= S.ROLE_ID,
	T.ROLE_NAME	= S.ROLE_NAME,
	T.SCHEME	= S.SCHEME,
	T.USER_ACCOUNT_PRINCIPAL_OID	= S.USER_ACCOUNT_PRINCIPAL_OID
	,     T.ODS_MODIFY_DATE	= sysdate
when not matched
then insert
	(
	T.USER_ROLE_OID,
	T.ACCOUNT_OID,
	T.ROLE_ID,
	T.ROLE_NAME,
	T.SCHEME,
	T.USER_ACCOUNT_PRINCIPAL_OID
	,      T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.USER_ROLE_OID,
	S.ACCOUNT_OID,
	S.ROLE_ID,
	S.ROLE_NAME,
	S.SCHEME,
	S.USER_ACCOUNT_PRINCIPAL_OID
	,      sysdate,
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

drop table RAX_APP_USER.I$_USER_ROLE 

&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* Update Account_OID */

MERGE INTO ODS_OWN.USER_ROLE t
     USING (SELECT ur.USER_ROLE_OID, a.ACCOUNT_OID
              FROM ods_own.user_role ur, ods_own.apo a
             WHERE     SUBSTR (ur.SCHEME, 8, 16) = a.apo_id
                   AND ur.role_name LIKE 'ROLE:%'
                   AND ur.ods_modify_date
                   >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap) s
        ON (t.user_role_oid = s.user_role_oid)
WHEN MATCHED
THEN
    UPDATE SET t.account_oid = s.account_oid,
                         t.ods_modify_date = sysdate
             WHERE DECODE (s.account_oid, account_oid, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 27 */
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
/* TASK No. 28 */
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
,'LOAD_ROLE_PKG'
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
'LOAD_ROLE_PKG',
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
