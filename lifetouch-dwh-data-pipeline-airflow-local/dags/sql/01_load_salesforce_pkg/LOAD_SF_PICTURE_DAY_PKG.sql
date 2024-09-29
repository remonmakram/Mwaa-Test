/* TASK No. 1 */
/* drop table sf_wo_driver */

BEGIN
    EXECUTE IMMEDIATE 'drop table sf_wo_driver';
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
/* TASK No. 2 */
/* create table sf_wo_driver */

create table sf_wo_driver as
select distinct workorderid__c
from ods_stage.sf_picture_date_stg
where workorderid__c is not null
and ods_modify_date > sysdate - 5

&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* pds_event_xr */

merge into ods_stage.pds_event_xr t
using
(
select wo.id
, wo.nss_event_type__c
, min(pd.date__c) as start_date
, max(pd.date__c) as end_date
from sf_wo_driver d
, ods_stage.sf_picture_date_stg pd
, ods_stage.sf_opportunity_stg o
, ods_stage.sf_workorder_stg wo
where d.workorderid__c = pd.workorderid__c
and pd.opportunityid__c = o.id
and pd.workorderid__c = wo.id
group by wo.id
, wo.nss_event_type__c
) s
on ( s.id = t.event_identifier )
when not matched then insert
( t.pds_event_oid
, t.event_identifier
, t.ods_create_date
)
values
( ods_stage.pds_event_oid_seq.nextval
, s.id
, sysdate
)


&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* ods_own.pds_event */

merge into ods_own.pds_event t
using
(
select wo.id
, wo.nss_event_type__c
, pdexr.pds_event_oid
, ss.source_system_oid
, min(pd.date__c) as start_date
, max(pd.date__c) as end_date
from sf_wo_driver d
, ods_stage.sf_picture_date_stg pd
, ods_stage.sf_opportunity_stg o
, ods_stage.sf_workorder_stg wo
, ods_stage.pds_event_xr pdexr
, ods_own.source_system ss
where d.workorderid__c = pd.workorderid__c
and pd.opportunityid__c = o.id
and pd.workorderid__c = wo.id
and wo.id = pdexr.event_identifier
and pd.date__c is not null
and ss.source_system_short_name = 'SF'
group by wo.id
, wo.nss_event_type__c
, pdexr.pds_event_oid
, ss.source_system_oid
) s
on ( s.pds_event_oid = t.pds_event_oid )
when matched then update
set t.start_date = s.start_date
, t.end_date = s.end_date
, t.event_type = s.nss_event_type__c
, t.ods_modify_date = sysdate
where decode(t.start_date , s.start_date,1,0) = 0
or decode(t.end_date , s.end_date,1,0) = 0
or decode(t.event_type , s.nss_event_type__c,1,0) = 0
when not matched then insert
( t.pds_event_oid
, t.event_identifier
, t.ods_create_date
, t.ods_modify_date
, t.source_system_oid
, t.start_date
, t.end_date
, t.event_type
, t.version
)
values
( s.pds_event_oid
, s.id
, sysdate
, sysdate
, s.source_system_oid
, s.start_date
, s.end_date
, s.nss_event_type__c
,0
)

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* picture_day_xr */

merge into ods_stage.sf_picture_day_xr t
using
(
select pd.id
, o.area__c
, wo.nss_job_number__c
, o.lid__c
, o.nss_sub_program__c
from ods_stage.sf_picture_date_stg pd
, ods_stage.sf_opportunity_stg o
, ods_stage.sf_workorder_stg wo
where pd.opportunityid__c = o.id
and pd.workorderid__c = wo.id(+)
and pd.date__c > trunc(sysdate) - 60
) s
on ( s.id = t.picture_day_id )
when matched then update
set t.area__c = s.area__c
, t.nss_job_number__c = s.nss_job_number__c
, t.lid__c = s.lid__c
, t.nss_sub_program__c = s.nss_sub_program__c
where decode(t.area__c , s.area__c,1,0) = 0
or decode(t.nss_job_number__c , s.nss_job_number__c,1,0) = 0
or decode(t.lid__c , s.lid__c,1,0) = 0
or decode(t.nss_sub_program__c , s.nss_sub_program__c,1,0) = 0
when not matched then insert
( t.picture_day_oid
, t.picture_day_id
, t.area__c
, t.nss_job_number__c
, t.lid__c
, t.nss_sub_program__c
, t.ods_create_date
)
values
( ODS_STAGE.PICTURE_DAY_OID_SEQ.nextval
, s.id
, s.area__c
, s.nss_job_number__c
, s.lid__c
, s.nss_sub_program__c
, sysdate
)


