select
case
when MONTHS_BETWEEN(trunc(sysdate,'MM'), trunc(sysdate,'YY')) <= 7
then to_number(to_char(sysdate,'YYYY'))
else to_number(to_char(sysdate,'YYYY')) + 1
end fy_start
from dual