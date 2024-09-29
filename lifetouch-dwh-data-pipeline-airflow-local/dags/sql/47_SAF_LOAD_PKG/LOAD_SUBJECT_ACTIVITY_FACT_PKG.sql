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
/* truncate stage */

truncate table RAX_APP_USER.subject_activity_stage

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* load stage */

insert into RAX_APP_USER.subject_activity_stage
( subject_apo_oid
, apo_id
, marketing_id
, account_id
, pipeline_status_id
, subject_id
, job_ticket_org_id
, assignment_id
, assignment_effective_date
, subject_activity_junk_id
, subject_junk_id
, photography_date
, order_date
, second_order_date
, second_photography_date
, yearbook_status_name
, trans_date
, image_qty
, ordered_image_qty
, recipe_qty
, ordered_recipe_qty
, occurs
, paid_order_qty
, price_amount
)
select sa.subject_apo_oid
, mapo.apo_id
, m.marketing_id
, ma.account_id
, ps.pipeline_status_id
, nvl(s.subject_id,-1)
, o.organization_id as job_ticket_org_id
, ca.assignment_id
, ca.effective_date as assignment_effective_date
, saj.subject_activity_junk_id
, sj.subject_junk_id
, nvl(sa.photography_date,to_date('19000101','YYYYMMDD'))
, nvl(sa.order_date,to_date('19000101','YYYYMMDD'))
, nvl(sa.second_order_date,to_date('19000101','YYYYMMDD'))
, nvl(sa.second_photography_date,to_date('19000101','YYYYMMDD'))
, 'N/A' as yearboook_status_name
, trunc(sysdate) as trans_date -- parameterize
, nvl(sa.image_qty,0)
, nvl(sa.ordered_image_qty,0)
, nvl(sa.recipe_qty,0)
, nvl(sa.ordered_recipe_qty,0)
, 1 as occurs
, nvl(sa.paid_order_qty, 0)
, nvl(sa.price_amount, 0)
from ODS_OWN.subject_apo sa
, ODS_OWN.apo
, ODS_OWN.sub_program sp
, ODS_OWN.account a
, mart.apo mapo
, mart.marketing m
, mart.account ma
, mart.pipeline_status ps
, MART.subject s
, mart.organization o
, mart.current_assignment ca
, ods_stage.grade_tf vg
, mart.subject_junk sj
, mart.subject_activity_junk saj
where sa.apo_oid = apo.apo_oid
and apo.sub_program_oid = sp.sub_program_oid
and apo.account_oid = a.account_oid
and apo.apo_id = mapo.apo_code
and sp.sub_program_oid = m.sub_program_oid
and a.lifetouch_id = ma.lifetouch_id
and nvl(sa.pipeline_sub_status,'Unknown') = ps.pipeline_sub_status
and sa.subject_oid = s.subject_oid
and apo.territory_code = o.territory_code
and a.lifetouch_id = ca.lifetouch_id
and m.program_id = ca.program_id
and s.grade = vg.grade(+)
and nvl(vg.verified_grade,'.') = sj.grade
and (case when s.subject_type in ('Staff','Student') then s.subject_type else '.' end) = sj.subject_type
and nvl(sa.buyer_type,'None (Non-Buyer)') = saj.buyer_type
and nvl(sa.channel_type,'None (Non-Buyer)') = saj.channel_type
and nvl(sa.session_type,'None') = saj.session_type
and nvl(sa.digital_buyer_ind,'UNKNOWN') = saj.digital_buyer_ind
and apo.school_year >= 2018
and sa.ods_modify_date > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* truncate stage2 */

truncate table RAX_APP_USER.subject_activity_stage2

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* stage DEL records */

