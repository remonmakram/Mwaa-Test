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
/* Drop Temp_Stage Table */

-- DROP TABLE RAX_APP_USER.DM_WORK_ORDER_BATCH_STG
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.DM_WORK_ORDER_BATCH_STG';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Create Temp_Stage Table */

CREATE TABLE RAX_APP_USER.DM_WORK_ORDER_BATCH_STG
(
        WORK_ORDER_BATCH_OID     	NUMBER,
        WORK_ORDER_BATCH_JUNK_ID 	NUMBER,
        MARKETING_ID             	NUMBER ,
        MARKETING_CODE           	VARCHAR2(100),
        SALES_LINE_NAME          	VARCHAR2(100),
        PROGRAM_NAME             	VARCHAR2(100),
        PROGRAM_ID               	NUMBER,  
        SUB_PROGRAM_OID          	NUMBER,
        SUB_PROGRAM_ID           	NUMBER,
        SUB_PROGRAM_NAME         	VARCHAR2(100),
        ACCOUNT_ID               	NUMBER ,
        UK_LIFETOUCH_ID          	VARCHAR2(100),
        ITEM_ID                  		NUMBER,
        UK_ITEM_CODE             	VARCHAR2(100),
        APO_ID                  	 	NUMBER,
        UK_APO_CODE              	VARCHAR2(100),   
        EVENT_ID                 		NUMBER,
        UK_JOB_NBR               	VARCHAR2(100),
        ORGANIZATION_ID          	NUMBER,
        UK_TERRITORY_CODE        	VARCHAR2(100), 
        SHIPMENT_NO              	VARCHAR2(50),  
        SHIPMENT_KEY             	VARCHAR2(50),    
        PARENT_ORDER_HEADER_OID  	NUMBER,
        LAB                      		VARCHAR2(50),    
        BIN_LOCATION                               VARCHAR2(50),    
        BATCH_ID                		VARCHAR2(100),
        BATCH_CREATE_DATE_KEY    	DATE,
        READY_FULLFILLMENT_DATE_KEY DATE,
        PRINT_DATE_KEY                   	DATE,
        COMPLETE_DATE_KEY  	DATE,
        BINNED_DATE_KEY                  DATE,
        PACKED_DATE_KEY                  DATE,    
        SHIPPED_DATE_KEY                 DATE,
        BATCH_STATUS             	VARCHAR2(100),
        BATCH_STATUS_DESC        	VARCHAR2(100),
        BATCH_COMPLETE_FLAG      	VARCHAR2(1),   
        DEVICE_GROUP             	VARCHAR2(100),
        FULFILLMENT_TYPE         	VARCHAR2(100),
        PRODUCT_LINE                              VARCHAR2(100),
        CHARGEBACK_CATEGORY             VARCHAR2(100),
        CHARGE_TYPE                                VARCHAR2(100),
        REQ_SHIP_DATE_KEY        	DATE,
        REQ_DELIVERY_DATE_KEY    	DATE,
        AVAILABLE_DATE_KEY       	DATE,
        TOTAL_WORK_ORDERS        	NUMBER,
        TOTAL_TASKS              	NUMBER,
        TOTAL_INCOMPLETE_TASKS   	NUMBER,
        TOTAL_COMPLETED_TASKS    	NUMBER,
        START_PAGE               	NUMBER,
        END_PAGE                 		NUMBER,
        TOTAL_PAGES              	NUMBER,
        MAKEOVER_COMMENT      	VARCHAR2(100),
        MAKEOVER_REASON         	VARCHAR2(100),
        REASON_DESC              	VARCHAR2(100),
        CANCEL_COMMENT           	VARCHAR2(100),
        MART_CREATE_DATE         	    DATE,
        MART_MODIFY_DATE         	    DATE,
        CALC_READY_FULLFILL_DATE_KEY   DATE,
        CALC_COMPLETE_DATE_KEY        	    DATE,
        FULLFILL_COMPLETE_DAYS  	    NUMBER,
        FULLFILL_COMPLETE_OT_FLAG  	    VARCHAR2(1),
        MANUFACTURER_ITEM            	    VARCHAR2(40),
        BOC_BATCH_ID                 	VARCHAR2(40),
        TOTAL_ORDERS                 	NUMBER,
        BUYER_COUNT                   	NUMBER,
        MAGNET                              	NUMBER,
        BUTTONS                            	NUMBER,
        PLAQUES                            	NUMBER,
        TRADER_CARDS                	NUMBER,
        STANDARD_PRINTS           	NUMBER,
        TP16X20                             	NUMBER,
        TP11X14                             	NUMBER
)



&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Insert into Temp_Stage */

