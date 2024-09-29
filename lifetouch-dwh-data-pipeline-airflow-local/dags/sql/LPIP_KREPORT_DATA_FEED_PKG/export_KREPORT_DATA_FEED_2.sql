select 	
	to_char(nvl(sum(KDF.AMOUNT),0),'999999999.99')	   AMOUNT
from	RAX_APP_USER.KREPORT_DATA_FEED   KDF
where	
	(1=1)	
And (KDF.TRANSMIT_DATE is null)