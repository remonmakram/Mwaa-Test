/* TASK No. 1 */
/* Load Job Classification table */

/* SOURCE CODE */


/*&*/

/* TARGET CODE */
MERGE INTO ODS_STAGE.EVENT_TYPE_JOB_CLASS_MAPPING   jc
using
(select distinct(job_classification)    as  job_classification
, case when job_classification IN ('Original','ORIGINAL')  then 'ORIGINAL' 
       when job_classification IN ('Retake','RETAKE') then 'RETAKE'
       when job_classification='Service Only' then 'SERVICEONLY'
       when job_classification='House Account' then 'HOUSE'
       when job_classification='Money Trans' then 'OTHER'
       when job_classification='Proof the X' then 'OTHER'
       when job_classification='Unknown' then 'OTHER'
       when job_classification='Projection' then 'OTHER'
       when job_classification='Outside' then 'OTHER'
       else 'OTHER'
   end    as event_type       
from ODS_OWN.EVENT
where job_classification is not null
) s
on (s.job_classification=jc.job_classification)
when matched then
update
  set jc.event_type=s.event_type
     ,jc.ods_modify_date=sysdate
    ,jc.updated_by='ODI_ETL'
where jc.event_type <> s.event_type
when not matched then
insert
(job_classification
,event_type
,ods_create_date
,ods_modify_date
,created_by
,updated_by
)
values
(s.job_classification
,s.event_type
,sysdate
,sysdate
,'ODI_ETL'
,'ODI_ETL'
)

&


/*-----------------------------------------------*/
/* TASK No. 2 */
/* Drop Staging Table */

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.TMP_EVENT_TYPE_XR_STG';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  
&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* Create Helper Table */

create table  RAX_APP_USER.TMP_EVENT_TYPE_XR_STG
as
Select 'ORIGINAL' as event_type
,'Original' as job_classification
from dual
union all
Select 'RETAKE' as event_type
,'Retake' as job_classification
from dual
union all
Select 'CANDID' as event_type
,'Candid' as job_classification
from dual
union all
Select 'SERVICEONLY' as event_type
,'Service Only' as job_classification
from dual
union all
Select 'HOUSE' as event_type
,'House Account' as job_classification
from dual
union all
Select 'OTHER' as event_type
,'Other' as job_classification
from dual



&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* Load EVENT_TYPE_XR table */

MERGE INTO ODS_STAGE.EVENT_TYPE_XR xr
USING
  (SELECT event_type   as event_type
             ,job_classification  as job_classification
from RAX_APP_USER.TMP_EVENT_TYPE_XR_STG
  ) s
on (xr.event_type=s.event_type)
when not matched then
insert
(event_type_oid
,event_type
,ods_create_date
)
values
(ODS_STAGE.EVENT_TYPE_OID_SEQ.nextval
,s.event_type
,sysdate
)

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Load EVENT_TYPE table */



/* TARGET CODE */
merge into ODS_OWN.EVENT_TYPE  e
using
   (select s.event_type    as event_type
         , s.job_classification    as job_classification
        , xr.event_type_oid    as event_type_oid
        , ss.source_system_oid   as source_system_oid
    from ODS_OWN.SOURCE_SYSTEM    ss , RAX_APP_USER.TMP_EVENT_TYPE_XR_STG s , ODS_STAGE.EVENT_TYPE_XR xr
    where ss.source_system_name='Data Warehouse' AND xr.event_type=s.event_type
  ) s
on (e.event_type=s.event_type)
when matched then
update
   set e.job_classification=s.job_classification
       ,e.source_system_oid=s.source_system_oid
      ,e.ods_modify_date=sysdate
     ,e.updated_by='ODI_ETL'
  where e.job_classification <> s.job_classification
     or e.source_system_oid <> s.source_system_oid
when not matched then
insert
(event_type_oid
,event_type
,job_classification
,source_system_oid
,ods_create_date
,ods_modify_date
,created_by
,updated_by
)
values
(s.event_type_oid
,s.event_type
,s.job_classification
,s.source_system_oid
,sysdate
,sysdate
,'ODI_ETL'
,'ODI_ETL'
)

&


/*-----------------------------------------------*/
