BEGIN
   EXECUTE IMMEDIATE 'drop table order_code_new_prod_ccpricing';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&

CREATE TABLE order_code_new_prod_ccpricing AS
select 'new products' as New_Products, l.* 
from ccpricingorderheader o
join ccpricinglineitem l on l.order_guid = o.order_guid   
where  o.order_date > '1-jan-2022' 
--o.order_date > '1-jan-2018' --
and order_code > 90
--and o.ORDER_GUID='8c72a28e-6f7f-4490-a827-962552e95693' --