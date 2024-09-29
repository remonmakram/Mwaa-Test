BEGIN
   EXECUTE IMMEDIATE 'drop table order_guid_in_coh_not_in_cli';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&

CREATE TABLE order_guid_in_coh_not_in_cli AS
 /*  SELECT ccheader.order_guid,ccheader.std_id  ,ccheader.order_date,
       'ccpricinglineitem not in CCpricingorderheader'     AS query_source
  FROM  (SELECT o.order_guid,
                o.std_id,
                o.order_date
           FROM ccpricingorderheader o-- where o.order_date > '1-oct-2020'
        ) ccheader
 WHERE 
 ccheader.order_guid ='00003be4-30af-43fa-b0ea-bb60a773643b'
 and ccheader.order_date > '1-jan-2022'*/



SELECT ccheader.order_guid,ccheader.std_id  ,ccheader.order_date,
       'ccpricinglineitem not in CCpricingorderheader'     AS query_source
  FROM  (SELECT o.order_guid,
                o.std_id,
                o.order_date
           FROM ccpricingorderheader o-- where o.order_date > '1-oct-2020'
        ) ccheader
 WHERE ccheader.order_guid NOT IN (SELECT order_guid FROM (SELECT DISTINCT order_guid
           FROM ccpricinglineitem
        ) ccdetail)
 and ccheader.order_date > '1-jan-2022'  