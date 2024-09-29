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
/* Drop Temp_Stage Table IF EXISTS */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.DM_ORDER_LINE_STG';
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
/* Create Temp_Stage Table */


CREATE TABLE RAX_APP_USER.DM_ORDER_LINE_STG
(
  ORDER_LINE_OID           NUMBER ,
  MARKETING_ID               NUMBER ,
  MARKETING_CODE         VARCHAR2(100),
  SALES_LINE_NAME         VARCHAR2(100),
  PROGRAM_NAME            VARCHAR2(100),
  PROGRAM_ID                  NUMBER,  
  SUB_PROGRAM_OID       NUMBER,
  SUB_PROGRAM_ID          NUMBER,
  SUB_PROGRAM_NAME    VARCHAR2(100),
  ACCOUNT_ID                   NUMBER ,
  UK_LIFETOUCH_ID          VARCHAR2(100),
  ITEM_ID                           NUMBER ,
  UK_ITEM_CODE               VARCHAR2(100), 
  APO_ID                            NUMBER ,
  UK_APO_CODE                VARCHAR2(100),
  EVENT_ID                        NUMBER ,
  UK_JOB_NBR                   VARCHAR2(100),
  ORGANIZATION_ID         NUMBER,
  UK_TERRITORY_CODE    VARCHAR2(100),
  ASSIGNMENT_ID              NUMBER,
  UK_APO_LIFETOUCH_ID   NUMBER,  
  ORDER_HEADER_OID       NUMBER ,
  SUBJECT_ID                      NUMBER ,    
  ORDER_JUNK_ID    NUMBER,  
  PHOTOGRAPHY_DATE_KEY   DATE,
  PLANT_RECEIPT_DATE_KEY  DATE,
  ORDER_DATE_KEY          	      DATE,
  REQ_SHIP_DATE_KEY            DATE,
  REQ_DELIVERY_DATE_KEY   DATE,
  RELEASE_DATE_KEY              DATE,
  PRINT_DATE_KEY          	      DATE,
  ORDER_SHIP_DATE_KEY       DATE,
  UNIT_PRICE              	NUMBER,      
  ORDER_QTY               	NUMBER,
  ORDERED_QTY             	NUMBER,
  LINE_TOTAL_AMT          	NUMBER,
  HOLD_FLAG               	 VARCHAR2(1),
  LOOK_ALIAS              	 VARCHAR2(200),
  SOURCE                  	 VARCHAR2(100),
  MART_CREATE_DATE       DATE ,
  MART_MODIFY_DATE       DATE,
  SHIPPED_QTY               	 NUMBER,
  ORDER_LINE_GRAIN         VARCHAR2(50),
  SI_ORDERED_QTY            NUMBER,
  SI_SHIPPED_QTY              NUMBER
)

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Index Creation Temp_Stage Table */

CREATE INDEX RAX_APP_USER.DM_ORDER_LINE_STG_IX1 ON RAX_APP_USER.DM_ORDER_LINE_STG
(ORDER_LINE_OID)
LOGGING
NOPARALLEL

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Insert into  Temp Stage Table */

