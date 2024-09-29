BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.YEARBOOK_IN_THE_PACK';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* create table */

create table RAX_APP_USER.YEARBOOK_IN_THE_PACK as
select
    to_char(case when to_date(:v_data_export_last_month_begin_date,'YYYYMMDD') is null then to_date('19000101','YYYYMMDD') else to_date(:v_data_export_last_month_begin_date,'YYYYMMDD') end,'MM/DD/YYYY') BEGIN_DATE
    ,to_char(case when to_date(:v_data_export_last_month_end_date,'YYYYMMDD') is null then to_date('21000101','YYYYMMDD') else to_date(:v_data_export_last_month_end_date,'YYYYMMDD') end,'MM/DD/YYYY') END_DATE
    ,e.EVENT_REF_ID
    ,APO.MARKETING_CODE PROGRAM
    ,org.TERRITORY_CODE 
    ,to_char(acc.LIFETOUCH_ID) LID
    ,acc.ACCOUNT_NAME
    ,ep.PAYMENT_AMOUNT
    ,to_char(ep.PAYMENT_DATE,'MM/DD/YYYY') PAYMENT_DATE
    ,to_char(apo.school_year) SCHOOL_YEAR
    ,org.BUSINESS_UNIT_NAME 
    ,ep.PAYMENT_SOURCE
    ,pt.PAYMENT_TYPE
    ,to_char(apo.APO_ID) APO_ID
from
    ODS_OWN.EVENT_PAYMENT ep
    ,ODS_OWN.PAYMENT_TYPE pt
    ,ODS_OWN.EVENT e
    ,ODS_OWN.APO apo
    ,ODS_OWN.ACCOUNT acc
    ,ODS_OWN.ORGANIZATION_VW org
    ,ODS_OWN.SUB_PROGRAM sp
where (1=1)
    and ep.PAYMENT_TYPE_OID=pt.PAYMENT_TYPE_OID
    and e.SALE_TYPE = 2
    and ep.PAYMENT_DATE >= case when to_date(:v_data_export_last_month_begin_date,'YYYYMMDD') is null then to_date('19000101','YYYYMMDD') else to_date(:v_data_export_last_month_begin_date,'YYYYMMDD') end
    and ep.PAYMENT_DATE <= case when to_date(:v_data_export_last_month_end_date,'YYYYMMDD') is null then to_date('21000101','YYYYMMDD') else to_date(:v_data_export_last_month_end_date,'YYYYMMDD') end
    and apo.SCHOOL_YEAR >= 2016
    and apo.FINANCIAL_PROCESSING_SYSTEM='Spectrum'
    and apo.TERRITORY_CODE=org.TERRITORY_CODE
    and apo.SUB_PROGRAM_OID=sp.SUB_PROGRAM_OID
    and sp.SUB_PROGRAM_NAME = 'Yearbook'
    and ep.EVENT_OID=e.EVENT_OID
    and e.APO_OID=apo.APO_OID
    and apo.ACCOUNT_OID=acc.ACCOUNT_OID
order by  
    apo.school_year
    ,e.EVENT_REF_ID
    ,ep.PAYMENT_DATE
    ,ep.PAYMENT_AMOUNT


