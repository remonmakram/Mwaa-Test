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
/* Identify Bad LID */

MERGE INTO ODS_STAGE.sf_errors t
     USING (
         SELECT s.id, s.LID__C
         FROM ODS_STAGE.sf_account_stg s
         JOIN ODS_STAGE.SF_RecordType_STG rt ON s.recordtypeid = rt.id
         WHERE rt.name = 'NSS - Account'
           AND (
               s.LID__C IS NULL
               OR LENGTH(TRIM(s.lid__c)) > 20
               OR REGEXP_LIKE(TRIM(s.lid__c), '[^0-9]+')
           )
           AND s.ods_modify_date >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_overlap
     ) s
    ON (
        s.id = t.sf_id
        AND t.ERROR_CODE = '001_BAD_LID'
        AND t.entity = 'Account'
        AND t.resolve_date IS NULL
    )
WHEN NOT MATCHED THEN
    INSERT (
        sf_errors_oid,
        entity,
        sf_id,
        ERROR_CODE,
        error_date,
        last_check_date,
        resolve_date
    )
    VALUES (
        ODS_STAGE.SF_ERRORS_OID_SEQ.NEXTVAL,
        'Account',
        s.id,
        '001_BAD_LID',
        SYSDATE,
        '',
        ''
    )


&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Identify Dup LID */

MERGE INTO ODS_STAGE.sf_errors t
     USING (SELECT s.id
              -- Numeric only source
              FROM ODS_STAGE.sf_account_stg  s,
                         ODS_STAGE.SF_RecordType_STG rt,
                   (  SELECT TO_NUMBER (TRIM (lid__c)) AS lid__c, COUNT (*)
                        FROM ODS_STAGE.sf_account_stg s,
                                   ODS_STAGE.SF_RecordType_STG rt
                       WHERE   s.recordtypeid = rt.id
                             AND rt.name = 'NSS - Account'  
                             AND s.ISDELETED != 1
                             AND TRIM (lid__c) IS NOT NULL
                             AND NOT REGEXP_LIKE (TRIM (s.lid__c), '[^0-9]+')
                    GROUP BY TO_NUMBER (TRIM (lid__c))
                      HAVING COUNT (*) > 1) dupe
             WHERE TRIM (s.lid__c) = dupe.lid__c
             AND s.recordtypeid = rt.id
             AND rt.name = 'NSS - Account'
             AND s.ISDELETED != 1
            UNION
            SELECT s.id
              -- Non-Numeric
              FROM ODS_STAGE.sf_account_stg  s,
                         ODS_STAGE.SF_RecordType_STG rt,
                   (  SELECT TRIM (lid__c) AS lid__c, COUNT (*)
                        FROM ODS_STAGE.sf_account_stg s,
                                   ODS_STAGE.SF_RecordType_STG rt
                       WHERE  s.recordtypeid = rt.id
                             AND rt.name = 'NSS - Account'   
                             AND s.ISDELETED != 1
                             AND TRIM (lid__c) IS NOT NULL
                             AND REGEXP_LIKE (TRIM (s.lid__c), '[^0-9]+')
                    GROUP BY TRIM (lid__c)
                      HAVING COUNT (*) > 1) dupe
             WHERE TRIM (s.lid__c) = dupe.lid__c
             AND s.recordtypeid = rt.id
             AND rt.name = 'NSS - Account'
             AND s.ISDELETED != 1
            UNION
            -- Numeric already in XR
            SELECT id
              FROM (SELECT xr.lid, xr.SF_ID, s.ID
                      FROM ODS_STAGE.sf_account_stg  s,
                           ODS_STAGE.SF_ACCOUNT_XR   xr,
                           ODS_STAGE.SF_RecordType_STG rt
                     WHERE     TRIM (s.LID__C) = xr.LID
                           AND s.recordtypeid = rt.id
                           AND rt.name = 'NSS - Account'
                           AND s.ISDELETED != 1
                           AND s.ID != xr.SF_ID
                           AND NOT REGEXP_LIKE (TRIM (s.lid__c), '[^0-9]+')))
           s
        ON (    s.id = t.sf_id
            AND t.ERROR_CODE = '002_DUPE_LID'
            AND t.entity = 'Account'
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
                'Account',
                s.id,
                '002_DUPE_LID',
                SYSDATE,
                '',
                '')

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Identify Long Name */

MERGE INTO ODS_STAGE.sf_errors t
     USING (SELECT s.id
              FROM ODS_STAGE.sf_account_stg s,
                         ODS_STAGE.SF_RecordType_STG rt
             WHERE s.recordtypeid = rt.id
             AND rt.name = 'NSS - Account' 
             AND LENGTH (s.name) > 50
              AND s.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (    s.id = t.sf_id
            AND t.ERROR_CODE = '005_ACCT_NAME_L'
            AND t.entity = 'Account'
            AND t.resolve_date IS NULL )
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
                'Account',
                s.id,
                '005_ACCT_NAME_L',
                SYSDATE,
                '',
                '')

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Identify Long Short Name */

MERGE INTO ODS_STAGE.sf_errors t
     USING (SELECT s.id
              FROM ODS_STAGE.sf_account_stg s,
                         ODS_STAGE.SF_RecordType_STG rt
             WHERE s.recordtypeid = rt.id
             AND rt.name = 'NSS - Account' 
              AND LENGTH (s.remit_to__c) > 50
              AND s.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (    s.id = t.sf_id
            AND t.ERROR_CODE = '007_ACCT_REMIT_TO_L'
            AND t.entity = 'Account')
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
                'Account',
                s.id,
                '007_ACCT_REMIT_TO_L',
                SYSDATE,
                '',
                '')

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Identify Changed LID */

