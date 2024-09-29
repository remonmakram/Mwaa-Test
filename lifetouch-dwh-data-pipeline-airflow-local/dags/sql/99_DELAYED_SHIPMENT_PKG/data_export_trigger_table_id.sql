select min(data_export_trigger_id)
from ODS_STAGE.data_export_trigger
where session_name = '99_DELAYED_SHIPMENT_PKG'
and status = 'READY'