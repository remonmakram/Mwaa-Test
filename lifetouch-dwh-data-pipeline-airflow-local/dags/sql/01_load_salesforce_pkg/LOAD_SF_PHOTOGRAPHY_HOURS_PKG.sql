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
/* drop sf_ph */

BEGIN
    EXECUTE IMMEDIATE 'drop table sf_ph';
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
/* create sf_ph */

create table sf_ph as
select ph.id
, ph.Name
, ph.additional_info__c as Additional_Info
, ph.area__c as territory_code
, ph.clicks__c as Clicks
, ph.Current_Oversched_Thresh
, ph.Current_Undersched_Thresh
, ph.Estimated_to_be_Photographed
, ph.minutes_variance__c as Minutes_Variance
, ph.number_of_photographers__c as Number_of_Photographers
, ph.picture_date__c as Picture_Date
, ph.reason__c as Reason
, ph.recommended_minutes__c as Recommended_Minutes
, e.employee_oid as Reviewer_employee_oid
, ph.Scheduled_Assist_Photog_Min
, ph.scheduled_csr_minutes__c as Scheduled_CSR_Min
, ph.scheduled_group_minutes__c as Scheduled_Group_Min
, ph.scheduled_i_depot_minutes__c as Scheduled_I_Depot_Min
, ph.Scheduled_In_Training_Min
, ph.Scheduled_Photography_Min
, ph.scheduled_total_minutes__c as Scheduled_Total_Min
, ph.setup_minutes__c as Setup_Min
, ph.status__c as Status
, ph.sub_program__c as Sub_Program_name
, bo.booking_opportunity_oid
, wo.nss_job_number__c as event_ref_id
from ods_stage.sf_photography_hours_stg ph
, ods_stage.sf_booking_opportunity_xr boxr
, ods_own.booking_opportunity bo
, ods_stage.sf_user_stg sfe
, ods_own.employee e
, ods_stage.sf_workorder_stg wo
where 1=1
and ph.opportunity__c = boxr.sf_id -- inner join as these are the only ones we want
and boxr.booking_opportunity_oid = bo.booking_opportunity_oid
and ph.reviewer__c = sfe.id(+)
and sfe.external_system_id__c = e.employee_number(+)
and ph.parentrecordid__c = wo.id(+)
and ph.isdeleted = 0
and ph.isactive__c = 1
and ph.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* sf_photography_hours_xr */

merge into ods_stage.photography_hours_xr t
using sf_ph s
on ( s.id = t.photographyhoursid )
when not matched then insert
( t.photography_hours_oid
, t.photographyhoursid
, t.ods_create_date
)
values
( ods_stage.photography_hours_oid_seq.nextval
, s.id
, sysdate
)

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* ods_own.photography_hours */

