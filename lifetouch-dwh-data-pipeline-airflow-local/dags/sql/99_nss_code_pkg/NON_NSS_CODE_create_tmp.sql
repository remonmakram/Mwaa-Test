
BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.NON_NSS_CODE';
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

create table RAX_APP_USER.NON_NSS_CODE
(
  BEGIN_DATE          VARCHAR2(10 BYTE),
  END_DATE            VARCHAR2(10 BYTE),
  EVENT_PAYMENT_OID NUMBER,
  SRMENABLED     VARCHAR2(50 BYTE),
  COUNTRY     VARCHAR2(50 BYTE),
  BANKCODE     VARCHAR2(50 BYTE),
  SCHOOLNAME      VARCHAR2(250 BYTE),
  YBJOBNUMBER      VARCHAR2(50 BYTE),
  AMOUNT           NUMBER(19,2),
  USERID      VARCHAR2(50 BYTE),
  DEPOSITDATE      VARCHAR2(50 BYTE),
  POSTEDDATE      VARCHAR2(50 BYTE),
  LID      VARCHAR2(50 BYTE)
)



&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* INSERT INTO */

INSERT INTO RAX_APP_USER.NON_NSS_CODE
 (
  BEGIN_DATE
 ,END_DATE
 ,EVENT_PAYMENT_OID
 ,SRMENABLED
 ,COUNTRY
 ,BANKCODE
 ,SCHOOLNAME
 ,YBJOBNUMBER
 ,AMOUNT
 ,USERID
 ,DEPOSITDATE
 ,POSTEDDATE
 ,LID
) 
select     
    to_char(case when to_date(:v_data_export_last_month_begin_date,'YYYYMMDD') is null then to_date('19000101','YYYYMMDD') else to_date(:v_data_export_last_month_begin_date,'YYYYMMDD') end,'MM/DD/YYYY') BEGIN_DATE
    ,to_char(case when to_date(:v_data_export_last_month_end_date,'YYYYMMDD') is null then to_date('21000101','YYYYMMDD') else to_date(:v_data_export_last_month_end_date,'YYYYMMDD') end,'MM/DD/YYYY') END_DATE,
    EP.EVENT_PAYMENT_OID,
    case when APO.FINANCIAL_PROCESSING_SYSTEM = 'Spectrum' then 'SRM' else 'GDT' end SRMENABLED,
    case when ACC.COUNTRY='Canada' then 'CAN' else 'USA' end  COUNTRY,
    BA.BANK_CODE                        BANKCODE,
    ACC.ACCOUNT_NAME       SCHOOLNAME,
    EP.EVENT_REF_ID           YBJOBNUMBER,
    EP.PAYMENT_AMOUNT       AMOUNT,
    EP.ENTERED_BY_USER       USERID,
    to_char(DEP.DEPOSIT_DATE,'MM/DD/YYYY')       DEPOSITDATE,
    to_char(DEP.ODS_CREATE_DATE,'MM/DD/YYYY')      POSTEDDATE,
    APO.LIFETOUCH_ID      LID
from    
     ODS_OWN.EVENT_PAYMENT   EP
    ,ODS_OWN.EVENT   E
    ,ODS_OWN.APO   APO
    ,ODS_OWN.SOURCE_SYSTEM   SS
    ,ODS_OWN.ACCOUNT   ACC
    ,ODS_OWN.DEPOSIT   DEP
    ,ODS_OWN.BANK_ACCOUNT   BA
    ,ODS_OWN.SUB_PROGRAM sp
where    
    (1=1)
    and apo.SUB_PROGRAM_OID=sp.SUB_PROGRAM_OID
    and sp.SUB_PROGRAM_NAME='Yearbook'
        And EP.EVENT_OID=E.EVENT_OID (+)
        AND E.APO_OID=APO.APO_OID (+)
        AND E.SOURCE_SYSTEM_OID=SS.SOURCE_SYSTEM_OID
        AND APO.ACCOUNT_OID=ACC.ACCOUNT_OID
        AND EP.DEPOSIT_OID=DEP.DEPOSIT_OID (+)
        AND DEP.BANK_ACCOUNT_OID=BA.BANK_ACCOUNT_OID (+)
--        And SS.SOURCE_SYSTEM_SHORT_NAME='LPIP'
--        And EP.TERRITORY_ACCOUNT_TYPE='Publishing'
        and trunc(DEP.ODS_CREATE_DATE) >= case when to_date(:v_data_export_last_month_begin_date,'YYYYMMDD') is null then to_date('19000101','YYYYMMDD') else to_date(:v_data_export_last_month_begin_date,'YYYYMMDD') end
        and trunc(DEP.ODS_CREATE_DATE) <= case when to_date(:v_data_export_last_month_end_date,'YYYYMMDD') is null then to_date('21000101','YYYYMMDD') else to_date(:v_data_export_last_month_end_date,'YYYYMMDD') end
        and to_char(ep.ODS_CREATE_DATE,'HH24:MI:SS') <> '11:11:11'
        and ba.corp_account_ind = 'N'
order by 
    to_char(DEP.DEPOSIT_DATE,'MM/DD/YYYY')
    ,BA.BANK_CODE
