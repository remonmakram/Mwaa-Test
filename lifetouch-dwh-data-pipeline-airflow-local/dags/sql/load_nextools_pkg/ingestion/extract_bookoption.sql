select	
	BOOKOPTION.BookOptionId	 as  C1_BOOKOPTIONID,
	BOOKOPTION.Description	 as  C2_DESCRIPTION,
	BOOKOPTION.Name	 as  C3_NAME,
	BOOKOPTION.BookOptionType	 as  C4_BOOKOPTIONTYPE,
	BOOKOPTION.DisplayOrder	 as  C5_DISPLAYORDER
from	<schema_name>.dbo.BookOption as BOOKOPTION
where	(1=1)