


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.SERVICENOW_CONTACT_STAGE';
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
/* TASK No. 9 */
/* create table */

create table RAX_APP_USER.SERVICENOW_CONTACT_STAGE as
SELECT a.lifetouch_id,
       c.contact_oid,
       c.first_name,
       c.last_name,
       c.title_name,
       c.work_phone,
       c.email_address
  FROM ods_own.account        a,
       ods_own.account        pa,
       ods_own.contact        c,
       ods_own.source_system  ss
 WHERE     1 = 1
       AND a.account_oid = c.account_oid
       AND a.parent_account_oid = pa.account_oid(+)
       AND c.source_system_oid = ss.source_system_oid
       AND ss.source_system_short_name NOT IN ('MDR')
       AND a.active_account_ind = 'A'
       AND (a.category_name<>'Test' OR a.subcategory_name<>'Test')
       AND UPPER(c.email_address) NOT LIKE '%@LIFETOUCH.COM'
       AND UPPER(c.email_address) NOT LIKE '%@LIFETOUCH.CA'
       AND a.account_name not like '%Test Account%' 
     AND EXISTS
               (SELECT 1
                  FROM ods_own.booking_opportunity  bo,
                       (SELECT TO_NUMBER (TO_CHAR (SYSDATE, 'YYYY'))    AS school_year
                          FROM DUAL) curr
                 WHERE     bo.account_oid = a.account_oid
                       AND bo.school_year IN
                               (curr.school_year, curr.school_year - 1)
                       AND bo.booking_status IN ('Agreement Filed'))