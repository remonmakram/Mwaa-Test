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

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 4 */




/*-----------------------------------------------*/
/* TASK No. 5 */
/* Drop work table */

-- drop table RAX_APP_USER.C$_0BTA_JOB_BAG_STG purge

-- &


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Create work table */

-- create table RAX_APP_USER.C$_0BTA_JOB_BAG_STG
-- (
-- 	C1_ID	NUMBER(19) NULL,
-- 	C2_VERSION	NUMBER(19) NULL,
-- 	C3_JOB_NUMBER	VARCHAR2(255) NULL,
-- 	C4_CREATED_BY	VARCHAR2(255) NULL,
-- 	C5_UPDATED_BY	VARCHAR2(255) NULL,
-- 	C6_DATE_CREATED	DATE NULL,
-- 	C7_LAST_UPDATED	DATE NULL,
-- 	C8_EVENT_NAME	VARCHAR2(255) NULL,
-- 	C9_PROCESSED_AT	VARCHAR2(255) NULL,
-- 	C10_RECEIVE_PROCESSED_AT	VARCHAR2(255) NULL,
-- 	C11_TRACKING_NUMBER	VARCHAR2(255) NULL,
-- 	C12_JOB_BAG_STATUS	VARCHAR2(255) NULL,
-- 	C13_CHECKED_IN_COMMENT	VARCHAR2(255) NULL,
-- 	C14_CHECKED_OUT_COMMENT	VARCHAR2(255) NULL,
-- 	C15_CHECKED_IN	DATE NULL,
-- 	C16_CHECKED_OUT	DATE NULL,
-- 	C17_TRACKING_COMMENTS	VARCHAR2(255) NULL,
-- 	C18_CHECKED_IN_PHOTOGRAPHER	VARCHAR2(255) NULL,
-- 	C19_CHECKED_OUT_PHOTOGRAPHER	VARCHAR2(255) NULL
-- )
-- NOLOGGING

-- &


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Load data */

/* SOURCE CODE */


-- select	
-- 	JOB_BAG.ID	   C1_ID,
-- 	JOB_BAG.VERSION	   C2_VERSION,
-- 	JOB_BAG.JOB_NUMBER	   C3_JOB_NUMBER,
-- 	JOB_BAG.CREATED_BY	   C4_CREATED_BY,
-- 	JOB_BAG.UPDATED_BY	   C5_UPDATED_BY,
-- 	JOB_BAG.DATE_CREATED	   C6_DATE_CREATED,
-- 	JOB_BAG.LAST_UPDATED	   C7_LAST_UPDATED,
-- 	JOB_BAG.EVENT_NAME	   C8_EVENT_NAME,
-- 	JOB_BAG.PROCESSED_AT	   C9_PROCESSED_AT,
-- 	JOB_BAG.RECEIVE_PROCESSED_AT	   C10_RECEIVE_PROCESSED_AT,
-- 	JOB_BAG.TRACKING_NUMBER	   C11_TRACKING_NUMBER,
-- 	JOB_BAG.JOB_BAG_STATUS	   C12_JOB_BAG_STATUS,
-- 	JOB_BAG.CHECKED_IN_COMMENT	   C13_CHECKED_IN_COMMENT,
-- 	JOB_BAG.CHECKED_OUT_COMMENT	   C14_CHECKED_OUT_COMMENT,
-- 	JOB_BAG.CHECKED_IN	   C15_CHECKED_IN,
-- 	JOB_BAG.CHECKED_OUT	   C16_CHECKED_OUT,
-- 	JOB_BAG.TRACKING_COMMENTS	   C17_TRACKING_COMMENTS,
-- 	JOB_BAG.CHECKED_IN_PHOTOGRAPHER	   C18_CHECKED_IN_PHOTOGRAPHER,
-- 	JOB_BAG.CHECKED_OUT_PHOTOGRAPHER	   C19_CHECKED_OUT_PHOTOGRAPHER
-- from	BTA_OWN.JOB_BAG   JOB_BAG
-- where	(1=1)
-- And (JOB_BAG.LAST_UPDATED >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap)







