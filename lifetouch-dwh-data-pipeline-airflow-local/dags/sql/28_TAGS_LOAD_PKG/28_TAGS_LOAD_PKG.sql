/* TASK No. 1 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */

-- Set Variable LIFETOUCH_PROJECT.v_cdc_load_table_name. Set to 'TAGS_TABLES'


/*-----------------------------------------------*/
/* TASK No. 2 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 2 */

-- Refresh Variable LIFETOUCH_PROJECT.v_cdc_ld_date:
-- SELECT TO_CHAR(LAST_CDC_COMPLETION_DATE, 'YYYY-MM-DD HH24:MI:SS')
-- FROM ODS_OWN.ODS_CDC_LOAD_STATUS
-- WHERE ODS_TABLE_NAME=#LIFETOUCH_PROJECT.v_cdc_load_table_name



/*-----------------------------------------------*/
/* TASK No. 3 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 3 */
-- Refresh Variable LIFETOUCH_PROJECT.v_cdc_oms_overlap:
-- select 30/(60*24) 
-- from dual




/*-----------------------------------------------*/
/* TASK No. 4 */
/* Drop work table */

-- drop table RAX_APP_USER.C$_0TAG_GROUP_STG 

-- &


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Create work table */

-- create table RAX_APP_USER.C$_0TAG_GROUP_STG
-- (
-- 	C1_ID	NUMBER(19) NULL,
-- 	C2_NAME	VARCHAR2(255) NULL,
-- 	C3_ACTIVE_FLAG	NUMBER(1) NULL,
-- 	C4_CREATED_BY	VARCHAR2(255) NULL,
-- 	C5_UPDATED_BY	VARCHAR2(255) NULL,
-- 	C6_DATE_CREATED	TIMESTAMP(6) NULL,
-- 	C7_LAST_UPDATED	TIMESTAMP(6) NULL
-- )
-- NOLOGGING

-- &


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Load data */

/* SOURCE CODE */
-- select	
-- 	TAG_GROUP.ID	   C1_ID,
-- 	TAG_GROUP.NAME	   C2_NAME,
-- 	TAG_GROUP.ACTIVE_FLAG	   C3_ACTIVE_FLAG,
-- 	TAG_GROUP.CREATED_BY	   C4_CREATED_BY,
-- 	TAG_GROUP.UPDATED_BY	   C5_UPDATED_BY,
-- 	TAG_GROUP.DATE_CREATED	   C6_DATE_CREATED,
-- 	TAG_GROUP.LAST_UPDATED	   C7_LAST_UPDATED
-- from	TAGS_OWN.TAG_GROUP   TAG_GROUP
-- where	(1=1)
-- And (TAG_GROUP.LAST_UPDATED  >= ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))





-- &

