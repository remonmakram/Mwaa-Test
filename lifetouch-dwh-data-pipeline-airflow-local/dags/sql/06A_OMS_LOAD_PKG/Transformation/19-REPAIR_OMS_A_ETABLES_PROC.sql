/* TASK No. 1 */
/* Fixup e$_order_line (order_header_oid) */

merge into E$_ORDER_LINE c 
using (
select c.order_header_oid,ODI_PK         
from 
E$_ORDER_LINE a
, ods_stage.OMS_ORDER_LINE_XR b
, ods_stage.OMS_ORDER_HEADER_XR c
where (1=1) 
and a.order_line_oid = b.order_line_oid 
and b.order_header_key = c.order_header_key(+)
and c.order_header_oid <> nvl(a.order_header_oid,-1)
--and A.ODI_ERR_MESS like '%The column ORDER_HEADER_OID cannot be null.'
) s on (c.ODI_PK = s.ODI_PK)
when matched then update
set 
c.order_header_oid = s.order_header_oid

&


/*-----------------------------------------------*/
/* TASK No. 2 */
/* Fixup E$_ORDER_LINE (ITEM_OID) */

merge into E$_ORDER_LINE c 
using (
select c.ITEM_oid,ODI_PK         
from 
E$_ORDER_LINE a
, ods_stage.OMS_ORDER_LINE_XR b 
, ods_own.ITEM c
where (1=1) 
and a.order_line_oid = b.order_line_oid 
and b.ITEM_KEY = c.ITEM_ID(+)
and c.ITEM_oid <> nvl(a.ITEM_oid,-1)
--and a.odi_err_mess like '%The column ITEM_OID cannot be null.'
) s on (c.ODI_PK = s.ODI_PK)
when matched then update
set 
c.ITEM_oid = s.ITEM_oid

&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* Fixup e$_header_charge98001 (add order_header_oid) */

update
(select e.order_header_oid as old_order_header_oid
         , ohxr.order_header_oid as new_order_header_oid
  from e$_header_charge98001 e
      ,ods_stage.oms_header_charge_xr hcxr
      ,ods_stage.oms_order_header_xr ohxr
  where e.header_charge_oid = hcxr.header_charge_oid
      and hcxr.header_key = ohxr.order_header_key
)
set old_order_header_oid = new_order_header_oid


/*
update e$_header_charge98001 ehc
set ehc.order_header_oid = (select 
  oh.order_header_oid
  from ods_own.order_header oh
  , ods_stage.oms_header_charge_xr hcxr
  , ods_own.header_charge hc
  where ehc.header_charge_oid = hcxr.header_charge_oid
  and hcxr.header_key = hc.header_charge_oid
  and hc.order_header_oid = oh.order_header_oid)
where ehc.order_header_oid is null
*/

&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* Fixup e$_line_charge108001 (add order_line_oid) */

merge into E$_LINE_CHARGE108001 c 
using (
select pxr.ORDER_LINE_oid,ODI_PK 
from E$_LINE_CHARGE108001 e, ods_stage.OMS_LINE_CHARGE_XR sxr, ods_stage.OMS_ORDER_LINE_XR pxr
where (1=1) and E.LINE_CHARGE_OID = SXR.LINE_CHARGE_OID and SXR.LINE_KEY = PXR.ORDER_LINE_KEY(+)
and pxr.ORDER_LINE_oid <> nvl(e.ORDER_LINE_oid,-1)
) s on (c.ODI_PK = s.ODI_PK)
when matched then update
set 
c.ORDER_LINE_oid = s.ORDER_LINE_oid

/*
update e$_line_charge108001 elc
set elc.order_line_oid = (select 
  ol.order_line_oid
  from ods_own.order_line ol
  , ods_stage.oms_line_charge_xr lcxr
  , ods_stage.oms_order_line_xr olxr
  where elc.line_charge_oid = lcxr.line_charge_oid
  and lcxr.line_key = olxr.order_line_key
  and ol.order_line_oid = olxr.order_line_oid)
where elc.order_line_oid is null
*/

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Fixup E$_PROMOTION28300 (order_header_oid) */

