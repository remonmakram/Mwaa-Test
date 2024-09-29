select	
	orders.id	 as  c1_id,
	orders.orderdate	 as  c2_orderdate,
	orders.transactiondate	 as  c3_transactiondate,
	orders.transactionid	 as  c4_transactionid,
	orders.jobnumber	 as  c5_jobnumber,
	orders.schoolname	 as  c6_schoolname,
	orders.schoolcountry	 as  c7_schoolcountry,
	orders.totalamount	 as  c8_totalamount,
	orders.taxamount	 as  c9_taxamount,
	orders.taxexemptind	 as  c10_taxexemptind,
	orders.createdate	 as  c11_createdate,
	orders.lastchangedate	 as  c12_lastchangedate,
	orders.issubmittedtonexttools	 as  c13_issubmittedtonexttools

from 	<schema_name>.dbo.[order] as orders
where	(1=1)
and (orders.lastchangedate >= convert(datetime,substring(:v_cdc_load_date, 1, 19),120) - 7.0)