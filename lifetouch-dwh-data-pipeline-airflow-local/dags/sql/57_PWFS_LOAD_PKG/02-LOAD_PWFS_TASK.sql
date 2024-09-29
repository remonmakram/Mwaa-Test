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
/* Merge into XR Table */

MERGE INTO ODS_STAGE.PWFS_TASK_XR T
USING (
SELECT 
       W.ID AS TASK_ID		,
       WXR.WORK_FLOW_OID	,
       W.WORKFLOW_ID AS WORK_FLOW_ID,
       E.EVENT_OID		,
       W.TASK_ALIAS		,
       W.CREATE_DATE		,
       W.MODIFIED_DATE
       FROM 
       ODS_STAGE.PWFS_TASK_STG W,  
       ODS_OWN.EVENT E,
       ODS_STAGE.PWFS_WORK_FLOW_XR  WXR         
       WHERE 1 = 1
       AND W.TASK_ALIAS = E.EVENT_REF_ID(+)
       and W.WORKFLOW_ID = WXR.WORK_FLOW_ID(+)
       AND W.ODS_MODIFY_DATE  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap 
       ) S
       ON (T.TASK_ID = S.TASK_ID)
WHEN NOT MATCHED
THEN
   INSERT     
   (   
   TASK_OID	    	,
   TASK_ID	    	,	 
   WORK_FLOW_OID	,
   WORK_FLOW_ID 	,
   EVENT_OID    	,
   TASK_ALIAS       	,  
   ODS_CREATE_DATE  	,
   ODS_MODIFY_DATE     	
   )
   VALUES (
               ODS_STAGE.PWFS_TASK_OID_SEQ.NEXTVAL,               
               S.TASK_ID        		,   
               S.WORK_FLOW_OID  	,    
               S.WORK_FLOW_ID   	,
               S.EVENT_OID      	,
               S.TASK_ALIAS     	,                       
               SYSDATE          		,
               SYSDATE
          )
WHEN MATCHED
THEN
   UPDATE SET
      T.WORK_FLOW_OID   = S.WORK_FLOW_OID,
      T.WORK_FLOW_ID    	= S.WORK_FLOW_ID,
      T.EVENT_OID       	= S.EVENT_OID,
      T.TASK_ALIAS      	= S.TASK_ALIAS,
      T.ODS_MODIFY_DATE = SYSDATE
      WHERE ( decode(S.WORK_FLOW_OID, T.WORK_FLOW_OID, 1, 0) = 0 OR 
 	decode(S.WORK_FLOW_ID, T.WORK_FLOW_ID, 1, 0) = 0 OR
             	decode(S.EVENT_OID, T.EVENT_OID, 1, 0) = 0 OR
             	decode(S.TASK_ALIAS, T.TASK_ALIAS, 1, 0) = 0              
            	)

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Merge into Target Table */

MERGE INTO ODS_OWN.PWFS_TASK T
USING 
( SELECT    
  XR.TASK_OID           		,     
  STG.ID AS TASK_ID		,
  XR.WORK_FLOW_OID     	,    
  XR.EVENT_OID          		, 
  STG.VERSION           		,      
  FROM_TZ (CAST (stg.assigned_on AS TIMESTAMP), 'UTC') AT TIME ZONE :v_data_center_tz AS  ASSIGNED_ON,       	 
  STG.AWS_TASK_QUEUE_ID 	,  
  FROM_TZ (CAST (stg.completed_on AS TIMESTAMP), 'UTC') AT TIME ZONE :v_data_center_tz AS COMPLETED_ON,     
  STG.DURATION_IN_MILLIS	,  
  STG.NO_OF_WORK_UNITS  	,  
  STG.PROCESSED         		, 
  STG.PROCESSED_BY      		,  
  STG.RETRY_COUNT       			,  
  STG.STATUS            			,  
  STG.TASK_ALIAS        			,  
  STG.TASK_TYPE         			,	  
  STG.WORKFLOW_ID WORK_FLOW_ID   	,  
  STG.TASK_DATA         		   	,  
  STG.FAILURE_REASON    	   	,  
  FROM_TZ (CAST (stg.create_date AS TIMESTAMP), 'UTC') AT TIME ZONE :v_data_center_tz AS SRC_CREATE_DATE,         	 
  FROM_TZ (CAST (stg.modified_date AS TIMESTAMP), 'UTC') AT TIME ZONE :v_data_center_tz AS SRC_MODIFY_DATE,    
  SS.SOURCE_SYSTEM_OID    
  FROM 
   ODS_STAGE.PWFS_TASK_STG STG,
   ODS_STAGE.PWFS_TASK_XR XR,                  
   ODS_OWN.SOURCE_SYSTEM  SS
   WHERE 1 = 1
   AND  STG.ID = XR.TASK_ID   
   AND  SS.SOURCE_SYSTEM_SHORT_NAME = 'PWFS'
   AND  STG.ODS_MODIFY_DATE  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap 
   ) S
    ON (T.TASK_OID = S.TASK_OID)
