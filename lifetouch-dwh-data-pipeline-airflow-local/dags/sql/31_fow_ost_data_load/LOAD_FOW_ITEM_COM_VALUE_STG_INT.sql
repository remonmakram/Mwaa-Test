/* TASK No. 1 */
/* Drop work table */
/*-----------------------------------------------*/
/* TASK No. 2 */
/* Create work table */
/*-----------------------------------------------*/
/* TASK No. 3 */
/* Load data */
/* SOURCE CODE */
/* drop table RAX_APP_USER.C$_0FOW_ITM_CM_VL_STG */
/* create table RAX_APP_USER.C$_0FOW_ITM_CM_VL_STG
(
	C1_ID	NUMBER(19) NULL,
	C2_VERSION	NUMBER(19) NULL,
	C3_PACKAGE_COMMISSION_MODEL_ID	NUMBER(19) NULL,
	C4_SKU_CODE	VARCHAR2(255) NULL,
	C5_VALUATION_TYPE	VARCHAR2(255) NULL,
	C6_VALUE	FLOAT(126) NULL
)
NOLOGGING */
/* select	
	ITEM_COMMISSION_VALUE.ID	   C1_ID,
	ITEM_COMMISSION_VALUE.VERSION	   C2_VERSION,
	ITEM_COMMISSION_VALUE.PACKAGE_COMMISSION_MODEL_ID	   C3_PACKAGE_COMMISSION_MODEL_ID,
	ITEM_COMMISSION_VALUE.SKU_CODE	   C4_SKU_CODE,
	ITEM_COMMISSION_VALUE.VALUATION_TYPE	   C5_VALUATION_TYPE,
	ITEM_COMMISSION_VALUE.VALUE	   C6_VALUE
from	FOW_OWN.ITEM_COMMISSION_VALUE   ITEM_COMMISSION_VALUE, FOW_OWN.OFFERING_MODEL_PACKAGE_COMM   OFFERING_MODEL_PACKAGE_COMM, FOW_OWN.OFFERING_MODEL_COMMISSION   OFFERING_MODEL_COMMISSION, FOW_OWN.OFFERING_MODEL   OFFERING_MODEL
where	(1=1)
And (OFFERING_MODEL.LAST_UPDATED >=   ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))
 And (OFFERING_MODEL_PACKAGE_COMM.ID=OFFERING_MODEL_COMMISSION.ID)
AND (OFFERING_MODEL_COMMISSION.ID=OFFERING_MODEL.COMMISSION_MODEL_ID)
AND (ITEM_COMMISSION_VALUE.PACKAGE_COMMISSION_MODEL_ID=OFFERING_MODEL_PACKAGE_COMM.ID) */
/* insert into RAX_APP_USER.C$_0FOW_ITM_CM_VL_STG
(
	C1_ID,
	C2_VERSION,
	C3_PACKAGE_COMMISSION_MODEL_ID,
	C4_SKU_CODE,
	C5_VALUATION_TYPE,
	C6_VALUE
)
values
(
	:C1_ID,
	:C2_VERSION,
	:C3_PACKAGE_COMMISSION_MODEL_ID,
	:C4_SKU_CODE,
	:C5_VALUATION_TYPE,
	:C6_VALUE
) */
/* TARGET CODE */
/*-----------------------------------------------*/
/* TASK No. 4 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0FOW_ITM_CM_VL_STG',
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


 /* drop table RAX_APP_USER.I$_FOW_ITM_CM_VL_STG921001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FOW_ITM_CM_VL_STG921001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 8 */
/* Create flow table I$ */



