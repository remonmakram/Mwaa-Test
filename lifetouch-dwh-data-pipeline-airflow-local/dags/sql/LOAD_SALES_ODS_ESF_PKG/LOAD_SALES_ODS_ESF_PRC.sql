/* TASK No. 1 */
/* CREATE TABLE ODS_APP_USER.STG_SODS_ESF */

-- CREATE TABLE RAX_APP_USER.STG_SODS_ESF
-- (
--   EVENT_REF_ID             VARCHAR2(40 BYTE) NOT NULL,
--   SHIP_DATE                DATE NOT NULL,
--   PAID_ORDER_QTY           NUMBER,
--   CALCULATED_PAID_ORDER_QTY           NUMBER,
--   PERFECT_ORDER_SALES_AMT  NUMBER,
--   SHIPPED_ORDER_QTY        NUMBER,
--   UNPAID_ORDER_QTY         NUMBER,
--   X_NO_PURCHASE_QTY        NUMBER,
--   TRANSACTION_AMOUNT        NUMBER, 
--   ACCT_CMSN_PAID_AMT        NUMBER,
--   ORDER_SALES_AMT        NUMBER,
--   ORDER_SALES_TAX_AMT        NUMBER,
--   TERRITORY_CMSN_AMT        NUMBER,
--   TERRITORY_CHARGEBACK_AMT        NUMBER,
--   IMAGE_QTY        NUMBER,
--   PROOF_QTY        NUMBER,
--   ODS_CREATE_DATE          DATE,
--   ODS_MODIFY_DATE          DATE,
--   CAPTURE_SESSION_QTY        NUMBER,
--   STAFF_CAPTURE_SESSION_QTY        NUMBER,
--   CLICK_QTY                  NUMBER,
--   EST_ACCT_CMSN_AMT          NUMBER,
--   TOT_EST_ACCT_CMSN_AMT      NUMBER
-- )
-- LOGGING 
-- NOCOMPRESS 
-- NOCACHE
-- NOPARALLEL
-- MONITORING

BEGIN
   EXECUTE IMMEDIATE 'CREATE TABLE RAX_APP_USER.STG_SODS_ESF
(
  EVENT_REF_ID             VARCHAR2(40 BYTE) NOT NULL,
  SHIP_DATE                DATE NOT NULL,
  PAID_ORDER_QTY           NUMBER,
  CALCULATED_PAID_ORDER_QTY           NUMBER,
  PERFECT_ORDER_SALES_AMT  NUMBER,
  SHIPPED_ORDER_QTY        NUMBER,
  UNPAID_ORDER_QTY         NUMBER,
  X_NO_PURCHASE_QTY        NUMBER,
  TRANSACTION_AMOUNT        NUMBER, 
  ACCT_CMSN_PAID_AMT        NUMBER,
  ORDER_SALES_AMT        NUMBER,
  ORDER_SALES_TAX_AMT        NUMBER,
  TERRITORY_CMSN_AMT        NUMBER,
  TERRITORY_CHARGEBACK_AMT        NUMBER,
  IMAGE_QTY        NUMBER,
  PROOF_QTY        NUMBER,
  ODS_CREATE_DATE          DATE,
  ODS_MODIFY_DATE          DATE,
  CAPTURE_SESSION_QTY        NUMBER,
  STAFF_CAPTURE_SESSION_QTY        NUMBER,
  CLICK_QTY                  NUMBER,
  EST_ACCT_CMSN_AMT          NUMBER,
  TOT_EST_ACCT_CMSN_AMT      NUMBER
)
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -955 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 2 */
/* CREATE UNIQUE INDEX on ODS_APP_USER.STG_SODS_ESF */

-- CREATE UNIQUE INDEX STG_SODS_ESF_IX0 ON RAX_APP_USER.STG_SODS_ESF
-- (EVENT_REF_ID, SHIP_DATE)
-- LOGGING
-- NOPARALLEL

BEGIN
   EXECUTE IMMEDIATE 'CREATE UNIQUE INDEX STG_SODS_ESF_IX0 ON RAX_APP_USER.STG_SODS_ESF
(EVENT_REF_ID, SHIP_DATE)
LOGGING
NOPARALLEL';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE!= -955 THEN
         RAISE;
      END IF;
END;


&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* CREATE MODIFY_DATE INDEX  ON ODS_APP_USER.STG_SODS_ESF */

-- CREATE INDEX STG_SODS_ESF_IX9 ON RAX_APP_USER.STG_SODS_ESF
-- (ODS_MODIFY_DATE)
-- LOGGING
-- NOPARALLEL

BEGIN
   EXECUTE IMMEDIATE 'CREATE INDEX STG_SODS_ESF_IX9 ON RAX_APP_USER.STG_SODS_ESF