INSERT INTO RAX_APP_USER.DM_ORDER_LINE_STG
SELECT A.ORDER_LINE_OID,
A.MARKETING_ID,A.MARKETING_CODE,A.SALES_LINE_NAME,A.PROGRAM_NAME,
A.PROGRAM_ID,A.SUB_PROGRAM_OID,A.SUB_PROGRAM_ID,A.SUB_PROGRAM_NAME,
A.ACCOUNT_ID,A.UK_LIFETOUCH_ID,A.ITEM_ID,A.UK_ITEM_CODE,A.APO_ID,A.UK_APO_CODE,
A.EVENT_ID,A.UK_JOB_NBR,A.ORGANIZATION_ID,A.UK_TERRITORY_CODE,
NVL(MART.X_CURRENT_ASSIGNMENT.ASSIGNMENT_ID,-1) AS ASSIGNMENT_ID,
A.UK_APO_LIFETOUCH_ID,A.ORDER_HEADER_OID,A.SUBJECT_ID,A.ORDER_JUNK_ID,
PHOTOGRAPHY_DATE_KEY,PLANT_RECEIPT_DATE_KEY,ORDER_DATE_KEY,
REQ_SHIP_DATE_KEY,A.REQ_DEL_DATE_KEY,A.RELEASE_DATE_KEY,A.PRINT_DATE_KEY,
A.ORDER_SHIP_DATE_KEY,A.UNIT_PRICE,A.ORDER_QTY,A.ORDERED_QUANTITY,
A.LINE_TOTAL_AMT,A.HOLD_FLAG,A.LOOK_ALIAS,A.SOURCE,A.MART_CREATE_DATE,
A.MART_MODIFY_DATE,A.SHIPPED_QTY,A.ORDER_LINE_GRAIN,A.SI_ORDERED_QTY,
A.SI_SHIPPED_QTY
FROM
(
SELECT 
ODS_OWN.ORDER_LINE.ORDER_LINE_OID,
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
ODS_OWN.APO.TERRITORY_CODE UK_TERRITORY_CODE,
MART.ORGANIZATION.TERRITORY_CODE,
MART.ORGANIZATION.ORGANIZATION_ID,
ODS_OWN.APO.LIFETOUCH_ID AS UK_APO_LIFETOUCH_ID,
ODS_OWN.ORDER_HEADER.ORDER_HEADER_OID,
MART.ORDER_HEADER_FACT.SUBJECT_ID,
MART.ORDER_HEADER_FACT.ORDER_JUNK_ID,
NVL(MART.EVENT.PHOTOGRAPHY_DATE,TO_DATE('01-JAN-1900 00:00:00','DD-MON-YYYY HH24:MI:SS')) PHOTOGRAPHY_DATE_KEY,
NVL(MART.EVENT.PLANT_RECEIPT_DATE,TO_DATE('01-JAN-1900 00:00:00','DD-MON-YYYY HH24:MI:SS')) PLANT_RECEIPT_DATE_KEY,
NVL(ODS_OWN.ORDER_HEADER.ORDER_DATE,TO_DATE('01-JAN-1900 00:00:00','DD-MON-YYYY HH24:MI:SS')) ORDER_DATE_KEY,
NVL(ODS_OWN.ORDER_HEADER.REQUESTED_SHIP_DATE,TO_DATE('01-JAN-1900 00:00:00','DD-MON-YYYY HH24:MI:SS')) REQ_SHIP_DATE_KEY,
NVL(ODS_OWN.ORDER_HEADER.REQUESTED_DELIVERY_DATE,TO_DATE('01-JAN-1900 00:00:00','DD-MON-YYYY HH24:MI:SS')) REQ_DEL_DATE_KEY,
NVL(NULL,TO_DATE('01-JAN-1900 00:00:00','DD-MON-YYYY HH24:MI:SS'))RELEASE_DATE_KEY,
NVL(NULL,TO_DATE('01-JAN-1900 00:00:00','DD-MON-YYYY HH24:MI:SS'))PRINT_DATE_KEY,
NVL(ODS_OWN.ORDER_HEADER.ORDER_SHIP_DATE,TO_DATE('01/01/1900','DD/MM/YYYY'))ORDER_SHIP_DATE_KEY,
ODS_OWN.ORDER_LINE.UNIT_PRICE,
NULL AS ORDER_QTY,
ODS_OWN.ORDER_LINE.ORDERED_QUANTITY,
ODS_OWN.ORDER_LINE.LINE_TOTAL AS LINE_TOTAL_AMT,
ODS_OWN.ORDER_LINE.HOLD_FLAG,
NULL AS LOOK_ALIAS,
'ORDER_LINE' AS SOURCE,
SYSDATE AS MART_CREATE_DATE,
SYSDATE AS MART_MODIFY_DATE,
ODS_OWN.ORDER_LINE.SHIPPED_QTY,
ODS_OWN.ORDER_HEADER.PARENT_ORDER_HEADER_OID,
CASE WHEN ODS_OWN.ORDER_HEADER.PARENT_ORDER_HEADER_OID IS NULL
THEN 'Parent'
ELSE 'Child'
END ORDER_LINE_GRAIN,
ODS_OWN.ORDER_LINE.SI_ORDERED_QTY,
ODS_OWN.ORDER_LINE.SI_SHIPPED_QTY
FROM
      ODS_OWN.ORDER_LINE 
     ,ODS_OWN.ORDER_HEADER 
     ,ODS_OWN.APO 
     ,ODS_OWN.ITEM
     ,ODS_OWN.EVENT
     ,ODS_OWN.ACCOUNT     
     ,ODS_OWN.SUB_PROGRAM
     ,ODS_OWN.PROGRAM 
     ,ODS_OWN.ORGANIZATION 
     ,MART.ACCOUNT   
     ,MART.APO
     ,MART.MARKETING
     ,MART.ITEM
     ,MART.EVENT  
     ,MART.ORGANIZATION   
     ,MART.TIME PHOTOGRAPHY_TIME
     ,MART.TIME PLANT_RECEIPT_TIME
     ,MART.TIME ORDER_TIME
     ,MART.TIME REQ_SHIP_TIME
     ,MART.TIME REQ_DEL_TIME
     ,MART.TIME ORDER_SHIP_TIME 
     ,ODS.DW_CDC_LOAD_STATUS 
     ,MART.ORDER_HEADER_FACT
WHERE  1 = 1
    AND ODS_OWN.ORDER_LINE.ORDER_HEADER_OID = ODS_OWN.ORDER_HEADER.ORDER_HEADER_OID
    AND ODS_OWN.ORDER_HEADER.APO_OID = ODS_OWN.APO.APO_OID
    AND ODS_OWN.ORDER_LINE.ITEM_OID = ODS_OWN.ITEM.ITEM_OID
    AND ODS_OWN.ORDER_HEADER.EVENT_OID = ODS_OWN.EVENT.EVENT_OID
    AND ODS_OWN.APO.ACCOUNT_OID = ODS_OWN.ACCOUNT.ACCOUNT_OID    
    AND ODS_OWN.APO.SUB_PROGRAM_OID = ODS_OWN.SUB_PROGRAM.SUB_PROGRAM_OID  
    AND ODS_OWN.SUB_PROGRAM.PROGRAM_OID = ODS_OWN.PROGRAM.PROGRAM_OID    
    AND ODS_OWN.ORGANIZATION.ORGANIZATION_OID = ODS_OWN.APO.ORGANIZATION_OID
    AND NVL(ODS_OWN.APO.TERRITORY_CODE,-1) = MART.ORGANIZATION.TERRITORY_CODE(+)
    AND NVL(ODS_OWN.APO.APO_ID,-1) = MART.APO.APO_CODE(+)
    AND NVL(ODS_OWN.ACCOUNT.LIFETOUCH_ID,-1) = MART.ACCOUNT.LIFETOUCH_ID(+)    
    AND NVL(ODS_OWN.SUB_PROGRAM.SUB_PROGRAM_OID,-1) = MART.MARKETING.SUB_PROGRAM_OID(+)   
    AND NVL(ODS_OWN.ITEM.ITEM_ID,-1) = MART.ITEM.ITEM_CODE(+)
    AND NVL(ODS_OWN.EVENT.EVENT_REF_ID,-1) = MART.EVENT.JOB_NBR(+)
    AND TRUNC(MART.EVENT.PHOTOGRAPHY_DATE) = PHOTOGRAPHY_TIME.DATE_KEY(+)     
    AND TRUNC(MART.EVENT.PLANT_RECEIPT_DATE) = PLANT_RECEIPT_TIME.DATE_KEY(+)
    AND TRUNC(ODS_OWN.ORDER_HEADER.ORDER_DATE) = ORDER_TIME.DATE_KEY(+)
    AND TRUNC(ODS_OWN.ORDER_HEADER.REQUESTED_SHIP_DATE) = REQ_SHIP_TIME.DATE_KEY(+)
    AND TRUNC(ODS_OWN.ORDER_HEADER.REQUESTED_DELIVERY_DATE) = REQ_DEL_TIME.DATE_KEY(+)    
    AND TRUNC(ODS_OWN.ORDER_HEADER.ORDER_SHIP_DATE) =  ORDER_SHIP_TIME.DATE_KEY(+)
    AND ODS_OWN.ORDER_LINE.ODS_MODIFY_DATE > (ODS.DW_CDC_LOAD_STATUS.LAST_CDC_COMPLETION_DATE - 1/24)
    AND ODS_OWN.ORDER_LINE.ODS_MODIFY_DATE > SYSDATE - 3
    AND ODS.DW_CDC_LOAD_STATUS.DW_TABLE_NAME = 'ORDER_LINE_FACT'  
    AND ODS_OWN.ORDER_LINE.ORDER_HEADER_OID = MART.ORDER_HEADER_FACT.ORDER_HEADER_OID
    )A,
    MART.X_CURRENT_ASSIGNMENT
    WHERE 
    A.UK_APO_LIFETOUCH_ID = MART.X_CURRENT_ASSIGNMENT.LIFETOUCH_ID(+)
    AND A.PROGRAM_ID = MART.X_CURRENT_ASSIGNMENT.PROGRAM_ID(+)

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Insert into DIM_MART.MARKETING */