&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* map the Candids sub program */

merge into ods_stage.sf_picture_day_xr t
using
(
select xr.picture_day_id
from ods_stage.sf_picture_day_xr xr
where xr.nss_sub_program__c is null
and xr.ods_create_date > sysdate - 2
and exists
(
select 1
from ods_stage.sf_serviceappointment_stg sa
, ods_stage.sf_Recordtype_stg sart
where xr.picture_day_id = sa.picturedateid__c
and sa.recordtypeid = sart.id
and sa.status not in 'Canceled'
and sa.isdeleted not in 1
and sart.name = 'Candid Picture Day'
)
) s
on ( s.picture_day_id = t.picture_day_id )
when matched then update
set t.nss_sub_program__c = 'Candids'


&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* drop table sf_pd_sa_detail */

BEGIN
    EXECUTE IMMEDIATE 'drop table sf_pd_sa_detail';
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
/* TASK No. 8 */
/* create table sf_pd_sa_detail */

create table sf_pd_sa_detail as
select picture_day_oid
, max(status) as max_status
, 'ACTIVE' as status
, listagg(status,'; ') within group (order by status) as detail_status
, case when max(appointments_scheduled__c) = 1 then 'Y' else null end as appointments_scheduled__c
from
(
select pdxr.picture_day_oid
, sa.status
, max(appointments_scheduled__c) as appointments_scheduled__c
from ods_stage.sf_picture_date_stg pd
, ods_stage.sf_picture_day_xr pdxr
, ods_stage.sf_serviceappointment_stg sa
where pd.id = pdxr.picture_day_id
and pd.id = sa.picturedateid__c
and sa.isdeleted not in (1)
and sa.status <> 'Canceled'
and pd.date__c > trunc(sysdate) - 60
group by pdxr.picture_day_oid
, sa.status
)
group by picture_day_oid

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/*  ods_own.picture_day */