BEGIN  
   EXECUTE IMMEDIATE 'merge into E$_PROMOTION28300 c 
                        using (
                        select pxr.ORDER_HEADER_oid,ODI_PK --, x.*,d.*
                        from 
                        E$_PROMOTION28300 e, ods_stage.OMS_PROMOTION_XR sxr, ods_stage.OMS_ORDER_HEADER_XR pxr
                        where (1=1) and E.PROMOTION_OID = SXR.PROMOTION_OID and SXR.ORDER_HEADER_KEY = PXR.ORDER_HEADER_KEY
                        and pxr.ORDER_HEADER_oid <> nvl(e.ORDER_HEADER_oid,-1)
                        ) s on (c.ODI_PK = s.ODI_PK)
                        when matched then update
                        set 
                        c.ORDER_HEADER_oid = s.ORDER_HEADER_oid';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Fixup  E$_SHIPMENT60001 (person_info_oid) */

merge into E$_SHIPMENT60001 c 
using (
select pxr.person_info_oid,ODI_PK       
from 
E$_SHIPMENT60001 e, ods_stage.OMS_SHIPMENT_XR sxr, ods_stage.OMS_PERSON_INFO_XR pxr
where (1=1) and E.SHIPMENT_OID = SXR.SHIPMENT_OID and SXR.TO_ADDRESS_KEY = PXR.PERSON_INFO_KEY(+)  
and pxr.person_info_oid <> nvl(e.person_info_oid,-3)
) s on (c.ODI_PK = s.ODI_PK)
when matched then update
set 
c.person_info_oid = s.person_info_oid


&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Fixup E$_ORDER_HEADER (PERSON_INFO_OID) */

merge into E$_ORDER_HEADER c 
using (
    select c.PERSON_INFO_OID,ODI_PK         
    from 
        E$_ORDER_HEADER a
        , ODS_STAGE.OMS_ORDER_HEADER_XR b
        , ODS_STAGE.OMS_PERSON_INFO_XR c
    where (1=1) 
    and a.ORDER_HEADER_OID = b.ORDER_HEADER_OID and b.SHIP_TO_KEY = c.PERSON_INFO_KEY(+)
    and c.PERSON_INFO_OID <> nvl(a.PERSON_INFO_OID,-1)
) s on (c.ODI_PK = s.ODI_PK)
when matched then update
set 
c.PERSON_INFO_OID = s.PERSON_INFO_OID

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Fixup E$_ORDER_HEADER (EVENT_OID) */

merge into E$_ORDER_HEADER c 
using (
    select E.EVENT_OID,e.apo_oid,a.ODI_PK         
    from 
        E$_ORDER_HEADER a
        , ODS_OWN.event e
    where (1=1) 
    and A.EVENT_REF_ID = E.EVENT_REF_ID
    and (nvl(A.EVENT_OID,-11111) <> nvl(E.EVENT_OID,-11111) 
         or nvl(A.APO_OID,-11111) <> nvl(e.APO_OID,-11111) )
) s on (c.ODI_PK = s.ODI_PK)
when matched then update
set 
c.EVENT_OID = s.EVENT_OID
,c.APO_OID = s.APO_OID

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Fix E$_ORDER_HEADER (PRICE_PROGRAM_OID) */

merge into E$_ORDER_HEADER c 
using (
    select 
        c.PRICE_PROGRAM_OID
        ,a.ODI_PK         
    -- select *
    from 
        E$_ORDER_HEADER a
        , ODS_STAGE.OMS_ORDER_HEADER_XR b
        , ODS_OWN.PRICE_PROGRAM c
    where (1=1) 
--    and a.order_header_oid = 7505040
        and a.ORDER_HEADER_OID = b.ORDER_HEADER_OID
        and b.PRICE_PROGRAM_NAME = c.PRICE_PROGRAM_NAME(+)
        and nvl(a.PRICE_PROGRAM_OID,-1) <> c.PRICE_PROGRAM_OID
) s on (c.ODI_PK = s.ODI_PK)
when matched then update
set 
c.PRICE_PROGRAM_OID = s.PRICE_PROGRAM_OID

&


/*-----------------------------------------------*/
