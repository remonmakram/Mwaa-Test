
BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0APOCS_RECORD_CHANGE_AUDIT',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;

&& /*-----------------------------------------------*/
/* TASK No. 9 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_APOCS_RECORD_CHANGE_AUDIT */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_APOCS_RECORD_CHANGE_AUDIT';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&& /*-----------------------------------------------*/
/* TASK No. 10 */
/* Create flow table I$ */




BEGIN  
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.I$_APOCS_RECORD_CHANGE_AUDIT
(
	TABLE_NAME		VARCHAR2(30) NULL,
	KEY_VALUE		VARCHAR2(255) NULL,
	EVENT_TYPE		VARCHAR2(10) NULL,
	EVENT_DETAIL		VARCHAR2(2000) NULL,
	DATE_CREATED		DATE NULL,
	ODS_MODIFY_DATE		DATE NULL,
	IND_UPDATE		CHAR(1)
)';  
EXCEPTION  
   WHEN OTHERS THEN  
      NULL;
END;

 

&& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Insert flow into I$ table */
/* DETECTION_STRATEGY = NOT_EXISTS */



insert into	RAX_APP_USER.I$_APOCS_RECORD_CHANGE_AUDIT
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

from	RAX_APP_USER.C$_0APOCS_RECORD_CHANGE_AUDIT
where	(1=1)






) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.APOCS_RECORD_CHANGE_AUDIT T
	where	T.TABLE_NAME	= S.TABLE_NAME
	and	T.KEY_VALUE	= S.KEY_VALUE 
		 and ((T.EVENT_TYPE = S.EVENT_TYPE) or (T.EVENT_TYPE IS NULL and S.EVENT_TYPE IS NULL)) and
		((T.EVENT_DETAIL = S.EVENT_DETAIL) or (T.EVENT_DETAIL IS NULL and S.EVENT_DETAIL IS NULL)) and
		((T.DATE_CREATED = S.DATE_CREATED) or (T.DATE_CREATED IS NULL and S.DATE_CREATED IS NULL))
        )

&& /*-----------------------------------------------*/
/* TASK No. 12 */
/* Create Index on flow table */



create index	RAX_APP_USER.I$_APOCS_RECORD_CHANGE_AUDIT_I
on		RAX_APP_USER.I$_APOCS_RECORD_CHANGE_AUDIT (TABLE_NAME, KEY_VALUE)
 

&& /*-----------------------------------------------*/
/* TASK No. 13 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_APOCS_RECORD_CHANGE_AUDIT',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

&& /*-----------------------------------------------*/
/* TASK No. 14 */
/* create check table */





BEGIN  
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.SNP_CHECK_TAB
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
)';  
EXCEPTION  
   WHEN OTHERS THEN  
      NULL;
END;

&& /*-----------------------------------------------*/
/* TASK No. 15 */
/* delete previous check sum */



delete from	RAX_APP_USER.SNP_CHECK_TAB
where	SCHEMA_NAME	= 'ODS_STAGE'
and	ORIGIN 		= '(2452001)ODS_Project.LOAD_APOCS_RECORD_CHANGE_AUDIT_INT'
and	ERR_TYPE 		= 'F'

&& /*-----------------------------------------------*/
/* TASK No. 16 */
/* create error table */





BEGIN  
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.E$_APOCS_RECORD_CHANGE_AUDIT
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
	ODS_MODIFY_DATE	DATE NULL,
	ODI_ORIGIN		VARCHAR2(100 CHAR) NULL,
	ODI_CONS_NAME	VARCHAR2(35 CHAR) NULL,
	ODI_CONS_TYPE		VARCHAR2(2 CHAR) NULL,
	ODI_PK			VARCHAR2(32 CHAR) PRIMARY KEY,
	ODI_SESS_NO		VARCHAR2(19 CHAR)
)';  
EXCEPTION  
   WHEN OTHERS THEN  
      NULL;
END;

&& /*-----------------------------------------------*/
/* TASK No. 17 */
/* delete previous errors */



delete from 	RAX_APP_USER.E$_APOCS_RECORD_CHANGE_AUDIT
where	(ODI_ERR_TYPE = 'S'	and 'F' = 'S')
or	(ODI_ERR_TYPE = 'F'	and ODI_ORIGIN = '(2452001)ODS_Project.LOAD_APOCS_RECORD_CHANGE_AUDIT_INT')