(ODS_MODIFY_DATE)
LOGGING
NOPARALLEL';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -972 AND SQLCODE != -1418 AND SQLCODE != -1408 AND SQLCODE!= -955 THEN
         RAISE;
      END IF;
END;
&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* Drop driver table */

-- DROP TABLE RAX_APP_USER.STG_SODS_ESF_DRIVER 
BEGIN  
   EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.STG_SODS_ESF_DRIVER';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;  


&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* CREATE driver table */

CREATE TABLE RAX_APP_USER.STG_SODS_ESF_DRIVER (EVENT_REF_ID  VARCHAR2(40) NOT NULL)


&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* CREATE UNIQUE INDEX */

CREATE UNIQUE INDEX event_ref_id_idx ON RAX_APP_USER.STG_SODS_ESF_DRIVER
(event_ref_id)
LOGGING
NOPARALLEL


&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* CDC for EVENT */


insert into RAX_APP_USER.STG_SODS_ESF_DRIVER (
    select e.EVENT_REF_ID from ods_own.event e
    where (1=1) 
      and e.school_year >= (select T.FISCAL_YEAR -1 from mart.time t where T.DATE_KEY = trunc(sysdate)) 
      and e.ODS_MODIFY_DATE  > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_sales_ods_overlap
      and e.EVENT_REF_ID is not null
      and not exists (select 1 from RAX_APP_USER.STG_SODS_ESF_DRIVER z where e.EVENT_REF_ID = z.EVENT_REF_ID) 
   group by e.EVENT_REF_ID
)



&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* CDC for ORDER_HEADER */

insert into RAX_APP_USER.STG_SODS_ESF_DRIVER (
    select oh.EVENT_REF_ID from ods_own.order_header oh,ods_own.event e 
    where (1=1) and oh.order_type <> 'Account_Order' 
    and oh.ODS_MODIFY_DATE  > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_sales_ods_overlap
    and oh.EVENT_OID = e.EVENT_OID
    and e.school_year >= (select T.FISCAL_YEAR -1 from mart.time t where T.DATE_KEY = trunc(sysdate)) 
    and not exists (select 1 from RAX_APP_USER.STG_SODS_ESF_DRIVER z where oh.EVENT_REF_ID = z.EVENT_REF_ID)
    group by oh.EVENT_REF_ID 
)

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* CDC for EVENT_PAYMENT */

insert into RAX_APP_USER.STG_SODS_ESF_DRIVER (
    select ep.EVENT_REF_ID from 
    ods_own.EVENT_PAYMENT  ep,ods_own.event e
    where (1=1) 
    and ep.EVENT_OID = e.EVENT_OID
    and e.school_year >= (select T.FISCAL_YEAR -1 from mart.time t where T.DATE_KEY = trunc(sysdate)) 
    and EP.ODS_MODIFY_DATE  > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_sales_ods_overlap
    and not exists (select 1 from RAX_APP_USER.STG_SODS_ESF_DRIVER z where ep.EVENT_REF_ID = z.EVENT_REF_ID)
    group by ep.EVENT_REF_ID 
) 

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* CDC for EVENT_ADJUSTMENT */

-- Adjustments will use the same driver table as Event Account Commission
insert into RAX_APP_USER.STG_SODS_ESF_DRIVER (
   select ea.EVENT_REF_ID from 
    ods_own.EVENT_ADJUSTMENT  ea,ods_own.event e
    where (1=1) 
    and EA.EVENT_OID = e.EVENT_OID
    and e.school_year >= (select T.FISCAL_YEAR -1 from mart.time t where T.DATE_KEY = trunc(sysdate)) 
    and EA.ODS_MODIFY_DATE  > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_sales_ods_overlap
    and not exists (select 1 from RAX_APP_USER.STG_SODS_ESF_DRIVER z where ea.EVENT_REF_ID = z.EVENT_REF_ID)
    group by ea.EVENT_REF_ID 
) 

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* CDC for SALES_RECOGNITION */

insert into RAX_APP_USER.STG_SODS_ESF_DRIVER (
    select sr.EVENT_REF_ID from 
	ods_own.SALES_RECOGNITION  sr,ods_own.event e
    where (1=1) 
    and SR.EVENT_OID = e.EVENT_OID
    and e.school_year >= (select T.FISCAL_YEAR -1 from mart.time t where T.DATE_KEY = trunc(sysdate)) 
    and sr.ODS_MODIFY_DATE  > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_sales_ods_overlap
    and not exists (select 1 from RAX_APP_USER.STG_SODS_ESF_DRIVER z where sr.EVENT_REF_ID = z.EVENT_REF_ID)
    group by sr.EVENT_REF_ID 
) 

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* CDC for CHARGEBACK_FACT */

