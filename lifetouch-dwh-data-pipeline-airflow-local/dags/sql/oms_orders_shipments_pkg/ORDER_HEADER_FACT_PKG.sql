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
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.DM_ORDER_HEADER_STG';
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

CREATE TABLE RAX_APP_USER.DM_ORDER_HEADER_STG
(
    ORDER_HEADER_OID               	NUMBER,
  ORDER_FORM_ID                 	 VARCHAR2(100),
  APO_ID                        		NUMBER,
  UK_APO_CODE                    	VARCHAR2(100), 
  ORDER_CHANNEL_ID               	NUMBER,
  UK_CHANNEL_NAME                	VARCHAR2(100),
  EVENT_ID                       		NUMBER,
  UK_JOB_NBR                     	VARCHAR2(100),  
  PRICE_PROGRAM_ID               	NUMBER,
  UK_PRICE_PROGRAM_NAME          	VARCHAR2(100),
  MARKETING_ID                   	NUMBER,
  SALES_LINE_NAME                	VARCHAR2(100),
  PROGRAM_NAME                   	VARCHAR2(100),
  PROGRAM_ID                     	NUMBER,
  SUB_PROGRAM_OID                	NUMBER,
  SUB_PROGRAM_ID                 	NUMBER,
  SUB_PROGRAM_NAME               	VARCHAR2(100), 
  ACCOUNT_ID                     	NUMBER ,
  UK_LIFETOUCH_ID                	VARCHAR2(100),
  ORGANIZATION_ID               	NUMBER,
  UK_TERRITORY_CODE             	VARCHAR2(100),
  ASSIGNMENT_ID                 	NUMBER,
  UK_APO_LIFETOUCH_ID           	NUMBER,
  SUBJECT_ID                    		NUMBER,    
  ORDER_JUNK_ID                 	NUMBER,
  MATCHED_CAPTURE_SESSION_ID    	VARCHAR2(100),
  BATCH_ID                       		VARCHAR2(100),
  SHIP_NODE                     		VARCHAR2(100),
  ORDER_NO                      	VARCHAR2(100),  
  ORDER_TYPE                  		VARCHAR2(100),
  ORDER_BUCKET               	VARCHAR2(100),
  SELLING_METHOD            	VARCHAR2(100),
  PLANT_RECEIPT_DATE_KEY       	DATE,
  UK_JOB_NBR_CS               	VARCHAR2(100),
  PLANT_RECEIPT_DATE_KEY_CS    	DATE,
  ORDER_DATE_KEY               	DATE,
  REQ_SHIP_DATE_KEY            	DATE,
  REQ_DELIVERY_DATE_KEY        	DATE, 
  ORDER_SHIP_DATE_KEY         	DATE,
  BATCH_CLOSE_DATE_KEY         	DATE,
  PLANT_RECEIPT_DATE_KEY_CS_CALC  DATE,
  ORDER_DATE_KEY_CALC             	DATE,
  ORDER_SHIP_DATE_KEY_CALC       	DATE,
  BATCH_CLOSE_DATE_KEY_CALC       	DATE,  
  ORDER_QTY             	NUMBER,
  TOTAL_AMT             	NUMBER,
  HOLD_FLAG             	VARCHAR2(1),
  ORDER_CLOSED_FLAG    VARCHAR2(1),
  ORDER_TO_SHIP_DAYS   NUMBER,
  OTD_FLAG              	VARCHAR2(1),
  SOURCE                	VARCHAR2(100),
  MART_CREATE_DATE      DATE,
  MART_MODIFY_DATE      DATE,
  PARENT_ORDER_HEADER_OID NUMBER,
  MLT_ORDER_TYPE             VARCHAR2(10)
)

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Index Creation Temp_Stage Table */

CREATE INDEX RAX_APP_USER.DM_ORDER_HEADER_STG_IX1 ON RAX_APP_USER.DM_ORDER_HEADER_STG
(ORDER_HEADER_OID)
LOGGING
NOPARALLEL

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Insert into Temp_Stage Table */


INSERT INTO RAX_APP_USER.DM_ORDER_HEADER_STG
SELECT
 A.ORDER_HEADER_OID,A.ORDER_FORM_ID,A.APO_ID,A.UK_APO_CODE,A.CHANNEL_ID,
 A.UK_CHANNEL_NAME,A.EVENT_ID,A.UK_JOB_NBR,A.PRICE_PROGRAM_ID,A.UK_PRICE_PROGRAM_NAME,
 A.MARKETING_ID,A.SALES_LINE_NAME,A.MKTG_PROGRAM_NAME,A.PROGRAM_ID,A.SUB_PROGRAM_OID,
 A.SUB_PROGRAM_ID,A.SUB_PROGRAM_NAME,A.ACCOUNT_ID,A.UK_LIFETOUCH_ID,A.ORGANIZATION_ID,
 A.UK_TERRITORY_CODE,NVL(MART.X_CURRENT_ASSIGNMENT.ASSIGNMENT_ID,-1) AS ASSIGNMENT_ID,
 A.UK_APO_LIFETOUCH_ID,A.SUBJECT_ID,A.ORDER_JUNK_ID,A.MATCHED_CAPTURE_SESSION_ID,
 A.BATCH_ID,A.SHIP_NODE,A.ORDER_NO,A.ORDER_TYPE,A.ORDER_BUCKET,A.SELLING_METHOD,A.PLANT_RECEIPT_DATE_KEY,
 A.UK_JOB_NBR_CS,A.PLANT_RECEIPT_DATE_KEY_CS,A.ORDER_DATE_KEY,A.REQ_SHIP_DATE_KEY,
 A.REQ_DEL_DATE_KEY,A.ORDER_SHIP_DATE_KEY,NULL,NULL,NULL,NULL,NULL,A.ORDER_QTY,A.TOTAL_AMOUNT, A.HOLD_FLAG,
 A.ORDER_CLOSED,A.ORDER_TO_SHIP_DAYS, A.OTD_FLAG,A.SOURCE,A.MART_CREATE_DATE,
 A.MART_MODIFY_DATE, A.PARENT_ORDER_HEADER_OID, A.MLT_ORDER_TYPE
 FROM
