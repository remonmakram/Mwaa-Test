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
/*-----------------------------------------------*/
/* TASK No. 5 */
/* Create work table */
/*-----------------------------------------------*/
/* TASK No. 6 */
/* Load data */
/* SOURCE CODE */
/* drop table RAX_APP_USER.C$_0FOW_YB_FRNG_CNG_STG */
/* create table RAX_APP_USER.C$_0FOW_YB_FRNG_CNG_STG
(
	C1_ID	NUMBER NULL,
	C2_OFFERING_ID	NUMBER NULL,
	C3_CONFIG_NAME	VARCHAR2(255) NULL,
	C4_CONFIG_VALUE	VARCHAR2(255) NULL,
	C5_DATE_CREATED	TIMESTAMP(6) NULL,
	C6_CREATED_BY	VARCHAR2(255) NULL,
	C7_TYPE	CHAR(50) NULL,
	C8_LAST_UPDATED	DATE NULL,
	C9_UPDATED_BY	VARCHAR2(255) NULL
)
NOLOGGING */
/* select	
	YB_OFFERING_CONFIG.ID	   C1_ID,
	YB_OFFERING_CONFIG.OFFERING_ID	   C2_OFFERING_ID,
	TRIM(YB_OFFERING_CONFIG.CONFIG_NAME)	   C3_CONFIG_NAME,
	TRIM(YB_OFFERING_CONFIG.CONFIG_VALUE)	   C4_CONFIG_VALUE,
	YB_OFFERING_CONFIG.DATE_CREATED	   C5_DATE_CREATED,
	TRIM(YB_OFFERING_CONFIG.CREATED_BY)	   C6_CREATED_BY,
	TRIM(YB_OFFERING_CONFIG.TYPE)	   C7_TYPE,
	YB_OFFERING_CONFIG.LAST_UPDATED	   C8_LAST_UPDATED,
	YB_OFFERING_CONFIG.UPDATED_BY	   C9_UPDATED_BY
from	FOW_OWN.YB_OFFERING_CONFIG   YB_OFFERING_CONFIG
where	(1=1)
And (YB_OFFERING_CONFIG.LAST_UPDATED  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap) */
/* insert into RAX_APP_USER.C$_0FOW_YB_FRNG_CNG_STG
(
	C1_ID,
	C2_OFFERING_ID,
	C3_CONFIG_NAME,
	C4_CONFIG_VALUE,
	C5_DATE_CREATED,
	C6_CREATED_BY,
	C7_TYPE,
	C8_LAST_UPDATED,
	C9_UPDATED_BY
)
values
(
	:C1_ID,
	:C2_OFFERING_ID,
	:C3_CONFIG_NAME,
	:C4_CONFIG_VALUE,
	:C5_DATE_CREATED,
	:C6_CREATED_BY,
	:C7_TYPE,
	:C8_LAST_UPDATED,
	:C9_UPDATED_BY
) */
/* TARGET CODE */
/*-----------------------------------------------*/
/* TASK No. 7 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0FOW_YB_FRNG_CNG_STG',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;

& /*-----------------------------------------------*/
/* TASK No. 9 */
/* Set vID */
/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 9 */
/*-----------------------------------------------*/
/* TASK No. 10 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_FOW_YB_FRNG_CNG_STG2344001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FOW_YB_FRNG_CNG_STG2344001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Create flow table I$ */


 /* create table RAX_APP_USER.I$_FOW_YB_FRNG_CNG_STG2344001
(
	ID	NUMBER NULL,
	OFFERING_ID	NUMBER NULL,
	CONFIG_NAME	VARCHAR2(255) NULL,
	CONFIG_VALUE	VARCHAR2(255) NULL,
	DATE_CREATED	TIMESTAMP(6) NULL,
	CREATED_BY	VARCHAR2(255) NULL,
	TYPE	CHAR(50) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	LAST_UPDATED	DATE NULL,
	UPDATED_BY	VARCHAR2(255) NULL
	,IND_UPDATE		char(1)
)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create table RAX_APP_USER.I$_FOW_YB_FRNG_CNG_STG2344001
(
	ID	NUMBER NULL,
	OFFERING_ID	NUMBER NULL,
	CONFIG_NAME	VARCHAR2(255) NULL,
	CONFIG_VALUE	VARCHAR2(255) NULL,
	DATE_CREATED	TIMESTAMP(6) NULL,
	CREATED_BY	VARCHAR2(255) NULL,
	TYPE	CHAR(50) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	LAST_UPDATED	DATE NULL,
	UPDATED_BY	VARCHAR2(255) NULL
	,IND_UPDATE		char(1)
)
NOLOGGING';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert flow into I$ table */
/* DETECTION_STRATEGY = NOT_EXISTS */



