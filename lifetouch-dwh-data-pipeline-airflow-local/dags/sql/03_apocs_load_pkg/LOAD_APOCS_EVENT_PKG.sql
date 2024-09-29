
BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0STG_APOCS_EVENT',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;

&& /*-----------------------------------------------*/
/* TASK No. 9 */
/* Create target table  */





BEGIN  
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.STG_APOCS_EVENT
(
	EVENT_ID	VARCHAR2(255) NULL,
	AUDIT_CREATE_DATE	TIMESTAMP(6) NULL,
	AUDIT_CREATED_BY	VARCHAR2(255) NULL,
	AUDIT_MODIFIED_BY	VARCHAR2(255) NULL,
	AUDIT_MODIFY_DATE	TIMESTAMP(6) NULL,
	BUSINESS_KEY	VARCHAR2(255) NULL,
	MAPPED_KEY	VARCHAR2(255) NULL,
	APO_ID	VARCHAR2(255) NULL
)';  
EXCEPTION  
   WHEN OTHERS THEN  
      NULL;
END;

&& /*-----------------------------------------------*/
/* TASK No. 10 */
/* Truncate target table */



truncate table RAX_APP_USER.STG_APOCS_EVENT

&& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Insert new rows */



insert into	RAX_APP_USER.STG_APOCS_EVENT 
( 
	EVENT_ID,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFIED_BY,
	AUDIT_MODIFY_DATE,
	BUSINESS_KEY,
	MAPPED_KEY,
	APO_ID 
	 
) 

select
    EVENT_ID,
	AUDIT_CREATE_DATE,
	AUDIT_CREATED_BY,
	AUDIT_MODIFIED_BY,
	AUDIT_MODIFY_DATE,
	BUSINESS_KEY,
	MAPPED_KEY,
	APO_ID   
   
FROM (	


select 	
	C5_EVENT_ID EVENT_ID,
	C7_AUDIT_CREATE_DATE AUDIT_CREATE_DATE,
	C8_AUDIT_CREATED_BY AUDIT_CREATED_BY,
	C3_AUDIT_MODIFIED_BY AUDIT_MODIFIED_BY,
	C2_AUDIT_MODIFY_DATE AUDIT_MODIFY_DATE,
	C1_BUSINESS_KEY BUSINESS_KEY,
	C4_MAPPED_KEY MAPPED_KEY,
	C6_APO_ID APO_ID 
from	RAX_APP_USER.C$_0STG_APOCS_EVENT
where		(1=1)	






)    ODI_GET_FROM

&& /*-----------------------------------------------*/
/* TASK No. 12 */
/* Commit transaction */
/* commit */
/*-----------------------------------------------*/
/* TASK No. 1000008 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0STG_APOCS_EVENT */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STG_APOCS_EVENT';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&& /*-----------------------------------------------*/
/* TASK No. 13 */
/* Set vID */
/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 13 */
/*-----------------------------------------------*/
/* TASK No. 14 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_APO_APOCS_EVENT_XR346001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_APO_APOCS_EVENT_XR346001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&& /*-----------------------------------------------*/
/* TASK No. 15 */
/* Create flow table I$ */



create table RAX_APP_USER.I$_APO_APOCS_EVENT_XR346001
(
	EVENT_REF_ID	VARCHAR2(40) NULL,
	EVENT_OID	NUMBER NULL,
	APO_ID	VARCHAR2(40) NULL,
	ODS_CREATE_DATE	DATE NULL
	,IND_UPDATE		char(1)
)
 

&& /*-----------------------------------------------*/
/* TASK No. 16 */
/* Insert flow into I$ table */
/* DETECTION_STRATEGY = NOT_EXISTS */



