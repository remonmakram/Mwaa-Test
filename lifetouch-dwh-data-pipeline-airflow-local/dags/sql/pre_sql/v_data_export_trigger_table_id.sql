select min(data_export_trigger_id)
from ODS_STAGE.data_export_trigger
where session_name = :v_session_name
and status = 'READY'