insert into RAX_APP_USER.subject_activity_stage2
( record_status
, subject_activity_curr_id
, subject_apo_oid
, apo_id
, marketing_id
, account_id
, pipeline_status_id
, subject_id
, job_ticket_org_id
, assignment_id
, assignment_effective_date
, subject_activity_junk_id
, subject_junk_id
, photography_date
, order_date
, second_order_date
, second_photography_date
, yearbook_status_name
, trans_date
, image_qty
, ordered_image_qty
, recipe_qty
, ordered_recipe_qty
, occurs
, paid_order_qty
, price_amount
)  
select 'DEL'                                                                                     
, c.subject_activity_curr_id
, c.subject_apo_oid
, c.apo_id
, c.marketing_id
, c.account_id
, c.pipeline_status_id
, c.subject_id
, c.job_ticket_org_id
, c.assignment_id
, c.assignment_effective_date
, c.subject_activity_junk_id
, c.subject_junk_id
, c.photography_date
, c.order_date
, c.second_order_date
, c.second_photography_date
, c.yearbook_status_name
, s.trans_date
, 0 as image_qty
, 0 as ordered_image_qty
, 0 as recipe_qty
, 0 as ordered_recipe_qty
, 0 as occurs
, 0 as paid_order_qty
, 0 as price_amount
from RAX_APP_USER.subject_activity_STAGE s
, ODS_STAGE.subject_activity_CURR c                                              
where 1=1
and  s.subject_apo_oid = c.subject_apo_oid             
and (  s.apo_id <> c.apo_id
    or s.marketing_id <> c.marketing_id
    or s.account_id <> c.account_id
    or s.pipeline_status_id <> c.pipeline_status_id
    or s.subject_id <> c.subject_id
    or s.job_ticket_org_id <> c.job_ticket_org_id
    or s.assignment_id <> c.assignment_id
    or s.subject_activity_junk_id <> c.subject_activity_junk_id
    or s.subject_junk_id <> c.subject_junk_id
    or s.yearbook_status_name <> c.yearbook_status_name
    or s.photography_date <> c.photography_date
    or s.order_date <> c.order_date
    or s.photography_date <> c.photography_date
    or s.second_order_date <> c.second_order_date
    or s.second_photography_date <> c.second_photography_date
)
and  (c.IMAGE_QTY <> 0
     or c.ORDERED_IMAGE_QTY <> 0
     or c.RECIPE_QTY <> 0
     or c.ORDERED_RECIPE_QTY <> 0
     or  c.OCCURS <> 0
     or  c.paid_order_qty <> 0
     or  c.price_amount <> 0)

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* stage NEW records */

insert into subject_activity_stage2
( subject_activity_curr_id
, record_status
, subject_apo_oid
, apo_id
, marketing_id
, account_id
, pipeline_status_id
, subject_id
, job_ticket_org_id
, assignment_id
, assignment_effective_date
, subject_activity_junk_id
, subject_junk_id
, photography_date
, order_date
, second_order_date
, second_photography_date
, yearbook_status_name
, trans_date
, image_qty
, ordered_image_qty
, recipe_qty
, ordered_recipe_qty
, occurs
, paid_order_qty
, price_amount
)
select ODS_STAGE.subject_activity_curr_id_seq.nextval
, 'NEW'                                                                                     
, s.subject_apo_oid
, s.apo_id
, s.marketing_id
, s.account_id
, s.pipeline_status_id
, s.subject_id
, s.job_ticket_org_id
, s.assignment_id
, s.assignment_effective_date
, s.subject_activity_junk_id
, s.subject_junk_id
, s.photography_date
, s.order_date
, s.second_order_date
, s.second_photography_date
, s.yearbook_status_name
, s.trans_date
, s.image_qty
, s.ordered_image_qty
, s.recipe_qty
, s.ordered_recipe_qty
, s.occurs
, s.paid_order_qty
, s.price_amount
from subject_activity_STAGE s                                                                       
where not exists 
(
select 1 
from ODS_STAGE.subject_activity_CURR c                                             
where s.subject_apo_oid = c.subject_apo_oid             
and s.apo_id = c.apo_id
and s.marketing_id = c.marketing_id
and s.account_id = c.account_id
and s.pipeline_status_id = c.pipeline_status_id
and s.subject_id = c.subject_id
and s.job_ticket_org_id = c.job_ticket_org_id
and s.assignment_id = c.assignment_id
and s.subject_activity_junk_id = c.subject_activity_junk_id
and s.subject_junk_id = c.subject_junk_id
and s.yearbook_status_name = c.yearbook_status_name
and s.photography_date = c.photography_date
and s.order_date = c.order_date
and s.photography_date = c.photography_date
and s.second_order_date = c.second_order_date
and s.second_photography_date = c.second_photography_date
)

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* stage UPD records */

