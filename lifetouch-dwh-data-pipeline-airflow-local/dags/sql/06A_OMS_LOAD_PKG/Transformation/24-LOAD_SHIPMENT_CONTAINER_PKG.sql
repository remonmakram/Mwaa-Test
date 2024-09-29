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
/* Drop tmp table */

-- drop table rax_app_user.oms3_shipment_container_tmp

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 5 */
-- /* Create tmp table */

-- create table rax_app_user.oms3_shipment_container_tmp (
--     SHIPMENT_CONTAINER_KEY          VARCHAR2 (24),
--     MANIFEST_KEY                    VARCHAR2 (24),
--     SHIPMENT_KEY                    VARCHAR2 (24),
--     LOAD_KEY                        VARCHAR2 (24),
--     PIPELINE_KEY                    VARCHAR2 (24),
--     STATUS                          VARCHAR2 (15),
--     DOCUMENT_TYPE                   VARCHAR2 (40),
--     ORDER_HEADER_KEY                VARCHAR2 (24),
--     ORDER_RELEASE_KEY               VARCHAR2 (24),
--     SHIP_TO_KEY                     VARCHAR2 (24),
--     CONTAINER_SEQ_NO                NUMBER,
--     TRACKING_NO                     VARCHAR2 (40),
--     COD_RETURN_TRACKING_NO          VARCHAR2 (40),
--     COD_AMOUNT                      NUMBER,
--     UCC128CODE                      VARCHAR2 (40),
--     MANIFEST_NO                     VARCHAR2 (40),
--     CONTAINER_SCM                   VARCHAR2 (40),
--     CONTAINER_EPC                   VARCHAR2 (250),
--     CONTAINER_TYPE                  VARCHAR2 (6),
--     CORRUGATION_ITEM_KEY            VARCHAR2 (24),
--     CONTAINER_LENGTH                NUMBER,
--     CONTAINER_WIDTH                 NUMBER,
--     CONTAINER_HEIGHT                NUMBER,
--     CONTAINER_GROSS_WEIGHT          NUMBER,
--     CONTAINER_NET_WEIGHT            NUMBER,
--     CONTAINER_LENGTH_UOM            VARCHAR2 (40),
--     CONTAINER_HEIGHT_UOM            VARCHAR2 (40),
--     CONTAINER_WIDTH_UOM             VARCHAR2 (40),
--     CONTAINER_GROSS_WEIGHT_UOM      VARCHAR2 (40),
--     CONTAINER_NET_WEIGHT_UOM        VARCHAR2 (40),
--     APPLIED_WEIGHT_UOM              VARCHAR2 (40),
--     HAS_OTHER_CONTAINERS            VARCHAR2 (1),
--     MASTER_CONTAINER_NO             NUMBER,
--     ACTUAL_FREIGHT_CHARGE           NUMBER,
--     SCAC                            VARCHAR2 (24),
--     SHIP_DATE                       DATE,
--     SHIP_MODE                       VARCHAR2 (40),
--     ZONE                            VARCHAR2 (15),
--     OVERSIZED_FLAG                  VARCHAR2 (1),
--     DIMMED_FLAG                     VARCHAR2 (1),
--     CARRIER_BILL_ACCOUNT            VARCHAR2 (40),
--     CARRIER_PAYMENT_TYPE            VARCHAR2 (20),
--     ASTRA_CODE                      VARCHAR2 (40),
--     ROUTING_CODE                    VARCHAR2 (20),
--     SERVICE_TYPE                    VARCHAR2 (20),
--     CARRIER_LOCATION_ID             VARCHAR2 (20),
--     CARRIER_SERVICE_CODE            VARCHAR2 (40),
--     APPLIED_WEIGHT                  NUMBER,
--     ACTUAL_WEIGHT                   NUMBER,
--     ACTUAL_WEIGHT_UOM               VARCHAR2 (40),
--     COMMITMENT_CODE                 VARCHAR2 (20),
--     DELIVERY_DAY                    VARCHAR2 (20),
--     DELIVER_BY                      VARCHAR2 (20),
--     FORM_ID                         VARCHAR2 (20),
--     BASIC_FREIGHT_CHARGE            NUMBER,
--     SPECIAL_SERVICES_SURCHARGE      NUMBER,
--     DELIVERY_CODE                   VARCHAR2 (40),
--     BARCODE_DISCOUNT                VARCHAR2 (1),
--     DISCOUNT_AMOUNT                 NUMBER,
--     CUSTOMS_VALUE                   NUMBER,
--     CARRIAGE_VALUE                  NUMBER,
--     DECLARED_VALUE                  NUMBER,
--     EXPORT_LICENSE_NO               VARCHAR2 (40),
--     EXPORT_LICENSE_EXP_DATE         DATE,
--     FREIGHT_TERMS                   VARCHAR2 (40),
--     CUSTCARRIER_ACCOUNT_NO          VARCHAR2 (40),
--     CONTAINER_NO                    VARCHAR2 (40),
--     PARENT_CONTAINER_KEY            VARCHAR2 (24),
--     PARENT_CONTAINER_NO             VARCHAR2 (40),
--     CONTAINER_GROUP                 VARCHAR2 (10),
--     PARENT_CONTAINER_GROUP          VARCHAR2 (10),
--     IS_RECEIVED                     VARCHAR2 (1),
--     IS_PACK_PROCESS_COMPLETE        VARCHAR2 (1),
--     STATUS_DATE                     DATE,
--     USED_DURING_PICK                VARCHAR2 (1),
--     SYSTEM_SUGGESTED                VARCHAR2 (1),
--     WAVE_KEY                        VARCHAR2 (24),
--     CONTAINS_STD_QTY                VARCHAR2 (1),
--     TASK_TYPE                       VARCHAR2 (10),
--     SERVICE_ITEM_ID                 VARCHAR2 (40),
--     IS_HAZMAT                       VARCHAR2 (1),
--     LOCKID                          NUMBER (5),
--     CREATETS                        DATE,
--     MODIFYTS                        DATE,
--     CREATEUSERID                    VARCHAR2 (40),
--     MODIFYUSERID                    VARCHAR2 (40),
--     CREATEPROGID                    VARCHAR2 (40),
--     MODIFYPROGID                    VARCHAR2 (40),
--     REQUIRED_NO_OF_RETURN_LABELS    NUMBER,
--     ACTUAL_NO_OF_RETURN_LABELS      NUMBER,
--     EXTN_SORT_TYPE                  VARCHAR2 (10),
--     EXTN_SORT_VALUE                 VARCHAR2 (50),
--     EXTERNAL_REFERENCE_1            VARCHAR2 (250),
--     IS_MANIFESTED                   VARCHAR2 (1),
--     ods_create_date date,
--     ods_modify_date date
-- )

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 6 */
-- /* Load tmp table */

-- /* SOURCE CODE */
-- SELECT 
-- TRIM (SHIPMENT_CONTAINER_KEY)       AS SHIPMENT_CONTAINER_KEY,
--        TRIM (MANIFEST_KEY)                 AS MANIFEST_KEY,
--        TRIM (SHIPMENT_KEY)                 AS SHIPMENT_KEY,
--        TRIM (LOAD_KEY)                     AS LOAD_KEY,
--        TRIM (PIPELINE_KEY)                 AS PIPELINE_KEY,
--        TRIM (STATUS)                       AS STATUS,
--        DOCUMENT_TYPE,
--        TRIM (ORDER_HEADER_KEY)             AS ORDER_HEADER_KEY,
--        TRIM (ORDER_RELEASE_KEY)            AS ORDER_RELEASE_KEY,
--        TRIM (SHIP_TO_KEY)                  SHIP_TO_KEY,
--        CONTAINER_SEQ_NO,
--        TRACKING_NO,
--        TRIM (COD_RETURN_TRACKING_NO)       AS COD_RETURN_TRACKING_NO,
--        COD_AMOUNT,
--        UCC128CODE,
--        MANIFEST_NO,
--        CONTAINER_SCM,
--        CONTAINER_EPC,
--        TRIM (CONTAINER_TYPE)               AS CONTAINER_TYPE,
--        TRIM (CORRUGATION_ITEM_KEY)         AS CORRUGATION_ITEM_KEY,
--        CONTAINER_LENGTH,
--        CONTAINER_WIDTH,
--        CONTAINER_HEIGHT,
--        CONTAINER_GROSS_WEIGHT,
--        CONTAINER_NET_WEIGHT,
--        CONTAINER_LENGTH_UOM,
--        CONTAINER_HEIGHT_UOM,
--        CONTAINER_WIDTH_UOM,
--        CONTAINER_GROSS_WEIGHT_UOM,
--        CONTAINER_NET_WEIGHT_UOM,
--        APPLIED_WEIGHT_UOM,
--        TRIM (HAS_OTHER_CONTAINERS)         AS HAS_OTHER_CONTAINERS,
--        MASTER_CONTAINER_NO,
--        ACTUAL_FREIGHT_CHARGE,
--        TRIM (SCAC)                         AS SCAC,
--        SHIP_DATE,
--        SHIP_MODE,
--        ZONE,
--        TRIM (OVERSIZED_FLAG)               AS OVERSIZED_FLAG,
--        TRIM (DIMMED_FLAG)                  AS DIMMED_FLAG,
--        CARRIER_BILL_ACCOUNT,
--        CARRIER_PAYMENT_TYPE,
--        ASTRA_CODE,
--        ROUTING_CODE,
--        SERVICE_TYPE,
--        CARRIER_LOCATION_ID,
--        CARRIER_SERVICE_CODE,
--        APPLIED_WEIGHT,
--        ACTUAL_WEIGHT,
--        ACTUAL_WEIGHT_UOM,
--        COMMITMENT_CODE,
--        DELIVERY_DAY,
--        DELIVER_BY,
--        FORM_ID,
--        BASIC_FREIGHT_CHARGE,
--        SPECIAL_SERVICES_SURCHARGE,
--        DELIVERY_CODE,
--        TRIM (BARCODE_DISCOUNT)             AS BARCODE_DISCOUNT,
--        DISCOUNT_AMOUNT,
--        CUSTOMS_VALUE,
--        CARRIAGE_VALUE,
--        DECLARED_VALUE,
--        EXPORT_LICENSE_NO,
--        EXPORT_LICENSE_EXP_DATE,
--        FREIGHT_TERMS,
--        CUSTCARRIER_ACCOUNT_NO,
--        CONTAINER_NO,
--        TRIM (PARENT_CONTAINER_KEY)         PARENT_CONTAINER_KEY,
--        PARENT_CONTAINER_NO,
--        CONTAINER_GROUP,
--        PARENT_CONTAINER_GROUP,
--        TRIM (IS_RECEIVED)                  AS IS_RECEIVED,
--        TRIM (IS_PACK_PROCESS_COMPLETE)     AS IS_PACK_PROCESS_COMPLETE,
--        STATUS_DATE,
--        TRIM (USED_DURING_PICK)             AS USED_DURING_PICK,
--        TRIM (SYSTEM_SUGGESTED)             AS SYSTEM_SUGGESTED,
--        TRIM (WAVE_KEY)                     AS WAVE_KEY,
--        TRIM (CONTAINS_STD_QTY)             AS CONTAINS_STD_QTY,
--        TRIM (TASK_TYPE)                    AS TASK_TYPE,
--        SERVICE_ITEM_ID,
--        TRIM (IS_HAZMAT)                    AS IS_HAZMAT,
--        LOCKID,
--        CREATETS,
--        MODIFYTS,
--        CREATEUSERID,
--        MODIFYUSERID,
--        CREATEPROGID,
--        MODIFYPROGID,
--        REQUIRED_NO_OF_RETURN_LABELS,
--        ACTUAL_NO_OF_RETURN_LABELS,
--        EXTN_SORT_TYPE,
--        EXTN_SORT_VALUE,
--        EXTERNAL_REFERENCE_1,
--        TRIM (IS_MANIFESTED)                AS IS_MANIFESTED
--   FROM OMS3_OWN.YFS_SHIPMENT_CONTAINER 
--  WHERE modifyts >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap

-- &

-- /* TARGET CODE */
-- INSERT INTO rax_app_user.oms3_shipment_container_tmp (
--                 SHIPMENT_CONTAINER_KEY,
--                 MANIFEST_KEY,
--                 SHIPMENT_KEY,
--                 LOAD_KEY,
--                 PIPELINE_KEY,
--                 STATUS,
--                 DOCUMENT_TYPE,
--                 ORDER_HEADER_KEY,
--                 ORDER_RELEASE_KEY,
--                 SHIP_TO_KEY,
--                 CONTAINER_SEQ_NO,
--                 TRACKING_NO,
--                 COD_RETURN_TRACKING_NO,
--                 COD_AMOUNT,
--                 UCC128CODE,
--                 MANIFEST_NO,
--                 CONTAINER_SCM,
--                 CONTAINER_EPC,
--                 CONTAINER_TYPE,
--                 CORRUGATION_ITEM_KEY,
--                 CONTAINER_LENGTH,
--                 CONTAINER_WIDTH,
--                 CONTAINER_HEIGHT,
--                 CONTAINER_GROSS_WEIGHT,
--                 CONTAINER_NET_WEIGHT,
--                 CONTAINER_LENGTH_UOM,
--                 CONTAINER_HEIGHT_UOM,
--                 CONTAINER_WIDTH_UOM,
--                 CONTAINER_GROSS_WEIGHT_UOM,
--                 CONTAINER_NET_WEIGHT_UOM,
--                 APPLIED_WEIGHT_UOM,
--                 HAS_OTHER_CONTAINERS,
--                 MASTER_CONTAINER_NO,
--                 ACTUAL_FREIGHT_CHARGE,
--                 SCAC,
--                 SHIP_DATE,
--                 SHIP_MODE,
--                 ZONE,
--                 OVERSIZED_FLAG,
--                 DIMMED_FLAG,
--                 CARRIER_BILL_ACCOUNT,
--                 CARRIER_PAYMENT_TYPE,
--                 ASTRA_CODE,
--                 ROUTING_CODE,
--                 SERVICE_TYPE,
--                 CARRIER_LOCATION_ID,
--                 CARRIER_SERVICE_CODE,
--                 APPLIED_WEIGHT,
--                 ACTUAL_WEIGHT,
--                 ACTUAL_WEIGHT_UOM,
--                 COMMITMENT_CODE,
--                 DELIVERY_DAY,
--                 DELIVER_BY,
--                 FORM_ID,
--                 BASIC_FREIGHT_CHARGE,
--                 SPECIAL_SERVICES_SURCHARGE,
--                 DELIVERY_CODE,
--                 BARCODE_DISCOUNT,
--                 DISCOUNT_AMOUNT,
--                 CUSTOMS_VALUE,
--                 CARRIAGE_VALUE,
--                 DECLARED_VALUE,
--                 EXPORT_LICENSE_NO,
--                 EXPORT_LICENSE_EXP_DATE,
--                 FREIGHT_TERMS,
--                 CUSTCARRIER_ACCOUNT_NO,
--                 CONTAINER_NO,
--                 PARENT_CONTAINER_KEY,
--                 PARENT_CONTAINER_NO,
--                 CONTAINER_GROUP,
--                 PARENT_CONTAINER_GROUP,
--                 IS_RECEIVED,
--                 IS_PACK_PROCESS_COMPLETE,
--                 STATUS_DATE,
--                 USED_DURING_PICK,
--                 SYSTEM_SUGGESTED,
--                 WAVE_KEY,
--                 CONTAINS_STD_QTY,
--                 TASK_TYPE,
--                 SERVICE_ITEM_ID,
--                 IS_HAZMAT,
--                 LOCKID,
--                 CREATETS,
--                 MODIFYTS,
--                 CREATEUSERID,
--                 MODIFYUSERID,
--                 CREATEPROGID,
--                 MODIFYPROGID,
--                 REQUIRED_NO_OF_RETURN_LABELS,
--                 ACTUAL_NO_OF_RETURN_LABELS,
--                 EXTN_SORT_TYPE,
--                 EXTN_SORT_VALUE,
--                 EXTERNAL_REFERENCE_1,
--                 IS_MANIFESTED,
--                 ODS_CREATE_DATE,
--                 ODS_MODIFY_DATE)
--      VALUES (:SHIPMENT_CONTAINER_KEY,
--              :MANIFEST_KEY,
--              :SHIPMENT_KEY,
--              :LOAD_KEY,
--              :PIPELINE_KEY,
--              :STATUS,
--              :DOCUMENT_TYPE,
--              :ORDER_HEADER_KEY,
--              :ORDER_RELEASE_KEY,
--              :SHIP_TO_KEY,
--              :CONTAINER_SEQ_NO,
--              :TRACKING_NO,
--              :COD_RETURN_TRACKING_NO,
--              :COD_AMOUNT,
--              :UCC128CODE,
--              :MANIFEST_NO,
--              :CONTAINER_SCM,
--              :CONTAINER_EPC,
--              :CONTAINER_TYPE,
--              :CORRUGATION_ITEM_KEY,
--              :CONTAINER_LENGTH,
--              :CONTAINER_WIDTH,
--              :CONTAINER_HEIGHT,
--              :CONTAINER_GROSS_WEIGHT,
--              :CONTAINER_NET_WEIGHT,
--              :CONTAINER_LENGTH_UOM,
--              :CONTAINER_HEIGHT_UOM,
--              :CONTAINER_WIDTH_UOM,
--              :CONTAINER_GROSS_WEIGHT_UOM,
--              :CONTAINER_NET_WEIGHT_UOM,
--              :APPLIED_WEIGHT_UOM,
--              :HAS_OTHER_CONTAINERS,
--              :MASTER_CONTAINER_NO,
--              :ACTUAL_FREIGHT_CHARGE,
--              :SCAC,
--              :SHIP_DATE,
--              :SHIP_MODE,
--              :ZONE,
--              :OVERSIZED_FLAG,
--              :DIMMED_FLAG,
--              :CARRIER_BILL_ACCOUNT,
--              :CARRIER_PAYMENT_TYPE,
--              :ASTRA_CODE,
--              :ROUTING_CODE,
--              :SERVICE_TYPE,
--              :CARRIER_LOCATION_ID,
--              :CARRIER_SERVICE_CODE,
--              :APPLIED_WEIGHT,
--              :ACTUAL_WEIGHT,
--              :ACTUAL_WEIGHT_UOM,
--              :COMMITMENT_CODE,
--              :DELIVERY_DAY,
--              :DELIVER_BY,
--              :FORM_ID,
--              :BASIC_FREIGHT_CHARGE,
--              :SPECIAL_SERVICES_SURCHARGE,
--              :DELIVERY_CODE,
--              :BARCODE_DISCOUNT,
--              :DISCOUNT_AMOUNT,
--              :CUSTOMS_VALUE,
--              :CARRIAGE_VALUE,
--              :DECLARED_VALUE,
--              :EXPORT_LICENSE_NO,
--              :EXPORT_LICENSE_EXP_DATE,
--              :FREIGHT_TERMS,
--              :CUSTCARRIER_ACCOUNT_NO,
--              :CONTAINER_NO,
--              :PARENT_CONTAINER_KEY,
--              :PARENT_CONTAINER_NO,
--              :CONTAINER_GROUP,
--              :PARENT_CONTAINER_GROUP,
--              :IS_RECEIVED,
--              :IS_PACK_PROCESS_COMPLETE,
--              :STATUS_DATE,
--              :USED_DURING_PICK,
--              :SYSTEM_SUGGESTED,
--              :WAVE_KEY,
--              :CONTAINS_STD_QTY,
--              :TASK_TYPE,
--              :SERVICE_ITEM_ID,
--              :IS_HAZMAT,
--              :LOCKID,
--              :CREATETS,
--              :MODIFYTS,
--              :CREATEUSERID,
--              :MODIFYUSERID,
--              :CREATEPROGID,
--              :MODIFYPROGID,
--              :REQUIRED_NO_OF_RETURN_LABELS,
--              :ACTUAL_NO_OF_RETURN_LABELS,
--              :EXTN_SORT_TYPE,
--              :EXTN_SORT_VALUE,
--              :EXTERNAL_REFERENCE_1,
--              :IS_MANIFESTED,
--              sysdate,
--              sysdate)

-- &


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Merge into Stage */

