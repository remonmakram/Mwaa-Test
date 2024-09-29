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

-- drop table RAX_APP_USER.C$_0STG_KIT_ITEM 

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 5 */
-- /* Create work table */

-- create table RAX_APP_USER.C$_0STG_KIT_ITEM
-- (
-- 	C1_MODIFYUSERID	VARCHAR2(40) NULL,
-- 	C2_ITEM_KEY	CHAR(24) NULL,
-- 	C3_CREATEPROGID	VARCHAR2(40) NULL,
-- 	C4_KIT_ITEM_KEY	CHAR(24) NULL,
-- 	C5_COMPONENT_ITEM_KEY	CHAR(24) NULL,
-- 	C6_MODIFYTS	DATE NULL,
-- 	C7_KIT_QUANTITY	NUMBER(14,4) NULL,
-- 	C8_MODIFYPROGID	VARCHAR2(40) NULL,
-- 	C9_CREATETS	DATE NULL,
-- 	C10_LOCKID	NUMBER(5) NULL,
-- 	C11_CREATEUSERID	VARCHAR2(40) NULL
-- )
-- NOLOGGING

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 6 */
-- /* Load data */

-- /* SOURCE CODE */
-- select	
-- 	KI.MODIFYUSERID	   C1_MODIFYUSERID,
-- 	KI.ITEM_KEY	   C2_ITEM_KEY,
-- 	KI.CREATEPROGID	   C3_CREATEPROGID,
-- 	KI.KIT_ITEM_KEY	   C4_KIT_ITEM_KEY,
-- 	KI.COMPONENT_ITEM_KEY	   C5_COMPONENT_ITEM_KEY,
-- 	KI.MODIFYTS	   C6_MODIFYTS,
-- 	KI.KIT_QUANTITY	   C7_KIT_QUANTITY,
-- 	KI.MODIFYPROGID	   C8_MODIFYPROGID,
-- 	KI.CREATETS	   C9_CREATETS,
-- 	KI.LOCKID	   C10_LOCKID,
-- 	KI.CREATEUSERID	   C11_CREATEUSERID
-- from	OMS3_OWN.YFS_KIT_ITEM   KI
-- where	(1=1)
-- And (KI.MODIFYTS >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap)





-- &

