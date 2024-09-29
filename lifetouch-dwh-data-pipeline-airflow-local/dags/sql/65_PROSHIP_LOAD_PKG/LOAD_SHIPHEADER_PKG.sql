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
/* Delete from ShipHeader_tmp */

-- delete from rax_app_user.proship_shipheader_tmp

-- &


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Load Proship_ShipHeader_tmp */

/* SOURCE CODE */
-- select 
-- 	ID ,
-- 	InternalID ,
-- 	UserID ,
-- 	MachineName ,
-- 	OrderNumber ,
-- 	Company ,
-- 	Contact ,
-- 	Address1 ,
-- 	Address2 ,
-- 	Address3 ,
-- 	City ,
-- 	State ,
-- 	Zip ,
-- 	Country ,
-- 	ServiceCode ,
-- 	PlainTextService ,
-- 	Shipper ,
-- 	ShipDate ,
-- 	ConsigneeReference ,
-- 	PaymentTerms ,
-- 	SatDelFlag ,
-- 	ResDelFlag ,
-- 	CODFlag ,
-- 	CODAmt ,
-- 	InsAmt ,
-- 	AdditionalHandlingCharge,
-- 	Dimensions ,
-- 	Weight ,
-- 	NumberofPallets ,
-- 	NumberofPackages ,
-- 	SigReqFlag ,
-- 	MiscRef1 ,
-- 	MiscRef2 ,
-- 	MiscRef3 ,
-- 	MiscRef4 ,
-- 	MiscRef5 ,
-- 	cast(TrackingNumber as varchar) as TrackingNumber ,
-- 	Base ,
-- 	Discount ,
-- 	Special ,
-- 	FuelSurcharge ,
-- 	Total ,
-- 	ErrMsg ,
-- 	Status ,
-- 	AltKey ,
-- 	Winner ,
-- 	Override ,
-- 	ProcessDate ,
-- 	TransitTime ,
-- 	WriteBack ,
-- 	TransmittingStatus ,
-- 	scac ,
-- 	boln ,
-- 	class ,
-- 	com_desc ,
-- 	special_inst ,
-- 	nmfc_item ,
-- 	nmfc_sub ,
-- 	ltl_ctns ,
-- 	pkg_cost ,
-- 	DimH ,
-- 	DimL ,
-- 	DimW ,
-- 	Void_ID ,
-- 	MbtDate,
-- 	pkg_type ,
-- 	TNT ,
-- 	[Zone] ,
-- 	Resolved ,
-- 	Pickup_dt ,
-- 	Delivery_dt
-- 	from SPSI.dbo.ShipHeader s 
-- where s.ShipDate >=  DATEADD(DAY,-3,CONVERT(DATETIME,(SUBSTRING(:v_cdc_load_date,1,19)),121))


-- &

