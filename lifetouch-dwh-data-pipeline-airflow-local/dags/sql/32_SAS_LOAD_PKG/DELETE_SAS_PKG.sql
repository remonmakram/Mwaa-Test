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

-- drop table RAX_APP_USER.C$_0SAS_RCA purge

-- &


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Create work table */

-- create table RAX_APP_USER.C$_0SAS_RCA
-- (
-- 	C1_TABLE_NAME	VARCHAR2(30) NULL,
-- 	C2_KEY_VALUE	VARCHAR2(255) NULL,
-- 	C3_EVENT_TYPE	VARCHAR2(10) NULL,
-- 	C4_EVENT_DETAIL	VARCHAR2(2000) NULL,
-- 	C5_DATE_CREATED	TIMESTAMP(6) NULL
-- )
-- NOLOGGING

-- &


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Load data */

/* SOURCE CODE */


-- select	
-- 	RECORD_CHANGE_AUDIT.TABLE_NAME	   C1_TABLE_NAME,
-- 	RECORD_CHANGE_AUDIT.KEY_VALUE	   C2_KEY_VALUE,
-- 	RECORD_CHANGE_AUDIT.EVENT_TYPE	   C3_EVENT_TYPE,
-- 	RECORD_CHANGE_AUDIT.EVENT_DETAIL	   C4_EVENT_DETAIL,
-- 	RECORD_CHANGE_AUDIT.DATE_CREATED	   C5_DATE_CREATED
-- from	SAS_SIT_OWN.RECORD_CHANGE_AUDIT   RECORD_CHANGE_AUDIT
-- where	(1=1)
-- And (RECORD_CHANGE_AUDIT.DATE_CREATED  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap)



-- &

