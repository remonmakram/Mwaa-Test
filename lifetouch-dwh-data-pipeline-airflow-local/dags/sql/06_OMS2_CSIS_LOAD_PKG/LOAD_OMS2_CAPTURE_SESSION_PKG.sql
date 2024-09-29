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

-- drop table RAX_APP_USER.C$_0OMS2_LT_SB_A_SES_STG purge

-- &


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Create work table */

-- create table RAX_APP_USER.C$_0OMS2_LT_SB_A_SES_STG
-- (
-- 	C1_SESSION_KEY	VARCHAR2(24) NULL,
-- 	C2_SUBJECT_KEY	VARCHAR2(24) NULL,
-- 	C3_APO_KEY	VARCHAR2(24) NULL,
-- 	C4_SIT_TYPE	VARCHAR2(15) NULL,
-- 	C5_LOCATION	VARCHAR2(15) NULL,
-- 	C6_EXECUTION_DATE	DATE NULL,
-- 	C7_CREATETS	DATE NULL,
-- 	C8_MODIFYTS	DATE NULL,
-- 	C9_CREATEUSERID	VARCHAR2(40) NULL,
-- 	C10_MODIFYUSERID	VARCHAR2(40) NULL,
-- 	C11_CREATEPROGID	VARCHAR2(40) NULL,
-- 	C12_MODIFYPROGID	VARCHAR2(40) NULL,
-- 	C13_LOCKID	NUMBER NULL
-- )
-- NOLOGGING

-- &


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Load data */

/* SOURCE CODE */


-- select	
-- 	trim(LT_SUBJECT_APO_SESSION_TIE.SESSION_KEY)	   C1_SESSION_KEY,
-- 	trim(LT_SUBJECT_APO_SESSION_TIE.SUBJECT_KEY)	   C2_SUBJECT_KEY,
-- 	trim(LT_SUBJECT_APO_SESSION_TIE.APO_KEY)	   C3_APO_KEY,
-- 	LT_SUBJECT_APO_SESSION_TIE.SIT_TYPE	   C4_SIT_TYPE,
-- 	LT_SUBJECT_APO_SESSION_TIE.LOCATION	   C5_LOCATION,
-- 	LT_SUBJECT_APO_SESSION_TIE.EXECUTION_DATE	   C6_EXECUTION_DATE,
-- 	LT_SUBJECT_APO_SESSION_TIE.CREATETS	   C7_CREATETS,
-- 	LT_SUBJECT_APO_SESSION_TIE.MODIFYTS	   C8_MODIFYTS,
-- 	LT_SUBJECT_APO_SESSION_TIE.CREATEUSERID	   C9_CREATEUSERID,
-- 	LT_SUBJECT_APO_SESSION_TIE.MODIFYUSERID	   C10_MODIFYUSERID,
-- 	LT_SUBJECT_APO_SESSION_TIE.CREATEPROGID	   C11_CREATEPROGID,
-- 	LT_SUBJECT_APO_SESSION_TIE.MODIFYPROGID	   C12_MODIFYPROGID,
-- 	LT_SUBJECT_APO_SESSION_TIE.LOCKID	   C13_LOCKID
-- from	OMS2_OWN.LT_SUBJECT_APO_SESSION_TIE   LT_SUBJECT_APO_SESSION_TIE
-- where	(1=1)
-- And (LT_SUBJECT_APO_SESSION_TIE.MODIFYTS >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
-- )







-- &

