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
/* drop temp_oh_order_bucket_driver */

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.TEMP_OH_ORDER_BUCKET_DRIVER';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* CDC for order_line */

create table RAX_APP_USER.TEMP_OH_ORDER_BUCKET_DRIVER  as
select distinct ol.order_header_oid
from ODS_OWN.order_line   ol
where ol.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* create index temp_oh_order_bucket_driver */

create unique index RAX_APP_USER.TEMP_OH_ORDER_BUCKET_DRIVER_PK 
   on RAX_APP_USER.TEMP_OH_ORDER_BUCKET_DRIVER (order_header_oid)


&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* CDC for order_header */

insert into RAX_APP_USER.TEMP_OH_ORDER_BUCKET_DRIVER (order_header_oid)
select distinct oh.order_header_oid
from ODS_OWN.ORDER_HEADER   oh
where (1=1) 
    and oh.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
    and not exists (select 1 from RAX_APP_USER.TEMP_OH_ORDER_BUCKET_DRIVER  z where z.order_header_oid = oh.order_header_oid)


&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* drop tmp_false_unpaid */

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_false_unpaid';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* create tmp_false_unpaid */

create table RAX_APP_USER.tmp_false_unpaid as
select oh.order_header_oid
from ODS_OWN.order_header oh
, ODS_OWN.source_system ss
, RAX_APP_USER.TEMP_OH_ORDER_BUCKET_DRIVER  z 
where 1=1
and z.order_header_oid = oh.order_header_oid
and oh.source_system_oid = ss.source_system_oid
and ss.source_system_short_name = 'OMS'
and oh.total_amount = 0
and oh.order_type in ('Additional_Order','Book','Bulk_Order','Bulk_ReOrder','Bulk_Retake','Customer_Order'
                     ,'Extra_Book','Missing_Order','Spec_Order','Staff_Order','Supplement','Solo_Cart') 
and oh.order_date > to_date('20170607','YYYYMMDD') -- do not want to mess with orders that were wrong before this was coded
and not exists
(
select 1
from ODS_OWN.order_line ol
, ODS_OWN.item i
where oh.order_header_oid = ol.order_header_oid
and ol.item_oid = i.item_oid
and (  ol.list_price > 0
    or i.tax_product_code = 'ELECIMAGES'
    or i.sku_category = 'PACKAGE'
    or ol.package_ref not like 'S%'
    )
)

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* index tmp_false_unpaid */

create unique index RAX_APP_USER.tmp_false_unpaid_pk on RAX_APP_USER.tmp_false_unpaid(order_header_oid)

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* update order_header.order_bucket */

merge into    ODS_OWN.ORDER_HEADER   T
using
    (
    select
        o.order_header_oid
        ,case
            when o.ordered_quantity = 0 then 'CANCELLED'
            when o.order_type in ('Solo_Cart') then 'CART'
            when o.total_amount > 0 then 'PAID'
            when (o.order_type in ('Bulk_Order_X','Proof_Order') or o.false_unpaid = 'Y')  then 'X'
            when o.order_type in ('Additional_Order','Book','Bulk_Order','Bulk_ReOrder','Bulk_Retake','Customer_Order'
                                   ,'Extra_Book','Missing_Order','Spec_Order','Staff_Order','Supplement','YBYearbook_Order',
                                   'YBCompliment_Order','YBExtraBkSpec_Order','YBIncentive_Order','YBReorder_Order',
                                   'YBSupplemental_Order','YBRerun_Order') then 'UNPAID'
            else 'SERVICE'
         end as new_order_bucket
    from
        (select
            oh.order_header_oid
            , sum(oh.total_amount) total_amount
            , oh.order_type
            , oh.order_bucket
            , sum(nvl(ol.ordered_quantity,0)) ordered_quantity
            , max(case when tfu.order_header_oid is not null then 'Y' else 'N' end) as false_unpaid
        from
            ODS_OWN.ORDER_LINE   ol
            , ODS_OWN.ORDER_HEADER  oh
            , ODS_OWN.SOURCE_SYSTEM  ss
            , RAX_APP_USER.tmp_false_unpaid tfu
            , RAX_APP_USER.TEMP_OH_ORDER_BUCKET_DRIVER  d
        where (1=1)
            and ol.ORDER_HEADER_OID(+) = oh.ORDER_HEADER_OID
            and oh.source_system_oid = ss.source_system_oid
            and ss.SOURCE_SYSTEM_SHORT_NAME not in ('ODS')
            and oh.order_header_oid = d.order_header_oid
            and oh.order_header_oid = tfu.order_header_oid(+)
        group by 
            oh.order_header_oid
            , oh.order_type
            , oh.order_bucket
        ) o
    where
        nvl(o.ORDER_BUCKET,'1') <>
        case
            when o.ordered_quantity = 0 then 'CANCELLED'
            when o.order_type in ('Solo_Cart') then 'CART'
            when o.total_amount > 0 then 'PAID'
            when (o.order_type in ('Bulk_Order_X','Proof_Order') or o.false_unpaid = 'Y')  then 'X'
            when o.order_type in ('Additional_Order','Book','Bulk_Order','Bulk_ReOrder','Bulk_Retake','Customer_Order'
                                   ,'Extra_Book','Missing_Order','Spec_Order','Staff_Order','Supplement','YBYearbook_Order',
                                   'YBCompliment_Order','YBExtraBkSpec_Order','YBIncentive_Order','YBReorder_Order',
                                   'YBSupplemental_Order','YBRerun_Order') then 'UNPAID'
            else 'SERVICE'
         end
     ) S
on    (
        T.order_header_oid=S.order_header_oid
    )
when matched
then update set
    T.order_bucket = S.new_order_bucket
   ,T.ODS_MODIFY_DATE = SYSDATE

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* create false_unpaid */

BEGIN  
   EXECUTE IMMEDIATE 'create table RAX_APP_USER.false_unpaid ( order_header_oid number, ods_create_date date, ods_modify_date date)';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -955 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* index false_unpaid */

BEGIN  
   EXECUTE IMMEDIATE 'create unique index RAX_APP_USER.false_unpaid_pk on RAX_APP_USER.false_unpaid(order_header_oid)';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -955 and SQLCODE != -01408 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* index false_unpaid2 */

BEGIN  
   EXECUTE IMMEDIATE 'create index RAX_APP_USER.false_unpaid_ix1 on RAX_APP_USER.false_unpaid(ods_create_date)';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -955 and SQLCODE != -01408 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* merge false_unpaid */

merge into RAX_APP_USER.false_unpaid t
using (select order_header_oid from RAX_APP_USER.tmp_false_unpaid) s
on (t.order_header_oid = s.order_header_oid)
when matched then update
set t.ods_modify_date = sysdate
when not matched then insert
( t.order_header_oid
, t.ods_create_date
, t.ods_modify_date
)
values
( s.order_header_oid
, sysdate
, sysdate
)


&


/*-----------------------------------------------*/
/* TASK No. 16 */
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
/* TASK No. 17 */
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
,'UPDATE_OH_ORDER_BUCKET_PKG'
,'021'
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
'UPDATE_OH_ORDER_BUCKET_PKG',
'021',
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
