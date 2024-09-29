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
/* drop sf_oli */

BEGIN
    EXECUTE IMMEDIATE 'drop table sf_oli';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -942 THEN
            DBMS_OUTPUT.PUT_LINE('Table does not exist.');
        ELSE
            RAISE;
        END IF;
END; 
&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* create sf_oli */

create table sf_oli as
select oli.id
,oli.productcode as PRODUCT_CODE
,oli.NAME
,oli.unitprice as UNIT_PRICE
,oli.QUANTITY
,oli.totalprice as TOTAL_PRICE
,oli.listprice as LIST_PRICE
,oli.servicedate as SERVICE_DATE
,oli.DESCRIPTION
,oli.payment_due_date__c as PAYMENT_DUE_DATE
,oli.hide_in_invoice__c as HIDE_IN_INVOICE
,oli.no_invoice_reason__c as NO_INVOICE_REASON
,oli.otherreason__c as OTHER_REASON
,oli.PRODUCT2ID
, p2.stockkeepingunit as stock_keeping_unit
, bo.booking_opportunity_oid
from ods_stage.sf_opportunitylineitem_stg oli
, ods_stage.sf_product2_stg p2
, ods_stage.sf_booking_opportunity_xr boxr
, ods_own.booking_opportunity bo
, ods_own.sub_program sp
where oli.product2id = p2.id(+)
and oli.opportunityid = boxr.sf_id -- inner join as these are the only ones we want
and boxr.booking_opportunity_oid = bo.booking_opportunity_oid
and bo.sub_program_oid = sp.sub_program_oid
and oli.isdeleted not in (1)
and oli.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* sf_opportunity_line_item_xr */

merge into ods_stage.opportunity_line_item_xr t
using sf_oli s
on ( s.id = t.opportunitylineitemid )
when not matched then insert
( t.opportunity_line_item_oid
, t.opportunitylineitemid
, t.ods_create_date
)
values
( ods_stage.opportunity_line_item_oid_seq.nextval
, s.id
, sysdate
)

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* opportunity_line_item */