insert into RAX_APP_USER.subject_activity_stage2
( record_status
, subject_activity_curr_id
, subject_apo_oid
, apo_id
, marketing_id
, account_id
, pipeline_status_id
, subject_id
, job_ticket_org_id
, assignment_id
, assignment_effective_date
, subject_activity_junk_id
, subject_junk_id
, photography_date
, order_date
, second_order_date
, second_photography_date
, yearbook_status_name
, trans_date
, image_qty
, ordered_image_qty
, recipe_qty
, ordered_recipe_qty
, occurs
, paid_order_qty
, price_amount
)
select 'UPD'
, c.subject_activity_curr_id
, s.subject_apo_oid
, s.apo_id
, s.marketing_id
, s.account_id
, s.pipeline_status_id
, s.subject_id
, s.job_ticket_org_id
, s.assignment_id
, s.assignment_effective_date
, s.subject_activity_junk_id
, s.subject_junk_id
, s.photography_date
, s.order_date
, s.second_order_date
, s.second_photography_date
, s.yearbook_status_name
, s.trans_date
, s.image_qty
, s.ordered_image_qty
, s.recipe_qty
, s.ordered_recipe_qty
, s.occurs
, s.paid_order_qty
, s.price_amount
from RAX_APP_USER.subject_activity_STAGE s
, ODS_STAGE.subject_activity_CURR c                                              
where s.subject_apo_oid = c.subject_apo_oid
and s.apo_id = c.apo_id
and s.marketing_id = c.marketing_id
and s.account_id = c.account_id
and s.pipeline_status_id = c.pipeline_status_id
and s.subject_id = c.subject_id
and s.job_ticket_org_id = c.job_ticket_org_id
and s.assignment_id = c.assignment_id
and s.subject_activity_junk_id = c.subject_activity_junk_id
and s.subject_junk_id = c.subject_junk_id
and s.yearbook_status_name = c.yearbook_status_name
and s.photography_date = c.photography_date
and s.order_date = c.order_date
and s.photography_date = c.photography_date
and s.second_order_date = c.second_order_date
and s.second_photography_date = c.second_photography_date
and (                                                                                             
           s.IMAGE_QTY <> c.IMAGE_QTY                                                            
           OR s.ORDERED_IMAGE_QTY <> c.ORDERED_IMAGE_QTY                                          
           OR s.RECIPE_QTY <> c.RECIPE_QTY                                            
	   OR s.ORDERED_RECIPE_QTY  <> c.ORDERED_RECIPE_QTY 
           OR s.OCCURS <> c.OCCURS    
           OR s.paid_order_qty <> c.paid_order_qty
           OR (s.paid_order_qty is not null and c.paid_order_qty is null)
           OR s.price_amount <> c.price_amount         
           OR (s.price_amount is not null and c.price_amount is null)                                                    
    )

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* load NEW fact */

insert into MART.subject_activity_FACT 
( subject_activity_fact_id
, subject_activity_id
, subject_apo_oid
, apo_id
, marketing_id
, account_id
, pipeline_status_id
, subject_id
, job_ticket_org_id
, assignment_id
, assignment_effective_date
, subject_activity_junk_id
, subject_junk_id
, photography_date
, order_date
, second_order_date
, second_photography_date
, yearbook_status_name
, trans_date
, image_qty
, ordered_image_qty
, recipe_qty
, ordered_recipe_qty
, occurs
, paid_order_qty
, price_amount
)
select mart.subject_activity_fact_id_seq.nextval
, s.subject_activity_curr_id
, s.subject_apo_oid
, s.apo_id
, s.marketing_id
, s.account_id
, s.pipeline_status_id
, s.subject_id
, s.job_ticket_org_id
, s.assignment_id
, s.assignment_effective_date
, s.subject_activity_junk_id
, s.subject_junk_id
, s.photography_date
, s.order_date
, s.second_order_date
, s.second_photography_date
, s.yearbook_status_name
, s.trans_date     
, s.image_qty
, s.ordered_image_qty
, s.recipe_qty
, s.ordered_recipe_qty
, s.occurs
, s.paid_order_qty
, s.price_amount
from RAX_APP_USER.subject_activity_STAGE2 s
where RECORD_STATUS in ('NEW')

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* load NEW curr */

