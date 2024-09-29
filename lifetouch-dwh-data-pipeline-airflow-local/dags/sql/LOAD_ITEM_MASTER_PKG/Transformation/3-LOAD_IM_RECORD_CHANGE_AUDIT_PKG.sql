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

-- drop table RAX_APP_USER.C$_0IM_RECORD_CHANGE_AUDIT_STG purge

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 5 */
-- /* Create work table */

-- create table RAX_APP_USER.C$_0IM_RECORD_CHANGE_AUDIT_STG
-- (
-- 	C1_TABLE_NAME	VARCHAR2(30) NULL,
-- 	C2_KEY_VALUE	VARCHAR2(255) NULL,
-- 	C3_EVENT_TYPE	VARCHAR2(10) NULL,
-- 	C4_EVENT_DETAIL	VARCHAR2(2000) NULL,
-- 	C5_DATE_CREATED	DATE NULL
-- )
-- NOLOGGING

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 6 */
-- /* Load data */

-- /* SOURCE CODE */


-- select	
-- 	RECORD_CHANGE_AUDIT.TABLE_NAME	   C1_TABLE_NAME,
-- 	RECORD_CHANGE_AUDIT.KEY_VALUE	   C2_KEY_VALUE,
-- 	RECORD_CHANGE_AUDIT.EVENT_TYPE	   C3_EVENT_TYPE,
-- 	RECORD_CHANGE_AUDIT.EVENT_DETAIL	   C4_EVENT_DETAIL,
-- 	RECORD_CHANGE_AUDIT.DATE_CREATED	   C5_DATE_CREATED
-- from	ITEM_MASTER_OWN.RECORD_CHANGE_AUDIT   RECORD_CHANGE_AUDIT
-- where	(1=1)
-- And (RECORD_CHANGE_AUDIT.DATE_CREATED >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap)







-- &

