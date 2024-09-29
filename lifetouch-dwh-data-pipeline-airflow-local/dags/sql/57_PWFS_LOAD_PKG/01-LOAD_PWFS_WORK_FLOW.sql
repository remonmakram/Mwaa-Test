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

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 4 */




/*-----------------------------------------------*/
/* TASK No. 5 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 5 */




/*-----------------------------------------------*/
/* TASK No. 6 */
/* Merge into XR Table - ODS_STAGE.PWFS_WORK_FLOW_XR */

MERGE INTO ODS_STAGE.PWFS_WORK_FLOW_XR T
USING (
SELECT 
       W.ID		,
       W.PARENT_ID	,
       W.CREATE_DATE	,
       W.MODIFIED_DATE
       FROM 
       ODS_STAGE.PWFS_WORK_FLOW_STG W            
       WHERE 1 = 1
       AND W.ODS_MODIFY_DATE  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap 
       ) S
       ON (T.WORK_FLOW_ID = S.ID)
WHEN NOT MATCHED
THEN
   INSERT     
   (   
   WORK_FLOW_OID	,
   WORK_FLOW_ID	, 
   PARENT_ID        	,  
   ODS_CREATE_DATE  	,
   ODS_MODIFY_DATE     	
   )
   VALUES (
               ODS_STAGE.PWFS_WORK_FLOW_OID_SEQ.NEXTVAL,
               S.ID,   
               S.PARENT_ID,                              
               SYSDATE,
               SYSDATE
          )
