/* TASK No. 1 */
/* Drop work table */
/*-----------------------------------------------*/
/* TASK No. 2 */
/* Create work table */
/*-----------------------------------------------*/
/* TASK No. 3 */
/* Load data */
/* SOURCE CODE */
/* drop table RAX_APP_USER.C$_0FW_FRNG_MDL_PKG_CM */
/* create table RAX_APP_USER.C$_0FW_FRNG_MDL_PKG_CM
(
	C1_ID	NUMBER(19) NULL
)
NOLOGGING */
/* select	DISTINCT
	OFFERING_MODEL_PACKAGE_COMM.ID	   C1_ID
from	FOW_OWN.OFFERING_MODEL_PACKAGE_COMM   OFFERING_MODEL_PACKAGE_COMM, FOW_OWN.OFFERING_MODEL_COMMISSION   OFFERING_MODEL_COMMISSION, FOW_OWN.OFFERING_MODEL   OFFERING_MODEL
where	(1=1)
And (OFFERING_MODEL.LAST_UPDATED >=  ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))
 And (OFFERING_MODEL_COMMISSION.ID=OFFERING_MODEL_PACKAGE_COMM.ID)
AND (OFFERING_MODEL.COMMISSION_MODEL_ID=OFFERING_MODEL_COMMISSION.ID) */
/* insert into RAX_APP_USER.C$_0FW_FRNG_MDL_PKG_CM
(
	C1_ID
)
values
(
	:C1_ID
) */
/* TARGET CODE */
/*-----------------------------------------------*/
/* TASK No. 4 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0FW_FRNG_MDL_PKG_CM',
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


 /* drop table RAX_APP_USER.I$_FW_FRNG_MDL_PKG_CM918001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FW_FRNG_MDL_PKG_CM918001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 8 */
/* Create flow table I$ */



create table RAX_APP_USER.I$_FW_FRNG_MDL_PKG_CM918001
(
	ID		NUMBER(19) NULL,
	ODS_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

& /*-----------------------------------------------*/
/* TASK No. 9 */
/* Insert flow into I$ table */
/* DETECTION_STRATEGY = POST_FLOW */



insert into	RAX_APP_USER.I$_FW_FRNG_MDL_PKG_CM918001
(
	ID,
	IND_UPDATE
)


select 	 
	DISTINCT
	C1_ID,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0FW_FRNG_MDL_PKG_CM
where	(1=1)

& /*-----------------------------------------------*/
/* TASK No. 10 */
/* Create Index on flow table */



create index	RAX_APP_USER.I$_FW_FRNG_MDL_PKG_CM_IDX9
on		RAX_APP_USER.I$_FW_FRNG_MDL_PKG_CM918001 (ID)
NOLOGGING

& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_FW_FRNG_MDL_PKG_CM918001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& /*-----------------------------------------------*/
/* TASK No. 12 */
/* Flag rows for update */
/* DETECTION_STRATEGY = POST_FLOW */



update	RAX_APP_USER.I$_FW_FRNG_MDL_PKG_CM918001
set	IND_UPDATE = 'U'
where	(ID)
	in	(
		select	ID
		from	ODS_STAGE.FOW_OFRING_MODEL_PKG_COM_STG
		)

& /*-----------------------------------------------*/
/* TASK No. 13 */
/* Flag useless rows */
/* DETECTION_STRATEGY = POST_FLOW */
/* Command skipped due to chosen DETECTION_STRATEGY */
/*-----------------------------------------------*/
/* TASK No. 14 */
/* Insert new rows */
/* DETECTION_STRATEGY = POST_FLOW */



insert into 	ODS_STAGE.FOW_OFRING_MODEL_PKG_COM_STG T
	(
	ID
	, ODS_CREATE_DATE,
	ODS_MODIFY_DATE
	)
select 	ID
	, SYSDATE,
	SYSDATE
from	RAX_APP_USER.I$_FW_FRNG_MDL_PKG_CM918001 S



where	IND_UPDATE = 'I'

& /*-----------------------------------------------*/
/* TASK No. 15 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 16 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_FW_FRNG_MDL_PKG_CM918001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FW_FRNG_MDL_PKG_CM918001';
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
	DISTINCT
	C1_ID    ID,
	SYSDATE    ODS_CREATE_DATE,
	SYSDATE    ODS_MODIFY_DATE
from	RAX_APP_USER.C$_0FW_FRNG_MDL_PKG_CM
where	(1=1)





)

& /*-----------------------------------------------*/
/* TASK No. 1000005 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0FW_FRNG_MDL_PKG_CM */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FW_FRNG_MDL_PKG_CM';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/





&