select 	
	ACT.PLANT_NAME	   PLANT_NAME,
	ACT.PROGRAM_NAME	   PROGRAM_NAME,
	ACT.THRU_DATE	   THRU_DATE,
	ACT.CURRENT_YEAR	   CURRENT_YEAR,
	ACT.CY_DTD_PRF	   CY_DTD_PRF,
	ACT.CY_DTD_ORD	   CY_DTD_ORD,
	ACT.PY_DTD_PRF	   PY_DTD_PRF,
	ACT.PY_DTD_ORD	   PY_DTD_ORD,
	ACT.CY_YTD_PRF	   CY_YTD_PRF,
	ACT.CY_YTD_ORD	   CY_YTD_ORD,
	ACT.PY_YTD_PRF	   PY_YTD_PRF,
	ACT.PY_YTD_ORD	   PY_YTD_ORD
from	RAX_APP_USER.ACTUATE_SENIPRF_ORDREL_LAB_STG   ACT
where	
	(1=1)	