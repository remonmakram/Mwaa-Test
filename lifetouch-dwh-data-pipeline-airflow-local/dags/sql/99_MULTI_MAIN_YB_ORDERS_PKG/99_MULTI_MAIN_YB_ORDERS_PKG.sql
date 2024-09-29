/* TASK No. 1 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 2 */




/*-----------------------------------------------*/
/* TASK No. 3 */
/* Drop Temp Table */

-- drop table  rax_app_user.multi_yb_orders

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 4 */
-- /* Create and load Temp table */

-- CREATE TABLE rax_app_user.multi_yb_orders AS
-- SELECT dr.event_ref_id, e.ship_date
--   FROM (  SELECT event_ref_id, COUNT (*)
--             FROM (SELECT DISTINCT e.EVENT_REF_ID,
--                                   oh.ORDER_TYPE,
--                                   oh.ORDER_BUCKET,
--                                   oh.ORDER_NO
--                     FROM ODS_OWN.SUB_PROGRAM    sp,
--                          ODS_OWN.ACCOUNT        acct,
--                          ODS_OWN.ORGANIZATION_VW org,
--                          ods_own.apo            a,
--                          ods_own.event          e,
--                          ODS_OWN.ORDER_HEADER   oh,
--                          ods_own.order_line     ol,
--                          ods_own.item           i
--                    WHERE     sp.SUB_PROGRAM_OID = a.SUB_PROGRAM_OID
--                          AND a.ACCOUNT_OID = acct.ACCOUNT_OID
--                          AND a.TERRITORY_CODE = org.TERRITORY_CODE
--                          AND a.APO_OID = e.APO_OID
--                          AND e.EVENT_REF_ID = oh.EVENT_REF_ID
--                          AND oh.ORDER_HEADER_OID = ol.ORDER_HEADER_OID
--                          AND ol.ITEM_OID = i.ITEM_OID
--                          AND sp.SUB_PROGRAM_NAME = 'Yearbook'
--                          AND i.DESCRIPTION = 'Yearbook'
--                          AND a.SCHOOL_YEAR >= 2021
--                          AND acct.CATEGORY_NAME NOT IN ('House', 'Test')
--                          AND org.BUSINESS_UNIT_NAME != ('Test Organization')
--                          AND oh.ORDER_TYPE = 'YBYearbook_Order'
--                          AND   (CASE
--                                     WHEN oh.ORDER_BUCKET = 'CANCELLED' THEN 1
--                                     ELSE 0
--                                 END)
--                              + (CASE
--                                     WHEN oh.ORDER_STATUS = 'Cancelled' THEN 1
--                                     ELSE 0
--                                 END) =
--                              0)
--         GROUP BY event_ref_id
--           HAVING COUNT (*) > 1) dr,
--        ods_own.event  e
--  WHERE dr.EVENT_REF_ID = e.EVENT_REF_ID AND e.status = '1'

-- &


/*-----------------------------------------------*/
/* TASK No. 5 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 5 */




/*-----------------------------------------------*/
/* TASK No. 6 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 6 */




/*-----------------------------------------------*/
/* TASK No. 7 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 7 */




/*-----------------------------------------------*/
-- /* TASK No. 8 */

-- incase of true

-- OdiSendMail "-MAILHOST=LTIVRS1.LIFETOUCH.NET" "-FROM=ODI_EMAIL-PROD@Lifetouch.com" "-SUBJECT=YB Events with more than 1 Main order" "-TO=:v_error_email_to"


-- :v_US_data_center Events

-- YB Events with Multiple 'Main' Orders 
-- Event_Ref_id		Ship Date
-- :v_multi_yb_orders


-- incase of false

-- OdiSendMail "-MAILHOST=LTIVRS1.LIFETOUCH.NET" "-FROM=ODI_EMAIL-PROD@Lifetouch.com" "-SUBJECT=YB Events with more than 1 Main order" "-TO=:v_error_email_to"


-- :v_US_data_center Events

-- No YB Events with Multiple 'Main' Orders 



-- &


/*-----------------------------------------------*/