merge into ods_own.picture_day t
using
(
select pdxr.picture_day_oid
, pd.id
, o.area__c
, wo.nss_job_number__c as event_ref_id
, wo.nss_event_type__c as event_type
, nvl(pe.pds_event_oid, 0) as pds_event_oid
, o.lid__c
, a.account_oid
, a.lifetouch_id
, a.enrollment
, pdxr.nss_sub_program__c as sub_program_name
, o.ams_booking_id__c as lt_booking_id
, o.ASSIGNED_SALES_PRO__C as sales_rep_name
, o.nss_selling_method__c as payment_type
, boxr.booking_opportunity_oid
, e.event_oid
, ss.source_system_oid
, case when sa_detail.max_status = 'Needs to be Rescheduled'
    then to_date(to_char(pd.date__c,'YYYY') || '1225','YYYYMMDD')
   else trunc(pd.date__c) end as picture_day_date
, pd.name as picture_day_name
, to_char(pd.setuptime__c, 'hh:mi AM') as arrival_time
, to_char(pd.starttime__c, 'hh:mi AM') as start_time
, to_char(pd.endtime__c, 'hh:mi AM') as end_time
, pd.location__c as location
, pd.NUMBERTOBEPHOTOGRAPHED__C as est_subjects
, sp.sub_program_oid
, org.organization_oid
, 0 as territory_id
, 'ACTIVE' as status
, sa_detail.appointments_scheduled__c
, sa_detail.detail_status
, pd.gradestobephotographed__c
from ods_stage.sf_picture_date_stg pd
, ods_stage.sf_picture_day_xr pdxr
, ods_stage.sf_opportunity_stg o
, ods_own.account a
, ods_stage.sf_booking_opportunity_xr boxr
, ods_stage.sf_workorder_stg wo
, ods_own.pds_event pe
, ods_own.event e
, ods_own.sub_program sp
, ods_own.source_system ss
, (select * from ods_own.organization where org_type_level = 6) org
, sf_pd_sa_detail sa_detail
where pd.id = pdxr.picture_day_id
and pd.isdeleted = 0
and pd.opportunityid__c = o.id
and pd.opportunityid__c = boxr.sf_id(+)
and o.lid__c = a.lifetouch_id
and pd.workorderid__c = wo.id(+)
and pd.workorderid__c = pe.event_identifier(+)
and wo.nss_job_number__c = e.event_ref_id(+)
and pdxr.nss_sub_program__c = sp.sub_program_name(+)
and o.area__c = org.org_code
and ss.source_system_short_name = 'SF'
and pdxr.picture_day_oid = sa_detail.picture_day_oid(+)
and pd.date__c > trunc(sysdate) - 60
and exists
(
select 1
from ods_stage.sf_serviceappointment_stg sa
where pd.id = sa.picturedateid__c
and sa.status not in 'Canceled'
and sa.isdeleted not in 1
)
) s
on ( s.picture_day_oid = t.picture_day_oid )
when matched then update
set t.pds_event_oid = s.pds_event_oid
, t.sub_program_oid = s.sub_program_oid
, t.account_oid = s.account_oid
, t.event_oid = s.event_oid
, t.end_time = s.end_time
, t.enrollment = s.enrollment
, t.event_ref_id = s.event_ref_id
, t.lifetouch_id = s.lifetouch_id
, t.location = s.location
, t.payment_type = s.payment_type
, t.picture_day_date = s.picture_day_date
, t.picture_day_name = s.picture_day_name
, t.sales_rep_name = s.sales_rep_name
, t.start_time = s.start_time
, t.sub_program_name = s.sub_program_name
, t.territory_id = s.territory_id
, t.lt_booking_id = s.lt_booking_id
, t.est_subjects = s.est_subjects
, t.organization_oid = s.organization_oid
, t.arrival_time = s.arrival_time
, t.status = s.status
, t.appointments_scheduled = s.appointments_scheduled__c
, t.detail_status = s.detail_status
, t.grades_to_be_photographed = s.gradestobephotographed__c
, t.ods_modify_date = sysdate
where decode(t.pds_event_oid, s.pds_event_oid,1,0) = 0
or decode(t.sub_program_oid , s.sub_program_oid,1,0) = 0
or decode(t.account_oid , s.account_oid,1,0) = 0
or decode(t.event_oid , s.event_oid,1,0) = 0
or decode(t.end_time , s.end_time,1,0) = 0
or decode(t.enrollment , s.enrollment,1,0) = 0
or decode(t.event_ref_id , s.event_ref_id,1,0) = 0
or decode(t.lifetouch_id , s.lifetouch_id,1,0) = 0
or decode(t.location , s.location,1,0) = 0
or decode(t.payment_type , s.payment_type,1,0) = 0
or decode(t.picture_day_date , s.picture_day_date,1,0) = 0
or decode(t.picture_day_name , s.picture_day_name,1,0) = 0
or decode(t.sales_rep_name , s.sales_rep_name,1,0) = 0
or decode(t.start_time , s.start_time,1,0) = 0
or decode(t.sub_program_name , s.sub_program_name,1,0) = 0
or decode(t.territory_id , s.territory_id,1,0) = 0
or decode(t.lt_booking_id , s.lt_booking_id,1,0) = 0
or decode(t.est_subjects , s.est_subjects,1,0) = 0
or decode(t.organization_oid , s.organization_oid,1,0) = 0
or decode(t.arrival_time , s.arrival_time,1,0) = 0
or decode(t.status , s.status,1,0) = 0
or decode(t.appointments_scheduled, s.appointments_scheduled__c,1,0) = 0
or decode(t.detail_status , s.detail_status,1,0) = 0
or decode(t.grades_to_be_photographed , s.gradestobephotographed__c,1,0) = 0
when not matched then insert
( t.picture_day_oid
, t.source_system_oid
, t.ods_create_date
, t.ods_modify_date
, t.pds_event_oid
, t.sub_program_oid
, t.account_oid
, t.event_oid
, t.end_time
, t.enrollment
, t.event_ref_id
, t.lifetouch_id
, t.location
, t.payment_type
, t.picture_day_date
, t.picture_day_name
, t.sales_rep_name
, t.start_time
, t.sub_program_name
, t.territory_id
, t.lt_booking_id
, t.est_subjects
, t.organization_oid
, t.arrival_time
, t.version
, t.status
, t.appointments_scheduled
, t.detail_status
, t.grades_to_be_photographed
)
values
( s.picture_day_oid
, s.source_system_oid
, sysdate
, sysdate
, s.pds_event_oid
, s.sub_program_oid
, s.account_oid
, s.event_oid
, s.end_time
, s.enrollment
, s.event_ref_id
, s.lifetouch_id
, s.location
, s.payment_type
, s.picture_day_date
, s.picture_day_name
, s.sales_rep_name
, s.start_time
, s.sub_program_name
, s.territory_id
, s.lt_booking_id
, s.est_subjects
, s.organization_oid
, s.arrival_time
, 0
, s.status
, s.appointments_scheduled__c
, s.detail_status
, s.gradestobephotographed__c
)

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* drop table sf_picture_day_team_member */