/*
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
      FROM RAX_APP_USER.DM_ORDER_LINE_STG S
      WHERE NOT EXISTS ( SELECT * FROM MART.MARKETING M
                                              WHERE  S.SUB_PROGRAM_OID = M.SUB_PROGRAM_OID)
*/
           

UPDATE RAX_APP_USER.DM_ORDER_LINE_STG STG
SET STG.MARKETING_ID = -1
WHERE STG.MARKETING_ID IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Insert into DIM_MART.ACCOUNT */

/*
INSERT ALL
      WHEN ACCOUNT_ID IS NULL
      THEN
          INTO MART.ACCOUNT (ACCOUNT_ID,LIFETOUCH_ID,LPIP_PID,ACCOUNT_CLASSIFICATION_CODE,
                                                NACAM_OVERALL_CLASS_NAME,NACAM_SENIORS_CLASS_NAME)
           VALUES  (ODS.ACCOUNT_ID_SEQ.NEXTVAL,UK_LIFETOUCH_ID,'.','.','.','.')
      SELECT DISTINCT  ACCOUNT_ID,UK_LIFETOUCH_ID,'ACCOUNT' AS DIM_TYPE 
      FROM RAX_APP_USER.DM_ORDER_LINE_STG S
      WHERE NOT EXISTS ( SELECT * FROM MART.ACCOUNT A
                                          WHERE  S.UK_LIFETOUCH_ID = A.LIFETOUCH_ID)
*/ 