&& /*-----------------------------------------------*/
/* TASK No. 18 */
/* Create index on PK */
/* FLOW CONTROL CREATE THE iNDEX ON THE I$TABLE */





BEGIN  
   EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.I$_APOCS_RECORD_CHANGE_AUDIT_I
on	RAX_APP_USER.I$_APOCS_RECORD_CHANGE_AUDIT (TABLE_NAME,
		KEY_VALUE)';  
EXCEPTION  
   WHEN OTHERS THEN  
      NULL;
END;

&& /*-----------------------------------------------*/
/* TASK No. 19 */
/* insert PK errors */



insert into RAX_APP_USER.E$_APOCS_RECORD_CHANGE_AUDIT
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
	ODS_MODIFY_DATE
)
select	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15064: The primary key APOCS_RECORD_CHANGE_AUDIT_UK is not unique.',
	'(2452001)ODS_Project.LOAD_APOCS_RECORD_CHANGE_AUDIT_INT',
	sysdate,
	'APOCS_RECORD_CHANGE_AUDIT_UK',
	'PK',	
	APOCS_RECORD_CHANGE_AUDIT.TABLE_NAME,
	APOCS_RECORD_CHANGE_AUDIT.KEY_VALUE,
	APOCS_RECORD_CHANGE_AUDIT.EVENT_TYPE,
	APOCS_RECORD_CHANGE_AUDIT.EVENT_DETAIL,
	APOCS_RECORD_CHANGE_AUDIT.DATE_CREATED,
	APOCS_RECORD_CHANGE_AUDIT.ODS_MODIFY_DATE
from	RAX_APP_USER.I$_APOCS_RECORD_CHANGE_AUDIT   APOCS_RECORD_CHANGE_AUDIT
where	exists  (
		select	SUB.TABLE_NAME,
			SUB.KEY_VALUE
		from 	RAX_APP_USER.I$_APOCS_RECORD_CHANGE_AUDIT SUB
		where 	SUB.TABLE_NAME=APOCS_RECORD_CHANGE_AUDIT.TABLE_NAME
			and SUB.KEY_VALUE=APOCS_RECORD_CHANGE_AUDIT.KEY_VALUE
		group by 	SUB.TABLE_NAME,
			SUB.KEY_VALUE
		having 	count(1) > 1
		)

&& /*-----------------------------------------------*/
/* TASK No. 20 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_APOCS_RECORD_CHANGE_AUDIT
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
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column TABLE_NAME cannot be null.',
	sysdate,
	'(2452001)ODS_Project.LOAD_APOCS_RECORD_CHANGE_AUDIT_INT',
	'TABLE_NAME',
	'NN',	
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_APOCS_RECORD_CHANGE_AUDIT
where	TABLE_NAME is null

&& /*-----------------------------------------------*/
/* TASK No. 21 */
/* insert Not Null errors */



insert into RAX_APP_USER.E$_APOCS_RECORD_CHANGE_AUDIT
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
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	ODS_MODIFY_DATE
)
select
	SYS_GUID(),
	:v_sess_no, 
	rowid,
	'F', 
	'ODI-15066: The column KEY_VALUE cannot be null.',
	sysdate,
	'(2452001)ODS_Project.LOAD_APOCS_RECORD_CHANGE_AUDIT_INT',
	'KEY_VALUE',
	'NN',	
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED,
	ODS_MODIFY_DATE
from	RAX_APP_USER.I$_APOCS_RECORD_CHANGE_AUDIT
where	KEY_VALUE is null

&& /*-----------------------------------------------*/
/* TASK No. 22 */
/* create index on error table */
/* FLOW CONTROL CREATE INDEX ON THE E$TABLE */



BEGIN  
   EXECUTE IMMEDIATE 'create index 	RAX_APP_USER.E$_APOCS_RECORD_CHANGE_AUDIT_I
on	RAX_APP_USER.E$_APOCS_RECORD_CHANGE_AUDIT (ODI_ROW_ID)';  
EXCEPTION  
   WHEN OTHERS THEN  
      NULL;
END;
&& /*-----------------------------------------------*/
/* TASK No. 23 */
/* delete errors from controlled table */



