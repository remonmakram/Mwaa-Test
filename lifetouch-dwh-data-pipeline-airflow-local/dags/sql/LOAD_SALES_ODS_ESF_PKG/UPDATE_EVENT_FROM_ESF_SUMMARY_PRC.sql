/* TASK No. 1 */
/* CREATE TABLE ODS_APP_USER.EVENT_ESF_DRIVER */

-- CREATE TABLE RAX_APP_USER.EVENT_ESF_DRIVER
-- (
--   EVENT_REF_ID               VARCHAR2(40 BYTE) NOT NULL
-- )

BEGIN
   EXECUTE IMMEDIATE 'CREATE TABLE RAX_APP_USER.EVENT_ESF_DRIVER
(
  EVENT_REF_ID               VARCHAR2(40 BYTE) NOT NULL
)';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -955 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 2 */
/* CREATE UNIQUE INDEX ODS_APP_USER.EVENT_ESF_DRIVER_IDX */

-- CREATE UNIQUE INDEX RAX_APP_USER.EVENT_ESF_DRIVER_IDX ON RAX_APP_USER.EVENT_ESF_DRIVER
-- (EVENT_REF_ID)

BEGIN
   EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX RAX_APP_USER.EVENT_ESF_DRIVER_IDX ON RAX_APP_USER.EVENT_ESF_DRIVER
(EVENT_REF_ID)';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE!= -955 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* truncate table ODS_APP_USER.EVENT_ESF_DRIVER */

truncate table RAX_APP_USER.EVENT_ESF_DRIVER

&
/*-----------------------------------------------*/
/* Added and Confirmed by Steve */

BEGIN
   EXECUTE IMMEDIATE 'CREATE TABLE RAX_APP_USER.TMP_AUDIT_EVENT_UPDATE (
	CDC_LOAD_DATE TIMESTAMP NULL,
	DW_CREATE_DATE TIMESTAMP NULL
)';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE!= -955 THEN
         RAISE;
      END IF;
END;

&

/*-----------------------------------------------*/
/* TASK No. 4 */
/* insert audit date for validation */

insert into RAX_APP_USER.TMP_AUDIT_EVENT_UPDATE
(cdc_load_date 
,dw_create_date
)
select TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') 
,sysdate
from dual

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* CDC for STG_SODS_ESF */

insert into RAX_APP_USER.EVENT_ESF_DRIVER (
select distinct ssf.EVENT_REF_ID from RAX_APP_USER.STG_SODS_ESF ssf,ODS_OWN.Event e,ODS_OWN.APO a
where (1=1) and 
ssf.Event_Ref_id = e.Event_Ref_id and
e.APO_OID = a.APO_OID
and ssf.ODS_MODIFY_DATE  >= TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - 1
and ssf.EVENT_REF_ID is not null
and a.Financial_Processing_System='Spectrum'
)

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* merge into  ODS_OWN.EVENT */