/* TARGET CODE */
-- insert into RAX_APP_USER.C$_0TAG_GROUP_STG
-- (
-- 	C1_ID,
-- 	C2_NAME,
-- 	C3_ACTIVE_FLAG,
-- 	C4_CREATED_BY,
-- 	C5_UPDATED_BY,
-- 	C6_DATE_CREATED,
-- 	C7_LAST_UPDATED
-- )
-- values
-- (
-- 	:C1_ID,
-- 	:C2_NAME,
-- 	:C3_ACTIVE_FLAG,
-- 	:C4_CREATED_BY,
-- 	:C5_UPDATED_BY,
-- 	:C6_DATE_CREATED,
-- 	:C7_LAST_UPDATED
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0TAG_GROUP_STG',
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
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_TAG_GROUP_STG1066001';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;


&

-- drop table RAX_APP_USER.I$_TAG_GROUP_STG1066001 

-- &


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_TAG_GROUP_STG1066001
(
	ID		NUMBER(19) NULL,
	NAME		VARCHAR2(255) NULL,
	ACTIVE_FLAG		NUMBER(1) NULL,
	CREATED_BY		VARCHAR2(255) NULL,
	UPDATED_BY		VARCHAR2(255) NULL,
	DATE_CREATED		TIMESTAMP(6) NULL,
	LAST_UPDATED		TIMESTAMP(6) NULL,
	ODS_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_TAG_GROUP_STG1066001
(
	ID,
	NAME,
	ACTIVE_FLAG,
	CREATED_BY,
	UPDATED_BY,
	DATE_CREATED,
	LAST_UPDATED,
	IND_UPDATE
)
select 
ID,
	NAME,
	ACTIVE_FLAG,
	CREATED_BY,
	UPDATED_BY,
	DATE_CREATED,
	LAST_UPDATED,
	IND_UPDATE
 from (


select 	 
	
	C1_ID ID,
	C2_NAME NAME,
	C3_ACTIVE_FLAG ACTIVE_FLAG,
	C4_CREATED_BY CREATED_BY,
	C5_UPDATED_BY UPDATED_BY,
	C6_DATE_CREATED DATE_CREATED,
	C7_LAST_UPDATED LAST_UPDATED,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0TAG_GROUP_STG
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.TAG_GROUP_STG T
	where	T.ID	= S.ID 
		 and ((T.NAME = S.NAME) or (T.NAME IS NULL and S.NAME IS NULL)) and
		((T.ACTIVE_FLAG = S.ACTIVE_FLAG) or (T.ACTIVE_FLAG IS NULL and S.ACTIVE_FLAG IS NULL)) and
		((T.CREATED_BY = S.CREATED_BY) or (T.CREATED_BY IS NULL and S.CREATED_BY IS NULL)) and
		((T.UPDATED_BY = S.UPDATED_BY) or (T.UPDATED_BY IS NULL and S.UPDATED_BY IS NULL)) and
		((T.DATE_CREATED = S.DATE_CREATED) or (T.DATE_CREATED IS NULL and S.DATE_CREATED IS NULL)) and
		((T.LAST_UPDATED = S.LAST_UPDATED) or (T.LAST_UPDATED IS NULL and S.LAST_UPDATED IS NULL))
        )

  
  

  

 


&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Create Index on flow table */

BEGIN  
   EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_TAG_GROUP_STG_IDX1066001
on		RAX_APP_USER.I$_TAG_GROUP_STG1066001 (ID)';  
 EXCEPTION  
    WHEN OTHERS THEN NULL;  
END;

&

-- create index	RAX_APP_USER.I$_TAG_GROUP_STG_IDX1066001
-- on		RAX_APP_USER.I$_TAG_GROUP_STG1066001 (ID)
-- NOLOGGING

-- &


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_TAG_GROUP_STG1066001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Flag rows for update */

/* DETECTION_STRATEGY = NOT_EXISTS */


update	RAX_APP_USER.I$_TAG_GROUP_STG1066001
set	IND_UPDATE = 'U'
where	(ID)
	in	(
		select	ID
		from	ODS_STAGE.TAG_GROUP_STG
		)



&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Flag useless rows */

/* DETECTION_STRATEGY = NOT_EXISTS */

/* Command skipped due to chosen DETECTION_STRATEGY */



/*-----------------------------------------------*/
/* TASK No. 17 */
/* Update existing rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
update	ODS_STAGE.TAG_GROUP_STG T
set 	
	(
	T.NAME,
	T.ACTIVE_FLAG,
	T.CREATED_BY,
	T.UPDATED_BY,
	T.DATE_CREATED,
	T.LAST_UPDATED
	) =
		(
		select	S.NAME,
			S.ACTIVE_FLAG,
			S.CREATED_BY,
			S.UPDATED_BY,
			S.DATE_CREATED,
			S.LAST_UPDATED
		from	RAX_APP_USER.I$_TAG_GROUP_STG1066001 S
		where	T.ID	=S.ID
	    	 )
	,      T.ODS_MODIFY_DATE = SYSDATE

where	(ID)
	in	(
		select	ID
		from	RAX_APP_USER.I$_TAG_GROUP_STG1066001
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Insert new rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
insert into 	ODS_STAGE.TAG_GROUP_STG T
	(
	ID,
	NAME,
	ACTIVE_FLAG,
	CREATED_BY,
	UPDATED_BY,
	DATE_CREATED,
	LAST_UPDATED
	,       ODS_CREATE_DATE,
	ODS_MODIFY_DATE
	)
select 	ID,
	NAME,
	ACTIVE_FLAG,
	CREATED_BY,
	UPDATED_BY,
	DATE_CREATED,
	LAST_UPDATED
	,       SYSDATE,
	SYSDATE
from	RAX_APP_USER.I$_TAG_GROUP_STG1066001 S



where	IND_UPDATE = 'I'



&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 20 */
/* Drop flow table */

drop table RAX_APP_USER.I$_TAG_GROUP_STG1066001 

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* sub-select inline view */

(


select 	 
	
	C1_ID    ID,
	C2_NAME    NAME,
	C3_ACTIVE_FLAG    ACTIVE_FLAG,
	C4_CREATED_BY    CREATED_BY,
	C5_UPDATED_BY    UPDATED_BY,
	C6_DATE_CREATED    DATE_CREATED,
	C7_LAST_UPDATED    LAST_UPDATED,
	SYSDATE    ODS_CREATE_DATE,
	SYSDATE    ODS_MODIFY_DATE
from	RAX_APP_USER.C$_0TAG_GROUP_STG
where	(1=1)





)

&


/*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */

drop table RAX_APP_USER.C$_0TAG_GROUP_STG 

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* Drop work table */

-- drop table RAX_APP_USER.C$_0TAG_TAG_STG 

-- &


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Create work table */

-- create table RAX_APP_USER.C$_0TAG_TAG_STG
-- (
-- 	C1_ID	NUMBER(19) NULL,
-- 	C2_GROUP_ID	NUMBER(19) NULL,
-- 	C3_NAME	VARCHAR2(255) NULL,
-- 	C4_SEQUENCE	NUMBER(10) NULL,
-- 	C5_ACTIVE_FLAG	NUMBER(1) NULL,
-- 	C6_CREATED_BY	VARCHAR2(255) NULL,
-- 	C7_UPDATED_BY	VARCHAR2(255) NULL,
-- 	C8_DATE_CREATED	TIMESTAMP(6) NULL,
-- 	C9_LAST_UPDATED	TIMESTAMP(6) NULL
-- )
-- NOLOGGING

-- &


/*-----------------------------------------------*/
/* TASK No. 24 */
/* Load data */

/* SOURCE CODE */
-- select	
-- 	TAG.ID	   C1_ID,
-- 	TAG.GROUP_ID	   C2_GROUP_ID,
-- 	TAG.NAME	   C3_NAME,
-- 	TAG.SEQUENCE	   C4_SEQUENCE,
-- 	TAG.ACTIVE_FLAG	   C5_ACTIVE_FLAG,
-- 	TAG.CREATED_BY	   C6_CREATED_BY,
-- 	TAG.UPDATED_BY	   C7_UPDATED_BY,
-- 	TAG.DATE_CREATED	   C8_DATE_CREATED,
-- 	TAG.LAST_UPDATED	   C9_LAST_UPDATED
-- from	TAGS_OWN.TAG   TAG
-- where	(1=1)
-- And (TAG.LAST_UPDATED >=   ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))





-- &

/* TARGET CODE */
-- insert into RAX_APP_USER.C$_0TAG_TAG_STG
-- (
-- 	C1_ID,
-- 	C2_GROUP_ID,
-- 	C3_NAME,
-- 	C4_SEQUENCE,
-- 	C5_ACTIVE_FLAG,
-- 	C6_CREATED_BY,
-- 	C7_UPDATED_BY,
-- 	C8_DATE_CREATED,
-- 	C9_LAST_UPDATED
-- )
-- values
-- (
-- 	:C1_ID,
-- 	:C2_GROUP_ID,
-- 	:C3_NAME,
-- 	:C4_SEQUENCE,
-- 	:C5_ACTIVE_FLAG,
-- 	:C6_CREATED_BY,
-- 	:C7_UPDATED_BY,
-- 	:C8_DATE_CREATED,
-- 	:C9_LAST_UPDATED
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 25 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0TAG_TAG_STG',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;




&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 27 */




/*-----------------------------------------------*/
/* TASK No. 28 */
/* Drop flow table */

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_TAG_TAG_STG1065001';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;


&

-- drop table RAX_APP_USER.I$_TAG_TAG_STG1065001 

-- &


/*-----------------------------------------------*/
/* TASK No. 29 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_TAG_TAG_STG1065001
(
	ID		NUMBER(19) NULL,
	GROUP_ID		NUMBER(19) NULL,
	NAME		VARCHAR2(255) NULL,
	SEQUENCE		NUMBER(10) NULL,
	ACTIVE_FLAG		NUMBER(1) NULL,
	CREATED_BY		VARCHAR2(255) NULL,
	UPDATED_BY		VARCHAR2(255) NULL,
	DATE_CREATED		TIMESTAMP(6) NULL,
	LAST_UPDATED		TIMESTAMP(6) NULL,
	ODS_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = POST_FLOW */
 


  
  
  


insert into	RAX_APP_USER.I$_TAG_TAG_STG1065001
(
	ID,
	GROUP_ID,
	NAME,
	SEQUENCE,
	ACTIVE_FLAG,
	CREATED_BY,
	UPDATED_BY,
	DATE_CREATED,
	LAST_UPDATED,
	IND_UPDATE
)


select 	 
	
	C1_ID,
	C2_GROUP_ID,
	C3_NAME,
	C4_SEQUENCE,
	C5_ACTIVE_FLAG,
	C6_CREATED_BY,
	C7_UPDATED_BY,
	C8_DATE_CREATED,
	C9_LAST_UPDATED,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0TAG_TAG_STG
where	(1=1)






  

 


&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* Create Index on flow table */

BEGIN  
   EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_TAG_TAG_STG_IDX1065001
on		RAX_APP_USER.I$_TAG_TAG_STG1065001 (ID)';  
 EXCEPTION  
    WHEN OTHERS THEN NULL;  
END;

&

-- create index	RAX_APP_USER.I$_TAG_TAG_STG_IDX1065001
-- on		RAX_APP_USER.I$_TAG_TAG_STG1065001 (ID)
-- NOLOGGING

-- &


/*-----------------------------------------------*/
/* TASK No. 32 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_TAG_TAG_STG1065001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 33 */
/* Flag rows for update */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_TAG_TAG_STG1065001
set	IND_UPDATE = 'U'
where	(ID)
	in	(
		select	ID
		from	ODS_STAGE.TAG_TAG_STG
		)



&


/*-----------------------------------------------*/
/* TASK No. 34 */
/* Flag useless rows */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_TAG_TAG_STG1065001 S
set	IND_UPDATE = 'N'
where	exists (
	select 	'X'
	from 	ODS_STAGE.TAG_TAG_STG 	T
	where	T.ID	= S.ID
		and	((T.GROUP_ID = S.GROUP_ID) or (T.GROUP_ID IS NULL and S.GROUP_ID IS NULL))
and	((T.NAME = S.NAME) or (T.NAME IS NULL and S.NAME IS NULL))
and	((T.SEQUENCE = S.SEQUENCE) or (T.SEQUENCE IS NULL and S.SEQUENCE IS NULL))
and	((T.ACTIVE_FLAG = S.ACTIVE_FLAG) or (T.ACTIVE_FLAG IS NULL and S.ACTIVE_FLAG IS NULL))
and	((T.CREATED_BY = S.CREATED_BY) or (T.CREATED_BY IS NULL and S.CREATED_BY IS NULL))
and	((T.UPDATED_BY = S.UPDATED_BY) or (T.UPDATED_BY IS NULL and S.UPDATED_BY IS NULL))
and	((T.DATE_CREATED = S.DATE_CREATED) or (T.DATE_CREATED IS NULL and S.DATE_CREATED IS NULL))
and	((T.LAST_UPDATED = S.LAST_UPDATED) or (T.LAST_UPDATED IS NULL and S.LAST_UPDATED IS NULL))
	)



&


/*-----------------------------------------------*/
/* TASK No. 35 */
/* Update existing rows */

/* DETECTION_STRATEGY = POST_FLOW */
update	ODS_STAGE.TAG_TAG_STG T
set 	
	(
	T.GROUP_ID,
	T.NAME,
	T.SEQUENCE,
	T.ACTIVE_FLAG,
	T.CREATED_BY,
	T.UPDATED_BY,
	T.DATE_CREATED,
	T.LAST_UPDATED
	) =
		(
		select	S.GROUP_ID,
			S.NAME,
			S.SEQUENCE,
			S.ACTIVE_FLAG,
			S.CREATED_BY,
			S.UPDATED_BY,
			S.DATE_CREATED,
			S.LAST_UPDATED
		from	RAX_APP_USER.I$_TAG_TAG_STG1065001 S
		where	T.ID	=S.ID
	    	 )
	,        T.ODS_MODIFY_DATE = SYSDATE

where	(ID)
	in	(
		select	ID
		from	RAX_APP_USER.I$_TAG_TAG_STG1065001
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 36 */
/* Insert new rows */

/* DETECTION_STRATEGY = POST_FLOW */
insert into 	ODS_STAGE.TAG_TAG_STG T
	(
	ID,
	GROUP_ID,
	NAME,
	SEQUENCE,
	ACTIVE_FLAG,
	CREATED_BY,
	UPDATED_BY,
	DATE_CREATED,
	LAST_UPDATED
	,         ODS_CREATE_DATE,
	ODS_MODIFY_DATE
	)
select 	ID,
	GROUP_ID,
	NAME,
	SEQUENCE,
	ACTIVE_FLAG,
	CREATED_BY,
	UPDATED_BY,
	DATE_CREATED,
	LAST_UPDATED
	,         SYSDATE,
	SYSDATE
from	RAX_APP_USER.I$_TAG_TAG_STG1065001 S



where	IND_UPDATE = 'I'



&


/*-----------------------------------------------*/
/* TASK No. 37 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 38 */
/* Drop flow table */

drop table RAX_APP_USER.I$_TAG_TAG_STG1065001 

&


/*-----------------------------------------------*/
/* TASK No. 39 */
/* sub-select inline view */

(


select 	 
	
	C1_ID    ID,
	C2_GROUP_ID    GROUP_ID,
	C3_NAME    NAME,
	C4_SEQUENCE    SEQUENCE,
	C5_ACTIVE_FLAG    ACTIVE_FLAG,
	C6_CREATED_BY    CREATED_BY,
	C7_UPDATED_BY    UPDATED_BY,
	C8_DATE_CREATED    DATE_CREATED,
	C9_LAST_UPDATED    LAST_UPDATED,
	SYSDATE    ODS_CREATE_DATE,
	SYSDATE    ODS_MODIFY_DATE
from	RAX_APP_USER.C$_0TAG_TAG_STG
where	(1=1)





)

&


/*-----------------------------------------------*/
/* TASK No. 1000026 */
/* Drop work table */

drop table RAX_APP_USER.C$_0TAG_TAG_STG 

&


/*-----------------------------------------------*/
/* TASK No. 40 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 40 */




/*-----------------------------------------------*/
/* TASK No. 41 */
/* Drop flow table */

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_TAG_TAG_TYPE_STG1067001';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;


&

-- drop table RAX_APP_USER.I$_TAG_TAG_TYPE_STG1067001 

-- &


/*-----------------------------------------------*/
/* TASK No. 42 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_TAG_TAG_TYPE_STG1067001
(
	ID		NUMBER(19) NULL,
	GROUP_ID		NUMBER(19) NULL,
	NAME		VARCHAR2(255) NULL,
	SEQUENCE		NUMBER(10) NULL,
	ACTIVE_FLAG		NUMBER(1) NULL,
	CREATED_BY		VARCHAR2(255) NULL,
	UPDATED_BY		VARCHAR2(255) NULL,
	DATE_CREATED		TIMESTAMP(6) NULL,
	LAST_UPDATED		TIMESTAMP(6) NULL,
	ODS_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 43 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = POST_FLOW */
 


  
  
  


insert into	RAX_APP_USER.I$_TAG_TAG_TYPE_STG1067001
(
	ID,
	GROUP_ID,
	NAME,
	SEQUENCE,
	ACTIVE_FLAG,
	CREATED_BY,
	UPDATED_BY,
	DATE_CREATED,
	LAST_UPDATED,
	IND_UPDATE
)


select 	 
	
	TAG_TAG_TYPE_STG.ID,
	TAG_TAG_TYPE_STG.GROUP_ID,
	TAG_TAG_TYPE_STG.NAME,
	TAG_TAG_TYPE_STG.SEQUENCE,
	TAG_TAG_TYPE_STG.ACTIVE_FLAG,
	TAG_TAG_TYPE_STG.CREATED_BY,
	TAG_TAG_TYPE_STG.UPDATED_BY,
	TAG_TAG_TYPE_STG.DATE_CREATED,
	TAG_TAG_TYPE_STG.LAST_UPDATED,

	'I' IND_UPDATE

from	ODS_STAGE.TAG_TAG_TYPE_STG   TAG_TAG_TYPE_STG
where	(1=1)

And (TAG_TAG_TYPE_STG.ODS_MODIFY_DATE >=   ( TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))




  

 


&


/*-----------------------------------------------*/
/* TASK No. 44 */
/* Create Index on flow table */

BEGIN  
   EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_TAG_TAG_TYPE_STG_IDX1067001
on		RAX_APP_USER.I$_TAG_TAG_TYPE_STG1067001 (ID)';  
 EXCEPTION  
    WHEN OTHERS THEN NULL;  
END;

&

-- create index	RAX_APP_USER.I$_TAG_TAG_TYPE_STG_IDX1067001
-- on		RAX_APP_USER.I$_TAG_TAG_TYPE_STG1067001 (ID)
-- NOLOGGING

-- &


/*-----------------------------------------------*/
/* TASK No. 45 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_TAG_TAG_TYPE_STG1067001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 46 */
/* Flag rows for update */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_TAG_TAG_TYPE_STG1067001
set	IND_UPDATE = 'U'
where	(ID)
	in	(
		select	ID
		from	ODS_STAGE.TAG_TAG_TYPE_STG
		)



&


/*-----------------------------------------------*/
/* TASK No. 47 */
/* Flag useless rows */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_TAG_TAG_TYPE_STG1067001 S
set	IND_UPDATE = 'N'
where	exists (
	select 	'X'
	from 	ODS_STAGE.TAG_TAG_TYPE_STG 	T
	where	T.ID	= S.ID
		and	((T.GROUP_ID = S.GROUP_ID) or (T.GROUP_ID IS NULL and S.GROUP_ID IS NULL))
and	((T.NAME = S.NAME) or (T.NAME IS NULL and S.NAME IS NULL))
and	((T.SEQUENCE = S.SEQUENCE) or (T.SEQUENCE IS NULL and S.SEQUENCE IS NULL))
and	((T.ACTIVE_FLAG = S.ACTIVE_FLAG) or (T.ACTIVE_FLAG IS NULL and S.ACTIVE_FLAG IS NULL))
and	((T.CREATED_BY = S.CREATED_BY) or (T.CREATED_BY IS NULL and S.CREATED_BY IS NULL))
and	((T.UPDATED_BY = S.UPDATED_BY) or (T.UPDATED_BY IS NULL and S.UPDATED_BY IS NULL))
and	((T.DATE_CREATED = S.DATE_CREATED) or (T.DATE_CREATED IS NULL and S.DATE_CREATED IS NULL))
and	((T.LAST_UPDATED = S.LAST_UPDATED) or (T.LAST_UPDATED IS NULL and S.LAST_UPDATED IS NULL))
	)



&


/*-----------------------------------------------*/
/* TASK No. 48 */
/* Update existing rows */

/* DETECTION_STRATEGY = POST_FLOW */
update	ODS_STAGE.TAG_TAG_TYPE_STG T
set 	
	(
	T.GROUP_ID,
	T.NAME,
	T.SEQUENCE,
	T.ACTIVE_FLAG,
	T.CREATED_BY,
	T.UPDATED_BY,
	T.DATE_CREATED,
	T.LAST_UPDATED
	) =
		(
		select	S.GROUP_ID,
			S.NAME,
			S.SEQUENCE,
			S.ACTIVE_FLAG,
			S.CREATED_BY,
			S.UPDATED_BY,
			S.DATE_CREATED,
			S.LAST_UPDATED
		from	RAX_APP_USER.I$_TAG_TAG_TYPE_STG1067001 S
		where	T.ID	=S.ID
	    	 )
	,        T.ODS_MODIFY_DATE = SYSDATE

where	(ID)
	in	(
		select	ID
		from	RAX_APP_USER.I$_TAG_TAG_TYPE_STG1067001
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 49 */
/* Insert new rows */

/* DETECTION_STRATEGY = POST_FLOW */
insert into 	ODS_STAGE.TAG_TAG_TYPE_STG T
	(
	ID,
	GROUP_ID,
	NAME,
	SEQUENCE,
	ACTIVE_FLAG,
	CREATED_BY,
	UPDATED_BY,
	DATE_CREATED,
	LAST_UPDATED
	,         ODS_CREATE_DATE,
	ODS_MODIFY_DATE
	)
select 	ID,
	GROUP_ID,
	NAME,
	SEQUENCE,
	ACTIVE_FLAG,
	CREATED_BY,
	UPDATED_BY,
	DATE_CREATED,
	LAST_UPDATED
	,         SYSDATE,
	SYSDATE
from	RAX_APP_USER.I$_TAG_TAG_TYPE_STG1067001 S



where	IND_UPDATE = 'I'



&


/*-----------------------------------------------*/
/* TASK No. 50 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 51 */
/* Drop flow table */

drop table RAX_APP_USER.I$_TAG_TAG_TYPE_STG1067001 

&


/*-----------------------------------------------*/
/* TASK No. 52 */
/* sub-select inline view */

(


select 	 
	
	TAG_TAG_TYPE_STG.ID    ID,
	TAG_TAG_TYPE_STG.GROUP_ID    GROUP_ID,
	TAG_TAG_TYPE_STG.NAME    NAME,
	TAG_TAG_TYPE_STG.SEQUENCE    SEQUENCE,
	TAG_TAG_TYPE_STG.ACTIVE_FLAG    ACTIVE_FLAG,
	TAG_TAG_TYPE_STG.CREATED_BY    CREATED_BY,
	TAG_TAG_TYPE_STG.UPDATED_BY    UPDATED_BY,
	TAG_TAG_TYPE_STG.DATE_CREATED    DATE_CREATED,
	TAG_TAG_TYPE_STG.LAST_UPDATED    LAST_UPDATED,
	SYSDATE    ODS_CREATE_DATE,
	SYSDATE    ODS_MODIFY_DATE
from	ODS_STAGE.TAG_TAG_TYPE_STG   TAG_TAG_TYPE_STG
where	(1=1)

And (TAG_TAG_TYPE_STG.ODS_MODIFY_DATE >=   ( TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))



)

&


/*-----------------------------------------------*/
/* TASK No. 53 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
+ nvl((TIMEZONE_OFFSET/24), 0) 
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env


&


/*-----------------------------------------------*/
/* TASK No. 54 */
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
,'28_TAGS_LOAD_PKG'
,'004'
,TO_DATE(SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
,TO_DATE (SUBSTR(:v_cdc_load_date, 1, 19),'YYYY-MM-DD HH24:MI:SS')
,:v_cdc_oms_overlap
,SYSDATE
,:v_env
,TIMEZONE_OFFSET
from 
ODS_OWN.ODS_CDC_LOAD_STATUS
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env


&


/*-----------------------------------------------*/
