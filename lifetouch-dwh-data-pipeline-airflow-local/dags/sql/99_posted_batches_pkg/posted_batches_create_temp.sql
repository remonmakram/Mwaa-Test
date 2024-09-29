
BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.POSTED_BATCHES';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;



&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* create table */

create table RAX_APP_USER.POSTED_BATCHES
(
  BEGIN_DATE          VARCHAR2(10 BYTE),
  END_DATE            VARCHAR2(10 BYTE),
  JOB_NUMBER  VARCHAR2(50 BYTE),
  TERRITORY_ACCOUNT_TYPE  VARCHAR2(50 BYTE),
  AMT          NUMBER(19,2),
  DEPOSIT_DATE          VARCHAR2(10 BYTE),
  BANK_ACCOUNT_CODE   VARCHAR2(50 BYTE),
  SOURCE_SYSTEM VARCHAR2(50 BYTE),
  VENDOR   VARCHAR2(50 BYTE),
  ENTRY_TYPE   VARCHAR2(50 BYTE),
  ERROR_MESSAGE   VARCHAR2(250 BYTE),
  POSTED_DATE          VARCHAR2(10 BYTE)
)



&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* insert CSS CSP */

INSERT INTO RAX_APP_USER.POSTED_BATCHES
 (
  BEGIN_DATE
  ,END_DATE
  ,JOB_NUMBER
  ,TERRITORY_ACCOUNT_TYPE
  ,AMT
  ,DEPOSIT_DATE
  ,BANK_ACCOUNT_CODE
  ,SOURCE_SYSTEM
  ,VENDOR
  ,ENTRY_TYPE
  ,ERROR_MESSAGE
  ,POSTED_DATE
)
select
    to_char(case when to_date(:v_data_export_last_month_begin_date,'YYYYMMDD') is null then to_date('19000101','YYYYMMDD') else to_date(:v_data_export_last_month_begin_date,'YYYYMMDD') end,'MM/DD/YYYY') BEGIN_DATE
    ,to_char(case when to_date(:v_data_export_last_month_end_date,'YYYYMMDD') is null then to_date('21000101','YYYYMMDD') else to_date(:v_data_export_last_month_end_date,'YYYYMMDD') end,'MM/DD/YYYY') END_DATE,
    TA.JOB_NUM JOB_NUMBER
    ,TA.TERRITORY_ACCOUNT_TYPE
    ,TAE.AMT
    ,to_char(be.DEPOSIT_DATE, 'mm-dd-yyyy') DEPOSIT_DATE
    ,ba.BANK_CODE BANK_ACCOUNT_CODE
    ,be.SOURCE_SYSTEM
    ,be.VENDOR
    ,be.ENTRY_TYPE
    ,TAE.POSTING_ERROR_MESSAGE ERROR_MESSAGE
    ,to_char(TAE.POSTED_DATE, 'mm-dd-yyyy') POSTED_DATE
from
    ODS_STAGE.WC_TERRITORY_ACCOUNT_STG TA
    ,ODS_STAGE.WC_TERRITORY_ACCOUNT_ENTRY_STG TAE
    ,ODS_STAGE.WC_BANK_ENTRY_STG be
    ,ODS_OWN.BANK_ACCOUNT ba
    ,ODS_STAGE.WC_BANK_ACCOUNT_XR ba_xr
where (1=1)
    and trunc(TAE.POSTED_DATE) >= case when to_date(:v_data_export_last_month_begin_date,'YYYYMMDD') is null then to_date('19000101','YYYYMMDD') else to_date(:v_data_export_last_month_begin_date,'YYYYMMDD') end
    and trunc(TAE.POSTED_DATE) <= case when to_date(:v_data_export_last_month_end_date,'YYYYMMDD') is null then to_date('21000101','YYYYMMDD') else to_date(:v_data_export_last_month_end_date,'YYYYMMDD') end
    and be.SOURCE_SYSTEM in ('CSP','CSS')
    and TAE.TERRITORY_ACCOUNT_ID=TA.TERRITORY_ACCOUNT_ID
    and TAE.BANK_ENTRY_ID=be.BANK_ENTRY_ID
    and ba.BANK_ACCOUNT_OID=ba_xr.BANK_ACCOUNT_OID
    and ba_xr.BANK_ACCOUNT_KEY=be.BANK_ACCOUNT_ID
order by
    be.SOURCE_SYSTEM
    ,TA.JOB_NUM
    ,be.DEPOSIT_DATE
    ,TAE.AMT
