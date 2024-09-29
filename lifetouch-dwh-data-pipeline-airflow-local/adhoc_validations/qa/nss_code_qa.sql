
--hardcoded START AND END TO 20190901 AND 20190930

select
    count(*)
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
        and trunc(DEP.ODS_CREATE_DATE) >= case when to_date(20190901,'YYYYMMDD') is null then to_date('19000101','YYYYMMDD') else to_date(20190901,'YYYYMMDD') end
        and trunc(DEP.ODS_CREATE_DATE) <= case when to_date(20190930,'YYYYMMDD') is null then to_date('21000101','YYYYMMDD') else to_date(20190930,'YYYYMMDD') end
        and to_char(ep.ODS_CREATE_DATE,'HH24:MI:SS') <> '11:11:11'
        and ba.corp_account_ind = 'N'

-- run the dag
--NON_NSSCodeDataFeed_20240808 FILE
--BEGIN_DATE,END_DATE,EVENT_PAYMENT_OID,SRMENABLED,COUNTRY,BANKCODE,SCHOOLNAME,YBJOBNUMBER,AMOUNT,USERID,DEPOSITDATE,POSTEDDATE,LID
--09/01/2019,09/30/2019,3564719,SRM,USA,LN02 201,Charter School for Applied Technologies1,EVTFXJMPN,500.0,wc.finance-user,09/17/2019,09/17/2019,413723
--09/01/2019,09/30/2019,3564914,SRM,USA,LN02 201,BEST SCHOOL EVER,EVTP6BGNF,200.0,wc.finance-user,09/19/2019,09/19/2019,455708
--09/01/2019,09/30/2019,3564912,SRM,USA,LN02 201,BEST SCHOOL EVER,EVTP6BGNF,1000.0,wc.finance-user,09/19/2019,09/19/2019,455708
--09/01/2019,09/30/2019,3564996,SRM,USA,LN02 201,BEST SCHOOL EVER,EVTFQJ3TN,1.15,wc.finance-user,09/23/2019,09/23/2019,455708

        select
    to_char(case when to_date(20240701,'YYYYMMDD') is null then to_date('19000101','YYYYMMDD') else to_date(20240701,'YYYYMMDD') end,'MM/DD/YYYY') BEGIN_DATE
    ,to_char(case when to_date(20240731,'YYYYMMDD') is null then to_date('21000101','YYYYMMDD') else to_date(20240731,'YYYYMMDD') end,'MM/DD/YYYY') END_DATE,
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
    ,DEP.ODS_CREATE_DATE
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
        and trunc(DEP.ODS_CREATE_DATE) >= case when to_date(20190901,'YYYYMMDD') is null then to_date('19000101','YYYYMMDD') else to_date(20190901,'YYYYMMDD') end
        and trunc(DEP.ODS_CREATE_DATE) <= case when to_date(20190930,'YYYYMMDD') is null then to_date('21000101','YYYYMMDD') else to_date(20190930,'YYYYMMDD') end
        and to_char(ep.ODS_CREATE_DATE,'HH24:MI:SS') <> '11:11:11'
        and ba.corp_account_ind = 'N'
order by
    DEP.ODS_CREATE_DATE DESC FETCH FIRST 10 ROWS ONLY
--    BEGIN_DATE|END_DATE  |EVENT_PAYMENT_OID|SRMENABLED|COUNTRY|BANKCODE|SCHOOLNAME                              |YBJOBNUMBER|AMOUNT|USERID         |DEPOSITDATE|POSTEDDATE|LID   |ODS_CREATE_DATE    |
------------+----------+-----------------+----------+-------+--------+----------------------------------------+-----------+------+---------------+-----------+----------+------+-------------------+
--07/01/2024|07/31/2024|          3564996|SRM       |USA    |LN02 201|BEST SCHOOL EVER                        |EVTFQJ3TN  |  1.15|wc.finance-user|09/23/2019 |09/23/2019|455708|2019-09-23 10:02:13|
--07/01/2024|07/31/2024|          3564912|SRM       |USA    |LN02 201|BEST SCHOOL EVER                        |EVTP6BGNF  |  1000|wc.finance-user|09/19/2019 |09/19/2019|455708|2019-09-19 17:10:57|
--07/01/2024|07/31/2024|          3564914|SRM       |USA    |LN02 201|BEST SCHOOL EVER                        |EVTP6BGNF  |   200|wc.finance-user|09/19/2019 |09/19/2019|455708|2019-09-19 17:10:57|
--07/01/2024|07/31/2024|          3564719|SRM       |USA    |LN02 201|Charter School for Applied Technologies1|EVTFXJMPN  |   500|wc.finance-user|09/17/2019 |09/17/2019|413723|2019-09-17 15:07:25|

