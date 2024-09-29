/* TASK No. 1 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */
/* drop  report tabe */


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.actuate_imgstrm_chrgebk_stage';
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
/* TASK No. 3 */
/* Create  report  table */

create table RAX_APP_USER.actuate_imgstrm_chrgebk_stage as
select territory_code
, ams_business_unit_name
, lifetouch_id
, account_name
, city
, state
, chargeback_amount
, item770
from RAX_APP_USER.imagestream_chargeback_true_up
order by territory_code
, lifetouch_id