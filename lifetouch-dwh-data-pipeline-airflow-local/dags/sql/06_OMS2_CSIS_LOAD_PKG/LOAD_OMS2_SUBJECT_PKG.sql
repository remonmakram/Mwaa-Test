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

-- drop table RAX_APP_USER.C$_0OMS2_LT_SUBJECT_STG purge

-- &


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Create work table */

-- create table RAX_APP_USER.C$_0OMS2_LT_SUBJECT_STG
-- (
-- 	C1_SUBJECT_KEY	VARCHAR2(24) NULL,
-- 	C2_FIRST_NAME	VARCHAR2(40) NULL,
-- 	C3_LAST_NAME	VARCHAR2(40) NULL,
-- 	C4_MIDDLE_NAME	VARCHAR2(40) NULL,
-- 	C5_MALE_FEMALE_CODE	VARCHAR2(15) NULL,
-- 	C6_EMAIL_ADDRESS	VARCHAR2(50) NULL,
-- 	C7_ALT_EMAIL_ADDRESS	VARCHAR2(50) NULL,
-- 	C8_ADDRESS1	VARCHAR2(30) NULL,
-- 	C9_ADDRESS2	VARCHAR2(30) NULL,
-- 	C10_CITY	VARCHAR2(50) NULL,
-- 	C11_ZIP_CODE	VARCHAR2(10) NULL,
-- 	C12_SUBJECT_CLASS	VARCHAR2(20) NULL,
-- 	C13_STATE	VARCHAR2(2) NULL,
-- 	C14_COUNTRY	VARCHAR2(40) NULL,
-- 	C15_MAJOR	VARCHAR2(50) NULL,
-- 	C16_MINOR	VARCHAR2(50) NULL,
-- 	C17_ORGANIZATION	VARCHAR2(20) NULL,
-- 	C18_SQUADRON	VARCHAR2(5) NULL,
-- 	C19_STATUS	VARCHAR2(15) NULL,
-- 	C20_CREATETS	DATE NULL,
-- 	C21_MODIFYTS	DATE NULL,
-- 	C22_CREATEUSERID	VARCHAR2(40) NULL,
-- 	C23_MODIFYUSERID	VARCHAR2(40) NULL,
-- 	C24_CREATEPROGID	VARCHAR2(40) NULL,
-- 	C25_MODIFYPROGID	VARCHAR2(40) NULL,
-- 	C26_LOCKID	NUMBER NULL,
-- 	C27_SUBJECT_ID	VARCHAR2(15) NULL,
-- 	C28_ROLE	VARCHAR2(15) NULL,
-- 	C29_ALTERNATE_PHONE_NUMBER	VARCHAR2(12) NULL,
-- 	C30_PHONE_NUMBER	VARCHAR2(12) NULL,
-- 	C31_X_REF_ID	VARCHAR2(15) NULL,
-- 	C32_TCPA_OPT_IN	VARCHAR2(1) NULL,
-- 	C33_CASL_OPT_IN	VARCHAR2(1) NULL,
-- 	C34_EXTN_SUBJECT_ID	VARCHAR2(40) NULL
-- )
-- NOLOGGING

-- &


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Load data */

/* SOURCE CODE */


-- select	
-- 	trim(LT_SUBJECT.SUBJECT_KEY)	   C1_SUBJECT_KEY,
-- 	LT_SUBJECT.FIRST_NAME	   C2_FIRST_NAME,
-- 	LT_SUBJECT.LAST_NAME	   C3_LAST_NAME,
-- 	LT_SUBJECT.MIDDLE_NAME	   C4_MIDDLE_NAME,
-- 	LT_SUBJECT.MALE_FEMALE_CODE	   C5_MALE_FEMALE_CODE,
-- 	LT_SUBJECT.EMAIL_ADDRESS	   C6_EMAIL_ADDRESS,
-- 	LT_SUBJECT.ALT_EMAIL_ADDRESS	   C7_ALT_EMAIL_ADDRESS,
-- 	LT_SUBJECT.ADDRESS1	   C8_ADDRESS1,
-- 	LT_SUBJECT.ADDRESS2	   C9_ADDRESS2,
-- 	trim(LT_SUBJECT.CITY)	   C10_CITY,
-- 	LT_SUBJECT.ZIP_CODE	   C11_ZIP_CODE,
-- 	LT_SUBJECT.SUBJECT_CLASS	   C12_SUBJECT_CLASS,
-- 	LT_SUBJECT.STATE	   C13_STATE,
-- 	LT_SUBJECT.COUNTRY	   C14_COUNTRY,
-- 	LT_SUBJECT.MAJOR	   C15_MAJOR,
-- 	LT_SUBJECT.MINOR	   C16_MINOR,
-- 	LT_SUBJECT.ORGANIZATION	   C17_ORGANIZATION,
-- 	LT_SUBJECT.SQUADRON	   C18_SQUADRON,
-- 	trim(LT_SUBJECT.STATUS)	   C19_STATUS,
-- 	LT_SUBJECT.CREATETS	   C20_CREATETS,
-- 	LT_SUBJECT.MODIFYTS	   C21_MODIFYTS,
-- 	LT_SUBJECT.CREATEUSERID	   C22_CREATEUSERID,
-- 	LT_SUBJECT.MODIFYUSERID	   C23_MODIFYUSERID,
-- 	LT_SUBJECT.CREATEPROGID	   C24_CREATEPROGID,
-- 	LT_SUBJECT.MODIFYPROGID	   C25_MODIFYPROGID,
-- 	LT_SUBJECT.LOCKID	   C26_LOCKID,
-- 	LT_SUBJECT.SUBJECT_ID	   C27_SUBJECT_ID,
-- 	LT_SUBJECT.ROLE	   C28_ROLE,
-- 	LT_SUBJECT.ALTERNATE_PHONE_NUMBER	   C29_ALTERNATE_PHONE_NUMBER,
-- 	LT_SUBJECT.PHONE_NUMBER	   C30_PHONE_NUMBER,
-- 	LT_SUBJECT.X_REF_ID	   C31_X_REF_ID,
-- 	LT_SUBJECT.TCPA_OPT_IN	   C32_TCPA_OPT_IN,
-- 	LT_SUBJECT.CASL_OPT_IN	   C33_CASL_OPT_IN,
-- 	LT_SUBJECT.EXTN_SUBJECT_ID	   C34_EXTN_SUBJECT_ID
-- from	OMS2_OWN.LT_SUBJECT   LT_SUBJECT
-- where	(1=1)
-- And (LT_SUBJECT.MODIFYTS >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
-- )







-- &