MERGE INTO ODS_STAGE.sf_errors t
     USING (SELECT s.id
              FROM ODS_STAGE.SF_ACCOUNT_STG  s,
                   ODS_STAGE.SF_ACCOUNT_XR   xr,
                   ODS_STAGE.SF_RecordType_STG rt
             WHERE  s.recordtypeid = rt.id
                   AND rt.name = 'NSS - Account'   
                   AND s.ID = xr.SF_ID
                   AND s.LID__C != xr.LID
                   AND s.ods_modify_date >=
                         TO_DATE (
                             SUBSTR (:v_cdc_load_date,
                                     1,
                                     19),
                             'YYYY-MM-DD HH24:MI:SS')
                       - :v_cdc_overlap) s
        ON (    s.id = t.sf_id
            AND t.ERROR_CODE = '006_LID_CHANGE'
            AND t.entity = 'Account'
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
                'Account',
                s.id,
                '006_LID_CHANGE',
                SYSDATE,
                '',
                '')

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Fix BAD LID */

MERGE INTO ODS_STAGE.sf_errors t
     USING (SELECT e.SF_ERRORS_OID,
                   e.sf_id,
                   CASE
                       WHEN    s.LID__C IS NULL
                            OR LENGTH (s.lid__c) > 20
                            OR REGEXP_LIKE (s.lid__c, '[^0-9]+')
                       THEN
                           NULL
                       ELSE
                           SYSDATE
                   END
                       AS fixed
              FROM ODS_STAGE.sf_account_stg  s,
                         ODS_STAGE.SF_RecordType_STG rt,
                   (SELECT sf_id, e.SF_ERRORS_OID
                      FROM ODS_STAGE.sf_errors e
                     WHERE  e.ENTITY = 'Account'
                           AND e.ERROR_CODE = '001_BAD_LID'
                           AND e.RESOLVE_DATE IS NULL) e
             WHERE s.ID = e.SF_ID
             AND s.recordtypeid = rt.id
             AND rt.name = 'NSS - Account' ) s
        ON (t.sf_errors_oid = s.sf_errors_oid)
WHEN MATCHED
THEN
    UPDATE SET t.last_check_date = SYSDATE, t.resolve_date = fixed

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Fix Dup LID */

MERGE INTO ODS_STAGE.sf_errors t
     USING (SELECT sf_id,
                   CASE WHEN dupe.id IS NULL THEN SYSDATE ELSE NULL END
                       AS fixed
              FROM ODS_STAGE.sf_errors  e,
                   (SELECT s.id
                      -- Numeric only source
                      FROM ODS_STAGE.sf_account_stg  s,
                           (  SELECT TO_NUMBER (TRIM (lid__c))     AS lid__c,
                                     COUNT (*)
                                FROM ODS_STAGE.sf_account_stg s,
                                           ODS_STAGE.SF_RecordType_STG rt
                               WHERE  s.recordtypeid = rt.id
                                     AND rt.name = 'NSS - Account'
                                     AND s.ISDELETED != 1   
                                     AND TRIM (lid__c) IS NOT NULL
                                     AND NOT REGEXP_LIKE (TRIM (s.lid__c),
                                                          '[^0-9]+')
                            GROUP BY TO_NUMBER (TRIM (lid__c))
                              HAVING COUNT (*) > 1) dupe
                     WHERE TRIM (s.lid__c) = dupe.lid__c
                    UNION
                    SELECT s.id
                      -- Non-Numeric
                      FROM ODS_STAGE.sf_account_stg  s,
                           (  SELECT TRIM (lid__c) AS lid__c, COUNT (*)
                                FROM ODS_STAGE.sf_account_stg s,
                                           ODS_STAGE.SF_RecordType_STG rt
                               WHERE s.recordtypeid = rt.id
                                     AND rt.name = 'NSS - Account'
                                     AND s.ISDELETED != 1   
                                     AND TRIM (lid__c) IS NOT NULL
                                     AND REGEXP_LIKE (TRIM (s.lid__c),
                                                      '[^0-9]+')
                            GROUP BY TRIM (lid__c)
                              HAVING COUNT (*) > 1) dupe
                     WHERE TRIM (s.lid__c) = dupe.lid__c
                     UNION
                     -- Numeric already in XR
                     SELECT id
              FROM (SELECT xr.lid, xr.SF_ID, s.ID
                      FROM ODS_STAGE.sf_account_stg  s,
                           ODS_STAGE.SF_ACCOUNT_XR   xr,
                           ODS_STAGE.SF_RecordType_STG rt
                     WHERE  s.recordtypeid = rt.id
                           AND rt.name = 'NSS - Account'
                           AND s.ISDELETED != 1   
                           AND TRIM (s.LID__C) = xr.LID
                           AND s.ID != xr.SF_ID
                           AND NOT REGEXP_LIKE (TRIM (s.lid__c), '[^0-9]+'))) dupe
             WHERE     1 = 1
                   AND e.sf_id = dupe.id(+)
                   AND e.ENTITY = 'Account'
                   AND e.ERROR_CODE = '002_DUPE_LID'
                   AND e.resolve_date is null) s
        ON (    s.sf_id = t.sf_id
            AND t.entity = 'Account'
            AND t.ERROR_CODE = '002_DUPE_LID')
WHEN MATCHED
THEN
    UPDATE SET t.last_check_date = SYSDATE, t.resolve_date = fixed
             WHERE t.resolve_date IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Fix Long Name */

MERGE INTO ODS_STAGE.sf_errors t
     USING (SELECT e.SF_ERRORS_OID,
                   e.sf_id,
                   CASE WHEN LENGTH (s.name) > 50 THEN NULL ELSE SYSDATE END
                       AS fixed
              FROM ODS_STAGE.sf_account_stg  s,
                         ODS_STAGE.SF_RecordType_STG rt,
                   (SELECT sf_id, e.SF_ERRORS_OID
                      FROM ODS_STAGE.sf_errors e
                     WHERE     e.ENTITY = 'Account'
                           AND e.ERROR_CODE = '005_ACCT_NAME_L'
                           AND e.RESOLVE_DATE IS NULL) e
             WHERE s.ID = e.SF_ID
                 AND s.recordtypeid = rt.id
                 AND rt.name = 'NSS - Account') s
        ON (t.sf_errors_oid = s.sf_errors_oid)
