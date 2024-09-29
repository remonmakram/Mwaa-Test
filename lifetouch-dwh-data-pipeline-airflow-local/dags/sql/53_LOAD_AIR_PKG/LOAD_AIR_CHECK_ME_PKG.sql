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

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 6 */




/*-----------------------------------------------*/
/* TASK No. 7 */
/* MERGE INTO ODS_STAGE.AIR_CHECK_ME_XR */

MERGE INTO ODS_STAGE.AIR_CHECK_ME_XR T USING
(SELECT S.ID,
  S.ASSET_ID
FROM ODS_STAGE.AIR_CHECK_ME_STG S,
  ODS_STAGE.AIR_ASSET_XR AIR_ASSET_XR
WHERE 1                = 1
AND S.ASSET_ID         = AIR_ASSET_XR.ID(+)
AND S.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap
) S ON (T.ID           = S.ID)
WHEN NOT MATCHED THEN
  INSERT
    (
      T.CHECK_ME_OID ,
      T.ID ,
      T.ASSET_ID ,
      T.ODS_CREATE_DATE ,
      T.ODS_MODIFY_DATE
    )
    VALUES
    (
      ODS_STAGE.AIR_CHECK_ME_OID_SEQ.NEXTVAL,
      S.ID,
      S.ASSET_ID,
      SYSDATE,
      SYSDATE
    )
    WHEN MATCHED THEN
  UPDATE
  SET T.ASSET_ID                             = S.ASSET_ID,
    T.ODS_MODIFY_DATE                        = SYSDATE
  WHERE DECODE(S.ASSET_ID, T.ASSET_ID, 1, 0) = 0 

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* MERGE INTO ODS_OWN.AIR_CHECK_ME */