-- /* TARGET CODE */
-- insert /*+ append */ into RAX_APP_USER.C$_0OMS2_LT_SUBJECT_STG
-- (
-- 	C1_SUBJECT_KEY,
-- 	C2_FIRST_NAME,
-- 	C3_LAST_NAME,
-- 	C4_MIDDLE_NAME,
-- 	C5_MALE_FEMALE_CODE,
-- 	C6_EMAIL_ADDRESS,
-- 	C7_ALT_EMAIL_ADDRESS,
-- 	C8_ADDRESS1,
-- 	C9_ADDRESS2,
-- 	C10_CITY,
-- 	C11_ZIP_CODE,
-- 	C12_SUBJECT_CLASS,
-- 	C13_STATE,
-- 	C14_COUNTRY,
-- 	C15_MAJOR,
-- 	C16_MINOR,
-- 	C17_ORGANIZATION,
-- 	C18_SQUADRON,
-- 	C19_STATUS,
-- 	C20_CREATETS,
-- 	C21_MODIFYTS,
-- 	C22_CREATEUSERID,
-- 	C23_MODIFYUSERID,
-- 	C24_CREATEPROGID,
-- 	C25_MODIFYPROGID,
-- 	C26_LOCKID,
-- 	C27_SUBJECT_ID,
-- 	C28_ROLE,
-- 	C29_ALTERNATE_PHONE_NUMBER,
-- 	C30_PHONE_NUMBER,
-- 	C31_X_REF_ID,
-- 	C32_TCPA_OPT_IN,
-- 	C33_CASL_OPT_IN,
-- 	C34_EXTN_SUBJECT_ID
-- )
-- values
-- (
-- 	:C1_SUBJECT_KEY,
-- 	:C2_FIRST_NAME,
-- 	:C3_LAST_NAME,
-- 	:C4_MIDDLE_NAME,
-- 	:C5_MALE_FEMALE_CODE,
-- 	:C6_EMAIL_ADDRESS,
-- 	:C7_ALT_EMAIL_ADDRESS,
-- 	:C8_ADDRESS1,
-- 	:C9_ADDRESS2,
-- 	:C10_CITY,
-- 	:C11_ZIP_CODE,
-- 	:C12_SUBJECT_CLASS,
-- 	:C13_STATE,
-- 	:C14_COUNTRY,
-- 	:C15_MAJOR,
-- 	:C16_MINOR,
-- 	:C17_ORGANIZATION,
-- 	:C18_SQUADRON,
-- 	:C19_STATUS,
-- 	:C20_CREATETS,
-- 	:C21_MODIFYTS,
-- 	:C22_CREATEUSERID,
-- 	:C23_MODIFYUSERID,
-- 	:C24_CREATEPROGID,
-- 	:C25_MODIFYPROGID,
-- 	:C26_LOCKID,
-- 	:C27_SUBJECT_ID,
-- 	:C28_ROLE,
-- 	:C29_ALTERNATE_PHONE_NUMBER,
-- 	:C30_PHONE_NUMBER,
-- 	:C31_X_REF_ID,
-- 	:C32_TCPA_OPT_IN,
-- 	:C33_CASL_OPT_IN,
-- 	:C34_EXTN_SUBJECT_ID
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0OMS2_LT_SUBJECT_STG',
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

-- drop table RAX_APP_USER.I$_OMS2_LT_SUBJECT_STG1999001 
BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_OMS2_LT_SUBJECT_STG1999001';
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

create table RAX_APP_USER.I$_OMS2_LT_SUBJECT_STG1999001
(
	SUBJECT_KEY	VARCHAR2(24) NULL,
	FIRST_NAME	VARCHAR2(40) NULL,
	LAST_NAME	VARCHAR2(40) NULL,
	MIDDLE_NAME	VARCHAR2(40) NULL,
	MALE_FEMALE_CODE	VARCHAR2(15) NULL,
	EMAIL_ADDRESS	VARCHAR2(50) NULL,
	ALT_EMAIL_ADDRESS	VARCHAR2(50) NULL,
	ADDRESS1	VARCHAR2(30) NULL,
	ADDRESS2	VARCHAR2(30) NULL,
	CITY	VARCHAR2(50) NULL,
	ZIP_CODE	VARCHAR2(10) NULL,
	SUBJECT_CLASS	VARCHAR2(20) NULL,
	STATE	VARCHAR2(2) NULL,
	COUNTRY	VARCHAR2(40) NULL,
	MAJOR	VARCHAR2(50) NULL,
	MINOR	VARCHAR2(50) NULL,
	ORGANIZATION	VARCHAR2(20) NULL,
	SQUADRON	VARCHAR2(5) NULL,
	STATUS	VARCHAR2(15) NULL,
	CREATETS	DATE NULL,
	MODIFYTS	DATE NULL,
	CREATEUSERID	VARCHAR2(40) NULL,
	MODIFYUSERID	VARCHAR2(40) NULL,
	CREATEPROGID	VARCHAR2(40) NULL,
	MODIFYPROGID	VARCHAR2(40) NULL,
	LOCKID	NUMBER NULL,
	SUBJECT_ID	VARCHAR2(15) NULL,
	ROLE	VARCHAR2(15) NULL,
	ALTERNATE_PHONE_NUMBER	VARCHAR2(12) NULL,
	PHONE_NUMBER	VARCHAR2(12) NULL,
	X_REF_ID	VARCHAR2(15) NULL,
	TCPA_OPT_IN	VARCHAR2(1) NULL,
	CASL_OPT_IN	VARCHAR2(1) NULL,
	EXTN_SUBJECT_ID	VARCHAR2(40) NULL,
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
 


  


insert into	RAX_APP_USER.I$_OMS2_LT_SUBJECT_STG1999001
(
	SUBJECT_KEY,
	FIRST_NAME,
	LAST_NAME,
	MIDDLE_NAME,
	MALE_FEMALE_CODE,
	EMAIL_ADDRESS,
	ALT_EMAIL_ADDRESS,
	ADDRESS1,
	ADDRESS2,
	CITY,
	ZIP_CODE,
	SUBJECT_CLASS,
	STATE,
	COUNTRY,
	MAJOR,
	MINOR,
	ORGANIZATION,
	SQUADRON,
	STATUS,
	CREATETS,
	MODIFYTS,
	CREATEUSERID,
	MODIFYUSERID,
	CREATEPROGID,
	MODIFYPROGID,
	LOCKID,
	SUBJECT_ID,
	ROLE,
	ALTERNATE_PHONE_NUMBER,
	PHONE_NUMBER,
	X_REF_ID,
	TCPA_OPT_IN,
	CASL_OPT_IN,
	EXTN_SUBJECT_ID,
	IND_UPDATE
)
select 
SUBJECT_KEY,
	FIRST_NAME,
	LAST_NAME,
	MIDDLE_NAME,
	MALE_FEMALE_CODE,
	EMAIL_ADDRESS,
	ALT_EMAIL_ADDRESS,
	ADDRESS1,
	ADDRESS2,
	CITY,
	ZIP_CODE,
	SUBJECT_CLASS,
	STATE,
	COUNTRY,
	MAJOR,
	MINOR,
	ORGANIZATION,
	SQUADRON,
	STATUS,
	CREATETS,
	MODIFYTS,
	CREATEUSERID,
	MODIFYUSERID,
	CREATEPROGID,
	MODIFYPROGID,
	LOCKID,
	SUBJECT_ID,
	ROLE,
	ALTERNATE_PHONE_NUMBER,
	PHONE_NUMBER,
	X_REF_ID,
	TCPA_OPT_IN,
	CASL_OPT_IN,
	EXTN_SUBJECT_ID,
	IND_UPDATE
 from (


select 	 
	
	C1_SUBJECT_KEY SUBJECT_KEY,
	C2_FIRST_NAME FIRST_NAME,
	C3_LAST_NAME LAST_NAME,
	C4_MIDDLE_NAME MIDDLE_NAME,
	C5_MALE_FEMALE_CODE MALE_FEMALE_CODE,
	C6_EMAIL_ADDRESS EMAIL_ADDRESS,
	C7_ALT_EMAIL_ADDRESS ALT_EMAIL_ADDRESS,
	C8_ADDRESS1 ADDRESS1,
	C9_ADDRESS2 ADDRESS2,
	C10_CITY CITY,
	C11_ZIP_CODE ZIP_CODE,
	C12_SUBJECT_CLASS SUBJECT_CLASS,
	C13_STATE STATE,
	C14_COUNTRY COUNTRY,
	C15_MAJOR MAJOR,
	C16_MINOR MINOR,
	C17_ORGANIZATION ORGANIZATION,
	C18_SQUADRON SQUADRON,
	C19_STATUS STATUS,
	C20_CREATETS CREATETS,
	C21_MODIFYTS MODIFYTS,
	C22_CREATEUSERID CREATEUSERID,
	C23_MODIFYUSERID MODIFYUSERID,
	C24_CREATEPROGID CREATEPROGID,
	C25_MODIFYPROGID MODIFYPROGID,
	C26_LOCKID LOCKID,
	C27_SUBJECT_ID SUBJECT_ID,
	C28_ROLE ROLE,
	C29_ALTERNATE_PHONE_NUMBER ALTERNATE_PHONE_NUMBER,
	C30_PHONE_NUMBER PHONE_NUMBER,
	C31_X_REF_ID X_REF_ID,
	C32_TCPA_OPT_IN TCPA_OPT_IN,
	C33_CASL_OPT_IN CASL_OPT_IN,
	C34_EXTN_SUBJECT_ID EXTN_SUBJECT_ID,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0OMS2_LT_SUBJECT_STG
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.OMS2_LT_SUBJECT_STG T
	where	T.SUBJECT_KEY	= S.SUBJECT_KEY 
		 and ((T.FIRST_NAME = S.FIRST_NAME) or (T.FIRST_NAME IS NULL and S.FIRST_NAME IS NULL)) and
		((T.LAST_NAME = S.LAST_NAME) or (T.LAST_NAME IS NULL and S.LAST_NAME IS NULL)) and
		((T.MIDDLE_NAME = S.MIDDLE_NAME) or (T.MIDDLE_NAME IS NULL and S.MIDDLE_NAME IS NULL)) and
		((T.MALE_FEMALE_CODE = S.MALE_FEMALE_CODE) or (T.MALE_FEMALE_CODE IS NULL and S.MALE_FEMALE_CODE IS NULL)) and
		((T.EMAIL_ADDRESS = S.EMAIL_ADDRESS) or (T.EMAIL_ADDRESS IS NULL and S.EMAIL_ADDRESS IS NULL)) and
		((T.ALT_EMAIL_ADDRESS = S.ALT_EMAIL_ADDRESS) or (T.ALT_EMAIL_ADDRESS IS NULL and S.ALT_EMAIL_ADDRESS IS NULL)) and
		((T.ADDRESS1 = S.ADDRESS1) or (T.ADDRESS1 IS NULL and S.ADDRESS1 IS NULL)) and
		((T.ADDRESS2 = S.ADDRESS2) or (T.ADDRESS2 IS NULL and S.ADDRESS2 IS NULL)) and
		((T.CITY = S.CITY) or (T.CITY IS NULL and S.CITY IS NULL)) and
		((T.ZIP_CODE = S.ZIP_CODE) or (T.ZIP_CODE IS NULL and S.ZIP_CODE IS NULL)) and
		((T.SUBJECT_CLASS = S.SUBJECT_CLASS) or (T.SUBJECT_CLASS IS NULL and S.SUBJECT_CLASS IS NULL)) and
		((T.STATE = S.STATE) or (T.STATE IS NULL and S.STATE IS NULL)) and
		((T.COUNTRY = S.COUNTRY) or (T.COUNTRY IS NULL and S.COUNTRY IS NULL)) and
		((T.MAJOR = S.MAJOR) or (T.MAJOR IS NULL and S.MAJOR IS NULL)) and
		((T.MINOR = S.MINOR) or (T.MINOR IS NULL and S.MINOR IS NULL)) and
		((T.ORGANIZATION = S.ORGANIZATION) or (T.ORGANIZATION IS NULL and S.ORGANIZATION IS NULL)) and
		((T.SQUADRON = S.SQUADRON) or (T.SQUADRON IS NULL and S.SQUADRON IS NULL)) and
		((T.STATUS = S.STATUS) or (T.STATUS IS NULL and S.STATUS IS NULL)) and
		((T.CREATETS = S.CREATETS) or (T.CREATETS IS NULL and S.CREATETS IS NULL)) and
		((T.MODIFYTS = S.MODIFYTS) or (T.MODIFYTS IS NULL and S.MODIFYTS IS NULL)) and
		((T.CREATEUSERID = S.CREATEUSERID) or (T.CREATEUSERID IS NULL and S.CREATEUSERID IS NULL)) and
		((T.MODIFYUSERID = S.MODIFYUSERID) or (T.MODIFYUSERID IS NULL and S.MODIFYUSERID IS NULL)) and
		((T.CREATEPROGID = S.CREATEPROGID) or (T.CREATEPROGID IS NULL and S.CREATEPROGID IS NULL)) and
		((T.MODIFYPROGID = S.MODIFYPROGID) or (T.MODIFYPROGID IS NULL and S.MODIFYPROGID IS NULL)) and
		((T.LOCKID = S.LOCKID) or (T.LOCKID IS NULL and S.LOCKID IS NULL)) and
		((T.SUBJECT_ID = S.SUBJECT_ID) or (T.SUBJECT_ID IS NULL and S.SUBJECT_ID IS NULL)) and
		((T.ROLE = S.ROLE) or (T.ROLE IS NULL and S.ROLE IS NULL)) and
		((T.ALTERNATE_PHONE_NUMBER = S.ALTERNATE_PHONE_NUMBER) or (T.ALTERNATE_PHONE_NUMBER IS NULL and S.ALTERNATE_PHONE_NUMBER IS NULL)) and
		((T.PHONE_NUMBER = S.PHONE_NUMBER) or (T.PHONE_NUMBER IS NULL and S.PHONE_NUMBER IS NULL)) and
		((T.X_REF_ID = S.X_REF_ID) or (T.X_REF_ID IS NULL and S.X_REF_ID IS NULL)) and
		((T.TCPA_OPT_IN = S.TCPA_OPT_IN) or (T.TCPA_OPT_IN IS NULL and S.TCPA_OPT_IN IS NULL)) and
		((T.CASL_OPT_IN = S.CASL_OPT_IN) or (T.CASL_OPT_IN IS NULL and S.CASL_OPT_IN IS NULL)) and
		((T.EXTN_SUBJECT_ID = S.EXTN_SUBJECT_ID) or (T.EXTN_SUBJECT_ID IS NULL and S.EXTN_SUBJECT_ID IS NULL))
        )

  
  

  



&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_OMS2_LT_SUBJECT_STG1999001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Create Index on flow table */

-- create index	RAX_APP_USER.I$_OMS2_LT_SUBJECT_STG_IDX1999001
-- on		RAX_APP_USER.I$_OMS2_LT_SUBJECT_STG1999001 (SUBJECT_KEY)
-- NOLOGGING
BEGIN
    EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_OMS2_LT_SUBJECT_STG_IDX1999001
on		RAX_APP_USER.I$_OMS2_LT_SUBJECT_STG1999001 (SUBJECT_KEY)
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

merge into	ODS_STAGE.OMS2_LT_SUBJECT_STG T
using	RAX_APP_USER.I$_OMS2_LT_SUBJECT_STG1999001 S
on	(
		T.SUBJECT_KEY=S.SUBJECT_KEY
	)
when matched
then update set
	T.FIRST_NAME	= S.FIRST_NAME,
	T.LAST_NAME	= S.LAST_NAME,
	T.MIDDLE_NAME	= S.MIDDLE_NAME,
	T.MALE_FEMALE_CODE	= S.MALE_FEMALE_CODE,
	T.EMAIL_ADDRESS	= S.EMAIL_ADDRESS,
	T.ALT_EMAIL_ADDRESS	= S.ALT_EMAIL_ADDRESS,
	T.ADDRESS1	= S.ADDRESS1,
	T.ADDRESS2	= S.ADDRESS2,
	T.CITY	= S.CITY,
	T.ZIP_CODE	= S.ZIP_CODE,
	T.SUBJECT_CLASS	= S.SUBJECT_CLASS,
	T.STATE	= S.STATE,
	T.COUNTRY	= S.COUNTRY,
	T.MAJOR	= S.MAJOR,
	T.MINOR	= S.MINOR,
	T.ORGANIZATION	= S.ORGANIZATION,
	T.SQUADRON	= S.SQUADRON,
	T.STATUS	= S.STATUS,
	T.CREATETS	= S.CREATETS,
	T.MODIFYTS	= S.MODIFYTS,
	T.CREATEUSERID	= S.CREATEUSERID,
	T.MODIFYUSERID	= S.MODIFYUSERID,
	T.CREATEPROGID	= S.CREATEPROGID,
	T.MODIFYPROGID	= S.MODIFYPROGID,
	T.LOCKID	= S.LOCKID,
	T.SUBJECT_ID	= S.SUBJECT_ID,
	T.ROLE	= S.ROLE,
	T.ALTERNATE_PHONE_NUMBER	= S.ALTERNATE_PHONE_NUMBER,
	T.PHONE_NUMBER	= S.PHONE_NUMBER,
	T.X_REF_ID	= S.X_REF_ID,
	T.TCPA_OPT_IN	= S.TCPA_OPT_IN,
	T.CASL_OPT_IN	= S.CASL_OPT_IN,
	T.EXTN_SUBJECT_ID	= S.EXTN_SUBJECT_ID
	,                                 T.ODS_MODIFY_DATE	= sysdate
when not matched
then insert
	(
	T.SUBJECT_KEY,
	T.FIRST_NAME,
	T.LAST_NAME,
	T.MIDDLE_NAME,
	T.MALE_FEMALE_CODE,
	T.EMAIL_ADDRESS,
	T.ALT_EMAIL_ADDRESS,
	T.ADDRESS1,
	T.ADDRESS2,
	T.CITY,
	T.ZIP_CODE,
	T.SUBJECT_CLASS,
	T.STATE,
	T.COUNTRY,
	T.MAJOR,
	T.MINOR,
	T.ORGANIZATION,
	T.SQUADRON,
	T.STATUS,
	T.CREATETS,
	T.MODIFYTS,
	T.CREATEUSERID,
	T.MODIFYUSERID,
	T.CREATEPROGID,
	T.MODIFYPROGID,
	T.LOCKID,
	T.SUBJECT_ID,
	T.ROLE,
	T.ALTERNATE_PHONE_NUMBER,
	T.PHONE_NUMBER,
	T.X_REF_ID,
	T.TCPA_OPT_IN,
	T.CASL_OPT_IN,
	T.EXTN_SUBJECT_ID
	,                                  T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.SUBJECT_KEY,
	S.FIRST_NAME,
	S.LAST_NAME,
	S.MIDDLE_NAME,
	S.MALE_FEMALE_CODE,
	S.EMAIL_ADDRESS,
	S.ALT_EMAIL_ADDRESS,
	S.ADDRESS1,
	S.ADDRESS2,
	S.CITY,
	S.ZIP_CODE,
	S.SUBJECT_CLASS,
	S.STATE,
	S.COUNTRY,
	S.MAJOR,
	S.MINOR,
	S.ORGANIZATION,
	S.SQUADRON,
	S.STATUS,
	S.CREATETS,
	S.MODIFYTS,
	S.CREATEUSERID,
	S.MODIFYUSERID,
	S.CREATEPROGID,
	S.MODIFYPROGID,
	S.LOCKID,
	S.SUBJECT_ID,
	S.ROLE,
	S.ALTERNATE_PHONE_NUMBER,
	S.PHONE_NUMBER,
	S.X_REF_ID,
	S.TCPA_OPT_IN,
	S.CASL_OPT_IN,
	S.EXTN_SUBJECT_ID
	,                                  sysdate,
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

drop table RAX_APP_USER.I$_OMS2_LT_SUBJECT_STG1999001 

&


/*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */

drop table RAX_APP_USER.C$_0OMS2_LT_SUBJECT_STG purge

&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Pivot OMS2_SUBJECT_ID into XR for SM rows */

merge into ods_stage.subject_xr t
using
(
select sa.subject_oid
, sa.alias
from ods_own.subject_alias sa
, ods_own.subject_alias_type sat
where sa.subject_alias_type_oid = sat.subject_alias_type_oid
and sat.alias_type = 'omsSubjectId'
and sa.alias not in ('True') -- SODS-1930
and sa.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap
) s
on (s.subject_oid = t.subject_oid)
when matched then update
set t.oms2_subject_id = s.alias
where decode(s.alias,t.oms2_subject_id,1,0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Update the OMS2 keys on the SM sourced XR rows */

MERGE INTO ODS_STAGE.SUBJECT_XR d
USING
(
  SELECT case when a.oms2_subject_key like 'D%' then substr(a.OMS2_SUBJECT_KEY,2,50) else a.OMS2_SUBJECT_KEY end as OMS2_SUBJECT_KEY
    ,a.OMS2_SUBJECT_ID
    ,a.OMS2_EXTN_SUBJECT_ID
  FROM 
    ODS_STAGE.SUBJECT_XR a
  WHERE (1=1)
    and a.system_of_record = 'OMS2'
    and exists (select 1 from ODS_STAGE.SUBJECT_XR b where b.system_of_record = 'SM' and b.oms2_subject_id = a.oms2_subject_id
    and b.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap)
) s 
ON (s.OMS2_SUBJECT_ID=d.OMS2_SUBJECT_ID)
WHEN MATCHED THEN UPDATE SET
     d.OMS2_SUBJECT_KEY = s.OMS2_SUBJECT_KEY
    ,d.OMS2_EXTN_SUBJECT_ID = s.OMS2_EXTN_SUBJECT_ID
    ,d.ODS_MODIFY_DATE = sysdate
WHERE 
    decode(s.OMS2_SUBJECT_KEY,d.OMS2_SUBJECT_KEY,1,0) = 0
    or decode(s.OMS2_EXTN_SUBJECT_ID,d.OMS2_EXTN_SUBJECT_ID,1,0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* drop oms2_dupe_subjects */

-- drop table oms2_dupe_subjects
BEGIN
    EXECUTE IMMEDIATE 'drop table oms2_dupe_subjects ';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* create oms2_dupe_subjects */

create table oms2_dupe_subjects as
select distinct s_xr2.SUBJECT_OID
,'D' || s_xr2.OMS2_SUBJECT_KEY OMS2_SUBJECT_KEY
from ods_stage.subject_xr s_xr
, ods_stage.subject_xr s_xr2
where s_xr.oms2_subject_id = s_xr2.oms2_subject_id
and s_xr2.system_of_record = 'OMS2'
and s_xr2.OMS2_SUBJECT_KEY not like 'D%' -- already marked, just waiting to be deleted
and s_xr.oms2_subject_id is not null
and s_xr.system_of_record = 'SM'
and s_xr.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* create index oms2_dupe_subjects_pk */

create unique index oms2_dupe_subjects_pk on oms2_dupe_subjects(SUBJECT_OID)

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Mark duplicate by OMS2_SUBJECT_KEY */

merge into ODS_STAGE.SUBJECT_XR d
USING
(
select
    SUBJECT_OID
    ,OMS2_SUBJECT_KEY OMS2_SUBJECT_KEY
from oms2_dupe_subjects
) s
ON (s.SUBJECT_OID=d.SUBJECT_OID)
WHEN MATCHED THEN UPDATE SET
     d.OMS2_SUBJECT_KEY = s.OMS2_SUBJECT_KEY
    ,d.ODS_MODIFY_DATE = sysdate

&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* ODS_STAGE.SUBJECT_XR */

-- OMS2
MERGE INTO ODS_STAGE.SUBJECT_XR d 
USING 
(
  SELECT a.SUBJECT_KEY OMS2_SUBJECT_KEY
    ,a.SUBJECT_ID OMS2_SUBJECT_ID
    ,a.EXTN_SUBJECT_ID OMS2_EXTN_SUBJECT_ID
  FROM 
    ODS_STAGE.OMS2_LT_SUBJECT_STG a
  WHERE (1=1)
    and a.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) s
ON (s.OMS2_SUBJECT_ID=d.OMS2_SUBJECT_ID)
WHEN MATCHED THEN UPDATE SET
     d.OMS2_SUBJECT_KEY = s.OMS2_SUBJECT_KEY
    ,d.OMS2_EXTN_SUBJECT_ID = s.OMS2_EXTN_SUBJECT_ID
    ,d.ODS_MODIFY_DATE = sysdate
WHERE 
    decode(s.OMS2_SUBJECT_KEY,d.OMS2_SUBJECT_KEY,1,0) = 0
    or decode(s.OMS2_EXTN_SUBJECT_ID,d.OMS2_EXTN_SUBJECT_ID,1,0) = 0
WHEN NOT MATCHED THEN INSERT 
(
     SUBJECT_OID
    ,OMS2_SUBJECT_KEY
    ,OMS2_SUBJECT_ID
    ,OMS2_EXTN_SUBJECT_ID
    ,SYSTEM_OF_RECORD
    ,ODS_CREATE_DATE
    ,ODS_MODIFY_DATE
)
VALUES 
(
     ODS_STAGE.SUBJECT_OID_SEQ.nextval
    ,s.OMS2_SUBJECT_KEY
    ,s.OMS2_SUBJECT_ID
    ,s.OMS2_EXTN_SUBJECT_ID
    ,'OMS2'
    ,sysdate
    ,sysdate
)


&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* ODS_OWN.SUBJECT */

-- OMS2
MERGE INTO ODS_OWN.SUBJECT d 
USING 
(
  SELECT 
     xr.SUBJECT_OID
    ,a.LAST_NAME
    ,a.FIRST_NAME
    ,a.MIDDLE_NAME
    ,substr(a.SUBJECT_CLASS,1,10) GRADE
    ,a.ADDRESS1 ADDRESS_LINE_1
    ,a.ADDRESS2 ADDRESS_LINE_2
    ,a.CITY
    ,a.STATE
    ,a.ZIP_CODE POSTAL_CODE
    ,a.EMAIL_ADDRESS
    ,a.MAJOR
    ,a.MINOR
    ,a.SQUADRON
    ,sysdate as ODS_CREATE_DATE
    ,sysdate as ODS_MODIFY_DATE
    ,ss.SOURCE_SYSTEM_OID
    ,a.ZIP_CODE ZIP
    ,a.EXTN_SUBJECT_ID EXTERNAL_SUBJECT_ID
    ,a.MALE_FEMALE_CODE GENDER_CODE
    ,a.ALT_EMAIL_ADDRESS
    ,a.COUNTRY
    ,a.ALTERNATE_PHONE_NUMBER ALT_PHONE_NUMBER
    ,a.PHONE_NUMBER PHONE_NUMBER
    ,a.TCPA_OPT_IN TCPA_OPT_IN
    ,a.CASL_OPT_IN CASL_OPT_IN
    ,'Y' OMS2_AUGMENTED_IND
    ,case when a.STATUS='Active' then 1 else 0 end ACTIVE
    ,xr.OMS2_SUBJECT_ID OMS2_SUBJECT_ID
-- select *
  FROM 
    ODS_STAGE.OMS2_LT_SUBJECT_STG a 
    ,ODS_STAGE.SUBJECT_XR xr
    ,ODS_OWN.SOURCE_SYSTEM ss
  WHERE (1=1)	
    and xr.SYSTEM_OF_RECORD = 'OMS2'
    and a.SUBJECT_ID=xr.OMS2_SUBJECT_ID
    and ss.SOURCE_SYSTEM_SHORT_NAME='OMS2'
    and a.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) s
ON (s.SUBJECT_OID=d.SUBJECT_OID)
WHEN MATCHED THEN UPDATE SET
     d.LAST_NAME=s.LAST_NAME
    ,d.FIRST_NAME=s.FIRST_NAME
    ,d.MIDDLE_NAME=s.MIDDLE_NAME
    ,d.GRADE=s.GRADE
    ,d.ADDRESS_LINE_1=s.ADDRESS_LINE_1
    ,d.ADDRESS_LINE_2=s.ADDRESS_LINE_2
    ,d.CITY=s.CITY
    ,d.STATE=s.STATE
    ,d.POSTAL_CODE=s.POSTAL_CODE
    ,d.EMAIL_ADDRESS=s.EMAIL_ADDRESS
    ,d.MAJOR=s.MAJOR
    ,d.MINOR=s.MINOR
    ,d.SQUADRON=s.SQUADRON
    ,d.SOURCE_SYSTEM_OID=s.SOURCE_SYSTEM_OID
    ,d.ZIP=s.ZIP
    ,d.EXTERNAL_SUBJECT_ID=s.EXTERNAL_SUBJECT_ID
    ,d.GENDER_CODE=s.GENDER_CODE
    ,d.ALT_EMAIL_ADDRESS=s.ALT_EMAIL_ADDRESS
    ,d.COUNTRY=s.COUNTRY
    ,d.ALT_PHONE_NUMBER=s.ALT_PHONE_NUMBER
    ,d.PHONE_NUMBER=s.PHONE_NUMBER
    ,d.TCPA_OPT_IN=s.TCPA_OPT_IN
    ,d.CASL_OPT_IN=s.CASL_OPT_IN
    ,d.OMS2_AUGMENTED_IND=s.OMS2_AUGMENTED_IND
    ,d.ACTIVE=s.ACTIVE
    ,d.OMS2_SUBJECT_ID=s.OMS2_SUBJECT_ID
    ,d.ODS_MODIFY_DATE = s.ODS_MODIFY_DATE
WHERE 
    decode(s.LAST_NAME,d.LAST_NAME,1,0) = 0
    or decode(s.FIRST_NAME,d.FIRST_NAME,1,0) = 0
    or decode(s.MIDDLE_NAME,d.MIDDLE_NAME,1,0) = 0
    or decode(s.GRADE,d.GRADE,1,0) = 0
    or decode(s.ADDRESS_LINE_1,d.ADDRESS_LINE_1,1,0) = 0
    or decode(s.ADDRESS_LINE_2,d.ADDRESS_LINE_2,1,0) = 0
    or decode(s.CITY,d.CITY,1,0) = 0
    or decode(s.STATE,d.STATE,1,0) = 0
    or decode(s.POSTAL_CODE,d.POSTAL_CODE,1,0) = 0
    or decode(s.EMAIL_ADDRESS,d.EMAIL_ADDRESS,1,0) = 0
    or decode(s.MAJOR,d.MAJOR,1,0) = 0
    or decode(s.MINOR,d.MINOR,1,0) = 0
    or decode(s.SQUADRON,d.SQUADRON,1,0) = 0
    or decode(s.SOURCE_SYSTEM_OID,d.SOURCE_SYSTEM_OID,1,0) = 0
    or decode(s.ZIP,d.ZIP,1,0) = 0
    or decode(s.EXTERNAL_SUBJECT_ID,d.EXTERNAL_SUBJECT_ID,1,0) = 0
    or decode(s.GENDER_CODE,d.GENDER_CODE,1,0) = 0
    or decode(s.ALT_EMAIL_ADDRESS,d.ALT_EMAIL_ADDRESS,1,0) = 0
    or decode(s.COUNTRY,d.COUNTRY,1,0) = 0
    or decode(s.ALT_PHONE_NUMBER,d.ALT_PHONE_NUMBER,1,0) = 0
    or decode(s.PHONE_NUMBER,d.PHONE_NUMBER,1,0) = 0
    or decode(s.TCPA_OPT_IN,d.TCPA_OPT_IN,1,0) = 0
    or decode(s.CASL_OPT_IN,d.CASL_OPT_IN,1,0) = 0
    or decode(s.OMS2_AUGMENTED_IND,d.OMS2_AUGMENTED_IND,1,0) = 0
    or decode(s.ACTIVE,d.ACTIVE,1,0) = 0
    or decode(s.OMS2_SUBJECT_ID,d.OMS2_SUBJECT_ID,1,0) = 0
WHEN NOT MATCHED THEN INSERT 
(
     SUBJECT_OID
    ,LAST_NAME
    ,FIRST_NAME
    ,MIDDLE_NAME
    ,GRADE
    ,ADDRESS_LINE_1
    ,ADDRESS_LINE_2
    ,CITY
    ,STATE
    ,POSTAL_CODE
    ,EMAIL_ADDRESS
    ,MAJOR
    ,MINOR
    ,SQUADRON
    ,ODS_CREATE_DATE
    ,ODS_MODIFY_DATE
    ,SOURCE_SYSTEM_OID
    ,ZIP
    ,EXTERNAL_SUBJECT_ID
    ,GENDER_CODE
    ,ALT_EMAIL_ADDRESS
    ,COUNTRY
    ,ALT_PHONE_NUMBER
    ,PHONE_NUMBER
    ,TCPA_OPT_IN
    ,CASL_OPT_IN
    ,OMS2_AUGMENTED_IND
    ,ACTIVE
    ,OMS2_SUBJECT_ID
) 
VALUES 
(
     s.SUBJECT_OID
    ,s.LAST_NAME
    ,s.FIRST_NAME
    ,s.MIDDLE_NAME
    ,s.GRADE
    ,s.ADDRESS_LINE_1
    ,s.ADDRESS_LINE_2
    ,s.CITY
    ,s.STATE
    ,s.POSTAL_CODE
    ,s.EMAIL_ADDRESS
    ,s.MAJOR
    ,s.MINOR
    ,s.SQUADRON
    ,s.ODS_CREATE_DATE
    ,s.ODS_MODIFY_DATE
    ,s.SOURCE_SYSTEM_OID
    ,s.ZIP
    ,s.EXTERNAL_SUBJECT_ID
    ,s.GENDER_CODE
    ,s.ALT_EMAIL_ADDRESS
    ,s.COUNTRY
    ,s.ALT_PHONE_NUMBER
    ,s.PHONE_NUMBER
    ,s.TCPA_OPT_IN
    ,s.CASL_OPT_IN
    ,s.OMS2_AUGMENTED_IND
    ,s.ACTIVE
    ,s.OMS2_SUBJECT_ID
)


&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* ODS_OWN.SUBJECT regardless of SYSTEM_OF_RECORD */

-- OMS2 regardless of SYSTEM_OF_RECORD
MERGE INTO ODS_OWN.SUBJECT d 
USING 
(
  SELECT 
     xr.SUBJECT_OID
    ,a.ADDRESS1 ADDRESS_LINE_1
    ,a.ADDRESS2 ADDRESS_LINE_2
    ,a.CITY
    ,a.STATE
    ,a.ZIP_CODE POSTAL_CODE
    ,a.EMAIL_ADDRESS
    ,a.MAJOR
    ,a.MINOR
    ,a.SQUADRON
    ,sysdate as ODS_CREATE_DATE
    ,sysdate as ODS_MODIFY_DATE
    ,a.ZIP_CODE ZIP
    ,a.EXTN_SUBJECT_ID EXTERNAL_SUBJECT_ID
    ,a.MALE_FEMALE_CODE GENDER_CODE
    ,a.ALT_EMAIL_ADDRESS
    ,a.COUNTRY
    ,a.ALTERNATE_PHONE_NUMBER ALT_PHONE_NUMBER
    ,a.PHONE_NUMBER PHONE_NUMBER
    ,a.TCPA_OPT_IN TCPA_OPT_IN
    ,a.CASL_OPT_IN CASL_OPT_IN
    ,'Y' OMS2_AUGMENTED_IND
    ,case when a.STATUS='Active' then 1 else 0 end ACTIVE
    ,xr.OMS2_SUBJECT_ID OMS2_SUBJECT_ID
-- select *
  FROM 
    ODS_STAGE.OMS2_LT_SUBJECT_STG a 
    ,ODS_STAGE.SUBJECT_XR xr
  WHERE (1=1)	
    and a.SUBJECT_ID=xr.OMS2_SUBJECT_ID
    and a.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) s
ON (s.SUBJECT_OID=d.SUBJECT_OID)
WHEN MATCHED THEN UPDATE SET
    d.ADDRESS_LINE_1=s.ADDRESS_LINE_1
    ,d.ADDRESS_LINE_2=s.ADDRESS_LINE_2
    ,d.CITY=s.CITY
    ,d.STATE=s.STATE
    ,d.POSTAL_CODE=s.POSTAL_CODE
    ,d.EMAIL_ADDRESS=s.EMAIL_ADDRESS
    ,d.MAJOR=s.MAJOR
    ,d.MINOR=s.MINOR
    ,d.SQUADRON=s.SQUADRON
    ,d.ZIP=s.ZIP
    ,d.EXTERNAL_SUBJECT_ID=s.EXTERNAL_SUBJECT_ID
    ,d.GENDER_CODE=s.GENDER_CODE
    ,d.ALT_EMAIL_ADDRESS=s.ALT_EMAIL_ADDRESS
    ,d.COUNTRY=s.COUNTRY
    ,d.ALT_PHONE_NUMBER=s.ALT_PHONE_NUMBER
    ,d.PHONE_NUMBER=s.PHONE_NUMBER
    ,d.TCPA_OPT_IN=s.TCPA_OPT_IN
    ,d.CASL_OPT_IN=s.CASL_OPT_IN
    ,d.OMS2_AUGMENTED_IND=s.OMS2_AUGMENTED_IND
    ,d.ACTIVE=s.ACTIVE
    ,d.OMS2_SUBJECT_ID=s.OMS2_SUBJECT_ID
    ,d.ODS_MODIFY_DATE = s.ODS_MODIFY_DATE
WHERE 
    decode(s.ADDRESS_LINE_1,d.ADDRESS_LINE_1,1,0) = 0
    or decode(s.ADDRESS_LINE_2,d.ADDRESS_LINE_2,1,0) = 0
    or decode(s.CITY,d.CITY,1,0) = 0
    or decode(s.STATE,d.STATE,1,0) = 0
    or decode(s.POSTAL_CODE,d.POSTAL_CODE,1,0) = 0
    or decode(s.EMAIL_ADDRESS,d.EMAIL_ADDRESS,1,0) = 0
    or decode(s.MAJOR,d.MAJOR,1,0) = 0
    or decode(s.MINOR,d.MINOR,1,0) = 0
    or decode(s.SQUADRON,d.SQUADRON,1,0) = 0
    or decode(s.ZIP,d.ZIP,1,0) = 0
    or decode(s.EXTERNAL_SUBJECT_ID,d.EXTERNAL_SUBJECT_ID,1,0) = 0
    or decode(s.GENDER_CODE,d.GENDER_CODE,1,0) = 0
    or decode(s.ALT_EMAIL_ADDRESS,d.ALT_EMAIL_ADDRESS,1,0) = 0
    or decode(s.COUNTRY,d.COUNTRY,1,0) = 0
    or decode(s.ALT_PHONE_NUMBER,d.ALT_PHONE_NUMBER,1,0) = 0
    or decode(s.PHONE_NUMBER,d.PHONE_NUMBER,1,0) = 0
    or decode(s.TCPA_OPT_IN,d.TCPA_OPT_IN,1,0) = 0
    or decode(s.CASL_OPT_IN,d.CASL_OPT_IN,1,0) = 0
    or decode(s.OMS2_AUGMENTED_IND,d.OMS2_AUGMENTED_IND,1,0) = 0
    or decode(s.ACTIVE,d.ACTIVE,1,0) = 0
    or decode(s.OMS2_SUBJECT_ID,d.OMS2_SUBJECT_ID,1,0) = 0




&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* ODS_OWN.SUBJECT regardless of SYSTEM_OF_RECORD - SM CDC */

-- OMS2 regardless of SYSTEM_OF_RECORD
MERGE INTO ODS_OWN.SUBJECT d 
USING 
(
  SELECT 
     xr.SUBJECT_OID
    ,a.ADDRESS1 ADDRESS_LINE_1
    ,a.ADDRESS2 ADDRESS_LINE_2
    ,a.CITY
    ,a.STATE
    ,a.ZIP_CODE POSTAL_CODE
    ,a.EMAIL_ADDRESS
    ,a.MAJOR
    ,a.MINOR
    ,a.SQUADRON
    ,sysdate as ODS_CREATE_DATE
    ,sysdate as ODS_MODIFY_DATE
    ,a.ZIP_CODE ZIP
    ,a.EXTN_SUBJECT_ID EXTERNAL_SUBJECT_ID
    ,a.MALE_FEMALE_CODE GENDER_CODE
    ,a.ALT_EMAIL_ADDRESS
    ,a.COUNTRY
    ,a.ALTERNATE_PHONE_NUMBER ALT_PHONE_NUMBER
    ,a.PHONE_NUMBER PHONE_NUMBER
    ,a.TCPA_OPT_IN TCPA_OPT_IN
    ,a.CASL_OPT_IN CASL_OPT_IN
    ,'Y' OMS2_AUGMENTED_IND
    ,case when a.STATUS='Active' then 1 else 0 end ACTIVE
    ,xr.OMS2_SUBJECT_ID OMS2_SUBJECT_ID
-- select *
  FROM 
    ODS_STAGE.OMS2_LT_SUBJECT_STG a 
    ,ODS_STAGE.SUBJECT_XR xr
    ,ods_own.subject s
  WHERE (1=1)	
    and a.SUBJECT_ID=xr.OMS2_SUBJECT_ID
    and xr.system_of_record = 'SM'
    and xr.subject_oid = s.subject_oid
    and s.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) s
ON (s.SUBJECT_OID=d.SUBJECT_OID)
WHEN MATCHED THEN UPDATE SET
    d.ADDRESS_LINE_1=s.ADDRESS_LINE_1
    ,d.ADDRESS_LINE_2=s.ADDRESS_LINE_2
    ,d.CITY=s.CITY
    ,d.STATE=s.STATE
    ,d.POSTAL_CODE=s.POSTAL_CODE
    ,d.EMAIL_ADDRESS=s.EMAIL_ADDRESS
    ,d.MAJOR=s.MAJOR
    ,d.MINOR=s.MINOR
    ,d.SQUADRON=s.SQUADRON
    ,d.ZIP=s.ZIP
    ,d.EXTERNAL_SUBJECT_ID=s.EXTERNAL_SUBJECT_ID
    ,d.GENDER_CODE=s.GENDER_CODE
    ,d.ALT_EMAIL_ADDRESS=s.ALT_EMAIL_ADDRESS
    ,d.COUNTRY=s.COUNTRY
    ,d.ALT_PHONE_NUMBER=s.ALT_PHONE_NUMBER
    ,d.PHONE_NUMBER=s.PHONE_NUMBER
    ,d.TCPA_OPT_IN=s.TCPA_OPT_IN
    ,d.CASL_OPT_IN=s.CASL_OPT_IN
    ,d.OMS2_AUGMENTED_IND=s.OMS2_AUGMENTED_IND
    ,d.ACTIVE=s.ACTIVE
    ,d.OMS2_SUBJECT_ID=s.OMS2_SUBJECT_ID
    ,d.ODS_MODIFY_DATE = s.ODS_MODIFY_DATE
WHERE 
    decode(s.ADDRESS_LINE_1,d.ADDRESS_LINE_1,1,0) = 0
    or decode(s.ADDRESS_LINE_2,d.ADDRESS_LINE_2,1,0) = 0
    or decode(s.CITY,d.CITY,1,0) = 0
    or decode(s.STATE,d.STATE,1,0) = 0
    or decode(s.POSTAL_CODE,d.POSTAL_CODE,1,0) = 0
    or decode(s.EMAIL_ADDRESS,d.EMAIL_ADDRESS,1,0) = 0
    or decode(s.MAJOR,d.MAJOR,1,0) = 0
    or decode(s.MINOR,d.MINOR,1,0) = 0
    or decode(s.SQUADRON,d.SQUADRON,1,0) = 0
    or decode(s.ZIP,d.ZIP,1,0) = 0
    or decode(s.EXTERNAL_SUBJECT_ID,d.EXTERNAL_SUBJECT_ID,1,0) = 0
    or decode(s.GENDER_CODE,d.GENDER_CODE,1,0) = 0
    or decode(s.ALT_EMAIL_ADDRESS,d.ALT_EMAIL_ADDRESS,1,0) = 0
    or decode(s.COUNTRY,d.COUNTRY,1,0) = 0
    or decode(s.ALT_PHONE_NUMBER,d.ALT_PHONE_NUMBER,1,0) = 0
    or decode(s.PHONE_NUMBER,d.PHONE_NUMBER,1,0) = 0
    or decode(s.TCPA_OPT_IN,d.TCPA_OPT_IN,1,0) = 0
    or decode(s.CASL_OPT_IN,d.CASL_OPT_IN,1,0) = 0
    or decode(s.OMS2_AUGMENTED_IND,d.OMS2_AUGMENTED_IND,1,0) = 0
    or decode(s.ACTIVE,d.ACTIVE,1,0) = 0
    or decode(s.OMS2_SUBJECT_ID,d.OMS2_SUBJECT_ID,1,0) = 0




&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* Fix Capture Session */

merge into ods_own.capture_session t using
(
select cs.capture_session_oid
, min(sxr.subject_oid) as subject_oid
from ods_own.capture_session cs
, ods_own.source_system ss
, ods_own.apo
, ods_stage.capture_session_xr csxr
, ods_stage.subject_xr sxr
, ods_own.subject_event_info sei
, ods_own.sm_event_image_fact eif
where 1=1
and cs.source_system_oid = ss.source_system_oid
and ss.source_system_short_name = 'OMS2'
and cs.capture_session_oid = csxr.capture_session_oid
and csxr.oms2_subject_key = sxr.oms2_subject_key
and cs.apo_oid = apo.apo_oid
and sxr.subject_oid = sei.subject_oid
and sxr.system_of_record = 'SM'
and sei.sm_event_image_fact_oid = eif.sm_event_image_fact_oid
and eif.apo_id = apo.apo_id
and sxr.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap
group by cs.capture_session_oid
) s
on ( s.capture_session_oid = t.capture_session_oid )
when matched then update
set t.subject_oid = s.subject_oid
, t.ods_modify_date = sysdate
where decode(s.subject_oid,t.subject_oid,1,0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* Fix ORDER_HEADER SUBJECT_OID */

merge into ods_own.order_header t using
(
select oh.order_header_oid
, min(sxr.subject_oid) as subject_oid
from ods_own.order_header oh
, ods_own.source_system ss
, ods_stage.oms2_order_header_xr ohxr
, ods_own.apo
, ods_stage.subject_xr sxr
, ods_own.subject_event_info sei
, ods_own.sm_event_image_fact eif
where 1=1
and oh.source_system_oid = ss.source_system_oid
and ss.source_system_short_name = 'OMS2'
and oh.order_header_oid = ohxr.order_header_oid
and ohxr.extn_subject_key = sxr.oms2_subject_key
and oh.apo_oid = apo.apo_oid
and sxr.subject_oid = sei.subject_oid
and sxr.system_of_record = 'SM'
and sei.sm_event_image_fact_oid = eif.sm_event_image_fact_oid
and eif.apo_id = apo.apo_id
and sxr.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap
group by oh.order_header_oid
) s
on ( s.order_header_oid = t.order_header_oid )
when matched then update
set t.subject_oid = s.subject_oid
, t.ods_modify_date = sysdate
where decode(s.subject_oid,t.subject_oid,1,0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* Fix SUBJECT_APO_SELECTION SUBJECT_OID */

merge into ODS_OWN.SUBJECT_APO_SELECTION t USING 
( 
select sapos.subject_apo_selection_oid
, min(sxr2.subject_oid) as subject_oid
from ods_stage.subject_apo_selection_xr sapos
, ods_stage.subject_xr sxr
, ods_stage.subject_xr sxr2
, ODS_STAGE.OMS2_LT_APO_STG oms2_apo
, ods_own.subject_event_info sei
, ods_own.sm_event_image_fact eif
where substr(sxr.oms2_subject_key,2,50) = sapos.oms2_subject_key
and sapos.oms2_apo_key = oms2_apo.apo_key
and sxr.oms2_subject_id = sxr2.oms2_subject_id
and sxr2.system_of_record = 'SM'
and sxr2.subject_oid = sei.subject_oid
and sei.sm_event_image_fact_oid = eif.sm_event_image_fact_oid
and eif.apo_id = oms2_apo.apo_id
and sxr.system_of_record = 'OMS2'
and sxr.oms2_subject_key like 'D%' -- these are the ones we need to move away from
and sxr.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap
group by sapos.subject_apo_selection_oid
) s
ON (s.SUBJECT_APO_SELECTION_OID=t.SUBJECT_APO_SELECTION_OID)
WHEN MATCHED THEN UPDATE 
SET t.SUBJECT_OID = s.SUBJECT_OID
,t.ODS_MODIFY_DATE = sysdate
where decode(s.subject_oid,t.subject_oid,1,0) = 0


&


/*-----------------------------------------------*/
/* TASK No. 31 */
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
/* TASK No. 32 */
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
,'LOAD_OMS2_SUBJECT_PKG'
,'022'
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
'LOAD_OMS2_SUBJECT_PKG',
'022',
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
