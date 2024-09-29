/* TASK No. 1 */
/* delete stale userterritory2association rows */

delete from ods_stage.sf_userterritory2associatn_stg s
where exists
(
select 1
from ods_stage.sf_copystorm_delete_detector d
where d.table_name = 'userterritory2association'
and d.min_backupmodifieddate > s.backupmodifieddate
and d.min_backupmodifieddate < sysdate + 1 -- give copystorm time to complete re-filling table
)

&


/*-----------------------------------------------*/
/* TASK No. 2 */
/* delete stale objectterritory2association rows */

delete from ods_stage.sf_objectterritory2assoctn_stg s
where exists
(
select 1
from ods_stage.sf_copystorm_delete_detector d
where d.table_name = 'objectterritory2association'
and d.min_backupmodifieddate > s.backupmodifieddate
and d.min_backupmodifieddate < sysdate + 1 -- give copystorm time to complete re-filling table
)

&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* drop sf_assignment */

BEGIN
    EXECUTE IMMEDIATE 'drop table sf_assignment';
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
/* TASK No. 4 */
/* create sf_assignment */

create table sf_assignment as
select a.lid__c
, oa.lifetouch_id
, oa.account_oid
, pg.program_group_code
, p.program_oid
, p.program_name
, p.program_id
, max(a.nss_territory_code__c) as territory_code
, max(t.name) as t2name
, max(substr(t.name,1,2)) as t2name_1_2
, max(t.territory_code__c) as territory_code__c
, max(a.nss_territory_code__c) as nss_territory_code__c
, max(ot.organization_oid) as organization_oid
, max(case when (uta.roleinterritory2 = 'Yearbook Specialist' or nvl(e.term_date,sysdate + 1) < sysdate) then null else  uta.roleinterritory2 end) as roleinterritory2
, max(case when (uta.roleinterritory2 = 'Yearbook Specialist' or nvl(e.term_date,sysdate + 1) < sysdate) then null else u.firstname end) as firstname
, max(case when (uta.roleinterritory2 = 'Yearbook Specialist' or nvl(e.term_date,sysdate + 1) < sysdate) then null else u.lastname end) as lastname
, max(case when (uta.roleinterritory2 = 'Yearbook Specialist' or nvl(e.term_date,sysdate + 1) < sysdate) then null else e.employee_oid end) as employee_oid
, max(case when (uta.roleinterritory2 = 'Yearbook Specialist' or nvl(e.term_date,sysdate + 1) < sysdate) then null else u.employeenumber end) as employeenumber
, max(case when (uta.roleinterritory2 = 'Yearbook Specialist' or nvl(e.term_date,sysdate + 1) < sysdate) then null else u.external_system_id__c end) as external_system_id__c
, max(case when (uta.roleinterritory2 = 'Yearbook Specialist' or nvl(e.term_date,sysdate + 1) < sysdate) then null else u.misc_code__c end) as  misc_code__c
, max(case when (uta.roleinterritory2 = 'Yearbook Specialist' or nvl(e.term_date,sysdate + 1) < sysdate) then null else u.sales_rep_number__c end) as sales_rep_number__c
, max(case when (uta.roleinterritory2 = 'Yearbook Specialist' or nvl(e.term_date,sysdate + 1) < sysdate) then null else u.line_of_business__c end) as line_of_business__c
, max(case when (uta.roleinterritory2 = 'Yearbook Specialist' or nvl(e.term_date,sysdate + 1) < sysdate) then null else u.username end) as username
, max(a.id) as account_id
, max(ota.isdeleted) as isdeleted
, max(uta.isactive) as isactive
, count(distinct a.nss_territory_code__c) as territory_codes
, count(distinct (case when (uta.roleinterritory2 = 'Yearbook Specialist' or  nvl(e.term_date,sysdate + 1) < sysdate) then null else  u.id end)) as sales_reps
from (select * from ODS_STAGE.sf_account_stg where isdeleted <>1) a
, (select * from ODS_STAGE.sf_objectterritory2assoctn_stg where isdeleted <>1) ota
, ODS_STAGE.sf_territory2_stg t
,
(
select *
from ODS_STAGE.sf_userterritory2associatn_stg
where isactive = 1
and roleinterritory2 in ('Schools Sales','Yearbook Specialist')
) uta
, (select * from ODS_STAGE.sf_user_stg where isactive = 1) u
,ODS_OWN.program_group pg
, ODS_OWN.program p
, ODS_OWN.account oa
, ODS_OWN.organization ot
, ODS_OWN.org_type tot
, ODS_OWN.employee e
, ods_stage.sf_recordtype_stg rt
where a.id = ota.objectid
and ota.sobjecttype = 'Account'
and ota.territory2id = t.id
and a.nss_territory_code__c = ot.org_code(+)
and ot.org_type_oid = tot.org_type_oid(+)
and tot.org_type_name(+) = 'Territory'
and t.id = uta.territory2id(+)
and uta.userid = u.id(+)
and pg.program_group_oid = p.program_group_oid
and a.lid__c = to_char(oa.lifetouch_id)
and nvl(trim(u.external_system_id__c), u.employeenumber) = e.employee_number(+)
and a.recordtypeid = rt.id
and rt.name = 'NSS - Account'
--and a.lid__c = '35636'
group by  a.lid__c
, oa.lifetouch_id
, oa.account_oid
, pg.program_group_code
, p.program_oid
, p.program_name
, p.program_id

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* delete 002_DUPE_LID errors */

delete from sf_assignment t
where exists
(
select a.lid__c
from  ODS_STAGE.sf_errors e
, ODS_STAGE.sf_account_stg a
where error_code = '002_DUPE_LID'
and sf_id = a.id
and a.lid__c = to_char(t.lifetouch_id)
and e.resolve_date is null
)


&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* index sf_assignment */

create unique index sf_assignment_pk on sf_assignment(lifetouch_id, program_oid)

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* drop sf_assignent_yb_rep */