MERGE INTO ods_stage.oms3_shipment_container_stg t
     USING (SELECT SHIPMENT_CONTAINER_KEY,
                   MANIFEST_KEY,
                   SHIPMENT_KEY,
                   LOAD_KEY,
                   PIPELINE_KEY,
                   STATUS,
                   DOCUMENT_TYPE,
                   ORDER_HEADER_KEY,
                   ORDER_RELEASE_KEY,
                   SHIP_TO_KEY,
                   CONTAINER_SEQ_NO,
                   TRACKING_NO,
                   COD_RETURN_TRACKING_NO,
                   COD_AMOUNT,
                   UCC128CODE,
                   MANIFEST_NO,
                   CONTAINER_SCM,
                   CONTAINER_EPC,
                   CONTAINER_TYPE,
                   CORRUGATION_ITEM_KEY,
                   CONTAINER_LENGTH,
                   CONTAINER_WIDTH,
                   CONTAINER_HEIGHT,
                   CONTAINER_GROSS_WEIGHT,
                   CONTAINER_NET_WEIGHT,
                   CONTAINER_LENGTH_UOM,
                   CONTAINER_HEIGHT_UOM,
                   CONTAINER_WIDTH_UOM,
                   CONTAINER_GROSS_WEIGHT_UOM,
                   CONTAINER_NET_WEIGHT_UOM,
                   APPLIED_WEIGHT_UOM,
                   HAS_OTHER_CONTAINERS,
                   MASTER_CONTAINER_NO,
                   ACTUAL_FREIGHT_CHARGE,
                   SCAC,
                   SHIP_DATE,
                   SHIP_MODE,
                   ZONE,
                   OVERSIZED_FLAG,
                   DIMMED_FLAG,
                   CARRIER_BILL_ACCOUNT,
                   CARRIER_PAYMENT_TYPE,
                   ASTRA_CODE,
                   ROUTING_CODE,
                   SERVICE_TYPE,
                   CARRIER_LOCATION_ID,
                   CARRIER_SERVICE_CODE,
                   APPLIED_WEIGHT,
                   ACTUAL_WEIGHT,
                   ACTUAL_WEIGHT_UOM,
                   COMMITMENT_CODE,
                   DELIVERY_DAY,
                   DELIVER_BY,
                   FORM_ID,
                   BASIC_FREIGHT_CHARGE,
                   SPECIAL_SERVICES_SURCHARGE,
                   DELIVERY_CODE,
                   BARCODE_DISCOUNT,
                   DISCOUNT_AMOUNT,
                   CUSTOMS_VALUE,
                   CARRIAGE_VALUE,
                   DECLARED_VALUE,
                   EXPORT_LICENSE_NO,
                   EXPORT_LICENSE_EXP_DATE,
                   FREIGHT_TERMS,
                   CUSTCARRIER_ACCOUNT_NO,
                   CONTAINER_NO,
                   PARENT_CONTAINER_KEY,
                   PARENT_CONTAINER_NO,
                   CONTAINER_GROUP,
                   PARENT_CONTAINER_GROUP,
                   IS_RECEIVED,
                   IS_PACK_PROCESS_COMPLETE,
                   STATUS_DATE,
                   USED_DURING_PICK,
                   SYSTEM_SUGGESTED,
                   WAVE_KEY,
                   CONTAINS_STD_QTY,
                   TASK_TYPE,
                   SERVICE_ITEM_ID,
                   IS_HAZMAT,
                   LOCKID,
                   CREATETS,
                   MODIFYTS,
                   CREATEUSERID,
                   MODIFYUSERID,
                   CREATEPROGID,
                   MODIFYPROGID,
                   REQUIRED_NO_OF_RETURN_LABELS,
                   ACTUAL_NO_OF_RETURN_LABELS,
                   EXTN_SORT_TYPE,
                   EXTN_SORT_VALUE,
                   EXTERNAL_REFERENCE_1,
                   IS_MANIFESTED
              FROM rax_app_user.oms3_shipment_container_tmp) s
        ON (s.shipment_container_key = t.shipment_container_key)
WHEN MATCHED
THEN
    UPDATE SET    
t.MANIFEST_KEY  =              s.MANIFEST_KEY,
t.SHIPMENT_KEY  =              s.SHIPMENT_KEY, 
t.LOAD_KEY      =              s.LOAD_KEY ,
t.PIPELINE_KEY  =              s.PIPELINE_KEY, 
t.STATUS        =              s.STATUS ,
t.DOCUMENT_TYPE =              s.DOCUMENT_TYPE, 
t.ORDER_HEADER_KEY    =        s.ORDER_HEADER_KEY ,
t.ORDER_RELEASE_KEY   =        s.ORDER_RELEASE_KEY ,
t.SHIP_TO_KEY         =        s.SHIP_TO_KEY ,
t.CONTAINER_SEQ_NO    =        s.CONTAINER_SEQ_NO, 
t.TRACKING_NO         =        s.TRACKING_NO ,
t.COD_RETURN_TRACKING_NO  =    s.COD_RETURN_TRACKING_NO, 
t.COD_AMOUNT              =    s.COD_AMOUNT ,
t.UCC128CODE              =    s.UCC128CODE ,
t.MANIFEST_NO             =    s.MANIFEST_NO ,
t.CONTAINER_SCM           =    s.CONTAINER_SCM, 
t.CONTAINER_EPC           =    s.CONTAINER_EPC,
t.CONTAINER_TYPE          =    s.CONTAINER_TYPE,
t.CORRUGATION_ITEM_KEY    =    s.CORRUGATION_ITEM_KEY,
t.CONTAINER_LENGTH        =    s.CONTAINER_LENGTH,
t.CONTAINER_WIDTH         =    s.CONTAINER_WIDTH,
t.CONTAINER_HEIGHT        =    s.CONTAINER_HEIGHT,
t.CONTAINER_GROSS_WEIGHT  =    s.CONTAINER_GROSS_WEIGHT,
t.CONTAINER_NET_WEIGHT    =    s.CONTAINER_NET_WEIGHT,
t.CONTAINER_LENGTH_UOM    =    s.CONTAINER_LENGTH_UOM,
t.CONTAINER_HEIGHT_UOM    =    s.CONTAINER_HEIGHT_UOM,
t.CONTAINER_WIDTH_UOM     =    s.CONTAINER_WIDTH_UOM,
t.CONTAINER_GROSS_WEIGHT_UOM  = s.CONTAINER_GROSS_WEIGHT_UOM,
t.CONTAINER_NET_WEIGHT_UOM    = s.CONTAINER_NET_WEIGHT_UOM,
t.APPLIED_WEIGHT_UOM          = s.APPLIED_WEIGHT_UOM,
t.HAS_OTHER_CONTAINERS        = s.HAS_OTHER_CONTAINERS,
t.MASTER_CONTAINER_NO         = s.MASTER_CONTAINER_NO,
t.ACTUAL_FREIGHT_CHARGE       = s.ACTUAL_FREIGHT_CHARGE,
t.SCAC                        = s.SCAC,
t.SHIP_DATE                   = s.SHIP_DATE,
t.SHIP_MODE                   = s.SHIP_MODE,
t.ZONE                        = s.ZONE,
t.OVERSIZED_FLAG              = s.OVERSIZED_FLAG,
t.DIMMED_FLAG                 = s.DIMMED_FLAG,
t.CARRIER_BILL_ACCOUNT        = s.CARRIER_BILL_ACCOUNT,
t.CARRIER_PAYMENT_TYPE        = s.CARRIER_PAYMENT_TYPE,
t.ASTRA_CODE                  = s.ASTRA_CODE,
t.ROUTING_CODE                = s.ROUTING_CODE,
t.SERVICE_TYPE                = s.SERVICE_TYPE,
t.CARRIER_LOCATION_ID         = s.CARRIER_LOCATION_ID,
t.CARRIER_SERVICE_CODE        = s.CARRIER_SERVICE_CODE,
t.APPLIED_WEIGHT              = s.APPLIED_WEIGHT,
t.ACTUAL_WEIGHT               = s.ACTUAL_WEIGHT,
t.ACTUAL_WEIGHT_UOM           = s.ACTUAL_WEIGHT_UOM,
t.COMMITMENT_CODE             = s.COMMITMENT_CODE,
t.DELIVERY_DAY                = s.DELIVERY_DAY,
t.DELIVER_BY                  = s.DELIVER_BY,
t.FORM_ID                     = s.FORM_ID,
t.BASIC_FREIGHT_CHARGE        = s.BASIC_FREIGHT_CHARGE,
t.SPECIAL_SERVICES_SURCHARGE  = s.SPECIAL_SERVICES_SURCHARGE,
t.DELIVERY_CODE               = s.DELIVERY_CODE,
t.BARCODE_DISCOUNT            = s.BARCODE_DISCOUNT,
t.DISCOUNT_AMOUNT             = s.DISCOUNT_AMOUNT,
t.CUSTOMS_VALUE               = s.CUSTOMS_VALUE,
t.CARRIAGE_VALUE              = s.CARRIAGE_VALUE,
t.DECLARED_VALUE              = s.DECLARED_VALUE,
t.EXPORT_LICENSE_NO           = s.EXPORT_LICENSE_NO,
t.EXPORT_LICENSE_EXP_DATE     = s.EXPORT_LICENSE_EXP_DATE,
t.FREIGHT_TERMS               = s.FREIGHT_TERMS,
t.CUSTCARRIER_ACCOUNT_NO      = s.CUSTCARRIER_ACCOUNT_NO,
t.CONTAINER_NO                = s.CONTAINER_NO,
t.PARENT_CONTAINER_KEY        = s.PARENT_CONTAINER_KEY,
t.PARENT_CONTAINER_NO         = s.PARENT_CONTAINER_NO,
t.CONTAINER_GROUP             = s.CONTAINER_GROUP,
t.PARENT_CONTAINER_GROUP      = s.PARENT_CONTAINER_GROUP,
t.IS_RECEIVED                 = s.IS_RECEIVED,
t.IS_PACK_PROCESS_COMPLETE    = s.IS_PACK_PROCESS_COMPLETE,
t.STATUS_DATE                 = s.STATUS_DATE,
t.USED_DURING_PICK            = s.USED_DURING_PICK,
t.SYSTEM_SUGGESTED            = s.SYSTEM_SUGGESTED,
t.WAVE_KEY                    = s.WAVE_KEY,
t.CONTAINS_STD_QTY            = s.CONTAINS_STD_QTY,
t.TASK_TYPE                   = s.TASK_TYPE,
t.SERVICE_ITEM_ID             = s.SERVICE_ITEM_ID,
t.IS_HAZMAT                   = s.IS_HAZMAT,
t.LOCKID                      = s.LOCKID,
t.CREATETS                    = s.CREATETS,
t.MODIFYTS                    = s.MODIFYTS,
t.CREATEUSERID                = s.CREATEUSERID,
t.MODIFYUSERID                = s.MODIFYUSERID,
t.CREATEPROGID                = s.CREATEPROGID,
t.MODIFYPROGID                = s.MODIFYPROGID,
t.REQUIRED_NO_OF_RETURN_LABELS = s.REQUIRED_NO_OF_RETURN_LABELS,
t.ACTUAL_NO_OF_RETURN_LABELS   = s.ACTUAL_NO_OF_RETURN_LABELS,
t.EXTN_SORT_TYPE               = s.EXTN_SORT_TYPE,
t.EXTN_SORT_VALUE              = s.EXTN_SORT_VALUE,
t.EXTERNAL_REFERENCE_1         = s.EXTERNAL_REFERENCE_1,
t.IS_MANIFESTED                = s.IS_MANIFESTED,
t.ods_modify_date = sysdate
             WHERE    decode(t.MANIFEST_KEY,             s.MANIFEST_KEY, 1, 0) = 0
   
