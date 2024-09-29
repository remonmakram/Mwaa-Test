/* TASK No. 1 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 2 */




/*-----------------------------------------------*/
/* TASK No. 3 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 3 */




/*-----------------------------------------------*/
/* TASK No. 4 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 4 */




/*-----------------------------------------------*/
/* TASK No. 5 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 5 */




/*-----------------------------------------------*/
/* TASK No. 6 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 6 */




/*-----------------------------------------------*/
/* TASK No. 7 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 7 */




/*-----------------------------------------------*/
/* TASK No. 8 */
/* Drop flow table */

--drop table RAX_APP_USER.I$_DGTL_PDCT_TRCKNG926001 
BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_DGTL_PDCT_TRCKNG926001';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_DGTL_PDCT_TRCKNG926001
(
	DIGITAL_PRODUCT_TRACKING_OID		NUMBER NULL,
	WORK_ORDER_DETAIL_ID		NUMBER NULL,
	WOMS_NODE		VARCHAR2(1000) NULL,
	WORK_ORDER_ALIAS_ID		VARCHAR2(20) NULL,
	ITEM_ID		VARCHAR2(40) NULL,
	ITEM_ID_REFERENCE_ID		NUMBER NULL,
	WOMS_CREATE_DATE		DATE NULL,
	ODS_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	SOURCE_SYSTEM_OID		NUMBER NULL,
	LAB_SESSION_ALIAS		VARCHAR2(100) NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = POST_FLOW */
 


  
  
  


insert into	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG926001
(
	WORK_ORDER_DETAIL_ID,
	WOMS_NODE,
	WORK_ORDER_ALIAS_ID,
	ITEM_ID,
	ITEM_ID_REFERENCE_ID,
	WOMS_CREATE_DATE,
	LAB_SESSION_ALIAS,
	IND_UPDATE
)


select 	 
	
	WOMS_WRK_ORD_DET_STG.WORK_ORDER_DETAIL_ID,
	WOMS_WRK_ORD_DET_STG.WOMS_NODE,
	WOMS_WORK_ORDER_STG.WORK_ORDER_ALIAS_ID,
	ITEM_ID_REFERENCE_STG.ITEM_ID,
	ITEM_ID_REFERENCE_STG.ITEM_ID_REFERENCE_ID,
	WOMS_WRK_ORD_DET_STG.AUDIT_CREATE_DATE,
	WOMS_WRK_ORD_DET_STG.LAB_SESSION_ALIAS,

	'I' IND_UPDATE

from	ODS_STAGE.WOMS_ITEM_ID_REFERENCE_STG   ITEM_ID_REFERENCE_STG, ODS_STAGE.WOMS_XREF_OMS_PROD_STG   XREF_OMS_PROD_STG, ODS_STAGE.WOMS_WORK_ORDER_DETAIL_STG   WOMS_WRK_ORD_DET_STG, ODS_STAGE.WOMS_WORK_ORDER_STG   WOMS_WORK_ORDER_STG
where	(1=1)
 And (ITEM_ID_REFERENCE_STG.XREF_OMS_PROD_ID=XREF_OMS_PROD_STG.XREF_OMS_PROD_ID)
AND (WOMS_WRK_ORD_DET_STG.ITEM_ID_REFERENCE_ID=ITEM_ID_REFERENCE_STG.ITEM_ID_REFERENCE_ID)
AND (WOMS_WRK_ORD_DET_STG.WORK_ORDER_ID=WOMS_WORK_ORDER_STG.WORK_ORDER_ID 
AND WOMS_WRK_ORD_DET_STG.WOMS_NODE=WOMS_WORK_ORDER_STG.WOMS_NODE)
And (XREF_OMS_PROD_STG.UNDERCLASS_PRODUCT_CODE = 'DID')
 And (WOMS_WRK_ORD_DET_STG.ODS_MODIFY_DATE >=   ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))




  

 