BEGIN
    EXECUTE IMMEDIATE 'drop table sf_assignment_yb_rep';
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
/* create sf_assignment_yb_rep */

create table sf_assignment_yb_rep as
select oa.lifetouch_id
, p.program_oid
, p.program_name
, max(uta.roleinterritory2) as roleinterritory2
, max(u.firstname) as firstname
, max(u.lastname) as lastname
, max(case when nvl(e.term_date,sysdate + 1) < sysdate then null else e.employee_oid end) as employee_oid
, max(u.employeenumber) as employeenumber
, max(u.external_system_id__c) as external_system_id__c
, max(u.misc_code__c) as  misc_code__c
, max(u.sales_rep_number__c) as sales_rep_number__c
, max(u.line_of_business__c) as line_of_business__c
, max(u.username) as username
, max(ota.isdeleted) as isdeleted
, max(uta.isactive) as isactive
, count(distinct u.id) as sales_reps
from (select * from ODS_STAGE.sf_account_stg where isdeleted <>1) a
, (select * from ODS_STAGE.sf_objectterritory2assoctn_stg where isdeleted <>1) ota
, ODS_STAGE.sf_territory2_stg t
,(select * from ODS_STAGE.sf_userterritory2associatn_stg where isactive = 1) uta
, (select * from ODS_STAGE.sf_user_stg where isactive = 1) u
,ODS_OWN.program_group pg
, ODS_OWN.program p
, ODS_OWN.account oa
, ODS_OWN.organization ot
, ODS_OWN.org_type tot
, ODS_OWN.employee e
, ods_stage.sf_Recordtype_stg rt
where a.id = ota.objectid
and ota.sobjecttype = 'Account'
and ota.territory2id = t.id
and a.nss_territory_code__c = ot.org_code(+)
and ot.org_type_oid = tot.org_type_oid(+)
and tot.org_type_name(+) = 'Territory'
and t.id = uta.territory2id(+)
and uta.userid = u.id(+)
and pg.program_group_oid = p.program_group_oid
and a.lid__c = to_char(oa.lifetouch_id)
and nvl(trim(u.external_system_id__c), u.employeenumber) = e.employee_number(+)
and a.recordtypeid = rt.id
and rt.name = 'NSS - Account'
and e.term_date is null
and uta.roleinterritory2 = 'Yearbook Specialist'
and pg.program_group_code = 'YB'
group by oa.lifetouch_id
, p.program_oid
, p.program_name

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* index sf_assignment_yb_rep */

create unique index sf_assignment_yb_rep_pk on sf_assignment_yb_rep(lifetouch_id, program_oid)

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* merge yb_reps */

merge into sf_assignment t
using sf_assignment_yb_rep s
on ( t.lifetouch_id = s.lifetouch_id and t.program_oid = s.program_oid )
when matched then update
set t.roleinterritory2 = s.roleinterritory2
, t.firstname = s.firstname
, t.lastname = s.lastname
, t.employee_oid = s.employee_oid
, t.employeenumber = s.employeenumber
, t.external_system_id__c = s.external_system_id__c
, t.misc_code__c = s.misc_code__c
, t.sales_rep_number__c = s.sales_rep_number__c
, t.line_of_business__c = s.line_of_business__c
, t.username = s.username
, t.isdeleted = s.isdeleted
, t.isactive = s.isactive
, t.sales_reps = s.sales_reps

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* 008_DUPE_CALL_RIGHT errors - update last check date */

update ODS_STAGE.sf_errors t
set t.last_check_date = sysdate
where t.error_code in ('008_DUPE_CALL_RIGHT')
and t.resolve_date is null
and exists
(
select 1
from sf_assignment s
where s.territory_codes > 1
and s.lifetouch_id = t.lifetouch_id
and s.program_group_code = t.program_group_code
)

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* 008_DUPE_CALL_RIGHT errors - insert new errors */

insert into  ODS_STAGE.sf_errors t
( SF_ERRORS_OID
, ENTITY
, SF_ID
, ERROR_CODE
, ERROR_DATE
, LAST_CHECK_DATE
, RESOLVE_DATE
, PROGRAM_GROUP_CODE
, LIFETOUCH_ID
, DUPE_QTY
)
select ODS_STAGE.SF_ERRORS_OID_SEQ.NEXTVAL
, 'Calling Right'
, s.account_id
, '008_DUPE_CALL_RIGHT'
, sysdate
, sysdate
, null
, s.program_group_code
, s.lifetouch_id
, s.territory_codes
from
(
select distinct account_id
, program_group_code
, lifetouch_id
, territory_codes
from sf_assignment
where territory_codes > 1
) s
where not exists
(
select 1
from ODS_STAGE.sf_errors t2
where t2.error_code = '008_DUPE_CALL_RIGHT'
and t2.lifetouch_id = s.lifetouch_id
and t2.program_group_code = s.program_group_code
and t2.resolve_date is null
)

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* 008_DUPE_CALL_RIGHT errors - mark resolved */

update ODS_STAGE.sf_errors t
set t.resolve_date = sysdate
where t.resolve_date is null
and t.error_code = '008_DUPE_CALL_RIGHT'
and not exists
(
select 1
from sf_assignment s
where t.lifetouch_id = s.lifetouch_id
and t.program_group_code = s.program_group_code
and s.territory_codes > 1
)


&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* 009_DUPE_REP_ASSGN errors -  update last check date */

update ODS_STAGE.sf_errors t
set t.last_check_date = sysdate
where t.error_code in ('009_DUPE_REP_ASSGN')
and t.resolve_date is null
and exists
(
select 1
from sf_assignment s
where s.sales_reps > 1
and s.lifetouch_id = t.lifetouch_id
and s.program_group_code = t.program_group_code
)

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* 009_DUPE_REP_ASSGN errors - insert new rows */

