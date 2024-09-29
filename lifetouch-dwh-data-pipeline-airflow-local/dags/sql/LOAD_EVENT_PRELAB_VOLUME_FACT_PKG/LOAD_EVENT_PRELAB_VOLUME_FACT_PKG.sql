/* TASK No. 1 */
/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 1 */
/*-----------------------------------------------*/
/* TASK No. 2 */
/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 2 */
/*-----------------------------------------------*/
/* TASK No. 3 */
/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 3 */
/*-----------------------------------------------*/
/* TASK No. 4 */
/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 4 */
/*-----------------------------------------------*/
/* TASK No. 5 */
/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 5 */
/*-----------------------------------------------*/
/* TASK No. 6 */
/* Drop Table */

/* DROP TABLE RAX_APP_USER.EVENT_MODIFIED_DRIVER_PRY  CASCADE CONSTRAINTS */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.EVENT_MODIFIED_DRIVER_PRY  CASCADE CONSTRAINTS';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

/*-----------------------------------------------*/
/* TASK No. 7 */
/* Create Driver Table (Primary) */

&  

CREATE TABLE RAX_APP_USER.EVENT_MODIFIED_DRIVER_PRY
(
PROCESSING_LAB  VARCHAR2(100),
EVENT_OID       NUMBER,
EVENT_REF_ID    VARCHAR2(100),
SCHOOL_YEAR     NUMBER,
SELLING_METHOD  VARCHAR2(100)
)

/*-----------------------------------------------*/
/* TASK No. 8 */
/* Create IDX1 */

&  

CREATE UNIQUE INDEX RAX_APP_USER.EVENT_MODIFIED_DRIVER_IX1 ON RAX_APP_USER.EVENT_MODIFIED_DRIVER_PRY
(EVENT_OID)
LOGGING
NOPARALLEL

/*-----------------------------------------------*/
/* TASK No. 9 */
/* Create IDX2 */

&  

CREATE INDEX RAX_APP_USER.EVENT_MODIFIED_DRIVER_IX2 ON RAX_APP_USER.EVENT_MODIFIED_DRIVER_PRY
(EVENT_REF_ID)
LOGGING
NOPARALLEL

/*-----------------------------------------------*/
/* TASK No. 10 */
/* Insert into Driver Table */

&  

INSERT INTO RAX_APP_USER.EVENT_MODIFIED_DRIVER_PRY
SELECT
DISTINCT EVENT.PROCESSING_LAB,EVENT.EVENT_OID,EVENT.EVENT_REF_ID,EVENT.SCHOOL_YEAR,EVENT.SELLING_METHOD
FROM ODS_OWN.CAPTURE_SESSION,
          ODS_OWN.IMAGE,
          ODS_OWN.SUBJECT,                
          ODS_OWN.EVENT