insert into	RAX_APP_USER.I$_APO_APOCS_EVENT_XR346001
(
	EVENT_REF_ID,
	EVENT_OID,
	APO_ID,
	IND_UPDATE
)
select 
EVENT_REF_ID,
	EVENT_OID,
	APO_ID,
	IND_UPDATE
 from (


select 	 
	
	STG_APOCS_EVENT.EVENT_ID EVENT_REF_ID,
	NVL(EVENT.EVENT_OID,-1) EVENT_OID,
	STG_APOCS_EVENT.APO_ID APO_ID,

	'I' IND_UPDATE

from	RAX_APP_USER.STG_APOCS_EVENT   STG_APOCS_EVENT, ODS_OWN.EVENT   EVENT
where	(1=1)
 And (STG_APOCS_EVENT.EVENT_ID=EVENT.EVENT_REF_ID (+))





) S
where NOT EXISTS 
	( select 1 from ODS_STAGE.APO_APOCS_EVENT_XR T
	where	T.EVENT_REF_ID	= S.EVENT_REF_ID 
		 and ((T.EVENT_OID = S.EVENT_OID) or (T.EVENT_OID IS NULL and S.EVENT_OID IS NULL)) and
		((T.APO_ID = S.APO_ID) or (T.APO_ID IS NULL and S.APO_ID IS NULL))
        )

&& /*-----------------------------------------------*/
/* TASK No. 17 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_APO_APOCS_EVENT_XR346001',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

&& /*-----------------------------------------------*/
/* TASK No. 18 */
/* Create Index on flow table */



create index	RAX_APP_USER.I$_APO_APOCS_EVENT_XR_IDX
on		RAX_APP_USER.I$_APO_APOCS_EVENT_XR346001 (EVENT_REF_ID)
 

&& /*-----------------------------------------------*/
/* TASK No. 19 */
/* Merge Rows */



merge into	ODS_STAGE.APO_APOCS_EVENT_XR T
using	RAX_APP_USER.I$_APO_APOCS_EVENT_XR346001 S
on	(
		T.EVENT_REF_ID=S.EVENT_REF_ID
	)
when matched
then update set
	T.EVENT_OID	= S.EVENT_OID,
	T.APO_ID	= S.APO_ID
	
when not matched
then insert
	(
	T.EVENT_REF_ID,
	T.EVENT_OID,
	T.APO_ID
	,   T.ODS_CREATE_DATE
	)
values
	(
	S.EVENT_REF_ID,
	S.EVENT_OID,
	S.APO_ID
	,   sysdate
	)

&& /*-----------------------------------------------*/
/* TASK No. 20 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 21 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_APO_APOCS_EVENT_XR346001 */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_APO_APOCS_EVENT_XR346001';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&& /*-----------------------------------------------*/
/* TASK No. 22 */
/* New merge into ODS_OWN.APO  */