insert into  ODS_STAGE.sf_errors t
( SF_ERRORS_OID
, ENTITY
, SF_ID
, ERROR_CODE
, ERROR_DATE
, LAST_CHECK_DATE
, RESOLVE_DATE
, PROGRAM_GROUP_CODE
, LIFETOUCH_ID
, DUPE_QTY
)
select ODS_STAGE.SF_ERRORS_OID_SEQ.NEXTVAL 
, 'Rep Assignment'
, s.account_id
, '009_DUPE_REP_ASSGN'
, sysdate
, sysdate
, null
, s.program_group_code
, s.lifetouch_id
, s.sales_reps
from
(
select distinct account_id
, program_group_code
, lifetouch_id
, sales_reps
from sf_assignment
where sales_reps > 1
) s
where not exists
(
select 1
from ODS_STAGE.sf_errors t2
where t2.error_code = '009_DUPE_REP_ASSGN'
and t2.lifetouch_id = s.lifetouch_id
and t2.program_group_code = s.program_group_code
and t2.resolve_date is null
)

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* 009_DUPE_REP_ASSGN errors - mark resolved */

update ODS_STAGE.sf_errors t
set t.resolve_date = sysdate
where t.resolve_date is null
and t.error_code =  '009_DUPE_REP_ASSGN'
and not exists
(
select 1
from sf_assignment s
where t.lifetouch_id = s.lifetouch_id
and t.program_group_code = s.program_group_code
and s.sales_reps > 1
)


&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* sf_calling_right_xr */

insert into ODS_STAGE.sf_calling_right_xr t
( calling_right_oid
, lifetouch_id
, program_name
, ods_create_date
)
select ODS_STAGE.CALLING_RIGHT_OID_seq.nextval
, sfa.lifetouch_id
, sfa.program_name
, sysdate
from sf_assignment sfa
where not exists
(
select 1
from ODS_STAGE.sf_calling_right_xr s
where s.lifetouch_id = sfa.lifetouch_id
and s.program_name = sfa.program_name
)

&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* calling_right */

merge into ODS_OWN.calling_right t
using
(
select xr.calling_right_oid
, sfa.account_oid
, sfa.program_oid
, sfa.organization_oid
, ss.source_system_oid
from sf_assignment sfa
, ODS_STAGE.sf_calling_right_xr xr
, ODS_OWN.source_system ss
where sfa.lifetouch_id = xr.lifetouch_id
and sfa.program_name = xr.program_name
and sfa.organization_oid is not null
and ss.source_system_short_name = 'SF'
) s
on ( s.calling_right_oid = t.calling_right_oid )
when matched then update
set t.organization_oid = s.organization_oid
, t.lt_start_date = sysdate
, t.lt_end_date = null
, t.ods_modify_date = sysdate
, t.source_system_oid = s.source_system_oid
where decode(t.organization_oid, s.organization_oid,1,0) = 0
or t.lt_end_date is not null
when not matched then insert
( t.calling_right_oid
, t.account_oid
, t.program_oid
, t.organization_oid
, t.lt_start_date
, t.ods_create_date
, t.ods_modify_date
, t.source_system_oid
)
values
( s.calling_right_oid
, s.account_oid
, s.program_oid
, s.organization_oid
, sysdate
, sysdate
, sysdate
, s.source_system_oid
)

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* inactivate calling_right */

update ODS_OWN.calling_right t
set lt_end_date = sysdate
, ods_modify_date = sysdate
where t.lt_end_date is null
and not exists
(
select 1
from sf_assignment sfa
where sfa.account_oid = t.account_oid
and sfa.program_oid = t.program_oid
and sfa.organization_oid is not null
)

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* sf_rep_assignment_xr */

insert into ODS_STAGE.sf_rep_assignment_xr t
( rep_assignment_oid
, lifetouch_id
, program_name
, rep_type
, ods_create_date
)
select ODS_STAGE.REP_ASSIGNMENT_OID_seq.nextval
, sfa.lifetouch_id
, sfa.program_name
, 'Sales'
, sysdate
from sf_assignment sfa
where sfa.employee_oid is not null
and not exists
(
select 1
from ODS_STAGE.sf_rep_assignment_xr s
where s.lifetouch_id = sfa.lifetouch_id
and s.program_name = sfa.program_name
and s.rep_type = 'Sales'
)

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* rep_assignment */

merge into ODS_OWN.rep_assignment t
using
(
select xr.rep_assignment_oid
, sfa.account_oid
, sfa.program_oid
, sfa.employee_oid
, ss.source_system_oid
from sf_assignment sfa
, ODS_STAGE.sf_rep_assignment_xr xr
, ods_own.source_system ss
where sfa.lifetouch_id = xr.lifetouch_id
and sfa.program_name = xr.program_name
and 'Sales' = xr.rep_type
and sfa.employee_oid is not null
and ss.source_system_short_name = 'SF'
and sfa.sales_reps = 1
) s
on ( s.rep_assignment_oid = t.rep_assignment_oid )
when matched then update
set t.employee_oid = s.employee_oid
, t.lt_rep_start_date = sysdate
, t.lt_rep_end_date = null
, t.ods_modify_date = sysdate
, t.source_system_oid = s.source_system_oid
where decode(t.employee_oid, s.employee_oid,1,0) = 0
or t.lt_rep_end_date is not null
when not matched then insert
( t.rep_assignment_oid
, t.account_oid
, t.program_oid
, t.rep_type
, t.employee_oid
, t.lt_rep_start_date
, t.ods_create_date
, t.ods_modify_date
, t.source_system_oid
)
values
( s.rep_assignment_oid
, s.account_oid
, s.program_oid
, 'Sales'
, s.employee_oid
, sysdate
, sysdate
, sysdate
, s.source_system_oid
)

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* inactivate rep_assignment */

update ODS_OWN.rep_assignment t
set lt_rep_end_date = sysdate
, ods_modify_date = sysdate
where t.lt_rep_end_date is null
and t.rep_type = 'Sales'
and not exists
(
select 1
from sf_assignment sfa
where sfa.account_oid = t.account_oid
and sfa.program_oid = t.program_oid
and sfa.employee_oid is not null
and sfa.sales_reps = 1
)

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Unknown Orgs (MART Prep) */