(
SELECT 
ODS_OWN.ORDER_HEADER.ORDER_HEADER_OID,
ODS_OWN.ORDER_HEADER.ORDER_FORM_ID, 
MART.APO.APO_ID APO_ID,
ODS_OWN.APO.APO_ID UK_APO_CODE,
MART.CHANNEL.CHANNEL_ID CHANNEL_ID,
ODS_OWN.ORDER_CHANNEL.CHANNEL_NAME UK_CHANNEL_NAME,
MART.EVENT.EVENT_ID EVENT_ID,
ODS_OWN.EVENT.EVENT_REF_ID UK_JOB_NBR,
MART.PRICE_PROGRAM.PRICE_PROGRAM_ID PRICE_PROGRAM_ID,
ODS_OWN.PRICE_PROGRAM.PRICE_PROGRAM_NAME UK_PRICE_PROGRAM_NAME,
MART.MARKETING.MARKETING_ID MARKETING_ID,
MART.MARKETING.MARKETING_CODE,       
MART.MARKETING.SALES_LINE_NAME,      
MART.MARKETING.PROGRAM_NAME MKTG_PROGRAM_NAME,
ODS_OWN.PROGRAM.PROGRAM_NAME,        
ODS_OWN.PROGRAM.PROGRAM_ID,          
ODS_OWN.SUB_PROGRAM.SUB_PROGRAM_OID,  
ODS_OWN.SUB_PROGRAM.SUB_PROGRAM_ID,   
ODS_OWN.SUB_PROGRAM.SUB_PROGRAM_NAME, 
MART.ACCOUNT.ACCOUNT_ID,
ODS_OWN.ACCOUNT.LIFETOUCH_ID UK_LIFETOUCH_ID,
ODS_OWN.APO.TERRITORY_CODE UK_TERRITORY_CODE,
MART.ORGANIZATION.TERRITORY_CODE,
MART.ORGANIZATION.ORGANIZATION_ID,
ODS_OWN.APO.LIFETOUCH_ID AS UK_APO_LIFETOUCH_ID,
1 AS SUBJECT_ID,
NULL AS ORDER_JUNK_ID,
ODS_OWN.ORDER_HEADER.MATCHED_CAPTURE_SESSION_ID,
ODS_OWN.ORDER_HEADER.BATCH_ID,
ODS_OWN.ORDER_HEADER.SHIP_NODE,
ODS_OWN.ORDER_HEADER.ORDER_NO,
ODS_OWN.ORDER_HEADER.ORDER_TYPE,
ODS_OWN.ORDER_HEADER.ORDER_BUCKET,
ODS_OWN.APO.SELLING_METHOD,
NVL(ODS_OWN.EVENT.PLANT_RECEIPT_DATE,TO_DATE('01-JAN-1900 00:00:00','DD-MON-YYYY HH24:MI:SS')) PLANT_RECEIPT_DATE_KEY,
EVENT_2.EVENT_REF_ID UK_JOB_NBR_CS, 
NVL(EVENT_2.PLANT_RECEIPT_DATE,TO_DATE('01-JAN-1900 00:00:00','DD-MON-YYYY HH24:MI:SS')) PLANT_RECEIPT_DATE_KEY_CS, 
NVL(ODS_OWN.ORDER_HEADER.ORDER_DATE,TO_DATE('01-JAN-1900 00:00:00','DD-MON-YYYY HH24:MI:SS')) ORDER_DATE_KEY,
NVL(ODS_OWN.ORDER_HEADER.REQUESTED_SHIP_DATE,TO_DATE('01-JAN-1900 00:00:00','DD-MON-YYYY HH24:MI:SS')) REQ_SHIP_DATE_KEY,
NVL(ODS_OWN.ORDER_HEADER.REQUESTED_DELIVERY_DATE,TO_DATE('01-JAN-1900 00:00:00','DD-MON-YYYY HH24:MI:SS')) REQ_DEL_DATE_KEY,
NVL(ODS_OWN.ORDER_HEADER.ORDER_SHIP_DATE,TO_DATE('01-JAN-1900 00:00:00','DD-MON-YYYY HH24:MI:SS'))ORDER_SHIP_DATE_KEY,
1 AS ORDER_QTY,
ODS_OWN.ORDER_HEADER.TOTAL_AMOUNT,
ODS_OWN.ORDER_HEADER.HOLD_FLAG,
ODS_OWN.ORDER_HEADER.ORDER_CLOSED,
NULL AS ORDER_TO_SHIP_DAYS,
NULL AS OTD_FLAG,
'ORDER_HEADER' AS SOURCE,
SYSDATE AS MART_CREATE_DATE,
SYSDATE AS MART_MODIFY_DATE,
ODS_OWN.ORDER_HEADER.PARENT_ORDER_HEADER_OID,
ODS_OWN.ORDER_HEADER.MLT_ORDER_TYPE
FROM
      ODS_OWN.ORDER_HEADER 
     ,ODS_OWN.APO      
     ,ODS_OWN.EVENT
     ,ODS_OWN.EVENT EVENT_2
     ,ODS_OWN.ORDER_CHANNEL
     ,ODS_OWN.PRICE_PROGRAM 
     ,ODS_OWN.ORDER_TYPE     
     ,ODS_OWN.SUB_PROGRAM
     ,ODS_OWN.PROGRAM 
     ,ODS_OWN.CAPTURE_SESSION
     ,ODS_OWN.ACCOUNT   
     ,ODS_OWN.ORGANIZATION  
     ,MART.APO     
     ,MART.EVENT  
     ,MART.CHANNEL
     ,MART.PRICE_PROGRAM   
     ,MART.TIME ORDER_TIME
     ,MART.TIME REQ_SHIP_TIME
     ,MART.TIME REQ_DEL_TIME
     ,MART.TIME ORDER_SHIP_TIME
     ,MART.MARKETING
     ,MART.ORGANIZATION   
     ,MART.ACCOUNT        
     ,ODS.DW_CDC_LOAD_STATUS        
WHERE   1 = 1      
    AND ODS_OWN.ORDER_HEADER.APO_OID = ODS_OWN.APO.APO_OID(+)
    AND ODS_OWN.ORDER_HEADER.MATCHED_CAPTURE_SESSION_ID = ODS_OWN.CAPTURE_SESSION.CAPTURE_SESSION_KEY(+)
    AND ODS_OWN.CAPTURE_SESSION.EVENT_OID = EVENT_2.EVENT_OID (+)
    AND ODS_OWN.ORDER_HEADER.EVENT_OID = ODS_OWN.EVENT.EVENT_OID(+)
    AND ODS_OWN.ORDER_HEADER.ORDER_CHANNEL_OID = ODS_OWN.ORDER_CHANNEL.ORDER_CHANNEL_OID(+)
    AND ODS_OWN.ORDER_HEADER.PRICE_PROGRAM_OID = ODS_OWN.PRICE_PROGRAM.PRICE_PROGRAM_OID(+) 
    AND ODS_OWN.ORDER_HEADER.ORDER_TYPE_OID = ODS_OWN.ORDER_TYPE.ORDER_TYPE_OID(+)       
    AND ODS_OWN.APO.SUB_PROGRAM_OID = ODS_OWN.SUB_PROGRAM.SUB_PROGRAM_OID  
    AND ODS_OWN.SUB_PROGRAM.PROGRAM_OID = ODS_OWN.PROGRAM.PROGRAM_OID      
    AND ODS_OWN.APO.ACCOUNT_OID = ODS_OWN.ACCOUNT.ACCOUNT_OID              
    AND ODS_OWN.APO.ORGANIZATION_OID = ODS_OWN.ORGANIZATION.ORGANIZATION_OID   
    AND NVL(ODS_OWN.APO.APO_ID,-1) = MART.APO.APO_CODE(+)
    AND NVL(ODS_OWN.EVENT.EVENT_REF_ID,-1) = MART.EVENT.JOB_NBR(+)
    AND NVL(ODS_OWN.ORDER_CHANNEL.CHANNEL_NAME,-1) = MART.CHANNEL.CHANNEL_NAME(+)
    AND NVL(ODS_OWN.PRICE_PROGRAM.PRICE_PROGRAM_NAME,-1) = MART.PRICE_PROGRAM.PRICE_PROGRAM_NAME(+)
    AND TRUNC(ODS_OWN.ORDER_HEADER.ORDER_DATE) = ORDER_TIME.DATE_KEY(+)
    AND TRUNC(ODS_OWN.ORDER_HEADER.REQUESTED_SHIP_DATE) = REQ_SHIP_TIME.DATE_KEY(+)
    AND TRUNC(ODS_OWN.ORDER_HEADER.REQUESTED_DELIVERY_DATE) = REQ_DEL_TIME.DATE_KEY(+)
    AND TRUNC(ODS_OWN.ORDER_HEADER.ORDER_SHIP_DATE) = ORDER_SHIP_TIME.DATE_KEY(+)    
    AND NVL(ODS_OWN.SUB_PROGRAM.SUB_PROGRAM_OID,-1) = MART.MARKETING.SUB_PROGRAM_OID(+)   
    AND NVL(ODS_OWN.ACCOUNT.LIFETOUCH_ID,-1) = MART.ACCOUNT.LIFETOUCH_ID(+)   
    AND NVL(ODS_OWN.APO.TERRITORY_CODE,-1) = MART.ORGANIZATION.TERRITORY_CODE(+)        
    AND ODS_OWN.ORDER_HEADER.ODS_MODIFY_DATE > (ODS.DW_CDC_LOAD_STATUS.LAST_CDC_COMPLETION_DATE - 3/24)
    AND ODS_OWN.ORDER_HEADER.ODS_MODIFY_DATE > TRUNC(SYSDATE) - 5
    AND ODS.DW_CDC_LOAD_STATUS.DW_TABLE_NAME = 'ORDER_HEADER_FACT' 
  )A,
    MART.X_CURRENT_ASSIGNMENT
    WHERE 
    A.UK_APO_LIFETOUCH_ID = MART.X_CURRENT_ASSIGNMENT.LIFETOUCH_ID(+)
    AND A.PROGRAM_ID = MART.X_CURRENT_ASSIGNMENT.PROGRAM_ID(+)

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Merging Data from Order Batch */

