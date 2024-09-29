/*-----------------------------------------------*/
/* TASK No. 3 */
/* drop report table */

BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'actuate_solo_proof_deposit_stg',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;

&


BEGIN
  EXECUTE IMMEDIATE 'drop table RAX_APP_USER.actuate_solo_proof_deposit_stg';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;
&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* create report table */

create table RAX_APP_USER.actuate_solo_proof_deposit_stg as
select s.subject_id
,  s.last_name || ', ' || s.first_name subject_name
, solo.order_no as solo_order_no
, solo.order_sales_channel as solo_order_sales_channel
, solo.order_date as solo_order_date
, solo.bill_to_address as solo_bill_to_address
, solo.bill_to_city as solo_bill_to_city
, solo.bill_to_state as solo_bill_to_state
, pd.order_no as pd_order_no
, pd.order_sales_channel as pd_order_sales_channel
, pd.order_date as pd_order_date
, pd.bill_to_address as pd_bill_to_address
, pd.bill_to_city as pd_bill_to_city
, pd.bill_to_state as pd_bill_to_state
, pd.item_id
, pd.item_description
, pd.ordered_qty
, pd.extended_price
, pd.status
from
(
select oh.extn_subject_key
, oh.order_no
, oh.entry_type as order_sales_channel
, oh.order_date
, p.address_line1 as bill_to_address
, p.city as bill_to_city
, p.state as bill_to_state
from ods.y0yfs_order_header_curr oh
, ods.y0yfs_person_info_curr p
where oh.entry_type = 'Solo'
and oh.bill_to_key = p.person_info_key
) solo
, (
select oh.extn_subject_key
, oh.order_no
, oh.entry_type as order_sales_channel
, oh.order_date
, p.address_line1 as bill_to_address
, p.city as bill_to_city
, p.state as bill_to_state
, ol.item_id
, ol.item_description
, ol.ordered_qty
, ((ol.ordered_qty * ol.unit_price) + ol.other_charges) as extended_price
, st.description as status
from ods.y0yfs_order_line_curr ol
, ods.y0yfs_order_header_curr oh
, ods.y0yfs_order_rel_stat_curr ors
, ods.y0yfs_status_curr st
, ods.y0yfs_person_info_curr p
where ol.order_header_key=oh.order_header_key
and ol.product_line='ProofDeposit'
and ors.order_line_key=ol.order_line_key
and ors.status_quantity>0
and st.process_type_key = 'ORDER_FULFILLMENT'
and st.description in ('Forfeited', 'Collected')
and ors.status=st.status
and oh.bill_to_key = p.person_info_key
and ((ol.ordered_qty * ol.unit_price) + ol.other_charges) > 0 
) pd
, ods.y0lt_subject_curr s
where pd.extn_subject_key = solo.extn_subject_key
and solo.extn_subject_key = s.subject_key
and pd.extn_subject_key = s.subject_key

