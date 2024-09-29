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
/*
drop table RAX_APP_USER.C$_0MLT_ORDER_LINE_ITEM 

&
*/

/*-----------------------------------------------*/
/* TASK No. 5 */
/* Create work table */
/*
create table RAX_APP_USER.C$_0MLT_ORDER_LINE_ITEM (C1_PARENT_ORDER_LINE_ID	NUMBER NULL,	C2_CHILD_ORDER_LINE_ID	NUMBER NULL) NOLOGGING

&
*/

/*-----------------------------------------------*/
/* TASK No. 6 */
/* Load data */

/* SOURCE CODE */
/*
select	
	ORDER_LINE_ITEM.PARENT_ORDER_LINE_ID	   C1_PARENT_ORDER_LINE_ID,
	ORDER_LINE_ITEM.CHILD_ORDER_LINE_ID	   C2_CHILD_ORDER_LINE_ID
from	MLT_OWN.ORDER_LINE_ITEM   ORDER_LINE_ITEM, MLT_OWN.ORDER_LINE   ORDER_LINE
where	(1=1)
And (ORDER_LINE.AUDIT_MODIFY_DATE >= ( TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))
 And (ORDER_LINE_ITEM.PARENT_ORDER_LINE_ID=ORDER_LINE.ORDER_LINE_ID)




&
*/
/* TARGET CODE */
/*
insert into RAX_APP_USER.C$_0MLT_ORDER_LINE_ITEM
(
	C1_PARENT_ORDER_LINE_ID,
	C2_CHILD_ORDER_LINE_ID
)
values
(
	:C1_PARENT_ORDER_LINE_ID,
	:C2_CHILD_ORDER_LINE_ID
)

&
*/

/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0MLT_ORDER_LINE_ITEM',
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
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_MLT_ORDER_LINE_ITEM1728001 ';  
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