WHERE 1 = 1
AND CAPTURE_SESSION.CAPTURE_SESSION_OID = IMAGE.CAPTURE_SESSION_OID
AND CAPTURE_SESSION.SUBJECT_OID = SUBJECT.SUBJECT_OID
AND CAPTURE_SESSION.EVENT_OID  = EVENT.EVENT_OID
AND (CAPTURE_SESSION.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date_ODS_DM, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap
OR SUBJECT.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date_ODS_DM, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap
OR IMAGE.ODS_MODIFY_DATE >=TO_DATE(SUBSTR(:v_cdc_load_date_ODS_DM, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap
)

/*-----------------------------------------------*/
/* TASK No. 11 */
/* Merge Into Driver Table */

&  

MERGE INTO RAX_APP_USER.EVENT_MODIFIED_DRIVER_PRY T
USING 
(
SELECT
DISTINCT EVENT.PROCESSING_LAB,EVENT.EVENT_OID,EVENT.EVENT_REF_ID,EVENT.SCHOOL_YEAR,EVENT.SELLING_METHOD
FROM 
ods_own.air_retouch_request retouch_request,
ods_own.air_asset asset,
ods_own.air_photo_import_batch pib,
ods_own.event event
WHERE 
retouch_request.asset_oid = asset.asset_oid
and asset.photo_import_batch_oid = pib.photo_import_batch_oid
and pib.event_id = event.event_ref_id
AND retouch_request.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date_ODS_DM, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap
) S
    ON (S.EVENT_OID = T.EVENT_OID)
WHEN NOT MATCHED
THEN
    INSERT 
          (T.PROCESSING_LAB,
           T.EVENT_OID,                          
           T.EVENT_REF_ID,
           T.SCHOOL_YEAR,
           T.SELLING_METHOD)
       VALUES (S.PROCESSING_LAB,
           S.EVENT_OID,                          
           S.EVENT_REF_ID,
           S.SCHOOL_YEAR,
           S.SELLING_METHOD)
WHEN MATCHED
THEN
   UPDATE SET
      T.PROCESSING_LAB = S.PROCESSING_LAB,
      T.SCHOOL_YEAR = S.SCHOOL_YEAR,
      T.SELLING_METHOD = S.SELLING_METHOD   
      WHERE
     ( decode(S.PROCESSING_LAB, T.PROCESSING_LAB, 1, 0) = 0 
      OR decode(S.SCHOOL_YEAR, T.SCHOOL_YEAR, 1, 0) = 0 
      OR decode(S.SELLING_METHOD, T.SELLING_METHOD, 1, 0) = 0
     )

/*-----------------------------------------------*/
/* TASK No. 12 */
/* Merge Into Driver Table */
&  


MERGE INTO RAX_APP_USER.EVENT_MODIFIED_DRIVER_PRY T
USING 
(
SELECT
DISTINCT EVENT.PROCESSING_LAB,EVENT.EVENT_OID,EVENT.EVENT_REF_ID,EVENT.SCHOOL_YEAR,EVENT.SELLING_METHOD
FROM 
ods_own.air_asset_request asset_request,
ods_own.air_asset asset,
ods_own.air_photo_import_batch pib,
ods_own.event event
WHERE 
asset_request.asset_oid = asset.asset_oid
and asset.photo_import_batch_oid = pib.photo_import_batch_oid
and pib.event_id = event.event_ref_id
AND asset_request.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date_ODS_DM, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap
) S
    ON (S.EVENT_OID = T.EVENT_OID)
WHEN NOT MATCHED
THEN
    INSERT 
          (T.PROCESSING_LAB,
           T.EVENT_OID,                          
           T.EVENT_REF_ID,
           T.SCHOOL_YEAR,
           T.SELLING_METHOD)
       VALUES (S.PROCESSING_LAB,
           S.EVENT_OID,                          
           S.EVENT_REF_ID,
           S.SCHOOL_YEAR,
           S.SELLING_METHOD)
WHEN MATCHED
THEN
   UPDATE SET
      T.PROCESSING_LAB = S.PROCESSING_LAB,
      T.SCHOOL_YEAR = S.SCHOOL_YEAR,
      T.SELLING_METHOD = S.SELLING_METHOD   
      WHERE 
     (decode(S.PROCESSING_LAB, T.PROCESSING_LAB, 1, 0) = 0 
      OR decode(S.SCHOOL_YEAR, T.SCHOOL_YEAR, 1, 0) = 0 
      OR decode(S.SELLING_METHOD, T.SELLING_METHOD, 1, 0) = 0
      )

/*-----------------------------------------------*/
/* TASK No. 13 */
/* Merge Into Driver Table */

&  

MERGE INTO RAX_APP_USER.EVENT_MODIFIED_DRIVER_PRY T
USING 
(
SELECT
DISTINCT EVENT.PROCESSING_LAB,EVENT.EVENT_OID,EVENT.EVENT_REF_ID,EVENT.SCHOOL_YEAR,EVENT.SELLING_METHOD
FROM ODS_OWN.AIR_PHOTO_IMPORT_BATCH PIB,
     ODS_OWN.EVENT EVENT  
WHERE  
1 = 1
AND PIB.EVENT_ID = EVENT.EVENT_REF_ID
AND PIB.ods_modify_date  >= TO_DATE(SUBSTR(:v_cdc_load_date_ODS_DM, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap
) S
    ON (S.EVENT_OID = T.EVENT_OID)
WHEN NOT MATCHED
THEN
    INSERT 
          (T.PROCESSING_LAB,
           T.EVENT_OID,                          
           T.EVENT_REF_ID,
           T.SCHOOL_YEAR,
           T.SELLING_METHOD)
       VALUES (S.PROCESSING_LAB,
           S.EVENT_OID,                          
           S.EVENT_REF_ID,
           S.SCHOOL_YEAR,
           S.SELLING_METHOD)
WHEN MATCHED
THEN
   UPDATE SET
      T.PROCESSING_LAB = S.PROCESSING_LAB,
      T.SCHOOL_YEAR = S.SCHOOL_YEAR,
      T.SELLING_METHOD = S.SELLING_METHOD   
      WHERE 
      (decode(S.PROCESSING_LAB, T.PROCESSING_LAB, 1, 0) = 0 
      OR decode(S.SCHOOL_YEAR, T.SCHOOL_YEAR, 1, 0) = 0 
      OR decode(S.SELLING_METHOD, T.SELLING_METHOD, 1, 0) = 0
      )

/*-----------------------------------------------*/
/* TASK No. 14 */
/* Merge into Driver Table */


&  
-- Note
-- Currently this pulls data from PWFS_TASK_STG. This will be changed to ODS_OWN once We load pwfs to ODS_OWN soon.

MERGE INTO RAX_APP_USER.EVENT_MODIFIED_DRIVER_PRY T
USING 
(
SELECT
DISTINCT EVENT.PROCESSING_LAB,EVENT.EVENT_OID,EVENT.EVENT_REF_ID,EVENT.SCHOOL_YEAR,EVENT.SELLING_METHOD
FROM ODS_OWN.PWFS_TASK TASK,
           ODS_OWN.EVENT EVENT  
WHERE  
1 = 1
AND EVENT.EVENT_REF_ID = TASK.TASK_ALIAS
AND TASK.STATUS IN ('Complete','COMPLETE')
AND TASK.TASK_TYPE IN ('EIC_READY')       
AND TASK.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date_ODS_DM, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  - :v_cdc_overlap 
) S
    ON (S.EVENT_OID = T.EVENT_OID)
WHEN NOT MATCHED
THEN
    INSERT 
          (T.PROCESSING_LAB,
           T.EVENT_OID,                          
           T.EVENT_REF_ID,
           T.SCHOOL_YEAR,
           T.SELLING_METHOD)
       VALUES (S.PROCESSING_LAB,
           S.EVENT_OID,                          
           S.EVENT_REF_ID,
           S.SCHOOL_YEAR,
           S.SELLING_METHOD)
WHEN MATCHED
THEN
   UPDATE SET
      T.PROCESSING_LAB = S.PROCESSING_LAB,
      T.SCHOOL_YEAR = S.SCHOOL_YEAR,
      T.SELLING_METHOD = S.SELLING_METHOD   
      WHERE (decode(S.PROCESSING_LAB, T.PROCESSING_LAB, 1, 0) = 0 
      OR decode(S.SCHOOL_YEAR, T.SCHOOL_YEAR, 1, 0) = 0 
      OR decode(S.SELLING_METHOD, T.SELLING_METHOD, 1, 0) = 0)

/*-----------------------------------------------*/
/* TASK No. 15 */
/* Drop Table */
&  
/* DROP TABLE RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY CASCADE CONSTRAINTS */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY CASCADE CONSTRAINTS';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

/*-----------------------------------------------*/
/* TASK No. 16 */
/* Create Drive Table(Secondary) */

&  

CREATE TABLE RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY
(
SCHOOL_YEAR     	NUMBER,
PROCESSING_LAB  	VARCHAR2(100),
ACCOUNT_ID   	NUMBER, 
APO_OID         	NUMBER,
APO_ID 		NUMBER,
EVENT_OID       	NUMBER,
EVENT_ID        	NUMBER,
EVENT_REF_ID    	VARCHAR2(100),
JOB_NBR         	VARCHAR2(100),
SELLING_METHOD  	VARCHAR2(100),
MARKETING_ID     	NUMBER,
PROGRAM_OID	NUMBER,
PROGRAM_ID 	 NUMBER,
PROGRAM_NAME     	VARCHAR2(200),
SUB_PROGRAM_OID  	NUMBER,
SUB_PROGRAM_ID   	NUMBER,
SUB_PROGRAM_NAME 	VARCHAR2(200),
EIC_DATE                          DATE
)

/*-----------------------------------------------*/
/* TASK No. 17 */
/* Create IDX1 */

&  

CREATE UNIQUE INDEX RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY_IX1 ON RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY
(EVENT_OID)
LOGGING
NOPARALLEL

/*-----------------------------------------------*/
/* TASK No. 18 */
/* Create IDX2 */

&  

CREATE INDEX RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY_IX2 ON RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY
(EVENT_REF_ID)
LOGGING
NOPARALLEL

/*-----------------------------------------------*/
/* TASK No. 19 */
/* Insert into Driver Table(Secondary) */

&  

INSERT INTO RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY
SELECT  PRY.SCHOOL_YEAR,
        PRY.PROCESSING_LAB,        
        MART.ACCOUNT.ACCOUNT_ID,        
        ODS_OWN.APO.APO_OID,        
        MART.APO.APO_ID,
        EVENT.EVENT_OID,
        MART.EVENT.EVENT_ID,
        ODS_OWN.EVENT.EVENT_REF_ID,
        MART.EVENT.JOB_NBR,
        PRY.SELLING_METHOD,
        MART.MARKETING.MARKETING_ID MARKETING_ID,             
        ODS_OWN.PROGRAM.PROGRAM_OID,
        ODS_OWN.PROGRAM.PROGRAM_ID,   
        ODS_OWN.PROGRAM.PROGRAM_NAME,       
        ODS_OWN.SUB_PROGRAM.SUB_PROGRAM_OID,  
        ODS_OWN.SUB_PROGRAM.SUB_PROGRAM_ID,   
        ODS_OWN.SUB_PROGRAM.SUB_PROGRAM_NAME,
        NULL
FROM 
RAX_APP_USER.EVENT_MODIFIED_DRIVER_PRY PRY,
ODS_OWN.APO,
ODS_OWN.EVENT,
ODS_OWN.SUB_PROGRAM,
ODS_OWN.PROGRAM,
MART.EVENT,
MART.APO,
MART.ACCOUNT,
MART.MARKETING
WHERE 
    RAX_APP_USER.PRY.EVENT_OID = ODS_OWN.EVENT.EVENT_OID(+)
    AND ODS_OWN.EVENT.APO_OID = ODS_OWN.APO.APO_OID(+)               
    AND ODS_OWN.APO.SUB_PROGRAM_OID = ODS_OWN.SUB_PROGRAM.SUB_PROGRAM_OID(+)    
    AND ODS_OWN.SUB_PROGRAM.PROGRAM_OID = ODS_OWN.PROGRAM.PROGRAM_OID(+)          
    AND NVL(ODS_OWN.SUB_PROGRAM.SUB_PROGRAM_OID,-1) = MART.MARKETING.SUB_PROGRAM_OID(+)       
    AND NVL(ODS_OWN.APO.APO_ID,-1) = MART.APO.APO_CODE(+)
    AND NVL(ODS_OWN.EVENT.EVENT_REF_ID,-1) = MART.EVENT.JOB_NBR(+)
    AND NVL(ODS_OWN.APO.LIFETOUCH_ID,-1) = MART.ACCOUNT.LIFETOUCH_ID(+)
    AND PRY.EVENT_OID IS NOT NULL 
    AND PRY.EVENT_OID <> -1

/*-----------------------------------------------*/
/* TASK No. 20 */
/* Merge into Driver Table(Secondary) */
&  


MERGE INTO RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY TGT
    USING  
    (  
    SELECT 
    SDY.EVENT_OID,SDY.EVENT_ID,SDY.EVENT_REF_ID,SDY.APO_OID,SDY.JOB_NBR
,min(from_tz(cast(task.completed_on as timestamp), 'UTC') at time zone 'US/Central') AS EIC_DATE
,TASK.STATUS 
    FROM 
    RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY SDY,
    ODS_OWN.PWFS_TASK TASK
    WHERE SDY.EVENT_REF_ID = TASK.TASK_ALIAS
    AND TASK.STATUS IN ('Complete','COMPLETE')
    AND TASK.TASK_TYPE IN ('EIC_READY')        
    GROUP BY SDY.EVENT_OID,SDY.EVENT_ID,SDY.EVENT_REF_ID,SDY.APO_OID,SDY.JOB_NBR,TASK.STATUS    
    )SRC
    ON (TGT.EVENT_OID = SRC.EVENT_OID)          
    WHEN MATCHED THEN
    UPDATE 
     SET            
          TGT.EIC_DATE            = SRC.EIC_DATE

/*-----------------------------------------------*/
/* TASK No. 21 */
/* Merge into Driver Table(Secondary) */

&  

-- Merge Lab Name from PWFS Workflow
--

MERGE INTO RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY TGT
USING  
 (  
SELECT F.EVENT_REF_ID,F.PROCESSING_LAB,MIN(WF.USER_TASK_ALLOCATION_ID) AS LAB
FROM RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY F,
           ODS_OWN.PWFS_WORK_FLOW WF
WHERE 1 = 1
and F.EVENT_REF_ID = WF.SOURCE_SYSTEM_IDENTIFIER_2
AND TRIM(WF.USER_TASK_ALLOCATION_ID) IS NOT NULL
GROUP BY F.EVENT_REF_ID,F.PROCESSING_LAB
 )SRC
    ON (TGT.EVENT_REF_ID = SRC.EVENT_REF_ID)          
    WHEN MATCHED THEN
    UPDATE 
     SET            
          TGT.PROCESSING_LAB = SRC.LAB

/*-----------------------------------------------*/
/* TASK No. 22 */
/* Merge into MART.AGG_EVENT_PRELAB_VOLUME (Target) */

&  

MERGE INTO MART.EVENT_PRELAB_VOLUME_FACT TGT
    USING  
    (  
     SELECT SDY.SCHOOL_YEAR,SDY.PROCESSING_LAB,SDY.APO_ID,SDY.PROGRAM_ID,SDY.SUB_PROGRAM_ID,
                 SDY.ACCOUNT_ID,SDY.EVENT_ID,SDY.EVENT_REF_ID,SDY.SUB_PROGRAM_NAME,SDY.SELLING_METHOD,SDY.EIC_DATE       
     FROM 
     RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY SDY,
     MART.EVENT EVENT
     WHERE 1 = 1 
     AND SDY.EVENT_ID = EVENT.EVENT_ID 
     AND SDY.EIC_DATE IS NOT NULL
    )SRC
    ON (TGT.EVENT_ID = SRC.EVENT_ID)          
    WHEN MATCHED THEN
    UPDATE 
     SET            
          TGT.SCHOOL_YEAR              =   SRC.SCHOOL_YEAR,                        
          TGT.PROCESSING_LAB         =   SRC.PROCESSING_LAB,
          TGT.APO_ID                          =   SRC.APO_ID, 
          TGT.PROGRAM_ID                =   SRC.PROGRAM_ID,          		  		 
          TGT.SUB_PROGRAM_ID        =   SRC.SUB_PROGRAM_ID,          
          TGT.ACCOUNT_ID                 =  SRC.ACCOUNT_ID,
          TGT.SUB_PROGRAM_NAME   =  SRC.SUB_PROGRAM_NAME, 
          TGT.SELLING_METHOD          =  SRC.SELLING_METHOD,
          TGT.EIC_DATE                       =  SRC.EIC_DATE,
          TGT.MART_MODIFY_DATE    =  SYSDATE               
      WHERE 
      (decode(SRC.SCHOOL_YEAR,TGT.SCHOOL_YEAR,1,0) = 0 
                        OR decode(SRC.PROCESSING_LAB,TGT.PROCESSING_LAB,1,0) = 0 
	   OR decode(SRC.APO_ID,TGT.APO_ID,1,0) = 0 
                        OR decode(SRC.PROGRAM_ID,TGT.PROGRAM_ID,1,0) = 0 
	   OR decode(SRC.SUB_PROGRAM_ID,TGT.SUB_PROGRAM_ID,1,0) = 0 
                        OR decode(SRC.ACCOUNT_ID,TGT.ACCOUNT_ID,1,0) = 0 
 	   OR decode(SRC.SUB_PROGRAM_NAME,TGT.SUB_PROGRAM_NAME,1,0) = 0 
                        OR  decode(SRC.SELLING_METHOD,TGT.SELLING_METHOD,1,0) = 0
                        OR  decode(SRC.EIC_DATE,TGT.EIC_DATE,1,0) = 0
       )                     
WHEN NOT MATCHED THEN 
INSERT( 
TGT.SCHOOL_YEAR,TGT.PROCESSING_LAB,TGT.APO_ID,TGT.PROGRAM_ID,TGT.SUB_PROGRAM_ID,
TGT.ACCOUNT_ID,TGT.EVENT_ID,TGT.EVENT_REF_ID ,TGT.SUB_PROGRAM_NAME,
TGT.SELLING_METHOD,TGT.EIC_DATE,TGT.DVD,TGT.GROUPS,TGT.GROUP_IMAGES,TGT.COMPOSITES,  TGT.SUBJECT_IMAGES,TGT.SUBJECTS,TGT.STUDENTS,TGT.STAFF,TGT.IMAGES,TGT.SLATES,
TGT.DUST_CARDS,TGT.CAL_BOARDS,TGT.RETOUCH_ORDERED,TGT.SERVICE_RETOUCH,TGT.BRT_EDIT,
TGT.CX_FIELD1,TGT.CX_FIELD2,TGT.CX_FIELD3,TGT.MART_CREATE_DATE, TGT.MART_MODIFY_DATE     
 )
VALUES
(
    SRC.SCHOOL_YEAR,SRC.PROCESSING_LAB,SRC.APO_ID,SRC.PROGRAM_ID,SRC.SUB_PROGRAM_ID,
    SRC.ACCOUNT_ID,SRC.EVENT_ID,SRC.EVENT_REF_ID,SRC.SUB_PROGRAM_NAME,SRC.SELLING_METHOD,
    SRC.EIC_DATE,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,
    NULL,SYSDATE,SYSDATE  
)

/*-----------------------------------------------*/
/* TASK No. 23 */
/* Merge GroupRooms# to Target */

&  

MERGE INTO MART.EVENT_PRELAB_VOLUME_FACT TGT
    USING  
    (  
     SELECT 
           SDY.SCHOOL_YEAR,SDY.PROCESSING_LAB,SDY.APO_ID,SDY.PROGRAM_ID,SDY.SUB_PROGRAM_ID,
           SDY.ACCOUNT_ID,SDY.EVENT_ID,SDY.EVENT_REF_ID ,SDY.SUB_PROGRAM_NAME,SDY.SELLING_METHOD,
           NULL AS DVD,count(distinct subject_group.SUBJECT_GROUP_OID) AS GROUPS,
           NULL AS COMPOSITES ,NULL AS SUBJECTS,NULL AS STUDENTS,NULL AS STAFF,NULL AS IMAGES, 
           NULL AS RETOUCH_ORDERED,NULL AS SERVICE_RETOUCH,NULL AS CX_FIELD1,NULL AS CX_FIELD2,NULL AS CX_FIELD3       
      FROM
       ods_own.capture_session capture_session
     , ods_own.image image
     , ods_own.subject_image subject_image
     , ods_own.subject subject
     , ods_own.event event
     , ods_own.apo
     , ods_own.sub_program
     , ods_own.subject_group_image subject_group_image
     , ods_own.subject_group subject_group
     , RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY SDY
     , RAX_APP_USER.EVENT_MODIFIED_DRIVER_PRY PRY
    where capture_session.capture_session_oid = image.capture_session_oid
    and image.image_oid = subject_image.image_image_oid(+)
    and subject_image.subject_subject_oid = subject.subject_oid(+)
    and image.image_oid = subject_group_image.image_oid(+)
    and subject_group_image.subject_group_oid = subject_group.subject_group_oid(+)
    and capture_session.event_oid = event.event_oid
    and event.apo_oid = apo.apo_oid
    and apo.sub_program_oid = sub_program.sub_program_oid
    and trim(image.lti_image_url) is not null 
    and event.event_oid = sdy.event_oid
    and sdy.event_oid = pry.event_oid 
    and sdy.eic_date is not null
    and apo.school_year > (SELECT DISTINCT CALENDAR_YEAR FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))
    and image.ods_create_date > (SELECT MIN(DATE_KEY) FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))) 
    and capture_session.ods_create_date > (SELECT MIN(DATE_KEY) FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))
    and subject_group.ods_create_date > (SELECT MIN(DATE_KEY) FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))
    GROUP BY SDY.SCHOOL_YEAR,SDY.PROCESSING_LAB,SDY.APO_ID,SDY.PROGRAM_ID,SDY.SUB_PROGRAM_ID,
                      SDY.ACCOUNT_ID,SDY.EVENT_ID,SDY.EVENT_REF_ID ,SDY.SUB_PROGRAM_NAME,SDY.SELLING_METHOD
    )SRC
      ON (TGT.EVENT_ID = SRC.EVENT_ID)          
  WHEN MATCHED THEN
    UPDATE 
    SET            
          TGT.GROUPS               = SRC.GROUPS,                        
          TGT.MART_MODIFY_DATE     = SYSDATE 
    WHERE decode(SRC.GROUPS,TGT.GROUPS,1,0) = 0

