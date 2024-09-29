/* TASK No. 1 */
/* Drop work table */
/*-----------------------------------------------*/
/* TASK No. 2 */
/* Create work table */
/*-----------------------------------------------*/
/* TASK No. 3 */
/* Load data */
/* SOURCE CODE */
/* drop table RAX_APP_USER.C$_0PS_PACKAGE_ITEM_XR */
/* create table RAX_APP_USER.C$_0PS_PACKAGE_ITEM_XR
(
	C1_ITEM_ID	NUMBER(22) NULL
)
NOLOGGING */
/* select	DISTINCT
	PACKAGE_ITEM.ITEM_ID	   C1_ITEM_ID
from	PS_OWN.PACKAGE_ITEM   PACKAGE_ITEM
where	(1=1) */
/* insert into RAX_APP_USER.C$_0PS_PACKAGE_ITEM_XR
(
	C1_ITEM_ID
)
values
(
	:C1_ITEM_ID
) */
/* TARGET CODE */
/*-----------------------------------------------*/
/* TASK No. 4 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0PS_PACKAGE_ITEM_XR',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;

& /*-----------------------------------------------*/
/* TASK No. 6 */
/* Insert new rows */



insert into	ODS_STAGE.PS_PACKAGE_ITEM_XR 
( 
	ITEM_ID 
	,PACKAGE_ITEM_OID 
) 

select
    ITEM_ID   
  ,ODS_STAGE.PACKAGE_ITEM_OID_SEQ.nextval 
FROM (	


select 	DISTINCT
	C1_ITEM_ID ITEM_ID 
from	ODS_STAGE.PS_PACKAGE_ITEM_XR   PS_PACKAGE_ITEM_XR, RAX_APP_USER.C$_0PS_PACKAGE_ITEM_XR
where		(1=1)	
 And (C1_ITEM_ID=PS_PACKAGE_ITEM_XR.ITEM_ID (+)
AND PS_PACKAGE_ITEM_XR.ITEM_ID IS NULL)





)    ODI_GET_FROM

& /*-----------------------------------------------*/
/* TASK No. 7 */
/* Commit transaction */
/* commit */
/*-----------------------------------------------*/
/* TASK No. 1000005 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0PS_PACKAGE_ITEM_XR */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0PS_PACKAGE_ITEM_XR';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 8 */
/* Drop work table */
/*-----------------------------------------------*/
/* TASK No. 9 */
/* Create work table */
/*-----------------------------------------------*/
/* TASK No. 10 */
/* Load data */
/* SOURCE CODE */
/* drop table RAX_APP_USER.C$_0PACKAGE_ITEM */
/* create table RAX_APP_USER.C$_0PACKAGE_ITEM
(
	C1_ITEM_ID	NUMBER(19) NULL,
	C2_MAX_PACKAGE_ID	NUMBER(19) NULL,
	C3_ITEM_ID	NUMBER(19) NULL
)
NOLOGGING */
/* select	
	T_TMP_PACKAGE_ITEM_MAX.ITEM_ID	   C1_ITEM_ID,
	T_TMP_PACKAGE_ITEM_MAX.MAX_PACKAGE_ID	   C2_MAX_PACKAGE_ID,
	T_TMP_PACKAGE_ITEM_MAX.ITEM_ID	   C3_ITEM_ID
from	(

select 	
	MAX(PACKAGE_ITEM.PACKAGE_ID)    MAX_PACKAGE_ID,	PACKAGE_ITEM.ITEM_ID    ITEM_ID
from	PS_OWN.PACKAGE_ITEM   PACKAGE_ITEM
where	(1=1)


Group By PACKAGE_ITEM.ITEM_ID

)   T_TMP_PACKAGE_ITEM_MAX
where	(1=1) */
/* insert into RAX_APP_USER.C$_0PACKAGE_ITEM
(
	C1_ITEM_ID,
	C2_MAX_PACKAGE_ID,
	C3_ITEM_ID
)
values
(
	:C1_ITEM_ID,
	:C2_MAX_PACKAGE_ID,
	:C3_ITEM_ID
) */
/* TARGET CODE */
/*-----------------------------------------------*/
/* TASK No. 11 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0PACKAGE_ITEM',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;

& /*-----------------------------------------------*/
/* TASK No. 13 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_PACKAGE_ITEM */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_PACKAGE_ITEM';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 14 */
/* Create flow table I$ */



