BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.YEARBOOK_SALES';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;
&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* create table */

create table RAX_APP_USER.YEARBOOK_SALES as
select 
    ORGV.OPERATING_COMPANY_NAME
    ,ORGV.BUSINESS_UNIT_NAME
    ,ORGV.AREA_NAME
    ,ORGV.REGION_NAME
    ,ORGV.TERRITORY_CODE
    ,APO.FINANCIAL_PROCESSING_SYSTEM
    ,APO.LIFETOUCH_ID
    ,ACC.ACCOUNT_NAME
    ,APO.STATUS as CANCELLED
    ,E.EVENT_REF_ID
    ,BS.REVISION_NUMBER INVOICE_NUMBER
    ,to_char(BS.STATEMENT_DATE,'MM/DD/YYYY') STATEMENT_DATE
    ,to_char(BS.MIN_SENT_DATE,'MM/DD/YYYY') MIN_SENT_DATE
    ,E.SCHOOL_YEAR PUB_YEAR
    ,to_char(E.SHIP_DATE,'MM/DD/YYYY') SHIP_DATE
    ,min(nvl(EP.PAYMENTS_RECEIVED,0)) PAYMENTS_RECEIVED
    ,case when E.SHIP_DATE is null then min(nvl(EP.PAYMENTS_RECEIVED,0)) else 0 end DEPOSIT_BALANCE 
    ,min(nvl(BS.SUB_AMOUNT,0)) INVOICE_SUBTOTAL
    ,min(nvl(sr.UNMAT_ORD_SH_TAX,0)) + min(nvl(sr.UNMAT_PRODUCT_TAX,0)) TAX
    ,min(nvl(sr.UNMAT_ORD_SH_TAX,0))  SH_TAX
    ,min (nvl(sr.UNMAT_ORD_SH_AMT,0)) FREIGHT
    ,min (nvl(BS.TOTAL_AMOUNT,0)) INVOICE_AMOUNT
    ,min (nvl(SR.INV_PAY_AMOUNT,0)) INV_PAY_AMOUNT
    ,min (nvl(SR.RECOGNITION_AMOUNT,0)) RECOGNITION_AMOUNT
    ,min(nvl(ORD.ORDER_AMOUNT,0)) ORDER_AMOUNT
    ,min(nvl(BS.SUB_AMOUNT,0)) INVOICED_ORDER_AMOUNT
    ,case when E.SHIP_DATE is null then 0 else min (nvl(BS.TOTAL_DUE,0)) end BALANCE_DUE
    ,case when E.SHIP_DATE is null then 0 else min(nvl(BS.OUTSTANDING_BALANCE,0)) end AR_BALANCE_DUE
    ,case when (SYSDATE - trunc(E.SHIP_DATE)) BETWEEN 0 and 30 then min (nvl(BS.TOTAL_DUE,0)) else 0 end DAYS_0_30
    ,case when (SYSDATE - trunc(E.SHIP_DATE)) BETWEEN 31 and 60 then min (nvl(BS.TOTAL_DUE,0)) else 0 end DAYS_31_60
    ,case when (SYSDATE - trunc(E.SHIP_DATE)) BETWEEN 61 and 90 then min (nvl(BS.TOTAL_DUE,0)) else 0 end DAYS_61_90
    ,case when (SYSDATE - trunc(E.SHIP_DATE)) > 90 then min (nvl(BS.TOTAL_DUE,0)) else 0 end DAYS_90_PLUS
    /*,min( nvl(sr.TERRITORY_CHARGEBACK,0) ) + min(nvl(sr.TERR_CHARGE_ADJ,0))  CHARGES_TO_TERRITORY per Scott Remiger 2/2/2017*/
    ,min(nvl(sr.TERR_CHARGE_ADJ,0))  CHARGES_TO_TERRITORY
    ,case when E.SHIP_DATE is null then 0 else  -1 * min(nvl(sr.TERRITORY_COMMISSION_AMOUNT,0)) end CREDITS_TO_TERRITORY
    ,-1 * (min(nvl(sr.RECOGNITION_AMOUNT,0)) - min(nvl(sr.CHARGEBACK_LIABILITY,0))) PROJECTED_COMMISSION
    /*,(-1 * min (nvl(SR.RECOGNITION_AMOUNT,0)))  + (min( nvl(sr.TERRITORY_CHARGEBACK,0) ) + min(nvl(sr.TERR_CHARGE_ADJ,0)) )  PROJECTED_NET per Scott Remiger 2/2/2017*/
    ,(-1 * min (nvl(SR.RECOGNITION_AMOUNT,0)))  + ( min(nvl(sr.TERR_CHARGE_ADJ,0)) )  PROJECTED_NET
    /*,case when E.SHIP_DATE is null then 0 else (-1 * min (nvl(SR.RECOGNITION_AMOUNT,0)))  + (min( nvl(sr.TERRITORY_CHARGEBACK,0) ) + min(nvl(sr.TERR_CHARGE_ADJ,0)) ) - (-1 * (min(nvl(EP.PAYMENTS_RECEIVED,0)) - (min(nvl(UNMAT_ORD_SH_TAX,0)) + min(nvl(UNMAT_PRODUCT_TAX,0))) - min (nvl(sr.UNMAT_ORD_SH_AMT,0))))  - (min( nvl(sr.TERRITORY_CHARGEBACK,0) ) + min(nvl(sr.TERR_CHARGE_ADJ,0)) ) end COMM_PAYABLE per Scott Remiger 2/2/2017*/
    ,(min(nvl(sr.RECOGNITION_AMOUNT,0)) - min(nvl(sr.CHARGEBACK_LIABILITY,0))) - min(nvl(sr.TERRITORY_COMMISSION_AMOUNT,0) - nvl(sr.TERRITORY_CHARGEBACK,0)) as COMM_PAYABLE
