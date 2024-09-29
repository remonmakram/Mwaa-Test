UPDATE ods_stage.data_export_trigger
SET status = 'READY',
PROCESSED_DATE = SYSDATE
WHERE session_name = '99_SENIOR_SALES_ANALYSIS_PKG'


select *
from ODS_STAGE.data_export_trigger
where session_name = '99_SENIOR_SALES_ANALYSIS_PKG'


select *
from ODS_STAGE.data_export_trigger
where data_export_trigger_id = (select min(data_export_trigger_id)
from ODS_STAGE.data_export_trigger
where session_name = '99_DELAYED_SHIPMENT_PKG'
)


select 	count(*)
from	RAX_APP_USER.ACTUATE_SENIORSAL_SUPPLE_STAGE   ACT_SNG_SUP
where
	(1=1)


select 	count(*)
from	RAX_APP_USER.ACTUATE_SENIORSAL_SUPPLE_STAGE   ACT_SNG_SUP
where
	(1=1)