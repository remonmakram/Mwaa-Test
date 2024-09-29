BEGIN
   EXECUTE IMMEDIATE 'drop table promo_code_miss_rev_share';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&

CREATE TABLE promo_code_miss_rev_share AS
SELECT promo_code.order_guid,
       promo_code.promo_code,
       'groupon missing from REVENUE_SHARE'     AS issue_with
  --select *
  FROM  (SELECT o.order_guid,
                pp.promo_code,
                SUBSTR (pp.PROMO_CODE, 1, 5)     AS core
           FROM ccpricingorderheader  o
                JOIN ccpricingpromo pp ON pp.order_guid = o.order_guid
          WHERE post_date IS NULL AND LENGTH (pp.promo_code) > 8--and std_id = 'P0004'
		  ) promo_code 
       JOIN REF_DAILY_DEAL_CODES r ON r.DD_PROMO_CODE = promo_code.core
       LEFT OUTER JOIN REVENUE_SHARE d ON d.order_guid = promo_code.order_guid
 WHERE 
d.order_guid IS  NULL
--d.order_guid='f371ad44-73f0-494d-9f3d-14e68e9db454'
 AND r.dd_active = 'Yes'
--and merch_pos.pos_id like 'P%'