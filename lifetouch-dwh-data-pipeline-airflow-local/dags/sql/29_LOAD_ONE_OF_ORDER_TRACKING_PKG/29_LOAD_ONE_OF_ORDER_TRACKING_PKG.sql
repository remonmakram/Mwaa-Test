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
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 7 */




/*-----------------------------------------------*/
/* TASK No. 8 */
/* Drop flow table */

BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_ONE_OF_ORDER_WIP857001';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -942 THEN
            DBMS_OUTPUT.PUT_LINE('Table does not exist.');
        ELSE
            RAISE;
        END IF;
END; 

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_ONE_OF_ORDER_WIP857001
(
	ONE_OF_ORDER_WIP_OID	NUMBER NULL,
	ORDER_NO	VARCHAR2(40) NULL,
	APO_OID	NUMBER NULL,
	EVENT_OID	NUMBER NULL,
	ORDER_DATE	DATE NULL,
	OMS_CREATE_DATE	DATE NULL,
	SHIP_NODE	VARCHAR2(40) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	SOURCE_SYSTEM_OID	NUMBER NULL,
	ORDER_SHIP_DATE	DATE NULL,
	ORDER_HEADER_OID	NUMBER NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  


insert into	RAX_APP_USER.I$_ONE_OF_ORDER_WIP857001
(
	ORDER_NO,
	APO_OID,
	EVENT_OID,
	ORDER_DATE,
	OMS_CREATE_DATE,
	SHIP_NODE,
	SOURCE_SYSTEM_OID,
	ORDER_SHIP_DATE,
	ORDER_HEADER_OID,
	IND_UPDATE
)
select 
ORDER_NO,
	APO_OID,
	EVENT_OID,
	ORDER_DATE,
	OMS_CREATE_DATE,
	SHIP_NODE,
	SOURCE_SYSTEM_OID,
	ORDER_SHIP_DATE,
	ORDER_HEADER_OID,
	IND_UPDATE
 from (


select 	 
	
	ORDER_HEADER.ORDER_NO ORDER_NO,
	ORDER_HEADER.APO_OID APO_OID,
	ORDER_HEADER.EVENT_OID EVENT_OID,
	ORDER_HEADER.ORDER_DATE ORDER_DATE,
	ORDER_HEADER.OMS_CREATETS OMS_CREATE_DATE,
	ORDER_HEADER.SHIP_NODE SHIP_NODE,
	ORDER_HEADER.SOURCE_SYSTEM_OID SOURCE_SYSTEM_OID,
	ORDER_HEADER.ORDER_SHIP_DATE ORDER_SHIP_DATE,
	ORDER_HEADER.ORDER_HEADER_OID ORDER_HEADER_OID,

	'I' IND_UPDATE

from	ODS_OWN.ORDER_HEADER   ORDER_HEADER, ODS_OWN.SOURCE_SYSTEM   SOURCE_SYSTEM
where	(1=1)
 And (SOURCE_SYSTEM.SOURCE_SYSTEM_OID=ORDER_HEADER.SOURCE_SYSTEM_OID)
And (ORDER_HEADER.SHIP_ORDERS_TO =  'Subject')
 And (ORDER_HEADER.ODS_MODIFY_DATE >=  ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_oms_overlap))
 And (SOURCE_SYSTEM.SOURCE_SYSTEM_SHORT_NAME <> 'OMS2')




) S
where NOT EXISTS 
	( select 1 from ODS_OWN.ONE_OF_ORDER_WIP T
	where	T.ORDER_HEADER_OID	= S.ORDER_HEADER_OID 
		 and ((T.ORDER_NO = S.ORDER_NO) or (T.ORDER_NO IS NULL and S.ORDER_NO IS NULL)) and
		((T.APO_OID = S.APO_OID) or (T.APO_OID IS NULL and S.APO_OID IS NULL)) and
		((T.EVENT_OID = S.EVENT_OID) or (T.EVENT_OID IS NULL and S.EVENT_OID IS NULL)) and
		((T.ORDER_DATE = S.ORDER_DATE) or (T.ORDER_DATE IS NULL and S.ORDER_DATE IS NULL)) and
		((T.OMS_CREATE_DATE = S.OMS_CREATE_DATE) or (T.OMS_CREATE_DATE IS NULL and S.OMS_CREATE_DATE IS NULL)) and
		((T.SHIP_NODE = S.SHIP_NODE) or (T.SHIP_NODE IS NULL and S.SHIP_NODE IS NULL)) and
		((T.SOURCE_SYSTEM_OID = S.SOURCE_SYSTEM_OID) or (T.SOURCE_SYSTEM_OID IS NULL and S.SOURCE_SYSTEM_OID IS NULL)) and
		((T.ORDER_SHIP_DATE = S.ORDER_SHIP_DATE) or (T.ORDER_SHIP_DATE IS NULL and S.ORDER_SHIP_DATE IS NULL))
        )

  
  

  



