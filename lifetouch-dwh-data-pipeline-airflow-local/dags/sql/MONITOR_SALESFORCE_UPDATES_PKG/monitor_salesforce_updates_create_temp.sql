
/*-----------------------------------------------*/
/* TASK No. 6 */
/* Drop Table */

BEGIN  
   EXECUTE IMMEDIATE 'drop table rax_app_user.monitor_salesforce_updates';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;




&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Create and Load Table */

create table rax_app_user.monitor_salesforce_updates as
SELECT 'Opportunity' AS table_name, MAX (ods_modify_date) as last_update_date
  FROM ods_stage.sf_opportunity_stg
UNION
SELECT 'Account' AS table_name, MAX (ods_modify_date) as last_update_date
  FROM ods_stage.sf_account_stg
UNION
SELECT 'ServiceAppoitment' AS table_name, MAX (ods_modify_date) as last_update_date
  FROM ods_stage.sf_serviceappointment_stg
UNION
SELECT 'Order2' AS table_name, MAX (ods_modify_date) as last_update_date
  FROM ods_stage.sf_order2_stg

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Delete Up To Date Tables */

delete from rax_app_user.monitor_salesforce_updates
where last_update_date >= sysdate -1

&