OR decode(t.SHIPMENT_KEY  ,              s.SHIPMENT_KEY,  1, 0) = 0
OR decode(t.LOAD_KEY      ,             s.LOAD_KEY ,  1, 0) = 0
OR decode(t.PIPELINE_KEY  ,              s.PIPELINE_KEY,   1, 0) = 0
OR decode(t.STATUS        ,              s.STATUS ,  1, 0) = 0
OR decode(t.DOCUMENT_TYPE ,              s.DOCUMENT_TYPE,   1, 0) = 0
OR decode(t.ORDER_HEADER_KEY    ,        s.ORDER_HEADER_KEY ,  1, 0) = 0
OR decode(t.ORDER_RELEASE_KEY   ,        s.ORDER_RELEASE_KEY ,  1, 0) = 0
OR decode(t.SHIP_TO_KEY         ,        s.SHIP_TO_KEY ,  1, 0) = 0
OR decode(t.CONTAINER_SEQ_NO    ,        s.CONTAINER_SEQ_NO,   1, 0) = 0
OR decode(t.TRACKING_NO         ,        s.TRACKING_NO ,  1, 0) = 0
OR decode(t.COD_RETURN_TRACKING_NO  ,    s.COD_RETURN_TRACKING_NO,   1, 0) = 0
OR decode(t.COD_AMOUNT              ,    s.COD_AMOUNT ,  1, 0) = 0
OR decode(t.UCC128CODE              ,    s.UCC128CODE ,  1, 0) = 0
OR decode(t.MANIFEST_NO             ,    s.MANIFEST_NO ,  1, 0) = 0
OR decode(t.CONTAINER_SCM           ,    s.CONTAINER_SCM,   1, 0) = 0
OR decode(t.CONTAINER_EPC           ,    s.CONTAINER_EPC,  1, 0) = 0
OR decode(t.CONTAINER_TYPE          ,    s.CONTAINER_TYPE,  1, 0) = 0
OR decode(t.CORRUGATION_ITEM_KEY    ,    s.CORRUGATION_ITEM_KEY,  1, 0) = 0
OR decode(t.CONTAINER_LENGTH        ,    s.CONTAINER_LENGTH,  1, 0) = 0
OR decode(t.CONTAINER_WIDTH         ,    s.CONTAINER_WIDTH,  1, 0) = 0
OR decode(t.CONTAINER_HEIGHT        ,    s.CONTAINER_HEIGHT,  1, 0) = 0
OR decode(t.CONTAINER_GROSS_WEIGHT  ,    s.CONTAINER_GROSS_WEIGHT,  1, 0) = 0
OR decode(t.CONTAINER_NET_WEIGHT    ,    s.CONTAINER_NET_WEIGHT,  1, 0) = 0
OR decode(t.CONTAINER_LENGTH_UOM    ,    s.CONTAINER_LENGTH_UOM,  1, 0) = 0
OR decode(t.CONTAINER_HEIGHT_UOM    ,    s.CONTAINER_HEIGHT_UOM,  1, 0) = 0
OR decode(t.CONTAINER_WIDTH_UOM     ,    s.CONTAINER_WIDTH_UOM,  1, 0) = 0
OR decode(t.CONTAINER_GROSS_WEIGHT_UOM  , s.CONTAINER_GROSS_WEIGHT_UOM,  1, 0) = 0
OR decode(t.CONTAINER_NET_WEIGHT_UOM    , s.CONTAINER_NET_WEIGHT_UOM,  1, 0) = 0
OR decode(t.APPLIED_WEIGHT_UOM          , s.APPLIED_WEIGHT_UOM,  1, 0) = 0
OR decode(t.HAS_OTHER_CONTAINERS        , s.HAS_OTHER_CONTAINERS,  1, 0) = 0
OR decode(t.MASTER_CONTAINER_NO         , s.MASTER_CONTAINER_NO,  1, 0) = 0
OR decode(t.ACTUAL_FREIGHT_CHARGE       , s.ACTUAL_FREIGHT_CHARGE,  1, 0) = 0
OR decode(t.SCAC                        , s.SCAC,  1, 0) = 0
OR decode(t.SHIP_DATE                   , s.SHIP_DATE,  1, 0) = 0
OR decode(t.SHIP_MODE                   , s.SHIP_MODE,  1, 0) = 0
OR decode(t.ZONE                        , s.ZONE,  1, 0) = 0
OR decode(t.OVERSIZED_FLAG              , s.OVERSIZED_FLAG,  1, 0) = 0
OR decode(t.DIMMED_FLAG                 , s.DIMMED_FLAG,  1, 0) = 0
OR decode(t.CARRIER_BILL_ACCOUNT        , s.CARRIER_BILL_ACCOUNT,  1, 0) = 0
OR decode(t.CARRIER_PAYMENT_TYPE        , s.CARRIER_PAYMENT_TYPE,  1, 0) = 0
OR decode(t.ASTRA_CODE                  , s.ASTRA_CODE,  1, 0) = 0
OR decode(t.ROUTING_CODE                , s.ROUTING_CODE,  1, 0) = 0
OR decode(t.SERVICE_TYPE                , s.SERVICE_TYPE,  1, 0) = 0
OR decode(t.CARRIER_LOCATION_ID         , s.CARRIER_LOCATION_ID,  1, 0) = 0
OR decode(t.CARRIER_SERVICE_CODE        , s.CARRIER_SERVICE_CODE,  1, 0) = 0
OR decode(t.APPLIED_WEIGHT              , s.APPLIED_WEIGHT,  1, 0) = 0
OR decode(t.ACTUAL_WEIGHT               , s.ACTUAL_WEIGHT,  1, 0) = 0
OR decode(t.ACTUAL_WEIGHT_UOM           , s.ACTUAL_WEIGHT_UOM,  1, 0) = 0
OR decode(t.COMMITMENT_CODE             , s.COMMITMENT_CODE,  1, 0) = 0
OR decode(t.DELIVERY_DAY                , s.DELIVERY_DAY,  1, 0) = 0
OR decode(t.DELIVER_BY                  , s.DELIVER_BY,  1, 0) = 0
OR decode(t.FORM_ID                     , s.FORM_ID,  1, 0) = 0
OR decode(t.BASIC_FREIGHT_CHARGE        , s.BASIC_FREIGHT_CHARGE,  1, 0) = 0
OR decode(t.SPECIAL_SERVICES_SURCHARGE  , s.SPECIAL_SERVICES_SURCHARGE,  1, 0) = 0
OR decode(t.DELIVERY_CODE               , s.DELIVERY_CODE,  1, 0) = 0
OR decode(t.BARCODE_DISCOUNT            , s.BARCODE_DISCOUNT,  1, 0) = 0
OR decode(t.DISCOUNT_AMOUNT             , s.DISCOUNT_AMOUNT,  1, 0) = 0
OR decode(t.CUSTOMS_VALUE               , s.CUSTOMS_VALUE,  1, 0) = 0
OR decode(t.CARRIAGE_VALUE              , s.CARRIAGE_VALUE,  1, 0) = 0
OR decode(t.DECLARED_VALUE              , s.DECLARED_VALUE,  1, 0) = 0
OR decode(t.EXPORT_LICENSE_NO           , s.EXPORT_LICENSE_NO,  1, 0) = 0
OR decode(t.EXPORT_LICENSE_EXP_DATE     , s.EXPORT_LICENSE_EXP_DATE,  1, 0) = 0
OR decode(t.FREIGHT_TERMS               , s.FREIGHT_TERMS,  1, 0) = 0
OR decode(t.CUSTCARRIER_ACCOUNT_NO      , s.CUSTCARRIER_ACCOUNT_NO,  1, 0) = 0
OR decode(t.CONTAINER_NO                , s.CONTAINER_NO,  1, 0) = 0
OR decode(t.PARENT_CONTAINER_KEY        , s.PARENT_CONTAINER_KEY,  1, 0) = 0
OR decode(t.PARENT_CONTAINER_NO         , s.PARENT_CONTAINER_NO,  1, 0) = 0
OR decode(t.CONTAINER_GROUP             , s.CONTAINER_GROUP,  1, 0) = 0
OR decode(t.PARENT_CONTAINER_GROUP      , s.PARENT_CONTAINER_GROUP,  1, 0) = 0
OR decode(t.IS_RECEIVED                 , s.IS_RECEIVED,  1, 0) = 0
OR decode(t.IS_PACK_PROCESS_COMPLETE    , s.IS_PACK_PROCESS_COMPLETE,  1, 0) = 0
OR decode(t.STATUS_DATE                 , s.STATUS_DATE,  1, 0) = 0
OR decode(t.USED_DURING_PICK            , s.USED_DURING_PICK,  1, 0) = 0
OR decode(t.SYSTEM_SUGGESTED            , s.SYSTEM_SUGGESTED,  1, 0) = 0
OR decode(t.WAVE_KEY                    , s.WAVE_KEY,  1, 0) = 0
OR decode(t.CONTAINS_STD_QTY            , s.CONTAINS_STD_QTY,  1, 0) = 0
OR decode(t.TASK_TYPE                   , s.TASK_TYPE,  1, 0) = 0
OR decode(t.SERVICE_ITEM_ID             , s.SERVICE_ITEM_ID,  1, 0) = 0
OR decode(t.IS_HAZMAT                   , s.IS_HAZMAT,  1, 0) = 0
OR decode(t.LOCKID                      , s.LOCKID,  1, 0) = 0
OR decode(t.CREATETS                    , s.CREATETS,  1, 0) = 0
OR decode(t.MODIFYTS                    , s.MODIFYTS,  1, 0) = 0
OR decode(t.CREATEUSERID                , s.CREATEUSERID,  1, 0) = 0
OR decode(t.MODIFYUSERID                , s.MODIFYUSERID,  1, 0) = 0
OR decode(t.CREATEPROGID                , s.CREATEPROGID,  1, 0) = 0  
OR decode(t.MODIFYPROGID                , s.MODIFYPROGID,  1, 0) = 0
OR decode(t.REQUIRED_NO_OF_RETURN_LABELS , s.REQUIRED_NO_OF_RETURN_LABELS,  1, 0) = 0
OR decode(t.ACTUAL_NO_OF_RETURN_LABELS   , s.ACTUAL_NO_OF_RETURN_LABELS,  1, 0) = 0
OR decode(t.EXTN_SORT_TYPE               , s.EXTN_SORT_TYPE,  1, 0) = 0
OR decode(t.EXTN_SORT_VALUE              , s.EXTN_SORT_VALUE,  1, 0) = 0
OR decode(t.EXTERNAL_REFERENCE_1         , s.EXTERNAL_REFERENCE_1,  1, 0) = 0
OR decode(t.IS_MANIFESTED                , s.IS_MANIFESTED,  1, 0) = 0
WHEN NOT MATCHED
THEN
    INSERT     (SHIPMENT_CONTAINER_KEY,
                   MANIFEST_KEY,
                   SHIPMENT_KEY,
                   LOAD_KEY,
                   PIPELINE_KEY,
                   STATUS,
                   DOCUMENT_TYPE,
                   ORDER_HEADER_KEY,
                   ORDER_RELEASE_KEY,
                   SHIP_TO_KEY,
                   CONTAINER_SEQ_NO,
                   TRACKING_NO,
                   COD_RETURN_TRACKING_NO,
                   COD_AMOUNT,
                   UCC128CODE,
                   MANIFEST_NO,
                   CONTAINER_SCM,
                   CONTAINER_EPC,
                   CONTAINER_TYPE,
                   CORRUGATION_ITEM_KEY,
                   CONTAINER_LENGTH,
                   CONTAINER_WIDTH,
                   CONTAINER_HEIGHT,
                   CONTAINER_GROSS_WEIGHT,
                   CONTAINER_NET_WEIGHT,
                   CONTAINER_LENGTH_UOM,
                   CONTAINER_HEIGHT_UOM,
                   CONTAINER_WIDTH_UOM,
                   CONTAINER_GROSS_WEIGHT_UOM,
                   CONTAINER_NET_WEIGHT_UOM,
                   APPLIED_WEIGHT_UOM,
                   HAS_OTHER_CONTAINERS,
                   MASTER_CONTAINER_NO,
                   ACTUAL_FREIGHT_CHARGE,
                   SCAC,
                   SHIP_DATE,
                   SHIP_MODE,
                   ZONE,
                   OVERSIZED_FLAG,
                   DIMMED_FLAG,
                   CARRIER_BILL_ACCOUNT,
                   CARRIER_PAYMENT_TYPE,
                   ASTRA_CODE,
                   ROUTING_CODE,
                   SERVICE_TYPE,
                   CARRIER_LOCATION_ID,
                   CARRIER_SERVICE_CODE,
                   APPLIED_WEIGHT,
                   ACTUAL_WEIGHT,
                   ACTUAL_WEIGHT_UOM,
                   COMMITMENT_CODE,
                   DELIVERY_DAY,
                   DELIVER_BY,
                   FORM_ID,
                   BASIC_FREIGHT_CHARGE,
                   SPECIAL_SERVICES_SURCHARGE,
                   DELIVERY_CODE,
                   BARCODE_DISCOUNT,
                   DISCOUNT_AMOUNT,
                   CUSTOMS_VALUE,
                   CARRIAGE_VALUE,
                   DECLARED_VALUE,
                   EXPORT_LICENSE_NO,
                   EXPORT_LICENSE_EXP_DATE,
                   FREIGHT_TERMS,
                   CUSTCARRIER_ACCOUNT_NO,
                   CONTAINER_NO,
                   PARENT_CONTAINER_KEY,
                   PARENT_CONTAINER_NO,
                   CONTAINER_GROUP,
                   PARENT_CONTAINER_GROUP,
                   IS_RECEIVED,
                   IS_PACK_PROCESS_COMPLETE,
                   STATUS_DATE,
                   USED_DURING_PICK,
                   SYSTEM_SUGGESTED,
                   WAVE_KEY,
                   CONTAINS_STD_QTY,
                   TASK_TYPE,
                   SERVICE_ITEM_ID,
                   IS_HAZMAT,
                   LOCKID,
                   CREATETS,
                   MODIFYTS,
                   CREATEUSERID,
                   MODIFYUSERID,
                   CREATEPROGID,
                   MODIFYPROGID,
                   REQUIRED_NO_OF_RETURN_LABELS,
                   ACTUAL_NO_OF_RETURN_LABELS,
                   EXTN_SORT_TYPE,
                   EXTN_SORT_VALUE,
                   EXTERNAL_REFERENCE_1,
                   IS_MANIFESTED,
                   ods_create_date,
                   ods_modify_date)
        VALUES (s.SHIPMENT_CONTAINER_KEY,
                   s.MANIFEST_KEY,
                   s.SHIPMENT_KEY,
                   s.LOAD_KEY,
                   s.PIPELINE_KEY,
                   s.STATUS,
                   s.DOCUMENT_TYPE,
                   s.ORDER_HEADER_KEY,
                   s.ORDER_RELEASE_KEY,
                   s.SHIP_TO_KEY,
                   s.CONTAINER_SEQ_NO,
                   s.TRACKING_NO,
                   s.COD_RETURN_TRACKING_NO,
                   s.COD_AMOUNT,
                   s.UCC128CODE,
                   s.MANIFEST_NO,
                   s.CONTAINER_SCM,
                   s.CONTAINER_EPC,
                   s.CONTAINER_TYPE,
                   s.CORRUGATION_ITEM_KEY,
                   s.CONTAINER_LENGTH,
                   s.CONTAINER_WIDTH,
                   s.CONTAINER_HEIGHT,
                   s.CONTAINER_GROSS_WEIGHT,
                   s.CONTAINER_NET_WEIGHT,
                   s.CONTAINER_LENGTH_UOM,
                   s.CONTAINER_HEIGHT_UOM,
                   s.CONTAINER_WIDTH_UOM,
                   s.CONTAINER_GROSS_WEIGHT_UOM,
                   s.CONTAINER_NET_WEIGHT_UOM,
                   s.APPLIED_WEIGHT_UOM,
                   s.HAS_OTHER_CONTAINERS,
                   s.MASTER_CONTAINER_NO,
                   s.ACTUAL_FREIGHT_CHARGE,
                   s.SCAC,
                   s.SHIP_DATE,
                   s.SHIP_MODE,
                   s.ZONE,
                   s.OVERSIZED_FLAG,
                   s.DIMMED_FLAG,
                   s.CARRIER_BILL_ACCOUNT,
                   s.CARRIER_PAYMENT_TYPE,
                   s.ASTRA_CODE,
                   s.ROUTING_CODE,
                   s.SERVICE_TYPE,
                   s.CARRIER_LOCATION_ID,
                   s.CARRIER_SERVICE_CODE,
                   s.APPLIED_WEIGHT,
                   s.ACTUAL_WEIGHT,
                   s.ACTUAL_WEIGHT_UOM,
                   s.COMMITMENT_CODE,
                   s.DELIVERY_DAY,
                   s.DELIVER_BY,
                   s.FORM_ID,
                   s.BASIC_FREIGHT_CHARGE,
                   s.SPECIAL_SERVICES_SURCHARGE,
                   s.DELIVERY_CODE,
                   s.BARCODE_DISCOUNT,
                   s.DISCOUNT_AMOUNT,
                   s.CUSTOMS_VALUE,
                   s.CARRIAGE_VALUE,
                   s.DECLARED_VALUE,
                   s.EXPORT_LICENSE_NO,
                   s.EXPORT_LICENSE_EXP_DATE,
                   s.FREIGHT_TERMS,
                   s.CUSTCARRIER_ACCOUNT_NO,
                   s.CONTAINER_NO,
                   s.PARENT_CONTAINER_KEY,
                   s.PARENT_CONTAINER_NO,
                   s.CONTAINER_GROUP,
                   s.PARENT_CONTAINER_GROUP,
                   s.IS_RECEIVED,
                   s.IS_PACK_PROCESS_COMPLETE,
                   s.STATUS_DATE,
                   s.USED_DURING_PICK,
                   s.SYSTEM_SUGGESTED,
                   s.WAVE_KEY,
                   s.CONTAINS_STD_QTY,
                   s.TASK_TYPE,
                   s.SERVICE_ITEM_ID,
                   s.IS_HAZMAT,
                   s.LOCKID,
                   s.CREATETS,
                   s.MODIFYTS,
                   s.CREATEUSERID,
                   s.MODIFYUSERID,
                   s.CREATEPROGID,
                   s.MODIFYPROGID,
                   s.REQUIRED_NO_OF_RETURN_LABELS,
                   s.ACTUAL_NO_OF_RETURN_LABELS,
                   s.EXTN_SORT_TYPE,
                   s.EXTN_SORT_VALUE,
                   s.EXTERNAL_REFERENCE_1,
                   s.IS_MANIFESTED,
                SYSDATE,
                SYSDATE)

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Merge into XR */

