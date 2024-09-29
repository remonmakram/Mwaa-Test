/* TASK No. 1 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 2 */




/*-----------------------------------------------*/
/* TASK No. 3 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 3 */




/*-----------------------------------------------*/
/* TASK No. 4 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 4 */




/*-----------------------------------------------*/
/* TASK No. 5 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 5 */




/*-----------------------------------------------*/
/* TASK No. 6 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 6 */




/*-----------------------------------------------*/
/* TASK No. 7 */
/* Dropping temp table for WORK Order Storage */


BEGIN  
   EXECUTE IMMEDIATE 'DROP TABLE rax_app_user.WOMS_TMP_SHIP_DT_WRK_ORD_STR';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;


&



/*-----------------------------------------------*/
/* TASK No. 8 */
/* Create WOMS work order shipping date table */

CREATE TABLE RAX_APP_USER.WOMS_TMP_SHIP_DT_WRK_ORD_STR AS
SELECT DISTINCT 
    WRK_ORD.WORK_ORDER_ID,
    WRK_ORD.WOMS_NODE
FROM 
    ODS_STAGE.WOMS_WORK_ORDER_STG WRK_ORD,
    ODS_STAGE.WOMS_STATUS_HISTORY_STG STATUS_HIST
WHERE 
    WRK_ORD.WORK_ORDER_ID =STATUS_HIST.WORK_ORDER_ID
    AND WRK_ORD.WOMS_NODE     =STATUS_HIST.WOMS_NODE
    and STATUS_HIST.STATUS_ID in ('7','8','9')
    AND WRK_ORD.ODS_MODIFY_DATE  >=  TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap



-- CREATE TABLE RAX_APP_USER.WOMS_TMP_SHIP_DT_WRK_ORD_STR
--    (	"WORK_ORDER_ID" NUMBER NOT NULL ENABLE, 
-- 	"WOMS_NODE" VARCHAR2(1000)
--    )

-- &

-- INSERT INTO RAX_APP_USER.WOMS_TMP_SHIP_DT_WRK_ORD_STR (WORK_ORDER_ID, WOMS_NODE)
-- SELECT DISTINCT 
--     WRK_ORD.WORK_ORDER_ID,
--     WRK_ORD.WOMS_NODE
-- FROM 
--     ODS_STAGE.WOMS_WORK_ORDER_STG WRK_ORD,
--     ODS_STAGE.WOMS_STATUS_HISTORY_STG STATUS_HIST
-- WHERE 
--     WRK_ORD.WORK_ORDER_ID =STATUS_HIST.WORK_ORDER_ID
--     AND WRK_ORD.WOMS_NODE     =STATUS_HIST.WOMS_NODE
--     and STATUS_HIST.STATUS_ID in ('7','8','9')
--     AND WRK_ORD.ODS_MODIFY_DATE  >=  TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* create unique index ods_app_user.WOMS_TMP_INDX */

create unique index rax_app_user.WOMS_TMP_INDX on  rax_app_user.WOMS_TMP_SHIP_DT_WRK_ORD_STR (WORK_ORDER_ID,WOMS_NODE)


&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* STATUS_HIST.ODS_MODIFY_DATE */

insert into rax_app_user.WOMS_TMP_SHIP_DT_WRK_ORD_STR (WORK_ORDER_ID,WOMS_NODE)
(
SELECT DISTINCT 
    WRK_ORD.WORK_ORDER_ID,
    WRK_ORD.WOMS_NODE
FROM 
    ODS_STAGE.WOMS_WORK_ORDER_STG WRK_ORD,
    ODS_STAGE.WOMS_STATUS_HISTORY_STG STATUS_HIST
WHERE 
    WRK_ORD.WORK_ORDER_ID =STATUS_HIST.WORK_ORDER_ID
    AND WRK_ORD.WOMS_NODE     =STATUS_HIST.WOMS_NODE
    and STATUS_HIST.STATUS_ID in ('7','8','9')
    and STATUS_HIST.ODS_MODIFY_DATE>=  TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
    and not exists (select 1 from rax_app_user.WOMS_TMP_SHIP_DT_WRK_ORD_STR z where (1=1)
                and z.WOMS_NODE = WRK_ORD.WOMS_NODE and z.WORK_ORDER_ID = WRK_ORD.WORK_ORDER_ID)
)


&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Dropping Temp Table */