merge into ODS_OWN.APO  T
using
(
select
	cand.FAUX_APO_ID as FAUX_APO_ID
	,cand.ACCOUNT_OID
	,cand.SCHOOL_YEAR as SCHOOL_YEAR
	,cand.SUB_PROGRAM_OID
	,ORG.ORGANIZATION_OID
	,'FAUX_'||ACC.ACCOUNT_NAME as DESCRIPTION
	,cand.LIFETOUCH_ID as LIFETOUCH_ID
	,cand.SUB_PROGRAM_NAME as SUB_PROGRAM_NAME
	,cand.TERRITORY_CODE as TERRITORY_CODE
	,cand.SELLING_METHOD_NAME as SELLING_METHOD
	,cand.SELLING_METHOD_OID as SELLING_METHOD_OID
	,cand.PROCESSING_LAB as PROCESSING_LAB
    ,'Active' as STATUS
	,null as PHOTOGAPHY_LOCIATION
	,null as VISION_JOB_NO
	,null as COMMISSION_GUARANTEED
	,null as COMMISSION_PER_CUSTOMER
	,null as COMMISSION_PERCENTAGE
	,null as GUARANTEED_DOLLAR_AMOUNT
	,null as SPECIAL_COMMISSION
	,null as VISUAL_MERCH_OID
	,null as PRICE_PROGRAM_NAME
	,cand.MARKETING_CODE as MARKETING_CODE
	,null as SORT_TYPE
	,null as FLYER_ID
	,null as ENVELOPE_TYPE
	,null as TAX_EXEMPT_CERTIFICATE_NUMBER
	,null as COMP_PROD_CODE
	,null as COMP_PROD_DELIVERY_TYPE
	,null as GROUP_PROD_CODE
	,null as GROUP_PROD_DELIVERY_TYPE
	,sysdate as ODS_CREATE_DATE
	,sysdate as ODS_MODIFY_DATE
	,SS.SOURCE_SYSTEM_OID
	,null as ROOM_QTY
	,null as FULFILLING_LAB_SYSTEM
	,null FINANCIAL_PROCESSING_SYSTEM
	,null CAPTURE_SESSION_QTY
	,null CLICK_QTY
	,null STAFF_CAPTURE_SESSION_QTY
	,null as PRICE_PROGRAM_OID
	,null ORIGINAL_BOOKING_REP  
	,null ORIGINAL_BOOKING_REP_NAME
	,null ESTIMATED_ENROLLMENT
	,null GLOSSIES_PAPER_DEADLINE
	,null STUDENT_ID_REQD
	,null TERRITORY_GROUP_ID
	,null SOLO_ACCESS
	,null STUDIO_ID
-- select *
from
	 ODS_OWN.ACCOUNT ACC
	,ODS_OWN.ORGANIZATION ORG
	,ODS_OWN.ORG_TYPE OT
	,ODS_OWN.SOURCE_SYSTEM SS
    ,(select
        max(--substr(E.JOB_NBR,1,9)||
		case 
		    when E.SELLING_METHOD_NAME='PrePay' then 'P'
		    when E.SELLING_METHOD_NAME='Spec' then 'S'
		    when E.SELLING_METHOD_NAME='Proof' then 'F'
		    when E.SELLING_METHOD_NAME='YB Direct to Parent' then 'D'
		    when E.SELLING_METHOD_NAME='YB Not Direct to Parent' then 'N'
		    else E.SELLING_METHOD_NAME
        end ||E.LIFETOUCH_ID||':'||sp.sub_program_id||':'||E.SCHOOL_YEAR) as FAUX_APO_ID
        ,acc.ACCOUNT_OID
        ,e.SCHOOL_YEAR
        ,sp.SUB_PROGRAM_OID
        ,sm.SELLING_METHOD_OID
        ,e.LIFETOUCH_ID
        ,e.SUB_PROGRAM_NAME
        ,e.SELLING_METHOD_NAME
        ,max(E.TERRITORY_CODE) as TERRITORY_CODE
        ,max(E.PLANT_NAME) as PROCESSING_LAB
        ,max(E.MARKETING_CODE) as MARKETING_CODE
    from
        mart.EVENT e
        ,ODS_OWN.ACCOUNT acc
        ,ODS_OWN.SUB_PROGRAM sp
        ,ODS_OWN.SELLING_METHOD sm
    where (1=1)
        and e.SUB_PROGRAM_NAME=sp.SUB_PROGRAM_NAME
        and e.SELLING_METHOD_NAME=sm.SELLING_METHOD
        and e.LIFETOUCH_ID=acc.LIFETOUCH_ID
        --and E.SCHOOL_YEAR >= to_char((add_months(trunc(sysdate),-12)),'YYYY') and E.SCHOOL_YEAR>= 2014 (SODS-1358)
        and E.SCHOOL_YEAR >= to_char((add_months(trunc(sysdate),-12)),'YYYY') and E.SCHOOL_YEAR>= 2019
        and E.LIFETOUCH_ID > 0
        and E.JOB_CLASSIFICATION_NAME in ('Original','Service Only','Retake')
        --AND E.BULL_FLAG = 'Y' (SODS-1358)
        and E.SOURCE_SYSTEM = 'GDT/Vision'
    group by
        acc.ACCOUNT_OID
        ,e.SCHOOL_YEAR
        ,sp.SUB_PROGRAM_OID
        ,sm.SELLING_METHOD_OID
        ,e.LIFETOUCH_ID
        ,e.SUB_PROGRAM_NAME
        ,e.SELLING_METHOD_NAME
        ) cand
where (1=1)
	and ACC.LIFETOUCH_ID=cand.LIFETOUCH_ID
	and ORG.ORG_CODE =cand.TERRITORY_CODE
	and ORG.ORG_TYPE_OID=OT.ORG_TYPE_OID and OT.ORG_TYPE_NAME='Territory'
	and SS.SOURCE_SYSTEM_SHORT_NAME='ODS'
    and not exists (select 1 from ODS_OWN.apo z where (1=1)
                    and cand.ACCOUNT_OID=z.ACCOUNT_OID
                    and cand.SCHOOL_YEAR=z.SCHOOL_YEAR
                    and cand.SUB_PROGRAM_OID=z.SUB_PROGRAM_OID
                    and cand.SELLING_METHOD_OID=z.SELLING_METHOD_OID
                    )
) S
on (T.APO_ID=S.FAUX_APO_ID)
when not matched then insert
( APO_OID
, ACCOUNT_OID
, APO_ID
, CAPTURE_SESSION_QTY
, CLICK_QTY
, COMMISSION_GUARANTEED
, COMMISSION_PERCENTAGE
, COMMISSION_PER_CUSTOMER
, COMP_PROD_CODE
, COMP_PROD_DELIVERY_TYPE
, DESCRIPTION
, ENVELOPE_TYPE
, FINANCIAL_PROCESSING_SYSTEM
, FLYER_ID
, FULFILLING_LAB_SYSTEM
, GROUP_PROD_CODE
, GROUP_PROD_DELIVERY_TYPE
, GUARANTEED_DOLLAR_AMOUNT
, LIFETOUCH_ID
, MARKETING_CODE
, ODS_CREATE_DATE
, ODS_MODIFY_DATE
, ORGANIZATION_OID
, PHOTOGAPHY_LOCIATION
, PRICE_PROGRAM_NAME
, PRICE_PROGRAM_OID
, PROCESSING_LAB
, ROOM_QTY
, SCHOOL_YEAR
, SELLING_METHOD
, SELLING_METHOD_OID
, SORT_TYPE
, SOURCE_SYSTEM_OID
, SPECIAL_COMMISSION
, STAFF_CAPTURE_SESSION_QTY
, SUB_PROGRAM_OID
, TAX_EXEMPT_CERTIFICATE_NUMBER
, TERRITORY_CODE
, VISION_JOB_NO
, VISUAL_MERCH_OID
, ORIGINAL_BOOKING_REP  
, ORIGINAL_BOOKING_REP_NAME
, ESTIMATED_ENROLLMENT
, GLOSSIES_PAPER_DEADLINE
, STUDENT_ID_REQD
, TERRITORY_GROUP_ID
, SOLO_ACCESS
, STUDIO_ID
, STATUS
) 
VALUES (
ODS_STAGE.APO_OID_SEQ.nextval
, S.ACCOUNT_OID
, S.FAUX_APO_ID
, S.CAPTURE_SESSION_QTY
, S.CLICK_QTY
, S.COMMISSION_GUARANTEED
, S.COMMISSION_PERCENTAGE
, S.COMMISSION_PER_CUSTOMER
, S.COMP_PROD_CODE
, S.COMP_PROD_DELIVERY_TYPE
, S.DESCRIPTION
, S.ENVELOPE_TYPE
, S.FINANCIAL_PROCESSING_SYSTEM
, S.FLYER_ID
, S.FULFILLING_LAB_SYSTEM
, S.GROUP_PROD_CODE
, S.GROUP_PROD_DELIVERY_TYPE
, S.GUARANTEED_DOLLAR_AMOUNT
, S.LIFETOUCH_ID
, S.MARKETING_CODE
, S.ODS_CREATE_DATE
, S.ODS_MODIFY_DATE
, S.ORGANIZATION_OID
, S.PHOTOGAPHY_LOCIATION
, S.PRICE_PROGRAM_NAME
, S.PRICE_PROGRAM_OID
, S.PROCESSING_LAB
, S.ROOM_QTY
, S.SCHOOL_YEAR
, S.SELLING_METHOD
, S.SELLING_METHOD_OID
, S.SORT_TYPE
, S.SOURCE_SYSTEM_OID
, S.SPECIAL_COMMISSION
, S.STAFF_CAPTURE_SESSION_QTY
, S.SUB_PROGRAM_OID
, S.TAX_EXEMPT_CERTIFICATE_NUMBER
, S.TERRITORY_CODE
, S.VISION_JOB_NO
, S.VISUAL_MERCH_OID
, S.ORIGINAL_BOOKING_REP  
, S.ORIGINAL_BOOKING_REP_NAME
, S.ESTIMATED_ENROLLMENT
, S.GLOSSIES_PAPER_DEADLINE
, S.STUDENT_ID_REQD
, S.TERRITORY_GROUP_ID
, S.SOLO_ACCESS
, S.STUDIO_ID
, S.STATUS
)