delete from	RAX_APP_USER.I$_APOCS_RECORD_CHANGE_AUDIT  T
where	exists 	(
		select	1
		from	RAX_APP_USER.E$_APOCS_RECORD_CHANGE_AUDIT E
		where ODI_SESS_NO = :v_sess_no
		and T.rowid = E.ODI_ROW_ID
		)

&& /*-----------------------------------------------*/
/* TASK No. 24 */
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
	'APOCS_RECORD_CHANGE_AUDIT',
	'ODS_STAGE.APOCS_RECORD_CHANGE_AUDIT',
	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE,
	count(1) 
from	RAX_APP_USER.E$_APOCS_RECORD_CHANGE_AUDIT E
where	E.ODI_ERR_TYPE	= 'F'
and	E.ODI_ORIGIN 	= '(2452001)ODS_Project.LOAD_APOCS_RECORD_CHANGE_AUDIT_INT'
group by	E.ODI_ERR_TYPE,
	E.ODI_ERR_MESS,
	E.ODI_CHECK_DATE,
	E.ODI_ORIGIN,
	E.ODI_CONS_NAME,
	E.ODI_CONS_TYPE

&& /*-----------------------------------------------*/
/* TASK No. 25 */
/* Flag rows for update */
/* DETECTION_STRATEGY = NOT_EXISTS */



update	RAX_APP_USER.I$_APOCS_RECORD_CHANGE_AUDIT
set	IND_UPDATE = 'U'
where	(TABLE_NAME, KEY_VALUE)
	in	(
		select	TABLE_NAME,
			KEY_VALUE
		from	ODS_STAGE.APOCS_RECORD_CHANGE_AUDIT
		)

&& /*-----------------------------------------------*/
/* TASK No. 26 */
/* Flag useless rows */
/* DETECTION_STRATEGY = NOT_EXISTS */
/* Command skipped due to chosen DETECTION_STRATEGY */
/*-----------------------------------------------*/
/* TASK No. 27 */
/* Update existing rows */
/* DETECTION_STRATEGY = NOT_EXISTS */



update	ODS_STAGE.APOCS_RECORD_CHANGE_AUDIT T
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
		from	RAX_APP_USER.I$_APOCS_RECORD_CHANGE_AUDIT S
		where	T.TABLE_NAME	=S.TABLE_NAME
		and	T.KEY_VALUE	=S.KEY_VALUE
	    	 )
	,   T.ODS_MODIFY_DATE = SYSDATE

where	(TABLE_NAME, KEY_VALUE)
	in	(
		select	TABLE_NAME,
			KEY_VALUE
		from	RAX_APP_USER.I$_APOCS_RECORD_CHANGE_AUDIT
		where	IND_UPDATE = 'U'
		)

&& /*-----------------------------------------------*/
/* TASK No. 28 */
/* Insert new rows */
/* DETECTION_STRATEGY = NOT_EXISTS */



insert into 	ODS_STAGE.APOCS_RECORD_CHANGE_AUDIT T
	(
	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED
	,     ODS_MODIFY_DATE
	)
select 	TABLE_NAME,
	KEY_VALUE,
	EVENT_TYPE,
	EVENT_DETAIL,
	DATE_CREATED
	,     SYSDATE
from	RAX_APP_USER.I$_APOCS_RECORD_CHANGE_AUDIT S



where	IND_UPDATE = 'I'

&& /*-----------------------------------------------*/
/* TASK No. 29 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 30 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_APOCS_RECORD_CHANGE_AUDIT */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_APOCS_RECORD_CHANGE_AUDIT';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&& /*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0APOCS_RECORD_CHANGE_AUDIT purge */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0APOCS_RECORD_CHANGE_AUDIT purge';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&& /*-----------------------------------------------*/
/* TASK No. 31 */
/* Update Group_Type when OLS_Default_Attribute deleted */