MERGE INTO RAX_APP_USER.DM_ORDER_HEADER_STG TGT
USING  
(  
SELECT S.ORDER_HEADER_OID,
       NVL(B.BATCH_CLOSE_DATE,S.ORDER_SHIP_DATE_KEY) AS BATCH_CLOSE_DATE
    FROM 
         RAX_APP_USER.DM_ORDER_HEADER_STG  S,
         ODS_OWN.ORDER_BATCH B 
        WHERE  
            TRUNC(S.ORDER_SHIP_DATE_KEY) NOT IN (TO_DATE('01-JAN-1900','DD-MON-YYYY'))
        AND UPPER(S.ORDER_BUCKET) NOT IN ('SERVICE')
        AND UPPER(S.SELLING_METHOD) IN ('PROOF')
        AND UPPER(S.ORDER_BUCKET) NOT IN ('X')
        AND S.BATCH_ID  = B.BATCH_ID(+)             
        --AND UPPER(B.BOC_STATUS) = 'CLOSED'
    )SRC
      ON (TGT.ORDER_HEADER_OID = SRC.ORDER_HEADER_OID)          
  WHEN MATCHED THEN
    UPDATE 
     SET            
          TGT.BATCH_CLOSE_DATE_KEY =  SRC.BATCH_CLOSE_DATE

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Recalculating the Dates (Excluding of Weekends) */