/*-----------------------------------------------*/
/* TASK No. 24 */
/* Merge Composites# to Target */
&  


MERGE INTO MART.EVENT_PRELAB_VOLUME_FACT TGT
USING  
(  
Select  
        SDY.SCHOOL_YEAR,SDY.PROCESSING_LAB,SDY.APO_ID,SDY.PROGRAM_ID,SDY.SUB_PROGRAM_ID, 
        SDY.ACCOUNT_ID,SDY.EVENT_ID,SDY.EVENT_REF_ID ,SDY.SUB_PROGRAM_NAME,SDY.SELLING_METHOD,
        NULL AS DVD,NULL AS GROUPS,count(distinct subject_role_group.subject_role_group_oid) AS COMPOSITES,
        NULL AS SUBJECTS,NULL AS STUDENTS,NULL AS STAFF,NULL AS IMAGES, NULL AS RETOUCH_ORDERED,
        NULL AS SERVICE_RETOUCH,NULL AS CX_FIELD1,NULL AS CX_FIELD2,NULL AS CX_FIELD3              
FROM
  ods_own.capture_session capture_session
, ods_own.image image
, ods_own.subject_image subject_image
, ods_own.subject subject
, ods_own.event event
, ods_own.apo
, ods_own.sub_program
, ods_own.subject_group_image subject_group_image
, ods_own.subject_role_group
, ods_own.subject_group subject_group
, RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY SDY
, RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY PRY
where capture_session.capture_session_oid = image.capture_session_oid
and image.image_oid = subject_image.image_image_oid(+)
and subject_image.subject_subject_oid = subject.subject_oid(+)
and image.image_oid = subject_group_image.image_oid(+)
and subject_group_image.subject_group_oid = subject_group.subject_group_oid(+)
and subject.subject_oid = subject_role_group.subject_oid
and capture_session.event_oid = event.event_oid
and event.apo_oid = apo.apo_oid
and apo.sub_program_oid = sub_program.sub_program_oid
and SUBJECT_GROUP.GROUP_TYPE IN ('CLASSROOM','classroom')
and trim(image.lti_image_url) is not null 
and event.event_oid = sdy.event_oid
and event.event_oid = sdy.event_oid
and sdy.event_oid = pry.event_oid
and sdy.eic_date is not null
and apo.school_year > (SELECT DISTINCT CALENDAR_YEAR FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))
    and image.ods_create_date > (SELECT MIN(DATE_KEY) FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))) 
    and capture_session.ods_create_date > (SELECT MIN(DATE_KEY) FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))
    and subject_group.ods_create_date > (SELECT MIN(DATE_KEY) FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))
    GROUP BY SDY.SCHOOL_YEAR,SDY.PROCESSING_LAB,SDY.APO_ID,SDY.PROGRAM_ID,
                     SDY.SUB_PROGRAM_ID,SDY.ACCOUNT_ID,SDY.EVENT_ID,SDY.EVENT_REF_ID ,
                     SDY.SUB_PROGRAM_NAME,SDY.SELLING_METHOD 
    )SRC
      ON (TGT.EVENT_ID = SRC.EVENT_ID)          
  WHEN MATCHED THEN
    UPDATE 
     SET    
          TGT.COMPOSITES                  = SRC.COMPOSITES,                        
          TGT.MART_MODIFY_DATE     = SYSDATE 
      WHERE 
      decode(SRC.COMPOSITES,TGT.COMPOSITES,1,0) = 0