INSERT INTO RAX_APP_USER.DM_WORK_ORDER_BATCH_STG
SELECT 
ODS_OWN.WORK_ORDER_BATCH.WORK_ORDER_BATCH_OID,
NULL AS WORK_ORDER_BATCH_JUNK_ID,
MART.MARKETING.MARKETING_ID MARKETING_ID,
MART.MARKETING.MARKETING_CODE,       
MART.MARKETING.SALES_LINE_NAME,      
ODS_OWN.PROGRAM.PROGRAM_NAME,        
ODS_OWN.PROGRAM.PROGRAM_ID,          
ODS_OWN.SUB_PROGRAM.SUB_PROGRAM_OID,  
ODS_OWN.SUB_PROGRAM.SUB_PROGRAM_ID,   
ODS_OWN.SUB_PROGRAM.SUB_PROGRAM_NAME, 
MART.ACCOUNT.ACCOUNT_ID,
ODS_OWN.ACCOUNT.LIFETOUCH_ID UK_LIFETOUCH_ID,
MART.ITEM.ITEM_ID,
ODS_OWN.ITEM.ITEM_ID UK_ITEM_CODE,
MART.APO.APO_ID,
ODS_OWN.APO.APO_ID UK_APO_CODE,
MART.EVENT.EVENT_ID,
ODS_OWN.EVENT.EVENT_REF_ID UK_JOB_NBR,
MART.ORGANIZATION.ORGANIZATION_ID,
ODS_OWN.APO.TERRITORY_CODE UK_TERRITORY_CODE,
ODS_OWN.WORK_ORDER_BATCH.SHIPMENT_NO,
ODS_OWN.WORK_ORDER_BATCH.SHIPMENT_KEY,
ODS_OWN.WORK_ORDER_BATCH.PARENT_ORDER_HEADER_OID,
ODS_OWN.WORK_ORDER_BATCH.LAB,
ODS_OWN.WORK_ORDER_BATCH.BIN_LOCATION,
ODS_OWN.WORK_ORDER_BATCH.BATCH_ID,
NULL AS BATCH_CREATE_DATE_KEY,
NULL AS READY_FULLFILLMENT_DATE_KEY,
NULL AS PRINT_DATE_KEY,
NULL AS COMPLETE_DATE_KEY,
NULL AS BINNED_DATE_KEY,
NULL AS PACKED_DATE_KEY,
NULL AS SHIPPED_DATE_KEY,
ODS_OWN.WORK_ORDER_BATCH.STATUS,
ODS_OWN.WORK_ORDER_BATCH.STATUS_DESC,
ODS_OWN.WORK_ORDER_BATCH.IS_COMPLETE,
ODS_OWN.WORK_ORDER_BATCH.DEVICE_GROUP,
ODS_OWN.WORK_ORDER_BATCH.FULFILLMENT_TYPE,
ODS_OWN.ITEM.PRODUCT_LINE,
ODS_OWN.ITEM.CHARGEBACK_CATEGORY,
ODS_OWN.ITEM.CHARGE_TYPE,
NVL(ODS_OWN.WORK_ORDER_BATCH.REQ_SHIP_DATE,TO_DATE('01-JAN-1900 00:00:00','DD-MON-YYYY HH24:MI:SS')) REQ_SHIP_DATE_KEY,
NVL(ODS_OWN.WORK_ORDER_BATCH.REQ_DELIVERY_DATE,TO_DATE('01-JAN-1900 00:00:00','DD-MON-YYYY HH24:MI:SS')) 
REQ_DELIVERY_DATE_KEY,
NVL(ODS_OWN.WORK_ORDER_BATCH.AVAILABLE_DATE,TO_DATE('01-JAN-1900 00:00:00','DD-MON-YYYY HH24:MI:SS')) AVAILABLE_DATE_KEY,
ODS_OWN.WORK_ORDER_BATCH.TOTAL_WORK_ORDERS,
ODS_OWN.WORK_ORDER_BATCH.TOTAL_TASKS,
ODS_OWN.WORK_ORDER_BATCH.TOTAL_INCOMPLT_TASKS,
ODS_OWN.WORK_ORDER_BATCH.TOTAL_COMPLTD_TASKS,
to_number(nvl(REGEXP_SUBSTR(ODS_OWN.WORK_ORDER_BATCH.START_PAGE,'(\d*)'),'0')) START_PAGE,
to_number(nvl(nvl(REGEXP_SUBSTR(ODS_OWN.WORK_ORDER_BATCH.END_PAGE,'(\d*)'),reverse(REGEXP_SUBSTR(reverse(ODS_OWN.WORK_ORDER_BATCH.START_PAGE),'(\d*)'))),'0')) END_PAGE,
ODS_OWN.WORK_ORDER_BATCH.TOTAL_PAGES,
ODS_OWN.WORK_ORDER_BATCH.MAKEOVER_COMMENT,
ODS_OWN.WORK_ORDER_BATCH.MAKEOVER_REASON,
ODS_OWN.WORK_ORDER_BATCH.REASON_DESC,
ODS_OWN.WORK_ORDER_BATCH.CANCEL_COMMENT,
SYSDATE AS MART_CREATE_DATE,
SYSDATE AS MART_MODIFY_DATE,
NULL AS CALC_READY_FULLFILL_DATE_KEY,
NULL AS CALC_COMPLETE_DATE_KEY,
NULL AS FULLFILL_COMPLETE_DAYS, 
NULL AS FULLFILL_COMPLETE_OT_FLAG,
ODS_OWN.WORK_ORDER_BATCH.MANUFACTURER_ITEM    ,        
ODS_OWN.WORK_ORDER_BATCH.BOC_BATCH_ID                ,
ODS_OWN.WORK_ORDER_BATCH.TOTAL_ORDERS	             ,
ODS_OWN.WORK_ORDER_BATCH.BUYER_COUNT                 , 
ODS_OWN.WORK_ORDER_BATCH.MAGNET                            , 
ODS_OWN.WORK_ORDER_BATCH.BUTTONS                          ,
ODS_OWN.WORK_ORDER_BATCH.PLAQUES                           ,
ODS_OWN.WORK_ORDER_BATCH.TRADER_CARDS               ,   
ODS_OWN.WORK_ORDER_BATCH.STANDARD_PRINTS          ,    
ODS_OWN.WORK_ORDER_BATCH.TP16X20                            , 
ODS_OWN.WORK_ORDER_BATCH.TP11X14                             
FROM
      ODS_OWN.WORK_ORDER_BATCH
     ,ODS_OWN.APO 
     ,ODS_OWN.ITEM
     ,ODS_OWN.EVENT
     ,ODS_OWN.ACCOUNT     
     ,ODS_OWN.SUB_PROGRAM 
     ,ODS_OWN.PROGRAM           
     ,MART.APO
     ,MART.ITEM
     ,MART.EVENT          
     ,MART.ORGANIZATION 
     ,MART.ACCOUNT
     ,MART.MARKETING
     ,MART.TIME REQ_SHIP_TIME
     ,MART.TIME REQ_DEL_TIME
     ,MART.TIME AVAILABLE_TIME     
     ,ODS.DW_CDC_LOAD_STATUS      
WHERE                
            ODS_OWN.WORK_ORDER_BATCH.APO_OID = ODS_OWN.APO.APO_OID
    AND ODS_OWN.WORK_ORDER_BATCH.ITEM_OID = ODS_OWN.ITEM.ITEM_OID
    AND ODS_OWN.WORK_ORDER_BATCH.EVENT_OID = ODS_OWN.EVENT.EVENT_OID       
    AND ODS_OWN.APO.ACCOUNT_OID = ODS_OWN.ACCOUNT.ACCOUNT_OID    
    AND ODS_OWN.APO.SUB_PROGRAM_OID = ODS_OWN.SUB_PROGRAM.SUB_PROGRAM_OID  
    AND ODS_OWN.SUB_PROGRAM.PROGRAM_OID = ODS_OWN.PROGRAM.PROGRAM_OID      
    AND NVL(ODS_OWN.APO.TERRITORY_CODE,-1) = MART.ORGANIZATION.TERRITORY_CODE(+)
    AND NVL(ODS_OWN.APO.APO_ID,-1) = MART.APO.APO_CODE(+)
    AND NVL(ODS_OWN.ACCOUNT.LIFETOUCH_ID,-1) = MART.ACCOUNT.LIFETOUCH_ID(+)    
    AND NVL(ODS_OWN.SUB_PROGRAM.SUB_PROGRAM_OID,-1) = MART.MARKETING.SUB_PROGRAM_OID(+)   
    AND NVL(ODS_OWN.ITEM.ITEM_ID,-1) = MART.ITEM.ITEM_CODE(+)
    AND NVL(ODS_OWN.EVENT.EVENT_REF_ID,-1) = MART.EVENT.JOB_NBR(+)
    AND TRUNC(ODS_OWN.WORK_ORDER_BATCH.REQ_SHIP_DATE) = REQ_SHIP_TIME.DATE_KEY(+)
    AND TRUNC(ODS_OWN.WORK_ORDER_BATCH.REQ_DELIVERY_DATE) = REQ_DEL_TIME.DATE_KEY(+)    
    AND TRUNC(ODS_OWN.WORK_ORDER_BATCH.AVAILABLE_DATE) =  AVAILABLE_TIME.DATE_KEY(+)
    AND ODS_OWN.WORK_ORDER_BATCH.ODS_MODIFY_DATE > ODS.DW_CDC_LOAD_STATUS.LAST_CDC_COMPLETION_DATE   
    AND ODS.DW_CDC_LOAD_STATUS.DW_TABLE_NAME = 'WORK_ORDER_BATCH_FACT'

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Index Creation Temp_Stage Table */

CREATE INDEX RAX_APP_USER.DM_WORK_ORDER_BATCH_STG_IX1 ON RAX_APP_USER.DM_WORK_ORDER_BATCH_STG
(WORK_ORDER_BATCH_OID)
LOGGING
NOPARALLEL

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Index Creation Temp_Stage Table */

CREATE INDEX RAX_APP_USER.DM_WORK_ORDER_BATCH_STG_IX2 ON RAX_APP_USER.DM_WORK_ORDER_BATCH_STG
(WORK_ORDER_BATCH_JUNK_ID)
LOGGING
NOPARALLEL

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Index Creation Temp_Stage Table */

CREATE INDEX RAX_APP_USER.DM_WORK_ORDER_BATCH_STG_IX3 ON RAX_APP_USER.DM_WORK_ORDER_BATCH_STG
(FULLFILL_COMPLETE_OT_FLAG)
LOGGING
NOPARALLEL

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Merge Status Date - Work Order Batch Create Date */