BEGIN
    EXECUTE IMMEDIATE 'drop table sf_picture_day_team_member';
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
/* TASK No. 11 */
/* create table sf_picture_day_team_member */

create table sf_picture_day_team_member as
select u.id as user_id
, u.street
, u.city
, u.statecode
, u.postalcode
, u.email
, u.firstname
, u.lastname
, u.title
, e.employee_oid
, u.external_system_id__c
from ods_stage.sf_user_stg u
, ods_own.employee e
where u.external_system_id__c = e.employee_number(+)
and exists
(
select 1
from ods_stage.sf_serviceappointment_stg sa
, ods_stage.sf_assignedresource_stg ar
, ods_stage.sf_serviceresource_stg sr
, ods_stage.sf_recordtype_stg sart
where ar.serviceappointmentid = sa.id
and ar.serviceresourceid = sr.id
and sr.relatedrecordid = u.id
and sa.recordtypeid = sart.id
and sart.name in ('School Picture Day','Candid Picture Day')
and sa.asset_type__c is null
and sa.nss_picture_date__c > trunc(sysdate) - 60
)


&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* sf_picture_day_team_member_xr */

insert into ods_stage.sf_picture_day_team_member_xr
( picture_day_team_member_oid
, user_id
, ods_create_date
)
select ods_stage.picture_day_team_member_oidseq.nextval
, user_id
, sysdate
from sf_picture_day_team_member sf
where not exists
(
select 1
from ods_stage.sf_picture_day_team_member_xr t
where t.user_id = sf.user_id
)

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* picture_day_team_member */