MERGE INTO ODS_STAGE.OMS3_SHIPMENT_CONTAINER_XR d
     USING (SELECT stg.SHIPMENT_CONTAINER_KEY,
                   stg.SHIPMENT_KEY,
                   ss.SOURCE_SYSTEM_OID
              FROM ODS_STAGE.OMS3_SHIPMENT_CONTAINER_STG  stg,
                   ods_own.source_system                  ss
             WHERE     1 = 1
                   AND ss.SOURCE_SYSTEM_SHORT_NAME = 'OMS'
                   AND stg.ODS_MODIFY_DATE  >= TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap) s
        ON (d.shipment_container_key = s.shipment_container_key)
WHEN MATCHED
THEN
    UPDATE SET d.shipment_key = s.shipment_key, d.ods_modify_date = SYSDATE
             WHERE DECODE (d.shipment_key, s.shipment_key, 1, 0) = 0
WHEN NOT MATCHED
THEN
    INSERT     (shipment_container_key,
                shipment_container_oid,
                shipment_key,
                ods_create_date,
                ods_modify_date)
        VALUES (s.shipment_container_key,
                ODS_STAGE.shipment_container_SEQ.nextval,
                s.shipment_key,
                SYSDATE,
                SYSDATE)

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Merge into Shipment_Container */


