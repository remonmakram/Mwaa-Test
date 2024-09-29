BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'actuate_solo_proof_deposit_stg',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;




select count(*)
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

--COUNT(*)|
----------+
--   44611|