/*-----------------------------------------------*/
/* TASK No. 25 */
/* Merge Subjects Info to Target */
&  

MERGE INTO MART.EVENT_PRELAB_VOLUME_FACT TGT
    USING  
    (                         
    SELECT   
        SCHOOL_YEAR,PROCESSING_LAB,APO_ID,PROGRAM_ID,SUB_PROGRAM_ID,ACCOUNT_ID,EVENT_ID,             
        EVENT_REF_ID,SUB_PROGRAM_NAME,SELLING_METHOD,DVD,GROUPS,COMPOSITES,IMAGES,RETOUCH_ORDERED,
        SERVICE_RETOUCH,CX_FIELD1,CX_FIELD2,CX_FIELD3,COUNT(STUDENTS) STUDENTS,COUNT(STAFF) STAFF,
        COUNT(STUDENTS) + COUNT(STAFF) SUBJECTS,ROW_NUM  
    FROM
    (
    SELECT  
            SDY.SCHOOL_YEAR,SDY.PROCESSING_LAB,SDY.APO_ID,SDY.PROGRAM_ID,SDY.SUB_PROGRAM_ID,SDY.ACCOUNT_ID,SDY.EVENT_ID,             
            SDY.EVENT_REF_ID,SDY.SUB_PROGRAM_NAME,SDY.SELLING_METHOD,NULL AS DVD,NULL AS GROUPS,
            NULL AS COMPOSITES ,NULL AS IMAGES, NULL AS RETOUCH_ORDERED,NULL AS SERVICE_RETOUCH,
            NULL AS CX_FIELD1,NULL AS CX_FIELD2,NULL AS CX_FIELD3,SUBJECT.SUBJECT_OID,
            CASE WHEN SUBJECT.STAFF_FLAG = 0 THEN 1 END STUDENTS,
            CASE WHEN SUBJECT.STAFF_FLAG = 1 THEN 1 END STAFF,
            ROW_NUMBER() OVER (PARTITION BY SUBJECT.SUBJECT_OID ORDER BY SUBJECT.SUBJECT_OID DESC) AS ROW_NUM             
    FROM ODS_OWN.CAPTURE_SESSION,
         ODS_OWN.IMAGE,
         ODS_OWN.SUBJECT,                
         ODS_OWN.EVENT,
         ODS_OWN.APO,
         ODS_OWN.SUB_PROGRAM,
         RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY SDY,
         RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY PRY            
    WHERE 1 = 1
    AND CAPTURE_SESSION.CAPTURE_SESSION_OID = IMAGE.CAPTURE_SESSION_OID
    AND CAPTURE_SESSION.SUBJECT_OID = SUBJECT.SUBJECT_OID (+)
    AND CAPTURE_SESSION.EVENT_OID  = EVENT.EVENT_OID
    AND ODS_OWN.EVENT.APO_OID = ODS_OWN.APO.APO_OID 
    AND APO.SUB_PROGRAM_OID = SUB_PROGRAM.SUB_PROGRAM_OID
    and trim(image.lti_image_url) is not null 
    AND event.event_oid = sdy.event_oid  
    and sdy.event_oid = pry.event_oid
    and sdy.eic_date is not null
    AND apo.school_year > (SELECT DISTINCT CALENDAR_YEAR FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))
    and image.ods_create_date > (SELECT MIN(DATE_KEY) FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))) 
    and capture_session.ods_create_date > (SELECT MIN(DATE_KEY) FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))
    and subject.ods_create_date > (SELECT MIN(DATE_KEY) FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))    
    )
    WHERE ROW_NUM = 1
    GROUP BY 
             SCHOOL_YEAR,PROCESSING_LAB,APO_ID,PROGRAM_ID,SUB_PROGRAM_ID,ACCOUNT_ID,EVENT_ID,EVENT_REF_ID,
             SUB_PROGRAM_NAME,SELLING_METHOD,DVD,GROUPS,COMPOSITES,IMAGES,RETOUCH_ORDERED,SERVICE_RETOUCH,
             CX_FIELD1,CX_FIELD2,CX_FIELD3,row_num  
     )SRC
      ON (TGT.EVENT_ID = SRC.EVENT_ID)          
  WHEN MATCHED THEN
    UPDATE 
     SET            
          TGT.SUBJECTS              = SRC.SUBJECTS,  
          TGT.STUDENTS              = SRC.STUDENTS,
          TGT.STAFF                     = SRC.STAFF,                                
          TGT.MART_MODIFY_DATE     = SYSDATE 
      WHERE 
       (
        decode(SRC.SUBJECTS,TGT.SUBJECTS,1,0) = 0 OR decode(SRC.STUDENTS,TGT.STUDENTS,1,0) = 0 OR decode(SRC.STAFF,TGT.STAFF,1,0) = 0
       )

