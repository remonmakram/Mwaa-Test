/* TASK No. 1 */
/* ODS_OWN.IMAGE */

delete
from ODS_OWN.IMAGE i where i.IMAGE_OID in (
select xr.IMAGE_OID
from
ODS_STAGE.IMAGE_XR xr
where (1=1)
and xr.OMS2_IMAGE_KEY like 'D%' 
and xr.SYSTEM_OF_RECORD = 'OMS2'
)

&


/*-----------------------------------------------*/
/* TASK No. 2 */
/* ODS_STAGE.IMAGE_XR */

delete
from
ODS_STAGE.IMAGE_XR xr
where (1=1)
and xr.OMS2_IMAGE_KEY like 'D%' 
and xr.SYSTEM_OF_RECORD = 'OMS2'
and not exists (select 1 from ODS_OWN.IMAGE z where z.IMAGE_OID = xr.IMAGE_OID)

&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* ODS_OWN.CAPTURE_SESSION */

delete
from 
ODS_OWN.CAPTURE_SESSION s where s.CAPTURE_SESSION_OID in (
select
xr.CAPTURE_SESSION_OID
from
ODS_STAGE.CAPTURE_SESSION_XR xr
where (1=1)
and xr.OMS2_SESSION_KEY like 'D%' 
and xr.SYSTEM_OF_RECORD = 'OMS2'
and not exists (select 1 from ods_own.IMAGE z where z.CAPTURE_SESSION_OID = xr.CAPTURE_SESSION_OID)
)


&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* ODS_STAGE.CAPTURE_SESSION_XR */

delete
from
ODS_STAGE.CAPTURE_SESSION_XR xr
where (1=1)
and xr.OMS2_SESSION_KEY like 'D%' 
and xr.SYSTEM_OF_RECORD = 'OMS2'
and not exists (select 1 from ODS_OWN.CAPTURE_SESSION z where z.CAPTURE_SESSION_OID = xr.CAPTURE_SESSION_OID)

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* ODS_OWN.SUBJECT */

delete
from 
ODS_OWN.SUBJECT s where s.SUBJECT_OID in (
select
xr.SUBJECT_OID
from
ODS_STAGE.SUBJECT_XR xr
where (1=1)
and xr.OMS2_SUBJECT_KEY like 'D%' 
and xr.SYSTEM_OF_RECORD = 'OMS2'
)


&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* ODS_STAGE.SUBJECT_XR */

delete
from
ODS_STAGE.SUBJECT_XR xr
where (1=1)
and xr.OMS2_SUBJECT_KEY like 'D%' 
and xr.SYSTEM_OF_RECORD = 'OMS2'
and not exists (select 1 from ODS_OWN.SUBJECT z where z.SUBJECT_OID = xr.SUBJECT_OID)

&


/*-----------------------------------------------*/