MERGE INTO RAX_APP_USER.DM_ORDER_HEADER_STG  TGT
USING  
(  
SELECT S.ORDER_HEADER_OID,
       ORDER_DATE_KEY,
       PLANT_RECEIPT_DATE_KEY_CS,
       ORDER_SHIP_DATE_KEY,
CASE WHEN T1.DAY_NAME IN ('Sat')
     THEN TRUNC(ORDER_DATE_KEY) + 2
     WHEN T1.DAY_NAME IN ('Sun')
     THEN TRUNC(ORDER_DATE_KEY) + 1
     ELSE ORDER_DATE_KEY
END AS ORDER_DATE_KEY_CALC,
CASE WHEN T2.DAY_NAME IN ('Sat')
     THEN TRUNC(PLANT_RECEIPT_DATE_KEY_CS) + 2
     WHEN T2.DAY_NAME IN ('Sun')
     THEN TRUNC(PLANT_RECEIPT_DATE_KEY_CS) + 1
     ELSE PLANT_RECEIPT_DATE_KEY_CS
END AS PLANT_RECEIPT_DATE_KEY_CS_CALC,        
CASE WHEN T3.DAY_NAME IN ('Sat')
     THEN TRUNC(ORDER_SHIP_DATE_KEY) + 2
     WHEN T3.DAY_NAME IN ('Sun')
     THEN TRUNC(ORDER_SHIP_DATE_KEY) + 1
     ELSE ORDER_SHIP_DATE_KEY    
END AS ORDER_SHIP_DATE_KEY_CALC,
CASE WHEN T4.DAY_NAME IN ('Sat')
     THEN TRUNC(BATCH_CLOSE_DATE_KEY) + 2
     WHEN T4.DAY_NAME IN ('Sun')
     THEN TRUNC(BATCH_CLOSE_DATE_KEY) + 1
     ELSE BATCH_CLOSE_DATE_KEY    
END AS BATCH_CLOSE_DATE_KEY_CALC    
FROM RAX_APP_USER.DM_ORDER_HEADER_STG  S,
     MART.TIME T1,
     MART.TIME T2,
     MART.TIME T3,
     MART.TIME T4    
WHERE --S.ORDER_HEADER_OID = 86058685 
TRUNC(S.ORDER_DATE_KEY) = T1.DATE_KEY(+)
AND TRUNC(S.PLANT_RECEIPT_DATE_KEY_CS) = T2.DATE_KEY(+)
AND TRUNC(S.ORDER_SHIP_DATE_KEY) = T3.DATE_KEY(+)
AND TRUNC(S.BATCH_CLOSE_DATE_KEY) = T4.DATE_KEY(+)
    )SRC
      ON (TGT.ORDER_HEADER_OID = SRC.ORDER_HEADER_OID)          
  WHEN MATCHED THEN
    UPDATE 
     SET  
          TGT.ORDER_DATE_KEY_CALC            =  SRC.ORDER_DATE_KEY_CALC,
          TGT.PLANT_RECEIPT_DATE_KEY_CS_CALC =  SRC.PLANT_RECEIPT_DATE_KEY_CS_CALC,
          TGT.ORDER_SHIP_DATE_KEY_CALC       =  SRC.ORDER_SHIP_DATE_KEY_CALC,
          TGT.BATCH_CLOSE_DATE_KEY_CALC      =  SRC.BATCH_CLOSE_DATE_KEY_CALC

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Give Credit incase the Plant Receipt Date is Greater than Order Ship Date */

MERGE INTO RAX_APP_USER.DM_ORDER_HEADER_STG  TGT
USING  
(  
SELECT 
       S.ORDER_HEADER_OID,
       S.ORDER_DATE_KEY_CALC,
       S.PLANT_RECEIPT_DATE_KEY_CS_CALC,
       S.ORDER_SHIP_DATE_KEY_CALC
    FROM 
        RAX_APP_USER.DM_ORDER_HEADER_STG  S
        WHERE 1 = 1
        AND  S.PLANT_RECEIPT_DATE_KEY_CS_CALC > S.ORDER_SHIP_DATE_KEY_CALC
        AND TRUNC(S.ORDER_SHIP_DATE_KEY) NOT IN (TO_DATE('01-JAN-1900','DD-MON-YYYY'))
        AND UPPER(S.ORDER_BUCKET) NOT IN ('SERVICE')
    )SRC
      ON (TGT.ORDER_HEADER_OID = SRC.ORDER_HEADER_OID)          
  WHEN MATCHED THEN
    UPDATE 
     SET            
          TGT.PLANT_RECEIPT_DATE_KEY_CS_CALC =  SRC.ORDER_SHIP_DATE_KEY_CALC

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Insert into DIM - MART.APO */

    
INSERT ALL      
       WHEN APO_ID IS NULL
       THEN  
           INTO MART.APO
                                (APO_ID,APO_CODE,SOURCE_SYSTEM_NAME,SCHOOL_YEAR,SELLING_METHOD_NAME,
                                 PLANT_NAME,PHOTOGRAPHY_DATE,LIFETOUCH_ID,MARKETING_CODE,
                                 TERRITORY_CODE,APY_ID,DESCRIPTION,PRICE_PROGRAM_NAME,PHOTOGRAPHY_LOCATION,
                                 STUDIO_CODE,INTERNET_ORDER_OFFERED_IND,TERRITORY_GROUP_CODE,STUDENT_ID_IND)
          VALUES(MART.APO_ID_SEQ.NEXTVAL,UK_APO_CODE,'.','0','.',
                 '.',TO_DATE('01-01-1900','DD-MM-YYYY'),0,'.',
                 '.',0,'.','.','.',
                 '.','.','.','.') 
          SELECT DISTINCT  APO_ID,UK_APO_CODE,'APO' AS DIM_TYPE 
          FROM RAX_APP_USER.DM_ORDER_HEADER_STG S
          WHERE NOT EXISTS ( SELECT * FROM MART.APO APO
                                              WHERE  S.UK_APO_CODE = APO.APO_CODE)


&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert into DIM - MART.EVENT */

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
               FROM RAX_APP_USER.DM_ORDER_HEADER_STG S
               WHERE NOT EXISTS (SELECT * FROM MART.EVENT EVENT
                                                  WHERE S.UK_JOB_NBR = EVENT.JOB_NBR)

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* Insert into DIM - MART.CHANNEL */