MERGE INTO ODS_OWN.AIR_CHECK_ME T USING
(SELECT XR.CHECK_ME_OID ,
  STG.ID ,
  ASSET.ASSET_OID ,
 STG.FACE ,
 STG.FACE_REASON ,
 STG.HEAD_POINTS ,
 STG.HEAD_POINTS_REASON ,
  STG.CHIN ,
 STG.CHIN_REASON ,
  STG.COLOR ,
  STG.COLOR_REASON ,
  STG.CAMERA ,
  STG.CAMERA_REASON ,
  STG.MULTI_SUBJECT ,
  STG.MULTI_SUBJECT_REASON ,
  STG.ORIENTATION ,
  STG.ORIENTATION_REASON ,
  STG.FRAME_TYPE ,
  STG.FRAME_TYPE_REASON ,
  STG.CREATE_DATE ,
  STG.MODIFIED_DATE ,
  STG.VERSION ,
  STG.ASSET_ID ,
  STG.OFF_EDGE ,
  STG.OFF_EDGE_REASON ,
  STG.MANUAL_CROP ,
  STG.MANUAL_CROP_REASON ,
  SS.SOURCE_SYSTEM_OID
FROM ODS_STAGE.AIR_CHECK_ME_STG STG,
  ODS_STAGE.AIR_CHECK_ME_XR XR,
  ODS_OWN.AIR_ASSET ASSET,
  ODS_OWN.SOURCE_SYSTEM SS
WHERE 1                         = 1
AND STG.ID                      = XR.ID
AND XR.ASSET_ID                 = ASSET.ID(+)
AND SS.SOURCE_SYSTEM_SHORT_NAME = 'AIR'
AND STG.ods_modify_date        >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap
) S ON (T.CHECK_ME_OID          = S.CHECK_ME_OID)
WHEN MATCHED THEN
  UPDATE
  SET T.ASSET_OID                                                   = S.ASSET_OID ,
  T.ID=S.ID,
    T.FACE                                                                  =S.FACE,
    T.FACE_REASON                                                  = S.FACE_REASON,
    T.HEAD_POINTS                                                  =S.HEAD_POINTS,
    T.HEAD_POINTS_REASON                                   =S.HEAD_POINTS_REASON,
    T.CHIN                                                                  =S.CHIN,
    T.CHIN_REASON                                                  =S.CHIN_REASON,
    T.COLOR                                                               =S.COLOR,
    T.COLOR_REASON                                               =S.COLOR_REASON,
    T.CAMERA                                                            =S.CAMERA,
    T.CAMERA_REASON                                             =S.CAMERA_REASON,
    T.MULTI_SUBJECT                                                =S.MULTI_SUBJECT,
    T.MULTI_SUBJECT_REASON                                =S.MULTI_SUBJECT_REASON,
    T.ORIENTATION                                                    =S.ORIENTATION,
    T.ORIENTATION_REASON                                    =S.ORIENTATION_REASON,
    T.FRAME_TYPE                                                      =S.FRAME_TYPE,
    T.FRAME_TYPE_REASON                                       = S.FRAME_TYPE_REASON,
    T.CREATE_DATE                                                    = S.CREATE_DATE ,
    T.MODIFIED_DATE                                                 = S.MODIFIED_DATE ,
    T.VERSION                                                             = S.VERSION ,
    T.ASSET_ID                                                            =S.ASSET_ID,
    T.OFF_EDGE                                                           =S.OFF_EDGE,
    T.OFF_EDGE_REASON                                            =S.OFF_EDGE_REASON,
    T.MANUAL_CROP                                                     =S.MANUAL_CROP,
    T.MANUAL_CROP_REASON                                      =S.MANUAL_CROP_REASON,
    T.ODS_MODIFY_DATE                                              = SYSDATE ,
    T.SOURCE_SYSTEM_OID                                           = S.SOURCE_SYSTEM_OID
  WHERE DECODE (S.ASSET_OID, T.ASSET_OID, 1, 0)                   = 0
 OR DECODE (S.ID, T.ID, 1, 0)                   = 0
  OR DECODE (S.FACE, T.FACE, 1, 0)                                = 0
  OR DECODE (S.FACE_REASON, T.FACE_REASON, 1, 0)                  = 0
  OR DECODE (S.HEAD_POINTS, T.HEAD_POINTS, 1, 0)                  = 0
  OR DECODE (S.HEAD_POINTS_REASON, T.HEAD_POINTS_REASON, 1, 0)    = 0
  OR DECODE (S.CHIN, T.CHIN, 1, 0)                                = 0
  OR DECODE (S.CHIN_REASON, T.CHIN_REASON, 1,0)                   = 0
  OR DECODE (S.COLOR, T.COLOR, 1, 0)                              = 0
  OR DECODE (S.COLOR_REASON, T.COLOR_REASON, 1, 0)                = 0
  OR DECODE (S.CAMERA, T.CAMERA, 1, 0)                = 0
 OR DECODE (S.CAMERA_REASON, T.CAMERA_REASON, 1, 0)                = 0
  OR DECODE (S.MULTI_SUBJECT, T.MULTI_SUBJECT, 1, 0)              = 0
  OR DECODE (S.MULTI_SUBJECT_REASON, T.MULTI_SUBJECT_REASON, 1,0) = 0
  OR DECODE (S.ORIENTATION, T.ORIENTATION, 1, 0)                  = 0
  OR DECODE (S.ORIENTATION_REASON, T.ORIENTATION_REASON, 1, 0)    = 0
  OR DECODE (S.FRAME_TYPE, T.FRAME_TYPE, 1,0)                     = 0
  OR DECODE (S.FRAME_TYPE_REASON, T.FRAME_TYPE_REASON, 1, 0)      = 0
  OR DECODE (S.CREATE_DATE, T.CREATE_DATE, 1, 0)                  = 0
  OR DECODE (S.MODIFIED_DATE, T.MODIFIED_DATE, 1, 0)              = 0
  OR DECODE (S.VERSION, T.VERSION, 1, 0)                          = 0
  OR DECODE (S.ASSET_ID, T.ASSET_ID, 1,0)                         = 0
  OR DECODE (S.OFF_EDGE, T.OFF_EDGE, 1, 0)                        = 0
  OR DECODE (S.OFF_EDGE_REASON, T.OFF_EDGE_REASON, 1,0)           = 0
  OR DECODE (S.MANUAL_CROP, T.MANUAL_CROP, 1, 0)                  = 0
  OR DECODE (S.MANUAL_CROP_REASON, T.MANUAL_CROP_REASON, 1, 0)    = 0
  OR DECODE (S.SOURCE_SYSTEM_OID, T.SOURCE_SYSTEM_OID, 1, 0)      = 0 WHEN NOT MATCHED THEN
  INSERT
    (
      T.CHECK_ME_OID,
      T.ID    ,
      T.ASSET_OID ,
      T.FACE ,
      T.FACE_REASON ,
      T.HEAD_POINTS ,
      T.HEAD_POINTS_REASON ,
      T.CHIN ,
      T.CHIN_REASON,
      T.COLOR,
      T.COLOR_REASON ,
      T.CAMERA,
      T.CAMERA_REASON,
      T.MULTI_SUBJECT ,
      T.MULTI_SUBJECT_REASON,
      T.ORIENTATION ,
      T.ORIENTATION_REASON,
      T.FRAME_TYPE ,
      T.FRAME_TYPE_REASON,
      T.CREATE_DATE ,
      T.MODIFIED_DATE ,
      T.VERSION ,
      T.ASSET_ID ,
      T.OFF_EDGE ,
      T.OFF_EDGE_REASON ,
      T.MANUAL_CROP ,
      T.MANUAL_CROP_REASON,
      T.SOURCE_SYSTEM_OID,
      T.ODS_CREATE_DATE ,
      T.ODS_MODIFY_DATE
    )
    VALUES
    (
      S.CHECK_ME_OID,
     S.ID,
      S.ASSET_OID ,
     S.FACE ,
      S.FACE_REASON ,
      S.HEAD_POINTS ,
      S.HEAD_POINTS_REASON ,
      S.CHIN ,
      S.CHIN_REASON,
      S.COLOR,
      S.COLOR_REASON ,
      S.CAMERA,
      S.CAMERA_REASON,
      S.MULTI_SUBJECT ,
      S.MULTI_SUBJECT_REASON,
      S.ORIENTATION ,
      S.ORIENTATION_REASON,
      S.FRAME_TYPE ,
      S.FRAME_TYPE_REASON,
      S.CREATE_DATE ,
      S.MODIFIED_DATE ,
      S.VERSION ,
      S.ASSET_ID ,
      S.OFF_EDGE ,
      S.OFF_EDGE_REASON ,
      S.MANUAL_CROP ,
      S.MANUAL_CROP_REASON,
      S.SOURCE_SYSTEM_OID,
      SYSDATE ,
      SYSDATE
    )

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Handle late arriving ASSET_OID */