create table RAX_APP_USER.I$_FOW_ITM_CM_VL_STG921001
(
	ID		NUMBER(19) NULL,
	VERSION		NUMBER(19) NULL,
	PACKAGE_COMMISSION_MODEL_ID		NUMBER(19) NULL,
	SKU_CODE		VARCHAR2(255) NULL,
	VALUATION_TYPE		VARCHAR2(255) NULL,
	VALUE		FLOAT(126) NULL,
	ODS_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

& /*-----------------------------------------------*/
/* TASK No. 9 */
/* Insert flow into I$ table */
/* DETECTION_STRATEGY = NOT_EXISTS */



insert into	RAX_APP_USER.I$_FOW_ITM_CM_VL_STG921001
(
	ID,
	VERSION,
	PACKAGE_COMMISSION_MODEL_ID,
	SKU_CODE,
	VALUATION_TYPE,
	VALUE,
	IND_UPDATE
)
select 
ID,
	VERSION,
	PACKAGE_COMMISSION_MODEL_ID,
	SKU_CODE,
	VALUATION_TYPE,
	VALUE,
	IND_UPDATE
 from (


select 	 
	
	C1_ID ID,
	C2_VERSION VERSION,
	C3_PACKAGE_COMMISSION_MODEL_ID PACKAGE_COMMISSION_MODEL_ID,
	C4_SKU_CODE SKU_CODE,
	C5_VALUATION_TYPE VALUATION_TYPE,
	C6_VALUE VALUE,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0FOW_ITM_CM_VL_STG
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.FOW_ITEM_COMM_VALUE_STG T
	where	T.ID	= S.ID 
		 and ((T.VERSION = S.VERSION) or (T.VERSION IS NULL and S.VERSION IS NULL)) and
		((T.PACKAGE_COMMISSION_MODEL_ID = S.PACKAGE_COMMISSION_MODEL_ID) or (T.PACKAGE_COMMISSION_MODEL_ID IS NULL and S.PACKAGE_COMMISSION_MODEL_ID IS NULL)) and
		((T.SKU_CODE = S.SKU_CODE) or (T.SKU_CODE IS NULL and S.SKU_CODE IS NULL)) and
		((T.VALUATION_TYPE = S.VALUATION_TYPE) or (T.VALUATION_TYPE IS NULL and S.VALUATION_TYPE IS NULL)) and
		((T.VALUE = S.VALUE) or (T.VALUE IS NULL and S.VALUE IS NULL))
        )

& /*-----------------------------------------------*/
/* TASK No. 10 */
/* Create Index on flow table */



create index	RAX_APP_USER.I$_FOW_ITM_CM_VL_STG_IDX921001
on		RAX_APP_USER.I$_FOW_ITM_CM_VL_STG921001 (ID)
NOLOGGING

& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_FOW_ITM_CM_VL_STG921001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& /*-----------------------------------------------*/
/* TASK No. 12 */
/* Flag rows for update */
/* DETECTION_STRATEGY = NOT_EXISTS */



update	RAX_APP_USER.I$_FOW_ITM_CM_VL_STG921001
set	IND_UPDATE = 'U'
where	(ID)
	in	(
		select	ID
		from	ODS_STAGE.FOW_ITEM_COMM_VALUE_STG
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



insert into 	ODS_STAGE.FOW_ITEM_COMM_VALUE_STG T
	(
	ID,
	VERSION,
	PACKAGE_COMMISSION_MODEL_ID,
	SKU_CODE,
	VALUATION_TYPE,
	VALUE
	,      ODS_CREATE_DATE,
	ODS_MODIFY_DATE
	)
select 	ID,
	VERSION,
	PACKAGE_COMMISSION_MODEL_ID,
	SKU_CODE,
	VALUATION_TYPE,
	VALUE
	,      SYSDATE,
	SYSDATE
from	RAX_APP_USER.I$_FOW_ITM_CM_VL_STG921001 S



where	IND_UPDATE = 'I'

& /*-----------------------------------------------*/
/* TASK No. 15 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 16 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_FOW_ITM_CM_VL_STG921001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FOW_ITM_CM_VL_STG921001';
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
	C3_PACKAGE_COMMISSION_MODEL_ID    PACKAGE_COMMISSION_MODEL_ID,
	C4_SKU_CODE    SKU_CODE,
	C5_VALUATION_TYPE    VALUATION_TYPE,
	C6_VALUE    VALUE,
	SYSDATE    ODS_CREATE_DATE,
	SYSDATE    ODS_MODIFY_DATE
from	RAX_APP_USER.C$_0FOW_ITM_CM_VL_STG
where	(1=1)





)

& /*-----------------------------------------------*/
/* TASK No. 1000005 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0FOW_ITM_CM_VL_STG */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_ITM_CM_VL_STG';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/





&