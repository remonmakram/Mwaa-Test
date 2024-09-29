/* TASK No. 1 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 2 */




/*-----------------------------------------------*/
/* TASK No. 3 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 3 */




/*-----------------------------------------------*/
/* TASK No. 4 */
/* Drop driver table */

BEGIN
   EXECUTE IMMEDIATE 'drop table  RAX_APP_USER.TMP_FOWAPO_ORIGBKREP_DRIVER';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Create Driver Table */

CREATE TABLE RAX_APP_USER.TMP_FOWAPO_ORIGBKREP_DRIVER
as
select apo.apo_oid
,apo.apo_id
,f.original_booking_rep
,f.original_booking_rep_name
,f.program as booking_program
from ODS_STAGE.FOW_APO_STAGE    f
      ,ODS_OWN.APO   apo
where apo.school_year >= 2015
and apo.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date,1,19),'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap 
    and apo.apo_oid=f.apo_oid(+)


&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Create unique index */

create unique index  RAX_APP_USER.TMP_FOWAPO_ORIGBKREP_DRIVER_IX
    ON RAX_APP_USER.TMP_FOWAPO_ORIGBKREP_DRIVER
(APO_OID)

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Update original booking rep info on APO */

update  
  (   select apo.original_booking_rep  as old_orig_booking_rep
              ,apo.original_booking_rep_name as old_orig_booking_rep_name
             ,s.original_booking_rep as new_orig_booking_rep
             ,s.original_booking_rep_name as new_orig_booking_rep_name
             ,apo.booking_program as old_booking_program
             ,s.booking_program as new_booking_program
     from   ODS_OWN.APO    apo
              ,RAX_APP_USER.TMP_FOWAPO_ORIGBKREP_DRIVER  s
     where s.apo_oid=apo.apo_oid
          and ( nvl(apo.original_booking_rep,'.')  <>   nvl(s.original_booking_rep,'.')
                      or
                   nvl(apo.original_booking_rep_name,'.') <>  nvl(s.original_booking_rep_name,'.')
                      or 
                   nvl(apo.booking_program,'.')  <>   nvl(s.booking_program,'.')
                )
  )
set old_orig_booking_rep=new_orig_booking_rep
    ,old_orig_booking_rep_name= new_orig_booking_rep_name
    ,old_booking_program = new_booking_program




&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
+ nvl((TIMEZONE_OFFSET/24), 0) 
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

/*
UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Insert CDC Audit Record */

INSERT INTO RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
(TABLE_NAME,
SESS_NO,                      
SESS_NAME,                    
SCEN_VERSION,                 
SESS_BEG,                     
ORIG_LAST_CDC_COMPLETION_DATE,
OVERLAP,
CREATE_DATE,
CONTEXT_NAME,
TIMEZONE_OFFSET              
)
select 
:v_cdc_load_table_name
,:v_sess_no
,'UPDATE_FOW_APO_BASED_DATA_PKG'
,'003'
,TO_DATE(SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
,TO_DATE (SUBSTR(:v_cdc_load_date, 1, 19),'YYYY-MM-DD HH24:MI:SS')
,:v_cdc_overlap
,SYSDATE
,:v_env
,TIMEZONE_OFFSET
from 
ODS_OWN.ODS_CDC_LOAD_STATUS
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

/*
INSERT INTO RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
(TABLE_NAME,
SESS_NO,                      
SESS_NAME,                    
SCEN_VERSION,                 
SESS_BEG,                     
ORIG_LAST_CDC_COMPLETION_DATE,
OVERLAP,
CREATE_DATE,
CONTEXT_NAME              
)
values (
:v_cdc_load_table_name,
:v_sess_no,
'UPDATE_FOW_APO_BASED_DATA_PKG',
'003',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/


&


/*-----------------------------------------------*/