/* TARGET CODE */
-- insert /*+ append */ into RAX_APP_USER.C$_0SAS_RCA
-- (
-- 	C1_TABLE_NAME,
-- 	C2_KEY_VALUE,
-- 	C3_EVENT_TYPE,
-- 	C4_EVENT_DETAIL,
-- 	C5_DATE_CREATED
-- )
-- values
-- (
-- 	:C1_TABLE_NAME,
-- 	:C2_KEY_VALUE,
-- 	:C3_EVENT_TYPE,
-- 	:C4_EVENT_DETAIL,
-- 	:C5_DATE_CREATED
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0SAS_RCA',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;



&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 9 */




/*-----------------------------------------------*/
/* TASK No. 10 */
/* Drop flow table */

-- drop table RAX_APP_USER.I$_SAS_RCA1610001

BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_SAS_RCA1610001';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&



/*-----------------------------------------------*/
/* TASK No. 11 */
/* Create flow table I$ */



create table RAX_APP_USER.I$_SAS_RCA1610001
(
	TABLE_NAME	VARCHAR2(30) NULL,
	KEY_VALUE	VARCHAR2(255) NULL,
	EVENT_TYPE	VARCHAR2(10) NULL,
	EVENT_DETAIL	VARCHAR2(2000) NULL,
	DATE_CREATED	TIMESTAMP(6) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_SAS_RCA1610001
(
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	IND_UPDATE
)
select 
TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	IND_UPDATE
 from (


select 	 
	
	C1_TABLE_NAME TABLE_NAME,
	C2_KEY_VALUE KEY_VALUE,
	C3_EVENT_TYPE EVENT_TYPE,
	C4_EVENT_DETAIL EVENT_DETAIL,
	C5_DATE_CREATED DATE_CREATED,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0SAS_RCA
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.SAS_RECORD_CHANGE_AUDIT T
	where	T.KEY_VALUE	= S.KEY_VALUE 
		 and ((T.TABLE_NAME = S.TABLE_NAME) or (T.TABLE_NAME IS NULL and S.TABLE_NAME IS NULL)) and
		((T.EVENT_TYPE = S.EVENT_TYPE) or (T.EVENT_TYPE IS NULL and S.EVENT_TYPE IS NULL)) and
		((T.EVENT_DETAIL = S.EVENT_DETAIL) or (T.EVENT_DETAIL IS NULL and S.EVENT_DETAIL IS NULL)) and
		((T.DATE_CREATED = S.DATE_CREATED) or (T.DATE_CREATED IS NULL and S.DATE_CREATED IS NULL))
        )

  
  

  



&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_SAS_RCA1610001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Create Index on flow table */

-- create index	RAX_APP_USER.I$_SAS_RCA_IDX1610001
-- on		RAX_APP_USER.I$_SAS_RCA1610001 (KEY_VALUE)
-- NOLOGGING


BEGIN
  EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.I$_SAS_RCA_IDX1610001
on   RAX_APP_USER.I$_SAS_RCA1610001 (KEY_VALUE)';
EXCEPTION
  WHEN OTHERS THEN
   -- Handle the case where the identifier is too long or such column list already indexed (ORA-00972 or ORA-01408)
   IF SQLCODE = -972 or  SQLCODE = -1408 or SQLCODE = -955  THEN
     DBMS_OUTPUT.PUT_LINE('Skipping creation of index.');
   ELSE
     RAISE;
   END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* create check table */

BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.SNP_CHECK_TAB';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&

-- create table RAX_APP_USER.SNP_CHECK_TAB
-- (
-- 	CATALOG_NAME	VARCHAR2(100 CHAR) NULL ,
-- 	SCHEMA_NAME	VARCHAR2(100 CHAR) NULL ,
-- 	RESOURCE_NAME	VARCHAR2(100 CHAR) NULL,
-- 	FULL_RES_NAME	VARCHAR2(100 CHAR) NULL,
-- 	ERR_TYPE		VARCHAR2(1 CHAR) NULL,
-- 	ERR_MESS		VARCHAR2(250 CHAR) NULL ,
-- 	CHECK_DATE	DATE NULL,
-- 	ORIGIN		VARCHAR2(100 CHAR) NULL,
-- 	CONS_NAME	VARCHAR2(35 CHAR) NULL,
-- 	CONS_TYPE		VARCHAR2(2 CHAR) NULL,
-- 	ERR_COUNT		NUMBER(10) NULL
-- )

BEGIN
   EXECUTE IMMEDIATE '
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
   ';
END;
	

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* delete previous check sum */

delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS_STAGE'
and	ORIGIN 		= '(1610001)ODS_Project.LOAD_SAS_RECORD_CHANGE_AUDIT_INT'
and	ERR_TYPE 		= 'F'


&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* create error table */

BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.E$_SAS_RCA1610001';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&

create table RAX_APP_USER.E$_SAS_RCA1610001
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	TABLE_NAME	VARCHAR2(30) NULL,
	KEY_VALUE	VARCHAR2(255) NULL,
	EVENT_TYPE	VARCHAR2(10) NULL,
	EVENT_DETAIL	VARCHAR2(2000) NULL,
	DATE_CREATED	TIMESTAMP(6) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
	ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
	ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
	ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
	ODI_SESS_NO		VARCHAR2(19 CHAR)
)



&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* delete previous errors */

delete from 	RAX_APP_USER.E$_SAS_RCA1610001
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(1610001)ODS_Project.LOAD_SAS_RECORD_CHANGE_AUDIT_INT')


&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_SAS_RCA1610001
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
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column TABLE_NAME cannot be null.',
	sysdate,
	'(1610001)ODS_Project.LOAD_SAS_RECORD_CHANGE_AUDIT_INT',
	'TABLE_NAME',
	'NN',	
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_SAS_RCA1610001
where	TABLE_NAME is null



&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_SAS_RCA1610001
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
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column KEY_VALUE cannot be null.',
	sysdate,
	'(1610001)ODS_Project.LOAD_SAS_RECORD_CHANGE_AUDIT_INT',
	'KEY_VALUE',
	'NN',	
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_SAS_RCA1610001
where	KEY_VALUE is null



&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* create index on error table */

 
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */
-- create index 	RAX_APP_USER.E$_SAS_RCA1610001
-- on	RAX_APP_USER.E$_SAS_RCA1610001 (ODI_ROW_ID)


BEGIN
  EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_SAS_RCA1610001
on   RAX_APP_USER.E$_SAS_RCA1610001 (ODI_ROW_ID)';
EXCEPTION
  WHEN OTHERS THEN
   -- Handle the case where the identifier is too long or such column list already indexed (ORA-00972 or ORA-01408)
   IF SQLCODE = -972 or  SQLCODE = -1408 or SQLCODE = -955  THEN
     DBMS_OUTPUT.PUT_LINE('Skipping creation of index.');
   ELSE
     RAISE;
   END IF;
END;


&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* delete errors from controlled table */

delete from	RAX_APP_USER.I$_SAS_RCA1610001  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_SAS_RCA1610001 E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)


&


/*-----------------------------------------------*/
/* TASK No. 23 */
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
	'SAS_RCA',
	'ODS_STAGE.SAS_RECORD_CHANGE_AUDIT1610001',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_SAS_RCA1610001 E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(1610001)ODS_Project.LOAD_SAS_RECORD_CHANGE_AUDIT_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE


&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* Merge Rows */