&& /*-----------------------------------------------*/
/* TASK No. 23 */
/* merge into ODS_STAGE.APO_XR */



merge into ODS_STAGE.APO_XR d
using (
select * from (
    select
        APO.APO_OID
        ,APO.APO_ID
        ,case when xr.SYSTEM_OF_RECORD in ('APOCS','FOW','OMS2','LPIP') then xr.SYSTEM_OF_RECORD else 'ODS' end as SYSTEM_OF_RECORD
        ,APO.APO_ID as ODS_SK_FAUX_APO_ID
        ,APO.SCHOOL_YEAR
        ,APO.PRICE_PROGRAM_NAME
        ,APO.LIFETOUCH_ID
        ,SP.SUB_PROGRAM_NAME
        ,APO.TERRITORY_CODE
        ,VM.VISUAL_MERCH_ID
        ,APO.SELLING_METHOD
        ,xr.APOCS_SK_APO_ID
        ,xr.FOW_SK_ID
        ,xr.OMS2_SK_BUSINESS_KEY
        ,xr.LPIP_SK_APO_ID
        ,sysdate as ODS_CREATE_DATE
        ,sysdate as ODS_MODIFY_DATE
        --,xr.*,apo.*
    from
        ODS_OWN.apo apo
        ,ODS_OWN.SOURCE_SYSTEM SS
        ,ODS_OWN.SUB_PROGRAM sp
        ,ODS_OWN.VISUAL_MERCH vm
        ,ODS_STAGE.APO_XR xr
    where (1=1)
        and APO.SOURCE_SYSTEM_OID=SS.SOURCE_SYSTEM_OID
        and APO.SUB_PROGRAM_OID=SP.SUB_PROGRAM_OID(+)
        and APO.VISUAL_MERCH_OID=VM.VISUAL_MERCH_OID(+)
        and SS.SOURCE_SYSTEM_SHORT_NAME='ODS'
        and APO.APO_ID=XR.APO_ID(+)
    ) s
where not exists  
	( select 1 from ODS_STAGE.APO_XR T
	where	T.APO_ID	= S.APO_ID 
		 and
---		((T.APO_OID = S.APO_OID) or (T.APO_OID IS NULL and S.APO_OID IS NULL))  and
		((T.ODS_SK_FAUX_APO_ID = S.ODS_SK_FAUX_APO_ID) or (T.ODS_SK_FAUX_APO_ID IS NULL and S.ODS_SK_FAUX_APO_ID IS NULL)) and
		((T.SCHOOL_YEAR = S.SCHOOL_YEAR) or (T.SCHOOL_YEAR IS NULL and S.SCHOOL_YEAR IS NULL)) and
		((T.SYSTEM_OF_RECORD = S.SYSTEM_OF_RECORD) or (T.SYSTEM_OF_RECORD IS NULL and S.SYSTEM_OF_RECORD IS NULL)) and
		((T.PRICE_PROGRAM_NAME = S.PRICE_PROGRAM_NAME) or (T.PRICE_PROGRAM_NAME IS NULL and S.PRICE_PROGRAM_NAME IS NULL)) and
		((T.LIFETOUCH_ID = S.LIFETOUCH_ID) or (T.LIFETOUCH_ID IS NULL and S.LIFETOUCH_ID IS NULL)) and
		((T.SUB_PROGRAM_NAME = S.SUB_PROGRAM_NAME) or (T.SUB_PROGRAM_NAME IS NULL and S.SUB_PROGRAM_NAME IS NULL)) and
		((T.TERRITORY_CODE = S.TERRITORY_CODE) or (T.TERRITORY_CODE IS NULL and S.TERRITORY_CODE IS NULL)) and
		((T.VISUAL_MERCH_ID = S.VISUAL_MERCH_ID) or (T.VISUAL_MERCH_ID IS NULL and S.VISUAL_MERCH_ID IS NULL)) and
		((T.SELLING_METHOD = S.SELLING_METHOD) or (T.SELLING_METHOD IS NULL and S.SELLING_METHOD IS NULL))
        )
) s 
ON
  (s.APO_ID=d.APO_ID)