merge into ods_own.picture_day_team_member t
using
(
select xr.picture_day_team_member_oid
, sf.street
, sf.city
, sf.statecode
, sf.postalcode
, sf.email
, sf.firstname
, sf.lastname
, sf.title
, sf.employee_oid
, sf.external_system_id__c
, ss.source_system_oid
from sf_picture_day_team_member sf
, ods_stage.sf_picture_day_team_member_xr xr
, ods_own.source_system ss
where sf.user_id = xr.user_id
and ss.source_system_short_name = 'SF'
) s
on ( t.picture_day_team_member_oid = s.picture_day_team_member_oid )
when matched then update
set t.address1 = s.street
, t.city = s.city
, t.state = s.statecode
, t.zip = s.postalcode
, t.email = s.email
, t.first_name = s.firstname
, t.last_name = s.lastname
, t.title = s.title
, t.employee_oid = s.employee_oid
, t.sap_id = s.external_system_id__c
, t.ods_modify_date = sysdate
where decode(t.address1 , s.street,1,0) = 0
or decode(t.city , s.city,1,0) = 0
or decode(t.state , s.statecode,1,0) = 0
or decode(t.zip , s.postalcode,1,0) = 0
or decode(t.email , s.email,1,0) = 0
or decode(t.first_name , s.firstname,1,0) = 0
or decode(t.last_name , s.lastname,1,0) = 0
or decode(t.title , s.title,1,0) = 0
or decode(t.employee_oid , s.employee_oid,1,0) = 0
or decode(t.sap_id , s.external_system_id__c,1,0) = 0
when not matched then insert
( picture_day_team_member_oid
, address1
, city
, state
, zip
, email
, first_name
, last_name
, title
, employee_oid
, sap_id
, ods_modify_date
, ods_create_date
, source_system_oid
)
values
( s.picture_day_team_member_oid
, s.street
, s.city
, s.statecode
, s.postalcode
, s.email
, s.firstname
, s.lastname
, s.title
, s.employee_oid
, s.external_system_id__c
, sysdate
, sysdate
, s.source_system_oid
)

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* drop table sf_picture_day_team2  */

BEGIN
    EXECUTE IMMEDIATE 'drop table sf_picture_day_team2';
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
/* TASK No. 15 */
/* create table sf_picture_day_team2 */

create table sf_picture_day_team2 as
select ar.id as ar_id
, pd.id as picture_day_id
, pdxr.picture_day_oid
, o.area__c
, pd.date__c
, u.id as user_id
, u.external_system_id__c
, substr(sa.photographer_role__c,1,255) as role_type
, e.employee_oid
, pdtmxr.picture_day_team_member_oid
, sa.duration
from ods_stage.sf_assignedresource_stg ar
, ods_stage.sf_serviceappointment_stg sa
, ods_stage.sf_picture_date_stg pd
, ods_stage.sf_opportunity_stg o
, ods_stage.sf_serviceresource_stg sr
, ods_stage.sf_user_stg u
, ods_own.employee e
, ods_stage.sf_picture_day_team_member_xr pdtmxr
, ods_stage.sf_picture_day_xr pdxr
, ods_stage.sf_recordtype_stg sart
where ar.serviceappointmentid = sa.id
and sa.picturedateid__c = pd.id
and pd.opportunityid__c = o.id
and ar.serviceresourceid = sr.id(+)
and sr.relatedrecordid = u.id(+)
and u.external_system_id__c = e.employee_number(+)
and u.id = pdtmxr.user_id(+)
and pd.id = pdxr.picture_day_id(+)
and sa.recordtypeid = sart.id
and sart.name in ('School Picture Day','Candid Picture Day')
and sa.asset_type__c is null
and ar.isdeleted = 0
and sa.isdeleted = 0
and sr.isactive = 1
and sa.nss_picture_date__c > trunc(sysdate) - 60


&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* sf_picture_day_team_xr */

insert into ods_stage.sf_picture_day_team_xr
( picture_day_team_oid
, ar_id
, ods_create_date
)
select ods_stage.picture_day_team_oid_seq.nextval
, pdt.ar_id
, sysdate
from sf_picture_day_team2 pdt
, ods_stage.sf_picture_day_xr pdxr
, ods_own.picture_day pd
where 1=1
and pdt.picture_day_id = pdxr.picture_day_id
and pdxr.picture_day_oid = pd.picture_day_oid
and not exists
(
select 1
from ods_stage.sf_picture_day_team_xr t
where t.ar_id = pdt.ar_id
)

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* picture_day_team */