insert into RAX_APP_USER.STG_SODS_ESF_DRIVER (
    select cf.EVENT_REF_ID from 
    ods_own.CHARGEBACK_FACT  cf,ods_own.event e
    where (1=1) 
    and cf.CHARGEBACK_AMOUNT <> 0
    and cf.ODS_MODIFY_DATE  >= TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_sales_ods_overlap
/*    and cf.TRANS_DATE  >= trunc(TO_DATE(SUBSTR('#WAREHOUSE_PROJECT.v_cdc_load_date',1,19),'YYYY-MM-DD HH24:MI:SS') - #WAREHOUSE_PROJECT.v_cdc_sales_ods_overlap)
*/
    and cf.EVENT_OID = e.EVENT_OID
    and e.school_year >= (select T.FISCAL_YEAR -1 from mart.time t where T.DATE_KEY = trunc(sysdate)) 
    and not exists (select 1 from RAX_APP_USER.STG_SODS_ESF_DRIVER z where cf.EVENT_REF_ID = z.EVENT_REF_ID)
    group by cf.EVENT_REF_ID 
) 


&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* CDC for EVENT_ACCOUNT_COMMISSION */

-- EAC will use the same driver table as Event Adjustments
insert into RAX_APP_USER.STG_SODS_ESF_DRIVER (
    select eac.EVENT_REF_ID from 
	ods_stage.SRM_EVENT_ACCOUNT_CMMSSION_STG eac,ods_own.event e
    where (1=1) 
    and eac.EVENT_OID = e.EVENT_OID
    and e.school_year >= (select T.FISCAL_YEAR -1 from mart.time t where T.DATE_KEY = trunc(sysdate)) 
    and eac.LAST_UPDATED  > TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_sales_ods_overlap
    and not exists (select 1 from RAX_APP_USER.STG_SODS_ESF_DRIVER z where eac.EVENT_REF_ID = z.EVENT_REF_ID)
    group by eac.EVENT_REF_ID 
) 

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* merge into    ODS_APP_USER.STG_SODS_ESF */