select
--    to_char(case when to_date(:v_data_export_last_month_begin_date,'YYYYMMDD') is null then to_date('19000101','YYYYMMDD') else to_date(:v_data_export_last_month_begin_date,'YYYYMMDD') end,'MM/DD/YYYY') BEGIN_DATE
--    ,to_char(case when to_date(:v_data_export_last_month_end_date,'YYYYMMDD') is null then to_date('21000101','YYYYMMDD') else to_date(:v_data_export_last_month_end_date,'YYYYMMDD') end,'MM/DD/YYYY') END_DATE,
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
    APO.LIFETOUCH_ID      LID,DEP.ODS_CREATE_DATE
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
--         and trunc(DEP.ODS_CREATE_DATE) >= case when to_date(20190901,'YYYYMMDD') is null then to_date('19000101','YYYYMMDD') else to_date(20190901,'YYYYMMDD') end
--        and trunc(DEP.ODS_CREATE_DATE) <= case when to_date(20190930,'YYYYMMDD') is null then to_date('21000101','YYYYMMDD') else to_date(20190930,'YYYYMMDD') end
        and to_char(ep.ODS_CREATE_DATE,'HH24:MI:SS') <> '11:11:11'
        and ba.corp_account_ind <> 'N'
order by
   DEP.ODS_CREATE_DATE desc



select
    to_char(case when to_date(20240701,'YYYYMMDD') is null then to_date('19000101','YYYYMMDD') else to_date(20240701,'YYYYMMDD') end,'MM/DD/YYYY') BEGIN_DATE
    ,to_char(case when to_date(20240731,'YYYYMMDD') is null then to_date('21000101','YYYYMMDD') else to_date(20240731,'YYYYMMDD') end,'MM/DD/YYYY') END_DATE,
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
    ,DEP.ODS_CREATE_DATE
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
        and trunc(DEP.ODS_CREATE_DATE) >= case when to_date(20190901,'YYYYMMDD') is null then to_date('19000101','YYYYMMDD') else to_date(20190901,'YYYYMMDD') end
        and trunc(DEP.ODS_CREATE_DATE) <= case when to_date(20190930,'YYYYMMDD') is null then to_date('21000101','YYYYMMDD') else to_date(20190930,'YYYYMMDD') end
        and to_char(ep.ODS_CREATE_DATE,'HH24:MI:SS') <> '11:11:11'
        and ba.corp_account_ind = 'N'
order by
    DEP.ODS_CREATE_DATE DESC FETCH FIRST 10 ROWS only
--    BEGIN_DATE|END_DATE  |EVENT_PAYMENT_OID|SRMENABLED|COUNTRY|BANKCODE|SCHOOLNAME                              |YBJOBNUMBER|AMOUNT|USERID         |DEPOSITDATE|POSTEDDATE|LID   |ODS_CREATE_DATE    |
------------+----------+-----------------+----------+-------+--------+----------------------------------------+-----------+------+---------------+-----------+----------+------+-------------------+
--07/01/2024|07/31/2024|          3564996|SRM       |USA    |LN02 201|BEST SCHOOL EVER                        |EVTFQJ3TN  |  1.15|wc.finance-user|09/23/2019 |09/23/2019|455708|2019-09-23 10:02:13|
--07/01/2024|07/31/2024|          3564912|SRM       |USA    |LN02 201|BEST SCHOOL EVER                        |EVTP6BGNF  |  1000|wc.finance-user|09/19/2019 |09/19/2019|455708|2019-09-19 17:10:57|
--07/01/2024|07/31/2024|          3564914|SRM       |USA    |LN02 201|BEST SCHOOL EVER                        |EVTP6BGNF  |   200|wc.finance-user|09/19/2019 |09/19/2019|455708|2019-09-19 17:10:57|
--07/01/2024|07/31/2024|          3564719|SRM       |USA    |LN02 201|Charter School for Applied Technologies1|EVTFXJMPN  |   500|wc.finance-user|09/17/2019 |09/17/2019|413723|2019-09-17 15:07:25|
--07/01/2024|07/31/2024|          3553022|SRM       |CAN    |LN02 201|G P Studio                              |EVTDT442X  |212.31|wc.finance-user|03/18/2019 |03/18/2019|328273|2019-03-18 11:02:19|
--07/01/2024|07/31/2024|          3553025|SRM       |CAN    |LN02 201|G P Studio                              |EVTDT442X  |434.33|wc.finance-user|03/18/2019 |03/18/2019|328273|2019-03-18 11:02:19|
--07/01/2024|07/31/2024|          3553024|SRM       |CAN    |LN02 201|G P Studio                              |EVTDT442X  |323.32|wc.finance-user|03/18/2019 |03/18/2019|328273|2019-03-18 11:02:19|
--07/01/2024|07/31/2024|          3552106|SRM       |CAN    |LN02 201|G P Studio                              |EVTDT442X  |212.31|wc.finance-user|02/14/2019 |02/14/2019|328273|2019-02-14 16:05:48|
--07/01/2024|07/31/2024|          3552108|SRM       |CAN    |LN02 201|G P Studio                              |EVTDT442X  |434.33|wc.finance-user|02/14/2019 |02/14/2019|328273|2019-02-14 16:05:48|
--07/01/2024|07/31/2024|          3552107|SRM       |CAN    |LN02 201|G P Studio                              |EVTDT442X  |323.32|wc.finance-user|02/14/2019 |02/14/2019|328273|2019-02-14 16:05:48|
