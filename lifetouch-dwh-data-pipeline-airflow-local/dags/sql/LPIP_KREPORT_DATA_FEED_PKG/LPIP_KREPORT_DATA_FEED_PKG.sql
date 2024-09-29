/* TASK No. 1 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 2 */




/*-----------------------------------------------*/
/* TASK No. 3 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 3 */




/*-----------------------------------------------*/
/* TASK No. 4 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 4 */




/*-----------------------------------------------*/
/* TASK No. 5 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 5 */




/*-----------------------------------------------*/
/* TASK No. 6 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 6 */




/*-----------------------------------------------*/
/* TASK No. 7 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 7 */




/*-----------------------------------------------*/
/* TASK No. 8 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 8 */




/*-----------------------------------------------*/
/* TASK No. 9 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 9 */




/*-----------------------------------------------*/
/* TASK No. 10 */
/* INSERT INTO ODS_APP_USER.KREPORT_DATA_FEED */

INSERT INTO RAX_APP_USER.KREPORT_DATA_FEED (
KREPORT_DATA_FEED_OID,
EVENT_PAYMENT_OID,
SRMENABLED,
COUNTRY,
   BANKCODE, SCHOOLNAME, YBJOBNUMBER, 
   AMOUNT, USERID, DEPOSITDATE, 
   POSTEDDATE, LID, TRANSMIT_DATE, 
    ODS_CREATE_DATE) 
(
select     
    ODS_APP_USER.KREPORT_DATA_FEED_OID_SEQ.nextval,
    EP.EVENT_PAYMENT_OID,
    case when APO.FINANCIAL_PROCESSING_SYSTEM = 'Spectrum' then 'SRM' else 'GDT' end SRMENABLED,
    case when ACC.COUNTRY='Canada' then 'CAN' else 'USA' end  COUNTRY,
    BA.BANK_CODE                        BANKCODE,
    ACC.ACCOUNT_NAME       SCHOOLNAME,
    EP.EVENT_REF_ID           YBJOBNUMBER,
    EP.PAYMENT_AMOUNT       AMOUNT,
    EP.ENTERED_BY_USER       USERID,
    DEP.DEPOSIT_DATE       DEPOSITDATE,
    DEP.ODS_CREATE_DATE       POSTEDDATE,
    APO.LIFETOUCH_ID      LID,
    NULL TRANSMIT_DATE,
    sysdate ODS_CREATE_DATE
--    substr(BA.BANK_CODE,1,8)                        BANKCODE,
--    substr(rpad(ACC.ACCOUNT_NAME,30,' '),1,30)       SCHOOLNAME,
--    substr(lpad(EP.EVENT_REF_ID,10,' '),1,10)           YBJOBNUMBER,
--    to_char(EP.PAYMENT_AMOUNT,'999999999.99')       AMOUNT,
--    upper(substr(lpad(EP.ENTERED_BY_USER,8,' '),1,8))       USERID,
--    to_char(DEP.DEPOSIT_DATE,'YYYY/MM/DD')       DEPOSITDATE,
--    to_char(DEP.ODS_CREATE_DATE,'YYYY/MM/DD')       POSTEDDATE,
--    substr(lpad(APO.LIFETOUCH_ID,10,'0'),1,10)       LID
from    
     ODS_OWN.EVENT_PAYMENT   EP
    ,ODS_OWN.EVENT   E, ODS_OWN.APO   APO
    ,ODS_OWN.SOURCE_SYSTEM   SS
    ,ODS_OWN.ACCOUNT   ACC
    ,ODS_OWN.DEPOSIT   DEP
    ,ODS_OWN.BANK_ACCOUNT   BA
    ,ODS_OWN.DATA_CENTER dc /* cartesian to 1 row table */
where    
    (1=1)    
and APO.APO_OID > 1
        and not exists (select 1 from RAX_APP_USER.KREPORT_DATA_FEED z where (1=1)
                        and z.EVENT_PAYMENT_OID = ep.EVENT_PAYMENT_OID)        
        And EP.EVENT_OID=E.EVENT_OID (+)
        AND E.APO_OID=APO.APO_OID (+)
        AND E.SOURCE_SYSTEM_OID=SS.SOURCE_SYSTEM_OID
        AND APO.ACCOUNT_OID=ACC.ACCOUNT_OID
        AND EP.DEPOSIT_OID=DEP.DEPOSIT_OID (+)
        AND DEP.BANK_ACCOUNT_OID=BA.BANK_ACCOUNT_OID (+)
        And SS.SOURCE_SYSTEM_SHORT_NAME='LPIP'
        And nvl(APO.FINANCIAL_PROCESSING_SYSTEM (+),'-1')<>'Spectrum'
        And EP.TERRITORY_ACCOUNT_TYPE='Publishing'
        and trunc(EP.ODS_CREATE_DATE) >= to_date('20151104','YYYYMMDD')
        and nvl(dc.data_center_name,'Not Canada') not in ('Canada')
)

&