--  Modifications:
--      03/10/2014  Dady    SODS-181
--                  Account commission estimate and total estimate now pulled from ACM
--
--      05/13/2014 JTP   EVENT_ADJUSTMENT.CHARGEBACK_AMOUNT goes through CHARGEBACK_FACT now
--
--     06/02/2014 kdady SODS-255
--                  Separate out driver tables
--     06/05/2014 kdady SODS-250
--                  Change source of Account Commission Paid
--                  Add post-merge update statement to zero out 'old' actual account commission ship date records.
--
--    07/25/2014  kdady  SODS-255
--                  Backout seperate driver table change
--                  Will need to re-visit (need seperate Merge statement for each driver table
--    09/14/2015  jtenpas
--                  change sr.payment_amount to sr.RECOGNITION_AMOUNT
--
--    02/23/2016  jtenpas
--                  change order_types to order_bucket
--
--   BEGIN
      MERGE INTO RAX_APP_USER.STG_SODS_ESF t
         USING (SELECT a.*
                  FROM (SELECT   aa.event_ref_id, TRUNC (aa.ship_date) ship_date, SUM (aa.paid_order_qty) paid_order_qty,
                                 SUM (aa.perfect_order_sales_amt) perfect_order_sales_amt, SUM (aa.shipped_order_qty) shipped_order_qty,
                                 SUM (aa.unpaid_order_qty) unpaid_order_qty, SUM (aa.x_no_purchase_qty) x_no_purchase_qty,
                                 SUM (aa.transaction_amount) transaction_amount, SUM (aa.acct_cmsn_paid_amt) AS acct_cmsn_paid_amt,
                                 SUM (aa.order_sales_amt) order_sales_amt, SUM (aa.order_sales_tax_amt) order_sales_tax_amt,
                                 SUM (aa.territory_cmsn_amt) territory_cmsn_amt, SUM (aa.chargeback_amount) territory_chargeback_amt, 0 image_qty, 0 proof_qty,
                                 SUM (aa.est_acct_cmsn_amt) est_acct_cmsn_amt, SUM (aa.tot_est_acct_cmsn_amt) tot_est_acct_cmsn_amt,
                                 CASE
                                    WHEN TRUNC (aa.ship_date) = TO_DATE ('19000101', 'YYYYMMDD')
                                       THEN MIN (NVL (e.capture_session_qty, 0))
                                    ELSE 0
                                 END AS capture_session_qty,
                                 CASE
                                    WHEN TRUNC (aa.ship_date) = TO_DATE ('19000101', 'YYYYMMDD')
                                       THEN MIN (NVL (e.staff_qty, 0))
                                    ELSE 0
                                 END AS staff_capture_session_qty,
                                 CASE
                                    WHEN TRUNC (aa.ship_date) = TO_DATE ('19000101', 'YYYYMMDD')
                                       THEN MIN (NVL (e.click_qty, 0))
                                    ELSE 0
                                 END AS click_qty
                            --select AA.*
                        FROM     (SELECT   ohi.event_ref_id, NVL (TRUNC (ohi.order_ship_date), TO_DATE ('19000101', 'YYYYMMDD')) AS ship_date,
                                           COUNT (CASE
                                                     WHEN ohi.order_bucket IN ('PAID')
                                                        THEN ohi.order_header_oid
                                                     ELSE NULL
                                                  END) AS paid_order_qty,
                                           SUM (ohi.total_amount) AS perfect_order_sales_amt,
                                           COUNT (CASE
                                                     WHEN ohi.order_bucket IN ('PAID','UNPAID') AND ohi.order_ship_date <> TO_DATE ('19000101', 'YYYYMMDD')
                                                        THEN ohi.order_header_oid
                                                     ELSE NULL
                                                  END
                                                 ) AS shipped_order_qty,
                                           COUNT (CASE
                                                     WHEN ohi.order_bucket IN ('UNPAID')
                                                        THEN ohi.order_header_oid
                                                     ELSE NULL
                                                  END
                                                 ) AS unpaid_order_qty,
                                           COUNT (CASE
                                                     WHEN ohi.order_bucket IN ('X')
                                                        THEN ohi.order_header_oid
                                                     ELSE NULL
                                                  END
                                                 ) AS x_no_purchase_qty,
                                           CASE
                                              WHEN NVL (TRUNC (ohi.order_ship_date), TO_DATE ('19000101', 'YYYYMMDD')) =
                                                                                                            TO_DATE ('19000101', 'YYYYMMDD')
                                                 THEN NVL (pay.transaction_amount, 0)
                                              ELSE 0
                                           END transaction_amount,
                                           0 acct_cmsn_paid_amt, 0 order_sales_amt, 0 order_sales_tax_amt, 0 territory_cmsn_amt, 0 chargeback_amount,
                                           0 est_acct_cmsn_amt, 0 tot_est_acct_cmsn_amt
                                      FROM (SELECT   oh.event_ref_id, oh.order_header_oid, oh.order_bucket, oh.total_amount, oh.order_ship_date,
                                                     SUM (ol.ordered_quantity) AS ordered_quantity
                                                FROM ods_own.order_header oh, ods_own.order_line ol, RAX_APP_USER.STG_SODS_ESF_DRIVER d
                                               WHERE (1 = 1)
                                                 AND oh.order_header_oid = ol.order_header_oid
                                                 -- SODS-288
                                                 AND nvl(oh.order_bucket,'UNKNOWN') NOT IN ('CANCELLED','SERVICE','UNKNOWN')
                                                 /* do not count account orders at all */
                                                 AND oh.event_ref_id = d.event_ref_id
                                            GROUP BY oh.event_ref_id, oh.order_header_oid, oh.order_bucket, oh.total_amount, oh.order_ship_date
                                            UNION
                                            /* Special Case for 1/1/1900 -> 0 */
                                            SELECT   d.event_ref_id, NULL, NULL, 0, TO_DATE ('19000101', 'YYYYMMDD'), 0
                                                FROM RAX_APP_USER.STG_SODS_ESF_DRIVER d
                                               WHERE (1 = 1)
                                            GROUP BY d.event_ref_id, NULL, NULL, 0, TO_DATE ('19000101', 'YYYYMMDD')) ohi,
                                           (SELECT pay1.event_ref_id, pay1.payment_date ship_date,
                                                   pay1.transaction_amount - NVL (rec.RECOGNITION_AMOUNT, 0) transaction_amount
                                              FROM (SELECT   ep.event_ref_id, TO_DATE ('19000101', 'YYYYMMDD') payment_date,
                                                             SUM (ep.payment_amount) transaction_amount
                                                        FROM ods_own.event_payment ep,
                                                                                      -- event payment driver
                                                                                      RAX_APP_USER.STG_SODS_ESF_DRIVER d
                                                       WHERE (1 = 1) AND ep.event_ref_id = d.event_ref_id
                                                    GROUP BY ep.event_ref_id, TO_DATE ('19000101', 'YYYYMMDD')) pay1,
                                                   (SELECT   sr.event_ref_id, SUM (sr.RECOGNITION_AMOUNT) RECOGNITION_AMOUNT
                                                        FROM ods_own.sales_recognition sr, RAX_APP_USER.STG_SODS_ESF_DRIVER d
                                                       WHERE (1 = 1) AND sr.event_ref_id = d.event_ref_id
                                                    GROUP BY sr.event_ref_id) rec
                                             WHERE pay1.event_ref_id = rec.event_ref_id(+)) pay
                                     WHERE (1 = 1) AND ohi.event_ref_id = pay.event_ref_id(+)
                                  GROUP BY ohi.event_ref_id,
                                           NVL (TRUNC (ohi.order_ship_date), TO_DATE ('19000101', 'YYYYMMDD')),
                                           CASE
                                              WHEN NVL (TRUNC (ohi.order_ship_date), TO_DATE ('19000101', 'YYYYMMDD')) = TO_DATE ('19000101', 'YYYYMMDD')
                                                 THEN NVL (pay.transaction_amount, 0)
                                              ELSE 0
                                           END
                                  UNION
                                  --
                                  -- Account Commission EST and Total EST
                                  --
                                  SELECT e2.event_ref_id, NVL (e2.ship_date, TO_DATE ('01011900', 'MMDDYYYY')), 0 paid_order_qty, 0 perfect_order_sales_amt,
                                         0 shipped_order_qty, 0 unpaid_order_qty, 0 x_no_purchase_qty, 0 transaction_amount, 0 acct_cmsn_paid_amt,
                                         0 order_sales_amt, 0 order_sales_tax_amt, 0 territory_cmsn_amt, 0 chargeback_amount, e2.est_acct_cmsn_amt,
                                         e2.tot_est_acct_cmsn_amt
                                    FROM (SELECT e3.event_ref_id, e3.ship_date, e3.est_acct_cmsn_amt, e3.tot_est_acct_cmsn_amt
                                            FROM ods_own.event e3, RAX_APP_USER.STG_SODS_ESF_DRIVER d
                                           WHERE e3.event_ref_id = d.event_ref_id) e2
                                  UNION
                                  --
                                  -- Actual Account Commission
                                  -- (SODS-250)
                                  -- If Event shipdate is not 1/1/1900, use that date
                                  -- Else use create date from event_account_commission
                                  SELECT e.event_ref_id,
                                         (CASE
                                             WHEN e.ship_date != TO_DATE ('01011900', 'MMDDYYYY')
                                                THEN e.ship_date
                                             WHEN eac.ship_date IS NOT NULL
                                                THEN eac.ship_date
                                             ELSE adj.ship_date
                                          END
                                         ) AS ship_date,
                                         0 paid_order_qty, 0 perfect_order_sales_amt, 0 shipped_order_qty, 0 unpaid_order_qty, 0 x_no_purchase_qty,
                                         0 transaction_amount, NVL (eac_acct_comm, 0) + NVL (adj, 0) acct_cmsn_paid_amt, 0 order_sales_amt,
                                         0 order_sales_tax_amt, 0 territory_cmsn_amt, 0 chargeback_amount, 0 est_acct_cmsn_amt, 0 tot_est_acct_cmsn_amt
                                    FROM (SELECT   eac.event_ref_id, MAX (TRUNC (date_created)) AS ship_date,
                                                   SUM (actual_account_commission) + SUM (normal_apo_account_commission) AS eac_acct_comm
                                              FROM ods_stage.srm_event_account_cmmssion_stg eac, RAX_APP_USER.STG_SODS_ESF_DRIVER d
                                             WHERE eac.event_ref_id = d.event_ref_id
                                          GROUP BY eac.event_ref_id) eac,
                                         (SELECT   ea.event_ref_id, MAX (TRUNC (ods_create_date)) AS ship_date, SUM (ea.account_commission_amount) adj
                                              FROM ods_own.event_adjustment ea, RAX_APP_USER.STG_SODS_ESF_DRIVER d
                                             WHERE ea.event_ref_id = d.event_ref_id
                                          GROUP BY ea.event_ref_id) adj,
                                         (SELECT e.event_ref_id, TRUNC (NVL (ship_date, TO_DATE ('01011900', 'MMDDYYYY'))) ship_date
                                            FROM ods_own.event e, RAX_APP_USER.STG_SODS_ESF_DRIVER d
                                           WHERE e.event_ref_id = d.event_ref_id) e
                                   WHERE e.event_ref_id = eac.event_ref_id(+)
                                     AND e.event_ref_id = adj.event_ref_id(+)
                                     AND (EXISTS (SELECT 1
                                                    FROM ods_stage.srm_event_account_cmmssion_stg eac2
                                                   WHERE eac2.event_ref_id = e.event_ref_id) OR EXISTS (SELECT 1
                                                                                                          FROM ods_own.event_adjustment ea2
                                                                                                         WHERE ea2.event_ref_id = e.event_ref_id))
                                  UNION
                                  SELECT b.event_ref_id, b.ship_date, 0 paid_order_qty, 0 perfect_order_sales_amt, 0 shipped_order_qty, 0 unpaid_order_qty,
                                         0 x_no_purchase_qty, b.transaction_amount, 0 acct_cmsn_paid_amt,
                                                                                                         -- SODS-250
                                                                                                         -- This statement incorrectly pulls actual account commission value from sales_recognition.
                                                                                                         -- Since order_sales_amt is calculated based on other columns in ESF Summary
                                                                                                         -- Order_sales_amount will be updated in next step of process.
                                                                                                         b.order_sales_amt, b.order_sales_tax_amt,
                                         b.territory_cmsn_amt, 0 chargeback_amount, 0 est_acct_cmsn_amt, 0 tot_est_acct_cmsn_amt
                                    FROM (SELECT   sr.event_ref_id, TRUNC (sr.recognized_date) ship_date, SUM (sr.RECOGNITION_AMOUNT) transaction_amount,
                                                   SUM (sr.account_commission_amount) acct_cmsn_paid_amt,
                                                   SUM (sr.RECOGNITION_AMOUNT) - SUM (sr.sales_tax_amount) - SUM (sr.account_commission_amount) order_sales_amt,
                                                   SUM (sr.sales_tax_amount) order_sales_tax_amt, SUM (sr.territory_commission_amount) territory_cmsn_amt
                                              FROM ods_own.sales_recognition sr, RAX_APP_USER.STG_SODS_ESF_DRIVER d
                                             WHERE (1 = 1) AND sr.event_ref_id = d.event_ref_id
                                          GROUP BY sr.event_ref_id, TRUNC (sr.recognized_date)) b
                                  UNION
                                  SELECT   cf.event_ref_id, TRUNC (cf.trans_date), 0 paid_order_qty, 0 perfect_order_sales_amt, 0 shipped_order_qty,
                                           0 unpaid_order_qty, 0 x_no_purchase_qty, 0 transaction_amount, 0 acct_cmsn_paid_amt, 0 order_sales_amt,
                                           0 order_sales_tax_amt, 0 territory_cmsn_amt, SUM (cf.chargeback_amount) chargeback_amount, 0 est_acct_cmsn_amt,
                                           0 tot_est_acct_cmsn_amt
                                      FROM ods_own.chargeback_fact cf, RAX_APP_USER.STG_SODS_ESF_DRIVER d
                                     WHERE (1 = 1) AND cf.chargeback_amount <> 0 AND cf.event_ref_id = d.event_ref_id
                                  GROUP BY cf.event_ref_id, TRUNC (cf.trans_date)
                                  UNION
                                  SELECT   ea.event_ref_id, TRUNC (ea.recognized_date), 0 paid_order_qty,
                                           SUM (ea.perfect_order_sales_amount) perfect_order_sales_amt, 0 shipped_order_qty, 0 unpaid_order_qty,
                                           0 x_no_purchase_qty, 0 transaction_amount, 0 acct_cmsn_paid_amt,
-- Ignore adj here because SALES_RECOGNITION.ACCOUNT_COMMISSION_AMOUNT handles this adjustment
                                           0 order_sales_amt, 0 order_sales_tax_amt, 0 territory_cmsn_amt,
-- EVENT_ADJUSTMENT.CHARGEBACK_AMOUNT goes through CHARGEBACK_FACT now
                                           0 chargeback_amount, 0 est_acct_cmsn_amt, 0 tot_est_acct_cmsn_amt
                                      FROM ods_own.event_adjustment ea, RAX_APP_USER.STG_SODS_ESF_DRIVER d
                                     WHERE (1 = 1) AND ea.event_ref_id = d.event_ref_id
                                  GROUP BY ea.event_ref_id, TRUNC (ea.recognized_date)) aa,
                                 ods_own.event e
                           WHERE (1 = 1) AND aa.event_ref_id = e.event_ref_id
                        GROUP BY aa.event_ref_id, aa.ship_date) a
                 WHERE (1 = 1)
                   AND NOT EXISTS (
                          SELECT 1
                            FROM RAX_APP_USER.STG_SODS_ESF t
                           WHERE t.event_ref_id = a.event_ref_id
                             AND t.ship_date = a.ship_date
                             AND ((t.paid_order_qty = a.paid_order_qty) OR (t.paid_order_qty IS NULL AND a.paid_order_qty IS NULL))
                             AND (   (t.perfect_order_sales_amt = a.perfect_order_sales_amt)
                                  OR (t.perfect_order_sales_amt IS NULL AND a.perfect_order_sales_amt IS NULL)
                                 )
                             AND ((t.shipped_order_qty = a.shipped_order_qty) OR (t.shipped_order_qty IS NULL AND a.shipped_order_qty IS NULL))
                             AND ((t.unpaid_order_qty = a.unpaid_order_qty) OR (t.unpaid_order_qty IS NULL AND a.unpaid_order_qty IS NULL))
                             AND ((t.x_no_purchase_qty = a.x_no_purchase_qty) OR (t.x_no_purchase_qty IS NULL AND a.x_no_purchase_qty IS NULL))
                             AND ((t.transaction_amount = a.transaction_amount) OR (t.transaction_amount IS NULL AND a.transaction_amount IS NULL))
                             AND ((t.acct_cmsn_paid_amt = a.acct_cmsn_paid_amt) OR (t.acct_cmsn_paid_amt IS NULL AND a.acct_cmsn_paid_amt IS NULL))
                             AND ((t.order_sales_amt = a.order_sales_amt) OR (t.order_sales_amt IS NULL AND a.order_sales_amt IS NULL))
                             AND ((t.order_sales_tax_amt = a.order_sales_tax_amt) OR (t.order_sales_tax_amt IS NULL AND a.order_sales_tax_amt IS NULL))
                             AND ((t.territory_cmsn_amt = a.territory_cmsn_amt) OR (t.territory_cmsn_amt IS NULL AND a.territory_cmsn_amt IS NULL))
                             AND (   (t.territory_chargeback_amt = a.territory_chargeback_amt)
                                  OR (t.territory_chargeback_amt IS NULL AND a.territory_chargeback_amt IS NULL)
                                 )
                             AND ((t.image_qty = a.image_qty) OR (t.image_qty IS NULL AND a.image_qty IS NULL))
                             AND ((t.proof_qty = a.proof_qty) OR (t.proof_qty IS NULL AND a.proof_qty IS NULL))
                             AND ((t.capture_session_qty = a.capture_session_qty) OR (t.capture_session_qty IS NULL AND a.capture_session_qty IS NULL))
                             AND (   (t.staff_capture_session_qty = a.staff_capture_session_qty)
                                  OR (t.staff_capture_session_qty IS NULL AND a.staff_capture_session_qty IS NULL)
                                 )
                             AND ((t.click_qty = a.click_qty) OR (t.click_qty IS NULL AND a.click_qty IS NULL))
                             AND ((t.est_acct_cmsn_amt = a.est_acct_cmsn_amt) OR (t.est_acct_cmsn_amt IS NULL AND a.est_acct_cmsn_amt IS NULL))
                             AND ((t.tot_est_acct_cmsn_amt = a.tot_est_acct_cmsn_amt) OR (t.tot_est_acct_cmsn_amt IS NULL AND a.tot_est_acct_cmsn_amt IS NULL)
                                 ))) s
         ON (t.event_ref_id = s.event_ref_id AND t.ship_date = s.ship_date)
         WHEN NOT MATCHED THEN
            INSERT (event_ref_id, ship_date, paid_order_qty, calculated_paid_order_qty, perfect_order_sales_amt, shipped_order_qty, unpaid_order_qty,
                    x_no_purchase_qty, transaction_amount, acct_cmsn_paid_amt, order_sales_amt, order_sales_tax_amt, territory_cmsn_amt,
                    territory_chargeback_amt, image_qty, proof_qty, ods_create_date, ods_modify_date, capture_session_qty, staff_capture_session_qty, click_qty,
                    est_acct_cmsn_amt, tot_est_acct_cmsn_amt)
            VALUES (s.event_ref_id, s.ship_date, s.paid_order_qty, s.paid_order_qty, s.perfect_order_sales_amt, s.shipped_order_qty, s.unpaid_order_qty,
                    s.x_no_purchase_qty, s.transaction_amount, s.acct_cmsn_paid_amt, s.order_sales_amt, s.order_sales_tax_amt, s.territory_cmsn_amt,
                    s.territory_chargeback_amt, s.image_qty, s.proof_qty, SYSDATE, SYSDATE, s.capture_session_qty, s.staff_capture_session_qty, s.click_qty,
                    s.est_acct_cmsn_amt, s.tot_est_acct_cmsn_amt)
         WHEN MATCHED THEN
            UPDATE
               SET t.paid_order_qty = s.paid_order_qty, t.calculated_paid_order_qty = s.paid_order_qty, t.perfect_order_sales_amt = s.perfect_order_sales_amt,
                   t.shipped_order_qty = s.shipped_order_qty, t.unpaid_order_qty = s.unpaid_order_qty, t.x_no_purchase_qty = s.x_no_purchase_qty,
                   t.transaction_amount = s.transaction_amount, t.acct_cmsn_paid_amt = s.acct_cmsn_paid_amt, t.order_sales_amt = s.order_sales_amt,
                   t.order_sales_tax_amt = s.order_sales_tax_amt, t.territory_cmsn_amt = s.territory_cmsn_amt,
                   t.territory_chargeback_amt = s.territory_chargeback_amt, t.image_qty = s.image_qty, t.proof_qty = s.proof_qty, t.ods_modify_date = SYSDATE,
                   t.capture_session_qty = s.capture_session_qty, t.staff_capture_session_qty = s.staff_capture_session_qty, t.click_qty = s.click_qty,
                   t.est_acct_cmsn_amt = s.est_acct_cmsn_amt, t.tot_est_acct_cmsn_amt = s.tot_est_acct_cmsn_amt
           

/*
move to next step in PROC
--
-- Zero out old actual account commission records
--
      UPDATE RAX_APP_USER.STG_SODS_ESF esf
         SET acct_cmsn_paid_amt = 0,
             order_sales_amt = 0,
             ods_modify_date = SYSDATE
       WHERE TRUNC (ship_date) !=
                (SELECT (CASE
                            WHEN NVL (e.ship_date, TO_DATE ('01011900', 'MMDDYYYY')) != TO_DATE ('01011900', 'MMDDYYYY')
                               THEN TRUNC (e.ship_date)
                            ELSE TRUNC (eac.date_created)
                         END
                        )
                   FROM ods_own.event e, ods_stage.srm_event_account_cmmssion_stg eac
                  WHERE e.event_ref_id = eac.event_ref_id AND e.event_ref_id = esf.event_ref_id)
         AND (acct_cmsn_paid_amt != 0 OR order_sales_amt != 0)
         AND esf.event_ref_id IN (SELECT event_ref_id
                                    FROM RAX_APP_USER.STG_SODS_ESF_DRIVER);
*/

--   END;


&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Zero out old actual account commission records */

merge into RAX_APP_USER.STG_SODS_ESF t using
(select
    esf.EVENT_REF_ID,
    esf.ship_date
    ,esf.acct_cmsn_paid_amt,esf.order_sales_amt
-- select *
from
     RAX_APP_USER.STG_SODS_ESF esf
    ,RAX_APP_USER.STG_SODS_ESF_DRIVER d
    ,(SELECT 
        eac.event_ref_id,
        min((CASE
                WHEN NVL (e.ship_date, TO_DATE ('01011900', 'MMDDYYYY')) <> TO_DATE ('01011900', 'MMDDYYYY') THEN TRUNC (e.ship_date)
                ELSE TRUNC (eac.date_created)
             END
            )) ship_date 
      FROM 
        ods_own.event e
       , ods_stage.srm_event_account_cmmssion_stg eac
      WHERE e.event_ref_id = eac.event_ref_id
      group by
       eac.event_ref_id
    ) eac
WHERE (1=1)
    and esf.event_ref_id = d.event_ref_id
    AND eac.event_ref_id = esf.event_ref_id
    and TRUNC (esf.ship_date) <> trunc(eac.ship_date)
    AND (esf.acct_cmsn_paid_amt <> 0 OR esf.order_sales_amt <> 0)
) s
on (t.EVENT_REF_ID = s.EVENT_REF_ID and t.SHIP_DATE = s.SHIP_DATE)
when matched then update set 
        t.acct_cmsn_paid_amt = 0
        ,t.order_sales_amt = 0
        ,t.ods_modify_date = SYSDATE


&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Set order_sales_amt correctly */

UPDATE RAX_APP_USER.STG_SODS_ESF
   SET order_sales_amt = transaction_amount - order_sales_tax_amt - acct_cmsn_paid_amt,
       ods_modify_date = SYSDATE
 WHERE order_sales_amt != transaction_amount - order_sales_tax_amt - acct_cmsn_paid_amt
   AND ods_modify_date >= TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_sales_ods_overlap

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Zero out old account commission values */

UPDATE RAX_APP_USER.STG_SODS_ESF esf
   SET est_acct_cmsn_amt = 0,
       tot_est_acct_cmsn_amt = 0,
       ods_modify_date = SYSDATE
 WHERE EXISTS (
          SELECT 1
            FROM ods_own.event e
           WHERE esf.event_ref_id = e.event_ref_id
             AND esf.ship_date != e.ship_date
             AND (   NVL (esf.est_acct_cmsn_amt, 0) != 0
                  OR NVL (esf.tot_est_acct_cmsn_amt, 0) != 0
                 ))

&


/*-----------------------------------------------*/
