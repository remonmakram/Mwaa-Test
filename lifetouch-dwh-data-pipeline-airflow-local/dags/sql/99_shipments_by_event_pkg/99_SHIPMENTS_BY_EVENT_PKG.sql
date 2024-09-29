/* TASK No. 1 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */

Set Variable LIFETOUCH_PROJECT.v_cdc_load_table_name. Set to 'SHIPMENTS_BY_EVENT_STG'
Refresh Variable LIFETOUCH_PROJECT.v_data_export_run_date:
select to_char(sysdate,'YYYYMMDD') from dual


Refresh Variable LIFETOUCH_PROJECT.v_record_count_global:
select NUM_ROWS from ODS_APP_USER.RECORD_COUNT_TEMP
WHERE TABLE_NAME = #LIFETOUCH_PROJECT.v_cdc_load_table_name

Evaluate Variable LIFETOUCH_PROJECT.v_record_count_global. GREATER_THAN 1

/*-----------------------------------------------*/
/* TASK No. 2 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 2 */




/*-----------------------------------------------*/
/* TASK No. 3 */
/* Drop Temp Table */

DROP TABLE RAX_APP_USER.REPORT_RUN_DATE_TEMP

&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* Create Temp Table */

CREATE TABLE RAX_APP_USER.REPORT_RUN_DATE_TEMP 
(
END_DATE      DATE,
START_DATE    DATE,
CURR_DATE     DATE
)

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Insert to Temp Table */

INSERT INTO RAX_APP_USER.REPORT_RUN_DATE_TEMP
SELECT DATE_KEY AS END_DATE, DATE_KEY - 10 AS START_DATE,TRUNC(SYSDATE) FROM MART.TIME
WHERE DATE_KEY IN (SELECT DATE_KEY FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) 
AND MONTH_DAY_NUMBER = 1
UNION ALL
SELECT DATE_KEY AS END_DATE, DATE_KEY - 9 AS START_DATE,TRUNC(SYSDATE) FROM MART.TIME
WHERE DATE_KEY IN (SELECT DATE_KEY FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) 
AND MONTH_DAY_NUMBER = 10

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Drop Temp Stage Table */

DROP TABLE RAX_APP_USER.SHIPMENTS_BY_EVENT_STG

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Insert to Stage Table */

CREATE TABLE RAX_APP_USER.SHIPMENTS_BY_EVENT_STG AS
SELECT 
e.plant_name,t.calendar_year,
t.week_number calendar_week_number,
e.job_nbr,m.sales_line_name,
m.program_name,m.sub_program_name,
replace(a.account_name,',',' ') as account_name,f.trans_date,
 sum(f.shipped_order_qty) as shipped_order_qty
FROM 
  MART.EVENT_SALES_FACT f,
  MART.EVENT e,
  MART.MARKETING m,
  MART.TIME t,
  MART.JOB_TICKET_ORGANIZATION_VW jt,
  MART.PLANT_NAME_XREF XREF,
  MART.ACCOUNT A     
where f.event_id = e.event_id
and f.marketing_id = m.marketing_id
and f.trans_date = t.date_key
and e.PLANT_NAME = XREF.PLANT_NAME
and t.calendar_year > (SELECT calendar_year -1 FROM TIME WHERE DATE_KEY = (SELECT TRUNC(SYSDATE) FROM DUAL))
and m.program_name <> 'Money Trans' 
and m.sub_program_name not in ('Commencements')
and substr(e.job_nbr,9,1) not in 'I'
and jt.organization_id = f.job_ticket_org_id
and jt.territory_code NOT IN ('LN')
and t.date_key between (SELECT T2.START_DATE FROM RAX_APP_USER.REPORT_RUN_DATE_TEMP T2) AND (SELECT T2.END_DATE FROM RAX_APP_USER.REPORT_RUN_DATE_TEMP T2) 
and f.account_id = a.account_id
GROUP BY e.plant_name,t.calendar_year,t.week_number,e.job_nbr,m.sales_line_name,m.program_name,m.sub_program_name,a.account_name,f.trans_date
having sum(f.shipped_order_qty) <> 0
ORDER BY e.PLANT_NAME,e.job_nbr, m.sales_line_name,m.program_name,m.sub_program_name,a.account_name,f.trans_date

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Drop Temp Table */

DROP TABLE RAX_APP_USER.RECORD_COUNT_TEMP

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Create Temp Table - RECORD_COUNT_TEMP */

CREATE TABLE RAX_APP_USER.RECORD_COUNT_TEMP
(
TABLE_NAME    VARCHAR2(50),
NUM_ROWS     NUMBER
)

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Merge to ODS_APP_USER.RECORD_COUNT_TEMP */

INSERT INTO RAX_APP_USER.RECORD_COUNT_TEMP T
SELECT 
         'SHIPMENTS_BY_EVENT_STG' AS TABLE_NAME, 
         COUNT(*) AS NUM_ROWS
         FROM RAX_APP_USER.SHIPMENTS_BY_EVENT_STG

         

&


/*-----------------------------------------------*/
/* TASK No. 11 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 11 */




/*-----------------------------------------------*/
/* TASK No. 12 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 12 */




/*-----------------------------------------------*/
/* TASK No. 21 */
/* Drop Temp Table1 */

DROP TABLE RAX_APP_USER.REPORT_RUN_DATE_TEMP

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* Drop Temp Table2 */

DROP TABLE RAX_APP_USER.SHIPMENTS_BY_EVENT_STG

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Drop Temp Table3 */

DROP TABLE RAX_APP_USER.RECORD_COUNT_TEMP

&


/*-----------------------------------------------*/
