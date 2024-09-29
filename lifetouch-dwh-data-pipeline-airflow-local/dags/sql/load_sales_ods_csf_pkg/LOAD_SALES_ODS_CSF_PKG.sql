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


BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0ODS_CSF_SUMMARY';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  
&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Create work table */

create table RAX_APP_USER.C$_0ODS_CSF_SUMMARY
(
	C1_APO_CODE	VARCHAR2(20) NULL,
	C2_CAPTURE_SESSION_QTY	NUMBER NULL,
	C3_STAFF_CAPTURE_SESSION_QTY	NUMBER NULL,
	C4_CLICK_QTY	NUMBER NULL,
	C5_ODS_CREATE_DATE	DATE NULL,
	C6_ODS_MODIFY_DATE	DATE NULL
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Load data */

/* SOURCE CODE */





&

/* TARGET CODE */
insert into RAX_APP_USER.C$_0ODS_CSF_SUMMARY
(
	C1_APO_CODE,
	C2_CAPTURE_SESSION_QTY,
	C3_STAFF_CAPTURE_SESSION_QTY,
	C4_CLICK_QTY,
	C5_ODS_CREATE_DATE,
	C6_ODS_MODIFY_DATE
)
select	
	APO.APO_ID	   C1_APO_CODE,
	APO.CAPTURE_SESSION_QTY	   C2_CAPTURE_SESSION_QTY,
	APO.STAFF_CAPTURE_SESSION_QTY	   C3_STAFF_CAPTURE_SESSION_QTY,
	APO.CLICK_QTY	   C4_CLICK_QTY,
	SYSDATE	   C5_ODS_CREATE_DATE,
	SYSDATE	   C6_ODS_MODIFY_DATE
from	ODS_OWN.APO   APO, ODS_OWN.SOURCE_SYSTEM   SOURCE_SYSTEM
where	(1=1)
And (APO.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(':v_cdc_load_date', 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_sales_ods_overlap)
 And (SOURCE_SYSTEM.SOURCE_SYSTEM_SHORT_NAME = 'OMS2')
 And (APO.SOURCE_SYSTEM_OID=SOURCE_SYSTEM.SOURCE_SYSTEM_OID)

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0ODS_CSF_SUMMARY',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;




&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Drop flow table */

 
BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_ODS_CSF_SUMMARY';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_ODS_CSF_SUMMARY
(
	ODS_CSF_SUMMARY_ID		NUMBER NULL,
	EFFECTIVE_DATE		DATE NULL,
	APO_CODE		VARCHAR2(20) NULL,
	CAPTURE_SESSION_QTY		NUMBER NULL,
	STAFF_CAPTURE_SESSION_QTY		NUMBER NULL,
	CLICK_QTY		NUMBER NULL,
	ODS_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_ODS_CSF_SUMMARY
(
	APO_CODE,
	CAPTURE_SESSION_QTY,
	STAFF_CAPTURE_SESSION_QTY,
	CLICK_QTY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	IND_UPDATE
)
select 
APO_CODE,
	CAPTURE_SESSION_QTY,
	STAFF_CAPTURE_SESSION_QTY,
	CLICK_QTY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	IND_UPDATE
 from (


select 	 
	
	C1_APO_CODE APO_CODE,
	C2_CAPTURE_SESSION_QTY CAPTURE_SESSION_QTY,
	C3_STAFF_CAPTURE_SESSION_QTY STAFF_CAPTURE_SESSION_QTY,
	C4_CLICK_QTY CLICK_QTY,
	C5_ODS_CREATE_DATE ODS_CREATE_DATE,
	C6_ODS_MODIFY_DATE ODS_MODIFY_DATE,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0ODS_CSF_SUMMARY
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS.ODS_CSF_SUMMARY T
	where	T.APO_CODE	= S.APO_CODE 
		 and ((T.CAPTURE_SESSION_QTY = S.CAPTURE_SESSION_QTY) or (T.CAPTURE_SESSION_QTY IS NULL and S.CAPTURE_SESSION_QTY IS NULL)) and
		((T.STAFF_CAPTURE_SESSION_QTY = S.STAFF_CAPTURE_SESSION_QTY) or (T.STAFF_CAPTURE_SESSION_QTY IS NULL and S.STAFF_CAPTURE_SESSION_QTY IS NULL)) and
		((T.CLICK_QTY = S.CLICK_QTY) or (T.CLICK_QTY IS NULL and S.CLICK_QTY IS NULL)) and
		((T.ODS_MODIFY_DATE = S.ODS_MODIFY_DATE) or (T.ODS_MODIFY_DATE IS NULL and S.ODS_MODIFY_DATE IS NULL))
        )

  
  

  

 


&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_ODS_CSF_SUMMARY_IDX
on		RAX_APP_USER.I$_ODS_CSF_SUMMARY (APO_CODE)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_ODS_CSF_SUMMARY',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 14 */
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
      NULL;
END;  

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* delete previous check sum */

delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS'
and	ORIGIN 		= '(235003)Warehouse_Project.LOAD_ODS_CSF_SUMMARY'
and	ERR_TYPE 		= 'F'


&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* create error table */




BEGIN  
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.E$_ODS_CSF_SUMMARY
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	ODS_CSF_SUMMARY_ID	NUMBER NULL,
	EFFECTIVE_DATE	DATE NULL,
	APO_CODE	VARCHAR2(20) NULL,
	CAPTURE_SESSION_QTY	NUMBER NULL,
	STAFF_CAPTURE_SESSION_QTY	NUMBER NULL,
	CLICK_QTY	NUMBER NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
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
/* TASK No. 17 */
/* delete previous errors */

delete from 	RAX_APP_USER.E$_ODS_CSF_SUMMARY
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(235003)Warehouse_Project.LOAD_ODS_CSF_SUMMARY')


&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Create index on AK */

 
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */
create index 	ODS_CSF_SUMMARY_IX0_flow
on	RAX_APP_USER.I$_ODS_CSF_SUMMARY 
	(ODS_CSF_SUMMARY_ID)


&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* insert AK errors */

insert into RAX_APP_USER.E$_ODS_CSF_SUMMARY
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
	ODS_CSF_SUMMARY_ID,
	EFFECTIVE_DATE,
	APO_CODE,
	CAPTURE_SESSION_QTY,
	STAFF_CAPTURE_SESSION_QTY,
	CLICK_QTY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15063: The alternate key ODS_CSF_SUMMARY_IX0 is not unique.',
	'(235003)Warehouse_Project.LOAD_ODS_CSF_SUMMARY',
	sysdate,
	'ODS_CSF_SUMMARY_IX0',
	'AK',	
	CSF.ODS_CSF_SUMMARY_ID,
	CSF.EFFECTIVE_DATE,
	CSF.APO_CODE,
	CSF.CAPTURE_SESSION_QTY,
	CSF.STAFF_CAPTURE_SESSION_QTY,
	CSF.CLICK_QTY,
	CSF.ODS_CREATE_DATE,
	CSF.ODS_MODIFY_DATE
from	RAX_APP_USER.I$_ODS_CSF_SUMMARY   CSF
where	exists  (
		select	SUB.ODS_CSF_SUMMARY_ID
		from 	RAX_APP_USER.I$_ODS_CSF_SUMMARY SUB
		where 	SUB.ODS_CSF_SUMMARY_ID=CSF.ODS_CSF_SUMMARY_ID
		group by 	SUB.ODS_CSF_SUMMARY_ID
		having 	count(1) > 1
		)



&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* Create index on AK */

 
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */


BEGIN  
   EXECUTE IMMEDIATE 'create index 	ODS_CSF_SUMMARY_IX1_flow
on	RAX_APP_USER.I$_ODS_CSF_SUMMARY 
	(APO_CODE)';  
EXCEPTION  
   WHEN OTHERS THEN  
      NULL;
END;  
&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* insert AK errors */

insert into RAX_APP_USER.E$_ODS_CSF_SUMMARY
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
	ODS_CSF_SUMMARY_ID,
	EFFECTIVE_DATE,
	APO_CODE,
	CAPTURE_SESSION_QTY,
	STAFF_CAPTURE_SESSION_QTY,
	CLICK_QTY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15063: The alternate key ODS_CSF_SUMMARY_IX1 is not unique.',
	'(235003)Warehouse_Project.LOAD_ODS_CSF_SUMMARY',
	sysdate,
	'ODS_CSF_SUMMARY_IX1',
	'AK',	
	CSF.ODS_CSF_SUMMARY_ID,
	CSF.EFFECTIVE_DATE,
	CSF.APO_CODE,
	CSF.CAPTURE_SESSION_QTY,
	CSF.STAFF_CAPTURE_SESSION_QTY,
	CSF.CLICK_QTY,
	CSF.ODS_CREATE_DATE,
	CSF.ODS_MODIFY_DATE
from	RAX_APP_USER.I$_ODS_CSF_SUMMARY   CSF
where	exists  (
		select	SUB.APO_CODE
		from 	RAX_APP_USER.I$_ODS_CSF_SUMMARY SUB
		where 	SUB.APO_CODE=CSF.APO_CODE
		group by 	SUB.APO_CODE
		having 	count(1) > 1
		)



&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_ODS_CSF_SUMMARY
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
	ODS_CSF_SUMMARY_ID,
	EFFECTIVE_DATE,
	APO_CODE,
	CAPTURE_SESSION_QTY,
	STAFF_CAPTURE_SESSION_QTY,
	CLICK_QTY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column APO_CODE cannot be null.',
	sysdate,
	'(235003)Warehouse_Project.LOAD_ODS_CSF_SUMMARY',
	'APO_CODE',
	'NN',	
	ODS_CSF_SUMMARY_ID,
	EFFECTIVE_DATE,
	APO_CODE,
	CAPTURE_SESSION_QTY,
	STAFF_CAPTURE_SESSION_QTY,
	CLICK_QTY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_ODS_CSF_SUMMARY
where	APO_CODE is null



&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* create index on error table */

 
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */


BEGIN  
   EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_ODS_CSF_SUMMARY_IDX
on	RAX_APP_USER.E$_ODS_CSF_SUMMARY (ODI_ROW_ID)';  
EXCEPTION  
   WHEN OTHERS THEN  
      NULL;
END;  

&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* delete errors from controlled table */

delete from	RAX_APP_USER.I$_ODS_CSF_SUMMARY  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_ODS_CSF_SUMMARY E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)


&


/*-----------------------------------------------*/
/* TASK No. 25 */
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
	'ODS',
	'ODS_CSF_SUMMARY',
	'ODS.ODS_CSF_SUMMARY',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_ODS_CSF_SUMMARY E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(235003)Warehouse_Project.LOAD_ODS_CSF_SUMMARY'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE


&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* Flag rows for update */

/* DETECTION_STRATEGY = NOT_EXISTS */


update	RAX_APP_USER.I$_ODS_CSF_SUMMARY
set	IND_UPDATE = 'U'
where	(APO_CODE)
	in	(
		select	APO_CODE
		from	ODS.ODS_CSF_SUMMARY
		)



&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* Flag useless rows */

/* DETECTION_STRATEGY = NOT_EXISTS */

/* Command skipped due to chosen DETECTION_STRATEGY */



/*-----------------------------------------------*/
/* TASK No. 28 */
/* Update existing rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
update	ODS.ODS_CSF_SUMMARY T
set 	
	(
	T.CAPTURE_SESSION_QTY,
	T.STAFF_CAPTURE_SESSION_QTY,
	T.CLICK_QTY,
	T.ODS_MODIFY_DATE
	) =
		(
		select	S.CAPTURE_SESSION_QTY,
			S.STAFF_CAPTURE_SESSION_QTY,
			S.CLICK_QTY,
			S.ODS_MODIFY_DATE
		from	RAX_APP_USER.I$_ODS_CSF_SUMMARY S
		where	T.APO_CODE	=S.APO_CODE
	    	 )
	,    T.EFFECTIVE_DATE = SYSDATE

where	(APO_CODE)
	in	(
		select	APO_CODE
		from	RAX_APP_USER.I$_ODS_CSF_SUMMARY
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* Insert new rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
insert into 	ODS.ODS_CSF_SUMMARY T
	(
	APO_CODE,
	CAPTURE_SESSION_QTY,
	STAFF_CAPTURE_SESSION_QTY,
	CLICK_QTY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
	,      ODS_CSF_SUMMARY_ID,
	EFFECTIVE_DATE
	)
select 	APO_CODE,
	CAPTURE_SESSION_QTY,
	STAFF_CAPTURE_SESSION_QTY,
	CLICK_QTY,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
	,      ODS.ODS_CSF_SUMMARY_ID_SEQ.nextval,
	SYSDATE
from	RAX_APP_USER.I$_ODS_CSF_SUMMARY S



where	IND_UPDATE = 'I'



&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 31 */
/* Drop flow table */

 
BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_ODS_CSF_SUMMARY';  
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

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0ODS_CSF_SUMMARY';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
&


/*-----------------------------------------------*/
/* TASK No. 32 */
/* Update CDC Load Status */

UPDATE ODS.DW_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE DW_TABLE_NAME=:v_cdc_load_table_name

&


/*-----------------------------------------------*/