merge into	ODS_STAGE.SAS_RECORD_CHANGE_AUDIT T
using	RAX_APP_USER.I$_SAS_RCA1610001 S
on	(
		T.KEY_VALUE=S.KEY_VALUE
	)
when matched
then update set
	T.TABLE_NAME	= S.TABLE_NAME,
	T.EVENT_TYPE	= S.EVENT_TYPE,
	T.EVENT_DETAIL	= S.EVENT_DETAIL,
	T.DATE_CREATED	= S.DATE_CREATED
	,    T.ODS_MODIFY_DATE	= SYSDATE
when not matched
then insert
	(
	T.TABLE_NAME,
	T.KEY_VALUE,
	T.EVENT_TYPE,
	T.EVENT_DETAIL,
	T.DATE_CREATED
	,     T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.TABLE_NAME,
	S.KEY_VALUE,
	S.EVENT_TYPE,
	S.EVENT_DETAIL,
	S.DATE_CREATED
	,     sysdate,
	SYSDATE
	)

&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 26 */
/* Drop flow table */

-- drop table RAX_APP_USER.I$_SAS_RCA1610001

BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_SAS_RCA1610001';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */

-- drop table RAX_APP_USER.C$_0SAS_RCA purge

BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0SAS_RCA purge';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* 
DELETE FROM ODS_STAGE.SAS_APPOINTMENT_STG */

DELETE FROM ODS_STAGE.SAS_APPOINTMENT_STG    SAT
WHERE  EXISTS
   (SELECT  1
    FROM ODS_STAGE.SAS_RECORD_CHANGE_AUDIT  D
   WHERE TABLE_NAME ='APPOINTMENT' AND  D.KEY_VALUE= SAT.APPOINTMENT_ID 
   )

&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* DELETE FROM ODS_OWN.APPOINTMENT */

DELETE FROM ods_own.Appointment ARX
WHERE  EXISTS
   (SELECT 1
    FROM ODS_STAGE.SAS_RECORD_CHANGE_AUDIT  D
inner join ODS_STAGE.SAS_APPOINTMENT_XR x on x.SK_APPOINTMENT_ID= d.KEY_VALUE 
   WHERE TABLE_NAME='APPOINTMENT' AND x.APPOINTMENT_OID = ARX. APPOINTMENT_OID

   )

&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* UPDATE ODS_STAGE.SAS_APPOINTMENT_XR */

UPDATE ODS_STAGE.SAS_APPOINTMENT_XR ARX
   SET ARX.EXISTS_ON_SOURCE = 'Deleted on Source'
,  ARX.ODS_MODIFY_DATE =sysdate
 WHERE  EXISTS (SELECT 1
                               FROM ODS_STAGE.SAS_RECORD_CHANGE_AUDIT D
                              WHERE     TABLE_NAME = 'APPOINTMENT' AND  D.KEY_VALUE= ARX.SK_APPOINTMENT_ID 
                             
)






&


/*-----------------------------------------------*/
/* TASK No. 30 */
/*  DELETE FROM ODS_STAGE.SAS_APPOINTMENT_SLOT_STG */

DELETE FROM ODS_STAGE.SAS_APPOINTMENT_SLOT_STG    SAT
WHERE  EXISTS
   (SELECT 1
    FROM ODS_STAGE.SAS_RECORD_CHANGE_AUDIT  D
   WHERE TABLE_NAME ='APPOINTMENT_SLOT'  AND D.KEY_VALUE = SAT.APPOINTMENT_SLOT_ID 
   )

&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* DELETE FROM ODS_OWN.APPOINTMENT_SLOT */

DELETE FROM ODS_OWN.APPOINTMENT_SLOT ARX
WHERE  EXISTS
(SELECT 1
FROM  ODS_STAGE.SAS_RECORD_CHANGE_AUDIT  D
inner join ODS_STAGE.SAS_APPOINTMENT_SLOT_XR x on x.SK_APPOINTMENT_SLOT_ID= d.KEY_VALUE 
WHERE TABLE_NAME='APPOINTMENT_SLOT' AND   x.APPOINTMENT_SLOT_OID = ARX.APPOINTMENT_SLOT_OID

)

&


/*-----------------------------------------------*/
/* TASK No. 32 */
/* UPDATE ODS_STAGE.SAS_APPOINTMENT_SLOT_XR */

UPDATE ODS_STAGE.SAS_APPOINTMENT_SLOT_XR ARX
   SET ARX.EXISTS_ON_SOURCE = 'Deleted on Source'
