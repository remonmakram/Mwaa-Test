/* TASK No. 1 */
/* drop sf_org */

BEGIN
    EXECUTE IMMEDIATE 'drop table sf_org';
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
/* create sf_org */

create table sf_org as
select upper(trim(a.Sales_Region__c)) as sales_region__c
, upper(trim(a.nss_territory_code__c)) as nss_territory_code__c
, type  -- field office type soething or other to distinguish between territories and sattelites
, a.id
, a.parentid
, a.area_name__c
, a.name
, a.billingstreet
, a.billingcity
, a.billingstatecode
, a.billingstate
, a.billingpostalcode
, a.billingcountry
, a.billingcountrycode
, a.phone
, a.fax
, a.Field_Office_Email__c
, upper(trim(a.company_code__c)) as company_code__c 
, a.office_manager__c 
, omu.firstname as manager_first_name
, omu.lastname as manager_last_name
, a.out_of_business__c
, a.isdeleted
, a.SystemModstamp
, a.backupmodifieddate
, substr(case when a.type = 'Hub' then nvl(a.area_name__c,a.name) else a.name end,1,40) as complex_name
from ODS_STAGE.sf_account_stg a
, ODS_STAGE.sf_recordtype_stg rt
, ODS_STAGE.sf_user_stg omu
where a.recordtypeid = rt.id
and a.office_manager__c = omu.id(+)
and rt.name = 'Field Office'
and a.type in ('Hub','Satellite')
and a.out_of_business__c = 0
and a.isdeleted = 0
and a.Sales_Region__c is not null
and a.name not like 'Atritava%'

&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* sf_organization_xr - Terr and Satellites */