INSERT ALL      
       WHEN ORDER_CHANNEL_ID IS NULL
       THEN  
          INTO MART.CHANNEL(CHANNEL_ID,CHANNEL_NAME)
          VALUES(MART.CHANNEL_ID_SEQ.NEXTVAL,UK_CHANNEL_NAME) 
          SELECT DISTINCT  ORDER_CHANNEL_ID,UK_CHANNEL_NAME,'CHANNEL_NAME' AS DIM_TYPE 
          FROM RAX_APP_USER.DM_ORDER_HEADER_STG S
          WHERE NOT EXISTS   (SELECT * FROM MART.CHANNEL CHANNEL 
                                              WHERE S.UK_CHANNEL_NAME  = CHANNEL.CHANNEL_NAME)

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* Insert into DIM - MART.MARKETING */

/*INSERT ALL 
      WHEN MARKETING_ID IS NULL
      THEN  
          INTO MART.MARKETING
         (MARKETING_ID,MARKETING_CODE,SUB_PROGRAM_ID,SUB_PROGRAM_NAME,PROGRAM_ID,
          PROGRAM_NAME,SALES_LINE_NAME,SUB_PROGRAM_OID)
          VALUES
                  (ODS.MARKETING_ID_SEQ.NEXTVAL,'Unknown '|| SUB_PROGRAM_ID||'-'|| PROGRAM_ID,
                   SUB_PROGRAM_ID,SUB_PROGRAM_NAME,PROGRAM_ID,PROGRAM_NAME,SALES_LINE_NAME,SUB_PROGRAM_OID)
          SELECT 
          DISTINCT MARKETING_ID,SUB_PROGRAM_ID,SUB_PROGRAM_NAME,
          PROGRAM_ID,PROGRAM_NAME,SALES_LINE_NAME,SUB_PROGRAM_OID
          FROM 
         RAX_APP_USER.DM_ORDER_HEADER_STG S
          WHERE NOT EXISTS ( SELECT * FROM MART.MARKETING M
                                              WHERE  S.SUB_PROGRAM_OID = M.SUB_PROGRAM_OID)
*/


UPDATE RAX_APP_USER.DM_ORDER_HEADER_STG STG
SET STG.MARKETING_ID = -1
WHERE STG.MARKETING_ID IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* Insert into DIM - MART.ACCOUNT */

/*INSERT ALL
      WHEN ACCOUNT_ID IS NULL
      THEN
          INTO MART.ACCOUNT    
             (  ACCOUNT_ID,LIFETOUCH_ID,LPIP_PID,ACCOUNT_CLASSIFICATION_CODE,
                NACAM_OVERALL_CLASS_NAME, NACAM_SENIORS_CLASS_NAME )
       VALUES  
              (ODS.ACCOUNT_ID_SEQ.NEXTVAL,UK_LIFETOUCH_ID,'.','.','.','.')
      SELECT
         DISTINCT  ACCOUNT_ID,UK_LIFETOUCH_ID,'ACCOUNT' AS DIM_TYPE 
         FROM RAX_APP_USER.DM_ORDER_HEADER_STG S
               WHERE NOT EXISTS ( SELECT * FROM MART.ACCOUNT A
                                              WHERE  S.UK_LIFETOUCH_ID = A.LIFETOUCH_ID)
*/


UPDATE rax_app_user.DM_ORDER_HEADER_STG STG
SET STG.ACCOUNT_ID = -1
WHERE STG.ACCOUNT_ID IS NULL


&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* Insert into DIM - MART.ORGANIZATION */

/*
INSERT ALL      
       WHEN ORGANIZATION_ID IS NULL
       THEN  
           INTO MART.ORGANIZATION
               (ORGANIZATION_ID,TERRITORY_CODE,AMS_ORGANIZATION_NAME,
                AMS_COMPANY_NAME,AMS_BUSINESS_UNIT_NAME,COMMISSION_IND)
                      VALUES(ODS.ORGANIZATION_ID_SEQ.NEXTVAL,UK_TERRITORY_CODE,'.','.','.','.')                                                         
           SELECT 
           DISTINCT ORGANIZATION_ID,UK_TERRITORY_CODE,'ORG' AS DIM_TYPE 
           FROM RAX_APP_USER.DM_ORDER_HEADER_STG S
               WHERE NOT EXISTS ( SELECT * FROM MART.ORGANIZATION ORG
                                              WHERE  S.UK_TERRITORY_CODE = ORG.TERRITORY_CODE)
*/


UPDATE rax_app_user.DM_ORDER_HEADER_STG STG
SET STG.ORGANIZATION_ID = -1
WHERE STG.ORGANIZATION_ID IS NULL

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Rebuild Temp_Stage Table */


MERGE INTO RAX_APP_USER.DM_ORDER_HEADER_STG TGT 
    USING  
 (    
SELECT 
STG.ORDER_HEADER_OID,
ORGANIZATION.ORGANIZATION_ID,
APO.APO_ID,
ACCOUNT.ACCOUNT_ID,
MARKETING.MARKETING_ID,
EVENT.EVENT_ID,
CHANNEL.CHANNEL_ID
    FROM 
    RAX_APP_USER.DM_ORDER_HEADER_STG STG,
    MART.APO APO,  
    MART.EVENT EVENT,  
    MART.CHANNEL CHANNEL,
    MART.MARKETING MARKETING,  
    MART.ACCOUNT ACCOUNT,  
     MART.ORGANIZATION ORGANIZATION
    WHERE 
    (
        STG.APO_ID IS NULL OR STG.EVENT_ID IS NULL 
       OR STG.ORDER_CHANNEL_ID IS NULL
       OR STG.MARKETING_ID IS NULL
       OR STG.ACCOUNT_ID IS NULL 
       OR STG.ORGANIZATION_ID IS NULL
    )
       AND STG.UK_APO_CODE = APO.APO_CODE
       AND STG.UK_JOB_NBR = EVENT.JOB_NBR
       AND STG.UK_CHANNEL_NAME = CHANNEL.CHANNEL_NAME    
       AND STG.SUB_PROGRAM_OID = MARKETING.SUB_PROGRAM_OID   
       AND STG.UK_LIFETOUCH_ID = ACCOUNT.LIFETOUCH_ID   
       AND STG.UK_TERRITORY_CODE = ORGANIZATION.TERRITORY_CODE                      
    )SRC
      ON (TGT.ORDER_HEADER_OID = SRC.ORDER_HEADER_OID)          
    WHEN MATCHED THEN
    UPDATE 
     SET  
             TGT.MARKETING_ID         	=  SRC.MARKETING_ID,
             TGT.ACCOUNT_ID           	=  SRC.ACCOUNT_ID,
             TGT.ORDER_CHANNEL_ID     	=  SRC.CHANNEL_ID,
             TGT.APO_ID               	=  SRC.APO_ID,
             TGT.EVENT_ID             	=  SRC.EVENT_ID,
             TGT.ORGANIZATION_ID      	=  SRC.ORGANIZATION_ID          
          
          

