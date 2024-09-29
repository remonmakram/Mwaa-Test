/* TASK No. 1 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 2 */




/*-----------------------------------------------*/
/* TASK No. 3 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 3 */




/*-----------------------------------------------*/
/* TASK No. 4 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 4 */




/*-----------------------------------------------*/
/* TASK No. 5 */
/* Load SF_Contact_Addresses_XR */

MERGE INTO ODS_STAGE.sf_contact_addresses_xr t
     USING (SELECT s.ID
              FROM ODS_STAGE.SF_CONTACT_STG s,
                          ODS_STAGE.SF_CONTACT_XR xr
             WHERE     s.ID = xr.SF_ID
                   AND NOT EXISTS
                           (SELECT 1
                              FROM ODS_STAGE.sf_errors e
                             WHERE     s.id = e.sf_id
                                   AND e.entity = 'Contact'
                                   AND e.resolve_date IS NULL)
                   AND s.ODS_MODIFY_DATE >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (s.id = t.sf_contact_id)
WHEN NOT MATCHED
THEN
    INSERT     (addresses_oid, sf_contact_id, ods_create_date)
        VALUES (ODS_STAGE.ADDRESSES_OID_SEQ.NEXTVAL,
                s.id,
                SYSDATE)

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Load ods_own.Addresses */

MERGE INTO ODS_OWN.ADDRESSES t
     USING (SELECT xr.ADDRESSES_OID,
                   cxr.CONTACT_OID,
                   s.MAILINGSTREET
                       AS address1,
                   s.MAILINGCITY
                       AS city,
                   s.MAILINGSTATECODE
                       AS state,
                   s.MAILINGPOSTALCODE
                       AS postal_code,
                   s.MAILINGCOUNTRY
                       AS country,
                   CASE WHEN s.isdeleted = 1 THEN 'Y' ELSE 'N' END
                       AS src_delete_flag,
                   ss.SOURCE_SYSTEM_OID,
                   CASE WHEN s.isdeleted = 1 THEN 'N' ELSE 'Y' END
                       AS active_flag
              FROM ODS_STAGE.SF_CONTACT_STG           s,
                   ODS_STAGE.SF_CONTACT_ADDRESSES_XR  xr,
                   ODS_STAGE.SF_CONTACT_XR            cxr,
                   ods_own.source_system              ss
             WHERE     s.ID = xr.SF_CONTACT_ID
                   AND s.ID = cxr.SF_ID
                   AND ss.SOURCE_SYSTEM_SHORT_NAME = 'SF'
                   AND s.ODS_MODIFY_DATE >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (t.addresses_oid = s.addresses_oid)
WHEN NOT MATCHED
THEN
    INSERT     (addresses_oid,
                contact_oid,
                address_type,
                address1,
                city,
                state,
                postal_code,
                country,
                src_delete_flag,
                ods_create_date,
                ods_modify_date,
                source_system_oid,
                active_flag)
        VALUES (s.addresses_oid,
                s.contact_oid,
                20,
                s.address1,
                s.city,
                s.state,
                s.postal_code,
                s.country,
                s.src_delete_flag,
                SYSDATE,
                SYSDATE,
                s.source_system_oid,
                s.active_flag)
WHEN MATCHED
THEN
    UPDATE SET t.contact_oid = s.contact_oid,
               t.address1 = s.address1,
               t.address2 = NULL,
               t.city = s.city,
               t.state = s.state,
               t.postal_code = s.postal_code,
               t.country = s.country,
               t.src_delete_flag = s.src_delete_flag,
               t.active_flag = s.active_flag,
               t.ods_modify_date = SYSDATE
               where DECODE (t.contact_oid, s.contact_oid, 1, 0) = 0
               or DECODE (t.address1, s.address1, 1, 0) = 0
               or DECODE (t.city, s.city, 1, 0) = 0
               or DECODE (t.state, s.state, 1, 0) = 0
               or DECODE (t.postal_code, s.postal_code, 1, 0) = 0
               or DECODE (t.country, s.country, 1, 0) = 0
               or DECODE (t.src_delete_flag, s.src_delete_flag, 1, 0) = 0
               or DECODE (t.active_flag, s.active_flag, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 7 */
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
             SUBSTR('2024-08-28 02:39:31.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/

&


/*-----------------------------------------------*/
/* TASK No. 8 */
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
,'LOAD_SF_CONTACT_ADDRESSES_PKG'
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
30601909200,
'LOAD_SF_CONTACT_ADDRESSES_PKG',
'005',
TO_DATE(
             SUBSTR('2024-08-28 02:39:31.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/


&


/*-----------------------------------------------*/