WHEN MATCHED
THEN
    UPDATE SET t.last_check_date = SYSDATE, t.resolve_date = fixed

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Fix Long Short Name */

MERGE INTO ODS_STAGE.sf_errors t
     USING (SELECT e.SF_ERRORS_OID,
                   e.sf_id,
                   CASE WHEN LENGTH (s.remit_to__c) > 50 THEN NULL ELSE SYSDATE END
                       AS fixed
              FROM ODS_STAGE.sf_account_stg  s,
                         ODS_STAGE.SF_RecordType_STG rt,
                   (SELECT sf_id, e.SF_ERRORS_OID
                      FROM ODS_STAGE.sf_errors e
                     WHERE     e.ENTITY = 'Account'
                           AND e.ERROR_CODE = '007_ACCT_REMIT_TO_L'
                           AND e.RESOLVE_DATE IS NULL) e
             WHERE s.ID = e.SF_ID
                 AND s.recordtypeid = rt.id
                 AND rt.name = 'NSS - Account') s
        ON (t.sf_errors_oid = s.sf_errors_oid)
WHEN MATCHED
THEN
    UPDATE SET t.last_check_date = SYSDATE, t.resolve_date = fixed

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Fix Changed LID */

MERGE INTO ODS_STAGE.sf_errors t
     USING (SELECT e.SF_ERRORS_OID,
                   e.sf_id,
                   CASE WHEN s.LID__C != xr.lid THEN NULL ELSE SYSDATE END
                       AS fixed
              FROM ODS_STAGE.sf_account_stg  s,
                   ODS_STAGE.SF_ACCOUNT_XR   xr,
                   ODS_STAGE.SF_RecordType_STG rt,
                   (SELECT sf_id, e.SF_ERRORS_OID
                      FROM ODS_STAGE.sf_errors e
                     WHERE     e.ENTITY = 'Account'
                           AND e.ERROR_CODE = '006_LID_CHANGE'
                           AND e.RESOLVE_DATE IS NULL) e
             WHERE s.recordtypeid = rt.id
                AND rt.name = 'NSS - Account' 
                AND s.ID = e.SF_ID 
                AND s.ID = xr.SF_ID) s
        ON (t.sf_errors_oid = s.sf_errors_oid)
WHEN MATCHED
THEN
    UPDATE SET t.last_check_date = SYSDATE, t.resolve_date = fixed

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Merge into XR where AMS LID now exists */

MERGE INTO ODS_STAGE.sf_account_xr t
     USING (SELECT s.id, s.lid__c
              FROM ODS_STAGE.sf_account_stg s,
                         ODS_STAGE.SF_RecordType_STG rt
             WHERE s.recordtypeid = rt.id
                  AND rt.name = 'NSS - Account'
                  AND s.ID NOT IN
                       (SELECT sf_id
                          FROM ODS_STAGE.sf_errors
                         WHERE entity = 'Account' AND resolve_date IS NULL)
               AND s.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap)
           s
        ON (t.lid = s.lid__c)
WHEN MATCHED
THEN
    UPDATE SET t.sf_id = s.id
             WHERE DECODE (T.sf_id, S.id, 1, 0) = 0 
             AND t.sf_id IS NULL


&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Merge into XR where new LID */

MERGE INTO  ODS_STAGE.SF_ACCOUNT_XR t
     USING (SELECT s.id, TO_NUMBER (s.lid__c) AS lid__c
              FROM  ODS_STAGE.SF_ACCOUNT_STG s,
                          ODS_STAGE.SF_RecordType_STG rt
             WHERE  s.recordtypeid = rt.id
                   AND rt.name = 'NSS - Account'  
                   AND s.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
                   AND NOT EXISTS
                           (SELECT 1
                              FROM  ODS_STAGE.sf_errors e
                             WHERE     s.id = e.sf_id
                                   AND e.entity = 'Account'
                                   AND e.resolve_date IS NULL)) s
        ON (t.sf_id = s.id)
WHEN MATCHED
THEN
    UPDATE SET t.lid = s.lid__c, t.ods_modify_date = SYSDATE
             WHERE DECODE (T.lid, S.lid__c, 1, 0) = 0
WHEN NOT MATCHED
THEN
    INSERT     (account_oid,
                sf_id,
                lid,
                ods_create_date,
                ods_modify_date)
        VALUES ( ODS_STAGE.ACCOUNT_OID_SEQ.NEXTVAL,
                s.id,
                s.lid__c,
                SYSDATE,
                SYSDATE)
         WHERE NOT EXISTS
                   (SELECT 1
                      FROM  ODS_STAGE.SF_ACCOUNT_XR xr
                     WHERE xr.lid = t.lid)

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Merge into Account */

