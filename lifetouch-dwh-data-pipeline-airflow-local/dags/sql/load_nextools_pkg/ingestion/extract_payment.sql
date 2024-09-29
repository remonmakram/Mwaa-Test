select	
	PAYMENT.Id	 as  C1_ID,
	PAYMENT.PersonId	 as  C2_PERSONID,
	PAYMENT.Amount	 as  C3_AMOUNT,
	PAYMENT.TransactionDate	 as  C4_TRANSACTIONDATE,
	PAYMENT.PaymentTypeId	 as  C5_PAYMENTTYPEID,
	PAYMENT.OriginId	 as  C6_ORIGINID,
	PAYMENT.Memo	 as  C7_MEMO,
	PAYMENT.CreatedUser	 as  C8_CREATEDUSER,
	PAYMENT.CreatedDate	 as  C9_CREATEDDATE,
	PAYMENT.LastModifiedUser	 as  C10_LASTMODIFIEDUSER,
	PAYMENT.LastModifiedDate	 as  C11_LASTMODIFIEDDATE,
	PAYMENT.VerificationResultCode	 as  C12_VERIFICATIONRESULTCODE,
	PAYMENT.VerificationResultMessage	 as  C13_VERIFICATIONRESULTMESSAGE,
	PAYMENT.PnRef	 as  C14_PNREF
from	<schema_name>.dbo.Payment as PAYMENT
where	(1=1)
And (PAYMENT.LastModifiedDate >= convert(datetime,SUBSTRING(:v_cdc_load_date, 1, 19),120) - 7.0)