/*-----------------------------------------------*/
/* TASK No. 26 */
/* Merge SM Images Info # to Target */

&  

-- Image Count from Subject Master 

MERGE INTO MART.EVENT_PRELAB_VOLUME_FACT TGT
    USING  
    (                  
    SELECT SCHOOL_YEAR,PROCESSING_LAB,APO_ID,PROGRAM_ID,SUB_PROGRAM_ID,ACCOUNT_ID,
                EVENT_ID,EVENT_REF_ID,SUB_PROGRAM_NAME,SELLING_METHOD,DVD,GROUPS,COMPOSITES,
               SUM(SM_SUBJECT_IMAGES) AS SM_SUBJECT_IMAGES,SUM(SM_GROUP_IMAGES) AS SM_GROUP_IMAGES,
               RETOUCH_ORDERED,SERVICE_RETOUCH,STUDENTS,STAFF,SUBJECTS
    FROM
    (
    SELECT SDY.SCHOOL_YEAR,SDY.PROCESSING_LAB,SDY.APO_ID,SDY.PROGRAM_ID,SDY.SUB_PROGRAM_ID,
                 SDY.ACCOUNT_ID,SDY.EVENT_ID,SDY.EVENT_REF_ID,SDY.SUB_PROGRAM_NAME,SDY.SELLING_METHOD,
                 NULL AS DVD,NULL AS GROUPS, NULL AS COMPOSITES ,
                 CASE WHEN IMAGE.SUBJECTS_TYPE = 'INDIVIDUAL' THEN  1 END SM_SUBJECT_IMAGES , 
                 CASE WHEN IMAGE.SUBJECTS_TYPE = 'GROUP' THEN  1 END SM_GROUP_IMAGES,                 
                 NULL AS RETOUCH_ORDERED,NULL AS SERVICE_RETOUCH,NULL AS STUDENTS,NULL AS STAFF,NULL AS SUBJECTS            
    FROM ODS_OWN.CAPTURE_SESSION,
         ODS_OWN.IMAGE,                         
         ODS_OWN.EVENT,
         ODS_OWN.APO,
         ODS_OWN.SUB_PROGRAM,
         RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY SDY,
         RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY PRY        
    WHERE 1 = 1
    AND CAPTURE_SESSION.CAPTURE_SESSION_OID = IMAGE.CAPTURE_SESSION_OID    
    AND CAPTURE_SESSION.EVENT_OID  = EVENT.EVENT_OID
    AND ODS_OWN.EVENT.APO_OID = ODS_OWN.APO.APO_OID 
    AND APO.SUB_PROGRAM_OID = SUB_PROGRAM.SUB_PROGRAM_OID
    --AND IMAGE.PRINTABLE_IND = 1    
    AND TRIM(IMAGE.LTI_IMAGE_URL) IS NOT NULL
    AND event.event_oid = sdy.event_oid    
    and sdy.event_oid = pry.event_oid
    AND apo.school_year > (SELECT DISTINCT CALENDAR_YEAR FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))
    and image.ods_create_date > (SELECT MIN(DATE_KEY) FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))) 
    and capture_session.ods_create_date > (SELECT MIN(DATE_KEY) FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))
    )
    GROUP BY SCHOOL_YEAR,PROCESSING_LAB,APO_ID,PROGRAM_ID,SUB_PROGRAM_ID,ACCOUNT_ID,
                     EVENT_ID,EVENT_REF_ID,SUB_PROGRAM_NAME,SELLING_METHOD,DVD,GROUPS,COMPOSITES,
                     RETOUCH_ORDERED,SERVICE_RETOUCH,STUDENTS,STAFF,SUBJECTS     
     )SRC
      ON (TGT.EVENT_ID = SRC.EVENT_ID)          
  WHEN MATCHED THEN
    UPDATE 
     SET            
          TGT.CX_FIELD2    = SRC.SM_SUBJECT_IMAGES,  
          TGT.CX_FIELD3      = SRC.SM_GROUP_IMAGES,                  
          TGT.MART_MODIFY_DATE     = SYSDATE 
      WHERE 
      ( 
       decode(SRC.SM_SUBJECT_IMAGES,TGT.CX_FIELD2,1,0) = 0   
       OR decode(SRC.SM_GROUP_IMAGES,TGT.CX_FIELD3,1,0) = 0            
      )

/*-----------------------------------------------*/
/* TASK No. 27 */
/* Merge AIR_Image_Info to Target */
&  