-- /* TARGET CODE */
-- insert into rax_app_user.proship_shipheader_tmp(
-- ID ,
-- 	InternalID ,
-- 	UserID ,
-- 	MachineName ,
-- 	OrderNumber ,
-- 	Company ,
-- 	Contact ,
-- 	Address1 ,
-- 	Address2 ,
-- 	Address3 ,
-- 	City ,
-- 	State ,
-- 	Zip ,
-- 	Country ,
-- 	ServiceCode ,
-- 	PlainTextService ,
-- 	Shipper ,
-- 	ShipDate ,
-- 	ConsigneeReference ,
-- 	PaymentTerms ,
-- 	SatDelFlag ,
-- 	ResDelFlag ,
-- 	CODFlag ,
-- 	CODAmt ,
-- 	InsAmt ,
-- 	AdditionalHandlingCharge,
-- 	Dimensions ,
-- 	Weight ,
-- 	NumberofPallets ,
-- 	NumberofPackages ,
-- 	SigReqFlag ,
-- 	MiscRef1 ,
-- 	MiscRef2 ,
-- 	MiscRef3 ,
-- 	MiscRef4 ,
-- 	MiscRef5 ,
-- 	TrackingNumber ,
-- 	Base ,
-- 	Discount ,
-- 	Special ,
-- 	FuelSurcharge ,
-- 	Total ,
-- 	ErrMsg ,
-- 	Status ,
-- 	AltKey ,
-- 	Winner ,
-- 	Override ,
-- 	ProcessDate ,
-- 	TransitTime ,
-- 	WriteBack ,
-- 	TransmittingStatus ,
-- 	scac ,
-- 	boln ,
-- 	class ,
-- 	com_desc ,
-- 	special_inst ,
-- 	nmfc_item ,
-- 	nmfc_sub ,
-- 	ltl_ctns ,
-- 	pkg_cost ,
-- 	DimH ,
-- 	DimL ,
-- 	DimW ,
-- 	Void_ID ,
-- 	MbtDate,
-- 	pkg_type ,
-- 	TNT ,
-- 	Zone ,
-- 	Resolved ,
-- 	Pickup_dt ,
-- 	Delivery_dt,
--                       ods_create_date,
--                       ods_modify_date)
-- values 
-- (
-- :ID ,
-- 	:InternalID ,
-- 	:UserID ,
-- 	:MachineName ,
-- 	:OrderNumber ,
-- 	:Company ,
-- 	:Contact ,
-- 	:Address1 ,
-- 	:Address2 ,
-- 	:Address3 ,
-- 	:City ,
-- 	:State ,
-- 	:Zip ,
-- 	:Country ,
-- 	:ServiceCode ,
-- 	:PlainTextService ,
-- 	:Shipper ,
-- 	:ShipDate ,
-- 	:ConsigneeReference ,
-- 	:PaymentTerms ,
-- 	:SatDelFlag ,
-- 	:ResDelFlag ,
-- 	:CODFlag ,
-- 	:CODAmt ,
-- 	:InsAmt ,
-- 	:AdditionalHandlingCharge,
-- 	:Dimensions ,
-- 	:Weight ,
-- 	:NumberofPallets ,
-- 	:NumberofPackages ,
-- 	:SigReqFlag ,
-- 	:MiscRef1 ,
-- 	:MiscRef2 ,
-- 	:MiscRef3 ,
-- 	:MiscRef4 ,
-- 	:MiscRef5 ,
-- 	:TrackingNumber ,
-- 	:Base ,
-- 	:Discount ,
-- 	:Special ,
-- 	:FuelSurcharge ,
-- 	:Total ,
-- 	:ErrMsg ,
-- 	:Status ,
-- 	:AltKey ,
-- 	:Winner ,
-- 	:Override ,
-- 	:ProcessDate ,
-- 	:TransitTime ,
-- 	:WriteBack ,
-- 	:TransmittingStatus ,
-- 	:scac ,
-- 	:boln ,
-- 	:class ,
-- 	:com_desc ,
-- 	:special_inst ,
-- 	:nmfc_item ,
-- 	:nmfc_sub ,
-- 	:ltl_ctns ,
-- 	:pkg_cost ,
-- 	:DimH ,
-- 	:DimL ,
-- 	:DimW ,
-- 	:Void_ID ,
-- 	:MbtDate,
-- 	:pkg_type ,
-- 	:TNT ,
-- 	:Zone ,
-- 	:Resolved ,
-- 	:Pickup_dt ,
-- 	:Delivery_dt,
--                       sysdate,
--                       sysdate)



-- &


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Load Proship_ShipHeader_stg */

MERGE INTO ODS_STAGE.PROSHIP_SHIPHEADER_STG t
     USING (SELECT ID,
                   InternalID,
                   UserID,
                   MachineName,
                   OrderNumber,
                   Company,
                   Contact,
                   Address1,
                   Address2,
                   Address3,
                   City,
                   State,
                   Zip,
                   Country,
                   ServiceCode,
                   PlainTextService,
                   Shipper,
                   ShipDate,
                   ConsigneeReference,
                   PaymentTerms,
                   SatDelFlag,
                   ResDelFlag,
                   CODFlag,
                   CODAmt,
                   InsAmt,
                   AdditionalHandlingCharge,
                   Dimensions,
                   Weight,
                   NumberofPallets,
                   NumberofPackages,
                   SigReqFlag,
                   MiscRef1,
                   MiscRef2,
                   MiscRef3,
                   MiscRef4,
                   MiscRef5,
                   TrackingNumber,
                   Base,
                   Discount,
                   Special,
                   FuelSurcharge,
                   Total,
                   ErrMsg,
                   Status,
                   AltKey,
                   Winner,
                   Override,
                   ProcessDate,
                   TransitTime,
                   WriteBack,
                   TransmittingStatus,
                   scac,
                   boln,
                   class,
                   com_desc,
                   special_inst,
                   nmfc_item,
                   nmfc_sub,
                   ltl_ctns,
                   pkg_cost,
                   DimH,
                   DimL,
                   DimW,
                   Void_ID,
                   MbtDate,
                   pkg_type,
                   TNT,
                   Zone,
                   Resolved,
                   Pickup_dt,
                   Delivery_dt
              FROM rax_app_user.proship_shipheader_tmp) s
        ON (t.id = s.id)
