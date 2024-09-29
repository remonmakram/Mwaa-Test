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
/* Load XR 'Yearbook Mailing' Addresses */

MERGE INTO ODS_STAGE.sf_account_addresses_xr t
     USING (SELECT s.ID,
                   CASE
                       WHEN s.USE_OF_SECONDARY_ADDRESS__C LIKE
                                '%Yearbook Invoice%'
                       THEN
                           'Shipping'
                       ELSE
                           'Billing'
                   END
                       AS sf_account_address_type,
                   'Yearbook Mailing'
                       AS ods_address_type
              FROM ODS_STAGE.SF_ACCOUNT_STG s, ODS_STAGE.SF_ACCOUNT_XR xr
             WHERE     s.ID = xr.SF_ID
                   AND NOT EXISTS
                           (SELECT 1
                              FROM ODS_STAGE.sf_errors e
                             WHERE     s.id = e.sf_id
                                   AND e.entity = 'Account'
                                   AND e.resolve_date IS NULL)
                   AND s.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (    s.id = t.sf_account_id
            AND s.ods_address_type = t.ods_address_type)
WHEN NOT MATCHED
THEN
    INSERT     (addresses_oid,
                sf_account_id,
                SF_ACCOUNT_ADDRESS_TYPE,
                ods_address_type,
                ods_create_date,
                ods_modify_date)
        VALUES (ODS_STAGE.ADDRESSES_OID_SEQ.NEXTVAL,
                s.id,
                s.sf_account_address_type,
                s.ods_address_type,
                SYSDATE,
                SYSDATE)
WHEN MATCHED
THEN
    UPDATE SET
        t.sf_account_address_type = s.sf_account_address_type, t.ods_modify_date = SYSDATE
             WHERE DECODE (t.sf_account_address_type, s.sf_account_address_type, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Load XR 'Physical' Addresses */

MERGE INTO ODS_STAGE.sf_account_addresses_xr t
     USING (SELECT s.ID,
                   'Billing'      AS sf_account_address_type,
                   'Physical'     AS ods_address_type
              FROM ODS_STAGE.SF_ACCOUNT_STG s, ODS_STAGE.SF_ACCOUNT_XR xr
             WHERE     s.ID = xr.SF_ID
                   AND NOT EXISTS
                           (SELECT 1
                              FROM ODS_STAGE.sf_errors e
                             WHERE     s.id = e.sf_id
                                   AND e.entity = 'Account'
                                   AND e.resolve_date IS NULL)
                   AND s.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (    s.id = t.sf_account_id
            AND s.ods_address_type = t.ods_address_type)
WHEN NOT MATCHED
THEN
    INSERT     (addresses_oid,
                sf_account_id,
                SF_ACCOUNT_ADDRESS_TYPE,
                ods_address_type,
                ods_create_date,
                ods_modify_date)
        VALUES (ODS_STAGE.ADDRESSES_OID_SEQ.NEXTVAL,
                s.id,
                s.sf_account_address_type,
                s.ods_address_type,
                SYSDATE,
                sysdate)

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Load XR 'General Mailing' Addresses */

MERGE INTO ODS_STAGE.sf_account_addresses_xr t
     USING (SELECT s.ID,
                   'Shipping'      AS sf_account_address_type,
                   'General Mailing'     AS ods_address_type
              FROM ODS_STAGE.SF_ACCOUNT_STG s, ODS_STAGE.SF_ACCOUNT_XR xr
             WHERE     s.ID = xr.SF_ID
                   AND NOT EXISTS
                           (SELECT 1
                              FROM ODS_STAGE.sf_errors e
                             WHERE     s.id = e.sf_id
                                   AND e.entity = 'Account'
                                   AND e.resolve_date IS NULL)
                   AND s.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (    s.id = t.sf_account_id
            AND s.ods_address_type = t.ods_address_type)
WHEN NOT MATCHED
THEN
    INSERT     (addresses_oid,
                sf_account_id,
                SF_ACCOUNT_ADDRESS_TYPE,
                ods_address_type,
                ods_create_date,
                ods_modify_date)
        VALUES (ODS_STAGE.ADDRESSES_OID_SEQ.NEXTVAL,
                s.id,
                s.sf_account_address_type,
                s.ods_address_type,
                SYSDATE,
                sysdate)

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Load 'Yearbook Mailing' Addresses */

MERGE INTO ODS_OWN.ADDRESSES t
     USING (SELECT xr.ADDRESSES_OID,
                   axr.ACCOUNT_OID,
                   CASE
                       WHEN s.USE_OF_SECONDARY_ADDRESS__C LIKE
                                '%Yearbook Invoice%'
                       THEN s.ShippingStreet
                       ELSE s.BillingStreet end
                       AS address1,
                   CASE
                       WHEN s.USE_OF_SECONDARY_ADDRESS__C LIKE
                                '%Yearbook Invoice%'
                       THEN s.ShippingCity
                       ELSE s.BillingCity end
                       AS city,
                   CASE
                       WHEN s.USE_OF_SECONDARY_ADDRESS__C LIKE
                                '%Yearbook Invoice%'
                       THEN s.ShippingStateCode
                       ELSE s.BillingStateCode end
                       AS state,
                   CASE
                       WHEN s.USE_OF_SECONDARY_ADDRESS__C LIKE
                                '%Yearbook Invoice%'
                       THEN s.ShippingPostalCode
                       ELSE s.BillingPostalCode end
                       AS postal_code,
                   CASE
                       WHEN s.USE_OF_SECONDARY_ADDRESS__C LIKE
                                '%Yearbook Invoice%'
                       THEN s.ShippingCountry
                       ELSE s.BillingCountry end
                       AS country,
                   CASE WHEN s.isdeleted = 1 THEN 'Y' ELSE 'N' END
                       AS src_delete_flag,
                   ss.SOURCE_SYSTEM_OID
              FROM ODS_STAGE.SF_ACCOUNT_STG           s,
                   ODS_STAGE.SF_ACCOUNT_ADDRESSES_XR  xr,
                   ODS_STAGE.SF_ACCOUNT_XR            axr,
                   ods_own.source_system              ss
             WHERE     s.ID = xr.SF_ACCOUNT_ID
                   AND s.ID = axr.SF_ID
                   and xr.ODS_ADDRESS_TYPE = 'Yearbook Mailing'
                   AND ss.SOURCE_SYSTEM_SHORT_NAME = 'SF'
                   AND s.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (t.addresses_oid = s.addresses_oid)
WHEN NOT MATCHED
THEN
    INSERT     (addresses_oid,
                account_oid,
                address_type,
                address_type_desc,
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
                s.account_oid,
                150,
                'Yearbook Mailing',
                s.address1,
                s.city,
                s.state,
                s.postal_code,
                s.country,
                s.src_delete_flag,
                SYSDATE,
                SYSDATE,
                s.source_system_oid,
                'Y')
WHEN MATCHED
THEN
    UPDATE SET t.account_oid = s.account_oid,
               t.address1 = s.address1,
               t.address2 = NULL,
               t.city = s.city,
               t.state = s.state,
               t.postal_code = s.postal_code,
               t.country = s.country,
               t.src_delete_flag = s.src_delete_flag,
               t.ods_modify_date = SYSDATE
               where DECODE (t.account_oid, s.account_oid, 1, 0) = 0
               or DECODE (t.address1, s.address1, 1, 0) = 0
               or DECODE (t.city, s.city, 1, 0) = 0
               or DECODE (t.state, s.state, 1, 0) = 0
               or DECODE (t.postal_code, s.postal_code, 1, 0) = 0
               or DECODE (t.country, s.country, 1, 0) = 0
               or DECODE (t.src_delete_flag, s.src_delete_flag, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Load 'Physical' Addresses */

MERGE INTO ODS_OWN.ADDRESSES t
     USING (SELECT xr.ADDRESSES_OID,
                   axr.ACCOUNT_OID,
                   s.BillingStreet
                       AS address1,
                   s.BillingCity
                       AS city,
                   s.BillingStateCode
                       AS state,
                   s.BillingPostalCode
                       AS postal_code,
                   s.BillingCountry
                       AS country,
                   CASE WHEN s.isdeleted = 1 THEN 'Y' ELSE 'N' END
                       AS src_delete_flag,
                   ss.SOURCE_SYSTEM_OID
              FROM ODS_STAGE.SF_ACCOUNT_STG           s,
                   ODS_STAGE.SF_ACCOUNT_ADDRESSES_XR  xr,
                   ODS_STAGE.SF_ACCOUNT_XR            axr,
                   ods_own.source_system              ss
             WHERE     s.ID = xr.SF_ACCOUNT_ID
                   AND s.ID = axr.SF_ID
                   AND xr.ODS_ADDRESS_TYPE = 'Physical'
                   AND ss.SOURCE_SYSTEM_SHORT_NAME = 'SF'
                   AND s.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (t.addresses_oid = s.addresses_oid)
WHEN NOT MATCHED
THEN
    INSERT     (addresses_oid,
                account_oid,
                address_type,
                address_type_desc,
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
                s.account_oid,
                40,
                'Physical',
                s.address1,
                s.city,
                s.state,
                s.postal_code,
                s.country,
                s.src_delete_flag,
                SYSDATE,
                SYSDATE,
                s.source_system_oid,
                'Y')
WHEN MATCHED
THEN
    UPDATE SET
        t.account_oid = s.account_oid,
        t.address1 = s.address1,
        t.address2 = NULL,
        t.city = s.city,
        t.state = s.state,
        t.postal_code = s.postal_code,
        t.country = s.country,
        t.src_delete_flag = s.src_delete_flag,
        t.ods_modify_date = SYSDATE
             WHERE    DECODE (t.account_oid, s.account_oid, 1, 0) = 0
                   OR DECODE (t.address1, s.address1, 1, 0) = 0
                   OR DECODE (t.city, s.city, 1, 0) = 0
                   OR DECODE (t.state, s.state, 1, 0) = 0
                   OR DECODE (t.postal_code, s.postal_code, 1, 0) = 0
                   OR DECODE (t.country, s.country, 1, 0) = 0
                   OR DECODE (t.src_delete_flag, s.src_delete_flag, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Load 'General Mailing' Addresses */

MERGE INTO ODS_OWN.ADDRESSES t
     USING (SELECT xr.ADDRESSES_OID,
                   axr.ACCOUNT_OID,
                   s.ShippingStreet
                       AS address1,
                   s.ShippingCity
                       AS city,
                   s.ShippingStateCode
                       AS state,
                   s.ShippingPostalCode
                       AS postal_code,
                   s.ShippingCountry
                       AS country,
                   CASE WHEN s.isdeleted = 1 THEN 'Y' ELSE 'N' END
                       AS src_delete_flag,
                   ss.SOURCE_SYSTEM_OID
              FROM ODS_STAGE.SF_ACCOUNT_STG           s,
                   ODS_STAGE.SF_ACCOUNT_ADDRESSES_XR  xr,
                   ODS_STAGE.SF_ACCOUNT_XR            axr,
                   ods_own.source_system              ss
             WHERE     s.ID = xr.SF_ACCOUNT_ID
                   AND s.ID = axr.SF_ID
                   AND xr.ODS_ADDRESS_TYPE = 'General Mailing'
                   AND ss.SOURCE_SYSTEM_SHORT_NAME = 'SF'
                   AND s.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (t.addresses_oid = s.addresses_oid)
WHEN NOT MATCHED
THEN
    INSERT     (addresses_oid,
                account_oid,
                address_type,
                address_type_desc,
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
                s.account_oid,
                10,
                'General Mailing',
                s.address1,
                s.city,
                s.state,
                s.postal_code,
                s.country,
                s.src_delete_flag,
                SYSDATE,
                SYSDATE,
                s.source_system_oid,
                'Y')
WHEN MATCHED
THEN
    UPDATE SET
        t.account_oid = s.account_oid,
        t.address1 = s.address1,
        t.address2 = NULL,
        t.city = s.city,
        t.state = s.state,
        t.postal_code = s.postal_code,
        t.country = s.country,
        t.src_delete_flag = s.src_delete_flag,
        t.ods_modify_date = SYSDATE
             WHERE    DECODE (t.account_oid, s.account_oid, 1, 0) = 0
                   OR DECODE (t.address1, s.address1, 1, 0) = 0
                   OR DECODE (t.city, s.city, 1, 0) = 0
                   OR DECODE (t.state, s.state, 1, 0) = 0
                   OR DECODE (t.postal_code, s.postal_code, 1, 0) = 0
                   OR DECODE (t.country, s.country, 1, 0) = 0
                   OR DECODE (t.src_delete_flag, s.src_delete_flag, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 11 */
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
             SUBSTR('2024-08-28 02:39:33.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/

&


/*-----------------------------------------------*/
/* TASK No. 12 */
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
,'LOAD_SF_ACCOUNT_ADDRESSES_PKG'
,'007'
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
30601910200,
'LOAD_SF_ACCOUNT_ADDRESSES_PKG',
'007',
TO_DATE(
             SUBSTR('2024-08-28 02:39:33.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/


&


/*-----------------------------------------------*/
