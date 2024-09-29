/* TASK No. 1 */
/* Drop work table */

-- drop table RAX_APP_USER.C$_0OMS_LT_SHIP_PROP_STG 

-- &


/*-----------------------------------------------*/
/* TASK No. 2 */
/* Create work table */

-- create table RAX_APP_USER.C$_0OMS_LT_SHIP_PROP_STG
-- (
-- 	C1_BATCH_SHIP_PROP_KEY	CHAR(24) NULL,
-- 	C2_BATCH_ID	VARCHAR2(20) NULL,
-- 	C3_SHIP_NODE	CHAR(24) NULL,
-- 	C4_SHIP_PROP_ID	VARCHAR2(40) NULL,
-- 	C5_STATUS	VARCHAR2(20) NULL,
-- 	C6_CREATETS	DATE NULL,
-- 	C7_MODIFYTS	DATE NULL,
-- 	C8_CREATEUSERID	VARCHAR2(40) NULL,
-- 	C9_MODIFYUSERID	VARCHAR2(40) NULL,
-- 	C10_CREATEPROGID	VARCHAR2(40) NULL,
-- 	C11_MODIFYPROGID	VARCHAR2(40) NULL,
-- 	C12_LOCKID	NUMBER(5) NULL
-- )
-- NOLOGGING

-- &


/*-----------------------------------------------*/
/* TASK No. 3 */
/* Load data */

/* SOURCE CODE */
-- select	
-- 	LT_BATCH_SHIP_PROP.BATCH_SHIP_PROP_KEY	   C1_BATCH_SHIP_PROP_KEY,
-- 	LT_BATCH_SHIP_PROP.BATCH_ID	   C2_BATCH_ID,
-- 	LT_BATCH_SHIP_PROP.SHIP_NODE	   C3_SHIP_NODE,
-- 	LT_BATCH_SHIP_PROP.SHIP_PROP_ID	   C4_SHIP_PROP_ID,
-- 	LT_BATCH_SHIP_PROP.STATUS	   C5_STATUS,
-- 	LT_BATCH_SHIP_PROP.CREATETS	   C6_CREATETS,
-- 	LT_BATCH_SHIP_PROP.MODIFYTS	   C7_MODIFYTS,
-- 	LT_BATCH_SHIP_PROP.CREATEUSERID	   C8_CREATEUSERID,
-- 	LT_BATCH_SHIP_PROP.MODIFYUSERID	   C9_MODIFYUSERID,
-- 	LT_BATCH_SHIP_PROP.CREATEPROGID	   C10_CREATEPROGID,
-- 	LT_BATCH_SHIP_PROP.MODIFYPROGID	   C11_MODIFYPROGID,
-- 	LT_BATCH_SHIP_PROP.LOCKID	   C12_LOCKID
-- from	OMS3_OWN.LT_BATCH_SHIP_PROP   LT_BATCH_SHIP_PROP
-- where	(1=1)
-- And (LT_BATCH_SHIP_PROP.MODIFYTS >= ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))





-- &

