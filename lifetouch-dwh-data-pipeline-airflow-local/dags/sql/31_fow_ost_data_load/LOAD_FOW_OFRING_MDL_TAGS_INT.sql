/* TASK No. 1 */
/* Drop work table */
/*-----------------------------------------------*/
/* TASK No. 2 */
/* Create work table */
/*-----------------------------------------------*/
/* TASK No. 3 */
/* Load data */
/* SOURCE CODE */
/* drop table RAX_APP_USER.C$_0FOW_FRNG_MDL_TGS_STG */
/* create table RAX_APP_USER.C$_0FOW_FRNG_MDL_TGS_STG
(
	C1_OFFERING_MODEL_ID	NUMBER(19) NULL,
	C2_TAGS_INTEGER	NUMBER(10) NULL
)
NOLOGGING */
/* select	
	OFFERING_MODEL_TAGS.OFFERING_MODEL_ID	   C1_OFFERING_MODEL_ID,
	OFFERING_MODEL_TAGS.TAGS_INTEGER	   C2_TAGS_INTEGER
from	FOW_OWN.OFFERING_MODEL_TAGS   OFFERING_MODEL_TAGS, FOW_OWN.OFFERING_MODEL   OFFERING_MODEL
where	(1=1)
And (OFFERING_MODEL.LAST_UPDATED >=   ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))
 And (OFFERING_MODEL.ID=OFFERING_MODEL_TAGS.OFFERING_MODEL_ID) */
/* insert into RAX_APP_USER.C$_0FOW_FRNG_MDL_TGS_STG
(
	C1_OFFERING_MODEL_ID,
	C2_TAGS_INTEGER
)
values
(
	:C1_OFFERING_MODEL_ID,
	:C2_TAGS_INTEGER
) */
/* TARGET CODE */
/*-----------------------------------------------*/
/* TASK No. 4 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0FOW_FRNG_MDL_TGS_STG',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;

& /*-----------------------------------------------*/
/* TASK No. 6 */
/* Set vID */
/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 6 */
/*-----------------------------------------------*/
/* TASK No. 7 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_FOW_FRNG_MDL_TGS_STG920001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FOW_FRNG_MDL_TGS_STG920001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 8 */
/* Create flow table I$ */



create table RAX_APP_USER.I$_FOW_FRNG_MDL_TGS_STG920001
(
	OFFERING_MODEL_ID		NUMBER(19) NULL,
	TAGS_INTEGER		NUMBER(10) NULL,
	ODS_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

& /*-----------------------------------------------*/
/* TASK No. 9 */
/* Insert flow into I$ table */
/* DETECTION_STRATEGY = NOT_EXISTS */



insert into	RAX_APP_USER.I$_FOW_FRNG_MDL_TGS_STG920001
(
	OFFERING_MODEL_ID,
	TAGS_INTEGER,
	IND_UPDATE
)
select 
OFFERING_MODEL_ID,
	TAGS_INTEGER,
	IND_UPDATE
 from (


select 	 
	
	C1_OFFERING_MODEL_ID OFFERING_MODEL_ID,
	C2_TAGS_INTEGER TAGS_INTEGER,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0FOW_FRNG_MDL_TGS_STG
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.FOW_OFRING_MODEL_TAGS_STG T
	where	T.OFFERING_MODEL_ID	= S.OFFERING_MODEL_ID 
		 and ((T.TAGS_INTEGER = S.TAGS_INTEGER) or (T.TAGS_INTEGER IS NULL and S.TAGS_INTEGER IS NULL))
        )

& /*-----------------------------------------------*/
/* TASK No. 10 */
/* Create Index on flow table */



create index	RAX_APP_USER.I$_FOW_FRNG_MDL_TGS_STG_IDX
on		RAX_APP_USER.I$_FOW_FRNG_MDL_TGS_STG920001 (OFFERING_MODEL_ID)
NOLOGGING

& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_FOW_FRNG_MDL_TGS_STG920001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& /*-----------------------------------------------*/
/* TASK No. 12 */
/* Flag rows for update */
/* DETECTION_STRATEGY = NOT_EXISTS */



update	RAX_APP_USER.I$_FOW_FRNG_MDL_TGS_STG920001
set	IND_UPDATE = 'U'
where	(OFFERING_MODEL_ID)
	in	(
		select	OFFERING_MODEL_ID
		from	ODS_STAGE.FOW_OFRING_MODEL_TAGS_STG
		)

& /*-----------------------------------------------*/
/* TASK No. 13 */
/* Flag useless rows */
/* DETECTION_STRATEGY = NOT_EXISTS */
/* Command skipped due to chosen DETECTION_STRATEGY */
/*-----------------------------------------------*/
/* TASK No. 14 */
/* Insert new rows */
/* DETECTION_STRATEGY = NOT_EXISTS */



insert into 	ODS_STAGE.FOW_OFRING_MODEL_TAGS_STG T
	(
	OFFERING_MODEL_ID,
	TAGS_INTEGER
	,  ODS_CREATE_DATE,
	ODS_MODIFY_DATE
	)
select 	OFFERING_MODEL_ID,
	TAGS_INTEGER
	,  SYSDATE,
	SYSDATE
from	RAX_APP_USER.I$_FOW_FRNG_MDL_TGS_STG920001 S



where	IND_UPDATE = 'I'

& /*-----------------------------------------------*/
/* TASK No. 15 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 16 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_FOW_FRNG_MDL_TGS_STG920001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FOW_FRNG_MDL_TGS_STG920001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 17 */
/* sub-select inline view */



(


select 	 
	
	C1_OFFERING_MODEL_ID    OFFERING_MODEL_ID,
	C2_TAGS_INTEGER    TAGS_INTEGER,
	SYSDATE    ODS_CREATE_DATE,
	SYSDATE    ODS_MODIFY_DATE
from	RAX_APP_USER.C$_0FOW_FRNG_MDL_TGS_STG
where	(1=1)





)

& /*-----------------------------------------------*/
/* TASK No. 1000005 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0FOW_FRNG_MDL_TGS_STG */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_FRNG_MDL_TGS_STG';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/





&