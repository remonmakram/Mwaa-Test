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
/* SOLO Orders - SOLO CDC */

merge into ods_own.senior_online_order_track t
using
(
select sco.customer_order_id
, sco.order_number as order_no
, sco.audit_create_date as source_create_date
, oh.oms_createts as target_create_date
from ods_stage.solo_customer_order sco
, 
(
select oh1.order_no
, oh1.oms_createts
from ods_own.order_header oh1
, ods_own.source_system ss
where ss.source_system_oid = oh1.source_system_oid
and ss.source_system_short_name = 'OMS2'
) oh
where sco.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
and sco.order_number = oh.order_no(+)
) s
on ( s.customer_order_id = t.customer_order_id and t.order_source = 'SOLO' )
when matched then update
set t.order_no = s.order_no
, t.target_create_date = s.target_create_date
, t.ignore_flag = case when s.order_no = 'unassigned' then 'Y' else 'N' end
, t.ods_modify_date = sysdate
where decode(t.order_no,s.order_no,1,0) = 0
or decode(t.target_create_date,s.target_create_date,1,0) = 0
or (t.ignore_flag = 'N' and s.order_no = 'unassigned')
when not matched then insert
(senior_online_order_track_oid
,customer_order_id
,order_source
,order_no
,source_create_date
,target_create_date
,ods_create_date
,ods_modify_date
)
values
(ods_own.senior_ol_order_track_oid_seq.nextval
,s.customer_order_id
,'SOLO'
,s.order_no
,s.source_create_date
,s.target_create_date
,sysdate
,sysdate
)
where s.order_no is not null
and s.order_no != 'unassigned'


&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* SOLO Orders - OH CDC */

merge into ods_own.senior_online_order_track t
using
(
select sco.customer_order_id
, sco.order_number as order_no
, sco.audit_create_date as source_create_date
, oh.oms_createts as target_create_date
from ods_stage.solo_customer_order sco
, 
(
select oh1.order_no
, oh1.oms_createts
from ods_own.order_header oh1
, ods_own.source_system ss
where ss.source_system_oid = oh1.source_system_oid
and ss.source_system_short_name = 'OMS2'
and oh1.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) oh
where 1=1
and sco.order_number = oh.order_no
) s
on ( s.customer_order_id = t.customer_order_id and t.order_source = 'SOLO' )
when matched then update
set t.order_no = s.order_no
, t.target_create_date = s.target_create_date
, t.ignore_flag = case when s.order_no = 'unassigned' then 'Y' else 'N' end
, t.ods_modify_date = sysdate
where decode(t.order_no,s.order_no,1,0) = 0
or decode(t.target_create_date,s.target_create_date,1,0) = 0
or (t.ignore_flag = 'N' and s.order_no = 'unassigned')


&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* SAS Orders - SAS payment CDC */

merge into ods_own.senior_online_order_track t
using
(
select sco.customer_order_id
, sco.order_number as order_no
, p.audit_create_date as source_create_date
, sco.deleted_ind
, oh.oms_createts as target_create_date
from ods_stage.sas_customer_order_stg sco
, ods_stage.sas_payment_stg p
, 
(
select oh1.order_no
, oh1.oms_createts
from ods_own.order_header oh1
, ods_own.source_system ss
where ss.source_system_oid = oh1.source_system_oid
and ss.source_system_short_name = 'OMS2'
) oh
where p.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
and sco.customer_order_id = p.customer_order_id
and p.authorization_code is not null
and sco.order_number = oh.order_no(+)
and sco.order_number not in ('AQ3JHTJX')
) s
on ( s.customer_order_id = t.customer_order_id and t.order_source = 'SAS' )
when matched then update
set t.order_no = s.order_no
, t.target_create_date = s.target_create_date
, t.ignore_flag = case when (s.order_no = 'unassigned' or s.deleted_ind = 'Y') then 'Y' else 'N' end
, t.ods_modify_date = sysdate
where decode(t.order_no,s.order_no,1,0) = 0
or decode(t.target_create_date,s.target_create_date,1,0) = 0
or (t.ignore_flag = 'N' and (s.order_no = 'unassigned' or s.deleted_ind = 'Y'))
when not matched then insert
(senior_online_order_track_oid
,customer_order_id
,order_source
,order_no
,source_create_date
,target_create_date
,ods_create_date
,ods_modify_date
)
values
(ods_own.senior_ol_order_track_oid_seq.nextval
,s.customer_order_id
,'SAS'
,s.order_no
,s.source_create_date
,s.target_create_date
,sysdate
,sysdate
)
where s.order_no is not null
and s.deleted_ind = 'N'

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* SAS Orders - SAS sco CDC */