UPDATE rax_app_user.DM_ORDER_LINE_STG STG
SET STG.ACCOUNT_ID = -1
WHERE STG.ACCOUNT_ID IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Insert into DIM_MART.ITEM */


INSERT ALL      
      WHEN ITEM_ID IS NULL
      THEN
          INTO MART.ITEM(ITEM_ID,PACKAGE_PRODUCT_HASH,PRODUCT_DETAIL_DESCRIPTION,SOURCE_SYSTEM_NAME
                         ,ITEM_CODE,DESCRIPTION,SHORT_DESCRIPTION,ITEM_GROUP
                         ,MERCHANDISE_CATEGORY,CHARGE_TYPE,POSTING_CLASSIFICATION,SELLABLE_UNIT_ID
                         ,SELLABLE_UNIT_PAPER_UNITS,SELLABLE_UNIT_COSTS,SELLABLE_UNIT_IMAGES)         
           VALUES (MART.ITEM_ID_SEQ.NEXTVAL,'.','.','.',UK_ITEM_CODE,'.','.','.','.','.','.',0,0,0,0)
      SELECT DISTINCT ITEM_ID,UK_ITEM_CODE,'ITEM' AS DIM_TYPE 
      FROM RAX_APP_USER.DM_ORDER_LINE_STG S
                     WHERE NOT EXISTS ( SELECT * FROM MART.ITEM I
                                              WHERE  I.ITEM_ID = S.ITEM_ID)

      


&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Insert into DIM_MART.APO */

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
          FROM RAX_APP_USER.DM_ORDER_LINE_STG S    
          WHERE NOT EXISTS ( SELECT * FROM MART.APO APO
                                              WHERE  S.UK_APO_CODE = APO.APO_CODE)


&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert into DIM_MART.EVENT */

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
               FROM RAX_APP_USER.DM_ORDER_LINE_STG S
               WHERE NOT EXISTS (SELECT * FROM MART.EVENT EVENT
                                                  WHERE S.UK_JOB_NBR = EVENT.JOB_NBR)






&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Insert into DIM_MART.ORGANIZATION */

/*
INSERT ALL      
       WHEN ORGANIZATION_ID IS NULL
       THEN  
           INTO MART.ORGANIZATION(ORGANIZATION_ID,TERRITORY_CODE,AMS_ORGANIZATION_NAME,
                                                          AMS_COMPANY_NAME,AMS_BUSINESS_UNIT_NAME,COMMISSION_IND)
                      VALUES(ODS.ORGANIZATION_ID_SEQ.NEXTVAL,UK_TERRITORY_CODE,'.','.','.','.')                                                         
           SELECT DISTINCT ORGANIZATION_ID,UK_TERRITORY_CODE,'ORG' AS DIM_TYPE 
           FROM RAX_APP_USER.DM_ORDER_LINE_STG S
           WHERE NOT EXISTS ( SELECT * FROM MART.ORGANIZATION ORG
                                               WHERE  S.UK_TERRITORY_CODE = ORG.TERRITORY_CODE)
*/


UPDATE rax_app_user.DM_ORDER_LINE_STG STG
SET STG.ORGANIZATION_ID = -1
WHERE STG.ORGANIZATION_ID IS NULL


&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Rebuild the Temp_Stage Table */


