/* TASK No. 1 */
/* Drop work table */
/*-----------------------------------------------*/
/* TASK No. 2 */
/* Create work table */
/*-----------------------------------------------*/
/* TASK No. 3 */
/* Load data */
/* SOURCE CODE */
/* drop table RAX_APP_USER.C$_0PS_STOCK_KEEPING_UNIT_XR */
/* create table RAX_APP_USER.C$_0PS_STOCK_KEEPING_UNIT_XR
(
	C1_STOCK_KEEPING_UNIT_ID	NUMBER(22) NULL,
	C2_SKU_CODE	VARCHAR2(255) NULL
)
NOLOGGING */
/* select	DISTINCT
	STOCK_KEEPING_UNIT.STOCK_KEEPING_UNIT_ID	   C1_STOCK_KEEPING_UNIT_ID,
	STOCK_KEEPING_UNIT.SKU_CODE	   C2_SKU_CODE
from	PS_OWN.STOCK_KEEPING_UNIT   STOCK_KEEPING_UNIT
where	(1=1) */
/* insert into RAX_APP_USER.C$_0PS_STOCK_KEEPING_UNIT_XR
(
	C1_STOCK_KEEPING_UNIT_ID,
	C2_SKU_CODE
)
values
(
	:C1_STOCK_KEEPING_UNIT_ID,
	:C2_SKU_CODE
) */
/* TARGET CODE */
/*-----------------------------------------------*/
/* TASK No. 4 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0PS_STOCK_KEEPING_UNIT_XR',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;

& /*-----------------------------------------------*/
/* TASK No. 6 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_PS_STOCK_KEEPING_UNIT_XR */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_PS_STOCK_KEEPING_UNIT_XR';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 7 */
/* Create flow table I$ */