INSERT INTO ODS_STAGE.TRACK_OLS_DELETES
    (SELECT apo.apo_oid,
            SYSDATE              AS ods_create_date
       FROM ods_own.apo                          apo,
            ods_own.event                        e,
            ods_own.sub_program                  sp,
            ods_own.ols_default                  ols,
            ods_own.ols_default_attribute        ola,
            ods_own.sku_external_reference       sr,
            ods_own.stock_keeping_unit           sku,
            ods_own.item                         i,
            ods_stage.apocs_record_change_audit  rca,
            ODS_STAGE.APOCS_OLS_DEFATT_XR        xr
      WHERE     apo.apo_oid = e.apo_oid
            AND apo.sub_program_oid = sp.sub_program_oid
            AND ols.apo_oid = apo.apo_oid
            AND ols.ols_default_oid = ola.ols_default_oid
            AND ola.VALUE = sr.external_id
            AND sr.stock_keeping_unit_oid = sku.stock_keeping_unit_oid
            AND sku.sku_code = ols.sku_id
            AND TO_CHAR (sku.sku_code) = i.item_id
            AND ola.OLS_DEFAULT_ATTRIBUTE_OID = xr.OLS_DEFAULT_ATTRIBUTE_OID
            AND xr.OLS_DEFAULT_ATTRIBUTE_ID = rca.key_value
            AND ola.name = 'productTemplate'
            AND i.sub_class = 'CLASSPIC'
            AND apo.fulfilling_lab_system = 'Prism'
            AND sr.external_type IS NOT NULL
            AND apo.school_year >= 2023
            AND rca.table_name = 'OLS_DEFAULT_ATTRIBUTE'
            AND rca.event_type = 'DELETE'
            AND rca.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap)

&& /*-----------------------------------------------*/
/* TASK No. 32 */
/* Update Group_Delivery when OLS_Default_Attribute deleted */



INSERT INTO ODS_STAGE.TRACK_OLS_DELETES
    (SELECT apo.apo_oid,
            SYSDATE         AS ods_create_date
       FROM ods_own.apo                          apo,
            ods_own.sub_program                  sp,
            ods_own.ols_default                  olsd,
            ods_own.ols_default_attribute        olsda,
            ods_stage.apocs_record_change_audit  rca,
            ODS_STAGE.APOCS_OLS_DEFATT_XR        xr
      WHERE     apo.sub_program_oid = sp.sub_program_oid
            AND apo.apo_oid = olsd.apo_oid
            AND olsd.ols_default_oid = olsda.ols_default_oid
            AND olsda.OLS_DEFAULT_ATTRIBUTE_OID =
                xr.OLS_DEFAULT_ATTRIBUTE_OID
            AND xr.OLS_DEFAULT_ATTRIBUTE_ID = rca.key_value
            AND olsda.name = 'deliveryMethod'
            AND apo.fulfilling_lab_system = 'Prism'
            AND olsda.VALUE IS NOT NULL
            AND apo.school_year >= 2023
            AND rca.table_name = 'OLS_DEFAULT_ATTRIBUTE'
            AND rca.event_type = 'DELETE'
            AND rca.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap)

&& /*-----------------------------------------------*/
/* TASK No. 33 */
/* Update Group_Type when OLS_Default deleted */



INSERT INTO ODS_STAGE.TRACK_OLS_DELETES
    (SELECT apo.apo_oid,
            SYSDATE              AS ods_create_date
       FROM ods_own.apo                          apo,
            ods_own.event                        e,
            ods_own.sub_program                  sp,
            ods_own.ols_default                  ols,
            ods_own.ols_default_attribute        ola,
            ods_own.sku_external_reference       sr,
            ods_own.stock_keeping_unit           sku,
            ods_own.item                         i,
            ods_stage.apocs_record_change_audit  rca,
            ODS_STAGE.APOCS_OLS_DEFAULT_XR       xr
      WHERE     apo.apo_oid = e.apo_oid
            AND apo.sub_program_oid = sp.sub_program_oid
            AND ols.apo_oid = apo.apo_oid
            AND ols.ols_default_oid = ola.ols_default_oid
            AND ola.VALUE = sr.external_id
            AND sr.stock_keeping_unit_oid = sku.stock_keeping_unit_oid
            AND sku.sku_code = ols.sku_id
            AND TO_CHAR (sku.sku_code) = i.item_id
            AND ols.OLS_DEFAULT_OID = xr.OLS_DEFAULT_OID
            AND xr.OLS_DEFAULT_ID = rca.key_value
            AND ola.name = 'productTemplate'
            AND i.sub_class = 'CLASSPIC'
            AND apo.fulfilling_lab_system = 'Prism'
            AND sr.external_type IS NOT NULL
            AND apo.school_year >= 2023
            AND rca.table_name = 'OLS_DEFAULT'
            AND rca.event_type = 'DELETE'
            AND rca.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap)

&& /*-----------------------------------------------*/
/* TASK No. 34 */
/* Update Group_Delivery when OLS_Default deleted */



