
BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0LTLPIADM_TBLENROLLMENT09',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;



&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Drop flow table */


BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_LTLPIADM_TBLENROLLMENT09 ';  
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

create table RAX_APP_USER.I$_LTLPIADM_TBLENROLLMENT09
(
	ENROLLMENTID		NUMBER NULL,
	JOBNUMBER		NUMBER NULL,
	EFFECTIVE_DATE		DATE NULL,
	ACTIVE_IND		VARCHAR2(5) NULL,
	LOAD_ID		NUMBER NULL,
	DW_CREATE_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_LTLPIADM_TBLENROLLMENT09
(
	ENROLLMENTID,
	JOBNUMBER,
	IND_UPDATE
)
select 
ENROLLMENTID,
	JOBNUMBER,
	IND_UPDATE
 from (


select 	 
	
	C1_ENROLLMENTID ENROLLMENTID,
	C2_JOBNUMBER JOBNUMBER,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0LTLPIADM_TBLENROLLMENT09
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS.LTLPIADM_TBLENROLLMENT09 T
	where	T.ENROLLMENTID	= S.ENROLLMENTID 
		 and ((T.JOBNUMBER = S.JOBNUMBER) or (T.JOBNUMBER IS NULL and S.JOBNUMBER IS NULL))
        )

  
  

  

 


&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_LTLPIADM_TBLENROLLMENT09_ID
on		RAX_APP_USER.I$_LTLPIADM_TBLENROLLMENT09 (ENROLLMENTID)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_LTLPIADM_TBLENROLLMENT09',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Flag rows for update */

/* DETECTION_STRATEGY = NOT_EXISTS */


update	RAX_APP_USER.I$_LTLPIADM_TBLENROLLMENT09
set	IND_UPDATE = 'U'
where	(ENROLLMENTID)
	in	(
		select	ENROLLMENTID
		from	ODS.LTLPIADM_TBLENROLLMENT09
		)



&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Flag useless rows */

/* DETECTION_STRATEGY = NOT_EXISTS */

/* Command skipped due to chosen DETECTION_STRATEGY */



/*-----------------------------------------------*/
/* TASK No. 16 */
/* Update existing rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
update	ODS.LTLPIADM_TBLENROLLMENT09 T
set 	
	(
	T.JOBNUMBER
	) =
		(
		select	S.JOBNUMBER
		from	RAX_APP_USER.I$_LTLPIADM_TBLENROLLMENT09 S
		where	T.ENROLLMENTID	=S.ENROLLMENTID
	    	 )
	, T.EFFECTIVE_DATE = sysdate,
	T.ACTIVE_IND = 'A',
	T.LOAD_ID = 1

where	(ENROLLMENTID)
	in	(
		select	ENROLLMENTID
		from	RAX_APP_USER.I$_LTLPIADM_TBLENROLLMENT09
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Insert new rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
insert into 	ODS.LTLPIADM_TBLENROLLMENT09 T
	(
	ENROLLMENTID,
	JOBNUMBER
	,  EFFECTIVE_DATE,
	ACTIVE_IND,
	LOAD_ID,
	DW_CREATE_DATE
	)
select 	ENROLLMENTID,
	JOBNUMBER
	,  sysdate,
	'A',
	1,
	sysdate
from	RAX_APP_USER.I$_LTLPIADM_TBLENROLLMENT09 S



where	IND_UPDATE = 'I'



&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Drop flow table */


BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_LTLPIADM_TBLENROLLMENT09';  
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
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0LTLPIADM_TBLENROLLMENT09';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  
&





/*-----------------------------------------------*/
/* TASK No. 22 */
/* Update active_ind on ltlpiadm_tblenrollment09 */

update ods.ltlpiadm_tblenrollment09 te
set te.active_ind = 'I'
where not exists
(select  * from RAX_APP_USER.ltlpiadm_tblenrollment09_stg tes
where (te.enrollmentid = tes.enrollmentid))



&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0LTLPIADM_TBLENRLMNT09_HIST',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;




&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* Drop flow table */


BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_LTLPIADM_TBLENRLMNT09_HIST';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 
&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_LTLPIADM_TBLENRLMNT09_HIST
(
	ENROLLMENTHISTORYID		NUMBER NULL,
	ENROLLMENTID		NUMBER NULL,
	PROGRAMDESCRIPTION		VARCHAR2(64) NULL,
	WEBSITE		NUMBER NULL,
	ADVISERFIRSTNAME		VARCHAR2(32) NULL,
	ADVISERLASTNAME		VARCHAR2(32) NULL,
	ADVISEREMAIL		VARCHAR2(64) NULL,
	ADVISERUSERNAME		VARCHAR2(10) NULL,
	ADVISERPASSWORD		VARCHAR2(10) NULL,
	SALESREPNAME		VARCHAR2(64) NULL,
	SALESREPEMAIL		VARCHAR2(64) NULL,
	SALESREPUSERNAME		VARCHAR2(10) NULL,
	SALESREPPASSWORD		VARCHAR2(10) NULL,
	SALESREPTERRITORYCODE		VARCHAR2(5) NULL,
	ENROLLMENTSTATUSID		NUMBER NULL,
	COMPLETEDBY		NUMBER NULL,
	COMPLETEDDATE		DATE NULL,
	COMPLETEDTIME		DATE NULL,
	EFFECTIVE_DATE		DATE NULL,
	ACTIVE_IND		VARCHAR2(5) NULL,
	LOAD_ID		NUMBER NULL,
	DW_CREATE_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_LTLPIADM_TBLENRLMNT09_HIST
(
	ENROLLMENTHISTORYID,
	ENROLLMENTID,
	PROGRAMDESCRIPTION,
	WEBSITE,
	ADVISERFIRSTNAME,
	ADVISERLASTNAME,
	ADVISEREMAIL,
	ADVISERUSERNAME,
	ADVISERPASSWORD,
	SALESREPNAME,
	SALESREPEMAIL,
	SALESREPUSERNAME,
	SALESREPPASSWORD,
	SALESREPTERRITORYCODE,
	ENROLLMENTSTATUSID,
	COMPLETEDBY,
	COMPLETEDDATE,
	COMPLETEDTIME,
	IND_UPDATE
)
select 
ENROLLMENTHISTORYID,
	ENROLLMENTID,
	PROGRAMDESCRIPTION,
	WEBSITE,
	ADVISERFIRSTNAME,
	ADVISERLASTNAME,
	ADVISEREMAIL,
	ADVISERUSERNAME,
	ADVISERPASSWORD,
	SALESREPNAME,
	SALESREPEMAIL,
	SALESREPUSERNAME,
	SALESREPPASSWORD,
	SALESREPTERRITORYCODE,
	ENROLLMENTSTATUSID,
	COMPLETEDBY,
	COMPLETEDDATE,
	COMPLETEDTIME,
	IND_UPDATE
 from (


select 	 
	
	C1_ENROLLMENTHISTORYID ENROLLMENTHISTORYID,
	C2_ENROLLMENTID ENROLLMENTID,
	C3_PROGRAMDESCRIPTION PROGRAMDESCRIPTION,
	C4_WEBSITE WEBSITE,
	C5_ADVISERFIRSTNAME ADVISERFIRSTNAME,
	C6_ADVISERLASTNAME ADVISERLASTNAME,
	C7_ADVISEREMAIL ADVISEREMAIL,
	C8_ADVISERUSERNAME ADVISERUSERNAME,
	C9_ADVISERPASSWORD ADVISERPASSWORD,
	C10_SALESREPNAME SALESREPNAME,
	C11_SALESREPEMAIL SALESREPEMAIL,
	C12_SALESREPUSERNAME SALESREPUSERNAME,
	C13_SALESREPPASSWORD SALESREPPASSWORD,
	C14_SALESREPTERRITORYCODE SALESREPTERRITORYCODE,
	C15_ENROLLMENTSTATUSID ENROLLMENTSTATUSID,
	C16_COMPLETEDBY COMPLETEDBY,
	C17_COMPLETEDDATE COMPLETEDDATE,
	C18_COMPLETEDTIME COMPLETEDTIME,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0LTLPIADM_TBLENRLMNT09_HIST
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS.LTLPIADM_TBLENRLMNT09_HIST T
	where	T.ENROLLMENTHISTORYID	= S.ENROLLMENTHISTORYID 
		 and ((T.ENROLLMENTID = S.ENROLLMENTID) or (T.ENROLLMENTID IS NULL and S.ENROLLMENTID IS NULL)) and
		((T.PROGRAMDESCRIPTION = S.PROGRAMDESCRIPTION) or (T.PROGRAMDESCRIPTION IS NULL and S.PROGRAMDESCRIPTION IS NULL)) and
		((T.WEBSITE = S.WEBSITE) or (T.WEBSITE IS NULL and S.WEBSITE IS NULL)) and
		((T.ADVISERFIRSTNAME = S.ADVISERFIRSTNAME) or (T.ADVISERFIRSTNAME IS NULL and S.ADVISERFIRSTNAME IS NULL)) and
		((T.ADVISERLASTNAME = S.ADVISERLASTNAME) or (T.ADVISERLASTNAME IS NULL and S.ADVISERLASTNAME IS NULL)) and
		((T.ADVISEREMAIL = S.ADVISEREMAIL) or (T.ADVISEREMAIL IS NULL and S.ADVISEREMAIL IS NULL)) and
		((T.ADVISERUSERNAME = S.ADVISERUSERNAME) or (T.ADVISERUSERNAME IS NULL and S.ADVISERUSERNAME IS NULL)) and
		((T.ADVISERPASSWORD = S.ADVISERPASSWORD) or (T.ADVISERPASSWORD IS NULL and S.ADVISERPASSWORD IS NULL)) and
		((T.SALESREPNAME = S.SALESREPNAME) or (T.SALESREPNAME IS NULL and S.SALESREPNAME IS NULL)) and
		((T.SALESREPEMAIL = S.SALESREPEMAIL) or (T.SALESREPEMAIL IS NULL and S.SALESREPEMAIL IS NULL)) and
		((T.SALESREPUSERNAME = S.SALESREPUSERNAME) or (T.SALESREPUSERNAME IS NULL and S.SALESREPUSERNAME IS NULL)) and
		((T.SALESREPPASSWORD = S.SALESREPPASSWORD) or (T.SALESREPPASSWORD IS NULL and S.SALESREPPASSWORD IS NULL)) and
		((T.SALESREPTERRITORYCODE = S.SALESREPTERRITORYCODE) or (T.SALESREPTERRITORYCODE IS NULL and S.SALESREPTERRITORYCODE IS NULL)) and
		((T.ENROLLMENTSTATUSID = S.ENROLLMENTSTATUSID) or (T.ENROLLMENTSTATUSID IS NULL and S.ENROLLMENTSTATUSID IS NULL)) and
		((T.COMPLETEDBY = S.COMPLETEDBY) or (T.COMPLETEDBY IS NULL and S.COMPLETEDBY IS NULL)) and
		((T.COMPLETEDDATE = S.COMPLETEDDATE) or (T.COMPLETEDDATE IS NULL and S.COMPLETEDDATE IS NULL)) and
		((T.COMPLETEDTIME = S.COMPLETEDTIME) or (T.COMPLETEDTIME IS NULL and S.COMPLETEDTIME IS NULL))
        )

  
  

  

 


&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_LTLPIADM_TBLENRLMNT09_HIST_
on		RAX_APP_USER.I$_LTLPIADM_TBLENRLMNT09_HIST (ENROLLMENTHISTORYID)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 32 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_LTLPIADM_TBLENRLMNT09_HIST',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 33 */
/* Flag rows for update */

/* DETECTION_STRATEGY = NOT_EXISTS */


update	RAX_APP_USER.I$_LTLPIADM_TBLENRLMNT09_HIST
set	IND_UPDATE = 'U'
where	(ENROLLMENTHISTORYID)
	in	(
		select	ENROLLMENTHISTORYID
		from	ODS.LTLPIADM_TBLENRLMNT09_HIST
		)



&


/*-----------------------------------------------*/
/* TASK No. 34 */
/* Flag useless rows */

/* DETECTION_STRATEGY = NOT_EXISTS */

/* Command skipped due to chosen DETECTION_STRATEGY */



/*-----------------------------------------------*/
/* TASK No. 35 */
/* Update existing rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
update	ODS.LTLPIADM_TBLENRLMNT09_HIST T
set 	
	(
	T.ENROLLMENTID,
	T.PROGRAMDESCRIPTION,
	T.WEBSITE,
	T.ADVISERFIRSTNAME,
	T.ADVISERLASTNAME,
	T.ADVISEREMAIL,
	T.ADVISERUSERNAME,
	T.ADVISERPASSWORD,
	T.SALESREPNAME,
	T.SALESREPEMAIL,
	T.SALESREPUSERNAME,
	T.SALESREPPASSWORD,
	T.SALESREPTERRITORYCODE,
	T.ENROLLMENTSTATUSID,
	T.COMPLETEDBY,
	T.COMPLETEDDATE,
	T.COMPLETEDTIME
	) =
		(
		select	S.ENROLLMENTID,
			S.PROGRAMDESCRIPTION,
			S.WEBSITE,
			S.ADVISERFIRSTNAME,
			S.ADVISERLASTNAME,
			S.ADVISEREMAIL,
			S.ADVISERUSERNAME,
			S.ADVISERPASSWORD,
			S.SALESREPNAME,
			S.SALESREPEMAIL,
			S.SALESREPUSERNAME,
			S.SALESREPPASSWORD,
			S.SALESREPTERRITORYCODE,
			S.ENROLLMENTSTATUSID,
			S.COMPLETEDBY,
			S.COMPLETEDDATE,
			S.COMPLETEDTIME
		from	RAX_APP_USER.I$_LTLPIADM_TBLENRLMNT09_HIST S
		where	T.ENROLLMENTHISTORYID	=S.ENROLLMENTHISTORYID
	    	 )
	,                 T.EFFECTIVE_DATE = sysdate,
	T.ACTIVE_IND = 'A',
	T.LOAD_ID = 1

where	(ENROLLMENTHISTORYID)
	in	(
		select	ENROLLMENTHISTORYID
		from	RAX_APP_USER.I$_LTLPIADM_TBLENRLMNT09_HIST
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 36 */
/* Insert new rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
insert into 	ODS.LTLPIADM_TBLENRLMNT09_HIST T
	(
	ENROLLMENTHISTORYID,
	ENROLLMENTID,
	PROGRAMDESCRIPTION,
	WEBSITE,
	ADVISERFIRSTNAME,
	ADVISERLASTNAME,
	ADVISEREMAIL,
	ADVISERUSERNAME,
	ADVISERPASSWORD,
	SALESREPNAME,
	SALESREPEMAIL,
	SALESREPUSERNAME,
	SALESREPPASSWORD,
	SALESREPTERRITORYCODE,
	ENROLLMENTSTATUSID,
	COMPLETEDBY,
	COMPLETEDDATE,
	COMPLETEDTIME
	,                  EFFECTIVE_DATE,
	ACTIVE_IND,
	LOAD_ID,
	DW_CREATE_DATE
	)
select 	ENROLLMENTHISTORYID,
	ENROLLMENTID,
	PROGRAMDESCRIPTION,
	WEBSITE,
	ADVISERFIRSTNAME,
	ADVISERLASTNAME,
	ADVISEREMAIL,
	ADVISERUSERNAME,
	ADVISERPASSWORD,
	SALESREPNAME,
	SALESREPEMAIL,
	SALESREPUSERNAME,
	SALESREPPASSWORD,
	SALESREPTERRITORYCODE,
	ENROLLMENTSTATUSID,
	COMPLETEDBY,
	COMPLETEDDATE,
	COMPLETEDTIME
	,                  sysdate,
	'A',
	1,
	sysdate
from	RAX_APP_USER.I$_LTLPIADM_TBLENRLMNT09_HIST S



where	IND_UPDATE = 'I'



&


/*-----------------------------------------------*/
/* TASK No. 37 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 38 */
/* Drop flow table */


BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_LTLPIADM_TBLENRLMNT09_HIST';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 
&


/*-----------------------------------------------*/
/* TASK No. 1000027 */
/* Drop work table */

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0LTLPIADM_TBLENRLMNT09_HIST';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 
&


update ods.ltlpiadm_tblenrlmnt09_hist teh
set teh.active_ind = 'I'
where not exists
(select  * from RAX_APP_USER.ltlpiadm_tblenrlmnt09hist_stg tehs
where (teh.enrollmenthistoryid = tehs.enrollmenthistoryid))



&






BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0LTLPIADM_TBLENRLMNT09_STAT',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;




&


/*-----------------------------------------------*/
/* TASK No. 47 */
/* Drop flow table */

 
BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_LTLPIADM_TBLENRLMNT09_STAT';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 
&


/*-----------------------------------------------*/
/* TASK No. 48 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_LTLPIADM_TBLENRLMNT09_STAT
(
	ENROLLMENTSTATUSID		NUMBER NULL,
	ENROLLMENTSTATUSDESCRIPTION		VARCHAR2(32) NULL,
	EFFECTIVE_DATE		DATE NULL,
	ACTIVE_IND		VARCHAR2(5) NULL,
	LOAD_ID		NUMBER NULL,
	DW_CREATE_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 49 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_LTLPIADM_TBLENRLMNT09_STAT
(
	ENROLLMENTSTATUSID,
	ENROLLMENTSTATUSDESCRIPTION,
	IND_UPDATE
)
select 
ENROLLMENTSTATUSID,
	ENROLLMENTSTATUSDESCRIPTION,
	IND_UPDATE
 from (


select 	 
	
	C1_ENROLLMENTSTATUSID ENROLLMENTSTATUSID,
	C2_ENROLLMENTSTATUSDESCRIPTION ENROLLMENTSTATUSDESCRIPTION,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0LTLPIADM_TBLENRLMNT09_STAT
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS.LTLPIADM_TBLENRLMNT09_STAT T
	where	T.ENROLLMENTSTATUSID	= S.ENROLLMENTSTATUSID 
		 and ((T.ENROLLMENTSTATUSDESCRIPTION = S.ENROLLMENTSTATUSDESCRIPTION) or (T.ENROLLMENTSTATUSDESCRIPTION IS NULL and S.ENROLLMENTSTATUSDESCRIPTION IS NULL))
        )

  
  

  

 


&


/*-----------------------------------------------*/
/* TASK No. 50 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_LTLPIADM_TBLENRLMNT09_STAT_
on		RAX_APP_USER.I$_LTLPIADM_TBLENRLMNT09_STAT (ENROLLMENTSTATUSID)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 51 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_LTLPIADM_TBLENRLMNT09_STAT',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 52 */
/* Flag rows for update */

/* DETECTION_STRATEGY = NOT_EXISTS */


update	RAX_APP_USER.I$_LTLPIADM_TBLENRLMNT09_STAT
set	IND_UPDATE = 'U'
where	(ENROLLMENTSTATUSID)
	in	(
		select	ENROLLMENTSTATUSID
		from	ODS.LTLPIADM_TBLENRLMNT09_STAT
		)



&


/*-----------------------------------------------*/
/* TASK No. 53 */
/* Flag useless rows */

/* DETECTION_STRATEGY = NOT_EXISTS */

/* Command skipped due to chosen DETECTION_STRATEGY */



/*-----------------------------------------------*/
/* TASK No. 54 */
/* Update existing rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
update	ODS.LTLPIADM_TBLENRLMNT09_STAT T
set 	
	(
	T.ENROLLMENTSTATUSDESCRIPTION
	) =
		(
		select	S.ENROLLMENTSTATUSDESCRIPTION
		from	RAX_APP_USER.I$_LTLPIADM_TBLENRLMNT09_STAT S
		where	T.ENROLLMENTSTATUSID	=S.ENROLLMENTSTATUSID
	    	 )
	, T.EFFECTIVE_DATE = sysdate,
	T.ACTIVE_IND = 'A',
	T.LOAD_ID = 1

where	(ENROLLMENTSTATUSID)
	in	(
		select	ENROLLMENTSTATUSID
		from	RAX_APP_USER.I$_LTLPIADM_TBLENRLMNT09_STAT
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 55 */
/* Insert new rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
insert into 	ODS.LTLPIADM_TBLENRLMNT09_STAT T
	(
	ENROLLMENTSTATUSID,
	ENROLLMENTSTATUSDESCRIPTION
	,  EFFECTIVE_DATE,
	ACTIVE_IND,
	LOAD_ID,
	DW_CREATE_DATE
	)
select 	ENROLLMENTSTATUSID,
	ENROLLMENTSTATUSDESCRIPTION
	,  sysdate,
	'A',
	1,
	sysdate
from	RAX_APP_USER.I$_LTLPIADM_TBLENRLMNT09_STAT S



where	IND_UPDATE = 'I'



&


/*-----------------------------------------------*/
/* TASK No. 56 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 57 */
/* Drop flow table */

 
BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_LTLPIADM_TBLENRLMNT09_STAT';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 
&


/*-----------------------------------------------*/
/* TASK No. 1000046 */
/* Drop work table */

 
BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0LTLPIADM_TBLENRLMNT09_STAT';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 
&


/*-----------------------------------------------*/
/* TASK No. 58 */
/* Update CDC Load Status */

UPDATE ODS.DW_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE DW_TABLE_NAME=:v_cdc_load_table_name

&


/*-----------------------------------------------*/
/* TASK No. 59 */
/* Insert Audit Record */

INSERT INTO RAX_APP_USER.DW_CDC_LOAD_STATUS_AUDIT
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
'LOAD_LIFETOUCHLPIADMIN_PKG',
'003',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (':v_cdc_load_date', 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          ),
:v_cdc_ods_overlap,
SYSDATE)

&


/*-----------------------------------------------*/
