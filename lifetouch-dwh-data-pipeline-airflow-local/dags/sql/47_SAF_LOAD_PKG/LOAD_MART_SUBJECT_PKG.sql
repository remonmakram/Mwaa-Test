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
/* Merge into Subject */

MERGE INTO MART.SUBJECT ms USING 
(
SELECT 
    sysdate effective_date
    ,6760548102 as load_id
    ,CASE s.active 
        WHEN 1 THEN 'A'
        WHEN 0 THEN 'I'
        ELSE '.'
     END as active_ind
    ,XR.SUBJECT_ID source_system_key
    ,ss.source_system_short_name source_system_name
    ,-1 as lifetouch_id
    ,CASE staff_flag
        WHEN '1' THEN 'Staff'
        WHEN '0' THEN 'Student'
        ELSE '.'
     END as subject_type
    ,NVL (s.first_name, '.') as subject_first_name
    ,NVL (s.last_name, '.') as subject_last_name
    ,NVL (s.middle_name, '.') as subject_middle_name
    ,NVL (s.grade, '.') as grade
    ,NVL (s.teacher_nbr, '.') as teacher_nbr
    ,s.teacher_first_name || ' ' || (CASE s.teacher_middle_name WHEN NULL THEN NULL ELSE s.teacher_middle_name || ' ' END) || s.teacher_last_name as teacher_name
    ,'.' as line
    ,NVL (s.home_room, '.') as homeroom
    ,NVL (s.period, '.') as period
    ,NVL (s.address_line_1, '.') as address_line1
    ,NVL (s.address_line_2, '.') as address_line2
    ,NVL (s.city, '.') as city
    ,NVL (s.state, '.') as state
    ,NVL (s.postal_code, NVL (s.zip, '.')) as postal_code
    ,'.' as home_phone
    ,'.' as work_phone
    ,'.' as parent_name
    ,s.email_address as email_address
    ,s.gender_code as male_female_code
    ,s.major as major
    ,s.minor as minor
    ,substr(s.squadron,1,20) as squadron
    ,substr(s.external_subject_id,1,40) as extn_subject_id
    ,CASE s.active
         WHEN 1 THEN 'Active'
         WHEN 0 THEN 'Inactive'
         ELSE '.' END as status
    ,s.subject_oid as subject_oid
    ,NVL (s.phone_number, '.')  as phone_number
FROM 
    ODS_OWN.subject s
    ,ODS_OWN.source_system ss
    ,ODS_STAGE.SUBJECT_XR xr
--ODS_STAGE.SM_SUBJECT_XR xr
WHERE (1=1) 
    and s.source_system_oid = ss.source_system_oid
    and S.SUBJECT_OID = XR.SUBJECT_OID
    AND s.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
    and XR.SUBJECT_ID is not null
    and xr.SYSTEM_OF_RECORD = 'SM'
)  os
 ON (ms.subject_oid = os.subject_oid)
WHEN MATCHED THEN UPDATE SET 
     ms.effective_date = os.effective_date
    ,ms.load_id = os.load_id
    ,ms.active_ind = os.active_ind
    ,ms.source_system_key = os.source_system_key
    ,ms.source_system_name = os.source_system_name
    ,ms.lifetouch_id = os.lifetouch_id
    ,ms.subject_type = os.subject_type
    ,ms.subject_first_name = os.subject_first_name
    ,ms.subject_last_name = os.subject_last_name
    ,ms.subject_middle_name = os.subject_middle_name
    ,ms.grade = os.grade
    ,ms.teacher_nbr = os.teacher_nbr
    ,ms.teacher_name = os.teacher_name
    ,ms.line = os.line
    ,ms.homeroom = os.homeroom
    ,ms.period = os.period
    ,ms.address_line1 = os.address_line1
    ,ms.address_line2 = os.address_line2
    ,ms.city = os.city
    ,ms.state = os.state
    ,ms.postal_code = os.postal_code
    ,ms.home_phone = os.home_phone
    ,ms.work_phone = os.work_phone
    ,ms.parent_name = os.parent_name
    ,ms.email_address = os.email_address
    ,ms.male_female_code = os.male_female_code
    ,ms.major = os.major
    ,ms.minor = os.minor
    ,ms.squadron = os.squadron
    ,ms.extn_subject_id = os.extn_subject_id
    ,ms.status = os.status
--    ,ms.subject_oid = os.subject_oid
    ,ms.phone_number = os.phone_number
