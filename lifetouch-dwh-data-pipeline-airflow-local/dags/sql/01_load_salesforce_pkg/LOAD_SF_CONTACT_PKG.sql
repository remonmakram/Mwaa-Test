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

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 5 */




/*-----------------------------------------------*/
/* TASK No. 6 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 6 */




/*-----------------------------------------------*/
/* TASK No. 7 */
/* Identify Missing Parent Account */

 MERGE INTO ODS_STAGE.sf_errors t
     USING (SELECT c.id
              FROM ODS_STAGE.sf_contact_stg  c,
                   ODS_STAGE.SF_ACCOUNT_XR       xr,
                   ODS_OWN.account               a,
                   ODS_STAGE.SF_RecordType_STG rt
             WHERE     c.recordtypeid = rt.id
                   AND xr.ACCOUNT_OID = a.ACCOUNT_OID(+)
                   AND c.ACCOUNTID = xr.SF_ID(+)
                   AND a.ACCOUNT_OID IS NULL
                   AND rt.name = 'NSS - Contacts'
                   and c.ODS_MODIFY_DATE >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
              ) s
        ON (    s.id = t.sf_id
            AND t.ERROR_CODE = '004_MISSING_ACCT'
            AND t.entity = 'Contact'
            AND t.resolve_date IS NULL)
WHEN NOT MATCHED
THEN
    INSERT     (sf_errors_oid,
                entity,
                sf_id,
                ERROR_CODE,
                error_date,
                last_check_date,
                resolve_date)
        VALUES (ODS_STAGE.SF_ERRORS_OID_SEQ.NEXTVAL,
                'Contact',
                s.id,
                '004_MISSING_ACCT',
                SYSDATE,
                '',
                '')

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Identify Non-Numeric LegacyID__C (contact_key) */

 MERGE INTO ODS_STAGE.sf_errors t
     USING (SELECT c.id
              FROM ODS_STAGE.sf_contact_stg  c
             WHERE    (NOT REGEXP_LIKE(legacyid__c, '^-?[0-9.]+$'))
                   and c.ODS_MODIFY_DATE >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
              ) s
        ON (    s.id = t.sf_id
            AND t.ERROR_CODE = '011_NON_NUMERIC_CONTACT_KEY'
            AND t.entity = 'Contact'
            AND t.resolve_date IS NULL)
WHEN NOT MATCHED
THEN
    INSERT     (sf_errors_oid,
                entity,
                sf_id,
                ERROR_CODE,
                error_date,
                last_check_date,
                resolve_date)
        VALUES (ODS_STAGE.SF_ERRORS_OID_SEQ.NEXTVAL,
                'Contact',
                s.id,
                '011_NON_NUMERIC_CONTACT_KEY',
                SYSDATE,
                '',
                '')

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Fix Missing Parent Account */

MERGE INTO ODS_STAGE.sf_errors t
     USING (SELECT c.id,
                   e.sf_errors_oid,
                   CASE
                       WHEN a.account_oid IS NOT NULL THEN SYSDATE
                       ELSE NULL
                   END
                       AS fixed
              FROM ODS_STAGE.sf_contact_stg  c,
                   ODS_STAGE.SF_ACCOUNT_XR       xr,
                   ODS_OWN.account               a,
                   ODS_STAGE.sf_errors           e,
                   ODS_STAGE.SF_RecordType_STG rt
             WHERE     c.ID = e.SF_ID
                   AND c.recordtypeid = rt.id
                   AND c.ACCOUNTID = xr.SF_ID(+)
                   AND xr.ACCOUNT_OID = a.ACCOUNT_OID(+)
                   AND e.ENTITY = 'Contact'
                   AND e.ERROR_CODE = '004_MISSING_ACCT'
                   AND rt.name = 'NSS - Contacts'
                   and e.RESOLVE_DATE is null) s
        ON (t.sf_errors_oid = s.sf_errors_oid)
WHEN MATCHED
THEN
    UPDATE SET t.resolve_date = s.fixed, t.last_check_date = SYSDATE

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Fix Non-Numeric LegacyID__c */