merge into ods_own.photography_hours t
using 
( select phxr.photography_hours_oid
, ss.source_system_oid
, ph.Name
, ph.Additional_Info
, ph.territory_code
, ph.Clicks
, ph.Current_Oversched_Thresh
, ph.Current_Undersched_Thresh
, ph.Estimated_to_be_Photographed
, ph.Minutes_Variance
, ph.Number_of_Photographers
, ph.Picture_Date
, ph.Reason
, ph.Recommended_Minutes
, ph.Reviewer_employee_oid
, ph.Scheduled_Assist_Photog_Min
, ph.Scheduled_CSR_Min
, ph.Scheduled_Group_Min
, ph.Scheduled_I_Depot_Min
, ph.Scheduled_In_Training_Min
, ph.Scheduled_Photography_Min
, ph.Scheduled_Total_Min
, ph.Setup_Min
, ph.Status
, ph.Sub_Program_name
, ph.booking_opportunity_oid
, ph.event_ref_id
from sf_ph ph
, ods_stage.photography_hours_xr phxr
, ods_own.source_system ss
where ph.id = phxr.photographyhoursid
and ss.source_system_short_name = 'SF'
) s
on ( s.photography_hours_oid = t.photography_hours_oid )
when matched then update
set t.BOOKING_OPPORTUNITY_OID = s.booking_opportunity_oid
, t.Name = s.Name
, t.Additional_Info = s.Additional_Info
, t.territory_code = s.territory_code
, t.Clicks = s.Clicks
, t.Current_Oversched_Thresh = s.Current_Oversched_Thresh
, t.Current_Undersched_Thresh = s.Current_Undersched_Thresh
, t.Estimated_to_be_Photographed = s.Estimated_to_be_Photographed
, t.Minutes_Variance = s.Minutes_Variance
, t.Number_of_Photographers = s.Number_of_Photographers
, t.Picture_Date = s.Picture_Date
, t.Reason = s.Reason
, t.Recommended_Minutes = s.Recommended_Minutes
, t.Reviewer_employee_oid = s.Reviewer_employee_oid
, t.Scheduled_Assist_Photog_Min = s.Scheduled_Assist_Photog_Min
, t.Scheduled_CSR_Min = s.Scheduled_CSR_Min
, t.Scheduled_Group_Min = s.Scheduled_Group_Min
, t.Scheduled_I_Depot_Min = s.Scheduled_I_Depot_Min
, t.Scheduled_In_Training_Min = s.Scheduled_In_Training_Min
, t.Scheduled_Photography_Min = s.Scheduled_Photography_Min
, t.Scheduled_Total_Min = s.Scheduled_Total_Min
, t.Setup_Min = s.Setup_Min
, t.Status = s.Status
, t.Sub_Program_name = s.sub_program_name 
, t.event_ref_id = s.event_ref_id
where decode(t.BOOKING_OPPORTUNITY_OID , s.booking_opportunity_oid,1,0) = 0
or decode( t.Name , s.Name,1,0) = 0
or decode( t.Additional_Info , s.Additional_Info,1,0) = 0
or decode( t.territory_code , s.territory_code,1,0) = 0
or decode( t.Clicks , s.Clicks,1,0) = 0
or decode( t.Current_Oversched_Thresh , s.Current_Oversched_Thresh,1,0) = 0
or decode( t.Current_Undersched_Thresh , s.Current_Undersched_Thresh,1,0) = 0
or decode( t.Estimated_to_be_Photographed , s.Estimated_to_be_Photographed,1,0) = 0
or decode( t.Minutes_Variance , s.Minutes_Variance,1,0) = 0
or decode( t.Number_of_Photographers , s.Number_of_Photographers,1,0) = 0
or decode( t.Picture_Date , s.Picture_Date,1,0) = 0
or decode( t.Reason , s.Reason,1,0) = 0
or decode( t.Recommended_Minutes , s.Recommended_Minutes,1,0) = 0
or decode( t.Reviewer_employee_oid , s.Reviewer_employee_oid,1,0) = 0
or decode( t.Scheduled_Assist_Photog_Min , s.Scheduled_Assist_Photog_Min,1,0) = 0
or decode( t.Scheduled_CSR_Min , s.Scheduled_CSR_Min,1,0) = 0
or decode( t.Scheduled_Group_Min , s.Scheduled_Group_Min,1,0) = 0
or decode( t.Scheduled_I_Depot_Min , s.Scheduled_I_Depot_Min,1,0) = 0
or decode( t.Scheduled_In_Training_Min , s.Scheduled_In_Training_Min,1,0) = 0
or decode( t.Scheduled_Photography_Min , s.Scheduled_Photography_Min,1,0) = 0
or decode( t.Scheduled_Total_Min , s.Scheduled_Total_Min,1,0) = 0
or decode( t.Setup_Min , s.Setup_Min,1,0) = 0
or decode( t.Status , s.Status,1,0) = 0
or decode( t.Sub_Program_name , s.sub_program_name ,1,0) = 0
or decode( t.event_Ref_id , s.event_ref_id ,1,0) = 0
when not matched then insert
( t.photography_hours_oid 
, t.BOOKING_OPPORTUNITY_OID
, t.Name
, t.Additional_Info
, t.territory_code
, t.Clicks
, t.Current_Oversched_Thresh
, t.Current_Undersched_Thresh
, t.Estimated_to_be_Photographed
, t.Minutes_Variance
, t.Number_of_Photographers
, t.Picture_Date
, t.Reason
, t.Recommended_Minutes
, t.Reviewer_employee_oid
, t.Scheduled_Assist_Photog_Min
, t.Scheduled_CSR_Min
, t.Scheduled_Group_Min
, t.Scheduled_I_Depot_Min
, t.Scheduled_In_Training_Min
, t.Scheduled_Photography_Min
, t.Scheduled_Total_Min
, t.Setup_Min
, t.Status
, t.Sub_Program_name
, t.event_ref_id
, t.ODS_CREATE_DATE
, t.ODS_MODIFY_DATE
, t.SOURCE_SYSTEM_OID
)
values
( s.photography_hours_oid
, s.BOOKING_OPPORTUNITY_OID
, s.Name
, s.Additional_Info
, s.territory_code
, s.Clicks
, s.Current_Oversched_Thresh
, s.Current_Undersched_Thresh
, s.Estimated_to_be_Photographed
, s.Minutes_Variance
, s.Number_of_Photographers
, s.Picture_Date
, s.Reason
, s.Recommended_Minutes
, s.Reviewer_employee_oid
, s.Scheduled_Assist_Photog_Min
, s.Scheduled_CSR_Min
, s.Scheduled_Group_Min
, s.Scheduled_I_Depot_Min
, s.Scheduled_In_Training_Min
, s.Scheduled_Photography_Min
, s.Scheduled_Total_Min
, s.Setup_Min
, s.Status
, s.Sub_Program_name
, s.event_ref_id
, sysdate
, sysdate
, s.SOURCE_SYSTEM_OID
)

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* delete photography_hours */

delete from ods_own.photography_hours t
where exists
(
select 1
from ods_stage.sf_photography_hours_stg s
, ods_stage.photography_hours_xr phxr
where s.id = phxr.photographyhoursid
and phxr.photography_hours_oid = t.photography_hours_oid
and (   s.isactive__c <> 1
     or s.isdeleted <> 0
)
and s.ods_modify_date >  TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
)

&


/*-----------------------------------------------*/
/* TASK No. 9 */
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
             SUBSTR('2024-08-28 02:45:39.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/

&


/*-----------------------------------------------*/
/* TASK No. 10 */
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
,'LOAD_SF_PHOTOGRAPHY_HOURS_PKG'
,'002'
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
30601947200,
'LOAD_SF_PHOTOGRAPHY_HOURS_PKG',
'002',
TO_DATE(
             SUBSTR('2024-08-28 02:45:39.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/


&


/*-----------------------------------------------*/