-- DROP TABLE WOMS_TEMP_SHIPPING_DATE_STORE

-- &


BEGIN  
   EXECUTE IMMEDIATE 'DROP TABLE WOMS_TEMP_SHIPPING_DATE_STORE';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;


&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Create TEMP Table for Shipping Date Storage */

CREATE TABLE WOMS_TEMP_SHIPPING_DATE_STORE AS
SELECT *
FROM
  (SELECT WRK_ORD.WOMS_NODE,
    WRK_ORD.SHIPMENT_PROPOSAL_ID,
    MIN(STATUS_HIST.STATUS_CHANGE_TS) SHIPPING_DATE
  FROM ODS_STAGE.WOMS_WORK_ORDER_STG WRK_ORD,
    ODS_STAGE.WOMS_STATUS_HISTORY_STG STATUS_HIST,
    rax_app_user.WOMS_TMP_SHIP_DT_WRK_ORD_STR TEMP
  WHERE WRK_ORD.WORK_ORDER_ID =STATUS_HIST.WORK_ORDER_ID
  AND WRK_ORD.WOMS_NODE       =STATUS_HIST.WOMS_NODE
  AND WRK_ORD.WOMS_NODE       =TEMP.WOMS_NODE
  AND WRK_ORD.WORK_ORDER_ID   =TEMP.WORK_ORDER_ID
AND STATUS_HIST.STATUS_ID in ('7','8','9')
  GROUP BY WRK_ORD.WORK_ORDER_ID,
    WRK_ORD.WOMS_NODE,
    WRK_ORD.SHIPMENT_PROPOSAL_ID
  )

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 13 */




/*-----------------------------------------------*/
/* TASK No. 14 */
/* Drop flow table */

-- drop table RAX_APP_USER.I$_ORDER_BATCH885001 

BEGIN  
   EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.I$_ORDER_BATCH885001 ';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_ORDER_BATCH885001
(
	ORDER_BATCH_OID	NUMBER NULL,
	WOMS_SHIP_DATE	DATE NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = POST_FLOW */
 


  
  
  


insert into	RAX_APP_USER.I$_ORDER_BATCH885001
(
	ORDER_BATCH_OID,
	WOMS_SHIP_DATE,
	IND_UPDATE
)


select 	 
	
	ORDER_BATCH.ORDER_BATCH_OID,
	WOMS_TEMP_SHIPPING_DATE_STORE.SHIPPING_DATE,

	'I' IND_UPDATE

from	ODS_OWN.ORDER_BATCH   ORDER_BATCH, RAX_APP_USER.WOMS_TEMP_SHIPPING_DATE_STORE   WOMS_TEMP_SHIPPING_DATE_STORE
where	(1=1)
 And (ORDER_BATCH.SHIP_NODE=WOMS_TEMP_SHIPPING_DATE_STORE.WOMS_NODE AND ORDER_BATCH.SHIPMENT_PROPOSAL_ID=WOMS_TEMP_SHIPPING_DATE_STORE.SHIPMENT_PROPOSAL_ID)





  



&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_ORDER_BATCH885001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_ORDER_BATCH_IDX885001
on		RAX_APP_USER.I$_ORDER_BATCH885001 (ORDER_BATCH_OID)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Merge Rows */

merge into	ODS_OWN.ORDER_BATCH T
using	RAX_APP_USER.I$_ORDER_BATCH885001 S
on	(
		T.ORDER_BATCH_OID=S.ORDER_BATCH_OID
	)
when matched
then update set
	T.WOMS_SHIP_DATE	= S.WOMS_SHIP_DATE
	
when not matched
then insert
	(
	T.ORDER_BATCH_OID,
	T.WOMS_SHIP_DATE
	
	)
values
	(
	S.ORDER_BATCH_OID,
	S.WOMS_SHIP_DATE
	
	)

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 21 */
/* Drop flow table */
-- drop table RAX_APP_USER.I$_ORDER_BATCH885001 

drop table RAX_APP_USER.I$_ORDER_BATCH885001

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name


&


/*-----------------------------------------------*/
/* TASK No. 23 */
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
'LOAD_WOMS_SHIP_DATE_INTO_WRK_ORD_TABLE',
'005',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_ld_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          ),
:v_cdc_oms_overlap,
SYSDATE)

&


/*-----------------------------------------------*/
