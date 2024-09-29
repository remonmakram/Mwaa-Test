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

-- OdiStartScen "-SCEN_NAME=FIX_E$_PROMOTION" "-SCEN_VERSION=-1" "-LOG_LEVEL=5" "-SYNC_MODE=1"
BEGIN  
   EXECUTE IMMEDIATE 'merge into E$_PROMOTION1959001 c 
						using (
						select pxr.ORDER_HEADER_oid,ODI_PK --, x.*,d.*
						from 
						E$_PROMOTION28300 e, ods_stage.OMS_PROMOTION_XR sxr, ods_stage.OMS_ORDER_HEADER_XR pxr
						where (1=1) 
						and E.PROMOTION_OID = SXR.PROMOTION_OID 
						and trim(SXR.ORDER_HEADER_KEY) = PXR.ORDER_HEADER_KEY
						and pxr.ORDER_HEADER_oid <> nvl(e.ORDER_HEADER_oid,-1)
						) s on (c.ODI_PK = s.ODI_PK)
						when matched then update
						set 
						c.ORDER_HEADER_oid = s.ORDER_HEADER_oid';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


-- /*-----------------------------------------------*/
-- /* TASK No. 5 */
-- /* Drop work table */

-- drop table RAX_APP_USER.C$_0STG_PROMOTION 

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 6 */
-- /* Create work table */

-- create table RAX_APP_USER.C$_0STG_PROMOTION
-- (
-- 	C1_DESCRIPTION	VARCHAR2(100) NULL,
-- 	C2_PROMOTION_ID	VARCHAR2(100) NULL,
-- 	C3_ORDER_HEADER_KEY	VARCHAR2(24) NULL,
-- 	C4_PROMOTION_TYPE	VARCHAR2(100) NULL,
-- 	C5_DENIAL_REASON	VARCHAR2(100) NULL,
-- 	C6_MODIFYTS	DATE NULL,
-- 	C7_MODIFYUSERID	VARCHAR2(40) NULL,
-- 	C8_PROMOTION_APPLIED	CHAR(1) NULL,
-- 	C9_CREATETS	DATE NULL,
-- 	C10_CREATEUSERID	VARCHAR2(40) NULL,
-- 	C11_MODIFYPROGID	VARCHAR2(40) NULL,
-- 	C12_PROMOTION_KEY	VARCHAR2(24) NULL,
-- 	C13_CREATEPROGID	VARCHAR2(40) NULL,
-- 	C14_LOCKID	NUMBER(5) NULL
-- )
-- NOLOGGING

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 7 */
-- /* Load data */

-- /* SOURCE CODE */
-- select	
-- 	PROMO.DESCRIPTION	   C1_DESCRIPTION,
-- 	PROMO.PROMOTION_ID	   C2_PROMOTION_ID,
-- 	trim(PROMO.ORDER_HEADER_KEY)	   C3_ORDER_HEADER_KEY,
-- 	PROMO.PROMOTION_TYPE	   C4_PROMOTION_TYPE,
-- 	PROMO.DENIAL_REASON	   C5_DENIAL_REASON,
-- 	PROMO.MODIFYTS	   C6_MODIFYTS,
-- 	PROMO.MODIFYUSERID	   C7_MODIFYUSERID,
-- 	PROMO.PROMOTION_APPLIED	   C8_PROMOTION_APPLIED,
-- 	PROMO.CREATETS	   C9_CREATETS,
-- 	PROMO.CREATEUSERID	   C10_CREATEUSERID,
-- 	PROMO.MODIFYPROGID	   C11_MODIFYPROGID,
-- 	trim(PROMO.PROMOTION_KEY)	   C12_PROMOTION_KEY,
-- 	PROMO.CREATEPROGID	   C13_CREATEPROGID,
-- 	PROMO.LOCKID	   C14_LOCKID
-- from	OMS3_OWN.YFS_PROMOTION   PROMO
-- where	(1=1)
-- And (PROMO.MODIFYTS >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap)





-- &