MERGE INTO ODS_STAGE.sf_errors t
     USING (SELECT c.id,
                   e.sf_errors_oid,
                   CASE
                       WHEN REGEXP_LIKE(legacyid__c, '^-?[0-9.]+$') THEN SYSDATE
                       ELSE NULL
                   END
                       AS fixed
              FROM ODS_STAGE.sf_contact_stg  c,
                         ODS_STAGE.sf_errors  e
             WHERE     c.ID = e.SF_ID
                   AND e.ENTITY = 'Contact'
                   AND e.ERROR_CODE = '011_NON_NUMERIC_CONTACT_KEY'
                   and e.RESOLVE_DATE is null) s
        ON (t.sf_errors_oid = s.sf_errors_oid)
WHEN MATCHED
THEN
    UPDATE SET t.resolve_date = s.fixed, t.last_check_date = SYSDATE

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Resolve SF_Errors when isdeleted = 1 */

MERGE INTO ODS_STAGE.SF_ERRORS t
     USING (SELECT e.SF_errors_oid
              FROM ODS_STAGE.SF_ERRORS e, ODS_STAGE.SF_CONTACT_STG s
             WHERE     e.SF_ID = s.ID
                   AND e.ENTITY = 'Contact'
                   AND s.ISDELETED = 1
                   AND e.RESOLVE_DATE IS NULL
                   AND s.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (t.sf_errors_oid = s.sf_errors_oid)
WHEN MATCHED
THEN
    UPDATE SET
        t.resolve_date = TO_DATE ('01011900', 'MMDDYYYY'),
        t.last_check_date = SYSDATE

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Load XR */

MERGE INTO ODS_STAGE.sf_contact_xr t
     USING (SELECT s.id, s.accountid
              FROM ODS_STAGE.SF_CONTACT_STG s,
                         ODS_STAGE.SF_RecordType_STG rt
             WHERE s.recordtypeid = rt.id
             AND rt.name = 'NSS - Contacts'
             AND s.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
AND NOT EXISTS
                           (SELECT 1
                              FROM  ODS_STAGE.sf_errors e
                             WHERE     s.id = e.sf_id
                                   AND e.entity = 'Contact'
                                   AND e.resolve_date IS NULL)) s
        ON (t.sf_id = s.id)
WHEN MATCHED
THEN
    UPDATE SET t.accountid = s.accountid, ods_modify_date = SYSDATE
             WHERE DECODE (t.accountid, s.accountid, 1, 0) = 0
WHEN NOT MATCHED
THEN
    INSERT     (CONTACT_OID,
                SF_ID,
                ACCOUNTID,
                ODS_CREATE_DATE,
                ODS_MODIFY_DATE)
        VALUES (ODS_STAGE.CONTACT_OID_SEQ.nextval,
                s.id,
                s.accountid,
                SYSDATE,
                SYSDATE)

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Load ODS_OWN */

MERGE INTO ODS_OWN.contact t
     USING (SELECT xr.CONTACT_OID,
                   case when c.isdeleted = 1 then 'Y' else 'N' end as src_delete_flag,
                   axr.ACCOUNT_OID,
                   NULL               AS calling_right_oid,
                   ss.SOURCE_SYSTEM_OID,
                   SUBSTR(c.FIRSTNAME,1,50)        AS first_name,
                   SUBSTR(c.LASTNAME,1,50)         AS last_name,
                   SUBSTR(c.SALUTATION,1,20)     AS salutation,
                   SUBSTR(c.NSS_TITLE__C,1,255)     AS title_name,
                   SUBSTR(c.PHONE,1,30)            AS work_phone,
                   SUBSTR(c.MOBILEPHONE,1,30)      AS cell_phone,
                   SUBSTR(c.FAX,1,30)              AS fax_phone,
                   SUBSTR(c.EMAIL,1,120)            AS email_address,
                   TO_NUMBER(c.legacyid__c) as contact_key
              FROM ODS_STAGE.SF_CONTACT_STG  c,
                   ODS_STAGE.sf_contact_xr   xr,
                   ODS_STAGE.SF_ACCOUNT_XR   axr,
                    ODS_STAGE.SF_RecordType_STG rt,
                   ODS_OWN.SOURCE_SYSTEM           ss
             WHERE     c.ID = xr.SF_ID
                   AND xr.ACCOUNTID = axr.SF_ID
                   AND c.recordtypeid = rt.id
                   AND rt.name = 'NSS - Contacts'  
                   AND c.Active__c = 1
                   AND ss.SOURCE_SYSTEM_SHORT_NAME = 'SF'
                   AND c.ods_modify_date  >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
                   AND NOT EXISTS
                           (SELECT 1
                              FROM  ODS_STAGE.sf_errors e
                             WHERE     c.id = e.sf_id
                                   AND e.entity = 'Contact'
                                   AND e.resolve_date IS NULL)) s
        ON (s.contact_oid = t.contact_oid)
WHEN MATCHED
THEN
    UPDATE SET
        t.account_oid = s.account_oid,
        t.src_delete_flag = s.src_delete_flag,
        t.first_name = s.first_name,
        t.last_name = s.last_name,
        t.salutation = s.salutation,
        t.title_name = s.title_name,
        t.work_phone = s.work_phone,
        t.cell_phone = s.cell_phone,
        t.fax_phone = s.fax_phone,
        t.email_address = s.email_address,
        t.contact_key = s.contact_key,
        t.ods_modify_date = SYSDATE,
        t.source_system_oid = s.source_system_oid
             WHERE    DECODE (t.account_oid, s.account_oid, 1, 0) = 0
                   OR DECODE (t.src_delete_flag, s.src_delete_flag, 1, 0) = 0
                   OR DECODE (t.first_name, s.first_name, 1, 0) = 0
                   OR DECODE (t.last_name, s.last_name, 1, 0) = 0
                   OR DECODE (t.salutation, s.salutation, 1, 0) = 0
                   OR DECODE (t.title_name, s.title_name, 1, 0) = 0
                   OR DECODE (t.work_phone, s.work_phone, 1, 0) = 0
                   OR DECODE (t.cell_phone, s.cell_phone, 1, 0) = 0
                   OR DECODE (t.fax_phone, s.fax_phone, 1, 0) = 0
                   OR DECODE (t.email_address, s.email_address, 1, 0) = 0
                   OR DECODE (t.contact_key, s.contact_key, 1, 0) = 0
                   OR DECODE (t.source_system_oid, s.source_system_oid, 1, 0) = 0
 when not matched then insert
                   ( contact_oid,
                   src_delete_flag,
                   account_oid,
                   first_name,
                   last_name,
                   salutation,
                   title_name,
                   work_phone,
                   cell_phone,
                   fax_phone,
                   email_address,
                   contact_key,
                   ods_create_date,
                   ods_modify_date,
                   source_system_oid) 
                   values (
                   s.contact_oid,
                   s.src_delete_flag,
                   s.account_oid,
                   s.first_name,
                   s.last_name,
                   s.salutation,
                   s.title_name,
                   s.work_phone,
                   s.cell_phone,
                   s.fax_phone,
                   s.email_address,
                   s.contact_key,
                   sysdate,
                   sysdate,
                   s.source_system_oid)

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Log Inactive contacts */

INSERT INTO RAX_APP_USER.sf_inactive_contacts_deleted
    (SELECT s.id, c.CONTACT_OID, SYSDATE
       FROM ODS_STAGE.SF_CONTACT_XR   xr,
            ODS_STAGE.SF_CONTACT_STG  s,
            ODS_OWN.CONTACT           c
      WHERE     s.ID = xr.SF_ID
            AND xr.CONTACT_OID = c.CONTACT_OID
            AND NVL (s.ACTIVE__C, 1) = 0
            AND s.ODS_MODIFY_DATE >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap)

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Delete Inactive contacts */

DELETE from  ODS_OWN.CONTACT   oc
WHERE EXISTS 
(SELECT  1
       FROM ODS_STAGE.SF_CONTACT_XR   xr,
            ODS_STAGE.SF_CONTACT_STG  s,
            ODS_OWN.CONTACT           c
      WHERE     s.ID = xr.SF_ID
            AND xr.CONTACT_OID = c.CONTACT_OID
            AND NVL (s.ACTIVE__C, 1) = 0
            AND oc.contact_oid = c.contact_oid
            AND s.ODS_MODIFY_DATE >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap)

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR('2024-08-28 02:39:13.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
+ nvl((TIMEZONE_OFFSET/24), 0) 
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

/*
UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR('2024-08-28 02:39:13.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/

&


/*-----------------------------------------------*/
/* TASK No. 17 */
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
,30601907200
,'LOAD_SF_CONTACT_PKG'
,'027'
,TO_DATE(SUBSTR('2024-08-28 02:39:13.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
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
30601907200,
'LOAD_SF_CONTACT_PKG',
'027',
TO_DATE(
             SUBSTR('2024-08-28 02:39:13.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/


&


/*-----------------------------------------------*/
/* TASK No. 18 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 18 */




/*-----------------------------------------------*/
/* TASK No. 19 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 19 */




/*-----------------------------------------------*/
/* TASK No. 20 */
/* Load Role_XR */

MERGE INTO ODS_STAGE.sf_role_xr t
     USING (SELECT DISTINCT REGEXP_SUBSTR (TRANSLATE (role__c, ',', ';'),
                                           '[^;]+',
                                           1,
                                           n)
                                AS role_name
              FROM ODS_STAGE.SF_CONTACT_STG  s,
                   (    SELECT LEVEL     n
                          FROM DUAL,
                               (SELECT   MAX (
                                             REGEXP_COUNT (
                                                 TRANSLATE (role__c, ',', ';'),
                                                 ';'))
                                       + 1
                                           mcomma
                                  FROM ODS_STAGE.SF_CONTACT_STG)
                    CONNECT BY LEVEL <= mcomma) ctr
             WHERE     ctr.n <= 1 + REGEXP_COUNT (role__c, ';')
                   AND s.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (s.role_name = t.role_name)
WHEN NOT MATCHED
THEN
    INSERT     (role_name, role_oid, ods_create_date)
        VALUES (s.role_name, ODS_STAGE.ROLE_OID_SEQ.NEXTVAL, SYSDATE)

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* Load Role */

MERGE INTO ODS_OWN.ROLE t
     USING (SELECT xr.role_name, xr.role_oid, ss.SOURCE_SYSTEM_OID
              FROM ODS_STAGE.sf_role_xr   xr,
                   ODS_OWN.role           r,
                   ODS_OWN.SOURCE_SYSTEM  ss
             WHERE     xr.ROLE_OID = r.ROLE_OID(+)
                   AND ss.source_system_short_name = 'SF'
                   AND xr.ODS_CREATE_DATE >=TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (t.role_oid = s.role_oid)
WHEN NOT MATCHED
THEN
    INSERT     (role_oid,
                role_name,
                ods_create_date,
                ods_modify_date,
                source_system_oid)
        VALUES (s.role_oid,
                s.role_name,
                SYSDATE,
                SYSDATE,
                s.source_system_oid)

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR('2024-08-28 02:39:13.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
+ nvl((TIMEZONE_OFFSET/24), 0) 
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

/*
UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR('2024-08-28 02:39:13.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/

&


/*-----------------------------------------------*/
/* TASK No. 23 */
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
,30601907200
,'LOAD_SF_CONTACT_PKG'
,'027'
,TO_DATE(SUBSTR('2024-08-28 02:39:13.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
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
30601907200,
'LOAD_SF_CONTACT_PKG',
'027',
TO_DATE(
             SUBSTR('2024-08-28 02:39:13.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/


&


/*-----------------------------------------------*/
/* TASK No. 24 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 24 */




/*-----------------------------------------------*/
/* TASK No. 25 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 25 */




/*-----------------------------------------------*/
/* TASK No. 26 */
/* Load Contact_Role */

merge into ODS_OWN.CONTACT_ROLE t
using (
SELECT c.CONTACT_OID, r.ROLE_OID, ss.SOURCE_SYSTEM_OID
  FROM ODS_OWN.contact          c,
       ODS_STAGE.SF_CONTACT_XR  cxr,
       ODS_OWN.ROLE             r,
       ODS_STAGE.sf_role_xr     rxr,
       ODS_STAGE.SF_CONTACT_STG s,
       ods_own.source_system ss,
       (SELECT DISTINCT id,
                        REGEXP_SUBSTR (TRANSLATE (role__c, ',', ';'),
                                       '[^;]+',
                                       1,
                                       n)
                            AS role_name
          FROM ODS_STAGE.SF_CONTACT_STG,
               (    SELECT LEVEL     n
                      FROM DUAL,
                           (SELECT   MAX (
                                         REGEXP_COUNT (
                                             TRANSLATE (role__c, ',', ';'),
                                             ';'))
                                   + 1
                                       mcomma
                              FROM ODS_STAGE.SF_CONTACT_STG)
                CONNECT BY LEVEL <= mcomma) ctr
         WHERE ctr.n <= 1 + REGEXP_COUNT (role__c, ';')) cr
 WHERE     cr.ID = cxr.SF_ID
       AND cr.ROLE_NAME = rxr.ROLE_NAME
       AND c.CONTACT_OID = cxr.CONTACT_OID
       AND r.ROLE_OID = rxr.ROLE_OID
       and ss.SOURCE_SYSTEM_SHORT_NAME = 'SF'
       and s.id =cxr.SF_ID
       and s.isdeleted != 1
       and s.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
       on (s.contact_oid = t.contact_oid and
       s.role_oid = t.role_oid)
       when not matched then insert (
       contact_role_oid,
       contact_oid,
       role_oid,
       ods_create_date,
       ods_modify_date,
       source_system_oid)
       values (
       ODS_STAGE.CONTACT_ROLE_OID_SEQ.NEXTVAL,
       s.contact_oid,
       s.role_oid,
       sysdate,
       sysdate,
       s.source_system_oid)

&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* Drop ODS driver table */


BEGIN
    EXECUTE IMMEDIATE 'drop table ods_contact_role_dr';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -942 THEN
            DBMS_OUTPUT.PUT_LINE('Table does not exist.');
        ELSE
            RAISE;
        END IF;
END; 

&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* Drop SF driver table */



BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE sf_contact_role_dr';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -942 THEN
            DBMS_OUTPUT.PUT_LINE('Table does not exist.');
        ELSE
            RAISE;
        END IF;
END; 

&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* Create ODS driver table */

CREATE TABLE ods_contact_role_dr
AS
    SELECT cr.contact_role_oid,
           cr.contact_oid,
           cr.role_oid,
           r.ROLE_NAME,
           s.ID
      FROM ODS_OWN.contact_role      cr,
           ODS_OWN.ROLE              r,
           ODS_STAGE.SF_CONTACT_XR   xr,
           ODS_STAGE.SF_CONTACT_STG  s,
           ODS_OWN.SOURCE_SYSTEM     ss
     WHERE     cr.CONTACT_OID = xr.CONTACT_OID
           AND xr.SF_ID = s.ID
           AND cr.ROLE_OID = r.ROLE_OID
           AND s.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
           AND cr.source_system_oid = ss.source_system_oid
           AND ss.source_system_short_name = 'SF'

&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* Create SF driver table  */

CREATE TABLE sf_contact_role_dr
AS
    SELECT DISTINCT id,
                    xr.CONTACT_OID,
                    REGEXP_SUBSTR (TRANSLATE (role__c, ',', ';'),
                                   '[^;]+',
                                   1,
                                   n)
                        AS role_name
      FROM ODS_STAGE.SF_CONTACT_STG  s,
           (    SELECT LEVEL     n
                  FROM DUAL,
                       (SELECT   MAX (
                                     REGEXP_COUNT (TRANSLATE (role__c, ',', ';'),
                                                   ';'))
                               + 1
                                   mcomma
                          FROM ODS_STAGE.SF_CONTACT_STG)
            CONNECT BY LEVEL <= mcomma) ctr,
           ODS_STAGE.SF_CONTACT_XR   xr
     WHERE     ctr.n <= 1 + REGEXP_COUNT (role__c, ';')
           AND s.ID = xr.SF_ID
           AND s.ODS_MODIFY_DATE >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap

&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* Handle Deleted Contact Roles */

delete from ODS_OWN.contact_role
where contact_role_oid in
(
SELECT contact_role_oid
  FROM ods_contact_role_dr odr
 WHERE     NOT EXISTS
               (SELECT 1
                  FROM sf_contact_role_dr sdr
                 WHERE     odr.CONTACT_OID = sdr.CONTACT_OID
                       AND odr.ROLE_NAME = sdr.ROLE_NAME)
       AND EXISTS
               (SELECT 1
                  FROM sf_contact_role_dr sdr2
                 WHERE sdr2.CONTACT_OID = odr.CONTACT_OID)
)

&


/*-----------------------------------------------*/
/* TASK No. 32 */
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
             SUBSTR('2024-08-28 02:39:13.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/

&


/*-----------------------------------------------*/
/* TASK No. 33 */
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
,'LOAD_SF_CONTACT_PKG'
,'027'
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
30601907200,
'LOAD_SF_CONTACT_PKG',
'027',
TO_DATE(
             SUBSTR('2024-08-28 02:39:13.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/


&


/*-----------------------------------------------*/