&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_ONE_OF_ORDER_WIP857001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_ONE_OF_ORDER_WIP_IDX857001
on		RAX_APP_USER.I$_ONE_OF_ORDER_WIP857001 (ORDER_HEADER_OID)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Merge Rows */

merge into	ODS_OWN.ONE_OF_ORDER_WIP T
using	RAX_APP_USER.I$_ONE_OF_ORDER_WIP857001 S
on	(
		T.ORDER_HEADER_OID=S.ORDER_HEADER_OID
	)
when matched
then update set
	T.ORDER_NO	= S.ORDER_NO,
	T.APO_OID	= S.APO_OID,
	T.EVENT_OID	= S.EVENT_OID,
	T.ORDER_DATE	= S.ORDER_DATE,
	T.OMS_CREATE_DATE	= S.OMS_CREATE_DATE,
	T.SHIP_NODE	= S.SHIP_NODE,
	T.SOURCE_SYSTEM_OID	= S.SOURCE_SYSTEM_OID,
	T.ORDER_SHIP_DATE	= S.ORDER_SHIP_DATE
	,        T.ONE_OF_ORDER_WIP_OID	= ODS_STAGE.ONE_OF_ORDER_SEQ.nextval,
	T.ODS_MODIFY_DATE	= SYSDATE
when not matched
then insert
	(
	T.ORDER_NO,
	T.APO_OID,
	T.EVENT_OID,
	T.ORDER_DATE,
	T.OMS_CREATE_DATE,
	T.SHIP_NODE,
	T.SOURCE_SYSTEM_OID,
	T.ORDER_SHIP_DATE,
	T.ORDER_HEADER_OID
	,         T.ONE_OF_ORDER_WIP_OID,
	T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.ORDER_NO,
	S.APO_OID,
	S.EVENT_OID,
	S.ORDER_DATE,
	S.OMS_CREATE_DATE,
	S.SHIP_NODE,
	S.SOURCE_SYSTEM_OID,
	S.ORDER_SHIP_DATE,
	S.ORDER_HEADER_OID
	,         ODS_STAGE.ONE_OF_ORDER_SEQ.nextval,
	SYSDATE,
	SYSDATE
	)

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Drop flow table */

drop table RAX_APP_USER.I$_ONE_OF_ORDER_WIP857001 

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 16 */




/*-----------------------------------------------*/
/* TASK No. 17 */
/* Drop flow table */

BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_ONE_OF_ORDER_WIP869001';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -942 THEN
            DBMS_OUTPUT.PUT_LINE('Table does not exist.');
        ELSE
            RAISE;
        END IF;
END; 