&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Calculate OTD for Non Proofs */

MERGE INTO RAX_APP_USER.DM_ORDER_HEADER_STG TGT
USING  
(  
SELECT S.ORDER_HEADER_OID,
           T.FISCAL_YEAR,
           T.SEASON_NAME,
           S.PROGRAM_NAME,
           TRUNC(S.ORDER_SHIP_DATE_KEY_CALC) AS SHIP_DATE,
           TRUNC(GREATEST(S.PLANT_RECEIPT_DATE_KEY_CS_CALC,S.ORDER_DATE_KEY_CALC)) as ORDER_DATE,
           COUNT(B.DATE_KEY) AS ORDER_TO_SHIP_DAYS,
           CASE 
                WHEN S.PROGRAM_NAME IS NOT NULL  
                AND  TRUNC(S.ORDER_SHIP_DATE_KEY_CALC) - 
                   TRUNC(GREATEST(S.PLANT_RECEIPT_DATE_KEY_CS_CALC,S.ORDER_DATE_KEY_CALC)) <= 
ORDER_TO_SHIP_DAYS_LKP.STANDARD_DAYS
                THEN 'Y'                                 
                ELSE 'N'
           END AS OTD_FLAG
          FROM 
               RAX_APP_USER.DM_ORDER_HEADER_STG S, 
               MART.TIME T,
               (SELECT * FROM MART.TIME WHERE DAY_NAME NOT IN ('Sat','Sun'))B,
               ODS_STAGE.ORDER_TO_SHIP_DAYS_LKP ORDER_TO_SHIP_DAYS_LKP
             WHERE  1 = 1
              AND TRUNC(S.ORDER_SHIP_DATE_KEY_CALC) = T.DATE_KEY               
              AND  UPPER(S.ORDER_BUCKET) NOT IN ('SERVICE')
              AND  ((UPPER(S.SELLING_METHOD) = 'PROOF' and S.ORDER_BUCKET in ('X')) OR (UPPER(S.SELLING_METHOD) <> 'PROOF') OR SELLING_METHOD IS NULL)
              AND  TRUNC(S.ORDER_SHIP_DATE_KEY_CALC) NOT IN (TO_DATE('01-JAN-1900','DD-MON-YYYY'))                
              AND  B.DATE_KEY BETWEEN  TRUNC(GREATEST(S.PLANT_RECEIPT_DATE_KEY_CS_CALC,S.ORDER_DATE_KEY_CALC))
              AND TRUNC(S.ORDER_SHIP_DATE_KEY_CALC)         
              AND  UPPER(T.SEASON_NAME) =  UPPER(ORDER_TO_SHIP_DAYS_LKP.SEASON_NAME)
              AND  T.FISCAL_YEAR = ORDER_TO_SHIP_DAYS_LKP.FISCAL_YEAR          
              AND  UPPER(S.PROGRAM_NAME) =  UPPER(ORDER_TO_SHIP_DAYS_LKP.PROGRAM_NAME) 
GROUP BY 
S.ORDER_HEADER_OID,T.FISCAL_YEAR,T.SEASON_NAME,S.PROGRAM_NAME,
TRUNC(S.ORDER_SHIP_DATE_KEY_CALC),
TRUNC(GREATEST(S.PLANT_RECEIPT_DATE_KEY_CS_CALC,S.ORDER_DATE_KEY_CALC)),          
CASE WHEN S.PROGRAM_NAME IS NOT NULL
AND  TRUNC(S.ORDER_SHIP_DATE_KEY_CALC) - TRUNC(GREATEST(S.PLANT_RECEIPT_DATE_KEY_CS_CALC,S.ORDER_DATE_KEY_CALC)) <= 
ORDER_TO_SHIP_DAYS_LKP.STANDARD_DAYS
THEN 'Y' ELSE 'N' END
    )SRC
      ON (TGT.ORDER_HEADER_OID = SRC.ORDER_HEADER_OID)          
  WHEN MATCHED THEN
    UPDATE 
     SET  
          TGT.ORDER_TO_SHIP_DAYS     =  SRC.ORDER_TO_SHIP_DAYS,
          TGT.OTD_FLAG               =  SRC.OTD_FLAG

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Calculate OTD for Proofs */