WHEN MATCHED
THEN
  UPDATE SET                       
  T.WORK_FLOW_OID         =   S.WORK_FLOW_OID,  
  T.EVENT_OID          	  =   S.EVENT_OID,
  T.VERSION            	  =   S.VERSION,
  T.ASSIGNED_ON        	  =   S.ASSIGNED_ON,
  T.AWS_TASK_QUEUE_ID   =   S.AWS_TASK_QUEUE_ID,
  T.COMPLETED_ON       	   =   S.COMPLETED_ON,
  T.DURATION_IN_MILLIS    =   S.DURATION_IN_MILLIS,
  T.NO_OF_WORK_UNITS    =   S.NO_OF_WORK_UNITS,
  T.PROCESSED          	   =   S.PROCESSED,
  T.PROCESSED_BY       	   =   S.PROCESSED_BY,
  T.RETRY_COUNT        	   =   S.RETRY_COUNT,
  T.STATUS             	   =   S.STATUS,
  T.TASK_ALIAS         	   =   S.TASK_ALIAS,
  T.TASK_TYPE          	   =   S.TASK_TYPE,
  T.WORK_FLOW_ID       	   =   S.WORK_FLOW_ID,
  T.TASK_DATA          	   =   S.TASK_DATA,
  T.FAILURE_REASON     	   =   S.FAILURE_REASON,
  T.SRC_CREATE_DATE        =   S.SRC_CREATE_DATE,
  T.SRC_MODIFY_DATE        =   S.SRC_MODIFY_DATE,
  T.ODS_MODIFY_DATE        =   SYSDATE,
  T.SOURCE_SYSTEM_OID    =   S.SOURCE_SYSTEM_OID
  WHERE  (DECODE (S.WORK_FLOW_OID, T.WORK_FLOW_OID, 1, 0) = 0
                 OR DECODE (S.EVENT_OID, T.EVENT_OID, 1, 0) = 0
                 OR DECODE (S.VERSION, T.VERSION, 1, 0) = 0
                 OR DECODE (S.ASSIGNED_ON, T.ASSIGNED_ON, 1, 0) = 0
                 OR DECODE (S.AWS_TASK_QUEUE_ID, T.AWS_TASK_QUEUE_ID, 1, 0) = 0
                 OR DECODE (S.COMPLETED_ON, T.COMPLETED_ON, 1, 0) = 0
                 OR DECODE (S.DURATION_IN_MILLIS, T.DURATION_IN_MILLIS, 1,0) = 0
                 OR DECODE (S.NO_OF_WORK_UNITS, T.NO_OF_WORK_UNITS, 1, 0) = 0
                 OR DECODE (S.PROCESSED, T.PROCESSED, 1, 0) = 0            
                 OR DECODE (S.PROCESSED_BY, T.PROCESSED_BY, 1, 0) = 0
                 OR DECODE (S.RETRY_COUNT, T.RETRY_COUNT, 1, 0) = 0      
                 OR DECODE (S.STATUS, T.STATUS, 1, 0) = 0      
                 OR DECODE (S.TASK_ALIAS, T.TASK_ALIAS, 1, 0) = 0
                 OR DECODE (S.TASK_TYPE, T.TASK_TYPE, 1, 0) = 0
                 OR DECODE (S.WORK_FLOW_ID, T.WORK_FLOW_ID, 1, 0) = 0
                 OR DECODE (S.TASK_DATA, T.TASK_DATA, 1, 0) = 0
                 OR DECODE (S.FAILURE_REASON, T.FAILURE_REASON, 1, 0) = 0
                 OR DECODE (S.SRC_CREATE_DATE, T.SRC_CREATE_DATE, 1, 0) = 0
                 OR DECODE (S.SRC_MODIFY_DATE, T.SRC_MODIFY_DATE, 1, 0) = 0                           
                 OR DECODE (S.SOURCE_SYSTEM_OID, T.SOURCE_SYSTEM_OID, 1, 0) = 0
            )                                                                                                                                      