MERGE INTO RAX_APP_USER.DM_ORDER_LINE_STG TGT 
    USING  
 (  
    SELECT 
    STG.ORDER_LINE_OID,
    ORGANIZATION.ORGANIZATION_ID,
    APO.APO_ID,
    ACCOUNT.ACCOUNT_ID,
    MARKETING.MARKETING_ID,
    ITEM.ITEM_ID,
    EVENT.EVENT_ID
    FROM 
    RAX_APP_USER.DM_ORDER_LINE_STG STG,
    MART.ORGANIZATION ORGANIZATION,
    MART.APO APO,
    MART.ACCOUNT ACCOUNT,
    MART.MARKETING MARKETING,
    MART.ITEM ITEM,
    MART.EVENT EVENT
    WHERE 
    (
      STG.ORGANIZATION_ID IS NULL 
      OR STG.APO_ID IS NULL 
      OR STG.ACCOUNT_ID IS NULL 
      OR STG.MARKETING_ID IS NULL
      OR STG.ITEM_ID IS NULL 
      OR STG.EVENT_ID IS NULL
    )
    AND STG.UK_TERRITORY_CODE = ORGANIZATION.TERRITORY_CODE
    AND STG.UK_APO_CODE = APO.APO_CODE
    AND STG.UK_LIFETOUCH_ID = ACCOUNT.LIFETOUCH_ID    
    AND STG.SUB_PROGRAM_OID = MARKETING.SUB_PROGRAM_OID   
    AND STG.UK_ITEM_CODE = ITEM.ITEM_CODE
    AND STG.UK_JOB_NBR = EVENT.JOB_NBR    
    )SRC
      ON (TGT.ORDER_LINE_OID = SRC.ORDER_LINE_OID)          
    WHEN MATCHED THEN
    UPDATE 
    SET  
       TGT.MARKETING_ID          	=  SRC.MARKETING_ID,
       TGT.ACCOUNT_ID             	=  SRC.ACCOUNT_ID,
       TGT.ITEM_ID                      	=  SRC.ITEM_ID,
       TGT.APO_ID                       	=  SRC.APO_ID,
       TGT.EVENT_ID             	=  SRC.EVENT_ID,
       TGT.ORGANIZATION_ID      	=  SRC.ORGANIZATION_ID                                      

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Merge into Target Fact Table */