MERGE INTO MART.EVENT_PRELAB_VOLUME_FACT  TGT
USING  
(  
SELECT   SCHOOL_YEAR,PROCESSING_LAB,APO_ID,PROGRAM_ID,SUB_PROGRAM_ID,
         ACCOUNT_ID,EVENT_ID,EVENT_REF_ID,SUB_PROGRAM_NAME,SELLING_METHOD,
         SUM(INDIVIDUAL) SUBJECT_IMAGES,SUM(GRP) GROUP_IMAGES,SUM(SLATE) AS SLATES,
         SUM(DUSTCARD) AS DUST_CARDS,SUM(CALBOARD) AS CAL_BOARDS,SUM(MULTISUBJECT) AS MULTISUBJECT,
         SUM(HOST_IMAGE) AS HOST_IMAGE,SUM(UNKNOWN) AS UNKNOWN,SUM(TOTAL_IMAGES) AS TOTAL_IMAGES
       FROM
(SELECT  SDY.SCHOOL_YEAR,SDY.PROCESSING_LAB,SDY.APO_ID,SDY.PROGRAM_ID,SDY.SUB_PROGRAM_ID,
         SDY.ACCOUNT_ID,SDY.EVENT_ID,SDY.EVENT_REF_ID ,SDY.SUB_PROGRAM_NAME,SDY.SELLING_METHOD,
         CASE WHEN asset.type = 'INDIVIDUAL' THEN  1 END INDIVIDUAL ,
         CASE WHEN asset.type = 'GROUP' THEN 1 END GRP ,
         CASE WHEN asset.type = 'SLATE' THEN 1 END SLATE ,                 
         CASE WHEN asset.type = 'DUSTCARD' THEN 1 END DUSTCARD ,
         CASE WHEN asset.type = 'CALBOARD' THEN 1 END CALBOARD ,
         CASE WHEN asset.type = 'MULTISUBJECT' THEN 1 END MULTISUBJECT ,
         CASE WHEN asset.type = 'HOST_IMAGE' THEN 1 END HOST_IMAGE ,
         CASE WHEN asset.type = 'UNKNOWN' THEN 1 END UNKNOWN,
         CASE WHEN asset.type IN ('INDIVIDUAL','GROUP','MULTISUBJECT','SLATE','DUSTCARD','CALBOARD') THEN 1 END TOTAL_IMAGES
FROM 
ods_own.air_photo_import_batch pib,
ods_own.air_asset asset,
ods_own.event event,
ods_own.apo apo,
ods_own.sub_program,
RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY SDY,
RAX_APP_USER.EVENT_MODIFIED_DRIVER_PRY PRY       
WHERE 1 = 1
and asset.photo_import_batch_oid = pib.photo_import_batch_oid
and pib.event_id = event.event_ref_id
and event.apo_oid = apo.apo_oid
AND apo.sub_program_oid = sub_program.sub_program_oid
AND event.event_oid = sdy.event_oid
AND sdy.event_oid = pry.event_oid
AND sdy.eic_date is not null
AND apo.school_year > (SELECT DISTINCT CALENDAR_YEAR FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))    
and asset.ods_create_date > (SELECT MIN(DATE_KEY) FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))
    )         
    GROUP BY SCHOOL_YEAR,PROCESSING_LAB,APO_ID,PROGRAM_ID,SUB_PROGRAM_ID,
             ACCOUNT_ID,EVENT_ID,EVENT_REF_ID,SUB_PROGRAM_NAME,SELLING_METHOD           
    )SRC
      ON (TGT.EVENT_ID = SRC.EVENT_ID)          
  WHEN MATCHED THEN
    UPDATE 
     SET    
          TGT.SLATES  = SRC.SLATES, 
          TGT.GROUP_IMAGES = SRC.GROUP_IMAGES,
          TGT.SUBJECT_IMAGES = SRC.SUBJECT_IMAGES,
          TGT.DUST_CARDS = SRC.DUST_CARDS,
          TGT.CAL_BOARDS = SRC.CAL_BOARDS,
          TGT.CX_FIELD1 = SRC.MULTISUBJECT,                    
          TGT.IMAGES =   SRC.TOTAL_IMAGES,
          TGT.MART_MODIFY_DATE = SYSDATE 
      WHERE 
      ( decode(SRC.SLATES,TGT.SLATES,1,0) = 0 
        OR decode(SRC.GROUP_IMAGES,TGT.GROUP_IMAGES,1,0) = 0 
        OR decode(SRC.SUBJECT_IMAGES,TGT.SUBJECT_IMAGES,1,0) = 0
        OR decode(SRC.DUST_CARDS,TGT.DUST_CARDS,1,0) = 0
        OR decode(SRC.CAL_BOARDS,TGT.CAL_BOARDS,1,0) = 0
        OR decode(SRC.MULTISUBJECT,TGT.CX_FIELD1,1,0) = 0
        OR decode(SRC.TOTAL_IMAGES,TGT.IMAGES,1,0) = 0
      )

/*-----------------------------------------------*/
/* TASK No. 28 */
/* Merge RetouchOrdered# to Target */


&  
-- Sourced from Retouch Request Table.
-- This Source table will be deactivated soon.

MERGE INTO MART.EVENT_PRELAB_VOLUME_FACT TGT
USING  
(  
SELECT
        SDY.SCHOOL_YEAR,SDY.PROCESSING_LAB,SDY.APO_ID,SDY.PROGRAM_ID,SDY.SUB_PROGRAM_ID,
        SDY.ACCOUNT_ID,SDY.EVENT_ID,SDY.EVENT_REF_ID ,SDY.SUB_PROGRAM_NAME,SDY.SELLING_METHOD,
        NULL AS DVD,NULL AS GROUPS,NULL AS COMPOSITES,NULL AS SUBJECTS,NULL AS STUDENTS,
        NULL AS STAFF,NULL AS IMAGES,count(retouch_request.retouch_request_oid) AS RETOUCH_ORDERED,
        NULL AS SERVICE_RETOUCH,NULL AS CX_FIELD1,NULL AS CX_FIELD2,NULL AS CX_FIELD3   
FROM 
ods_own.air_retouch_request retouch_request,
ods_own.air_asset asset,
ods_own.air_photo_import_batch pib,
ods_own.event event,
ods_own.apo apo,
ods_own.sub_program,
RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY SDY,
RAX_APP_USER.EVENT_MODIFIED_DRIVER_PRY PRY     
WHERE 
retouch_request.asset_oid = asset.asset_oid
and asset.photo_import_batch_oid = pib.photo_import_batch_oid
and retouch_request.STATUS IN ('COMPLETE','Complete')
and retouch_request.RETOUCH_TYPE IN ('Premium','premium','PREMIUM')
and pib.event_id = event.event_ref_id
and event.apo_oid = apo.apo_oid
and apo.sub_program_oid = sub_program.sub_program_oid
and event.event_oid = sdy.event_oid
and sdy.event_oid = pry.event_oid
and sdy.eic_date is not null
and apo.school_year > (SELECT DISTINCT CALENDAR_YEAR FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))
    and retouch_request.ods_create_date > (SELECT MIN(DATE_KEY) FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))     
    GROUP BY SDY.SCHOOL_YEAR,SDY.PROCESSING_LAB,SDY.APO_ID,SDY.PROGRAM_ID,SDY.SUB_PROGRAM_ID,SDY.ACCOUNT_ID,SDY.EVENT_ID,             
             SDY.EVENT_REF_ID ,SDY.SUB_PROGRAM_NAME,SDY.SELLING_METHOD  
    )SRC
      ON (TGT.EVENT_ID = SRC.EVENT_ID)          
  WHEN MATCHED THEN
    UPDATE 
     SET    
          TGT.RETOUCH_ORDERED      = SRC.RETOUCH_ORDERED,                        
          TGT.MART_MODIFY_DATE     = SYSDATE 
      WHERE 
      decode(SRC.RETOUCH_ORDERED,TGT.RETOUCH_ORDERED,1,0) = 0

/*-----------------------------------------------*/
/* TASK No. 29 */
/* Merge ServiceReotuch# to Target */

&  

-- Sourced from Retouch Request Table.
-- This Source table will be deactivated soon.