&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG_IDX926001
on		RAX_APP_USER.I$_DGTL_PDCT_TRCKNG926001 (WORK_ORDER_DETAIL_ID, WOMS_NODE, LAB_SESSION_ALIAS)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_DGTL_PDCT_TRCKNG926001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Flag rows for update */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG926001
set	IND_UPDATE = 'U'
where	(WORK_ORDER_DETAIL_ID, WOMS_NODE, LAB_SESSION_ALIAS)
	in	(
		select	WORK_ORDER_DETAIL_ID,
			WOMS_NODE,
			LAB_SESSION_ALIAS
		from	ODS_OWN.DIGITAL_PRODUCT_TRACK
		)



&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Flag useless rows */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG926001 S
set	IND_UPDATE = 'N'
where	exists (
	select 	'X'
	from 	ODS_OWN.DIGITAL_PRODUCT_TRACK 	T
	where	T.WORK_ORDER_DETAIL_ID	= S.WORK_ORDER_DETAIL_ID
	and	T.WOMS_NODE	= S.WOMS_NODE
	and	T.LAB_SESSION_ALIAS	= S.LAB_SESSION_ALIAS
		and	((T.WORK_ORDER_ALIAS_ID = S.WORK_ORDER_ALIAS_ID) or (T.WORK_ORDER_ALIAS_ID IS NULL and S.WORK_ORDER_ALIAS_ID IS NULL))
and	((T.ITEM_ID = S.ITEM_ID) or (T.ITEM_ID IS NULL and S.ITEM_ID IS NULL))
and	((T.ITEM_ID_REFERENCE_ID = S.ITEM_ID_REFERENCE_ID) or (T.ITEM_ID_REFERENCE_ID IS NULL and S.ITEM_ID_REFERENCE_ID IS NULL))
and	((T.WOMS_CREATE_DATE = S.WOMS_CREATE_DATE) or (T.WOMS_CREATE_DATE IS NULL and S.WOMS_CREATE_DATE IS NULL))
	)



&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Update existing rows */

/* DETECTION_STRATEGY = POST_FLOW */
update	ODS_OWN.DIGITAL_PRODUCT_TRACK T
set 	
	(
	T.WORK_ORDER_ALIAS_ID,
	T.ITEM_ID,
	T.ITEM_ID_REFERENCE_ID,
	T.WOMS_CREATE_DATE
	) =
		(
		select	S.WORK_ORDER_ALIAS_ID,
			S.ITEM_ID,
			S.ITEM_ID_REFERENCE_ID,
			S.WOMS_CREATE_DATE
		from	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG926001 S
		where	T.WORK_ORDER_DETAIL_ID	=S.WORK_ORDER_DETAIL_ID
		and	T.WOMS_NODE	=S.WOMS_NODE
		and	T.LAB_SESSION_ALIAS	=S.LAB_SESSION_ALIAS
	    	 )
	,    T.ODS_MODIFY_DATE = SYSDATE,
	T.SOURCE_SYSTEM_OID = (Select source_system_oid from ods_own.source_system where source_system_short_name='WOMS')