where 
--    decode(ms.effective_date,os.effective_date,1,0) = 0
    decode(ms.load_id,os.load_id,1,0) = 0
    or decode(ms.active_ind,os.active_ind,1,0) = 0
    or decode(ms.source_system_key,os.source_system_key,1,0) = 0
    or decode(ms.source_system_name,os.source_system_name,1,0) = 0
    or decode(ms.lifetouch_id,os.lifetouch_id,1,0) = 0
    or decode(ms.subject_type,os.subject_type,1,0) = 0
    or decode(ms.subject_first_name,os.subject_first_name,1,0) = 0
    or decode(ms.subject_last_name,os.subject_last_name,1,0) = 0
    or decode(ms.subject_middle_name,os.subject_middle_name,1,0) = 0
    or decode(ms.grade,os.grade,1,0) = 0
    or decode(ms.teacher_nbr,os.teacher_nbr,1,0) = 0
    or decode(ms.teacher_name,os.teacher_name,1,0) = 0
    or decode(ms.line,os.line,1,0) = 0
    or decode(ms.homeroom,os.homeroom,1,0) = 0
    or decode(ms.period,os.period,1,0) = 0
    or decode(ms.address_line1,os.address_line1,1,0) = 0
    or decode(ms.address_line2,os.address_line2,1,0) = 0
    or decode(ms.city,os.city,1,0) = 0
    or decode(ms.state,os.state,1,0) = 0
    or decode(ms.postal_code,os.postal_code,1,0) = 0
    or decode(ms.home_phone,os.home_phone,1,0) = 0
    or decode(ms.work_phone,os.work_phone,1,0) = 0
    or decode(ms.parent_name,os.parent_name,1,0) = 0
    or decode(ms.email_address,os.email_address,1,0) = 0
    or decode(ms.male_female_code,os.male_female_code,1,0) = 0
    or decode(ms.major,os.major,1,0) = 0
    or decode(ms.minor,os.minor,1,0) = 0
    or decode(ms.squadron,os.squadron,1,0) = 0
    or decode(ms.extn_subject_id,os.extn_subject_id,1,0) = 0
    or decode(ms.status,os.status,1,0) = 0
--    or decode(ms.subject_oid,os.subject_oid,1,0) = 0
    or decode(ms.phone_number,os.phone_number,1,0) = 0
WHEN NOT MATCHED THEN INSERT 
(
    subject_id
    ,effective_date
    ,load_id
    ,active_ind
    ,source_system_key
    ,source_system_name
    ,lifetouch_id
    ,subject_type
    ,subject_first_name
    ,subject_last_name
    ,subject_middle_name
    ,grade
    ,teacher_nbr
    ,teacher_name
    ,line
    ,homeroom
    ,period
    ,address_line1
    ,address_line2
    ,city
    ,state
    ,postal_code
    ,home_phone
    ,work_phone
    ,parent_name
    ,email_address
    ,male_female_code
    ,major
    ,minor
    ,squadron
    ,extn_subject_id
    ,status
    ,subject_oid
    ,phone_number
) VALUES (
    MART.subject_id_seq.NEXTVAL
    ,os.effective_date
    ,os.load_id
    ,os.active_ind
    ,os.source_system_key
    ,os.source_system_name
    ,os.lifetouch_id
    ,os.subject_type
    ,os.subject_first_name
    ,os.subject_last_name
    ,os.subject_middle_name
    ,os.grade
    ,os.teacher_nbr
    ,os.teacher_name
    ,os.line
    ,os.homeroom
    ,os.period
    ,os.address_line1
    ,os.address_line2
    ,os.city
    ,os.state
    ,os.postal_code
    ,os.home_phone
    ,os.work_phone
    ,os.parent_name
    ,os.email_address
    ,os.male_female_code
    ,os.major
    ,os.minor
    ,os.squadron
    ,os.extn_subject_id
    ,os.status
    ,os.subject_oid
    ,os.phone_number
)


&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* drop late_subject_dim */


BEGIN  
   EXECUTE IMMEDIATE 'drop table late_subject_dim';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 
&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* create table late_subject_dim */

create table late_subject_dim as
select distinct sapo.subject_oid
FROM
    ODS_OWN.subject s
    ,ODS_OWN.source_system ss
    ,ODS_STAGE.SUBJECT_XR xr
    ,ODS_OWN.SUBJECT_APO sapo
WHERE (1=1)
    and s.source_system_oid = ss.source_system_oid
    and S.SUBJECT_OID = XR.SUBJECT_OID
    and sapo.subject_oid = s.subject_oid
    AND sapo.ods_modify_date >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -:v_cdc_overlap
    and XR.SUBJECT_ID is not null
    and xr.SYSTEM_OF_RECORD = 'SM'
    and not exists