MERGE INTO RAX_APP_USER.DM_WORK_ORDER_BATCH_STG  TGT
    USING  
    (  
      SELECT WORK_ORDER_BATCH_OID,STATUS_DATE AS BATCH_CREATE_DATE FROM
      (
        SELECT STAT.WORK_ORDER_BATCH_STATUS_OID,STAT.WORK_ORDER_BATCH_OID,STG.BATCH_ID,
                     STAT.STATUS,STAT.ODS_CREATE_DATE,STAT.STATUS_DATE,
                     ROW_NUMBER() OVER (PARTITION BY STAT.WORK_ORDER_BATCH_OID 
         ORDER BY STAT.STATUS_DATE DESC) R
       FROM   
         RAX_APP_USER.DM_WORK_ORDER_BATCH_STG  STG,
          ODS_OWN.WORK_ORDER_BATCH_STATUS STAT      
       WHERE 1 = 1
       AND STG.WORK_ORDER_BATCH_OID = STAT.WORK_ORDER_BATCH_OID 
       AND STAT.STATUS = 'Work Order Created'
       )
      WHERE R = 1
      ORDER BY 1
    )SRC
      ON (TGT.WORK_ORDER_BATCH_OID = SRC.WORK_ORDER_BATCH_OID)          
      WHEN MATCHED THEN
       UPDATE 
        SET TGT.BATCH_CREATE_DATE_KEY =  SRC.BATCH_CREATE_DATE

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Merge Status Date - Ready Fullfillment Date */

MERGE INTO RAX_APP_USER.DM_WORK_ORDER_BATCH_STG  TGT
    USING  
    (  

      SELECT WORK_ORDER_BATCH_OID,STATUS_DATE AS READY_FULLFILLMENT_DATE FROM
      (
        SELECT STAT.WORK_ORDER_BATCH_STATUS_OID,STAT.WORK_ORDER_BATCH_OID,
        STG.BATCH_ID,STAT.STATUS,STAT.ODS_CREATE_DATE,STAT.STATUS_DATE,
        ROW_NUMBER() OVER (PARTITION BY STAT.WORK_ORDER_BATCH_OID 
        ORDER BY STAT.STATUS_DATE DESC) R
       FROM   
          RAX_APP_USER.DM_WORK_ORDER_BATCH_STG  STG,
          ODS_OWN.WORK_ORDER_BATCH_STATUS STAT      
       WHERE 1 = 1
       AND STG.WORK_ORDER_BATCH_OID = STAT.WORK_ORDER_BATCH_OID 
       AND STAT.STATUS = 'Ready For Fulfillment'
       )
      WHERE R = 1
      ORDER BY 1
    )SRC
      ON (TGT.WORK_ORDER_BATCH_OID = SRC.WORK_ORDER_BATCH_OID)          
      WHEN MATCHED THEN
       UPDATE 
        SET TGT.READY_FULLFILLMENT_DATE_KEY =  SRC.READY_FULLFILLMENT_DATE

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Merge Status Date - Print Success Date */

MERGE INTO RAX_APP_USER.DM_WORK_ORDER_BATCH_STG  TGT
    USING  
    (  
      SELECT WORK_ORDER_BATCH_OID,STATUS_DATE AS PRINT_DATE FROM
      (
        SELECT STAT.WORK_ORDER_BATCH_STATUS_OID,STAT.WORK_ORDER_BATCH_OID,
        STG.BATCH_ID,STAT.STATUS,STAT.ODS_CREATE_DATE,STAT.STATUS_DATE,
        ROW_NUMBER() OVER (PARTITION BY STAT.WORK_ORDER_BATCH_OID 
        ORDER BY STAT.STATUS_DATE DESC) R
       FROM   
          RAX_APP_USER.DM_WORK_ORDER_BATCH_STG  STG,
          ODS_OWN.WORK_ORDER_BATCH_STATUS STAT      
       WHERE 1 = 1
       AND STG.WORK_ORDER_BATCH_OID = STAT.WORK_ORDER_BATCH_OID 
       AND STAT.STATUS = 'Print Success'
       )
      WHERE R = 1
      ORDER BY 1
    )SRC
      ON (TGT.WORK_ORDER_BATCH_OID = SRC.WORK_ORDER_BATCH_OID)          
      WHEN MATCHED THEN
       UPDATE
        SET TGT.PRINT_DATE_KEY = SRC.PRINT_DATE

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Merge Status Date - Complete Date */

MERGE INTO RAX_APP_USER.DM_WORK_ORDER_BATCH_STG  TGT
    USING  
    (  

      SELECT WORK_ORDER_BATCH_OID,STATUS_DATE AS COMPLETE_DATE FROM
      (
        SELECT STAT.WORK_ORDER_BATCH_STATUS_OID,STAT.WORK_ORDER_BATCH_OID,
        STG.BATCH_ID,STAT.STATUS,STAT.ODS_CREATE_DATE,STAT.STATUS_DATE,
        ROW_NUMBER() OVER (PARTITION BY STAT.WORK_ORDER_BATCH_OID 
        ORDER BY STAT.STATUS_DATE DESC) R
       FROM   
          RAX_APP_USER.DM_WORK_ORDER_BATCH_STG  STG,
          ODS_OWN.WORK_ORDER_BATCH_STATUS STAT      
       WHERE 1 = 1
       AND STG.WORK_ORDER_BATCH_OID = STAT.WORK_ORDER_BATCH_OID 
       AND STAT.STATUS = 'Complete'
       )
      WHERE R = 1
      ORDER BY 1
    )SRC
      ON (TGT.WORK_ORDER_BATCH_OID = SRC.WORK_ORDER_BATCH_OID)          
      WHEN MATCHED THEN
       UPDATE 
        SET TGT.COMPLETE_DATE_KEY =  SRC.COMPLETE_DATE

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Merge Status Date - Binned Date */

MERGE INTO RAX_APP_USER.DM_WORK_ORDER_BATCH_STG  TGT
    USING  
    (  

      SELECT WORK_ORDER_BATCH_OID,STATUS_DATE AS BINNED_DATE FROM
      (
        SELECT         
        STAT.WORK_ORDER_BATCH_STATUS_OID,STAT.WORK_ORDER_BATCH_OID,
        STG.BATCH_ID,STAT.STATUS,STAT.ODS_CREATE_DATE,STAT.STATUS_DATE,
        ROW_NUMBER() OVER (PARTITION BY STAT.WORK_ORDER_BATCH_OID 
        ORDER BY STAT.STATUS_DATE DESC) R
       FROM   
          RAX_APP_USER.DM_WORK_ORDER_BATCH_STG  STG,
          ODS_OWN.WORK_ORDER_BATCH_STATUS STAT      
       WHERE 1 = 1
       AND STG.WORK_ORDER_BATCH_OID = STAT.WORK_ORDER_BATCH_OID 
       AND STAT.STATUS = 'Binned'
       )
      WHERE R = 1
      ORDER BY 1
    )SRC
      ON (TGT.WORK_ORDER_BATCH_OID = SRC.WORK_ORDER_BATCH_OID)          
      WHEN MATCHED THEN
        UPDATE 
        SET TGT.BINNED_DATE_KEY =  SRC.BINNED_DATE

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Merge Status Date - Packed Date */

MERGE INTO RAX_APP_USER.DM_WORK_ORDER_BATCH_STG  TGT
    USING  
    (  
      SELECT WORK_ORDER_BATCH_OID,STATUS_DATE AS PACKED_DATE FROM
      (
        SELECT         
        STAT.WORK_ORDER_BATCH_STATUS_OID,STAT.WORK_ORDER_BATCH_OID,
        STG.BATCH_ID,STAT.STATUS,STAT.ODS_CREATE_DATE,STAT.STATUS_DATE,
        ROW_NUMBER() OVER (PARTITION BY STAT.WORK_ORDER_BATCH_OID 
        ORDER BY STAT.STATUS_DATE DESC) R
       FROM   
         RAX_APP_USER.DM_WORK_ORDER_BATCH_STG  STG,
          ODS_OWN.WORK_ORDER_BATCH_STATUS STAT      
       WHERE 1 = 1
       AND STG.WORK_ORDER_BATCH_OID = STAT.WORK_ORDER_BATCH_OID
       AND STAT.STATUS = 'Packed'
       )
      WHERE R = 1
      ORDER BY 1
    )SRC
      ON (TGT.WORK_ORDER_BATCH_OID = SRC.WORK_ORDER_BATCH_OID)          
      WHEN MATCHED THEN
        UPDATE 
        SET TGT.PACKED_DATE_KEY =  SRC.PACKED_DATE

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Merge Status Date - Shipped Date */