--    ,case when E.SHIP_DATE is null then 0 else (-1 * min (nvl(SR.RECOGNITION_AMOUNT,0)))  + ( min(nvl(sr.TERR_CHARGE_ADJ,0)) ) - (-1 * (min(nvl(EP.PAYMENTS_RECEIVED,0)) - (min(nvl(UNMAT_ORD_SH_TAX,0)) + min(nvl(UNMAT_PRODUCT_TAX,0))) - min (nvl(sr.UNMAT_ORD_SH_AMT,0))))  - (min(nvl(sr.TERR_CHARGE_ADJ,0)) ) end COMM_PAYABLE
    ,min(nvl(sr.TERRITORY_COMMISSION_AMOUNT,0) - nvl(sr.TERRITORY_CHARGEBACK,0)) as COMM_PAID
    ,case 
        when (min(nvl(sr.RECOGNITION_AMOUNT,0)) - min(nvl(sr.CHARGEBACK_LIABILITY,0))) >= 0 then 
            case when min(nvl(sr.TERRITORY_COMMISSION_AMOUNT,0) - nvl(sr.TERRITORY_CHARGEBACK,0)) >= 0 then min(nvl(sr.TERRITORY_COMMISSION_AMOUNT,0) - nvl(sr.TERRITORY_CHARGEBACK,0)) else 0 end
        else 
            (min(nvl(sr.RECOGNITION_AMOUNT,0)) - min(nvl(sr.CHARGEBACK_LIABILITY,0))) 
        end as ADJ_COMM_PAID
