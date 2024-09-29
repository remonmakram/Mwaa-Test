select	
	PERSON.PersonId	 as  C1_PERSONID,
	PERSON.PortraitGroupTypeId	 as  C2_PORTRAITGROUPTYPEID,
	PERSON.FirstName	 as  C3_FIRSTNAME,
	PERSON.LastName	 as  C4_LASTNAME,
	PERSON.PersonType	 as  C5_PERSONTYPE,
	PERSON.Courtesy	 as  C6_COURTESY,
	PERSON.JobId	 as  C7_JOBID,
	PERSON.StdBookCount	 as  C8_STDBOOKCOUNT,
	PERSON.ImprintLnOne	 as  C9_IMPRINTLNONE,
	PERSON.ImprintLnTwo	 as  C10_IMPRINTLNTWO,
	PERSON.ModifiedBy	 as  C11_MODIFIEDBY,
	PERSON.ModifiedDate	 as  C12_MODIFIEDDATE,
	PERSON.UploadCode	 as  C13_UPLOADCODE,
	PERSON.CreatedDate	 as  C14_CREATEDDATE,
	PERSON.IsTeacher	 as  C15_ISTEACHER,
	PERSON.PaymentDate	 as  C16_PAYMENTDATE,
	PERSON.PaymentRec	 as  C17_PAYMENTREC,
	PERSON.Notes	 as  C18_NOTES,
	PERSON.ExternalId	 as  C19_EXTERNALID,
	PERSON.CurrentPortrait	 as  C20_CURRENTPORTRAIT,
	PERSON.OrderOriginId	 as  C21_ORDERORIGINID,
	PERSON.OriginReferenceNumber	 as  C22_ORIGINREFERENCENUMBER,
	PERSON.PackageSchoolPricingId	 as  C23_PACKAGESCHOOLPRICINGID,
	PERSON.EffectivePrice	 as  C24_EFFECTIVEPRICE,
	PERSON.TotalAmount	 as  C25_TOTALAMOUNT,
	PERSON.TotalTax	 as  C26_TOTALTAX,
	PERSON.DonationAmount	 as  C27_DONATIONAMOUNT,
	PERSON.PortraitImageUrl	 as  C28_PORTRAITIMAGEURL,
	PERSON.OrderDate	 as  C29_ORDERDATE,
	PERSON.LastModifiedDate	 as  C30_LASTMODIFIEDDATE,
	PERSON.LastModifiedBy	 as  C31_LASTMODIFIEDBY,
	PERSON.Discount	 as  C32_DISCOUNT,
	PERSON.GradeId	 as  C33_GRADEID,
	PERSON.JobPricingOverrideId	 as  C34_JOBPRICINGOVERRIDEID,
	PERSON.IncludedLine	 as  C35_INCLUDEDLINE,
	PERSON.IncludedIcon	 as  C36_INCLUDEDICON,
	PERSON.CIRId	 as  C37_CIRID,
	PERSON.PortraitPoseEnable	 as  C38_PORTRAITPOSEENABLE,
	PERSON.CurrentPortraitPose	 as  C39_CURRENTPORTRAITPOSE,
	PERSON.CustomerEmail	 as  C40_CUSTOMEREMAIL,
	PERSON.SubjectKey	 as  C41_SUBJECT_KEY
from	<schema_name>.dbo.Person as PERSON, <schema_name>.dbo.Job as JOB
where	(1=1)
And (JOB.JobCode%100 >= 14 AND
((PERSON.CreatedDate >= convert(datetime,SUBSTRING(:v_cdc_load_date, 1, 19),120) - 7.0)
or
(PERSON.ModifiedDate >= convert(datetime,SUBSTRING(:v_cdc_load_date, 1, 19),120) - 7.0)
or
(PERSON.LastModifiedDate >= convert(datetime,SUBSTRING(:v_cdc_load_date, 1, 19),120) - 7.0)))
 And (PERSON.JobId=JOB.JobId)