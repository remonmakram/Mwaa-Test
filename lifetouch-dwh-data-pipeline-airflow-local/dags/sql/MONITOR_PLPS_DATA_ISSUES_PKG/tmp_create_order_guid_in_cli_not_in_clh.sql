BEGIN
   EXECUTE IMMEDIATE 'drop table order_guid_in_cli_not_in_clh';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;        

&

CREATE TABLE order_guid_in_cli_not_in_clh AS
/*SELECT ccdetail.order_guid,
       'ccpricinglineitem not in CCpricingorderheader'     AS query_source
  FROM  (SELECT DISTINCT order_guid
           FROM ccpricinglineitem
        ) ccdetail
 WHERE 
 ccdetail.order_guid ='000002df-5546-420d-b2d8-d7f8f9a4e3d5'*/

 SELECT ccdetail.order_guid,
       'ccpricinglineitem not in CCpricingorderheader'     AS query_source
  FROM  (SELECT DISTINCT order_guid
           FROM ccpricinglineitem
        ) ccdetail
 WHERE ccdetail.order_guid NOT IN (SELECT order_guid FROM  (SELECT o.order_guid
           FROM ccpricingorderheader o-- where o.order_date > '1-oct-2020'
                                      ) ccheader) 