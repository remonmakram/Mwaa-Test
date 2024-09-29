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
/* insert into mlt_payment_order_line */

insert into ods_app_user.mlt_payment_order_line
(job_number
, payment_id
, payment_date
, payment_amount
, payment_voucher_id
, order_type
, sku_code
, Description
, order_id
, order_payment_amount
)
select o.job_number
, p.payment_id
, p.payment_date
, p.payment_amount
, o.payment_voucher_id
, o.order_type
, olc.sku_code
, Olc.Description
, o.order_id
, o.payment_amount
From Ods.Mlt_Payment_Curr P
, Ods.Mlt_Mlt_Order_Curr O
, Ods.Mlt_Order_Line_Curr Ol
, Ods.Mlt_Order_Line_Item Oli
, ODS.Mlt_Order_Line_Curr olc
where p.payment_id = o.payment_id
and o.order_id = ol.order_id
and ol.order_line_id = oli.parent_order_line_id
and oli.child_order_line_id = olc.order_line_id
and Oli.effective_date >= TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
and not exists (
	select 1 from ods_app_user.mlt_payment_order_line M
	where M.payment_id = P.payment_id
)

&


/*-----------------------------------------------*/
/* TASK No. 5 */
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
/* TASK No. 6 */
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
,'LOAD_MLT_PAYMENT_ORDER_LINE'
,'005'
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
'LOAD_MLT_PAYMENT_ORDER_LINE',
'005',
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