update sf_assignment s
set s.territory_code = '-1'
where not exists
(
select 1
from mart.organization o
where s.territory_code = o.territory_code
)

&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* add record_status and rep cols */

alter table sf_assignment add
( record_status varchar2(3)
, SALES_REP_EMPLOYEE_ID number
, SALES_REP_EMPLOYEE_CODE varchar2(50)
, SALES_REP_NAME varchar2(100)
)

&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* update sales rep cols */

merge into sf_assignment t
using
(
select sf.lifetouch_id
, sf.program_id
, nvl(case when sf.sales_reps <> 1  then -1 else me.employee_id end,-1) as SALES_REP_EMPLOYEE_ID
, case when sf.sales_reps <> 1  then 'Unknown'
       when e.vision_employee_code is not null then e.vision_employee_code
       else 'Unknown' end
  as SALES_REP_EMPLOYEE_CODE
, case when sf.sales_reps <> 1  then 'Unknown'
       when  nvl(e.term_date,sysdate + 1) < sysdate then 'Unknown'
       when e.first_name || e.last_name is not null then e.first_name || ' ' || e.last_name
       when sf.firstname || sf.lastname is not null then sf.firstname || ' ' || sf.lastname
       else 'Unknown' end
  as SALES_REP_NAME
from sf_assignment sf
, ods_own.employee e
, mart.employee me
where 1=1
and sf.employee_oid = e.employee_oid(+)
and case when e.employee_number = '.' then null else e.employee_number end = me.employee_number(+)
) s
on ( s.lifetouch_id = t.lifetouch_id and s.program_id = t.program_id )
when matched then update
set t.SALES_REP_EMPLOYEE_ID = s.sales_rep_employee_id
, t.SALES_REP_EMPLOYEE_CODE = s.sales_rep_employee_code
, t.SALES_REP_NAME = s.sales_rep_name


&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* assign rep from cheater column when more than 1 rep in ETM */

merge into sf_assignment t
using
(
select sfa.lid__c
, sfa.lifetouch_id
, sfa.sales_reps
, sfa.account_id
, sfa.program_name
, sfa.program_id
, sfa.t2name
, sfa.territory_code
, u.external_system_id__c
, u.employeenumber
, nvl(me.employee_id,-1) as SALES_REP_EMPLOYEE_ID
, e.vision_employee_code as SALES_REP_EMPLOYEE_CODE
, case when  nvl(e.term_date,sysdate + 1) < sysdate then 'Unknown'
       when e.first_name || e.last_name is not null then e.first_name || ' ' || e.last_name
       when sfa.firstname || sfa.lastname is not null then sfa.firstname || ' ' || sfa.lastname
       else 'Unknown' end
  as SALES_REP_NAME
from sf_assignment sfa
, ods_stage.sf_account_stg a
, ods_stage.sf_user_stg u
, ods_own.employee e
, mart.employee me
where 1=1
and sfa.sales_reps > 1
and sfa.account_id = a.id
and a.underclass_rep__c = u.id
and nvl(trim(u.external_system_id__c), u.employeenumber) = e.employee_number
and e.vision_employee_code is not null -- this keeps out the inside sales people
and e.term_date is null
and e.employee_oid = me.employee_oid
) s
on ( s.lifetouch_id = t.lifetouch_id and s.program_id = t.program_id )
when matched then update
set t.SALES_REP_EMPLOYEE_ID = s.sales_rep_employee_id
, t.SALES_REP_EMPLOYEE_CODE = s.sales_rep_employee_code
, t.SALES_REP_NAME = s.sales_rep_name

&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* assign yb rep from cheater column when more than 1 sales rep assigned */

