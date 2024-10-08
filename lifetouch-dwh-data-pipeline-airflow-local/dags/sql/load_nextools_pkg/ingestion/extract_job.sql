select	
	JOB.JOBID	 as  C1_JOBID,
	JOB."BookId"	 as  C2_BOOKID,
	JOB.ORGANIZATIONID	 as  C3_ORGANIZATIONID,
	JOB.JOBSTATUSID	 as  C4_JOBSTATUSID,
	JOB.HARDCOUNT	 as  C5_HARDCOUNT,
	JOB.SOFTCOUNT	 as  C6_SOFTCOUNT,
	JOB.FINALCOUNTSUBMITDATE	 as  C7_FINALCOUNTSUBMITDATE,
	JOB.FINALCOUNTSUBMITUSERID	 as  C8_FINALCOUNTSUBMITUSERID,
	JOB.JOBCODE	 as  C9_JOBCODE,
	JOB.JOBNAME	 as  C10_JOBNAME,
	JOB.MESSAGE	 as  C11_MESSAGE,
	JOB.SCHOOLNAME	 as  C12_SCHOOLNAME,
	JOB.TRIMSIZEID	 as  C13_TRIMSIZEID,
	JOB.PRINTTYPE	 as  C14_PRINTTYPE,
	JOB.EXPORTTOCUSTOMDICTIONARY	 as  C15_EXPORTTOCUSTOMDICTIONARY,
	JOB.YBPAYACTIVATIONDATE	 as  C16_YBPAYACTIVATIONDATE,
	JOB.YBPAYCLOSEDATE	 as  C17_YBPAYCLOSEDATE,
	JOB.ISTAXABLE	 as  C18_ISTAXABLE,
	JOB.TAXRATE	 as  C19_TAXRATE,
	JOB."PricingLastModifedDate"	 as  C20_PRICINGLASTMODIFEDDATE,
	JOB.ADVERTISEMENTPURCHASEBYDATE	 as  C21_ADVERTISEMENTPURCHASEBYDAT,
	JOB.ADVERTISEMENTSUBMITBYDATE	 as  C22_ADVERTISEMENTSUBMITBYDATE,
	JOB.ISADBUILDERENABLED	 as  C23_ISADBUILDERENABLED
from	<schema_name>.dbo.Job as JOB
where	(1=1)