merge into ods_own.opportunity_line_item t
using 
( select olixr.opportunity_line_item_oid
, ss.source_system_oid
,oli.BOOKING_OPPORTUNITY_OID
,oli.PRODUCT_CODE
,oli.NAME
,oli.UNIT_PRICE
,oli.QUANTITY
,oli.TOTAL_PRICE
,oli.LIST_PRICE
,oli.SERVICE_DATE
,oli.DESCRIPTION
,oli.PAYMENT_DUE_DATE
,oli.HIDE_IN_INVOICE
,oli.NO_INVOICE_REASON
,oli.OTHER_REASON
,oli.PRODUCT2ID
,oli.STOCK_KEEPING_UNIT
from sf_oli oli
, ods_stage.opportunity_line_item_xr olixr
, ods_own.source_system ss
where oli.id = olixr.opportunitylineitemid
and ss.source_system_short_name = 'SF'
) s
on ( s.opportunity_line_item_oid = t.opportunity_line_item_oid )
when matched then update
set t.BOOKING_OPPORTUNITY_OID = s.booking_opportunity_oid
,t.PRODUCT_CODE = s.product_code
,t.NAME = s.name
,t.UNIT_PRICE = s.unit_price
,t.QUANTITY = s.quantity
,t.TOTAL_PRICE = s.total_price
,t.LIST_PRICE = s.list_price
,t.SERVICE_DATE = s.service_date
,t.DESCRIPTION = s.description
,t.PAYMENT_DUE_DATE = s.payment_due_date
,t.HIDE_IN_INVOICE = s.hide_in_invoice
,t.NO_INVOICE_REASON = s.no_invoice_reason
,t.OTHER_REASON = s.other_reason
,t.PRODUCT2ID = s.product2id
,t.STOCK_KEEPING_UNIT = s.stock_keeping_unit
where decode(t.BOOKING_OPPORTUNITY_OID , s.booking_opportunity_oid,1,0) = 0
or decode(t.PRODUCT_CODE , s.product_code,1,0) = 0
or decode(t.NAME , s.name,1,0) = 0
or decode(t.UNIT_PRICE , s.unit_price,1,0) = 0
or decode(t.QUANTITY , s.quantity,1,0) = 0
or decode(t.TOTAL_PRICE , s.total_price,1,0) = 0
or decode(t.LIST_PRICE , s.list_price,1,0) = 0
or decode(t.SERVICE_DATE , s.service_date,1,0) = 0
or decode(t.DESCRIPTION , s.description,1,0) = 0
or decode(t.PAYMENT_DUE_DATE , s.payment_due_date,1,0) = 0
or decode(t.HIDE_IN_INVOICE , s.hide_in_invoice,1,0) = 0
or decode(t.NO_INVOICE_REASON , s.no_invoice_reason,1,0) = 0
or decode(t.OTHER_REASON , s.other_reason,1,0) = 0
or decode(t.PRODUCT2ID , s.product2id,1,0) = 0
or decode(t.STOCK_KEEPING_UNIT , s.stock_keeping_unit,1,0) = 0
when not matched then insert
( t.opportunity_line_item_oid 
,t.BOOKING_OPPORTUNITY_OID
,t.PRODUCT_CODE
,t.NAME
,t.UNIT_PRICE
,t.QUANTITY
,t.TOTAL_PRICE
,t.LIST_PRICE
,t.SERVICE_DATE
,t.DESCRIPTION
,t.PAYMENT_DUE_DATE
,t.HIDE_IN_INVOICE
,t.NO_INVOICE_REASON
,t.OTHER_REASON
,t.PRODUCT2ID
,t.STOCK_KEEPING_UNIT
,t.ODS_CREATE_DATE
,t.ODS_MODIFY_DATE
,t.SOURCE_SYSTEM_OID
)
values
( s.opportunity_line_item_oid
,s.BOOKING_OPPORTUNITY_OID
,s.PRODUCT_CODE
,s.NAME
,s.UNIT_PRICE
,s.QUANTITY
,s.TOTAL_PRICE
,s.LIST_PRICE
,s.SERVICE_DATE
,s.DESCRIPTION
,s.PAYMENT_DUE_DATE
,s.HIDE_IN_INVOICE
,s.NO_INVOICE_REASON
,s.OTHER_REASON
,s.PRODUCT2ID
,s.STOCK_KEEPING_UNIT
,sysdate
,sysdate
,s.SOURCE_SYSTEM_OID
)

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* deletes */

delete from ods_own.opportunity_line_item oli
where exists
(
select 1
from ods_stage.opportunity_line_item_xr olixr
, ods_stage.sf_opportunitylineitem_stg olis
where oli.opportunity_line_item_oid = olixr.opportunity_line_item_oid
and olixr.opportunitylineitemid = olis.id
and olis.isdeleted = 1
and olis.ods_modify_date >  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
)

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* opportunity_invoice_xr */

insert into ods_stage.opportunity_invoice_xr
( opportunity_invoice_oid
, order2id
, ods_create_date
, ods_modify_date
)
select ods_stage.opportunity_invoice_oid_seq.nextval
, s.id
, sysdate
, sysdate
from ods_stage.sf_order2_stg s
, ods_stage.sf_booking_opportunity_xr boxr
where s.opportunityid = boxr.sf_id
and s.isdeleted = 0
and s.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - 1
and not exists
(
select 1
from ods_stage.opportunity_invoice_xr t
where t.order2id = s.id
)

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* opportunity_invoice */