-- /* TARGET CODE */
-- insert into RAX_APP_USER.C$_0STG_PROMOTION
-- (
-- 	C1_DESCRIPTION,
-- 	C2_PROMOTION_ID,
-- 	C3_ORDER_HEADER_KEY,
-- 	C4_PROMOTION_TYPE,
-- 	C5_DENIAL_REASON,
-- 	C6_MODIFYTS,
-- 	C7_MODIFYUSERID,
-- 	C8_PROMOTION_APPLIED,
-- 	C9_CREATETS,
-- 	C10_CREATEUSERID,
-- 	C11_MODIFYPROGID,
-- 	C12_PROMOTION_KEY,
-- 	C13_CREATEPROGID,
-- 	C14_LOCKID
-- )
-- values
-- (
-- 	:C1_DESCRIPTION,
-- 	:C2_PROMOTION_ID,
-- 	:C3_ORDER_HEADER_KEY,
-- 	:C4_PROMOTION_TYPE,
-- 	:C5_DENIAL_REASON,
-- 	:C6_MODIFYTS,
-- 	:C7_MODIFYUSERID,
-- 	:C8_PROMOTION_APPLIED,
-- 	:C9_CREATETS,
-- 	:C10_CREATEUSERID,
-- 	:C11_MODIFYPROGID,
-- 	:C12_PROMOTION_KEY,
-- 	:C13_CREATEPROGID,
-- 	:C14_LOCKID
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0STG_PROMOTION',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;




&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Create target table  */

BEGIN  
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.STG_PROMOTION
						(
							DESCRIPTION	VARCHAR2(100) NULL,
							PROMOTION_ID	VARCHAR2(100) NULL,
							ORDER_HEADER_KEY	VARCHAR2(24) NULL,
							PROMOTION_TYPE	VARCHAR2(100) NULL,
							DENIAL_REASON	VARCHAR2(100) NULL,
							MODIFYTS	DATE NULL,
							MODIFYUSERID	VARCHAR2(40) NULL,
							PROMOTION_APPLIED	CHAR(1) NULL,
							CREATETS	DATE NULL,
							CREATEUSERID	VARCHAR2(40) NULL,
							MODIFYPROGID	VARCHAR2(40) NULL,
							PROMOTION_KEY	VARCHAR2(24) NULL,
							CREATEPROGID	VARCHAR2(40) NULL,
							LOCKID	NUMBER(5) NULL
						)';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -955 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Truncate target table */

truncate table RAX_APP_USER.STG_PROMOTION


&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert new rows */

 
insert into	RAX_APP_USER.STG_PROMOTION 
( 
	DESCRIPTION,
	PROMOTION_ID,
	ORDER_HEADER_KEY,
	PROMOTION_TYPE,
	DENIAL_REASON,
	MODIFYTS,
	MODIFYUSERID,
	PROMOTION_APPLIED,
	CREATETS,
	CREATEUSERID,
	MODIFYPROGID,
	PROMOTION_KEY,
	CREATEPROGID,
	LOCKID 
	 
) 

select
    DESCRIPTION,
	PROMOTION_ID,
	ORDER_HEADER_KEY,
	PROMOTION_TYPE,
	DENIAL_REASON,
	MODIFYTS,
	MODIFYUSERID,
	PROMOTION_APPLIED,
	CREATETS,
	CREATEUSERID,
	MODIFYPROGID,
	PROMOTION_KEY,
	CREATEPROGID,
	LOCKID   
   
FROM (	


select 	
	C1_DESCRIPTION DESCRIPTION,
	C2_PROMOTION_ID PROMOTION_ID,
	C3_ORDER_HEADER_KEY ORDER_HEADER_KEY,
	C4_PROMOTION_TYPE PROMOTION_TYPE,
	C5_DENIAL_REASON DENIAL_REASON,
	C6_MODIFYTS MODIFYTS,
	C7_MODIFYUSERID MODIFYUSERID,
	C8_PROMOTION_APPLIED PROMOTION_APPLIED,
	C9_CREATETS CREATETS,
	C10_CREATEUSERID CREATEUSERID,
	C11_MODIFYPROGID MODIFYPROGID,
	C12_PROMOTION_KEY PROMOTION_KEY,
	C13_CREATEPROGID CREATEPROGID,
	C14_LOCKID LOCKID 
from	RAX_APP_USER.C$_0STG_PROMOTION
where		(1=1)	






)    ODI_GET_FROM




&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Commit transaction */

/* commit */


/*-----------------------------------------------*/
/* TASK No. 1000009 */
/* Drop work table */

drop table RAX_APP_USER.C$_0STG_PROMOTION 

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 14 */




/*-----------------------------------------------*/
/* TASK No. 15 */
/* Drop flow table */

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_OMS_PROMOTION_XR27300';  
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

create table RAX_APP_USER.I$_OMS_PROMOTION_XR27300
(
	PROMOTION_OID	NUMBER NULL,
	PROMOTION_KEY	VARCHAR2(24) NULL,
	PROMOTION_ID	VARCHAR2(100) NULL,
	ORDER_HEADER_KEY	VARCHAR2(24) NULL,
	ODS_CREATE_DATE	DATE NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_OMS_PROMOTION_XR27300
(
	PROMOTION_KEY,
	PROMOTION_ID,
	ORDER_HEADER_KEY,
	IND_UPDATE
)
select 
PROMOTION_KEY,
	PROMOTION_ID,
	ORDER_HEADER_KEY,
	IND_UPDATE
 from (


select 	 
	DISTINCT
	STG_PROMOTION.PROMOTION_KEY PROMOTION_KEY,
	STG_PROMOTION.PROMOTION_ID PROMOTION_ID,
	STG_PROMOTION.ORDER_HEADER_KEY ORDER_HEADER_KEY,

	'I' IND_UPDATE

from	RAX_APP_USER.STG_PROMOTION   STG_PROMOTION, ODS_STAGE.OMS_PROMOTION_XR   OMS_PROMOTION_XR
where	(1=1)
 And (STG_PROMOTION.PROMOTION_KEY=OMS_PROMOTION_XR.PROMOTION_KEY(+)
and OMS_PROMOTION_XR.PROMOTION_KEY IS NULL)





) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.OMS_PROMOTION_XR T
	where	T.PROMOTION_KEY	= S.PROMOTION_KEY 
		 and ((T.PROMOTION_ID = S.PROMOTION_ID) or (T.PROMOTION_ID IS NULL and S.PROMOTION_ID IS NULL)) and
		((T.ORDER_HEADER_KEY = S.ORDER_HEADER_KEY) or (T.ORDER_HEADER_KEY IS NULL and S.ORDER_HEADER_KEY IS NULL))
        )

  
  

  



&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_OMS_PROMOTION_XR27300',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_OMS_PROMOTION_XR_IDX27300
on		RAX_APP_USER.I$_OMS_PROMOTION_XR27300 (PROMOTION_KEY)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* Merge Rows */

merge into	ODS_STAGE.OMS_PROMOTION_XR T
using	RAX_APP_USER.I$_OMS_PROMOTION_XR27300 S
on	(
		T.PROMOTION_KEY=S.PROMOTION_KEY
	)
when matched
then update set
	T.PROMOTION_ID	= S.PROMOTION_ID,
	T.ORDER_HEADER_KEY	= S.ORDER_HEADER_KEY
	
when not matched
then insert
	(
	T.PROMOTION_KEY,
	T.PROMOTION_ID,
	T.ORDER_HEADER_KEY
	,   T.PROMOTION_OID,
	T.ODS_CREATE_DATE
	)
values
	(
	S.PROMOTION_KEY,
	S.PROMOTION_ID,
	S.ORDER_HEADER_KEY
	,   ODS_STAGE.PROMOTION_OID_SEQ.nextval,
	SYSDATE
	)

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 22 */
/* Drop flow table */

drop table RAX_APP_USER.I$_OMS_PROMOTION_XR27300 

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 23 */




/*-----------------------------------------------*/
/* TASK No. 24 */
/* Drop flow table */

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_PROMOTION1959001';  
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

create table RAX_APP_USER.I$_PROMOTION1959001
(
	PROMOTION_OID	NUMBER NULL,
	PROMOTION_ID	VARCHAR2(100) NULL,
	PROMOTION_TYPE	VARCHAR2(100) NULL,
	PROMOTION_APPLIED	CHAR(1) NULL,
	DENIAL_REASON	VARCHAR2(100) NULL,
	DESCRIPTION	VARCHAR2(100) NULL,
	ORDER_HEADER_OID	NUMBER NULL,
	SOURCE_SYSTEM_OID	NUMBER NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_PROMOTION1959001
(
	PROMOTION_OID,
	PROMOTION_ID,
	PROMOTION_TYPE,
	PROMOTION_APPLIED,
	DENIAL_REASON,
	DESCRIPTION,
	ORDER_HEADER_OID,
	SOURCE_SYSTEM_OID,
	IND_UPDATE
)
select 
PROMOTION_OID,
	PROMOTION_ID,
	PROMOTION_TYPE,
	PROMOTION_APPLIED,
	DENIAL_REASON,
	DESCRIPTION,
	ORDER_HEADER_OID,
	SOURCE_SYSTEM_OID,
	IND_UPDATE
 from (


select 	 
	
	OMS_PROMOTION_XR.PROMOTION_OID PROMOTION_OID,
	STG_PROMOTION.PROMOTION_ID PROMOTION_ID,
	STG_PROMOTION.PROMOTION_TYPE PROMOTION_TYPE,
	STG_PROMOTION.PROMOTION_APPLIED PROMOTION_APPLIED,
	STG_PROMOTION.DENIAL_REASON DENIAL_REASON,
	STG_PROMOTION.DESCRIPTION DESCRIPTION,
	OMS_OH_XR.ORDER_HEADER_OID ORDER_HEADER_OID,
	SOURCE_SYSTEM.SOURCE_SYSTEM_OID SOURCE_SYSTEM_OID,

	'I' IND_UPDATE

from	RAX_APP_USER.STG_PROMOTION   STG_PROMOTION, ODS_STAGE.OMS_PROMOTION_XR   OMS_PROMOTION_XR, ODS_STAGE.OMS_ORDER_HEADER_XR   OMS_OH_XR, ODS_OWN.SOURCE_SYSTEM   SOURCE_SYSTEM
where	(1=1)
 And (STG_PROMOTION.PROMOTION_KEY=OMS_PROMOTION_XR.PROMOTION_KEY)
AND (STG_PROMOTION.ORDER_HEADER_KEY=OMS_OH_XR.ORDER_HEADER_KEY (+))
And (SOURCE_SYSTEM.SOURCE_SYSTEM_SHORT_NAME='OMS')




) S
where NOT EXISTS 
	( select 1 from ODS_OWN.PROMOTION T
	where	T.PROMOTION_OID	= S.PROMOTION_OID 
		 and ((T.PROMOTION_ID = S.PROMOTION_ID) or (T.PROMOTION_ID IS NULL and S.PROMOTION_ID IS NULL)) and
		((T.PROMOTION_TYPE = S.PROMOTION_TYPE) or (T.PROMOTION_TYPE IS NULL and S.PROMOTION_TYPE IS NULL)) and
		((T.PROMOTION_APPLIED = S.PROMOTION_APPLIED) or (T.PROMOTION_APPLIED IS NULL and S.PROMOTION_APPLIED IS NULL)) and
		((T.DENIAL_REASON = S.DENIAL_REASON) or (T.DENIAL_REASON IS NULL and S.DENIAL_REASON IS NULL)) and
		((T.DESCRIPTION = S.DESCRIPTION) or (T.DESCRIPTION IS NULL and S.DESCRIPTION IS NULL)) and
		((T.ORDER_HEADER_OID = S.ORDER_HEADER_OID) or (T.ORDER_HEADER_OID IS NULL and S.ORDER_HEADER_OID IS NULL)) and
		((T.SOURCE_SYSTEM_OID = S.SOURCE_SYSTEM_OID) or (T.SOURCE_SYSTEM_OID IS NULL and S.SOURCE_SYSTEM_OID IS NULL))
        )

  
  

  



&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* Recycle previous errors */

BEGIN  
   EXECUTE IMMEDIATE 'insert into RAX_APP_USER.I$_PROMOTION1959001
						(
							PROMOTION_OID,
							PROMOTION_ID,
							PROMOTION_TYPE,
							PROMOTION_APPLIED,
							DENIAL_REASON,
							DESCRIPTION,
							ORDER_HEADER_OID,
							SOURCE_SYSTEM_OID,
							IND_UPDATE
						)
						select	DISTINCT PROMOTION_OID,
							PROMOTION_ID,
							PROMOTION_TYPE,
							PROMOTION_APPLIED,
							DENIAL_REASON,
							DESCRIPTION,
							ORDER_HEADER_OID,
							SOURCE_SYSTEM_OID,
							''I'' IND_UPDATE
						from	RAX_APP_USER.E$_PROMOTION1959001 E
						where 	not exists (
								select	''?''
								from	RAX_APP_USER.I$_PROMOTION1959001 T
								where			T.PROMOTION_OID=E.PROMOTION_OID
								)
						and	E.ODI_ORIGIN	= ''(1959001)ODS_Project.LOAD_PROMOTION_INT''
						and	E.ODI_ERR_TYPE	= ''F''';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_PROMOTION1959001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_PROMOTION_IDX1959001
on		RAX_APP_USER.I$_PROMOTION1959001 (PROMOTION_OID)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 30 */
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
/* TASK No. 31 */
/* delete previous check sum */

delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS_OWN'
and	ORIGIN 		= '(1959001)ODS_Project.LOAD_PROMOTION_INT'
and	ERR_TYPE 		= 'F'


&


/*-----------------------------------------------*/
/* TASK No. 32 */
/* create error table */


BEGIN  
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.E$_PROMOTION1959001
						(
							ODI_ROW_ID 		UROWID,
							ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
							ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
							ODI_CHECK_DATE	DATE NULL, 
							PROMOTION_OID	NUMBER NULL,
							PROMOTION_ID	VARCHAR2(100) NULL,
							PROMOTION_TYPE	VARCHAR2(100) NULL,
							PROMOTION_APPLIED	CHAR(1) NULL,
							DENIAL_REASON	VARCHAR2(100) NULL,
							DESCRIPTION	VARCHAR2(100) NULL,
							ORDER_HEADER_OID	NUMBER NULL,
							SOURCE_SYSTEM_OID	NUMBER NULL,
							ODS_CREATE_DATE	DATE NULL,
							ODS_MODIFY_DATE	DATE NULL,
							PROMOTION_MASTER_OID	NUMBER NULL,
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
/* TASK No. 33 */
/* delete previous errors */

delete from 	RAX_APP_USER.E$_PROMOTION1959001
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(1959001)ODS_Project.LOAD_PROMOTION_INT')


&


/*-----------------------------------------------*/
/* TASK No. 34 */
/* Create index on PK */

 
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */
BEGIN  
   EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.I$_PROMOTION1959001 on	RAX_APP_USER.I$_PROMOTION1959001 (PROMOTION_OID)';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -955 and SQLCODE != -01408 THEN  
         RAISE;  
      END IF;  
END;


&


/*-----------------------------------------------*/
/* TASK No. 35 */
/* insert PK errors */

DECLARE
               CheckTable                             VarChar2(60);
               TargetTable                            VarChar2(60);
               VariableCheckTable                     VarChar2(60);

BEGIN
               SELECT 'RAX_APP_USER.I$_PROMOTION' INTO CheckTable FROM DUAL;
               SELECT 'ODS_OWN.PROMOTION' INTO TargetTable FROM DUAL;

IF CheckTable = TargetTable THEN
   VariableCheckTable := CheckTable; 
ELSE
   VariableCheckTable := CheckTable || '1959001';
END IF;

execute immediate '
insert into RAX_APP_USER.E$_PROMOTION1959001
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
	PROMOTION_OID,
	PROMOTION_ID,
	PROMOTION_TYPE,
	PROMOTION_APPLIED,
	DENIAL_REASON,
	DESCRIPTION,
	ORDER_HEADER_OID,
	SOURCE_SYSTEM_OID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	''F'', 
	''ODI-15064: The primary key PROMOTION_PK is not unique.'',
	''(1959001)ODS_Project.LOAD_PROMOTION_INT'',
	sysdate,
	''PROMOTION_PK'',
	''PK'',	
	PROMOTION.PROMOTION_OID,
	PROMOTION.PROMOTION_ID,
	PROMOTION.PROMOTION_TYPE,
	PROMOTION.PROMOTION_APPLIED,
	PROMOTION.DENIAL_REASON,
	PROMOTION.DESCRIPTION,
	PROMOTION.ORDER_HEADER_OID,
	PROMOTION.SOURCE_SYSTEM_OID,
	PROMOTION.ODS_CREATE_DATE,
	PROMOTION.ODS_MODIFY_DATE
from	'
 || VariableCheckTable || 
' PROMOTION 
where	exists  (
		select	SUB1.PROMOTION_OID
		from 	' 
|| VariableCheckTable ||
'  SUB1
		where 	SUB1.PROMOTION_OID=PROMOTION.PROMOTION_OID
		group by 	SUB1.PROMOTION_OID
		having 	count(1) > 1
		)
';

END;


&


/*-----------------------------------------------*/
/* TASK No. 36 */
/* Create index on AK */

 
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */
BEGIN  
   EXECUTE IMMEDIATE 'create index 	PROMOTION_PKX_flow on RAX_APP_USER.I$_PROMOTION1959001 (PROMOTION_OID)';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -955 and SQLCODE != -01408 THEN  
         RAISE;  
      END IF;  
END;


&


/*-----------------------------------------------*/
/* TASK No. 37 */
/* insert AK errors */

DECLARE
               CheckTable                             VarChar2(60);
               TargetTable                            VarChar2(60);
               VariableCheckTable                VarChar2(60);

BEGIN
               SELECT 'RAX_APP_USER.I$_PROMOTION' INTO CheckTable FROM DUAL;
               SELECT 'ODS_OWN.PROMOTION' INTO TargetTable FROM DUAL;

IF CheckTable = TargetTable THEN
   VariableCheckTable := CheckTable; 
ELSE
   VariableCheckTable := CheckTable || '1959001';
END IF;

execute immediate '
insert into RAX_APP_USER.E$_PROMOTION1959001
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
	PROMOTION_OID,
	PROMOTION_ID,
	PROMOTION_TYPE,
	PROMOTION_APPLIED,
	DENIAL_REASON,
	DESCRIPTION,
	ORDER_HEADER_OID,
	SOURCE_SYSTEM_OID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	''F'', 
	''ODI-15063: The alternate key PROMOTION_PKX is not unique.'',
	''(1959001)ODS_Project.LOAD_PROMOTION_INT'',
	sysdate,
	''PROMOTION_PKX'',
	''AK'',	
	PROMOTION.PROMOTION_OID,
	PROMOTION.PROMOTION_ID,
	PROMOTION.PROMOTION_TYPE,
	PROMOTION.PROMOTION_APPLIED,
	PROMOTION.DENIAL_REASON,
	PROMOTION.DESCRIPTION,
	PROMOTION.ORDER_HEADER_OID,
	PROMOTION.SOURCE_SYSTEM_OID,
	PROMOTION.ODS_CREATE_DATE,
	PROMOTION.ODS_MODIFY_DATE
from              '	
 || VariableCheckTable || 
' PROMOTION
where	exists  (
		select	SUB.PROMOTION_OID
		from 	'
 || VariableCheckTable || 
' SUB
		where 	SUB.PROMOTION_OID=PROMOTION.PROMOTION_OID
		group by 	SUB.PROMOTION_OID
		having 	count(1) > 1
		)
 ';

END;

/*  Checked Datastore =RAX_APP_USER.I$_PROMOTION  */
/*  Integration Datastore =RAX_APP_USER.I$_PROMOTION   */
/*  Target Datastore =ODS_OWN.PROMOTION */



&


/*-----------------------------------------------*/
/* TASK No. 38 */
/* insert FK errors */

DECLARE
               CheckTable                             VarChar2(60);
               TargetTable                            VarChar2(60);
               VariableCheckTable                VarChar2(60);

BEGIN
               SELECT 'RAX_APP_USER.I$_PROMOTION' INTO CheckTable FROM DUAL;
               SELECT 'ODS_OWN.PROMOTION' INTO TargetTable FROM DUAL;

IF CheckTable = TargetTable THEN
   VariableCheckTable := CheckTable; 
ELSE
   VariableCheckTable := CheckTable || '1959001';
END IF;

execute immediate '
insert into RAX_APP_USER.E$_PROMOTION1959001
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
	PROMOTION_OID,
	PROMOTION_ID,
	PROMOTION_TYPE,
	PROMOTION_APPLIED,
	DENIAL_REASON,
	DESCRIPTION,
	ORDER_HEADER_OID,
	SOURCE_SYSTEM_OID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	''F'', 
	''ODI-15065: Join error (PROMO_ORDER_HEADER) between the table PROMOTION and the table ORDER_HEADER.'',
	sysdate,
	''(1959001)ODS_Project.LOAD_PROMOTION_INT'',
	''PROMO_ORDER_HEADER'',
	''FK'',	
	PROMOTION_OID,
	PROMOTION_ID,
	PROMOTION_TYPE,
	PROMOTION_APPLIED,
	DENIAL_REASON,
	DESCRIPTION,
	ORDER_HEADER_OID,
	SOURCE_SYSTEM_OID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE

from	'
 || VariableCheckTable || 
' PROMOTION 
where 	(
		PROMOTION.ORDER_HEADER_OID 
	) not in 	(
		select 	ORDER_HEADER_OID
		from 	ODS_OWN.ORDER_HEADER
		)
and	(
		PROMOTION.ORDER_HEADER_OID is not null 
	)

';

END;

/*  Checked Datastore =RAX_APP_USER.I$_PROMOTION  */
/*  Integration Datastore =RAX_APP_USER.I$_PROMOTION   */
/*  Target Datastore =ODS_OWN.PROMOTION */


&


/*-----------------------------------------------*/
/* TASK No. 39 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_PROMOTION1959001
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
	PROMOTION_OID,
	PROMOTION_ID,
	PROMOTION_TYPE,
	PROMOTION_APPLIED,
	DENIAL_REASON,
	DESCRIPTION,
	ORDER_HEADER_OID,
	SOURCE_SYSTEM_OID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column PROMOTION_OID cannot be null.',
	sysdate,
	'(1959001)ODS_Project.LOAD_PROMOTION_INT',
	'PROMOTION_OID',
	'NN',	
	PROMOTION_OID,
	PROMOTION_ID,
	PROMOTION_TYPE,
	PROMOTION_APPLIED,
	DENIAL_REASON,
	DESCRIPTION,
	ORDER_HEADER_OID,
	SOURCE_SYSTEM_OID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PROMOTION1959001
where	PROMOTION_OID is null



&


/*-----------------------------------------------*/
/* TASK No. 40 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_PROMOTION1959001
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
	PROMOTION_OID,
	PROMOTION_ID,
	PROMOTION_TYPE,
	PROMOTION_APPLIED,
	DENIAL_REASON,
	DESCRIPTION,
	ORDER_HEADER_OID,
	SOURCE_SYSTEM_OID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column PROMOTION_ID cannot be null.',
	sysdate,
	'(1959001)ODS_Project.LOAD_PROMOTION_INT',
	'PROMOTION_ID',
	'NN',	
	PROMOTION_OID,
	PROMOTION_ID,
	PROMOTION_TYPE,
	PROMOTION_APPLIED,
	DENIAL_REASON,
	DESCRIPTION,
	ORDER_HEADER_OID,
	SOURCE_SYSTEM_OID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PROMOTION1959001
where	PROMOTION_ID is null



&


/*-----------------------------------------------*/
/* TASK No. 41 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_PROMOTION1959001
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
	PROMOTION_OID,
	PROMOTION_ID,
	PROMOTION_TYPE,
	PROMOTION_APPLIED,
	DENIAL_REASON,
	DESCRIPTION,
	ORDER_HEADER_OID,
	SOURCE_SYSTEM_OID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column PROMOTION_TYPE cannot be null.',
	sysdate,
	'(1959001)ODS_Project.LOAD_PROMOTION_INT',
	'PROMOTION_TYPE',
	'NN',	
	PROMOTION_OID,
	PROMOTION_ID,
	PROMOTION_TYPE,
	PROMOTION_APPLIED,
	DENIAL_REASON,
	DESCRIPTION,
	ORDER_HEADER_OID,
	SOURCE_SYSTEM_OID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PROMOTION1959001
where	PROMOTION_TYPE is null



&


/*-----------------------------------------------*/
/* TASK No. 42 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_PROMOTION1959001
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
	PROMOTION_OID,
	PROMOTION_ID,
	PROMOTION_TYPE,
	PROMOTION_APPLIED,
	DENIAL_REASON,
	DESCRIPTION,
	ORDER_HEADER_OID,
	SOURCE_SYSTEM_OID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column PROMOTION_APPLIED cannot be null.',
	sysdate,
	'(1959001)ODS_Project.LOAD_PROMOTION_INT',
	'PROMOTION_APPLIED',
	'NN',	
	PROMOTION_OID,
	PROMOTION_ID,
	PROMOTION_TYPE,
	PROMOTION_APPLIED,
	DENIAL_REASON,
	DESCRIPTION,
	ORDER_HEADER_OID,
	SOURCE_SYSTEM_OID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PROMOTION1959001
where	PROMOTION_APPLIED is null



&


/*-----------------------------------------------*/
/* TASK No. 43 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_PROMOTION1959001
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
	PROMOTION_OID,
	PROMOTION_ID,
	PROMOTION_TYPE,
	PROMOTION_APPLIED,
	DENIAL_REASON,
	DESCRIPTION,
	ORDER_HEADER_OID,
	SOURCE_SYSTEM_OID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column DENIAL_REASON cannot be null.',
	sysdate,
	'(1959001)ODS_Project.LOAD_PROMOTION_INT',
	'DENIAL_REASON',
	'NN',	
	PROMOTION_OID,
	PROMOTION_ID,
	PROMOTION_TYPE,
	PROMOTION_APPLIED,
	DENIAL_REASON,
	DESCRIPTION,
	ORDER_HEADER_OID,
	SOURCE_SYSTEM_OID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PROMOTION1959001
where	DENIAL_REASON is null



&


/*-----------------------------------------------*/
/* TASK No. 44 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_PROMOTION1959001
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
	PROMOTION_OID,
	PROMOTION_ID,
	PROMOTION_TYPE,
	PROMOTION_APPLIED,
	DENIAL_REASON,
	DESCRIPTION,
	ORDER_HEADER_OID,
	SOURCE_SYSTEM_OID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column DESCRIPTION cannot be null.',
	sysdate,
	'(1959001)ODS_Project.LOAD_PROMOTION_INT',
	'DESCRIPTION',
	'NN',	
	PROMOTION_OID,
	PROMOTION_ID,
	PROMOTION_TYPE,
	PROMOTION_APPLIED,
	DENIAL_REASON,
	DESCRIPTION,
	ORDER_HEADER_OID,
	SOURCE_SYSTEM_OID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PROMOTION1959001
where	DESCRIPTION is null



&


/*-----------------------------------------------*/
/* TASK No. 45 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_PROMOTION1959001
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
	PROMOTION_OID,
	PROMOTION_ID,
	PROMOTION_TYPE,
	PROMOTION_APPLIED,
	DENIAL_REASON,
	DESCRIPTION,
	ORDER_HEADER_OID,
	SOURCE_SYSTEM_OID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column ORDER_HEADER_OID cannot be null.',
	sysdate,
	'(1959001)ODS_Project.LOAD_PROMOTION_INT',
	'ORDER_HEADER_OID',
	'NN',	
	PROMOTION_OID,
	PROMOTION_ID,
	PROMOTION_TYPE,
	PROMOTION_APPLIED,
	DENIAL_REASON,
	DESCRIPTION,
	ORDER_HEADER_OID,
	SOURCE_SYSTEM_OID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_PROMOTION1959001
where	ORDER_HEADER_OID is null



&


/*-----------------------------------------------*/
/* TASK No. 46 */
/* create index on error table */

 
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */
BEGIN  
   EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_PROMOTION1959001 on RAX_APP_USER.E$_PROMOTION1959001 (ODI_ROW_ID)';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -955 and SQLCODE != -01408 THEN  
         RAISE;  
      END IF;  
END;


&


/*-----------------------------------------------*/
/* TASK No. 47 */
/* delete errors from controlled table */

delete from	RAX_APP_USER.I$_PROMOTION1959001  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_PROMOTION1959001 E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)


&


/*-----------------------------------------------*/
/* TASK No. 48 */
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
	'PROMOTION',
	'ODS_OWN.PROMOTION1959001',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_PROMOTION1959001 E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(1959001)ODS_Project.LOAD_PROMOTION_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE


&


/*-----------------------------------------------*/
/* TASK No. 49 */
/* Merge Rows */

merge into	ODS_OWN.PROMOTION T
using	RAX_APP_USER.I$_PROMOTION1959001 S
on	(
		T.PROMOTION_OID=S.PROMOTION_OID
	)
when matched
then update set
	T.PROMOTION_ID	= S.PROMOTION_ID,
	T.PROMOTION_TYPE	= S.PROMOTION_TYPE,
	T.PROMOTION_APPLIED	= S.PROMOTION_APPLIED,
	T.DENIAL_REASON	= S.DENIAL_REASON,
	T.DESCRIPTION	= S.DESCRIPTION,
	T.ORDER_HEADER_OID	= S.ORDER_HEADER_OID,
	T.SOURCE_SYSTEM_OID	= S.SOURCE_SYSTEM_OID
	,       T.ODS_MODIFY_DATE	= SYSDATE
when not matched
then insert
	(
	T.PROMOTION_OID,
	T.PROMOTION_ID,
	T.PROMOTION_TYPE,
	T.PROMOTION_APPLIED,
	T.DENIAL_REASON,
	T.DESCRIPTION,
	T.ORDER_HEADER_OID,
	T.SOURCE_SYSTEM_OID
	,        T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.PROMOTION_OID,
	S.PROMOTION_ID,
	S.PROMOTION_TYPE,
	S.PROMOTION_APPLIED,
	S.DENIAL_REASON,
	S.DESCRIPTION,
	S.ORDER_HEADER_OID,
	S.SOURCE_SYSTEM_OID
	,        SYSDATE,
	SYSDATE
	)

&


/*-----------------------------------------------*/
/* TASK No. 50 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 51 */
/* Drop flow table */

drop table RAX_APP_USER.I$_PROMOTION1959001 

&


/*-----------------------------------------------*/
/* TASK No. 52 */
/* Update Promotion Promotion_Master_OID */

MERGE INTO ods_own.promotion d
   USING (SELECT p.promotion_oid, pm.promotion_master_oid
            FROM ods_own.promotion p,
                 ods_own.promotion_master pm,
                 ods_stage.promotion_master_xr xr,
                 ods_own.source_system ss
           WHERE p.promotion_id = pm.promotion_code
             AND pm.promotion_master_oid = xr.promotion_master_oid
             AND p.source_system_oid = ss.source_system_oid
             AND p.promotion_master_oid IS NULL
             AND xr.system_of_record = 'PS'
             AND ss.source_system_short_name = 'OMS'
             and pm.active = 1 -- DM-136
            and xr.ps_promotion_id not in (8779)
             AND P.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
) s
   ON (d.promotion_oid = s.promotion_oid)
   WHEN MATCHED THEN
      UPDATE
         SET d.promotion_master_oid = s.promotion_master_oid

&


/*-----------------------------------------------*/
/* TASK No. 53 */
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
/* TASK No. 54 */
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
,'LOAD_PROMOTION_PKG'
,'016'
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
'LOAD_PROMOTION_PKG',
'016',
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
