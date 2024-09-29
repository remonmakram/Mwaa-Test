select	
	BOOK.BookId	 as  C1_BOOKID,
	BOOK.Name	 as  C2_NAME,
	BOOK.BookStatusId	 as  C3_BOOKSTATUSID,
	BOOK.ReleaseDate	 as  C4_RELEASEDATE,
	BOOK.BookTypeId	 as  C5_BOOKTYPEID,
	BOOK.PreferenceOptionId	 as  C6_PREFERENCEOPTIONID,
	BOOK.YearCode	 as  C7_YEARCODE,
	BOOK.Message	 as  C8_MESSAGE
from	<schema_name>.dbo.Book as BOOK
where	(1=1)