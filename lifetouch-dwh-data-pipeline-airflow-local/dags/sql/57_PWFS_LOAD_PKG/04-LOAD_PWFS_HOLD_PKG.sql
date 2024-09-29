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

MERGE INTO ODS_STAGE.PWFS_HOLD_XR T
USING (
SELECT 
       H.ID AS HOLD_ID	     	,
       WXR.WORK_FLOW_OID	,
       WXR.WORK_FLOW_ID      	,
       H.CREATE_DATE         	,
       H.MODIFIED_DATE
       FROM 
       ODS_STAGE.PWFS_HOLD_STG H,         
       ODS_STAGE.PWFS_WORK_FLOW_XR  WXR         
       WHERE 1 = 1       
       AND H.WORKFLOW_ID = WXR.WORK_FLOW_ID(+)
       AND H.ODS_MODIFY_DATE  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap 
       ) S
       ON (T.HOLD_ID = S.HOLD_ID)
WHEN NOT MATCHED
THEN
   INSERT     
   (   
   HOLD_OID	    	,
   HOLD_ID	    	,	 
   WORK_FLOW_OID	,
   WORK_FLOW_ID 	,
   ODS_CREATE_DATE  	,
   ODS_MODIFY_DATE     	
   )
   VALUES (
               ODS_STAGE.PWFS_HOLD_OID_SEQ.NEXTVAL,               
               S.HOLD_ID        		,   
               S.WORK_FLOW_OID  	,    
               S.WORK_FLOW_ID   	,                  
               SYSDATE          		,
               SYSDATE
          )
WHEN MATCHED
THEN
   UPDATE SET      
      T.WORK_FLOW_OID    	= S.WORK_FLOW_OID,
      T.WORK_FLOW_ID       	= S.WORK_FLOW_ID,      
      T.ODS_MODIFY_DATE     = SYSDATE
      WHERE (    
                decode(S.WORK_FLOW_OID, T.WORK_FLOW_OID, 1, 0) = 0 OR
             	decode(S.WORK_FLOW_ID, T.WORK_FLOW_ID, 1, 0) = 0             	           
            	)

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Merge into Target Table */

MERGE INTO ODS_OWN.PWFS_HOLD T
USING 
( SELECT    
  XR.HOLD_OID           			,       
  XR.WORK_FLOW_OID              		,
   FROM_TZ (CAST (stg.create_date AS TIMESTAMP), 'UTC') AT TIME ZONE :v_data_center_tz AS SRC_CREATE_DATE         	 ,
   FROM_TZ (CAST (stg.modified_date AS TIMESTAMP), 'UTC') AT TIME ZONE :v_data_center_tz AS SRC_MODIFIED_DATE        ,
  STG.VERSION                   		,
  STG.INITIATED_BY              		,
  STG.RELEASED_BY               		,
  FROM_TZ (CAST (stg.released_on AS TIMESTAMP), 'UTC') AT TIME ZONE :v_data_center_tz AS RELEASED_ON        	 ,
  STG.ID AS HOLD_ID		        	,
  STG.WORKFLOW_ID               		, 
  SS.SOURCE_SYSTEM_OID    
  FROM 
   ODS_STAGE.PWFS_HOLD_STG STG,
   ODS_STAGE.PWFS_HOLD_XR XR,                  
   ODS_OWN.SOURCE_SYSTEM  SS
   WHERE 1 = 1
   AND  STG.ID = XR.HOLD_ID   
   AND  SS.SOURCE_SYSTEM_SHORT_NAME = 'PWFS'
   AND  STG.ODS_MODIFY_DATE  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap 
   ) S
    ON (T.HOLD_OID = S.HOLD_OID)
