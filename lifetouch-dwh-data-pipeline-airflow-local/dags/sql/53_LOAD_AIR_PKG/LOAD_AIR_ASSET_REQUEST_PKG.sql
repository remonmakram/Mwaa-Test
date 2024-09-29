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
/* Merge into XR */

MERGE INTO ODS_STAGE.AIR_ASSET_REQUEST_XR T
USING (
SELECT STG.ID,       
       STG.ASSET_ID,
       PIB_XR.EVENT_ID
       FROM 
             ODS_STAGE.AIR_ASSET_REQUEST_STG STG,                        
             ODS_STAGE.AIR_ASSET_XR ASSET_XR,
             ODS_STAGE.AIR_PHOTO_IMPORT_BATCH_XR PIB_XR          
         WHERE 1 = 1
         AND STG.ASSET_ID = ASSET_XR.ID(+)
         AND ASSET_XR.PHOTO_IMPORT_BATCH_ID = PIB_XR.ID(+)
         AND STG.ODS_MODIFY_DATE  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap 
       ) S
       ON (S.ID = T.ID)
WHEN NOT MATCHED
THEN
    INSERT 
          ( ASSET_REQUEST_OID,
            ID,                          
            ASSET_ID,
            EVENT_ID,
            ods_create_date,
            ods_modify_date)
       VALUES (ODS_STAGE.AIR_ASSET_REQUEST_OID_SEQ.NEXTVAL,
               S.ID, 
               S.ASSET_ID,              
               S.EVENT_ID,               
               SYSDATE,
               SYSDATE)
WHEN MATCHED
THEN
   UPDATE SET
      T.ASSET_ID = S.ASSET_ID,
      T.EVENT_ID = S.EVENT_ID,
      T.ODS_MODIFY_DATE = SYSDATE
      WHERE decode(S.ASSET_ID, T.ASSET_ID, 1, 0) = 0
                   OR decode(S.EVENT_ID, T.EVENT_ID, 1, 0) = 0                        

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Merge into ODS_OWN.AIR_ASSET_REQUEST */




MERGE INTO ODS_OWN.AIR_ASSET_REQUEST T
USING 
(SELECT 
   XR.ASSET_REQUEST_OID  	,     
   STG.id                     	    	,
   STG.EVENT_ID             	    	,
   E.EVENT_OID               	    	,   	 
   ASSET_XR.ASSET_OID                   	,
   STG.source_system_identifier     	, 	 
   STG.status             	        	,   
   STG.created_by          	        	,  
   STG.request_type        	        	,	 
   STG.operator_id          	        	, 
   STG.failure_reason               	,   
   STG.create_date                  	,                  
   STG.modified_date                	,
   STG.version                      	,
   STG.ODS_CREATE_DATE              	,       
   STG.ODS_MODIFY_DATE              	,        
   SS.SOURCE_SYSTEM_OID            
, stg.requires_specialist
, stg.operator_duration
, stg.no_of_iterations
   FROM 
   ODS_STAGE.AIR_ASSET_REQUEST_STG STG,
   ODS_STAGE.AIR_ASSET_REQUEST_XR XR,
   ODS_OWN.EVENT E,
   ODS_STAGE.AIR_ASSET_XR ASSET_XR,              
   ODS_OWN.SOURCE_SYSTEM  SS
   WHERE 1 = 1
   AND  STG.ID = XR.ID
   AND  XR.EVENT_ID = E.EVENT_REF_ID(+)
   AND  XR.ASSET_ID = ASSET_XR.ID(+)
   AND  SS.SOURCE_SYSTEM_SHORT_NAME = 'AIR'
   AND  STG.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - 1
   ) S
    ON (T.ASSET_REQUEST_OID = S.ASSET_REQUEST_OID)
WHEN MATCHED
THEN
   UPDATE SET                  
    T.event_id 	        	=	S.event_id                            ,
    T.EVENT_OID         		=	S.EVENT_OID                        ,
    T.asset_oid		=	S.asset_oid                           ,
    T.source_system_identifier	=	S.source_system_identifier  ,
    T.status 			=	S.status                        	,
    T.created_by 		=	S.created_by                    	,
    T.request_type 		=	S.request_type                  , 
    T.operator_id 		=	S.operator_id           	,
    T.failure_reason    		=	S.failure_reason                ,
    T.create_date 		=	S.create_date                    ,
    T.modified_date 		=	S.modified_date                 ,
    T.version			=	S.version                       	,    
    T.ODS_CREATE_DATE  	 	=	S.ODS_CREATE_DATE               ,
    T.ODS_MODIFY_DATE  	 	=	S.ODS_MODIFY_DATE               ,
    T.SOURCE_SYSTEM_OID   	=	S.SOURCE_SYSTEM_OID           	
, t.requires_specialist = s.requires_specialist
, t.operator_duration = s.operator_duration
, t.no_of_iterations = s.no_of_iterations	        	
   WHERE  DECODE (S.event_id, T.event_id, 1, 0) = 0
                 OR DECODE (S.event_oid, T.event_oid, 1, 0) = 0
                 OR DECODE (S.asset_oid, T.asset_oid, 1, 0) = 0                 
                 OR DECODE (S.source_system_identifier, T.source_system_identifier, 1, 0) = 0
                 OR DECODE (S.status, T.status, 1, 0) = 0
                 OR DECODE (S.created_by, T.created_by, 1, 0) = 0
                 OR DECODE (S.request_type, T.request_type, 1, 0) = 0
                 OR DECODE (S.operator_id, T.operator_id, 1, 0) = 0
                 OR DECODE (S.failure_reason, T.failure_reason, 1, 0) = 0
                 OR DECODE (S.create_date, T.create_date, 1, 0) = 0                 
                 OR DECODE (S.modified_date, T.modified_date, 1,0) = 0
                 OR DECODE (S.version, T.version, 1, 0) = 0                                                      
                 OR DECODE (S.source_system_oid, T.source_system_oid, 1, 0) = 0                                                                                    OR DECODE (S.requires_specialist, T.requires_specialist, 1, 0) = 0         
                 OR DECODE (S.operator_duration, T.operator_duration, 1, 0) = 0   
                 OR DECODE (S.no_of_iterations, T.no_of_iterations, 1, 0) = 0                                             