create table RAX_APP_USER.I$_PACKAGE_ITEM
(
	PACKAGE_ITEM_OID	NUMBER(22) NULL,
	ITEM_SKU_OID	NUMBER(22) NULL,
	PACKAGE_SKU_OID	NUMBER(22) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	SOURCE_SYSTEM_OID	NUMBER(22) NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

& /*-----------------------------------------------*/
/* TASK No. 15 */
/* Insert flow into I$ table */
/*+ APPEND */



insert   into RAX_APP_USER.I$_PACKAGE_ITEM
	(
	PACKAGE_ITEM_OID,
	ITEM_SKU_OID,
	PACKAGE_SKU_OID,
	SOURCE_SYSTEM_OID
	,IND_UPDATE
	)


select 	 
	
	PS_PACKAGE_ITEM_XR.PACKAGE_ITEM_OID,
	ITEM_SKU_LKP.STOCK_KEEPING_UNIT_OID,
	PACKAGE_SKU_LKP.STOCK_KEEPING_UNIT_OID,
	SOURCE_SYSTEM.SOURCE_SYSTEM_OID,

	'I' IND_UPDATE

from	ODS_STAGE.PS_STOCK_KEEPING_UNIT_XR   ITEM_SKU_LKP, ODS_STAGE.PS_STOCK_KEEPING_UNIT_XR   PACKAGE_SKU_LKP, ODS_STAGE.PS_PACKAGE_ITEM_XR   PS_PACKAGE_ITEM_XR, ODS_OWN.SOURCE_SYSTEM   SOURCE_SYSTEM, RAX_APP_USER.C$_0PACKAGE_ITEM
where	(1=1)
 And (C1_ITEM_ID=ITEM_SKU_LKP.STOCK_KEEPING_UNIT_ID (+))
AND (C2_MAX_PACKAGE_ID=PACKAGE_SKU_LKP.STOCK_KEEPING_UNIT_ID (+))
AND (C1_ITEM_ID=PS_PACKAGE_ITEM_XR.ITEM_ID (+))
And (SOURCE_SYSTEM.SOURCE_SYSTEM_SHORT_NAME='PS')




minus
select
	PACKAGE_ITEM_OID,
	ITEM_SKU_OID,
	PACKAGE_SKU_OID,
	SOURCE_SYSTEM_OID
	,'I'	IND_UPDATE
from	ODS_OWN.PACKAGE_ITEM

& /*-----------------------------------------------*/
/* TASK No. 16 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_PACKAGE_ITEM',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& /*-----------------------------------------------*/
/* TASK No. 17 */
/* Create Index on flow table */


 /* create index	RAX_APP_USER.I$_PACKAGE_ITEM_IDX
on		RAX_APP_USER.I$_PACKAGE_ITEM (PACKAGE_ITEM_OID)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_PACKAGE_ITEM_IDX
on		RAX_APP_USER.I$_PACKAGE_ITEM (PACKAGE_ITEM_OID)
NOLOGGING';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 18 */
/* Merge Rows */



merge into	ODS_OWN.PACKAGE_ITEM T
using	(SELECT *
    FROM RAX_APP_USER.I$_PACKAGE_ITEM
    WHERE PACKAGE_SKU_OID IS NOT NULL AND ITEM_SKU_OID IS NOT NULL) S
on	(
		T.PACKAGE_ITEM_OID=S.PACKAGE_ITEM_OID
	)
when matched
then update set
	T.ITEM_SKU_OID	= S.ITEM_SKU_OID,
	T.PACKAGE_SKU_OID	= S.PACKAGE_SKU_OID,
	T.SOURCE_SYSTEM_OID	= S.SOURCE_SYSTEM_OID
	,   T.ODS_MODIFY_DATE	= SYSDATE
when not matched
then insert
	(
	T.PACKAGE_ITEM_OID,
	T.ITEM_SKU_OID,
	T.PACKAGE_SKU_OID,
	T.SOURCE_SYSTEM_OID
	,    T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.PACKAGE_ITEM_OID,
	S.ITEM_SKU_OID,
	S.PACKAGE_SKU_OID,
	S.SOURCE_SYSTEM_OID
	,    SYSDATE,
	SYSDATE
	)
		
& /*-----------------------------------------------*/
/* TASK No. 19 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 20 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_PACKAGE_ITEM */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_PACKAGE_ITEM';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 1000012 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0PACKAGE_ITEM */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0PACKAGE_ITEM';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/





&