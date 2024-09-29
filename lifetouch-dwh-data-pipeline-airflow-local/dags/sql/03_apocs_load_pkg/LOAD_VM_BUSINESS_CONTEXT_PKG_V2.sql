

BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0STG_VM_BUSINESS_CONTEXT',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;

&& /*-----------------------------------------------*/
/* TASK No. 6 */
/* Create target table  */





BEGIN  
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.STG_VM_BUSINESS_CONTEXT
(
	CREATETS	DATE NULL,
	CREATEUSERID	VARCHAR2(40) NULL,
	MODIFYPROGID	VARCHAR2(40) NULL,
	VISUAL_MERCH_KEY	CHAR(24) NULL,
	CREATEPROGID	VARCHAR2(40) NULL,
	VM_BUSINESS_CONTEXT_KEY	CHAR(24) NULL,
	LOCKID	NUMBER(5) NULL,
	VM_BUSINESS_CONTEXT_NAME	VARCHAR2(40) NULL,
	ENTRY_MODE	VARCHAR2(40) NULL,
	MODIFYTS	DATE NULL,
	MODIFYUSERID	VARCHAR2(40) NULL
)';  
EXCEPTION  
   WHEN OTHERS THEN  
      NULL;
END;

&& /*-----------------------------------------------*/
/* TASK No. 7 */
/* Truncate target table */



truncate table RAX_APP_USER.STG_VM_BUSINESS_CONTEXT

&& /*-----------------------------------------------*/
/* TASK No. 8 */
/* Insert new rows */



insert into	RAX_APP_USER.STG_VM_BUSINESS_CONTEXT 
( 
	CREATETS,
	CREATEUSERID,
	MODIFYPROGID,
	VISUAL_MERCH_KEY,
	CREATEPROGID,
	VM_BUSINESS_CONTEXT_KEY,
	LOCKID,
	VM_BUSINESS_CONTEXT_NAME,
	ENTRY_MODE,
	MODIFYTS,
	MODIFYUSERID 
	 
) 

select
    CREATETS,
	CREATEUSERID,
	MODIFYPROGID,
	VISUAL_MERCH_KEY,
	CREATEPROGID,
	VM_BUSINESS_CONTEXT_KEY,
	LOCKID,
	VM_BUSINESS_CONTEXT_NAME,
	ENTRY_MODE,
	MODIFYTS,
	MODIFYUSERID   
   
FROM (	


select 	
	C1_CREATETS CREATETS,
	C2_CREATEUSERID CREATEUSERID,
	C3_MODIFYPROGID MODIFYPROGID,
	C4_VISUAL_MERCH_KEY VISUAL_MERCH_KEY,
	C5_CREATEPROGID CREATEPROGID,
	C6_VM_BUSINESS_CONTEXT_KEY VM_BUSINESS_CONTEXT_KEY,
	C7_LOCKID LOCKID,
	C8_VM_BUSINESS_CONTEXT_NAME VM_BUSINESS_CONTEXT_NAME,
	C9_ENTRY_MODE ENTRY_MODE,
	C10_MODIFYTS MODIFYTS,
	C11_MODIFYUSERID MODIFYUSERID 
from	RAX_APP_USER.C$_0STG_VM_BUSINESS_CONTEXT
where		(1=1)	






)    ODI_GET_FROM

&& /*-----------------------------------------------*/
/* TASK No. 9 */
/* Commit transaction */
/* commit */
/*-----------------------------------------------*/
/* TASK No. 1000005 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0STG_VM_BUSINESS_CONTEXT */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STG_VM_BUSINESS_CONTEXT';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&& /*-----------------------------------------------*/
/* TASK No. 10 */
/* Insert new rows */



insert into	ODS_STAGE.OMS_VM_BUSINESS_CONTEXT_XR 
( 
	VM_BUSINESS_CONTEXT_KEY 
	,VM_BUSINESS_CONTEXT_OID 
) 

select
    VM_BUSINESS_CONTEXT_KEY   
  ,ODS_STAGE.VM_BUSINESS_CONTEXT_OID_SEQ.nextval 
FROM (	


select 	DISTINCT
	TRIM(BC.VM_BUSINESS_CONTEXT_KEY) VM_BUSINESS_CONTEXT_KEY 
from	RAX_APP_USER.STG_VM_BUSINESS_CONTEXT   BC, ODS_STAGE.OMS_VM_BUSINESS_CONTEXT_XR   OMS_VM_BUSINESS_CONTEXT_XR
where		(1=1)	
 And (TRIM(BC.VM_BUSINESS_CONTEXT_KEY)=OMS_VM_BUSINESS_CONTEXT_XR.VM_BUSINESS_CONTEXT_KEY (+)
AND OMS_VM_BUSINESS_CONTEXT_XR.VM_BUSINESS_CONTEXT_KEY IS NULL)





)    ODI_GET_FROM

&& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Commit transaction */
/* commit */
/*-----------------------------------------------*/
/* TASK No. 12 */
/* Set vID */
/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 12 */
/*-----------------------------------------------*/
/* TASK No. 13 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_VM_BUSINESS_CONTEXT54001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_VM_BUSINESS_CONTEXT54001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&& /*-----------------------------------------------*/
/* TASK No. 14 */
/* Create flow table I$ */


BEGIN  
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.I$_VM_BUSINESS_CONTEXT54001
(
	VM_BUSINESS_CONTEXT_OID	NUMBER NULL,
	VM_BUSINESS_CONTEXT_NAME	VARCHAR2(40) NULL,
	VISUAL_MERCH_OID	NUMBER NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	SOURCE_SYSTEM_OID	NUMBER NULL
	,IND_UPDATE		char(1)
)';  
EXCEPTION  
   WHEN OTHERS THEN  
      NULL;
END;
 