&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_ONE_OF_ORDER_WIP869001
(
	ONE_OF_ORDER_WIP_OID		NUMBER NULL,
	STATUS		VARCHAR2(40) NULL,
	SHIP_PROP_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	SHIPMENT_ADVICE_NUMBER		VARCHAR2(255) NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = POST_FLOW */
 


  
  
  


insert into	RAX_APP_USER.I$_ONE_OF_ORDER_WIP869001
(
	ONE_OF_ORDER_WIP_OID,
	SHIP_PROP_CREATE_DATE,
	SHIPMENT_ADVICE_NUMBER,
	IND_UPDATE
)


select 	 
	
	ONE_OF_ORDER_WIP.ONE_OF_ORDER_WIP_OID,
	OMS3_ORDER_RELEASE_STG.CREATETS,
	OMS3_ORDER_RELEASE_STG.SHIP_ADVICE_NO,

	'I' IND_UPDATE

from	ODS_OWN.ONE_OF_ORDER_WIP   ONE_OF_ORDER_WIP, ODS_STAGE.OMS3_ORDER_RELEASE_STG   OMS3_ORDER_RELEASE_STG, ODS_STAGE.OMS_ORDER_HEADER_XR   OMS_ORDER_HEADER_XR
where	(1=1)
 And (ONE_OF_ORDER_WIP.ORDER_HEADER_OID=OMS_ORDER_HEADER_XR.ORDER_HEADER_OID)
AND (OMS_ORDER_HEADER_XR.ORDER_HEADER_KEY=OMS3_ORDER_RELEASE_STG.ORDER_HEADER_KEY)
And (OMS3_ORDER_RELEASE_STG.RELEASE_NO=1)
 And (ONE_OF_ORDER_WIP.STATUS IS NULL)




  

 


&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_ONE_OF_ORDER_WIP_IDX869001
on		RAX_APP_USER.I$_ONE_OF_ORDER_WIP869001 (ONE_OF_ORDER_WIP_OID)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_ONE_OF_ORDER_WIP869001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* Flag rows for update */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_ONE_OF_ORDER_WIP869001
set	IND_UPDATE = 'U'
where	(ONE_OF_ORDER_WIP_OID)
	in	(
		select	ONE_OF_ORDER_WIP_OID
		from	ODS_OWN.ONE_OF_ORDER_WIP
		)



&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Flag useless rows */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_ONE_OF_ORDER_WIP869001 S
set	IND_UPDATE = 'N'
where	exists (
	select 	'X'
	from 	ODS_OWN.ONE_OF_ORDER_WIP 	T
	where	T.ONE_OF_ORDER_WIP_OID	= S.ONE_OF_ORDER_WIP_OID
		and	((T.SHIP_PROP_CREATE_DATE = S.SHIP_PROP_CREATE_DATE) or (T.SHIP_PROP_CREATE_DATE IS NULL and S.SHIP_PROP_CREATE_DATE IS NULL))
and	((T.SHIPMENT_ADVICE_NUMBER = S.SHIPMENT_ADVICE_NUMBER) or (T.SHIPMENT_ADVICE_NUMBER IS NULL and S.SHIPMENT_ADVICE_NUMBER IS NULL))
	)



&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* Update existing rows */

/* DETECTION_STRATEGY = POST_FLOW */
update	ODS_OWN.ONE_OF_ORDER_WIP T
set 	
	(
	T.SHIP_PROP_CREATE_DATE,
	T.SHIPMENT_ADVICE_NUMBER
	) =
		(
		select	S.SHIP_PROP_CREATE_DATE,
			S.SHIPMENT_ADVICE_NUMBER
		from	RAX_APP_USER.I$_ONE_OF_ORDER_WIP869001 S
		where	T.ONE_OF_ORDER_WIP_OID	=S.ONE_OF_ORDER_WIP_OID
	    	 )
	,  T.STATUS = 'Arrived in OMS',
	T.ODS_MODIFY_DATE = SYSDATE

where	(ONE_OF_ORDER_WIP_OID)
	in	(
		select	ONE_OF_ORDER_WIP_OID
		from	RAX_APP_USER.I$_ONE_OF_ORDER_WIP869001
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* Insert new rows */

/* DETECTION_STRATEGY = POST_FLOW */
insert into 	ODS_OWN.ONE_OF_ORDER_WIP T
	(
	ONE_OF_ORDER_WIP_OID,
	SHIP_PROP_CREATE_DATE,
	SHIPMENT_ADVICE_NUMBER
	,   STATUS,
	ODS_MODIFY_DATE
	)
select 	ONE_OF_ORDER_WIP_OID,
	SHIP_PROP_CREATE_DATE,
	SHIPMENT_ADVICE_NUMBER
	,   'Arrived in OMS',
	SYSDATE
from	RAX_APP_USER.I$_ONE_OF_ORDER_WIP869001 S



where	IND_UPDATE = 'I'



&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 27 */
/* Drop flow table */

drop table RAX_APP_USER.I$_ONE_OF_ORDER_WIP869001 

&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* sub-select inline view */

(


select 	 
	
	ONE_OF_ORDER_WIP.ONE_OF_ORDER_WIP_OID    ONE_OF_ORDER_WIP_OID,
	'Arrived in OMS'    STATUS,
	OMS3_ORDER_RELEASE_STG.CREATETS    SHIP_PROP_CREATE_DATE,
	SYSDATE    ODS_MODIFY_DATE,
	OMS3_ORDER_RELEASE_STG.SHIP_ADVICE_NO    SHIPMENT_ADVICE_NUMBER
from	ODS_OWN.ONE_OF_ORDER_WIP   ONE_OF_ORDER_WIP, ODS_STAGE.OMS3_ORDER_RELEASE_STG   OMS3_ORDER_RELEASE_STG, ODS_STAGE.OMS_ORDER_HEADER_XR   OMS_ORDER_HEADER_XR
where	(1=1)
 And (ONE_OF_ORDER_WIP.ORDER_HEADER_OID=OMS_ORDER_HEADER_XR.ORDER_HEADER_OID)
AND (OMS_ORDER_HEADER_XR.ORDER_HEADER_KEY=OMS3_ORDER_RELEASE_STG.ORDER_HEADER_KEY)
And (OMS3_ORDER_RELEASE_STG.RELEASE_NO=1)
 And (ONE_OF_ORDER_WIP.STATUS IS NULL)



)

&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* Drop table for DAG temporary table */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE TMP_ONE_DAG_SHPMNT_PROP_STG';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -942 THEN
            DBMS_OUTPUT.PUT_LINE('Table does not exist.');
        ELSE
            RAISE;
        END IF;
END;
&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* Create temp table for DAG data */

CREATE TABLE TMP_ONE_DAG_SHPMNT_PROP_STG AS
SELECT SUBSTR(DAG_SHIPMENT_PROPOSAL_STG.BATCH_ID,3,20) SHPMNT_ADV_NO,
  MIN(AUDIT_CREATE_DATE) CREATE_DATE
FROM ODS_STAGE.DAG_SHIPMENT_PROPOSAL_STG
GROUP BY SUBSTR(DAG_SHIPMENT_PROPOSAL_STG.BATCH_ID,3,20)

&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 31 */




/*-----------------------------------------------*/
/* TASK No. 32 */
/* Drop flow table */

BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_ONE_OF_ORDER_WIP886001';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -942 THEN
            DBMS_OUTPUT.PUT_LINE('Table does not exist.');
        ELSE
            RAISE;
        END IF;
END; 

&


/*-----------------------------------------------*/
/* TASK No. 33 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_ONE_OF_ORDER_WIP886001
(
	ONE_OF_ORDER_WIP_OID		NUMBER NULL,
	STATUS		VARCHAR2(40) NULL,
	DAG_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 34 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = POST_FLOW */
 


  
  
  


insert into	RAX_APP_USER.I$_ONE_OF_ORDER_WIP886001
(
	ONE_OF_ORDER_WIP_OID,
	DAG_CREATE_DATE,
	IND_UPDATE
)


select 	 
	
	ONE_OF_ORDER_WIP.ONE_OF_ORDER_WIP_OID,
	TMP_ONE_DAG_SHPMNT_PROP_STG.CREATE_DATE,

	'I' IND_UPDATE

from	ODS_OWN.ONE_OF_ORDER_WIP   ONE_OF_ORDER_WIP, ODS_STAGE.OMS3_ORDER_RELEASE_STG   OMS3_ORDER_RELEASE_STG, ODS_STAGE.OMS_ORDER_HEADER_XR   OMS_ORDER_HEADER_XR, RAX_APP_USER.TMP_ONE_DAG_SHPMNT_PROP_STG   TMP_ONE_DAG_SHPMNT_PROP_STG
where	(1=1)
 And (ONE_OF_ORDER_WIP.ORDER_HEADER_OID=OMS_ORDER_HEADER_XR.ORDER_HEADER_OID)
AND (OMS_ORDER_HEADER_XR.ORDER_HEADER_KEY=OMS3_ORDER_RELEASE_STG.ORDER_HEADER_KEY)
AND (OMS3_ORDER_RELEASE_STG.SHIP_ADVICE_NO=TMP_ONE_DAG_SHPMNT_PROP_STG.SHPMNT_ADV_NO)
And (OMS3_ORDER_RELEASE_STG.RELEASE_NO=1)
 And (ONE_OF_ORDER_WIP.STATUS='Arrived in OMS')




  

 


&


/*-----------------------------------------------*/
/* TASK No. 35 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_ONE_OF_ORDER_WIP_IDX886001
on		RAX_APP_USER.I$_ONE_OF_ORDER_WIP886001 (ONE_OF_ORDER_WIP_OID)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 36 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_ONE_OF_ORDER_WIP886001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 37 */
/* Flag rows for update */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_ONE_OF_ORDER_WIP886001
set	IND_UPDATE = 'U'
where	(ONE_OF_ORDER_WIP_OID)
	in	(
		select	ONE_OF_ORDER_WIP_OID
		from	ODS_OWN.ONE_OF_ORDER_WIP
		)



&


/*-----------------------------------------------*/
/* TASK No. 38 */
/* Flag useless rows */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_ONE_OF_ORDER_WIP886001 S
set	IND_UPDATE = 'N'
where	exists (
	select 	'X'
	from 	ODS_OWN.ONE_OF_ORDER_WIP 	T
	where	T.ONE_OF_ORDER_WIP_OID	= S.ONE_OF_ORDER_WIP_OID
		and	((T.DAG_CREATE_DATE = S.DAG_CREATE_DATE) or (T.DAG_CREATE_DATE IS NULL and S.DAG_CREATE_DATE IS NULL))
	)



&


/*-----------------------------------------------*/
/* TASK No. 39 */
/* Update existing rows */

/* DETECTION_STRATEGY = POST_FLOW */
update	ODS_OWN.ONE_OF_ORDER_WIP T
set 	
	(
	T.DAG_CREATE_DATE
	) =
		(
		select	S.DAG_CREATE_DATE
		from	RAX_APP_USER.I$_ONE_OF_ORDER_WIP886001 S
		where	T.ONE_OF_ORDER_WIP_OID	=S.ONE_OF_ORDER_WIP_OID
	    	 )
	, T.STATUS =  'Arrived in DAG',
	T.ODS_MODIFY_DATE = SYSDATE

where	(ONE_OF_ORDER_WIP_OID)
	in	(
		select	ONE_OF_ORDER_WIP_OID
		from	RAX_APP_USER.I$_ONE_OF_ORDER_WIP886001
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 40 */
/* Insert new rows */

/* DETECTION_STRATEGY = POST_FLOW */
insert into 	ODS_OWN.ONE_OF_ORDER_WIP T
	(
	ONE_OF_ORDER_WIP_OID,
	DAG_CREATE_DATE
	,  STATUS,
	ODS_MODIFY_DATE
	)
select 	ONE_OF_ORDER_WIP_OID,
	DAG_CREATE_DATE
	,   'Arrived in DAG',
	SYSDATE
from	RAX_APP_USER.I$_ONE_OF_ORDER_WIP886001 S



where	IND_UPDATE = 'I'



&


/*-----------------------------------------------*/
/* TASK No. 41 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 42 */
/* Drop flow table */

drop table RAX_APP_USER.I$_ONE_OF_ORDER_WIP886001 

&


/*-----------------------------------------------*/
/* TASK No. 43 */
/* sub-select inline view */

(


select 	 
	
	ONE_OF_ORDER_WIP.ONE_OF_ORDER_WIP_OID    ONE_OF_ORDER_WIP_OID,
	 'Arrived in DAG'    STATUS,
	TMP_ONE_DAG_SHPMNT_PROP_STG.CREATE_DATE    DAG_CREATE_DATE,
	SYSDATE    ODS_MODIFY_DATE
from	ODS_OWN.ONE_OF_ORDER_WIP   ONE_OF_ORDER_WIP, ODS_STAGE.OMS3_ORDER_RELEASE_STG   OMS3_ORDER_RELEASE_STG, ODS_STAGE.OMS_ORDER_HEADER_XR   OMS_ORDER_HEADER_XR, RAX_APP_USER.TMP_ONE_DAG_SHPMNT_PROP_STG   TMP_ONE_DAG_SHPMNT_PROP_STG
where	(1=1)
 And (ONE_OF_ORDER_WIP.ORDER_HEADER_OID=OMS_ORDER_HEADER_XR.ORDER_HEADER_OID)
AND (OMS_ORDER_HEADER_XR.ORDER_HEADER_KEY=OMS3_ORDER_RELEASE_STG.ORDER_HEADER_KEY)
AND (OMS3_ORDER_RELEASE_STG.SHIP_ADVICE_NO=TMP_ONE_DAG_SHPMNT_PROP_STG.SHPMNT_ADV_NO)
And (OMS3_ORDER_RELEASE_STG.RELEASE_NO=1)
 And (ONE_OF_ORDER_WIP.STATUS='Arrived in OMS')



)

&


/*-----------------------------------------------*/
/* TASK No. 44 */
/* Dropping temporary table */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE WOMS_ONE_OF_UPD';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -942 THEN
            DBMS_OUTPUT.PUT_LINE('Table does not exist.');
        ELSE
            RAISE;
        END IF;
END;
&


/*-----------------------------------------------*/
/* TASK No. 45 */
/* Temporary table creation for WOMS */

CREATE TABLE WOMS_ONE_OF_UPD AS
SELECT SUBSTR(dag.BATCH_ID,3,20) SHPMNT_ADV_NO,
  MIN(woms.WORK_ORDER_ALIAS_ID) wrk_alias_id,
  MIN(woms.AUDIT_CREATE_DATE) woms_create_date
FROM ods_stage.woms_work_order_stg woms,
  ods_stage.DAG_SHIPMENT_PROPOSAL_STG dag
WHERE woms.shipment_proposal_id          =dag.extn_ship_prop_id
AND woms.woms_node                       =dag.ship_node
GROUP BY SUBSTR(dag.BATCH_ID,3,20) 

&


/*-----------------------------------------------*/
/* TASK No. 46 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 46 */




/*-----------------------------------------------*/
/* TASK No. 47 */
/* Drop flow table */

BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_ONE_OF_ORDER_WIP887001';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -942 THEN
            DBMS_OUTPUT.PUT_LINE('Table does not exist.');
        ELSE
            RAISE;
        END IF;
END; 

&


/*-----------------------------------------------*/
/* TASK No. 48 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_ONE_OF_ORDER_WIP887001
(
	ONE_OF_ORDER_WIP_OID		NUMBER NULL,
	STATUS		VARCHAR2(40) NULL,
	WOMS_CREATE_DATE		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	WORK_ORDER_ALIAS_ID		VARCHAR2(20) NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 49 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = POST_FLOW */
 


  
  
  


insert into	RAX_APP_USER.I$_ONE_OF_ORDER_WIP887001
(
	ONE_OF_ORDER_WIP_OID,
	WOMS_CREATE_DATE,
	WORK_ORDER_ALIAS_ID,
	IND_UPDATE
)


select 	 
	
	ONE_OF_ORDER_WIP.ONE_OF_ORDER_WIP_OID,
	WOMS_ONE_OF_UPD.WOMS_CREATE_DATE,
	WOMS_ONE_OF_UPD.WRK_ALIAS_ID,

	'I' IND_UPDATE

from	ODS_OWN.ONE_OF_ORDER_WIP   ONE_OF_ORDER_WIP, ODS_STAGE.OMS3_ORDER_RELEASE_STG   OMS3_ORDER_RELEASE_STG, ODS_STAGE.OMS_ORDER_HEADER_XR   OMS_ORDER_HEADER_XR, RAX_APP_USER.WOMS_ONE_OF_UPD   WOMS_ONE_OF_UPD
where	(1=1)
 And (ONE_OF_ORDER_WIP.ORDER_HEADER_OID=OMS_ORDER_HEADER_XR.ORDER_HEADER_OID)
AND (OMS_ORDER_HEADER_XR.ORDER_HEADER_KEY=OMS3_ORDER_RELEASE_STG.ORDER_HEADER_KEY)
AND (OMS3_ORDER_RELEASE_STG.SHIP_ADVICE_NO=WOMS_ONE_OF_UPD.SHPMNT_ADV_NO)
And (OMS3_ORDER_RELEASE_STG.RELEASE_NO=1)
 And (ONE_OF_ORDER_WIP.STATUS= 'Arrived in DAG')




  

 


&


/*-----------------------------------------------*/
/* TASK No. 50 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_ONE_OF_ORDER_WIP_IDX887001
on		RAX_APP_USER.I$_ONE_OF_ORDER_WIP887001 (ONE_OF_ORDER_WIP_OID)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 51 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_ONE_OF_ORDER_WIP887001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 52 */
/* Flag rows for update */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_ONE_OF_ORDER_WIP887001
set	IND_UPDATE = 'U'
where	(ONE_OF_ORDER_WIP_OID)
	in	(
		select	ONE_OF_ORDER_WIP_OID
		from	ODS_OWN.ONE_OF_ORDER_WIP
		)



&


/*-----------------------------------------------*/
/* TASK No. 53 */
/* Flag useless rows */

/* DETECTION_STRATEGY = POST_FLOW */


update	RAX_APP_USER.I$_ONE_OF_ORDER_WIP887001 S
set	IND_UPDATE = 'N'
where	exists (
	select 	'X'
	from 	ODS_OWN.ONE_OF_ORDER_WIP 	T
	where	T.ONE_OF_ORDER_WIP_OID	= S.ONE_OF_ORDER_WIP_OID
		and	((T.WOMS_CREATE_DATE = S.WOMS_CREATE_DATE) or (T.WOMS_CREATE_DATE IS NULL and S.WOMS_CREATE_DATE IS NULL))
and	((T.WORK_ORDER_ALIAS_ID = S.WORK_ORDER_ALIAS_ID) or (T.WORK_ORDER_ALIAS_ID IS NULL and S.WORK_ORDER_ALIAS_ID IS NULL))
	)



&


/*-----------------------------------------------*/
/* TASK No. 54 */
/* Update existing rows */

/* DETECTION_STRATEGY = POST_FLOW */
update	ODS_OWN.ONE_OF_ORDER_WIP T
set 	
	(
	T.WOMS_CREATE_DATE,
	T.WORK_ORDER_ALIAS_ID
	) =
		(
		select	S.WOMS_CREATE_DATE,
			S.WORK_ORDER_ALIAS_ID
		from	RAX_APP_USER.I$_ONE_OF_ORDER_WIP887001 S
		where	T.ONE_OF_ORDER_WIP_OID	=S.ONE_OF_ORDER_WIP_OID
	    	 )
	,  T.STATUS = 'Arrived in WOMS',
	T.ODS_MODIFY_DATE = SYSDATE

where	(ONE_OF_ORDER_WIP_OID)
	in	(
		select	ONE_OF_ORDER_WIP_OID
		from	RAX_APP_USER.I$_ONE_OF_ORDER_WIP887001
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 55 */
/* Insert new rows */

/* DETECTION_STRATEGY = POST_FLOW */
insert into 	ODS_OWN.ONE_OF_ORDER_WIP T
	(
	ONE_OF_ORDER_WIP_OID,
	WOMS_CREATE_DATE,
	WORK_ORDER_ALIAS_ID
	,   STATUS,
	ODS_MODIFY_DATE
	)
select 	ONE_OF_ORDER_WIP_OID,
	WOMS_CREATE_DATE,
	WORK_ORDER_ALIAS_ID
	,   'Arrived in WOMS',
	SYSDATE
from	RAX_APP_USER.I$_ONE_OF_ORDER_WIP887001 S



where	IND_UPDATE = 'I'



&


/*-----------------------------------------------*/
/* TASK No. 56 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 57 */
/* Drop flow table */

drop table RAX_APP_USER.I$_ONE_OF_ORDER_WIP887001 

&


/*-----------------------------------------------*/
/* TASK No. 58 */
/* sub-select inline view */

(


select 	 
	
	ONE_OF_ORDER_WIP.ONE_OF_ORDER_WIP_OID    ONE_OF_ORDER_WIP_OID,
	'Arrived in WOMS'    STATUS,
	WOMS_ONE_OF_UPD.WOMS_CREATE_DATE    WOMS_CREATE_DATE,
	SYSDATE    ODS_MODIFY_DATE,
	WOMS_ONE_OF_UPD.WRK_ALIAS_ID    WORK_ORDER_ALIAS_ID
from	ODS_OWN.ONE_OF_ORDER_WIP   ONE_OF_ORDER_WIP, ODS_STAGE.OMS3_ORDER_RELEASE_STG   OMS3_ORDER_RELEASE_STG, ODS_STAGE.OMS_ORDER_HEADER_XR   OMS_ORDER_HEADER_XR, RAX_APP_USER.WOMS_ONE_OF_UPD   WOMS_ONE_OF_UPD
where	(1=1)
 And (ONE_OF_ORDER_WIP.ORDER_HEADER_OID=OMS_ORDER_HEADER_XR.ORDER_HEADER_OID)
AND (OMS_ORDER_HEADER_XR.ORDER_HEADER_KEY=OMS3_ORDER_RELEASE_STG.ORDER_HEADER_KEY)
AND (OMS3_ORDER_RELEASE_STG.SHIP_ADVICE_NO=WOMS_ONE_OF_UPD.SHPMNT_ADV_NO)
And (OMS3_ORDER_RELEASE_STG.RELEASE_NO=1)
 And (ONE_OF_ORDER_WIP.STATUS= 'Arrived in DAG')



)

&


/*-----------------------------------------------*/
/* TASK No. 59 */
/* Drop table TMP_ORD_HEAD_OID_CANCELLED */


BEGIN
    EXECUTE IMMEDIATE 'drop table TMP_ORD_HEAD_OID_CANCELLED';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -942 THEN
            DBMS_OUTPUT.PUT_LINE('Table does not exist.');
        ELSE
            RAISE;
        END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 60 */
/* CREATE TABLE TMP_ORD_HEAD_OID_CANCELLED */


CREATE TABLE TMP_ORD_HEAD_OID_CANCELLED (
    order_header_oid NUMBER
) 
&

INSERT INTO TMP_ORD_HEAD_OID_CANCELLED (order_header_oid)
SELECT DISTINCT order_header_oid
FROM ODS_OWN.ORDER_HEADER
WHERE ORDER_BUCKET = 'CANCELLED'
AND ODS_MODIFY_DATE >= (TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap)


/*create table TMP_ORD_HEAD_OID_CANCELLED as
select distinct order_header_oid
from ODS_OWN.ORDER_HEADER
where ORDER_BUCKET = 'CANCELLED'
AND ODS_MODIFY_DATE   >= ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap)
*/

&


/*-----------------------------------------------*/
/* TASK No. 61 */
/* Update One_Of_Order_WIP Ignore Flag */


UPDATE ODS_OWN.One_Of_Order_WIP wip
SET
  (
    WIP.IGNORE_FLAG,
    WIP.IGNORE_DATE,
    WIP.IGNORE_BY_USER,
    WIP.IGNORE_REASON
  )
  =
  (
SELECT
'Y',
sysdate,
'ODI Proc',
'Order_Header Order_Bucket = CANCELLED'
FROM  TMP_ORD_HEAD_OID_CANCELLED temp
  WHERE wip.order_header_oid=temp.order_header_oid
  )
WHERE EXISTS
  (SELECT 1
  FROM TMP_ORD_HEAD_OID_CANCELLED temp
  WHERE wip.order_header_oid=temp.order_header_oid
  )

&


/*-----------------------------------------------*/
/* TASK No. 62 */
/* Drop TMP Table */


BEGIN
    EXECUTE IMMEDIATE 'drop table tmp_ONE_OF_WOMS_SHIP';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -942 THEN
            DBMS_OUTPUT.PUT_LINE('Table does not exist.');
        ELSE
            RAISE;
        END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 63 */
/* CREATE TMP */

CREATE TABLE tmp_ONE_OF_WOMS_SHIP (
    WOMS_SHIP_DATE DATE,
    WORK_ORDER_ALIAS_ID VARCHAR2(255)
)

&

INSERT INTO tmp_ONE_OF_WOMS_SHIP (WOMS_SHIP_DATE, WORK_ORDER_ALIAS_ID)
SELECT
    MAX(hist.STATUS_CHANGE_TS) AS WOMS_SHIP_DATE,
    wo.WORK_ORDER_ALIAS_ID
FROM ODS_STAGE.WOMS_STATUS_HISTORY_STG hist
JOIN ODS_STAGE.WOMS_WORK_ORDER_STG wo
ON hist.WORK_ORDER_ID = wo.WORK_ORDER_ID
WHERE hist.ODS_MODIFY_DATE >= (TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap)
AND hist.STATUS_ID = '7'
GROUP BY wo.WORK_ORDER_ALIAS_ID



/*create table tmp_ONE_OF_WOMS_SHIP as
Select
max(hist.STATUS_CHANGE_TS) as WOMS_SHIP_DATE
,wo.WORK_ORDER_ALIAS_ID
from ODS_STAGE.WOMS_STATUS_HISTORY_STG hist
join ODS_STAGE.WOMS_WORK_ORDER_STG wo
on hist.WORK_ORDER_ID = wo.WORK_ORDER_ID
where hist.ODS_MODIFY_DATE   >= ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap)
and hist.STATUS_ID = '7'
group by wo.WORK_ORDER_ALIAS_ID
*/
&


/*-----------------------------------------------*/
/* TASK No. 64 */
/* Update One of WIP with WOMS Ship Date */


UPDATE ODS_OWN.One_Of_Order_WIP wip
SET
  (
    WIP.WOMS_SHIP_DATE,
    WIP.ODS_MODIFY_DATE
  )
  =
  (
SELECT
WOMS_SHIP_DATE
,sysdate
FROM  tmp_ONE_OF_WOMS_SHIP temp
  WHERE wip.WORK_ORDER_ALIAS_ID=temp.WORK_ORDER_ALIAS_ID
  )
WHERE EXISTS
  (SELECT 1
  FROM tmp_ONE_OF_WOMS_SHIP temp
  WHERE wip.WORK_ORDER_ALIAS_ID=temp.WORK_ORDER_ALIAS_ID)
  

&


/*-----------------------------------------------*/
/* TASK No. 65 */
/* Update LAB_CANCELLED_FLAG */

MERGE INTO ODS_OWN.ONE_OF_ORDER_WIP TGT
USING  
(  
SELECT
one.ONE_OF_ORDER_WIP_OID,
case when wo.STATUS = 'Lab Canceled'
     then 1
     else null
     end LAB_CANCELLED_FLAG 
FROM 
ODS_STAGE.WOMS_WORK_ORDER_STG wo,
ODS_OWN.ONE_OF_ORDER_WIP one,
ODS_OWN.APO APO
WHERE 1 = 1
and one.WORK_ORDER_ALIAS_ID = wo.WORK_ORDER_ALIAS_ID
and one.SHIP_NODE = wo.WOMS_NODE
and one.APO_OID = APO.APO_OID
and one.ODS_MODIFY_DATE   >= ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap)
and one.WOMS_SHIP_DATE IS NULL
and APO.SCHOOL_YEAR > (SELECT FISCAL_YEAR-3 FROM MART.TIME WHERE DATE_KEY = (SELECT TRUNC(SYSDATE) FROM DUAL))
and wo.STATUS_ID = 4
--AND one.WORK_ORDER_ALIAS_ID = 'YDG3CB8M'
)SRC
  ON (TGT.ONE_OF_ORDER_WIP_OID = SRC.ONE_OF_ORDER_WIP_OID)          
  WHEN MATCHED THEN
    UPDATE 
     SET  
     TGT.LAB_CANCELLED_FLAG = SRC.LAB_CANCELLED_FLAG

&


/*-----------------------------------------------*/
/* TASK No. 66 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
+ nvl((TIMEZONE_OFFSET/24), 0) 
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env


&


/*-----------------------------------------------*/
/* TASK No. 67 */
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
,'29_LOAD_ONE_OF_ORDER_TRACKING_PKG'
,'004'
,TO_DATE(SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
,TO_DATE (SUBSTR(:v_cdc_ld_date, 1, 19),'YYYY-MM-DD HH24:MI:SS')
,:v_cdc_overlap
,SYSDATE
,:v_env
,TIMEZONE_OFFSET
from 
ODS_OWN.ODS_CDC_LOAD_STATUS
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env


&


/*-----------------------------------------------*/