--    ,case when E.SHIP_DATE is null then 0 else  -1 * min(nvl(sr.TERRITORY_COMMISSION_AMOUNT,0)) end COMM_PAID
    ,min(nvl(BS.WRITE_OFF_AMOUNT,0)) WRITE_OFF_AMOUNT
    ,min(nvl(BS.REFUND_AMOUNT,0)) REFUND_AMOUNT
    ,APO.MARKETING_CODE as PROGRAM
    ,mark.MARKETING_CODE_NAME as PROGRAM_DESCRIPTION
    ,min(nvl(pages.pages,0)) PAGES
    ,min(nvl(pages.main_copies,0)) MAIN_COPIES
    ,min(nvl(pages.extra_copies,0)) EXTRA_COPIES
    ,min(nvl(pages.returned_extra_copies,0)) RETURNED_EXTRA_COPIES
    ,min(nvl(pages.reorder_copies,0)) REORDER_COPIES
    ,min(nvl(pages.rerun_copies,0)) RERUN_COPIES
    ,BOOK.PAGE_QTY
    ,BOOK.COPY_QTY
    ,BOOK.HARD_COVER_QTY
    ,BOOK.SOFT_COVER_QTY
    ,APY.BOOKING_STATUS
    ,BOOK.COVER_TYPE_DESC
    ,nvl(REP.FIRST_NAME,'Unassigned') FIRST_NAME
    ,nvl(REP.LAST_NAME,'Unassigned') LAST_NAME
    ,SP.SUB_PROGRAM_NAME
    ,case when E.SALE_TYPE = '1' then 'Separate_Sales' when E.SALE_TYPE = '2' then 'In_The_Pack' else nvl(E.SALE_TYPE,'Separate_Sales') end SALE_TYPE
    ,min(nvl(ORD.B_TOTAL_AMOUNT,0)) as NON_EXTRA_COPY_SUBTOTAL
    ,min(nvl(ORD.B_ADJUSTMENTS,0)) as NON_EXTRA_COPY_ADJ
    ,min(nvl(ORD.EBS_TOTAL_AMOUNT,0)) as EXTRA_COPY_SUBTOTAL
    ,min(nvl(ORD.EBS_ADJUSTMENTS,0)) as EXTRA_COPY_ADJ
    ,nvl(((min(ORD.EBS_TOTAL_AMOUNT) + min(nvl(ORD.EBS_ADJUSTMENTS,0))) - min(sr.CONTRA_PRODUCT)),0) as EXTRA_COPY_RECOGNIZED
    ,min(nvl(sr.CONTRA_PRODUCT,0))  as EXTRA_COPY_RECOGNIZABLE
    ,min(nvl(sr.CONTRA_PRODUCT,0)) CONTRA_PRODUCT
    ,min(nvl(sr.CONTRA_TAX,0)) CONTRA_TAX
    ,min(nvl(sr.CONTRA_COMMISSION,0)) CONTRA_COMMISSION
    ,min(nvl(sr.CONTRA_CHR_BCK,0)) CONTRA_CHR_BCK
    ,min(nvl(sr.TERRITORY_COMMISSION_LIABILITY,0)) COMMISSION_LIABILITY 
    ,min(nvl(sr.TERRITORY_COMMISSION_AMOUNT,0)) RECOGNIZED_COMMISSION 
    ,min(nvl(sr.TERRITORY_COMMISSION_LIABILITY,0)) - min(nvl(sr.TERRITORY_COMMISSION_AMOUNT,0)) - min(nvl(BS.WRITE_OFF_AMOUNT,0)) COMMISSION_PAYABLE 
    ,min(nvl(pages.Optional_Extra_Copies ,0)) OPTIONAL_EXTRA_COPIES 
    ,min(nvl(ORD.Territory_Order,0)) TERRITORY_ORDER
    ,min(nvl(ORD.Customer_Care_Order,0)) CUSTOMER_CARE_ORDER
    ,min(nvl(ORD.Compliment_Order,0))	COMPLIMENT_ORDER
    ,min(nvl(ORD.Rerun_Order,0))	RERUN_ORDER
    ,APO.APO_ID as APO_ID