, ARX.ODS_MODIFY_DATE = sysdate
 WHERE  EXISTS (SELECT  1
                               FROM ODS_STAGE.SAS_RECORD_CHANGE_AUDIT D
                              WHERE     TABLE_NAME = 'APPOINTMENT_SLOT'
                                AND D.KEY_VALUE = ARX.SK_APPOINTMENT_SLOT_ID 
)

&


/*-----------------------------------------------*/
/* TASK No. 33 */
/*  DELETE FROM ODS_STAGE.SAS_EVENT_IMAGE_FACT_STG */

DELETE FROM ODS_STAGE.SAS_EVENT_IMAGE_FACT_STG   SAT
WHERE  EXISTS
   (SELECT  1
    FROM ODS_STAGE.SAS_RECORD_CHANGE_AUDIT  D
   WHERE TABLE_NAME ='EVENT_IMAGE_FACT' AND  D.KEY_VALUE = SAT.EVENT_IMAGE_FACT_ID
   )


&


/*-----------------------------------------------*/
/* TASK No. 34 */
/*  DELETE FROM ODS_STAGE.SAS_PARENT_GUARDIAN_STG */

DELETE FROM ODS_STAGE.SAS_PARENT_GUARDIAN_STG   SAT
WHERE  EXISTS
   (SELECT  1
    FROM  ODS_STAGE.SAS_RECORD_CHANGE_AUDIT  D
   WHERE
    TABLE_NAME ='PARENT_GUARDIAN'  AND D.KEY_VALUE=  SAT.PARENT_GUARDIAN_ID
   )


&


/*-----------------------------------------------*/
/* TASK No. 35 */
/*  DELETE FROM ODS_STAGE.SAS_SUBJECT_ALIAS_STG */

DELETE FROM ODS_STAGE.SAS_SUBJECT_ALIAS_STG   SSA
WHERE EXISTS 
   (SELECT  1
    FROM ODS_STAGE.SAS_RECORD_CHANGE_AUDIT  D
   WHERE
    D.TABLE_NAME ='SUBJECT_ALIAS'  AND D.KEY_VALUE= SSA.SUBJECT_ALIAS_ID
   )


&


/*-----------------------------------------------*/
/* TASK No. 36 */
/*  DELETE FROM ODS_STAGE.SAS_SUBJECT_STG */

DELETE FROM ODS_STAGE.SAS_SUBJECT_STG    SAT
WHERE EXISTS
   (SELECT 1
    FROM ODS_STAGE.SAS_RECORD_CHANGE_AUDIT  D
   WHERE D.KEY_VALUE =SAT.SUBJECT_ID
       AND TABLE_NAME='SUBJECT'   AND D.KEY_VALUE=  SAT.SUBJECT_ID 
   )


&


/*-----------------------------------------------*/
/* TASK No. 37 */
/* DELETE FROM ODS_OWN.SUBJECT */

DELETE FROM ODS_OWN.SUBJECT ARX
WHERE  EXISTS
   (SELECT  1
    FROM  ODS_STAGE.SAS_RECORD_CHANGE_AUDIT  D
inner join ODS_STAGE.SAS_SUBJECT_XR x on x.SK_SUBJECT_ID= d.KEY_VALUE 
   WHERE TABLE_NAME ='SUBJECT' AND x.SUBJECT_OID = ARX.SUBJECT_OID

   )


&


/*-----------------------------------------------*/
/* TASK No. 38 */
/* UPDATE ODS_STAGE.SAS_SUBJECT_XR */

update ODS_STAGE.SAS_SUBJECT_XR ARX 
  set  ARX.exists_on_source ='Deleted on Source'
, ARX.ODS_MODIFY_DATE = sysdate
 where EXISTS (SELECT  1
         from ODS_STAGE.SAS_RECORD_CHANGE_AUDIT  D
  where 
       TABLE_NAME ='SUBJECT'  and   D.KEY_VALUE= ARX.SK_SUBJECT_ID
)



&


/*-----------------------------------------------*/
/* TASK No. 39 */
/*  DELETE FROM ODS_STAGE.SAS_PAYMENT_STG */

DELETE FROM ODS_STAGE.SAS_PAYMENT_STG   SPS
WHERE  EXISTS
   (SELECT 1
    FROM ODS_STAGE.SAS_RECORD_CHANGE_AUDIT  D
   WHERE D.TABLE_NAME ='PAYMENT' AND  D.KEY_VALUE =  SPS.PAYMENT_ID 
   )



&


/*-----------------------------------------------*/
/* TASK No. 40 */
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
/* TASK No. 41 */
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
,'DELETE_SAS_PKG'
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
'DELETE_SAS_PKG',
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