WHEN MATCHED
THEN
UPDATE SET
  d.APO_OID = s.APO_OID,
  d.ODS_SK_FAUX_APO_ID = s.ODS_SK_FAUX_APO_ID,
  d.SCHOOL_YEAR = s.SCHOOL_YEAR,
  d.PRICE_PROGRAM_NAME = s.PRICE_PROGRAM_NAME,
  d.LIFETOUCH_ID = s.LIFETOUCH_ID,
  d.SUB_PROGRAM_NAME = s.SUB_PROGRAM_NAME,
  d.TERRITORY_CODE = s.TERRITORY_CODE,
  d.VISUAL_MERCH_ID = s.VISUAL_MERCH_ID,
  d.SELLING_METHOD = s.SELLING_METHOD,
  d.SYSTEM_OF_RECORD = s.SYSTEM_OF_RECORD,
  d.ODS_MODIFY_DATE = s.ODS_MODIFY_DATE
WHEN NOT MATCHED
THEN
INSERT (
  APO_OID, APO_ID, APOCS_SK_APO_ID,SYSTEM_OF_RECORD,
  FOW_SK_ID, OMS2_SK_BUSINESS_KEY, LPIP_SK_APO_ID,ODS_SK_FAUX_APO_ID,
  SCHOOL_YEAR, PRICE_PROGRAM_NAME, LIFETOUCH_ID,
  SUB_PROGRAM_NAME, TERRITORY_CODE, VISUAL_MERCH_ID,
  SELLING_METHOD, ODS_CREATE_DATE, ODS_MODIFY_DATE)