MERGE INTO ods_own.shipment_container t
     USING (SELECT xr.SHIPMENT_CONTAINER_OID,
                   sxr.SHIPMENT_OID,
                   ss.SOURCE_SYSTEM_OID,
                   stg.MANIFEST_KEY,
                   stg.SHIPMENT_KEY,
                   stg.LOAD_KEY,
                   stg.PIPELINE_KEY,
                   stg.STATUS,
                   stg.DOCUMENT_TYPE,
                   stg.ORDER_HEADER_KEY,
                   stg.ORDER_RELEASE_KEY,
                   stg.SHIP_TO_KEY,
                   stg.CONTAINER_SEQ_NO,
                   stg.TRACKING_NO,
                   stg.COD_RETURN_TRACKING_NO,
                   stg.COD_AMOUNT,
                   stg.UCC128CODE,
                   stg.MANIFEST_NO,
                   stg.CONTAINER_SCM,
                   stg.CONTAINER_EPC,
                   stg.CONTAINER_TYPE,
                   stg.CORRUGATION_ITEM_KEY,
                   stg.CONTAINER_LENGTH,
                   stg.CONTAINER_WIDTH,
                   stg.CONTAINER_HEIGHT,
                   stg.CONTAINER_GROSS_WEIGHT,
                   stg.CONTAINER_NET_WEIGHT,
                   stg.CONTAINER_LENGTH_UOM,
                   stg.CONTAINER_HEIGHT_UOM,
                   stg.CONTAINER_WIDTH_UOM,
                   stg.CONTAINER_GROSS_WEIGHT_UOM,
                   stg.CONTAINER_NET_WEIGHT_UOM,
                   stg.APPLIED_WEIGHT_UOM,
                   stg.HAS_OTHER_CONTAINERS,
                   stg.MASTER_CONTAINER_NO,
                   stg.ACTUAL_FREIGHT_CHARGE,
                   stg.SCAC,
                   stg.SHIP_DATE,
                   stg.SHIP_MODE,
                   stg.ZONE,
                   stg.OVERSIZED_FLAG,
                   stg.DIMMED_FLAG,
                   stg.CARRIER_BILL_ACCOUNT,
                   stg.CARRIER_PAYMENT_TYPE,
                   stg.ASTRA_CODE,
                   stg.ROUTING_CODE,
                   stg.SERVICE_TYPE,
                   stg.CARRIER_LOCATION_ID,
                   stg.CARRIER_SERVICE_CODE,
                   stg.APPLIED_WEIGHT,
                   stg.ACTUAL_WEIGHT,
                   stg.ACTUAL_WEIGHT_UOM,
                   stg.COMMITMENT_CODE,
                   stg.DELIVERY_DAY,
                   stg.DELIVER_BY,
                   stg.FORM_ID,
                   stg.BASIC_FREIGHT_CHARGE,
                   stg.SPECIAL_SERVICES_SURCHARGE,
                   stg.DELIVERY_CODE,
                   stg.BARCODE_DISCOUNT,
                   stg.DISCOUNT_AMOUNT,
                   stg.CUSTOMS_VALUE,
                   stg.CARRIAGE_VALUE,
                   stg.DECLARED_VALUE,
                   stg.EXPORT_LICENSE_NO,
                   stg.EXPORT_LICENSE_EXP_DATE,
                   stg.FREIGHT_TERMS,
                   stg.CUSTCARRIER_ACCOUNT_NO,
                   stg.CONTAINER_NO,
                   stg.PARENT_CONTAINER_KEY,
                   stg.PARENT_CONTAINER_NO,
                   stg.CONTAINER_GROUP,
                   stg.PARENT_CONTAINER_GROUP,
                   stg.IS_RECEIVED,
                   stg.IS_PACK_PROCESS_COMPLETE,
                   stg.STATUS_DATE,
                   stg.USED_DURING_PICK,
                   stg.SYSTEM_SUGGESTED,
                   stg.WAVE_KEY,
                   stg.CONTAINS_STD_QTY,
                   stg.TASK_TYPE,
                   stg.SERVICE_ITEM_ID,
                   stg.IS_HAZMAT,
                   stg.LOCKID,
                   stg.CREATETS,
                   stg.MODIFYTS,
                   stg.CREATEUSERID,
                   stg.MODIFYUSERID,
                   stg.CREATEPROGID,
                   MODIFYPROGID,
                   REQUIRED_NO_OF_RETURN_LABELS,
                   ACTUAL_NO_OF_RETURN_LABELS,
                   EXTN_SORT_TYPE,
                   EXTN_SORT_VALUE,
                   EXTERNAL_REFERENCE_1,
                   IS_MANIFESTED
              FROM ODS_STAGE.OMS3_SHIPMENT_CONTAINER_STG  stg,
                   ODS_STAGE.OMS3_SHIPMENT_CONTAINER_XR   xr,
                   ODS_STAGE.OMS_SHIPMENT_XR              sxr,
                   ODS_OWN.SOURCE_SYSTEM                  ss
             WHERE     TRIM (stg.SHIPMENT_CONTAINER_KEY) =
                       TRIM (xr.SHIPMENT_CONTAINER_KEY)
                   AND xr.SHIPMENT_KEY = sxr.SHIPMENT_KEY(+)
                   AND ss.SOURCE_SYSTEM_SHORT_NAME = 'OMS' 
                   AND stg.ODS_MODIFY_DATE >=  TO_DATE(SUBSTR(:v_cdc_load_date, 1, 19), 'YYYY-MM-DD HH24:MI:SS') - :v_cdc_oms_overlap
              ) s
        ON (t.shipment_container_oid = s.shipment_container_oid)
