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

-- drop table RAX_APP_USER.C$_0SAS_SUBSCR_TYP_STG purge

-- &


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Create work table */

-- create table RAX_APP_USER.C$_0SAS_SUBSCR_TYP_STG
-- (
-- 	C1_SUBSCRIPTION_TYPE_ID	NUMBER NULL,
-- 	C2_SUBSCRIPTION_TYPE	VARCHAR2(15) NULL
-- )
-- NOLOGGING

-- &


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Load data */

/* SOURCE CODE */


-- select	
-- 	SUBSCRIPTION_TYPE.SUBSCRIPTION_TYPE_ID	   C1_SUBSCRIPTION_TYPE_ID,
-- 	SUBSCRIPTION_TYPE.SUBSCRIPTION_TYPE	   C2_SUBSCRIPTION_TYPE
-- from	SAS_SIT_OWN.SUBSCRIPTION_TYPE   SUBSCRIPTION_TYPE
-- where	(1=1)








-- &

/* TARGET CODE */
-- insert /*+ append */ into RAX_APP_USER.C$_0SAS_SUBSCR_TYP_STG
-- (
-- 	C1_SUBSCRIPTION_TYPE_ID,
-- 	C2_SUBSCRIPTION_TYPE
-- )
-- values
-- (
-- 	:C1_SUBSCRIPTION_TYPE_ID,
-- 	:C2_SUBSCRIPTION_TYPE
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0SAS_SUBSCR_TYP_STG',
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

-- drop table RAX_APP_USER.I$_SAS_SUBSCR_TYP_STG1723001

BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_SAS_SUBSCR_TYP_STG1723001';
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

create table RAX_APP_USER.I$_SAS_SUBSCR_TYP_STG1723001
(
	SUBSCRIPTION_TYPE_ID	NUMBER NULL,
	SUBSCRIPTION_TYPE	VARCHAR2(15) NULL,
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
 


  


insert into	RAX_APP_USER.I$_SAS_SUBSCR_TYP_STG1723001
(
	SUBSCRIPTION_TYPE_ID,
	SUBSCRIPTION_TYPE,
	IND_UPDATE
)
select 
SUBSCRIPTION_TYPE_ID,
	SUBSCRIPTION_TYPE,
	IND_UPDATE
 from (


select 	 
	
	C1_SUBSCRIPTION_TYPE_ID SUBSCRIPTION_TYPE_ID,
	C2_SUBSCRIPTION_TYPE SUBSCRIPTION_TYPE,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0SAS_SUBSCR_TYP_STG
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.SAS_SUBSCRIPTION_TYPE_STG T
	where	T.SUBSCRIPTION_TYPE_ID	= S.SUBSCRIPTION_TYPE_ID 
		 and ((T.SUBSCRIPTION_TYPE = S.SUBSCRIPTION_TYPE) or (T.SUBSCRIPTION_TYPE IS NULL and S.SUBSCRIPTION_TYPE IS NULL))
        )

  
  

  



&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_SAS_SUBSCR_TYP_STG1723001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Create Index on flow table */

-- create index	RAX_APP_USER.I$_SAS_SUBSCR_TYP_STG_IDX1723001
-- on		RAX_APP_USER.I$_SAS_SUBSCR_TYP_STG1723001 (SUBSCRIPTION_TYPE_ID)
-- NOLOGGING


BEGIN
  EXECUTE IMMEDIATE 'create index RAX_APP_USER.I$_SAS_SUBSCR_TYP_STG_IDX1723001
on   RAX_APP_USER.I$_SAS_SUBSCR_TYP_STG1723001 (SUBSCRIPTION_TYPE_ID)';
EXCEPTION
  WHEN OTHERS THEN
   -- Handle the case where the identifier is too long (ORA-00972)
   IF SQLCODE = -972 or  SQLCODE = -1408 or SQLCODE = -955  THEN
     DBMS_OUTPUT.PUT_LINE('Identifier is too long. Skipping creation of index.');
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
and	ORIGIN 		= '(1723001)ODS_Project.LOAD_SAS_SUBSCRIPTION_TYPE_INT'
and	ERR_TYPE 		= 'F'


&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* create error table */

BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.E$_SAS_SUBSCR_TYP_STG1723001';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&


create table RAX_APP_USER.E$_SAS_SUBSCR_TYP_STG1723001
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	SUBSCRIPTION_TYPE_ID	NUMBER NULL,
	SUBSCRIPTION_TYPE	VARCHAR2(15) NULL,
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

delete from 	RAX_APP_USER.E$_SAS_SUBSCR_TYP_STG1723001
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(1723001)ODS_Project.LOAD_SAS_SUBSCRIPTION_TYPE_INT')


&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Create index on PK */

 
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */
-- create index 	RAX_APP_USER.I$_SAS_SUBSCR_TYP_STG1723001
-- on	RAX_APP_USER.I$_SAS_SUBSCR_TYP_STG1723001 (SUBSCRIPTION_TYPE_ID)

BEGIN
  EXECUTE IMMEDIATE 'create index RAX_APP_USER.I$_SAS_SUBSCR_TYP_STG1723001
on   RAX_APP_USER.I$_SAS_SUBSCR_TYP_STG1723001 (SUBSCRIPTION_TYPE_ID)';
EXCEPTION
  WHEN OTHERS THEN
   -- Handle the case where the identifier is too long (ORA-00972)
   IF SQLCODE = -972 or  SQLCODE = -1408 or SQLCODE = -955  THEN
     DBMS_OUTPUT.PUT_LINE('Identifier is too long. Skipping creation of index.');
   ELSE
     RAISE;
   END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* insert PK errors */

DECLARE
               CheckTable                             VarChar2(60);
               TargetTable                            VarChar2(60);
               VariableCheckTable                     VarChar2(60);

BEGIN
               SELECT 'RAX_APP_USER.I$_SAS_SUBSCR_TYP_STG' INTO CheckTable FROM DUAL;
               SELECT 'ODS_STAGE.SAS_SUBSCRIPTION_TYPE_STG' INTO TargetTable FROM DUAL;

IF CheckTable = TargetTable THEN
   VariableCheckTable := CheckTable; 
ELSE
   VariableCheckTable := CheckTable || '1723001';
END IF;

execute immediate '
insert into RAX_APP_USER.E$_SAS_SUBSCR_TYP_STG1723001
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
	SUBSCRIPTION_TYPE_ID,
	SUBSCRIPTION_TYPE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	''F'', 
	''ODI-15064: The primary key SUBSCRIPTION_TYPE_ID_PK is not unique.'',
	''(1723001)ODS_Project.LOAD_SAS_SUBSCRIPTION_TYPE_INT'',
	sysdate,
	''SUBSCRIPTION_TYPE_ID_PK'',
	''PK'',	
	SAS_SUBSCR_TYP_STG.SUBSCRIPTION_TYPE_ID,
	SAS_SUBSCR_TYP_STG.SUBSCRIPTION_TYPE,
	SAS_SUBSCR_TYP_STG.ODS_CREATE_DATE,
	SAS_SUBSCR_TYP_STG.ODS_MODIFY_DATE
from	'
 || VariableCheckTable || 
' SAS_SUBSCR_TYP_STG 
where	exists  (
		select	SUB1.SUBSCRIPTION_TYPE_ID
		from 	' 
|| VariableCheckTable ||
'  SUB1
		where 	SUB1.SUBSCRIPTION_TYPE_ID=SAS_SUBSCR_TYP_STG.SUBSCRIPTION_TYPE_ID
		group by 	SUB1.SUBSCRIPTION_TYPE_ID
		having 	count(1) > 1
		)
';

END;


&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_SAS_SUBSCR_TYP_STG1723001
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
	SUBSCRIPTION_TYPE_ID,
	SUBSCRIPTION_TYPE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column SUBSCRIPTION_TYPE_ID cannot be null.',
	sysdate,
	'(1723001)ODS_Project.LOAD_SAS_SUBSCRIPTION_TYPE_INT',
	'SUBSCRIPTION_TYPE_ID',
	'NN',	
	SUBSCRIPTION_TYPE_ID,
	SUBSCRIPTION_TYPE,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_SAS_SUBSCR_TYP_STG1723001
where	SUBSCRIPTION_TYPE_ID is null



&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* create index on error table */

 
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */
-- create index 	RAX_APP_USER.E$_SAS_SUBSCR_TYP_STG1723001
-- on	RAX_APP_USER.E$_SAS_SUBSCR_TYP_STG1723001 (ODI_ROW_ID)

BEGIN
  EXECUTE IMMEDIATE 'create index RAX_APP_USER.E$_SAS_SUBSCR_TYP_STG1723001
on   RAX_APP_USER.E$_SAS_SUBSCR_TYP_STG1723001 (ODI_ROW_ID)';
EXCEPTION
  WHEN OTHERS THEN
   -- Handle the case where the identifier is too long (ORA-00972)
   IF SQLCODE = -972 or  SQLCODE = -1408 or SQLCODE = -955  THEN
     DBMS_OUTPUT.PUT_LINE('Identifier is too long. Skipping creation of index.');
   ELSE
     RAISE;
   END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* delete errors from controlled table */

delete from	RAX_APP_USER.I$_SAS_SUBSCR_TYP_STG1723001  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_SAS_SUBSCR_TYP_STG1723001 E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)


&


/*-----------------------------------------------*/
/* TASK No. 24 */
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
	'SAS_SUBSCR_TYP_STG',
	'ODS_STAGE.SAS_SUBSCRIPTION_TYPE_STG1723001',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_SAS_SUBSCR_TYP_STG1723001 E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(1723001)ODS_Project.LOAD_SAS_SUBSCRIPTION_TYPE_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE


&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* Merge Rows */

merge into	ODS_STAGE.SAS_SUBSCRIPTION_TYPE_STG T
using	RAX_APP_USER.I$_SAS_SUBSCR_TYP_STG1723001 S
on	(
		T.SUBSCRIPTION_TYPE_ID=S.SUBSCRIPTION_TYPE_ID
	)
when matched
then update set
	T.SUBSCRIPTION_TYPE	= S.SUBSCRIPTION_TYPE
	, T.ODS_MODIFY_DATE	= SYSDATE
when not matched
then insert
	(
	T.SUBSCRIPTION_TYPE_ID,
	T.SUBSCRIPTION_TYPE
	,  T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.SUBSCRIPTION_TYPE_ID,
	S.SUBSCRIPTION_TYPE
	,  SYSDATE,
	SYSDATE
	)

&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 27 */
/* Drop flow table */

-- drop table RAX_APP_USER.I$_SAS_SUBSCR_TYP_STG1723001

BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_SAS_SUBSCR_TYP_STG1723001';
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

-- drop table RAX_APP_USER.C$_0SAS_SUBSCR_TYP_STG purge

BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0SAS_SUBSCR_TYP_STG purge';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;


&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* MERGE INTO ODS_STAGE.SAS_USER_SUBSCRIPTION_TYPE_XR */

-- SAS_USER_SUBSCRIPTION_TYPE_XR
MERGE INTO ODS_STAGE.SAS_USER_SUBSCRIPTION_TYPE_XR  d
USING (
select * from
    (  Select
         XR.USER_SUBSCRIPTION_TYPE_OID USER_SUBSCRIPTION_TYPE_OID
        ,STG.SUBSCRIPTION_TYPE_ID as SK_SUBSCRIPTION_TYPE_ID
        ,sysdate as ODS_CREATE_DATE
        ,sysdate as ODS_MODIFY_DATE
    FROM 
        ODS_STAGE.SAS_SUBSCRIPTION_TYPE_STG  stg
       ,ODS_STAGE.SAS_USER_SUBSCRIPTION_TYPE_XR xr
    WHERE (1=1)
        and stg.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
        and STG.SUBSCRIPTION_TYPE_ID=XR. SK_SUBSCRIPTION_TYPE_ID(+)
     ) s
) s 
ON
  (s.SK_SUBSCRIPTION_TYPE_ID=d.SK_SUBSCRIPTION_TYPE_ID)
--WHEN MATCHED THEN UPDATE SET
--  d.USER_SUBSCRIPTION_TYPE_OID = s.USER_SUBSCRIPTION_TYPE_OID
--  ,d.ODS_MODIFY_DATE = s.ODS_MODIFY_DATE
WHEN NOT MATCHED THEN INSERT 
(
  USER_SUBSCRIPTION_TYPE_OID 
 ,SK_SUBSCRIPTION_TYPE_ID
 ,ODS_CREATE_DATE
 ,ODS_MODIFY_DATE
 )
VALUES (
  ODS_STAGE.USER_SUBSCRIPTION_TYPE_OID_SEQ.nextval
  ,s.SK_SUBSCRIPTION_TYPE_ID
  ,s.ODS_CREATE_DATE
  ,s.ODS_MODIFY_DATE
  )


&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* MERGE INTO ODS_OWN.USER_SUBSCRIPTION_TYPE */

MERGE INTO ODS_OWN.USER_SUBSCRIPTION_TYPE d
USING (
select * from (
      Select
         XR.USER_SUBSCRIPTION_TYPE_OID as USER_SUBSCRIPTION_TYPE_OID
        ,STG.SUBSCRIPTION_TYPE_ID as USER_SUBSCRIPTION_TYPE_ID
        ,STG.SUBSCRIPTION_TYPE as SUBSCRIPTION_TYPE
        ,SS.SOURCE_SYSTEM_OID as SOURCE_SYSTEM_OID
        ,sysdate as ODS_CREATE_DATE
        ,sysdate as ODS_MODIFY_DATE
-- select *
    from
         ODS_STAGE.SAS_SUBSCRIPTION_TYPE_STG stg
        ,ODS_STAGE.SAS_USER_SUBSCRIPTION_TYPE_XR xr
        ,ODS_OWN.SOURCE_SYSTEM SS
    where (1=1)
        and stg.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
        and STG.SUBSCRIPTION_TYPE_ID=XR.SK_SUBSCRIPTION_TYPE_ID(+)
        and SS.SOURCE_SYSTEM_SHORT_NAME='SAS'
     ) s
) s 
ON
  (d.USER_SUBSCRIPTION_TYPE_OID = s.USER_SUBSCRIPTION_TYPE_OID)
WHEN MATCHED THEN UPDATE SET
   d.USER_SUBSCRIPTION_TYPE_ID = s.USER_SUBSCRIPTION_TYPE_ID
  ,d.SUBSCRIPTION_TYPE = s.SUBSCRIPTION_TYPE
  ,d.SOURCE_SYSTEM_OID = s.SOURCE_SYSTEM_OID
  ,d.ODS_MODIFY_DATE = s.ODS_MODIFY_DATE
where not (
    ((d.USER_SUBSCRIPTION_TYPE_ID = s.USER_SUBSCRIPTION_TYPE_ID) or (d.USER_SUBSCRIPTION_TYPE_ID IS NULL and s.USER_SUBSCRIPTION_TYPE_ID IS NULL)) 
    and ((d.SUBSCRIPTION_TYPE = s.SUBSCRIPTION_TYPE) or (d.SUBSCRIPTION_TYPE IS NULL and s.SUBSCRIPTION_TYPE IS NULL)))
WHEN NOT MATCHED THEN INSERT 
(
     USER_SUBSCRIPTION_TYPE_OID
    ,USER_SUBSCRIPTION_TYPE_ID
    ,SUBSCRIPTION_TYPE
    ,SOURCE_SYSTEM_OID
    ,ODS_CREATE_DATE
    ,ODS_MODIFY_DATE
    )
VALUES (
     s.USER_SUBSCRIPTION_TYPE_OID
    ,s.USER_SUBSCRIPTION_TYPE_ID
    ,s.SUBSCRIPTION_TYPE
    ,s.SOURCE_SYSTEM_OID
    ,s.ODS_CREATE_DATE
    ,s.ODS_MODIFY_DATE
    )


&


/*-----------------------------------------------*/
/* TASK No. 30 */
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
/* TASK No. 31 */
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
,'LOAD_SAS_SUBSCRIPTION_TYPE_PKG'
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
'LOAD_SAS_SUBSCRIPTION_TYPE_PKG',
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


&


/*-----------------------------------------------*/