&& /*-----------------------------------------------*/
/* TASK No. 15 */
/* Insert flow into I$ table */
/* DETECTION_STRATEGY = NOT_EXISTS */



insert into	RAX_APP_USER.I$_VM_BUSINESS_CONTEXT54001
(
	VM_BUSINESS_CONTEXT_OID,
	VM_BUSINESS_CONTEXT_NAME,
	VISUAL_MERCH_OID,
	SOURCE_SYSTEM_OID,
	IND_UPDATE
)
select 
VM_BUSINESS_CONTEXT_OID,
	VM_BUSINESS_CONTEXT_NAME,
	VISUAL_MERCH_OID,
	SOURCE_SYSTEM_OID,
	IND_UPDATE
 from (


select 	 
	
	OMS_VM_BUSINESS_CONTEXT_XR.VM_BUSINESS_CONTEXT_OID VM_BUSINESS_CONTEXT_OID,
	BC.VM_BUSINESS_CONTEXT_NAME VM_BUSINESS_CONTEXT_NAME,
	NVL(OMS_VISUAL_MERCH_XR.VISUAL_MERCH_OID, -1) VISUAL_MERCH_OID,
	SOURCE_SYSTEM.SOURCE_SYSTEM_OID SOURCE_SYSTEM_OID,

	'I' IND_UPDATE

from	RAX_APP_USER.STG_VM_BUSINESS_CONTEXT   BC, ODS_STAGE.OMS_VISUAL_MERCH_XR   OMS_VISUAL_MERCH_XR, ODS_STAGE.OMS_VM_BUSINESS_CONTEXT_XR   OMS_VM_BUSINESS_CONTEXT_XR, ODS_OWN.SOURCE_SYSTEM   SOURCE_SYSTEM
where	(1=1)
 And (TRIM(BC.VISUAL_MERCH_KEY)=OMS_VISUAL_MERCH_XR.VISUAL_MERCH_KEY (+))
AND (TRIM(BC.VM_BUSINESS_CONTEXT_KEY)=OMS_VM_BUSINESS_CONTEXT_XR.VM_BUSINESS_CONTEXT_KEY (+))
And (SOURCE_SYSTEM.SOURCE_SYSTEM_SHORT_NAME='OMS')




) S
where NOT EXISTS 
	( select 1 from ODS_OWN.VM_BUSINESS_CONTEXT T
	where	T.VM_BUSINESS_CONTEXT_OID	= S.VM_BUSINESS_CONTEXT_OID 
		 and ((T.VM_BUSINESS_CONTEXT_NAME = S.VM_BUSINESS_CONTEXT_NAME) or (T.VM_BUSINESS_CONTEXT_NAME IS NULL and S.VM_BUSINESS_CONTEXT_NAME IS NULL)) and
		((T.VISUAL_MERCH_OID = S.VISUAL_MERCH_OID) or (T.VISUAL_MERCH_OID IS NULL and S.VISUAL_MERCH_OID IS NULL)) and
		((T.SOURCE_SYSTEM_OID = S.SOURCE_SYSTEM_OID) or (T.SOURCE_SYSTEM_OID IS NULL and S.SOURCE_SYSTEM_OID IS NULL))
        )

&& /*-----------------------------------------------*/
/* TASK No. 16 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_VM_BUSINESS_CONTEXT54001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

&& /*-----------------------------------------------*/
/* TASK No. 17 */
/* Create Index on flow table */


BEGIN  
   EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_VM_BUSINESS_CONTEXT_IDX54001
on		RAX_APP_USER.I$_VM_BUSINESS_CONTEXT54001 (VM_BUSINESS_CONTEXT_OID)';  
EXCEPTION  
   WHEN OTHERS THEN  
      NULL;
END;
 



&& /*-----------------------------------------------*/
/* TASK No. 18 */
/* Merge Rows */



merge into	ODS_OWN.VM_BUSINESS_CONTEXT T
using	RAX_APP_USER.I$_VM_BUSINESS_CONTEXT54001 S
on	(
		T.VM_BUSINESS_CONTEXT_OID=S.VM_BUSINESS_CONTEXT_OID
	)
when matched
then update set
	T.VM_BUSINESS_CONTEXT_NAME	= S.VM_BUSINESS_CONTEXT_NAME,
	T.VISUAL_MERCH_OID	= S.VISUAL_MERCH_OID,
	T.SOURCE_SYSTEM_OID	= S.SOURCE_SYSTEM_OID
	,   T.ODS_MODIFY_DATE	= SYSDATE
when not matched
then insert
	(
	T.VM_BUSINESS_CONTEXT_OID,
	T.VM_BUSINESS_CONTEXT_NAME,
	T.VISUAL_MERCH_OID,
	T.SOURCE_SYSTEM_OID
	,    T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.VM_BUSINESS_CONTEXT_OID,
	S.VM_BUSINESS_CONTEXT_NAME,
	S.VISUAL_MERCH_OID,
	S.SOURCE_SYSTEM_OID
	,    SYSDATE,
	SYSDATE
	)

&& /*-----------------------------------------------*/
/* TASK No. 19 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 20 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_VM_BUSINESS_CONTEXT54001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_VM_BUSINESS_CONTEXT54001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&& /*-----------------------------------------------*/
/* TASK No. 21 */
/* Command 0 */



DELETE FROM ods_own.vm_business_context vpc
      WHERE NOT EXISTS (
               SELECT xr.vm_business_context_oid
                 FROM rax_app_user.stg_vm_business_context stg,
                      ods_stage.oms_vm_business_context_xr xr
                WHERE TRIM(stg.vm_business_context_key) = xr.vm_business_context_key
                  AND xr.vm_business_context_oid = vpc.vm_business_context_oid)

&& /*-----------------------------------------------*/





&&