from
    (select 
        SR.EVENT_OID
        ,sum(RECOGNITION_AMOUNT) RECOGNITION_AMOUNT   
        ,sum(ACCOUNT_COMMISSION_AMOUNT) ACCOUNT_COMMISSION_AMOUNT
        ,sum(SALES_TAX_AMOUNT) SALES_TAX_AMOUNT
        ,sum(TERRITORY_COMMISSION_AMOUNT) TERRITORY_COMMISSION_AMOUNT
        ,sum(UNMATCHED_PAYMENT_AMOUNT) UNMATCHED_PAYMENT_AMOUNT 
        ,sum(UNMATCHED_SALES_TAX_AMOUNT) UNMATCHED_SALES_TAX_AMOUNT
        ,sum(sr.TERR_CHARGE_ADJ) TERRITORY_CHARGEBACK
        ,sum(TERRITORY_COMMISSION_LIABILITY) TERRITORY_COMMISSION_LIABILITY
        ,sum(ACCT_COMMISSION_ADJ) ACCT_COMMISSION_ADJ
        ,sum(INV_PAY_AMOUNT) INV_PAY_AMOUNT
        ,sum(MAT_SALES_TAX_AMOUNT) MAT_SALES_TAX_AMOUNT
        ,sum(PAYMENT_AMOUNT) PAYMENT_AMOUNT 
        ,sum(TERR_CHARGE_ADJ) TERR_CHARGE_ADJ
        ,sum(TERR_COM_ADJ) TERR_COM_ADJ
        ,sum(TERR_COM_LIA_ADJ) TERR_COM_LIA_ADJ
        ,sum(MAT_ORD_SH_AMT) MAT_ORD_SH_AMT
        ,sum(MAT_ORD_SH_TAX) MAT_ORD_SH_TAX
        ,sum(UNMAT_ORD_SH_AMT) UNMAT_ORD_SH_AMT
        ,sum(UNMAT_ORD_SH_TAX) UNMAT_ORD_SH_TAX
        ,sum(MAT_PRODUCT_AMT) MAT_PRODUCT_AMT
        ,sum(MAT_PRODUCT_TAX) MAT_PRODUCT_TAX
        ,sum(UNMAT_PRODUCT_AMT) UNMAT_PRODUCT_AMT
        ,sum(UNMAT_PRODUCT_TAX) UNMAT_PRODUCT_TAX
        ,sum(WRITE_OFF_AMOUNT) WRITE_OFF_AMOUNT
        ,sum(sr.CONTRA_PRODUCT) CONTRA_PRODUCT
        ,sum(sr.CONTRA_TAX) CONTRA_TAX
        ,sum(sr.CONTRA_COMMISSION) CONTRA_COMMISSION
        ,sum(sr.CONTRA_CHR_BCK) CONTRA_CHR_BCK
        ,sum(sr.REFUNDS) REFUNDS
        ,sum(sr.TERR_CHG_LIA_ADJ) CHARGEBACK_LIABILITY
    from
        ODS_OWN.SALES_RECOGNITION sr
        ,ODS_OWN.EVENT e
        ,ODS_OWN.APO apo
        ,ODS_OWN.SUB_PROGRAM sp
    where (1=1)
        and SR.EVENT_OID=E.EVENT_OID
        and e.APO_OID=apo.APO_OID
        and apo.SUB_PROGRAM_OID=sp.SUB_PROGRAM_OID
        and sp.SUB_PROGRAM_NAME = 'Yearbook'
        and E.SCHOOL_YEAR >= (select tt.FISCAL_YEAR - 3 from MART.TIME tt where tt.DATE_KEY = trunc(sysdate))
    group by 
        SR.EVENT_OID 
     ) sr 
    ,(select
        BS.EVENT_OID
        ,BS.EVENT_REF_ID
        ,BS.ADJUSTMENT_AMOUNT
        ,BS.FREIGHT_AMOUNT
        ,BS.FREIGHT_TAX_AMOUNT
        ,BS.REVISION_NUMBER
        ,BS.SENT_DATE
        ,trunc(dedup.SENT_DATE) MIN_SENT_DATE
        ,trunc(BS.STATEMENT_DATE) STATEMENT_DATE
        ,BS.SUB_AMOUNT
        ,BS.TAX_AMOUNT
        ,BS.TOTAL_AMOUNT
        ,BS.TOTAL_DUE
        ,BS.FREIGHT_ADJUSTMENT_AMOUNT
        ,BS.OUTSTANDING_BALANCE
        ,BS.WRITE_OFF_AMOUNT
        ,BS.REFUND_AMOUNT
    from
        ods_own.BILLING_STATEMENT bs
        ,(select
            BS.EVENT_REF_ID
            ,min(BS.SENT_DATE) SENT_DATE
            ,max(BS.REVISION_NUMBER) REVISION_NUMBER
        from
            ods_own.BILLING_STATEMENT bs
        where (1=1)
        group by
            BS.EVENT_REF_ID
        ) dedup
    where (1=1)
        and BS.EVENT_REF_ID=dedup.EVENT_REF_ID
        and BS.REVISION_NUMBER=dedup.REVISION_NUMBER
    ) bs
    ,ODS_OWN.EVENT e
    ,ODS_OWN.APO apo
    ,ODS_OWN.ACCOUNT acc
    ,ODS_OWN.SOURCE_SYSTEM ss
    ,ODS_OWN.MARKETING mark
    ,ODS_OWN.ORGANIZATION_VW orgv
    ,MART.APY apy
    ,(select 
        oh.EVENT_OID 
        ,max(case when item.ITEM_ID = '57352' then ol.ORDERED_QUANTITY end) as PAGE_QTY 
        ,max(case when item.ITEM_ID = '55019' then ol.ORDERED_QUANTITY end) as COPY_QTY 
        ,max(case when item.ITEM_ID = '55019' and ole.ELEMENT_NAME = 'HARD_COVER_QTY' then to_number(ole.ELEMENT_VALUE) else 0 end) as HARD_COVER_QTY
        ,max(case when item.ITEM_ID = '55019' and ole.ELEMENT_NAME = 'SOFT_COVER_QTY' then to_number(ole.ELEMENT_VALUE) else 0 end) as SOFT_COVER_QTY
        ,case when max(case when item.ITEM_ID = '55019' and ole.ELEMENT_NAME = 'SOFT_COVER_QTY' then to_number(ole.ELEMENT_VALUE) else 0 end) > 0
               and max(case when item.ITEM_ID = '55019' and ole.ELEMENT_NAME = 'HARD_COVER_QTY' then to_number(ole.ELEMENT_VALUE) else 0 end) > 0 then 'Split Cover'
              when max(case when item.ITEM_ID = '55019' and ole.ELEMENT_NAME = 'HARD_COVER_QTY' then to_number(ole.ELEMENT_VALUE) else 0 end) > 0 then 'Hard Cover'
              else 'Soft Cover'
         end COVER_TYPE_DESC
    from 
        ODS_OWN.ORDER_HEADER oh, ODS_OWN.ORDER_LINE ol,ODS_OWN.ITEM item,ODS_OWN.ORDER_LINE_DETAIL old ,ODS_OWN.ORDER_LINE_ELEMENT ole 
    where 
        oh.ORDER_HEADER_OID=ol.ORDER_HEADER_OID and ol.ITEM_OID=item.ITEM_OID
        and ol.ORDER_LINE_OID=old.ORDER_LINE_OID(+) and old.ORDER_LINE_DETAIL_OID=ole.ORDER_LINE_DETAIL_OID(+)
        and item.ITEM_ID in ( '57352','55019') 
    group by oh.EVENT_OID) book
    ,(select 
        SRE.FIRST_NAME,SRE.LAST_NAME,
        rep.*
      from
        ODS_OWN.REP_ASSIGNMENT rep
        ,ODS_OWN.EMPLOYEE sre
        ,(select
            REP.ACCOUNT_OID
            ,REP.PROGRAM_OID
            ,REP.REP_TYPE
            ,max(REP.LT_REP_START_DATE) LT_REP_START_DATE
            ,max(rep.REP_ASSIGNMENT_OID) REP_ASSIGNMENT_OID
        from
            ODS_OWN.REP_ASSIGNMENT rep
            ,ODS_OWN.PROGRAM prog
        where (1=1)
            and rep.PROGRAM_OID=prog.PROGRAM_OID
            and prog.PROGRAM_NAME='Yearbook'
            and REP.REP_TYPE='Sales'
            and REP.LT_REP_END_DATE is  null
        group by
            REP.ACCOUNT_OID
            ,REP.PROGRAM_OID
            ,REP.REP_TYPE
        ) cand
      where (1=1)
        and REP.ACCOUNT_OID=cand.ACCOUNT_OID
        and REP.PROGRAM_OID=cand.PROGRAM_OID
        and REP.REP_TYPE= cand.REP_TYPE
--        and REP.LT_REP_START_DATE=cand.LT_REP_START_DATE
        and rep.REP_ASSIGNMENT_OID=cand.REP_ASSIGNMENT_OID
        and rep.EMPLOYEE_OID=sre.EMPLOYEE_OID
        ) rep
    ,ODS_OWN.SUB_PROGRAM sp
    ,(select
        OH.EVENT_OID
        ,max(OH.ORDER_SHIP_DATE) SHIP_DATE
        ,sum(OH.TOTAL_AMOUNT) ORDER_AMOUNT
        ,sum(case when oh.ORDER_TYPE in ('Extra_Book_Spec','YBExtraBkSpec_Order') and oh.DOCUMENT_TYPE <> '0003' then oh.TOTAL_AMOUNT else 0 end)  EBS_TOTAL_AMOUNT 
        ,sum(case when oh.ORDER_TYPE not in ('Extra_Book_Spec','YBExtraBkSpec_Order') then oh.TOTAL_AMOUNT else 0 end)  B_TOTAL_AMOUNT 
        ,min(ea.PERFECT_ORDER_SALES_AMOUNT) B_ADJUSTMENTS
        ,sum(case when oh.ORDER_TYPE in ('Extra_Book_Spec','YBExtraBkSpec_Order') and oh.DOCUMENT_TYPE = '0003' then oh.TOTAL_AMOUNT else 0 end)  EBS_ADJUSTMENTS
       ,sum(case when oh.order_type in('YBTerritory_Order') then oh.TOTAL_AMOUNT else 0 end) Territory_Order
       ,sum(case when oh.order_type in('YBCustomerCare_Order') then oh.TOTAL_AMOUNT else 0 end) Customer_Care_Order
       ,sum(case when oh.order_type in('YBCompliment_Order') then oh.TOTAL_AMOUNT else 0 end) Compliment_Order
       ,sum(case when oh.order_type in('YBRerun_Order') then oh.TOTAL_AMOUNT else 0 end) Rerun_Order
		
    from
        ODS_OWN.ORDER_HEADER oh
        ,ODS_OWN.EVENT e
        ,(select ea.EVENT_OID,sum(ea.PERFECT_ORDER_SALES_AMOUNT) PERFECT_ORDER_SALES_AMOUNT from  ODS_OWN.EVENT_ADJUSTMENT ea /*where event_oid = 11471519*/ group by ea.EVENT_OID) ea
        ,ODS_OWN.APO apo
        ,ODS_OWN.SUB_PROGRAM sp
    where (1=1)
        and oh.APO_OID=apo.APO_OID
        and apo.SUB_PROGRAM_OID=sp.SUB_PROGRAM_OID
        and sp.SUB_PROGRAM_NAME = 'Yearbook'    
        and OH.EVENT_OID=E.EVENT_OID
        and oh.EVENT_OID=ea.EVENT_OID(+)
        and E.SCHOOL_YEAR >= (select tt.FISCAL_YEAR - 3 from MART.TIME tt where tt.DATE_KEY = trunc(sysdate))
    group by 
        OH.EVENT_OID
    ) ord 
    ,(select 
        ep.EVENT_OID
        ,sum(EP.PAYMENT_AMOUNT) PAYMENTS_RECEIVED
      from 
        ODS_OWN.EVENT_PAYMENT ep 
      where (1=1)
      group by 
        ep.EVENT_OID) EP
    ,(select
        OH.EVENT_OID
        ,max(case when I.ITEM_ID in ('57352') then OL.ORDERED_QUANTITY else 0 end) as PAGES
        ,sum(case when I.ITEM_ID in ('55019') and oh.ORDER_TYPE in ('YBExtraBkSpec_Order','Extra_Book_Spec') then  case when ol.unit_price > 0 then OL.ORDERED_QUANTITY else 0 end  else 0 end) as EXTRA_COPIES
        ,sum(case when I.ITEM_ID in ('55019') and oh.ORDER_TYPE in ('YBExtraBkSpec_Order','Extra_Book_Spec') then  case when ol.unit_price < 0 then OL.ORDERED_QUANTITY else 0 end  else 0 end) as RETURNED_EXTRA_COPIES
        ,sum(case when I.ITEM_ID in ('55019') and oh.ORDER_TYPE in ('YBYearbook_Order','Book') then OL.ORDERED_QUANTITY else 0 end) as MAIN_COPIES
        ,sum(case when I.ITEM_ID in ('55019') and oh.ORDER_TYPE in ('YBReorder_Order','Extra_Book') then OL.ORDERED_QUANTITY else 0 end) as REORDER_COPIES
        ,sum(case when I.ITEM_ID in ('55019') and oh.ORDER_TYPE in ('YBRerun_Order') then OL.ORDERED_QUANTITY else 0 end) as RERUN_COPIES
     ,sum(case when oh.order_no like '01:%' and oh.ORDER_TYPE in ('YBExtraBkSpec_Order') and i.description = 'Yearbook' then sl.SHIPPED_QUANTITY * ol.unit_price 
	when oh.order_no not like '01:%' and oh.ORDER_TYPE in ('YBExtraBkSpec_Order') and i.description = 'Yearbook' then ol.Ordered_Quantity * ol.unit_price
else 0 end) as Optional_Extra_Copies
    from
         ODS_OWN.ORDER_HEADER oh
        ,ODS_OWN.ORDER_LINE ol
        ,ODS_OWN.ITEM i
        ,ODS_OWN.SHIPMENT_LINE sl
        ,ODS_OWN.APO apo
        ,ODS_OWN.SUB_PROGRAM sp
    where (1=1)
        and oh.APO_OID=apo.APO_OID
        and apo.SUB_PROGRAM_OID=sp.SUB_PROGRAM_OID
        and sp.SUB_PROGRAM_NAME = 'Yearbook'    
        and OH.ORDER_HEADER_OID=OL.ORDER_HEADER_OID
         and OL.ORDER_LINE_OID = SL.ORDER_LINE_OID (+)
        and apo.SCHOOL_YEAR >= (select tt.FISCAL_YEAR - 3 from MART.TIME tt where tt.DATE_KEY = trunc(sysdate))
        and OL.ITEM_OID=I.ITEM_OID
        and I.ITEM_ID in ('57352','55019')
    group by
        OH.EVENT_OID
       ) pages
    ,ODS_OWN.DATA_CENTER dc /* cartesian to 1 row table */
