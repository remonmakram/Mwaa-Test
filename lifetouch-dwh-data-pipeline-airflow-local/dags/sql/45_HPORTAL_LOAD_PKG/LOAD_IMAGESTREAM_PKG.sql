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
/*
drop table RAX_APP_USER.C$_0HP_IMAGESTREAM_STG purge

&
*/

/*-----------------------------------------------*/
/* TASK No. 6 */
/* Create work table */
/*
create table RAX_APP_USER.C$_0HP_IMAGESTREAM_STG
(
	C1_IMAGESTREAM_OID	NUMBER NULL,
	C2_LID	NUMBER NULL,
	C3_LOCAL_LOCATION	VARCHAR2(500) NULL,
	C4_CENTRAL_LOCATION	VARCHAR2(500) NULL,
	C5_ACADEMIC_YEAR	VARCHAR2(20) NULL,
	C6_MD5	VARCHAR2(32) NULL,
	C7_RETAKE_INDICATOR	NUMBER NULL,
	C8_CREATED_DATE	DATE NULL,
	C9_STATUS	VARCHAR2(20) NULL,
	C10_UPDATED_ON	DATE NULL
)
NOLOGGING

&
*/

/*-----------------------------------------------*/
/* TASK No. 7 */
/* Load data */

/* SOURCE CODE */

/*
select	
	IMAGESTREAM.IMAGESTREAM_OID	   C1_IMAGESTREAM_OID,
	IMAGESTREAM.LID	   C2_LID,
	IMAGESTREAM.LOCAL_LOCATION	   C3_LOCAL_LOCATION,
	IMAGESTREAM.CENTRAL_LOCATION	   C4_CENTRAL_LOCATION,
	IMAGESTREAM.ACADEMIC_YEAR	   C5_ACADEMIC_YEAR,
	IMAGESTREAM.MD5	   C6_MD5,
	IMAGESTREAM.RETAKE_INDICATOR	   C7_RETAKE_INDICATOR,
	IMAGESTREAM.CREATED_DATE	   C8_CREATED_DATE,
	IMAGESTREAM.STATUS	   C9_STATUS,
	IMAGESTREAM.UPDATED_ON	   C10_UPDATED_ON
from	HPORTAL_OWN.IMAGESTREAM   IMAGESTREAM
where	(1=1)
And (NVL(IMAGESTREAM.UPDATED_ON, IMAGESTREAM.CREATED_DATE)>= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap)







&
*/
/* TARGET CODE */
/*
insert into RAX_APP_USER.C$_0HP_IMAGESTREAM_STG
(
	C1_IMAGESTREAM_OID,
	C2_LID,
	C3_LOCAL_LOCATION,
	C4_CENTRAL_LOCATION,
	C5_ACADEMIC_YEAR,
	C6_MD5,
	C7_RETAKE_INDICATOR,
	C8_CREATED_DATE,
	C9_STATUS,
	C10_UPDATED_ON
)
values
(
	:C1_IMAGESTREAM_OID,
	:C2_LID,
	:C3_LOCAL_LOCATION,
	:C4_CENTRAL_LOCATION,
	:C5_ACADEMIC_YEAR,
	:C6_MD5,
	:C7_RETAKE_INDICATOR,
	:C8_CREATED_DATE,
	:C9_STATUS,
	:C10_UPDATED_ON
)

&

*/
/*-----------------------------------------------*/
/* TASK No. 8 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0HP_IMAGESTREAM_STG',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;




&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 10 */




/*-----------------------------------------------*/
/* TASK No. 11 */
/* Drop flow table */


BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_HP_IMAGESTREAM_STG1197001 ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_HP_IMAGESTREAM_STG1197001
(
	IMAGESTREAM_OID		NUMBER NULL,
	LID		NUMBER NULL,
	LOCAL_LOCATION		VARCHAR2(500) NULL,
	CENTRAL_LOCATION		VARCHAR2(500) NULL,
	ACADEMIC_YEAR		VARCHAR2(20) NULL,
	MD5		VARCHAR2(32) NULL,
	RETAKE_INDICATOR		NUMBER NULL,
	CREATED_DATE		DATE NULL,
	STATUS		VARCHAR2(20) NULL,
	UPDATED_ON		DATE NULL,
	ODS_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_HP_IMAGESTREAM_STG1197001
(
	IMAGESTREAM_OID,
	LID,
	LOCAL_LOCATION,
	CENTRAL_LOCATION,
	ACADEMIC_YEAR,
	MD5,
	RETAKE_INDICATOR,
	CREATED_DATE,
	STATUS,
	UPDATED_ON,
	IND_UPDATE
)
select 
IMAGESTREAM_OID,
	LID,
	LOCAL_LOCATION,
	CENTRAL_LOCATION,
	ACADEMIC_YEAR,
	MD5,
	RETAKE_INDICATOR,
	CREATED_DATE,
	STATUS,
	UPDATED_ON,
	IND_UPDATE
 from (


select 	 
	
	C1_IMAGESTREAM_OID IMAGESTREAM_OID,
	C2_LID LID,
	C3_LOCAL_LOCATION LOCAL_LOCATION,
	C4_CENTRAL_LOCATION CENTRAL_LOCATION,
	C5_ACADEMIC_YEAR ACADEMIC_YEAR,
	C6_MD5 MD5,
	C7_RETAKE_INDICATOR RETAKE_INDICATOR,
	C8_CREATED_DATE CREATED_DATE,
	C9_STATUS STATUS,
	C10_UPDATED_ON UPDATED_ON,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0HP_IMAGESTREAM_STG
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.HP_IMAGESTREAM_STG T
	where	T.IMAGESTREAM_OID	= S.IMAGESTREAM_OID 
		 and ((T.LID = S.LID) or (T.LID IS NULL and S.LID IS NULL)) and
		((T.LOCAL_LOCATION = S.LOCAL_LOCATION) or (T.LOCAL_LOCATION IS NULL and S.LOCAL_LOCATION IS NULL)) and
		((T.CENTRAL_LOCATION = S.CENTRAL_LOCATION) or (T.CENTRAL_LOCATION IS NULL and S.CENTRAL_LOCATION IS NULL)) and
		((T.ACADEMIC_YEAR = S.ACADEMIC_YEAR) or (T.ACADEMIC_YEAR IS NULL and S.ACADEMIC_YEAR IS NULL)) and
		((T.MD5 = S.MD5) or (T.MD5 IS NULL and S.MD5 IS NULL)) and
		((T.RETAKE_INDICATOR = S.RETAKE_INDICATOR) or (T.RETAKE_INDICATOR IS NULL and S.RETAKE_INDICATOR IS NULL)) and
		((T.CREATED_DATE = S.CREATED_DATE) or (T.CREATED_DATE IS NULL and S.CREATED_DATE IS NULL)) and
		((T.STATUS = S.STATUS) or (T.STATUS IS NULL and S.STATUS IS NULL)) and
		((T.UPDATED_ON = S.UPDATED_ON) or (T.UPDATED_ON IS NULL and S.UPDATED_ON IS NULL))
        )

  
  

  

 


&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Create Index on flow table */





BEGIN  
   EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_HP_IMAGESTREAM_STG_IDX1197001
on		RAX_APP_USER.I$_HP_IMAGESTREAM_STG1197001 (IMAGESTREAM_OID)';  
EXCEPTION  
   WHEN OTHERS THEN  
      NULL;
END;  



&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_HP_IMAGESTREAM_STG1197001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Flag rows for update */

/* DETECTION_STRATEGY = NOT_EXISTS */


update	RAX_APP_USER.I$_HP_IMAGESTREAM_STG1197001
set	IND_UPDATE = 'U'
where	(IMAGESTREAM_OID)
	in	(
		select	IMAGESTREAM_OID
		from	ODS_STAGE.HP_IMAGESTREAM_STG
		)



&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Flag useless rows */

/* DETECTION_STRATEGY = NOT_EXISTS */

/* Command skipped due to chosen DETECTION_STRATEGY */



/*-----------------------------------------------*/
/* TASK No. 18 */
/* Update existing rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
update	ODS_STAGE.HP_IMAGESTREAM_STG T
set 	
	(
	T.LID,
	T.LOCAL_LOCATION,
	T.CENTRAL_LOCATION,
	T.ACADEMIC_YEAR,
	T.MD5,
	T.RETAKE_INDICATOR,
	T.CREATED_DATE,
	T.STATUS,
	T.UPDATED_ON
	) =
		(
		select	S.LID,
			S.LOCAL_LOCATION,
			S.CENTRAL_LOCATION,
			S.ACADEMIC_YEAR,
			S.MD5,
			S.RETAKE_INDICATOR,
			S.CREATED_DATE,
			S.STATUS,
			S.UPDATED_ON
		from	RAX_APP_USER.I$_HP_IMAGESTREAM_STG1197001 S
		where	T.IMAGESTREAM_OID	=S.IMAGESTREAM_OID
	    	 )
	,         T.ODS_MODIFY_DATE = sysdate

where	(IMAGESTREAM_OID)
	in	(
		select	IMAGESTREAM_OID
		from	RAX_APP_USER.I$_HP_IMAGESTREAM_STG1197001
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Insert new rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
insert into 	ODS_STAGE.HP_IMAGESTREAM_STG T
	(
	IMAGESTREAM_OID,
	LID,
	LOCAL_LOCATION,
	CENTRAL_LOCATION,
	ACADEMIC_YEAR,
	MD5,
	RETAKE_INDICATOR,
	CREATED_DATE,
	STATUS,
	UPDATED_ON
	,          ODS_CREATE_DATE,
	ODS_MODIFY_DATE
	)
select 	IMAGESTREAM_OID,
	LID,
	LOCAL_LOCATION,
	CENTRAL_LOCATION,
	ACADEMIC_YEAR,
	MD5,
	RETAKE_INDICATOR,
	CREATED_DATE,
	STATUS,
	UPDATED_ON
	,          sysdate,
	sysdate
from	RAX_APP_USER.I$_HP_IMAGESTREAM_STG1197001 S



where	IND_UPDATE = 'I'



&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 21 */
/* Drop flow table */

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_HP_IMAGESTREAM_STG1197001  ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  
&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* sub-select inline view */

(


select 	 
	
	C1_IMAGESTREAM_OID    IMAGESTREAM_OID,
	C2_LID    LID,
	C3_LOCAL_LOCATION    LOCAL_LOCATION,
	C4_CENTRAL_LOCATION    CENTRAL_LOCATION,
	C5_ACADEMIC_YEAR    ACADEMIC_YEAR,
	C6_MD5    MD5,
	C7_RETAKE_INDICATOR    RETAKE_INDICATOR,
	C8_CREATED_DATE    CREATED_DATE,
	C9_STATUS    STATUS,
	C10_UPDATED_ON    UPDATED_ON,
	sysdate    ODS_CREATE_DATE,
	sysdate    ODS_MODIFY_DATE
from	RAX_APP_USER.C$_0HP_IMAGESTREAM_STG
where	(1=1)





)

&


/*-----------------------------------------------*/
/* TASK No. 1000009 */
/* Drop work table */

drop table RAX_APP_USER.C$_0HP_IMAGESTREAM_STG purge

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name


&


/*-----------------------------------------------*/
/* TASK No. 24 */
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
'LOAD_IMAGESTREAM_PKG',
'001',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          ),
:v_cdc_oms_overlap,
SYSDATE)


&


/*-----------------------------------------------*/