MERGE INTO MART.ORDER_LINE_FACT TGT
    USING  
    (  
         SELECT S.ORDER_LINE_OID,S.MARKETING_ID,S.ACCOUNT_ID,S.ITEM_ID,              
         S.APO_ID,S.EVENT_ID,S.ORGANIZATION_ID,S.ASSIGNMENT_ID,S.ORDER_HEADER_OID,
         S.SUBJECT_ID,S.ORDER_JUNK_ID,S.PHOTOGRAPHY_DATE_KEY,S.PLANT_RECEIPT_DATE_KEY,
         S.ORDER_DATE_KEY,S.REQ_SHIP_DATE_KEY,S.REQ_DELIVERY_DATE_KEY,S.RELEASE_DATE_KEY,
         S.PRINT_DATE_KEY,S.ORDER_SHIP_DATE_KEY,S.UNIT_PRICE,S.ORDER_QTY,S.ORDERED_QTY,
         S.LINE_TOTAL_AMT,S.HOLD_FLAG,S.LOOK_ALIAS,S.SOURCE,S.MART_CREATE_DATE,
         S.MART_MODIFY_DATE,S.SHIPPED_QTY,S.ORDER_LINE_GRAIN,S.SI_ORDERED_QTY,S.SI_SHIPPED_QTY
         FROM RAX_APP_USER.DM_ORDER_LINE_STG  S
    )SRC
      ON (TGT.ORDER_LINE_OID = SRC.ORDER_LINE_OID)          
    WHEN MATCHED THEN
    UPDATE 
     SET  
          TGT.MARKETING_ID         	=  SRC.MARKETING_ID,
          TGT.ACCOUNT_ID           	=  SRC.ACCOUNT_ID,
          TGT.ITEM_ID              	=  SRC.ITEM_ID,
          TGT.APO_ID               	=  SRC.APO_ID,
          TGT.EVENT_ID             	=  SRC.EVENT_ID,
          TGT.JOB_TICKET_ORG_ID    	=  SRC.ORGANIZATION_ID,
          TGT.ASSIGNMENT_ID        	=  SRC.ASSIGNMENT_ID,
          TGT.ORDER_HEADER_OID     	=  SRC.ORDER_HEADER_OID,
          TGT.SUBJECT_ID           	=  SRC.SUBJECT_ID,    
          TGT.ORDER_JUNK_ID   	=  SRC.ORDER_JUNK_ID,
          TGT.PHOTOGRAPHY_DATE_KEY   = SRC.PHOTOGRAPHY_DATE_KEY,
          TGT.PLANT_RECEIPT_DATE_KEY = SRC.PLANT_RECEIPT_DATE_KEY,
          TGT.ORDER_DATE_KEY         	= SRC.ORDER_DATE_KEY,
          TGT.REQ_SHIP_DATE_KEY      	= SRC.REQ_SHIP_DATE_KEY,
          TGT.REQ_DELIVERY_DATE_KEY  	= SRC.REQ_DELIVERY_DATE_KEY,
          TGT.RELEASE_DATE_KEY       	= SRC.RELEASE_DATE_KEY,
          TGT.PRINT_DATE_KEY         	= SRC.PRINT_DATE_KEY,
          TGT.ORDER_SHIP_DATE_KEY    	= SRC.ORDER_SHIP_DATE_KEY,
          TGT.UNIT_PRICE             	= SRC.UNIT_PRICE,      
          TGT.ORDERED_QTY            	= SRC.ORDERED_QTY,
          TGT.LINE_TOTAL_AMT         	= SRC.LINE_TOTAL_AMT,
          TGT.HOLD_FLAG              	= SRC.HOLD_FLAG,
          TGT.LOOK_ALIAS             	= SRC.LOOK_ALIAS,          
          TGT.MART_MODIFY_DATE       	= SYSDATE ,    
          TGT.SHIPPED_QTY                    	= SRC.SHIPPED_QTY,
          TGT.ORDER_LINE_GRAIN         	= SRC.ORDER_LINE_GRAIN,     
          TGT.SI_ORDERED_QTY                = SRC.SI_ORDERED_QTY,
          TGT.SI_SHIPPED_QTY                  = SRC.SI_SHIPPED_QTY        
  WHEN NOT MATCHED THEN 
  INSERT (TGT.ORDER_LINE_OID,TGT.MARKETING_ID,TGT.ACCOUNT_ID,TGT.ITEM_ID,              
         TGT.APO_ID,TGT.EVENT_ID,TGT.JOB_TICKET_ORG_ID,TGT.ASSIGNMENT_ID,
         TGT.ORDER_HEADER_OID,TGT.SUBJECT_ID,
         TGT.ORDER_JUNK_ID,TGT.PHOTOGRAPHY_DATE_KEY,TGT.PLANT_RECEIPT_DATE_KEY,TGT.ORDER_DATE_KEY,        
         TGT.REQ_SHIP_DATE_KEY,TGT.REQ_DELIVERY_DATE_KEY,TGT.RELEASE_DATE_KEY,TGT.PRINT_DATE_KEY,
         TGT.ORDER_SHIP_DATE_KEY,TGT.UNIT_PRICE,TGT.ORDERED_QTY,TGT.LINE_TOTAL_AMT,TGT.HOLD_FLAG,  
         TGT.LOOK_ALIAS,TGT.MART_CREATE_DATE,TGT.MART_MODIFY_DATE,TGT.SHIPPED_QTY,TGT.ORDER_LINE_GRAIN,
         TGT.SI_ORDERED_QTY,TGT.SI_SHIPPED_QTY)
         VALUES(SRC.ORDER_LINE_OID,SRC.MARKETING_ID,SRC.ACCOUNT_ID,SRC.ITEM_ID,             
         SRC.APO_ID,SRC.EVENT_ID,SRC.ORGANIZATION_ID,SRC.ASSIGNMENT_ID,SRC.ORDER_HEADER_OID,SRC.SUBJECT_ID,
         SRC.ORDER_JUNK_ID,SRC.PHOTOGRAPHY_DATE_KEY,SRC.PLANT_RECEIPT_DATE_KEY,SRC.ORDER_DATE_KEY,        
         SRC.REQ_SHIP_DATE_KEY,SRC.REQ_DELIVERY_DATE_KEY,SRC.RELEASE_DATE_KEY,SRC.PRINT_DATE_KEY,
         SRC.ORDER_SHIP_DATE_KEY,SRC.UNIT_PRICE,SRC.ORDERED_QTY,SRC.LINE_TOTAL_AMT,SRC.HOLD_FLAG,  
         SRC.LOOK_ALIAS,SYSDATE,SYSDATE,SRC.SHIPPED_QTY,SRC.ORDER_LINE_GRAIN,
         SRC.SI_ORDERED_QTY,SRC.SI_SHIPPED_QTY)
         

&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Drop Temp_Stage Table */

DROP TABLE RAX_APP_USER.DM_ORDER_LINE_STG CASCADE CONSTRAINTS

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Drop Temp_Stage Table IF EXISTS */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.DM_SHIPMENT_STG';
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
/* TASK No. 18 */
/* Create Temp_Stage Table */