merge into ods_own.senior_online_order_track t
using
(
select sco.customer_order_id
, sco.order_number as order_no
, p.audit_create_date as source_create_date
, sco.deleted_ind
, oh.oms_createts as target_create_date
from ods_stage.sas_customer_order_stg sco
, ods_stage.sas_payment_stg p
, 
(
select oh1.order_no
, oh1.oms_createts
from ods_own.order_header oh1
, ods_own.source_system ss
where ss.source_system_oid = oh1.source_system_oid
and ss.source_system_short_name = 'OMS2'
) oh
where sco.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
and sco.customer_order_id = p.customer_order_id
and p.authorization_code is not null
and sco.order_number = oh.order_no(+)
and sco.order_number  not in ( 'AQ3JHTJX','AQ4Y2WYZ','AQ4Y7JV4','AQ4YWDY3','AQ42YPWX','AQ42MD9Z'
,'AQ43Y4QX'
,'AQ42V3K2'
,'AQ43XHQ2'
,'AQ43Y4QX'
,'AQ437332'
,'AQ43D3DZ'
,'AQ44YJH7'
,'AQ444R86'
,'AQ44CW96'
,'AQ44NY6Z'
,'AQ4Z27CZ'
,'AQ4Z24W4'
,'AQ4ZYBZ7'
,'AQ4ZQFMX'
,'AQ4ZB6N6'
,'AQ4ZQ7D4'
,'AQ4ZJTC3'
,'AQ46YBT6'
,'AQ46XQT3'
,'AQ46ZXT2'
,'AQ463CW3'
,'AQ466Z8Y'
,'AQ467RVY'
,'AQ46Q2V6'
)
) s
on ( s.customer_order_id = t.customer_order_id and t.order_source = 'SAS' )
when matched then update
set t.order_no = s.order_no
, t.target_create_date = s.target_create_date
, t.ignore_flag = case when (s.order_no = 'unassigned' or s.deleted_ind = 'Y') then 'Y' else 'N' end
, t.ods_modify_date = sysdate
where decode(t.order_no,s.order_no,1,0) = 0
or decode(t.target_create_date,s.target_create_date,1,0) = 0
or (t.ignore_flag = 'N' and (s.order_no = 'unassigned' or s.deleted_ind = 'Y'))
when not matched then insert
(senior_online_order_track_oid
,customer_order_id
,order_source
,order_no
,source_create_date
,target_create_date
,ods_create_date
,ods_modify_date
)
values
(ods_own.senior_ol_order_track_oid_seq.nextval
,s.customer_order_id
,'SAS'
,s.order_no
,s.source_create_date
,s.target_create_date
,sysdate
,sysdate
)
where s.order_no is not null
and s.deleted_ind = 'N'

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* SAS Orders - OH CDC */

merge into ods_own.senior_online_order_track t
using
(
select sco.customer_order_id
, sco.order_number as order_no
, sco.audit_create_date as source_create_date
, sco.deleted_ind
, oh.oms_createts as target_create_date
from ods_stage.sas_customer_order_stg sco
, 
(
select oh1.order_no
, oh1.oms_createts
from ods_own.order_header oh1
, ods_own.source_system ss
where ss.source_system_oid = oh1.source_system_oid
and ss.source_system_short_name = 'OMS2'
and oh1.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) oh
where 1=1
and sco.order_number = oh.order_no
) s
on ( s.customer_order_id = t.customer_order_id and t.order_source = 'SAS' )
when matched then update
set t.order_no = s.order_no
, t.target_create_date = s.target_create_date
, t.ignore_flag = case when (s.order_no = 'unassigned' or s.deleted_ind = 'Y') then 'Y' else 'N' end
, t.ods_modify_date = sysdate
where decode(t.order_no,s.order_no,1,0) = 0
or decode(t.target_create_date,s.target_create_date,1,0) = 0
or (t.ignore_flag = 'N' and (s.order_no = 'unassigned' or s.deleted_ind = 'Y'))


&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* 90 DAY HAPPY PATH PURGE */

delete
-- select *
from
ods_own.senior_online_order_track
where (1=1)
and ODS_CREATE_DATE <= sysdate -90
and (source_create_date is not null
    and target_create_date is not null)


&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* 365 DAY  PURGE */

delete
-- select *
from
ods_own.senior_online_order_track
where (1=1)
and ODS_CREATE_DATE <= sysdate -365

&


/*-----------------------------------------------*/
/* TASK No. 11 */
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
/* TASK No. 12 */
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
,'LOAD_SR_E2EV_ONLINE_ORDER_PKG'
,'034'
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
'LOAD_SR_E2EV_ONLINE_ORDER_PKG',
'034',
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
