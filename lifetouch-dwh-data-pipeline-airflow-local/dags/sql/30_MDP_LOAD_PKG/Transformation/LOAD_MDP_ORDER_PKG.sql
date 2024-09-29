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

-- drop table RAX_APP_USER.C$_0MDP_ORDER_STG purge

-- &


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Create work table */

-- create table RAX_APP_USER.C$_0MDP_ORDER_STG
-- (
-- 	C1_ORDER_ID	NUMBER NULL,
-- 	C2_SHIPMENT_ID	NUMBER NULL,
-- 	C3_SOURCE	VARCHAR2(255) NULL,
-- 	C4_ORDER_NO	VARCHAR2(255) NULL,
-- 	C5_PROCESSING_START_TIME	TIMESTAMP(6) NULL,
-- 	C6_PROCESSING_END_TIME	TIMESTAMP(6) NULL,
-- 	C7_OUTCOME	VARCHAR2(255) NULL,
-- 	C8_AUDIT_CREATE_DATE	TIMESTAMP(6) NULL,
-- 	C9_AUDIT_MODIFIED_DATE	TIMESTAMP(6) NULL,
-- 	C10_VERSION	NUMBER NULL,
-- 	C11_CUSTOMER_ORDER_MESSAGE_KEY	VARCHAR2(255) NULL,
-- 	C12_SHIPMENT_KEY	VARCHAR2(255) NULL
-- )
-- NOLOGGING

-- &


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Load data */

/* SOURCE CODE */


-- select	
-- 	MDP_ORDER.ORDER_ID	   C1_ORDER_ID,
-- 	MDP_ORDER.SHIPMENT_ID	   C2_SHIPMENT_ID,
-- 	MDP_ORDER.SOURCE	   C3_SOURCE,
-- 	MDP_ORDER.ORDER_NO	   C4_ORDER_NO,
-- 	MDP_ORDER.PROCESSING_START_TIME	   C5_PROCESSING_START_TIME,
-- 	MDP_ORDER.PROCESSING_END_TIME	   C6_PROCESSING_END_TIME,
-- 	MDP_ORDER.OUTCOME	   C7_OUTCOME,
-- 	MDP_ORDER.AUDIT_CREATE_DATE	   C8_AUDIT_CREATE_DATE,
-- 	MDP_ORDER.AUDIT_MODIFIED_DATE	   C9_AUDIT_MODIFIED_DATE,
-- 	MDP_ORDER.VERSION	   C10_VERSION,
-- 	MDP_ORDER.CUSTOMER_ORDER_MESSAGE_KEY	   C11_CUSTOMER_ORDER_MESSAGE_KEY,
-- 	SHIPMENT.SHIPMENT_KEY	   C12_SHIPMENT_KEY
-- from	MDP_OWN.MDP_ORDER   MDP_ORDER, MDP_OWN.SHIPMENT   SHIPMENT
-- where	(1=1)
-- And (MDP_ORDER.AUDIT_MODIFIED_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap)

--  And (MDP_ORDER.SHIPMENT_ID=SHIPMENT.SHIPMENT_ID (+))





-- &