WHEN MATCHED
THEN
    UPDATE SET
        t.shipment_oid = s.shipment_oid,
        t.MANIFEST_KEY = s.MANIFEST_KEY,
        t.SHIPMENT_KEY = s.SHIPMENT_KEY,
        t.LOAD_KEY = s.LOAD_KEY,
        t.PIPELINE_KEY = s.PIPELINE_KEY,
        t.STATUS = s.STATUS,
        t.DOCUMENT_TYPE = s.DOCUMENT_TYPE,
        t.ORDER_HEADER_KEY = s.ORDER_HEADER_KEY,
        t.ORDER_RELEASE_KEY = s.ORDER_RELEASE_KEY,
        t.SHIP_TO_KEY = s.SHIP_TO_KEY,
        t.CONTAINER_SEQ_NO = s.CONTAINER_SEQ_NO,
        t.TRACKING_NO = s.TRACKING_NO,
        t.COD_RETURN_TRACKING_NO = s.COD_RETURN_TRACKING_NO,
        t.COD_AMOUNT = s.COD_AMOUNT,
        t.UCC128CODE = s.UCC128CODE,
        t.MANIFEST_NO = s.MANIFEST_NO,
        t.CONTAINER_SCM = s.CONTAINER_SCM,
        t.CONTAINER_EPC = s.CONTAINER_EPC,
        t.CONTAINER_TYPE = s.CONTAINER_TYPE,
        t.CORRUGATION_ITEM_KEY = s.CORRUGATION_ITEM_KEY,
        t.CONTAINER_LENGTH = s.CONTAINER_LENGTH,
        t.CONTAINER_WIDTH = s.CONTAINER_WIDTH,
        t.CONTAINER_HEIGHT = s.CONTAINER_HEIGHT,
        t.CONTAINER_GROSS_WEIGHT = s.CONTAINER_GROSS_WEIGHT,
        t.CONTAINER_NET_WEIGHT = s.CONTAINER_NET_WEIGHT,
        t.CONTAINER_LENGTH_UOM = s.CONTAINER_LENGTH_UOM,
        t.CONTAINER_HEIGHT_UOM = s.CONTAINER_HEIGHT_UOM,
        t.CONTAINER_WIDTH_UOM = s.CONTAINER_WIDTH_UOM,
        t.CONTAINER_GROSS_WEIGHT_UOM = s.CONTAINER_GROSS_WEIGHT_UOM,
        t.CONTAINER_NET_WEIGHT_UOM = s.CONTAINER_NET_WEIGHT_UOM,
        t.APPLIED_WEIGHT_UOM = s.APPLIED_WEIGHT_UOM,
        t.HAS_OTHER_CONTAINERS = s.HAS_OTHER_CONTAINERS,
        t.MASTER_CONTAINER_NO = s.MASTER_CONTAINER_NO,
        t.ACTUAL_FREIGHT_CHARGE = s.ACTUAL_FREIGHT_CHARGE,
        t.SCAC = s.SCAC,
        t.SHIP_DATE = s.SHIP_DATE,
        t.SHIP_MODE = s.SHIP_MODE,
        t.ZONE = s.ZONE,
        t.OVERSIZED_FLAG = s.OVERSIZED_FLAG,
        t.DIMMED_FLAG = s.DIMMED_FLAG,
        t.CARRIER_BILL_ACCOUNT = s.CARRIER_BILL_ACCOUNT,
        t.CARRIER_PAYMENT_TYPE = s.CARRIER_PAYMENT_TYPE,
        t.ASTRA_CODE = s.ASTRA_CODE,
        t.ROUTING_CODE = s.ROUTING_CODE,
        t.SERVICE_TYPE = s.SERVICE_TYPE,
        t.CARRIER_LOCATION_ID = s.CARRIER_LOCATION_ID,
        t.CARRIER_SERVICE_CODE = s.CARRIER_SERVICE_CODE,
        t.APPLIED_WEIGHT = s.APPLIED_WEIGHT,
        t.ACTUAL_WEIGHT = s.ACTUAL_WEIGHT,
        t.ACTUAL_WEIGHT_UOM = s.ACTUAL_WEIGHT_UOM,
        t.COMMITMENT_CODE = s.COMMITMENT_CODE,
        t.DELIVERY_DAY = s.DELIVERY_DAY,
        t.DELIVER_BY = s.DELIVER_BY,
        t.FORM_ID = s.FORM_ID,
        t.BASIC_FREIGHT_CHARGE = s.BASIC_FREIGHT_CHARGE,
        t.SPECIAL_SERVICES_SURCHARGE = s.SPECIAL_SERVICES_SURCHARGE,
        t.DELIVERY_CODE = s.DELIVERY_CODE,
        t.BARCODE_DISCOUNT = s.BARCODE_DISCOUNT,
        t.DISCOUNT_AMOUNT = s.DISCOUNT_AMOUNT,
        t.CUSTOMS_VALUE = s.CUSTOMS_VALUE,
        t.CARRIAGE_VALUE = s.CARRIAGE_VALUE,
        t.DECLARED_VALUE = s.DECLARED_VALUE,
        t.EXPORT_LICENSE_NO = s.EXPORT_LICENSE_NO,
        t.EXPORT_LICENSE_EXP_DATE = s.EXPORT_LICENSE_EXP_DATE,
        t.FREIGHT_TERMS = s.FREIGHT_TERMS,
        t.CUSTCARRIER_ACCOUNT_NO = s.CUSTCARRIER_ACCOUNT_NO,
        t.CONTAINER_NO = s.CONTAINER_NO,
        t.PARENT_CONTAINER_KEY = s.PARENT_CONTAINER_KEY,
        t.PARENT_CONTAINER_NO = s.PARENT_CONTAINER_NO,
        t.CONTAINER_GROUP = s.CONTAINER_GROUP,
        t.PARENT_CONTAINER_GROUP = s.PARENT_CONTAINER_GROUP,
        t.IS_RECEIVED = s.IS_RECEIVED,
        t.IS_PACK_PROCESS_COMPLETE = s.IS_PACK_PROCESS_COMPLETE,
        t.STATUS_DATE = s.STATUS_DATE,
        t.USED_DURING_PICK = s.USED_DURING_PICK,
        t.SYSTEM_SUGGESTED = s.SYSTEM_SUGGESTED,
        t.WAVE_KEY = s.WAVE_KEY,
        t.CONTAINS_STD_QTY = s.CONTAINS_STD_QTY,
        t.TASK_TYPE = s.TASK_TYPE,
        t.SERVICE_ITEM_ID = s.SERVICE_ITEM_ID,
        t.IS_HAZMAT = s.IS_HAZMAT,
        t.LOCKID = s.LOCKID,
        t.CREATETS = s.CREATETS,
        t.MODIFYTS = s.MODIFYTS,
        t.CREATEUSERID = s.CREATEUSERID,
        t.MODIFYUSERID = s.MODIFYUSERID,
        t.CREATEPROGID = s.CREATEPROGID,
        t.MODIFYPROGID = s.MODIFYPROGID,
        t.REQUIRED_NO_OF_RETURN_LABELS = s.REQUIRED_NO_OF_RETURN_LABELS,
        t.ACTUAL_NO_OF_RETURN_LABELS = s.ACTUAL_NO_OF_RETURN_LABELS,
        t.EXTN_SORT_TYPE = s.EXTN_SORT_TYPE,
        t.EXTN_SORT_VALUE = s.EXTN_SORT_VALUE,
        t.EXTERNAL_REFERENCE_1 = s.EXTERNAL_REFERENCE_1,
        t.IS_MANIFESTED = s.IS_MANIFESTED,
        t.ods_modify_date = SYSDATE
             WHERE    DECODE (t.shipment_oid, s.shipment_oid, 1, 0) = 0
                   OR DECODE (t.MANIFEST_KEY, s.MANIFEST_KEY, 1, 0) = 0
                   OR DECODE (t.SHIPMENT_KEY, s.SHIPMENT_KEY, 1, 0) = 0
                   OR DECODE (t.LOAD_KEY, s.LOAD_KEY, 1, 0) = 0
                   OR DECODE (t.PIPELINE_KEY, s.PIPELINE_KEY, 1, 0) = 0
                   OR DECODE (t.STATUS, s.STATUS, 1, 0) = 0
                   OR DECODE (t.DOCUMENT_TYPE, s.DOCUMENT_TYPE, 1, 0) = 0
                   OR DECODE (t.ORDER_HEADER_KEY, s.ORDER_HEADER_KEY, 1, 0) =
                      0
                   OR DECODE (t.ORDER_RELEASE_KEY, s.ORDER_RELEASE_KEY, 1, 0) =
                      0
                   OR DECODE (t.SHIP_TO_KEY, s.SHIP_TO_KEY, 1, 0) = 0
                   OR DECODE (t.CONTAINER_SEQ_NO, s.CONTAINER_SEQ_NO, 1, 0) =
                      0
                   OR DECODE (t.TRACKING_NO, s.TRACKING_NO, 1, 0) = 0
                   OR DECODE (t.COD_RETURN_TRACKING_NO,
                              s.COD_RETURN_TRACKING_NO, 1,
                              0) =
                      0
                   OR DECODE (t.COD_AMOUNT, s.COD_AMOUNT, 1, 0) = 0
                   OR DECODE (t.UCC128CODE, s.UCC128CODE, 1, 0) = 0
                   OR DECODE (t.MANIFEST_NO, s.MANIFEST_NO, 1, 0) = 0
                   OR DECODE (t.CONTAINER_SCM, s.CONTAINER_SCM, 1, 0) = 0
                   OR DECODE (t.CONTAINER_EPC, s.CONTAINER_EPC, 1, 0) = 0
                   OR DECODE (t.CONTAINER_TYPE, s.CONTAINER_TYPE, 1, 0) = 0
                   OR DECODE (t.CORRUGATION_ITEM_KEY,
                              s.CORRUGATION_ITEM_KEY, 1,
                              0) =
                      0
                   OR DECODE (t.CONTAINER_LENGTH, s.CONTAINER_LENGTH, 1, 0) =
                      0
                   OR DECODE (t.CONTAINER_WIDTH, s.CONTAINER_WIDTH, 1, 0) = 0
                   OR DECODE (t.CONTAINER_HEIGHT, s.CONTAINER_HEIGHT, 1, 0) =
                      0
                   OR DECODE (t.CONTAINER_GROSS_WEIGHT,
                              s.CONTAINER_GROSS_WEIGHT, 1,
                              0) =
                      0
                   OR DECODE (t.CONTAINER_NET_WEIGHT,
                              s.CONTAINER_NET_WEIGHT, 1,
                              0) =
                      0
                   OR DECODE (t.CONTAINER_LENGTH_UOM,
                              s.CONTAINER_LENGTH_UOM, 1,
                              0) =
                      0
                   OR DECODE (t.CONTAINER_HEIGHT_UOM,
                              s.CONTAINER_HEIGHT_UOM, 1,
                              0) =
                      0
                   OR DECODE (t.CONTAINER_WIDTH_UOM,
                              s.CONTAINER_WIDTH_UOM, 1,
                              0) =
                      0
                   OR DECODE (t.CONTAINER_GROSS_WEIGHT_UOM,
                              s.CONTAINER_GROSS_WEIGHT_UOM, 1,
                              0) =
                      0
                   OR DECODE (t.CONTAINER_NET_WEIGHT_UOM,
                              s.CONTAINER_NET_WEIGHT_UOM, 1,
                              0) =
                      0
                   OR DECODE (t.APPLIED_WEIGHT_UOM,
                              s.APPLIED_WEIGHT_UOM, 1,
                              0) =
                      0
                   OR DECODE (t.HAS_OTHER_CONTAINERS,
                              s.HAS_OTHER_CONTAINERS, 1,
                              0) =
                      0
                   OR DECODE (t.MASTER_CONTAINER_NO,
                              s.MASTER_CONTAINER_NO, 1,
                              0) =
                      0
                   OR DECODE (t.ACTUAL_FREIGHT_CHARGE,
                              s.ACTUAL_FREIGHT_CHARGE, 1,
                              0) =
                      0
                   OR DECODE (t.SCAC, s.SCAC, 1, 0) = 0
                   OR DECODE (t.SHIP_DATE, s.SHIP_DATE, 1, 0) = 0
                   OR DECODE (t.SHIP_MODE, s.SHIP_MODE, 1, 0) = 0
                   OR DECODE (t.ZONE, s.ZONE, 1, 0) = 0
                   OR DECODE (t.OVERSIZED_FLAG, s.OVERSIZED_FLAG, 1, 0) = 0
                   OR DECODE (t.DIMMED_FLAG, s.DIMMED_FLAG, 1, 0) = 0
                   OR DECODE (t.CARRIER_BILL_ACCOUNT,
                              s.CARRIER_BILL_ACCOUNT, 1,
                              0) =
                      0
                   OR DECODE (t.CARRIER_PAYMENT_TYPE,
                              s.CARRIER_PAYMENT_TYPE, 1,
                              0) =
                      0
                   OR DECODE (t.ASTRA_CODE, s.ASTRA_CODE, 1, 0) = 0
                   OR DECODE (t.ROUTING_CODE, s.ROUTING_CODE, 1, 0) = 0
                   OR DECODE (t.SERVICE_TYPE, s.SERVICE_TYPE, 1, 0) = 0
                   OR DECODE (t.CARRIER_LOCATION_ID,
                              s.CARRIER_LOCATION_ID, 1,
                              0) =
                      0
                   OR DECODE (t.CARRIER_SERVICE_CODE,
                              s.CARRIER_SERVICE_CODE, 1,
                              0) =
                      0
                   OR DECODE (t.APPLIED_WEIGHT, s.APPLIED_WEIGHT, 1, 0) = 0
                   OR DECODE (t.ACTUAL_WEIGHT, s.ACTUAL_WEIGHT, 1, 0) = 0
                   OR DECODE (t.ACTUAL_WEIGHT_UOM, s.ACTUAL_WEIGHT_UOM, 1, 0) =
                      0
                   OR DECODE (t.COMMITMENT_CODE, s.COMMITMENT_CODE, 1, 0) = 0
                   OR DECODE (t.DELIVERY_DAY, s.DELIVERY_DAY, 1, 0) = 0
                   OR DECODE (t.DELIVER_BY, s.DELIVER_BY, 1, 0) = 0
                   OR DECODE (t.FORM_ID, s.FORM_ID, 1, 0) = 0
                   OR DECODE (t.BASIC_FREIGHT_CHARGE,
                              s.BASIC_FREIGHT_CHARGE, 1,
                              0) =
                      0
                   OR DECODE (t.SPECIAL_SERVICES_SURCHARGE,
                              s.SPECIAL_SERVICES_SURCHARGE, 1,
                              0) =
                      0
                   OR DECODE (t.DELIVERY_CODE, s.DELIVERY_CODE, 1, 0) = 0
                   OR DECODE (t.BARCODE_DISCOUNT, s.BARCODE_DISCOUNT, 1, 0) =
                      0
                   OR DECODE (t.DISCOUNT_AMOUNT, s.DISCOUNT_AMOUNT, 1, 0) = 0
                   OR DECODE (t.CUSTOMS_VALUE, s.CUSTOMS_VALUE, 1, 0) = 0
                   OR DECODE (t.CARRIAGE_VALUE, s.CARRIAGE_VALUE, 1, 0) = 0
                   OR DECODE (t.DECLARED_VALUE, s.DECLARED_VALUE, 1, 0) = 0
                   OR DECODE (t.EXPORT_LICENSE_NO, s.EXPORT_LICENSE_NO, 1, 0) =
                      0
                   OR DECODE (t.EXPORT_LICENSE_EXP_DATE,
                              s.EXPORT_LICENSE_EXP_DATE, 1,
                              0) =
                      0
                   OR DECODE (t.FREIGHT_TERMS, s.FREIGHT_TERMS, 1, 0) = 0
                   OR DECODE (t.CUSTCARRIER_ACCOUNT_NO,
                              s.CUSTCARRIER_ACCOUNT_NO, 1,
                              0) =
                      0
                   OR DECODE (t.CONTAINER_NO, s.CONTAINER_NO, 1, 0) = 0
                   OR DECODE (t.PARENT_CONTAINER_KEY,
                              s.PARENT_CONTAINER_KEY, 1,
                              0) =
                      0
                   OR DECODE (t.PARENT_CONTAINER_NO,
                              s.PARENT_CONTAINER_NO, 1,
                              0) =
                      0
                   OR DECODE (t.CONTAINER_GROUP, s.CONTAINER_GROUP, 1, 0) = 0
                   OR DECODE (t.PARENT_CONTAINER_GROUP,
                              s.PARENT_CONTAINER_GROUP, 1,
                              0) =
                      0
                   OR DECODE (t.IS_RECEIVED, s.IS_RECEIVED, 1, 0) = 0
                   OR DECODE (t.IS_PACK_PROCESS_COMPLETE,
                              s.IS_PACK_PROCESS_COMPLETE, 1,
                              0) =
                      0
                   OR DECODE (t.STATUS_DATE, s.STATUS_DATE, 1, 0) = 0
                   OR DECODE (t.USED_DURING_PICK, s.USED_DURING_PICK, 1, 0) =
                      0
                   OR DECODE (t.SYSTEM_SUGGESTED, s.SYSTEM_SUGGESTED, 1, 0) =
                      0
                   OR DECODE (t.WAVE_KEY, s.WAVE_KEY, 1, 0) = 0
                   OR DECODE (t.CONTAINS_STD_QTY, s.CONTAINS_STD_QTY, 1, 0) =
                      0
                   OR DECODE (t.TASK_TYPE, s.TASK_TYPE, 1, 0) = 0
                   OR DECODE (t.SERVICE_ITEM_ID, s.SERVICE_ITEM_ID, 1, 0) = 0
                   OR DECODE (t.IS_HAZMAT, s.IS_HAZMAT, 1, 0) = 0
                   OR DECODE (t.LOCKID, s.LOCKID, 1, 0) = 0
                   OR DECODE (t.CREATETS, s.CREATETS, 1, 0) = 0
                   OR DECODE (t.MODIFYTS, s.MODIFYTS, 1, 0) = 0
                   OR DECODE (t.CREATEUSERID, s.CREATEUSERID, 1, 0) = 0
                   OR DECODE (t.MODIFYUSERID, s.MODIFYUSERID, 1, 0) = 0
                   OR DECODE (t.CREATEPROGID, s.CREATEPROGID, 1, 0) = 0
                   OR DECODE (t.MODIFYPROGID, s.MODIFYPROGID, 1, 0) = 0
                   OR DECODE (t.REQUIRED_NO_OF_RETURN_LABELS,
                              s.REQUIRED_NO_OF_RETURN_LABELS, 1,
                              0) =
                      0
                   OR DECODE (t.ACTUAL_NO_OF_RETURN_LABELS,
                              s.ACTUAL_NO_OF_RETURN_LABELS, 1,
                              0) =
                      0
                   OR DECODE (t.EXTN_SORT_TYPE, s.EXTN_SORT_TYPE, 1, 0) = 0
                   OR DECODE (t.EXTN_SORT_VALUE, s.EXTN_SORT_VALUE, 1, 0) = 0
                   OR DECODE (t.EXTERNAL_REFERENCE_1,
                              s.EXTERNAL_REFERENCE_1, 1,
                              0) =
                      0
                   OR DECODE (t.IS_MANIFESTED, s.IS_MANIFESTED, 1, 0) = 0
