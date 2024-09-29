/* TASK No. 1 */
/* Drop work table */
/*-----------------------------------------------*/
/* TASK No. 2 */
/* Create work table */
/*-----------------------------------------------*/
/* TASK No. 3 */
/* Load data */
/* SOURCE CODE */
/* drop table RAX_APP_USER.C$_0FOW_FRNG_MDL_CM_STG */
/* create table RAX_APP_USER.C$_0FOW_FRNG_MDL_CM_STG
(
	C1_ID	NUMBER(19) NULL,
	C2_VERSION	NUMBER(19) NULL,
	C3_BAD_CHECK_ALLOWANCE	FLOAT(126) NULL,
	C4_GUARANTEED_MINIMUM	FLOAT(126) NULL,
	C5_PAY_ON_SHIP_TO_HOME	NUMBER(1) NULL
)
NOLOGGING */
/* select	
	OFFERING_MODEL.ID	   C1_ID,
	OFFERING_MODEL.VERSION	   C2_VERSION,
	OFFERING_MODEL_COMMISSION.BAD_CHECK_ALLOWANCE	   C3_BAD_CHECK_ALLOWANCE,
	OFFERING_MODEL_COMMISSION.GUARANTEED_MINIMUM	   C4_GUARANTEED_MINIMUM,
	OFFERING_MODEL_COMMISSION.PAY_ON_SHIP_TO_HOME	   C5_PAY_ON_SHIP_TO_HOME
from	FOW_OWN.OFFERING_MODEL   OFFERING_MODEL, FOW_OWN.OFFERING_MODEL_COMMISSION   OFFERING_MODEL_COMMISSION
where	(1=1)
And (OFFERING_MODEL.LAST_UPDATED >=   ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))
 And (OFFERING_MODEL.COMMISSION_MODEL_ID=OFFERING_MODEL_COMMISSION.ID) */
/* insert into RAX_APP_USER.C$_0FOW_FRNG_MDL_CM_STG
(
	C1_ID,
	C2_VERSION,
	C3_BAD_CHECK_ALLOWANCE,
	C4_GUARANTEED_MINIMUM,
	C5_PAY_ON_SHIP_TO_HOME
)
values
(
	:C1_ID,
	:C2_VERSION,
	:C3_BAD_CHECK_ALLOWANCE,
	:C4_GUARANTEED_MINIMUM,
	:C5_PAY_ON_SHIP_TO_HOME
) */
/* TARGET CODE */
/*-----------------------------------------------*/
/* TASK No. 4 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0FOW_FRNG_MDL_CM_STG',
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


 /* drop table RAX_APP_USER.I$_FOW_FRNG_MDL_CM_STG914001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FOW_FRNG_MDL_CM_STG914001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 8 */
/* Create flow table I$ */



