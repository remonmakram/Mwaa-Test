SELECT max(ODS_MODIFY_DATE) FROM ods_own.event
--MAX(ODS_MODIFY_DATE)|
----------------------+
-- 2024-08-28 20:18:43|

-- update cdc for yesterday start day date and run the dag

UPDATE ods_own.ods_cdc_load_status
SET last_cdc_completion_date = TO_DATE(SUBSTR('2024-08-28 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
WHERE ods_table_name IN ('EVENT_PLANT_RECEIPT_DATE_LOAD','EVENT_STAFF_CAPSESS_LOAD','EVENT_CLICK_QTY_LOAD','EVENT_CAPTURE_SESSION_LOAD')

-- run the dag

SELECT max(ODS_MODIFY_DATE) FROM ods_own.event





----------------------------------------------------
SELECT * FROM rax_app_user.temp_event_staff_qty

SELECT * FROM ODS_OWN.EVENT WHERE EVENT_OID = '8944329'

--EVENT_OID|EVENT_REF_ID|APO_OID  |LIFETOUCH_ID|ORGANIZATION_OID|TERRITORY_CODE|SELLING_METHOD|MARKETING_CODE|DW_MARKETING_CODE|SCHOOL_YEAR|JOB_CLASSIFICATION|PHOTOGRAPHY_DATE   |PLANT_RECEIPT_DATE |SHIP_DATE          |VISION_PHOTO_DATE_A|VISION_PHOTO_DATE_B|VISION_COMMIT_DATE|PROCESSING_LAB|ACCOUNT_COMMISSION_METHOD|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |SOURCE_SYSTEM_OID|STAFF_QTY|CAPTURE_SESSION_QTY|TRANSACTION_AMT|RECOGNIZED_REVENUE_AMT|PERFECT_ORDER_SALES_AMT|SHIPPED_SALES_AMT|ACCOUNT_COMMISSION_AMT|TERRITORY_COMMISSION_AMT|CHARGEBACK_AMT|PAID_ORDER_QTY|UNPAID_ORDER_QTY|X_NO_PURCHASE_QTY|SHIPPED_ORDER_QTY|CLICK_QTY|EVENT_TYPE_OID|EVENT_TYPE|EST_ACCT_CMSN_AMT|TOT_EST_ACCT_CMSN_AMT|EVENT_ACCT_COMMISSION_LST_UPD|PDK_NUMBER  |ROLLOVER_JOB_IND|SPECTRUM_IND|FLYER|SELLING_METHOD_OID|SEND_INVOICE_TO|PRICES_TAX_INCLUSIVE|DESCRIPTION|PRF_ORDER_DUE_DATE|ALTERNATE_PICTURE_DAY_TEXT|SPECIAL_INSTRUCTIONS                |SH_BILL_MODEL|SALE_TYPE|PRIM_SORT|SHIP_TO|EST_SUBJECTS|FLYER_TITLE|AUTO_PDK_DISABLED|AUTO_PDK_DISABLED_REASON|AUTO_PDK_UPDATED_BY|YB_DEPOSIT_PERCENT|YB_COMPLETE_COPY_DATE|STATUS|SHIP_TO_SATELLITE_CODE|YB_ARRIVAL_DATE|COVER_ENDSHEET_DEADLINE|FIRST_PAGE_DEADLINE|FINAL_PAGE_DEADLINE|CUT_OUT_PAGES|YB_EXTRA_COPIES|YB_PAGES|YB_COPIES|YB_SOFT_COVER_QTY|YB_HARD_COVER_QTY|YB_REORDER_CHARGE|INVOICE_TO|INVOICE_TO_ADDRESS|SHIPPING_HANDLING|SHIPPING_CHARGE|PORTRAIT_PAGES|ACTIVITY_PAGES|SR_APPOINTMENT_DISTRIBUTION|SCHOOL_PO_HEADER|PDKOFFSET|CLASS_PICTURE_RELEASE|FINAL_QUANTITY_DEADLINE|ADDITIONAL_PAGE_DEADLINE2|ADDITIONAL_PAGE_DEADLINE3|ADDITIONAL_PAGE_DEADLINE4|EXTRA_COVERAGE_DEADLINE|ENHANCEMENT_DEADLINE|FIRST_PAGE_DEADLINE_PP|ADDITIONAL_PAGE_DEADLINE2_PP|ADDITIONAL_PAGE_DEADLINE3_PP|EXTRA_COVERAGE_DEADLINE_PP|FINAL_PAGE_DEADLINE_PP|FOW_EVENT_IMAGE_COMPLETE|FIRST_BOC_START_DATE|EVENT_HOLD_STATUS|EVENT_HOLD_STATUS_CHANGE_BY|EVENT_HOLD_STATUS_DATE|FIRST_BOC_CLOSE_DATE|AID_IND|ASSET_UPLOAD_COMPLETE_DATE|IMAGE_TRANSMISSION_METHOD|
-----------+------------+---------+------------+----------------+--------------+--------------+--------------+-----------------+-----------+------------------+-------------------+-------------------+-------------------+-------------------+-------------------+------------------+--------------+-------------------------+-------------------+-------------------+-----------------+---------+-------------------+---------------+----------------------+-----------------------+-----------------+----------------------+------------------------+--------------+--------------+----------------+-----------------+-----------------+---------+--------------+----------+-----------------+---------------------+-----------------------------+------------+----------------+------------+-----+------------------+---------------+--------------------+-----------+------------------+--------------------------+------------------------------------+-------------+---------+---------+-------+------------+-----------+-----------------+------------------------+-------------------+------------------+---------------------+------+----------------------+---------------+-----------------------+-------------------+-------------------+-------------+---------------+--------+---------+-----------------+-----------------+-----------------+----------+------------------+-----------------+---------------+--------------+--------------+---------------------------+----------------+---------+---------------------+-----------------------+-------------------------+-------------------------+-------------------------+-----------------------+--------------------+----------------------+----------------------------+----------------------------+--------------------------+----------------------+------------------------+--------------------+-----------------+---------------------------+----------------------+--------------------+-------+--------------------------+-------------------------+
--  8944329|EVTCXK9P9   |115931027|      413691|             516|LN            |Proof         |              |Unknown 01       |       2024|Original          |2023-10-16 00:00:00|2023-06-06 00:00:00|2024-05-17 00:00:00|                   |2023-10-16 00:00:00|                  |Shakopee      |                         |2023-05-31 11:26:12|2024-08-28 12:02:59|               61|        1|                 60|     1073216.44|                     0|              591376.51|            65.07|                     0|                       0|             0|          5926|              10|               44|                3|      111|             1|ORIGINAL  |                 |                     |                             |LN01XF300038|                |           1|     |                 3|               |                   1|E2E 14A    |                  |                          |SPECIAL INSTRUCTIONS TEST FOR FLYERS|             |         |Teacher  |Subject|         100|E2E 14A    |                1|Test Jobs               |fow.admin          |                  |                     |1     |                      |               |                       |                   |                   |             |               |        |         |                 |                 |                 |          |                  |                 |               |              |              |                           |                |       14|                    0|                       |                         |                         |                         |                       |                    |                      |                            |                            |                          |                      |                       1| 2023-06-08 08:10:45|                 |                           |                      | 2023-06-08 08:12:35|Y      |       2023-06-06 11:31:57|Web Uploader             |

UPDATE ODS_OWN.EVENT
SET STAFF_QTY = NULL
WHERE EVENT_OID = '8944329'

SELECT * FROM ODS_OWN.EVENT WHERE EVENT_OID = '8944329'
--EVENT_OID|EVENT_REF_ID|APO_OID  |LIFETOUCH_ID|ORGANIZATION_OID|TERRITORY_CODE|SELLING_METHOD|MARKETING_CODE|DW_MARKETING_CODE|SCHOOL_YEAR|JOB_CLASSIFICATION|PHOTOGRAPHY_DATE   |PLANT_RECEIPT_DATE |SHIP_DATE          |VISION_PHOTO_DATE_A|VISION_PHOTO_DATE_B|VISION_COMMIT_DATE|PROCESSING_LAB|ACCOUNT_COMMISSION_METHOD|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |SOURCE_SYSTEM_OID|STAFF_QTY|CAPTURE_SESSION_QTY|TRANSACTION_AMT|RECOGNIZED_REVENUE_AMT|PERFECT_ORDER_SALES_AMT|SHIPPED_SALES_AMT|ACCOUNT_COMMISSION_AMT|TERRITORY_COMMISSION_AMT|CHARGEBACK_AMT|PAID_ORDER_QTY|UNPAID_ORDER_QTY|X_NO_PURCHASE_QTY|SHIPPED_ORDER_QTY|CLICK_QTY|EVENT_TYPE_OID|EVENT_TYPE|EST_ACCT_CMSN_AMT|TOT_EST_ACCT_CMSN_AMT|EVENT_ACCT_COMMISSION_LST_UPD|PDK_NUMBER  |ROLLOVER_JOB_IND|SPECTRUM_IND|FLYER|SELLING_METHOD_OID|SEND_INVOICE_TO|PRICES_TAX_INCLUSIVE|DESCRIPTION|PRF_ORDER_DUE_DATE|ALTERNATE_PICTURE_DAY_TEXT|SPECIAL_INSTRUCTIONS                |SH_BILL_MODEL|SALE_TYPE|PRIM_SORT|SHIP_TO|EST_SUBJECTS|FLYER_TITLE|AUTO_PDK_DISABLED|AUTO_PDK_DISABLED_REASON|AUTO_PDK_UPDATED_BY|YB_DEPOSIT_PERCENT|YB_COMPLETE_COPY_DATE|STATUS|SHIP_TO_SATELLITE_CODE|YB_ARRIVAL_DATE|COVER_ENDSHEET_DEADLINE|FIRST_PAGE_DEADLINE|FINAL_PAGE_DEADLINE|CUT_OUT_PAGES|YB_EXTRA_COPIES|YB_PAGES|YB_COPIES|YB_SOFT_COVER_QTY|YB_HARD_COVER_QTY|YB_REORDER_CHARGE|INVOICE_TO|INVOICE_TO_ADDRESS|SHIPPING_HANDLING|SHIPPING_CHARGE|PORTRAIT_PAGES|ACTIVITY_PAGES|SR_APPOINTMENT_DISTRIBUTION|SCHOOL_PO_HEADER|PDKOFFSET|CLASS_PICTURE_RELEASE|FINAL_QUANTITY_DEADLINE|ADDITIONAL_PAGE_DEADLINE2|ADDITIONAL_PAGE_DEADLINE3|ADDITIONAL_PAGE_DEADLINE4|EXTRA_COVERAGE_DEADLINE|ENHANCEMENT_DEADLINE|FIRST_PAGE_DEADLINE_PP|ADDITIONAL_PAGE_DEADLINE2_PP|ADDITIONAL_PAGE_DEADLINE3_PP|EXTRA_COVERAGE_DEADLINE_PP|FINAL_PAGE_DEADLINE_PP|FOW_EVENT_IMAGE_COMPLETE|FIRST_BOC_START_DATE|EVENT_HOLD_STATUS|EVENT_HOLD_STATUS_CHANGE_BY|EVENT_HOLD_STATUS_DATE|FIRST_BOC_CLOSE_DATE|AID_IND|ASSET_UPLOAD_COMPLETE_DATE|IMAGE_TRANSMISSION_METHOD|
-----------+------------+---------+------------+----------------+--------------+--------------+--------------+-----------------+-----------+------------------+-------------------+-------------------+-------------------+-------------------+-------------------+------------------+--------------+-------------------------+-------------------+-------------------+-----------------+---------+-------------------+---------------+----------------------+-----------------------+-----------------+----------------------+------------------------+--------------+--------------+----------------+-----------------+-----------------+---------+--------------+----------+-----------------+---------------------+-----------------------------+------------+----------------+------------+-----+------------------+---------------+--------------------+-----------+------------------+--------------------------+------------------------------------+-------------+---------+---------+-------+------------+-----------+-----------------+------------------------+-------------------+------------------+---------------------+------+----------------------+---------------+-----------------------+-------------------+-------------------+-------------+---------------+--------+---------+-----------------+-----------------+-----------------+----------+------------------+-----------------+---------------+--------------+--------------+---------------------------+----------------+---------+---------------------+-----------------------+-------------------------+-------------------------+-------------------------+-----------------------+--------------------+----------------------+----------------------------+----------------------------+--------------------------+----------------------+------------------------+--------------------+-----------------+---------------------------+----------------------+--------------------+-------+--------------------------+-------------------------+
--  8944329|EVTCXK9P9   |115931027|      413691|             516|LN            |Proof         |              |Unknown 01       |       2024|Original          |2023-10-16 00:00:00|2023-06-06 00:00:00|2024-05-17 00:00:00|                   |2023-10-16 00:00:00|                  |Shakopee      |                         |2023-05-31 11:26:12|2024-08-28 12:02:59|               61|         |                 60|     1073216.44|                     0|              591376.51|            65.07|                     0|                       0|             0|          5926|              10|               44|                3|      111|             1|ORIGINAL  |                 |                     |                             |LN01XF300038|                |           1|     |                 3|               |                   1|E2E 14A    |                  |                          |SPECIAL INSTRUCTIONS TEST FOR FLYERS|             |         |Teacher  |Subject|         100|E2E 14A    |                1|Test Jobs               |fow.admin          |                  |                     |1     |                      |               |                       |                   |                   |             |               |        |         |                 |                 |                 |          |                  |                 |               |              |              |                           |                |       14|                    0|                       |                         |                         |                         |                       |                    |                      |                            |                            |                          |                      |                       1| 2023-06-08 08:10:45|                 |                           |                      | 2023-06-08 08:12:35|Y      |       2023-06-06 11:31:57|Web Uploader             |


UPDATE ods_own.ods_cdc_load_status
SET last_cdc_completion_date = TO_DATE(SUBSTR('2024-08-28 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
WHERE ods_table_name IN ('EVENT_PLANT_RECEIPT_DATE_LOAD','EVENT_STAFF_CAPSESS_LOAD','EVENT_CLICK_QTY_LOAD','EVENT_CAPTURE_SESSION_LOAD')

-- run the DW_MARKETING_CODE

SELECT * FROM ODS_OWN.EVENT WHERE EVENT_OID = '8944329'
--EVENT_OID|EVENT_REF_ID|APO_OID  |LIFETOUCH_ID|ORGANIZATION_OID|TERRITORY_CODE|SELLING_METHOD|MARKETING_CODE|DW_MARKETING_CODE|SCHOOL_YEAR|JOB_CLASSIFICATION|PHOTOGRAPHY_DATE   |PLANT_RECEIPT_DATE |SHIP_DATE          |VISION_PHOTO_DATE_A|VISION_PHOTO_DATE_B|VISION_COMMIT_DATE|PROCESSING_LAB|ACCOUNT_COMMISSION_METHOD|ODS_CREATE_DATE    |ODS_MODIFY_DATE    |SOURCE_SYSTEM_OID|STAFF_QTY|CAPTURE_SESSION_QTY|TRANSACTION_AMT|RECOGNIZED_REVENUE_AMT|PERFECT_ORDER_SALES_AMT|SHIPPED_SALES_AMT|ACCOUNT_COMMISSION_AMT|TERRITORY_COMMISSION_AMT|CHARGEBACK_AMT|PAID_ORDER_QTY|UNPAID_ORDER_QTY|X_NO_PURCHASE_QTY|SHIPPED_ORDER_QTY|CLICK_QTY|EVENT_TYPE_OID|EVENT_TYPE|EST_ACCT_CMSN_AMT|TOT_EST_ACCT_CMSN_AMT|EVENT_ACCT_COMMISSION_LST_UPD|PDK_NUMBER  |ROLLOVER_JOB_IND|SPECTRUM_IND|FLYER|SELLING_METHOD_OID|SEND_INVOICE_TO|PRICES_TAX_INCLUSIVE|DESCRIPTION|PRF_ORDER_DUE_DATE|ALTERNATE_PICTURE_DAY_TEXT|SPECIAL_INSTRUCTIONS                |SH_BILL_MODEL|SALE_TYPE|PRIM_SORT|SHIP_TO|EST_SUBJECTS|FLYER_TITLE|AUTO_PDK_DISABLED|AUTO_PDK_DISABLED_REASON|AUTO_PDK_UPDATED_BY|YB_DEPOSIT_PERCENT|YB_COMPLETE_COPY_DATE|STATUS|SHIP_TO_SATELLITE_CODE|YB_ARRIVAL_DATE|COVER_ENDSHEET_DEADLINE|FIRST_PAGE_DEADLINE|FINAL_PAGE_DEADLINE|CUT_OUT_PAGES|YB_EXTRA_COPIES|YB_PAGES|YB_COPIES|YB_SOFT_COVER_QTY|YB_HARD_COVER_QTY|YB_REORDER_CHARGE|INVOICE_TO|INVOICE_TO_ADDRESS|SHIPPING_HANDLING|SHIPPING_CHARGE|PORTRAIT_PAGES|ACTIVITY_PAGES|SR_APPOINTMENT_DISTRIBUTION|SCHOOL_PO_HEADER|PDKOFFSET|CLASS_PICTURE_RELEASE|FINAL_QUANTITY_DEADLINE|ADDITIONAL_PAGE_DEADLINE2|ADDITIONAL_PAGE_DEADLINE3|ADDITIONAL_PAGE_DEADLINE4|EXTRA_COVERAGE_DEADLINE|ENHANCEMENT_DEADLINE|FIRST_PAGE_DEADLINE_PP|ADDITIONAL_PAGE_DEADLINE2_PP|ADDITIONAL_PAGE_DEADLINE3_PP|EXTRA_COVERAGE_DEADLINE_PP|FINAL_PAGE_DEADLINE_PP|FOW_EVENT_IMAGE_COMPLETE|FIRST_BOC_START_DATE|EVENT_HOLD_STATUS|EVENT_HOLD_STATUS_CHANGE_BY|EVENT_HOLD_STATUS_DATE|FIRST_BOC_CLOSE_DATE|AID_IND|ASSET_UPLOAD_COMPLETE_DATE|IMAGE_TRANSMISSION_METHOD|
-----------+------------+---------+------------+----------------+--------------+--------------+--------------+-----------------+-----------+------------------+-------------------+-------------------+-------------------+-------------------+-------------------+------------------+--------------+-------------------------+-------------------+-------------------+-----------------+---------+-------------------+---------------+----------------------+-----------------------+-----------------+----------------------+------------------------+--------------+--------------+----------------+-----------------+-----------------+---------+--------------+----------+-----------------+---------------------+-----------------------------+------------+----------------+------------+-----+------------------+---------------+--------------------+-----------+------------------+--------------------------+------------------------------------+-------------+---------+---------+-------+------------+-----------+-----------------+------------------------+-------------------+------------------+---------------------+------+----------------------+---------------+-----------------------+-------------------+-------------------+-------------+---------------+--------+---------+-----------------+-----------------+-----------------+----------+------------------+-----------------+---------------+--------------+--------------+---------------------------+----------------+---------+---------------------+-----------------------+-------------------------+-------------------------+-------------------------+-----------------------+--------------------+----------------------+----------------------------+----------------------------+--------------------------+----------------------+------------------------+--------------------+-----------------+---------------------------+----------------------+--------------------+-------+--------------------------+-------------------------+
--  8944329|EVTCXK9P9   |115931027|      413691|             516|LN            |Proof         |              |Unknown 01       |       2024|Original          |2023-10-16 00:00:00|2023-06-06 00:00:00|2024-05-17 00:00:00|                   |2023-10-16 00:00:00|                  |Shakopee      |                         |2023-05-31 11:26:12|2024-08-29 04:17:43|               61|        1|                 60|     1073216.44|                     0|              591376.51|            65.07|                     0|                       0|             0|          5926|              10|               44|                3|      111|             1|ORIGINAL  |                 |                     |                             |LN01XF300038|                |           1|     |                 3|               |                   1|E2E 14A    |                  |                          |SPECIAL INSTRUCTIONS TEST FOR FLYERS|             |         |Teacher  |Subject|         100|E2E 14A    |                1|Test Jobs               |fow.admin          |                  |                     |1     |                      |               |                       |                   |                   |             |               |        |         |                 |                 |                 |          |                  |                 |               |              |              |                           |                |       14|                    0|                       |                         |                         |                         |                       |                    |                      |                            |                            |                          |                      |                       1| 2023-06-08 08:10:45|                 |                           |                      | 2023-06-08 08:12:35|Y      |       2023-06-06 11:31:57|Web Uploader             |

SELECT STAFF_QTY ,event_oid, ods_modify_date FROM ods_own.event WHERE STAFF_QTY IS NOT NULL ORDER BY ods_modify_date DESC FETCH FIRST 5 ROWS only

select src.staff_qty as src_staff_qty,trg.event_oid
, trg.staff_qty as trg_staff_qty
, trg.ods_modify_date as trg_ods_modify_date
from ods_own.event trg
, rax_app_user.temp_event_staff_qty src
where trg.event_oid = src.event_oid
and (trg.staff_qty <> src.staff_qty
     or trg.staff_qty is null
    )

  SELECT * FROM rax_app_user.temp_event_staff_qty_d

    select
event_oid
from (
select  cs.event_oid
from ods_own.capture_session cs
,ods_own.event e
where cs.ods_modify_date >=   TO_DATE(SUBSTR('2024-08-28 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
and e.event_oid = cs.event_oid
and e.school_year >= to_char(trunc(sysdate),'YYYY') /* dont reset when degistered. 6 month buffer on school year */
and nvl(cs.event_oid,-1) <> -1
union
select  e.event_oid
from ods_own.event e
where e.ods_modify_date >=   TO_DATE(SUBSTR('2024-08-28 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
and e.school_year >= to_char(trunc(sysdate),'YYYY') /* dont reset when degistered. 6 month buffer on school year */
and nvl(e.event_oid,-1) <> -1
) group by event_oid


    select e.event_oid
, case when e.rollover_job_ind = 'X' then 0 else count(distinct cs.CAPTURE_SESSION_OID) end as staff_qty
from ods_own.capture_session cs
, rax_app_user.temp_event_staff_qty_d d
, ods_own.event e
, ods_own.image i
, ods_own.subject_image si
, ods_own.subject s
, ods_own.source_system ss
where cs.event_oid = e.event_oid
and cs.event_oid = d.event_oid
and e.school_year >= to_char(trunc(sysdate),'YYYY') /* dont reset when degistered. 6 month buffer on school year */
and cs.capture_session_oid = i.capture_session_oid
and i.image_oid = si.image_image_oid
and si.subject_subject_oid = s.subject_oid
and s.staff_flag = 1
and i.source_system_oid = ss.source_system_oid
and (ss.source_system_short_name <> 'SM' or (ss.source_system_short_name = 'SM' and trim(i.LTI_IMAGE_URL) is not null))
group by e.event_oid
,e.rollover_job_ind


-------------------------------------------

SELECT count(*) FROM ODS_OWN.event WHERE event_ref_id in (
select  e.event_ref_id
from ODS_STAGE.event_plant_receipt_date eprd
, ODS_OWN.event e
, ODS_OWN.source_system ss
, ODS_OWN.apo apo
where 1=1
and eprd.event_ref_id = e.event_ref_id
and e.source_system_oid = ss.source_system_oid
and e.apo_oid = apo.apo_oid
and ss.source_system_name = 'Field Operations Workbench'
and eprd.system_of_record in ('GDT','Capture Session Date')
and eprd.last_modify_date >=  TO_DATE(SUBSTR('2024-08-28 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')
)

select eprd.event_ref_id
, (case when eprd.system_of_record = 'GDT' then eprd.gdt_plant_receipt_date
/* request from Diane Hatfield and Ross Marble to subtract 3 days because this will happen a lot on GDT Proof and the receipt was likely 3 days earlier */
           when eprd.system_of_record = 'Capture Session Date' and e.selling_method = 'Proof' and apo.fulfilling_lab_system IN ('Prism') then eprd.capture_session_date
           when eprd.system_of_record = 'Capture Session Date' and e.selling_method = 'Proof' and apo.fulfilling_lab_system NOT IN ('Prism') then eprd.capture_session_date - 3
           when eprd.system_of_record = 'Capture Session Date' then eprd.capture_session_date
           else null end) as plant_receipt_date
from ODS_STAGE.event_plant_receipt_date eprd
, ODS_OWN.event e
, ODS_OWN.source_system ss
, ODS_OWN.apo apo
where 1=1
and eprd.event_ref_id = e.event_ref_id
and e.source_system_oid = ss.source_system_oid
and e.apo_oid = apo.apo_oid
and ss.source_system_name = 'Field Operations Workbench'
and eprd.system_of_record in ('GDT','Capture Session Date')
and eprd.last_modify_date >=  TO_DATE(SUBSTR('2024-08-29 00:00:00', 1, 19), 'YYYY-MM-DD HH24:MI:SS')


SELECT * FROM ODS_OWN.ODS_CDC_LOAD_STATUS
WHERE ODS_TABLE_NAME IN ('EVENT_PLANT_RECEIPT_DATE_LOAD','EVENT_STAFF_CAPSESS_LOAD','EVENT_CLICK_QTY_LOAD','EVENT_CAPTURE_SESSION_LOAD')