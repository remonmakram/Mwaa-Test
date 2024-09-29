SELECT CASE
           WHEN data_center_name = 'Canada' THEN 'US/Eastern'
           ELSE 'US/Central'
       END
           AS data_center_tz
FROM ODS_OWN.DATA_CENTER