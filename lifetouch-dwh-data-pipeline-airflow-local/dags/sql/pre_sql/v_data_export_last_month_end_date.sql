select
to_char(my_t2.CALENDAR_MONTH_END,'YYYYMMDD') CALENDAR_MONTH_END
from 
MART.TIME my_t
,MART.TIME my_t2
where (1=1) and my_t.DATE_KEY= trunc(sysdate)
and case when my_t.MONTH_NUMBER = 1 then 12 else my_t.MONTH_NUMBER -1 end = my_t2.MONTH_NUMBER
and case when my_t.MONTH_NUMBER = 1 then my_t.CALENDAR_YEAR -1 else my_t.CALENDAR_YEAR end  = my_t2.CALENDAR_YEAR
and my_t2.MONTH_DAY_NUMBER=1