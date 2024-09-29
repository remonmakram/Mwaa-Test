BEGIN
   EXECUTE IMMEDIATE 'drop table CCPricingLineItem_is_nul';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&

CREATE TABLE CCPricingLineItem_is_nul AS select * from CCPricingLineItem where SBASE_CODE IS NULL