MERGE INTO RAX_APP_USER.DM_WORK_ORDER_BATCH_STG  TGT
    USING  
    (  

      SELECT WORK_ORDER_BATCH_OID,STATUS_DATE AS SHIPPED_DATE FROM
      (
        SELECT STAT.WORK_ORDER_BATCH_STATUS_OID,STAT.WORK_ORDER_BATCH_OID,
        STG.BATCH_ID,STAT.STATUS,STAT.ODS_CREATE_DATE,STAT.STATUS_DATE,
        ROW_NUMBER() OVER (PARTITION BY STAT.WORK_ORDER_BATCH_OID 
        ORDER BY STAT.STATUS_DATE DESC) R
       FROM   
          RAX_APP_USER.DM_WORK_ORDER_BATCH_STG  STG,
          ODS_OWN.WORK_ORDER_BATCH_STATUS STAT      
       WHERE 1 = 1
       AND STG.WORK_ORDER_BATCH_OID = STAT.WORK_ORDER_BATCH_OID 
       AND STAT.STATUS = 'Shipped'
       )
      WHERE R = 1
      ORDER BY 1
    )SRC
      ON (TGT.WORK_ORDER_BATCH_OID = SRC.WORK_ORDER_BATCH_OID)          
      WHEN MATCHED THEN
       UPDATE 
        SET TGT.SHIPPED_DATE_KEY =  SRC.SHIPPED_DATE

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Insert to DIM - MART.MARKETING */

INSERT ALL 
      WHEN MARKETING_ID IS NULL
      THEN  
          INTO MART.MARKETING
         (MARKETING_ID,MARKETING_CODE,SUB_PROGRAM_ID,SUB_PROGRAM_NAME,PROGRAM_ID,
          PROGRAM_NAME,SALES_LINE_NAME,SUB_PROGRAM_OID)
          VALUES
                  (ODS.MARKETING_ID_SEQ.NEXTVAL,
                   'Unknown '|| SUB_PROGRAM_ID||'-'|| PROGRAM_ID,
                   SUB_PROGRAM_ID,SUB_PROGRAM_NAME,PROGRAM_ID,PROGRAM_NAME,
                   SALES_LINE_NAME,SUB_PROGRAM_OID)
      SELECT  
          DISTINCT MARKETING_ID,SUB_PROGRAM_ID,SUB_PROGRAM_NAME,
          PROGRAM_ID,PROGRAM_NAME,SALES_LINE_NAME,SUB_PROGRAM_OID
      FROM RAX_APP_USER.DM_WORK_ORDER_BATCH_STG S
      WHERE NOT EXISTS ( SELECT * FROM MART.MARKETING M
                                              WHERE  S.SUB_PROGRAM_OID = M.SUB_PROGRAM_OID)

&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Insert to DIM - MART.ACCOUNT */

INSERT ALL
      WHEN ACCOUNT_ID IS NULL
      THEN
          INTO MART.ACCOUNT (ACCOUNT_ID,LIFETOUCH_ID,LPIP_PID,ACCOUNT_CLASSIFICATION_CODE,
                                                NACAM_OVERALL_CLASS_NAME,NACAM_SENIORS_CLASS_NAME)
           VALUES  (ODS.ACCOUNT_ID_SEQ.NEXTVAL,UK_LIFETOUCH_ID,'.','.','.','.')
      SELECT DISTINCT  ACCOUNT_ID,UK_LIFETOUCH_ID,'ACCOUNT' AS DIM_TYPE 
      FROM RAX_APP_USER.DM_WORK_ORDER_BATCH_STG S
      WHERE NOT EXISTS ( SELECT * FROM MART.ACCOUNT A
                                          WHERE  S.UK_LIFETOUCH_ID = A.LIFETOUCH_ID)

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Insert to DIM - MART.ITEM */

INSERT ALL      
      WHEN ITEM_ID IS NULL
      THEN
          INTO MART.ITEM(ITEM_ID,PACKAGE_PRODUCT_HASH,PRODUCT_DETAIL_DESCRIPTION,SOURCE_SYSTEM_NAME
                         ,ITEM_CODE,DESCRIPTION,SHORT_DESCRIPTION,ITEM_GROUP
                         ,MERCHANDISE_CATEGORY,CHARGE_TYPE,POSTING_CLASSIFICATION,SELLABLE_UNIT_ID
                         ,SELLABLE_UNIT_PAPER_UNITS,SELLABLE_UNIT_COSTS,SELLABLE_UNIT_IMAGES)         
           VALUES (MART.ITEM_ID_SEQ.NEXTVAL,'.','.','.',UK_ITEM_CODE,'.','.','.','.','.','.',0,0,0,0)
      SELECT DISTINCT ITEM_ID,UK_ITEM_CODE,'ITEM' AS DIM_TYPE 
      FROM RAX_APP_USER.DM_WORK_ORDER_BATCH_STG S
                     WHERE NOT EXISTS ( SELECT * FROM MART.ITEM I
                                              WHERE  I.ITEM_ID = S.ITEM_ID)


&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* Insert to DIM - MART.APO */

INSERT ALL      
       WHEN APO_ID IS NULL
       THEN  
           INTO MART.APO(APO_ID,APO_CODE,SOURCE_SYSTEM_NAME,SCHOOL_YEAR,SELLING_METHOD_NAME,
                                 PLANT_NAME,PHOTOGRAPHY_DATE,LIFETOUCH_ID,MARKETING_CODE,
                                 TERRITORY_CODE,APY_ID,DESCRIPTION,PRICE_PROGRAM_NAME,PHOTOGRAPHY_LOCATION,
                                 STUDIO_CODE,INTERNET_ORDER_OFFERED_IND,TERRITORY_GROUP_CODE,STUDENT_ID_IND)
          VALUES(MART.APO_ID_SEQ.NEXTVAL,UK_APO_CODE,'.','0','.',
                 '.',TO_DATE('01-01-1900','DD-MM-YYYY'),0,'.',
                 '.',0,'.','.','.',
                 '.','.','.','.') 
          SELECT DISTINCT  APO_ID,UK_APO_CODE,'APO' AS DIM_TYPE
          FROM RAX_APP_USER.DM_WORK_ORDER_BATCH_STG S    
          WHERE NOT EXISTS ( SELECT * FROM MART.APO APO
                                              WHERE  S.UK_APO_CODE = APO.APO_CODE)

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* Insert to DIM - MART.EVENT */