where	(WORK_ORDER_DETAIL_ID, WOMS_NODE, LAB_SESSION_ALIAS)
	in	(
		select	WORK_ORDER_DETAIL_ID,
			WOMS_NODE,
			LAB_SESSION_ALIAS
		from	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG926001
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Insert new rows */

/* DETECTION_STRATEGY = POST_FLOW */
insert into 	ODS_OWN.DIGITAL_PRODUCT_TRACK T
	(
	WORK_ORDER_DETAIL_ID,
	WOMS_NODE,
	WORK_ORDER_ALIAS_ID,
	ITEM_ID,
	ITEM_ID_REFERENCE_ID,
	WOMS_CREATE_DATE,
	LAB_SESSION_ALIAS
	,       DIGITAL_PRODUCT_TRACKING_OID,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE,
	SOURCE_SYSTEM_OID
	)
select 	WORK_ORDER_DETAIL_ID,
	WOMS_NODE,
	WORK_ORDER_ALIAS_ID,
	ITEM_ID,
	ITEM_ID_REFERENCE_ID,
	WOMS_CREATE_DATE,
	LAB_SESSION_ALIAS
	,       ODS_STAGE.DIGITAL_PRODUCT_TRACKING_SEQ.NEXTVAL,
	SYSDATE,
	SYSDATE,
	(Select source_system_oid from ods_own.source_system where source_system_short_name='WOMS')
from	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG926001 S



where	IND_UPDATE = 'I'



&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Drop flow table */

--drop table RAX_APP_USER.I$_DGTL_PDCT_TRCKNG926001
BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_DGTL_PDCT_TRCKNG926001';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* sub-select inline view */

(


select 	 
	
	ODS_STAGE.DIGITAL_PRODUCT_TRACKING_SEQ.NEXTVAL    DIGITAL_PRODUCT_TRACKING_OID,
	WOMS_WRK_ORD_DET_STG.WORK_ORDER_DETAIL_ID    WORK_ORDER_DETAIL_ID,
	WOMS_WRK_ORD_DET_STG.WOMS_NODE    WOMS_NODE,
	WOMS_WORK_ORDER_STG.WORK_ORDER_ALIAS_ID    WORK_ORDER_ALIAS_ID,
	ITEM_ID_REFERENCE_STG.ITEM_ID    ITEM_ID,
	ITEM_ID_REFERENCE_STG.ITEM_ID_REFERENCE_ID    ITEM_ID_REFERENCE_ID,
	WOMS_WRK_ORD_DET_STG.AUDIT_CREATE_DATE    WOMS_CREATE_DATE,
	SYSDATE    ODS_CREATE_DATE,
	SYSDATE    ODS_MODIFY_DATE,
	(Select source_system_oid from ods_own.source_system where source_system_short_name='WOMS')    SOURCE_SYSTEM_OID,
	WOMS_WRK_ORD_DET_STG.LAB_SESSION_ALIAS    LAB_SESSION_ALIAS
from	ODS_STAGE.WOMS_ITEM_ID_REFERENCE_STG   ITEM_ID_REFERENCE_STG, ODS_STAGE.WOMS_XREF_OMS_PROD_STG   XREF_OMS_PROD_STG, ODS_STAGE.WOMS_WORK_ORDER_DETAIL_STG   WOMS_WRK_ORD_DET_STG, ODS_STAGE.WOMS_WORK_ORDER_STG   WOMS_WORK_ORDER_STG
where	(1=1)
 And (ITEM_ID_REFERENCE_STG.XREF_OMS_PROD_ID=XREF_OMS_PROD_STG.XREF_OMS_PROD_ID)
AND (WOMS_WRK_ORD_DET_STG.ITEM_ID_REFERENCE_ID=ITEM_ID_REFERENCE_STG.ITEM_ID_REFERENCE_ID)
AND (WOMS_WRK_ORD_DET_STG.WORK_ORDER_ID=WOMS_WORK_ORDER_STG.WORK_ORDER_ID 
AND WOMS_WRK_ORD_DET_STG.WOMS_NODE=WOMS_WORK_ORDER_STG.WOMS_NODE)
And (XREF_OMS_PROD_STG.UNDERCLASS_PRODUCT_CODE = 'DID')
 And (WOMS_WRK_ORD_DET_STG.ODS_MODIFY_DATE >=   ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))



)

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 20 */




/*-----------------------------------------------*/
/* TASK No. 21 */
/* Drop flow table */

