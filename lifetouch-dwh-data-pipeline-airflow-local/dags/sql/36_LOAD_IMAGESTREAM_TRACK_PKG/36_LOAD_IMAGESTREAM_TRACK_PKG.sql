/* TASK No. 1 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 2 */




/*-----------------------------------------------*/
/* TASK No. 3 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 3 */




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
/* Drop  tmp_imagestream_load */

-- drop table tmp_imagestream_load
BEGIN
   EXECUTE IMMEDIATE 'drop table tmp_imagestream_load';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Create  tmp_imagestream_load */

Create table tmp_imagestream_load as
select distinct
ol.ODS_CREATE_DATE as ORDER_CREATE_DATE
,ol.LINE_SEQ_NO
,oh.ORDER_NO
,oh.EVENT_REF_ID
,e.PROCESSING_LAB as PLANT_NODE
,e.PLANT_RECEIPT_DATE as PLANT_RECEIVE_DATE
,e.LIFETOUCH_ID as LID
,ss.SOURCE_SYSTEM_NAME as SOURCE_SYSTEM
,apo.SCHOOL_YEAR
, i.item_id
,case when gsi.service_item_type = 'Unknown' then i.item_id
else i.item_id||gsi.service_item_type
end as ITEM_AND_TYPE
,gsi.slot_nbr
from ods_own.order_header oh
, ods_own.event e
, ods_own.apo
, ods_own.order_line ol
, ods_own.order_line bp_ol
, ODS_OWN.SOURCE_SYSTEM ss
, ods_own.item i
, ods_stage.dw_order_line_xr dolx
, ods_own.gdt_service_item gsi
, ods_stage.oms_order_line_xr oolx
where oh.event_ref_id = e.event_ref_id
and oh.order_header_oid = ol.order_header_oid
and e.apo_oid = apo.apo_oid
and ol.bundle_parent_order_line_oid = bp_ol.order_line_oid(+)
and ol.SOURCE_SYSTEM_OID = ss.SOURCE_SYSTEM_OID
and ol.item_oid = i.item_oid
and ol.order_line_oid = dolx.order_line_oid(+)
and dolx.order_line_key = gsi.gdt_service_item_id(+)
and ol.order_line_oid = oolx.order_line_oid(+)
and i.item_id = '774'
and ol.ODS_MODIFY_DATE >= ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap)
and ss.SOURCE_SYSTEM_NAME = 'Data Warehouse'

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Merge IMAGESTREAM_TRACK */

MERGE INTO ODS_OWN.IMAGESTREAM_TRACK T
USING(
select distinct
ORDER_CREATE_DATE
,LINE_SEQ_NO
,ORDER_NO
,EVENT_REF_ID
,PLANT_NODE
,PLANT_RECEIVE_DATE
,LID
,SOURCE_SYSTEM
,SCHOOL_YEAR
,ITEM_AND_TYPE
,SLOT_NBR
from RAX_APP_USER.tmp_imagestream_load
) S
on (T.EVENT_REF_ID = S.EVENT_REF_ID and T.ITEM = S.ITEM_AND_TYPE and T.SLOT_NUMBER = S.SLOT_NBR)
WHEN NOT MATCHED THEN INSERT
(
t.IMG_STREAM_TRACK_OID
,t.ORDER_CREATE_DATE
,t.LINE_SEQ_NO
,t.ORDER_NO
,t.EVENT_REF_ID
,t.PLANT_NODE
,t.PLANT_RECEIVE_DATE
,t.LID
,t.SOURCE_SYSTEM
,t.SCHOOL_YEAR
,t.ITEM
,t.SLOT_NUMBER
,t.ODS_CREATE_DATE
,t.ODS_MODIFY_DATE)
values(
ods_own.IMAGESTREAM_TRACK_SEQ.NEXTVAL
,s.ORDER_CREATE_DATE
,s.LINE_SEQ_NO
,s.ORDER_NO
,s.EVENT_REF_ID
,s.PLANT_NODE
,s.PLANT_RECEIVE_DATE
,s.LID
,s.SOURCE_SYSTEM
,s.SCHOOL_YEAR
,s.ITEM_AND_TYPE
,s.SLOT_NBR
,sysdate
,sysdate)

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* drop table tmp_hp_upd_imagestream */

-- drop table tmp_hp_upd_imagestream
BEGIN
   EXECUTE IMMEDIATE 'drop table tmp_hp_upd_imagestream';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* create tmp upd hp imagestream */

create table tmp_hp_upd_imagestream as
select distinct
substr(upper(LOCAL_LOCATION), -20, 10) as Event_Ref_ID
,replace(substr(LOCAL_LOCATION, -10, 4),'_',NULL)  as Item
,substr(LOCAL_LOCATION, -6, 2) as Slot
,LID
,ACADEMIC_YEAR
,CREATED_DATE as PORTAL_CREATE_DATE
,STATUS
,UPDATED_ON
from ODS_STAGE.HP_IMAGESTREAM_STG
where ODS_MODIFY_DATE   >= ( TO_DATE(SUBSTR(:v_cdc_ld_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap)
and LENGTH(TRIM(TRANSLATE(substr(LOCAL_LOCATION, -6, 2), ' +-.0123456789', ' '))) is null
and  LENGTH(TRIM(TRANSLATE(replace(substr(LOCAL_LOCATION, -10, 4),'_',NULL), ' +-.0123456789', ' '))) is null


&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Update ImageStream_Track with Portal Create Date */

UPDATE ODS_OWN.IMAGESTREAM_TRACK t
SET
  (
    t.PORTAL_CREATE_DATE,
    t.ODS_MODIFY_DATE
  )
  =
  (SELECT distinct
  max(temp.PORTAL_CREATE_DATE) as PORTAL_CREATE_DATE
  ,sysdate
  FROM tmp_hp_upd_imagestream temp
  WHERE t.event_ref_id = temp.event_ref_id and t.item = temp.item and t.slot_number = temp.slot
  )
WHERE EXISTS
  (SELECT 1
  FROM tmp_hp_upd_imagestream temp
  WHERE t.event_ref_id=temp.event_ref_id and t.item = temp.item and t.slot_number = temp.slot
  )

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Update ImageStream Track with Processed Date */

UPDATE ODS_OWN.IMAGESTREAM_TRACK t
SET
  (
    t.PORTAL_PROCESSED_DATE,
    t.ODS_MODIFY_DATE
  )
  =
  (SELECT distinct
    (
    CASE
      WHEN temp.status = 'PROCESSED'
      THEN NVL(temp.UPDATED_ON, temp.PORTAL_CREATE_DATE)
      ELSE NULL
    END) 
  ,sysdate
  FROM tmp_hp_upd_imagestream temp
  WHERE t.event_ref_id = temp.event_ref_id and t.item = temp.item and t.slot_number = temp.slot and t.PORTAL_CREATE_DATE = temp.PORTAL_CREATE_DATE
  )
WHERE EXISTS
  (SELECT 1
  FROM tmp_hp_upd_imagestream temp
  WHERE t.event_ref_id=temp.event_ref_id and t.item = temp.item and t.slot_number = temp.slot and t.PORTAL_CREATE_DATE = temp.PORTAL_CREATE_DATE)

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Update CDC Load Status */

UPDATE ODS_OWN.ODS_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE ODS_TABLE_NAME=:v_cdc_load_table_name


&


/*-----------------------------------------------*/
/* TASK No. 15 */
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
'36_LOAD_IMAGESTREAM_TRACK_PKG',
'001',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_ld_date, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          ),
:v_cdc_oms_overlap,
SYSDATE)

&


/*-----------------------------------------------*/