INSERT ALL       
       WHEN EVENT_ID IS NULL
       THEN 
            INTO MART.EVENT(EVENT_ID,
                                    JOB_NBR,
                                    SOURCE_SYSTEM,
                                    SCHOOL_YEAR,
                                    SEASON_NAME,
                                    SELLING_METHOD_NAME,
                                    JOB_NBR_CHAR9,
                                    JOB_NBR_CHAR10,
                                    BID_IND,
                                    PDK_IND,
                                    PDK_PARTNBR,
                                    RETAKE_IND,
                                    RETAKE_NBR,
                                    SHIPPED_IND,
                                    PAID_IND,
                                    PREJOB_IND,
                                    CMSN_STATUS_CODE,
                                    PLANT_CODE,
                                    PLANT_NAME,
                                    SOURCE_SYSTEM_EVENT_ID,
                                    PROJECTION_JOB_IND,
                                    JOB_TICKET_ONLY_IND,
                                    SERVICE_ONLY_IND,
                                    OUTSIDE_JOB_IND,
                                    RELATED_JOBS_CODE,
                                    JOB_CLASSIFICATION_NAME,
                                    PHOTOGRAPHY_DATE,
                                    PLANT_RECEIPT_DATE,
                                    SHIP_DATE,
                                    FIRST_DEPOSIT_DATE,
                                    VISION_COMMIT_DATE,
                                    FINAL_DATE,
                                    BULL_FLAG,
                                    VISION_FLAG,
                                    LIFETOUCH_ID,
                                    LOCATION_CODE,
                                    MARKETING_CODE,
                                    FLYER,
                                    CANCEL_IND,
                                    ALPHA_SORT_CODE,
                                    ALPHA_PLUS_CODE,
                                    PRINT_ALBUM_CODE,
                                    STAFF_COMPOSITE_CODE,
                                    GROUP_COMPOSITE_LATER_CODE,
                                    GROUP_COMPOSITE_NAME_CODE,
                                    CAMERA_TYPE,
                                    PVL_NEEDED_IND,
                                    JOB_DELAYED_IND,
                                    BARCODED_SERVICES_IND,
                                    TERRITORY_CODE,
                                    APY_ID,
                                    SUB_PROGRAM_NAME,
                                    FISCAL_YEAR,
                                    APY_BID_IND,
                                    AT_RISK_IND,
                                    BOOKING_STATUS,
                                    VISION_EMPLOYEE_CODE,
                                    INCENTIVE_ACQUISITION_IND,
                                    ACQUIRED_BUSINESS_NAME,
                                    ACQUISITION_DATE,
                                    RETENTION_CODE,
                                    CURRENT_YEAR_SELLING_METHODS,
                                    PRIOR_YEAR_SELLING_METHODS,
                                    CURRENT_YEAR_MKT_CODES,
                                    PRIOR_YEAR_MKT_CODES,
                                    EVENT_BOOKING_STATUS,
                                    BOOKING_STATUS_REASON_ID,
                                    LOST_TO_COMPETITOR_ID,
                                    AT_RISK_REASON_ID,
                                    AT_RISK_COMPETITOR_ID,
                                    PVL_IND,
                                    ROLLOVER_JOB_IND,
                                    SETCODE,
                                    VISION_PHOTO_DATE_A,
                                    VISION_PHOTO_DATE_B)
                          VALUES (ODS.EVENT_ID_SEQ.NEXTVAL,
                                  UK_JOB_NBR,
                                  '.',
                                  0,
                                  '.',
                                  '.',
                                  '.',
                                  '.',
                                  '.',
                                  '.',
                                  '.',
                                  '.',
                                  0,
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    0,
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    TO_DATE('01-01-1900','DD-MM-YYYY'),
                                    TO_DATE('01-01-1900','DD-MM-YYYY'),
                                    TO_DATE('01-01-1900','DD-MM-YYYY'),
                                    TO_DATE('01-01-1900','DD-MM-YYYY'),
                                    TO_DATE('01-01-1900','DD-MM-YYYY'),
                                    TO_DATE('01-01-1900','DD-MM-YYYY'),
                                    '.',
                                    '.',
                                    0,
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    0,
                                    '.',
                                    0,
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    TO_DATE('01-01-1900','DD-MM-YYYY'),
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    '.',
                                    0,
                                    0,
                                    0,
                                    0,
                                    '.',
                                    '.',
                                    '.',
                                    TO_DATE('01-01-1900','DD-MM-YYYY'),
                                    TO_DATE('01-01-1900','DD-MM-YYYY')
                                 )
               SELECT DISTINCT EVENT_ID,UK_JOB_NBR,'EVENT' AS DIM_TYPE 
               FROM RAX_APP_USER.DM_WORK_ORDER_BATCH_STG S
               WHERE NOT EXISTS (SELECT * FROM MART.EVENT EVENT
                                                  WHERE S.UK_JOB_NBR = EVENT.JOB_NBR)


&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* Insert to DIM - MART.ORGANIZATION */

INSERT ALL      
       WHEN ORGANIZATION_ID IS NULL
       THEN  
           INTO MART.ORGANIZATION(ORGANIZATION_ID,TERRITORY_CODE,AMS_ORGANIZATION_NAME,
                                                          AMS_COMPANY_NAME,AMS_BUSINESS_UNIT_NAME,COMMISSION_IND)
                      VALUES(ODS.ORGANIZATION_ID_SEQ.NEXTVAL,UK_TERRITORY_CODE,'.','.','.','.')                                                         
           SELECT DISTINCT ORGANIZATION_ID,UK_TERRITORY_CODE,'ORG' AS DIM_TYPE 
           FROM RAX_APP_USER.DM_WORK_ORDER_BATCH_STG S
           WHERE NOT EXISTS ( SELECT * FROM MART.ORGANIZATION ORG
                                               WHERE  S.UK_TERRITORY_CODE = ORG.TERRITORY_CODE)

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Rebuild Temp_Stage Table */



MERGE INTO RAX_APP_USER.DM_WORK_ORDER_BATCH_STG TGT 
    USING  
 (  
    SELECT STG.WORK_ORDER_BATCH_OID,ORGANIZATION.ORGANIZATION_ID,APO.APO_ID,ACCOUNT.ACCOUNT_ID,
    MARKETING.MARKETING_ID,ITEM.ITEM_ID,EVENT.EVENT_ID
    FROM 
    RAX_APP_USER.DM_WORK_ORDER_BATCH_STG STG,
    MART.ORGANIZATION ORGANIZATION,
    MART.APO APO,
    MART.ACCOUNT ACCOUNT,
    MART.MARKETING MARKETING,
    MART.ITEM ITEM,
    MART.EVENT EVENT
    WHERE 
    (
       STG.ORGANIZATION_ID IS NULL OR STG.APO_ID IS NULL 
    OR STG.ACCOUNT_ID IS NULL OR STG.MARKETING_ID IS NULL
    OR STG.ITEM_ID IS NULL OR STG.EVENT_ID IS NULL
    )
    AND STG.UK_TERRITORY_CODE = ORGANIZATION.TERRITORY_CODE
    AND STG.UK_APO_CODE = APO.APO_CODE
    AND STG.UK_LIFETOUCH_ID = ACCOUNT.LIFETOUCH_ID    
    AND STG.SUB_PROGRAM_OID = MARKETING.SUB_PROGRAM_OID   
    AND STG.UK_ITEM_CODE = ITEM.ITEM_CODE
    AND STG.UK_JOB_NBR = EVENT.JOB_NBR    
    )SRC
      ON (TGT.WORK_ORDER_BATCH_OID = SRC.WORK_ORDER_BATCH_OID)          
    WHEN MATCHED THEN
    UPDATE 
     SET  
          TGT.MARKETING_ID             =  SRC.MARKETING_ID,
          TGT.ACCOUNT_ID               =  SRC.ACCOUNT_ID,
          TGT.ITEM_ID                  =  SRC.ITEM_ID,
          TGT.APO_ID                   =  SRC.APO_ID,
          TGT.EVENT_ID                 =  SRC.EVENT_ID,
          TGT.ORGANIZATION_ID          =  SRC.ORGANIZATION_ID  

&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* Calculate Dates */


MERGE INTO RAX_APP_USER.DM_WORK_ORDER_BATCH_STG TGT
USING
(
SELECT 
STG.WORK_ORDER_BATCH_OID,
STG.BATCH_CREATE_DATE_KEY,
STG.READY_FULLFILLMENT_DATE_KEY,
STG.COMPLETE_DATE_KEY,
 (
 SELECT MIN(DATE_KEY)FROM
 (SELECT DATE_KEY,row_number() over(order by DATE_KEY)rn  FROM MART.TIME
 WHERE UPPER(DAY_NAME) NOT IN ('SAT','SUN') AND HOLIDAY_IND <> 'Y'
 )
 where  DATE_KEY >= TRUNC(STG.READY_FULLFILLMENT_DATE_KEY)
 )AS CALC_READY_FULLFILL_DATE_KEY,
 (
 SELECT MIN (DATE_KEY) FROM
 (SELECT DATE_KEY,row_number() over(order by DATE_KEY)rn  FROM MART.TIME
  WHERE UPPER(DAY_NAME) NOT IN ('SAT','SUN') AND HOLIDAY_IND <> 'Y'
 )
 where DATE_KEY >= TRUNC(STG.COMPLETE_DATE_KEY) 
 )AS CALC_COMPLETE_DATE_KEY
FROM 
RAX_APP_USER.DM_WORK_ORDER_BATCH_STG STG
WHERE 1 = 1
   AND READY_FULLFILLMENT_DATE_KEY IS NOT NULL
   AND COMPLETE_DATE_KEY IS NOT NULL
)SRC
ON (TGT.WORK_ORDER_BATCH_OID = SRC.WORK_ORDER_BATCH_OID)
WHEN MATCHED THEN
UPDATE
	SET
   	  TGT.CALC_READY_FULLFILL_DATE_KEY  = SRC.CALC_READY_FULLFILL_DATE_KEY,
                        TGT.CALC_COMPLETE_DATE_KEY = SRC.CALC_COMPLETE_DATE_KEY

