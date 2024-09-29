with data as
(
select p.personid
from <schema_name>.dbo.person p, <schema_name>.dbo.job j
where p.jobid = j.jobid
and j.jobcode%100 >= 14
)
select personid
from data