VALUES (
  ODS_STAGE.APO_OID_SEQ.nextval, s.APO_ID, s.APOCS_SK_APO_ID,s.SYSTEM_OF_RECORD,
  s.FOW_SK_ID, s.OMS2_SK_BUSINESS_KEY, s.LPIP_SK_APO_ID, s.ODS_SK_FAUX_APO_ID,
  s.SCHOOL_YEAR, s.PRICE_PROGRAM_NAME, s.LIFETOUCH_ID,
  s.SUB_PROGRAM_NAME, s.TERRITORY_CODE, s.VISUAL_MERCH_ID,
  s.SELLING_METHOD, s.ODS_CREATE_DATE, s.ODS_MODIFY_DATE)

&& /*-----------------------------------------------*/
/* TASK No. 24 */
/* Fix late arriving event_oids */



merge into ods_stage.APO_APOCS_EVENT_XR T
using 
(
select 
    X.EVENT_REF_ID
    ,E.EVENT_OID
from 
    ods_stage.APO_APOCS_EVENT_XR x
    ,ODS_OWN.EVENT e
where (1=1)
    and X.EVENT_REF_ID = E.EVENT_REF_ID
    and nvl(X.EVENT_OID,-1) <> E.EVENT_OID
) S
on (T.EVENT_REF_ID = s.EVENT_REF_ID)
when matched then update
set T.EVENT_OID = S.EVENT_OID

