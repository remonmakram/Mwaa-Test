UPDATE ODS.DW_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE DW_TABLE_NAME=:v_cdc_load_table_name

&

INSERT INTO ODS_ETL_OWNER.DW_CDC_LOAD_STATUS_AUDIT
(TABLE_NAME,
SESS_NO,                      
SESS_NAME,                    
SCEN_VERSION,                 
SESS_BEG,                     
ORIG_LAST_CDC_COMPLETION_DATE,
OVERLAP,
CREATE_DATE              
)
values (
:v_cdc_load_table_name,
:v_sess_no,
'PROCESS_X1WO_WOMS_ISSUES_PKG',
'002',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date_ODS_DM, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          ),
:v_cdc_overlap,
SYSDATE)

&