where (1=1)
--and e.event_ref_id in ( '10015216','10018717','10016917','10010817')
--and e.EVENT_REF_ID = 'EVTR7HM9W'
    and sp.SUB_PROGRAM_NAME='Yearbook'
-- DM-1159 change following from SR.event_oid to E.event_oid
    and E.EVENT_OID=bs.EVENT_OID(+)
    and E.EVENT_OID = SR.EVENT_OID(+)
    and APO.SUB_PROGRAM_OID=SP.SUB_PROGRAM_OID(+)
    and REP.ACCOUNT_OID(+) = ACC.ACCOUNT_OID
    and SP.PROGRAM_OID=case when REP.PROGRAM_OID is null then SP.PROGRAM_OID else REP.PROGRAM_OID end
    and E.EVENT_OID = BOOK.EVENT_OID (+)
    and ACC.LIFETOUCH_ID = APY.LIFETOUCH_ID
    and APO.SCHOOL_YEAR = APY.FISCAL_YEAR(+)
    and 'Yearbook' = APY.SUB_PROGRAM_NAME(+)
    and E.SOURCE_SYSTEM_OID=SS.SOURCE_SYSTEM_OID 
    and APO.FINANCIAL_PROCESSING_SYSTEM='Spectrum'
    and E.SCHOOL_YEAR >= (select tt.FISCAL_YEAR - 3 from MART.TIME tt where tt.DATE_KEY = trunc(sysdate))
    and E.APO_OID=APO.APO_OID
    and APO.MARKETING_CODE=MARK.DW_MARKETING_CODE(+)
    and APO.ACCOUNT_OID=ACC.ACCOUNT_OID
    and E.EVENT_OID = ORD.EVENT_OID(+)
    and E.EVENT_OID = EP.EVENT_OID(+)
    and E.EVENT_OID = pages.EVENT_OID(+)
    and APO.TERRITORY_CODE = orgv.TERRITORY_CODE(+)
