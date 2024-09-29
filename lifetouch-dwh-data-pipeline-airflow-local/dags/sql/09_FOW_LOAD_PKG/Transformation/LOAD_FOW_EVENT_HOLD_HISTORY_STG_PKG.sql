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
/* drop stage */

-- drop table RAX_APP_USER.fow_event_hold_stg

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 5 */
-- /* create stage */

-- create table RAX_APP_USER.fow_event_hold_stg
-- ( ID NUMBER NOT NULL
-- , VERSION NUMBER
-- , APO_ID NUMBER
-- , EVENT_ID NUMBER
-- , HOLD_STATUS VARCHAR2(16 BYTE)
-- , HOLD_REASON VARCHAR2(255 BYTE)
-- , CREATED_BY VARCHAR2(255 BYTE)
-- , DATE_CREATED date
-- )

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 6 */
-- /* select and load stage */

-- /* SOURCE CODE */
-- select ID
-- , VERSION
-- , APO_ID
-- , EVENT_ID
-- , HOLD_STATUS
-- , HOLD_REASON
-- , CREATED_BY
-- , DATE_CREATED
-- from fow_own.event_hold_history
-- where date_created >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap

-- &

-- /* TARGET CODE */
-- insert into RAX_APP_USER.fow_event_hold_stg
-- ( ID
-- , VERSION
-- , APO_ID
-- , EVENT_ID
-- , HOLD_STATUS
-- , HOLD_REASON
-- , CREATED_BY
-- , DATE_CREATED
-- )
-- values
-- ( :ID
-- , :VERSION
-- , :APO_ID
-- , :EVENT_ID
-- , :HOLD_STATUS
-- , :HOLD_REASON
-- , :CREATED_BY
-- , :DATE_CREATED
-- )

-- &


/*-----------------------------------------------*/
/* TASK No. 7 */
/* index stage */

BEGIN  
   EXECUTE IMMEDIATE 'create unique index RAX_APP_USER.fow_event_hold_stg_uk on RAX_APP_USER.fow_event_hold_stg(id)';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -955 THEN  
         RAISE;  
      END IF;  
END;


&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* merge to target */

merge into ODS_STAGE.fow_event_hold_history_stg t
using RAX_APP_USER.fow_event_hold_stg s
on (s.id = t.id)
when matched then update
set t.VERSION = s.VERSION
, t.APO_ID = s.APO_ID
, t.EVENT_ID = s.EVENT_ID
, t.HOLD_STATUS = s.HOLD_STATUS
, t.HOLD_REASON = s.HOLD_REASON
, t.CREATED_BY = s.CREATED_BY
, t.DATE_CREATED = s.DATE_CREATED
, t.ods_modify_date = sysdate
where decode(t.VERSION , s.VERSION,1,0) = 0
or decode( t.APO_ID , s.APO_ID,1,0) = 0
or decode(t.EVENT_ID , s.EVENT_ID,1,0) = 0
or decode(t.HOLD_STATUS , s.HOLD_STATUS,1,0) = 0
or decode(t.HOLD_REASON , s.HOLD_REASON,1,0) = 0
or decode(t.CREATED_BY , s.CREATED_BY,1,0) = 0
or decode(t.DATE_CREATED , s.DATE_CREATED,1,0) = 0
when not matched then insert
( t.ID
, t.VERSION
, t.APO_ID
, t.EVENT_ID
, t.HOLD_STATUS
, t.HOLD_REASON
, t.CREATED_BY
, t.DATE_CREATED
, t.ods_modify_date
)
values
( s.ID
, s.VERSION
, s.APO_ID
, s.EVENT_ID
, s.HOLD_STATUS
, s.HOLD_REASON
, s.CREATED_BY
, s.DATE_CREATED
, sysdate
)


&


/*-----------------------------------------------*/
/* TASK No. 9 */
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
/* TASK No. 10 */
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
,'LOAD_FOW_EVENT_HOLD_HISTORY_STG_PKG'
,'001'
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
'LOAD_FOW_EVENT_HOLD_HISTORY_STG_PKG',
'001',
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