merge into ods_own.opportunity_invoice t
using
(
select o2.ordernumber
, o2.salesorderid__c
, o2.billingdocumentid__c
, o2.billingdocumentstatus__c
, o2.billedamount__c
, o2.taxamount__c
, o2.invoiced_amount__c
, o2.paymentamount__c
, o2.totalamount
, o2.createddate
, o2.lastmodifieddate
, o2.last_invoice_payment_date__c
, xr.opportunity_invoice_oid
, ss.source_system_oid
, boxr.booking_opportunity_oid
from ods_stage.sf_order2_stg o2
, ods_stage.opportunity_invoice_xr xr
, ods_stage.sf_booking_opportunity_xr boxr
, ods_own.source_system ss
where o2.id = xr.order2id
and o2.opportunityid = boxr.sf_id
and o2.isdeleted = 0
and ss.source_system_short_name = 'SF'
and o2.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - 1
) s
on ( s.opportunity_invoice_oid = t.opportunity_invoice_oid )
when matched then update
set t.order_number = s.ordernumber
, t.sales_order_id = s.salesorderid__c
, t.billing_document_id = s.billingdocumentid__c
, t.billing_document_status = s.billingdocumentstatus__c
, t.billed_amount = s.billedamount__c
, t.tax_amount = s.taxamount__c
, t.invoiced_amount = s.invoiced_amount__c
, t.payment_amount = s.paymentamount__c
, t.total_amount = s.totalamount
, t.created_date = s.createddate
, t.last_modified_date = s.lastmodifieddate
, t.last_invoice_payment_date = s.last_invoice_payment_date__c
, t.booking_opportunity_oid = s.booking_opportunity_oid
, t.ods_modify_date = sysdate
where decode(t.order_number , s.ordernumber,1,0) = 0
or decode( t.sales_order_id , s.salesorderid__c,1,0) = 0
or decode( t.billing_document_id , s.billingdocumentid__c,1,0) = 0
or decode( t.billing_document_status , s.billingdocumentstatus__c,1,0) = 0
or decode( t.billed_amount , s.billedamount__c,1,0) = 0
or decode( t.tax_amount , s.taxamount__c,1,0) = 0
or decode( t.invoiced_amount , s.invoiced_amount__c,1,0) = 0
or decode( t.payment_amount , s.paymentamount__c,1,0) = 0
or decode( t.total_amount , s.totalamount,1,0) = 0
or decode( t.created_date , s.createddate,1,0) = 0
or decode( t.last_modified_date , s.lastmodifieddate,1,0) = 0
or decode( t.last_invoice_payment_date , s.last_invoice_payment_date__c,1,0) = 0
or decode( t.booking_opportunity_oid , s.booking_opportunity_oid,1,0) = 0
when not matched then insert
(OPPORTUNITY_INVOICE_OID
,BOOKING_OPPORTUNITY_OID
,ORDER_NUMBER
,SALES_ORDER_ID
,BILLING_DOCUMENT_ID
,BILLING_DOCUMENT_STATUS
,BILLED_AMOUNT
,TAX_AMOUNT
,INVOICED_AMOUNT
,PAYMENT_AMOUNT
,TOTAL_AMOUNT
,CREATED_DATE
,LAST_MODIFIED_DATE
,LAST_INVOICE_PAYMENT_DATE
,ODS_CREATE_DATE
,ODS_MODIFY_DATE
,SOURCE_SYSTEM_OID
)
values
(s.OPPORTUNITY_INVOICE_OID
,s.BOOKING_OPPORTUNITY_OID
,s.ordernumber
,s.salesorderid__c
,s.billingdocumentid__c
,s.billingdocumentstatus__c
,s.billedamount__c
,s.taxamount__c
,s.invoiced_amount__c
,s.paymentamount__c
,s.totalamount
,s.CREATEDDATE
,s.LASTMODIFIEDDATE
,s.last_invoice_payment_date__c
,sysdate
,sysdate
,s.SOURCE_SYSTEM_OID
)

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* deletes */

delete from ods_own.opportunity_invoice oi
where exists
(
select 1
from ods_stage.opportunity_invoice_xr oixr
, ods_stage.sf_order2_stg o
where oi.opportunity_invoice_oid = oixr.opportunity_invoice_oid
and oixr.order2id = o.id
and o.isdeleted = 1
and o.ods_modify_date >  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
)

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* opportunity_invoice_line_xr */