WHEN NOT MATCHED
THEN
   INSERT     
   (    
  T.TASK_OID            	  ,
  T.TASK_ID 		  ,
  T.WORK_FLOW_OID         ,
  T.EVENT_OID           	  ,
  T.VERSION             	  ,
  T.ASSIGNED_ON         	  ,
  T.AWS_TASK_QUEUE_ID  ,
  T.COMPLETED_ON        	  ,
  T.DURATION_IN_MILLIS   ,
  T.NO_OF_WORK_UNITS   ,
  T.PROCESSED           	  ,
  T.PROCESSED_BY        	,
  T.RETRY_COUNT         	,
  T.STATUS              	,
  T.TASK_ALIAS          	,
  T.TASK_TYPE           	,
  T.WORK_FLOW_ID        	,
  T.TASK_DATA           	,
  T.FAILURE_REASON       ,
  T.SRC_CREATE_DATE     ,
  T.SRC_MODIFY_DATE     ,
  T.ODS_CREATE_DATE     ,
  T.ODS_MODIFY_DATE     ,
  T.SOURCE_SYSTEM_OID    	                
    )
       VALUES 
    (   
  S.TASK_OID            	  ,
  S.TASK_ID 		  ,
  S.WORK_FLOW_OID         ,
  S.EVENT_OID           	  ,
  S.VERSION             	  ,
  S.ASSIGNED_ON         	  ,
  S.AWS_TASK_QUEUE_ID  ,
  S.COMPLETED_ON        	  ,
  S.DURATION_IN_MILLIS   ,
  S.NO_OF_WORK_UNITS   ,
  S.PROCESSED           	  ,
  S.PROCESSED_BY        	  ,
  S.RETRY_COUNT         	  ,
  S.STATUS              	  ,
  S.TASK_ALIAS         	  ,
  S.TASK_TYPE            	  ,
  S.WORK_FLOW_ID        	  ,
  S.TASK_DATA           	  ,
  S.FAILURE_REASON          ,
  S.SRC_CREATE_DATE       ,
  S.SRC_MODIFY_DATE       ,
  SYSDATE               	  ,
  SYSDATE               	  , 
  S.SOURCE_SYSTEM_OID    
 )

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Handle late arriving WORK_FLOW_OID */

-- Handle late arriving WORK_FLOW_OID

MERGE INTO ODS_OWN.PWFS_TASK T
USING (
SELECT 
WFLW.WORK_FLOW_OID,
TASK.TASK_OID,
SYSDATE AS ODS_MODIFY_DATE 
FROM  ODS_OWN.PWFS_TASK TASK,
           ODS_STAGE.PWFS_TASK_XR XR,
           ODS_OWN.PWFS_WORK_FLOW WFLW
WHERE  1 = 1
AND TASK.TASK_OID = XR.TASK_OID
AND XR.WORK_FLOW_ID = WFLW.WORK_FLOW_ID
AND TASK.ODS_CREATE_DATE > SYSDATE - 3
AND XR.WORK_FLOW_ID IS NOT NULL
AND TASK.WORK_FLOW_OID IS NULL
AND WFLW.ODS_CREATE_DATE > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) S
ON (T.TASK_OID = S.TASK_OID)
WHEN MATCHED THEN UPDATE SET
     T.WORK_FLOW_OID = S.WORK_FLOW_OID
    ,T.ODS_MODIFY_DATE = S.ODS_MODIFY_DATE
WHERE 
decode(S.WORK_FLOW_OID,T.WORK_FLOW_OID,1,0) = 0

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
,'LOAD_PWFS_TASK'
,'008'
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
'LOAD_PWFS_TASK',
'008',
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