CREATE TABLE RAX_APP_USER.DM_SHIPMENT_STG
(
  SHIPMENT_OID                      NUMBER  NOT NULL,
  PERSON_INFO_OID               NUMBER ,
  SHIP_NODE                     	      VARCHAR2(100 BYTE),
  SHIPMENT_NO                       VARCHAR2(40 BYTE),
  SHIP_DATE_KEY                 	DATE,
  TRACKING_NO                   	VARCHAR2(40 BYTE),
  STATUS                        		VARCHAR2(15 BYTE),
  SHIP_VIA                      		VARCHAR2(100 BYTE),
  ACTUAL_SHIPMENT_DATE          	DATE,
  ACTUAL_DELIVERY_DATE          	DATE,
  TOTAL_ACTUAL_CHARGE           	NUMBER,
  ACTUAL_FREIGHT_CHARGE         	NUMBER,
  CREATE_DATE              		DATE
)

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Insert into Temp_Stage */

        
          INSERT INTO RAX_APP_USER.DM_SHIPMENT_STG
          SELECT 
          S.SHIPMENT_OID,          
          S.PERSON_INFO_OID,
          S.SHIP_NODE,
          S.SHIPMENT_NO,
          NVL(S.SHIP_DATE,TO_DATE('01-JAN-1900 00:00:00','DD-MON-YYYY HH24:MI:SS')),
          S.TRACKING_NO,
          S.STATUS,
          S.SHIP_VIA,          
          S.ACTUAL_SHIPMENT_DATE,
          S.ACTUAL_DELIVERY_DATE,
          S.TOTAL_ACTUAL_CHARGE,
          S.ACTUAL_FREIGHT_CHARGE,
          SYSDATE          
          FROM
          ODS_OWN.SHIPMENT S,
          ODS.DW_CDC_LOAD_STATUS CDC
          WHERE 1 = 1
          AND S.ODS_MODIFY_DATE > (CDC.LAST_CDC_COMPLETION_DATE - 1/24)
          AND CDC.DW_TABLE_NAME = 'ORDER_LINE_FACT'
          AND S.ODS_MODIFY_DATE > TRUNC(SYSDATE) - 3                   


&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* Merge into Target Table */

MERGE INTO MART.SHIPMENT TGT
    USING  
    (  
     SELECT 
     SHIPMENT_OID,PERSON_INFO_OID,SHIP_NODE,
     SHIPMENT_NO,SHIP_DATE_KEY,TRACKING_NO,STATUS,SHIP_VIA,
     ACTUAL_SHIPMENT_DATE,ACTUAL_DELIVERY_DATE
     FROM
     RAX_APP_USER.DM_SHIPMENT_STG
    )SRC
      ON (TGT.SHIPMENT_OID = SRC.SHIPMENT_OID)          
  WHEN MATCHED THEN
    UPDATE 
     SET              
            TGT.PERSON_INFO_OID            = SRC.PERSON_INFO_OID,            
            TGT.SHIPMENT_NO                 	= SRC.SHIPMENT_NO,
            TGT.SHIP_DATE_KEY               	= SRC.SHIP_DATE_KEY,
            TGT.SHIP_NODE                   	= SRC.SHIP_NODE,
            TGT.TRACKING_NO                 	= SRC.TRACKING_NO,
            TGT.SHIP_VIA                    	= SRC.SHIP_VIA,
            TGT.STATUS                      	= SRC.STATUS,
            TGT.ACTUAL_SHIPMENT_DATE_KEY    = SRC.ACTUAL_SHIPMENT_DATE,
            TGT.ACTUAL_DELIVERY_DATE_KEY     = SRC.ACTUAL_DELIVERY_DATE,
            TGT.MART_MODIFY_DATE                    = SYSDATE
  WHEN NOT MATCHED THEN 
 INSERT (
        TGT.SHIPMENT_OID,PERSON_INFO_OID,TGT.SHIP_NODE,TGT.SHIPMENT_NO,
        TGT.SHIP_DATE_KEY,TGT.TRACKING_NO,TGT.STATUS,TGT.SHIP_VIA,
        TGT.ACTUAL_SHIPMENT_DATE_KEY,TGT.ACTUAL_DELIVERY_DATE_KEY,
        TGT.MART_CREATE_DATE,TGT.MART_MODIFY_DATE
        )
         VALUES(
        SRC.SHIPMENT_OID,SRC.PERSON_INFO_OID,SRC.SHIP_NODE,SRC.SHIPMENT_NO,
        SRC.SHIP_DATE_KEY,SRC.TRACKING_NO,SRC.STATUS,SRC.SHIP_VIA,
        SRC.ACTUAL_SHIPMENT_DATE,SRC.ACTUAL_DELIVERY_DATE,SYSDATE,SYSDATE
         )

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* Drop Temp_Stage Table */

DROP TABLE RAX_APP_USER.DM_SHIPMENT_STG

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* Create Temp_Stage Table */

