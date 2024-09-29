select	
	jobinfo.orderid	 as  c1_orderid,
	jobinfo.createdate	 as  c2_createdate,
	jobinfo.lastchangedate	 as  c3_lastchangedate

from 	<schema_name>.dbo.jobinfo as jobinfo
where	(1=1)
and (jobinfo.lastchangedate >= convert(datetime,substring(:v_cdc_load_date, 1, 19),120) - 7.0)