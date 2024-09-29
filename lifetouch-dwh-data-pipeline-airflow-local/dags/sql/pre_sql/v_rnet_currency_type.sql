SELECT CASE
           WHEN data_center_name = 'Canada' THEN 'CAD'
           ELSE 'USD'
       END
           AS data_center_tz
FROM ODS_OWN.DATA_CENTER