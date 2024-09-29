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
/* Drop driver table */

BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.T_OH_SHIP_COMP_D';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Create driver table */

create table rax_app_user.T_OH_SHIP_COMP_D (order_header_oid number)

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* create driver table index */

create unique index rax_app_user.T_OH_SHIP_COMP_D_pk on rax_app_user.T_OH_SHIP_COMP_D (order_header_oid)


&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Shipment driver */

insert into rax_app_user.T_OH_SHIP_COMP_D (order_header_oid) (
select 
    oh.order_header_oid
from 
    ods_own.order_line ol
    , ods_own.order_header oh
    , ods_own.shipment_line sl
    , ods_own.shipment s
where (1=1) 
    and s.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - 0.5
    and OH.ORDER_DATE >= to_date('20140101','YYYYMMDD')
    and nvl(oh.order_ship_complete_ind,0) <> 1 /* we only deal with orders that aren't shipped yet */
    and ol.ORDER_HEADER_OID = oh.ORDER_HEADER_OID
    and ol.order_line_oid = sl.order_line_oid
    and sl.shipment_oid = s.shipment_oid
    and not exists (select 1 from rax_app_user.T_OH_SHIP_COMP_D z where z.order_header_oid = oh.order_header_oid)
group by 
    oh.order_header_oid
)

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* ShipmentLine driver */

insert into rax_app_user.T_OH_SHIP_COMP_D (order_header_oid) (
select 
    oh.order_header_oid
from 
    ods_own.order_line ol
    , ods_own.order_header oh
    , ods_own.shipment_line sl
where (1=1) 
    and sl.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - 0.5
    and OH.ORDER_DATE >= to_date('20140101','YYYYMMDD')
    and nvl(oh.order_ship_complete_ind,0) <> 1 /* we only deal with orders that aren't shipped yet */
    and ol.ORDER_HEADER_OID = oh.ORDER_HEADER_OID
    and ol.order_line_oid = sl.order_line_oid
    and not exists (select 1 from rax_app_user.T_OH_SHIP_COMP_D z where z.order_header_oid = oh.order_header_oid)
group by 
    oh.order_header_oid
)

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* OrderLine Driver */

insert into rax_app_user.T_OH_SHIP_COMP_D (order_header_oid) (
select 
    oh.order_header_oid
from 
    ods_own.order_line ol
    , ods_own.order_header oh
where (1=1) 
    and ol.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - 0.5
    and OH.ORDER_DATE >= to_date('20140101','YYYYMMDD')
    and nvl(oh.order_ship_complete_ind,0) <> 1 /* we only deal with orders that aren't shipped yet */
    and ol.ORDER_HEADER_OID = oh.ORDER_HEADER_OID
    and not exists (select 1 from rax_app_user.T_OH_SHIP_COMP_D z where z.order_header_oid = oh.order_header_oid)
group by 
    oh.order_header_oid
)

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Order Header Driver */

insert into rax_app_user.T_OH_SHIP_COMP_D (order_header_oid) (
select 
    oh.order_header_oid
from 
    ods_own.order_header oh
where (1=1) 
    and oh.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - 0.5
    and OH.ORDER_DATE >= to_date('20140101','YYYYMMDD')
    and nvl(oh.order_ship_complete_ind,0) <> 1 /* we only deal with orders that aren't shipped yet */
    and not exists (select 1 from rax_app_user.T_OH_SHIP_COMP_D z where z.order_header_oid = oh.order_header_oid)
group by 
    oh.order_header_oid
)


&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* drop temp_oh_ship_complete_ind */

BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.temp_oh_ship_complete_ind';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* create temp_oh_ship_complete_ind */

create table rax_app_user.temp_oh_ship_complete_ind as
select 
    a.order_header_oid
    /* First non DID shipped OR if only DID, then first DID */ 
    ,case when (a.sum_ord_qty > 0 and ((a.non_did_ship_count > 0) or (a.did_ship_count > 0 and a.non_did_count = 0))) then '1' else '0' end as order_ship_complete_ind
    ,a.sum_ord_qty
    ,a.non_did_ship_count
    ,a.did_ship_count
    ,a.non_did_count
    ,a.old_order_ship_complete_ind
    ,a.old_order_ship_date
    ,a.shipments_order_ship_date
