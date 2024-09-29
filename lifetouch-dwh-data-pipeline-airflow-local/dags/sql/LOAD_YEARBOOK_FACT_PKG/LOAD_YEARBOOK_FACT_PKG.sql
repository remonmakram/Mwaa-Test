/* TASK No. 1 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 2 */




/*-----------------------------------------------*/
/* TASK No. 3 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 3 */




/*-----------------------------------------------*/
/* TASK No. 4 */
/* drop yb_fact_driver */
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.yb_fact_driver';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  

-- drop table  rax_app_user.yb_fact_driver

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* create table yb_fact_driver */

create table rax_app_user.yb_fact_driver
as
select event_oid from ods_own.order_header
where ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap
group by event_oid
union
select oh.event_oid 
from ods_own.order_line ol, ods_own.order_header oh
where ol.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap
and ol.order_header_oid = oh.order_header_oid
group by oh.event_oid 
union
select event_oid 
from ods_own.billing_statement
where ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap
group by event_oid
union
select event_oid 
from ods_own.event_payment
where ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap
group by event_oid
union
select event_oid 
from ods_own.sales_recognition
where ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap
group by event_oid
union
select oh.event_oid
 from ods_own.order_header oh, ods_own.order_line ol,ods_own.item item, ods_own.order_line_detail old ,ods_own.order_line_element ole 
    where 
        oh.ORDER_HEADER_OID=ol.ORDER_HEADER_OID and ol.ITEM_OID=item.ITEM_OID
        and ol.ORDER_LINE_OID=old.ORDER_LINE_OID and old.ORDER_LINE_DETAIL_OID=ole.ORDER_LINE_DETAIL_OID
        and item.ITEM_ID in ( '57352','55019') 
       and ole.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap
group by oh.event_oid

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Add to yb_fact_driver (used to recalc only) */

MERGE INTO rax_app_user.yb_fact_driver t
     USING (SELECT DISTINCT event_oid
              FROM rax_app_user.yearbook_fact_backfill) s
        ON (t.event_oid = s.event_oid)
