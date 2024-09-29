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
/* MERGE INTO ODS_STAGE.FOW_ORDER_STATUS_XR */

MERGE INTO ODS_STAGE.FOW_ORDER_STATUS_XR d
USING (
select * from
    (  Select
    OS.ORDER_STATUS_OID as OS_ORDER_STATUS_OID,xr.ORDER_STATUS_OID as XR_ORDER_STATUS_OID,
        nvl(OS.ORDER_STATUS_OID,xr.ORDER_STATUS_OID) ORDER_STATUS_OID,
        stg.CODE ORDER_STATUS_CODE,
        sysdate as ODS_CREATE_DATE,
        sysdate as ODS_MODIFY_DATE
    -- select *
    FROM 
        ODS_STAGE.FOW_REFERENCE_STG stg
        ,ODS_STAGE.FOW_ORDER_STATUS_XR xr
        ,ODS_OWN.ORDER_STATUS OS
    WHERE (1=1)
        and stg.CODE=OS.ORDER_STATUS_CODE(+)
        and stg.CODE=XR.ORDER_STATUS_CODE(+)
        and stg.NAME(+) = 'ORDER_STATUS'
     ) s
where NOT EXISTS 
	( select 1 from ODS_STAGE.FOW_ORDER_STATUS_XR T
	where	T.ORDER_STATUS_CODE	= S.ORDER_STATUS_CODE 
		 and
		((T.ORDER_STATUS_OID = S.ORDER_STATUS_OID) or (T.ORDER_STATUS_OID IS NULL and S.ORDER_STATUS_OID IS NULL)) 
        )
) s 
ON
  (s.ORDER_STATUS_CODE=d.ORDER_STATUS_CODE)
WHEN MATCHED
THEN
UPDATE SET
  d.ORDER_STATUS_OID = s.ORDER_STATUS_OID,
  d.ODS_MODIFY_DATE = s.ODS_MODIFY_DATE
WHEN NOT MATCHED
THEN
INSERT (
  ORDER_STATUS_OID, ORDER_STATUS_CODE,ODS_CREATE_DATE, ODS_MODIFY_DATE)
VALUES (
  nvl(s.ORDER_STATUS_OID,ODS_STAGE.ORDER_STATUS_OID_SEQ.nextval), s.ORDER_STATUS_CODE,  s.ODS_CREATE_DATE, s.ODS_MODIFY_DATE)

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* MERGE INTO ODS_OWN.ORDER_STATUS  */

MERGE INTO ODS_OWN.ORDER_STATUS d
USING (
select * from (
      Select
        xr.ORDER_STATUS_OID as ORDER_STATUS_OID,
        xr.ORDER_STATUS_CODE as ORDER_STATUS_CODE,
        stg.DESCRIPTION as ORDER_STATUS,
        sysdate as ODS_CREATE_DATE,
        sysdate as ODS_MODIFY_DATE,
        SS.SOURCE_SYSTEM_OID as SOURCE_SYSTEM_OID
        --select *
    from
        ODS_STAGE.FOW_REFERENCE_STG stg
        ,ODS_STAGE.FOW_ORDER_STATUS_XR xr
        ,ODS_OWN.SOURCE_SYSTEM ss
--        ,ODS_OWN.ORDER_STATUS OS
    where (1=1)
        and STG.CODE=XR.ORDER_STATUS_CODE
        and stg.NAME = 'ORDER_STATUS'
        and SS.SOURCE_SYSTEM_SHORT_NAME='FOW'
         ) s
where NOT EXISTS 
	( select 1 from ODS_OWN.ORDER_STATUS T
	where	T.ORDER_STATUS_OID	= S.ORDER_STATUS_OID 
		 and ((T.ORDER_STATUS_CODE = S.ORDER_STATUS_CODE) or (T.ORDER_STATUS_CODE IS NULL and S.ORDER_STATUS_CODE IS NULL)) and
        ((T.ORDER_STATUS = S.ORDER_STATUS) or (T.ORDER_STATUS IS NULL and S.ORDER_STATUS IS NULL)) and
        ((T.SOURCE_SYSTEM_OID = S.SOURCE_SYSTEM_OID) or (T.SOURCE_SYSTEM_OID IS NULL and S.SOURCE_SYSTEM_OID IS NULL))
        )
) s ON
  (d.ORDER_STATUS_CODE = s.ORDER_STATUS_CODE)
WHEN MATCHED
THEN
UPDATE SET
  d.ORDER_STATUS_OID = s.ORDER_STATUS_OID,
  d.ORDER_STATUS = s.ORDER_STATUS,
  d.ODS_MODIFY_DATE = s.ODS_MODIFY_DATE,
  d.SOURCE_SYSTEM_OID = s.SOURCE_SYSTEM_OID
WHEN NOT MATCHED
THEN
INSERT (
    ORDER_STATUS_OID
    ,ORDER_STATUS_CODE 
    ,ORDER_STATUS
    ,ODS_CREATE_DATE
    ,ODS_MODIFY_DATE 
    ,SOURCE_SYSTEM_OID
  )
VALUES (
    s.ORDER_STATUS_OID
    ,s.ORDER_STATUS_CODE 
    ,s.ORDER_STATUS
    ,s.ODS_CREATE_DATE
    ,s.ODS_MODIFY_DATE 
    ,s.SOURCE_SYSTEM_OID
)

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name
AND CONTEXT_NAME = :v_env

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Insert CDC Audit Record */

INSERT INTO RAX_APP_USER.ODS_CDC_LOAD_STATUS_AUDIT
(TABLE_NAME,
SESS_NO,                      
SESS_NAME,                    
SCEN_VERSION,                 
SESS_BEG,                     
ORIG_LAST_CDC_COMPLETION_DATE,
OVERLAP,
CREATE_DATE              
)
values (
:v_cdc_load_table_name,
:v_sess_no,
'LOAD_ORDER_STATUS_PKG',
'001',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          ),
:v_cdc_overlap,
SYSDATE)

&


/*-----------------------------------------------*/