-- /* TARGET CODE */
-- insert into RAX_APP_USER.C$_0STG_KIT_ITEM
-- (
-- 	C1_MODIFYUSERID,
-- 	C2_ITEM_KEY,
-- 	C3_CREATEPROGID,
-- 	C4_KIT_ITEM_KEY,
-- 	C5_COMPONENT_ITEM_KEY,
-- 	C6_MODIFYTS,
-- 	C7_KIT_QUANTITY,
-- 	C8_MODIFYPROGID,
-- 	C9_CREATETS,
-- 	C10_LOCKID,
-- 	C11_CREATEUSERID
-- )
-- values
-- (
-- 	:C1_MODIFYUSERID,
-- 	:C2_ITEM_KEY,
-- 	:C3_CREATEPROGID,
-- 	:C4_KIT_ITEM_KEY,
-- 	:C5_COMPONENT_ITEM_KEY,
-- 	:C6_MODIFYTS,
-- 	:C7_KIT_QUANTITY,
-- 	:C8_MODIFYPROGID,
-- 	:C9_CREATETS,
-- 	:C10_LOCKID,
-- 	:C11_CREATEUSERID
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0STG_KIT_ITEM',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;




&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Create target table  */

BEGIN  
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.STG_KIT_ITEM
						(
							MODIFYUSERID	VARCHAR2(40) NULL,
							ITEM_KEY	CHAR(24) NULL,
							CREATEPROGID	VARCHAR2(40) NULL,
							KIT_ITEM_KEY	CHAR(24) NULL,
							COMPONENT_ITEM_KEY	CHAR(24) NULL,
							MODIFYTS	DATE NULL,
							KIT_QUANTITY	NUMBER(14,4) NULL,
							MODIFYPROGID	VARCHAR2(40) NULL,
							CREATETS	DATE NULL,
							LOCKID	NUMBER(5) NULL,
							CREATEUSERID	VARCHAR2(40) NULL
						)';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -955 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Truncate target table */

truncate table RAX_APP_USER.STG_KIT_ITEM


&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Insert new rows */

 
insert into	RAX_APP_USER.STG_KIT_ITEM 
( 
	MODIFYUSERID,
	ITEM_KEY,
	CREATEPROGID,
	KIT_ITEM_KEY,
	COMPONENT_ITEM_KEY,
	MODIFYTS,
	KIT_QUANTITY,
	MODIFYPROGID,
	CREATETS,
	LOCKID,
	CREATEUSERID 
	 
) 

select
    MODIFYUSERID,
	ITEM_KEY,
	CREATEPROGID,
	KIT_ITEM_KEY,
	COMPONENT_ITEM_KEY,
	MODIFYTS,
	KIT_QUANTITY,
	MODIFYPROGID,
	CREATETS,
	LOCKID,
	CREATEUSERID   
   
FROM (	


select 	
	C1_MODIFYUSERID MODIFYUSERID,
	C2_ITEM_KEY ITEM_KEY,
	C3_CREATEPROGID CREATEPROGID,
	C4_KIT_ITEM_KEY KIT_ITEM_KEY,
	C5_COMPONENT_ITEM_KEY COMPONENT_ITEM_KEY,
	C6_MODIFYTS MODIFYTS,
	C7_KIT_QUANTITY KIT_QUANTITY,
	C8_MODIFYPROGID MODIFYPROGID,
	C9_CREATETS CREATETS,
	C10_LOCKID LOCKID,
	C11_CREATEUSERID CREATEUSERID 
from	RAX_APP_USER.C$_0STG_KIT_ITEM
where		(1=1)	






)    ODI_GET_FROM




&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Commit transaction */

/* commit */


/*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */

drop table RAX_APP_USER.C$_0STG_KIT_ITEM 

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 13 */




/*-----------------------------------------------*/
/* TASK No. 14 */
/* Drop flow table */

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_OMS_KIT_ITEM_XR211001 ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_OMS_KIT_ITEM_XR211001
(
	KIT_ITEM_OID	NUMBER(22) NULL,
	KIT_ITEM_KEY	VARCHAR2(24) NULL,
	ITEM_KEY	VARCHAR2(24) NULL,
	COMPONENT_ITEM_KEY	VARCHAR2(24) NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_OMS_KIT_ITEM_XR211001
(
	KIT_ITEM_KEY,
	ITEM_KEY,
	COMPONENT_ITEM_KEY,
	IND_UPDATE
)
select 
KIT_ITEM_KEY,
	ITEM_KEY,
	COMPONENT_ITEM_KEY,
	IND_UPDATE
 from (


select 	 
	DISTINCT
	TRIM(KI.KIT_ITEM_KEY) KIT_ITEM_KEY,
	TRIM(KI.ITEM_KEY) ITEM_KEY,
	TRIM(KI.COMPONENT_ITEM_KEY) COMPONENT_ITEM_KEY,

	'I' IND_UPDATE

from	RAX_APP_USER.STG_KIT_ITEM   KI, ODS_STAGE.OMS_KIT_ITEM_XR   OMS_KIT_ITEM_XR
where	(1=1)
 And (TRIM(KI.KIT_ITEM_KEY)=OMS_KIT_ITEM_XR.KIT_ITEM_KEY (+)
AND OMS_KIT_ITEM_XR.KIT_ITEM_KEY IS NULL)





) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.OMS_KIT_ITEM_XR T
	where	T.KIT_ITEM_KEY	= S.KIT_ITEM_KEY 
		 and ((T.ITEM_KEY = S.ITEM_KEY) or (T.ITEM_KEY IS NULL and S.ITEM_KEY IS NULL)) and
		((T.COMPONENT_ITEM_KEY = S.COMPONENT_ITEM_KEY) or (T.COMPONENT_ITEM_KEY IS NULL and S.COMPONENT_ITEM_KEY IS NULL))
        )

  
  

  



&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_OMS_KIT_ITEM_XR211001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_OMS_KIT_ITEM_XR_IDX211001
on		RAX_APP_USER.I$_OMS_KIT_ITEM_XR211001 (KIT_ITEM_KEY)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Merge Rows */

merge into	ODS_STAGE.OMS_KIT_ITEM_XR T
using	RAX_APP_USER.I$_OMS_KIT_ITEM_XR211001 S
on	(
		T.KIT_ITEM_KEY=S.KIT_ITEM_KEY
	)
when matched
then update set
	T.ITEM_KEY	= S.ITEM_KEY,
	T.COMPONENT_ITEM_KEY	= S.COMPONENT_ITEM_KEY
	
when not matched
then insert
	(
	T.KIT_ITEM_KEY,
	T.ITEM_KEY,
	T.COMPONENT_ITEM_KEY
	,   T.KIT_ITEM_OID
	)
values
	(
	S.KIT_ITEM_KEY,
	S.ITEM_KEY,
	S.COMPONENT_ITEM_KEY
	,   ODS_STAGE.KIT_ITEM_OID_SEQ.nextval
	)

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 21 */
/* Drop flow table */

drop table RAX_APP_USER.I$_OMS_KIT_ITEM_XR211001 

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 22 */




/*-----------------------------------------------*/
/* TASK No. 23 */
/* Drop flow table */

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_KIT_ITEM212001';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_KIT_ITEM212001
(
	KIT_ITEM_OID	NUMBER NULL,
	ITEM_OID	NUMBER NULL,
	COMPONENT_ITEM_OID	NUMBER NULL,
	KIT_QUANTITY	NUMBER NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	SOURCE_SYSTEM_OID	NUMBER NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_KIT_ITEM212001
(
	KIT_ITEM_OID,
	ITEM_OID,
	COMPONENT_ITEM_OID,
	KIT_QUANTITY,
	SOURCE_SYSTEM_OID,
	IND_UPDATE
)
select 
KIT_ITEM_OID,
	ITEM_OID,
	COMPONENT_ITEM_OID,
	KIT_QUANTITY,
	SOURCE_SYSTEM_OID,
	IND_UPDATE
 from (


select 	 
	
	OMS_KIT_ITEM_XR.KIT_ITEM_OID KIT_ITEM_OID,
	NVL(ITEM_LKP.ITEM_OID, -1) ITEM_OID,
	NVL(COMP_ITEM_LKP.ITEM_OID, -1) COMPONENT_ITEM_OID,
	KI.KIT_QUANTITY KIT_QUANTITY,
	SOURCE_SYSTEM.SOURCE_SYSTEM_OID SOURCE_SYSTEM_OID,

	'I' IND_UPDATE

from	RAX_APP_USER.STG_KIT_ITEM   KI, ODS_OWN.SOURCE_SYSTEM   SOURCE_SYSTEM, ODS_STAGE.OMS_KIT_ITEM_XR   OMS_KIT_ITEM_XR, ODS_STAGE.OMS_ITEM_XR   ITEM_LKP, ODS_STAGE.OMS_ITEM_XR   COMP_ITEM_LKP
where	(1=1)
 And (TRIM(KI.KIT_ITEM_KEY)=OMS_KIT_ITEM_XR.KIT_ITEM_KEY(+))
AND (TRIM(KI.ITEM_KEY)=ITEM_LKP.ITEM_KEY(+))
AND (TRIM(KI.COMPONENT_ITEM_KEY)=COMP_ITEM_LKP.ITEM_KEY(+))
And (SOURCE_SYSTEM.SOURCE_SYSTEM_SHORT_NAME='OMS')




) S
where NOT EXISTS 
	( select 1 from ODS_OWN.KIT_ITEM T
	where	T.KIT_ITEM_OID	= S.KIT_ITEM_OID 
		 and ((T.ITEM_OID = S.ITEM_OID) or (T.ITEM_OID IS NULL and S.ITEM_OID IS NULL)) and
		((T.COMPONENT_ITEM_OID = S.COMPONENT_ITEM_OID) or (T.COMPONENT_ITEM_OID IS NULL and S.COMPONENT_ITEM_OID IS NULL)) and
		((T.KIT_QUANTITY = S.KIT_QUANTITY) or (T.KIT_QUANTITY IS NULL and S.KIT_QUANTITY IS NULL)) and
		((T.SOURCE_SYSTEM_OID = S.SOURCE_SYSTEM_OID) or (T.SOURCE_SYSTEM_OID IS NULL and S.SOURCE_SYSTEM_OID IS NULL))
        )

  
  

  



&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_KIT_ITEM212001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_KIT_ITEM_IDX212001
on		RAX_APP_USER.I$_KIT_ITEM212001 (KIT_ITEM_OID)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* create check table */


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
	

&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* delete previous check sum */

delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS_OWN'
and	ORIGIN 		= '(212001)ODS_Project.LOAD_KIT_ITEM_INT'
and	ERR_TYPE 		= 'F'


&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* create error table */


BEGIN  
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.E$_KIT_ITEM212001
						(
							ODI_ROW_ID 		UROWID,
							ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
							ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
							ODI_CHECK_DATE	DATE NULL, 
							KIT_ITEM_OID	NUMBER NULL,
							ITEM_OID	NUMBER NULL,
							COMPONENT_ITEM_OID	NUMBER NULL,
							KIT_QUANTITY	NUMBER NULL,
							ODS_CREATE_DATE	DATE NULL,
							ODS_MODIFY_DATE	DATE NULL,
							SOURCE_SYSTEM_OID	NUMBER NULL,
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



&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* delete previous errors */

delete from 	RAX_APP_USER.E$_KIT_ITEM212001
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(212001)ODS_Project.LOAD_KIT_ITEM_INT')


&


/*-----------------------------------------------*/
/* TASK No. 32 */
/* Create index on PK */

 
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */
BEGIN  
   EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.I$_KIT_ITEM212001 on RAX_APP_USER.I$_KIT_ITEM212001 (KIT_ITEM_OID)';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -955 and SQLCODE != -01408 THEN  
         RAISE;  
      END IF;  
END;


&


/*-----------------------------------------------*/
/* TASK No. 33 */
/* insert PK errors */

DECLARE
               CheckTable                             VarChar2(60);
               TargetTable                            VarChar2(60);
               VariableCheckTable                     VarChar2(60);

BEGIN
               SELECT 'RAX_APP_USER.I$_KIT_ITEM' INTO CheckTable FROM DUAL;
               SELECT 'ODS_OWN.KIT_ITEM' INTO TargetTable FROM DUAL;

IF CheckTable = TargetTable THEN
   VariableCheckTable := CheckTable; 
ELSE
   VariableCheckTable := CheckTable || '212001';
END IF;

execute immediate '
insert into RAX_APP_USER.E$_KIT_ITEM212001
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
	KIT_ITEM_OID,
	ITEM_OID,
	COMPONENT_ITEM_OID,
	KIT_QUANTITY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	''F'', 
	''ODI-15064: The primary key KIT_ITEM_PK is not unique.'',
	''(212001)ODS_Project.LOAD_KIT_ITEM_INT'',
	sysdate,
	''KIT_ITEM_PK'',
	''PK'',	
	KIT_ITEM.KIT_ITEM_OID,
	KIT_ITEM.ITEM_OID,
	KIT_ITEM.COMPONENT_ITEM_OID,
	KIT_ITEM.KIT_QUANTITY,
	KIT_ITEM.ODS_CREATE_DATE,
	KIT_ITEM.ODS_MODIFY_DATE,
	KIT_ITEM.SOURCE_SYSTEM_OID
from	'
 || VariableCheckTable || 
' KIT_ITEM 
where	exists  (
		select	SUB1.KIT_ITEM_OID
		from 	' 
|| VariableCheckTable ||
'  SUB1
		where 	SUB1.KIT_ITEM_OID=KIT_ITEM.KIT_ITEM_OID
		group by 	SUB1.KIT_ITEM_OID
		having 	count(1) > 1
		)
';

END;


&


/*-----------------------------------------------*/
/* TASK No. 34 */
/* insert FK errors */

DECLARE
               CheckTable                             VarChar2(60);
               TargetTable                            VarChar2(60);
               VariableCheckTable                VarChar2(60);

BEGIN
               SELECT 'RAX_APP_USER.I$_KIT_ITEM' INTO CheckTable FROM DUAL;
               SELECT 'ODS_OWN.KIT_ITEM' INTO TargetTable FROM DUAL;

IF CheckTable = TargetTable THEN
   VariableCheckTable := CheckTable; 
ELSE
   VariableCheckTable := CheckTable || '212001';
END IF;

execute immediate '
insert into RAX_APP_USER.E$_KIT_ITEM212001
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
	KIT_ITEM_OID,
	ITEM_OID,
	COMPONENT_ITEM_OID,
	KIT_QUANTITY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	''F'', 
	''ODI-15065: Join error (KIT_ITEM_COMP_ITEM_OID_FK) between the table KIT_ITEM and the table ITEM.'',
	sysdate,
	''(212001)ODS_Project.LOAD_KIT_ITEM_INT'',
	''KIT_ITEM_COMP_ITEM_OID_FK'',
	''FK'',	
	KIT_ITEM_OID,
	ITEM_OID,
	COMPONENT_ITEM_OID,
	KIT_QUANTITY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID

from	'
 || VariableCheckTable || 
' KIT_ITEM 
where 	(
		KIT_ITEM.COMPONENT_ITEM_OID 
	) not in 	(
		select 	ITEM_OID
		from 	ODS_OWN.ITEM
		)
and	(
		KIT_ITEM.COMPONENT_ITEM_OID is not null 
	)

';

END;

/*  Checked Datastore =RAX_APP_USER.I$_KIT_ITEM  */
/*  Integration Datastore =RAX_APP_USER.I$_KIT_ITEM   */
/*  Target Datastore =ODS_OWN.KIT_ITEM */


&


/*-----------------------------------------------*/
/* TASK No. 35 */
/* insert FK errors */

DECLARE
               CheckTable                             VarChar2(60);
               TargetTable                            VarChar2(60);
               VariableCheckTable                VarChar2(60);

BEGIN
               SELECT 'RAX_APP_USER.I$_KIT_ITEM' INTO CheckTable FROM DUAL;
               SELECT 'ODS_OWN.KIT_ITEM' INTO TargetTable FROM DUAL;

IF CheckTable = TargetTable THEN
   VariableCheckTable := CheckTable; 
ELSE
   VariableCheckTable := CheckTable || '212001';
END IF;

execute immediate '
insert into RAX_APP_USER.E$_KIT_ITEM212001
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
	KIT_ITEM_OID,
	ITEM_OID,
	COMPONENT_ITEM_OID,
	KIT_QUANTITY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	''F'', 
	''ODI-15065: Join error (KIT_ITEM_ITEM_OID_FK) between the table KIT_ITEM and the table ITEM.'',
	sysdate,
	''(212001)ODS_Project.LOAD_KIT_ITEM_INT'',
	''KIT_ITEM_ITEM_OID_FK'',
	''FK'',	
	KIT_ITEM_OID,
	ITEM_OID,
	COMPONENT_ITEM_OID,
	KIT_QUANTITY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID

from	'
 || VariableCheckTable || 
' KIT_ITEM 
where 	(
		KIT_ITEM.ITEM_OID 
	) not in 	(
		select 	ITEM_OID
		from 	ODS_OWN.ITEM
		)
and	(
		KIT_ITEM.ITEM_OID is not null 
	)

';

END;

/*  Checked Datastore =RAX_APP_USER.I$_KIT_ITEM  */
/*  Integration Datastore =RAX_APP_USER.I$_KIT_ITEM   */
/*  Target Datastore =ODS_OWN.KIT_ITEM */


&


/*-----------------------------------------------*/
/* TASK No. 36 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_KIT_ITEM212001
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
	KIT_ITEM_OID,
	ITEM_OID,
	COMPONENT_ITEM_OID,
	KIT_QUANTITY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column KIT_ITEM_OID cannot be null.',
	sysdate,
	'(212001)ODS_Project.LOAD_KIT_ITEM_INT',
	'KIT_ITEM_OID',
	'NN',	
	KIT_ITEM_OID,
	ITEM_OID,
	COMPONENT_ITEM_OID,
	KIT_QUANTITY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID
from	RAX_APP_USER.I$_KIT_ITEM212001
where	KIT_ITEM_OID is null



&


/*-----------------------------------------------*/
/* TASK No. 37 */
/* create index on error table */

 
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */
BEGIN  
   EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_KIT_ITEM212001 on RAX_APP_USER.E$_KIT_ITEM212001 (ODI_ROW_ID)';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -955 and SQLCODE != -01408 THEN  
         RAISE;  
      END IF;  
END;


&


/*-----------------------------------------------*/
/* TASK No. 38 */
/* delete errors from controlled table */

delete from	RAX_APP_USER.I$_KIT_ITEM212001  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_KIT_ITEM212001 E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)


&


/*-----------------------------------------------*/
/* TASK No. 39 */
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
	'KIT_ITEM',
	'ODS_OWN.KIT_ITEM212001',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_KIT_ITEM212001 E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(212001)ODS_Project.LOAD_KIT_ITEM_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE


&


/*-----------------------------------------------*/
/* TASK No. 40 */
/* Merge Rows */

merge into	ODS_OWN.KIT_ITEM T
using	RAX_APP_USER.I$_KIT_ITEM212001 S
on	(
		T.KIT_ITEM_OID=S.KIT_ITEM_OID
	)
when matched
then update set
	T.ITEM_OID	= S.ITEM_OID,
	T.COMPONENT_ITEM_OID	= S.COMPONENT_ITEM_OID,
	T.KIT_QUANTITY	= S.KIT_QUANTITY,
	T.SOURCE_SYSTEM_OID	= S.SOURCE_SYSTEM_OID
	,    T.ODS_MODIFY_DATE	= SYSDATE
when not matched
then insert
	(
	T.KIT_ITEM_OID,
	T.ITEM_OID,
	T.COMPONENT_ITEM_OID,
	T.KIT_QUANTITY,
	T.SOURCE_SYSTEM_OID
	,     T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.KIT_ITEM_OID,
	S.ITEM_OID,
	S.COMPONENT_ITEM_OID,
	S.KIT_QUANTITY,
	S.SOURCE_SYSTEM_OID
	,     SYSDATE,
	SYSDATE
	)

&


/*-----------------------------------------------*/
/* TASK No. 41 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 42 */
/* Drop flow table */

drop table RAX_APP_USER.I$_KIT_ITEM212001 

&


/*-----------------------------------------------*/
/* TASK No. 43 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

&


/*-----------------------------------------------*/
/* TASK No. 44 */
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
CONTEXT_NAME              
)
values (
:v_cdc_load_table_name,
:v_sess_no,
'LOAD_KIT_ITEM_PKG',
'005',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          ),
:v_cdc_overlap,
SYSDATE,
 :v_env)

&


/*-----------------------------------------------*/
/* TASK No. 45 */
/* DELETE KIT ITEM FROM STAGE TABLE */

DELETE FROM ODS_STAGE.OMS3_KIT_ITEM_STG

&
