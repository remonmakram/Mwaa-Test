select	
	payment.id	 as  c1_id,
	payment.orderid	 as  c2_orderid,
	payment.amount	 as  c3_amount,
	payment.creditcardtypecode	 as  c4_creditcardtypecode,
	payment.maskedcardnumber	 as  c5_maskedcardnumber,
	payment.verificationresultcode	 as  c6_verificationresultcode,
	payment.verificationresultmessage	 as  c7_verificationresultmessage,
	payment.salepnref	 as  c8_salepnref,
	payment.createdate	 as  c9_createdate,
	payment.lastchangedate	 as  c10_lastchangedate

from 	<schema_name>.dbo.payment as payment
where	(1=1)
and (payment.lastchangedate >= convert(datetime,substring(:v_cdc_load_date, 1, 19),120) - 7.0)