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
/* drop d1 */

-- DROP table eob_d1
BEGIN  
   EXECUTE IMMEDIATE 'DROP TABLE eob_d1';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&



/*-----------------------------------------------*/
/* TASK No. 5 */
/* create d1 */

create table eob_d1 as
select distinct e.apo_oid
from ods_own.event e
, ods_own.order_header oh
where e.event_oid = oh.event_oid
and trim(oh.batch_id) is not null
and oh.ods_modify_date >  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap 

-- CREATE TABLE eob_d1
--    (	apo_oid NUMBER
--    )

-- &

-- INSERT INTO eob_d1(apo_oid)
-- select distinct e.apo_oid
-- from ods_own.event e
-- , ods_own.order_header oh
-- where e.event_oid = oh.event_oid
-- and trim(oh.batch_id) is not null
-- and oh.ods_modify_date >  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap 

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* index d1 */

create unique index eob_d1_pk on eob_d1(apo_oid)

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* drop d2 */

-- drop  table eob_d2

BEGIN  
   EXECUTE IMMEDIATE 'DROP TABLE eob_d2';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* create d2 */

create table eob_d2 as
select distinct e.event_ref_id
, oh.batch_id
from ods_own.event e
, ods_own.order_header oh
, eob_d1 d1
where e.event_oid = oh.event_oid
and e.apo_oid = d1.apo_oid
and trim(oh.batch_id) is not null

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* index d2 */

create index eob_d2_ix on eob_d2(batch_id)

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* insert event_order_batch */

merge into ods_own.event_order_batch t
using
(
select event_ref_id
, batch_id
from eob_d2
) s
on (s.event_ref_id = t.event_ref_id and s.batch_id = t.batch_id)
when not matched then insert
( event_ref_id
, batch_id
, ods_modify_date
)
values
( s.event_ref_id
, s.batch_id
, sysdate
)

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* delete event_order_batch */

delete from ods_own.event_order_batch t
where exists
(
select 1
from eob_d1 d1
, ods_own.event e
where d1.apo_oid = e.apo_oid
and e.event_ref_id = t.event_ref_id
)
and not exists
(
select 1
from eob_d2 d2
where t.event_ref_id = d2.event_ref_id
and t.batch_id = d2.batch_id
)


&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* event.first_boc_start_date */

merge into ods_own.event t
using
(
select e.event_oid
, min(ob.batch_create_date) as first_boc_start_date 
, min(ob.batch_close_date) as first_boc_close_date
FROM eob_d1
join ods_own.event e on eob_d1.apo_oid = e.apo_oid
JOIN ods_own.event_order_batch eob ON eob.event_ref_id = e.event_ref_id
join ods_own.order_batch ob on ob.batch_id = eob.batch_id
group by e.event_oid
) s
on ( t.event_oid = s.event_oid )
when matched then update
set t.first_boc_start_date = s.first_boc_start_date
, t.first_boc_close_date = s.first_boc_close_date
, t.ods_modify_date = sysdate
where t.first_boc_start_date <> s.first_boc_start_date or ( t.first_boc_start_date is null and s.first_boc_start_date is not null )
or  t.first_boc_close_date <> s.first_boc_start_date or ( t.first_boc_close_date is null and  s.first_boc_close_date is not null )

&


/*-----------------------------------------------*/
/* TASK No. 13 */
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
/* TASK No. 14 */
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
,'LOAD_EVENT_ORDER_BATCH_PKG'
,'003'
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
'LOAD_EVENT_ORDER_BATCH_PKG',
'003',
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
