SELECT count(*)
from	RAX_APP_USER.YB_FREIGHT_CHARGEBACKS   YFC
where
	(1=1)
/* Order the output by the UD1, UD2, UD3, UD4, UD5, UD6 Fields. */
ORDER BY  EVENT_REF_ID
, SHIP_DATE
, FREIGHT_CHARGE

--COUNT(*)|
----------+
--     192|