-- /* TARGET CODE */
-- insert /*+ append */ into RAX_APP_USER.C$_0OMS2_LT_SB_A_SES_STG
-- (
-- 	C1_SESSION_KEY,
-- 	C2_SUBJECT_KEY,
-- 	C3_APO_KEY,
-- 	C4_SIT_TYPE,
-- 	C5_LOCATION,
-- 	C6_EXECUTION_DATE,
-- 	C7_CREATETS,
-- 	C8_MODIFYTS,
-- 	C9_CREATEUSERID,
-- 	C10_MODIFYUSERID,
-- 	C11_CREATEPROGID,
-- 	C12_MODIFYPROGID,
-- 	C13_LOCKID
-- )
-- values
-- (
-- 	:C1_SESSION_KEY,
-- 	:C2_SUBJECT_KEY,
-- 	:C3_APO_KEY,
-- 	:C4_SIT_TYPE,
-- 	:C5_LOCATION,
-- 	:C6_EXECUTION_DATE,
-- 	:C7_CREATETS,
-- 	:C8_MODIFYTS,
-- 	:C9_CREATEUSERID,
-- 	:C10_MODIFYUSERID,
-- 	:C11_CREATEPROGID,
-- 	:C12_MODIFYPROGID,
-- 	:C13_LOCKID
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0OMS2_LT_SB_A_SES_STG',
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

-- drop table RAX_APP_USER.I$_OMS2_LT_SB_A_SES_STG1997001 
BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_OMS2_LT_SB_A_SES_STG1997001 ';
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

create table RAX_APP_USER.I$_OMS2_LT_SB_A_SES_STG1997001
(
	SESSION_KEY	VARCHAR2(24) NULL,
	SUBJECT_KEY	VARCHAR2(24) NULL,
	APO_KEY	VARCHAR2(24) NULL,
	SIT_TYPE	VARCHAR2(15) NULL,
	LOCATION	VARCHAR2(15) NULL,
	EXECUTION_DATE	DATE NULL,
	CREATETS	DATE NULL,
	MODIFYTS	DATE NULL,
	CREATEUSERID	VARCHAR2(40) NULL,
	MODIFYUSERID	VARCHAR2(40) NULL,
	CREATEPROGID	VARCHAR2(40) NULL,
	MODIFYPROGID	VARCHAR2(40) NULL,
	LOCKID	NUMBER NULL,
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
 


  


insert into	RAX_APP_USER.I$_OMS2_LT_SB_A_SES_STG1997001
(
	SESSION_KEY,
	SUBJECT_KEY,
	APO_KEY,
	SIT_TYPE,
	LOCATION,
	EXECUTION_DATE,
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
SESSION_KEY,
	SUBJECT_KEY,
	APO_KEY,
	SIT_TYPE,
	LOCATION,
	EXECUTION_DATE,
	CREATETS,
	MODIFYTS,
	CREATEUSERID,
	MODIFYUSERID,
	CREATEPROGID,
	MODIFYPROGID,
	LOCKID,
	IND_UPDATE
 from (


select 	 
	
	C1_SESSION_KEY SESSION_KEY,
	C2_SUBJECT_KEY SUBJECT_KEY,
	C3_APO_KEY APO_KEY,
	C4_SIT_TYPE SIT_TYPE,
	C5_LOCATION LOCATION,
	C6_EXECUTION_DATE EXECUTION_DATE,
	C7_CREATETS CREATETS,
	C8_MODIFYTS MODIFYTS,
	C9_CREATEUSERID CREATEUSERID,
	C10_MODIFYUSERID MODIFYUSERID,
	C11_CREATEPROGID CREATEPROGID,
	C12_MODIFYPROGID MODIFYPROGID,
	C13_LOCKID LOCKID,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0OMS2_LT_SB_A_SES_STG
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.OMS2_LT_SUBJECT_APO_SESS_STG T
	where	T.SESSION_KEY	= S.SESSION_KEY 
		 and ((T.SUBJECT_KEY = S.SUBJECT_KEY) or (T.SUBJECT_KEY IS NULL and S.SUBJECT_KEY IS NULL)) and
		((T.APO_KEY = S.APO_KEY) or (T.APO_KEY IS NULL and S.APO_KEY IS NULL)) and
		((T.SIT_TYPE = S.SIT_TYPE) or (T.SIT_TYPE IS NULL and S.SIT_TYPE IS NULL)) and
		((T.LOCATION = S.LOCATION) or (T.LOCATION IS NULL and S.LOCATION IS NULL)) and
		((T.EXECUTION_DATE = S.EXECUTION_DATE) or (T.EXECUTION_DATE IS NULL and S.EXECUTION_DATE IS NULL)) and
		((T.CREATETS = S.CREATETS) or (T.CREATETS IS NULL and S.CREATETS IS NULL)) and
		((T.MODIFYTS = S.MODIFYTS) or (T.MODIFYTS IS NULL and S.MODIFYTS IS NULL)) and
		((T.CREATEUSERID = S.CREATEUSERID) or (T.CREATEUSERID IS NULL and S.CREATEUSERID IS NULL)) and
		((T.MODIFYUSERID = S.MODIFYUSERID) or (T.MODIFYUSERID IS NULL and S.MODIFYUSERID IS NULL)) and
		((T.CREATEPROGID = S.CREATEPROGID) or (T.CREATEPROGID IS NULL and S.CREATEPROGID IS NULL)) and
		((T.MODIFYPROGID = S.MODIFYPROGID) or (T.MODIFYPROGID IS NULL and S.MODIFYPROGID IS NULL)) and
		((T.LOCKID = S.LOCKID) or (T.LOCKID IS NULL and S.LOCKID IS NULL))
        )

  
  

  



&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_OMS2_LT_SB_A_SES_STG1997001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Create Index on flow table */

-- create index	RAX_APP_USER.I$_OMS2_LT_SB_A_SES_STG_IDX1997001
-- on		RAX_APP_USER.I$_OMS2_LT_SB_A_SES_STG1997001 (SESSION_KEY)
-- NOLOGGING

BEGIN
    EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_OMS2_LT_SB_A_SES_STG_IDX1997001
on		RAX_APP_USER.I$_OMS2_LT_SB_A_SES_STG1997001 (SESSION_KEY)
NOLOGGING';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Merge Rows */

merge into	ODS_STAGE.OMS2_LT_SUBJECT_APO_SESS_STG T
using	RAX_APP_USER.I$_OMS2_LT_SB_A_SES_STG1997001 S
on	(
		T.SESSION_KEY=S.SESSION_KEY
	)
when matched
then update set
	T.SUBJECT_KEY	= S.SUBJECT_KEY,
	T.APO_KEY	= S.APO_KEY,
	T.SIT_TYPE	= S.SIT_TYPE,
	T.LOCATION	= S.LOCATION,
	T.EXECUTION_DATE	= S.EXECUTION_DATE,
	T.CREATETS	= S.CREATETS,
	T.MODIFYTS	= S.MODIFYTS,
	T.CREATEUSERID	= S.CREATEUSERID,
	T.MODIFYUSERID	= S.MODIFYUSERID,
	T.CREATEPROGID	= S.CREATEPROGID,
	T.MODIFYPROGID	= S.MODIFYPROGID,
	T.LOCKID	= S.LOCKID
	,            T.ODS_MODIFY_DATE	= sysdate
when not matched
then insert
	(
	T.SESSION_KEY,
	T.SUBJECT_KEY,
	T.APO_KEY,
	T.SIT_TYPE,
	T.LOCATION,
	T.EXECUTION_DATE,
	T.CREATETS,
	T.MODIFYTS,
	T.CREATEUSERID,
	T.MODIFYUSERID,
	T.CREATEPROGID,
	T.MODIFYPROGID,
	T.LOCKID
	,             T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.SESSION_KEY,
	S.SUBJECT_KEY,
	S.APO_KEY,
	S.SIT_TYPE,
	S.LOCATION,
	S.EXECUTION_DATE,
	S.CREATETS,
	S.MODIFYTS,
	S.CREATEUSERID,
	S.MODIFYUSERID,
	S.CREATEPROGID,
	S.MODIFYPROGID,
	S.LOCKID
	,             sysdate,
	sysdate
	)

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Drop flow table */

drop table RAX_APP_USER.I$_OMS2_LT_SB_A_SES_STG1997001 

&


/*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */

drop table RAX_APP_USER.C$_0OMS2_LT_SB_A_SES_STG purge

&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Pivot OMS2_SESSION_KEY into XR for SM rows */

merge into ods_stage.capture_session_xr t
using
(
select csa.capture_session_oid
, csa.value
from ods_own.capture_session_alias csa
, rax_app_user.capture_sess_alias_type csat
where 1=1
and to_char(csat.session_alias_type_id) = csa.alias_type
and csat.name = 'SeniorCaptureSessionId'
and csa.capture_session_oid is not null
and csa.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap
) s
on (s.capture_session_oid = t.capture_session_oid)
when matched then update
set t.oms2_session_key = s.value
where decode(s.value,t.oms2_session_key,1,0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Update the OMS2 keys on the SM sourced XR rows */

MERGE INTO ODS_STAGE.CAPTURE_SESSION_XR d
USING
(
  SELECT a.OMS2_SESSION_KEY
    ,a.OMS2_SUBJECT_KEY
    ,a.OMS2_APO_KEY
  FROM 
    ODS_STAGE.CAPTURE_SESSION_XR a
  WHERE (1=1)
    and (a.OMS2_SUBJECT_KEY is not null or a.OMS2_APO_KEY is not null)
    and a.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) s 
ON (s.OMS2_SESSION_KEY=d.OMS2_SESSION_KEY)
WHEN MATCHED THEN UPDATE SET
     d.OMS2_SUBJECT_KEY = s.OMS2_SUBJECT_KEY
    ,d.OMS2_APO_KEY = s.OMS2_APO_KEY
    ,d.ODS_MODIFY_DATE = sysdate
WHERE 
    decode(s.OMS2_SUBJECT_KEY,d.OMS2_SUBJECT_KEY,1,0) = 0
    or decode(s.OMS2_APO_KEY,d.OMS2_APO_KEY,1,0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* drop oms2_dupe_sessions */

-- drop table oms2_dupe_sessions

BEGIN
    EXECUTE IMMEDIATE 'drop table oms2_dupe_sessions';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* create oms2_dupe_sessions */

create table oms2_dupe_sessions as
select distinct cs_xr2.CAPTURE_SESSION_OID
,'D' || cs_xr2.OMS2_SESSION_KEY OMS2_SESSION_KEY
from ods_stage.capture_session_xr cs_xr
, ods_stage.capture_session_xr cs_xr2
where cs_xr.oms2_session_key = cs_xr2.oms2_session_key
and cs_xr2.system_of_record = 'OMS2'
and cs_xr2.OMS2_SESSION_KEY not like 'D%' -- already marked, just waiting to be deleted
and cs_xr.oms2_session_key is not null
and cs_xr.system_of_record = 'SM'
and cs_xr.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* create index oms2_dupe_sessions_pk */

create unique index oms2_dupe_sessions_pk on oms2_dupe_sessions(capture_session_oid)

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/*  oms2_dupe_sessions - OMS2 CDC */

merge into oms2_dupe_sessions t
using
(
select cs_xr2.CAPTURE_SESSION_OID
,'D' || cs_xr2.OMS2_SESSION_KEY OMS2_SESSION_KEY
from ods_stage.capture_session_xr cs_xr
, ods_stage.capture_session_xr cs_xr2
where cs_xr.oms2_session_key = cs_xr2.oms2_session_key
and cs_xr2.system_of_record = 'OMS2'
and cs_xr2.OMS2_SESSION_KEY not like 'D%' -- already marked, just waiting to be deleted
and cs_xr.oms2_session_key is not null
and cs_xr.system_of_record = 'SM'
and cs_xr2.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap
) s
on ( s.capture_session_oid = t.capture_session_oid )
when not matched then insert
(t.capture_session_oid
,t.OMS2_SESSION_KEY
)
values
( s.capture_session_oid
,s.OMS2_SESSION_KEY
)

&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* MARK OMS2 that are DUPS */

merge into ODS_STAGE.CAPTURE_SESSION_XR d
USING
(
select
    CAPTURE_SESSION_OID
    ,OMS2_SESSION_KEY
from oms2_dupe_sessions
) s
ON (s.CAPTURE_SESSION_OID=d.CAPTURE_SESSION_OID)
WHEN MATCHED THEN UPDATE SET
     d.OMS2_SESSION_KEY = s.OMS2_SESSION_KEY
    ,d.ODS_MODIFY_DATE = sysdate

&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* ODS_STAGE.CAPTURE_SESSION_XR */

-- OMS2
MERGE INTO ODS_STAGE.CAPTURE_SESSION_XR d 
USING 
(
  SELECT
     a.SESSION_KEY as OMS2_SESSION_KEY
    ,a.SUBJECT_KEY as OMS2_SUBJECT_KEY
    ,a.APO_KEY as OMS2_APO_KEY
  FROM 
    ODS_STAGE.OMS2_LT_SUBJECT_APO_SESS_STG a
  WHERE (1=1)	
    and a.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) s
ON (s.OMS2_SESSION_KEY=d.OMS2_SESSION_KEY)
WHEN MATCHED THEN UPDATE SET
    d.OMS2_SUBJECT_KEY = s.OMS2_SUBJECT_KEY
    ,d.OMS2_APO_KEY = s.OMS2_APO_KEY
    ,d.ODS_MODIFY_DATE = SYSDATE
WHERE 
    decode(s.OMS2_SUBJECT_KEY,d.OMS2_SUBJECT_KEY,1,0) = 0
    or decode(s.OMS2_APO_KEY,d.OMS2_APO_KEY,1,0) = 0
WHEN NOT MATCHED THEN INSERT 
(
  CAPTURE_SESSION_OID
  ,OMS2_SESSION_KEY
  ,OMS2_SUBJECT_KEY
  ,OMS2_APO_KEY
  ,SYSTEM_OF_RECORD
  ,ODS_CREATE_DATE
  ,ODS_MODIFY_DATE
)
VALUES 
(
   ODS_STAGE.CAPTURE_SESSION_OID_SEQ.nextval
  ,s.OMS2_SESSION_KEY
  ,s.OMS2_SUBJECT_KEY
  ,s.OMS2_APO_KEY
  ,'OMS2'
  ,sysdate
  ,sysdate
)


&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* ODS_OWN.CAPTURE_SESSION matched to SM Subjects */

MERGE INTO ODS_OWN.CAPTURE_SESSION d 
USING 
(
  SELECT
     xr.CAPTURE_SESSION_OID
    ,a.EXECUTION_DATE PICTURE_DATE
    ,apo_xr.APO_OID
    ,sub_xr.SUBJECT_OID
    ,a.SESSION_KEY SR_SESSION_KEY
    ,a.EXECUTION_DATE SR_EXECUTION_DATE
    ,ss.SOURCE_SYSTEM_OID
    ,sysdate as ODS_CREATE_DATE
    ,sysdate as ODS_MODIFY_DATE
-- select *
  FROM 
    ODS_STAGE.OMS2_LT_SUBJECT_APO_SESS_STG a
    ,ODS_STAGE.CAPTURE_SESSION_XR xr
    ,ODS_STAGE.APO_XR apo_xr
    ,ODS_STAGE.SUBJECT_XR sub_xr
    ,ODS_OWN.SOURCE_SYSTEM ss
    ,( select min(sei.subject_oid) as subject_oid
       , eif.apo_id
       from ods_own.subject_event_info sei
       ,ods_own.sm_event_image_fact eif
       where (1=1)
       and sei.sm_event_image_fact_oid = eif.sm_event_image_fact_oid
       group by eif.apo_id
      ) eif_sq
  WHERE (1=1)	
    and a.SESSION_KEY=xr.OMS2_SESSION_KEY
    and ss.SOURCE_SYSTEM_SHORT_NAME='OMS2'
    and xr.OMS2_APO_KEY=apo_xr.OMS2_SK_BUSINESS_KEY
    and xr.OMS2_SUBJECT_KEY=sub_xr.OMS2_SUBJECT_KEY
    and sub_xr.subject_oid = eif_sq.subject_oid
    and eif_sq.apo_id = apo_xr.apo_id
    and xr.SYSTEM_OF_RECORD = 'OMS2'
    and sub_xr.SYSTEM_OF_RECORD = 'SM'
    and a.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) s
ON (s.CAPTURE_SESSION_OID=d.CAPTURE_SESSION_OID)
WHEN MATCHED THEN UPDATE SET
     d.PICTURE_DATE=s.PICTURE_DATE
    ,d.APO_OID=s.APO_OID
    ,d.SUBJECT_OID= case when s.SUBJECT_OID is null then d.subject_oid else s.subject_oid end
    ,d.SOURCE_SYSTEM_OID=s.SOURCE_SYSTEM_OID
    ,d.SR_SESSION_KEY=s.SR_SESSION_KEY
    ,d.SR_EXECUTION_DATE=s.SR_EXECUTION_DATE
    ,d.ODS_MODIFY_DATE = s.ODS_MODIFY_DATE
WHERE 
    decode(s.PICTURE_DATE,d.PICTURE_DATE,1,0) = 0
    or decode(s.APO_OID,d.APO_OID,1,0) = 0
    or s.SUBJECT_OID <> d.SUBJECT_OID
    or decode(s.SOURCE_SYSTEM_OID,d.SOURCE_SYSTEM_OID,1,0) = 0
    or decode(s.SR_SESSION_KEY,d.SR_SESSION_KEY,1,0) = 0
    or decode(s.SR_EXECUTION_DATE,d.SR_EXECUTION_DATE,1,0) = 0
WHEN NOT MATCHED THEN INSERT 
(
  CAPTURE_SESSION_OID
--  ,CAPTURE_SESSION_ID
--  ,EVENT_OID
  ,PICTURE_DATE
--  ,LAB_SESSION_ID
--  ,JOB_ALPHA_NBR
  ,APO_OID
--  ,ORDER_FORM_ID
  ,ODS_CREATE_DATE
  ,ODS_MODIFY_DATE
  ,SOURCE_SYSTEM_OID
--  ,CAPTURE_SESSION_KEY
--  ,ACCESS_CODE
  ,SUBJECT_OID
  ,SR_SESSION_KEY
  ,SR_EXECUTION_DATE
) 
VALUES 
(
  s.CAPTURE_SESSION_OID
--  ,s.CAPTURE_SESSION_ID
--  ,s.EVENT_OID
  ,s.PICTURE_DATE
--  ,s.LAB_SESSION_ID
--  ,s.JOB_ALPHA_NBR
  ,s.APO_OID
--  ,s.ORDER_FORM_ID
  ,s.ODS_CREATE_DATE
  ,s.ODS_MODIFY_DATE
  ,s.SOURCE_SYSTEM_OID
--  ,s.CAPTURE_SESSION_KEY
--  ,s.ACCESS_CODE
  ,s.SUBJECT_OID
  ,s.SR_SESSION_KEY
  ,s.SR_EXECUTION_DATE
)

&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* ODS_OWN.CAPTURE_SESSION matched to OMS2 Subjects */

MERGE INTO ODS_OWN.CAPTURE_SESSION d 
USING 
(
  SELECT
     xr.CAPTURE_SESSION_OID
    ,a.EXECUTION_DATE PICTURE_DATE
    ,apo_xr.APO_OID
    ,sub_xr.SUBJECT_OID
    ,a.SESSION_KEY SR_SESSION_KEY
    ,a.EXECUTION_DATE SR_EXECUTION_DATE
    ,ss.SOURCE_SYSTEM_OID
    ,sysdate as ODS_CREATE_DATE
    ,sysdate as ODS_MODIFY_DATE
-- select *
  FROM 
    ODS_STAGE.OMS2_LT_SUBJECT_APO_SESS_STG a
    ,ODS_STAGE.CAPTURE_SESSION_XR xr
    ,ODS_STAGE.APO_XR apo_xr
    ,ODS_STAGE.SUBJECT_XR sub_xr
    ,ODS_OWN.SOURCE_SYSTEM ss
  WHERE (1=1)	
    and a.SESSION_KEY=xr.OMS2_SESSION_KEY
    and ss.SOURCE_SYSTEM_SHORT_NAME='OMS2'
    and xr.OMS2_APO_KEY=apo_xr.OMS2_SK_BUSINESS_KEY(+)
    and xr.OMS2_SUBJECT_KEY=sub_xr.OMS2_SUBJECT_KEY(+)
    and xr.SYSTEM_OF_RECORD = 'OMS2'
    and sub_xr.SYSTEM_OF_RECORD(+) = 'OMS2'
    and a.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) s
ON (s.CAPTURE_SESSION_OID=d.CAPTURE_SESSION_OID)
WHEN MATCHED THEN UPDATE SET
     d.PICTURE_DATE=s.PICTURE_DATE
    ,d.APO_OID=s.APO_OID
    ,d.SUBJECT_OID= case when s.SUBJECT_OID is null then d.subject_oid else s.subject_oid end
    ,d.SOURCE_SYSTEM_OID=s.SOURCE_SYSTEM_OID
    ,d.SR_SESSION_KEY=s.SR_SESSION_KEY
    ,d.SR_EXECUTION_DATE=s.SR_EXECUTION_DATE
    ,d.ODS_MODIFY_DATE = s.ODS_MODIFY_DATE
WHERE 
    decode(s.PICTURE_DATE,d.PICTURE_DATE,1,0) = 0
    or decode(s.APO_OID,d.APO_OID,1,0) = 0
    or s.SUBJECT_OID <> d.SUBJECT_OID
    or decode(s.SOURCE_SYSTEM_OID,d.SOURCE_SYSTEM_OID,1,0) = 0
    or decode(s.SR_SESSION_KEY,d.SR_SESSION_KEY,1,0) = 0
    or decode(s.SR_EXECUTION_DATE,d.SR_EXECUTION_DATE,1,0) = 0
WHEN NOT MATCHED THEN INSERT 
(
  CAPTURE_SESSION_OID
--  ,CAPTURE_SESSION_ID
--  ,EVENT_OID
  ,PICTURE_DATE
--  ,LAB_SESSION_ID
--  ,JOB_ALPHA_NBR
  ,APO_OID
--  ,ORDER_FORM_ID
  ,ODS_CREATE_DATE
  ,ODS_MODIFY_DATE
  ,SOURCE_SYSTEM_OID
--  ,CAPTURE_SESSION_KEY
--  ,ACCESS_CODE
  ,SUBJECT_OID
  ,SR_SESSION_KEY
  ,SR_EXECUTION_DATE
) 
VALUES 
(
  s.CAPTURE_SESSION_OID
--  ,s.CAPTURE_SESSION_ID
--  ,s.EVENT_OID
  ,s.PICTURE_DATE
--  ,s.LAB_SESSION_ID
--  ,s.JOB_ALPHA_NBR
  ,s.APO_OID
--  ,s.ORDER_FORM_ID
  ,s.ODS_CREATE_DATE
  ,s.ODS_MODIFY_DATE
  ,s.SOURCE_SYSTEM_OID
--  ,s.CAPTURE_SESSION_KEY
--  ,s.ACCESS_CODE
  ,s.SUBJECT_OID
  ,s.SR_SESSION_KEY
  ,s.SR_EXECUTION_DATE
)

&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* ODS_OWN.CAPTURE_SESSION regardless of SYSTEM_OF_RECORD */

-- ODS_OWN.CAPTURE_SESSION regardless of SYSTEM_OF_RECORD
MERGE INTO ODS_OWN.CAPTURE_SESSION d 
USING 
(
  SELECT
     xr.CAPTURE_SESSION_OID
    ,a.SESSION_KEY SR_SESSION_KEY
    ,a.EXECUTION_DATE SR_EXECUTION_DATE
    ,sysdate as ODS_CREATE_DATE
    ,sysdate as ODS_MODIFY_DATE
-- select *
  FROM 
    ODS_STAGE.OMS2_LT_SUBJECT_APO_SESS_STG a
    ,ODS_STAGE.CAPTURE_SESSION_XR xr
  WHERE (1=1)	
    and a.SESSION_KEY=xr.OMS2_SESSION_KEY
    and a.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) s
ON (s.CAPTURE_SESSION_OID=d.CAPTURE_SESSION_OID)
WHEN MATCHED THEN UPDATE SET
     d.SR_SESSION_KEY=s.SR_SESSION_KEY
    ,d.SR_EXECUTION_DATE=s.SR_EXECUTION_DATE
    ,d.picture_date = s.SR_EXECUTION_DATE
    ,d.ODS_MODIFY_DATE = s.ODS_MODIFY_DATE
WHERE 
    decode(s.SR_SESSION_KEY,d.SR_SESSION_KEY,1,0) = 0
    or decode(s.SR_EXECUTION_DATE,d.SR_EXECUTION_DATE,1,0) = 0
    or decode(s.SR_EXECUTION_DATE,d.picture_date,1,0) = 0


&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* ODS_OWN.CAPTURE_SESSION regardless of SYSTEM_OF_RECORD CAPTURE_SESSION CDC */

-- ODS_OWN.CAPTURE_SESSION regardless of SYSTEM_OF_RECORD
MERGE INTO ODS_OWN.CAPTURE_SESSION d 
USING 
(
  SELECT
     xr.CAPTURE_SESSION_OID
    ,a.SESSION_KEY SR_SESSION_KEY
    ,a.EXECUTION_DATE SR_EXECUTION_DATE
    ,sysdate as ODS_CREATE_DATE
    ,sysdate as ODS_MODIFY_DATE
-- select *
  FROM 
    ODS_STAGE.OMS2_LT_SUBJECT_APO_SESS_STG a
    ,ODS_STAGE.CAPTURE_SESSION_XR xr
    ,ODS_OWN.CAPTURE_SESSION cs
  WHERE (1=1)	
    and a.SESSION_KEY=xr.OMS2_SESSION_KEY
    and xr.capture_session_oid = cs.capture_session_oid
    and cs.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) s
ON (s.CAPTURE_SESSION_OID=d.CAPTURE_SESSION_OID)
WHEN MATCHED THEN UPDATE SET
     d.SR_SESSION_KEY=s.SR_SESSION_KEY
    ,d.SR_EXECUTION_DATE=s.SR_EXECUTION_DATE
    ,d.picture_date = s.SR_EXECUTION_DATE
    ,d.ODS_MODIFY_DATE = s.ODS_MODIFY_DATE
WHERE 
    decode(s.SR_SESSION_KEY,d.SR_SESSION_KEY,1,0) = 0
    or decode(s.SR_EXECUTION_DATE,d.SR_EXECUTION_DATE,1,0) = 0
    or decode(s.SR_EXECUTION_DATE,d.picture_date,1,0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* Repair SUBJECT_OID - OMS2 Subjects */

MERGE INTO ODS_OWN.CAPTURE_SESSION d 
USING 
(
  SELECT
     xr.CAPTURE_SESSION_OID
    ,sub_xr.SUBJECT_OID
    ,sysdate as ODS_MODIFY_DATE
-- select *
  FROM 
     ODS_STAGE.CAPTURE_SESSION_XR xr
    ,ODS_STAGE.SUBJECT_XR sub_xr
  WHERE (1=1)	
    and xr.SYSTEM_OF_RECORD = 'OMS2'
    and sub_xr.SYSTEM_OF_RECORD = 'OMS2'
    and xr.OMS2_SUBJECT_KEY=sub_xr.OMS2_SUBJECT_KEY
    and sub_xr.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) s
ON (s.CAPTURE_SESSION_OID=d.CAPTURE_SESSION_OID)
WHEN MATCHED THEN UPDATE SET
     d.SUBJECT_OID=s.SUBJECT_OID
    ,d.ODS_MODIFY_DATE = s.ODS_MODIFY_DATE
WHERE 
    decode(s.SUBJECT_OID,d.SUBJECT_OID,1,0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* Repair SUBJECT_OID - SM Subjects */

MERGE INTO ODS_OWN.CAPTURE_SESSION d 
USING 
(
  SELECT
     xr.CAPTURE_SESSION_OID
    ,max(sub_xr.SUBJECT_OID) as subject_oid
    ,sysdate as ODS_MODIFY_DATE
-- select *
  FROM 
     ODS_STAGE.CAPTURE_SESSION_XR xr
    ,ODS_STAGE.SUBJECT_XR sub_xr
    ,ODS_STAGE.APO_XR apo_xr
    ,( select distinct sei.subject_oid
       , eif.apo_id
       from ods_own.subject_event_info sei
       ,ods_own.sm_event_image_fact eif
       where (1=1)
       and sei.sm_event_image_fact_oid = eif.sm_event_image_fact_oid
      ) eif_sq
  WHERE (1=1)	
    and xr.SYSTEM_OF_RECORD = 'OMS2'
    and sub_xr.SYSTEM_OF_RECORD = 'SM'
    and sub_xr.subject_oid = eif_sq.subject_oid
    and xr.OMS2_APO_KEY=apo_xr.OMS2_SK_BUSINESS_KEY
    and eif_sq.apo_id = apo_xr.apo_id
    and xr.OMS2_SUBJECT_KEY=sub_xr.OMS2_SUBJECT_KEY
    and sub_xr.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
group by xr.CAPTURE_SESSION_OID
) s
ON (s.CAPTURE_SESSION_OID=d.CAPTURE_SESSION_OID)
WHEN MATCHED THEN UPDATE SET
     d.SUBJECT_OID=s.SUBJECT_OID
    ,d.ODS_MODIFY_DATE = s.ODS_MODIFY_DATE
WHERE 
    decode(s.SUBJECT_OID,d.SUBJECT_OID,1,0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 32 */
/* Repair APO_OID */

MERGE INTO ODS_OWN.CAPTURE_SESSION d 
USING 
(
  SELECT
     xr.CAPTURE_SESSION_OID
    ,apo_xr.APO_OID
    ,sysdate as ODS_MODIFY_DATE
-- select *
  FROM 
     ODS_STAGE.CAPTURE_SESSION_XR xr
    ,ODS_STAGE.APO_XR apo_xr
  WHERE (1=1)	
    and xr.SYSTEM_OF_RECORD = 'OMS2'
    and xr.OMS2_APO_KEY=apo_xr.OMS2_SK_BUSINESS_KEY
    and apo_xr.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) s
ON (s.CAPTURE_SESSION_OID=d.CAPTURE_SESSION_OID)
WHEN MATCHED THEN UPDATE SET
     d.APO_OID=s.APO_OID
    ,d.ODS_MODIFY_DATE = s.ODS_MODIFY_DATE
WHERE 
    decode(s.APO_OID,d.APO_OID,1,0) = 0


&


/*-----------------------------------------------*/
/* TASK No. 33 */
/* CREATE TABLE OMS2_CS_IMAGE_FIX */

-- CREATE TABLE OMS2_CS_IMAGE_FIX
-- (
--   OLD_CAPTURE_SESSION_OID  NUMBER               NOT NULL,
--   NEW_CAPTURE_SESSION_OID  NUMBER               NOT NULL,
--   OMS2_SESSION_KEY         VARCHAR2(50 BYTE),
--   ODS_CREATE_DATE          DATE
-- )

BEGIN
    EXECUTE IMMEDIATE 'CREATE TABLE OMS2_CS_IMAGE_FIX
(
  OLD_CAPTURE_SESSION_OID  NUMBER               NOT NULL,
  NEW_CAPTURE_SESSION_OID  NUMBER               NOT NULL,
  OMS2_SESSION_KEY         VARCHAR2(50 BYTE),
  ODS_CREATE_DATE          DATE
)
';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;



&


/*-----------------------------------------------*/
/* TASK No. 34 */
/* CREATE INDEX */

-- CREATE UNIQUE INDEX CSIF_01_IX ON OMS2_CS_IMAGE_FIX (OLD_CAPTURE_SESSION_OID) TABLESPACE ODS_INDX

BEGIN
    EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX CSIF_01_IX ON OMS2_CS_IMAGE_FIX (OLD_CAPTURE_SESSION_OID) TABLESPACE ODS_INDX';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;


&


/*-----------------------------------------------*/
/* TASK No. 35 */
/* CREATE INDEX CSIF_99_IX */

-- CREATE INDEX CSIF_99_IX ON OMS2_CS_IMAGE_FIX (ODS_CREATE_DATE) TABLESPACE ODS_INDX

BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX CSIF_99_IX ON OMS2_CS_IMAGE_FIX (ODS_CREATE_DATE) TABLESPACE ODS_INDX';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;


&


/*-----------------------------------------------*/
/* TASK No. 36 */
/* INSERT INTO OMS2_CS_IMAGE_FIX */

INSERT INTO OMS2_CS_IMAGE_FIX (
   OLD_CAPTURE_SESSION_OID, NEW_CAPTURE_SESSION_OID, OMS2_SESSION_KEY, 
   ODS_CREATE_DATE) 
select distinct
xr.CAPTURE_SESSION_OID OLD_CAPTURE_SESSION_OID ,new_xr.CAPTURE_SESSION_OID NEW_CAPTURE_SESSION_OID, new_xr.OMS2_SESSION_KEY OMS2_SESSION_KEY,sysdate as ODS_CREATE_DATE
from
ODS_STAGE.CAPTURE_SESSION_XR xr
,ODS_STAGE.CAPTURE_SESSION_XR new_xr
where (1=1)
and xr.OMS2_SESSION_KEY like 'D%' 
and xr.SYSTEM_OF_RECORD = 'OMS2'
and xr.OMS2_SESSION_KEY = 'D' || new_xr.OMS2_SESSION_KEY
/*and exists (select 1 from ODS_STAGE.CAPTURE_SESSION_XR z where (1=1)
            and z.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
            and z.CAPTURE_SESSION_OID = new_xr.CAPTURE_SESSION_OID)*/
and not exists (select 1 from OMS2_CS_IMAGE_FIX z where z.OLD_CAPTURE_SESSION_OID = xr.CAPTURE_SESSION_OID)
and not exists (select 1 from  ods_own.event e where new_xr.job_nbr = e.event_ref_id and e.event_type = 'PRESTIGEIMAGES')

&


/*-----------------------------------------------*/
/* TASK No. 37 */
/* Fix IMAGE CAPTURE_SESSION_OID */

merge into ODS_OWN.IMAGE d USING (
select
    i.IMAGE_OID
    ,cif.NEW_CAPTURE_SESSION_OID
    ,cif.OLD_CAPTURE_SESSION_OID
    ,sysdate as ODS_MODIFY_DATE
from
    OMS2_CS_IMAGE_FIX cif
    ,ODS_OWN.IMAGE i
where (1=1)
    and cif.OLD_CAPTURE_SESSION_OID = i.CAPTURE_SESSION_OID
    and i.CAPTURE_SESSION_OID <> cif.NEW_CAPTURE_SESSION_OID
    and cif.ODS_CREATE_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - 3
) s
ON (s.IMAGE_OID=d.IMAGE_OID)
WHEN MATCHED THEN UPDATE SET
    d.CAPTURE_SESSION_OID = s.NEW_CAPTURE_SESSION_OID
    ,d.ODS_MODIFY_DATE = s.ODS_MODIFY_DATE


&


/*-----------------------------------------------*/
/* TASK No. 38 */
/* Fix ORDER_LINE_ELEMENT CAPTURE_SESSION_OID */

merge into ODS_OWN.ORDER_LINE_ELEMENT d USING (
select
    i.ORDER_LINE_ELEMENT_OID
    ,cif.NEW_CAPTURE_SESSION_OID
    ,cif.OLD_CAPTURE_SESSION_OID
    ,sysdate as ODS_MODIFY_DATE
from
    OMS2_CS_IMAGE_FIX cif
    ,ODS_OWN.ORDER_LINE_ELEMENT i
where (1=1)
    and cif.OLD_CAPTURE_SESSION_OID = i.CAPTURE_SESSION_OID
    and i.CAPTURE_SESSION_OID <> cif.NEW_CAPTURE_SESSION_OID
    and cif.ODS_CREATE_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - 3
) s
ON (s.ORDER_LINE_ELEMENT_OID=d.ORDER_LINE_ELEMENT_OID)
WHEN MATCHED THEN UPDATE SET
    d.CAPTURE_SESSION_OID = s.NEW_CAPTURE_SESSION_OID
    ,d.ODS_MODIFY_DATE = s.ODS_MODIFY_DATE


&


/*-----------------------------------------------*/
/* TASK No. 39 */
merge into ods_own.capture_session t
using
(
select cs.capture_session_oid
, sa.alias as access_code
from ods_own.capture_session cs
, ods_own.subject_alias sa
, ods_own.subject_alias_type sat
where 1=1
and cs.subject_oid = sa.subject_oid
and sa.subject_alias_type_oid = sat.subject_alias_type_oid
and sat.alias_type = 'qlabAccessCode'
and sa.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap
) s
on ( t.capture_session_oid = s.capture_session_oid )
when matched then update
set t.access_code = s.access_code
, t.ods_modify_date = sysdate
where decode(s.access_code,t.access_code,1,0) = 0

&

/*-----------------------------------------------*/
/* TASK No. 40 */

merge into ods_own.capture_session t
using
(
select cs.capture_session_oid
, sa.alias as access_code
from ods_own.capture_session cs
, ods_own.subject_alias sa
, ods_own.subject_alias_type sat
where 1=1
and cs.subject_oid = sa.subject_oid
and sa.subject_alias_type_oid = sat.subject_alias_type_oid
and sat.alias_type = 'qlabAccessCode'
and cs.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap
) s
on ( t.capture_session_oid = s.capture_session_oid )
when matched then update
set t.access_code = s.access_code
, t.ods_modify_date = sysdate
where decode(s.access_code,t.access_code,1,0) = 0

&

/*-----------------------------------------------*/
/* TASK No. 41 */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
+ nvl((TIMEZONE_OFFSET/24), 0) 
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

/*
UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR('2024-09-11 04:59:14.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=#LIFETOUCH_PROJECT.v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/

&

/*-----------------------------------------------*/
/* TASK No. 42 */

INSERT INTO ODS_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
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
,'LOAD_OMS2_CAPTURE_SESSION_PKG'
,'027'
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
INSERT INTO ODS_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
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
#LIFETOUCH_PROJECT.v_cdc_load_table_name,
30726290200,
'LOAD_OMS2_CAPTURE_SESSION_PKG',
'027',
TO_DATE(
             SUBSTR('2024-09-11 04:59:14.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR ('#LIFETOUCH_PROJECT.v_cdc_load_date', 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,#LIFETOUCH_PROJECT.v_cdc_overlap,
SYSDATE,
 :v_env)
*/