WHEN MATCHED
THEN
   UPDATE SET
      T.PARENT_ID = S.PARENT_ID,
      T.ODS_MODIFY_DATE = SYSDATE
      WHERE decode(S.PARENT_ID, T.PARENT_ID, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Merge into Target Table -  ODS_OWN.PWFS_WORK_FLOW */

  
MERGE INTO ODS_OWN.PWFS_WORK_FLOW T
USING 
(SELECT 
   XR.WORK_FLOW_OID  	           	,    
   STG.ID AS  WORK_FLOW_ID          	,
   STG.VERSION                     	,
   STG.SOURCE_SYSTEM_IDENTIFIER_1 ,
   STG.SOURCE_SYSTEM_IDENTIFIER_2 ,
   STG.SOURCE_SYSTEM_IDENTIFIER_3 ,
   STG.SOURCE_SYSTEM_IDENTIFIER_4 ,
   STG.STATUS                      	,
   STG.WORK_FLOW_TYPE              	,
   STG.PARENT_ID                   	,
   STG.ENABLE_RECORDING            	,
   STG.AUTO_COMPLETE               	,
   STG.AUTO_TRANSITION_TO          	,
   FROM_TZ (CAST (stg.create_date AS TIMESTAMP), 'UTC') AT TIME ZONE :v_data_center_tz AS SRC_CREATE_DATE         	 ,
   FROM_TZ (CAST (stg.modified_date AS TIMESTAMP), 'UTC') AT TIME ZONE :v_data_center_tz AS SRC_MODIFIED_DATE        ,
stg.source_system_identifier_5,
stg.source_system_identifier_6,
stg.lock_id,
stg.success_callback_url,
stg.failure_callback_url,
stg.callback_http_method,
stg.callback_success,
stg.user_task_allocation_id,
stg.prioritized,
FROM_TZ (CAST (stg.prioritized_on AS TIMESTAMP), 'UTC') AT TIME ZONE :v_data_center_tz AS prioritized_on,   
SS.SOURCE_SYSTEM_OID,
stg.specialized,   
stg.business_line,
stg.program,
e.event_oid,
FROM_TZ (CAST (stg.event_prioritization_date AS TIMESTAMP), 'UTC') AT TIME ZONE :v_data_center_tz AS event_prioritization_date   
   FROM 
   ODS_STAGE.PWFS_WORK_FLOW_STG STG,
   ODS_STAGE.PWFS_WORK_FLOW_XR XR,                  
   ODS_OWN.SOURCE_SYSTEM  SS,
   ODS_OWN.EVENT E
   WHERE 1 = 1
   AND  STG.ID = XR.WORK_FLOW_ID   
   AND  SS.SOURCE_SYSTEM_SHORT_NAME = 'PWFS' 
   AND  STG.event_id = e.event_ref_id(+)
   AND  STG.ODS_MODIFY_DATE  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap 
   ) S
    ON (T.WORK_FLOW_OID = S.WORK_FLOW_OID)
WHEN MATCHED
THEN
   UPDATE SET            
  T.VERSION                     	                  =   S.VERSION                   ,
  T.SOURCE_SYSTEM_IDENTIFIER_1  =   S.SOURCE_SYSTEM_IDENTIFIER_1,
  T.SOURCE_SYSTEM_IDENTIFIER_2  =   S.SOURCE_SYSTEM_IDENTIFIER_2,
  T.SOURCE_SYSTEM_IDENTIFIER_3  =   S.SOURCE_SYSTEM_IDENTIFIER_3,
  T.SOURCE_SYSTEM_IDENTIFIER_4  =   S.SOURCE_SYSTEM_IDENTIFIER_4,
  T.STATUS                      	       =   S.STATUS                    	,
  T.WORK_FLOW_TYPE             =   S.WORK_FLOW_TYPE            	,
  T.PARENT_ID                          =   S.PARENT_ID                 	,
  T.ENABLE_RECORDING          =   S.ENABLE_RECORDING          	,
  T.AUTO_COMPLETE                =   S.AUTO_COMPLETE             	,
  T.AUTO_TRANSITION_TO      =   S.AUTO_TRANSITION_TO        	,
  T.SRC_CREATE_DATE            =   S.SRC_CREATE_DATE           	,
  T.SRC_MODIFIED_DATE         =   S.SRC_MODIFIED_DATE         	,  
  T.ODS_MODIFY_DATE            =   SYSDATE                     	,
t.source_system_identifier_5 = s.source_system_identifier_5  ,
t.source_system_identifier_6 = s.source_system_identifier_6  ,
t.lock_id = s.lock_id  ,
t.success_callback_url = s.success_callback_url  ,
t.failure_callback_url = s.failure_callback_url  ,
t.callback_http_method = s.callback_http_method  ,
t.callback_success = s.callback_success  ,
t.user_task_allocation_id = s.user_task_allocation_id  ,
t.prioritized = s.prioritized  ,
t.prioritized_on = s.prioritized_on  ,
 T.SOURCE_SYSTEM_OID        =   S.SOURCE_SYSTEM_OID,
t.specialized = s.specialized,   
t.business_line = s.business_line,
t.program = s.program,
t.event_oid = s.event_oid,
t.event_prioritization_date    = s.event_prioritization_date  	
   WHERE  DECODE (S.VERSION, T.VERSION, 1, 0) = 0
                 OR DECODE (S.SOURCE_SYSTEM_IDENTIFIER_1, T.SOURCE_SYSTEM_IDENTIFIER_1, 1, 0) = 0
                 OR DECODE (S.SOURCE_SYSTEM_IDENTIFIER_2, T.SOURCE_SYSTEM_IDENTIFIER_2, 1, 0) = 0
                 OR DECODE (S.SOURCE_SYSTEM_IDENTIFIER_3, T.SOURCE_SYSTEM_IDENTIFIER_3, 1, 0) = 0
                 OR DECODE (S.SOURCE_SYSTEM_IDENTIFIER_4, T.SOURCE_SYSTEM_IDENTIFIER_4, 1, 0) = 0
                 OR DECODE (S.STATUS, T.STATUS, 1, 0) = 0
                 OR DECODE (S.WORK_FLOW_TYPE, T.WORK_FLOW_TYPE, 1,0) = 0
                 OR DECODE (S.PARENT_ID, T.PARENT_ID, 1, 0) = 0
                 OR DECODE (S.ENABLE_RECORDING, T.ENABLE_RECORDING, 1, 0) = 0            
                 OR DECODE (S.AUTO_COMPLETE, T.AUTO_COMPLETE, 1, 0) = 0
                 OR DECODE (S.AUTO_TRANSITION_TO, T.AUTO_TRANSITION_TO, 1, 0) = 0      
                 OR DECODE (S.SRC_CREATE_DATE, T.SRC_CREATE_DATE, 1, 0) = 0      
                 OR DECODE (S.SRC_MODIFIED_DATE, T.SRC_MODIFIED_DATE, 1, 0) = 0           
                 OR DECODE (s.source_system_identifier_5, t.source_system_identifier_5  ,1, 0) = 0
                 OR DECODE (s.source_system_identifier_6, t.source_system_identifier_6  ,1, 0) = 0
                 OR DECODE (s.lock_id, t.lock_id  ,1, 0) = 0
                 OR DECODE (s.success_callback_url, t.success_callback_url  ,1, 0) = 0
                 OR DECODE (s.failure_callback_url, t.failure_callback_url  ,1, 0) = 0
                 OR DECODE (s.callback_http_method, t.callback_http_method  ,1, 0) = 0
                 OR DECODE (s.callback_success, t.callback_success  ,1, 0) = 0
                 OR DECODE (s.user_task_allocation_id, t.user_task_allocation_id  ,1, 0) = 0
                 OR DECODE (s.prioritized, t.prioritized  ,1, 0) = 0
                 OR DECODE (s.prioritized_on, t.prioritized_on  ,1, 0) = 0            
                 OR DECODE (S.SOURCE_SYSTEM_OID, T.SOURCE_SYSTEM_OID, 1, 0) = 0     
                 OR DECODE (s.specialized, t.specialized  ,1, 0) = 0   
                 OR DECODE (s.business_line, t.business_line  ,1, 0) = 0     
                 OR DECODE (s.program, t.program  ,1, 0) = 0     
                 OR DECODE (s.event_oid, t.event_oid  ,1, 0) = 0   
                 OR DECODE (s.event_prioritization_date, t.event_prioritization_date  ,1, 0) = 0                                      
 WHEN NOT MATCHED THEN INSERT     
   (    
  T.WORK_FLOW_OID                 	,     
  T.WORK_FLOW_ID	       	,
  T.VERSION                       	,
  T.SOURCE_SYSTEM_IDENTIFIER_1    	,
  T.SOURCE_SYSTEM_IDENTIFIER_2    	,
  T.SOURCE_SYSTEM_IDENTIFIER_3    	,
  T.SOURCE_SYSTEM_IDENTIFIER_4    	,
  T.STATUS                        		,
  T.WORK_FLOW_TYPE               	,
  T.PARENT_ID                     	,
  T.ENABLE_RECORDING              	,
  T.AUTO_COMPLETE                 	,
  T.AUTO_TRANSITION_TO            	,
  T.SRC_CREATE_DATE               	,
  T.SRC_MODIFIED_DATE             	,
  T.ODS_CREATE_DATE               	,
  T.ODS_MODIFY_DATE               	,
t.source_system_identifier_5,
t.source_system_identifier_6,
t.lock_id,
t.success_callback_url,
t.failure_callback_url,
t.callback_http_method,
t.callback_success,
t.user_task_allocation_id,
t.prioritized,
t.prioritized_on,
T.SOURCE_SYSTEM_OID,  
t.specialized,   
t.business_line,
t.program,
t.event_oid,
t.event_prioritization_date                     	                
    )
       VALUES 
    (   
  S.WORK_FLOW_OID                 	,     
  S.WORK_FLOW_ID	       	,	      
  S.VERSION                       	,
  S.SOURCE_SYSTEM_IDENTIFIER_1    	,
  S.SOURCE_SYSTEM_IDENTIFIER_2    	,
  S.SOURCE_SYSTEM_IDENTIFIER_3    	,
  S.SOURCE_SYSTEM_IDENTIFIER_4    	,
  S.STATUS                        		,
  S.WORK_FLOW_TYPE                	,
  S.PARENT_ID                     	,
  S.ENABLE_RECORDING              	,
  S.AUTO_COMPLETE                 	,
  S.AUTO_TRANSITION_TO            	,
  S.SRC_CREATE_DATE               	,
  S.SRC_MODIFIED_DATE             	,
  SYSDATE                         		,
  SYSDATE                        	 	,
s.source_system_identifier_5,
s.source_system_identifier_6,
s.lock_id,
s.success_callback_url,
s.failure_callback_url,
s.callback_http_method,
s.callback_success,
s.user_task_allocation_id,
s.prioritized,
s.prioritized_on,	
S.SOURCE_SYSTEM_OID  ,
s.specialized,   
s.business_line,
s.program,
s.event_oid,
s.event_prioritization_date                      	    
 )

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
,'LOAD_PWFS_WORK_FLOW'
,'009'
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
'LOAD_PWFS_WORK_FLOW',
'009',
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