insert into ODS_STAGE.subject_activity_curr
( subject_activity_curr_id
, subject_apo_oid
, apo_id
, marketing_id
, account_id
, pipeline_status_id
, subject_id
, job_ticket_org_id
, assignment_id
, assignment_effective_date
, subject_activity_junk_id
, subject_junk_id
, photography_date
, order_date
, second_order_date
, second_photography_date
, yearbook_status_name
, trans_date
, modify_date
, create_date
, image_qty
, ordered_image_qty
, recipe_qty
, ordered_recipe_qty
, occurs
, paid_order_qty
, price_amount
)
select ODS_STAGE.subject_activity_curr_id_seq.nextval
, s.subject_apo_oid
, s.apo_id
, s.marketing_id
, s.account_id
, s.pipeline_status_id
, s.subject_id
, s.job_ticket_org_id
, s.assignment_id
, s.assignment_effective_date
, s.subject_activity_junk_id
, s.subject_junk_id
, s.photography_date
, s.order_date
, s.second_order_date
, s.second_photography_date
, s.yearbook_status_name
, s.trans_date
, sysdate
, sysdate
, s.image_qty
, s.ordered_image_qty
, s.recipe_qty
, s.ordered_recipe_qty
, s.occurs
, s.paid_order_qty
, s.price_amount
from RAX_APP_USER.subject_activity_STAGE2 s
where s.RECORD_STATUS in ('NEW')

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* load UPD, DEL fact */

insert into MART.subject_activity_FACT 
( subject_activity_fact_id
, subject_activity_id
, subject_apo_oid
, apo_id
, marketing_id
, account_id
, pipeline_status_id
, subject_id
, job_ticket_org_id
, assignment_id
, assignment_effective_date
, subject_activity_junk_id
, subject_junk_id
, photography_date
, order_date
, second_order_date
, second_photography_date
, yearbook_status_name
, trans_date
, image_qty
, ordered_image_qty
, recipe_qty
, ordered_recipe_qty
, occurs
, paid_order_qty
, price_amount
)
select mart.subject_activity_fact_id_seq.nextval
, s.subject_activity_curr_id
, s.subject_apo_oid
, s.apo_id
, s.marketing_id
, s.account_id
, s.pipeline_status_id
, s.subject_id
, s.job_ticket_org_id
, s.assignment_id
, s.assignment_effective_date
, s.subject_activity_junk_id
, s.subject_junk_id
, s.photography_date
, s.order_date
, s.second_order_date
, s.second_photography_date
, s.yearbook_status_name
, s.trans_date
, s.image_qty - c.image_qty
, s.ordered_image_qty - c.ordered_image_qty
, s.recipe_qty - c.recipe_qty
, s.ordered_recipe_qty - c.ordered_recipe_qty
, s.occurs - c.occurs
, s.paid_order_qty -c.paid_order_qty
, s.price_amount - c.price_amount
from RAX_APP_USER.subject_activity_STAGE2 s
, ODS_STAGE.subject_activity_curr c
where s.RECORD_STATUS in ('UPD','DEL')
and s.subject_activity_curr_ID = c.subject_activity_curr_ID

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* merge UPD, DEL curr */

MERGE into ODS_STAGE.subject_activity_CURR c      
using (select * from RAX_APP_USER.subject_activity_stage2 where RECORD_STATUS in('UPD','DEL') ) s
 on ( s.subject_activity_curr_ID=c.subject_activity_curr_ID)                                                  
when matched then update                                                                            
     set                                                                                            
       c.MODIFY_DATE = sysdate
       ,c.IMAGE_QTY = s.IMAGE_QTY                                                                   
       ,c.ORDERED_IMAGE_QTY = s.ORDERED_IMAGE_QTY                                                   
       ,c.RECIPE_QTY = s.RECIPE_QTY                                                   
       ,c.ORDERED_RECIPE_QTY = s.ORDERED_RECIPE_QTY                                                   
       ,c.OCCURS = s.OCCURS
       ,c.PAID_ORDER_QTY = s.PAID_ORDER_QTY
       ,c.PRICE_AMOUNT = s.PRICE_AMOUNT

&


/*-----------------------------------------------*/
/* TASK No. 14 */
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
/* TASK No. 15 */
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
,'LOAD_SUBJECT_ACTIVITY_FACT_PKG'
,'007'
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
'LOAD_SUBJECT_ACTIVITY_FACT_PKG',
'007',
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
