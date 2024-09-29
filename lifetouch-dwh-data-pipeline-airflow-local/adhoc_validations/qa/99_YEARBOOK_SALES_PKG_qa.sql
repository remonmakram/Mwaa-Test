SELECT count(*)
from	RAX_APP_USER.YEARBOOK_SALES

--COUNT(*)|
----------+
--    8945|

-- checked the files and are identical

SELECT count(*)
  FROM ods_own.sub_program       sp,
       ods_own.apo               a,
       ods_own.event             e,
       ods_own.event_adjustment  ea
 WHERE     sp.SUB_PROGRAM_OID = a.SUB_PROGRAM_OID
       AND a.APO_OID = e.APO_OID
       AND e.EVENT_OID = ea.EVENT_OID
       AND sp.SUB_PROGRAM_NAME = 'Yearbook'
       AND a.FINANCIAL_PROCESSING_SYSTEM = 'Spectrum'
       AND E.SCHOOL_YEAR >= (SELECT tt.FISCAL_YEAR - 4
                               FROM MART.TIME tt
                              WHERE tt.DATE_KEY = TRUNC (SYSDATE))


--COUNT(*)|
----------+
--       0|

--                              EVENT_REF_ID	RECOGNIZED_DATE	SALES	ACCOUNT_COMMISSION	CHARGE_BACK	TERRITORY_COMMISSION	ORDER_SHIPPING_HANDLING	WRITE_OFF	UPDATED_BY	REASON	NOTE	APO_ID
