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

MERGE INTO ODS_STAGE.PWFS_HOLD_REASON_XR T
USING (
SELECT 
       HR.ID AS HOLD_REASON_ID,      
       HXR.HOLD_OID      	           ,
       HXR.HOLD_ID         
       FROM 
       ODS_STAGE.PWFS_HOLD_REASON_STG HR,         
       ODS_STAGE.PWFS_HOLD_XR  HXR         
       WHERE 1 = 1       
       AND HR.HOLD_ID = HXR.HOLD_ID(+)
       AND HR.ODS_MODIFY_DATE  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap 
       ) S
       ON (T.HOLD_REASON_ID = S.HOLD_REASON_ID)
WHEN NOT MATCHED
THEN
   INSERT     
   (   
    HOLD_REASON_OID      ,
    HOLD_REASON_ID       	 ,      
    HOLD_OID	 ,
    HOLD_ID         	 ,  
    ODS_CREATE_DATE       ,  
    ODS_MODIFY_DATE       	
   )
   VALUES (
               ODS_STAGE.PWFS_HOLD_REASON_OID_SEQ.NEXTVAL,               
               S.HOLD_REASON_ID        	,   
               S.HOLD_OID  	            	,    
               S.HOLD_ID   	            	,                  
               SYSDATE          	    	,
               SYSDATE
          )
WHEN MATCHED
THEN
   UPDATE SET            
      T.HOLD_OID       = S.HOLD_OID,      
      T.HOLD_ID         =  S.HOLD_ID ,
      T.ODS_MODIFY_DATE = SYSDATE
      WHERE (    
                decode(S.HOLD_OID, T.HOLD_OID, 1, 0) = 0 OR
             	decode(S.HOLD_ID, T.HOLD_ID, 1, 0) = 0             	           
                  )

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Merge into Target Table */

MERGE INTO ODS_OWN.PWFS_HOLD_REASON T
USING 
( SELECT    
  XR.HOLD_REASON_OID           		,       
  XR.HOLD_OID                               		,
  STG.ID AS HOLD_REASON_ID                  	,
  XR.HOLD_ID                                		,
  FROM_TZ (CAST (stg.create_date AS TIMESTAMP), 'UTC') AT TIME ZONE :v_data_center_tz AS SRC_CREATE_DATE,
  FROM_TZ (CAST (stg.modified_date AS TIMESTAMP), 'UTC') AT TIME ZONE :v_data_center_tz AS SRC_MODIFIED_DATE,
  STG.VERSION                       		,
  STG.CREATED_BY                    		,
  STG.REASON                        		,
  STG.COMMENTS                      		,
  SS.SOURCE_SYSTEM_OID    
  FROM 
   ODS_STAGE.PWFS_HOLD_REASON_STG STG,
   ODS_STAGE.PWFS_HOLD_REASON_XR XR,                  
   ODS_OWN.SOURCE_SYSTEM  SS
  WHERE 1 = 1
   AND  STG.ID = XR.HOLD_REASON_ID   
   AND  SS.SOURCE_SYSTEM_SHORT_NAME = 'PWFS'
   AND  STG.ODS_MODIFY_DATE  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap 
   )S
    ON (T.HOLD_REASON_OID = S.HOLD_REASON_OID)
