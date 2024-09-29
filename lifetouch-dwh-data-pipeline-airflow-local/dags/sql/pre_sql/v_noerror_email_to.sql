select listagg(email_address, ',') within group (order by email_address) AS email_col
from ODS_APP_USER.odi_email_to
WHERE package_name = :v_package_name  AND status = 'A'
AND send_when_no_errors = 'Y'