insert into	RAX_APP_USER.I$_FOW_YB_FRNG_CNG_STG2344001
(
	ID,
	OFFERING_ID,
	CONFIG_NAME,
	CONFIG_VALUE,
	DATE_CREATED,
	CREATED_BY,
	TYPE,
	LAST_UPDATED,
	UPDATED_BY,
	IND_UPDATE
)
select 
ID,
	OFFERING_ID,
	CONFIG_NAME,
	CONFIG_VALUE,
	DATE_CREATED,
	CREATED_BY,
	TYPE,
	LAST_UPDATED,
	UPDATED_BY,
	IND_UPDATE
 from (


select 	 
	
	C1_ID ID,
	C2_OFFERING_ID OFFERING_ID,
	C3_CONFIG_NAME CONFIG_NAME,
	C4_CONFIG_VALUE CONFIG_VALUE,
	C5_DATE_CREATED DATE_CREATED,
	C6_CREATED_BY CREATED_BY,
	C7_TYPE TYPE,
	C8_LAST_UPDATED LAST_UPDATED,
	C9_UPDATED_BY UPDATED_BY,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0FOW_YB_FRNG_CNG_STG
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.FOW_YB_OFFERING_CONFIG_STG T
	where	T.ID	= S.ID 
		 and ((T.OFFERING_ID = S.OFFERING_ID) or (T.OFFERING_ID IS NULL and S.OFFERING_ID IS NULL)) and
		((T.CONFIG_NAME = S.CONFIG_NAME) or (T.CONFIG_NAME IS NULL and S.CONFIG_NAME IS NULL)) and
		((T.CONFIG_VALUE = S.CONFIG_VALUE) or (T.CONFIG_VALUE IS NULL and S.CONFIG_VALUE IS NULL)) and
		((T.DATE_CREATED = S.DATE_CREATED) or (T.DATE_CREATED IS NULL and S.DATE_CREATED IS NULL)) and
		((T.CREATED_BY = S.CREATED_BY) or (T.CREATED_BY IS NULL and S.CREATED_BY IS NULL)) and
		((T.TYPE = S.TYPE) or (T.TYPE IS NULL and S.TYPE IS NULL)) and
		((T.LAST_UPDATED = S.LAST_UPDATED) or (T.LAST_UPDATED IS NULL and S.LAST_UPDATED IS NULL)) and
		((T.UPDATED_BY = S.UPDATED_BY) or (T.UPDATED_BY IS NULL and S.UPDATED_BY IS NULL))
        )

& /*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_FOW_YB_FRNG_CNG_STG2344001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& /*-----------------------------------------------*/
/* TASK No. 14 */
/* Create Index on flow table */


 /* create index	RAX_APP_USER.I$_FOW_YB_FRNG_CNG_STG_IDX2344001
on		RAX_APP_USER.I$_FOW_YB_FRNG_CNG_STG2344001 (ID)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_FOW_YB_FRNG_CNG_STG_IDX2344001
on		RAX_APP_USER.I$_FOW_YB_FRNG_CNG_STG2344001 (ID)
NOLOGGING';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 15 */
/* Merge Rows */



merge into	ODS_STAGE.FOW_YB_OFFERING_CONFIG_STG T
using	RAX_APP_USER.I$_FOW_YB_FRNG_CNG_STG2344001 S
on	(
		T.ID=S.ID
	)
when matched
then update set
	T.OFFERING_ID	= S.OFFERING_ID,
	T.CONFIG_NAME	= S.CONFIG_NAME,
	T.CONFIG_VALUE	= S.CONFIG_VALUE,
	T.DATE_CREATED	= S.DATE_CREATED,
	T.CREATED_BY	= S.CREATED_BY,
	T.TYPE	= S.TYPE,
	T.LAST_UPDATED	= S.LAST_UPDATED,
	T.UPDATED_BY	= S.UPDATED_BY
	,        T.ODS_CREATE_DATE	= SYSDATE,
	T.ODS_MODIFY_DATE	= SYSDATE