WHEN NOT MATCHED
THEN
    INSERT     (source_system_oid,
                shipment_container_oid,
                shipment_oid,
                MANIFEST_KEY,
                SHIPMENT_KEY,
                LOAD_KEY,
                PIPELINE_KEY,
                STATUS,
                DOCUMENT_TYPE,
                ORDER_HEADER_KEY,
                ORDER_RELEASE_KEY,
                SHIP_TO_KEY,
                CONTAINER_SEQ_NO,
                TRACKING_NO,
                COD_RETURN_TRACKING_NO,
                COD_AMOUNT,
                UCC128CODE,
                MANIFEST_NO,
                CONTAINER_SCM,
                CONTAINER_EPC,
                CONTAINER_TYPE,
                CORRUGATION_ITEM_KEY,
                CONTAINER_LENGTH,
                CONTAINER_WIDTH,
                CONTAINER_HEIGHT,
                CONTAINER_GROSS_WEIGHT,
                CONTAINER_NET_WEIGHT,
                CONTAINER_LENGTH_UOM,
                CONTAINER_HEIGHT_UOM,
                CONTAINER_WIDTH_UOM,
                CONTAINER_GROSS_WEIGHT_UOM,
                CONTAINER_NET_WEIGHT_UOM,
                APPLIED_WEIGHT_UOM,
                HAS_OTHER_CONTAINERS,
                MASTER_CONTAINER_NO,
                ACTUAL_FREIGHT_CHARGE,
                SCAC,
                SHIP_DATE,
                SHIP_MODE,
                ZONE,
                OVERSIZED_FLAG,
                DIMMED_FLAG,
                CARRIER_BILL_ACCOUNT,
                CARRIER_PAYMENT_TYPE,
                ASTRA_CODE,
                ROUTING_CODE,
                SERVICE_TYPE,
                CARRIER_LOCATION_ID,
                CARRIER_SERVICE_CODE,
                APPLIED_WEIGHT,
                ACTUAL_WEIGHT,
                ACTUAL_WEIGHT_UOM,
                COMMITMENT_CODE,
                DELIVERY_DAY,
                DELIVER_BY,
                FORM_ID,
                BASIC_FREIGHT_CHARGE,
                SPECIAL_SERVICES_SURCHARGE,
                DELIVERY_CODE,
                BARCODE_DISCOUNT,
                DISCOUNT_AMOUNT,
                CUSTOMS_VALUE,
                CARRIAGE_VALUE,
                DECLARED_VALUE,
                EXPORT_LICENSE_NO,
                EXPORT_LICENSE_EXP_DATE,
                FREIGHT_TERMS,
                CUSTCARRIER_ACCOUNT_NO,
                CONTAINER_NO,
                PARENT_CONTAINER_KEY,
                PARENT_CONTAINER_NO,
                CONTAINER_GROUP,
                PARENT_CONTAINER_GROUP,
                IS_RECEIVED,
                IS_PACK_PROCESS_COMPLETE,
                STATUS_DATE,
                USED_DURING_PICK,
                SYSTEM_SUGGESTED,
                WAVE_KEY,
                CONTAINS_STD_QTY,
                TASK_TYPE,
                SERVICE_ITEM_ID,
                IS_HAZMAT,
                LOCKID,
                CREATETS,
                MODIFYTS,
                CREATEUSERID,
                MODIFYUSERID,
                CREATEPROGID,
                MODIFYPROGID,
                REQUIRED_NO_OF_RETURN_LABELS,
                ACTUAL_NO_OF_RETURN_LABELS,
                EXTN_SORT_TYPE,
                EXTN_SORT_VALUE,
                EXTERNAL_REFERENCE_1,
                IS_MANIFESTED,
                ods_create_date,
                ods_modify_date)
        VALUES (s.source_system_oid,
                s.shipment_container_oid,
                s.shipment_oid,
                s.MANIFEST_KEY,
                s.SHIPMENT_KEY,
                s.LOAD_KEY,
                s.PIPELINE_KEY,
                s.STATUS,
                s.DOCUMENT_TYPE,
                s.ORDER_HEADER_KEY,
                s.ORDER_RELEASE_KEY,
                s.SHIP_TO_KEY,
                s.CONTAINER_SEQ_NO,
                s.TRACKING_NO,
                s.COD_RETURN_TRACKING_NO,
                s.COD_AMOUNT,
                s.UCC128CODE,
                s.MANIFEST_NO,
                s.CONTAINER_SCM,
                s.CONTAINER_EPC,
                s.CONTAINER_TYPE,
                s.CORRUGATION_ITEM_KEY,
                s.CONTAINER_LENGTH,
                s.CONTAINER_WIDTH,
                s.CONTAINER_HEIGHT,
                s.CONTAINER_GROSS_WEIGHT,
                s.CONTAINER_NET_WEIGHT,
                s.CONTAINER_LENGTH_UOM,
                s.CONTAINER_HEIGHT_UOM,
                s.CONTAINER_WIDTH_UOM,
                s.CONTAINER_GROSS_WEIGHT_UOM,
                s.CONTAINER_NET_WEIGHT_UOM,
                s.APPLIED_WEIGHT_UOM,
                s.HAS_OTHER_CONTAINERS,
                s.MASTER_CONTAINER_NO,
                s.ACTUAL_FREIGHT_CHARGE,
                s.SCAC,
                s.SHIP_DATE,
                s.SHIP_MODE,
                s.ZONE,
                s.OVERSIZED_FLAG,
                s.DIMMED_FLAG,
                s.CARRIER_BILL_ACCOUNT,
                s.CARRIER_PAYMENT_TYPE,
                s.ASTRA_CODE,
                s.ROUTING_CODE,
                s.SERVICE_TYPE,
                s.CARRIER_LOCATION_ID,
                s.CARRIER_SERVICE_CODE,
                s.APPLIED_WEIGHT,
                s.ACTUAL_WEIGHT,
                s.ACTUAL_WEIGHT_UOM,
                s.COMMITMENT_CODE,
                s.DELIVERY_DAY,
                s.DELIVER_BY,
                s.FORM_ID,
                s.BASIC_FREIGHT_CHARGE,
                s.SPECIAL_SERVICES_SURCHARGE,
                s.DELIVERY_CODE,
                s.BARCODE_DISCOUNT,
                s.DISCOUNT_AMOUNT,
                s.CUSTOMS_VALUE,
                s.CARRIAGE_VALUE,
                s.DECLARED_VALUE,
                s.EXPORT_LICENSE_NO,
                s.EXPORT_LICENSE_EXP_DATE,
                s.FREIGHT_TERMS,
                s.CUSTCARRIER_ACCOUNT_NO,
                s.CONTAINER_NO,
                s.PARENT_CONTAINER_KEY,
                s.PARENT_CONTAINER_NO,
                s.CONTAINER_GROUP,
                s.PARENT_CONTAINER_GROUP,
                s.IS_RECEIVED,
                s.IS_PACK_PROCESS_COMPLETE,
                s.STATUS_DATE,
                s.USED_DURING_PICK,
                s.SYSTEM_SUGGESTED,
                s.WAVE_KEY,
                s.CONTAINS_STD_QTY,
                s.TASK_TYPE,
                s.SERVICE_ITEM_ID,
                s.IS_HAZMAT,
                s.LOCKID,
                s.CREATETS,
                s.MODIFYTS,
                s.CREATEUSERID,
                s.MODIFYUSERID,
                s.CREATEPROGID,
                s.MODIFYPROGID,
                s.REQUIRED_NO_OF_RETURN_LABELS,
                s.ACTUAL_NO_OF_RETURN_LABELS,
                s.EXTN_SORT_TYPE,
                s.EXTN_SORT_VALUE,
                s.EXTERNAL_REFERENCE_1,
                s.IS_MANIFESTED,
                SYSDATE,
                SYSDATE)

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Merge late arriving Shipment */

MERGE INTO ods_own.shipment_container d
     USING (SELECT cxr.SHIPMENT_CONTAINER_OID, sxr.SHIPMENT_oid
              FROM ODS_STAGE.OMS3_SHIPMENT_CONTAINER_XR  cxr,
                   ODS_STAGE.OMS_SHIPMENT_XR             sxr,
                   ods_own.shipment_container            c
             WHERE     cxr.SHIPMENT_KEY = sxr.SHIPMENT_KEY
                   AND cxr.SHIPMENT_CONTAINER_OID = c.SHIPMENT_CONTAINER_OID
                   AND c.SHIPMENT_OID IS NULL) s
        ON (d.SHIPMENT_CONTAINER_OID = s.SHIPMENT_CONTAINER_OID)
WHEN MATCHED
THEN
    UPDATE SET d.shipment_oid = s.shipment_oid, d.ods_modify_date = SYSDATE
             WHERE d.shipment_oid IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 11 */
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
/* TASK No. 12 */
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
,'LOAD_SHIPMENT_CONTAINER_PKG'
,'002'
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
'LOAD_SHIPMENT_CONTAINER_PKG',
'002',
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