WHEN MATCHED
THEN
  UPDATE SET      
  T.HOLD_OID             	=  S.HOLD_OID              	   	,
  T.HOLD_REASON_ID       =  S.HOLD_REASON_ID        	,
  T.HOLD_ID              	=  S.HOLD_ID               	    	,  
  T.SRC_CREATE_DATE     =  S.SRC_CREATE_DATE      	,
  T.SRC_MODIFIED_DATE =  S.SRC_MODIFIED_DATE     	,
  T.VERSION              	=  S.VERSION               		,
  T.REASON               	=  S.REASON                		,
  T.COMMENTS             	=  S.COMMENTS              		,
  T.ODS_MODIFY_DATE     =  SYSDATE                 		,    
  T.SOURCE_SYSTEM_OID =  S.SOURCE_SYSTEM_OID        
  WHERE  (DECODE (S.HOLD_REASON_ID, T.HOLD_REASON_ID, 1, 0) = 0
                 OR DECODE (S.HOLD_OID, T.HOLD_OID, 1, 0) = 0
                 OR DECODE (S.HOLD_ID, T.HOLD_ID, 1, 0) = 0
                 OR DECODE (S.SRC_CREATE_DATE, T.SRC_CREATE_DATE, 1, 0) = 0
                 OR DECODE (S.SRC_MODIFIED_DATE, T.SRC_MODIFIED_DATE, 1, 0) = 0
                 OR DECODE (S.VERSION, T.VERSION, 1, 0) = 0
                 OR DECODE (S.REASON, T.REASON, 1, 0) = 0
                 OR DECODE (S.COMMENTS, T.COMMENTS, 1, 0) = 0                    
                 OR DECODE (S.SOURCE_SYSTEM_OID, T.SOURCE_SYSTEM_OID, 1, 0) = 0                       
            )                                                                                                                                      
WHEN NOT MATCHED
THEN
   INSERT     
   (    
  T.HOLD_REASON_OID                    	 ,
  T.HOLD_OID             		 ,
  T.HOLD_REASON_ID                      	 ,
  T.HOLD_ID       		 ,
  T.SRC_CREATE_DATE     	 ,
  T.SRC_MODIFIED_DATE                   	 ,
  T.VERSION                      	    	 ,
  T.CREATED_BY                       	 ,
  T.REASON           		 ,
  T.COMMENTS                           	 ,  
  T.ODS_CREATE_DATE                     	 ,
  T.ODS_MODIFY_DATE                     	 ,
  T.SOURCE_SYSTEM_OID            
    )
       VALUES 
    (   
  S.HOLD_REASON_OID                     	,
  S.HOLD_OID             		,
  S.HOLD_REASON_ID                      	,
  S.HOLD_ID                             	,
  S.SRC_CREATE_DATE    		,
  S.SRC_MODIFIED_DATE 		,
  S.VERSION                   		,
  S.CREATED_BY                      	,
  S.REASON                       	    	,
  S.COMMENTS                            	,
  SYSDATE                               	,
  SYSDATE                               	,
  S.SOURCE_SYSTEM_OID      
 )

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Handle late arriving HOLD_OID */

-- Handle late arriving HOLD_OID

MERGE INTO ODS_OWN.PWFS_HOLD_REASON T
USING (
SELECT 
HOLD.HOLD_OID,
HR.HOLD_REASON_OID,
SYSDATE AS ODS_MODIFY_DATE 
FROM  ODS_OWN.PWFS_HOLD_REASON HR,
      ODS_STAGE.PWFS_HOLD_REASON_XR XR,
      ODS_OWN.PWFS_HOLD HOLD
WHERE  1 = 1
AND HR.HOLD_REASON_OID = XR.HOLD_REASON_OID
AND XR.HOLD_ID = HOLD.HOLD_ID
AND HR.ODS_CREATE_DATE > SYSDATE - 7
AND XR.HOLD_ID IS NOT NULL
AND HR.HOLD_OID IS NULL
AND HOLD.ODS_CREATE_DATE > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) S
ON (T.HOLD_REASON_OID = S.HOLD_REASON_OID)
WHEN MATCHED THEN UPDATE SET
     T.HOLD_OID = S.HOLD_OID
    ,T.ODS_MODIFY_DATE = S.ODS_MODIFY_DATE
WHERE 
decode(S.HOLD_OID,T.HOLD_OID,1,0) = 0 




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
,'LOAD_PWFS_HOLD_REASON_PKG'
,'005'
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
'LOAD_PWFS_HOLD_REASON_PKG',
'005',
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