-- /* TARGET CODE */
-- insert /*+ append */ into RAX_APP_USER.C$_0MDP_ORDER_STG
-- (
-- 	C1_ORDER_ID,
-- 	C2_SHIPMENT_ID,
-- 	C3_SOURCE,
-- 	C4_ORDER_NO,
-- 	C5_PROCESSING_START_TIME,
-- 	C6_PROCESSING_END_TIME,
-- 	C7_OUTCOME,
-- 	C8_AUDIT_CREATE_DATE,
-- 	C9_AUDIT_MODIFIED_DATE,
-- 	C10_VERSION,
-- 	C11_CUSTOMER_ORDER_MESSAGE_KEY,
-- 	C12_SHIPMENT_KEY
-- )
-- values
-- (
-- 	:C1_ORDER_ID,
-- 	:C2_SHIPMENT_ID,
-- 	:C3_SOURCE,
-- 	:C4_ORDER_NO,
-- 	:C5_PROCESSING_START_TIME,
-- 	:C6_PROCESSING_END_TIME,
-- 	:C7_OUTCOME,
-- 	:C8_AUDIT_CREATE_DATE,
-- 	:C9_AUDIT_MODIFIED_DATE,
-- 	:C10_VERSION,
-- 	:C11_CUSTOMER_ORDER_MESSAGE_KEY,
-- 	:C12_SHIPMENT_KEY
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0MDP_ORDER_STG',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;




&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Drop flow table */


BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_MDP_ORDER_STG';  
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

create table RAX_APP_USER.I$_MDP_ORDER_STG
(
	ORDER_ID		NUMBER NULL,
	SHIPMENT_ID		NUMBER NULL,
	SOURCE		VARCHAR2(255) NULL,
	ORDER_NO		VARCHAR2(255) NULL,
	PROCESSING_START_TIME		TIMESTAMP(6) NULL,
	PROCESSING_END_TIME		TIMESTAMP(6) NULL,
	OUTCOME		VARCHAR2(255) NULL,
	AUDIT_CREATE_DATE		TIMESTAMP(6) NULL,
	AUDIT_MODIFIED_DATE		TIMESTAMP(6) NULL,
	VERSION		NUMBER NULL,
	CUSTOMER_ORDER_MESSAGE_KEY		VARCHAR2(255) NULL,
	SHIPMENT_KEY		VARCHAR2(255) NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_MDP_ORDER_STG
(
	ORDER_ID,
	SHIPMENT_ID,
	SOURCE,
	ORDER_NO,
	PROCESSING_START_TIME,
	PROCESSING_END_TIME,
	OUTCOME,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFIED_DATE,
	VERSION,
	CUSTOMER_ORDER_MESSAGE_KEY,
	SHIPMENT_KEY,
	IND_UPDATE
)
select 
ORDER_ID,
	SHIPMENT_ID,
	SOURCE,
	ORDER_NO,
	PROCESSING_START_TIME,
	PROCESSING_END_TIME,
	OUTCOME,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFIED_DATE,
	VERSION,
	CUSTOMER_ORDER_MESSAGE_KEY,
	SHIPMENT_KEY,
	IND_UPDATE
 from (


select 	 
	
	C1_ORDER_ID ORDER_ID,
	C2_SHIPMENT_ID SHIPMENT_ID,
	C3_SOURCE SOURCE,
	C4_ORDER_NO ORDER_NO,
	C5_PROCESSING_START_TIME PROCESSING_START_TIME,
	C6_PROCESSING_END_TIME PROCESSING_END_TIME,
	C7_OUTCOME OUTCOME,
	C8_AUDIT_CREATE_DATE AUDIT_CREATE_DATE,
	C9_AUDIT_MODIFIED_DATE AUDIT_MODIFIED_DATE,
	C10_VERSION VERSION,
	C11_CUSTOMER_ORDER_MESSAGE_KEY CUSTOMER_ORDER_MESSAGE_KEY,
	C12_SHIPMENT_KEY SHIPMENT_KEY,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0MDP_ORDER_STG
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.MDP_ORDER_STG T
	where	T.ORDER_ID	= S.ORDER_ID 
		 and ((T.SHIPMENT_ID = S.SHIPMENT_ID) or (T.SHIPMENT_ID IS NULL and S.SHIPMENT_ID IS NULL)) and
		((T.SOURCE = S.SOURCE) or (T.SOURCE IS NULL and S.SOURCE IS NULL)) and
		((T.ORDER_NO = S.ORDER_NO) or (T.ORDER_NO IS NULL and S.ORDER_NO IS NULL)) and
		((T.PROCESSING_START_TIME = S.PROCESSING_START_TIME) or (T.PROCESSING_START_TIME IS NULL and S.PROCESSING_START_TIME IS NULL)) and
		((T.PROCESSING_END_TIME = S.PROCESSING_END_TIME) or (T.PROCESSING_END_TIME IS NULL and S.PROCESSING_END_TIME IS NULL)) and
		((T.OUTCOME = S.OUTCOME) or (T.OUTCOME IS NULL and S.OUTCOME IS NULL)) and
		((T.AUDIT_CREATE_DATE = S.AUDIT_CREATE_DATE) or (T.AUDIT_CREATE_DATE IS NULL and S.AUDIT_CREATE_DATE IS NULL)) and
		((T.AUDIT_MODIFIED_DATE = S.AUDIT_MODIFIED_DATE) or (T.AUDIT_MODIFIED_DATE IS NULL and S.AUDIT_MODIFIED_DATE IS NULL)) and
		((T.VERSION = S.VERSION) or (T.VERSION IS NULL and S.VERSION IS NULL)) and
		((T.CUSTOMER_ORDER_MESSAGE_KEY = S.CUSTOMER_ORDER_MESSAGE_KEY) or (T.CUSTOMER_ORDER_MESSAGE_KEY IS NULL and S.CUSTOMER_ORDER_MESSAGE_KEY IS NULL)) and
		((T.SHIPMENT_KEY = S.SHIPMENT_KEY) or (T.SHIPMENT_KEY IS NULL and S.SHIPMENT_KEY IS NULL))
        )

  
  

  

 


&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Create Index on flow table */


BEGIN  
   EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_MDP_ORDER_STG_IDX
on		RAX_APP_USER.I$_MDP_ORDER_STG (ORDER_ID)';  
 EXCEPTION  
    WHEN OTHERS THEN NULL;  
END;


&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_MDP_ORDER_STG',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* create check table */


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
	

-- &


/*-----------------------------------------------*/
/* TASK No. 15 */
/* delete previous check sum */

delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS_STAGE'
and	ORIGIN 		= '(2269001)ODS_Project.LOAD_MDP_ORDER_STG_INT'
and	ERR_TYPE 		= 'F'


&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* create error table */

BEGIN
   EXECUTE IMMEDIATE 
   'create table RAX_APP_USER.E$_MDP_ORDER_STG
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	ORDER_ID	NUMBER NULL,
	SHIPMENT_ID	NUMBER NULL,
	SOURCE	VARCHAR2(255) NULL,
	ORDER_NO	VARCHAR2(255) NULL,
	PROCESSING_START_TIME	TIMESTAMP(6) NULL,
	PROCESSING_END_TIME	TIMESTAMP(6) NULL,
	OUTCOME	VARCHAR2(255) NULL,
	AUDIT_CREATE_DATE	TIMESTAMP(6) NULL,
	AUDIT_MODIFIED_DATE	TIMESTAMP(6) NULL,
	VERSION	NUMBER NULL,
	CUSTOMER_ORDER_MESSAGE_KEY	VARCHAR2(255) NULL,
	SHIPMENT_KEY	VARCHAR2(255) NULL,
	SHIPMENT_NO	VARCHAR2(40) NULL,
	ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
	ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
	ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
	ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
	ODI_SESS_NO		VARCHAR2(19 CHAR)
)';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -955 THEN  -- ORA-00955: name is already used by an existing object
         RAISE;
      ELSE
         DBMS_OUTPUT.PUT_LINE('Table RAX_APP_USER.E$_MDP_ORDER_STG already exists.');
      END IF;
END;


&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* delete previous errors */

delete from 	RAX_APP_USER.E$_MDP_ORDER_STG
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(2269001)ODS_Project.LOAD_MDP_ORDER_STG_INT')


&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Create index on PK */

 
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */
-- create index 	RAX_APP_USER.I$_MDP_ORDER_STG_IDX
-- on	RAX_APP_USER.I$_MDP_ORDER_STG (ORDER_ID)


-- &


/*-----------------------------------------------*/
/* TASK No. 19 */
/* insert PK errors */

insert into RAX_APP_USER.E$_MDP_ORDER_STG
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
	ORDER_ID,
	SHIPMENT_ID,
	SOURCE,
	ORDER_NO,
	PROCESSING_START_TIME,
	PROCESSING_END_TIME,
	OUTCOME,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFIED_DATE,
	VERSION,
	CUSTOMER_ORDER_MESSAGE_KEY,
	SHIPMENT_KEY
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15064: The primary key MDP_ORDER_STG_PK is not unique.',
	'(2269001)ODS_Project.LOAD_MDP_ORDER_STG_INT',
	sysdate,
	'MDP_ORDER_STG_PK',
	'PK',	
	MDP_ORDER_STG.ORDER_ID,
	MDP_ORDER_STG.SHIPMENT_ID,
	MDP_ORDER_STG.SOURCE,
	MDP_ORDER_STG.ORDER_NO,
	MDP_ORDER_STG.PROCESSING_START_TIME,
	MDP_ORDER_STG.PROCESSING_END_TIME,
	MDP_ORDER_STG.OUTCOME,
	MDP_ORDER_STG.AUDIT_CREATE_DATE,
	MDP_ORDER_STG.AUDIT_MODIFIED_DATE,
	MDP_ORDER_STG.VERSION,
	MDP_ORDER_STG.CUSTOMER_ORDER_MESSAGE_KEY,
	MDP_ORDER_STG.SHIPMENT_KEY
from	RAX_APP_USER.I$_MDP_ORDER_STG   MDP_ORDER_STG
where	exists  (
		select	SUB.ORDER_ID
		from 	RAX_APP_USER.I$_MDP_ORDER_STG SUB
		where 	SUB.ORDER_ID=MDP_ORDER_STG.ORDER_ID
		group by 	SUB.ORDER_ID
		having 	count(1) > 1
		)



&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_MDP_ORDER_STG
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
	ORDER_ID,
	SHIPMENT_ID,
	SOURCE,
	ORDER_NO,
	PROCESSING_START_TIME,
	PROCESSING_END_TIME,
	OUTCOME,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFIED_DATE,
	VERSION,
	CUSTOMER_ORDER_MESSAGE_KEY,
	SHIPMENT_KEY
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column ORDER_ID cannot be null.',
	sysdate,
	'(2269001)ODS_Project.LOAD_MDP_ORDER_STG_INT',
	'ORDER_ID',
	'NN',	
	ORDER_ID,
	SHIPMENT_ID,
	SOURCE,
	ORDER_NO,
	PROCESSING_START_TIME,
	PROCESSING_END_TIME,
	OUTCOME,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFIED_DATE,
	VERSION,
	CUSTOMER_ORDER_MESSAGE_KEY,
	SHIPMENT_KEY
from	RAX_APP_USER.I$_MDP_ORDER_STG
where	ORDER_ID is null



&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* create index on error table */

 
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */

BEGIN  
   EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_MDP_ORDER_STG_IDX
on	RAX_APP_USER.E$_MDP_ORDER_STG (ODI_ROW_ID)';  
 EXCEPTION  
    WHEN OTHERS THEN NULL;  
END;


&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* delete errors from controlled table */

delete from	RAX_APP_USER.I$_MDP_ORDER_STG  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_MDP_ORDER_STG E
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
	'MDP_ORDER_STG',
	'ODS_STAGE.MDP_ORDER_STG',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_MDP_ORDER_STG E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(2269001)ODS_Project.LOAD_MDP_ORDER_STG_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE


&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* Flag rows for update */

/* DETECTION_STRATEGY = NOT_EXISTS */


update	RAX_APP_USER.I$_MDP_ORDER_STG
set	IND_UPDATE = 'U'
where	(ORDER_ID)
	in	(
		select	ORDER_ID
		from	ODS_STAGE.MDP_ORDER_STG
		)



&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* Flag useless rows */

/* DETECTION_STRATEGY = NOT_EXISTS */

/* Command skipped due to chosen DETECTION_STRATEGY */



/*-----------------------------------------------*/
/* TASK No. 26 */
/* Update existing rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
update	ODS_STAGE.MDP_ORDER_STG T
set 	
	(
	T.SHIPMENT_ID,
	T.SOURCE,
	T.ORDER_NO,
	T.PROCESSING_START_TIME,
	T.PROCESSING_END_TIME,
	T.OUTCOME,
	T.AUDIT_CREATE_DATE,
	T.AUDIT_MODIFIED_DATE,
	T.VERSION,
	T.CUSTOMER_ORDER_MESSAGE_KEY,
	T.SHIPMENT_KEY
	) =
		(
		select	S.SHIPMENT_ID,
			S.SOURCE,
			S.ORDER_NO,
			S.PROCESSING_START_TIME,
			S.PROCESSING_END_TIME,
			S.OUTCOME,
			S.AUDIT_CREATE_DATE,
			S.AUDIT_MODIFIED_DATE,
			S.VERSION,
			S.CUSTOMER_ORDER_MESSAGE_KEY,
			S.SHIPMENT_KEY
		from	RAX_APP_USER.I$_MDP_ORDER_STG S
		where	T.ORDER_ID	=S.ORDER_ID
	    	 )
	

where	(ORDER_ID)
	in	(
		select	ORDER_ID
		from	RAX_APP_USER.I$_MDP_ORDER_STG
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* Insert new rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
insert into 	ODS_STAGE.MDP_ORDER_STG T
	(
	ORDER_ID,
	SHIPMENT_ID,
	SOURCE,
	ORDER_NO,
	PROCESSING_START_TIME,
	PROCESSING_END_TIME,
	OUTCOME,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFIED_DATE,
	VERSION,
	CUSTOMER_ORDER_MESSAGE_KEY,
	SHIPMENT_KEY
	
	)
select 	ORDER_ID,
	SHIPMENT_ID,
	SOURCE,
	ORDER_NO,
	PROCESSING_START_TIME,
	PROCESSING_END_TIME,
	OUTCOME,
	AUDIT_CREATE_DATE,
	AUDIT_MODIFIED_DATE,
	VERSION,
	CUSTOMER_ORDER_MESSAGE_KEY,
	SHIPMENT_KEY
	
from	RAX_APP_USER.I$_MDP_ORDER_STG S



where	IND_UPDATE = 'I'



&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 29 */
/* Drop flow table */

drop table RAX_APP_USER.I$_MDP_ORDER_STG 

&


/*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */

drop table RAX_APP_USER.C$_0MDP_ORDER_STG purge

&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* MDP_ORDER_XR */

insert into ods_stage.mdp_order_xr
( ORDER_ID
, MDP_ORDER_OID
, ORDER_NO
, ODS_CREATE_DATE
)
select  ORDER_ID
, ods_stage.MDP_ORDER_OID_SEQ.nextval
, ORDER_NO
, sysdate
from ods_stage.mdp_order_stg s
where s.audit_modified_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap
and not exists
( 
select 1
from ods_stage.mdp_order_xr t
where s.order_id = t.order_id
)

&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* MDP_ORDER */

merge into ods_own.mdp_order t using
(
select xr.mdp_order_oid
, stg.ORDER_ID
, stg.SHIPMENT_ID
, stg.ORDER_NO
, stg.SOURCE
, stg.OUTCOME
, stg.CUSTOMER_ORDER_MESSAGE_KEY
, stg.PROCESSING_START_TIME
, stg.PROCESSING_END_TIME
, stg.AUDIT_CREATE_DATE
, stg.AUDIT_MODIFIED_DATE
, stg.VERSION
, stg.shipment_key
, ss.source_system_oid
from ods_stage.mdp_order_stg stg
, ods_stage.mdp_order_xr xr
, ods_own.source_system ss
where stg.order_id = xr.order_id
and 'MDP' = ss.source_system_short_name
and stg.audit_modified_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap
) s
on ( s.mdp_order_oid = t.mdp_order_oid )
when matched then update
set t.SHIPMENT_ID = s.SHIPMENT_ID
, t.ORDER_NO = s.ORDER_NO
, t.SOURCE = s.SOURCE
, t.OUTCOME = s.OUTCOME
, t.CUSTOMER_ORDER_MESSAGE_KEY = s.CUSTOMER_ORDER_MESSAGE_KEY
, t.PROCESSING_START_TIME = s.PROCESSING_START_TIME
, t.PROCESSING_END_TIME = s.PROCESSING_END_TIME
, t.AUDIT_CREATE_DATE = s.AUDIT_CREATE_DATE
, t.AUDIT_MODIFIED_DATE = s.AUDIT_MODIFIED_DATE
, t.VERSION = s.VERSION
, t.shipment_key = s.shipment_key
, t.ODS_MODIFY_DATE = sysdate
where decode(t.SHIPMENT_ID,s.SHIPMENT_ID,1,0) = 0
or decode(t.ORDER_NO,s.ORDER_NO,1,0) = 0
or decode(t.SOURCE,s.SOURCE,1,0) = 0
or decode(t.OUTCOME,s.OUTCOME,1,0) = 0
or decode(t.CUSTOMER_ORDER_MESSAGE_KEY,s.CUSTOMER_ORDER_MESSAGE_KEY,1,0) = 0
or decode(t.PROCESSING_START_TIME,s.PROCESSING_START_TIME,1,0) = 0
or decode(t.PROCESSING_END_TIME,s.PROCESSING_END_TIME,1,0) = 0
or decode(t.AUDIT_CREATE_DATE,s.AUDIT_CREATE_DATE,1,0) = 0
or decode(t.AUDIT_MODIFIED_DATE,s.AUDIT_MODIFIED_DATE,1,0) = 0
or decode(t.VERSION,s.VERSION,1,0) = 0
or decode(t.shipment_key,s.shipment_key,1,0) = 0
when not matched then insert
( t.MDP_ORDER_OID
, t.ORDER_ID
, t.SHIPMENT_ID
, t.ORDER_NO
, t.SOURCE
, T.OUTCOME
, t.CUSTOMER_ORDER_MESSAGE_KEY
, t.PROCESSING_START_TIME
, t.PROCESSING_END_TIME
, t.AUDIT_CREATE_DATE
, t.AUDIT_MODIFIED_DATE
, t.VERSION
, t.shipment_key
, t.ODS_CREATE_DATE
, t.ODS_MODIFY_DATE
, t.SOURCE_SYSTEM_OID
)
values
( s.MDP_ORDER_OID
, s.ORDER_ID
, s.SHIPMENT_ID
, s.ORDER_NO
, s.SOURCE
, s.OUTCOME
, s.CUSTOMER_ORDER_MESSAGE_KEY
, s.PROCESSING_START_TIME
, s.PROCESSING_END_TIME
, s.AUDIT_CREATE_DATE
, s.AUDIT_MODIFIED_DATE
, s.VERSION
, s.shipment_key
, sysdate
, sysdate
, s.SOURCE_SYSTEM_OID
)

&


/*-----------------------------------------------*/
/* TASK No. 32 */
/* update order_header_oid */

merge into ods_own.mdp_order t using
(
select xr.mdp_order_oid
, max(oh.order_header_oid) as order_header_oid
from ods_stage.mdp_order_stg stg
, ods_stage.mdp_order_xr xr
, ods_own.order_header oh
, ods_own.source_system ss
where stg.order_id = xr.order_id
and stg.order_no = oh.order_no
and 'MDP' = ss.source_system_short_name
and stg.audit_modified_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap
group by xr.mdp_order_oid
) s
on ( s.mdp_order_oid = t.mdp_order_oid )
when matched then update
set t.ORDER_HEADER_OID = s.ORDER_HEADER_OID
, t.ODS_MODIFY_DATE = sysdate
where decode(t.ORDER_HEADER_OID,s.ORDER_HEADER_OID,1,0) = 0


&


/*-----------------------------------------------*/
/* TASK No. 33 */
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
             SUBSTR('2024-06-17 13:09:21.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/

&


/*-----------------------------------------------*/
/* TASK No. 34 */
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
,'LOAD_MDP_ORDER_PKG'
,'003'
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
'LOAD_MDP_ORDER_PKG',
'003',
TO_DATE(
             SUBSTR('2024-06-17 13:09:21.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/


&


/*-----------------------------------------------*/
