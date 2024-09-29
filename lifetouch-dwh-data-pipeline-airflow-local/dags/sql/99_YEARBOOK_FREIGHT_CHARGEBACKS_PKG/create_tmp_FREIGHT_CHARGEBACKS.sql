/*-----------------------------------------------*/
/* TASK No. 2 */
/* drop report table */


BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.YB_FREIGHT_CHARGEBACKS';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;
&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* create report table */

create table RAX_APP_USER.YB_FREIGHT_CHARGEBACKS as
select 
a.EVENT_REF_ID
,min(a.SHIP_DATE) SHIP_DATE
,sum(a.FREIGHT_CHARGE) FREIGHT_CHARGE
from
(select
e.EVENT_REF_ID
,to_char(s.SHIP_DATE,'MM/DD/YYYY') SHIP_DATE
,min(s.TOTAL_ACTUAL_CHARGE) FREIGHT_CHARGE
from
ODS_OWN.EVENT e
,ODS_OWN.SUB_PROGRAM sp
,ODS_OWN.ORDER_HEADER oh
,ODS_OWN.ORDER_LINE ol
,ODS_OWN.SHIPMENT_LINE sl
,ODS_OWN.SHIPMENT s
,ODS_OWN.APO apo
where (1=1)
and apo.SCHOOL_YEAR = 2017
--and e.EVENT_REF_ID in ('2321917','13156317')
and e.APO_OID=apo.APO_OID
and apo.SUB_PROGRAM_OID=sp.SUB_PROGRAM_OID
and sp.SUB_PROGRAM_NAME='Yearbook'
and apo.FINANCIAL_PROCESSING_SYSTEM='Spectrum'
and oh.EVENT_OID=e.EVENT_OID
and ol.ORDER_HEADER_OID=oh.ORDER_HEADER_OID
and sl.ORDER_LINE_OID=ol.ORDER_LINE_OID
and s.SHIPMENT_OID=sl.SHIPMENT_OID
group by
e.EVENT_REF_ID
,to_char(s.SHIP_DATE,'MM/DD/YYYY')
order by
e.EVENT_REF_ID 
,to_char(s.SHIP_DATE,'MM/DD/YYYY')) a
group by
a.EVENT_REF_ID