merge into  ODS_STAGE.sf_organization_xr t
using
(
select case when sf.type = 'Hub' then nss_territory_code__c
            when sf.type = 'Satellite' then substr(name,1,4)
       else null end as org_code
, ot.org_type_name
from sf_org sf
,  ODS_OWN.org_type ot
where sf.type = ot.sf_type
) s
on ( s.org_code = t.org_code and s.org_type_name = t.org_type_name )
when not matched then insert
( t.ORGANIZATION_OID
, t.ORG_CODE
, t.ORG_TYPE_NAME
, t.ODS_CREATE_DATE
)
values
( ods_stage.organization_oid_seq.nextval
--( ODS_STAGE.seq_and_deploy_nextval('organization_oid_seq')
, s.org_code
, s.org_type_name
, sysdate
)

&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* organization - Terr and Satellites */

merge into  ODS_OWN.organization t
using
(
select oxr.organization_oid
, oxr.org_code
, (ot.org_type_parent_level + 1) as org_type_level
, sf.complex_name
, sf.name
, sf.area_name__c
, sf.phone
, ot.org_type_oid
, ss.source_system_oid
, sf.sales_region__c
, sf.company_code__c
, sf.fax
, sf.manager_first_name
, sf.manager_last_name
, sf.billingstreet
, sf.billingcity
, sf.billingstatecode
, sf.billingstate
, sf.billingpostalcode
, sf.billingcountrycode
, sf.billingcountry
from  ODS_STAGE.sf_organization_xr oxr
, sf_org sf
,  ODS_OWN.org_type ot
, ods_own.source_system ss
where case when sf.type = 'Hub' then nss_territory_code__c
           when sf.type = 'Satellite' then substr(name,1,4)
      else null end = oxr.org_code
and sf.type = ot.sf_type
and oxr.org_type_name = ot.org_type_name
and ss.source_system_short_name = 'SF'
) s
on ( s.organization_oid = t.organization_oid )
when matched then update
set t.organization_name = s.complex_name
, t.org_type_level = s.org_type_level
, t.office_direct_dial_phone = s.phone
, t.source_system_oid = s.source_system_oid
, t.ods_modify_date = sysdate
where decode(t.organization_name , s.complex_name,1,0) = 0
or decode(t.org_type_level , s.org_type_level,1,0) = 0
or decode(t.office_direct_dial_phone , s.phone,1,0) = 0
or decode(t.source_system_oid , s.source_system_oid,1,0) = 0
when not matched then insert
( ORGANIZATION_OID
, ORG_TYPE_OID
, ORG_CODE
, ORGANIZATION_NAME
, ORG_TYPE_LEVEL
, ODS_CREATE_DATE
, ODS_MODIFY_DATE
, SOURCE_SYSTEM_OID
, OFFICE_DIRECT_DIAL_PHONE
)
values
( s.organization_oid
, s.org_type_oid
, s.org_code
, s.complex_name
, s.org_type_level
, sysdate
, sysdate
, s.source_system_oid
, s.phone
)

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* drop sf_regions */

BEGIN
    EXECUTE IMMEDIATE 'drop table sf_regions';
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
/* TASK No. 6 */
/* sf_regions */

create table sf_regions as
select distinct sales_region__c
, company_code__c
from sf_org
where sales_region__c is not null

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* index sf_Regions */

create unique index sf_regions_pk on sf_regions(sales_region__c)

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* organization_xr - Regions */

merge into  ODS_STAGE.sf_organization_xr t
using
(
select sales_region__c as org_code
, ot.org_type_name
from sf_regions sf
,  ODS_OWN.org_type ot
where ot.org_type_name = 'Region'
) s
on ( s.org_code = t.org_code and s.org_type_name = t.org_type_name )
when not matched then insert
( t.ORGANIZATION_OID
, t.ORG_CODE
, t.ORG_TYPE_NAME
, t.ODS_CREATE_DATE
)
values
( ods_stage.organization_oid_seq.nextval
--( ODS_STAGE.seq_and_deploy_nextval('organization_oid_seq')
, s.org_code
, s.org_type_name
, sysdate
)

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* organization - regions */

merge into  ODS_OWN.organization t
using
(
select oxr.organization_oid
, oxr.org_code
, ot.org_type_oid
, (ot.org_type_parent_level + 1) as org_type_level
, sf.sales_region__c
, ss.source_system_oid
from ODS_STAGE.sf_organization_xr oxr
, sf_regions sf
,  ODS_OWN.org_type ot
, ods_own.source_system ss
where sf.sales_region__c = oxr.org_code
and ot.org_type_name = 'Region'
and oxr.org_type_name = ot.org_type_name
and ss.source_system_short_name = 'SF'
) s
on ( s.organization_oid = t.organization_oid )
when matched then update
set t.organization_name = s.sales_region__c
, t.org_type_level = s.org_type_level
, t.source_system_oid = s.source_system_oid
, t.ods_modify_date = sysdate
where decode(t.organization_name , s.sales_region__c,1,0) = 0
or decode(t.org_type_level , s.org_type_level,1,0) = 0
or decode(t.source_system_oid , s.source_system_oid,1,0) = 0
when not matched then insert
( ORGANIZATION_OID
, ORG_TYPE_OID
, ORG_CODE
, ORGANIZATION_NAME
, ORG_TYPE_LEVEL
, ODS_CREATE_DATE
, ODS_MODIFY_DATE
, SOURCE_SYSTEM_OID
)
values
( s.organization_oid
, s.org_type_oid
, s.org_code
, s.sales_region__c
, s.org_type_level
, sysdate
, sysdate
, s.source_system_oid
)

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* drop sf_bu */

BEGIN
    EXECUTE IMMEDIATE 'drop table sf_bu';
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
/* sf_bu */

create table sf_bu as
select company_code__c
-- these hardcoded due to all the downstream things dependant on these values - smollig 20220422
, case when company_code__c = 'US11' then 'USSG'
       when company_code__c = 'CA30' then 'CDSG'
  else 'TEST' end as business_unit_code
, case when company_code__c = 'US11' then 'United States School Groups'
       when company_code__c = 'CA30' then 'Canada School Group'
       else 'Test Organization'  end as business_unit_name
, min(sales_region__c) as area_code
, min('Area ' || sales_region__c) as area_name
from sf_regions
group by company_code__c
, case when company_code__c = 'US11' then 'USSG'
       when company_code__c = 'CA30' then 'CDSG'
  else 'TEST' end
, case when company_code__c = 'US11' then 'United States School Groups'
       when company_code__c = 'CA30' then 'Canada School Group'
       else 'Test Organization' end


&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* index sf_bu */

create unique index sf_bu_pk on sf_bu(business_unit_code)

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* index sf_bu 2 */

create unique index sf_bu_uk on sf_bu(area_code)

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* sf_organization_xr - area */

merge into  ODS_STAGE.sf_organization_xr t
using
(
select area_code as org_code
, ot.org_type_name
from sf_bu sf
,  ODS_OWN.org_type ot
where ot.org_type_name = 'Area'
) s
on ( s.org_code = t.org_code and s.org_type_name = t.org_type_name )
when not matched then insert
( t.ORGANIZATION_OID
, t.ORG_CODE
, t.ORG_TYPE_NAME
, t.ODS_CREATE_DATE
)
values
( ods_stage.organization_oid_seq.nextval
--( ODS_STAGE.seq_and_deploy_nextval('organization_oid_seq')
, s.org_code
, s.org_type_name
, sysdate
)

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* organization - Area */

merge into  ODS_OWN.organization t
using
(
select oxr.organization_oid
, oxr.org_code
, ot.org_type_oid
, (ot.org_type_parent_level + 1) as org_type_level
, sf.area_name
, ss.source_system_oid
from  ODS_STAGE.sf_organization_xr oxr
, sf_bu sf
,  ODS_OWN.org_type ot
, ods_own.source_system ss
where sf.area_code = oxr.org_code
and ot.org_type_name = 'Area'
and oxr.org_type_name = ot.org_type_name
and ss.source_system_short_name = 'SF'
) s
on ( s.organization_oid = t.organization_oid )
when matched then update
set t.organization_name = s.area_name
, t.org_type_level = s.org_type_level
, t.source_system_oid = s.source_system_oid
, t.ods_modify_date = sysdate
where decode(t.organization_name , s.area_name,1,0) = 0
or decode(t.org_type_level , s.org_type_level,1,0) = 0
or decode(t.source_system_oid , s.source_system_oid,1,0) = 0
when not matched then insert
( ORGANIZATION_OID
, ORG_TYPE_OID
, ORG_CODE
, ORGANIZATION_NAME
, ORG_TYPE_LEVEL
, ODS_CREATE_DATE
, ODS_MODIFY_DATE
, SOURCE_SYSTEM_OID
)
values
( s.organization_oid
, s.org_type_oid
, s.org_code
, s.area_name
, s.org_type_level
, sysdate
, sysdate
, s.source_system_oid
)

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* organization_xr - bus unit */

merge into  ODS_STAGE.sf_organization_xr t
using
(
select sf.business_unit_code as org_code
, ot.org_type_name
from sf_bu sf
,  ODS_OWN.org_type ot
where ot.org_type_name = 'Business Unit'
) s
on ( s.org_code = t.org_code and s.org_type_name = t.org_type_name )
when not matched then insert
( t.ORGANIZATION_OID
, t.ORG_CODE
, t.ORG_TYPE_NAME
, t.ODS_CREATE_DATE
)
values
( ods_stage.organization_oid_seq.nextval
--( ODS_STAGE.seq_and_deploy_nextval('organization_oid_seq')
, s.org_code
, s.org_type_name
, sysdate
)

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* organization - bus unit */

merge into  ODS_OWN.organization t
using
(
select oxr.organization_oid
, oxr.org_code
, ot.org_type_oid
, (ot.org_type_parent_level + 1) as org_type_level
, ss.source_system_oid
, sf.business_unit_name
from  ODS_STAGE.sf_organization_xr oxr
, sf_bu sf
,  ODS_OWN.org_type ot
, ods_own.source_system ss
where sf.area_code = oxr.org_code
and ot.org_type_name = 'Business Unit'
and oxr.org_type_name = ot.org_type_name
and ss.source_system_short_name = 'SF'
) s
on ( s.organization_oid = t.organization_oid )
when matched then update
set t.organization_name = s.business_unit_name
, t.org_type_level = s.org_type_level
, t.source_system_oid = s.source_system_oid
, t.ods_modify_date = sysdate
where decode(t.organization_name , s.business_unit_name,1,0) = 0
or decode(t.org_type_level , s.org_type_level,1,0) = 0
or decode(t.source_system_oid , s.source_system_oid,1,0) = 0
when not matched then insert
( ORGANIZATION_OID
, ORG_TYPE_OID
, ORG_CODE
, ORGANIZATION_NAME
, ORG_TYPE_LEVEL
, ODS_CREATE_DATE
, ODS_MODIFY_DATE
, SOURCE_SYSTEM_OID
)
values
( s.organization_oid
, s.org_type_oid
, s.org_code
, s.business_unit_name
, s.org_type_level
, sysdate
, sysdate
, s.source_system_oid
)

&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* org_relationship_xr */

merge into  ODS_STAGE.sf_org_relationship_xr t
using
(
select o.org_code
, ot.org_type_name
from  ODS_OWN.organization o
,  ODS_OWN.org_type ot
where o.org_type_oid = ot.org_type_oid
) s
on ( s.org_code = t.org_code and s.org_type_name = t.org_type_name )
when not matched then insert
( t.ORG_RELATIONSHIP_OID
, t.ORG_CODE
, t.ORG_TYPE_NAME
, t.ODS_CREATE_DATE
)
values
( ods_stage.org_relationship_oid_seq.nextval
--( ODS_STAGE.seq_and_deploy_nextval('org_relationship_oid_seq')
, s.org_code
, s.org_type_name
, sysdate
)

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* org_relationship - Satellite:Terr */

merge into  ODS_OWN.org_relationship t
using
(
select orxr.org_relationship_oid
, oxr.organization_oid as child_organization_oid
, poxr.organization_oid as parent_organization_oid
, ss.source_system_oid
, sf.name
, psf.nss_territory_code__c
from sf_org sf
,  ODS_OWN.org_type ot
,  ODS_STAGE.sf_organization_xr oxr
,  ODS_STAGE.sf_org_relationship_xr orxr
, sf_org psf
,  ODS_OWN.org_type pot
,  ODS_STAGE.sf_organization_xr poxr
, ods_own.source_system ss
where sf.type = 'Satellite'
and sf.type = ot.sf_type
and substr(sf.name,1,4) = oxr.org_code
and ot.org_type_name = oxr.org_type_name
and oxr.org_code = orxr.org_code
and oxr.org_type_name = orxr.org_type_name
and sf.parentid = psf.id
and psf.type = pot.sf_type
and psf.nss_territory_code__c = poxr.org_code
and pot.org_type_name = poxr.org_type_name
and ss.source_system_short_name = 'SF'
) s
on ( s.org_relationship_oid = t.org_relationship_oid )
when matched then update
set t.child_organization_oid = s.child_organization_oid
, t.parent_organization_oid = s.parent_organization_oid
, t.source_system_oid = s.source_system_oid
, t.ods_modify_date = sysdate
where decode(t.child_organization_oid , s.child_organization_oid,1,0) = 0
or decode(t.parent_organization_oid , s.parent_organization_oid,1,0) = 0
or decode(t.source_system_oid , s.source_system_oid,1,0) = 0
when not matched then insert
( t.ORG_RELATIONSHIP_OID
, t.PARENT_ORGANIZATION_OID
, t.CHILD_ORGANIZATION_OID
, t.ODS_CREATE_DATE
, t.ODS_MODIFY_DATE
, t.SOURCE_SYSTEM_OID
)
values
( s.ORG_RELATIONSHIP_OID
, s.PARENT_ORGANIZATION_OID
, s.CHILD_ORGANIZATION_OID
, sysdate
, sysdate
, s.SOURCE_SYSTEM_OID
)

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* org_relationship - Terr:Region */

merge into  ODS_OWN.org_relationship t
using
(
select orxr.org_relationship_oid
, oxr.organization_oid as child_organization_oid
, poxr.organization_oid as parent_organization_oid
, ss.source_system_oid
, sf.nss_territory_code__c
, poxr.org_code
from sf_org sf
,  ODS_OWN.org_type ot
, ODS_STAGE.sf_organization_xr oxr
, ODS_STAGE.sf_org_relationship_xr orxr
, ODS_STAGE.sf_organization_xr poxr
, ods_own.source_system ss
where sf.type = 'Hub'
and sf.type = ot.sf_type
and nss_territory_code__c = oxr.org_code
and ot.org_type_name = oxr.org_type_name
and oxr.org_code = orxr.org_code
and oxr.org_type_name = orxr.org_type_name
and poxr.org_type_name = 'Region'
and sf.sales_region__c = poxr.org_code
and ss.source_system_short_name = 'SF'
) s
on ( s.org_relationship_oid = t.org_relationship_oid )
when matched then update
set t.child_organization_oid = s.child_organization_oid
, t.parent_organization_oid = s.parent_organization_oid
, t.source_system_oid = s.source_system_oid
, t.ods_modify_date = sysdate
where decode(t.child_organization_oid , s.child_organization_oid,1,0) = 0
or decode(t.parent_organization_oid , s.parent_organization_oid,1,0) = 0
or decode(t.source_system_oid , s.source_system_oid,1,0) = 0
when not matched then insert
( t.ORG_RELATIONSHIP_OID
, t.PARENT_ORGANIZATION_OID
, t.CHILD_ORGANIZATION_OID
, t.ODS_CREATE_DATE
, t.ODS_MODIFY_DATE
, t.SOURCE_SYSTEM_OID
)
values
( s.ORG_RELATIONSHIP_OID
, s.PARENT_ORGANIZATION_OID
, s.CHILD_ORGANIZATION_OID
, sysdate
, sysdate
, s.SOURCE_SYSTEM_OID
)

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* org_relationship - Region:Area */

merge into  ODS_OWN.org_relationship t
using
(
select orxr.org_relationship_oid
, oxr.organization_oid as child_organization_oid
, poxr.organization_oid as parent_organization_oid
, ss.source_system_oid
, sf.sales_region__c
, poxr.org_code
from sf_regions sf
,  ODS_OWN.org_type ot
,  ODS_STAGE.sf_organization_xr oxr
,  ODS_STAGE.sf_org_relationship_xr orxr
, sf_bu psf
,  ODS_STAGE.sf_organization_xr poxr
, ods_own.source_system ss
where ot.org_type_name = 'Region'
and sf.sales_region__c = oxr.org_code
and ot.org_type_name = oxr.org_type_name
and oxr.org_code = orxr.org_code
and oxr.org_type_name = orxr.org_type_name
and sf.company_code__c = psf.company_code__c
and psf.area_code = poxr.org_code
and poxr.org_type_name = 'Area'
and ss.source_system_short_name = 'SF'
) s
on ( s.org_relationship_oid = t.org_relationship_oid )
when matched then update
set t.child_organization_oid = s.child_organization_oid
, t.parent_organization_oid = s.parent_organization_oid
, t.source_system_oid = s.source_system_oid
, t.ods_modify_date = sysdate
where decode(t.child_organization_oid , s.child_organization_oid,1,0) = 0
or decode(t.parent_organization_oid , s.parent_organization_oid,1,0) = 0
or decode(t.source_system_oid , s.source_system_oid,1,0) = 0
when not matched then insert
( t.ORG_RELATIONSHIP_OID
, t.PARENT_ORGANIZATION_OID
, t.CHILD_ORGANIZATION_OID
, t.ODS_CREATE_DATE
, t.ODS_MODIFY_DATE
, t.SOURCE_SYSTEM_OID
)
values
( s.ORG_RELATIONSHIP_OID
, s.PARENT_ORGANIZATION_OID
, s.CHILD_ORGANIZATION_OID
, sysdate
, sysdate
, s.SOURCE_SYSTEM_OID
)

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* org_relationship - Area:Bus Unit */

merge into ODS_OWN.org_relationship t
using
(
select orxr.org_relationship_oid
, oxr.organization_oid as child_organization_oid
, poxr.organization_oid as parent_organization_oid
, ss.source_system_oid
, sf.area_code
, poxr.org_code
from sf_bu sf
, ODS_OWN.org_type ot
, ODS_STAGE.sf_organization_xr oxr
, ODS_STAGE.sf_org_relationship_xr orxr
, ODS_STAGE.sf_organization_xr poxr
, ods_own.source_system ss
where ot.org_type_name = 'Area'
and sf.area_code = oxr.org_code
and ot.org_type_name = oxr.org_type_name
and oxr.org_code = orxr.org_code
and oxr.org_type_name = orxr.org_type_name
and sf.business_unit_code = poxr.org_code
and poxr.org_type_name = 'Business Unit'
and ss.source_system_short_name = 'SF'
) s
on ( s.org_relationship_oid = t.org_relationship_oid )
when matched then update
set t.child_organization_oid = s.child_organization_oid
, t.parent_organization_oid = s.parent_organization_oid
, t.source_system_oid = s.source_system_oid
, t.ods_modify_date = sysdate
where decode(t.child_organization_oid , s.child_organization_oid,1,0) = 0
or decode(t.parent_organization_oid , s.parent_organization_oid,1,0) = 0
or decode(t.source_system_oid , s.source_system_oid,1,0) = 0
when not matched then insert
( t.ORG_RELATIONSHIP_OID
, t.PARENT_ORGANIZATION_OID
, t.CHILD_ORGANIZATION_OID
, t.ODS_CREATE_DATE
, t.ODS_MODIFY_DATE
, t.SOURCE_SYSTEM_OID
)
values
( s.ORG_RELATIONSHIP_OID
, s.PARENT_ORGANIZATION_OID
, s.CHILD_ORGANIZATION_OID
, sysdate
, sysdate
, s.SOURCE_SYSTEM_OID
)

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* sf_org_addresses_xr */

merge into  ODS_STAGE.sf_org_address_xr t
using
(
select case when sf.type = 'Hub' then nss_territory_code__c
            when sf.type = 'Satellite' then substr(name,1,4)
       else null end as org_code
, ot.org_type_name
, 'Mailing' as address_type
from sf_org sf
, ODS_OWN.org_type ot
where sf.type = ot.sf_type
) s
on ( s.org_code = t.org_code and s.org_type_name = t.org_type_name and s.address_type = t.address_type )
when not matched then insert
( t.ORG_ADDRESS_OID
, t.ORG_CODE
, t.ORG_TYPE_NAME
, t.ADDRESS_TYPE
, t.ODS_CREATE_DATE
)
values
( ods_stage.org_address_oid_seq.nextval
--( ODS_STAGE.seq_and_deploy_nextval('org_address_oid_seq')
, s.org_code
, s.org_type_name
, s.address_type
, sysdate
)

&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* org_addresses */

merge into ODS_OWN.org_address t
using
(
select oaxr.org_address_oid
, oaxr.org_code
, (ot.org_type_parent_level + 1) as org_type_level
, oaxr.address_type
, oxr.organization_oid
, sf.complex_name
, sf.name
, sf.area_name__c
, sf.phone
, ot.org_type_oid
, ss.source_system_oid
, sf.sales_region__c
, sf.company_code__c
, sf.fax
, sf.manager_first_name
, sf.manager_last_name
, sf.billingstreet
, sf.billingcity
, sf.billingstatecode
, sf.billingstate
, sf.billingpostalcode
, sf.billingcountrycode
, sf.billingcountry
from  ODS_STAGE.sf_org_address_xr oaxr
, sf_org sf
, ODS_OWN.org_type ot
, ods_own.source_system ss
,  ODS_STAGE.sf_organization_xr oxr
where case when sf.type = 'Hub' then nss_territory_code__c
           when sf.type = 'Satellite' then substr(name,1,4)
      else null end = oaxr.org_code
and sf.type = ot.sf_type
and oaxr.org_type_name = ot.org_type_name
and oaxr.address_type = 'Mailing'
and ss.source_system_short_name = 'SF'
and oaxr.org_code = oxr.org_code
and oaxr.org_type_name = oxr.org_type_name
) s
on ( s.org_address_oid = t.org_address_oid )
when matched then update
set t.address1 = s.billingstreet
, t.address2 = null
, t.city = s.billingcity
, t.state = s.billingstatecode
, t.postal_code = s.billingpostalcode
, t.source_system_oid = s.source_system_oid
, t.ods_modify_date = sysdate
where decode(t.address1 , s.billingstreet,1,0) = 0
or t.address2 is not null
or decode(t.city , s.billingcity,1,0) = 0
or decode(t.state , s.billingstatecode,1,0) = 0
or decode(t.postal_code , s.billingpostalcode,1,0) = 0
or decode(t.source_system_oid , s.source_system_oid,1,0) = 0
when not matched then insert
( ORG_ADDRESS_OID
, ORGANIZATION_OID
, ADDRESS_TYPE
, ADDRESS1
, CITY
, STATE
, POSTAL_CODE
, ODS_CREATE_DATE
, ODS_MODIFY_DATE
, SOURCE_SYSTEM_OID
)
values
( s.org_address_oid
, s.organization_oid
, s.address_type
, s.billingstreet
, s.billingcity
, s.billingstatecode
, s.billingpostalcode
, sysdate
, sysdate
, s.source_system_oid
)

&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* sf_organization_addresses_xr */

merge into  ODS_STAGE.sf_organization_addresses_xr t
using
(
select case when sf.type = 'Hub' then nss_territory_code__c
            when sf.type = 'Satellite' then substr(name,1,4)
       else null end as org_code
, ot.org_type_name
, 'Mailing' as address_type_desc
from sf_org sf
, ODS_OWN.org_type ot
where sf.type = ot.sf_type
) s
on ( s.org_code = t.org_code and s.org_type_name = t.org_type_name and s.address_type_desc = t.address_type_desc )
when not matched then insert
( t.ADDRESSES_OID
, t.ORG_CODE
, t.ORG_TYPE_NAME
, t.ADDRESS_TYPE_DESC
, t.ODS_CREATE_DATE
)
values
( ods_stage.addresses_oid_seq.nextval
--( ODS_STAGE.seq_and_deploy_nextval('addresses_oid_seq')
, s.org_code
, s.org_type_name
, s.address_type_desc
, sysdate
)

&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* addresses */

merge into ODS_OWN.addresses t
using
(
select oaxr.addresses_oid
, oaxr.org_code
, (ot.org_type_parent_level + 1) as org_type_level
, 10 as address_type -- 10 was mailing org address type in AMS
, oaxr.address_type_desc
, oxr.organization_oid
, sf.complex_name
, sf.name
, sf.area_name__c
, sf.phone
, ot.org_type_oid
, ss.source_system_oid
, sf.sales_region__c
, sf.company_code__c
, sf.fax
, sf.manager_first_name
, sf.manager_last_name
, sf.billingstreet
, sf.billingcity
, sf.billingstatecode
, sf.billingstate
, sf.billingpostalcode
, sf.billingcountrycode
, sf.billingcountry
from ODS_STAGE.sf_organization_addresses_xr oaxr
, sf_org sf
, ODS_OWN.org_type ot
, ods_own.source_system ss
, ODS_STAGE.sf_organization_xr oxr
where case when sf.type = 'Hub' then nss_territory_code__c
           when sf.type = 'Satellite' then substr(name,1,4)
      else null end = oaxr.org_code
and sf.type = ot.sf_type
and oaxr.org_type_name = ot.org_type_name
and oaxr.address_type_desc = 'Mailing'
and ss.source_system_short_name = 'SF'
and oaxr.org_code = oxr.org_code
and oaxr.org_type_name = oxr.org_type_name
) s
on ( s.addresses_oid = t.addresses_oid )
when matched then update
set t.address1 = s.billingstreet
, t.address2 = null
, t.address3 = null
, t.city = s.billingcity
, t.state = s.billingstatecode
, t.postal_code = s.billingpostalcode
, t.source_system_oid = s.source_system_oid
, t.ods_modify_date = sysdate
where decode(t.address1 , s.billingstreet,1,0) = 0
or t.address2 is not null
or t.address3 is not null
or decode(t.city , s.billingcity,1,0) = 0
or decode(t.state , s.billingstatecode,1,0) = 0
or decode(t.postal_code , s.billingpostalcode,1,0) = 0
or decode(t.source_system_oid , s.source_system_oid,1,0) = 0
when not matched then insert
( ADDRESSES_OID
, ORGANIZATION_OID
, ADDRESS_TYPE_DESC
, ADDRESS_TYPE
, ADDRESS1
, CITY
, STATE
, POSTAL_CODE
, ODS_CREATE_DATE
, ODS_MODIFY_DATE
, SOURCE_SYSTEM_OID
)
values
( s.addresses_oid
, s.organization_oid
, s.address_type_desc
, s.address_type
, s.billingstreet
, s.billingcity
, s.billingstatecode
, s.billingpostalcode
, sysdate
, sysdate
, s.source_system_oid
)

&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* MART.ORGANIZATION */

merge into MART.organization t
using
(
SELECT t.org_code     AS territory_code ,
  t.organization_name AS territory_name ,
  r.organization_name AS region_name ,
  a.organization_name AS area_name ,
  b.organization_name AS business_unit_name ,
  c.organization_name AS operating_company_name ,
  oa.address1 ,
  oa.city ,
  oa.state ,
  oa.postal_code ,
  sf.billingcountrycode ,
  sf.phone ,
  sf.fax ,
  sf.manager_first_name ,
  sf.manager_last_name ,
  (t.organization_oid + 10000000) as territory_id ,
  (r.organization_oid + 10000000) as region_id ,
  (a.organization_oid + 10000000) as area_id ,
  2 as company_code ,
  'LNSS' as ams_company_name ,
  case when sf.company_code__c = 'TEST' then 'Test Data'
       when sf.billingcountrycode = 'US' then 'United States'
       when sf.billingcountrycode = 'CA' then 'CANADA'
       else sf.billingcountry
  end as country_name ,
  case when sf.company_code__c = 'TEST' then 99
       when sf.billingcountrycode = 'US' then 3
       when sf.billingcountrycode = 'CA' then 4
       else c.organization_oid
  end as country_code ,
  'Lifetouch Inc' as ams_organization_name
FROM ODS_OWN.org_type tot ,
  ODS_OWN.organization t ,
  ODS_OWN.org_relationship tor ,
  ODS_OWN.organization r ,
  ODS_OWN.org_relationship ror ,
  ODS_OWN.organization a ,
  ODS_OWN.org_relationship aor ,
  ODS_OWN.organization b ,
  ODS_OWN.org_relationship bor ,
  ODS_OWN.organization c ,
  ods_own.source_system ss ,
  ODS_OWN.org_address oa ,
  sf_org sf
WHERE tot.org_type_name         = 'Territory'
AND tot.org_type_oid            = t.org_type_oid
AND t.organization_oid          = tor.child_organization_oid
AND tor.parent_organization_oid = r.organization_oid
AND r.organization_oid          = ror.child_organization_oid
AND ror.parent_organization_oid = a.organization_oid
AND a.organization_oid          = aor.child_organization_oid
AND aor.parent_organization_oid = b.organization_oid
AND b.organization_oid          = bor.child_organization_oid
AND bor.parent_organization_oid = c.organization_oid
and t.source_system_oid = ss.source_system_oid
and t.organization_oid = oa.organization_oid
and oa.address_type = 'Mailing'
and t.org_code = sf.nss_territory_code__c
and sf.type = 'Hub'
and ss.source_system_short_name = 'SF'
) s
on ( s.territory_code = t.territory_code )
when matched then update
set t.territory_name = s.TERRITORY_NAME
,t.customer_service_phone_nbr = 'Unknown'
,t.alternative_phone_nbr = 'Unknown'
,t.region_id = s.REGION_ID
,t.region_name = s.REGION_NAME
,t.area_id = s.AREA_ID
,t.area_name = s.AREA_NAME
,t.country_code = s.COUNTRY_CODE
,t.country_name = s.COUNTRY_NAME
,t.company_code = s.COMPANY_CODE
,t.company_name = s.AMS_COMPANY_NAME
,t.office_phone_nbr = s.phone
,t.fax_phone_nbr = 'Unknown'
,t.cell_phone_nbr = 'Unknown'
,t.mailing_addr1 = s.address1
,t.mailing_addr2 = 'Unknown'
,t.mailing_city = s.city
,t.mailing_state = s.state
,t.mailing_postal_code = s.postal_code
,t.mailing_country = s.billingcountrycode
,t.physical_addr1 = s.address1
,t.physical_addr2 = 'Unknown'
,t.physical_city = s.city
,t.physical_state = s.state
,t.physical_postal_code = s.postal_code
,t.physical_country = s.billingcountrycode
,t.manager_first_name = s.MANAGER_FIRST_NAME
,t.manager_last_name = s.MANAGER_LAST_NAME
,t.ams_organization_name = s.AMS_ORGANIZATION_NAME
,t.ams_company_name = s.AMS_COMPANY_NAME
,t.ams_business_unit_name = s.business_unit_name
where decode(t.territory_name , s.TERRITORY_NAME,1,0) = 0
or decode(t.customer_service_phone_nbr , 'Unknown' ,1,0) = 0
or decode(t.alternative_phone_nbr , 'Unknown' ,1,0) = 0
or decode(t.region_id , s.REGION_ID,1,0) = 0
or decode(t.region_name , s.REGION_NAME,1,0) = 0
or decode(t.area_id , s.AREA_ID,1,0) = 0
or decode(t.area_name , s.AREA_NAME,1,0) = 0
or decode(t.country_code , s.COUNTRY_CODE,1,0) = 0
or decode(t.country_name , s.COUNTRY_NAME,1,0) = 0
or decode(t.company_code , s.COMPANY_CODE,1,0) = 0
or decode(t.company_name , s.AMS_COMPANY_NAME,1,0) = 0
or decode(t.office_phone_nbr , s.phone ,1,0) = 0
or decode(t.fax_phone_nbr , 'Unknown' ,1,0) = 0
or decode(t.cell_phone_nbr , 'Unknown' ,1,0) = 0
or decode(t.mailing_addr1 , s.address1 ,1,0) = 0
or decode(t.mailing_addr2 , 'Unknown' ,1,0) = 0
or decode(t.mailing_city , s.city ,1,0) = 0
or decode(t.mailing_state , s.state ,1,0) = 0
or decode(t.mailing_postal_code , s.postal_code ,1,0) = 0
or decode(t.mailing_country , s.billingcountrycode ,1,0) = 0
or decode(t.physical_addr1 , s.address1 ,1,0) = 0
or decode(t.physical_addr2 , 'Unknown' ,1,0) = 0
or decode(t.physical_city , s.city ,1,0) = 0
or decode(t.physical_state , s.state ,1,0) = 0
or decode(t.physical_postal_code , s.postal_code ,1,0) = 0
or decode(t.physical_country , s.billingcountrycode ,1,0) = 0
or decode(t.manager_first_name , s.MANAGER_FIRST_NAME,1,0) = 0
or decode(t.manager_last_name , s.MANAGER_LAST_NAME,1,0) = 0
or decode(t.ams_organization_name , s.AMS_ORGANIZATION_NAME,1,0) = 0
or decode(t.ams_company_name , s.AMS_COMPANY_NAME,1,0) = 0
or decode(t.ams_business_unit_name , s.business_unit_name ,1,0) = 0
when not matched then insert
(ORGANIZATION_ID
,TERRITORY_ID
,TERRITORY_CODE
,TERRITORY_NAME
,CUSTOMER_SERVICE_PHONE_NBR
,ALTERNATIVE_PHONE_NBR
,REGION_ID
,REGION_NAME
,AREA_ID
,AREA_NAME
,COUNTRY_CODE
,COUNTRY_NAME
,COMPANY_CODE
,COMPANY_NAME
,OFFICE_PHONE_NBR
,FAX_PHONE_NBR
,CELL_PHONE_NBR
,MAILING_ADDR1
,MAILING_ADDR2
,MAILING_CITY
,MAILING_STATE
,MAILING_POSTAL_CODE
,MAILING_COUNTRY
,PHYSICAL_ADDR1
,PHYSICAL_ADDR2
,PHYSICAL_CITY
,PHYSICAL_STATE
,PHYSICAL_POSTAL_CODE
,PHYSICAL_COUNTRY
,MANAGER_FIRST_NAME
,MANAGER_LAST_NAME
,AMS_ORGANIZATION_NAME
,AMS_COMPANY_NAME
,AMS_BUSINESS_UNIT_NAME
,COMMISSION_IND
)
values
( ods.organization_id_seq.nextval
--( ODS.seq_and_deploy_nextval('organization_id_seq')
,s.TERRITORY_ID
,s.TERRITORY_CODE
,s.TERRITORY_NAME
,'Unknown' -- CUSTOMER_SERVICE_PHONE_NBR
,'Unknown' -- ALTERNATIVE_PHONE_NBR
,s.REGION_ID
,s.REGION_NAME
,s.AREA_ID
,s.AREA_NAME
,s.COUNTRY_CODE
,s.COUNTRY_NAME
,s.COMPANY_CODE
,s.AMS_COMPANY_NAME
,s.phone -- OFFICE_PHONE_NBR
,'Unknown' -- FAX_PHONE_NBR
,'Unknown' -- CELL_PHONE_NBR
,s.address1 -- MAILING_ADDR1
,'Unknown' -- MAILING_ADDR2
,s.city -- MAILING_CITY
,s.state -- MAILING_STATE
,s.postal_code -- MAILING_POSTAL_CODE
,s.billingcountrycode -- MAILING_COUNTRY
,s.address1 -- PHYSICAL_ADDR1
,'Unknown' -- PHYSICAL_ADDR2
,s.city -- PHYSICAL_CITY
,s.state -- PHYSICAL_STATE
,s.postal_code -- PHYSICAL_POSTAL_CODE
,s.billingcountrycode -- PHYSICAL_COUNTRY
,s.MANAGER_FIRST_NAME
,s.MANAGER_LAST_NAME
,s.AMS_ORGANIZATION_NAME
,s.AMS_COMPANY_NAME
,s.business_unit_name -- AMS_BUSINESS_UNIT_NAME
,'.' -- COMMISSION_IND
)

&


/*-----------------------------------------------*/
