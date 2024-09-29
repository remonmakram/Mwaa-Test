select replace(nvl(dc.data_center_name,'United States'),' ','_') from ODS_OWN.DATA_CENTER dc