WHEN NOT MATCHED
THEN
   INSERT     
   (    
    T.ASSET_REQUEST_OID           	,
    T.ID                            		,
    T.event_id                      	,
    T.EVENT_OID                     	,
    T.asset_oid                     	,
    T.source_system_identifier      	,
    T.status                        		,
    T.created_by                    	, 
    T.request_type                	,  
    T.operator_id           	        	,
    T.failure_reason                	, 
    T.create_date                   	,
    T.modified_date                 	, 
    T.version                      	 	,               
    T.ODS_CREATE_DATE               	,
    T.ODS_MODIFY_DATE               	, 
    T.SOURCE_SYSTEM_OID  
, T.requires_specialist
, T.operator_duration
, T.no_of_iterations                  	               
    )
       VALUES 
    (   
    S.ASSET_REQUEST_OID           	,
    S.ID                            		,
    S.event_id                      	,
    S.EVENT_OID                     	,
    S.asset_oid                     	,
    S.source_system_identifier      	,
    S.status                        		,
    S.created_by                 	, 
    S.request_type                  	, 
    S.operator_id           	        	,
    S.failure_reason                	,    
    S.create_date                   	,
    S.modified_date                 	, 
    S.version                       		,              
    SYSDATE                         	,
    SYSDATE                         	, 
    S.SOURCE_SYSTEM_OID            
, S.requires_specialist
, S.operator_duration
, S.no_of_iterations 	    
 )

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Handle late arriving ASSET_OID */


-- Handle late arriving ASSET_OID

MERGE INTO ODS_OWN.AIR_ASSET_REQUEST T
USING (
SELECT 
ASSET.ASSET_OID,
AIR_ASSET_REQUEST.ASSET_REQUEST_OID,
SYSDATE AS ODS_MODIFY_DATE 
FROM  ODS_OWN.AIR_ASSET_REQUEST,
      ODS_STAGE.AIR_ASSET_REQUEST_XR,
      ODS_OWN.AIR_ASSET ASSET
WHERE  1 = 1
AND AIR_ASSET_REQUEST.ASSET_REQUEST_OID = AIR_ASSET_REQUEST_XR.ASSET_REQUEST_OID
AND AIR_ASSET_REQUEST_XR.ASSET_ID = ASSET.ID
AND AIR_ASSET_REQUEST_XR.ODS_CREATE_DATE > SYSDATE - 3
AND AIR_ASSET_REQUEST.ODS_CREATE_DATE > SYSDATE - 3
AND AIR_ASSET_REQUEST_XR.ASSET_ID IS NOT NULL
AND AIR_ASSET_REQUEST.ASSET_OID IS NULL
AND ASSET.ODS_CREATE_DATE > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) S
ON (T.ASSET_REQUEST_OID = S.ASSET_REQUEST_OID)
WHEN MATCHED THEN UPDATE SET
     T.ASSET_OID = S.ASSET_OID
    ,T.ODS_MODIFY_DATE = S.ODS_MODIFY_DATE
WHERE 
    decode(S.ASSET_OID,T.ASSET_OID,1,0) = 0
    

               

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Handle late arriving Events */

--
-- Handle late arriving Events


MERGE INTO ODS_OWN.AIR_ASSET_REQUEST T
USING (
SELECT 
ASSET.ASSET_OID,
PIB.EVENT_OID,
AIR_ASSET_REQUEST.ASSET_REQUEST_OID,
SYSDATE AS ODS_MODIFY_DATE 
FROM  ODS_OWN.AIR_ASSET_REQUEST,
            ODS_STAGE.AIR_ASSET_REQUEST_XR,
            ODS_OWN.AIR_ASSET ASSET,
            ODS_OWN.AIR_PHOTO_IMPORT_BATCH PIB
WHERE AIR_ASSET_REQUEST.ASSET_REQUEST_OID = AIR_ASSET_REQUEST_XR.ASSET_REQUEST_OID
AND AIR_ASSET_REQUEST_XR.ASSET_ID = ASSET.ID
AND ASSET.PHOTO_IMPORT_BATCH_OID = PIB.PHOTO_IMPORT_BATCH_OID
AND AIR_ASSET_REQUEST_XR.ODS_CREATE_DATE > SYSDATE - 3
AND AIR_ASSET_REQUEST.ODS_CREATE_DATE > SYSDATE - 3
AND AIR_ASSET_REQUEST_XR.ASSET_ID IS NOT NULL
AND AIR_ASSET_REQUEST.EVENT_OID IS NULL
--AND ASSET.ODS_CREATE_DATE > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) S
ON (T.ASSET_REQUEST_OID = S.ASSET_REQUEST_OID)
WHEN MATCHED THEN UPDATE SET
     T.EVENT_OID = S.EVENT_OID
    ,T.ODS_MODIFY_DATE = S.ODS_MODIFY_DATE
WHERE 
    decode(S.EVENT_OID,T.EVENT_OID,1,0) = 0
    
   

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
,'LOAD_AIR_ASSET_REQUEST_PKG'
,'012'
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
'LOAD_AIR_ASSET_REQUEST_PKG',
'012',
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
