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
/* Merge into XR (ODS_STAGE.AIR_ASSET_XR) */

MERGE INTO ODS_STAGE.AIR_ASSET_XR T
USING (
SELECT stg.id,       
             stg.photo_import_batch_id
             FROM 
             ods_stage.air_asset_stg stg,
             ods_stage.air_photo_import_batch_xr pib_xr
         WHERE 1 = 1
         AND stg.photo_import_batch_id = pib_xr.id(+)
         AND stg.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap 
       ) S
       ON (S.ID = T.ID)
WHEN NOT MATCHED
THEN
    INSERT 
          (asset_oid,
            id,                          
            photo_import_batch_id,
            ods_create_date,
            ods_modify_date)
       VALUES (ods_stage.AIR_ASSET_OID_SEQ.NEXTVAL,
               s.id,               
               s.photo_import_batch_id,               
               sysdate,
               sysdate)
WHEN MATCHED
THEN
   UPDATE SET
      T.photo_import_batch_id = S.photo_import_batch_id,
      T.ods_modify_date = sysdate
      WHERE decode(S.photo_import_batch_id, T.photo_import_batch_id, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Merge into ODS_OWN.AIR_ASSET */

MERGE INTO ODS_OWN.AIR_ASSET T
USING (SELECT 
       XR.ASSET_OID,
       STG.ID,
       PIB.PHOTO_IMPORT_BATCH_OID,
       STG.CAPTURE_SEQ ,            		
       STG.SOURCE_SYSTEM,          		
       STG.TYPE,         		   
       STG.CLOCKWISE_ROTATION,     		
       STG.INPUT_DEVICE_CODE,	
       STG.CREATE_DATE,   	
       STG.MODIFIED_DATE,	
       STG.VERSION ,	
       STG.CHECK_ME,
       SYSDATE AS ODS_CREATE_DATE,
       SYSDATE AS ODS_MODIFY_DATE,    
       SS.SOURCE_SYSTEM_OID, 
       STG.CAMERA_IDENTIFIED_CHECK_ME,
       STG.CAMERA_IDENTIFIED_SIBLING,
       STG.USABLE,
       STG.SIT_CARD_NO,
       STG.ART_INTENT,
       STG.CAL_IMAGE_ID,
       STG.CAL_IMAGE_TYPE
       FROM 
	   ODS_STAGE.AIR_ASSET_STG STG,
	   ODS_STAGE.AIR_ASSET_XR XR,
	   ODS_OWN.AIR_PHOTO_IMPORT_BATCH PIB,                   
                        ODS_OWN.SOURCE_SYSTEM  SS
       WHERE 1 = 1
       AND  STG.ID = XR.ID
       AND  STG.PHOTO_IMPORT_BATCH_ID = PIB.ID(+)
       AND  SS.SOURCE_SYSTEM_SHORT_NAME = 'AIR'
	   AND STG.ods_modify_date >= to_date(substr(:v_cdc_load_date, 1, 19), 'yyyy-mm-dd hh24:mi:ss')  -:v_cdc_overlap
        ) S
       ON (T.ASSET_OID = S.ASSET_OID)
WHEN MATCHED
THEN
   UPDATE SET
       T.PHOTO_IMPORT_BATCH_OID = S.PHOTO_IMPORT_BATCH_OID,
       T.CAPTURE_SEQ = S.CAPTURE_SEQ,            		
       T.SOURCE_SYSTEM = S.SOURCE_SYSTEM,          		
       T.TYPE = S.TYPE,         		   
       T.CLOCKWISE_ROTATION = S.CLOCKWISE_ROTATION,     		
       T.INPUT_DEVICE_CODE = S.INPUT_DEVICE_CODE,	
       T.CREATE_DATE = S.CREATE_DATE,	
       T.MODIFIED_DATE = S.MODIFIED_DATE,	
       T.VERSION = S.VERSION,	
       T.CHECK_ME = S.CHECK_ME,
       T.ODS_MODIFY_DATE = SYSDATE, 
       T.SOURCE_SYSTEM_OID = S.SOURCE_SYSTEM_OID,
       T.CAMERA_IDENTIFIED_CHECK_ME = S.CAMERA_IDENTIFIED_CHECK_ME,
       T.CAMERA_IDENTIFIED_SIBLING = S.CAMERA_IDENTIFIED_SIBLING,
       T.USABLE = S.USABLE,
       T.SIT_CARD_NO = S.SIT_CARD_NO,
       T.ART_INTENT = S.ART_INTENT,
       T.CAL_IMAGE_ID = S.CAL_IMAGE_ID,
       T.CAL_IMAGE_TYPE = S.CAL_IMAGE_TYPE 
           WHERE    DECODE (S.PHOTO_IMPORT_BATCH_OID, T.PHOTO_IMPORT_BATCH_OID, 1, 0) = 0
                 OR DECODE (S.CAPTURE_SEQ, T.CAPTURE_SEQ, 1, 0) = 0
                 OR DECODE (S.SOURCE_SYSTEM, T.SOURCE_SYSTEM, 1, 0) = 0
                 OR DECODE (S.TYPE, T.TYPE, 1, 0) = 0
                 OR DECODE (S.CLOCKWISE_ROTATION, T.CLOCKWISE_ROTATION, 1, 0) = 0
                 OR DECODE (S.INPUT_DEVICE_CODE, T.INPUT_DEVICE_CODE, 1, 0) = 0
                 OR DECODE (S.CREATE_DATE, T.CREATE_DATE, 1,0) = 0
                 OR DECODE (S.MODIFIED_DATE, T.MODIFIED_DATE, 1, 0) = 0
                 OR DECODE (S.VERSION, T.VERSION, 1,0) = 0
                 OR DECODE (S.CHECK_ME, T.CHECK_ME, 1,0) = 0    
                 OR DECODE (S.SOURCE_SYSTEM_OID, T.SOURCE_SYSTEM_OID, 1,0) = 0  
                 OR DECODE (S.CAMERA_IDENTIFIED_CHECK_ME, T.CAMERA_IDENTIFIED_CHECK_ME, 1,0) = 0  
                 OR DECODE (S.CAMERA_IDENTIFIED_SIBLING, T.CAMERA_IDENTIFIED_SIBLING, 1,0) = 0  
                 OR DECODE (S.USABLE, T.USABLE, 1,0) = 0  
                 OR DECODE (S.SIT_CARD_NO, T.SIT_CARD_NO, 1,0) = 0  
                 OR DECODE (S.ART_INTENT, T.ART_INTENT, 1,0) = 0  
                 OR DECODE (S.CAL_IMAGE_ID, T.CAL_IMAGE_ID, 1,0) = 0  
                 OR DECODE (S.CAL_IMAGE_TYPE, T.CAL_IMAGE_TYPE, 1,0) = 0  				 
WHEN NOT MATCHED
THEN
   INSERT     ( 
                T.ASSET_OID,          
                T.ID,
                T.PHOTO_IMPORT_BATCH_OID,
                T.CAPTURE_SEQ,
                T.SOURCE_SYSTEM,
                T.TYPE,        	
                T.CLOCKWISE_ROTATION,     		
                T.INPUT_DEVICE_CODE,  		
                T.CREATE_DATE,   		
                T.MODIFIED_DATE,  		
                T.VERSION,   		
                T.CHECK_ME,   		
                T.ODS_CREATE_DATE,         
                T.ODS_MODIFY_DATE, 
                T.SOURCE_SYSTEM_OID,				
                T.CAMERA_IDENTIFIED_CHECK_ME,
                T.CAMERA_IDENTIFIED_SIBLING,
                T.USABLE,
                T.SIT_CARD_NO,
                T.ART_INTENT,
               T.CAL_IMAGE_ID,
               T.CAL_IMAGE_TYPE
	)
       VALUES ( S.ASSET_OID,          
                S.ID,
                S.PHOTO_IMPORT_BATCH_OID,
                S.CAPTURE_SEQ,
                S.SOURCE_SYSTEM,
                S.TYPE,        	
                S.CLOCKWISE_ROTATION,     		
                S.INPUT_DEVICE_CODE,  		
                S.CREATE_DATE,   		
                S.MODIFIED_DATE,  		
                S.VERSION,   		
                S.CHECK_ME,   		
                SYSDATE,         
                SYSDATE,	         
                S.SOURCE_SYSTEM_OID,
                S.CAMERA_IDENTIFIED_CHECK_ME, 
                S.CAMERA_IDENTIFIED_SIBLING,
                S.USABLE,
                S.SIT_CARD_NO,
                S.ART_INTENT,
                S.CAL_IMAGE_ID, 
                S.CAL_IMAGE_TYPE
	)                            
                

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* UPDATE PHOTO_IMPORT_BATCH_OID */


-- Handle late arriving PIB

MERGE INTO ODS_OWN.AIR_ASSET T
USING (
SELECT 
PIB.PHOTO_IMPORT_BATCH_OID,
AIR_ASSET.ASSET_OID,
SYSDATE AS ODS_MODIFY_DATE 
FROM  ODS_OWN.AIR_ASSET,
      ODS_STAGE.AIR_ASSET_XR,
      ODS_OWN.AIR_PHOTO_IMPORT_BATCH PIB
WHERE AIR_ASSET.ASSET_OID = AIR_ASSET_XR.ASSET_OID
AND AIR_ASSET_XR.PHOTO_IMPORT_BATCH_ID = PIB.ID
AND AIR_ASSET_XR.ODS_CREATE_DATE > SYSDATE - 3
AND AIR_ASSET.ODS_CREATE_DATE > SYSDATE - 3
AND AIR_ASSET_XR.PHOTO_IMPORT_BATCH_ID IS NOT NULL
AND AIR_ASSET.PHOTO_IMPORT_BATCH_OID IS NULL
AND PIB.ODS_CREATE_DATE > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) S
ON (T.ASSET_OID = S.ASSET_OID)
WHEN MATCHED THEN UPDATE SET
     T.PHOTO_IMPORT_BATCH_OID = S.PHOTO_IMPORT_BATCH_OID
    ,T.ODS_MODIFY_DATE = S.ODS_MODIFY_DATE
WHERE 
    decode(S.PHOTO_IMPORT_BATCH_OID,T.PHOTO_IMPORT_BATCH_OID,1,0) = 0
               

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
,'LOAD_AIR_ASSET_PKG'
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
'LOAD_AIR_ASSET_PKG',
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