--drop table RAX_APP_USER.I$_DGTL_PDCT_TRCKNG927001
BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_DGTL_PDCT_TRCKNG927001';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_DGTL_PDCT_TRCKNG927001
(
	DIGITAL_PRODUCT_TRACKING_OID		NUMBER NULL,
	PBS_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = POST_FLOW */
 


  
  
  


insert into	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG927001
(
	DIGITAL_PRODUCT_TRACKING_OID,
	PBS_CREATE_DATE,
	IND_UPDATE
)


select 	 
	
	DIGITAL_PRODUCT_TRACKING.DIGITAL_PRODUCT_TRACKING_OID,
	MAX(PDB_JOB_QUEUE_STG.ODS_CREATE_DATE),

	'I' IND_UPDATE

from	ODS_OWN.DIGITAL_PRODUCT_TRACK   DIGITAL_PRODUCT_TRACKING, ODS_STAGE.PDB_JOB_QUEUE_STG   PDB_JOB_QUEUE_STG
where	(1=1)
 And (PDB_JOB_QUEUE_STG.ONE_LAB_WORK_ORD_ALIAS=DIGITAL_PRODUCT_TRACKING.WORK_ORDER_ALIAS_ID)
And (PDB_JOB_QUEUE_STG.JOB_QUEUE_PRODUCT_CODE='DID')
 And (DIGITAL_PRODUCT_TRACKING.PBS_CREATE_DATE IS NULL)

Group By DIGITAL_PRODUCT_TRACKING.DIGITAL_PRODUCT_TRACKING_OID


  

 


&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG_IDX927001
on		RAX_APP_USER.I$_DGTL_PDCT_TRCKNG927001 (DIGITAL_PRODUCT_TRACKING_OID)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_DGTL_PDCT_TRCKNG927001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* Flag rows for update */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG927001
set	IND_UPDATE = 'U'
where	(DIGITAL_PRODUCT_TRACKING_OID)
	in	(
		select	DIGITAL_PRODUCT_TRACKING_OID
		from	ODS_OWN.DIGITAL_PRODUCT_TRACK
		)



&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* Flag useless rows */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG927001 S
set	IND_UPDATE = 'N'
where	exists (
	select 	'X'
	from 	ODS_OWN.DIGITAL_PRODUCT_TRACK 	T
	where	T.DIGITAL_PRODUCT_TRACKING_OID	= S.DIGITAL_PRODUCT_TRACKING_OID
		and	((T.PBS_CREATE_DATE = S.PBS_CREATE_DATE) or (T.PBS_CREATE_DATE IS NULL and S.PBS_CREATE_DATE IS NULL))
	)



&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* Update existing rows */

/* DETECTION_STRATEGY = POST_FLOW */
update	ODS_OWN.DIGITAL_PRODUCT_TRACK T
set 	
	(
	T.PBS_CREATE_DATE
	) =
		(
		select	S.PBS_CREATE_DATE
		from	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG927001 S
		where	T.DIGITAL_PRODUCT_TRACKING_OID	=S.DIGITAL_PRODUCT_TRACKING_OID
	    	 )
	, T.ODS_MODIFY_DATE = SYSDATE

where	(DIGITAL_PRODUCT_TRACKING_OID)
	in	(
		select	DIGITAL_PRODUCT_TRACKING_OID
		from	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG927001
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 30 */
/* Drop flow table */

-- drop table RAX_APP_USER.I$_DGTL_PDCT_TRCKNG927001
BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_DGTL_PDCT_TRCKNG927001';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* sub-select inline view */

(


select 	 
	
	DIGITAL_PRODUCT_TRACKING.DIGITAL_PRODUCT_TRACKING_OID    DIGITAL_PRODUCT_TRACKING_OID,
	MAX(PDB_JOB_QUEUE_STG.ODS_CREATE_DATE)    PBS_CREATE_DATE,
	SYSDATE    ODS_MODIFY_DATE
from	ODS_OWN.DIGITAL_PRODUCT_TRACK   DIGITAL_PRODUCT_TRACKING, ODS_STAGE.PDB_JOB_QUEUE_STG   PDB_JOB_QUEUE_STG
where	(1=1)
 And (PDB_JOB_QUEUE_STG.ONE_LAB_WORK_ORD_ALIAS=DIGITAL_PRODUCT_TRACKING.WORK_ORDER_ALIAS_ID)
And (PDB_JOB_QUEUE_STG.JOB_QUEUE_PRODUCT_CODE='DID')
 And (DIGITAL_PRODUCT_TRACKING.PBS_CREATE_DATE IS NULL)
Group By DIGITAL_PRODUCT_TRACKING.DIGITAL_PRODUCT_TRACKING_OID


)

&


/*-----------------------------------------------*/
/* TASK No. 32 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 32 */




/*-----------------------------------------------*/
/* TASK No. 33 */
/* Drop flow table */

-- drop table RAX_APP_USER.I$_DGTL_PDCT_TRCKNG933001 
BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_DGTL_PDCT_TRCKNG933001';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 34 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_DGTL_PDCT_TRCKNG933001
(
	DIGITAL_PRODUCT_TRACKING_OID		NUMBER NULL,
	IMAGE_CACHE_CREATE_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 35 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = POST_FLOW */
 


  
  
  


insert into	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG933001
(
	DIGITAL_PRODUCT_TRACKING_OID,
	IMAGE_CACHE_CREATE_DATE,
	IND_UPDATE
)


select 	 
	
	DIGITAL_PRODUCT_TRACKING.DIGITAL_PRODUCT_TRACKING_OID,
	MAX(IC_EMAIL_REQUEST_STG.AUDIT_CREATE_DATE),

	'I' IND_UPDATE

from	ODS_OWN.DIGITAL_PRODUCT_TRACK   DIGITAL_PRODUCT_TRACKING, ODS_STAGE.IC_EMAIL_REQUEST_STG   IC_EMAIL_REQUEST_STG
where	(1=1)
 And (DIGITAL_PRODUCT_TRACKING.WORK_ORDER_ALIAS_ID=IC_EMAIL_REQUEST_STG.WORK_ORDER_ALIAS_ID AND IC_EMAIL_REQUEST_STG.LAB_SESSION_ALIAS=DIGITAL_PRODUCT_TRACKING.LAB_SESSION_ALIAS)
And (IC_EMAIL_REQUEST_STG.AUDIT_MODIFY_DATE >=  ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))

Group By DIGITAL_PRODUCT_TRACKING.DIGITAL_PRODUCT_TRACKING_OID


  

 


&


/*-----------------------------------------------*/
/* TASK No. 36 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG_IDX933001
on		RAX_APP_USER.I$_DGTL_PDCT_TRCKNG933001 (DIGITAL_PRODUCT_TRACKING_OID)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 37 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_DGTL_PDCT_TRCKNG933001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 38 */
/* Flag rows for update */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG933001
set	IND_UPDATE = 'U'
where	(DIGITAL_PRODUCT_TRACKING_OID)
	in	(
		select	DIGITAL_PRODUCT_TRACKING_OID
		from	ODS_OWN.DIGITAL_PRODUCT_TRACK
		)



&


/*-----------------------------------------------*/
/* TASK No. 39 */
/* Flag useless rows */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG933001 S
set	IND_UPDATE = 'N'
where	exists (
	select 	'X'
	from 	ODS_OWN.DIGITAL_PRODUCT_TRACK 	T
	where	T.DIGITAL_PRODUCT_TRACKING_OID	= S.DIGITAL_PRODUCT_TRACKING_OID
		and	((T.IMAGE_CACHE_CREATE_DATE = S.IMAGE_CACHE_CREATE_DATE) or (T.IMAGE_CACHE_CREATE_DATE IS NULL and S.IMAGE_CACHE_CREATE_DATE IS NULL))
	)



&


/*-----------------------------------------------*/
/* TASK No. 40 */
/* Update existing rows */

/* DETECTION_STRATEGY = POST_FLOW */
update	ODS_OWN.DIGITAL_PRODUCT_TRACK T
set 	
	(
	T.IMAGE_CACHE_CREATE_DATE
	) =
		(
		select	S.IMAGE_CACHE_CREATE_DATE
		from	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG933001 S
		where	T.DIGITAL_PRODUCT_TRACKING_OID	=S.DIGITAL_PRODUCT_TRACKING_OID
	    	 )
	

where	(DIGITAL_PRODUCT_TRACKING_OID)
	in	(
		select	DIGITAL_PRODUCT_TRACKING_OID
		from	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG933001
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 41 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 42 */
/* Drop flow table */

-- drop table RAX_APP_USER.I$_DGTL_PDCT_TRCKNG933001 
BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_DGTL_PDCT_TRCKNG933001';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;


&


/*-----------------------------------------------*/
/* TASK No. 43 */
/* sub-select inline view */

(


select 	 
	
	DIGITAL_PRODUCT_TRACKING.DIGITAL_PRODUCT_TRACKING_OID    DIGITAL_PRODUCT_TRACKING_OID,
	MAX(IC_EMAIL_REQUEST_STG.AUDIT_CREATE_DATE)    IMAGE_CACHE_CREATE_DATE
from	ODS_OWN.DIGITAL_PRODUCT_TRACK   DIGITAL_PRODUCT_TRACKING, ODS_STAGE.IC_EMAIL_REQUEST_STG   IC_EMAIL_REQUEST_STG
where	(1=1)
 And (DIGITAL_PRODUCT_TRACKING.WORK_ORDER_ALIAS_ID=IC_EMAIL_REQUEST_STG.WORK_ORDER_ALIAS_ID AND IC_EMAIL_REQUEST_STG.LAB_SESSION_ALIAS=DIGITAL_PRODUCT_TRACKING.LAB_SESSION_ALIAS)
And (IC_EMAIL_REQUEST_STG.AUDIT_MODIFY_DATE >=  ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))
Group By DIGITAL_PRODUCT_TRACKING.DIGITAL_PRODUCT_TRACKING_OID


)

&


/*-----------------------------------------------*/
/* TASK No. 44 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 44 */




/*-----------------------------------------------*/
/* TASK No. 45 */
/* Drop flow table */

-- drop table RAX_APP_USER.I$_DGTL_PDCT_TRCKNG934001
BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_DGTL_PDCT_TRCKNG934001';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 46 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_DGTL_PDCT_TRCKNG934001
(
	DIGITAL_PRODUCT_TRACKING_OID		NUMBER NULL,
	EMAIL_SENT_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 47 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = POST_FLOW */
 


  
  
  


insert into	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG934001
(
	DIGITAL_PRODUCT_TRACKING_OID,
	EMAIL_SENT_DATE,
	IND_UPDATE
)


select 	 
	
	DIGITAL_PRODUCT_TRACKING.DIGITAL_PRODUCT_TRACKING_OID,
	MAX(IC_EMAIL_REQUEST_STG.AUDIT_MODIFY_DATE),

	'I' IND_UPDATE

from	ODS_OWN.DIGITAL_PRODUCT_TRACK   DIGITAL_PRODUCT_TRACKING, ODS_STAGE.IC_EMAIL_REQUEST_STG   IC_EMAIL_REQUEST_STG, ODS_STAGE.IC_STATUS_STG   IC_STATUS_STG
where	(1=1)
 And (IC_EMAIL_REQUEST_STG.WORK_ORDER_ALIAS_ID=DIGITAL_PRODUCT_TRACKING.WORK_ORDER_ALIAS_ID AND 
IC_EMAIL_REQUEST_STG.LAB_SESSION_ALIAS=DIGITAL_PRODUCT_TRACKING.LAB_SESSION_ALIAS)
AND (IC_EMAIL_REQUEST_STG.STATUS_ID=IC_STATUS_STG.STATUS_ID)
And (IC_STATUS_STG.CODE = 'ST')
 And (IC_EMAIL_REQUEST_STG.ODS_MODIFY_DATE >=  ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))

Group By DIGITAL_PRODUCT_TRACKING.DIGITAL_PRODUCT_TRACKING_OID


  

 


&


/*-----------------------------------------------*/
/* TASK No. 48 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG_IDX934001
on		RAX_APP_USER.I$_DGTL_PDCT_TRCKNG934001 (DIGITAL_PRODUCT_TRACKING_OID)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 49 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_DGTL_PDCT_TRCKNG934001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 50 */
/* Flag rows for update */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG934001
set	IND_UPDATE = 'U'
where	(DIGITAL_PRODUCT_TRACKING_OID)
	in	(
		select	DIGITAL_PRODUCT_TRACKING_OID
		from	ODS_OWN.DIGITAL_PRODUCT_TRACK
		)



&


/*-----------------------------------------------*/
/* TASK No. 51 */
/* Flag useless rows */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG934001 S
set	IND_UPDATE = 'N'
where	exists (
	select 	'X'
	from 	ODS_OWN.DIGITAL_PRODUCT_TRACK 	T
	where	T.DIGITAL_PRODUCT_TRACKING_OID	= S.DIGITAL_PRODUCT_TRACKING_OID
		and	((T.EMAIL_SENT_DATE = S.EMAIL_SENT_DATE) or (T.EMAIL_SENT_DATE IS NULL and S.EMAIL_SENT_DATE IS NULL))
	)



&


/*-----------------------------------------------*/
/* TASK No. 52 */
/* Update existing rows */

/* DETECTION_STRATEGY = POST_FLOW */
update	ODS_OWN.DIGITAL_PRODUCT_TRACK T
set 	
	(
	T.EMAIL_SENT_DATE
	) =
		(
		select	S.EMAIL_SENT_DATE
		from	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG934001 S
		where	T.DIGITAL_PRODUCT_TRACKING_OID	=S.DIGITAL_PRODUCT_TRACKING_OID
	    	 )
	, T.ODS_MODIFY_DATE = SYSDATE

where	(DIGITAL_PRODUCT_TRACKING_OID)
	in	(
		select	DIGITAL_PRODUCT_TRACKING_OID
		from	RAX_APP_USER.I$_DGTL_PDCT_TRCKNG934001
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 53 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 54 */
/* Drop flow table */

-- drop table RAX_APP_USER.I$_DGTL_PDCT_TRCKNG934001
BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_DGTL_PDCT_TRCKNG934001 ';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 55 */
/* sub-select inline view */

(


select 	 
	
	DIGITAL_PRODUCT_TRACKING.DIGITAL_PRODUCT_TRACKING_OID    DIGITAL_PRODUCT_TRACKING_OID,
	MAX(IC_EMAIL_REQUEST_STG.AUDIT_MODIFY_DATE)    EMAIL_SENT_DATE,
	SYSDATE    ODS_MODIFY_DATE
from	ODS_OWN.DIGITAL_PRODUCT_TRACK   DIGITAL_PRODUCT_TRACKING, ODS_STAGE.IC_EMAIL_REQUEST_STG   IC_EMAIL_REQUEST_STG, ODS_STAGE.IC_STATUS_STG   IC_STATUS_STG
where	(1=1)
 And (IC_EMAIL_REQUEST_STG.WORK_ORDER_ALIAS_ID=DIGITAL_PRODUCT_TRACKING.WORK_ORDER_ALIAS_ID AND 
IC_EMAIL_REQUEST_STG.LAB_SESSION_ALIAS=DIGITAL_PRODUCT_TRACKING.LAB_SESSION_ALIAS)
AND (IC_EMAIL_REQUEST_STG.STATUS_ID=IC_STATUS_STG.STATUS_ID)
And (IC_STATUS_STG.CODE = 'ST')
 And (IC_EMAIL_REQUEST_STG.ODS_MODIFY_DATE >=  ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))
Group By DIGITAL_PRODUCT_TRACKING.DIGITAL_PRODUCT_TRACKING_OID


)

&


/*-----------------------------------------------*/
/* TASK No. 56 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name


&


/*-----------------------------------------------*/
/* TASK No. 57 */
/* Insert CDC Audit Record */

INSERT INTO RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
(TABLE_NAME,
SESS_NO,                      
SESS_NAME,                    
SCEN_VERSION,                 
SESS_BEG,                     
ORIG_LAST_CDC_COMPLETION_DATE,
OVERLAP,
CREATE_DATE              
)
values (
:v_cdc_load_table_name,
:v_sess_no,
'34_DIGITAL_ORDER_TRACKING_PKG',
'001',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_ld_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          ),
:v_cdc_oms_overlap,
SYSDATE)

&


/*-----------------------------------------------*/
