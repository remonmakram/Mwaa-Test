with data as
(
select personid
,bookoptionid
from <schema_name>.dbo.personbookoption
)
select personid
,bookoptionid
from data