create table RAX_APP_USER.I$_PS_STOCK_KEEPING_UNIT_XR
(
	STOCK_KEEPING_UNIT_OID	NUMBER(22) NULL,
	STOCK_KEEPING_UNIT_ID	NUMBER(22) NULL,
	SKU_CODE	VARCHAR2(255) NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

& /*-----------------------------------------------*/
/* TASK No. 8 */
/* Insert flow into I$ table */
/*+ APPEND */



insert   into RAX_APP_USER.I$_PS_STOCK_KEEPING_UNIT_XR
	(
	STOCK_KEEPING_UNIT_ID,
	SKU_CODE
	,IND_UPDATE
	)


select 	 
	DISTINCT
	C1_STOCK_KEEPING_UNIT_ID,
	C2_SKU_CODE,

	'I' IND_UPDATE

from	RAX_APP_USER.C$_0PS_STOCK_KEEPING_UNIT_XR
where	(1=1)






minus
select
	STOCK_KEEPING_UNIT_ID,
	SKU_CODE
	,'I'	IND_UPDATE
from	ODS_STAGE.PS_STOCK_KEEPING_UNIT_XR

& /*-----------------------------------------------*/
/* TASK No. 9 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_PS_STOCK_KEEPING_UNIT_XR',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& /*-----------------------------------------------*/
/* TASK No. 10 */
/* Create Index on flow table */


 /* create index	RAX_APP_USER.I$_PS_STOCK_KEEPING_UNIT_XR_ID
on		RAX_APP_USER.I$_PS_STOCK_KEEPING_UNIT_XR (SKU_CODE)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_PS_STOCK_KEEPING_UNIT_XR_ID
on		RAX_APP_USER.I$_PS_STOCK_KEEPING_UNIT_XR (SKU_CODE)
NOLOGGING';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 11 */
/* Merge Rows */



merge into	ODS_STAGE.PS_STOCK_KEEPING_UNIT_XR T
using	RAX_APP_USER.I$_PS_STOCK_KEEPING_UNIT_XR S
on	(
		T.SKU_CODE=S.SKU_CODE
	)
when matched
then update set
	T.STOCK_KEEPING_UNIT_ID	= S.STOCK_KEEPING_UNIT_ID
	
when not matched
then insert
	(
	T.STOCK_KEEPING_UNIT_ID,
	T.SKU_CODE
	,  T.STOCK_KEEPING_UNIT_OID
	)
values
	(
	S.STOCK_KEEPING_UNIT_ID,
	S.SKU_CODE
	,  ODS_STAGE.STOCK_KEEPING_UNIT_OID_SEQ.nextval
	)

& /*-----------------------------------------------*/
/* TASK No. 12 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 13 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_PS_STOCK_KEEPING_UNIT_XR */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_PS_STOCK_KEEPING_UNIT_XR';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 1000005 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0PS_STOCK_KEEPING_UNIT_XR */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0PS_STOCK_KEEPING_UNIT_XR';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 14 */
/* Drop work table */
/*-----------------------------------------------*/
/* TASK No. 15 */
/* Create work table */
/*-----------------------------------------------*/
/* TASK No. 16 */
/* Load data */
/* SOURCE CODE */
/* drop table RAX_APP_USER.C$_0STOCK_KEEPING_UNIT */
/* create table RAX_APP_USER.C$_0STOCK_KEEPING_UNIT
(
	C1_TAX_PRODUCT_CODE	VARCHAR2(32) NULL,
	C2_UPGRADE_TYPE	VARCHAR2(20) NULL,
	C3_SKU_CODE	VARCHAR2(255) NULL,
	C4_NAME	VARCHAR2(255) NULL,
	C5_LOOK_COUNT	NUMBER(22) NULL,
	C6_DESCRIPTION	VARCHAR2(255) NULL,
	C7_PERSONALIZABLE	NUMBER(22) NULL,
	C8_PRODUCT_LINE	VARCHAR2(255) NULL,
	C9_DISPLAY_GROUP	VARCHAR2(20) NULL,
	C10_CATEGORY	VARCHAR2(7) NULL,
	C11_IMAGE_COUNT	NUMBER(22) NULL
)
NOLOGGING */
/* select	
	STOCK_KEEPING_UNIT.TAX_PRODUCT_CODE	   C1_TAX_PRODUCT_CODE,
	STOCK_KEEPING_UNIT.UPGRADE_TYPE	   C2_UPGRADE_TYPE,
	STOCK_KEEPING_UNIT.SKU_CODE	   C3_SKU_CODE,
	STOCK_KEEPING_UNIT.NAME	   C4_NAME,
	STOCK_KEEPING_UNIT.LOOK_COUNT	   C5_LOOK_COUNT,
	STOCK_KEEPING_UNIT.DESCRIPTION	   C6_DESCRIPTION,
	STOCK_KEEPING_UNIT.PERSONALIZABLE	   C7_PERSONALIZABLE,
	STOCK_KEEPING_UNIT.PRODUCT_LINE	   C8_PRODUCT_LINE,
	STOCK_KEEPING_UNIT.DISPLAY_GROUP	   C9_DISPLAY_GROUP,
	STOCK_KEEPING_UNIT.CATEGORY	   C10_CATEGORY,
	STOCK_KEEPING_UNIT.IMAGE_COUNT	   C11_IMAGE_COUNT
from	PS_OWN.STOCK_KEEPING_UNIT   STOCK_KEEPING_UNIT
where	(1=1) */
/* insert into RAX_APP_USER.C$_0STOCK_KEEPING_UNIT
(
	C1_TAX_PRODUCT_CODE,
	C2_UPGRADE_TYPE,
	C3_SKU_CODE,
	C4_NAME,
	C5_LOOK_COUNT,
	C6_DESCRIPTION,
	C7_PERSONALIZABLE,
	C8_PRODUCT_LINE,
	C9_DISPLAY_GROUP,
	C10_CATEGORY,
	C11_IMAGE_COUNT
)
values
(
	:C1_TAX_PRODUCT_CODE,
	:C2_UPGRADE_TYPE,
	:C3_SKU_CODE,
	:C4_NAME,
	:C5_LOOK_COUNT,
	:C6_DESCRIPTION,
	:C7_PERSONALIZABLE,
	:C8_PRODUCT_LINE,
	:C9_DISPLAY_GROUP,
	:C10_CATEGORY,
	:C11_IMAGE_COUNT
) */
/* TARGET CODE */
/*-----------------------------------------------*/
/* TASK No. 17 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0STOCK_KEEPING_UNIT',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;

& /*-----------------------------------------------*/
/* TASK No. 19 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_STOCK_KEEPING_UNIT */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_STOCK_KEEPING_UNIT';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 20 */
/* Create flow table I$ */



create table RAX_APP_USER.I$_STOCK_KEEPING_UNIT
(
	STOCK_KEEPING_UNIT_OID	NUMBER(22) NULL,
	SKU_CODE	VARCHAR2(255) NULL,
	NAME	VARCHAR2(255) NULL,
	DESCRIPTION	VARCHAR2(255) NULL,
	CATEGORY	VARCHAR2(7) NULL,
	DISPLAY_GROUP	VARCHAR2(20) NULL,
	IMAGE_COUNT	NUMBER(22) NULL,
	LOOK_COUNT	NUMBER(22) NULL,
	PERSONALIZABLE	NUMBER(22) NULL,
	PRODUCT_LINE	VARCHAR2(255) NULL,
	TAX_PRODUCT_CODE	VARCHAR2(32) NULL,
	UPGRADE_TYPE	VARCHAR2(20) NULL,
	ODS_CREATE_DATE	DATE NULL,
	ODS_MODIFY_DATE	DATE NULL,
	SOURCE_SYSTEM_OID	NUMBER(22) NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

& /*-----------------------------------------------*/
/* TASK No. 21 */
/* Insert flow into I$ table */
/*+ APPEND */



insert   into RAX_APP_USER.I$_STOCK_KEEPING_UNIT
	(
	STOCK_KEEPING_UNIT_OID,
	SKU_CODE,
	NAME,
	DESCRIPTION,
	CATEGORY,
	DISPLAY_GROUP,
	IMAGE_COUNT,
	LOOK_COUNT,
	PERSONALIZABLE,
	PRODUCT_LINE,
	TAX_PRODUCT_CODE,
	UPGRADE_TYPE,
	SOURCE_SYSTEM_OID
	,IND_UPDATE
	)


select 	 
	
	PS_STOCK_KEEPING_UNIT_XR.STOCK_KEEPING_UNIT_OID,
	C3_SKU_CODE,
	C4_NAME,
	C6_DESCRIPTION,
	C10_CATEGORY,
	C9_DISPLAY_GROUP,
	C11_IMAGE_COUNT,
	C5_LOOK_COUNT,
	C7_PERSONALIZABLE,
	C8_PRODUCT_LINE,
	C1_TAX_PRODUCT_CODE,
	C2_UPGRADE_TYPE,
	SOURCE_SYSTEM.SOURCE_SYSTEM_OID,

	'I' IND_UPDATE

from	ODS_OWN.SOURCE_SYSTEM   SOURCE_SYSTEM, ODS_STAGE.PS_STOCK_KEEPING_UNIT_XR   PS_STOCK_KEEPING_UNIT_XR, RAX_APP_USER.C$_0STOCK_KEEPING_UNIT
where	(1=1)
 And (C3_SKU_CODE=PS_STOCK_KEEPING_UNIT_XR.SKU_CODE (+))
And (SOURCE_SYSTEM.SOURCE_SYSTEM_SHORT_NAME='PS')




minus
select
	STOCK_KEEPING_UNIT_OID,
	SKU_CODE,
	NAME,
	DESCRIPTION,
	CATEGORY,
	DISPLAY_GROUP,
	IMAGE_COUNT,
	LOOK_COUNT,
	PERSONALIZABLE,
	PRODUCT_LINE,
	TAX_PRODUCT_CODE,
	UPGRADE_TYPE,
	SOURCE_SYSTEM_OID
	,'I'	IND_UPDATE
from	ODS_OWN.STOCK_KEEPING_UNIT

& /*-----------------------------------------------*/
/* TASK No. 22 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_STOCK_KEEPING_UNIT',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;

& /*-----------------------------------------------*/
/* TASK No. 23 */
/* Create Index on flow table */


 /* create index	RAX_APP_USER.I$_STOCK_KEEPING_UNIT_IDX
on		RAX_APP_USER.I$_STOCK_KEEPING_UNIT (STOCK_KEEPING_UNIT_OID)
NOLOGGING */ 


BEGIN
    EXECUTE IMMEDIATE 'create index	RAX_APP_USER.I$_STOCK_KEEPING_UNIT_IDX
on		RAX_APP_USER.I$_STOCK_KEEPING_UNIT (STOCK_KEEPING_UNIT_OID)
NOLOGGING';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 24 */
/* Merge Rows */



merge into	ODS_OWN.STOCK_KEEPING_UNIT T
using	RAX_APP_USER.I$_STOCK_KEEPING_UNIT S
on	(
		T.STOCK_KEEPING_UNIT_OID=S.STOCK_KEEPING_UNIT_OID
	)
when matched
then update set
	T.SKU_CODE	= S.SKU_CODE,
	T.NAME	= S.NAME,
	T.DESCRIPTION	= S.DESCRIPTION,
	T.CATEGORY	= S.CATEGORY,
	T.DISPLAY_GROUP	= S.DISPLAY_GROUP,
	T.IMAGE_COUNT	= S.IMAGE_COUNT,
	T.LOOK_COUNT	= S.LOOK_COUNT,
	T.PERSONALIZABLE	= S.PERSONALIZABLE,
	T.PRODUCT_LINE	= S.PRODUCT_LINE,
	T.TAX_PRODUCT_CODE	= S.TAX_PRODUCT_CODE,
	T.UPGRADE_TYPE	= S.UPGRADE_TYPE,
	T.SOURCE_SYSTEM_OID	= S.SOURCE_SYSTEM_OID
	,            T.ODS_MODIFY_DATE	= SYSDATE
when not matched
then insert
	(
	T.STOCK_KEEPING_UNIT_OID,
	T.SKU_CODE,
	T.NAME,
	T.DESCRIPTION,
	T.CATEGORY,
	T.DISPLAY_GROUP,
	T.IMAGE_COUNT,
	T.LOOK_COUNT,
	T.PERSONALIZABLE,
	T.PRODUCT_LINE,
	T.TAX_PRODUCT_CODE,
	T.UPGRADE_TYPE,
	T.SOURCE_SYSTEM_OID
	,             T.ODS_CREATE_DATE,
	T.ODS_MODIFY_DATE
	)
values
	(
	S.STOCK_KEEPING_UNIT_OID,
	S.SKU_CODE,
	S.NAME,
	S.DESCRIPTION,
	S.CATEGORY,
	S.DISPLAY_GROUP,
	S.IMAGE_COUNT,
	S.LOOK_COUNT,
	S.PERSONALIZABLE,
	S.PRODUCT_LINE,
	S.TAX_PRODUCT_CODE,
	S.UPGRADE_TYPE,
	S.SOURCE_SYSTEM_OID
	,             SYSDATE,
	SYSDATE
	)

& /*-----------------------------------------------*/
/* TASK No. 25 */
/* Commit transaction */
/*commit*/
/*-----------------------------------------------*/
/* TASK No. 26 */
/* Drop flow table */


 /* drop table RAX_APP_USER.I$_STOCK_KEEPING_UNIT */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_STOCK_KEEPING_UNIT';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/
/* TASK No. 1000018 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0STOCK_KEEPING_UNIT */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STOCK_KEEPING_UNIT';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/





&