select	
	orderline.id	 as  c1_id,
	orderline.orderid	 as  c2_orderid,
	orderline.studentid	 as  c3_studentid,
	orderline.firstname	 as  c4_firstname,
	orderline.lastname	 as  c5_lastname,
	orderline.gradeid	 as  c6_gradeid,
	orderline.gradedescription	 as  c7_gradedescription,
	orderline.packageschoolpricingid	 as  c8_packageschoolpricingid,
	orderline.packagename	 as  c9_packagename,
	orderline.quantity	 as  c10_quantity,
	orderline.yearbookprice	 as  c11_yearbookprice,
	orderline.yearbooktax	 as  c12_yearbooktax,
	orderline.donationamount	 as  c13_donationamount,
	orderline.totalamount	 as  c14_totalamount,
	orderline.totaltax	 as  c15_totaltax,
	orderline.createdate	 as  c16_createdate,
	orderline.lastchangedate	 as  c17_lastchangedate,
	orderline.includedline	 as  c18_includedline,
	orderline.includedicon	 as  c19_includedicon

from 	<schema_name>.dbo.orderline as orderline
where	(1=1)
and (orderline.lastchangedate >= convert(datetime,substring(:v_cdc_load_date, 1, 19),120) - 7.0)