group by
    ORGV.OPERATING_COMPANY_NAME
    ,ORGV.BUSINESS_UNIT_NAME
    ,ORGV.AREA_NAME
    ,ORGV.REGION_NAME
    ,ORGV.TERRITORY_CODE
    ,APO.FINANCIAL_PROCESSING_SYSTEM
    ,APO.LIFETOUCH_ID
    ,ACC.ACCOUNT_NAME
    ,APO.STATUS
    ,E.EVENT_REF_ID
    ,BS.REVISION_NUMBER
    ,BS.STATEMENT_DATE
    ,BS.MIN_SENT_DATE
    ,E.SCHOOL_YEAR
    ,E.SHIP_DATE
    ,APO.MARKETING_CODE 
    ,MARK.MARKETING_CODE_NAME 
    ,APY.BOOKING_STATUS
    ,BOOK.COVER_TYPE_DESC
    ,BOOK.PAGE_QTY
    ,BOOK.COPY_QTY
    ,BOOK.HARD_COVER_QTY
    ,BOOK.SOFT_COVER_QTY
    ,nvl(REP.FIRST_NAME,'Unassigned')
    ,nvl(REP.LAST_NAME,'Unassigned') 
    ,APO.SUB_PROGRAM_OID
    ,SP.PROGRAM_OID,REP.PROGRAM_OID
    ,SP.SUB_PROGRAM_NAME
    ,rep.REP_ASSIGNMENT_OID
    ,rep.EMPLOYEE_OID
    ,rep.ACCOUNT_OID
    ,rep.PROGRAM_OID
    ,rep.LT_REP_START_DATE
    ,rep.LT_REP_END_DATE
    ,rep.REP_TYPE
    ,case when E.SALE_TYPE = '1' then 'Separate_Sales' when E.SALE_TYPE = '2' then 'In_The_Pack' else nvl(E.SALE_TYPE,'Separate_Sales') end
    ,APO.APO_ID 
order by 
    E.SCHOOL_YEAR
    ,E.EVENT_REF_ID
    ,E.SHIP_DATE
    ,BS.REVISION_NUMBER

