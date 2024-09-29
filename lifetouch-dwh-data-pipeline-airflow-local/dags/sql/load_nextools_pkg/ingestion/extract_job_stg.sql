with data as
(
select jobcode
from <schema_name>.dbo.job
)
select jobcode
from data