-- &

/* TARGET CODE */
-- insert /*+ append */ into RAX_APP_USER.C$_0BTA_JOB_BAG_STG
-- (
-- 	C1_ID,
-- 	C2_VERSION,
-- 	C3_JOB_NUMBER,
-- 	C4_CREATED_BY,
-- 	C5_UPDATED_BY,
-- 	C6_DATE_CREATED,
-- 	C7_LAST_UPDATED,
-- 	C8_EVENT_NAME,
-- 	C9_PROCESSED_AT,
-- 	C10_RECEIVE_PROCESSED_AT,
-- 	C11_TRACKING_NUMBER,
-- 	C12_JOB_BAG_STATUS,
-- 	C13_CHECKED_IN_COMMENT,
-- 	C14_CHECKED_OUT_COMMENT,
-- 	C15_CHECKED_IN,
-- 	C16_CHECKED_OUT,
-- 	C17_TRACKING_COMMENTS,
-- 	C18_CHECKED_IN_PHOTOGRAPHER,
-- 	C19_CHECKED_OUT_PHOTOGRAPHER
-- )
-- values
-- (
-- 	:C1_ID,
-- 	:C2_VERSION,
-- 	:C3_JOB_NUMBER,
-- 	:C4_CREATED_BY,
-- 	:C5_UPDATED_BY,
-- 	:C6_DATE_CREATED,
-- 	:C7_LAST_UPDATED,
-- 	:C8_EVENT_NAME,
-- 	:C9_PROCESSED_AT,
-- 	:C10_RECEIVE_PROCESSED_AT,
-- 	:C11_TRACKING_NUMBER,
-- 	:C12_JOB_BAG_STATUS,
-- 	:C13_CHECKED_IN_COMMENT,
-- 	:C14_CHECKED_OUT_COMMENT,
-- 	:C15_CHECKED_IN,
-- 	:C16_CHECKED_OUT,
-- 	:C17_TRACKING_COMMENTS,
-- 	:C18_CHECKED_IN_PHOTOGRAPHER,
-- 	:C19_CHECKED_OUT_PHOTOGRAPHER
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0BTA_JOB_BAG_STG',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;




&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Drop flow table */


BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_BTA_JOB_BAG_STG';
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

create table RAX_APP_USER.I$_BTA_JOB_BAG_STG
(
	ID	NUMBER(19) NULL,
	VERSION	NUMBER(19) NULL,
	JOB_NUMBER	VARCHAR2(255) NULL,
	CREATED_BY	VARCHAR2(255) NULL,
	UPDATED_BY	VARCHAR2(255) NULL,
	DATE_CREATED	DATE NULL,
	LAST_UPDATED	DATE NULL,
	EVENT_NAME	VARCHAR2(255) NULL,
	PROCESSED_AT	VARCHAR2(255) NULL,
	RECEIVE_PROCESSED_AT	VARCHAR2(255) NULL,
	TRACKING_NUMBER	VARCHAR2(255) NULL,
	JOB_BAG_STATUS	VARCHAR2(255) NULL,
	CHECKED_IN_COMMENT	VARCHAR2(255) NULL,
	CHECKED_OUT_COMMENT	VARCHAR2(255) NULL,
	CHECKED_IN	DATE NULL,
	CHECKED_OUT	DATE NULL,
	TRACKING_COMMENTS	VARCHAR2(255) NULL,
	CHECKED_IN_PHOTOGRAPHER	VARCHAR2(255) NULL,
	CHECKED_OUT_PHOTOGRAPHER	VARCHAR2(255) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert flow into I$ table */

insert /*+ APPEND */  into RAX_APP_USER.I$_BTA_JOB_BAG_STG
	(
	ID,
	VERSION,
	JOB_NUMBER,
	CREATED_BY,
	UPDATED_BY,
	DATE_CREATED,
	LAST_UPDATED,
	EVENT_NAME,
	PROCESSED_AT,
	RECEIVE_PROCESSED_AT,
	TRACKING_NUMBER,
	JOB_BAG_STATUS,
	CHECKED_IN_COMMENT,
	CHECKED_OUT_COMMENT,
	CHECKED_IN,
	CHECKED_OUT,
	TRACKING_COMMENTS,
	CHECKED_IN_PHOTOGRAPHER,
	CHECKED_OUT_PHOTOGRAPHER
	,IND_UPDATE
	)


select 	 
	
	C1_ID,
	C2_VERSION,
	C3_JOB_NUMBER,
	C4_CREATED_BY,
	C5_UPDATED_BY,
	C6_DATE_CREATED,
	C7_LAST_UPDATED,
	C8_EVENT_NAME,
	C9_PROCESSED_AT,
	C10_RECEIVE_PROCESSED_AT,
	C11_TRACKING_NUMBER,
	C12_JOB_BAG_STATUS,
	C13_CHECKED_IN_COMMENT,
	C14_CHECKED_OUT_COMMENT,
	C15_CHECKED_IN,
	C16_CHECKED_OUT,
	C17_TRACKING_COMMENTS,
	C18_CHECKED_IN_PHOTOGRAPHER,
	C19_CHECKED_OUT_PHOTOGRAPHER,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0BTA_JOB_BAG_STG
where	(1=1)






minus
select
	ID,
	VERSION,
	JOB_NUMBER,
	CREATED_BY,
	UPDATED_BY,
	DATE_CREATED,
	LAST_UPDATED,
	EVENT_NAME,
	PROCESSED_AT,
	RECEIVE_PROCESSED_AT,
	TRACKING_NUMBER,
	JOB_BAG_STATUS,
	CHECKED_IN_COMMENT,
	CHECKED_OUT_COMMENT,
	CHECKED_IN,
	CHECKED_OUT,
	TRACKING_COMMENTS,
	CHECKED_IN_PHOTOGRAPHER,
	CHECKED_OUT_PHOTOGRAPHER
	,'I'	IND_UPDATE
from	ODS_STAGE.BTA_JOB_BAG_STG

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_BTA_JOB_BAG_STG',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Create Index on flow table */


create index	RAX_APP_USER.I$_BTA_JOB_BAG_STG_IDX
on		RAX_APP_USER.I$_BTA_JOB_BAG_STG (ID)
NOLOGGING


&

/*-----------------------------------------------*/
/* TASK No. 15 */
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


BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.SNP_CHECK_TAB';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&

BEGIN
   EXECUTE IMMEDIATE '
      create table RAX_APP_USER.SNP_CHECK_TAB
        (
            CATALOG_NAME    VARCHAR2(100 CHAR) NULL ,
            SCHEMA_NAME VARCHAR2(100 CHAR) NULL ,
            RESOURCE_NAME   VARCHAR2(100 CHAR) NULL,
            FULL_RES_NAME   VARCHAR2(100 CHAR) NULL,
            ERR_TYPE        VARCHAR2(1 CHAR) NULL,
            ERR_MESS        VARCHAR2(250 CHAR) NULL ,
            CHECK_DATE  DATE NULL,
            ORIGIN      VARCHAR2(100 CHAR) NULL,
            CONS_NAME   VARCHAR2(35 CHAR) NULL,
            CONS_TYPE       VARCHAR2(2 CHAR) NULL,
            ERR_COUNT       NUMBER(10) NULL
        )
   ';
END;


&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* delete previous check sum */

delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS_STAGE'
and	ORIGIN 		= '(1491001)ODS_Project.LOAD_STAGING_BTA_JOB_BAG_INT'
and	ERR_TYPE 		= 'F'


&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* create error table */

BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.E$_BTA_JOB_BAG_STG';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&

create table RAX_APP_USER.E$_BTA_JOB_BAG_STG
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	ID	NUMBER(19) NULL,
	VERSION	NUMBER(19) NULL,
	JOB_NUMBER	VARCHAR2(255) NULL,
	CREATED_BY	VARCHAR2(255) NULL,
	UPDATED_BY	VARCHAR2(255) NULL,
	DATE_CREATED	DATE NULL,
	LAST_UPDATED	DATE NULL,
	EVENT_NAME	VARCHAR2(255) NULL,
	PROCESSED_AT	VARCHAR2(255) NULL,
	RECEIVE_PROCESSED_AT	VARCHAR2(255) NULL,
	TRACKING_NUMBER	VARCHAR2(255) NULL,
	JOB_BAG_STATUS	VARCHAR2(255) NULL,
	CHECKED_IN_COMMENT	VARCHAR2(255) NULL,
	CHECKED_OUT_COMMENT	VARCHAR2(255) NULL,
	CHECKED_IN	DATE NULL,
	CHECKED_OUT	DATE NULL,
	TRACKING_COMMENTS	VARCHAR2(255) NULL,
	CHECKED_IN_PHOTOGRAPHER	VARCHAR2(255) NULL,
	CHECKED_OUT_PHOTOGRAPHER	VARCHAR2(255) NULL,
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

delete from 	RAX_APP_USER.E$_BTA_JOB_BAG_STG
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(1491001)ODS_Project.LOAD_STAGING_BTA_JOB_BAG_INT')


&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* create index on error table */

 
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */


create index 	RAX_APP_USER.E$_BTA_JOB_BAG_STG_IDX
on	RAX_APP_USER.E$_BTA_JOB_BAG_STG (ODI_ROW_ID)

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* delete errors from controlled table */

delete from	RAX_APP_USER.I$_BTA_JOB_BAG_STG  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_BTA_JOB_BAG_STG E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)


&


/*-----------------------------------------------*/
/* TASK No. 21 */
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
	'BTA_JOB_BAG_STG',
	'ODS_STAGE.BTA_JOB_BAG_STG',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_BTA_JOB_BAG_STG E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(1491001)ODS_Project.LOAD_STAGING_BTA_JOB_BAG_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE


&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* Merge Rows */

merge into	ODS_STAGE.BTA_JOB_BAG_STG T
using	RAX_APP_USER.I$_BTA_JOB_BAG_STG S
on	(
		T.ID=S.ID
	)
when matched
then update set
	T.VERSION	= S.VERSION,
	T.JOB_NUMBER	= S.JOB_NUMBER,
	T.CREATED_BY	= S.CREATED_BY,
	T.UPDATED_BY	= S.UPDATED_BY,
	T.DATE_CREATED	= S.DATE_CREATED,
	T.LAST_UPDATED	= S.LAST_UPDATED,
	T.EVENT_NAME	= S.EVENT_NAME,
	T.PROCESSED_AT	= S.PROCESSED_AT,
	T.RECEIVE_PROCESSED_AT	= S.RECEIVE_PROCESSED_AT,
	T.TRACKING_NUMBER	= S.TRACKING_NUMBER,
	T.JOB_BAG_STATUS	= S.JOB_BAG_STATUS,
	T.CHECKED_IN_COMMENT	= S.CHECKED_IN_COMMENT,
	T.CHECKED_OUT_COMMENT	= S.CHECKED_OUT_COMMENT,
	T.CHECKED_IN	= S.CHECKED_IN,
	T.CHECKED_OUT	= S.CHECKED_OUT,
	T.TRACKING_COMMENTS	= S.TRACKING_COMMENTS,
	T.CHECKED_IN_PHOTOGRAPHER	= S.CHECKED_IN_PHOTOGRAPHER,
	T.CHECKED_OUT_PHOTOGRAPHER	= S.CHECKED_OUT_PHOTOGRAPHER
	,                  T.ODS_MODIFY_DATE	= sysdate
when not matched
then insert
	(
	T.ID,
	T.VERSION,
	T.JOB_NUMBER,
	T.CREATED_BY,
	T.UPDATED_BY,
	T.DATE_CREATED,
	T.LAST_UPDATED,
	T.EVENT_NAME,
	T.PROCESSED_AT,
	T.RECEIVE_PROCESSED_AT,
	T.TRACKING_NUMBER,
	T.JOB_BAG_STATUS,
	T.CHECKED_IN_COMMENT,
	T.CHECKED_OUT_COMMENT,
	T.CHECKED_IN,
	T.CHECKED_OUT,
	T.TRACKING_COMMENTS,
	T.CHECKED_IN_PHOTOGRAPHER,
	T.CHECKED_OUT_PHOTOGRAPHER
	,                   T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.ID,
	S.VERSION,
	S.JOB_NUMBER,
	S.CREATED_BY,
	S.UPDATED_BY,
	S.DATE_CREATED,
	S.LAST_UPDATED,
	S.EVENT_NAME,
	S.PROCESSED_AT,
	S.RECEIVE_PROCESSED_AT,
	S.TRACKING_NUMBER,
	S.JOB_BAG_STATUS,
	S.CHECKED_IN_COMMENT,
	S.CHECKED_OUT_COMMENT,
	S.CHECKED_IN,
	S.CHECKED_OUT,
	S.TRACKING_COMMENTS,
	S.CHECKED_IN_PHOTOGRAPHER,
	S.CHECKED_OUT_PHOTOGRAPHER
	,                   sysdate,
	sysdate
	)

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 24 */
/* Drop flow table */

drop table RAX_APP_USER.I$_BTA_JOB_BAG_STG 

&


/*-----------------------------------------------*/
/* TASK No. 1000009 */
/* Drop work table */

drop table RAX_APP_USER.C$_0BTA_JOB_BAG_STG purge

&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* Drop work table */

-- drop table RAX_APP_USER.C$_0BTA_TMPR_EVID_DETS_STG purge

-- &


/*-----------------------------------------------*/
/* TASK No. 26 */
/* Create work table */

-- create table RAX_APP_USER.C$_0BTA_TMPR_EVID_DETS_STG
-- (
-- 	C1_ID	NUMBER(19) NULL,
-- 	C2_VERSION	NUMBER(19) NULL,
-- 	C3_COMMENTS	VARCHAR2(255) NULL,
-- 	C4_JOB_NUMBER	VARCHAR2(255) NULL,
-- 	C5_PHOTOGRAPHY_ID	VARCHAR2(255) NULL,
-- 	C6_TE_BAGS	VARCHAR2(255) NULL,
-- 	C7_STATUS	VARCHAR2(50) NULL,
-- 	C8_CREATED_BY	VARCHAR2(255) NULL,
-- 	C9_UPDATED_BY	VARCHAR2(255) NULL,
-- 	C10_DATE_CREATED	DATE NULL,
-- 	C11_LAST_UPDATED	DATE NULL,
-- 	C12_EVENT_NAME	VARCHAR2(255) NULL,
-- 	C13_TRACKING_NUMBER	VARCHAR2(255) NULL
-- )
-- NOLOGGING

-- &


/*-----------------------------------------------*/
/* TASK No. 27 */
/* Load data */

/* SOURCE CODE */


-- select	
-- 	TAMPER_EVIDENT_DETAILS.ID	   C1_ID,
-- 	TAMPER_EVIDENT_DETAILS.VERSION	   C2_VERSION,
-- 	TAMPER_EVIDENT_DETAILS.COMMENTS	   C3_COMMENTS,
-- 	TAMPER_EVIDENT_DETAILS.JOB_NUMBER	   C4_JOB_NUMBER,
-- 	TAMPER_EVIDENT_DETAILS.PHOTOGRAPHY_ID	   C5_PHOTOGRAPHY_ID,
-- 	TAMPER_EVIDENT_DETAILS.TE_BAGS	   C6_TE_BAGS,
-- 	TAMPER_EVIDENT_DETAILS.STATUS	   C7_STATUS,
-- 	TAMPER_EVIDENT_DETAILS.CREATED_BY	   C8_CREATED_BY,
-- 	TAMPER_EVIDENT_DETAILS.UPDATED_BY	   C9_UPDATED_BY,
-- 	TAMPER_EVIDENT_DETAILS.DATE_CREATED	   C10_DATE_CREATED,
-- 	TAMPER_EVIDENT_DETAILS.LAST_UPDATED	   C11_LAST_UPDATED,
-- 	TAMPER_EVIDENT_DETAILS.EVENT_NAME	   C12_EVENT_NAME,
-- 	TAMPER_EVIDENT_DETAILS.TRACKING_NUMBER	   C13_TRACKING_NUMBER
-- from	BTA_OWN.TAMPER_EVIDENT_DETAILS   TAMPER_EVIDENT_DETAILS
-- where	(1=1)
-- And (TAMPER_EVIDENT_DETAILS.LAST_UPDATED >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap)







-- &

/* TARGET CODE */
-- insert /*+ append */ into RAX_APP_USER.C$_0BTA_TMPR_EVID_DETS_STG
-- (
-- 	C1_ID,
-- 	C2_VERSION,
-- 	C3_COMMENTS,
-- 	C4_JOB_NUMBER,
-- 	C5_PHOTOGRAPHY_ID,
-- 	C6_TE_BAGS,
-- 	C7_STATUS,
-- 	C8_CREATED_BY,
-- 	C9_UPDATED_BY,
-- 	C10_DATE_CREATED,
-- 	C11_LAST_UPDATED,
-- 	C12_EVENT_NAME,
-- 	C13_TRACKING_NUMBER
-- )
-- values
-- (
-- 	:C1_ID,
-- 	:C2_VERSION,
-- 	:C3_COMMENTS,
-- 	:C4_JOB_NUMBER,
-- 	:C5_PHOTOGRAPHY_ID,
-- 	:C6_TE_BAGS,
-- 	:C7_STATUS,
-- 	:C8_CREATED_BY,
-- 	:C9_UPDATED_BY,
-- 	:C10_DATE_CREATED,
-- 	:C11_LAST_UPDATED,
-- 	:C12_EVENT_NAME,
-- 	:C13_TRACKING_NUMBER
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 28 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0BTA_TMPR_EVID_DETS_STG',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;




&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* Drop flow table */

-- drop table RAX_APP_USER.I$_BTA_TMPR_EVID_DETS_STG 

BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_BTA_TMPR_EVID_DETS_STG';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_BTA_TMPR_EVID_DETS_STG
(
	ID	NUMBER(19) NULL,
	VERSION	NUMBER(19) NULL,
	COMMENTS	VARCHAR2(255) NULL,
	JOB_NUMBER	VARCHAR2(255) NULL,
	PHOTOGRAPHY_ID	VARCHAR2(255) NULL,
	TE_BAGS	VARCHAR2(255) NULL,
	STATUS	VARCHAR2(50) NULL,
	CREATED_BY	VARCHAR2(255) NULL,
	UPDATED_BY	VARCHAR2(255) NULL,
	DATE_CREATED	DATE NULL,
	LAST_UPDATED	DATE NULL,
	EVENT_NAME	VARCHAR2(255) NULL,
	TRACKING_NUMBER	VARCHAR2(255) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 32 */
/* Insert flow into I$ table */

insert /*+ APPEND */  into RAX_APP_USER.I$_BTA_TMPR_EVID_DETS_STG
	(
	ID,
	VERSION,
	COMMENTS,
	JOB_NUMBER,
	PHOTOGRAPHY_ID,
	TE_BAGS,
	STATUS,
	CREATED_BY,
	UPDATED_BY,
	DATE_CREATED,
	LAST_UPDATED,
	EVENT_NAME,
	TRACKING_NUMBER
	,IND_UPDATE
	)


select 	 
	
	C1_ID,
	C2_VERSION,
	C3_COMMENTS,
	C4_JOB_NUMBER,
	C5_PHOTOGRAPHY_ID,
	C6_TE_BAGS,
	C7_STATUS,
	C8_CREATED_BY,
	C9_UPDATED_BY,
	C10_DATE_CREATED,
	C11_LAST_UPDATED,
	C12_EVENT_NAME,
	C13_TRACKING_NUMBER,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0BTA_TMPR_EVID_DETS_STG
where	(1=1)






minus
select
	ID,
	VERSION,
	COMMENTS,
	JOB_NUMBER,
	PHOTOGRAPHY_ID,
	TE_BAGS,
	STATUS,
	CREATED_BY,
	UPDATED_BY,
	DATE_CREATED,
	LAST_UPDATED,
	EVENT_NAME,
	TRACKING_NUMBER
	,'I'	IND_UPDATE
from	ODS_STAGE.BTA_TMPR_EVID_DETS_STG

&


/*-----------------------------------------------*/
/* TASK No. 33 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_BTA_TMPR_EVID_DETS_STG',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 34 */
/* Create Index on flow table */


create index	RAX_APP_USER.I$_BTA_TMPR_EVID_DETS_STG_IDX
on		RAX_APP_USER.I$_BTA_TMPR_EVID_DETS_STG (ID)
NOLOGGING


&


/*-----------------------------------------------*/
/* TASK No. 35 */
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

BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.SNP_CHECK_TAB';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&

BEGIN
   EXECUTE IMMEDIATE '
      create table RAX_APP_USER.SNP_CHECK_TAB
        (
            CATALOG_NAME    VARCHAR2(100 CHAR) NULL ,
            SCHEMA_NAME VARCHAR2(100 CHAR) NULL ,
            RESOURCE_NAME   VARCHAR2(100 CHAR) NULL,
            FULL_RES_NAME   VARCHAR2(100 CHAR) NULL,
            ERR_TYPE        VARCHAR2(1 CHAR) NULL,
            ERR_MESS        VARCHAR2(250 CHAR) NULL ,
            CHECK_DATE  DATE NULL,
            ORIGIN      VARCHAR2(100 CHAR) NULL,
            CONS_NAME   VARCHAR2(35 CHAR) NULL,
            CONS_TYPE       VARCHAR2(2 CHAR) NULL,
            ERR_COUNT       NUMBER(10) NULL
        )
   ';
END;

&


/*-----------------------------------------------*/
/* TASK No. 36 */
/* delete previous check sum */

delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS_STAGE'
and	ORIGIN 		= '(1497001)ODS_Project.LOAD_STAGING_TAMPER_EVIDENT_DETAILS'
and	ERR_TYPE 		= 'F'


&


/*-----------------------------------------------*/
/* TASK No. 37 */
/* create error table */
BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.E$_BTA_TMPR_EVID_DETS_STG';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&

create table RAX_APP_USER.E$_BTA_TMPR_EVID_DETS_STG
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	ID	NUMBER(19) NULL,
	VERSION	NUMBER(19) NULL,
	COMMENTS	VARCHAR2(255) NULL,
	JOB_NUMBER	VARCHAR2(255) NULL,
	PHOTOGRAPHY_ID	VARCHAR2(255) NULL,
	TE_BAGS	VARCHAR2(255) NULL,
	STATUS	VARCHAR2(50) NULL,
	CREATED_BY	VARCHAR2(255) NULL,
	UPDATED_BY	VARCHAR2(255) NULL,
	DATE_CREATED	DATE NULL,
	LAST_UPDATED	DATE NULL,
	EVENT_NAME	VARCHAR2(255) NULL,
	TRACKING_NUMBER	VARCHAR2(255) NULL,
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
/* TASK No. 38 */
/* delete previous errors */

delete from 	RAX_APP_USER.E$_BTA_TMPR_EVID_DETS_STG
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(1497001)ODS_Project.LOAD_STAGING_TAMPER_EVIDENT_DETAILS')


&


/*-----------------------------------------------*/
/* TASK No. 39 */
/* create index on error table */

 
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */


create index 	RAX_APP_USER.E$_BTA_TMPR_EVID_DETS_STG_IDX
on	RAX_APP_USER.E$_BTA_TMPR_EVID_DETS_STG (ODI_ROW_ID)


&


/*-----------------------------------------------*/
/* TASK No. 40 */
/* delete errors from controlled table */

delete from	RAX_APP_USER.I$_BTA_TMPR_EVID_DETS_STG  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_BTA_TMPR_EVID_DETS_STG E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)


&


/*-----------------------------------------------*/
/* TASK No. 41 */
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
	'BTA_TMPR_EVID_DETS_STG',
	'ODS_STAGE.BTA_TMPR_EVID_DETS_STG',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_BTA_TMPR_EVID_DETS_STG E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(1497001)ODS_Project.LOAD_STAGING_TAMPER_EVIDENT_DETAILS'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE


&


/*-----------------------------------------------*/
/* TASK No. 42 */
/* Merge Rows */

merge into	ODS_STAGE.BTA_TMPR_EVID_DETS_STG T
using	RAX_APP_USER.I$_BTA_TMPR_EVID_DETS_STG S
on	(
		T.ID=S.ID
	)
when matched
then update set
	T.VERSION	= S.VERSION,
	T.COMMENTS	= S.COMMENTS,
	T.JOB_NUMBER	= S.JOB_NUMBER,
	T.PHOTOGRAPHY_ID	= S.PHOTOGRAPHY_ID,
	T.TE_BAGS	= S.TE_BAGS,
	T.STATUS	= S.STATUS,
	T.CREATED_BY	= S.CREATED_BY,
	T.UPDATED_BY	= S.UPDATED_BY,
	T.DATE_CREATED	= S.DATE_CREATED,
	T.LAST_UPDATED	= S.LAST_UPDATED,
	T.EVENT_NAME	= S.EVENT_NAME,
	T.TRACKING_NUMBER	= S.TRACKING_NUMBER
	,            T.ODS_MODIFY_DATE	= sysdate
when not matched
then insert
	(
	T.ID,
	T.VERSION,
	T.COMMENTS,
	T.JOB_NUMBER,
	T.PHOTOGRAPHY_ID,
	T.TE_BAGS,
	T.STATUS,
	T.CREATED_BY,
	T.UPDATED_BY,
	T.DATE_CREATED,
	T.LAST_UPDATED,
	T.EVENT_NAME,
	T.TRACKING_NUMBER
	,             T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.ID,
	S.VERSION,
	S.COMMENTS,
	S.JOB_NUMBER,
	S.PHOTOGRAPHY_ID,
	S.TE_BAGS,
	S.STATUS,
	S.CREATED_BY,
	S.UPDATED_BY,
	S.DATE_CREATED,
	S.LAST_UPDATED,
	S.EVENT_NAME,
	S.TRACKING_NUMBER
	,             sysdate,
	sysdate
	)

&


/*-----------------------------------------------*/
/* TASK No. 43 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 44 */
/* Drop flow table */

drop table RAX_APP_USER.I$_BTA_TMPR_EVID_DETS_STG 

&


/*-----------------------------------------------*/
/* TASK No. 1000029 */
/* Drop work table */

drop table RAX_APP_USER.C$_0BTA_TMPR_EVID_DETS_STG purge

&


/*-----------------------------------------------*/
/* TASK No. 45 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
+ nvl((TIMEZONE_OFFSET/24), 0) 
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env


&


/*-----------------------------------------------*/
/* TASK No. 46 */
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
,'43_BTA_LOAD_PKG'
,'002'
,TO_DATE(SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
,TO_DATE (SUBSTR(:v_cdc_ld_date, 1, 19),'YYYY-MM-DD HH24:MI:SS')
,:v_cdc_overlap
,SYSDATE
,:v_env
,TIMEZONE_OFFSET
from 
ODS_OWN.ODS_CDC_LOAD_STATUS
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env


&


/*-----------------------------------------------*/
