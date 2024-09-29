/* TASK No. 1 */
/* Drop work table */
/*-----------------------------------------------*/
/* TASK No. 2 */
/* Create work table */
/*-----------------------------------------------*/
/* TASK No. 3 */
/* Load data */
/* SOURCE CODE */
/* drop table RAX_APP_USER.C$_0STG_PRICE_SET_SKU */
/* create table RAX_APP_USER.C$_0STG_PRICE_SET_SKU
(
	C1_CHANNEL	VARCHAR2(20) NULL,
	C2_AMOUNT	NUMBER(10,2) NULL,
	C3_PRICE_SET_ID	NUMBER(19) NULL,
	C4_PRODUCT_CODE	VARCHAR2(10) NULL,
	C5_PRICE_SET_SKU_ID	NUMBER(19) NULL,
	C6_STOCK_KEEPING_UNIT_ID	NUMBER(19) NULL
)
NOLOGGING */
/* select	
	PRICE_SET_SKU.CHANNEL	   C1_CHANNEL,
	PRICE_SET_SKU.AMOUNT	   C2_AMOUNT,
	PRICE_SET_SKU.PRICE_SET_ID	   C3_PRICE_SET_ID,
	PRICE_SET_SKU.PRODUCT_CODE	   C4_PRODUCT_CODE,
	PRICE_SET_SKU.PRICE_SET_SKU_ID	   C5_PRICE_SET_SKU_ID,
	PRICE_SET_SKU.STOCK_KEEPING_UNIT_ID	   C6_STOCK_KEEPING_UNIT_ID
from	PS_OWN.PRICE_SET_SKU   PRICE_SET_SKU
where	(1=1) */
/* insert into RAX_APP_USER.C$_0STG_PRICE_SET_SKU
(
	C1_CHANNEL,
	C2_AMOUNT,
	C3_PRICE_SET_ID,
	C4_PRODUCT_CODE,
	C5_PRICE_SET_SKU_ID,
	C6_STOCK_KEEPING_UNIT_ID
)
values
(
	:C1_CHANNEL,
	:C2_AMOUNT,
	:C3_PRICE_SET_ID,
	:C4_PRODUCT_CODE,
	:C5_PRICE_SET_SKU_ID,
	:C6_STOCK_KEEPING_UNIT_ID
) */
/* TARGET CODE */
/*-----------------------------------------------*/
/* TASK No. 4 */
/* Analyze work table */



BEGIN
DBMS_STATS.GATHER_TABLE_STATS (
    ownname =>	'RAX_APP_USER',
    tabname =>	'C$_0STG_PRICE_SET_SKU',
    estimate_percent =>	DBMS_STATS.AUTO_SAMPLE_SIZE
);
END;

& /*-----------------------------------------------*/
/* TASK No. 6 */
/* Create target table  */



-- create table RAX_APP_USER.STG_PRICE_SET_SKU
-- (
-- 	CHANNEL	VARCHAR2(20) NULL,
-- 	AMOUNT	NUMBER(10,2) NULL,
-- 	PRICE_SET_ID	NUMBER(19) NULL,
-- 	PRODUCT_CODE	VARCHAR2(10) NULL,
-- 	PRICE_SET_SKU_ID	NUMBER(19) NULL,
-- 	STOCK_KEEPING_UNIT_ID	NUMBER(19) NULL
-- )

BEGIN
    EXECUTE IMMEDIATE 'create table RAX_APP_USER.STG_PRICE_SET_SKU
(
	CHANNEL	VARCHAR2(20) NULL,
	AMOUNT	NUMBER(10,2) NULL,
	PRICE_SET_ID	NUMBER(19) NULL,
	PRODUCT_CODE	VARCHAR2(10) NULL,
	PRICE_SET_SKU_ID	NUMBER(19) NULL,
	STOCK_KEEPING_UNIT_ID	NUMBER(19) NULL
)';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -955 THEN
            RAISE;
        END IF;
    END;

& /*-----------------------------------------------*/
/* TASK No. 7 */
/* Truncate target table */



truncate table RAX_APP_USER.STG_PRICE_SET_SKU

& /*-----------------------------------------------*/
/* TASK No. 8 */
/* Insert new rows */



insert into	RAX_APP_USER.STG_PRICE_SET_SKU 
( 
	CHANNEL,
	AMOUNT,
	PRICE_SET_ID,
	PRODUCT_CODE,
	PRICE_SET_SKU_ID,
	STOCK_KEEPING_UNIT_ID 
	 
) 

select
    CHANNEL,
	AMOUNT,
	PRICE_SET_ID,
	PRODUCT_CODE,
	PRICE_SET_SKU_ID,
	STOCK_KEEPING_UNIT_ID   
   
FROM (	


select 	
	C1_CHANNEL CHANNEL,
	C2_AMOUNT AMOUNT,
	C3_PRICE_SET_ID PRICE_SET_ID,
	C4_PRODUCT_CODE PRODUCT_CODE,
	C5_PRICE_SET_SKU_ID PRICE_SET_SKU_ID,
	C6_STOCK_KEEPING_UNIT_ID STOCK_KEEPING_UNIT_ID 
from	RAX_APP_USER.C$_0STG_PRICE_SET_SKU
where		(1=1)	






)    ODI_GET_FROM

& /*-----------------------------------------------*/
/* TASK No. 9 */
/* Commit transaction */
/* commit */
/*-----------------------------------------------*/
/* TASK No. 1000005 */
/* Drop work table */


 /* drop table RAX_APP_USER.C$_0STG_PRICE_SET_SKU */ 


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0STG_PRICE_SET_SKU';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

& /*-----------------------------------------------*/





&