WHEN NOT MATCHED
THEN
    INSERT     (ID,
                InternalID,
                UserID,
                MachineName,
                OrderNumber,
                Company,
                Contact,
                Address1,
                Address2,
                Address3,
                City,
                State,
                Zip,
                Country,
                ServiceCode,
                PlainTextService,
                Shipper,
                ShipDate,
                ConsigneeReference,
                PaymentTerms,
                SatDelFlag,
                ResDelFlag,
                CODFlag,
                CODAmt,
                InsAmt,
                AdditionalHandlingCharge,
                Dimensions,
                Weight,
                NumberofPallets,
                NumberofPackages,
                SigReqFlag,
                MiscRef1,
                MiscRef2,
                MiscRef3,
                MiscRef4,
                MiscRef5,
                TrackingNumber,
                Base,
                Discount,
                Special,
                FuelSurcharge,
                Total,
                ErrMsg,
                Status,
                AltKey,
                Winner,
                Override,
                ProcessDate,
                TransitTime,
                WriteBack,
                TransmittingStatus,
                scac,
                boln,
                class,
                com_desc,
                special_inst,
                nmfc_item,
                nmfc_sub,
                ltl_ctns,
                pkg_cost,
                DimH,
                DimL,
                DimW,
                Void_ID,
                MbtDate,
                pkg_type,
                TNT,
                Zone,
                Resolved,
                Pickup_dt,
                Delivery_dt,
                ods_create_date,
                ods_modify_date)
        VALUES (s.ID,
                s.InternalID,
                s.UserID,
                s.MachineName,
                s.OrderNumber,
                s.Company,
                s.Contact,
                s.Address1,
                s.Address2,
                s.Address3,
                s.City,
                s.State,
                s.Zip,
                s.Country,
                s.ServiceCode,
                s.PlainTextService,
                s.Shipper,
                s.ShipDate,
                s.ConsigneeReference,
                s.PaymentTerms,
                s.SatDelFlag,
                s.ResDelFlag,
                s.CODFlag,
                s.CODAmt,
                s.InsAmt,
                s.AdditionalHandlingCharge,
                s.Dimensions,
                s.Weight,
                s.NumberofPallets,
                s.NumberofPackages,
                s.SigReqFlag,
                s.MiscRef1,
                s.MiscRef2,
                s.MiscRef3,
                s.MiscRef4,
                s.MiscRef5,
                s.TrackingNumber,
                s.Base,
                s.Discount,
                s.Special,
                s.FuelSurcharge,
                s.Total,
                s.ErrMsg,
                s.Status,
                s.AltKey,
                s.Winner,
                s.Override,
                s.ProcessDate,
                s.TransitTime,
                s.WriteBack,
                s.TransmittingStatus,
                s.scac,
                s.boln,
                s.class,
                s.com_desc,
                s.special_inst,
                s.nmfc_item,
                s.nmfc_sub,
                s.ltl_ctns,
                s.pkg_cost,
                s.DimH,
                s.DimL,
                s.DimW,
                s.Void_ID,
                s.MbtDate,
                s.pkg_type,
                s.TNT,
                s.Zone,
                s.Resolved,
                s.Pickup_dt,
                s.Delivery_dt,
                SYSDATE,
                SYSDATE)