&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* Calculate days between Fullfillment Start Date and Completion Day */

MERGE INTO RAX_APP_USER.DM_WORK_ORDER_BATCH_STG TGT
USING
(
SELECT 
WORK_ORDER_BATCH_OID,
CALC_COMPLETE_DATE_KEY,
CALC_READY_FULLFILL_DATE_KEY,
COUNT(B.DATE_KEY) AS FULLFILL_COMPLETE_DAYS
FROM 
             RAX_APP_USER.DM_WORK_ORDER_BATCH_STG STG,
             (SELECT * FROM MART.TIME WHERE DAY_NAME NOT IN ('Sat','Sun'))B
WHERE 1 = 1
AND CALC_READY_FULLFILL_DATE_KEY IS NOT NULL 
AND CALC_COMPLETE_DATE_KEY IS NOT NULL
AND  B.DATE_KEY BETWEEN  TRUNC(CALC_READY_FULLFILL_DATE_KEY) and TRUNC(CALC_COMPLETE_DATE_KEY)
AND COMPLETE_DATE_KEY IS NOT NULL 
AND READY_FULLFILLMENT_DATE_KEY IS NOT NULL 
GROUP BY WORK_ORDER_BATCH_OID,
         CALC_COMPLETE_DATE_KEY,
         CALC_READY_FULLFILL_DATE_KEY
)SRC
ON (TGT.WORK_ORDER_BATCH_OID = SRC.WORK_ORDER_BATCH_OID)
WHEN MATCHED THEN
UPDATE
SET
   TGT.FULLFILL_COMPLETE_DAYS = SRC.FULLFILL_COMPLETE_DAYS

&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* Calculate OTD Flag for Completed Batches  (Service  Items Only) */

MERGE INTO RAX_APP_USER.DM_WORK_ORDER_BATCH_STG TGT
USING
(
SELECT 
WORK_ORDER_BATCH_OID,
FULLFILL_COMPLETE_DAYS,
CASE WHEN FULLFILL_COMPLETE_DAYS <= LKP.FULLFILLMENT_COMPLETE_STD_DAYS THEN 'Y'
     ELSE 'N'
     END FLAG
FROM 
RAX_APP_USER.DM_WORK_ORDER_BATCH_STG STG,
MART.TIME TIME,
ODS_STAGE.ORDERS_STANDARD_DAYS_LKP LKP
WHERE 1 = 1     
     AND STG.FULLFILL_COMPLETE_DAYS IS NOT NULL 
     AND TRUNC(STG.COMPLETE_DATE_KEY) = TIME.DATE_KEY         
     AND TIME.FISCAL_YEAR = LKP.FISCAL_YEAR
     AND UPPER(TIME.SEASON_NAME) = UPPER(LKP.SEASON_NAME)
     AND UPPER(STG.CHARGEBACK_CATEGORY) = UPPER(LKP.CHARGEBACK_CATEGORY)
     AND UPPER(STG.CHARGEBACK_CATEGORY) = 'SERVICEITEM'   
)SRC
ON (TGT.WORK_ORDER_BATCH_OID = SRC.WORK_ORDER_BATCH_OID)
WHEN MATCHED THEN
UPDATE
SET
   TGT.FULLFILL_COMPLETE_OT_FLAG = SRC.FLAG

&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* Update Flag for Incomplete Batches (Service  Items Only) */

MERGE INTO RAX_APP_USER.DM_WORK_ORDER_BATCH_STG  TGT
USING  
    (  
     SELECT 
          S.WORK_ORDER_BATCH_OID,
          S.BATCH_COMPLETE_FLAG
     FROM 
     RAX_APP_USER.DM_WORK_ORDER_BATCH_STG S
     WHERE  1 = 1
     AND ( COMPLETE_DATE_KEY IS NULL            
           OR READY_FULLFILLMENT_DATE_KEY IS NULL) 
     AND S.CHARGEBACK_CATEGORY = 'ServiceItem'
     ) SRC
       ON (TGT.WORK_ORDER_BATCH_OID = SRC.WORK_ORDER_BATCH_OID)          
       WHEN MATCHED THEN
        UPDATE 
        SET TGT.FULLFILL_COMPLETE_OT_FLAG =  'U'

&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* Update Flag for Incomplete Batches (Service  Items Only) */

-- Fix Data Issue
-- When CALC_READY_FULLFILL_DATE_KEY > CALC_COMPLETE_DATE_KEY  


MERGE INTO RAX_APP_USER.DM_WORK_ORDER_BATCH_STG  TGT
USING  
    (  
     SELECT
     WORK_ORDER_BATCH_OID, 
     CASE WHEN CALC_READY_FULLFILL_DATE_KEY > CALC_COMPLETE_DATE_KEY  
     THEN 'Y'
     END
     FROM
     RAX_APP_USER.DM_WORK_ORDER_BATCH_STG
     WHERE CHARGEBACK_CATEGORY = 'ServiceItem'
     AND CALC_READY_FULLFILL_DATE_KEY > CALC_COMPLETE_DATE_KEY
     ) SRC
       ON (TGT.WORK_ORDER_BATCH_OID = SRC.WORK_ORDER_BATCH_OID)          
       WHEN MATCHED THEN
        UPDATE 
        SET TGT.FULLFILL_COMPLETE_OT_FLAG =  'U'

&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* Calculate the Flag (for Non Service Items only) */

MERGE INTO RAX_APP_USER.DM_WORK_ORDER_BATCH_STG  TGT
USING
(
SELECT 
WORK_ORDER_BATCH_OID
FROM 
RAX_APP_USER.DM_WORK_ORDER_BATCH_STG STG
WHERE 1 = 1       
  AND UPPER(STG.CHARGEBACK_CATEGORY) <> 'SERVICEITEM'       
)SRC
ON (TGT.WORK_ORDER_BATCH_OID = SRC.WORK_ORDER_BATCH_OID)
WHEN MATCHED THEN
UPDATE
SET
   TGT.FULLFILL_COMPLETE_OT_FLAG = 'U'

&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* Update Work Order Junk DIM ID  (Service Items & Non Service Items) */

MERGE INTO RAX_APP_USER.DM_WORK_ORDER_BATCH_STG  TGT
    USING  
    (  
     SELECT 
          S.WORK_ORDER_BATCH_OID,S.BATCH_COMPLETE_FLAG,
          S.FULLFILL_COMPLETE_OT_FLAG,JUNK.WORK_ORDER_BATCH_JUNK_ID
     FROM 
          RAX_APP_USER.DM_WORK_ORDER_BATCH_STG S, 
          MART.WORK_ORDER_BATCH_JUNK_DIM JUNK                   
     WHERE  1 = 1
     AND  S.FULLFILL_COMPLETE_OT_FLAG = JUNK.FULLFILL_COMPLETE_OT_FLAG   
     AND  S.LAB = JUNK.LAB                                   
     )SRC
      ON (TGT.WORK_ORDER_BATCH_OID = SRC.WORK_ORDER_BATCH_OID)          
      WHEN MATCHED THEN
       UPDATE 
       SET TGT.WORK_ORDER_BATCH_JUNK_ID =  SRC.WORK_ORDER_BATCH_JUNK_ID

