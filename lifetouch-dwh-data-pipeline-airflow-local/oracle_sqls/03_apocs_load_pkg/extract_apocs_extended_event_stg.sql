SELECT EXT_EVENT_ID,
       AUDIT_CREATE_DATE,
       AUDIT_CREATED_BY,
       AUDIT_MODIFIED_BY,
       AUDIT_MODIFY_DATE,
       EXPECTED_SALES_AMT,
       JOB_CLASSIFICATION_NAME,
       JOB_NBR,
       LIFETOUCH_ID,
       ACCOUNT_LT_PARTNER_KEY,
       LT_ACCOUNT_PROGRAM_KEY,
       MARKETING_CODE,
       ORDER_SALES_TAX_AMT,
       PAID_ORDER_QTY,
       PHOTOGRAPHY_DATE,
       PLANT_RECEIPT_DATE,
       PROCESSING_LAB,
       PROGRAM_NAME,
       SCHOOL_YEAR,
       SELLING_METHOD_NAME,
       SHIP_DATE,
       SHIPPED_ORDER_QTY,
       SOURCE_SYSTEM,
       STATUS,
       SUB_PROGRAM_NAME,
       TERRITORY_LT_PARTNER_KEY,
       TERRITORY_CODE,
       TRANSACTION_AMT,
       UNPAID_ORDER_QTY,
       VISION_COMMIT_DATE,
       VISION_PHOTO_DATE_A,
       VISION_PHOTO_DATE_B,
       X_NO_PURCHASE_QTY,
       EVENT_IMAGE_COMPLETE,
       AIR_ENABLED,
       YB_COVERENDSHEET_DEADLINE,
       YB_COPIES,
       YB_PAGES,
       YB_FIRSTPAGE_DEADLINE,
       YB_FINALPAGE_DEADLINE,
       YB_ORDER_NO,
       EVENT_TYPE,
       EVENT_SEQUENCE,
       YB_FINALIZED_DATE,
       YB_COVERRECIEVED_DATE,
       YB_ADDTNL_PAGE_DEADLINE1,
       YB_ADDTNL_PAGE_DLINE1_PAGE_DUE,
       YB_ADDTNL_PAGE_DEADLINE2,
       YB_ADDTNL_PAGE_DLINE2_PAGE_DUE,
       YB_ADDTNL_PAGE_DEADLINE3,
       YB_ADDTNL_PAGE_DLINE3_PAGE_DUE,
       YB_EXTRA_COVER_DLINE_PAGE_DUE,
       YB_FINAL_PAGE_DLINE_PAGES_DUE,
       YB_FINAL_QUANTITY_DEADLINE,
       YB_EXTRA_COVERAGE_DEADLINE,
       YB_ENHANCEMENT_DEADLINE,
       COVER_DTLS_PROVIDED,
       COVER_APPROVED,
       YB_CUTOUT_PAGES,
       EXPRESS_FREIGHT,
       YB_TAPE_PLACEMENT,
       YB_SHIPPING_HANDLING,
       YB_SHIPPING_CHARGE
, event_hold_status 
, event_hold_status_change_by 
, event_hold_status_date
, proof_order_duedate
  FROM <schema_name>.EXTENDED_EVENT ee
 WHERE ee.AUDIT_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - 1