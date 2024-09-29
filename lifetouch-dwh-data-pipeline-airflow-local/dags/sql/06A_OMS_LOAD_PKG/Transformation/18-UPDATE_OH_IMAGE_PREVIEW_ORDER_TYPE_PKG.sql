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
/* Update Order Header Buyer Order */

update (
select oh.* from ods_own.order_header oh, ods_own.event evt ,ods_own.apo apo
where oh.ODS_CREATE_DATE > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
and oh.event_oid=evt.event_oid(+)
and OH.APO_OID=apo.apo_oid(+)
and IMAGE_PREVIEW_ORDER_TYPE is null
and (
    ((evt.selling_method='PrePay' or apo.selling_method='PrePay') and 	oh.ORDER_TYPE<>'Bulk_Order_X')
 or ((evt.selling_method='Spec' or apo.selling_method='Spec') and oh.ORDER_TYPE='Bulk_ReOrder')
 or ((evt.selling_method='Proof' or apo.selling_method='Proof') and oh.ORDER_TYPE not in ('Bulk_Order_X','Staff_Order'))
 or ((evt.selling_method='Proof' or apo.selling_method='Proof') and oh.ORDER_TYPE in ('Staff_Order') 
     and exists (select 1 from ods_own.order_line ol ,ods_own.item i
         where ol.order_header_oid=oh.order_header_oid and ol.item_oid=i.item_oid and i.ITEM_ID not in ('50015' , '50016','50414','50415')))
)
) trg
set trg. IMAGE_PREVIEW_ORDER_TYPE='Buyer'

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Update Order Header Non-Buyer Order */

update (
select oh. IMAGE_PREVIEW_ORDER_TYPE from ods_own.order_header oh
where oh.ODS_CREATE_DATE > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
and IMAGE_PREVIEW_ORDER_TYPE is null
) trg
set trg. IMAGE_PREVIEW_ORDER_TYPE='Non-Buyer'

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name

&


/*-----------------------------------------------*/