when not matched
then insert
	(
	T.ID,
	T.OFFERING_ID,
	T.CONFIG_NAME,
	T.CONFIG_VALUE,
	T.DATE_CREATED,
	T.CREATED_BY,
	T.TYPE,
	T.LAST_UPDATED,
	T.UPDATED_BY
	,         T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.ID,
	S.OFFERING_ID,
	S.CONFIG_NAME,
	S.CONFIG_VALUE,
	S.DATE_CREATED,
	S.CREATED_BY,
	S.TYPE,
	S.LAST_UPDATED,
	S.UPDATED_BY
	,         SYSDATE,
	SYSDATE
	)

& /*-----------------------------------------------*/
/* TASK No. 16 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 17 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_FOW_YB_FRNG_CNG_STG2344001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_FOW_YB_FRNG_CNG_STG2344001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0FOW_YB_FRNG_CNG_STG */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0FOW_YB_FRNG_CNG_STG';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 18 */
/* insert into ods_stage.YB_OFFERING_CONFIG_XR */



Insert into ODS_STAGE.YB_OFFERING_CONFIG_XR
( 
    Id,    
    OFFERING_ID,
    YB_OFFERING_CONFIG_OID,
    ODS_CREATE_DATE,
    ODS_MODIFY_DATE
) 
select
    Id,   
    OFFERING_ID,
    ODS_STAGE.YB_OFFERING_CONFIG_OID_SEQ.nextval,
    SYSDATE,
    SYSDATE
FROM (  
 Select  
     T.Id    ,
     T.OFFERING_ID
 From ods_stage.FOW_YB_OFFERING_CONFIG_STG T,
     ods_stage.YB_OFFERING_CONFIG_XR XR
 Where (1=1)
   And Trim(T.Id) = Trim(Xr.Id(+))    
   And Xr.YB_OFFERING_CONFIG_OID Is Null   
   And T.ODS_MODIFY_DATE>= TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
)    ODI_GET_FROM

& /*-----------------------------------------------*/
/* TASK No. 19 */
/* MERGE INTO ODS_OWN.YB_OFFERING_CONFIG */



MERGE INTO ODS_OWN.YB_OFFERING_CONFIG T
     USING (SELECT YB_OFFERING_CONFIG_XR.YB_OFFERING_CONFIG_OID
                      YB_OFFERING_CONFIG_OID, offering_xr.offering_oid,
                   FOWYB.TYPE TYPE,
                   FOWYB.CONFIG_NAME CONFIG_NAME,
                   FOWYB.CONFIG_VALUE CONFIG_VALUE,
                   FOWYB.DATE_CREATED,
                   SOURCE_SYSTEM.SOURCE_SYSTEM_OID SOURCE_SYSTEM_OID
              FROM ods_stage.FOW_YB_OFFERING_CONFIG_STG FOWYB,
                   ods_stage.YB_OFFERING_CONFIG_XR YB_OFFERING_CONFIG_XR,
                   ODS_OWN.SOURCE_SYSTEM SOURCE_SYSTEM,
                   ods_stage.fow_offering_xr offering_xr
             WHERE     (1 = 1)
                   AND (FOWYB.ID = YB_OFFERING_CONFIG_XR.ID)
                   AND (SOURCE_SYSTEM.SOURCE_SYSTEM_SHORT_NAME = 'FOW')
                   AND YB_OFFERING_CONFIG_XR.offering_id = offering_xr.id(+)
                   AND FOWYB.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap) S
        ON (T.YB_OFFERING_CONFIG_OID = S.YB_OFFERING_CONFIG_OID)
WHEN MATCHED
THEN
   UPDATE SET T.TYPE = S.TYPE,
              T.CONFIG_NAME = S.CONFIG_NAME,
              T.CONFIG_VALUE = S.CONFIG_VALUE,
              T.OFFERING_OID = S.OFFERING_OID,
              T.DATE_CREATED = S.DATE_CREATED,
              T.ODS_MODIFY_DATE = SYSDATE
