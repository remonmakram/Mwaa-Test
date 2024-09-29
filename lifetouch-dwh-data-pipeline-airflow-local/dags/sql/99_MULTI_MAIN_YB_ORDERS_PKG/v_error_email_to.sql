select listagg(email_address, ',') within group (order by email_address)
from odi_email_to
WHERE package_name ='99_MULTI_MAIN_YB_ORDERS_PKG'  AND status = 'A'