&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* Update Work Order Junk DIM ID (For entries Non matching to DIM) */

MERGE INTO RAX_APP_USER.DM_WORK_ORDER_BATCH_STG  TGT
    USING  
    (  
     SELECT 
          S.WORK_ORDER_BATCH_OID
     FROM  RAX_APP_USER.DM_WORK_ORDER_BATCH_STG S 
     WHERE S.WORK_ORDER_BATCH_JUNK_ID IS NULL                                 
     )SRC
      ON (TGT.WORK_ORDER_BATCH_OID = SRC.WORK_ORDER_BATCH_OID)          
      WHEN MATCHED THEN
       UPDATE 
        SET TGT.WORK_ORDER_BATCH_JUNK_ID =  -1

&


/*-----------------------------------------------*/
/* TASK No. 32 */
/* Merge into Target Table */

MERGE INTO MART.WORK_ORDER_BATCH_FACT  TGT
    USING  
    (  
     SELECT  WORK_ORDER_BATCH_OID,WORK_ORDER_BATCH_JUNK_ID,MARKETING_ID,
        MARKETING_CODE,SALES_LINE_NAME,PROGRAM_NAME,PROGRAM_ID,SUB_PROGRAM_OID,
        SUB_PROGRAM_ID,SUB_PROGRAM_NAME,ACCOUNT_ID,UK_LIFETOUCH_ID,ITEM_ID,
        UK_ITEM_CODE,APO_ID,UK_APO_CODE,EVENT_ID,UK_JOB_NBR,ORGANIZATION_ID,
        UK_TERRITORY_CODE,SHIPMENT_NO,SHIPMENT_KEY,PARENT_ORDER_HEADER_OID,LAB,
        BIN_LOCATION,BATCH_ID, BATCH_CREATE_DATE_KEY,READY_FULLFILLMENT_DATE_KEY,
        PRINT_DATE_KEY,COMPLETE_DATE_KEY,BINNED_DATE_KEY,PACKED_DATE_KEY,SHIPPED_DATE_KEY,
        BATCH_STATUS,BATCH_STATUS_DESC,BATCH_COMPLETE_FLAG,DEVICE_GROUP,
        FULFILLMENT_TYPE,REQ_SHIP_DATE_KEY,REQ_DELIVERY_DATE_KEY,AVAILABLE_DATE_KEY,
        TOTAL_WORK_ORDERS,TOTAL_TASKS,TOTAL_INCOMPLETE_TASKS,TOTAL_COMPLETED_TASKS,
        START_PAGE,END_PAGE,TOTAL_PAGES,MAKEOVER_COMMENT,MAKEOVER_REASON,REASON_DESC,
        CANCEL_COMMENT,MART_CREATE_DATE,MART_MODIFY_DATE,CALC_READY_FULLFILL_DATE_KEY,
        CALC_COMPLETE_DATE_KEY,FULLFILL_COMPLETE_DAYS,FULLFILL_COMPLETE_OT_FLAG,
        MANUFACTURER_ITEM,BOC_BATCH_ID,TOTAL_ORDERS,BUYER_COUNT,MAGNET,BUTTONS,PLAQUES,
        TRADER_CARDS,STANDARD_PRINTS,TP16X20,TP11X14
     FROM RAX_APP_USER.DM_WORK_ORDER_BATCH_STG  S
    )SRC
      ON (TGT.WORK_ORDER_BATCH_OID = SRC.WORK_ORDER_BATCH_OID)          
  WHEN MATCHED THEN
    UPDATE 
    SET      
    TGT.MARKETING_ID                    		= SRC.MARKETING_ID,
    TGT.ACCOUNT_ID                      		= SRC.ACCOUNT_ID, 
    TGT.ITEM_ID                         		= SRC.ITEM_ID,
    TGT.APO_ID                          		= SRC.APO_ID,
    TGT.EVENT_ID                        		= SRC.EVENT_ID,
    TGT.JOB_TICKET_ORG_ID               		= SRC.ORGANIZATION_ID,
    TGT.WORK_ORDER_BATCH_JUNK_ID        	= SRC.WORK_ORDER_BATCH_JUNK_ID,
    TGT.SHIPMENT_OID                    	         	= NULL,
    TGT.PARENT_ORDER_HEADER_OID         	= SRC.PARENT_ORDER_HEADER_OID,
    TGT.BATCH_ID                                                         = SRC.BATCH_ID,    
    TGT.BATCH_CREATE_DATE_KEY           	= SRC.BATCH_CREATE_DATE_KEY,
    TGT.READY_FULLFILLMENT_DATE_KEY     	= SRC.READY_FULLFILLMENT_DATE_KEY,
    TGT.PRINT_DATE_KEY                  		= SRC.PRINT_DATE_KEY,
    TGT.COMPLETE_DATE_KEY               		= SRC.COMPLETE_DATE_KEY,
    TGT.BINNED_DATE_KEY                 		= SRC.BINNED_DATE_KEY,
    TGT.PACKED_DATE_KEY                 		= SRC.PACKED_DATE_KEY,
    TGT.SHIPPED_DATE_KEY                		= SRC.SHIPPED_DATE_KEY,
    TGT.AVAILABLE_DATE_KEY              		= SRC.AVAILABLE_DATE_KEY,       
    TGT.STATUS_DESC                     		= SRC.BATCH_STATUS_DESC,
    TGT.TOTAL_TASKS                     		= SRC.TOTAL_TASKS,       
    TGT.TOTAL_COMPLTD_TASKS             	= SRC.TOTAL_COMPLETED_TASKS,       
    TGT.TOTAL_PAGES                     		= SRC.TOTAL_PAGES,
    TGT.TOTAL_WORK_ORDERS               	= SRC.TOTAL_WORK_ORDERS,
    TGT.DEVICE_GROUP                    		= SRC.DEVICE_GROUP,
    TGT.FULFILLMENT_TYPE                		= SRC.FULFILLMENT_TYPE,
    TGT.START_PAGE                      		= SRC.START_PAGE,
    TGT.END_PAGE                        		= SRC.END_PAGE,
    TGT.MAKEOVER_REASON                 		= SRC.MAKEOVER_REASON,
    TGT.REASON_DESC                     		= SRC.REASON_DESC,
    TGT.CANCEL_COMMENT                  		= SRC.CANCEL_COMMENT,
    TGT.BIN_LOCATION                    		= SRC.BIN_LOCATION,    
    TGT.ORDER_NO                        		= NULL,
    TGT.MART_MODIFY_DATE                		= SYSDATE,
    TGT.CALC_READY_FULLFILL_DATE_KEY    	= SRC.CALC_READY_FULLFILL_DATE_KEY,
    TGT.CALC_COMPLETE_DATE_KEY          	= SRC.CALC_COMPLETE_DATE_KEY,
    TGT.READY_FULLFILL_COMP_DAYS        	= SRC.FULLFILL_COMPLETE_DAYS,
    TGT.MANUFACTURER_ITEM       		= SRC.MANUFACTURER_ITEM,
    TGT.BOC_BATCH_ID 			= SRC.BOC_BATCH_ID,
    TGT.TOTAL_ORDERS 			= SRC.TOTAL_ORDERS,
    TGT.BUYER_COUNT 			= SRC.BUYER_COUNT,
    TGT.MAGNET 			= SRC.MAGNET,
    TGT.BUTTONS 			= SRC.BUTTONS,
    TGT.PLAQUES 			= SRC.PLAQUES,
    TGT.TRADER_CARDS 			= SRC.TRADER_CARDS,
    TGT.STANDARD_PRINTS 		= SRC.STANDARD_PRINTS,
    TGT.TP16X20 			= SRC.TP16X20,
    TGT.TP11X14 			= SRC.TP11X14
 WHEN NOT MATCHED THEN 
 INSERT (TGT.WORK_ORDER_BATCH_OID,TGT.MARKETING_ID,TGT.ACCOUNT_ID,TGT.ITEM_ID,
    TGT.APO_ID,TGT.EVENT_ID,TGT.JOB_TICKET_ORG_ID,TGT.WORK_ORDER_BATCH_JUNK_ID,
    TGT.SHIPMENT_OID,TGT.PARENT_ORDER_HEADER_OID,TGT.BATCH_ID,TGT.BATCH_CREATE_DATE_KEY,
    TGT.READY_FULLFILLMENT_DATE_KEY,TGT.PRINT_DATE_KEY,TGT.COMPLETE_DATE_KEY,
    TGT.BINNED_DATE_KEY,TGT.PACKED_DATE_KEY,TGT.SHIPPED_DATE_KEY,TGT.AVAILABLE_DATE_KEY,       
    TGT.STATUS_DESC,TGT.TOTAL_TASKS,TGT.TOTAL_COMPLTD_TASKS,TGT.TOTAL_PAGES,
    TGT.TOTAL_WORK_ORDERS,TGT.DEVICE_GROUP,TGT.FULFILLMENT_TYPE,TGT.START_PAGE,
    TGT.END_PAGE,TGT.MAKEOVER_REASON,TGT.REASON_DESC,TGT.CANCEL_COMMENT,    
    TGT.BIN_LOCATION,TGT.ORDER_NO,TGT.MART_CREATE_DATE,TGT.MART_MODIFY_DATE,
    TGT.CALC_READY_FULLFILL_DATE_KEY,TGT.CALC_COMPLETE_DATE_KEY,TGT.READY_FULLFILL_COMP_DAYS,
    TGT.MANUFACTURER_ITEM,TGT.BOC_BATCH_ID,TGT.TOTAL_ORDERS,TGT.BUYER_COUNT,TGT.MAGNET,
    TGT.BUTTONS,TGT.PLAQUES,TGT.TRADER_CARDS,TGT.STANDARD_PRINTS,TGT.TP16X20,TGT.TP11X14
    )
    VALUES
    (
    SRC.WORK_ORDER_BATCH_OID,SRC.MARKETING_ID,SRC.ACCOUNT_ID,SRC.ITEM_ID,
    SRC.APO_ID,SRC.EVENT_ID,SRC.ORGANIZATION_ID,SRC.WORK_ORDER_BATCH_JUNK_ID,
    NULL,SRC.PARENT_ORDER_HEADER_OID,SRC.BATCH_ID,SRC.BATCH_CREATE_DATE_KEY,
    SRC.READY_FULLFILLMENT_DATE_KEY,SRC.PRINT_DATE_KEY,SRC.COMPLETE_DATE_KEY,
    SRC.BINNED_DATE_KEY,SRC.PACKED_DATE_KEY,SRC.SHIPPED_DATE_KEY,SRC.AVAILABLE_DATE_KEY,
    SRC.BATCH_STATUS_DESC,SRC.TOTAL_TASKS,SRC.TOTAL_COMPLETED_TASKS,       
    SRC.TOTAL_PAGES,SRC.TOTAL_WORK_ORDERS,SRC.DEVICE_GROUP,SRC.FULFILLMENT_TYPE,
    SRC.START_PAGE,SRC.END_PAGE,SRC.MAKEOVER_REASON,SRC.REASON_DESC,SRC.CANCEL_COMMENT,
    SRC.BIN_LOCATION,NULL,SYSDATE,SYSDATE,SRC.CALC_READY_FULLFILL_DATE_KEY,
    SRC.CALC_COMPLETE_DATE_KEY,SRC.FULLFILL_COMPLETE_DAYS,
    SRC.MANUFACTURER_ITEM,SRC.BOC_BATCH_ID,SRC.TOTAL_ORDERS,SRC.BUYER_COUNT,SRC.MAGNET,
    SRC.BUTTONS,SRC.PLAQUES,SRC.TRADER_CARDS,SRC.STANDARD_PRINTS,SRC.TP16X20,SRC.TP11X14
   )