merge into sf_assignment t
using
(
select sfa.lid__c
, sfa.lifetouch_id
, sfa.sales_reps
, sfa.account_id
, sfa.program_name
, sfa.program_id
, sfa.t2name
, sfa.territory_code
, u.external_system_id__c
, u.employeenumber
, nvl(me.employee_id,-1) as SALES_REP_EMPLOYEE_ID
, e.vision_employee_code as SALES_REP_EMPLOYEE_CODE
, case when  nvl(e.term_date,sysdate + 1) < sysdate then 'Unknown'
       when e.first_name || e.last_name is not null then e.first_name || ' ' || e.last_name
       when sfa.firstname || sfa.lastname is not null then sfa.firstname || ' ' || sfa.lastname
       else 'Unknown' end
  as SALES_REP_NAME
from sf_assignment sfa
, ods_stage.sf_account_stg a
, ods_stage.sf_user_stg u
, ods_own.employee e
, mart.employee me
where 1=1
and sfa.sales_reps > 1
and sfa.account_id = a.id
and a.yearbook_rep__c = u.id
and nvl(trim(u.external_system_id__c), u.employeenumber) = e.employee_number
and e.vision_employee_code is not null -- this keeps out the inside sales people
and e.employee_oid = me.employee_oid
and e.term_date is null
and sfa.program_name = 'Yearbook'
) s
on ( s.lifetouch_id = t.lifetouch_id and s.program_id = t.program_id )
when matched then update
set t.SALES_REP_EMPLOYEE_ID = s.sales_rep_employee_id
, t.SALES_REP_EMPLOYEE_CODE = s.sales_rep_employee_code
, t.SALES_REP_NAME = s.sales_rep_name
where decode(t.SALES_REP_EMPLOYEE_ID , s.sales_rep_employee_id,1,0) = 0
or decode(t.SALES_REP_EMPLOYEE_CODE , s.sales_rep_employee_code,1,0) = 0
or decode(t.SALES_REP_NAME , s.sales_rep_name,1,0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* Mark NEW */

update sf_assignment s
set s.record_status = 'NEW'
where not exists
(
select 1
from MART.x_current_assignment ca
where s.program_id = ca.program_id
and s.lifetouch_id = ca.lifetouch_id
)

&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* Mark UPD */

update sf_assignment s
set s.record_status = 'UPD'
where exists
(
select 1
from MART.x_current_assignment ca
, MART.organization o
where s.territory_code = o.territory_code
and s.program_id = ca.program_id
and s.lifetouch_id = ca.lifetouch_id
and 
( decode( o.ORGANIZATION_ID, ca.organization_id,1,0) = 0
or decode(o.TERRITORY_ID, ca.territory_id,1,0) = 0
or decode(o.TERRITORY_CODE, ca.territory_code,1,0) = 0
or decode(o.TERRITORY_NAME, ca.territory_name,1,0) = 0
or decode(o.CUSTOMER_SERVICE_PHONE_NBR, ca.customer_service_phone_nbr,1,0) = 0
or decode(o.ALTERNATIVE_PHONE_NBR, ca.alternative_phone_nbr,1,0) = 0
or decode(o.REGION_ID, ca.region_id,1,0) = 0
or decode(o.REGION_NAME, ca.region_name,1,0) = 0
or decode(o.AREA_ID, ca.area_id,1,0) = 0
or decode(o.AREA_NAME, ca.area_name,1,0) = 0
or decode(o.COUNTRY_CODE, ca.country_code,1,0) = 0
or decode(o.COUNTRY_NAME, ca.country_name,1,0) = 0
or decode(o.COMPANY_CODE, ca.company_code,1,0) = 0
or decode(o.COMPANY_NAME, ca.company_name,1,0) = 0
or decode(o.OFFICE_PHONE_NBR, ca.office_phone_nbr,1,0) = 0
or decode(o.FAX_PHONE_NBR, ca.fax_phone_nbr,1,0) = 0
or decode(o.CELL_PHONE_NBR, ca.cell_phone_nbr,1,0) = 0
or decode(o.MAILING_ADDR1, ca.mailing_addr1,1,0) = 0
or decode(o.MAILING_ADDR2, ca.mailing_addr2,1,0) = 0
or decode(o.MAILING_CITY, ca.mailing_city,1,0) = 0
or decode(o.MAILING_STATE, ca.mailing_state,1,0) = 0
or decode(o.MAILING_POSTAL_CODE, ca.mailing_postal_code,1,0) = 0
or decode(o.MAILING_COUNTRY, ca.mailing_country,1,0) = 0
or decode(o.PHYSICAL_ADDR1, ca.physical_addr1,1,0) = 0
or decode(o.PHYSICAL_ADDR2, ca.physical_addr2,1,0) = 0
or decode(o.PHYSICAL_CITY, ca.physical_city,1,0) = 0
or decode(o.PHYSICAL_STATE, ca.physical_state,1,0) = 0
or decode(o.PHYSICAL_POSTAL_CODE, ca.physical_postal_code,1,0) = 0
or decode(o.PHYSICAL_COUNTRY, ca.physical_country,1,0) = 0
or decode(o.MANAGER_FIRST_NAME, ca.manager_first_name,1,0) = 0
or decode(o.MANAGER_LAST_NAME, ca.manager_last_name,1,0) = 0
or decode(s.SALES_REP_EMPLOYEE_ID, ca.SALES_REP_EMPLOYEE_ID,1,0) = 0
or decode(s.SALES_REP_EMPLOYEE_CODE, ca.SALES_REP_EMPLOYEE_CODE,1,0) = 0
or decode(s.SALES_REP_NAME, ca.SALES_REP_NAME,1,0) = 0
or decode(o.AMS_ORGANIZATION_NAME, ca.ams_organization_name,1,0) = 0
or decode(o.AMS_COMPANY_NAME, ca.ams_company_name,1,0) = 0
or decode(o.AMS_BUSINESS_UNIT_NAME, ca.ams_business_unit_name,1,0) = 0
)
)


&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* allow null account_oids in sf_assignment */

alter table sf_assignment modify
( account_oid null )

&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* Add DEL rows if missing from SF or org changes even if not in SF */

insert into sf_assignment t
( record_status
, lifetouch_id
, program_id
, territory_code
, account_oid
, program_oid
, program_name
)
select 'DEL'
, ca.lifetouch_id
, ca.program_id
, ca.territory_code
, a.account_oid
, p.program_oid
, p.program_name
from MART.x_current_assignment ca
,MART.organization o
, ods_own.account a
, ods_own.program p
where ca.territory_code = o.territory_code
and ca.lifetouch_id = a.lifetouch_id(+)
and ca.program_id = p.program_id
and 
(   o.ORGANIZATION_ID <> ca.organization_id
or o.TERRITORY_ID <> ca.territory_id
or o.TERRITORY_CODE <> ca.territory_code
or o.TERRITORY_NAME <> ca.territory_name
or o.CUSTOMER_SERVICE_PHONE_NBR <> ca.customer_service_phone_nbr
or o.ALTERNATIVE_PHONE_NBR <> ca.alternative_phone_nbr
or o.REGION_ID <> ca.region_id
or o.REGION_NAME <> ca.region_name
or o.AREA_ID <> ca.area_id
or o.AREA_NAME <> ca.area_name
or o.COUNTRY_CODE <> ca.country_code
or o.COUNTRY_NAME <> ca.country_name
or o.COMPANY_CODE <> ca.company_code
or o.COMPANY_NAME <> ca.company_name
or o.OFFICE_PHONE_NBR <> ca.office_phone_nbr
or o.FAX_PHONE_NBR <> ca.fax_phone_nbr
or o.CELL_PHONE_NBR <> ca.cell_phone_nbr
or o.MAILING_ADDR1 <> ca.mailing_addr1
or o.MAILING_ADDR2 <> ca.mailing_addr2
or o.MAILING_CITY <> ca.mailing_city
or o.MAILING_STATE <> ca.mailing_state
or o.MAILING_POSTAL_CODE <> ca.mailing_postal_code
or o.MAILING_COUNTRY <> ca.mailing_country
or o.PHYSICAL_ADDR1 <> ca.physical_addr1
or o.PHYSICAL_ADDR2 <> ca.physical_addr2
or o.PHYSICAL_CITY <> ca.physical_city
or o.PHYSICAL_STATE <> ca.physical_state
or o.PHYSICAL_POSTAL_CODE <> ca.physical_postal_code
or o.PHYSICAL_COUNTRY <> ca.physical_country
or o.MANAGER_FIRST_NAME <> ca.manager_first_name
or o.MANAGER_LAST_NAME <> ca.manager_last_name
or o.AMS_ORGANIZATION_NAME <> ca.ams_organization_name
or o.AMS_COMPANY_NAME <> ca.ams_company_name
or o.AMS_BUSINESS_UNIT_NAME <> ca.ams_business_unit_name
)
and not exists
(
select 1
from sf_assignment s
where s.program_id = ca.program_id
and s.lifetouch_id = ca.lifetouch_id
)


&


/*-----------------------------------------------*/
/* TASK No. 32 */
/* NEW to CURRENT_ASSIGNMENT */

insert into MART.x_current_assignment
( ASSIGNMENT_ID
, EFFECTIVE_DATE
, LOAD_ID
, ACTIVE_IND
, LT_ACCT_PROGRAM_KEY
, LIFETOUCH_ID
, PROGRAM_ID
, ORGANIZATION_ID
, TERRITORY_ID
, TERRITORY_CODE
, TERRITORY_NAME
, CUSTOMER_SERVICE_PHONE_NBR
, ALTERNATIVE_PHONE_NBR
, REGION_ID
, REGION_NAME
, AREA_ID
, AREA_NAME
, COUNTRY_CODE
, COUNTRY_NAME
, COMPANY_CODE
, COMPANY_NAME
, OFFICE_PHONE_NBR
, FAX_PHONE_NBR
, CELL_PHONE_NBR
, MAILING_ADDR1
, MAILING_ADDR2
, MAILING_CITY
, MAILING_STATE
, MAILING_POSTAL_CODE
, MAILING_COUNTRY
, PHYSICAL_ADDR1
, PHYSICAL_ADDR2
, PHYSICAL_CITY
, PHYSICAL_STATE
, PHYSICAL_POSTAL_CODE
, PHYSICAL_COUNTRY
, MANAGER_FIRST_NAME
, MANAGER_LAST_NAME
, SALES_REP_EMPLOYEE_ID
, SALES_REP_EMPLOYEE_CODE
, SALES_REP_NAME
, AMS_ORGANIZATION_NAME
, AMS_COMPANY_NAME
, AMS_BUSINESS_UNIT_NAME
--, PHOTO_REP_EMPLOYEE_CODE
--, PHOTO_REP_NAME
--, OPERATION_REP_EMPLOYEE_CODE
--, OPERATION_REP_NAME
)
select ODS.assignment_id_seq.nextval
, sysdate
, 1
, 'A'
, -1
, s.LIFETOUCH_ID
, s.PROGRAM_ID
, o.ORGANIZATION_ID
, o.TERRITORY_ID
, o.TERRITORY_CODE
, o.TERRITORY_NAME
, o.CUSTOMER_SERVICE_PHONE_NBR
, o.ALTERNATIVE_PHONE_NBR
, o.REGION_ID
, o.REGION_NAME
, o.AREA_ID
, o.AREA_NAME
, o.COUNTRY_CODE
, o.COUNTRY_NAME
, o.COMPANY_CODE
, o.COMPANY_NAME
, o.OFFICE_PHONE_NBR
, o.FAX_PHONE_NBR
, o.CELL_PHONE_NBR
, o.MAILING_ADDR1
, o.MAILING_ADDR2
, o.MAILING_CITY
, o.MAILING_STATE
, o.MAILING_POSTAL_CODE
, o.MAILING_COUNTRY
, o.PHYSICAL_ADDR1
, o.PHYSICAL_ADDR2
, o.PHYSICAL_CITY
, o.PHYSICAL_STATE
, o.PHYSICAL_POSTAL_CODE
, o.PHYSICAL_COUNTRY
, o.MANAGER_FIRST_NAME
, o.MANAGER_LAST_NAME
, s.SALES_REP_EMPLOYEE_ID
, s.SALES_REP_EMPLOYEE_CODE
, s.SALES_REP_NAME
, o.AMS_ORGANIZATION_NAME
, o.AMS_COMPANY_NAME
, o.AMS_BUSINESS_UNIT_NAME
-- don't need to worry about these looks like...
--, 'Unknown' as PHOTO_REP_EMPLOYEE_CODE
--, 'Unknown' as PHOTO_REP_NAME
--, 'Unknown' as OPERATION_REP_EMPLOYEE_CODE
--, 'Unknown' as OPERATION_REP_NAME
from sf_assignment s
, MART.organization o
where s.territory_code = o.territory_code
and s.record_status = 'NEW'

&


/*-----------------------------------------------*/
/* TASK No. 33 */
/* NEW to ASSIGNMENT */

insert into MART.x_assignment
( ASSIGNMENT_ID
, EFFECTIVE_DATE
, LOAD_ID
, ACTIVE_IND
, LT_ACCT_PROGRAM_KEY
, LIFETOUCH_ID
, PROGRAM_ID
, ORGANIZATION_ID
, TERRITORY_ID
, TERRITORY_CODE
, TERRITORY_NAME
, CUSTOMER_SERVICE_PHONE_NBR
, ALTERNATIVE_PHONE_NBR
, REGION_ID
, REGION_NAME
, AREA_ID
, AREA_NAME
, COUNTRY_CODE
, COUNTRY_NAME
, COMPANY_CODE
, COMPANY_NAME
, OFFICE_PHONE_NBR
, FAX_PHONE_NBR
, CELL_PHONE_NBR
, MAILING_ADDR1
, MAILING_ADDR2
, MAILING_CITY
, MAILING_STATE
, MAILING_POSTAL_CODE
, MAILING_COUNTRY
, PHYSICAL_ADDR1
, PHYSICAL_ADDR2
, PHYSICAL_CITY
, PHYSICAL_STATE
, PHYSICAL_POSTAL_CODE
, PHYSICAL_COUNTRY
, MANAGER_FIRST_NAME
, MANAGER_LAST_NAME
, SALES_REP_EMPLOYEE_ID
, SALES_REP_EMPLOYEE_CODE
, SALES_REP_NAME
, AMS_ORGANIZATION_NAME
, AMS_COMPANY_NAME
, AMS_BUSINESS_UNIT_NAME
--, PHOTO_REP_EMPLOYEE_CODE
--, PHOTO_REP_NAME
--, OPERATION_REP_EMPLOYEE_CODE
--, OPERATION_REP_NAME
)
select ca.assignment_id
, ca.effective_date
, 1
, 'A'
, -1
, s.LIFETOUCH_ID
, s.PROGRAM_ID
, o.ORGANIZATION_ID
, o.TERRITORY_ID
, o.TERRITORY_CODE
, o.TERRITORY_NAME
, o.CUSTOMER_SERVICE_PHONE_NBR
, o.ALTERNATIVE_PHONE_NBR
, o.REGION_ID
, o.REGION_NAME
, o.AREA_ID
, o.AREA_NAME
, o.COUNTRY_CODE
, o.COUNTRY_NAME
, o.COMPANY_CODE
, o.COMPANY_NAME
, o.OFFICE_PHONE_NBR
, o.FAX_PHONE_NBR
, o.CELL_PHONE_NBR
, o.MAILING_ADDR1
, o.MAILING_ADDR2
, o.MAILING_CITY
, o.MAILING_STATE
, o.MAILING_POSTAL_CODE
, o.MAILING_COUNTRY
, o.PHYSICAL_ADDR1
, o.PHYSICAL_ADDR2
, o.PHYSICAL_CITY
, o.PHYSICAL_STATE
, o.PHYSICAL_POSTAL_CODE
, o.PHYSICAL_COUNTRY
, o.MANAGER_FIRST_NAME
, o.MANAGER_LAST_NAME
, s.SALES_REP_EMPLOYEE_ID
, s.SALES_REP_EMPLOYEE_CODE
, s.SALES_REP_NAME
, o.AMS_ORGANIZATION_NAME
, o.AMS_COMPANY_NAME
, o.AMS_BUSINESS_UNIT_NAME
-- don't need to worry about these looks like...
--, 'Unknown' as PHOTO_REP_EMPLOYEE_CODE
--, 'Unknown' as PHOTO_REP_NAME
--, 'Unknown' as OPERATION_REP_EMPLOYEE_CODE
--, 'Unknown' as OPERATION_REP_NAME
from sf_assignment s
, MART.organization o
, MART.x_current_assignment ca
where s.territory_code = o.territory_code
and s.record_status = 'NEW'
and s.program_id = ca.program_id
and s.lifetouch_id = ca.lifetouch_id

&


/*-----------------------------------------------*/
/* TASK No. 34 */
/* UPD to CURRENT_ASSIGNMENT */

merge into MART.x_current_assignment t
using
(
select sf.lifetouch_id
, sf.program_id
, sf.record_status
, o.ORGANIZATION_ID
, o.TERRITORY_ID
, o.TERRITORY_CODE
, o.TERRITORY_NAME
, o.CUSTOMER_SERVICE_PHONE_NBR
, o.ALTERNATIVE_PHONE_NBR
, o.REGION_ID
, o.REGION_NAME
, o.AREA_ID
, o.AREA_NAME
, o.COUNTRY_CODE
, o.COUNTRY_NAME
, o.COMPANY_CODE
, o.COMPANY_NAME
, o.OFFICE_PHONE_NBR
, o.FAX_PHONE_NBR
, o.CELL_PHONE_NBR
, o.MAILING_ADDR1
, o.MAILING_ADDR2
, o.MAILING_CITY
, o.MAILING_STATE
, o.MAILING_POSTAL_CODE
, o.MAILING_COUNTRY
, o.PHYSICAL_ADDR1
, o.PHYSICAL_ADDR2
, o.PHYSICAL_CITY
, o.PHYSICAL_STATE
, o.PHYSICAL_POSTAL_CODE
, o.PHYSICAL_COUNTRY
, o.MANAGER_FIRST_NAME
, o.MANAGER_LAST_NAME
, sf.SALES_REP_EMPLOYEE_ID
, sf.SALES_REP_EMPLOYEE_CODE
, sf.SALES_REP_NAME
, o.AMS_ORGANIZATION_NAME
, o.AMS_COMPANY_NAME
, o.AMS_BUSINESS_UNIT_NAME
-- don't need to worry about these looks like...
--, 'Unknown' as PHOTO_REP_EMPLOYEE_CODE
--, 'Unknown' as PHOTO_REP_NAME
--, 'Unknown' as OPERATION_REP_EMPLOYEE_CODE
--, 'Unknown' as OPERATION_REP_NAME
from sf_assignment sf
, MART.organization o
where sf.territory_code = o.territory_code
and sf.record_status in ('UPD','DEL')
) s
on ( s.lifetouch_id = t.lifetouch_id and s.program_id = t.program_id )
when matched then update
set t.effective_date = sysdate
, t.active_ind = case when s.record_status = 'UPD' then 'A' else 'I' end
, t.ORGANIZATION_ID = s.organization_id
, t.TERRITORY_ID = s.territory_id
, t.TERRITORY_CODE = s.territory_code
, t.TERRITORY_NAME = s.territory_name
, t.CUSTOMER_SERVICE_PHONE_NBR = s.customer_service_phone_nbr
, t.ALTERNATIVE_PHONE_NBR = s.alternative_phone_nbr
, t.REGION_ID = s.region_id
, t.REGION_NAME = s.region_name
, t.AREA_ID = s.area_id
, t.AREA_NAME = s.area_name
, t.COUNTRY_CODE = s.country_code
, t.COUNTRY_NAME = s.country_name
, t.COMPANY_CODE = s.company_code
, t.COMPANY_NAME = s.company_name
, t.OFFICE_PHONE_NBR = s.office_phone_nbr
, t.FAX_PHONE_NBR = s.fax_phone_nbr
, t.CELL_PHONE_NBR = s.cell_phone_nbr
, t.MAILING_ADDR1 = s.mailing_addr1
, t.MAILING_ADDR2 = s.mailing_addr2
, t.MAILING_CITY = s.mailing_city
, t.MAILING_STATE = s.mailing_state
, t.MAILING_POSTAL_CODE = s.mailing_postal_code
, t.MAILING_COUNTRY = s.mailing_country
, t.PHYSICAL_ADDR1 = s.physical_addr1
, t.PHYSICAL_ADDR2 = s.physical_addr2
, t.PHYSICAL_CITY = s.physical_city
, t.PHYSICAL_STATE = s.physical_state
, t.PHYSICAL_POSTAL_CODE = s.physical_postal_code
, t.PHYSICAL_COUNTRY = s.physical_country
, t.MANAGER_FIRST_NAME = s.manager_first_name
, t.MANAGER_LAST_NAME = s.manager_last_name
, t.SALES_REP_EMPLOYEE_ID = s.sales_rep_employee_id
, t.SALES_REP_EMPLOYEE_CODE = s.sales_rep_employee_code
, t.SALES_REP_NAME = s.sales_rep_name
, t.AMS_ORGANIZATION_NAME = s.ams_organization_name
, t.AMS_COMPANY_NAME = s.ams_company_name
, t.AMS_BUSINESS_UNIT_NAME = s.ams_business_unit_name

&


/*-----------------------------------------------*/
/* TASK No. 35 */
/* UPD to ASSIGNMENT */

insert into MART.x_assignment
( ASSIGNMENT_ID
, EFFECTIVE_DATE
, LOAD_ID
, ACTIVE_IND
, LT_ACCT_PROGRAM_KEY
, LIFETOUCH_ID
, PROGRAM_ID
, ORGANIZATION_ID
, TERRITORY_ID
, TERRITORY_CODE
, TERRITORY_NAME
, CUSTOMER_SERVICE_PHONE_NBR
, ALTERNATIVE_PHONE_NBR
, REGION_ID
, REGION_NAME
, AREA_ID
, AREA_NAME
, COUNTRY_CODE
, COUNTRY_NAME
, COMPANY_CODE
, COMPANY_NAME
, OFFICE_PHONE_NBR
, FAX_PHONE_NBR
, CELL_PHONE_NBR
, MAILING_ADDR1
, MAILING_ADDR2
, MAILING_CITY
, MAILING_STATE
, MAILING_POSTAL_CODE
, MAILING_COUNTRY
, PHYSICAL_ADDR1
, PHYSICAL_ADDR2
, PHYSICAL_CITY
, PHYSICAL_STATE
, PHYSICAL_POSTAL_CODE
, PHYSICAL_COUNTRY
, MANAGER_FIRST_NAME
, MANAGER_LAST_NAME
, SALES_REP_EMPLOYEE_ID
, SALES_REP_EMPLOYEE_CODE
, SALES_REP_NAME
, AMS_ORGANIZATION_NAME
, AMS_COMPANY_NAME
, AMS_BUSINESS_UNIT_NAME
--, PHOTO_REP_EMPLOYEE_CODE
--, PHOTO_REP_NAME
--, OPERATION_REP_EMPLOYEE_CODE
--, OPERATION_REP_NAME
)
select ca.assignment_id
, ca.effective_date
, 1
, case when s.record_status = 'UPD' then 'A' else 'I' end
, -1
, s.LIFETOUCH_ID
, s.PROGRAM_ID
, o.ORGANIZATION_ID
, o.TERRITORY_ID
, o.TERRITORY_CODE
, o.TERRITORY_NAME
, o.CUSTOMER_SERVICE_PHONE_NBR
, o.ALTERNATIVE_PHONE_NBR
, o.REGION_ID
, o.REGION_NAME
, o.AREA_ID
, o.AREA_NAME
, o.COUNTRY_CODE
, o.COUNTRY_NAME
, o.COMPANY_CODE
, o.COMPANY_NAME
, o.OFFICE_PHONE_NBR
, o.FAX_PHONE_NBR
, o.CELL_PHONE_NBR
, o.MAILING_ADDR1
, o.MAILING_ADDR2
, o.MAILING_CITY
, o.MAILING_STATE
, o.MAILING_POSTAL_CODE
, o.MAILING_COUNTRY
, o.PHYSICAL_ADDR1
, o.PHYSICAL_ADDR2
, o.PHYSICAL_CITY
, o.PHYSICAL_STATE
, o.PHYSICAL_POSTAL_CODE
, o.PHYSICAL_COUNTRY
, o.MANAGER_FIRST_NAME
, o.MANAGER_LAST_NAME
, s.SALES_REP_EMPLOYEE_ID
, s.SALES_REP_EMPLOYEE_CODE
, s.SALES_REP_NAME
, o.AMS_ORGANIZATION_NAME
, o.AMS_COMPANY_NAME
, o.AMS_BUSINESS_UNIT_NAME
-- don't need to worry about these looks like...
--, 'Unknown' as PHOTO_REP_EMPLOYEE_CODE
--, 'Unknown' as PHOTO_REP_NAME
--, 'Unknown' as OPERATION_REP_EMPLOYEE_CODE
--, 'Unknown' as OPERATION_REP_NAME
from sf_assignment s
, MART.organization o
, MART.x_current_assignment ca
where s.territory_code = o.territory_code
and s.record_status in ('UPD','DEL')
and s.program_id = ca.program_id
and s.lifetouch_id = ca.lifetouch_id

&


/*-----------------------------------------------*/