WHEN MATCHED
THEN
  UPDATE SET                       
  T.WORK_FLOW_OID         =  S.WORK_FLOW_OID         ,
  T.SRC_CREATE_DATE       =  S.SRC_CREATE_DATE       ,
  T.SRC_MODIFIED_DATE    =  S.SRC_MODIFIED_DATE   ,
  T.VERSION              	   =  S.VERSION               	  ,
  T.INITIATED_BY         	   =  S.INITIATED_BY           ,
  T.RELEASED_BY          	   =  S.RELEASED_BY            ,
  T.RELEASED_ON          	   =  S.RELEASED_ON           ,
  T.HOLD_ID              	   =  S.HOLD_ID               	   ,
  T.WORK_FLOW_ID             =  S.WORKFLOW_ID         ,
  T.ODS_MODIFY_DATE        =  SYSDATE                 	   ,    
  T.SOURCE_SYSTEM_OID    =  S.SOURCE_SYSTEM_OID        
  WHERE  (DECODE (S.WORK_FLOW_OID, T.WORK_FLOW_OID, 1, 0) = 0
                 OR DECODE (S.SRC_CREATE_DATE, T.SRC_CREATE_DATE, 1, 0) = 0
                 OR DECODE (S.SRC_MODIFIED_DATE, T.SRC_MODIFIED_DATE, 1, 0) = 0
                 OR DECODE (S.VERSION, T.VERSION, 1, 0) = 0
                 OR DECODE (S.INITIATED_BY, T.INITIATED_BY, 1, 0) = 0
                 OR DECODE (S.RELEASED_BY, T.RELEASED_BY, 1, 0) = 0
                 OR DECODE (S.RELEASED_ON, T.RELEASED_ON, 1,0) = 0
                 OR DECODE (S.HOLD_ID, T.HOLD_ID, 1, 0) = 0
                 OR DECODE (S.WORKFLOW_ID, T.WORK_FLOW_ID, 1, 0) = 0                             
                 OR DECODE (S.SOURCE_SYSTEM_OID, T.SOURCE_SYSTEM_OID, 1, 0) = 0                       
            )                                                                                                                                      
WHEN NOT MATCHED
THEN
   INSERT     
   (    
  T.HOLD_OID                            	,
  T.WORK_FLOW_OID              	,
  T.SRC_CREATE_DATE       	,
  T.SRC_MODIFIED_DATE     	,
  T.VERSION                   		,
  T.INITIATED_BY                      	,
  T.RELEASED_BY                       	,
  T.RELEASED_ON           		,
  T.HOLD_ID                           	,
  T.WORK_FLOW_ID                      	,
  T.ODS_CREATE_DATE                     	,
  T.ODS_MODIFY_DATE                     	,
  T.SOURCE_SYSTEM_OID            
    )
       VALUES 
    (   
  S.HOLD_OID                            	,
  S.WORK_FLOW_OID             	,
  S.SRC_CREATE_DATE    		,
  S.SRC_MODIFIED_DATE 		,
  S.VERSION                   		,
  S.INITIATED_BY                      	,
  S.RELEASED_BY                       	,
  S.RELEASED_ON           		,
  S.HOLD_ID                           	,
  S.WORKFLOW_ID                      	,
  SYSDATE                               	,
  SYSDATE                               	,
  S.SOURCE_SYSTEM_OID      
 )

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Handle late arriving WORK_FLOW_OID */

-- Handle late arriving WORK_FLOW_OID

MERGE INTO ODS_OWN.PWFS_HOLD T
USING (
SELECT 
WFLW.WORK_FLOW_OID	,
HOLD.HOLD_OID	,
SYSDATE AS ODS_MODIFY_DATE 
FROM  ODS_OWN.PWFS_HOLD HOLD,
      ODS_STAGE.PWFS_HOLD_XR XR,
      ODS_OWN.PWFS_WORK_FLOW WFLW
WHERE  1 = 1
AND HOLD.HOLD_OID = XR.HOLD_OID
AND XR.WORK_FLOW_ID = WFLW.WORK_FLOW_ID
AND HOLD.ODS_CREATE_DATE > SYSDATE - 7
AND XR.WORK_FLOW_ID IS NOT NULL
AND HOLD.WORK_FLOW_OID IS NULL
AND WFLW.ODS_CREATE_DATE > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) S
ON (T.HOLD_OID = S.HOLD_OID)
WHEN MATCHED THEN UPDATE SET
     T.WORK_FLOW_OID = S.WORK_FLOW_OID,
     T.ODS_MODIFY_DATE = S.ODS_MODIFY_DATE
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
,'LOAD_PWFS_HOLD_PKG'
,'004'
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
'LOAD_PWFS_HOLD_PKG',
'004',
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