from
(
    select ol.order_header_oid
    , sum(ol.ordered_quantity) sum_ord_qty
    , nvl(oh.order_ship_complete_ind,0) as old_order_ship_complete_ind
    , min(oh.order_ship_date) as old_order_ship_date
    , NVL(MIN(s.ship_date),trunc(sysdate)) as shipments_order_ship_date
    , sum(case when (i.FULFILLMENT_TYPE = 'Digital') then ol.shipped_qty else 0 end) as did_ship_count 
    , sum(case when (i.FULFILLMENT_TYPE <> 'Digital' or i.FULFILLMENT_TYPE is null) then ol.shipped_qty else 0 end) as non_did_ship_count 
    , sum(case when (i.FULFILLMENT_TYPE <> 'Digital' or i.FULFILLMENT_TYPE is null) then ol.ordered_quantity else 0 end) as non_did_count 
from ods_own.order_line ol
        , ods_own.item i
        , ods_own.order_header oh
        , ods_own.shipment_line sl
        , ods_own.shipment s
        , rax_app_user.T_OH_SHIP_COMP_D d
    where (1=1) 
    and oh.order_header_oid = d.order_header_oid 
    and OH.ORDER_DATE >= to_date('20140101','YYYYMMDD')
    and nvl(oh.order_ship_complete_ind,0) <> 1 /* we only deal with orders that aren't shipped yet */
    and ol.item_oid = i.item_oid
    and ol.ORDER_HEADER_OID = oh.ORDER_HEADER_OID
    and ol.order_line_oid = sl.order_line_oid(+)
    and sl.shipment_oid = s.shipment_oid(+)
    group by ol.order_header_oid
    , oh.order_ship_complete_ind
) a
where (1=1)
and a.old_order_ship_complete_ind <> case when (a.sum_ord_qty > 0 and ((a.non_did_ship_count > 0) or (a.did_ship_count > 0 and a.non_did_count = 0))) then '1' else '0' end



/*
select ol.order_header_oid
, case when sum(ol.shipped_qty) > 0 and sum(ol.ordered_quantity) > 0 then '1' else '0' end as order_ship_complete_ind
, sum(ol.ordered_quantity) sum_ord_qty
, sum(ol.shipped_qty) sum_shipped_qty
, oh.order_ship_complete_ind as old_order_ship_complete_ind
from ods_own.order_line ol
, ods_own.item i
, ods_own.order_header oh
where ol.order_header_oid in ( select distinct order_header_oid from 
		ods_own.order_line where 
		ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap) 
and oh.order_ship_complete_ind <> 1 
and ol.item_oid = i.item_oid
and ol.ORDER_HEADER_OID = oh.ORDER_HEADER_OID
group by ol.order_header_oid
, oh.order_ship_complete_ind
having  case when sum(ol.shipped_qty) > 0 and sum(ol.ordered_quantity) > 0 then '1' else '0' end = '1'
*/

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* create index oh_ship_complete_ind_pk */

create unique index rax_app_user.temp_oh_ship_complete_ind_pk on rax_app_user.temp_oh_ship_complete_ind(order_header_oid)

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* update order_header */

update 
(
select src.order_ship_complete_ind as src_order_ship_complete_ind
, trg.order_ship_complete_ind as trg_order_ship_complete_ind
, trg.ods_modify_date as trg_ods_modify_date
, trg.order_ship_date as trg_order_ship_date
, src.shipments_order_ship_date as shipments_order_ship_date 
from ods_own.order_header trg
, rax_app_user.temp_oh_ship_complete_ind src
where trg.order_header_oid = src.order_header_oid
and (trg.order_ship_complete_ind <> src.order_ship_complete_ind
or trg.order_ship_complete_ind is null
)
)
set trg_order_ship_complete_ind = src_order_ship_complete_ind
, trg_ods_modify_date = sysdate
, trg_order_ship_date =  trunc(shipments_order_ship_date)
 /*12/22/2015 - Removed - trunc(sysdate)we trunc the date because this process is not all that precise and this will simplify things downstream in the DW */

&


/*-----------------------------------------------*/
/* TASK No. 15 */
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
/* TASK No. 16 */
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
,'UPDATE_OH_SHIP_COMPLETE_IND_PKG'
,'016'
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
'UPDATE_OH_SHIP_COMPLETE_IND_PKG',
'016',
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
