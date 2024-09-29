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
/* MERGE INTO ODS_STAGE.AIR_IMAGE_GROUP_XR */

MERGE INTO ODS_STAGE.AIR_IMAGE_GROUP_XR T
USING (
SELECT S.ID,
       S.ASSET_ID
       FROM ODS_STAGE.AIR_IMAGE_GROUP_STG S,
            ODS_STAGE.AIR_ASSET_XR AIR_ASSET_XR
       WHERE 1 = 1
       AND S.ASSET_ID = AIR_ASSET_XR.ID(+)
       AND S.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap 
       ) S
       ON (T.ID = S.ID)
WHEN NOT MATCHED
THEN
   INSERT     (T.IMAGE_GROUP_OID       	,
               T.ID            	        ,
               T.ASSET_ID 	            ,               
               T.ODS_CREATE_DATE     	,
               T.ODS_MODIFY_DATE     	
              )
       VALUES (ODS_STAGE.AIR_IMAGE_GROUP_OID_SEQ.NEXTVAL,
               S.ID,
               S.ASSET_ID,                                          
               SYSDATE,
               SYSDATE)
WHEN MATCHED
THEN
   UPDATE SET
      T.ASSET_ID = S.ASSET_ID,      
      T.ODS_MODIFY_DATE = SYSDATE
      WHERE decode(S.ASSET_ID, T.ASSET_ID, 1, 0) = 0   

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* MERGE INTO ODS_OWN.AIR_IMAGE_GROUP */

  
		   
MERGE INTO ODS_OWN.AIR_IMAGE_GROUP T
USING 
(SELECT 
   XR.IMAGE_GROUP_OID       ,
   STG.ID                   	      ,
   ASSET.ASSET_OID               ,
   STG.TYPE                              ,
   STG.CREATE_DATE      	,
   STG.MODIFIED_DATE    	,
   STG.VERSION          	,
   STG.IMAGE_WIDTH      	,
   STG.IMAGE_LENGTH     	,
   SS.SOURCE_SYSTEM_OID	   
   FROM 
    ODS_STAGE.AIR_IMAGE_GROUP_STG STG,
    ODS_STAGE.AIR_IMAGE_GROUP_XR XR,  
    ODS_OWN.AIR_ASSET ASSET,                 
    ODS_OWN.SOURCE_SYSTEM  SS
            WHERE 1 = 1
 	    AND  STG.ID = XR.ID
 	    AND  XR.ASSET_ID = ASSET.ID
	    AND  SS.SOURCE_SYSTEM_SHORT_NAME = 'AIR'
	    AND  STG.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap 
	   ) S
       ON (T.IMAGE_GROUP_OID = S.IMAGE_GROUP_OID)
WHEN MATCHED
THEN
   UPDATE SET                                                          	      
   T.ASSET_OID            	=	   S.ASSET_OID        	,
   T.TYPE             	=	   S.TYPE             	,
   T.CREATE_DATE      	=	   S.CREATE_DATE      	,
   T.MODIFIED_DATE    	=	   S.MODIFIED_DATE    	,
   T.VERSION          	=	   S.VERSION          	,
   T.IMAGE_WIDTH      	=	   S.IMAGE_WIDTH      	,
   T.IMAGE_LENGTH     	=	   S.IMAGE_LENGTH     ,    
   T.ODS_MODIFY_DATE  	=	   SYSDATE            ,
   T.SOURCE_SYSTEM_OID =	   S.SOURCE_SYSTEM_OID           	
           WHERE    DECODE (S.ASSET_OID, T.ASSET_OID, 1, 0) = 0
                 OR DECODE (S.TYPE, T.TYPE, 1, 0) = 0
                 OR DECODE (S.CREATE_DATE, T.CREATE_DATE, 1, 0) = 0
                 OR DECODE (S.MODIFIED_DATE, T.MODIFIED_DATE, 1, 0) = 0
                 OR DECODE (S.VERSION, T.VERSION, 1, 0) = 0
                 OR DECODE (S.IMAGE_WIDTH, T.IMAGE_WIDTH, 1, 0) = 0
                 OR DECODE (S.IMAGE_LENGTH, T.IMAGE_LENGTH, 1,0) = 0
                 OR DECODE (S.SOURCE_SYSTEM_OID, T.SOURCE_SYSTEM_OID, 1, 0) = 0                                                                            
WHEN NOT MATCHED
THEN
   INSERT     
   (    
   T.IMAGE_GROUP_OID  	, 
   T.ID               	,   
   T.ASSET_OID        	,
   T.TYPE             	,
   T.CREATE_DATE      	,
   T.MODIFIED_DATE    	,
   T.VERSION          	,
   T.IMAGE_WIDTH      	,
   T.IMAGE_LENGTH     	,
   T.ODS_CREATE_DATE  	,
   T.ODS_MODIFY_DATE  	,
   T.SOURCE_SYSTEM_OID         	                
    )
       VALUES 
    (   
   S.IMAGE_GROUP_OID  	, 
   S.ID               	,   
   S.ASSET_OID        	,
   S.TYPE             	,
   S.CREATE_DATE      	,
   S.MODIFIED_DATE    	,
   S.VERSION          	,
   S.IMAGE_WIDTH      	,
   S.IMAGE_LENGTH     	,
   SYSDATE            	,           		
   SYSDATE            	,	  
   S.SOURCE_SYSTEM_OID             	    
 )

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Update ASSET_OID */

--
-- Handle late arriving ASSET_OID
--



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
,'LOAD_AIR_IMAGE_GROUP_PKG'
,'006'
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
'LOAD_AIR_IMAGE_GROUP_PKG',
'006',
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
