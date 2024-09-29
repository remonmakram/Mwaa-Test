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
/* drop temp table1 */


BEGIN  
   EXECUTE IMMEDIATE 'drop table tmp_payonly_order_promo';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  


&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* create temp table1 */

create table tmp_payonly_order_promo 
(
   order_id number,
   item_oid number,
   job_number varchar2(10),
   amount number,
   promotion_code varchar2(255), 
   coupon_code varchar2(255)
)


&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* insert into temp table1 */

insert into tmp_payonly_order_promo 
(
   order_id
   ,item_oid
   ,job_number
   ,amount
   ,promotion_code
   ,coupon_code
)
select order_id, item_oid, job_number, amount, promotion_code, coupon_code
from (
            select mo.order_id, null as item_oid, mo.job_number, p.amount, p.promotion_code, p.coupon_code 
            from ODS.mlt_mlt_order_curr mo
             , ODS.mlt_order_promotions_curr op
            , ODS_STAGE.mlt_promotion_stg p
             where mo.effective_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')                          -:v_cdc_overlap
             and mo.selling_method_name = 'SPEC'
             and mo.order_id = op.order_id
             and op.promotion_id = p.promotion_id
             union
             select ol.order_id, item.item_oid, mo.job_number, p.amount, p.promotion_code, p.coupon_code
             from ODS.mlt_mlt_order_curr mo
             , ODS.mlt_order_line_curr ol
             , ODS.mlt_order_line_promos_curr op
             , ODS_STAGE.mlt_promotion_stg p
              , ODS_OWN.item item
              where mo.effective_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')                           -:v_cdc_overlap
              and mo.selling_method_name = 'SPEC'
              and mo.order_id = ol.order_id
              and ol.order_line_id = op.order_line_id
              and op.promotion_id = p.promotion_id
              and ol.sku_code = item.item_id(+)
) s


&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* index temp table1 */

create unique index tmp_payonly_order_promo_ix on 
tmp_payonly_order_promo(order_id, item_oid, promotion_code, coupon_code)

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* drop temp table2 */


BEGIN  
   EXECUTE IMMEDIATE 'drop table tmp_payonly_order_promo2';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  


&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* create temp table2 */

create table tmp_payonly_order_promo2
as
select 
    ep.event_payment_oid, mo.order_id
from 
 tmp_payonly_order_promo p
, ODS_OWN.event_payment ep
, ODS_OWN.event e
, ODS_STAGE.wc_event_payment_xr2 epxr
, ODS_STAGE.wc_bank_entry_stg be
, ODS.mlt_mlt_order_curr mo
where 1=1
and ep.event_oid = e.event_oid
and ep.event_payment_oid = epxr.event_payment_oid
and epxr.bank_entry_id = be.bank_entry_id
and regexp_replace(regexp_replace(be.source_system_key, '-.*'),'[^0-9]') = mo.order_id
and e.event_ref_id = p.job_number
and mo.order_id = p.order_id
group by ep.event_payment_oid, mo.order_id


&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* index temp table2 */

create unique index tmp_payonly_order_promo2_idx on 
tmp_payonly_order_promo2(event_payment_oid, order_id)

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* merge into ods_own.payonly_order_promotion */

merge into ODS_OWN.payonly_order_promotion t
using
(
   select p.order_id, p.item_oid, p2.event_payment_oid, p.amount as discount_amt, p.promotion_code, p.coupon_code
   from tmp_payonly_order_promo p
   , tmp_payonly_order_promo2 p2 
   where p.order_id = p2.order_id   	
) s
on (s.event_payment_oid = t.event_payment_oid and nvl(s.item_oid, -1) = nvl(t.item_oid, -1) and s.promotion_code = t.promotion_code and s.coupon_code = t.coupon_code)
when matched then update
set t.discount_amt = s.discount_amt,
ods_modify_date = sysdate
where decode(t.discount_amt,s.discount_amt,1,0) = 0
when not matched then insert
(
  t.payonly_order_promotion_oid
, t.event_payment_oid
, t.item_oid
, t.discount_amt
, t.promotion_code
, t.coupon_code
, t.ods_create_date
, t.ods_modify_date
)
values
(
  ODS_OWN.payonly_order_promotion_seq.nextval
, s.event_payment_oid
, s.item_oid
, s.discount_amt
, s.promotion_code
, s.coupon_code
, sysdate
, sysdate
)




&


/*-----------------------------------------------*/
/* TASK No. 12 */
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
/* TASK No. 13 */
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
,'LOAD_PAYONLY_ORDER_PROMOTION_PKG'
,'001'
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
'LOAD_PAYONLY_ORDER_PROMOTION_PKG',
'001',
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
