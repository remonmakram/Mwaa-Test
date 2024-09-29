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
/* Drop Driver Table */

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.tmp_IMAGE_MODIFY_DATE_DRIVER';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;


&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Create Driver Table */

CREATE TABLE RAX_APP_USER.tmp_IMAGE_MODIFY_DATE_DRIVER
(
    image_oid        NUMBER,
    modified_date    DATE,
    source_table     VARCHAR2 (30)
)

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Load from Asset table */

INSERT INTO RAX_APP_USER.tmp_IMAGE_MODIFY_DATE_DRIVER (image_oid,
                                                       modified_date,
                                                       source_table)
      SELECT i.IMAGE_OID, MAX (a.modified_date), 'ASSET'
        FROM ODS_OWN.IMAGE i, ODS_OWN.AIR_ASSET a
       WHERE i.ASSET_ID = a.ID AND a.MODIFIED_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap
    GROUP BY i.IMAGE_OID

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Load from Recipe table */

INSERT INTO RAX_APP_USER.tmp_IMAGE_MODIFY_DATE_DRIVER (image_oid,
                                                       modified_date,
                                                       source_table)
      SELECT i.IMAGE_OID, MAX (stg.modified_date), 'RECIPE'
        FROM ods_own.image i, ods_stage.air_recipe_stg stg
       WHERE i.ASSET_ID = stg.ASSET_ID AND stg.MODIFIED_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap
    GROUP BY i.IMAGE_OID

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Load from Attribute table */

INSERT INTO RAX_APP_USER.tmp_IMAGE_MODIFY_DATE_DRIVER (image_oid,
                                                       modified_date,
                                                       source_table)
      SELECT i.IMAGE_OID, MAX (stg.modified_date), 'ATTRIBUTE'
        FROM ods_own.image i, ods_stage.air_attribute_stg stg
       WHERE i.ASSET_ID = stg.ASSET_ID AND stg.MODIFIED_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap
    GROUP BY i.IMAGE_OID

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Load from Image table */

INSERT INTO RAX_APP_USER.tmp_IMAGE_MODIFY_DATE_DRIVER (image_oid,
                                                       modified_date,
                                                       source_table)
      SELECT i.IMAGE_OID, MAX (ai.MODIFIED_DATE), 'IMAGE'
        FROM ods_own.image                i,
             ODS_STAGE.AIR_IMAGE_GROUP_STG ig,
             ODS_STAGE.AIR_IMAGE_STG      ai
       WHERE     i.ASSET_ID = ig.ASSET_ID
             AND ig.id = ai.IMAGE_GROUP_ID
             AND ai.MODIFIED_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_oms_overlap
    GROUP BY i.IMAGE_OID

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Create Index */

CREATE INDEX RAX_APP_USER.TMP_IMAGE_MODI_DATE_DRIVER_ix1 ON RAX_APP_USER.TMP_IMAGE_MODIFY_DATE_DRIVER
(IMAGE_OID)

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Merge into ods_own.image */

MERGE INTO ODS_OWN.IMAGE D
     USING (  SELECT IMAGE_OID,
                     FROM_TZ (CAST (MAX (MODIFIED_DATE) AS TIMESTAMP), 'UTC')
                         AT TIME ZONE 'US/Central'
                         AS MODIFIED_DATE
                FROM RAX_APP_USER.TMP_IMAGE_MODIFY_DATE_DRIVER
            GROUP BY image_oid) s
        ON (s.image_oid = d.image_oid)
WHEN MATCHED
THEN
    UPDATE SET
        d.image_modify_date = s.modified_date, d.ods_modify_date = SYSDATE
             WHERE DECODE (s.modified_date, d.image_modify_date, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 12 */
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
/* TASK No. 13 */
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
,'UPDATE_IMAGE_MODIFY_DATE_AIR_PKG'
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
'UPDATE_IMAGE_MODIFY_DATE_AIR_PKG',
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