create table RAX_APP_USER.I$_FOW_FRNG_MDL_CM_STG914001
(
	ID		NUMBER(19) NULL,
	VERSION		NUMBER(19) NULL,
	BAD_CHECK_ALLOWANCE		FLOAT(126) NULL,
	GUARANTEED_MINIMUM		FLOAT(126) NULL,
	PAY_ON_SHIP_TO_HOME		NUMBER(1) NULL,
	ODS_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

& /*-----------------------------------------------*/
/* TASK No. 9 */
/* Insert flow into I$ table */
/* DETECTION_STRATEGY = POST_FLOW */



insert into	RAX_APP_USER.I$_FOW_FRNG_MDL_CM_STG914001
(
	ID,
	VERSION,
	BAD_CHECK_ALLOWANCE,
	GUARANTEED_MINIMUM,
	PAY_ON_SHIP_TO_HOME,
	IND_UPDATE
)


select 	 
	
	C1_ID,
	C2_VERSION,
	C3_BAD_CHECK_ALLOWANCE,
	C4_GUARANTEED_MINIMUM,
	C5_PAY_ON_SHIP_TO_HOME,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0FOW_FRNG_MDL_CM_STG
where	(1=1)

& /*-----------------------------------------------*/
/* TASK No. 10 */
/* Create Index on flow table */



create index	RAX_APP_USER.I$_FOW_FRNG_MDL_CM_STG_IDX
on		RAX_APP_USER.I$_FOW_FRNG_MDL_CM_STG914001 (ID)
NOLOGGING

& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_FOW_FRNG_MDL_CM_STG914001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& /*-----------------------------------------------*/
/* TASK No. 12 */
/* Flag rows for update */
/* DETECTION_STRATEGY = POST_FLOW */



update	RAX_APP_USER.I$_FOW_FRNG_MDL_CM_STG914001
set	IND_UPDATE = 'U'
where	(ID)
	in	(
		select	ID
		from	ODS_STAGE.FOW_OFFERING_MODEL_COMM_STG
		)

& /*-----------------------------------------------*/
/* TASK No. 13 */
/* Flag useless rows */
/* DETECTION_STRATEGY = POST_FLOW */



update	RAX_APP_USER.I$_FOW_FRNG_MDL_CM_STG914001 S
set	IND_UPDATE = 'N'
where	exists (
	select 	'X'
	from 	ODS_STAGE.FOW_OFFERING_MODEL_COMM_STG 	T
	where	T.ID	= S.ID
		and	((T.VERSION = S.VERSION) or (T.VERSION IS NULL and S.VERSION IS NULL))
and	((T.BAD_CHECK_ALLOWANCE = S.BAD_CHECK_ALLOWANCE) or (T.BAD_CHECK_ALLOWANCE IS NULL and S.BAD_CHECK_ALLOWANCE IS NULL))
and	((T.GUARANTEED_MINIMUM = S.GUARANTEED_MINIMUM) or (T.GUARANTEED_MINIMUM IS NULL and S.GUARANTEED_MINIMUM IS NULL))
and	((T.PAY_ON_SHIP_TO_HOME = S.PAY_ON_SHIP_TO_HOME) or (T.PAY_ON_SHIP_TO_HOME IS NULL and S.PAY_ON_SHIP_TO_HOME IS NULL))
	)

& /*-----------------------------------------------*/
/* TASK No. 14 */
/* Insert new rows */
/* DETECTION_STRATEGY = POST_FLOW */



insert into 	ODS_STAGE.FOW_OFFERING_MODEL_COMM_STG T
	(
	ID,
	VERSION,
	BAD_CHECK_ALLOWANCE,
	GUARANTEED_MINIMUM,
	PAY_ON_SHIP_TO_HOME
	,     ODS_CREATE_DATE,
	ODS_MODIFY_DATE
	)
select 	ID,
	VERSION,
	BAD_CHECK_ALLOWANCE,
	GUARANTEED_MINIMUM,
	PAY_ON_SHIP_TO_HOME
	,     SYSDATE,
	SYSDATE
from	RAX_APP_USER.I$_FOW_FRNG_MDL_CM_STG914001 S



where	IND_UPDATE = 'I'

& /*-----------------------------------------------*/
/* TASK No. 15 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 16 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_FOW_FRNG_MDL_CM_STG914001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FOW_FRNG_MDL_CM_STG914001';
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
	
	C1_ID    ID,
	C2_VERSION    VERSION,
	C3_BAD_CHECK_ALLOWANCE    BAD_CHECK_ALLOWANCE,
	C4_GUARANTEED_MINIMUM    GUARANTEED_MINIMUM,
	C5_PAY_ON_SHIP_TO_HOME    PAY_ON_SHIP_TO_HOME,
	SYSDATE    ODS_CREATE_DATE,
	SYSDATE    ODS_MODIFY_DATE
from	RAX_APP_USER.C$_0FOW_FRNG_MDL_CM_STG
where	(1=1)





)

& /*-----------------------------------------------*/
/* TASK No. 1000005 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0FOW_FRNG_MDL_CM_STG */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_FRNG_MDL_CM_STG';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/





&