(
select 1
from mart.subject anti_ms
where sapo.subject_oid = anti_ms.subject_oid
)

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* index late_subject_dim */

create unique index late_subject_dim_pk on late_subject_dim(subject_oid)

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* MERGE INTO MART.SUBJECT */

MERGE INTO MART.SUBJECT ms USING 
(
SELECT 
    sysdate effective_date
    ,6760548102 as load_id
    ,CASE s.active 
        WHEN 1 THEN 'A'
        WHEN 0 THEN 'I'
        ELSE '.'
     END as active_ind
    ,XR.SUBJECT_ID source_system_key
    ,ss.source_system_short_name source_system_name
    ,-1 as lifetouch_id
    ,CASE staff_flag
        WHEN '1' THEN 'Staff'
        WHEN '0' THEN 'Student'
        ELSE '.'
     END as subject_type
    ,NVL (s.first_name, '.') as subject_first_name
    ,NVL (s.last_name, '.') as subject_last_name
    ,NVL (s.middle_name, '.') as subject_middle_name
    ,NVL (s.grade, '.') as grade
    ,NVL (s.teacher_nbr, '.') as teacher_nbr
    ,s.teacher_first_name || ' ' || (CASE s.teacher_middle_name WHEN NULL THEN NULL ELSE s.teacher_middle_name || ' ' END) || s.teacher_last_name as teacher_name
    ,'.' as line
    ,NVL (s.home_room, '.') as homeroom
    ,NVL (s.period, '.') as period
    ,NVL (s.address_line_1, '.') as address_line1
    ,NVL (s.address_line_2, '.') as address_line2
    ,NVL (s.city, '.') as city
    ,NVL (s.state, '.') as state
    ,NVL (s.postal_code, NVL (s.zip, '.')) as postal_code
    ,'.' as home_phone
    ,'.' as work_phone
    ,'.' as parent_name
    ,s.email_address as email_address
    ,s.gender_code as male_female_code
    ,s.major as major
    ,s.minor as minor
    ,substr(s.squadron,1,20) as squadron
    ,substr(s.external_subject_id,1,40) as extn_subject_id
    ,CASE s.active
         WHEN 1 THEN 'Active'
         WHEN 0 THEN 'Inactive'
         ELSE '.' END as status
    ,s.subject_oid as subject_oid
    ,NVL (s.phone_number, '.')  as phone_number
FROM 
    ODS_OWN.subject s
    ,ODS_OWN.source_system ss
    ,ODS_STAGE.SUBJECT_XR xr
    ,late_subject_dim d
WHERE (1=1) 
    and s.source_system_oid = ss.source_system_oid
    and S.SUBJECT_OID = XR.SUBJECT_OID
    and d.subject_oid = s.subject_oid
    and XR.SUBJECT_ID is not null
    and xr.SYSTEM_OF_RECORD = 'SM'
)  os
 ON (ms.subject_oid = os.subject_oid)
WHEN NOT MATCHED THEN INSERT 
(
    subject_id
    ,effective_date
    ,load_id
    ,active_ind
    ,source_system_key
    ,source_system_name
    ,lifetouch_id
    ,subject_type
    ,subject_first_name
    ,subject_last_name
    ,subject_middle_name
    ,grade
    ,teacher_nbr
    ,teacher_name
    ,line
    ,homeroom
    ,period
    ,address_line1
    ,address_line2
    ,city
    ,state
    ,postal_code
    ,home_phone
    ,work_phone
    ,parent_name
    ,email_address
    ,male_female_code
    ,major
    ,minor
    ,squadron
    ,extn_subject_id
    ,status
    ,subject_oid
    ,phone_number
) VALUES (
    MART.subject_id_seq.NEXTVAL
    ,os.effective_date
    ,os.load_id
    ,os.active_ind
    ,os.source_system_key
    ,os.source_system_name
    ,os.lifetouch_id
    ,os.subject_type
    ,os.subject_first_name
    ,os.subject_last_name
    ,os.subject_middle_name
    ,os.grade
    ,os.teacher_nbr
    ,os.teacher_name
    ,os.line
    ,os.homeroom
    ,os.period
    ,os.address_line1
    ,os.address_line2
    ,os.city
    ,os.state
    ,os.postal_code
    ,os.home_phone
    ,os.work_phone
    ,os.parent_name
    ,os.email_address
    ,os.male_female_code
    ,os.major
    ,os.minor
    ,os.squadron
    ,os.extn_subject_id
    ,os.status
    ,os.subject_oid
    ,os.phone_number
)

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
,'LOAD_MART_SUBJECT_PKG'
,'009'
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
'LOAD_MART_SUBJECT_PKG',
'009',
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