----Handle late arriving ASSET_OID
MERGE INTO ODS_OWN.AIR_CHECK_ME T
USING (
SELECT 
ASSET.ASSET_OID,
AIR_CHECK_ME.CHECK_ME_OID,
SYSDATE AS ODS_MODIFY_DATE 
FROM  ODS_OWN.AIR_CHECK_ME,
      ODS_STAGE.AIR_CHECK_ME_XR,
      ODS_OWN.AIR_ASSET ASSET
WHERE AIR_CHECK_ME.CHECK_ME_OID = AIR_CHECK_ME_XR.CHECK_ME_OID
AND AIR_CHECK_ME_XR.ASSET_ID = ASSET.ID
AND AIR_CHECK_ME_XR.ASSET_ID IS NOT NULL
AND AIR_CHECK_ME.ASSET_OID IS NULL
AND ASSET.ODS_CREATE_DATE > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') -:v_cdc_overlap
) S
ON (T.CHECK_ME_OID = S.CHECK_ME_OID)
WHEN MATCHED THEN UPDATE SET
     T.ASSET_OID = S.ASSET_OID
    ,T.ODS_MODIFY_DATE = S.ODS_MODIFY_DATE
WHERE 
    decode(S.ASSET_OID,T.ASSET_OID,1,0) = 0
    

&


/*-----------------------------------------------*/
/* TASK No. 10 */
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
/* TASK No. 11 */
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
,'LOAD_AIR_CHECK_ME_PKG'
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
'LOAD_AIR_CHECK_ME_PKG',
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
