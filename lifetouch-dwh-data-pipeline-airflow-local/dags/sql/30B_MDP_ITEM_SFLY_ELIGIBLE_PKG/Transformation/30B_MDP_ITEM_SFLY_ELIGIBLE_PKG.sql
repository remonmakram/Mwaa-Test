/* TASK No. 1 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 2 */




/*-----------------------------------------------*/
/* TASK No. 3 */
/* merge into item */

merge into ods_own.item i
using
(
select mdp.item_id
, mdp.shutterfly_eligible
, mdp.administrative_type
, mdp.exclude_from_shipment_trigger
, mdp.all_looks_shutterfly_eligible
from ods_stage.mdp_item_eligibility_stg mdp
where 1=1
and mdp.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - 1 
) s
on ( s.item_id = i.item_id )
when matched then update
set i.shutterfly_eligible = case when s.shutterfly_eligible = 1 then 'Y' else 'N' end
, i.administrative_type = s.administrative_type
, i.exclude_from_shipment_trigger = s.exclude_from_shipment_trigger
, i.all_looks_shutterfly_eligible = s.all_looks_shutterfly_eligible
, i.ods_modify_date = sysdate
where i.shutterfly_eligible is null
or (i.shutterfly_eligible = 'Y' and s.shutterfly_eligible = 0)
or (i.shutterfly_eligible = 'N' and nvl(s.shutterfly_eligible,0) = 1)
or decode(i.administrative_type, s.administrative_type,1,0) = 0
or decode(i.exclude_from_shipment_trigger, s.exclude_from_shipment_trigger,1,0) = 0
or decode(i.all_looks_shutterfly_eligible, s.all_looks_shutterfly_eligible,1,0) = 0


&


/*-----------------------------------------------*/
/* TASK No. 4 */
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
             SUBSTR('2024-06-12 00:25:15.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/

&


/*-----------------------------------------------*/
/* TASK No. 5 */
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
,29903828200
,'30B_MDP_ITEM_SFLY_ELIGIBLE_PKG'
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
29903828200,
'30B_MDP_ITEM_SFLY_ELIGIBLE_PKG',
'005',
TO_DATE(
             SUBSTR('2024-06-12 00:25:15.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/


&


/*-----------------------------------------------*/
