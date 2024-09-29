/* TASK No. 1 */
/* ods.solo_payment_curr.first_name */

update ods.solo_payment_curr
set billing_firstname = 'SODS-973' 
, effective_date = sysdate
where length(regexp_replace(billing_firstname,'[^0-9]+','')) > 11
and effective_Date > trunc(sysdate) - 5


&


/*-----------------------------------------------*/
/* TASK No. 2 */
/* ods.solo_payment_curr.last_name */

update ods.solo_payment_curr
set billing_lastname = 'SODS-973' 
, effective_date = sysdate
where length(regexp_replace(billing_lastname,'[^0-9]+','')) > 11
and effective_Date > trunc(sysdate) - 5

&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* ods.inf_payment_attempt */

update ods.inf_payment_attempt
set cardholder_name = 'SODS-973'
, effective_date = sysdate
where length(regexp_replace(cardholder_name,'[^0-9]+','')) > 11
and effective_Date > trunc(sysdate) - 5

&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* ods.y0yfs_payment_curr */

update ods.y0yfs_payment_curr
set credit_card_name = 'SODS-973'
, effective_date = sysdate
where length(regexp_replace(credit_card_name,'[^0-9]+','')) > 11
and effective_Date > trunc(sysdate) - 5


&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* ods.y0yfs_person_info_curr.first_name */

update ods.y0yfs_person_info_curr
set first_name = 'SODS-973'
, effective_date = sysdate
where length(regexp_replace(first_name,'[^0-9]+','')) > 11
and effective_Date > trunc(sysdate) - 5


&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* ods.y0yfs_person_info_curr.last_name */

update ods.y0yfs_person_info_curr
set last_name = 'SODS-973'
, effective_date = sysdate
where length(regexp_replace(last_name,'[^0-9]+','')) > 11
and effective_Date > trunc(sysdate) - 5

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* ods_own.person_info.first_name */

update ods_own.person_info
set first_name = 'SODS-973'
, ods_modify_date = sysdate
where length(regexp_replace(first_name,'[^0-9]+','')) > 11
and ods_modify_date > trunc(sysdate) - 5

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* ods_own.person_info.last_name */

update ods_own.person_info
set last_name = 'SODS-973'
, ods_modify_date = sysdate
where length(regexp_replace(last_name,'[^0-9]+','')) > 11
and ods_modify_date > trunc(sysdate) - 5

&


/*-----------------------------------------------*/