merge into  ODS_OWN.EVENT T
using
    (select 
        esf.*
    from
        (select 
            sesf.EVENT_REF_ID 
            ,sum(sesf.TRANSACTION_AMOUNT) TRANSACTION_AMT
            ,sum(case when nvl(sesf.SHIP_DATE,to_date('19000101','YYYYMMDD')) <> to_date('19000101','YYYYMMDD') then sesf.TRANSACTION_AMOUNT else 0 end)  RECOGNIZED_REVENUE_AMT
            ,sum(sesf.PERFECT_ORDER_SALES_AMT) PERFECT_ORDER_SALES_AMT
            ,sum(case when nvl(sesf.SHIP_DATE,to_date('19000101','YYYYMMDD')) <> to_date('19000101','YYYYMMDD') then sesf.PERFECT_ORDER_SALES_AMT else 0 end) SHIPPED_SALES_AMT
            ,sum(sesf.ACCT_CMSN_PAID_AMT) ACCOUNT_COMMISSION_AMT
            ,sum(sesf.TERRITORY_CMSN_AMT) TERRITORY_COMMISSION_AMT
            ,sum(sesf.TERRITORY_CHARGEBACK_AMT) CHARGEBACK_AMT
            ,sum(sesf.PAID_ORDER_QTY) PAID_ORDER_QTY
            ,sum(sesf.UNPAID_ORDER_QTY) UNPAID_ORDER_QTY
            ,sum(sesf.X_NO_PURCHASE_QTY) X_NO_PURCHASE_QTY
            ,sum(case when nvl(sesf.SHIP_DATE,to_date('19000101','YYYYMMDD')) <> to_date('19000101','YYYYMMDD') then sesf.PAID_ORDER_QTY + sesf.UNPAID_ORDER_QTY  else 0 end) SHIPPED_ORDER_QTY
        from 
            RAX_APP_USER.STG_SODS_ESF sesf
           ,RAX_APP_USER.EVENT_ESF_DRIVER d
        where sesf.event_ref_id = d.event_ref_id
        group by 
            sesf.EVENT_REF_ID   
        ) esf
    where (1=1)
        and not exists (select 1 from ODS_OWN.EVENT T where  
               esf.EVENT_REF_ID = T.EVENT_REF_ID and
               ((T.TRANSACTION_AMT = esf.TRANSACTION_AMT) or (T.TRANSACTION_AMT IS NULL and esf.TRANSACTION_AMT IS NULL)) and
               ((T.RECOGNIZED_REVENUE_AMT = esf.RECOGNIZED_REVENUE_AMT) or (T.RECOGNIZED_REVENUE_AMT IS NULL and esf.RECOGNIZED_REVENUE_AMT IS NULL)) and
               ((T.PERFECT_ORDER_SALES_AMT = esf.PERFECT_ORDER_SALES_AMT) or (T.PERFECT_ORDER_SALES_AMT IS NULL and esf.PERFECT_ORDER_SALES_AMT IS NULL)) and
               ((T.SHIPPED_SALES_AMT = esf.SHIPPED_SALES_AMT) or (T.SHIPPED_SALES_AMT IS NULL and esf.SHIPPED_SALES_AMT IS NULL)) and
               ((T.ACCOUNT_COMMISSION_AMT = esf.ACCOUNT_COMMISSION_AMT) or (T.ACCOUNT_COMMISSION_AMT IS NULL and esf.ACCOUNT_COMMISSION_AMT IS NULL)) and
               ((T.TERRITORY_COMMISSION_AMT = esf.TERRITORY_COMMISSION_AMT) or (T.TERRITORY_COMMISSION_AMT IS NULL and esf.TERRITORY_COMMISSION_AMT IS NULL)) and
               ((T.CHARGEBACK_AMT = esf.CHARGEBACK_AMT) or (T.CHARGEBACK_AMT IS NULL and esf.CHARGEBACK_AMT IS NULL)) and
               ((T.PAID_ORDER_QTY = esf.PAID_ORDER_QTY) or (T.PAID_ORDER_QTY IS NULL and esf.PAID_ORDER_QTY IS NULL)) and
               ((T.UNPAID_ORDER_QTY = esf.UNPAID_ORDER_QTY) or (T.UNPAID_ORDER_QTY IS NULL and esf.UNPAID_ORDER_QTY IS NULL)) and
               ((T.X_NO_PURCHASE_QTY = esf.X_NO_PURCHASE_QTY) or (T.X_NO_PURCHASE_QTY IS NULL and esf.X_NO_PURCHASE_QTY IS NULL)) and
               ((T.SHIPPED_ORDER_QTY = esf.SHIPPED_ORDER_QTY) or (T.SHIPPED_ORDER_QTY IS NULL and esf.SHIPPED_ORDER_QTY IS NULL))
               )
     ) S
on    (
        T.EVENT_REF_ID=S.EVENT_REF_ID 
    )
when matched
then update set
    T.TRANSACTION_AMT = S.TRANSACTION_AMT
    ,T.RECOGNIZED_REVENUE_AMT = S.RECOGNIZED_REVENUE_AMT
    ,T.PERFECT_ORDER_SALES_AMT = S.PERFECT_ORDER_SALES_AMT
    ,T.SHIPPED_SALES_AMT = S.SHIPPED_SALES_AMT
    ,T.ACCOUNT_COMMISSION_AMT = S.ACCOUNT_COMMISSION_AMT
    ,T.TERRITORY_COMMISSION_AMT = S.TERRITORY_COMMISSION_AMT
    ,T.CHARGEBACK_AMT = S.CHARGEBACK_AMT
    ,T.PAID_ORDER_QTY = S.PAID_ORDER_QTY
    ,T.UNPAID_ORDER_QTY = S.UNPAID_ORDER_QTY
    ,T.X_NO_PURCHASE_QTY = S.X_NO_PURCHASE_QTY
    ,T.SHIPPED_ORDER_QTY = S.SHIPPED_ORDER_QTY
    ,T.ODS_MODIFY_DATE = SYSDATE


&


/*-----------------------------------------------*/