/* TARGET CODE */
-- insert into RAX_APP_USER.C$_0OMS_LT_SHIP_PROP_STG
-- (
-- 	C1_BATCH_SHIP_PROP_KEY,
-- 	C2_BATCH_ID,
-- 	C3_SHIP_NODE,
-- 	C4_SHIP_PROP_ID,
-- 	C5_STATUS,
-- 	C6_CREATETS,
-- 	C7_MODIFYTS,
-- 	C8_CREATEUSERID,
-- 	C9_MODIFYUSERID,
-- 	C10_CREATEPROGID,
-- 	C11_MODIFYPROGID,
-- 	C12_LOCKID
-- )
-- values
-- (
-- 	:C1_BATCH_SHIP_PROP_KEY,
-- 	:C2_BATCH_ID,
-- 	:C3_SHIP_NODE,
-- 	:C4_SHIP_PROP_ID,
-- 	:C5_STATUS,
-- 	:C6_CREATETS,
-- 	:C7_MODIFYTS,
-- 	:C8_CREATEUSERID,
-- 	:C9_MODIFYUSERID,
-- 	:C10_CREATEPROGID,
-- 	:C11_MODIFYPROGID,
-- 	:C12_LOCKID
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 4 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0OMS_LT_SHIP_PROP_STG',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;




&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 6 */




/*-----------------------------------------------*/
/* TASK No. 7 */
/* Drop flow table */
BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_OMS_LT_SHIP_PROP_STG758001 ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;


&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_OMS_LT_SHIP_PROP_STG758001
(
	BATCH_SHIP_PROP_KEY		CHAR(24) NULL,
	BATCH_ID		VARCHAR2(20) NULL,
	SHIP_NODE		CHAR(24) NULL,
	SHIP_PROP_ID		VARCHAR2(40) NULL,
	STATUS		VARCHAR2(20) NULL,
	CREATETS		DATE NULL,
	MODIFYTS		DATE NULL,
	CREATEUSERID		VARCHAR2(40) NULL,
	MODIFYUSERID		VARCHAR2(40) NULL,
	CREATEPROGID		VARCHAR2(40) NULL,
	MODIFYPROGID		VARCHAR2(40) NULL,
	LOCKID		NUMBER(5) NULL,
	ODS_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = POST_FLOW */
 


  
  
  


insert into	RAX_APP_USER.I$_OMS_LT_SHIP_PROP_STG758001
(
	BATCH_SHIP_PROP_KEY,
	BATCH_ID,
	SHIP_NODE,
	SHIP_PROP_ID,
	STATUS,
	CREATETS,
	MODIFYTS,
	CREATEUSERID,
	MODIFYUSERID,
	CREATEPROGID,
	MODIFYPROGID,
	LOCKID,
	IND_UPDATE
)


select 	 
	
	C1_BATCH_SHIP_PROP_KEY,
	C2_BATCH_ID,
	C3_SHIP_NODE,
	C4_SHIP_PROP_ID,
	C5_STATUS,
	C6_CREATETS,
	C7_MODIFYTS,
	C8_CREATEUSERID,
	C9_MODIFYUSERID,
	C10_CREATEPROGID,
	C11_MODIFYPROGID,
	C12_LOCKID,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0OMS_LT_SHIP_PROP_STG
where	(1=1)






  

 


&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Create Index on flow table */

-- create index	RAX_APP_USER.I$_OMS_LT_SHIP_PROP_STG_IDX758001
-- on		RAX_APP_USER.I$_OMS_LT_SHIP_PROP_STG758001 (BATCH_SHIP_PROP_KEY)
-- NOLOGGING

BEGIN
   EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_OMS_LT_SHIP_PROP_STG_IDX758001
on		RAX_APP_USER.I$_OMS_LT_SHIP_PROP_STG758001 (BATCH_SHIP_PROP_KEY)';
EXCEPTION
   WHEN OTHERS THEN
      -- Handle the case where the identifier is too long (ORA-00972)
      IF SQLCODE = -972 THEN
         DBMS_OUTPUT.PUT_LINE('Identifier is too long. Skipping creation of index.');
      ELSE
         RAISE;
      END IF;
END;


&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_OMS_LT_SHIP_PROP_STG758001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Flag rows for update */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_OMS_LT_SHIP_PROP_STG758001
set	IND_UPDATE = 'U'
where	(BATCH_SHIP_PROP_KEY)
	in	(
		select	BATCH_SHIP_PROP_KEY
		from	ODS_STAGE.OMS_LT_SHIP_PROP_STG
		)



&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Flag useless rows */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_OMS_LT_SHIP_PROP_STG758001 S
set	IND_UPDATE = 'N'
where	exists (
	select 	'X'
	from 	ODS_STAGE.OMS_LT_SHIP_PROP_STG 	T
	where	T.BATCH_SHIP_PROP_KEY	= S.BATCH_SHIP_PROP_KEY
		and	((T.BATCH_ID = S.BATCH_ID) or (T.BATCH_ID IS NULL and S.BATCH_ID IS NULL))
and	((T.SHIP_NODE = S.SHIP_NODE) or (T.SHIP_NODE IS NULL and S.SHIP_NODE IS NULL))
and	((T.SHIP_PROP_ID = S.SHIP_PROP_ID) or (T.SHIP_PROP_ID IS NULL and S.SHIP_PROP_ID IS NULL))
and	((T.STATUS = S.STATUS) or (T.STATUS IS NULL and S.STATUS IS NULL))
and	((T.CREATETS = S.CREATETS) or (T.CREATETS IS NULL and S.CREATETS IS NULL))
and	((T.MODIFYTS = S.MODIFYTS) or (T.MODIFYTS IS NULL and S.MODIFYTS IS NULL))
and	((T.CREATEUSERID = S.CREATEUSERID) or (T.CREATEUSERID IS NULL and S.CREATEUSERID IS NULL))
and	((T.MODIFYUSERID = S.MODIFYUSERID) or (T.MODIFYUSERID IS NULL and S.MODIFYUSERID IS NULL))
and	((T.CREATEPROGID = S.CREATEPROGID) or (T.CREATEPROGID IS NULL and S.CREATEPROGID IS NULL))
and	((T.MODIFYPROGID = S.MODIFYPROGID) or (T.MODIFYPROGID IS NULL and S.MODIFYPROGID IS NULL))
and	((T.LOCKID = S.LOCKID) or (T.LOCKID IS NULL and S.LOCKID IS NULL))
	)



&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Update existing rows */

/* DETECTION_STRATEGY = POST_FLOW */
update	ODS_STAGE.OMS_LT_SHIP_PROP_STG T
set 	
	(
	T.BATCH_ID,
	T.SHIP_NODE,
	T.SHIP_PROP_ID,
	T.STATUS,
	T.CREATETS,
	T.MODIFYTS,
	T.CREATEUSERID,
	T.MODIFYUSERID,
	T.CREATEPROGID,
	T.MODIFYPROGID,
	T.LOCKID
	) =
		(
		select	S.BATCH_ID,
			S.SHIP_NODE,
			S.SHIP_PROP_ID,
			S.STATUS,
			S.CREATETS,
			S.MODIFYTS,
			S.CREATEUSERID,
			S.MODIFYUSERID,
			S.CREATEPROGID,
			S.MODIFYPROGID,
			S.LOCKID
		from	RAX_APP_USER.I$_OMS_LT_SHIP_PROP_STG758001 S
		where	T.BATCH_SHIP_PROP_KEY	=S.BATCH_SHIP_PROP_KEY
	    	 )
	,           T.ODS_MODIFY_DATE = SYSDATE

where	(BATCH_SHIP_PROP_KEY)
	in	(
		select	BATCH_SHIP_PROP_KEY
		from	RAX_APP_USER.I$_OMS_LT_SHIP_PROP_STG758001
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Insert new rows */

/* DETECTION_STRATEGY = POST_FLOW */
insert into 	ODS_STAGE.OMS_LT_SHIP_PROP_STG T
	(
	BATCH_SHIP_PROP_KEY,
	BATCH_ID,
	SHIP_NODE,
	SHIP_PROP_ID,
	STATUS,
	CREATETS,
	MODIFYTS,
	CREATEUSERID,
	MODIFYUSERID,
	CREATEPROGID,
	MODIFYPROGID,
	LOCKID
	,            ODS_CREATE_DATE,
	ODS_MODIFY_DATE
	)
select 	BATCH_SHIP_PROP_KEY,
	BATCH_ID,
	SHIP_NODE,
	SHIP_PROP_ID,
	STATUS,
	CREATETS,
	MODIFYTS,
	CREATEUSERID,
	MODIFYUSERID,
	CREATEPROGID,
	MODIFYPROGID,
	LOCKID
	,            SYSDATE,
	SYSDATE
from	RAX_APP_USER.I$_OMS_LT_SHIP_PROP_STG758001 S



where	IND_UPDATE = 'I'



&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Drop flow table */

drop table RAX_APP_USER.I$_OMS_LT_SHIP_PROP_STG758001 

&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* sub-select inline view */

(


select 	 
	
	C1_BATCH_SHIP_PROP_KEY    BATCH_SHIP_PROP_KEY,
	C2_BATCH_ID    BATCH_ID,
	C3_SHIP_NODE    SHIP_NODE,
	C4_SHIP_PROP_ID    SHIP_PROP_ID,
	C5_STATUS    STATUS,
	C6_CREATETS    CREATETS,
	C7_MODIFYTS    MODIFYTS,
	C8_CREATEUSERID    CREATEUSERID,
	C9_MODIFYUSERID    MODIFYUSERID,
	C10_CREATEPROGID    CREATEPROGID,
	C11_MODIFYPROGID    MODIFYPROGID,
	C12_LOCKID    LOCKID,
	SYSDATE    ODS_CREATE_DATE,
	SYSDATE    ODS_MODIFY_DATE
from	RAX_APP_USER.C$_0OMS_LT_SHIP_PROP_STG
where	(1=1)





)

&


/*-----------------------------------------------*/
/* TASK No. 1000005 */
/* Drop work table */

drop table RAX_APP_USER.C$_0OMS_LT_SHIP_PROP_STG 

&


/*-----------------------------------------------*/