MERGE INTO RAX_APP_USER.DM_ORDER_HEADER_STG TGT
USING  
(  
SELECT S.ORDER_HEADER_OID,
           T.FISCAL_YEAR,
           T.SEASON_NAME,
           S.PROGRAM_NAME,
           TRUNC(S.ORDER_SHIP_DATE_KEY_CALC) AS SHIP_DATE,
           TRUNC(S.ORDER_DATE_KEY_CALC) AS ORDEr_DATE,
           TRUNC(S.BATCH_CLOSE_DATE_KEY_CALC) AS BATCH_CLOSE_DATE,
           COUNT(B.DATE_KEY) AS ORDER_TO_SHIP_DAYS,
           CASE 
                WHEN S.PROGRAM_NAME IS NOT NULL  
                AND  TRUNC(S.ORDER_SHIP_DATE_KEY_CALC) - 
                   TRUNC(S.BATCH_CLOSE_DATE_KEY_CALC) <= ORDER_TO_SHIP_DAYS_LKP.STANDARD_DAYS
                THEN 'Y'                                 
                ELSE 'N'
           END AS OTD_FLAG
          FROM 
               RAX_APP_USER.DM_ORDER_HEADER_STG S, 
               MART.TIME T,
               (SELECT * FROM MART.TIME WHERE DAY_NAME NOT IN ('Sat','Sun'))B,
               ODS_STAGE.ORDER_TO_SHIP_DAYS_LKP ORDER_TO_SHIP_DAYS_LKP
              WHERE 1 = 1
              AND TRUNC(S.ORDER_SHIP_DATE_KEY_CALC) = T.DATE_KEY               
              AND  UPPER(S.ORDER_BUCKET) NOT IN ('SERVICE')
              AND  (UPPER(S.SELLING_METHOD) = 'PROOF' and UPPER(S.ORDER_BUCKET) NOT IN ('X'))  
              AND  TRUNC(S.ORDER_SHIP_DATE_KEY_CALC) NOT IN (TO_DATE('01-JAN-1900','DD-MON-YYYY'))                
              AND  B.DATE_KEY BETWEEN  TRUNC(S.BATCH_CLOSE_DATE_KEY_CALC)
              AND TRUNC(S.ORDER_SHIP_DATE_KEY_CALC)         
              AND  UPPER(T.SEASON_NAME) =  UPPER(ORDER_TO_SHIP_DAYS_LKP.SEASON_NAME)
              AND  T.FISCAL_YEAR = ORDER_TO_SHIP_DAYS_LKP.FISCAL_YEAR          
              AND  UPPER(S.PROGRAM_NAME) =  UPPER(ORDER_TO_SHIP_DAYS_LKP.PROGRAM_NAME) 
GROUP BY 
S.ORDER_HEADER_OID,T.FISCAL_YEAR,T.SEASON_NAME,S.PROGRAM_NAME,
TRUNC(S.ORDER_SHIP_DATE_KEY_CALC),
TRUNC(S.BATCH_CLOSE_DATE_KEY_CALC),  
 TRUNC(S.ORDER_DATE_KEY_CALC) ,        
CASE WHEN S.PROGRAM_NAME IS NOT NULL
AND  TRUNC(S.ORDER_SHIP_DATE_KEY_CALC) - TRUNC(S.BATCH_CLOSE_DATE_KEY_CALC) <= ORDER_TO_SHIP_DAYS_LKP.STANDARD_DAYS
THEN 'Y' ELSE 'N' END
    )SRC
      ON (TGT.ORDER_HEADER_OID = SRC.ORDER_HEADER_OID)          
  WHEN MATCHED THEN
    UPDATE 
     SET  
          TGT.ORDER_TO_SHIP_DAYS     =  SRC.ORDER_TO_SHIP_DAYS,
          TGT.OTD_FLAG               =  SRC.OTD_FLAG

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* Update subject_id */

MERGE INTO RAX_APP_USER.DM_ORDER_HEADER_STG TGT
    USING  
(  
SELECT S.ORDER_HEADER_OID, MS.SUBJECT_ID
FROM RAX_APP_USER.DM_ORDER_HEADER_STG S, 
ODS_OWN.CAPTURE_SESSION CS,
MART.SUBJECT MS
WHERE S.MATCHED_CAPTURE_SESSION_ID = CS.CAPTURE_SESSION_KEY
AND CS.SUBJECT_OID = MS.SUBJECT_OID
)SRC
ON (TGT.ORDER_HEADER_OID = SRC.ORDER_HEADER_OID)          
WHEN MATCHED THEN
 UPDATE 
 SET  
 TGT.SUBJECT_ID     =  SRC.SUBJECT_ID

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* Populate Junk DIM_KEY at Temp_Stage Table */


MERGE INTO RAX_APP_USER.DM_ORDER_HEADER_STG TGT
    USING  
    (  
     SELECT S.ORDER_HEADER_OID,S.HOLD_FLAG,S.ORDER_CLOSED_FLAG,S.OTD_FLAG,JUNK.ORDER_JUNK_ID
     FROM RAX_APP_USER.DM_ORDER_HEADER_STG S, 
          MART.ORDER_JUNK_DIM JUNK, MART.SUBJECT SUBJECT        
      WHERE  1 = 1   
     AND NVL(S.OTD_FLAG,'UNKNOWN') = JUNK.OTD_FLAG
     AND S.ORDER_BUCKET = JUNK.ORDER_BUCKET
     AND S.SUBJECT_ID = SUBJECT.SUBJECT_ID
     AND JUNK.SUBJECT_TYPE = NVL(UPPER(SUBJECT.SUBJECT_TYPE),'UNKNOWN') 
     AND JUNK.MLT_ORDER_TYPE = NVL(UPPER(S.MLT_ORDER_TYPE),'UNKNOWN') 
     --AND JUNK.SUBJECT_TYPE = 'STUDENT'                                                        
    )SRC
      ON (TGT.ORDER_HEADER_OID = SRC.ORDER_HEADER_OID)          
  WHEN MATCHED THEN
    UPDATE 
    SET TGT.ORDER_JUNK_ID =  SRC.ORDER_JUNK_ID   
    
  

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* Merge into Target Fact Table */