&


/*-----------------------------------------------*/
/* TASK No. 33 */
/* Update OrderLine Fact Table (Merge the Work Order Batch oid) */

MERGE INTO MART.ORDER_LINE_FACT TGT
USING  
     (              
       SELECT     
       WORK_ORDER_OID,WORK_ORDER_BATCH_OID,
       ORDER_LINE_OID,WORK_ORDER_BATCH_JUNK_ID
       FROM(
            SELECT MIN(WORK_ORDER_OID) AS WORK_ORDER_OID,
                         MIN(WORK_ORDER_BATCH_OID) AS WORK_ORDER_BATCH_OID,
                         ORDER_LINE_OID AS ORDER_LINE_OID,
                         MIN(WORK_ORDER_BATCH_JUNK_ID) AS WORK_ORDER_BATCH_JUNK_ID
            FROM
            (SELECT          
                WO.WORK_ORDER_OID,
                STG.WORK_ORDER_BATCH_OID,
                WO.ORDER_LINE_OID,
                STG.WORK_ORDER_BATCH_JUNK_ID,
                ROW_NUMBER() OVER (PARTITION BY STAT.WORK_ORDER_BATCH_OID,WO.ORDER_LINE_OID
                                   ORDER BY STAT.STATUS_DATE DESC) R                 
                FROM
                    RAX_APP_USER.DM_WORK_ORDER_BATCH_STG STG,
                    MART.WORK_ORDER_BATCH_FACT WOBF,
                    ODS_OWN.WORK_ORDER WO,
                    ODS_OWN.WORK_ORDER_BATCH_STATUS STAT
                WHERE 1 = 1
                AND STG.WORK_ORDER_BATCH_OID     = WOBF.WORK_ORDER_BATCH_OID 
                AND WOBF.WORK_ORDER_BATCH_OID    = WO.WORK_ORDER_BATCH_OID
                AND STG.WORK_ORDER_BATCH_OID     = STAT.WORK_ORDER_BATCH_OID 
                AND STAT.STATUS =  'Complete'
                 )
                WHERE R = 1
                GROUP BY ORDER_LINE_OID
                ORDER BY 1
              )S
             WHERE NOT EXISTS 
              ( SELECT 1 FROM MART.ORDER_LINE_FACT T
                     WHERE T.ORDER_LINE_OID = S.ORDER_LINE_OID
                     AND T.WORK_ORDER_BATCH_OID = S.WORK_ORDER_BATCH_OID
                     AND T.WORK_ORDER_BATCH_JUNK_ID = S.WORK_ORDER_BATCH_JUNK_ID)                                                    
     )SRC
      ON (TGT.ORDER_LINE_OID = SRC.ORDER_LINE_OID)          
    WHEN MATCHED THEN
    UPDATE 
    SET              
            TGT.WORK_ORDER_BATCH_OID            = SRC.WORK_ORDER_BATCH_OID,            
            TGT.WORK_ORDER_BATCH_JUNK_ID    = SRC.WORK_ORDER_BATCH_JUNK_ID,            
            TGT.MART_MODIFY_DATE                      = SYSDATE

&


/*-----------------------------------------------*/
/* TASK No. 34 */
/* Drop Temp_Stage Table */

DROP TABLE RAX_APP_USER.DM_WORK_ORDER_BATCH_STG

&


/*-----------------------------------------------*/
/* TASK No. 35 */
/* Update CDC Load Status */

UPDATE ODS.DW_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE DW_TABLE_NAME=:v_cdc_load_table_name

&


/*-----------------------------------------------*/
/* TASK No. 36 */
/* Insert Audit Record */

INSERT INTO ODS_ETL_OWNER.DW_CDC_LOAD_STATUS_AUDIT
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
'WORK_ORDER_BATCH_FACT_PKG',
'014',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date_ODS_DM, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          ),
:v_cdc_overlap,
SYSDATE)



&


/*-----------------------------------------------*/