WHEN MATCHED
THEN
    UPDATE SET
        t.InternalID = s.InternalID,
        t.UserID = s.UserID,
        t.MachineName = s.MachineName,
        t.OrderNumber = s.OrderNumber,
        t.Company = s.Company,
        t.Contact = s.Contact,
        t.Address1 = s.Address1,
        t.Address2 = s.Address2,
        t.Address3 = s.Address3,
        t.City = s.City,
        t.State = s.State,
        t.Zip = s.Zip,
        t.Country = s.Country,
        t.ServiceCode = s.ServiceCode,
        t.PlainTextService = s.PlainTextService,
        t.Shipper = s.Shipper,
        t.ShipDate = s.ShipDate,
        t.ConsigneeReference = s.ConsigneeReference,
        t.PaymentTerms = s.PaymentTerms,
        t.SatDelFlag = s.SatDelFlag,
        t.ResDelFlag = s.ResDelFlag,
        t.CODFlag = s.CODFlag,
        t.CODAmt = s.CODAmt,
        t.InsAmt = s.InsAmt,
        t.AdditionalHandlingCharge = s.AdditionalHandlingCharge,
        t.Dimensions = s.Dimensions,
        t.Weight = s.Weight,
        t.NumberofPallets = s.NumberofPallets,
        t.NumberofPackages = s.NumberofPackages,
        t.SigReqFlag = s.SigReqFlag,
        t.MiscRef1 = s.MiscRef1,
        t.MiscRef2 = s.MiscRef2,
        t.MiscRef3 = s.MiscRef3,
        t.MiscRef4 = s.MiscRef4,
        t.MiscRef5 = s.MiscRef5,
        t.TrackingNumber = s.TrackingNumber,
        t.Base = s.Base,
        t.Discount = s.Discount,
        t.Special = s.Special,
        t.FuelSurcharge = s.FuelSurcharge,
        t.Total = s.Total,
        t.ErrMsg = s.ErrMsg,
        t.Status = s.Status,
        t.AltKey = s.AltKey,
        t.Winner = s.Winner,
        t.Override = s.Override,
        t.ProcessDate = s.ProcessDate,
        t.TransitTime = s.TransitTime,
        t.WriteBack = s.WriteBack,
        t.TransmittingStatus = s.TransmittingStatus,
        t.scac = s.scac,
        t.boln = s.boln,
        t.class = s.class,
        t.com_desc = s.com_desc,
        t.special_inst = s.special_inst,
        t.nmfc_item = s.nmfc_item,
        t.nmfc_sub = s.nmfc_sub,
        t.ltl_ctns = s.ltl_ctns,
        t.pkg_cost = s.pkg_cost,
        t.DimH = s.DimH,
        t.DimL = s.DimL,
        t.DimW = s.DimW,
        t.Void_ID = s.Void_ID,
        t.MbtDate = s.MbtDate,
        t.pkg_type = s.pkg_type,
        t.TNT = s.TNT,
        t.Zone = s.Zone,
        t.Resolved = s.Resolved,
        t.Pickup_dt = s.Pickup_dt,
        t.Delivery_dt = s.Delivery_dt,
        t.ods_modify_date = SYSDATE
             WHERE    DECODE (InternalID, s.InternalID, 1, 0) = 0
                   OR DECODE (UserID, s.UserID, 1, 0) = 0
                   OR DECODE (MachineName, s.MachineName, 1, 0) = 0
                   OR DECODE (OrderNumber, s.OrderNumber, 1, 0) = 0
                   OR DECODE (Company, s.Company, 1, 0) = 0
                   OR DECODE (Contact, s.Contact, 1, 0) = 0
                   OR DECODE (Address1, s.Address1, 1, 0) = 0
                   OR DECODE (Address2, s.Address2, 1, 0) = 0
                   OR DECODE (Address3, s.Address3, 1, 0) = 0
                   OR DECODE (City, s.City, 1, 0) = 0
                   OR DECODE (State, s.State, 1, 0) = 0
                   OR DECODE (Zip, s.Zip, 1, 0) = 0
                   OR DECODE (Country, s.Country, 1, 0) = 0
                   OR DECODE (ServiceCode, s.ServiceCode, 1, 0) = 0
                   OR DECODE (PlainTextService, s.PlainTextService, 1, 0) = 0
                   OR DECODE (Shipper, s.Shipper, 1, 0) = 0
                   OR DECODE (ShipDate, s.ShipDate, 1, 0) = 0
                   OR DECODE (ConsigneeReference, s.ConsigneeReference, 1, 0) =
                      0
                   OR DECODE (PaymentTerms, s.PaymentTerms, 1, 0) = 0
                   OR DECODE (SatDelFlag, s.SatDelFlag, 1, 0) = 0
                   OR DECODE (ResDelFlag, s.ResDelFlag, 1, 0) = 0
                   OR DECODE (CODFlag, s.CODFlag, 1, 0) = 0
                   OR DECODE (CODAmt, s.CODAmt, 1, 0) = 0
                   OR DECODE (InsAmt, s.InsAmt, 1, 0) = 0
                   OR DECODE (AdditionalHandlingCharge,
                              s.AdditionalHandlingCharge, 1,
                              0) =
                      0
                   OR DECODE (Dimensions, s.Dimensions, 1, 0) = 0
                   OR DECODE (Weight, s.Weight, 1, 0) = 0
                   OR DECODE (NumberofPallets, s.NumberofPallets, 1, 0) = 0
                   OR DECODE (NumberofPackages, s.NumberofPackages, 1, 0) = 0
                   OR DECODE (SigReqFlag, s.SigReqFlag, 1, 0) = 0
                   OR DECODE (MiscRef1, s.MiscRef1, 1, 0) = 0
                   OR DECODE (MiscRef2, s.MiscRef2, 1, 0) = 0
                   OR DECODE (MiscRef3, s.MiscRef3, 1, 0) = 0
                   OR DECODE (MiscRef4, s.MiscRef4, 1, 0) = 0
                   OR DECODE (MiscRef5, s.MiscRef5, 1, 0) = 0
                   OR DECODE (TrackingNumber, s.TrackingNumber, 1, 0) = 0
                   OR DECODE (Base, s.Base, 1, 0) = 0
                   OR DECODE (Discount, s.Discount, 1, 0) = 0
                   OR DECODE (Special, s.Special, 1, 0) = 0
                   OR DECODE (FuelSurcharge, s.FuelSurcharge, 1, 0) = 0
                   OR DECODE (Total, s.Total, 1, 0) = 0
                   OR DECODE (ErrMsg, s.ErrMsg, 1, 0) = 0
                   OR DECODE (Status, s.Status, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 7 */
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
/* TASK No. 8 */
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
,'LOAD_SHIPHEADER_PKG'
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
:v_sess_no,
'LOAD_SHIPHEADER_PKG',
'002',
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
