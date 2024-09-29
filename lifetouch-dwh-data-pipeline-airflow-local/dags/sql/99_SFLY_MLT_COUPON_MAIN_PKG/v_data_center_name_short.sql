SELECT CASE
          WHEN NVL (data_center_name,
                    'United States'
                   ) = 'United States'
             THEN 'US'
          ELSE 'CA'
       END AS data_center_name
  FROM ods_own.data_center