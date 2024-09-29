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
/* drop temp table */



BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_order_subject';
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
/* TASK No. 5 */
/* create temp table */

create table RAX_APP_USER.tmp_order_subject
as
  select
       S.ORDER_HEADER_OID, MS.SUBJECT_ID, MS.SUBJECT_TYPE
  from
       MART.order_header_fact S
      ,ODS_OWN.CAPTURE_SESSION CS
      ,MART.SUBJECT MS
  where (1=1)
      and S.SUBJECT_ID = 1
      and S.MATCHED_CAPTURE_SESSION_ID = CS.CAPTURE_SESSION_KEY
      and CS.SUBJECT_OID = MS.SUBJECT_OID     
      and MS.EFFECTIVE_DATE > TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS')  -3/24


&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* index temp table */

create index RAX_APP_USER.tmp_order_subject_ix on RAX_APP_USER.tmp_order_subject(order_header_oid)

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* merge into mart.order_header_fact */

merge into MART.order_header_fact T
using 
(
  select
       S.ORDER_HEADER_OID, tmp.SUBJECT_ID, JUNK.ORDER_JUNK_ID
  from
       MART.order_header_fact s
      ,MART.order_junk_dim junk
      ,RAX_APP_USER.tmp_order_subject tmp
      , MART.ORDER_JUNK_DIM OLDJUNK
  where (1=1)     
     and S.ORDER_JUNK_ID = OLDJUNK.ORDER_JUNK_ID     
     AND NVL(OLDJUNK.OTD_FLAG, -1) = NVL(JUNK.OTD_FLAG, -1)
     AND NVL(OLDJUNK.ORDER_BUCKET, -1) = NVL(JUNK.ORDER_BUCKET, -1)
     AND S.ORDER_HEADER_OID = tmp.ORDER_HEADER_OID
     AND OLDJUNK.MLT_ORDER_TYPE = NVL(JUNK.MLT_ORDER_TYPE,'UNKNOWN')
     AND JUNK.SUBJECT_TYPE = NVL(UPPER(tmp.SUBJECT_TYPE),'UNKNOWN')
) SRC
on (T.ORDER_HEADER_OID = SRC.ORDER_HEADER_OID)
when matched then update set
T.SUBJECT_ID = SRC.SUBJECT_ID,
T.ORDER_JUNK_ID = SRC.ORDER_JUNK_ID

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* drop temp table1 */

BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_line_subject';
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
/* create temp table1 */

create table RAX_APP_USER.tmp_line_subject
as
  select
       ol.order_line_oid, oh.subject_id, oh.order_junk_id
  from
      RAX_APP_USER. tmp_order_subject s
      ,MART.order_line_fact ol
      ,MART.order_header_fact oh
  where (1=1)
      and s.order_header_oid = ol.order_header_oid
      and s.order_header_oid = oh.order_header_oid
     


&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* index temp table1 */

create index RAX_APP_USER.tmp_line_subject_ix on RAX_APP_USER.tmp_line_subject(order_line_oid)

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* merge into mart.order_line_fact */

merge into MART.order_line_fact T
using 
(
  select
       order_line_oid, subject_id, order_junk_id
  from       
       RAX_APP_USER.tmp_line_subject  
) SRC
on (T.order_line_oid = SRC.order_line_oid)
when matched then update set
T.SUBJECT_ID = SRC.SUBJECT_ID,
T.ORDER_JUNK_ID = SRC.ORDER_JUNK_ID

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* drop temp table2 */


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_look_subject';
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
/* create temp table2 */

create table RAX_APP_USER.tmp_look_subject
as
  select
       ol.order_look_id, s.subject_id
  from
      RAX_APP_USER. tmp_order_subject s
      , MART.order_look_fact ol
  where (1=1)
      and s.order_header_oid = ol.order_header_oid
      
     


&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* index temp table2 */

create index RAX_APP_USER.tmp_look_subject_ix on RAX_APP_USER.tmp_look_subject(order_look_id)

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* merge into mart.order_look_fact */

merge into MART.order_look_fact T
using 
(
  select
       order_look_id, subject_id
  from       
       RAX_APP_USER.tmp_look_subject  
) SRC
on (T.order_look_id = SRC.order_look_id)
when matched then update set
T.SUBJECT_ID = SRC.SUBJECT_ID


&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* drop temp table3 */


BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.tmp_promo_subject';
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
/* TASK No. 17 */
/* create temp table3 */

create table RAX_APP_USER.tmp_promo_subject
as
  select
       op.order_promotion_id, s.subject_id
  from
      RAX_APP_USER. tmp_order_subject s
     , MART.order_promotion_fact op
     , ODS_OWN.order_header oh
  where (1=1)
      and s.order_header_oid = oh.order_header_oid
      and oh.order_no = op.order_no

&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* index temp table3 */

create index RAX_APP_USER.tmp_promo_subject_ix on RAX_APP_USER.tmp_promo_subject(order_promotion_id)

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* merge into mart.order_promotion_fact */

merge into MART.order_promotion_fact T
using 
(
  select
       order_promotion_id, subject_id
  from       
       RAX_APP_USER.tmp_promo_subject  
) SRC
on (T.order_promotion_id = SRC.order_promotion_id)
when matched then update set
T.SUBJECT_ID = SRC.SUBJECT_ID


&


/*-----------------------------------------------*/
/* TASK No. 20 */
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
/* TASK No. 21 */
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
,'UPDATE_SUBJECT_ID_ORDER_FACT_TABLES_PKG'
,'003'
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
'UPDATE_SUBJECT_ID_ORDER_FACT_TABLES_PKG',
'003',
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