-- /* TARGET CODE */
-- insert /*+ append */ into RAX_APP_USER.C$_0IM_RECORD_CHANGE_AUDIT_STG
-- (
-- 	C1_TABLE_NAME,
-- 	C2_KEY_VALUE,
-- 	C3_EVENT_TYPE,
-- 	C4_EVENT_DETAIL,
-- 	C5_DATE_CREATED
-- )
-- values
-- (
-- 	:C1_TABLE_NAME,
-- 	:C2_KEY_VALUE,
-- 	:C3_EVENT_TYPE,
-- 	:C4_EVENT_DETAIL,
-- 	:C5_DATE_CREATED
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0IM_RECORD_CHANGE_AUDIT_STG',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;




&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Drop flow table */

-- drop table RAX_APP_USER.I$_IM_RECORD_CHANGE_AUDIT_STG 
BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_IM_RECORD_CHANGE_AUDIT_STG ';  
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

create table RAX_APP_USER.I$_IM_RECORD_CHANGE_AUDIT_STG
(
	TABLE_NAME		VARCHAR2(30) NULL,
	KEY_VALUE		VARCHAR2(255) NULL,
	EVENT_TYPE		VARCHAR2(10) NULL,
	EVENT_DETAIL		VARCHAR2(2000) NULL,
	DATE_CREATED		DATE NULL,
	ODS_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_IM_RECORD_CHANGE_AUDIT_STG
(
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	IND_UPDATE
)
select 
TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	IND_UPDATE
 from (


select 	 
	
	C1_TABLE_NAME TABLE_NAME,
	C2_KEY_VALUE KEY_VALUE,
	C3_EVENT_TYPE EVENT_TYPE,
	C4_EVENT_DETAIL EVENT_DETAIL,
	C5_DATE_CREATED DATE_CREATED,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0IM_RECORD_CHANGE_AUDIT_STG
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.IM_RECORD_CHANGE_AUDIT_STG T
	where	T.TABLE_NAME	= S.TABLE_NAME
	and	T.KEY_VALUE	= S.KEY_VALUE 
		 and ((T.EVENT_TYPE = S.EVENT_TYPE) or (T.EVENT_TYPE IS NULL and S.EVENT_TYPE IS NULL)) and
		((T.EVENT_DETAIL = S.EVENT_DETAIL) or (T.EVENT_DETAIL IS NULL and S.EVENT_DETAIL IS NULL)) and
		((T.DATE_CREATED = S.DATE_CREATED) or (T.DATE_CREATED IS NULL and S.DATE_CREATED IS NULL))
        )

  
  

  

 


&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_IM_RECORD_CHANGE_AUDIT_STG_
on		RAX_APP_USER.I$_IM_RECORD_CHANGE_AUDIT_STG (TABLE_NAME, KEY_VALUE)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_IM_RECORD_CHANGE_AUDIT_STG',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* create check table */




BEGIN
   EXECUTE IMMEDIATE '  
            create table RAX_APP_USER.SNP_CHECK_TAB
			(
				CATALOG_NAME	VARCHAR2(100 CHAR) NULL ,
				SCHEMA_NAME	VARCHAR2(100 CHAR) NULL ,
				RESOURCE_NAME	VARCHAR2(100 CHAR) NULL,
				FULL_RES_NAME	VARCHAR2(100 CHAR) NULL,
				ERR_TYPE		VARCHAR2(1 CHAR) NULL,
				ERR_MESS		VARCHAR2(250 CHAR) NULL ,
				CHECK_DATE	DATE NULL,
				ORIGIN		VARCHAR2(100 CHAR) NULL,
				CONS_NAME	VARCHAR2(35 CHAR) NULL,
				CONS_TYPE		VARCHAR2(2 CHAR) NULL,
				ERR_COUNT		NUMBER(10) NULL
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
/* TASK No. 15 */
/* delete previous check sum */

delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS_STAGE'
and	ORIGIN 		= '(2477001)ODS_Project.LOAD_IM_RECORD_CHANGE_AUDIT_INT'
and	ERR_TYPE 		= 'F'


&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* create error table */




BEGIN
   EXECUTE IMMEDIATE '  
            create table RAX_APP_USER.E$_IM_RECORD_CHANGE_AUDIT_STG
			(
				ODI_ROW_ID 		UROWID,
				ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
				ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
				ODI_CHECK_DATE	DATE NULL, 
				TABLE_NAME	VARCHAR2(30) NULL,
				KEY_VALUE	VARCHAR2(255) NULL,
				EVENT_TYPE	VARCHAR2(10) NULL,
				EVENT_DETAIL	VARCHAR2(2000) NULL,
				DATE_CREATED	DATE NULL,
				ODS_CREATE_DATE	DATE NULL,
				ODS_MODIFY_DATE	DATE NULL,
				ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
				ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
				ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
				ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
				ODI_SESS_NO		VARCHAR2(19 CHAR)
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
/* TASK No. 17 */
/* delete previous errors */

delete from 	RAX_APP_USER.E$_IM_RECORD_CHANGE_AUDIT_STG
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(2477001)ODS_Project.LOAD_IM_RECORD_CHANGE_AUDIT_INT')


&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Create index on AK */

 
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */
-- create index 	IM_RECORD_CHANGE_AUDIT_STG_PK_flow
-- on	RAX_APP_USER.I$_IM_RECORD_CHANGE_AUDIT_STG 
-- 	(KEY_VALUE,
-- 			TABLE_NAME)

BEGIN
   EXECUTE IMMEDIATE 'create index 	IM_RECORD_CHANGE_AUDIT_STG_PK_flow on RAX_APP_USER.I$_IM_RECORD_CHANGE_AUDIT_STG  (KEY_VALUE, TABLE_NAME)';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -972 THEN
         RAISE;
      END IF;
END;
&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* insert AK errors */

insert into RAX_APP_USER.E$_IM_RECORD_CHANGE_AUDIT_STG
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
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	ODS_CREATE_DATE,
	ODS_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15063: The alternate key IM_RECORD_CHANGE_AUDIT_STG_PK is not unique.',
	'(2477001)ODS_Project.LOAD_IM_RECORD_CHANGE_AUDIT_INT',
	sysdate,
	'IM_RECORD_CHANGE_AUDIT_STG_PK',
	'AK',	
	IM_RECORD_CHANGE_AUDIT_STG.TABLE_NAME,
	IM_RECORD_CHANGE_AUDIT_STG.KEY_VALUE,
	IM_RECORD_CHANGE_AUDIT_STG.EVENT_TYPE,
	IM_RECORD_CHANGE_AUDIT_STG.EVENT_DETAIL,
	IM_RECORD_CHANGE_AUDIT_STG.DATE_CREATED,
	IM_RECORD_CHANGE_AUDIT_STG.ODS_CREATE_DATE,
	IM_RECORD_CHANGE_AUDIT_STG.ODS_MODIFY_DATE
from	RAX_APP_USER.I$_IM_RECORD_CHANGE_AUDIT_STG   IM_RECORD_CHANGE_AUDIT_STG
where	exists  (
		select	SUB.KEY_VALUE,
			SUB.TABLE_NAME
		from 	RAX_APP_USER.I$_IM_RECORD_CHANGE_AUDIT_STG SUB
		where 	SUB.KEY_VALUE=IM_RECORD_CHANGE_AUDIT_STG.KEY_VALUE
			and SUB.TABLE_NAME=IM_RECORD_CHANGE_AUDIT_STG.TABLE_NAME
		group by 	SUB.KEY_VALUE,
			SUB.TABLE_NAME
		having 	count(1) > 1
		)



&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* create index on error table */

 
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */
-- create index 	RAX_APP_USER.E$_IM_RECORD_CHANGE_AUDIT_STG_
-- on	RAX_APP_USER.E$_IM_RECORD_CHANGE_AUDIT_STG (ODI_ROW_ID)

BEGIN
   EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_IM_RECORD_CHANGE_AUDIT_STG_ on	RAX_APP_USER.E$_IM_RECORD_CHANGE_AUDIT_STG (ODI_ROW_ID)';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -955 THEN
         RAISE;
      END IF;
END;
&

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* delete errors from controlled table */

delete from	RAX_APP_USER.I$_IM_RECORD_CHANGE_AUDIT_STG  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_IM_RECORD_CHANGE_AUDIT_STG E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)


&


/*-----------------------------------------------*/
/* TASK No. 22 */
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
	'IM_RECORD_CHANGE_AUDIT_STG',
	'ODS_STAGE.IM_RECORD_CHANGE_AUDIT_STG',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_IM_RECORD_CHANGE_AUDIT_STG E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(2477001)ODS_Project.LOAD_IM_RECORD_CHANGE_AUDIT_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE


&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Flag rows for update */

/* DETECTION_STRATEGY = NOT_EXISTS */


update	RAX_APP_USER.I$_IM_RECORD_CHANGE_AUDIT_STG
set	IND_UPDATE = 'U'
where	(TABLE_NAME, KEY_VALUE)
	in	(
		select	TABLE_NAME,
			KEY_VALUE
		from	ODS_STAGE.IM_RECORD_CHANGE_AUDIT_STG
		)



&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* Flag useless rows */

/* DETECTION_STRATEGY = NOT_EXISTS */

/* Command skipped due to chosen DETECTION_STRATEGY */



/*-----------------------------------------------*/
/* TASK No. 25 */
/* Update existing rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
update	ODS_STAGE.IM_RECORD_CHANGE_AUDIT_STG T
set 	
	(
	T.EVENT_TYPE,
	T.EVENT_DETAIL,
	T.DATE_CREATED
	) =
		(
		select	S.EVENT_TYPE,
			S.EVENT_DETAIL,
			S.DATE_CREATED
		from	RAX_APP_USER.I$_IM_RECORD_CHANGE_AUDIT_STG S
		where	T.TABLE_NAME	=S.TABLE_NAME
		and	T.KEY_VALUE	=S.KEY_VALUE
	    	 )
	,   T.ODS_MODIFY_DATE = sysdate

where	(TABLE_NAME, KEY_VALUE)
	in	(
		select	TABLE_NAME,
			KEY_VALUE
		from	RAX_APP_USER.I$_IM_RECORD_CHANGE_AUDIT_STG
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* Insert new rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
insert into 	ODS_STAGE.IM_RECORD_CHANGE_AUDIT_STG T
	(
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED
	,     ODS_CREATE_DATE,
	ODS_MODIFY_DATE
	)
select 	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED
	,     sysdate,
	sysdate
from	RAX_APP_USER.I$_IM_RECORD_CHANGE_AUDIT_STG S



where	IND_UPDATE = 'I'



&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 28 */
/* Drop flow table */

-- drop table RAX_APP_USER.I$_IM_RECORD_CHANGE_AUDIT_STG 
BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_IM_RECORD_CHANGE_AUDIT_STG';  
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

-- drop table RAX_APP_USER.C$_0IM_RECORD_CHANGE_AUDIT_STG purge
BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0IM_RECORD_CHANGE_AUDIT_STG purge';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* delete from ods_own.selection_field */

update ods_own.selection_field sf
set deleted_ind = 1
where exists
(
  select 1 from ods_stage.im_record_change_audit_stg rca, ods_stage.im_selection_field_xr xr
  where xr.id = rca.key_value
  and xr.selection_field_oid = sf.selection_field_oid
  and rca.table_name = 'SELECTION_FIELD'
  and rca.event_type = 'DELETE'
  and rca.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
)

&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* delete from ods_own.selection_field_choice */

update ods_own.selection_field_choice sfc
set deleted_ind = 1
where exists
(
  select 1 from ods_stage.im_record_change_audit_stg rca, ods_stage.im_selection_field_choice_xr xr
  where xr.id = rca.key_value
  and xr.selection_field_choice_oid = sfc.selection_field_choice_oid
  and rca.table_name = 'SELECTION_FIELD_CHOICE'
  and rca.event_type = 'DELETE'
  and rca.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
)

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
,'LOAD_IM_RECORD_CHANGE_AUDIT_PKG'
,'001'
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
'LOAD_IM_RECORD_CHANGE_AUDIT_PKG',
'001',
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