WHEN NOT MATCHED
THEN
   INSERT     (T.YB_OFFERING_CONFIG_OID,
               T.TYPE,
               T.CONFIG_NAME,
               T.CONFIG_VALUE,
               T.OFFERING_OID,
               T.DATE_CREATED,
               T.SOURCE_SYSTEM_OID,
               T.ODS_CREATE_DATE,
               T.ODS_MODIFY_DATE)
       VALUES (S.YB_OFFERING_CONFIG_OID,
               S.TYPE,
               S.CONFIG_NAME,
               S.CONFIG_VALUE,
               S.OFFERING_OID,
               S.DATE_CREATED,
               S.SOURCE_SYSTEM_OID,
               SYSDATE,
               SYSDATE)

& /*-----------------------------------------------*/
/* TASK No. 20 */
/* update selection_field_choice_label */



merge into ods_own.yb_offering_config t
using(
   select xr.yb_offering_config_oid, sfc.label as selection_field_choice_label
   from ods_stage.fow_yb_offering_config_stg stg
   , ods_stage.yb_offering_config_xr xr
   , ods_own. selection_field sf
   , ods_own.selection_field_choice sfc
   where stg.config_name like '%YB%'
   and stg.id = xr.id
   and REGEXP_SUBSTR(stg.config_name, '\YB(.*)', 1)  = sf.name
   and stg.config_value = sfc.choice_id
   and sf.selection_field_oid = sfc.selection_field_oid
   and trim(stg.type) = 'ITEM'
   and stg.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
   group by xr.yb_offering_config_oid, sfc.label
) s
on (s.yb_offering_config_oid = t.yb_offering_config_oid)
when matched then update
set t.selection_field_choice_label = s.selection_field_choice_label
where (t.selection_field_choice_label is null and s.selection_field_choice_label is not null)
or t.selection_field_choice_label <> s.selection_field_choice_label

& /*-----------------------------------------------*/
/* TASK No. 21 */
/* Handle late arriving Offering record */



MERGE INTO ODS_OWN.YB_OFFERING_CONFIG t
     USING (SELECT oc.YB_OFFERING_CONFIG_OID, oxr.OFFERING_OID
              FROM ODS_OWN.YB_OFFERING_CONFIG       oc,
                   ODS_STAGE.YB_OFFERING_CONFIG_XR  xr,
                   ODS_STAGE.FOW_OFFERING_XR        oxr,
                   ODS_OWN.OFFERING o
             WHERE     oc.YB_OFFERING_CONFIG_OID = xr.YB_OFFERING_CONFIG_OID
                   AND xr.OFFERING_ID = oxr.ID
                   and oxr.OFFERING_OID = o.OFFERING_OID
                   AND oc.OFFERING_OID IS NULL) s
        ON (t.YB_OFFERING_CONFIG_OID = s.YB_OFFERING_CONFIG_OID)
WHEN MATCHED
THEN
    UPDATE SET t.offering_oid = s.offering_oid, t.ods_modify_date = SYSDATE

& /*-----------------------------------------------*/
/* TASK No. 22 */
/* MERGE INTO ODS_OWN.APO */



MERGE INTO ODS_OWN.APO T
     USING (  SELECT offering.apo_oid, 
                      tag.name as best_seller_type
                FROM ods_own.yb_offering_config yoc,
                     ODS_STAGE.TAG_TAG_STG               TAG,
                     ods_own.offering offering
               WHERE     1 = 1
                     AND TRIM (yoc.TYPE) = 'TAG'
                     AND yoc.CONFIG_NAME = 'YBPay'
                     AND yoc.CONFIG_VALUE = TAG.ID
                     AND yoc.offering_oid = offering.offering_oid 
                     AND yoc.ODS_MODIFY_DATE >=TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),'YYYY-MM-DD HH24:MI:SS')- :v_cdc_overlap          
            )S
        ON (S.APO_OID = T.APO_OID)
WHEN MATCHED
THEN
    UPDATE SET T.ODS_MODIFY_DATE = SYSDATE,T.best_seller_type =S.best_seller_type
    WHERE DECODE (S.best_seller_type, T.best_seller_type, 0, 1) = 1

& /*-----------------------------------------------*/
/* TASK No. 23 */
/* Update CDC Load Status */
/*
UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/



UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
+ nvl((TIMEZONE_OFFSET/24), 0) 
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

& /*-----------------------------------------------*/
/* TASK No. 24 */
/* Insert CDC Audit Record */
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
'LOAD_FOW_YB_OFFERING_CONFIG_PKG',
'008',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/



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
,'LOAD_FOW_YB_OFFERING_CONFIG_PKG'
,'008'
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

& /*-----------------------------------------------*/





&