MERGE INTO ODS_OWN.ACCOUNT t
     USING (SELECT xr.ACCOUNT_OID,
                   xr.LID,
                   case when s.isdeleted = 1 then 'Y' else 'N' end as src_delete_flag,
                   s.NAME,
                  NVL( s.Remit_To__c,s.NAME) as remit_to__c,
                   CASE WHEN s.OUT_OF_BUSINESS__C = 1 THEN 'I' ELSE 'A' END
                       AS out_of_business__c,
                   s.TYPE,
                   s.SUB_TYPE__C,
                   NVL (s.AVG_ATTENDANCE__C, 0)
                       AS avg_attendance__c,
                   s.BILLINGSTREET,
                   s.BILLINGCITY,
                   s.BILLINGSTATECODE,
                   s.BILLINGPOSTALCODE,
                   s.COUNTY__C,
                   CASE s.BILLINGCOUNTRYCODE
                       WHEN 'US' THEN 'USA'
                       WHEN 'CA' THEN 'Canada'
                       ELSE 'Unknown'
                   END
                       AS BILLINGCOUNTRYCODE,
                   s.ACCOUNT_HIGH_GRADE__C,
                   s.ACCOUNT_LOW_GRADE__C,
                   s.NSS_NACAM__C,
                   case when s.SHIPPINGSTREET is null then  s.BILLINGSTREET else  s.SHIPPINGSTREET end as SHIPPINGSTREET,
                    case when s.SHIPPINGSTREET is null then  s.BILLINGCITY else s.SHIPPINGCITY end as SHIPPINGCITY,
                    case when s.SHIPPINGSTREET is null then  s.BILLINGSTATECODE else s.SHIPPINGSTATECODE end as SHIPPINGSTATECODE,
                    case when s.SHIPPINGSTREET is null then  s.BILLINGPOSTALCODE else s.SHIPPINGPOSTALCODE end as SHIPPINGPOSTALCODE,
                   s.PHONE,
                   s.BILLINGLATITUDE,
                   s.BILLINGLONGITUDE,
                   s.WEBSITE,
                   s.FAX,
                   s.NOT_QUALIFIED__C,
                   pxr.ACCOUNT_OID
                       AS PARENTID,
                   s.district_status__c,
                   s.affiliation__c as affiliation_name,
                   s.Star_Rating_Reporting__c,
                   ss.SOURCE_SYSTEM_OID
              FROM ODS_STAGE.SF_ACCOUNT_XR   xr,
                   ODS_STAGE.SF_ACCOUNT_STG  s,
                   ODS_STAGE.SF_RecordType_STG rt,
                   ODS_OWN.SOURCE_SYSTEM           ss,
                   ODS_STAGE.SF_ACCOUNT_XR   pxr
             WHERE     xr.SF_ID = s.ID
                   AND s.PARENTID = pxr.SF_ID(+)
                   AND s.recordtypeid = rt.id
                   AND rt.name = 'NSS - Account'
                   AND ss.SOURCE_SYSTEM_SHORT_NAME = 'SF'
                   AND NOT EXISTS
                           (SELECT 1
                              FROM ODS_STAGE.sf_errors e
                             WHERE e.SF_ID = s.id 
                                 AND e.entity = 'Account'
                                 AND e.resolve_date IS NULL)
                   AND  s.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (t.account_oid = s.account_oid)
WHEN NOT MATCHED
THEN
    INSERT     (ACCOUNT_OID,
                lifetouch_id,
                account_alias,
                account_name,
                active_account_ind,
                category_name,
                subcategory_name,
                enrollment,
                physical_address_line1,
                city,
                state,
                county,
                country,
                postal_code,
                school_high_grade,
                school_low_grade,
                nacam_overall_class_name,
                ship_to_address_line1,
                ship_to_city,
                ship_to_state,
                ship_to_postal_code,
                business_phone,
                latitude,
                longitude,
                parent_account_oid,
                web_address,
                fax_number,
                preschool_capacity,
                source_system_oid,
                ods_create_date,
                ods_modify_date,
                src_delete_flag,
                district_status,
                affiliation_name,
                Star_Rating_Reporting)
        VALUES (s.ACCOUNT_OID,
                s.LID,
                s.NAME,
                s.Remit_To__c,
                s.out_of_business__c,
                s.TYPE,
                s.SUB_TYPE__C,
                s.avg_attendance__c,
                s.BILLINGSTREET,
                s.BILLINGCITY,
                s.BILLINGSTATECODE,
                s.COUNTY__C,
                s.BILLINGCOUNTRYCODE,
                s.BILLINGPOSTALCODE,
                s.ACCOUNT_HIGH_GRADE__C,
                s.ACCOUNT_LOW_GRADE__C,
                s.NSS_NACAM__C,
                s.SHIPPINGSTREET,
                s.SHIPPINGCITY,
                s.SHIPPINGSTATECODE,
                s.SHIPPINGPOSTALCODE,
                s.PHONE,
                s.BILLINGLATITUDE,
                s.BILLINGLONGITUDE,
                s.PARENTID,
                s.WEBSITE,
                s.FAX,
                0, -- Preschool_capacity
                s.SOURCE_SYSTEM_OID,
                SYSDATE,
                SYSDATE,
                s.src_delete_flag,
                s.district_status__c,
                s.affiliation_name,
                s.Star_Rating_Reporting__c)
WHEN MATCHED
THEN
    UPDATE SET
        t.account_alias = s.name,
        t.account_name = s.Remit_To__c,
        t.active_account_ind = s.out_of_business__c,
        t.category_name = s.TYPE,
        t.subcategory_name = s.sub_type__c,
        t.enrollment = s.avg_attendance__c,
        t.physical_address_line1 = s.billingstreet,
        t.physical_address_line2 = NULL,
        t.physical_address_line3 = NULL,
        t.city = s.billingcity,
        t.state = s.billingstatecode,
        t.county = s.county__c,
        t.country = s.billingcountrycode,
        t.postal_code = s.billingpostalcode,
        t.school_high_grade = s.account_high_grade__c,
        t.school_low_grade = s.account_low_grade__c,
        t.nacam_overall_class_name = s.nss_nacam__c,
        t.ship_to_address_line1 = s.shippingstreet,
        t.ship_to_city = s.shippingcity,
        t.ship_to_state = s.shippingstatecode,
        t.ship_to_postal_code = s.shippingpostalcode,
        t.business_phone = s.phone,
        t.latitude = s.billinglatitude,
        t.longitude = s.billinglongitude,
        t.parent_account_oid = s.parentid,
        t.web_address = s.website,
        t.fax_number = s.fax,
        t.ods_modify_date = SYSDATE,
        t.src_delete_flag = s.src_delete_flag,
        t.district_status = s.district_status__c, 
        t.affiliation_name = s.affiliation_name,
        t.Star_Rating_Reporting = s.Star_Rating_Reporting__c
             WHERE    DECODE (t.account_alias, s.name, 1, 0) = 0
                  OR DECODE ( t.account_name, s.Remit_To__c, 1, 0) = 0
                   OR DECODE (t.active_account_ind,
                              s.out_of_business__c, 1,
                              0) =
                      0
                   OR DECODE (t.category_name, s.TYPE, 1, 0) = 0
                   OR DECODE (t.subcategory_name, s.sub_type__c, 1, 0) = 0
                   OR DECODE (t.enrollment, s.avg_attendance__c, 1, 0) = 0
                   OR DECODE (t.physical_address_line1,
                              s.billingstreet, 1,
                              0) =
                      0
                   OR DECODE (t.city, s.billingcity, 1, 0) = 0
                   OR DECODE (t.state, s.billingstatecode, 1, 0) = 0
                   OR DECODE (t.county, s.county__c, 1, 0) = 0
                   OR DECODE (t.country, s.billingcountrycode, 1, 0) = 0
                   OR DECODE (t.postal_code, s.billingpostalcode, 1, 0) = 0
                   OR DECODE (t.school_high_grade,
                              s.account_high_grade__c, 1,
                              0) =
                      0
                   OR DECODE (t.school_low_grade,
                              s.account_low_grade__c, 1,
                              0) =
                      0
                   OR DECODE (t.nacam_overall_class_name,
                              s.nss_nacam__c, 1,
                              0) =
                      0
                   OR DECODE (t.ship_to_address_line1,
                              s.shippingstreet, 1,
                              0) =
                      0
                   OR DECODE (t.ship_to_city, s.shippingcity, 1, 0) = 0
                   OR DECODE (t.ship_to_state, s.shippingstatecode, 1, 0) = 0
                   OR DECODE (t.ship_to_postal_code,
                              s.shippingpostalcode, 1,
                              0) =
                      0
                   OR DECODE (t.business_phone, s.phone, 1, 0) = 0
                   OR DECODE (t.latitude, s.billinglatitude, 1, 0) = 0
                   OR DECODE (t.longitude, s.billinglongitude, 1, 0) = 0
                   OR DECODE (t.parent_account_oid, s.parentid, 1, 0) = 0
                   OR DECODE (t.Star_Rating_Reporting, s.Star_Rating_Reporting__c, 1, 0) = 0
                   OR DECODE (t.web_address, s.website, 1, 0) = 0
                   OR DECODE (t.fax_number, s.fax, 1, 0) = 0
                   OR DECODE (t.src_delete_flag, s.src_delete_flag, 1, 0) = 0
                   OR DECODE (t.district_status, s.district_status__c, 1, 0) = 0
                   OR DECODE (t.affiliation_name, s.affiliation_name, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* Handle late arriving Parent accounts */

MERGE INTO ODS_OWN.account t
     USING (SELECT a.ACCOUNT_OID, pxr.ACCOUNT_OID AS parent_account_oid
              FROM ODS_OWN.ACCOUNT           a,
                   ODS_STAGE.SF_ACCOUNT_STG  s,
                   ODS_STAGE.SF_ACCOUNT_XR   xr,
                   ODS_STAGE.SF_ACCOUNT_XR   pxr
             WHERE     1 = 1
                   AND a.ACCOUNT_OID = xr.ACCOUNT_OID
                   AND xr.SF_ID = s.ID
                   AND s.PARENTID = pxr.SF_ID
                   AND a.PARENT_ACCOUNT_OID IS NULL) s
        ON (t.account_oid = s.account_oid)
WHEN MATCHED
THEN
    UPDATE SET
        t.parent_account_oid = s.parent_account_oid,
        t.ods_modify_date = SYSDATE

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* Populate YB Address Columns */

MERGE INTO ODS_OWN.ACCOUNT t
     USING ( SELECT xr.ACCOUNT_OID,
                    ss.source_system_short_name,
                   case when ss.source_system_short_name = 'AMS' and (
                   case when s.USE_OF_SECONDARY_ADDRESS__C like '%Yearbook Invoice%' then s.SHIPPINGSTREET else s.BILLINGSTREET end is NULL
                   OR case when s.USE_OF_SECONDARY_ADDRESS__C like '%Yearbook Invoice%' then s.SHIPPINGCITY else s.BILLINGCITY end is NULL
                   OR case when s.USE_OF_SECONDARY_ADDRESS__C like '%Yearbook Invoice%' then s.SHIPPINGSTATECODE else s.BILLINGSTATECODE end is NULL
                   OR case when s.USE_OF_SECONDARY_ADDRESS__C like '%Yyearbook Invoice%' then s.SHIPPINGPOSTALCODE else s.BILLINGPOSTALCODE end is NULL
                   ) then 1 else 0 end  as do_not_update,
                   case when s.USE_OF_SECONDARY_ADDRESS__C like '%Yearbook Invoice%' then s.SHIPPINGSTREET else s.BILLINGSTREET end as YB_Mailing_Address_line1,
                   case when s.USE_OF_SECONDARY_ADDRESS__C like '%Yearbook Invoice%' then s.SHIPPINGCITY else s.BILLINGCITY end as YB_Mailing_City,
                   case when s.USE_OF_SECONDARY_ADDRESS__C like '%Yearbook Invoice%' then s.SHIPPINGSTATECODE else s.BILLINGSTATECODE end as YB_Mailing_State,
                   case when s.USE_OF_SECONDARY_ADDRESS__C like '%Yearbook Invoice%' then s.SHIPPINGPOSTALCODE else s.BILLINGPOSTALCODE end as YB_Mailing_Postal_Code
              FROM ODS_STAGE.SF_ACCOUNT_XR   xr,
                   ODS_STAGE.SF_ACCOUNT_STG  s,
                   ODS_OWN.account a,
                   ods_own.source_system ss
             WHERE     xr.SF_ID = s.ID
                   AND xr.ACCOUNT_OID = a.ACCOUNT_OID
                   and a.SOURCE_SYSTEM_OID = ss.SOURCE_SYSTEM_OID
                   AND  s.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (t.account_oid = s.account_oid)
WHEN MATCHED
THEN
    UPDATE SET
        t.yb_mailing_address_line1 = s.yb_mailing_address_line1,
        t.yb_mailing_city = s.yb_mailing_city,
        t.yb_mailing_state = s.yb_mailing_state,
        t.yb_mailing_postal_code = s.yb_mailing_postal_code,
        t.YB_MAILING_ADDRESS_LINE2 = NULL,
        t.YB_MAILING_ADDRESS_LINE3 = NULL,
        t.ods_modify_date = sysdate
                   WHERE (DECODE (t.yb_mailing_address_line1, s.yb_mailing_address_line1, 1, 0) = 0
                   OR DECODE (t.yb_mailing_city, s.yb_mailing_city, 1, 0) = 0
                   OR DECODE (t.yb_mailing_state, s.yb_mailing_state, 1, 0) = 0
                   OR DECODE (t.yb_mailing_postal_code, s.yb_mailing_postal_code, 1, 0) = 0)
                   AND s.do_not_update = 0

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR('2024-08-28 02:38:42.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
+ nvl((TIMEZONE_OFFSET/24), 0) 
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

/*
UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR('2024-08-28 02:38:42.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
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
,30601906200
,'LOAD_SF_ACCOUNT_PKG'
,'055'
,TO_DATE(SUBSTR('2024-08-28 02:38:42.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
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
30601906200,
'LOAD_SF_ACCOUNT_PKG',
'055',
TO_DATE(
             SUBSTR('2024-08-28 02:38:42.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
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
/* Load Mart Account */

MERGE INTO MART.account t
     USING (SELECT a.LIFETOUCH_ID,
                   a.account_alias
                       AS account_name,
                  a.src_delete_flag,
                   a.CATEGORY_NAME
                       AS account_category_name,
                   a.ACTIVE_ACCOUNT_IND,
                   SUBSTR (a.SUBCATEGORY_NAME, 1, 30)
                       AS account_subcategory_name,
                   a.PHYSICAL_ADDRESS_LINE1
                       AS address_line_1,
                   a.CITY,
                   a.STATE,
                   a.COUNTRY,
                  substr( a.POSTAL_CODE,1,10) AS POSTAL_CODE,
                   a.WEB_ADDRESS,
                   a.BUSINESS_PHONE
                       AS phone_number,
                   a.FAX_NUMBER,
                   pa.ACCOUNT_ALIAS
                       AS district_name,
                   a.ENROLLMENT
                       AS enrollment_count,
                   a.SCHOOL_LOW_GRADE
                       AS low_grade_code,
                   a.SCHOOL_HIGH_GRADE
                       AS high_grade_code,
                   'Unknown'
                       AS majority_ethnicity_group_name,
                   'Unknown'
                       AS school_type_name,
                   'Unknown'
                       AS kindergarten_school_ind,
                   'Unknown'
                       AS ALTERNATIVE_SCHOOL_IND,
                   'Unknown'
                       AS site_based_management_ind,
                   'Unknown'
                       AS early_child_ind,
                   'Unknown'
                       AS title1_name,
                   'Unknown'
                       AS per_pupil_textbook_exp_name,
                   'Unknown'
                       AS per_pupil_other_exp_name,
                   'Unknown'
                       AS computer_assist_name,
                   a.COUNTY,
                   -1
                       AS lpip_pid,
                   '.'
                       AS ACCOUNT_CLASSIFICATION_CODE,
                   NVL (nal.OVERALL_CLASS, '.')
                       AS NACAM_OVERALL_CLASS_NAME,
                   NVL (nal.SENIORS_CLASS, '.')
                       AS NACAM_SENIORS_CLASS_NAME,
nvl(
case when a.subcategory_name in ('Preschool','PRES','House','HOUSE') or a.category_name in ('Preschool') then 0
  else case when ma.grade11_enrollment_qty is not null and ma.grade11_enrollment_qty <> 0 then ma.grade11_enrollment_qty
       else case when (nvl(a.school_high_grade,'-') in ('-','Unknown','N/A') or nvl(a.school_low_grade,'-') in ('-','Unknown','N\A')) and a.subcategory_name ='Secondary School'
            then round(a.enrollment / 4)
            else case when (nvl(a.school_high_grade,'-') in ('-','Unknown','N/A') or nvl(a.school_low_grade,'-') in ('-','Unknown','N\A')) and a.subcategory_name ='Combined with Secondary'
                 then round(a.enrollment / 7)
                 else case when nvl(a.school_high_grade,'-') in ('-','Unknown','N/A') or nvl(a.school_low_grade,'-') in ('-','Unknown','N\A')
                      then 0
                      else case when nvl(a.school_high_grade,'-') in ('K','PK','Pre-K','SP','UP','P','k','pk','ST','S','Unknown','-','N/A') or nvl(a.school_low_grade,'-') in ('Unknown','-','N/A','SP','ST','S','P','MS','K0','OK') then
                           round(nvl(a.enrollment,0) / 4)
                           else case when a.school_low_grade in ('K','k') then
                                round(nvl(a.enrollment,0) / decode(((ods_own.safe_to_number(a.school_high_grade) - 0) + 1),0,1,((ods_own.safe_to_number(a.school_high_grade) - 0) + 1)) )
                                else case when a.school_low_grade in ('PK','pk','Pre-K') then
                                     round(nvl(a.enrollment,0) / decode(((ods_own.safe_to_number(a.school_high_grade) - 0) + 2),0,1,((ods_own.safe_to_number(a.school_high_grade) - 0) + 2)) )
                                     else round(nvl(a.enrollment,0) / decode((ods_own.safe_to_number(a.school_high_grade) - ods_own.safe_to_number(a.school_low_grade) + 1),0,1,(ods_own.safe_to_number(a.school_high_grade) - ods_own.safe_to_number(a.school_low_grade) + 1)) )
                                     end
                                end
                           end
                      end
                 end
           end
       end
end,0) as dw_grade_11_enrollment_qty,
                   a.SHIP_TO_ADDRESS_LINE1,
                   a.SHIP_TO_CITY,
                   a.SHIP_TO_STATE,
                   a.SHIP_TO_POSTAL_CODE,
                   pa.LIFETOUCH_ID
                       AS district_lid,
                   a.affiliation_name,
                   a.Star_Rating_Reporting
              FROM ODS_OWN.ACCOUNT       a,
                   ODS_OWN.ACCOUNT       pa,
                   DW_OWN.NACAM_ACCOUNT_LEVEL  nal,
              mart.account ma
             WHERE     a.PARENT_ACCOUNT_OID = pa.ACCOUNT_OID(+)
                   AND a.LIFETOUCH_ID = nal.LIFETOUCH_ID(+)
                   AND a.LIFETOUCH_ID = ma.lifetouch_id(+)
                   AND a.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap) s
        ON (s.lifetouch_id = t.lifetouch_id)
WHEN NOT MATCHED
THEN
    INSERT     (ACCOUNT_ID,
                LIFETOUCH_ID,
                ACCOUNT_NAME,
                ACTIVE_ACCOUNT_IND,
                SRC_DELETE_FLAG,
                ACCOUNT_CATEGORY_NAME,
                ACCOUNT_SUBCATEGORY_NAME,
                AFFILIATION_NAME,
                ADDRESS_LINE_1,
                CITY,
                STATE,
                POSTAL_CODE,
                COUNTRY,
                WEB_ADDRESS,
                PHONE_NUMBER,
                FAX_NUMBER,
                DISTRICT_NAME,
                ENROLLMENT_COUNT,
                LOW_GRADE_CODE,
                HIGH_GRADE_CODE,
                MAJORITY_ETHNICITY_GROUP_NAME,
                SCHOOL_TYPE_NAME,
                KINDERGARTEN_SCHOOL_IND,
                ALTERNATIVE_SCHOOL_IND,
                SITE_BASED_MANAGEMENT_IND,
                EARLY_CHILD_IND,
                TITLE1_NAME,
                PER_PUPIL_TEXTBOOK_EXP_NAME,
                PER_PUPIL_OTHER_EXP_NAME,
                COMPUTER_ASSIST_NAME,
                COUNTY,
                LPIP_PID,
                ACCOUNT_CLASSIFICATION_CODE,
                NACAM_OVERALL_CLASS_NAME,
                NACAM_SENIORS_CLASS_NAME,
                DW_GRADE_11_ENROLLMENT_QTY,
                SHIP_TO_ADDRESS_LINE1,
                SHIP_TO_CITY,
                SHIP_TO_STATE,
                SHIP_TO_POSTAL_CODE,
                DISTRICT_LID,
                ODS_CREATE_DATE,
                ODS_MODIFY_DATE,
                Star_Rating_Reporting)
        VALUES ( ODS.ACCOUNT_ID_SEQ.NEXTVAL,
                s.lifetouch_id,
                s.account_name,
                s.active_account_ind,
                s.src_delete_flag,
                s.account_category_name,
                s.account_subcategory_name,
                s.affiliation_name,
                s.address_line_1,
                s.city,
                s.state,
                s.postal_code,
                s.country,
                s.web_address,
                s.phone_number,
                s.fax_number,
                s.district_name,
                s.enrollment_count,
                s.low_grade_code,
                s.high_grade_code,
                s.majority_ethnicity_group_name,
                s.school_type_name,
                s.kindergarten_school_ind,
                s.ALTERNATIVE_SCHOOL_IND,
                s.site_based_management_ind,
                s.early_child_ind,
                s.TITLE1_NAME,
                s.PER_PUPIL_TEXTBOOK_EXP_NAME,
                s.PER_PUPIL_OTHER_EXP_NAME,
                s.COMPUTER_ASSIST_NAME,
                s.county,
                s.lpip_pid,
                s.ACCOUNT_CLASSIFICATION_CODE,
                s.NACAM_OVERALL_CLASS_NAME,
                s.NACAM_SENIORS_CLASS_NAME,
                s.DW_GRADE_11_ENROLLMENT_QTY,
                s.ship_to_address_line1,
                s.ship_to_city,
                s.ship_to_state,
                s.ship_to_postal_code,
                s.district_lid,
                SYSDATE,
                SYSDATE,
                s.Star_Rating_Reporting)
WHEN MATCHED
THEN
    UPDATE SET
        t.account_name = s.account_name,
        t.active_account_ind = s.active_account_ind,
        t.src_delete_flag = s.src_delete_flag,
        t.account_category_name = s.account_category_name,
        t.account_subcategory_name = s.account_subcategory_name,
        t.affiliation_name = s.affiliation_name,
        t.address_line_1 = s.address_line_1,
        t.city = s.city,
        t.state = s.state,
        t.postal_code = s.postal_code,
        t.country = s.country,
        t.web_address = s.web_address,
        t.phone_number = s.phone_number,
        t.fax_number = s.fax_number,
        t.district_name = s.district_name,
        t.enrollment_count = s.enrollment_count,
        t.low_grade_code = s.low_grade_code,
        t.high_grade_code = s.high_grade_code,
        t.majority_ethnicity_group_name = s.majority_ethnicity_group_name,
        t.school_type_name = s.school_type_name,
        t.kindergarten_school_ind = s.kindergarten_school_ind,
        t.ALTERNATIVE_SCHOOL_IND = s.ALTERNATIVE_SCHOOL_IND,
        t.site_based_management_ind = s.site_based_management_ind,
        t.early_child_ind = s.early_child_ind,
        t.TITLE1_NAME = s.TITLE1_NAME,
        t.PER_PUPIL_TEXTBOOK_EXP_NAME = s.PER_PUPIL_TEXTBOOK_EXP_NAME,
        t.PER_PUPIL_OTHER_EXP_NAME = s.PER_PUPIL_OTHER_EXP_NAME,
        t.COMPUTER_ASSIST_NAME = s.COMPUTER_ASSIST_NAME,
        t.county = s.county,
        t.lpip_pid = s.lpip_pid,
        t.ACCOUNT_CLASSIFICATION_CODE = s.ACCOUNT_CLASSIFICATION_CODE,
        t.NACAM_OVERALL_CLASS_NAME = s.NACAM_OVERALL_CLASS_NAME,
        t.NACAM_SENIORS_CLASS_NAME = s.NACAM_SENIORS_CLASS_NAME,
        t.DW_GRADE_11_ENROLLMENT_QTY = s.DW_GRADE_11_ENROLLMENT_QTY,
        t.ship_to_address_line1 = s.ship_to_address_line1,
        t.ship_to_city = s.ship_to_city,
        t.ship_to_state = s.ship_to_state,
        t.ship_to_postal_code = s.ship_to_postal_code,
        t.district_lid = s.district_lid,
        t.ods_modify_date = sysdate,
        t.Star_Rating_Reporting = s.Star_Rating_Reporting 
             WHERE    DECODE (t.account_name, s.account_name, 1, 0) = 0
                   OR DECODE (t.active_account_ind,
                              s.active_account_ind, 1,
                              0) =
                      0
                    OR DECODE (t.src_delete_flag, s.src_delete_flag, 1, 0) = 0
                   OR DECODE (t.account_category_name,
                              s.account_category_name, 1,
                              0) =
                      0
                   OR DECODE (t.account_subcategory_name,
                              s.account_subcategory_name, 1,
                              0) =
                      0
                   OR DECODE (t.affiliation_name, s.affiliation_name, 1, 0) =
                      0
                   OR DECODE (t.address_line_1, s.address_line_1, 1, 0) = 0
                   OR DECODE (t.city, s.city, 1, 0) = 0
                   OR DECODE (t.state, s.state, 1, 0) = 0
                   OR DECODE (t.postal_code, s.postal_code, 1, 0) = 0
                   OR DECODE (t.country, s.country, 1, 0) = 0
                   OR DECODE (t.web_address, s.web_address, 1, 0) = 0
                   OR DECODE (t.phone_number, s.phone_number, 1, 0) = 0
                   OR DECODE (t.fax_number, s.fax_number, 1, 0) = 0
                   OR DECODE (t.district_name, s.district_name, 1, 0) = 0
                   OR DECODE (t.enrollment_count, s.enrollment_count, 1, 0) =
                      0
                   OR DECODE (t.low_grade_code, s.low_grade_code, 1, 0) = 0
                   OR DECODE (t.high_grade_code, s.high_grade_code, 1, 0) = 0
                   OR DECODE (t.majority_ethnicity_group_name,
                              s.majority_ethnicity_group_name, 1,
                              0) =
                      0
                   OR DECODE (t.school_type_name, s.school_type_name, 1, 0) =
                      0
                   OR DECODE (t.kindergarten_school_ind,
                              s.kindergarten_school_ind, 1,
                              0) =
                      0
                   OR DECODE (t.ALTERNATIVE_SCHOOL_IND,
                              s.ALTERNATIVE_SCHOOL_IND, 1,
                              0) =
                      0
                   OR DECODE (t.site_based_management_ind,
                              s.site_based_management_ind, 1,
                              0) =
                      0
                   OR DECODE (t.early_child_ind, s.early_child_ind, 1, 0) = 0
                   OR DECODE (t.TITLE1_NAME, s.TITLE1_NAME, 1, 0) = 0
                   OR DECODE (t.PER_PUPIL_TEXTBOOK_EXP_NAME,
                              s.PER_PUPIL_TEXTBOOK_EXP_NAME, 1,
                              0) =
                      0
                   OR DECODE (t.PER_PUPIL_OTHER_EXP_NAME,
                              s.PER_PUPIL_OTHER_EXP_NAME, 1,
                              0) =
                      0
                   OR DECODE (t.COMPUTER_ASSIST_NAME,
                              s.COMPUTER_ASSIST_NAME, 1,
                              0) =
                      0
                   OR DECODE (t.county, s.county, 1, 0) = 0
                   OR DECODE (t.lpip_pid, s.lpip_pid, 1, 0) = 0
                   OR DECODE (t.ACCOUNT_CLASSIFICATION_CODE,
                              s.ACCOUNT_CLASSIFICATION_CODE, 1,
                              0) =
                      0
                   OR DECODE (t.NACAM_OVERALL_CLASS_NAME,
                              s.NACAM_OVERALL_CLASS_NAME, 1,
                              0) =
                      0
                   OR DECODE (t.NACAM_SENIORS_CLASS_NAME,
                              s.NACAM_SENIORS_CLASS_NAME, 1,
                              0) =
                      0
                   OR DECODE (t.DW_GRADE_11_ENROLLMENT_QTY,
                              s.DW_GRADE_11_ENROLLMENT_QTY, 1,
                              0) =
                      0
                   OR DECODE (t.ship_to_address_line1,
                              s.ship_to_address_line1, 1,
                              0) =
                      0
                   OR DECODE (t.ship_to_city, s.ship_to_city, 1, 0) = 0
                   OR DECODE (t.ship_to_state, s.ship_to_state, 1, 0) = 0
                   OR DECODE (t.Star_Rating_Reporting, s.Star_Rating_Reporting, 1, 0) = 0
                   OR DECODE (t.ship_to_postal_code,
                              s.ship_to_postal_code, 1,
                              0) =
                      0
                   OR DECODE (t.district_lid, s.district_lid, 1, 0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* update district_name */

merge into mart.account t
using
(
select a.lifetouch_id
, pa.account_alias as district_name
from ods_own.account a
, ods_own.account pa
where 1=1
and a.parent_account_oid = pa.account_oid
) s
on ( s.lifetouch_id = t.lifetouch_id )
when matched then update
set t.district_name = s.district_name
where decode(s.district_name, t.district_name,1,0) = 0

&


/*-----------------------------------------------*/
/* TASK No. 28 */
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
             SUBSTR('2024-08-28 02:38:42.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env
*/

&


/*-----------------------------------------------*/
/* TASK No. 29 */
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
,'LOAD_SF_ACCOUNT_PKG'
,'055'
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
30601906200,
'LOAD_SF_ACCOUNT_PKG',
'055',
TO_DATE(
             SUBSTR('2024-08-28 02:38:42.0', 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          )
,:v_cdc_overlap,
SYSDATE,
 :v_env)
*/


&


/*-----------------------------------------------*/