CREATE TABLE RAX_APP_USER.DM_SHIPMENT_STG
(
  SHIPMENT_OID                      NUMBER  NOT NULL,
  SHIPMENT_LINE_OID             NUMBER  NOT NULL,
  ORDER_LINE_OID                  NUMBER  NOT NULL,
  SHIP_DATE                             DATE  	 NOT NULL,
  REQ_SHIPMENT_TO_SHIP_DAYS     	NUMBER,
  REQ_SHIPMENT_TO_SHIP_OTD_FLAG VARCHAR2(1),
  CREATE_DATE              		DATE
)

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Insert into Temp_Stage Table */

       
          INSERT INTO RAX_APP_USER.DM_SHIPMENT_STG
          SELECT 
          S.SHIPMENT_OID,
          SL.SHIPMENT_LINE_OID,             
          SL.ORDER_LINE_OID,     
          S.SHIP_DATE_KEY,                    
          S.SHIP_DATE_KEY - CASE WHEN TRUNC(OH.REQUESTED_SHIP_DATE) = '01-JAN-1900' 
                                                                OR OH.REQUESTED_SHIP_DATE IS NULL
                                           THEN S.SHIP_DATE_KEY
                                           ELSE OH.REQUESTED_SHIP_DATE END DIFF_DAYS,                                        
          CASE  WHEN S.SHIP_DATE_KEY - (CASE WHEN TRUNC(OH.REQUESTED_SHIP_DATE) = '01-JAN-1900' 
                                                                  OR OH.REQUESTED_SHIP_DATE IS NULL
                                           THEN S.SHIP_DATE_KEY
                                            ELSE OH.REQUESTED_SHIP_DATE
          END)>= 0
          THEN 'Y'
          ELSE 'N'
          END  FLAG,
          SYSDATE          
          FROM
          MART.SHIPMENT S,
          ODS_OWN.SHIPMENT_LINE SL,
          ODS_OWN.ORDER_LINE OL,
          ODS_OWN.ORDER_HEADER OH,
          ODS.DW_CDC_LOAD_STATUS CDC
          WHERE SL.SHIPMENT_OID = S.SHIPMENT_OID
          AND SL.ORDER_LINE_OID = OL.ORDER_LINE_OID
          AND OL.ORDER_HEADER_OID = OH.ORDER_HEADER_OID
          AND S.MART_MODIFY_DATE > (CDC.LAST_CDC_COMPLETION_DATE - 1/8)
          AND CDC.DW_TABLE_NAME = 'ORDER_LINE_FACT'
          AND S.MART_MODIFY_DATE > TRUNC(SYSDATE) - 3

&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* Merge Updates to MART.ORDER_LINE_FACT */


MERGE  INTO MART.ORDER_LINE_FACT TGT
USING  
    (  
      SELECT SHIPMENT_OID,SHIP_DATE,ORDER_LINE_OID,SHIPMENT_JUNK_ID,
                   REQ_SHIPMENT_TO_SHIP_DAYS,rn from
      (
      SELECT 
      STG.SHIPMENT_OID,
      STG.SHIP_DATE,
      STG.ORDER_LINE_OID,
      JUNK.SHIPMENT_JUNK_ID,
      STG.REQ_SHIPMENT_TO_SHIP_DAYS,
      row_number() over(partition by STG.ORDER_LINE_OID order by STG.SHIPMENT_OID) rn      
      FROM
        	RAX_APP_USER.DM_SHIPMENT_STG STG,        	
        	MART.SHIPMENT_JUNK_DIM JUNK
      WHERE 1 = 1
                  AND STG.REQ_SHIPMENT_TO_SHIP_OTD_FLAG = JUNK.REQ_SHIPMENT_TO_SHIP_OTD_FLAG  
        )
        where rn = 1      
    )SRC
      ON (TGT.ORDER_LINE_OID = SRC.ORDER_LINE_OID)          
    WHEN MATCHED THEN
    UPDATE 
    SET              
            TGT.SHIPMENT_OID                		= SRC.SHIPMENT_OID,            
            TGT.ORDER_SHIP_DATE_KEY                          = SRC.SHIP_DATE,
            TGT.SHIPMENT_JUNK_ID            	= SRC.SHIPMENT_JUNK_ID,
            TGT.REQ_SHIPMENT_TO_SHIP_DAYS   	= SRC.REQ_SHIPMENT_TO_SHIP_DAYS,
            TGT.MART_MODIFY_DATE            	= SYSDATE

&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* Drop Temp_Stage Table */

DROP TABLE RAX_APP_USER.DM_SHIPMENT_STG

&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* Update CDC Load Status */

UPDATE ODS.DW_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE DW_TABLE_NAME=:v_cdc_load_table_name

&


/*-----------------------------------------------*/
/* TASK No. 27 */
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
'ORDER_LINE_FACT_PKG',
'029',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date_ODS_DM, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          ),
:v_cdc_overlap,
SYSDATE)



&


/*-----------------------------------------------*/