&& /*-----------------------------------------------*/
/* TASK No. 25 */
/* merge into ods_own.event from APOCS */
/*merge into ods_own.event T
using 
(select 
    E.EVENT_OID
    ,apo.apo_oid
from 
    ods_own.event e
    ,ODS_STAGE.APO_APOCS_EVENT_XR ax
    ,ods_own.apo apo
where (1=1) 
    and E.EVENT_OID > 0
    and E.EVENT_OID = aX.EVENT_OID
    and AX.APO_ID = APO.APO_ID
    and nvl(e.apo_oid,-1) <> apo.apo_oid
) S
on (T.EVENT_OID = s.EVENT_OID)
when matched then update
set T.APO_OID = S.APO_OID
     ,T.ODS_MODIFY_DATE = sysdate*/



merge into ods_own.event T
using 
(select 
    E.EVENT_OID
    ,apo.apo_oid
    ,apo.LIFETOUCH_ID
from 
    ods_own.event e
    ,ODS_STAGE.APO_APOCS_EVENT_XR ax
    ,ods_own.apo apo
where (1=1) 
    and E.EVENT_OID > 0
    and E.EVENT_OID = aX.EVENT_OID
    and AX.APO_ID = APO.APO_ID
    and nvl(e.apo_oid,-1) <> apo.apo_oid
) S
on (T.EVENT_OID = s.EVENT_OID)
when matched then update
set T.APO_OID = S.APO_OID,
    T.LIFETOUCH_ID = S.LIFETOUCH_ID
     ,T.ODS_MODIFY_DATE = sysdate

&& /*-----------------------------------------------*/
/* TASK No. 26 */
/* merge into ods_own.event from lid/year/sub_program NON APOCS */
/* APOCS always wins */
/* fow always wins */



merge into ods_own.event T
using 
(
select  
    E.EVENT_OID
    ,apo.apo_oid
--    ,E.APO_OID, apo.*,e.*
from 
    ods_own.event e
    ,(select
          min(apo.apo_oid) apo_oid
          ,ACC.LIFETOUCH_ID
          ,APO.SCHOOL_YEAR
          ,SP.SUB_PROGRAM_NAME
      from
        ods_own.apo apo
        ,ODS_OWN.ACCOUNT ACC
        ,ODS_OWN.SUB_PROGRAM sp
        ,ODS_OWN.SOURCE_SYSTEM ss
      where (1=1)
        and APO.ACCOUNT_OID=ACC.ACCOUNT_OID
        and APO.SUB_PROGRAM_OID=SP.SUB_PROGRAM_OID
        and apo.SOURCE_SYSTEM_OID=ss.SOURCE_SYSTEM_OID
        -- SODS-330 Only set to 'faux' APO
        and ss.SOURCE_SYSTEM_SHORT_NAME IN ('ODS','MAN')
      group by 
          ACC.LIFETOUCH_ID
          ,APO.SCHOOL_YEAR
          ,SP.SUB_PROGRAM_NAME
       ) APO,
       MART.MARKETING M
       ,ODS_STAGE.EVENT_XR xr
where (1=1)
    and e.EVENT_OID=xr.EVENT_OID
    and xr.SYSTEM_OF_RECORD = 'DW'
    and not exists (select 1 from  ODS_STAGE.APO_APOCS_EVENT_XR ax where AX.EVENT_OID=E.EVENT_OID and AX.APO_ID is not null) 
    and not exists (select 1 from  ODS_STAGE.FOW_EVENT_STG fx where fX.EVENT_REF_ID = E.EVENT_REF_ID and FX.APO_ID is not null) 
    and E.DW_MARKETING_CODE= M.MARKETING_CODE  -- Changed
    and E.EVENT_OID > 0
    and E.SCHOOL_YEAR >= to_char((add_months(trunc(sysdate),-12)),'YYYY')
    and E.SCHOOL_YEAR=APO.SCHOOL_YEAR
    and E.LIFETOUCH_ID=APO.LIFETOUCH_ID
    and APO.SUB_PROGRAM_NAME = M.SUB_PROGRAM_NAME
    and nvl(E.apo_oid,-1) <> APO.apo_oid
    and E.school_year >= 2017         --- Added
) S
on (T.EVENT_OID = S.EVENT_OID)
when matched then update
set T.APO_OID = S.APO_OID
     ,T.ODS_MODIFY_DATE = sysdate

