-- /*-----------------------------------------------*/
-- /* TASK No. 46 */
-- /* Drop work table */

-- drop table RAX_APP_USER.C$_0OMS3_KIT_ITEM_STG;  

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 47 */
-- /* Create work table */

-- create table RAX_APP_USER.C$_0OMS3_KIT_ITEM_STG
-- (
-- 	C1_KIT_ITEM_KEY	VARCHAR2(24) NULL
-- )
-- NOLOGGING

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 48 */
-- /* Load data */

-- /* SOURCE CODE */
-- select	
-- 	trim(YFS_KIT_ITEM.KIT_ITEM_KEY)	   C1_KIT_ITEM_KEY
-- from	OMS3_OWN.YFS_KIT_ITEM   YFS_KIT_ITEM
-- where	(1=1)






-- &

-- /* TARGET CODE */
-- insert into RAX_APP_USER.C$_0OMS3_KIT_ITEM_STG
-- (
-- 	C1_KIT_ITEM_KEY
-- )
-- values
-- (
-- 	:C1_KIT_ITEM_KEY
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 49 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0OMS3_KIT_ITEM_STG',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;




&


/*-----------------------------------------------*/
/* TASK No. 51 */
/* Insert new rows */

 
insert into	ODS_STAGE.OMS3_KIT_ITEM_STG 
( 
	KIT_ITEM_KEY 
	 
) 

select
    KIT_ITEM_KEY   
   
FROM (	


select 	
	C1_KIT_ITEM_KEY KIT_ITEM_KEY 
from	RAX_APP_USER.C$_0OMS3_KIT_ITEM_STG
where		(1=1)	






)    ODI_GET_FROM




&


/*-----------------------------------------------*/
/* TASK No. 52 */
/* Commit transaction */

/* commit */


/*-----------------------------------------------*/
/* TASK No. 1000050 */
/* Drop work table */

drop table RAX_APP_USER.C$_0OMS3_KIT_ITEM_STG 

&


/*-----------------------------------------------*/
/* TASK No. 53 */
/* delete from kit item table */

  DELETE FROM ODS_OWN.KIT_ITEM KI WHERE  EXISTS (
    SELECT 1 FROM (
    SELECT XR.KIT_ITEM_OID FROM ODS_STAGE.OMS_KIT_ITEM_XR XR, 
   ODS_STAGE.OMS3_KIT_ITEM_STG STG
    WHERE XR.KIT_ITEM_KEY=STG.KIT_ITEM_KEY(+)
    AND STG.KIT_ITEM_KEY IS NULL) STG WHERE KI.KIT_ITEM_OID=STG.KIT_ITEM_OID) 
    
   

&
