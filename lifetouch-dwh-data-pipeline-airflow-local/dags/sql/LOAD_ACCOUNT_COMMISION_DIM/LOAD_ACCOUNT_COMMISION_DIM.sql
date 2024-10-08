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
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0ODS_ACC_COMM';  
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

create table RAX_APP_USER.C$_0ODS_ACC_COMM
(
	C1_ACCOUNT_COMMISSION_OID	NUMBER NULL,
	C2_PAYMENT_DATE	DATE NULL,
	C3_PAYMENT_AMOUNT	NUMBER NULL,
	C4_CURRENCY	VARCHAR2(20) NULL,
	C5_EVENT_REF_ID	VARCHAR2(255) NULL,
	C6_CHECK_NUMBER	VARCHAR2(255) NULL,
	C7_PAY_TO	VARCHAR2(255) NULL,
	C8_ACTIVITY_CODE	VARCHAR2(255) NULL,
	C9_RECONCILE_DATE	DATE NULL,
	C10_ACCT_COMM_PMT_REQ_ID	NUMBER NULL,
	C11_APO_ID	VARCHAR2(255) NULL,
	C12_STATUS	VARCHAR2(50) NULL,
	C13_PAYMENT_TYPE	VARCHAR2(255) NULL,
	C14_ACTUAL_PAYMENT_AMOUNT	NUMBER NULL,
	C15_LIFETOUCH_ID	NUMBER NULL,
	C16_SUB_PROGRAM_NAME	VARCHAR2(50) NULL,
	C17_SCHOOL_YEAR	NUMBER NULL
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Load data */

/* SOURCE CODE */
insert into RAX_APP_USER.C$_0ODS_ACC_COMM
(
	C1_ACCOUNT_COMMISSION_OID,
	C2_PAYMENT_DATE,
	C3_PAYMENT_AMOUNT,
	C4_CURRENCY,
	C5_EVENT_REF_ID,
	C6_CHECK_NUMBER,
	C7_PAY_TO,
	C8_ACTIVITY_CODE,
	C9_RECONCILE_DATE,
	C10_ACCT_COMM_PMT_REQ_ID,
	C11_APO_ID,
	C12_STATUS,
	C13_PAYMENT_TYPE,
	C14_ACTUAL_PAYMENT_AMOUNT,
	C15_LIFETOUCH_ID,
	C16_SUB_PROGRAM_NAME,
	C17_SCHOOL_YEAR
)
select	
	ACCOUNT_COMMISSION.ACCOUNT_COMMISSION_OID	   C1_ACCOUNT_COMMISSION_OID,
	ACCOUNT_COMMISSION.PAYMENT_DATE	   C2_PAYMENT_DATE,
	ACCOUNT_COMMISSION.PAYMENT_AMOUNT	   C3_PAYMENT_AMOUNT,
	ACCOUNT_COMMISSION.CURRENCY	   C4_CURRENCY,
	ACCOUNT_COMMISSION.EVENT_REF_ID	   C5_EVENT_REF_ID,
	ACCOUNT_COMMISSION.CHECK_NUMBER	   C6_CHECK_NUMBER,
	ACCOUNT_COMMISSION.PAY_TO	   C7_PAY_TO,
	ACCOUNT_COMMISSION.ACTIVITY_CODE	   C8_ACTIVITY_CODE,
	ACCOUNT_COMMISSION.RECONCILE_DATE	   C9_RECONCILE_DATE,
	ACCOUNT_COMMISSION.ACCT_COMM_PMT_REQ_ID	   C10_ACCT_COMM_PMT_REQ_ID,
	ACCOUNT_COMMISSION.APO_ID	   C11_APO_ID,
	ACCOUNT_COMMISSION.STATUS	   C12_STATUS,
	ACCOUNT_COMMISSION.PAYMENT_TYPE	   C13_PAYMENT_TYPE,
	ACCOUNT_COMMISSION.ACTUAL_PAYMENT_AMOUNT	   C14_ACTUAL_PAYMENT_AMOUNT,
	APO.LIFETOUCH_ID	   C15_LIFETOUCH_ID,
	APO.SUB_PROGRAM_OID	   C16_SUB_PROGRAM_NAME,
	NVL(APO.SCHOOL_YEAR, 1800)	   C17_SCHOOL_YEAR
from	ODS_OWN.ACCOUNT_COMMISSION   ACCOUNT_COMMISSION, ODS_OWN.APO   APO
where	(1=1)
And (ACCOUNT_COMMISSION.ODS_MODIFY_DATE >=TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_sales_ods_overlap)
 And (ACCOUNT_COMMISSION.ACCT_COMM_PMT_REQ_ID IS NOT NULL)
 And (ACCOUNT_COMMISSION.APO_OID=APO.APO_OID)


&

/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0ODS_ACC_COMM',
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

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_ODS_ACC_COMM321003';  
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

create table RAX_APP_USER.I$_ODS_ACC_COMM321003
(
	ACCOUNT_COMMISSION_OID		NUMBER NULL,
	PAYMENT_DATE		DATE NULL,
	PAYMENT_AMOUNT		NUMBER NULL,
	CURRENCY		VARCHAR2(20) NULL,
	EVENT_REF_ID		VARCHAR2(255) NULL,
	CHECK_NUMBER		VARCHAR2(255) NULL,
	PAY_TO		VARCHAR2(255) NULL,
	ACTIVITY_CODE		VARCHAR2(255) NULL,
	RECONCILE_DATE		DATE NULL,
	ACCT_COMM_PMT_REQ_ID		NUMBER NULL,
	APO_ID		VARCHAR2(255) NULL,
	STATUS		VARCHAR2(50) NULL,
	PAYMENT_TYPE		VARCHAR2(255) NULL,
	ACTUAL_PAYMENT_AMOUNT		NUMBER NULL,
	LIFETOUCH_ID		NUMBER NULL,
	SUB_PROGRAM_NAME		VARCHAR2(50) NULL,
	SCHOOL_YEAR		NUMBER NULL,
	EFFECTIVE_DATE		DATE NULL,
	ACTIVE_IND		VARCHAR2(5) NULL,
	LOAD_ID		NUMBER NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = POST_FLOW */
 


  
  
  


insert into	RAX_APP_USER.I$_ODS_ACC_COMM321003
(
	ACCOUNT_COMMISSION_OID,
	PAYMENT_DATE,
	PAYMENT_AMOUNT,
	CURRENCY,
	EVENT_REF_ID,
	CHECK_NUMBER,
	PAY_TO,
	ACTIVITY_CODE,
	RECONCILE_DATE,
	ACCT_COMM_PMT_REQ_ID,
	APO_ID,
	STATUS,
	PAYMENT_TYPE,
	ACTUAL_PAYMENT_AMOUNT,
	LIFETOUCH_ID,
	SUB_PROGRAM_NAME,
	SCHOOL_YEAR,
	IND_UPDATE
)


select 	 
	
	C1_ACCOUNT_COMMISSION_OID,
	C2_PAYMENT_DATE,
	C3_PAYMENT_AMOUNT,
	C4_CURRENCY,
	C5_EVENT_REF_ID,
	C6_CHECK_NUMBER,
	C7_PAY_TO,
	C8_ACTIVITY_CODE,
	C9_RECONCILE_DATE,
	C10_ACCT_COMM_PMT_REQ_ID,
	C11_APO_ID,
	C12_STATUS,
	C13_PAYMENT_TYPE,
	C14_ACTUAL_PAYMENT_AMOUNT,
	C15_LIFETOUCH_ID,
	C16_SUB_PROGRAM_NAME,
	C17_SCHOOL_YEAR,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0ODS_ACC_COMM
where	(1=1)






  

 


&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_ODS_ACC_COMM_IDX321003
on		RAX_APP_USER.I$_ODS_ACC_COMM321003 (ACCOUNT_COMMISSION_OID)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_ODS_ACC_COMM321003',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Flag rows for update */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_ODS_ACC_COMM321003
set	IND_UPDATE = 'U'
where	(ACCOUNT_COMMISSION_OID)
	in	(
		select	ACCOUNT_COMMISSION_OID
		from	ODS.ODS_ACCOUNT_COMMISSION
		)



&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Flag useless rows */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_ODS_ACC_COMM321003 S
set	IND_UPDATE = 'N'
where	exists (
	select 	'X'
	from 	ODS.ODS_ACCOUNT_COMMISSION 	T
	where	T.ACCOUNT_COMMISSION_OID	= S.ACCOUNT_COMMISSION_OID
		and	((T.PAYMENT_DATE = S.PAYMENT_DATE) or (T.PAYMENT_DATE IS NULL and S.PAYMENT_DATE IS NULL))
and	((T.PAYMENT_AMOUNT = S.PAYMENT_AMOUNT) or (T.PAYMENT_AMOUNT IS NULL and S.PAYMENT_AMOUNT IS NULL))
and	((T.CURRENCY = S.CURRENCY) or (T.CURRENCY IS NULL and S.CURRENCY IS NULL))
and	((T.EVENT_REF_ID = S.EVENT_REF_ID) or (T.EVENT_REF_ID IS NULL and S.EVENT_REF_ID IS NULL))
and	((T.CHECK_NUMBER = S.CHECK_NUMBER) or (T.CHECK_NUMBER IS NULL and S.CHECK_NUMBER IS NULL))
and	((T.PAY_TO = S.PAY_TO) or (T.PAY_TO IS NULL and S.PAY_TO IS NULL))
and	((T.ACTIVITY_CODE = S.ACTIVITY_CODE) or (T.ACTIVITY_CODE IS NULL and S.ACTIVITY_CODE IS NULL))
and	((T.RECONCILE_DATE = S.RECONCILE_DATE) or (T.RECONCILE_DATE IS NULL and S.RECONCILE_DATE IS NULL))
and	((T.ACCT_COMM_PMT_REQ_ID = S.ACCT_COMM_PMT_REQ_ID) or (T.ACCT_COMM_PMT_REQ_ID IS NULL and S.ACCT_COMM_PMT_REQ_ID IS NULL))
and	((T.APO_ID = S.APO_ID) or (T.APO_ID IS NULL and S.APO_ID IS NULL))
and	((T.STATUS = S.STATUS) or (T.STATUS IS NULL and S.STATUS IS NULL))
and	((T.PAYMENT_TYPE = S.PAYMENT_TYPE) or (T.PAYMENT_TYPE IS NULL and S.PAYMENT_TYPE IS NULL))
and	((T.ACTUAL_PAYMENT_AMOUNT = S.ACTUAL_PAYMENT_AMOUNT) or (T.ACTUAL_PAYMENT_AMOUNT IS NULL and S.ACTUAL_PAYMENT_AMOUNT IS NULL))
and	((T.LIFETOUCH_ID = S.LIFETOUCH_ID) or (T.LIFETOUCH_ID IS NULL and S.LIFETOUCH_ID IS NULL))
and	((T.SUB_PROGRAM_NAME = S.SUB_PROGRAM_NAME) or (T.SUB_PROGRAM_NAME IS NULL and S.SUB_PROGRAM_NAME IS NULL))
and	((T.SCHOOL_YEAR = S.SCHOOL_YEAR) or (T.SCHOOL_YEAR IS NULL and S.SCHOOL_YEAR IS NULL))
	)



&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Update existing rows */

/* DETECTION_STRATEGY = POST_FLOW */
update	ODS.ODS_ACCOUNT_COMMISSION T
set 	
	(
	T.PAYMENT_DATE,
	T.PAYMENT_AMOUNT,
	T.CURRENCY,
	T.EVENT_REF_ID,
	T.CHECK_NUMBER,
	T.PAY_TO,
	T.ACTIVITY_CODE,
	T.RECONCILE_DATE,
	T.ACCT_COMM_PMT_REQ_ID,
	T.APO_ID,
	T.STATUS,
	T.PAYMENT_TYPE,
	T.ACTUAL_PAYMENT_AMOUNT,
	T.LIFETOUCH_ID,
	T.SUB_PROGRAM_NAME,
	T.SCHOOL_YEAR
	) =
		(
		select	S.PAYMENT_DATE,
			S.PAYMENT_AMOUNT,
			S.CURRENCY,
			S.EVENT_REF_ID,
			S.CHECK_NUMBER,
			S.PAY_TO,
			S.ACTIVITY_CODE,
			S.RECONCILE_DATE,
			S.ACCT_COMM_PMT_REQ_ID,
			S.APO_ID,
			S.STATUS,
			S.PAYMENT_TYPE,
			S.ACTUAL_PAYMENT_AMOUNT,
			S.LIFETOUCH_ID,
			S.SUB_PROGRAM_NAME,
			S.SCHOOL_YEAR
		from	RAX_APP_USER.I$_ODS_ACC_COMM321003 S
		where	T.ACCOUNT_COMMISSION_OID	=S.ACCOUNT_COMMISSION_OID
	    	 )
	,                T.EFFECTIVE_DATE = SYSDATE,
	T.ACTIVE_IND = 'A',
	T.LOAD_ID = 1

where	(ACCOUNT_COMMISSION_OID)
	in	(
		select	ACCOUNT_COMMISSION_OID
		from	RAX_APP_USER.I$_ODS_ACC_COMM321003
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Insert new rows */

/* DETECTION_STRATEGY = POST_FLOW */
insert into 	ODS.ODS_ACCOUNT_COMMISSION T
	(
	ACCOUNT_COMMISSION_OID,
	PAYMENT_DATE,
	PAYMENT_AMOUNT,
	CURRENCY,
	EVENT_REF_ID,
	CHECK_NUMBER,
	PAY_TO,
	ACTIVITY_CODE,
	RECONCILE_DATE,
	ACCT_COMM_PMT_REQ_ID,
	APO_ID,
	STATUS,
	PAYMENT_TYPE,
	ACTUAL_PAYMENT_AMOUNT,
	LIFETOUCH_ID,
	SUB_PROGRAM_NAME,
	SCHOOL_YEAR
	,                 EFFECTIVE_DATE,
	ACTIVE_IND,
	LOAD_ID
	)
select 	ACCOUNT_COMMISSION_OID,
	PAYMENT_DATE,
	PAYMENT_AMOUNT,
	CURRENCY,
	EVENT_REF_ID,
	CHECK_NUMBER,
	PAY_TO,
	ACTIVITY_CODE,
	RECONCILE_DATE,
	ACCT_COMM_PMT_REQ_ID,
	APO_ID,
	STATUS,
	PAYMENT_TYPE,
	ACTUAL_PAYMENT_AMOUNT,
	LIFETOUCH_ID,
	SUB_PROGRAM_NAME,
	SCHOOL_YEAR
	,                 SYSDATE,
	'A',
	1
from	RAX_APP_USER.I$_ODS_ACC_COMM321003 S



where	IND_UPDATE = 'I'



&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 20 */
/* Drop flow table */

drop table RAX_APP_USER.I$_ODS_ACC_COMM321003 

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* sub-select inline view */

-- (


-- select 	 
	
-- 	C1_ACCOUNT_COMMISSION_OID    ACCOUNT_COMMISSION_OID,
-- 	C2_PAYMENT_DATE    PAYMENT_DATE,
-- 	C3_PAYMENT_AMOUNT    PAYMENT_AMOUNT,
-- 	C4_CURRENCY    CURRENCY,
-- 	C5_EVENT_REF_ID    EVENT_REF_ID,
-- 	C6_CHECK_NUMBER    CHECK_NUMBER,
-- 	C7_PAY_TO    PAY_TO,
-- 	C8_ACTIVITY_CODE    ACTIVITY_CODE,
-- 	C9_RECONCILE_DATE    RECONCILE_DATE,
-- 	C10_ACCT_COMM_PMT_REQ_ID    ACCT_COMM_PMT_REQ_ID,
-- 	C11_APO_ID    APO_ID,
-- 	C12_STATUS    STATUS,
-- 	C13_PAYMENT_TYPE    PAYMENT_TYPE,
-- 	C14_ACTUAL_PAYMENT_AMOUNT    ACTUAL_PAYMENT_AMOUNT,
-- 	C15_LIFETOUCH_ID    LIFETOUCH_ID,
-- 	C16_SUB_PROGRAM_NAME    SUB_PROGRAM_NAME,
-- 	C17_SCHOOL_YEAR    SCHOOL_YEAR,
-- 	SYSDATE    EFFECTIVE_DATE,
-- 	'A'    ACTIVE_IND,
-- 	1    LOAD_ID
-- from	RAX_APP_USER.C$_0ODS_ACC_COMM
-- where	(1=1)





-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */

drop table RAX_APP_USER.C$_0ODS_ACC_COMM 

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* Update CDC Load Status */

UPDATE ODS.DW_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE DW_TABLE_NAME=:v_cdc_load_table_name

&


/*-----------------------------------------------*/
