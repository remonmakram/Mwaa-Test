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
/* MERGE INTO AIR_PHOTO_IMPORT_BATCH_XR */


MERGE INTO ODS_STAGE.AIR_PHOTO_IMPORT_BATCH_XR T
USING (
SELECT 
       S.ID,
       S.EVENT_ID
       FROM ODS_STAGE.AIR_PHOTO_IMPORT_BATCH_STG S,
            ODS_OWN.EVENT E
       WHERE 1 = 1
       AND S.EVENT_ID = E.EVENT_REF_ID(+)
       AND S.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap 
       ) S
       ON (T.ID = S.ID)
WHEN NOT MATCHED
THEN
   INSERT     
   (   
   PHOTO_IMPORT_BATCH_OID	,
   ID	                    		,
   EVENT_ID                		,
   ODS_CREATE_DATE     	    	,
   ODS_MODIFY_DATE     	
   )
   VALUES (
               ODS_STAGE.AIR_PHOTO_IMPORT_BATCH_OID_SEQ.NEXTVAL,
               S.ID,
               S.EVENT_ID,                   
               SYSDATE,
               SYSDATE)
WHEN MATCHED
THEN
   UPDATE SET
      T.EVENT_ID = S.EVENT_ID,
      T.ODS_MODIFY_DATE = SYSDATE
      WHERE decode(S.EVENT_ID, T.EVENT_ID, 1, 0) = 0
                 
            
       



&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* MERGE INTO ODS_OWN.AIR_PHOTO_IMPORT_BATCH */

   
MERGE INTO ODS_OWN.AIR_PHOTO_IMPORT_BATCH T
USING 
(SELECT 
   XR.PHOTO_IMPORT_BATCH_OID  	,     
   STG.id                     	,
   STG.business_line        	,
   STG.camera_id            	,	 
   STG.event_id             	,
   E.EVENT_OID            	,  
   STG.media_id             	,   
   STG.create_date          	,  
   STG.modified_date        	, 
   STG.version              	, 
   STG.lab                  	,
   STG.ODS_CREATE_DATE      ,       
   STG.ODS_MODIFY_DATE      ,        
   SS.SOURCE_SYSTEM_OID            
   FROM 
   ODS_STAGE.AIR_PHOTO_IMPORT_BATCH_STG STG,
   ODS_STAGE.AIR_PHOTO_IMPORT_BATCH_XR XR,
   ODS_OWN.EVENT E    ,               
   ODS_OWN.SOURCE_SYSTEM  SS
   WHERE 1 = 1
   AND  STG.ID = XR.ID
   AND STG.EVENT_ID = E.EVENT_REF_ID(+)
   AND  SS.SOURCE_SYSTEM_SHORT_NAME = 'AIR'
   AND  STG.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap 
   ) S
    ON (T.PHOTO_IMPORT_BATCH_OID = S.PHOTO_IMPORT_BATCH_OID)
WHEN MATCHED
THEN
   UPDATE SET          
   T.business_line    	=	   S.business_line   ,
   T.camera_id          	=	   S.camera_id        , 
   T.event_id           	=	   S.event_id          ,
   T.event_oid	=	   S.event_oid        ,
   T.media_id          	=	   S.media_id          ,        
   T.create_date       	=	   S.create_date    ,       
   T.modified_date     	=	   S.modified_date , 
   T.version            	=	   S.version            , 
   T.lab                	=	   S.lab                   ,                     
   T.ods_modify_date    	=      	   SYSDATE            ,        
   T.source_system_oid  	=	   S.source_system_oid                 	
   WHERE    DECODE (S.business_line, T.business_line, 1, 0) = 0
                 OR DECODE (S.camera_id, T.camera_id, 1, 0) = 0
                 OR DECODE (S.event_id, T.event_id, 1, 0) = 0
                 OR DECODE (S.event_oid, T.event_oid, 1, 0) = 0
                 OR DECODE (S.media_id, T.media_id, 1, 0) = 0
                 OR DECODE (S.create_date, T.create_date, 1, 0) = 0
                 OR DECODE (S.modified_date, T.modified_date, 1,0) = 0
                 OR DECODE (S.version, T.version, 1, 0) = 0
                 OR DECODE (S.lab, T.lab, 1, 0) = 0            
                 OR DECODE (S.source_system_oid, T.source_system_oid, 1, 0) = 0                                                                                                             
WHEN NOT MATCHED
THEN
   INSERT     
   (    
   T.PHOTO_IMPORT_BATCH_OID     	,  
   T.id                         	 	,
   T.business_line              		,
   T.camera_id                  		,
   T.event_id                   		,
   T.event_oid                  		,
   T.media_id                   		,
   T.create_date                		,
   T.modified_date              	,
   T.version                    		,
   T.lab                        		,
   T.ODS_CREATE_DATE            	,
   T.ODS_MODIFY_DATE            	,    
   T.SOURCE_SYSTEM_OID                       	                
    )
       VALUES 
    (   
   S.PHOTO_IMPORT_BATCH_OID     	,  
   S.id                         		,
   S.business_line             	 	,
   S.camera_id                  		,
   S.event_id                   		,
   S.event_oid                  		,
   S.media_id                   		,
   S.create_date                		,
   S.modified_date              	,
   S.version                    		,
   S.lab                        		,
   SYSDATE                      		,
   SYSDATE                      		,    
   S.SOURCE_SYSTEM_OID                            	    
 )

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Handle Late Arriving Events */

--
-- Handle late arriving Events
-- Not Required -- Since Events are created long before the Pre Lab Process





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
,'LOAD_AIR_PHOTO_IMPORT_BATCH_PKG'
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
'LOAD_AIR_PHOTO_IMPORT_BATCH_PKG',
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