MERGE INTO MART.EVENT_PRELAB_VOLUME_FACT TGT
USING  
(  
select  SDY.SCHOOL_YEAR,SDY.PROCESSING_LAB,SDY.APO_ID,SDY.PROGRAM_ID,SDY.
           SUB_PROGRAM_ID,SDY.ACCOUNT_ID,SDY.EVENT_ID,SDY.EVENT_REF_ID ,SDY.SUB_PROGRAM_NAME,
           SDY.SELLING_METHOD,NULL AS DVD,NULL AS GROUPS,NULL AS COMPOSITES,NULL AS SUBJECTS,
           NULL AS STUDENTS,NULL AS STAFF,NULL AS IMAGES,NULL AS RETOUCH_ORDERED,
           count(retouch_request.retouch_request_oid) AS SERVICE_RETOUCH,NULL AS CX_FIELD1,
           NULL AS CX_FIELD2,NULL AS CX_FIELD3   
FROM 
ods_own.air_retouch_request retouch_request,
ods_own.air_asset asset,
ods_own.air_photo_import_batch pib,
ods_own.event event,
ods_own.apo apo,
ods_own.sub_program,
RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY SDY,
RAX_APP_USER.EVENT_MODIFIED_DRIVER_PRY PRY      
WHERE 
retouch_request.asset_oid = asset.asset_oid
and asset.photo_import_batch_oid = pib.photo_import_batch_oid
AND retouch_request.STATUS IN ('COMPLETE','Complete')
AND retouch_request.RETOUCH_TYPE IN  ('Basic','BASIC','basic')
and pib.event_id = event.event_ref_id
and event.apo_oid = apo.apo_oid
AND apo.sub_program_oid = sub_program.sub_program_oid
AND event.event_oid = sdy.event_oid
and sdy.event_oid = pry.event_oid
and sdy.eic_date is not null
AND apo.school_year > (SELECT DISTINCT CALENDAR_YEAR FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))
    and retouch_request.ods_create_date > (SELECT MIN(DATE_KEY) FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))     
    GROUP BY 
    SDY.SCHOOL_YEAR,SDY.PROCESSING_LAB,SDY.APO_ID,SDY.PROGRAM_ID,SDY.SUB_PROGRAM_ID,
    SDY.ACCOUNT_ID,SDY.EVENT_ID,SDY.EVENT_REF_ID ,SDY.SUB_PROGRAM_NAME,SDY.SELLING_METHOD 
    )SRC
      ON (TGT.EVENT_ID = SRC.EVENT_ID)          
  WHEN MATCHED THEN
    UPDATE 
     SET    
          TGT.SERVICE_RETOUCH        = SRC.SERVICE_RETOUCH,                        
          TGT.MART_MODIFY_DATE     = SYSDATE 
      WHERE 
      decode(SRC.SERVICE_RETOUCH,TGT.SERVICE_RETOUCH,1,0) = 0

/*-----------------------------------------------*/
/* TASK No. 30 */
/* Merge DVD# into Target */
&  


MERGE INTO MART.EVENT_PRELAB_VOLUME_FACT  TGT
USING  
(  
SELECT  
        SDY.SCHOOL_YEAR,SDY.PROCESSING_LAB,SDY.APO_ID,SDY.PROGRAM_ID,SDY.SUB_PROGRAM_ID,
        SDY.ACCOUNT_ID,SDY.EVENT_ID,SDY.EVENT_REF_ID ,SDY.SUB_PROGRAM_NAME,SDY.SELLING_METHOD,
        count(pib.event_id) AS DVD,NULL AS GROUPS,NULL AS COMPOSITES,NULL AS SUBJECTS,
        NULL AS STUDENTS,NULL AS STAFF,NULL AS IMAGES, NULL AS RETOUCH_ORDERED,
        NULL AS SERVICE_RETOUCH,NULL AS CX_FIELD1,NULL AS CX_FIELD2,NULL AS CX_FIELD3          
FROM 
ods_own.air_photo_import_batch pib,
ods_own.event event,
ods_own.apo apo,
ods_own.sub_program,
RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY SDY,
RAX_APP_USER.EVENT_MODIFIED_DRIVER_PRY PRY       
WHERE 1 = 1
and pib.event_id = event.event_ref_id
and event.apo_oid = apo.apo_oid
and apo.sub_program_oid = sub_program.sub_program_oid
and event.event_oid = sdy.event_oid
and sdy.event_oid = pry.event_oid
and sdy.eic_date is not null
and apo.school_year > (SELECT DISTINCT CALENDAR_YEAR FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))       
    GROUP BY SDY.SCHOOL_YEAR,SDY.PROCESSING_LAB,SDY.APO_ID,SDY.PROGRAM_ID,SDY.SUB_PROGRAM_ID,
                     SDY.ACCOUNT_ID,SDY.EVENT_ID,SDY.EVENT_REF_ID ,SDY.SUB_PROGRAM_NAME,SDY.SELLING_METHOD
    )SRC
      ON (TGT.EVENT_ID = SRC.EVENT_ID)          
  WHEN MATCHED THEN
    UPDATE 
     SET    
          TGT.DVD  = SRC.DVD,                        
          TGT.MART_MODIFY_DATE = SYSDATE 
      WHERE 
      decode(SRC.DVD,TGT.DVD,1,0) = 0

/*-----------------------------------------------*/
/* TASK No. 31 */
/* Merge RetouchOrdered# to Target */

&  

MERGE INTO MART.EVENT_PRELAB_VOLUME_FACT  TGT
USING  
(  
select  
        SDY.SCHOOL_YEAR,SDY.PROCESSING_LAB,SDY.APO_ID,SDY.PROGRAM_ID,SDY.SUB_PROGRAM_ID,
        SDY.ACCOUNT_ID,SDY.EVENT_ID,SDY.EVENT_REF_ID ,SDY.SUB_PROGRAM_NAME,
        SDY.SELLING_METHOD,NULL AS DVD,NULL AS GROUPS,NULL AS COMPOSITES,
        NULL AS SUBJECTS,NULL AS STUDENTS,NULL AS STAFF,NULL AS IMAGES, 
        count(asset_request.asset_request_oid) AS RETOUCH_ORDERED,
        NULL AS SERVICE_RETOUCH,NULL AS CX_FIELD1,NULL AS CX_FIELD2,NULL AS CX_FIELD3   
FROM 
ods_own.air_asset_request asset_request,
ods_own.air_asset asset,
ods_own.air_photo_import_batch pib,
ods_own.event event,
ods_own.apo apo,
ods_own.sub_program,
RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY SDY,
RAX_APP_USER.EVENT_MODIFIED_DRIVER_PRY PRY     
WHERE 
asset_request.asset_oid = asset.asset_oid
and asset.photo_import_batch_oid = pib.photo_import_batch_oid
and asset_request.status IN ('COMPLETE','Complete')
and asset_request.request_type IN ('PREMIUM_RETOUCH')
and pib.event_id = event.event_ref_id
and event.apo_oid = apo.apo_oid
AND apo.sub_program_oid = sub_program.sub_program_oid
AND event.event_oid = sdy.event_oid
and sdy.event_oid = pry.event_oid
and sdy.eic_date is not null
AND apo.school_year > (SELECT DISTINCT CALENDAR_YEAR FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))
    and asset_request.ods_create_date > (SELECT MIN(DATE_KEY) FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))     
    GROUP BY SDY.SCHOOL_YEAR,SDY.PROCESSING_LAB,SDY.APO_ID,SDY.PROGRAM_ID,SDY.SUB_PROGRAM_ID,SDY.ACCOUNT_ID,SDY.EVENT_ID,             
             SDY.EVENT_REF_ID ,SDY.SUB_PROGRAM_NAME,SDY.SELLING_METHOD  
    )SRC
      ON (TGT.EVENT_ID = SRC.EVENT_ID)          
  WHEN MATCHED THEN
    UPDATE 
     SET    
          TGT.RETOUCH_ORDERED      = SRC.RETOUCH_ORDERED,                        
          TGT.MART_MODIFY_DATE     = SYSDATE 
      WHERE 
      decode(SRC.RETOUCH_ORDERED,TGT.RETOUCH_ORDERED,1,0) = 0