&& /*-----------------------------------------------*/
/* TASK No. 27 */
/* drop driver table */


 /* DROP TABLE RAX_APP_USER.TMP_FAPO_D */ 


BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.TMP_FAPO_D';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&& /*-----------------------------------------------*/
/* TASK No. 28 */
/* create driver table */



CREATE TABLE RAX_APP_USER.TMP_FAPO_D (
APO_OID number,
STATUS varchar2(255)
)

&& /*-----------------------------------------------*/
/* TASK No. 29 */
/* insert driver table */



insert into RAX_APP_USER.TMP_FAPO_D
( apo_oid, status )
select 
    s.apo_oid, case when s.total_count = s.total_inactive then 'Inactive' else 'Active' end
from
    (select event.apo_oid as apo_oid, count(event.apo_oid) as total_count, sum(case when me.active_ind = 'I' then 1 else 0 end) as total_inactive, max(event.ods_modify_date) as modify_date
    from mart.event me, ods_own.event event, ods_stage.apo_xr xr
    where event.event_ref_id = me.job_nbr and event.school_year = me.school_year and event.school_year > 2014 and event.apo_oid = xr.apo_oid and ods_sk_faux_apo_id is not null and xr.apocs_sk_apo_id is null       and xr.fow_sk_id is null and xr.oms2_sk_business_key is null and xr.lpip_sk_apo_id is null   
Group By Event.Apo_Oid) s 
where s.modify_date > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap

&& /*-----------------------------------------------*/
/* TASK No. 30 */
/* merge */
/*
MERGE INTO ODS_OWN.APO APO
USING
(
 SELECT APO_OID, STATUS FROM RAX_APP_USER.TMP_FAPO_D
) driver
ON
( 
 APO.APO_OID= driver.APO_OID
)
WHEN MATCHED THEN UPDATE
SET APO.STATUS=driver.STATUS ,
ODS_MODIFY_DATE=SYSDATE
*/



MERGE INTO ODS_OWN.APO APO
USING
(
 SELECT 
    d.APO_OID, 
    d.STATUS  
    ,apo.status cur_status
 FROM 
    RAX_APP_USER.TMP_FAPO_D D
    ,ODS_OWN.APO apo
 WHERE (1=1)
    and d.apo_oid = apo.apo_oid
    and nvl(d.STATUS,'-1') <> nvl(apo.status,'-1')
) driver
ON
( 
 APO.APO_OID= driver.APO_OID
)
WHEN MATCHED THEN UPDATE
SET APO.STATUS=driver.STATUS ,
ODS_MODIFY_DATE=SYSDATE

&& /*-----------------------------------------------*/
/* TASK No. 31 */
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
/* TASK No. 32 */
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
'LOAD_APOCS_EVENT_PKG',
'025',
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
,'LOAD_APOCS_EVENT_PKG'
,'025'
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