INSERT INTO ODS_STAGE.TRACK_OLS_DELETES
    (SELECT apo.apo_oid,
            SYSDATE         AS ods_create_date
       FROM ods_own.apo                          apo,
            ods_own.sub_program                  sp,
            ods_own.ols_default                  olsd,
            ods_own.ols_default_attribute        olsda,
            ods_stage.apocs_record_change_audit  rca,
            ODS_STAGE.APOCS_OLS_DEFAULT_XR       xr
      WHERE     apo.sub_program_oid = sp.sub_program_oid
            AND apo.apo_oid = olsd.apo_oid
            AND olsd.ols_default_oid = olsda.ols_default_oid
            AND olsda.OLS_DEFAULT_OID = xr.OLS_DEFAULT_OID
            AND xr.OLS_DEFAULT_ID = rca.key_value
            AND olsda.name = 'deliveryMethod'
            AND apo.fulfilling_lab_system = 'Prism'
            AND olsda.VALUE IS NOT NULL
            AND apo.school_year >= 2023
            AND rca.table_name = 'OLS_DEFAULT'
            AND rca.event_type = 'DELETE'
            AND rca.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap)

&& /*-----------------------------------------------*/
/* TASK No. 35 */
/* OLS_DEFAULT_ATTRIBUTE deletes */



delete from ods_own.ols_default_attribute t
where exists
(
select 1
from ods_stage.apocs_record_change_audit s
, ods_stage.apocs_ols_defatt_xr odaxr
where s.table_name = 'OLS_DEFAULT_ATTRIBUTE'
and s.event_type = 'DELETE'
and to_number(s.key_value) = odaxr.ols_default_attribute_id
and odaxr.ols_default_attribute_oid = t.ols_default_attribute_oid
and s.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap
)

&& /*-----------------------------------------------*/
/* TASK No. 36 */
/* OLS_DEFAULT deletes */



delete from ods_own.ols_default t
where exists
(
select 1
from ods_stage.apocs_record_change_audit s
, ods_stage.apocs_ols_default_xr odxr
where s.table_name = 'OLS_DEFAULT'
and s.event_type = 'DELETE'
and to_number(s.key_value) = odxr.ols_default_id
and odxr.ols_default_oid = t.ols_default_oid
and s.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap
)

&& /*-----------------------------------------------*/
/* TASK No. 37 */
/* Create OLS delete log table */




BEGIN  
   EXECUTE IMMEDIATE 'CREATE TABLE rax_app_user.deleted_apo_ols
(
    apo_oid            NUMBER,
    column_name        varchar2 (30),
    ods_create_date    DATE
)';  
EXCEPTION  
   WHEN OTHERS THEN  
      NULL;
END;

&& /*-----------------------------------------------*/
/* TASK No. 38 */
/* Drop deleted Classpic temp table  */


 /* DROP TABLE rax_app_user.del_ols */ 


BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE rax_app_user.del_ols';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&& /*-----------------------------------------------*/
/* TASK No. 39 */
/* Create and load temp table */



CREATE TABLE rax_app_user.del_ols
AS
    SELECT DISTINCT a.apo_oid del_apo_oid, dr.apo_oid dr
      FROM ods_own.apo                     a,
           ods_own.ols_default             ols,
           ods_own.ols_default_attribute   ola,
           ods_own.sku_external_reference  sr,
           ods_own.stock_keeping_unit      sku,
           ods_own.item                    i,
           ods_stage.track_ols_deletes     dr
     WHERE     a.apo_oid = ols.apo_oid
           AND ols.ols_default_oid = ola.ols_default_oid
           AND ola.VALUE = sr.external_id
           AND sr.stock_keeping_unit_oid = sku.stock_keeping_unit_oid
           AND sku.sku_code = ols.sku_id
           AND TO_CHAR (sku.sku_code) = i.item_id
           AND ola.name ='productTemplate'
           AND i.sub_class ='CLASSPIC'
           AND a.fulfilling_lab_system = 'Prism'
           AND sr.external_type IS NOT NULL
           AND a.school_year >= 2023
           AND a.apo_oid = dr.apo_oid

&& /*-----------------------------------------------*/
/* TASK No. 40 */
/* Process Classpic deletes */



BEGIN