WHEN NOT MATCHED
THEN
    INSERT     (t.event_oid)
        VALUES (s.event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* drop table yb_temp */
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.yb_temp';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  

-- drop table rax_app_user.yb_temp

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* create table yb_temp */

create table rax_app_user.yb_temp
as
select driver.event_oid
from rax_app_user.yb_fact_driver driver
, ods_own.event e
, ods_own.apo apo
, ods_own.sub_program sp
where driver.event_oid = e.event_oid
and e.apo_oid = apo.apo_oid
and apo.sub_program_oid = sp.sub_program_oid
and sp.sub_program_name = 'Yearbook'
and e.school_year >= 2020


&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* index yb_temp */

create unique index rax_app_user.yb_temp_pk on rax_app_user.yb_temp(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* drop table yb_temp1 */
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.yb_temp1';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  

-- drop table rax_app_user.yb_temp1

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* create table yb_temp1 */

create table rax_app_user.yb_temp1
(
  event_oid number
, event_ref_id varchar2(20)
, revision_number number
, statement_date date
, sent_date date
, sub_amount number
, total_amount number
, total_due number
, outstanding_balance number
, write_off_amount number
, refund_amount number
)



&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* insert into yb_temp1 (Invoice) */

insert into rax_app_user.yb_temp1
select
        bs.event_oid
       ,bs.event_ref_id    
        ,bs.revision_number
        ,trunc(bs.statement_date) statement_date
        ,trunc(bs.sent_date) sent_date
        ,sum(bs.sub_amount) as sub_amount
        ,sum(bs.total_amount) as total_amount
        ,sum(bs.total_due) as total_due
        ,sum(bs.outstanding_balance) as outstanding_balance
        ,sum(bs.write_off_amount) as write_off_amount
        ,sum(bs.refund_amount) as refund_amount
    from
        rax_app_user.yb_temp temp
        , ods_own.billing_statement bs
        ,(select
            bs.event_ref_id
           ,max(bs.revision_number) revision_number
        from
            ods_own.billing_statement bs
        where (1=1)
        group by
            bs.event_ref_id
        ) dedup
    where (1=1)
        and temp.event_oid = bs.event_oid
        and bs.event_ref_id = dedup.event_ref_id
        and bs.revision_number = dedup.revision_number
     group by  bs.event_oid, bs.event_ref_id,bs.revision_number, trunc(bs.statement_date), trunc(bs.sent_date)

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* index yb_temp1 */

create unique index rax_app_user.yb_temp1_pk on rax_app_user.yb_temp1(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* drop table yb_temp2 */
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.yb_temp2';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  

-- drop table rax_app_user.yb_temp2

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* create table yb_temp2 (Payment) */

create table rax_app_user.yb_temp2
as
select ep.event_oid
, sum(ep.payment_amount) as payments_received
--, min(nvl(ep.payment_received,0)) as deposit_balance
from ods_own.event_payment ep
, rax_app_user.yb_temp temp
where (1=1)
and ep.event_oid = temp.event_oid
group by ep.event_oid

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* index yb_temp2 */

create unique index rax_app_user.yb_temp2_pk on rax_app_user.yb_temp2(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* drop table yb_temp3 */
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.yb_temp3';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  

-- drop table rax_app_user.yb_temp3

&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* create table yb_temp3 (Sales Rec) */

create table rax_app_user.yb_temp3
as
select 
        sr.event_oid
        ,sum(recognition_amount) recognition_amount      
        ,sum(territory_commission_amount) territory_commission_amount    
        ,sum(sr.terr_charge_adj) territory_chargeback
        ,sum(territory_commission_liability) territory_commission_liability
        ,sum(inv_pay_amount) inv_pay_amount    
        ,sum(terr_charge_adj) terr_charge_adj  
        ,sum(unmat_ord_sh_amt) unmat_ord_sh_amt   
        ,sum(unmat_ord_sh_tax) unmat_ord_sh_tax     
        ,sum(unmat_product_tax) unmat_product_tax
        ,sum(write_off_amount) write_off_amount
        ,sum(sr.contra_product) contra_product
        ,sum(sr.contra_tax) contra_tax
        ,sum(contra_commission) contra_commission
        ,sum(sr.contra_chr_bck) contra_chr_bck     
        ,sum(sr.terr_chg_lia_adj) chargeback_liability
    from
        ods_own.sales_recognition sr
        ,rax_app_user.yb_temp temp       
    where (1=1)
        and sr.event_oid=temp.event_oid       
    group by 
        sr.event_oid

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* index yb_temp3 */

create unique index rax_app_user.yb_temp3_pk on rax_app_user.yb_temp3(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* drop table yb_temp4 */
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.yb_temp4';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

-- drop table rax_app_user.yb_temp4

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* create table yb_temp4 (Orders) */

create table rax_app_user.yb_temp4
as
select oh.event_oid, max(case when i.manufacturer_item = 'Yearbook Page' then ol.ordered_quantity else 0 end) as pages
, sum(case when i.manufacturer_item = 'Book' and oh.order_type in ('YBYearbook_Order','Book') then ol.ordered_quantity else 0 end) as main_copies
, sum(case when i.manufacturer_item = 'Book' and oh.order_type in ('YBExtraBkSpec_Order','Extra_Book_Spec') then  case when ol.unit_price > 0 then ol.ordered_quantity else 0 end  else 0 end) as extra_copies
, sum(case when i.manufacturer_item = 'Book'  and oh.order_type in ('YBExtraBkSpec_Order','Extra_Book_Spec') then  case when ol.unit_price < 0 then ol.ordered_quantity else 0 end  else 0 end) as returned_extra_copies
, sum(case when i.manufacturer_item = 'Book' and oh.order_type in ('YBReorder_Order','Extra_Book') then ol.ordered_quantity else 0 end) as reorder_copies
, sum(case when i.manufacturer_item = 'Book' and oh.order_type in ('YBRerun_Order') then ol.ordered_quantity else 0 end) as rerun_copies
 from
 ods_own.order_header oh
, ods_own.order_line ol
, ods_own.item i
--, ods_own.apo apo
--, ods_own.sub_program sp
, rax_app_user.yb_temp temp
 where (1=1)
        and oh.event_oid = temp.event_oid
       -- and oh.apo_oid=apo.apo_oid
      --  and apo.SUB_PROGRAM_OID=sp.SUB_PROGRAM_OID
       -- and sp.sub_program_name = 'Yearbook'    
        and oh.order_header_oid = ol.order_header_oid
       -- and apo.school_year>= (select tt.fiscal_year - 2 from mart.time tt where tt.date_key = trunc(sysdate))
        and ol.item_oid = i.item_oid
        and i.manufacturer_item in ('Book','Yearbook Page')
        AND ol.ORDERED_QUANTITY != 0
    group by
        oh.event_oid

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* index yb_temp4 */

create unique index rax_app_user.yb_temp4_pk on rax_app_user.yb_temp4(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* drop table yb_temp5 */
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.yb_temp5';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;
-- drop table rax_app_user.yb_temp5

&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* create table yb_temp5 (Hard/Soft Cover) */

create table rax_app_user.yb_temp5
as
select 
        oh.event_oid
        ,max(case when item.manufacturer_item = 'Yearbook Page' then ol.ordered_quantity end) as page_qty 
        ,max(case when item.manufacturer_item = 'Book'  then ol.ordered_quantity end) as COPY_QTY 
        ,max(case when item.manufacturer_item = 'Book' and oh.ORDER_TYPE = 'YBYearbook_Order' and ole.element_name = 'HARD_COVER_QTY' then to_number(ole.element_value) else 0 end) as hard_cover_qty
        ,max(case when item.manufacturer_item = 'Book' and oh.ORDER_TYPE = 'YBYearbook_Order' and ole.element_name = 'SOFT_COVER_QTY' then to_number(ole.element_value) else 0 end) as SOFT_COVER_QTY
        ,case when max(case when item.manufacturer_item = 'Book' and ole.element_name = 'SOFT_COVER_QTY' then to_number(ole.element_value) else 0 end) > 0
               and max(case when item.manufacturer_item = 'Book' and ole.element_name = 'HARD_COVER_QTY' then to_number(ole.element_value) else 0 end) > 0 then 'Split Cover'
              when max(case when item.manufacturer_item = 'Book' and ole.element_name = 'HARD_COVER_QTY' then to_number(ole.element_value) else 0 end) > 0 then 'Hard Cover'
              else 'Soft Cover'
         end cover_type_desc
        ,max(case when item.manufacturer_item = 'Book' and oh.ORDER_TYPE = 'YBReorder_Order' and ole.element_name = 'HARD_COVER_QTY' then to_number(ole.element_value) else 0 end) as reorder_hard_cover_qty
        ,max(case when item.manufacturer_item = 'Book' and oh.ORDER_TYPE = 'YBReorder_Order' and ole.element_name = 'SOFT_COVER_QTY' then to_number(ole.element_value) else 0 end) as reorder_SOFT_COVER_QTY
        ,max(case when item.manufacturer_item = 'Book' and oh.ORDER_TYPE = 'YBRerun_Order' and ole.element_name = 'HARD_COVER_QTY' then to_number(ole.element_value) else 0 end) as rerun_hard_cover_qty
        ,max(case when item.manufacturer_item = 'Book' and oh.ORDER_TYPE = 'YBRerun_Order' and ole.element_name = 'SOFT_COVER_QTY' then to_number(ole.element_value) else 0 end) as rerun_SOFT_COVER_QTY
        ,max(case when item.manufacturer_item = 'Book' and oh.ORDER_TYPE = 'YBExtraBkSpec_Order' and ol.unit_price > 0 and ole.element_name = 'HARD_COVER_QTY' then to_number(ole.element_value) else 0 end) as extra_hard_cover_qty
        ,max(case when item.manufacturer_item = 'Book' and oh.ORDER_TYPE = 'YBExtraBkSpec_Order' and ol.unit_price > 0 and ole.element_name = 'SOFT_COVER_QTY' then to_number(ole.element_value) else 0 end) as extra_SOFT_COVER_QTY
 ,max(case when item.manufacturer_item = 'Book' and oh.ORDER_TYPE = 'YBExtraBkSpec_Order' and ol.unit_price < 0 and ole.element_name = 'HARD_COVER_QTY' then to_number(ole.element_value) else 0 end) as return_hard_cover_qty
        ,max(case when item.manufacturer_item = 'Book' and oh.ORDER_TYPE = 'YBExtraBkSpec_Order' and ol.unit_price < 0 and ole.element_name = 'SOFT_COVER_QTY' then to_number(ole.element_value) else 0 end) as return_SOFT_COVER_QTY
    from rax_app_user.yb_temp temp
       , ods_own.order_header oh
       , ods_own.order_line ol
       , ods_own.item item
       , ods_own.order_line_detail old
       , ods_own.order_line_element ole 
    where 1=1
        and oh.event_oid = temp.event_oid
        and oh.order_header_oid = ol.order_header_oid and ol.item_oid = item.item_oid
        and ol.order_line_oid = old.order_line_oid(+) and old.order_line_detail_oid=ole.order_line_detail_oid(+)
        and item.manufacturer_item in ('Book','Yearbook Page')
        AND ol.ORDERED_QUANTITY != 0
    group by oh.event_oid

&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* index yb_temp5 */

create unique index rax_app_user.yb_temp5_pk on rax_app_user.yb_temp5(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* drop table yb_temp6 */
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.yb_temp6';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

-- drop table rax_app_user.yb_temp6

&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* create table yb_temp6 (Adjustments) */

create table rax_app_user.yb_temp6
as
select
        oh.event_oid
        ,max(oh.order_ship_date) ship_date
        ,sum(oh.total_amount) order_amount
        ,sum(case when oh.order_type in ('Extra_Book_Spec','YBExtraBkSpec_Order') and oh.DOCUMENT_TYPE <> '0003' then oh.total_amount else 0 end)  ebs_total_amount
        ,sum(case when oh.order_type not in ('Extra_Book_Spec','YBExtraBkSpec_Order') then oh.total_amount else 0 end)  b_total_amount
        ,min(ea.perfect_order_sales_amount) b_adjustments
        ,sum(case when oh.order_type in ('Extra_Book_Spec','YBExtraBkSpec_Order') and oh.DOCUMENT_TYPE = '0003' then oh.total_amount else 0 end)  ebs_adjustments
    from
          rax_app_user.yb_temp temp
        , ods_own.order_header oh
       -- , ods_own.event e
        , (select ea.event_oid,sum(ea.perfect_order_sales_amount) perfect_order_sales_amount from  ods_own.event_adjustment ea  group by ea.EVENT_OID) ea
        --, ods_own.apo apo
        --, ods_own.sub_program sp
    where (1=1)
        and temp.event_oid = oh.event_oid
        --and oh.apo_oid = apo.apo_oid
        --and apo.sub_program_oid =sp.sub_program_oid
        --and sp.sub_program_name = 'Yearbook'    
        --and oh.event_oid=e.event_oid
        and oh.event_oid=ea.event_oid(+)
       -- and e.school_year >= (select tt.fiscal_year - 2 from mart.time tt where tt.date_key = trunc(sysdate))
    group by 
        oh.event_oid

&


/*-----------------------------------------------*/
/* TASK No. 28 */
/*  index yb_temp6 */

create unique index rax_app_user.yb_temp6_pk on rax_app_user.yb_temp6(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* drop table yb_temp7 */
BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.yb_temp7';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

-- drop table rax_app_user.yb_temp7

&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* create table yb_temp7 */

create table rax_app_user.yb_temp7
as
select temp.event_oid, bs.revision_number invoice_number
, to_char(bs.statement_date, 'MM-DD-YY') statement_date
, to_char(bs.sent_date, 'MM-DD-YY') sent_date
, e.ship_date
, nvl(ep.payments_received,0) payments_received
, case when e.ship_date is null then nvl(ep.payments_received,0) else 0 end deposit_balance
, nvl(bs.sub_amount,0) invoice_subtotal
, nvl(sr.unmat_ord_sh_tax,0) + nvl(sr.unmat_product_tax,0) tax
, nvl(sr.unmat_ord_sh_tax,0)  sh_tax
, nvl(sr.unmat_ord_sh_amt,0) freight
, nvl(bs.total_amount,0) invoice_amount
, nvl(sr.inv_pay_amount,0) invoice_pay_amount
, nvl(sr.recognition_amount,0) recognition_amount
, nvl(ord.order_amount,0) order_amount
, nvl(bs.sub_amount,0) invoiced_order_amount
, case when e.ship_date is null then 0 else nvl(bs.total_due,0) end balance_due
, case when e.ship_date is null then 0 else nvl(bs.outstanding_balance,0) end ar_balance_due
, nvl(sr.terr_charge_adj,0)  charges_to_territory
, case when e.ship_date is null then 0 else  -1 * (nvl(sr.territory_commission_amount,0)) end credits_to_territory 
, -1 * (nvl(sr.recognition_amount,0) - nvl(sr.chargeback_liability,0)) projected_commission
,  (-1 * nvl(sr.recognition_amount,0))  + ( nvl(sr.terr_charge_adj,0) )  projected_net
, (nvl(sr.recognition_amount,0) - nvl(sr.chargeback_liability,0)) - (nvl(sr.territory_commission_amount,0) - nvl(sr.territory_chargeback,0)) as comm_payable
, (nvl(sr.territory_commission_amount,0) - nvl(sr.territory_chargeback,0)) as comm_paid
, case 
        when (nvl(sr.recognition_amount,0) - nvl(sr.chargeback_liability,0)) >= 0 then 
            case when (nvl(sr.territory_commission_amount,0) - nvl(sr.territory_chargeback,0)) >= 0 then (nvl(sr.territory_commission_amount,0) - nvl(sr.territory_chargeback,0)) else 0 end
        else 
            (nvl(sr.recognition_amount,0) - nvl(sr.chargeback_liability,0)) 
        end as adj_comm_paid
, nvl(bs.write_off_amount,0) write_off_amount
, nvl(bs.refund_amount,0) refund_amount
, nvl(pages.pages,0) pages
, nvl(pages.main_copies,0) main_copies
, nvl(pages.extra_copies,0) extra_copies
, nvl(pages.returned_extra_copies,0) returned_extra_copies
, nvl(pages.reorder_copies,0) reorder_copies
, nvl(pages.rerun_copies,0) rerun_copies
--, book_page_qty
, book.copy_qty
, book.hard_cover_qty
, book.soft_cover_qty
, book.cover_type_desc
, book.reorder_hard_cover_qty
, book.reorder_soft_cover_qty
, book.rerun_hard_cover_qty
, book.rerun_soft_cover_qty
, book.extra_hard_cover_qty
, book.extra_soft_cover_qty
, book.return_hard_cover_qty
, book.return_soft_cover_qty
, nvl(ord.b_total_amount,0) as non_extra_copy_subtotal
, nvl(ord.b_adjustments,0) as non_extra_copy_adj 
, nvl(ord.ebs_total_amount,0) as extra_copy_subtotal
, nvl(ord.ebs_adjustments,0) as extra_copy_adj
, nvl(((ord.ebs_total_amount + nvl(ord.ebs_adjustments,0)) - sr.contra_product),0) as extra_copy_recognized
, nvl(sr.contra_product,0)  as extra_copy_recognizable
, nvl(sr.contra_product,0) contra_product
, nvl(sr.contra_tax,0) contra_tax
, nvl(sr.contra_commission,0) contra_commission
, nvl(sr.contra_chr_bck,0) contra_chr_bck
, nvl(sr.territory_commission_liability,0) commission_liability 
, nvl(sr.territory_commission_amount,0) recognized_commission 
, nvl(sr.territory_commission_liability,0) - nvl(sr.territory_commission_amount,0) - nvl(bs.write_off_amount,0) commission_payable 
from rax_app_user.yb_temp temp
, rax_app_user.yb_temp1 bs
, rax_app_user.yb_temp2 ep
, rax_app_user.yb_temp3 sr
, rax_app_user.yb_temp6 ord
, rax_app_user.yb_temp4 pages
, rax_app_user.yb_temp5 book
, ods_own.event e
where temp.event_oid = e.event_oid
and e.event_oid = bs.event_oid(+)
and temp.event_oid = ep.event_oid(+)
and temp.event_oid = sr.event_oid(+)
and temp.event_oid = ord.event_oid(+)
and temp.event_oid = pages.event_oid(+)
and temp.event_oid = book.event_oid(+)


&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* index yb_temp7 */

create unique index rax_app_user.yb_temp7_pk on rax_app_user.yb_temp7(event_oid)

&


/*-----------------------------------------------*/
/* TASK No. 32 */
/* truncate stage */

truncate table rax_app_user.yearbook_stage

&


/*-----------------------------------------------*/
/* TASK No. 33 */
/* load stage */

insert into rax_app_user.yearbook_stage
(account_id
, apo_id
, job_nbr
, marketing_id
, job_ticket_org_id
, assignment_id
, assignment_effective_date
, invoice_number
, statement_date
, sent_date
, ship_date
, payments_received
, deposit_balance
, invoice_subtotal
, tax
, sh_tax
, freight
, invoice_amount
, invoice_pay_amount
, recognition_amount
, order_amount
, invoiced_order_amount
, balance_due
, ar_balance_due
, charges_to_territory
, credits_to_territory
, projected_commission
, projected_net
, comm_payable
, comm_paid
, adj_comm_paid
, write_off_amount
, refund_amount
, pages
, main_copies
, extra_copies
, returned_extra_copies
, reorder_copies
, rerun_copies
, copy_qty
, hard_cover_qty
, soft_cover_qty
, cover_type_desc
, reorder_hard_cover_qty
, reorder_soft_cover_qty
, rerun_hard_cover_qty
, rerun_soft_cover_qty
, extra_hard_cover_qty
, extra_soft_cover_qty
, return_hard_cover_qty
, return_soft_cover_qty
, non_extra_copy_subtotal
, non_extra_copy_adj
, extra_copy_subtotal
, extra_copy_adj
, extra_copy_recognized
, extra_copy_recognizable
, contra_product
, contra_tax
, contra_commission
, contra_chr_bck
, commission_liability
, recognized_commission
, commission_payable
, trans_date
)
select ma.account_id
, mapo.apo_id
, e.event_ref_id as job_nbr
, mm.marketing_id
, nvl(mo.organization_id, -1) as job_ticket_org_id
, nvl(ca.assignment_id, -1) as assignment_id
, ca.effective_date as assignment_effective_date
, nvl(tmp.invoice_number, '-1') as invoice_number
, nvl(to_date(tmp.statement_date, 'MM-DD-YYYY') , to_date('19000101','YYYYMMDD')) as statement_date
, nvl(to_date(tmp.sent_date, 'MM-DD-YYYY'),  to_date('19000101','YYYYMMDD')) as sent_date
, nvl(e.ship_date,  to_date('19000101','YYYYMMDD')) as ship_date
, tmp.payments_received
, case when e.ship_date is null then tmp.deposit_balance else 0 end as deposit_balance
, tmp.invoice_subtotal
, tmp.tax
, tmp.sh_tax
, tmp.freight
, tmp.invoice_amount
, tmp.invoice_pay_amount
, tmp.recognition_amount
, tmp.order_amount
, tmp.invoiced_order_amount
, case when e.ship_date is null then 0 else tmp.balance_due end balance_due
, case when e.ship_date is null then 0 else tmp.ar_balance_due end ar_balance_due
, tmp.charges_to_territory
, tmp.credits_to_territory
, tmp.projected_commission
, tmp.projected_net
, tmp.comm_payable
, tmp.comm_paid
, tmp.adj_comm_paid
, tmp.write_off_amount
, tmp.refund_amount
, tmp.pages
, tmp.main_copies
, tmp.extra_copies
, tmp.returned_extra_copies
, tmp.reorder_copies
, tmp.rerun_copies
, nvl(tmp.copy_qty, 0) as copy_qty
, nvl(tmp.hard_cover_qty, 0) as hard_cover_qty
, nvl(tmp.soft_cover_qty, 0) as soft_cover_qty
, nvl(tmp.cover_type_desc, '.') as cover_type_desc
, nvl(tmp.reorder_hard_cover_qty,0) as reorder_hard_cover_qty
, nvl(tmp.reorder_soft_cover_qty,0) as reorder_soft_cover_qty
, nvl(tmp.rerun_hard_cover_qty,0) as rerun_hard_cover_qty
, nvl(tmp.rerun_soft_cover_qty,0) as rerun_soft_cover_qty
, nvl(tmp.extra_hard_cover_qty,0) as extra_hard_cover_qty
, nvl(tmp.extra_soft_cover_qty,0) as extra_soft_cover_qty
, nvl(tmp.return_hard_cover_qty,0) as return_hard_cover_qty
, nvl(tmp.return_soft_cover_qty,0) as return_soft_cover_qty
, tmp.non_extra_copy_subtotal
, tmp.non_extra_copy_adj
, tmp.extra_copy_subtotal
, tmp.extra_copy_adj
, tmp.extra_copy_recognized
, tmp.extra_copy_recognizable
, tmp.contra_product
, tmp.contra_tax
, tmp.contra_commission
, tmp.contra_chr_bck
, tmp.commission_liability
, tmp.recognized_commission
, tmp.commission_payable
, trunc(sysdate) as trans_date 
from  rax_app_user.yb_temp7 tmp
, ods_own.event e
, ods_own.account a
, ods_own.apo apo
, mart.apo mapo
, mart.account ma
, ods_own.sub_program sp
, mart.marketing mm
, mart.current_assignment ca
, mart.organization  mo   
where 1=1
and tmp.event_oid = e.event_oid
and nvl(e.apo_oid, -1) = apo.apo_Oid(+)
and  nvl(apo.apo_id, -1) = mapo.apo_code(+)
and apo.account_oid = a.account_oid 
and nvl(a.lifetouch_id, -1) = ma.lifetouch_id(+)
and apo.sub_program_oid = sp.sub_program_oid  
and nvl(sp.sub_program_oid, -1) = mm.sub_program_oid(+)
and a.Lifetouch_Id = ca.Lifetouch_Id
and mm.program_id = ca.program_id
and nvl(apo.territory_code, -1) = mo.territory_code(+)


&


/*-----------------------------------------------*/
/* TASK No. 34 */
/* truncate stage2 */

truncate table rax_app_user.yearbook_stage2

&


/*-----------------------------------------------*/
/* TASK No. 35 */
/* insert stage2 DEL records */

insert into rax_app_user.yearbook_stage2
(
record_status
, yearbook_curr_id
, account_id
, apo_id
, job_nbr
, marketing_id
, job_ticket_org_id
, assignment_id
, assignment_effective_date
, invoice_number
, statement_date
, sent_date
, ship_date
, payments_received
, deposit_balance
, invoice_subtotal
, tax
, sh_tax
, freight
, invoice_amount
, invoice_pay_amount
, recognition_amount
, order_amount
, invoiced_order_amount
, balance_due
, ar_balance_due
, charges_to_territory
, credits_to_territory
, projected_commission
, projected_net
, comm_payable
, comm_paid
, adj_comm_paid
, write_off_amount
, refund_amount
, pages
, main_copies
, extra_copies
, returned_extra_copies
, reorder_copies
, rerun_copies
, copy_qty
, hard_cover_qty
, soft_cover_qty
, cover_type_desc
, reorder_hard_cover_qty
, reorder_soft_cover_qty
, rerun_hard_cover_qty
, rerun_soft_cover_qty
, extra_hard_cover_qty
, extra_soft_cover_qty
, return_hard_cover_qty
, return_soft_cover_qty
, non_extra_copy_subtotal
, non_extra_copy_adj
, extra_copy_subtotal
, extra_copy_adj
, extra_copy_recognized
, extra_copy_recognizable
, contra_product
, contra_tax
, contra_commission
, contra_chr_bck
, commission_liability
, recognized_commission
, commission_payable
, trans_date
)
select 'DEL'   
, c.yearbook_curr_id
, c.account_id
, c.apo_id
, c.job_nbr
, c.marketing_id
, c.job_ticket_org_id
, c.assignment_id
, c.assignment_effective_date
, c.invoice_number
, c.statement_date
, c.sent_date
, c.ship_date
, 0 as payments_received
, 0 as deposit_balance
, 0 as invoice_subtotal
, 0 as tax
, 0 as sh_tax
, 0 as freight
, 0 as invoice_amount
, 0 as invoice_pay_amount
, 0 as recognition_amount
, 0 as order_amount
, 0 as invoiced_order_amount
, 0 as balance_due
, 0 as ar_balance_due
, 0 as charges_to_territory
, 0 as credits_to_territory
, 0 as projected_commission
, 0 as projected_net
, 0 as comm_payable
, 0 as comm_paid
, 0 as adj_comm_paid
, 0 as write_off_amount
, 0 as refund_amount
, 0 as pages
, 0 as main_copies
, 0 as extra_copies
, 0 as returned_extra_copies
, 0 as reorder_copies
, 0 as rerun_copies
, 0 as copy_qty
, 0 as hard_cover_qty
, 0 as soft_cover_qty
, c.cover_type_desc
, 0 as reorder_hard_cover_qty
, 0 as reorder_soft_cover_qty
, 0 as rerun_hard_cover_qty
, 0 as rerun_soft_cover_qty
, 0 as extra_hard_cover_qty
, 0 as extra_soft_cover_qty
, 0 as return_hard_cover_qty
, 0 as return_soft_cover_qty
, 0 as non_extra_copy_subtotal
, 0 as non_extra_copy_adj
, 0 as extra_copy_subtotal
, 0 as extra_copy_adj
, 0 as extra_copy_recognized
, 0 as extra_copy_recognizable
, 0 as contra_product
, 0 as contra_tax
, 0 as contra_commission
, 0 as contra_chr_bck
, 0 as commission_liability
, 0 as recognized_commission
, 0 as commission_payable
, s.trans_date 
from  rax_app_user.yearbook_stage s
, ods_stage.yearbook_curr c
where 1=1
and s.job_nbr = c.job_nbr
and (
    s.account_id <> c.account_id
    or s.apo_id <> c.apo_id
    or s.marketing_id <> c.marketing_id
    or s.job_ticket_org_id <> c.job_ticket_org_id
    or  s.assignment_id <> c.assignment_id
    or s.assignment_effective_date <> c.assignment_effective_date
    or s.invoice_number <> c.invoice_number
    or s.statement_date <> c.statement_date
    or s.sent_date <> c.sent_date
    or s.ship_date <> c.ship_date
    or s.cover_type_desc <> c.cover_type_desc
  )
 and (c.payments_received <> 0
    or c.deposit_balance <> 0
    or c.invoice_subtotal <> 0
    or c.tax <> 0
    or c.sh_tax <> 0
    or c.freight <> 0
    or c.invoice_amount <> 0
    or c.invoice_pay_amount <> 0
    or c.recognition_amount <> 0
    or c.order_amount <> 0
    or c.invoiced_order_amount <> 0
    or c.balance_due <> 0
    or c.ar_balance_due <> 0
    or c.charges_to_territory <> 0
    or c.credits_to_territory <> 0
    or c.projected_commission <> 0
    or c.projected_net <> 0
    or c.comm_payable <> 0
    or c.comm_paid <> 0
    or c.adj_comm_paid <> 0
    or c.write_off_amount <> 0
    or c.refund_amount <> 0
    or c.pages <> 0
    or c.main_copies <> 0
    or c.extra_copies <> 0
    or c.returned_extra_copies <> 0
    or c.reorder_copies <> 0
    or c.rerun_copies <> 0
    or c.copy_qty <> 0
    or c.hard_cover_qty <> 0
    or c.soft_cover_qty <> 0
    or c.reorder_hard_cover_qty <> 0
    or c.reorder_soft_cover_qty <> 0
    or c.rerun_hard_cover_qty <> 0
    or c.rerun_soft_cover_qty <> 0
    or c.extra_hard_cover_qty <> 0
    or c.extra_soft_cover_qty <> 0
    or c.return_hard_cover_qty <> 0
    or c.return_soft_cover_qty <> 0
    or c.non_extra_copy_subtotal <> 0
    or c.non_extra_copy_adj <> 0
    or c.extra_copy_subtotal <> 0
    or c.extra_copy_adj <> 0
    or c.extra_copy_recognized <> 0
    or c.extra_copy_recognizable <> 0
    or c.contra_product <> 0
    or c.contra_tax <> 0
    or c.contra_commission <> 0
    or c.contra_chr_bck <> 0
    or c.commission_liability <> 0
    or c.recognized_commission <> 0
    or c.commission_payable <> 0
)





&


/*-----------------------------------------------*/
/* TASK No. 36 */
/* insert stage2 NEW records */

insert into rax_app_user.yearbook_stage2
(
record_status
, yearbook_curr_id
, account_id
, apo_id
, job_nbr
, marketing_id
, job_ticket_org_id
, assignment_id
, assignment_effective_date
, invoice_number
, statement_date
, sent_date
, ship_date
, payments_received
, deposit_balance
, invoice_subtotal
, tax
, sh_tax
, freight
, invoice_amount
, invoice_pay_amount
, recognition_amount
, order_amount
, invoiced_order_amount
, balance_due
, ar_balance_due
, charges_to_territory
, credits_to_territory
, projected_commission
, projected_net
, comm_payable
, comm_paid
, adj_comm_paid
, write_off_amount
, refund_amount
, pages
, main_copies
, extra_copies
, returned_extra_copies
, reorder_copies
, rerun_copies
, copy_qty
, hard_cover_qty
, soft_cover_qty
, cover_type_desc
, reorder_hard_cover_qty
, reorder_soft_cover_qty
, rerun_hard_cover_qty
, rerun_soft_cover_qty
, extra_hard_cover_qty
, extra_soft_cover_qty
, return_hard_cover_qty
, return_soft_cover_qty
, non_extra_copy_subtotal
, non_extra_copy_adj
, extra_copy_subtotal
, extra_copy_adj
, extra_copy_recognized
, extra_copy_recognizable
, contra_product
, contra_tax
, contra_commission
, contra_chr_bck
, commission_liability
, recognized_commission
, commission_payable
, trans_date
)
select 'NEW'   
,  ods_stage.yearbook_curr_id_seq.nextval  
, s.account_id
, s.apo_id
, s.job_nbr
, s.marketing_id
, s.job_ticket_org_id
, s.assignment_id
, s.assignment_effective_date
, s.invoice_number
, s.statement_date
, s.sent_date
, s.ship_date
, s.payments_received
, s.deposit_balance
, s.invoice_subtotal
, s.tax
, s.sh_tax
, s.freight
, s.invoice_amount
, s.invoice_pay_amount
, s.recognition_amount
, s.order_amount
, s.invoiced_order_amount
, s.balance_due
, s.ar_balance_due
, s.charges_to_territory
, s.credits_to_territory
, s.projected_commission
, s.projected_net
, s.comm_payable
, s.comm_paid
, s.adj_comm_paid
, s.write_off_amount
, s.refund_amount
, s.pages
, s.main_copies
, s.extra_copies
, s.returned_extra_copies
, s.reorder_copies
, s.rerun_copies
, s.copy_qty
, s.hard_cover_qty
, s.soft_cover_qty
, s.cover_type_desc
, s.reorder_hard_cover_qty
, s.reorder_soft_cover_qty
, s.rerun_hard_cover_qty
, s.rerun_soft_cover_qty
, s.extra_hard_cover_qty
, s.extra_soft_cover_qty
, s.return_hard_cover_qty
, s.return_soft_cover_qty
, s.non_extra_copy_subtotal
, s.non_extra_copy_adj
, s.extra_copy_subtotal
, s.extra_copy_adj
, s.extra_copy_recognized
, s.extra_copy_recognizable
, s.contra_product
, s.contra_tax
, s.contra_commission
, s.contra_chr_bck
, s.commission_liability
, s.recognized_commission
, s.commission_payable
, s.trans_date
from  rax_app_user.yearbook_stage s
where not exists (
  select 1 from ods_stage.yearbook_curr c
  where 1=1
    and s.job_nbr = c.job_nbr
    and s.account_id = c.account_id
    and s.apo_id = c.apo_id
    and s.marketing_id = c.marketing_id
    and s.job_ticket_org_id = c.job_ticket_org_id
    and  s.assignment_id = c.assignment_id
    and s.assignment_effective_date = c.assignment_effective_date
    and s.invoice_number = c.invoice_number
    and s.statement_date = c.statement_date
    and s.ship_date = c.ship_date
    and s.sent_date = c.sent_date
    and s.cover_type_desc  = c.cover_type_desc
 )

&


/*-----------------------------------------------*/
/* TASK No. 37 */
/* insert stage2 UPD records */

insert into rax_app_user.yearbook_stage2
(
record_status
, yearbook_curr_id
, account_id
, apo_id
, job_nbr
, marketing_id
, job_ticket_org_id
, assignment_id
, assignment_effective_date
, invoice_number
, statement_date
, sent_date
, ship_date
, payments_received
, deposit_balance
, invoice_subtotal
, tax
, sh_tax
, freight
, invoice_amount
, invoice_pay_amount
, recognition_amount
, order_amount
, invoiced_order_amount
, balance_due
, ar_balance_due
, charges_to_territory
, credits_to_territory
, projected_commission
, projected_net
, comm_payable
, comm_paid
, adj_comm_paid
, write_off_amount
, refund_amount
, pages
, main_copies
, extra_copies
, returned_extra_copies
, reorder_copies
, rerun_copies
, copy_qty
, hard_cover_qty
, soft_cover_qty
, cover_type_desc
, reorder_hard_cover_qty
, reorder_soft_cover_qty
, rerun_hard_cover_qty
, rerun_soft_cover_qty
, extra_hard_cover_qty
, extra_soft_cover_qty
, return_hard_cover_qty
, return_soft_cover_qty
, non_extra_copy_subtotal
, non_extra_copy_adj
, extra_copy_subtotal
, extra_copy_adj
, extra_copy_recognized
, extra_copy_recognizable
, contra_product
, contra_tax
, contra_commission
, contra_chr_bck
, commission_liability
, recognized_commission
, commission_payable
, trans_date
)
select 'UPD'   
, c.yearbook_curr_id
, s.account_id
, s.apo_id
, s.job_nbr
, s.marketing_id
, s.job_ticket_org_id
, s.assignment_id
, s.assignment_effective_date
, s.invoice_number
, s.statement_date
, s.sent_date
, s.ship_date
, s.payments_received
, s.deposit_balance
, s.invoice_subtotal
, s.tax
, s.sh_tax
, s.freight
, s.invoice_amount
, s.invoice_pay_amount
, s.recognition_amount
, s.order_amount
, s.invoiced_order_amount
, s.balance_due
, s.ar_balance_due
, s.charges_to_territory
, s.credits_to_territory
, s.projected_commission
, s.projected_net
, s.comm_payable
, s.comm_paid
, s.adj_comm_paid
, s.write_off_amount
, s.refund_amount
, s.pages
, s.main_copies
, s.extra_copies
, s.returned_extra_copies
, s.reorder_copies
, s.rerun_copies
, s.copy_qty
, s.hard_cover_qty
, s.soft_cover_qty
, s.cover_type_desc
, s.reorder_hard_cover_qty
, s.reorder_soft_cover_qty
, s.rerun_hard_cover_qty
, s.rerun_soft_cover_qty
, s.extra_hard_cover_qty
, s.extra_soft_cover_qty
, s.return_hard_cover_qty
, s.return_soft_cover_qty
, s.non_extra_copy_subtotal
, s.non_extra_copy_adj
, s.extra_copy_subtotal
, s.extra_copy_adj
, s.extra_copy_recognized
, s.extra_copy_recognizable
, s.contra_product
, s.contra_tax
, s.contra_commission
, s.contra_chr_bck
, s.commission_liability
, s.recognized_commission
, s.commission_payable
, s.trans_date
from  rax_app_user.yearbook_stage s
, ods_stage.yearbook_curr c
where 1=1
and s.job_nbr = c.job_nbr
and s.account_id = c.account_id
and s.apo_id = c.apo_id
and s.marketing_id = c.marketing_id
and s.job_ticket_org_id = c.job_ticket_org_id
and  s.assignment_id = c.assignment_id
and s.assignment_effective_date = c.assignment_effective_date
and s.invoice_number = c.invoice_number
and s.statement_date = c.statement_date
and s.sent_date = c.sent_date
and s.ship_date = c.ship_date
and s.cover_type_desc = c.cover_type_desc
and (s.payments_received <> c.payments_received
    or s.deposit_balance <> c.deposit_balance
    or s.invoice_subtotal <> c.invoice_subtotal
    or s.tax <> c.tax
    or s.sh_tax <> c.sh_tax
    or s.freight <> c.freight
    or s.invoice_amount <> c.invoice_amount
    or s.invoice_pay_amount <> c.invoice_pay_amount
    or s.recognition_amount <> c.recognition_amount
    or s.order_amount <> c.order_amount
    or s.invoiced_order_amount <> c.invoiced_order_amount
    or s.balance_due <> c.balance_due
    or s.ar_balance_due <> c.ar_balance_due
    or s.charges_to_territory <> c.charges_to_territory
    or s.credits_to_territory <> c.credits_to_territory
    or s.projected_commission <> c.projected_commission 
    or s.projected_net <> c.projected_net 
    or s.comm_payable <> c.comm_payable
    or s.comm_paid <> c.comm_paid
    or s.adj_comm_paid <> c.adj_comm_paid
    or s.write_off_amount <> c.write_off_amount 
    or s.refund_amount <> c.refund_amount 
    or s.pages <> c.pages
    or s.main_copies <> c.main_copies
    or s.extra_copies <> c.extra_copies
    or s.returned_extra_copies <> c.returned_extra_copies
    or s.reorder_copies <> c.reorder_copies 
    or s.RERUN_COPIES <> c.RERUN_COPIES
    or s.copy_qty <> c.copy_qty
    or s.hard_cover_qty <> c.hard_cover_qty
    or s.soft_cover_qty <> c.soft_cover_qty
    or s.reorder_hard_cover_qty <> c.reorder_hard_cover_qty
    or s.reorder_soft_cover_qty <> c.reorder_soft_cover_qty
    or s.rerun_hard_cover_qty <> c.rerun_hard_cover_qty
    or s.rerun_soft_cover_qty <> c.rerun_soft_cover_qty
    or s.extra_hard_cover_qty <> c.extra_hard_cover_qty
    or s.extra_soft_cover_qty <> c.extra_soft_cover_qty
    or s.return_hard_cover_qty <> c.return_hard_cover_qty
    or s.return_soft_cover_qty <> c.return_soft_cover_qty
    or s.non_extra_copy_subtotal <> c.non_extra_copy_subtotal
    or s.non_extra_copy_adj <> c.non_extra_copy_adj
    or s.extra_copy_subtotal <> c.extra_copy_subtotal 
    or s.extra_copy_adj <> c.extra_copy_adj 
    or s.extra_copy_recognized <> c.extra_copy_recognized
    or s.extra_copy_recognizable <> c.extra_copy_recognizable
    or s.contra_product <> c.contra_product
    or s.contra_tax <> c.contra_tax 
    or s.contra_commission <> c.contra_commission
    or s.contra_chr_bck <> c.contra_chr_bck
    or s.commission_liability <> c.commission_liability
    or s.recognized_commission <> c.recognized_commission
    or s.commission_payable <> c.commission_payable
)

&


/*-----------------------------------------------*/
/* TASK No. 38 */
/* Load new into fact */

insert into mart.yearbook_fact 
(
 yearbook_fact_id
, account_id
, apo_id
, job_nbr
, marketing_id 
, job_ticket_org_id 
, assignment_id
, assignment_effective_date 
, invoice_number 
, statement_date 
, sent_date 
, ship_date 
, payments_received
, deposit_balance
, invoice_subtotal 
, tax 
, sh_tax 
, freight 
, invoice_amount 
, invoice_pay_amount 
, recognition_amount 
, order_amount 
, invoiced_order_amount 
, balance_due 
, ar_balance_due
, charges_to_territory 
, credits_to_territory 
, projected_commission 
, projected_net 
, comm_payable
, comm_paid
, adj_comm_paid 
, write_off_amount 
, refund_amount
, pages 
, main_copies 
, extra_copies 
, returned_extra_copies 
, reorder_copies
, rerun_copies
, copy_qty 
, hard_cover_qty 
, soft_cover_qty 
, cover_type_desc 
, reorder_hard_cover_qty
, reorder_soft_cover_qty
, rerun_hard_cover_qty
, rerun_soft_cover_qty
, extra_hard_cover_qty
, extra_soft_cover_qty
, return_hard_cover_qty
, return_soft_cover_qty
, non_extra_copy_subtotal 
, non_extra_copy_adj 
, extra_copy_subtotal 
, extra_copy_adj 
, extra_copy_recognized 
, extra_copy_recognizable 
, contra_product
, contra_tax 
, contra_commission 
, contra_chr_bck 
, commission_liability 
, recognized_commission 
, commission_payable 
, trans_date
)
select mart.yearbook_fact_id_seq.nextval
, s.account_id
, s.apo_id
, s.job_nbr
, s.marketing_id 
, s.job_ticket_org_id 
, s.assignment_id
, s.assignment_effective_date 
, s.invoice_number 
, s.statement_date
, s.sent_date
, s.ship_date
, s.payments_received
, s.deposit_balance
, s.invoice_subtotal 
, s.tax 
, s.sh_tax 
, s.freight 
, s.invoice_amount 
, s.invoice_pay_amount 
, s.recognition_amount 
, s.order_amount 
, s.invoiced_order_amount 
, s.balance_due 
, s.ar_balance_due 
, s.charges_to_territory 
, s.credits_to_territory 
, s.projected_commission 
, s.projected_net 
, s.comm_payable
, s.comm_paid
, s.adj_comm_paid 
, s.write_off_amount 
, s.refund_amount
, s.pages 
, s.main_copies 
, s.extra_copies 
, s.returned_extra_copies 
, s.reorder_copies
, s.rerun_copies
, s.copy_qty 
, s.hard_cover_qty 
, s.soft_cover_qty 
, s.cover_type_desc
, s.reorder_hard_cover_qty
, s.reorder_soft_cover_qty
, s.rerun_hard_cover_qty
, s.rerun_soft_cover_qty
, s.extra_hard_cover_qty
, s.extra_soft_cover_qty
, s.return_hard_cover_qty
, s.return_soft_cover_qty 
, s.non_extra_copy_subtotal 
, s.non_extra_copy_adj 
, s.extra_copy_subtotal 
, s.extra_copy_adj 
, s.extra_copy_recognized 
, s.extra_copy_recognizable 
, s.contra_product
, s.contra_tax 
, s.contra_commission 
, s.contra_chr_bck 
, s.commission_liability 
, s.recognized_commission 
, s.commission_payable 
, s.trans_date 
from rax_app_user.yearbook_stage2 s
where RECORD_STATUS in ('NEW')

&


/*-----------------------------------------------*/
/* TASK No. 39 */
/* Load new into curr */

insert into ods_stage.yearbook_curr
(
 yearbook_curr_id
, account_id
, apo_id
, job_nbr
, marketing_id 
, job_ticket_org_id 
, assignment_id
, assignment_effective_date 
, invoice_number 
, statement_date 
, sent_date 
, ship_date 
, payments_received
, deposit_balance
, invoice_subtotal 
, tax 
, sh_tax 
, freight 
, invoice_amount 
, invoice_pay_amount 
, recognition_amount 
, order_amount 
, invoiced_order_amount 
, balance_due 
, ar_balance_due
, charges_to_territory 
, credits_to_territory 
, projected_commission 
, projected_net 
, comm_payable
, comm_paid
, adj_comm_paid 
, write_off_amount 
, refund_amount
, pages 
, main_copies 
, extra_copies 
, returned_extra_copies 
, reorder_copies
, rerun_copies
, copy_qty 
, hard_cover_qty 
, soft_cover_qty 
, cover_type_desc 
, reorder_hard_cover_qty
, reorder_soft_cover_qty
, rerun_hard_cover_qty
, rerun_soft_cover_qty
, extra_hard_cover_qty
, extra_soft_cover_qty
, return_hard_cover_qty
, return_soft_cover_qty
, non_extra_copy_subtotal 
, non_extra_copy_adj 
, extra_copy_subtotal 
, extra_copy_adj 
, extra_copy_recognized 
, extra_copy_recognizable 
, contra_product
, contra_tax 
, contra_commission 
, contra_chr_bck 
, commission_liability 
, recognized_commission 
, commission_payable 
, trans_date
, create_date
, modify_date
)
select
 ods_stage.yearbook_curr_id_seq.nextval
, s.account_id
, s.apo_id
, s.job_nbr
, s.marketing_id 
, s.job_ticket_org_id 
, s.assignment_id
, s.assignment_effective_date 
, s.invoice_number 
, s.statement_date
, s.sent_date
, s.ship_date
, s.payments_received
, s.deposit_balance
, s.invoice_subtotal 
, s.tax 
, s.sh_tax 
, s.freight 
, s.invoice_amount 
, s.invoice_pay_amount 
, s.recognition_amount 
, s.order_amount 
, s.invoiced_order_amount 
, s.balance_due 
, s.ar_balance_due 
, s.charges_to_territory 
, s.credits_to_territory 
, s.projected_commission 
, s.projected_net 
, s.comm_payable
, s.comm_paid
, s.adj_comm_paid 
, s.write_off_amount 
, s.refund_amount
, s.pages 
, s.main_copies 
, s.extra_copies 
, s.returned_extra_copies 
, s.reorder_copies
, s.RERUN_COPIES
, s.copy_qty 
, s.hard_cover_qty 
, s.soft_cover_qty 
, s.cover_type_desc 
, s.reorder_hard_cover_qty
, s.reorder_soft_cover_qty
, s.rerun_hard_cover_qty
, s.rerun_soft_cover_qty
, s.extra_hard_cover_qty
, s.extra_soft_cover_qty
, s.return_hard_cover_qty
, s.return_soft_cover_qty
, s.non_extra_copy_subtotal 
, s.non_extra_copy_adj 
, s.extra_copy_subtotal 
, s.extra_copy_adj 
, s.extra_copy_recognized 
, s.extra_copy_recognizable 
, s.contra_product
, s.contra_tax 
, s.contra_commission 
, s.contra_chr_bck 
, s.commission_liability 
, s.recognized_commission 
, s.commission_payable 
, s.trans_date
, sysdate
, sysdate
from rax_app_user.yearbook_stage2 s
where s.RECORD_STATUS in ('NEW')

&


/*-----------------------------------------------*/
/* TASK No. 40 */
/* load UPD, DEL  into fact table */

insert into mart.yearbook_fact 
(
 yearbook_fact_id
, account_id
, apo_id
, job_nbr
, marketing_id 
, job_ticket_org_id 
, assignment_id
, assignment_effective_date 
, invoice_number 
, statement_date 
, sent_date 
, ship_date 
, payments_received
, deposit_balance
, invoice_subtotal 
, tax 
, sh_tax 
, freight 
, invoice_amount 
, invoice_pay_amount 
, recognition_amount 
, order_amount 
, invoiced_order_amount 
, balance_due 
, ar_balance_due
, charges_to_territory 
, credits_to_territory 
, projected_commission 
, projected_net 
, comm_payable
, comm_paid
, adj_comm_paid 
, write_off_amount 
, refund_amount
, pages 
, main_copies 
, extra_copies 
, returned_extra_copies 
, reorder_copies
, rerun_copies
, copy_qty 
, hard_cover_qty 
, soft_cover_qty 
, cover_type_desc 
, reorder_hard_cover_qty
, reorder_soft_cover_qty
, rerun_hard_cover_qty
, rerun_soft_cover_qty
, extra_hard_cover_qty
, extra_soft_cover_qty
, return_hard_cover_qty
, return_soft_cover_qty
, non_extra_copy_subtotal 
, non_extra_copy_adj 
, extra_copy_subtotal 
, extra_copy_adj 
, extra_copy_recognized 
, extra_copy_recognizable 
, contra_product
, contra_tax 
, contra_commission 
, contra_chr_bck 
, commission_liability 
, recognized_commission 
, commission_payable 
, trans_date
)
select mart.yearbook_fact_id_seq.nextval
, s.account_id
, s.apo_id
, s.job_nbr
, s.marketing_id 
, s.job_ticket_org_id 
, s.assignment_id
, s.assignment_effective_date 
, s.invoice_number 
, s.statement_date
, s.sent_date
, s.ship_date
, s.payments_received - c.payments_received
, s.deposit_balance - c.deposit_balance
, s.invoice_subtotal - c.invoice_subtotal
, s.tax  - c.tax
, s.sh_tax  - c.sh_tax
, s.freight  - c.freight
, s.invoice_amount  - c.invoice_amount
, s.invoice_pay_amount - c.invoice_pay_amount
, s.recognition_amount - c.recognition_amount
, s.order_amount - c.order_amount
, s.invoiced_order_amount - c.invoiced_order_amount
, s.balance_due - c.balance_due
, s.ar_balance_due - c.ar_balance_due
, s.charges_to_territory - c.charges_to_territory
, s.credits_to_territory - c.credits_to_territory
, s.projected_commission - c.projected_commission
, s.projected_net - c.projected_net
, s.comm_payable - c.comm_payable
, s.comm_paid - c.comm_paid
, s.adj_comm_paid - c.adj_comm_paid
, s.write_off_amount - c.write_off_amount
, s.refund_amount - c.refund_amount
, s.pages - c.pages
, s.main_copies - c.main_copies
, s.extra_copies -  c.extra_copies
, s.returned_extra_copies - c.returned_extra_copies
, s.reorder_copies - c.reorder_copies
, s.rerun_copies - c.rerun_copies
, s.copy_qty - c.copy_qty
, s.hard_cover_qty - c.hard_cover_qty
, s.soft_cover_qty - c.soft_cover_qty
, s.cover_type_desc 
, s.reorder_hard_cover_qty - c.reorder_hard_cover_qty
, s.reorder_soft_cover_qty - c.reorder_soft_cover_qty
, s.rerun_hard_cover_qty - c.rerun_hard_cover_qty
, s.rerun_soft_cover_qty - c.rerun_soft_cover_qty
, s.extra_hard_cover_qty - c.extra_hard_cover_qty
, s.extra_soft_cover_qty - c.extra_soft_cover_qty
, s.return_hard_cover_qty - c.return_hard_cover_qty
, s.return_soft_cover_qty - c.return_soft_cover_qty
, s.non_extra_copy_subtotal - c.non_extra_copy_subtotal
, s.non_extra_copy_adj - c.non_extra_copy_adj
, s.extra_copy_subtotal - c.extra_copy_subtotal
, s.extra_copy_adj - c.extra_copy_adj
, s.extra_copy_recognized - c.extra_copy_recognized
, s.extra_copy_recognizable - c.extra_copy_recognizable
, s.contra_product - c.contra_product
, s.contra_tax - c.contra_tax
, s.contra_commission - c.contra_commission
, s.contra_chr_bck - c.contra_chr_bck
, s.commission_liability - c.commission_liability
, s.recognized_commission - c.recognized_commission
, s.commission_payable - c.commission_payable
, s.trans_date 
from rax_app_user.yearbook_stage2 s
, ods_stage.yearbook_curr c
where s.RECORD_STATUS in ('UPD','DEL')
and s.yearbook_curr_id = c.yearbook_curr_id

&


/*-----------------------------------------------*/
/* TASK No. 41 */
/* merge UPD, DEL into curr */

merge into ods_stage.yearbook_curr c      
using (select * from rax_app_user.yearbook_stage2 where record_status in('UPD','DEL') ) s
 on ( s.yearbook_curr_id=c.yearbook_curr_id)                                                  
when matched then update                                                                            
set                                                                                            
    c.modify_date = sysdate
  , c.payments_received = s.payments_received
  , c.deposit_balance = s.deposit_balance
  , c.invoice_subtotal = s.invoice_subtotal
  , c.tax = s.tax
  , c.sh_tax = s.sh_tax
  , c.freight = s.freight
  , c.invoice_amount = s.invoice_amount
  , c.invoice_pay_amount = s.invoice_pay_amount
  , c.recognition_amount = s.recognition_amount
  , c.order_amount = s.order_amount
  , c.invoiced_order_amount= s.invoiced_order_amount
  , c.balance_due = s.balance_due
  , c.ar_balance_due = s.ar_balance_due
  , c.charges_to_territory = s.charges_to_territory
  , c.credits_to_territory = s.credits_to_territory
  , c.projected_commission = s.projected_commission
  , c.projected_net = s.projected_net
  , c.comm_payable = s.comm_payable
  , c.comm_paid = s.comm_paid
  , c.adj_comm_paid = s.adj_comm_paid
  , c.write_off_amount = s.write_off_amount
  , c.refund_amount = s.refund_amount
  , c.pages = s.pages
  , c.main_copies = s.main_copies
  , c.extra_copies = s.extra_copies
  , c.returned_extra_copies = s.returned_extra_copies
  , c.reorder_copies = s.reorder_copies
  , c.rerun_copies = s.rerun_copies
  , c.copy_qty = s.copy_qty
  , c.hard_cover_qty = s.hard_cover_qty
  , c.soft_cover_qty = s.soft_cover_qty 
  , c.reorder_hard_cover_qty = s.reorder_hard_cover_qty
  , c.reorder_soft_cover_qty = s.reorder_soft_cover_qty
  , c.rerun_hard_cover_qty = s.rerun_hard_cover_qty
  , c.rerun_soft_cover_qty = s.rerun_soft_cover_qty
  , c.extra_hard_cover_qty = s.extra_hard_cover_qty
  , c.extra_soft_cover_qty = s.extra_soft_cover_qty
  , c.return_hard_cover_qty = s.return_hard_cover_qty
  , c.return_soft_cover_qty = s.return_soft_cover_qty
  , c.non_extra_copy_subtotal = s.non_extra_copy_subtotal
  , c.non_extra_copy_adj = s.non_extra_copy_adj 
  , c.extra_copy_subtotal = s.extra_copy_subtotal 
  , c.extra_copy_adj = s.extra_copy_adj 
  , c.extra_copy_recognized = s.extra_copy_recognized 
  , c.extra_copy_recognizable = s.extra_copy_recognizable
  , c.contra_product = s.contra_product
  , c.contra_tax = s.contra_tax
  , c.contra_commission = s.contra_commission
  , c.contra_chr_bck = s.contra_chr_bck
  , c.commission_liability = s.commission_liability
  , c.recognized_commission = s.recognized_commission
  , c.commission_payable =s.commission_payable





&


/*-----------------------------------------------*/
/* TASK No. 42 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
+ nvl((TIMEZONE_OFFSET/24), 0) 
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

/*
UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/

&


/*-----------------------------------------------*/
/* TASK No. 43 */
/* Insert CDC Audit Record */

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
,'LOAD_YEARBOOK_FACT_PKG'
,'010'
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
'LOAD_YEARBOOK_FACT_PKG',
'010',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/


&


/*-----------------------------------------------*/