create table RAX_APP_USER.I$_MLT_ORDER_LINE_ITEM1728001
(
	EFFECTIVE_DATE		DATE NULL,
	PARENT_ORDER_LINE_ID		NUMBER NULL,
	CHILD_ORDER_LINE_ID		NUMBER NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_MLT_ORDER_LINE_ITEM1728001
(
	PARENT_ORDER_LINE_ID,
	CHILD_ORDER_LINE_ID,
	IND_UPDATE
)
select 
PARENT_ORDER_LINE_ID,
	CHILD_ORDER_LINE_ID,
	IND_UPDATE
 from (


select 	 
	
	C1_PARENT_ORDER_LINE_ID PARENT_ORDER_LINE_ID,
	C2_CHILD_ORDER_LINE_ID CHILD_ORDER_LINE_ID,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0MLT_ORDER_LINE_ITEM
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS.MLT_ORDER_LINE_ITEM T
	where	T.PARENT_ORDER_LINE_ID	= S.PARENT_ORDER_LINE_ID
	and	T.CHILD_ORDER_LINE_ID	= S.CHILD_ORDER_LINE_ID 
		
        )

  
  

  

 


&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Create Index on flow table */

--create index	RAX_APP_USER.I$_MLT_ORDR_LN_ITEM_IDX1728001
--on		RAX_APP_USER.I$_MLT_ORDER_LINE_ITEM1728001 (PARENT_ORDER_LINE_ID, CHILD_ORDER_LINE_ID)
--NOLOGGING

BEGIN
   EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_MLT_ORDR_LN_ITEM_IDX1728001 on	RAX_APP_USER.I$_MLT_ORDER_LINE_ITEM1728001 (PARENT_ORDER_LINE_ID, CHILD_ORDER_LINE_ID) NOLOGGING';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE NOT IN (-972,-955) THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_MLT_ORDER_LINE_ITEM1728001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* create check table */

/*
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
	

&
*/

/*-----------------------------------------------*/
/* TASK No. 16 */
/* delete previous check sum */

delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS'
and	ORIGIN 		= '(1728001)ODS_Project.LOAD_MLT_ORDER_LINE_ITEM_INT'
and	ERR_TYPE 		= 'F'


&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* create error table */

BEGIN
   EXECUTE IMMEDIATE
   'create table RAX_APP_USER.E$_MLT_ORDER_LINE_ITEM1728001
(
	ODI_ROW_ID 		UROWID,
	ODI_ERR_TYPE		VARCHAR2(1 CHAR) NULL, 
	ODI_ERR_MESS		VARCHAR2(250 CHAR) NULL,
	ODI_CHECK_DATE	DATE NULL, 
	EFFECTIVE_DATE	DATE NULL,
	PARENT_ORDER_LINE_ID	NUMBER NULL,
	CHILD_ORDER_LINE_ID	NUMBER NULL,
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
         DBMS_OUTPUT.PUT_LINE('Table RAX_APP_USER.E$_MLT_ORDER_LINE_ITEM1728001 already exists.');
      END IF;
END;




&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* delete previous errors */

delete from 	RAX_APP_USER.E$_MLT_ORDER_LINE_ITEM1728001
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(1728001)ODS_Project.LOAD_MLT_ORDER_LINE_ITEM_INT')


&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_MLT_ORDER_LINE_ITEM1728001
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
	EFFECTIVE_DATE,
	PARENT_ORDER_LINE_ID,
	CHILD_ORDER_LINE_ID
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column PARENT_ORDER_LINE_ID cannot be null.',
	sysdate,
	'(1728001)ODS_Project.LOAD_MLT_ORDER_LINE_ITEM_INT',
	'PARENT_ORDER_LINE_ID',
	'NN',	
	EFFECTIVE_DATE,
	PARENT_ORDER_LINE_ID,
	CHILD_ORDER_LINE_ID
from	RAX_APP_USER.I$_MLT_ORDER_LINE_ITEM1728001
where	PARENT_ORDER_LINE_ID is null



&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* insert Not Null errors */

insert into RAX_APP_USER.E$_MLT_ORDER_LINE_ITEM1728001
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
	EFFECTIVE_DATE,
	PARENT_ORDER_LINE_ID,
	CHILD_ORDER_LINE_ID
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column CHILD_ORDER_LINE_ID cannot be null.',
	sysdate,
	'(1728001)ODS_Project.LOAD_MLT_ORDER_LINE_ITEM_INT',
	'CHILD_ORDER_LINE_ID',
	'NN',	
	EFFECTIVE_DATE,
	PARENT_ORDER_LINE_ID,
	CHILD_ORDER_LINE_ID
from	RAX_APP_USER.I$_MLT_ORDER_LINE_ITEM1728001
where	CHILD_ORDER_LINE_ID is null



&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* create index on error table */

 
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */
--create index 	RAX_APP_USER.E$_MLT_ORDER_LINE_ITEM1728001
--on	RAX_APP_USER.E$_MLT_ORDER_LINE_ITEM1728001 (ODI_ROW_ID)

BEGIN
   EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_MLT_ORDER_LINE_ITEM1728001 on	RAX_APP_USER.E$_MLT_ORDER_LINE_ITEM1728001 (ODI_ROW_ID)';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE NOT IN (-972,-955) THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* delete errors from controlled table */

delete from	RAX_APP_USER.I$_MLT_ORDER_LINE_ITEM1728001  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_MLT_ORDER_LINE_ITEM1728001 E
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
	'ODS',
	'MLT_ORDER_LINE_ITEM',
	'ODS.MLT_ORDER_LINE_ITEM1728001',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_MLT_ORDER_LINE_ITEM1728001 E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(1728001)ODS_Project.LOAD_MLT_ORDER_LINE_ITEM_INT'
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


update	RAX_APP_USER.I$_MLT_ORDER_LINE_ITEM1728001
set	IND_UPDATE = 'U'
where	(PARENT_ORDER_LINE_ID, CHILD_ORDER_LINE_ID)
	in	(
		select	PARENT_ORDER_LINE_ID,
			CHILD_ORDER_LINE_ID
		from	ODS.MLT_ORDER_LINE_ITEM
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
update	ODS.MLT_ORDER_LINE_ITEM T
set 	

	T.EFFECTIVE_DATE = SYSDATE

where	(PARENT_ORDER_LINE_ID, CHILD_ORDER_LINE_ID)
	in	(
		select	PARENT_ORDER_LINE_ID,
			CHILD_ORDER_LINE_ID
		from	RAX_APP_USER.I$_MLT_ORDER_LINE_ITEM1728001
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* Insert new rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
insert into 	ODS.MLT_ORDER_LINE_ITEM T
	(
	PARENT_ORDER_LINE_ID,
	CHILD_ORDER_LINE_ID
	,  EFFECTIVE_DATE
	)
select 	PARENT_ORDER_LINE_ID,
	CHILD_ORDER_LINE_ID
	,  SYSDATE
from	RAX_APP_USER.I$_MLT_ORDER_LINE_ITEM1728001 S



where	IND_UPDATE = 'I'



&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 29 */
/* Drop flow table */

--drop table RAX_APP_USER.I$_MLT_ORDER_LINE_ITEM1728001 
BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_MLT_ORDER_LINE_ITEM1728001';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* sub-select inline view */

(


select 	 
	
	SYSDATE    EFFECTIVE_DATE,
	C1_PARENT_ORDER_LINE_ID    PARENT_ORDER_LINE_ID,
	C2_CHILD_ORDER_LINE_ID    CHILD_ORDER_LINE_ID
from	RAX_APP_USER.C$_0MLT_ORDER_LINE_ITEM
where	(1=1)





)

&


/*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */

--drop table RAX_APP_USER.C$_0MLT_ORDER_LINE_ITEM 
BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0MLT_ORDER_LINE_ITEM ';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;


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
,'LOAD_MLT_ORDER_LINE_ITEM_PKG'
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
'LOAD_MLT_ORDER_LINE_ITEM_PKG',
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