insert into ods_stage.opportunity_invoice_line_xr
( opportunity_invoice_line_oid
, orderitemid
, orderid
, ods_create_date
, ods_modify_date
)
select ods_stage.opp_invoice_line_oid_seq.nextval
, s.id
, s.orderid
, sysdate
, sysdate
from ods_stage.sf_orderitem_stg s
, ods_stage.opportunity_invoice_xr oixr
where s.orderid = oixr.order2id
and s.isdeleted = 0
and s.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - 1
and not exists
(
select 1
from ods_stage.opportunity_invoice_line_xr t
where t.orderitemid = s.id
)

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* opportunity_invoice_line */

merge into ods_own.opportunity_invoice_line t
using
(
select oilxr.opportunity_invoice_line_oid
, oixr.opportunity_invoice_oid
, p2.productcode
, p2.name
, stg.quantity
, stg.unitprice
, stg.totalprice
, stg.createddate
, stg.lastmodifieddate
, ss.source_system_oid
from ods_stage.sf_orderitem_stg stg
, ods_stage.opportunity_invoice_line_xr oilxr
, ods_stage.opportunity_invoice_xr oixr
, ods_stage.sf_product2_stg p2
, ods_own.source_system ss
where stg.orderid = oixr.order2id
and stg.id = oilxr.orderitemid
and stg.isdeleted = 0
and stg.product2id = p2.id(+)
and ss.source_system_short_name = 'SF'
and stg.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - 1
) s
on ( s.opportunity_invoice_line_oid = t.opportunity_invoice_line_oid )
when matched then update
set t.opportunity_invoice_oid = s.opportunity_invoice_oid
, t.product_code = s.productcode
, t.product_name = s.name
, t.quantity = s.quantity
, t.unit_price = s.unitprice
, t.total_price = s.totalprice
, t.created_date = s.createddate
, t.last_modified_date = s.lastmodifieddate
, t.ods_modify_date = sysdate
where decode(t.opportunity_invoice_oid , s.opportunity_invoice_oid,1,0) = 0
or decode( t.product_code , s.productcode,1,0) = 0
or decode( t.product_name , s.name,1,0) = 0
or decode( t.quantity , s.quantity,1,0) = 0
or decode( t.unit_price , s.unitprice,1,0) = 0
or decode( t.total_price , s.totalprice,1,0) = 0
or decode( t.created_date , s.createddate,1,0) = 0
or decode( t.last_modified_date , s.lastmodifieddate,1,0) = 0
when not matched then insert
(t.OPPORTUNITY_INVOICE_LINE_OID
,t.OPPORTUNITY_INVOICE_OID
,t.PRODUCT_CODE
,t.PRODUCT_NAME
,t.QUANTITY
,t.UNIT_PRICE
,t.TOTAL_PRICE
,t.CREATED_DATE
,t.LAST_MODIFIED_DATE
,t.ODS_CREATE_DATE
,t.ODS_MODIFY_DATE
,t.SOURCE_SYSTEM_OID
)
values
(s.OPPORTUNITY_INVOICE_LINE_OID
,s.OPPORTUNITY_INVOICE_OID
,s.PRODUCTCODE
,s.NAME
,s.QUANTITY
,s.UNITPRICE
,s.TOTALPRICE
,s.CREATEDDATE
,s.LASTMODIFIEDDATE
,sysdate
,sysdate
,s.SOURCE_SYSTEM_OID
)

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* deletes */

delete from ods_own.opportunity_invoice_line oil
where exists
(
select 1
from ods_stage.opportunity_invoice_line_xr oilxr
, ods_stage.sf_orderitem_stg oi
where oil.opportunity_invoice_line_oid = oilxr.opportunity_invoice_line_oid
and oilxr.orderitemid = oi.id
and oi.isdeleted = 1
and oi.ods_modify_date >  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
)

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
,'LOAD_SF_OPPORTUNITY_LINE_ITEM_PKG'
,'006'
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
'LOAD_SF_OPPORTUNITY_LINE_ITEM_PKG',
'006',
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
