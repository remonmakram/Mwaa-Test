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
/* Drop Order Header to process driver table */

-- drop table RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER1
BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER1';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Create Order Header to process driver table */

create table  RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER1
as
select 
   order_header_oid
from ODS_OWN.ORDER_HEADER  oh
where oh.source_system_oid=2   /* only process OMS Underclass  */
and oh.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap


&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Add Order Headers from updated order_line to driver table */

insert into RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER1
(order_header_oid
)
select distinct ol.order_header_oid
from ODS_OWN.ORDER_LINE    ol
        ,RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER1  b
where ol.source_system_oid=2  /*  only process OMS Underclass  */
and ol.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
and ol.order_header_oid=b.order_header_oid(+)
and b.order_header_oid is null

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Add Order Headers from matched_sales_recognition to driver table */

insert into RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER1
(order_header_oid
)
select distinct msr.order_header_oid
from ODS_OWN.MATCHED_SALES_RECOGNITION   msr
        ,ODS_OWN.ORDER_HEADER   oh
        ,RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER1   b
where oh.order_header_oid=msr.order_header_oid
and oh.source_system_oid=2   /*  only process OMS Underclass  */
and msr.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
and msr.order_header_oid=b.order_header_oid(+)
and b.order_header_oid is null

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Add Order Headers based on modified header_charge to driver table */

insert into RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER1
(order_header_oid
)
select distinct hc.order_header_oid
from ODS_OWN.HEADER_CHARGE   hc
        ,ODS_OWN.ORDER_HEADER   oh
        ,RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER1   b
where oh.order_header_oid=hc.order_header_oid
and oh.source_system_oid=2   /*  only process OMS Underclass  */
and hc.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
and hc.order_header_oid=b.order_header_oid(+)
and b.order_header_oid is null

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Create unique index on driver table */

create unique index RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER1_IX1
  on RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER1(order_header_oid)
compute statistics

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Drop matched_sales_recognition driver table */

-- drop table RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER2_MSR
BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER2_MSR';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Figure out tax on matched_sales_recognitions */

create table RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER2_MSR
as
select d.order_header_oid
        ,sum(msr.sales_tax_amount)   msr_sales_tax_amt
        ,max(case when msr.order_header_oid is not null then 'Y' else 'N' end) as matched_tax_exists
from RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER1   d
      ,ODS_OWN.MATCHED_SALES_RECOGNITION   msr
where d.order_header_oid=msr.order_header_oid
group by d.order_header_oid

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* drop order_line tax driver table now */

-- drop table RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER2_OL
BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER2_OL';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Create Order Line tax driver table now */

create table RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER2_OL
as
select d.order_header_oid
        ,sum(ol.est_tax_amount)   ol_sales_tax_amt
from RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER1   d
      ,ODS_OWN.ORDER_LINE  ol
where d.order_header_oid=ol.order_header_oid
group by d.order_header_oid

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* drop header charge tax driver table now */

-- drop table RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER2_HC
BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER2_HC';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Create header charge driver table now */

create table RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER2_HC
as
select d.order_header_oid
        ,sum(hc.est_tax_amount)   hc_sales_tax_amt
from RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER1   d
      ,ODS_OWN.HEADER_CHARGE   hc
where d.order_header_oid=hc.order_header_oid
group by d.order_header_oid

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* DROP FINAL DRIVER TABLE */

-- DROP TABLE RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER3 
BEGIN
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER3';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Create final driver table for update to order_header */

create table RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER3 
as
select  d.order_header_oid
            ,oh.tax     as orig_oh_tax_amt
            ,case when msr.matched_tax_exists='Y' then nvl(msr.msr_sales_tax_amt,0) else (nvl(ol.ol_sales_tax_amt,0) + nvl(hc.hc_sales_tax_amt,0)) end as new_oh_tax_amt
            ,hc.hc_sales_tax_amt  as hc_sales_tax_amt
           ,ol.ol_sales_tax_amt as ol_sales_tax_amt
          ,msr.msr_sales_tax_amt as msr_sales_tax_amt
   from ODS_OWN.ORDER_HEADER  oh
          ,RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER1   d
          ,RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER2_MSR   msr
          ,RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER2_OL   ol
          ,RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER2_HC hc
  where oh.order_header_oid=d.order_header_oid
      and d.order_header_oid=msr.order_header_oid(+)
      and d.order_header_oid=ol.order_header_oid(+)
      and d.order_header_oid=hc.order_header_oid(+)



&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Create unique index */

create unique index RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER3_IX1
  on RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER3(order_header_oid)
compute statistics

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Update Order Header tax amount */

update 
  ( select oh.tax     as old_tax_amt
            ,oh.ods_modify_date as old_ods_modify_date
            ,d.new_oh_tax_amt  as new_tax_amt
            ,sysdate as new_ods_modify_date
   from ODS_OWN.ORDER_HEADER  oh
          ,RAX_APP_USER.TMP_SRM_OH_TAX_DRIVER3   d
  where oh.order_header_oid=d.order_header_oid
  and nvl(oh.tax,-111111111)   <> nvl(d.new_oh_tax_amt,-111111111)
  )
set old_tax_amt=new_tax_amt
,  old_ods_modify_date=new_ods_modify_date

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name


&


/*-----------------------------------------------*/