MERGE INTO MART.ORDER_HEADER_FACT TGT
    USING  
    (  
     SELECT 
     ORDER_HEADER_OID,ORDER_FORM_ID,APO_ID,ORDER_CHANNEL_ID,PRICE_PROGRAM_ID,
     EVENT_ID,MARKETING_ID,ACCOUNT_ID,ASSIGNMENT_ID,ORGANIZATION_ID,SUBJECT_ID,
     NVL(ORDER_JUNK_ID,-1) AS ORDER_JUNK_ID,MATCHED_CAPTURE_SESSION_ID,BATCH_ID,
     SHIP_NODE,ORDER_NO, ORDER_TYPE,ORDER_BUCKET,TRUNC(ORDER_DATE_KEY) AS  ORDER_DATE_KEY,
     REQ_SHIP_DATE_KEY, REQ_DELIVERY_DATE_KEY,ORDER_SHIP_DATE_KEY,1 AS ORDER_QTY,TOTAL_AMT,
     ORDER_TO_SHIP_DAYS,HOLD_FLAG,ORDER_CLOSED_FLAG,SOURCE,MART_CREATE_DATE,
     MART_MODIFY_DATE,PARENT_ORDER_HEADER_OID
     FROM
     RAX_APP_USER.DM_ORDER_HEADER_STG  S
    )SRC
      ON (TGT.ORDER_HEADER_OID = SRC.ORDER_HEADER_OID)          
  WHEN MATCHED THEN
    UPDATE 
     SET  
          TGT.ORDER_FORM_ID          	=  SRC.ORDER_FORM_ID,
          TGT.APO_ID                	=  SRC.APO_ID,
          TGT.ORDER_CHANNEL_ID       	=  SRC.ORDER_CHANNEL_ID,          
          TGT.EVENT_ID               	=  SRC.EVENT_ID,
          TGT.MARKETING_ID           	=  SRC.MARKETING_ID,
          TGT.JOB_TICKET_ORG_ID      	=  SRC.ORGANIZATION_ID,
          TGT.ACCOUNT_ID             	=  SRC.ACCOUNT_ID,
          TGT.ASSIGNMENT_ID          	=  SRC.ASSIGNMENT_ID,
          TGT.SUBJECT_ID             	=  SRC.SUBJECT_ID,
          TGT.ORDER_JUNK_ID   	=  SRC.ORDER_JUNK_ID,
          TGT.MATCHED_CAPTURE_SESSION_ID  = SRC.MATCHED_CAPTURE_SESSION_ID,
          TGT.BATCH_ID               	=  SRC.BATCH_ID,
          TGT.SHIP_NODE              	=  SRC.SHIP_NODE,
          TGT.ORDER_NO               	=  SRC.ORDER_NO,
          TGT.ORDER_TYPE             	=  SRC.ORDER_TYPE,          
          TGT.ORDER_DATE_KEY         	=  SRC.ORDER_DATE_KEY,
          TGT.REQ_SHIP_DATE_KEY      	=  SRC.REQ_SHIP_DATE_KEY,
          TGT.REQ_DELIVERY_DATE_KEY  	=  SRC.REQ_DELIVERY_DATE_KEY,
          TGT.ORDER_SHIP_DATE_KEY    	=  SRC.ORDER_SHIP_DATE_KEY,
          TGT.ORDER_QTY              	=  SRC.ORDER_QTY,
          TGT.TOTAL_AMT              	=  SRC.TOTAL_AMT,
          TGT.ORDER_TO_SHIP_DAYS     	=  SRC.ORDER_TO_SHIP_DAYS,
          TGT.ORDER_HOLD_FLAG        	=  SRC.HOLD_FLAG,
          TGT.ORDER_CLOSED_FLAG      	=  SRC.ORDER_CLOSED_FLAG,
          TGT.MART_MODIFY_DATE       	=  SYSDATE,
          TGT.PARENT_ORDER_HEADER_OID = SRC.PARENT_ORDER_HEADER_OID
  WHEN NOT MATCHED THEN 
 INSERT ( 
               TGT.ORDER_HEADER_OID,TGT.ORDER_FORM_ID,TGT.APO_ID,TGT.ORDER_CHANNEL_ID,
               TGT.EVENT_ID,TGT.MARKETING_ID,TGT.JOB_TICKET_ORG_ID,TGT.ACCOUNT_ID,
                TGT.ASSIGNMENT_ID,TGT.SUBJECT_ID,TGT.ORDER_JUNK_ID,TGT.MATCHED_CAPTURE_SESSION_ID,
                TGT.BATCH_ID,TGT.SHIP_NODE,TGT.ORDER_NO,TGT.ORDER_TYPE,TGT.ORDER_DATE_KEY,
                TGT.REQ_SHIP_DATE_KEY,TGT.REQ_DELIVERY_DATE_KEY,TGT.ORDER_SHIP_DATE_KEY,
                TGT.ORDER_QTY,TGT.TOTAL_AMT,TGT.ORDER_TO_SHIP_DAYS,TGT.ORDER_HOLD_FLAG,
                TGT.ORDER_CLOSED_FLAG,TGT.MART_CREATE_DATE,TGT.MART_MODIFY_DATE,
                TGT.PARENT_ORDER_HEADER_OID
        )
         VALUES(
         SRC.ORDER_HEADER_OID,SRC.ORDER_FORM_ID,SRC.APO_ID,SRC.ORDER_CHANNEL_ID,
         SRC.EVENT_ID,SRC.MARKETING_ID,SRC.ORGANIZATION_ID,SRC.ACCOUNT_ID,SRC.ASSIGNMENT_ID,
         SRC.SUBJECT_ID,SRC.ORDER_JUNK_ID,SRC.MATCHED_CAPTURE_SESSION_ID,
         SRC.BATCH_ID,SRC.SHIP_NODE,SRC.ORDER_NO,SRC.ORDER_TYPE,SRC.ORDER_DATE_KEY,
         SRC.REQ_SHIP_DATE_KEY,SRC.REQ_DELIVERY_DATE_KEY,SRC.ORDER_SHIP_DATE_KEY,SRC.ORDER_QTY,
         SRC.TOTAL_AMT,SRC.ORDER_TO_SHIP_DAYS,SRC.HOLD_FLAG,SRC.ORDER_CLOSED_FLAG,
         SYSDATE,SYSDATE,SRC.PARENT_ORDER_HEADER_OID
         )

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Drop Temp_Stage Table */

DROP TABLE RAX_APP_USER.DM_ORDER_HEADER_STG


&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* Update CDC Load Status */

UPDATE ODS.DW_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE DW_TABLE_NAME=:v_cdc_load_table_name

&


/*-----------------------------------------------*/
/* TASK No. 25 */
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
'ORDER_HEADER_FACT_PKG',
'038',
TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
TO_DATE (SUBSTR (:v_cdc_load_date_ODS_DM, 1, 19),
                           'YYYY-MM-DD HH24:MI:SS'
                          ),
:v_cdc_overlap,
SYSDATE)



&


/*-----------------------------------------------*/