/*-----------------------------------------------*/
/* TASK No. 32 */
/* Merge ServiceRetouch# to Target */

&  

MERGE INTO MART.EVENT_PRELAB_VOLUME_FACT  TGT
USING  
(  
SELECT  
        SDY.SCHOOL_YEAR,SDY.PROCESSING_LAB,SDY.APO_ID,SDY.PROGRAM_ID,SDY.SUB_PROGRAM_ID,
        SDY.ACCOUNT_ID,SDY.EVENT_ID,SDY.EVENT_REF_ID ,SDY.SUB_PROGRAM_NAME,SDY.SELLING_METHOD,
        NULL AS DVD,NULL AS GROUPS,NULL AS COMPOSITES,NULL AS SUBJECTS,NULL AS STUDENTS,
        NULL AS STAFF,NULL AS IMAGES,NULL AS RETOUCH_ORDERED,
        COUNT(asset_request.asset_request_oid) AS SERVICE_RETOUCH,
        NULL AS CX_FIELD1,NULL AS CX_FIELD2,NULL AS CX_FIELD3   
FROM 
ods_own.air_asset_request asset_request,
ods_own.air_asset asset,
ods_own.air_photo_import_batch pib,
ods_own.event event,
ods_own.apo apo,
ods_own.sub_program,
RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY SDY,
RAX_APP_USER.EVENT_MODIFIED_DRIVER_PRY PRY     
WHERE 
asset_request.asset_oid = asset.asset_oid
and asset.photo_import_batch_oid = pib.photo_import_batch_oid
and asset_request.status IN ('COMPLETE','Complete')
and asset_request.request_type IN ('BASIC_RETOUCH')
and pib.event_id = event.event_ref_id
and event.apo_oid = apo.apo_oid
AND apo.sub_program_oid = sub_program.sub_program_oid
AND event.event_oid = sdy.event_oid
and sdy.event_oid = pry.event_oid
and sdy.eic_date is not null
AND apo.school_year > (SELECT DISTINCT CALENDAR_YEAR FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))
    and asset_request.ods_create_date > (SELECT MIN(DATE_KEY) FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))     
    GROUP BY SDY.SCHOOL_YEAR,SDY.PROCESSING_LAB,SDY.APO_ID,SDY.PROGRAM_ID,SDY.SUB_PROGRAM_ID,SDY.ACCOUNT_ID,SDY.EVENT_ID,             
             SDY.EVENT_REF_ID ,SDY.SUB_PROGRAM_NAME,SDY.SELLING_METHOD  
    )SRC
      ON (TGT.EVENT_ID = SRC.EVENT_ID)          
  WHEN MATCHED THEN
    UPDATE 
     SET    
          TGT.SERVICE_RETOUCH      = SRC.SERVICE_RETOUCH,                        
          TGT.MART_MODIFY_DATE     = SYSDATE 
      WHERE 
      decode(SRC.SERVICE_RETOUCH,TGT.SERVICE_RETOUCH,1,0) = 0

/*-----------------------------------------------*/
/* TASK No. 33 */
/* Merge BRT_EDIT# to Target */
&  


MERGE INTO MART.EVENT_PRELAB_VOLUME_FACT  TGT
USING  
(  
SELECT  
        SDY.SCHOOL_YEAR,SDY.PROCESSING_LAB,SDY.APO_ID,SDY.PROGRAM_ID,SDY.SUB_PROGRAM_ID,
        SDY.ACCOUNT_ID,SDY.EVENT_ID,SDY.EVENT_REF_ID ,SDY.SUB_PROGRAM_NAME,SDY.SELLING_METHOD,
        NULL AS DVD,NULL AS GROUPS,NULL AS COMPOSITES,NULL AS SUBJECTS,NULL AS STUDENTS,
        NULL AS STAFF,NULL AS IMAGES,NULL AS RETOUCH_ORDERED,
        NULL AS SERVICE_RETOUCH,COUNT(asset_request.asset_request_oid) AS BRT_EDIT,
        NULL AS CX_FIELD1,NULL AS CX_FIELD2,NULL AS CX_FIELD3   
FROM 
ods_own.air_asset_request asset_request,
ods_own.air_asset asset,
ods_own.air_photo_import_batch pib,
ods_own.event event,
ods_own.apo apo,
ods_own.sub_program,
RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY SDY,
RAX_APP_USER.EVENT_MODIFIED_DRIVER_PRY PRY     
WHERE 
asset_request.asset_oid = asset.asset_oid
and asset.photo_import_batch_oid = pib.photo_import_batch_oid
and asset_request.status IN ('COMPLETE','Complete')
and asset_request.request_type IN ('BRT_EDIT')
and pib.event_id = event.event_ref_id
and event.apo_oid = apo.apo_oid
and apo.sub_program_oid = sub_program.sub_program_oid
and event.event_oid = sdy.event_oid
and sdy.event_oid = pry.event_oid
and sdy.eic_date is not null
and apo.school_year > (SELECT DISTINCT CALENDAR_YEAR FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))
    and asset_request.ods_create_date > (SELECT MIN(DATE_KEY) FROM MART.TIME 
    WHERE CALENDAR_YEAR = (SELECT CALENDAR_YEAR - 2 FROM  MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))     
    GROUP BY SDY.SCHOOL_YEAR,SDY.PROCESSING_LAB,SDY.APO_ID,SDY.PROGRAM_ID,SDY.SUB_PROGRAM_ID,SDY.ACCOUNT_ID,SDY.EVENT_ID,             
             SDY.EVENT_REF_ID ,SDY.SUB_PROGRAM_NAME,SDY.SELLING_METHOD  
    )SRC
      ON (TGT.EVENT_ID = SRC.EVENT_ID)          
  WHEN MATCHED THEN
    UPDATE 
     SET    
          TGT.BRT_EDIT      = SRC.BRT_EDIT,                        
          TGT.MART_MODIFY_DATE     = SYSDATE 
      WHERE 
      decode(SRC.BRT_EDIT,TGT.BRT_EDIT,1,0) = 0
&  
/*-----------------------------------------------*/
/* TASK No. 34 */
/* Drop Driver Table(Primary) */

/* DROP TABLE RAX_APP_USER.EVENT_MODIFIED_DRIVER_PRY  CASCADE CONSTRAINTS */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.EVENT_MODIFIED_DRIVER_PRY  CASCADE CONSTRAINTS';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;

&   

/*-----------------------------------------------*/
/* TASK No. 35 */
/* Drop Driver Table(Secondary) */

/* DROP TABLE RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY CASCADE CONSTRAINTS */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.EVENT_MODIFIED_DRIVER_SDY CASCADE CONSTRAINTS';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    
& 

/*-----------------------------------------------*/
/* Update CDC Load Status  */

UPDATE ODS.DW_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE DW_TABLE_NAME= :v_cdc_load_table_name

& 

/* Insert Audit Record */

INSERT INTO ODS_ETL_OWNER.DW_CDC_LOAD_STATUS_AUDIT
(TABLE_NAME,
SESS_NO,                      
SESS_NAME,                    
SCEN_VERSION,                 
SESS_BEG,                     
ORIG_LAST_CDC_COMPLETION_DATE,
OVERLAP,
CREATE_DATE              
)
values (
:v_cdc_load_table_name,
:v_sess_no,
'LOAD_EVENT_PRELAB_VOLUME_FACT_PKG',
'003',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date_ODS_DM, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          ),
:v_cdc_overlap,
SYSDATE)



&