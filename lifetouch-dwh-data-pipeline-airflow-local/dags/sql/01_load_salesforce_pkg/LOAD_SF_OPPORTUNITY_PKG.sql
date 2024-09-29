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
     USING (SELECT o.id
              FROM ODS_STAGE.sf_opportunity_stg  o,
                   ODS_STAGE.SF_RECORDTYPE_STG  rt,
                   ODS_STAGE.SF_ACCOUNT_XR       xr,
                   ODS_OWN.account               a
             WHERE     xr.ACCOUNT_OID = a.ACCOUNT_OID(+)
                   AND o.ACCOUNTID = xr.SF_ID(+)
                   AND a.ACCOUNT_OID IS NULL
                   AND substr(o.NSS_YEAR__C, 6, 4) is not null
                   AND o.recordtypeid = rt.id
                   AND rt.name not in ('Special')
                   and o.ODS_MODIFY_DATE  >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (    s.id = t.sf_id
            AND t.ERROR_CODE = '004_MISSING_ACCT'
            AND t.entity = 'Opportunity'
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
                'Opportunity',
                s.id,
                '004_MISSING_ACCT',
                SYSDATE,
                '',
                '')

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Fix Missing Parent Account */

MERGE INTO ODS_STAGE.sf_errors t
     USING (SELECT o.id,
                   e.sf_errors_oid,
                   CASE
                       WHEN a.account_oid IS NOT NULL THEN SYSDATE
                       ELSE NULL
                   END
                       AS fixed
              FROM ODS_STAGE.sf_opportunity_stg  o,
                   ODS_STAGE.SF_ACCOUNT_XR       xr,
                   ODS_OWN.account               a,
                   ODS_STAGE.sf_errors           e
             WHERE     o.ID = e.SF_ID
                   AND o.ACCOUNTID = xr.SF_ID(+)
                   AND xr.ACCOUNT_OID = a.ACCOUNT_OID(+)
                   AND e.ENTITY = 'Opportunity'
                   AND e.ERROR_CODE = '004_MISSING_ACCT'
                   and e.RESOLVE_DATE is null) s
        ON (t.sf_errors_oid = s.sf_errors_oid)
WHEN MATCHED
THEN
    UPDATE SET t.resolve_date = s.fixed, t.last_check_date = SYSDATE

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Resolve SF_Errors when isdeleted = 1 */

MERGE INTO ODS_STAGE.SF_ERRORS t
     USING (SELECT e.SF_errors_oid
              FROM ODS_STAGE.SF_ERRORS e, ODS_STAGE.SF_OPPORTUNITY_STG s
             WHERE     e.SF_ID = s.ID
                   AND e.ENTITY = 'Opportunity'
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
/* TASK No. 10 */
/* Merge into XR */

MERGE INTO  ODS_STAGE.SF_BOOKING_OPPORTUNITY_XR t
     USING (SELECT s.id       AS sf_id,
                   NULL     AS sf_booking_id,
                   s.NSS_SUB_PROGRAM__C,
                   s.NSS_PROGRAM__C,
                   s.NSS_SELLING_METHOD__C,
                   s.NSS_COMPETITOR__C,
                   s.ACCOUNTID,
                   s.OWNERID
              FROM  ODS_STAGE.SF_opportunity_STG s,
                   ODS_STAGE.SF_RECORDTYPE_STG  rt
             WHERE substr(s.NSS_YEAR__C, 6, 4) is not null
                   AND s.recordtypeid = rt.id
                   AND rt.name not in ('Special')
                   AND  s.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
                   AND NOT EXISTS
                           (SELECT 1
                              FROM  ODS_STAGE.sf_errors e
                             WHERE     s.id = e.sf_id
                                   AND e.entity = 'Opportunity'
                                   AND e.resolve_date IS NULL)) s
        ON (t.sf_id = s.sf_id)
WHEN MATCHED
THEN
    UPDATE SET
        t.sf_booking_id = s.sf_booking_id,
        t.nss_sub_program__c = s.nss_sub_program__c,
        t.NSS_PROGRAM__C = s.NSS_PROGRAM__C,
        t.NSS_SELLING_METHOD__C = s.NSS_SELLING_METHOD__C,
        t.NSS_COMPETITOR__C = s.NSS_COMPETITOR__C,
        t.ACCOUNTID = s.ACCOUNTID,
        t.OWNERID = s.OWNERID,
        t.ods_modify_date = SYSDATE
             WHERE    DECODE (T.sf_booking_id, S.sf_booking_id, 1, 0) = 0
                   OR DECODE (T.nss_sub_program__c,
                              S.nss_sub_program__c, 1,
                              0) =
                      0
                   OR DECODE (T.NSS_PROGRAM__C, S.NSS_PROGRAM__C, 1, 0) = 0
                   OR DECODE (T.NSS_SELLING_METHOD__C,
                              S.NSS_SELLING_METHOD__C, 1,
                              0) =
                      0
                   OR DECODE (T.NSS_COMPETITOR__C, S.NSS_COMPETITOR__C, 1, 0) =
                      0
                   OR DECODE (T.ACCOUNTID, S.ACCOUNTID, 1, 0) = 0
                   OR DECODE (T.OWNERID, S.OWNERID, 1, 0) = 0
WHEN NOT MATCHED
THEN
    INSERT     (BOOKING_OPPORTUNITY_OID,
                SF_ID,
                SF_BOOKING_ID,
                NSS_SUB_PROGRAM__C,
                NSS_PROGRAM__C,
                NSS_SELLING_METHOD__C,
                NSS_COMPETITOR__C,
                ACCOUNTID,
                OWNERID,
                ODS_CREATE_DATE,
                ODS_MODIFY_DATE)
        VALUES (
             ODS_STAGE.BOOKING_OPPORTUNITY_OID_SEQ_ID.NEXTVAL,
            s.sf_id,
            s.sf_booking_id,
            s.NSS_SUB_PROGRAM__C,
            s.NSS_PROGRAM__C,
            s.NSS_SELLING_METHOD__C,
            s.NSS_COMPETITOR__C,
            s.ACCOUNTID,
            s.OWNERID,
            SYSDATE,
            SYSDATE)
         WHERE NOT EXISTS
                   (SELECT 1
                      FROM  ODS_STAGE.SF_ACCOUNT_XR xr
                     WHERE xr.sf_id = t.sf_id)

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Merge into ODS_OWN */

MERGE INTO ODS_OWN.BOOKING_OPPORTUNITY t
     USING (SELECT xr.BOOKING_OPPORTUNITY_OID,
                   xr.SF_BOOKING_ID
                       AS booking_id,
                   case when s.isdeleted = 1 then 'Y' else 'N' end as src_delete_flag,
                   NVL (sp.SUB_PROGRAM_OID, -1)
                       AS sub_program_oid,
                   NVL (acct.ACCOUNT_OID, -1)
                       AS account_oid,
                   acct.LID
                       AS lifetouch_id,
                   SUBSTR (s.NSS_YEAR__C, 6, 4)
                       AS school_year,
                      SUBSTR (s.nss_year__c, 3, 3)
                   || SUBSTR (s.nss_year__c, 8, 2)
                       AS booking_year_desc,
                   sm.SELLING_METHOD_OID,
                   ss.SOURCE_SYSTEM_OID,
                   s.STAGENAME
                       AS booking_status,
                   CASE
                       WHEN s.stagename = 'Closed Won' THEN s.closedate
                       ELSE NULL
                   END
                       AS booking_date,
                   s.AT_RISK__C
                       AS risk_ind,
                   SUBSTR(s.AT_RISK_REASONS__C,1,80)
                       AS risk_reason_text,
                   s.AREA__C
                       AS territory_code,
                   CASE
                       WHEN s.stagename = 'Closed Lost' THEN s.closedate
                       ELSE NULL
                   END
                       AS booking_lost_date,
                  substr( s.LOSS_REASON__C,1,80)
                       AS lost_reason_code,
                   CASE
                       WHEN s.stagename = 'Closed Lost' THEN 'Y'
                       ELSE 'N'
                   END
                       AS lost_ind,
                   CASE
                       WHEN s.stagename = 'Closed Lost'
                       THEN
                           account.ACCOUNT_NAME
                       ELSE
                           NULL
                   END
                       AS lost_to_competitor_name,
                   account.ACCOUNT_NAME
                       AS booking_competitor_name,
                   substr(s.NSS_CLOSE_LOST_REASON_NOTES__C,1,80) as lost_reason_text
,s.most_recenet_agreement_stat__c as most_recent_agreement_status
              FROM ODS_STAGE.SF_OPPORTUNITY_STG         s,
                   ODS_STAGE.SF_BOOKING_OPPORTUNITY_XR  xr,
                   ODS_OWN.PROGRAM                      p,
                   ODS_OWN.SUB_PROGRAM                  sp,
                   ODS_OWN.SELLING_METHOD               sm,
                   ODS_STAGE.SF_ACCOUNT_XR              acct,
                   ODS_STAGE.SF_ACCOUNT_XR              comp_acct,
                   ODS_STAGE.SF_USER_STG                u,
                   ODS_OWN.ACCOUNT                      account,
                   ODS_OWN.SOURCE_SYSTEM                      ss
             WHERE     s.ID = xr.SF_ID
                   AND xr.NSS_PROGRAM__C = p.PROGRAM_NAME(+)
                   AND xr.NSS_SUB_PROGRAM__C = sp.SUB_PROGRAM_NAME(+)
                   AND case when xr.NSS_SELLING_METHOD__C = 'Family Approval' then 'Spec' else xr.NSS_SELLING_METHOD__C end = sm.SELLING_METHOD(+)
                   AND xr.ACCOUNTID = acct.SF_ID(+)
                   AND xr.NSS_COMPETITOR__C = comp_acct.SF_ID(+)
                   AND comp_acct.ACCOUNT_OID = account.ACCOUNT_OID(+)
                   AND xr.OWNERID = u.ID(+)
                   AND substr(s.NSS_YEAR__C, 6, 4) is not null
                   AND ss.SOURCE_SYSTEM_SHORT_NAME = 'SF'
                   AND s.ODS_MODIFY_DATE >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (t.BOOKING_OPPORTUNITY_OID = s.BOOKING_OPPORTUNITY_OID)
WHEN MATCHED
THEN
    UPDATE SET
        t.BOOKING_ID = s.BOOKING_ID,
        t.src_delete_flag = s.src_delete_flag,
        t.SUB_PROGRAM_OID = s.SUB_PROGRAM_OID,
        t.ACCOUNT_OID = s.ACCOUNT_OID,
        t.LIFETOUCH_ID = s.LIFETOUCH_ID,
        t.SCHOOL_YEAR = s.SCHOOL_YEAR,
        t.BOOKING_YEAR_DESC = s.BOOKING_YEAR_DESC,
        t.SELLING_METHOD_OID = s.SELLING_METHOD_OID,
        t.SOURCE_SYSTEM_OID = SOURCE_SYSTEM_OID,
        t.BOOKING_STATUS = s.BOOKING_STATUS,
        t.BOOKING_DATE = s.BOOKING_DATE,
        t.RISK_IND = s.RISK_IND,
        t.RISK_REASON_TEXT = s.RISK_REASON_TEXT,
        t.TERRITORY_CODE = s.TERRITORY_CODE,
        t.BOOKING_LOST_DATE = s.BOOKING_LOST_DATE,
        t.LOST_IND = s.LOST_IND,
        t.LOST_TO_COMPETITOR_NAME = s.LOST_TO_COMPETITOR_NAME,
        t.BOOKING_COMPETITOR_NAME = s.BOOKING_COMPETITOR_NAME,
        t.lost_reason_code = s.lost_reason_code,
        t.lost_reason_text = s.lost_reason_text,
        t.most_recent_agreement_status = s.most_recent_agreement_status,
        ODS_MODIFY_DATE = SYSDATE
             WHERE    DECODE (T.BOOKING_ID, S.BOOKING_ID, 1, 0) = 0
                   OR DECODE (T.src_delete_flag, S.src_delete_flag, 1, 0) = 0
                   OR DECODE (T.SUB_PROGRAM_OID, S.SUB_PROGRAM_OID, 1, 0) = 0
                   OR DECODE (T.ACCOUNT_OID, S.ACCOUNT_OID, 1, 0) = 0
                   OR DECODE (T.LIFETOUCH_ID, S.LIFETOUCH_ID, 1, 0) = 0
                   OR DECODE (T.SCHOOL_YEAR, S.SCHOOL_YEAR, 1, 0) = 0
                   OR DECODE (T.BOOKING_YEAR_DESC, S.BOOKING_YEAR_DESC, 1, 0) =
                      0
                   OR DECODE (T.SELLING_METHOD_OID,
                              S.SELLING_METHOD_OID, 1,
                              0) =
                      0
                   OR DECODE (T.SOURCE_SYSTEM_OID, S.SOURCE_SYSTEM_OID, 1, 0) =
                      0
                   OR DECODE (T.BOOKING_STATUS, S.BOOKING_STATUS, 1, 0) = 0
                   OR DECODE (T.BOOKING_DATE, S.BOOKING_DATE, 1, 0) = 0
                   OR DECODE (T.RISK_REASON_TEXT, S.RISK_REASON_TEXT, 1, 0) =
                      0
                   OR DECODE (T.TERRITORY_CODE, S.TERRITORY_CODE, 1, 0) = 0
                   OR DECODE (T.BOOKING_LOST_DATE, S.BOOKING_LOST_DATE, 1, 0) =
                      0
                   OR DECODE (T.LOST_IND, S.LOST_IND, 1, 0) = 0
                   OR DECODE (T.LOST_TO_COMPETITOR_NAME,
                              S.LOST_TO_COMPETITOR_NAME, 1,
                              0) =
                      0
                   OR DECODE (T.BOOKING_COMPETITOR_NAME,
                              S.BOOKING_COMPETITOR_NAME, 1,
                              0) =
                      0
                   OR DECODE (T.lost_reason_code, S.lost_reason_code, 1, 0) = 0
                   OR DECODE (T.lost_reason_text, S.lost_reason_text, 1, 0) = 0
                   or decode (t.most_recent_agreement_status , s.most_recent_agreement_status, 1, 0) = 0
WHEN NOT MATCHED
THEN
    INSERT     (BOOKING_OPPORTUNITY_OID,
                BOOKING_ID,
                src_delete_flag,
                SUB_PROGRAM_OID,
                ACCOUNT_OID,
                LIFETOUCH_ID,
                SCHOOL_YEAR,
                BOOKING_YEAR_DESC,
                SELLING_METHOD_OID,
                SOURCE_SYSTEM_OID,
                BOOKING_STATUS,
                BOOKING_DATE,
                RISK_IND,
                RISK_REASON_TEXT,
                TERRITORY_CODE,
                BOOKING_LOST_DATE,
                LOST_IND,
                LOST_TO_COMPETITOR_NAME,
                BOOKING_COMPETITOR_NAME,
                LOST_REASON_CODE,
                LOST_REASON_TEXT,
                most_recent_agreement_status,
                ODS_CREATE_DATE,
                ODS_MODIFY_DATE)
        VALUES (s.BOOKING_OPPORTUNITY_OID,
                s.BOOKING_ID,
                s.src_delete_flag,
                s.SUB_PROGRAM_OID,
                s.ACCOUNT_OID,
                s.LIFETOUCH_ID,
                s.SCHOOL_YEAR,
                s.BOOKING_YEAR_DESC,
                s.SELLING_METHOD_OID,
                s.SOURCE_SYSTEM_OID,
                s.BOOKING_STATUS,
                s.BOOKING_DATE,
                s.RISK_IND,
                s.RISK_REASON_TEXT,
                s.TERRITORY_CODE,
                s.BOOKING_LOST_DATE,
                s.LOST_IND,
                s.LOST_TO_COMPETITOR_NAME,
                s.BOOKING_COMPETITOR_NAME,
                s.LOST_REASON_CODE,
                s.LOST_REASON_TEXT,
                s.most_recent_agreement_status,
                SYSDATE,
                SYSDATE)

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/*     Drop driver table */

BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.photo_date_dr';
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
/* TASK No. 13 */
/*     Create driver table (CDC on Opportunity) */

create table RAX_APP_USER.photo_date_dr as
SELECT DISTINCT  id, PICTURE_DAY_START__C
  FROM (SELECT o.id,
               e.PICTURE_DAY_START__C,
               MIN (
                   NVL (e.PICTURE_DAY_START__C,
                        TO_DATE ('39990101', 'YYYYMMDD')))
                   OVER (PARTITION BY o.id)
                   AS first_photography_date
          FROM ODS_STAGE.SF_OPPORTUNITY_STG            o,
               ODS_STAGE.SF_REQUESTED_EVENT_DETAIL__C  e
         WHERE o.ID = e.OPPORTUNITY__C 
         AND e.isdeleted != 1
         AND substr(o.NSS_YEAR__C, 6, 4) is not null
         AND o.ODS_MODIFY_DATE >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap)
 WHERE PICTURE_DAY_START__C = first_photography_date

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/*     Merge into driver table (CDC on REQUESTED_EVENT_DETAIL__C) */

MERGE INTO  RAX_APP_USER.photo_date_dr t
USING(
SELECT DISTINCT id, PICTURE_DAY_START__C
  FROM (SELECT o.id,
               e.PICTURE_DAY_START__C,
               MIN (
                   NVL (e.PICTURE_DAY_START__C,
                        TO_DATE ('39990101', 'YYYYMMDD')))
                   OVER (PARTITION BY o.id)
                   AS first_photography_date
          FROM ODS_STAGE.SF_OPPORTUNITY_STG            o,
               ODS_STAGE.SF_REQUESTED_EVENT_DETAIL__C  e
         WHERE o.ID = e.OPPORTUNITY__C 
         AND e.isdeleted != 1
         AND e.ODS_MODIFY_DATE >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap)
 WHERE PICTURE_DAY_START__C = first_photography_date) s
ON (t.id = s.id)
WHEN NOT MATCHED THEN INSERT (
id,
picture_day_start__c)
VALUES (
s.id,
s.picture_day_start__c)

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/*     Merge into Booking_Opp */

MERGE INTO ODS_OWN.BOOKING_OPPORTUNITY t
     USING (SELECT xr.BOOKING_OPPORTUNITY_OID,
                   picture_day_start__c     AS photography_date
              FROM RAX_APP_USER.PHOTO_DATE_DR                dr,
                   ODS_STAGE.SF_BOOKING_OPPORTUNITY_XR  xr
             WHERE dr.ID = xr.SF_ID) s
        ON (t.BOOKING_OPPORTUNITY_OID = s.BOOKING_OPPORTUNITY_OID)
WHEN MATCHED
THEN
    UPDATE SET
        t.photography_date = s.photography_date, t.ods_modify_date = SYSDATE
             WHERE DECODE (T.photography_date, S.photography_date, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Merge EST_Photoed */

MERGE INTO ODS_OWN.BOOKING_OPPORTUNITY t
     USING (  SELECT xr.BOOKING_OPPORTUNITY_OID,
                     MAX (stg.NSS_ENROLLMENT__C)     AS NSS_ENROLLMENT__C
                FROM ODS_STAGE.SF_SERVICEAPPOINTMENT_STG stg,
                     ODS_STAGE.SF_BOOKING_OPPORTUNITY_XR xr
               WHERE     xr.SF_ID = stg.OPPORTUNITY__C
                     AND stg.ISDELETED != 1
                     AND stg.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
            GROUP BY xr.BOOKING_OPPORTUNITY_OID) s
        ON (s.BOOKING_OPPORTUNITY_OID = t.BOOKING_OPPORTUNITY_OID)
WHEN MATCHED
THEN
    UPDATE SET
        t.EST_PHOTOED = s.NSS_ENROLLMENT__C, t.ods_modify_date = SYSDATE
             WHERE DECODE (t.EST_PHOTOED, s.NSS_ENROLLMENT__C, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Merge Booking_Employee_OID (cdc SF_OPPORTUNITY_STG) */

MERGE INTO ODS_OWN.BOOKING_OPPORTUNITY t
     USING (SELECT xr.BOOKING_OPPORTUNITY_OID, CASE WHEN u.isactive = 1 THEN e.EMPLOYEE_OID ELSE NULL END
                       AS employee_oid
              FROM ODS_STAGE.SF_USER_STG                u,
                   ODS_OWN.EMPLOYEE                           e,
                   ODS_STAGE.SF_BOOKING_OPPORTUNITY_XR  xr,
                   ODS_STAGE.SF_OPPORTUNITY_STG         s
             WHERE     u.EXTERNAL_SYSTEM_ID__C = e.EMPLOYEE_NUMBER
                   AND xr.SF_ID = s.ID
                   AND u.ID = s.OWNERID
                   AND s.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (t.BOOKING_OPPORTUNITY_OID = s.BOOKING_OPPORTUNITY_OID)
WHEN MATCHED
THEN
    UPDATE SET
        t.booking_employee_oid = s.employee_oid, t.ods_modify_date = SYSDATE
             WHERE DECODE (t.booking_employee_oid, s.employee_oid, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Merge Booking_Employee_OID (cdc SF_USER_STG) */

MERGE INTO ODS_OWN.BOOKING_OPPORTUNITY t
     USING (SELECT xr.BOOKING_OPPORTUNITY_OID, CASE WHEN u.isactive = 1 THEN e.EMPLOYEE_OID ELSE NULL END
                       AS employee_oid
              FROM ODS_STAGE.SF_USER_STG                u,
                   ODS_OWN.EMPLOYEE                           e,
                   ODS_STAGE.SF_BOOKING_OPPORTUNITY_XR  xr,
                   ODS_STAGE.SF_OPPORTUNITY_STG         s
             WHERE     u.EXTERNAL_SYSTEM_ID__C = e.EMPLOYEE_NUMBER
                   AND xr.SF_ID = s.ID
                   AND u.ID = s.OWNERID
                   AND u.ODS_MODIFY_DATE >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (t.BOOKING_OPPORTUNITY_OID = s.BOOKING_OPPORTUNITY_OID)
WHEN MATCHED
THEN
    UPDATE SET
        t.booking_employee_oid = s.employee_oid, t.ods_modify_date = SYSDATE
             WHERE DECODE (t.booking_employee_oid, s.employee_oid, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 19 */
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
             SUBSTR('2024-08-28 02:39:35.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/

&


/*-----------------------------------------------*/
/* TASK No. 20 */
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
,'LOAD_SF_OPPORTUNITY_PKG'
,'030'
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
30601911200,
'LOAD_SF_OPPORTUNITY_PKG',
'030',
TO_DATE(
             SUBSTR('2024-08-28 02:39:35.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/


&


/*-----------------------------------------------*/
