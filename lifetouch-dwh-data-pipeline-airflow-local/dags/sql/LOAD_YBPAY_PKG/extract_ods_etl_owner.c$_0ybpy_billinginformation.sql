select	
	billinginformation.orderid	 as  c1_orderid,
	billinginformation.customeremail	 as  c2_customeremail,
	billinginformation.firstname	 as  c3_firstname,
	billinginformation.lastname	 as  c4_lastname,
	billinginformation.address1	 as  c5_address1,
	billinginformation.address2	 as  c6_address2,
	billinginformation.countrycode	 as  c7_countrycode,
	billinginformation.city	 as  c8_city,
	billinginformation.state	 as  c9_state,
	billinginformation.postalcode	 as  c10_postalcode,
	billinginformation.createdate	 as  c11_createdate,
	billinginformation.lastchangedate	 as  c12_lastchangedate

from 	<schema_name>.dbo.billinginformation as billinginformation
where	(1=1)
and (billinginformation.lastchangedate >= convert(datetime,substring(:v_cdc_load_date, 1, 19),120) - 7.0)