UPDATE ods_own.apo
   SET group_type = NULL, ods_modify_date = SYSDATE
 WHERE     school_year >= 2023
       AND group_type IS NOT NULL
       AND EXISTS
               (SELECT 1
                  FROM rax_app_user.del_ols, ods_stage.TRACK_OLS_DELETES dr
                 WHERE     del_ols.del_apo_oid(+) = dr.apo_oid
                       AND del_apo_oid IS NULL
                       AND dr.apo_oid = apo.apo_oid);


INSERT INTO rax_app_user.deleted_apo_ols
    (SELECT DISTINCT dr.apo_oid, 'GROUP_TYPE', SYSDATE
       FROM rax_app_user.del_ols, ods_stage.TRACK_OLS_DELETES dr
      WHERE del_ols.del_apo_oid(+) = dr.apo_oid AND del_apo_oid IS NULL);

END;

&& /*-----------------------------------------------*/
/* TASK No. 41 */
/* Drop deleted Classpic temp table */


 /* drop table rax_app_user.del_ols */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table rax_app_user.del_ols';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&& /*-----------------------------------------------*/
/* TASK No. 42 */
/* Create and load temp table */



CREATE TABLE rax_app_user.del_ols
AS
    SELECT DISTINCT apo.apo_oid as del_apo_oid
      FROM ods_own.apo                    apo,
           ods_own.ols_default            olsd,
           ods_own.ols_default_attribute  olsda,
           ods_stage.track_ols_deletes    dr
     WHERE     apo.apo_oid = olsd.apo_oid
           AND olsd.ols_default_oid = olsda.ols_default_oid
           AND apo.apo_oid = dr.apo_oid
           AND olsda.name = 'deliveryMethod'
           AND apo.fulfilling_lab_system = 'Prism'
           AND olsda.VALUE IS NOT NULL
           AND apo.school_year >= 2023

&& /*-----------------------------------------------*/
/* TASK No. 43 */
/* Process Group Delivery deletes */



BEGIN

         
UPDATE ods_own.apo
   SET group_delivery = NULL, ods_modify_date = SYSDATE
 WHERE     school_year >= 2023
       AND group_delivery IS NOT NULL
       AND EXISTS
               (SELECT 1
                  FROM rax_app_user.del_ols, ods_stage.TRACK_OLS_DELETES dr
                 WHERE     del_ols.del_apo_oid(+) = dr.apo_oid
                       AND del_apo_oid IS NULL
                       AND dr.apo_oid = apo.apo_oid);

                       
INSERT INTO rax_app_user.deleted_apo_ols
    (SELECT DISTINCT dr.apo_oid, 'GROUP_DELIVERY', SYSDATE
       FROM rax_app_user.del_ols, ods_stage.TRACK_OLS_DELETES dr
      WHERE del_ols.del_apo_oid(+) = dr.apo_oid AND del_apo_oid IS NULL);

END;

&& /*-----------------------------------------------*/
/* TASK No. 44 */
/* Delete processed Classpic deleted records */



delete from ods_stage.TRACK_OLS_DELETES

&& /*-----------------------------------------------*/
/* TASK No. 45 */
/* Delete from ODS_STAGE.apocs_ll_theme_assoc_stg */



delete from ods_stage.apocs_ll_theme_assoc_stg t
where exists
(
select 1
from ods_stage.apocs_record_change_audit d                      
where 
d.table_name = 'LOOK_LAYOUT_THEME_ASSOC'
and d.key_value = t.look_layout_theme_assoc_id
and d.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap
)

&& /*-----------------------------------------------*/
/* TASK No. 46 */
/* delete from ods_own.look_layout_theme_assoc */



delete from ods_own.look_layout_theme_assoc t
where exists
(
select 1
from ods_stage.apocs_record_change_audit d   
, ods_stage.apocs_ll_theme_assoc_xr xr                   
where 
d.table_name = 'LOOK_LAYOUT_THEME_ASSOC'
and d.key_value = xr.look_layout_theme_assoc_id
and xr.look_layout_theme_assoc_oid = t.look_layout_theme_assoc_oid
and d.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap
)

&& /*-----------------------------------------------*/
/* TASK No. 47 */
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

&& /*-----------------------------------------------*/
/* TASK No. 48 */
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
'PROCESS_APOCS_DELETES_PKG',
'013',
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
,'PROCESS_APOCS_DELETES_PKG'
,'013'
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

&& /*-----------------------------------------------*/





&&