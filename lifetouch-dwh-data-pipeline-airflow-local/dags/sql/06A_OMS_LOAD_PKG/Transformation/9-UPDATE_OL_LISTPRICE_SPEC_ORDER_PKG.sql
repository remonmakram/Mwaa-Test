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
/* Update price on ORDER_LINES */

--merge into ODS_OWN.ORDER_LINE OL
--using
--  ( Select olnew.order_line_oid,
--    olnew.list_price,
--    olnew.unit_price,
--    olnew.line_total
--    from
--  (Select    /*+ parallel(ol2,8) parallel(oh,8) */
--   ol2.order_line_oid as order_line_oid,
--   psk.amount as list_price,
--   psk.amount as unit_price,
--   psk.amount * ol2.ordered_quantity as line_total
--   from ods_own.order_line ol2
--   , ods_own.order_header oh
--   , ods_own.item i
--   , ods_own.price_program pp
--   , ods_own.pp_price_set pps
--   , ods_own.price_set ps
--   , ods_own.price_set_sku psk
--   , ods_own.stock_keeping_unit sku
--   , ods_own.event e
--   , (select distinct ol.order_header_oid
--        from ods_own.order_line ol
--        where ol.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap)  driver
--   where 
--   OH.ORDER_HEADER_OID = driver.ORDER_HEADER_OID
--   and ol2.order_header_oid = oh.order_header_oid
--   and i.item_oid = ol2.item_oid 
--   and pp.price_program_oid = oh.price_program_oid
--   and pps.price_program_oid = pp.price_program_oid
--   and ps.price_set_oid = pps.price_set_oid
--   and ps.price_set_oid = psk.price_set_oid
--   and i.item_id = sku.sku_code
--   and e.event_oid = oh.event_oid
--   and e.selling_method = 'Spec'
--   and oh.order_type in ('Spec_Order','Missing_Order')
--   and not exists (select 1
--      from ods_own.price_set_sku psk2
--      where psk2.price_set_oid = psk.price_set_oid
--      and psk2.stock_keeping_unit_oid = psk.stock_keeping_unit_oid
--      and psk2.ods_create_date > psk.ods_create_date)
--   and sku.stock_keeping_unit_oid = psk.stock_keeping_unit_oid
--   and psk.channel like '%PAPER%'
--   -- and oL2.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap 
--   ) olnew,
--   ODS_OWN.ORDER_LINE OL3
--   where olnew.order_line_oid = ol3.order_line_oid
--   and ol3.unit_price != olnew.unit_price
--   ) source
--on (
--             ol.order_line_oid = source.order_line_oid
--   )
--when matched
--then update set
--   ol.list_price = source.list_price,
--   ol.unit_price = source.unit_price,
--   ol.line_total = source.line_total,
--   ol.ods_modify_date = sysdate



/*-----------------------------------------------*/
/* TASK No. 5 */
/* Update order total ORDER_HEADER */

--merge into ods_own.order_header T
--using
--(Select
--   oh.order_header_oid,
--   oh.total_amount,
--   Sum(ol.line_total) as new_total_amount
--from 
--    ods_own.order_line ol
--    ,ods_own.order_header oh
--where 
--    ol.order_header_oid = oh.order_header_oid
--    and oh.order_type in ('Spec_Order','Missing_Order')
--    and oh.event_oid in (select e.event_oid
--        from ods_own.event e
--        where e.event_oid = oh.event_oid
--        and e.selling_method = 'Spec')
--    and oh.order_header_oid in (select ol2.order_header_oid
--        from ods_own.order_line ol2
--        where ol2.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap )
--group by 
--    oh.order_header_oid,oh.total_amount
--having
--    oh.total_amount <> Sum(ol.line_total)
--) S
--on ( T.order_header_oid = S.order_header_oid)
--when matched then update
--set
--    T.total_amount = S.new_total_amount
--    ,T.ods_modify_date = sysdate


/*-----------------------------------------------*/
/* TASK No. 6 */
/* old Update price on ORDER_LINES */

--update ods_own.order_line ol1
--set (ol1.list_price, ol1.unit_price, ol1.line_total, ol1.ods_modify_date) =
--  (Select
--   psk.amount as list_price,
--   psk.amount as unit_price,
--   psk.amount * ol2.ordered_quantity as line_total,
--   sysdate as ods_modify_date
--   from ods_own.order_line ol2
--   , ods_own.order_header oh
--   , ods_own.item i
--   , ods_own.price_program pp
--   , ods_own.pp_price_set pps
--   , ods_own.price_set ps
--   , ods_own.price_set_sku psk
--   , ods_own.stock_keeping_unit sku
--   where ol2.order_line_oid = ol1.order_line_oid
--   and ol2.order_header_oid = oh.order_header_oid
--   and i.item_oid = ol2.item_oid 
--   and pp.price_program_oid = oh.price_program_oid
--   and pps.price_program_oid = pp.price_program_oid
--   and ps.price_set_oid = pps.price_set_oid
--   and ps.price_set_oid = psk.price_set_oid
--   and i.item_id = sku.sku_code
--   and not exists (select 1
--      from ods_own.price_set_sku psk2
--      where psk2.price_set_oid = psk.price_set_oid
--      and psk2.stock_keeping_unit_oid = psk.stock_keeping_unit_oid
--      and psk2.ods_create_date > psk.ods_create_date)
--   and sku.stock_keeping_unit_oid = psk.stock_keeping_unit_oid
--   and psk.channel like '%PAPER%')
--where ol1.order_header_oid in (select ol2.order_header_oid
--  from ods_own.order_header oh
--  , ods_own.order_line ol2
--  , ods_own.event e
--  where ol2.order_header_oid = oh.order_header_oid
--  and e.event_oid = oh.event_oid
--  and e.selling_method = 'Spec'
--  and oh.order_type in ('Spec_Order','Missing_Order')
--  and oL2.ods_modify_date >= TRUNC(TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')))
--and ol1.bundle_parent_order_line_oid is null



/*-----------------------------------------------*/
/* TASK No. 7 */
/* old Update order total ORDER_HEADER */

/*
update ods_own.order_header oh
set (oh.total_amount, oh.ods_modify_date) = 
  (Select
   Sum(ol.line_total) as total_amount,
   sysdate as ods_modify_date
   from ods_own.order_line ol
   where ol.order_header_oid = oh.order_header_oid
   group by ol.order_header_oid)
where oh.order_type in ('Spec_Order','Missing_Order')
and oh.event_oid in (select e.event_oid
  from ods_own.event e
  where e.event_oid = oh.event_oid
  and e.selling_method = 'Spec')
and oh.order_header_oid in (select ol2.order_header_oid
  from ods_own.order_line ol2
  where ol2.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap 
)
*/


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

&


/*-----------------------------------------------*/
/* TASK No. 9 */
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
CONTEXT_NAME              
)
values (
:v_cdc_load_table_name,
:v_sess_no,
'UPDATE_OL_LISTPRICE_SPEC_ORDER_PKG',
'009',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          ),
:v_cdc_overlap,
SYSDATE,
 :v_env)

&


/*-----------------------------------------------*/