merge into ods_own.picture_day_team t
using
(
select xr.picture_day_team_oid
, sf.ar_id
, sf.picture_day_id
, sf.picture_day_oid
, sf.area__c
, sf.date__c
, sf.user_id
, sf.external_system_id__c
, sf.role_type
, sf.employee_oid
, sf.picture_day_team_member_oid
, sf.duration
, ss.source_system_oid
from sf_picture_day_team2 sf
, ods_stage.sf_picture_day_team_xr xr
, ods_own.source_system ss
where sf.ar_id = xr.ar_id
and sf.picture_day_oid is not null
and ss.source_system_short_name = 'SF'
) s
on ( s.picture_day_team_oid = t.picture_day_team_oid )
when matched then update
set t.picture_day_team_member_oid = s.picture_day_team_member_oid
, t.employee_oid = s.employee_oid
, t.role_type = s.role_type
, t.duration = s.duration
, t.ods_modify_date = sysdate
where decode(t.picture_day_team_member_oid , s.picture_day_team_member_oid,1,0) = 0
or decode( t.employee_oid , s.employee_oid,1,0) = 0
or decode( t.role_type , s.role_type,1,0) = 0
or decode( t.duration , s.duration,1,0) = 0
when not matched then insert
( picture_day_team_oid
, picture_day_team_member_oid
, picture_day_oid
, employee_oid
, role_type
, duration
, source_system_oid
, ods_create_date
, ods_modify_date
, version
)
values
( s.picture_day_team_oid
, s.picture_day_team_member_oid
, s.picture_day_oid
, s.employee_oid
, s.role_type
, s.duration
, s.source_system_oid
, sysdate
, sysdate
, 0
)

&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* delete picture_day_team */

delete from ods_own.picture_day_team t 
where t.ods_create_date > sysdate - 60
and exists
(
select 1
from ods_stage.sf_picture_day_team_xr pdtxr
, ods_stage.sf_assignedresource_stg ar
, ods_stage.sf_serviceappointment_stg sa
, ods_stage.sf_serviceresource_stg sr
where 1=1
and pdtxr.picture_day_team_oid = t.picture_day_team_oid
and pdtxr.ar_id = ar.id
and ar.serviceappointmentid = sa.id
and ar.serviceresourceid = sr.id
and ( sr.isactive = 0
        or sa.isdeleted = 1
        or ar.isdeleted = 1
       )
)

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* drop table sf_picture_day_delete */

BEGIN
    EXECUTE IMMEDIATE 'drop table sf_picture_day_delete';
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
/* TASK No. 20 */
/* create table sf_picture_day_delete */

create table sf_picture_day_delete as
select pd.picture_day_oid
from ods_own.picture_day pd
, ods_own.source_system ss
, ods_stage.sf_picture_day_xr pdxr
, ods_stage.sf_picture_date_stg sfpd
where pd.source_system_oid = ss.source_system_oid
and pd.picture_day_oid = pdxr.picture_day_oid
and pdxr.picture_day_id = sfpd.id
and ss.source_system_short_name = 'SF'
and pd.picture_day_date >  trunc(sysdate) - 60
and not exists
(
select 1
from ods_stage.sf_serviceappointment_stg sa2
where pdxr.picture_day_id = sa2.picturedateid__c
and sa2.status not in 'Canceled'
and sa2.isdeleted not in 1
)

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* delete cancelled picture_days */

delete from ods_own.picture_day t
where t.picture_day_date  > trunc(sysdate) - 30 
and exists
(
select 1
from sf_picture_day_delete d
where 1=1
and d.picture_day_oid = t.picture_day_oid
) 

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* insert picture_day_deleted so deleted rows flow to CDW and CARE */

insert into ods_stage.picture_day_deleted
(id
,date_deleted
,ods_create_date
,ods_modify_date
)
select s.picture_day_oid -- was changed to use OID when Salesforce became source system
, sysdate
, sysdate
, sysdate
from  sf_picture_day_delete s
where not exists
( 
select 1
from  ods_stage.picture_day_deleted d
where d.id = s.picture_day_oid
)


&


/*-----------------------------------------------*/
