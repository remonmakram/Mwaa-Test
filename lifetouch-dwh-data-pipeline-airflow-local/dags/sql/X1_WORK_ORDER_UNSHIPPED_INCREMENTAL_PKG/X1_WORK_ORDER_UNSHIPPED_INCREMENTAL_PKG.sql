/* TASK No. 1 */
/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 1 */
/*-----------------------------------------------*/
/* TASK No. 2 */
/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 2 */
/*-----------------------------------------------*/
/* TASK No. 3 */
/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 3 */
/*-----------------------------------------------*/
/* TASK No. 4 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 5 */
/* Create Temp Table */



CREATE TABLE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1
(
 PLATFORM_DETAIL        	VARCHAR2(30),
 WORK_ORDER_ID          	NUMBER,
 EVENT_REF_ID           	VARCHAR2(30),
 JOB_TYPE               	VARCHAR2(30),
 LID                    	NUMBER,
 ACCT_NAME              	VARCHAR2(200),
 SHIP_PROPSL_RECEIVED       DATE,
 BATCH_ID               	      VARCHAR2(30),    
 WORK_ORDER_ALIAS_ID      VARCHAR2(30),
 SUBJECT_COUNT          	      NUMBER,
 WORK_ORDER_FORM_PRT    DATE,
 RET                    	VARCHAR2(100),
 RET_QTY                	NUMBER,
 RET_PRT               	DATE,
 PKG                    	VARCHAR2(100),
 PKG_QTY                	NUMBER,
 PKG_PRT                	DATE,
 POS                    	VARCHAR2(100),
 POS_QTY                	NUMBER,
 POS_PRT                	DATE,
 DIGITAL_MEDIA1          	VARCHAR2(100),
 DIGITAL_MEDIA1_QTY     NUMBER,
 DIGITAL_MEDIA1_PRT     	DATE,
 DIGITAL_MEDIA2          	VARCHAR2(100),
 DIGITAL_MEDIA2_QTY     NUMBER,
 DIGITAL_MEDIA2_PRT     	DATE,
 LAMINATE               	VARCHAR2(100),           
 LAMINATE_QTY           	NUMBER,
 LAMINATE_PRT           	DATE,
 MAGNET                 	VARCHAR2(100),
 MAGNET_QTY             	NUMBER,
 MAGNET_PRT             	DATE,
 METALLIC               	VARCHAR2(100),
 METALLIC_QTY           	NUMBER,
 METALLIC_PRT           	DATE, 
 SPECIALITY             	VARCHAR2(100),  
 SPECIALITY_QTY         	NUMBER,
 SPECIALITY_PRODUCED   DATE,
-- INDIGO_PRODUCT       	VARCHAR2(100),
-- INDIGO_QTY             	NUMBER,
-- INDIGO_PRODUCED      DATE,
 INDIGO_PRODUCT1                       VARCHAR2(100),
 INDIGO_PRODUCT1_QTY               NUMBER,
 INDIGO_PRODUCT1_PRODUCED   DATE,
 INDIGO_PRODUCT2                       VARCHAR2(100),
 INDIGO_PRODUCT2_QTY               NUMBER,
 INDIGO_PRODUCT2_PRODUCED   DATE,
 PROOF_PRODUCT          	VARCHAR2(100),
 PROOF_QTY              	NUMBER,
 PROOF_PRODUCED         	DATE,
 CLASS_DELIVERY         	VARCHAR2(100),
 CLASS                  	VARCHAR2(100),
 CLASS_QTY              	NUMBER,
 CLASS_PRT              	DATE,
 DID                    	VARCHAR2(100),
 DID_QTY                	NUMBER,
 DID_PRT                	DATE,
 DSSK                   	VARCHAR2(100), 
 DSSK_QTY               	NUMBER,
 DSSK_PRT               	DATE,
 EZP                    	VARCHAR2(100),
 EZP_QTY                	NUMBER,
 EZP_PRT                	DATE,
 POS618                             VARCHAR2(100),
 POS618_QTY                     NUMBER,
 POS618_PRT                     DATE,
 SPECIAL_REQUEST        	VARCHAR2(100), 
 WORK_ORDER_STATUS   VARCHAR2(100),
 PROCESSING_COMMENT  VARCHAR2(2000), 
 SHIP_GOAL_DATE        	DATE,
 WOMS_NODE              	VARCHAR2(30),
 DEACTIVATED_FLAG         VARCHAR2(1)
)

&

/*-----------------------------------------------*/
/* TASK No. 6 */
/* Create IDX1 */



CREATE INDEX X1_WO_UNSHIPPED_TEMP1_IX1 ON RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1
(WORK_ORDER_ID,LID,WOMS_NODE)
LOGGING
NOPARALLEL

&

/*-----------------------------------------------*/
/* TASK No. 7 */
/* Create IDX2 */



CREATE INDEX X1_WO_UNSHIPPED_TEMP1_IX2 ON RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1
(WORK_ORDER_ID,WOMS_NODE)
LOGGING
NOPARALLEL

&

/*-----------------------------------------------*/
/* TASK No. 8 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 9 */
/* Create Temp Table */



CREATE TABLE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2
(
 PLATFORM_DETAIL        	VARCHAR2(30),
 WORK_ORDER_ID         	NUMBER,
 EVENT_REF_ID           	VARCHAR2(30),
 JOB_TYPE               	VARCHAR2(30),
 LID                    	NUMBER,
 ACCT_NAME              	VARCHAR2(200),
 SHIP_PROPSL_RECEIVED        DATE,
 BATCH_ID               	       VARCHAR2(30),    
 WORK_ORDER_ALIAS_ID       VARCHAR2(30),
 SUBJECT_COUNT                    NUMBER,
 WORK_ORDER_FORM_PRT    DATE,
 RET                    	VARCHAR2(100),
 RET_QTY                	NUMBER,
 RET_PRT                	DATE,
 PKG                    	VARCHAR2(100),
 PKG_QTY               	 NUMBER,
 PKG_PRT                	DATE,
 POS                    	VARCHAR2(100),
 POS_QTY                	NUMBER,
 POS_PRT                	DATE,
 DIGITAL_MEDIA1          	VARCHAR2(100),
 DIGITAL_MEDIA1_QTY     NUMBER,
 DIGITAL_MEDIA1_PRT     	DATE,
 DIGITAL_MEDIA2          	VARCHAR2(100),
 DIGITAL_MEDIA2_QTY     NUMBER,
 DIGITAL_MEDIA2_PRT     	DATE,
 LAMINATE               	VARCHAR2(100),           
 LAMINATE_QTY           	NUMBER,
 LAMINATE_PRT           	DATE,
 MAGNET                 	VARCHAR2(100),
 MAGNET_QTY             	NUMBER,
 MAGNET_PRT            	DATE,
 METALLIC               	VARCHAR2(100),
 METALLIC_QTY           	NUMBER,
 METALLIC_PRT           	DATE, 
 SPECIALITY             	VARCHAR2(100),  
 SPECIALITY_QTY         		NUMBER,
 SPECIALITY_PRODUCED  		DATE,
-- INDIGO_PRODUCT        		VARCHAR2(100),
-- INDIGO_QTY             		NUMBER,
-- INDIGO_PRODUCED      		DATE,
 INDIGO_PRODUCT1               	VARCHAR2(100),
 INDIGO_PRODUCT1_QTY           	NUMBER,
 INDIGO_PRODUCT1_PRODUCED      	DATE,
 INDIGO_PRODUCT2               	VARCHAR2(100),
 INDIGO_PRODUCT2_QTY           	NUMBER,
 INDIGO_PRODUCT2_PRODUCED      	DATE,
 PROOF_PRODUCT          		VARCHAR2(100),
 PROOF_QTY              		NUMBER,
 PROOF_PRODUCED         		DATE,
 CLASS_DELIVERY         	VARCHAR2(100),
 CLASS                  	VARCHAR2(100),
 CLASS_QTY              	NUMBER,
 CLASS_PRT              	DATE,
 DID                    	VARCHAR2(100),
 DID_QTY                	NUMBER,
 DID_PRT                	DATE,
 DSSK                   	VARCHAR2(100), 
 DSSK_QTY               	NUMBER,
 DSSK_PRT               	DATE,
 EZP                    	VARCHAR2(100),
 EZP_QTY                	NUMBER,
 EZP_PRT                	DATE,
 POS618                             VARCHAR2(100),
 POS618_QTY                     NUMBER,
 POS618_PRT                     DATE,
 SPECIAL_REQUEST        	VARCHAR2(100), 
 WORK_ORDER_STATUS   VARCHAR2(100),
 PROCESSING_COMMENT  VARCHAR2(2000), 
 SHIP_GOAL_DATE         	DATE,
 WOMS_NODE              	VARCHAR2(30),
 DEACTIVATED_FLAG      	VARCHAR2(1)
)

&

/*-----------------------------------------------*/
/* TASK No. 10 */
/* Create IDX1 */



CREATE INDEX X1_WO_UNSHIPPED_TEMP2_IX1 ON RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2
(WORK_ORDER_ID,LID,WOMS_NODE)
LOGGING
NOPARALLEL

&

/*-----------------------------------------------*/
/* TASK No. 11 */
/* Create IDX2 */



CREATE INDEX X1_WO_UNSHIPPED_TEMP2_IX2 ON RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2
(WORK_ORDER_ID,WOMS_NODE)
LOGGING
NOPARALLEL

&

/*-----------------------------------------------*/
/* TASK No. 12 */
/* Insert to Temp1 Table */



INSERT INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 
SELECT 
    PLATFORM_DETAIL,
    WORK_ORDER_ID,
    EVENT_REF_ID, 
    JOB_TYPE,
    LID,
    ACCT_NAME,
    SHIP_PROPSL_RECEIVED,
    SHIP_PROPSL_BATCH_ID,    
    WORK_ORDER_ALIAS_ID,
    NULL AS SUBJECT_COUNT,
    WORK_ORDER_FORM_PRT,
    RET,
    SUM(RET_QTY) RET_QTY,
    NULL AS RET_PRT,    
    PKG,
    SUM(PKG_QTY) PKG_QTY,
    NULL AS PKG_PRT,
    POS,
    SUM(POS_QTY) POS_QTY,
    POS_PRT,
    DIGITAL_MEDIA1,
    SUM(DIGITAL_MEDIA1_QTY) DIGITAL_MEDIA1_QTY,
    DIGITAL_MEDIA1_PRT,    
    DIGITAL_MEDIA2,
    SUM(DIGITAL_MEDIA2_QTY) DIGITAL_MEDIA2_QTY,
    DIGITAL_MEDIA2_PRT,  
    LAMINATE,
    SUM(LAMINATE_QTY) AS LAMINATE_QTY, 
    LAMINATE_PRT,
    MAGNET,    
    SUM(MAGNET_QTY) AS MAGNET_QTY,
    MAGNET_PRT,
    METALLIC,    
    SUM(METALLIC_QTY) AS METALLIC_QTY,
    METALLIC_PRT,
    SPECIALITY, 
    SUM(SPECIALITY_QTY) AS SPECIALITY_QTY ,
    SPECIALITY_PRODUCED,
    INDIGO_PRODUCT1               		                     ,
    SUM(INDIGO_PRODUCT1_QTY) AS    INDIGO_PRODUCT1_QTY ,
    INDIGO_PRODUCT1_PRODUCED      		                     ,
    INDIGO_PRODUCT2               		                     ,
    SUM(INDIGO_PRODUCT2_QTY)      INDIGO_PRODUCT2_QTY  	,
    INDIGO_PRODUCT2_PRODUCED      		                     ,
    PROOF,
    SUM(PROOF_QTY) AS PROOF_QTY,
    PROOF_PRODUCED,           
    CLASS_DELIVER_TYPE,
    CLASS,   
    SUM(CLASS_QTY) CLASS_QTY,
    CLASS_PRT,
    DID,        
    SUM(DID_QTY) DID_QTY,
    DID_PRT,
    DSSK,
    SUM(DSSK_QTY) DSSK_QTY,
    DSSK_PRT,
    EZP,
    SUM(EZP_QTY) EZP_QTY,
    EZP_PRT,
    POS618,
    SUM(POS618_QTY) POS618_QTY,
    POS618_PRT,
    NULL AS SPECIAL_REQUEST,
    STATUS,
    PROCESSING_COMMENT,
    SHIP_GOAL_DATE,
    WOMS_NODE,
    DEACTIVATED_FLAG
FROM
( 
 SELECT 
    VW.PLATFORM_DETAIL AS PLATFORM_DETAIL,
    WO.WORK_ORDER_ID,
    EVENT.EVENT_REF_ID AS EVENT_REF_ID,
    EVENT.SELLING_METHOD AS JOB_TYPE,
    APO.LIFETOUCH_ID AS LID,
    ACCOUNT.ACCOUNT_NAME AS ACCT_NAME,
    WO.RECEIVED_DATE AS SHIP_PROPSL_RECEIVED,
    NULL AS MAIL_RECEIVED,
    BATCH.SHIP_PROPSL_BATCH_ID AS SHIP_PROPSL_BATCH_ID,
    WO.WORK_ORDER_ALIAS_ID AS WORK_ORDER_ALIAS_ID,
    NULL AS SUBJECT_COUNT,    
    NULL AS WORK_ORDER_FORM_PRT, 
    NULL AS SESSION_ID,
    WO.DEACTIVATED_DATE,   
    NULL AS RET,
    NULL AS RET_QTY,
    NULL AS RET_PRT,
    NULL AS PKG,
    NULL AS PKG_QTY,
    NULL AS PKG_PRT,
    'POS' AS POS,
    NULL AS POS_QTY,
    NULL AS POS_PRT,
    NULL AS DIGITAL_MEDIA1,
    NULL AS DIGITAL_MEDIA1_QTY,
    NULL AS DIGITAL_MEDIA1_PRT,
    NULL AS DIGITAL_MEDIA2,
    NULL AS DIGITAL_MEDIA2_QTY,
    NULL AS DIGITAL_MEDIA2_PRT,
    NULL AS LAMINATE,
    NULL AS LAMINATE_QTY,
    NULL AS LAMINATE_PRT,
    NULL AS MAGNET,
    NULL AS MAGNET_QTY,
    NULL AS MAGNET_PRT,
    NULL AS METALLIC,
    NULL AS METALLIC_QTY,
    NULL AS METALLIC_PRT,
    NULL AS SPECIALITY,
    NULL AS SPECIALITY_QTY,
    NULL AS SPECIALITY_PRODUCED,
    NULL AS  INDIGO_PRODUCT1               ,
    NULL AS  INDIGO_PRODUCT1_QTY           ,
    NULL AS  INDIGO_PRODUCT1_PRODUCED      ,
    NULL AS  INDIGO_PRODUCT2               ,
    NULL AS  INDIGO_PRODUCT2_QTY           ,
    NULL AS  INDIGO_PRODUCT2_PRODUCED      ,
    NULL AS PROOF,
    NULL AS PROOF_QTY,
    NULL AS PROOF_PRODUCED,
    NULL AS CLASS_DELIVER_TYPE,
    NULL AS CLASS,
    NULL AS CLASS_QTY,
    NULL AS CLASS_PRT,
    NULL AS DID,
    NULL AS DID_QTY,
    NULL AS DID_PRT,
    NULL AS DSSK,
    NULL AS DSSK_QTY,
    NULL AS DSSK_PRT,
    NULL AS EZP,
    NULL AS EZP_QTY,
    NULL AS EZP_PRT,
    NULL AS POS618,
    NULL AS POS618_QTY,
    NULL AS POS618_PRT,
    WO.STATUS,
    WO.PROCESSING_COMMENT,
    WO.SHIP_GOAL_DATE,
    WO.WOMS_NODE,
    NULL AS DEACTIVATED_FLAG    
    FROM  
                  
                  ODS_STAGE.WOMS_WORK_ORDER_STG WO,
                  ODS_STAGE.WOMS_ORDER_BATCH_STG BATCH,
                  ODS_STAGE.WOMS_WORK_ORDER_DETAIL_STG WOD,
                  ODS_OWN.APO,
                  ODS_OWN.APO_TAG_VW VW ,
                  ODS_OWN.ACCOUNT,
                  ODS_OWN.EVENT               
                                  
    WHERE  
                1 = 1                
                AND WO.WORK_ORDER_ID = BATCH.WORK_ORDER_ID(+)   
                AND WO.WOMS_NODE = BATCH.WOMS_NODE(+)
                AND WO.WOMS_NODE = WOD.WOMS_NODE
                AND WO.WORK_ORDER_ID = WOD.WORK_ORDER_ID
                AND WOD.APO_ID = APO.APO_ID
                AND APO.APO_ID = VW.APO_ID
                AND APO.ACCOUNT_OID = ACCOUNT.ACCOUNT_OID
                AND APO.VISION_JOB_NO = EVENT.EVENT_REF_ID(+)              
                AND WO.ODS_MODIFY_DATE >  ( SELECT LAST_CDC_COMPLETION_DATE - .010
			        FROM ODS.DW_CDC_LOAD_STATUS
                                                                        WHERE DW_TABLE_NAME = 'X1_WO_UNSHIPPED')
                AND WOD.ODS_CREATE_DATE >= (SELECT MIN(DATE_KEY) FROM MART.TIME
                			WHERE FISCAL_YEAR = (SELECT FISCAL_YEAR FROM MART.TIME 
                                                                WHERE DATE_KEY = TRUNC(SYSDATE))-1)         
-- AND WO.STATUS NOT IN ('Canceled Acknowledged','Lab Canceled')   
    AND WO.WOMS_NODE IN (
                                                select distinct plant_group from MART.PLANT_NAME_XREF
		     where plant_group in (select  case when 'United States' <> :v_data_center
                                                                                then 'Winnipeg' 
                                                                                else plant_group 
                                                                                end from MART.PLANT_NAME_XREF)                  
                                               )
	AND WO.WORK_ORDER_ID not in (6691166)    
)                                          
 GROUP BY
    PLATFORM_DETAIL,
    WORK_ORDER_ID,
    EVENT_REF_ID, 
    JOB_TYPE,
    LID,
    ACCT_NAME,
    SHIP_PROPSL_RECEIVED,
    SHIP_PROPSL_BATCH_ID,    
    WORK_ORDER_ALIAS_ID,  
    NULL,  
    WORK_ORDER_FORM_PRT,
    RET,    
    RET_PRT,    
    PKG,    
    PKG_PRT,
    POS,    
    POS_PRT,
    DIGITAL_MEDIA1,    
    DIGITAL_MEDIA1_PRT,  
    DIGITAL_MEDIA2,    
    DIGITAL_MEDIA2_PRT,      
    LAMINATE,     
    LAMINATE_PRT,
    MAGNET,       
    MAGNET_PRT,
    METALLIC,        
    METALLIC_PRT,
    SPECIALITY,     
    SPECIALITY_PRODUCED,
    INDIGO_PRODUCT1  ,
    INDIGO_PRODUCT1_PRODUCED      ,
    INDIGO_PRODUCT2  ,  
    INDIGO_PRODUCT2_PRODUCED      ,
    PROOF,    
    PROOF_PRODUCED,           
    CLASS_DELIVER_TYPE,
    CLASS,       
    CLASS_PRT,
    DID,
    DSSK,
    EZP,            
    STATUS,
    PROCESSING_COMMENT,
    SHIP_GOAL_DATE,
    WOMS_NODE,
    DEACTIVATED_FLAG

&

/*-----------------------------------------------*/
/* TASK No. 13 */
/* Drop Temp Table (Non Deactivated WO Lines) */

/* DROP TABLE RAX_APP_USER.TEMP_WORKORDER_DETAIL */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.TEMP_WORKORDER_DETAIL';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 14 */
/* Create Temp Table (Non Deactivated WO Lines) */



-- at least one or more orderlines has non-deactivated Status 
-- ie., WOD.DEACTIVATED_DATE IS NULL 


CREATE TABLE RAX_APP_USER.TEMP_WORKORDER_DETAIL
(
WORK_ORDER_ID 		NUMBER,
LID                                                           NUMBER,
CLASS_DELIVER_TYPE         	VARCHAR2(200),
UNDERCLASS_PRODUCT_CODE    	VARCHAR2(200),
PRODUCE_QUANTITY  		NUMBER,
WOMS_NODE 		VARCHAR2(30)
)

&

/*-----------------------------------------------*/
/* TASK No. 15 */
/* Create IDX */



CREATE INDEX TEMP_WORKORDER_DETAIL_IDX ON RAX_APP_USER.TEMP_WORKORDER_DETAIL
(WORK_ORDER_ID,LID,WOMS_NODE)
LOGGING
NOPARALLEL

&

/*-----------------------------------------------*/
/* TASK No. 16 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.TEMP_WOD_WODEACTIVATED */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.TEMP_WOD_WODEACTIVATED';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 17 */
/* Create Temp Table (WOD WO Deactivated) */



-- capture all detail, whether deactivated or not, for deactivated work orders

CREATE TABLE RAX_APP_USER.TEMP_WOD_WODEACTIVATED
(
WORK_ORDER_ID 		 NUMBER,
LID                                                            NUMBER,
CLASS_DELIVER_TYPE         	 VARCHAR2(200),
UNDERCLASS_PRODUCT_CODE    	 VARCHAR2(200),
PRODUCE_QUANTITY  		 NUMBER,
WOMS_NODE                  		 VARCHAR2(30)
)

&

/*-----------------------------------------------*/
/* TASK No. 18 */
/* Create IDX */



CREATE INDEX TEMP_WOD_WODEACTIVATED_IDX ON RAX_APP_USER.TEMP_WOD_WODEACTIVATED
(WORK_ORDER_ID,LID,WOMS_NODE)
LOGGING
NOPARALLEL

&

/*-----------------------------------------------*/
/* TASK No. 19 */
/* DROP Temp TABLE (TEMP_WO_DEACTIVE_BASED_ON_WOL) */

/* DROP TABLE RAX_APP_USER.TEMP_WO_DEACTIVE_BASED_ON_WOL */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.TEMP_WO_DEACTIVE_BASED_ON_WOL';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 20 */
/* Create Temp Table (TEMP_WO_DEACTIVE_BASED_ON_WOL) */



-- Get list of Workorders NOT DEACTIVATED but ALL orderlines have been deactivated...mark those as deactivated


CREATE TABLE RAX_APP_USER.TEMP_WO_DEACTIVE_BASED_ON_WOL
(
WORK_ORDER_ID                       NUMBER,
LID                                 NUMBER,
WOMS_NODE                           VARCHAR2(30),
WORK_ORDER_DEACTIVATION_DATE        DATE,
ALL_WORK_ORDER_LINES_DEACTIVE       VARCHAR2(30)
--ODS_CREATE_DATE                     DATE,
--ODS_MODIFY_DATE                     DATE
)

&

/*-----------------------------------------------*/
/* TASK No. 21 */
/* Create IDX */



CREATE INDEX TEMP_WO_WODEACTIVE_IDX1 ON RAX_APP_USER.TEMP_WO_DEACTIVE_BASED_ON_WOL
(WORK_ORDER_ID,LID,WOMS_NODE)
LOGGING
NOPARALLEL

&

/*-----------------------------------------------*/
/* TASK No. 22 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_RET */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_RET';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 23 */
/* Create Temp Table (ODS_APP_USER.UC_PRODUCT_CODE_PKG) */



CREATE TABLE RAX_APP_USER.UC_PRODUCT_CODE_RET
(
 WORK_ORDER_ID NUMBER,
 WOMS_NODE VARCHAR2(50),
 LID       NUMBER,
 CLASS_DELIVER_TYPE VARCHAR2(50),
 UNDERCLASS_PRODUCT_CODE VARCHAR2(50),
 PRODUCE_QUANTITY NUMBER
)

&

/*-----------------------------------------------*/
/* TASK No. 24 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_PKG */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_PKG';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 25 */
/* Create Temp Table (ODS_APP_USER.UC_PRODUCT_CODE_PKG) */



CREATE TABLE RAX_APP_USER.UC_PRODUCT_CODE_PKG
(
 WORK_ORDER_ID NUMBER,
 WOMS_NODE VARCHAR2(50),
 LID       NUMBER,
 CLASS_DELIVER_TYPE VARCHAR2(50),
 UNDERCLASS_PRODUCT_CODE VARCHAR2(50),
 PRODUCE_QUANTITY NUMBER
)

&

/*-----------------------------------------------*/
/* TASK No. 26 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_DM_IC */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_DM_IC';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 27 */
/* Create Temp Table (ODS_APP_USER.UC_PRODUCT_CODE_DIGITAL_MEDIA_IC) */



CREATE TABLE RAX_APP_USER.UC_PRODUCT_CODE_DM_IC
(
 WORK_ORDER_ID NUMBER,
 WOMS_NODE VARCHAR2(50),
 LID       NUMBER,
 CLASS_DELIVER_TYPE VARCHAR2(50),
 UNDERCLASS_PRODUCT_CODE VARCHAR2(50),
 PRODUCE_QUANTITY NUMBER
)

&

/*-----------------------------------------------*/
/* TASK No. 28 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_DM_IG */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_DM_IG';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 29 */
/* Create Temp Table (ODS_APP_USER.UC_PRODUCT_CODE_DIGITAL_MEDIA_IG) */



CREATE TABLE RAX_APP_USER.UC_PRODUCT_CODE_DM_IG
(
 WORK_ORDER_ID NUMBER,
 WOMS_NODE VARCHAR2(50),
 LID       NUMBER,
 CLASS_DELIVER_TYPE VARCHAR2(50),
 UNDERCLASS_PRODUCT_CODE VARCHAR2(50),
 PRODUCE_QUANTITY NUMBER
)

&

/*-----------------------------------------------*/
/* TASK No. 30 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_LAMINATE */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_LAMINATE';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 31 */
/* Create Temp Table (ODS_APP_USER.UC_PRODUCT_CODE_LAMINATE) */



CREATE TABLE RAX_APP_USER.UC_PRODUCT_CODE_LAMINATE
(
 WORK_ORDER_ID NUMBER,
 WOMS_NODE VARCHAR2(50),
 LID       NUMBER,
 CLASS_DELIVER_TYPE VARCHAR2(50),
 UNDERCLASS_PRODUCT_CODE VARCHAR2(50),
 PRODUCE_QUANTITY NUMBER
)

&

/*-----------------------------------------------*/
/* TASK No. 32 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_MAGNET */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_MAGNET';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 33 */
/* Create Temp Table (ODS_APP_USER.UC_PRODUCT_CODE_MAGNET) */



CREATE TABLE RAX_APP_USER.UC_PRODUCT_CODE_MAGNET
(
 WORK_ORDER_ID NUMBER,
 WOMS_NODE VARCHAR2(50),
 LID       NUMBER,
 CLASS_DELIVER_TYPE VARCHAR2(50),
 UNDERCLASS_PRODUCT_CODE VARCHAR2(50),
 PRODUCE_QUANTITY NUMBER
)

&

/*-----------------------------------------------*/
/* TASK No. 34 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_METALLIC */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_METALLIC';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 35 */
/* Create Temp Table (ODS_APP_USER.UC_PRODUCT_CODE_METALLIC) */



CREATE TABLE RAX_APP_USER.UC_PRODUCT_CODE_METALLIC
(
 WORK_ORDER_ID NUMBER,
 WOMS_NODE VARCHAR2(50),
 LID       NUMBER,
 CLASS_DELIVER_TYPE VARCHAR2(50),
 UNDERCLASS_PRODUCT_CODE VARCHAR2(50),
 PRODUCE_QUANTITY NUMBER
)

&

/*-----------------------------------------------*/
/* TASK No. 36 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_SPECIALITY */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_SPECIALITY';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 37 */
/* Create Temp Table (ODS_APP_USER.UC_PRODUCT_CODE_SPECIALITY) */



CREATE TABLE RAX_APP_USER.UC_PRODUCT_CODE_SPECIALITY
(
 WORK_ORDER_ID NUMBER,
 WOMS_NODE VARCHAR2(50),
 LID       NUMBER,
 CLASS_DELIVER_TYPE VARCHAR2(50),
 UNDERCLASS_PRODUCT_CODE VARCHAR2(50),
 PRODUCE_QUANTITY NUMBER
)

&

/*-----------------------------------------------*/
/* TASK No. 38 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_INDIGO_FT */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_INDIGO_FT';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 39 */
/* Create Temp Table (ODS_APP_USER.UC_PRODUCT_CODE_INDIGO) */



CREATE TABLE RAX_APP_USER.UC_PRODUCT_CODE_INDIGO_FT
(
 WORK_ORDER_ID NUMBER,
 WOMS_NODE VARCHAR2(50),
 LID       NUMBER,
 CLASS_DELIVER_TYPE VARCHAR2(50),
 UNDERCLASS_PRODUCT_CODE VARCHAR2(50),
 PRODUCE_QUANTITY NUMBER
)

&

/*-----------------------------------------------*/
/* TASK No. 40 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_INDIGO_NA */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_INDIGO_NA';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 41 */
/* Create Temp Table (ODS_APP_USER.UC_PRODUCT_CODE_INDIGO_NA) */



CREATE TABLE RAX_APP_USER.UC_PRODUCT_CODE_INDIGO_NA
(
 WORK_ORDER_ID        NUMBER,
 WOMS_NODE                VARCHAR2(50),
 LID                                 NUMBER,
 CLASS_DELIVER_TYPE  VARCHAR2(50),
 UNDERCLASS_PRODUCT_CODE     VARCHAR2(50),
 PRODUCE_QUANTITY                      NUMBER
)

&

/*-----------------------------------------------*/
/* TASK No. 42 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_PROOF */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_PROOF';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 43 */
/* Create Temp Table (ODS_APP_USER.UC_PRODUCT_CODE_PROOF) */



CREATE TABLE RAX_APP_USER.UC_PRODUCT_CODE_PROOF
(
 WORK_ORDER_ID NUMBER,
 WOMS_NODE VARCHAR2(50),
 LID       NUMBER,
 CLASS_DELIVER_TYPE VARCHAR2(50),
 UNDERCLASS_PRODUCT_CODE VARCHAR2(50),
 PRODUCE_QUANTITY NUMBER
)

&

/*-----------------------------------------------*/
/* TASK No. 44 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_CLASS */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_CLASS';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 45 */
/* Create Temp Table (ODS_APP_USER.UC_PRODUCT_CODE_CLASS) */



CREATE TABLE RAX_APP_USER.UC_PRODUCT_CODE_CLASS
(
 WORK_ORDER_ID NUMBER,
 WOMS_NODE VARCHAR2(50),
 LID       NUMBER,
 CLASS_DELIVER_TYPE VARCHAR2(50),
 UNDERCLASS_PRODUCT_CODE VARCHAR2(50),
 PRODUCE_QUANTITY NUMBER
)

&

/*-----------------------------------------------*/
/* TASK No. 46 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_DID */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_DID';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 47 */
/* Create Temp Table (ODS_APP_USER.UC_PRODUCT_CODE_DID) */



CREATE TABLE RAX_APP_USER.UC_PRODUCT_CODE_DID
(
 WORK_ORDER_ID NUMBER,
 WOMS_NODE VARCHAR2(50),
 LID       NUMBER,
 CLASS_DELIVER_TYPE VARCHAR2(50),
 UNDERCLASS_PRODUCT_CODE VARCHAR2(50),
 PRODUCE_QUANTITY NUMBER
)

&

/*-----------------------------------------------*/
/* TASK No. 48 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_DSSK */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_DSSK';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 49 */
/* Create Temp Table (ODS_APP_USER.UC_PRODUCT_CODE_DSSK) */



CREATE TABLE RAX_APP_USER.UC_PRODUCT_CODE_DSSK
(
 WORK_ORDER_ID NUMBER,
 WOMS_NODE VARCHAR2(50),
 LID       NUMBER,
 CLASS_DELIVER_TYPE VARCHAR2(50),
 UNDERCLASS_PRODUCT_CODE VARCHAR2(50),
 PRODUCE_QUANTITY NUMBER
)

&

/*-----------------------------------------------*/
/* TASK No. 50 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_EZP */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_EZP';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 51 */
/* Create Temp Table (ODS_APP_USER.UC_PRODUCT_CODE_EZP) */



CREATE TABLE RAX_APP_USER.UC_PRODUCT_CODE_EZP
(
 WORK_ORDER_ID NUMBER,
 WOMS_NODE VARCHAR2(50),
 LID       NUMBER,
 CLASS_DELIVER_TYPE VARCHAR2(50),
 UNDERCLASS_PRODUCT_CODE VARCHAR2(50),
 PRODUCE_QUANTITY NUMBER
)

&

/*-----------------------------------------------*/
/* TASK No. 52 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.TEMP_WORK_ORDER_SUBJECT_COUNT CASCADE CONSTRAINTS */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.TEMP_WORK_ORDER_SUBJECT_COUNT CASCADE CONSTRAINTS';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 53 */
/* CREATE TABLE TEMP_WORK_ORDER_SUBJECT_COUNT */



CREATE TABLE RAX_APP_USER.TEMP_WORK_ORDER_SUBJECT_COUNT
(
    WORK_ORDER_ID                           NUMBER,  
    LID                                                   NUMBER,
    WORK_ORDER_SUBJECT_COUNT  NUMBER,
    CLASS_DELIVER_TYPE                    VARCHAR2(50),
    WOMS_NODE                                  VARCHAR2(30)
)

&

/*-----------------------------------------------*/
/* TASK No. 54 */
/* Create IDX */



CREATE INDEX TEMP_WO_SUBJ_COUNT_IDX1 ON RAX_APP_USER.TEMP_WORK_ORDER_SUBJECT_COUNT
(WORK_ORDER_ID,LID,WOMS_NODE)
LOGGING
NOPARALLEL

&

/*-----------------------------------------------*/
/* TASK No. 55 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.TEMP_WO_SUBJ_COUNT_WODEACTIVE CASCADE CONSTRAINTS */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.TEMP_WO_SUBJ_COUNT_WODEACTIVE CASCADE CONSTRAINTS';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 56 */
/* CREATE TABLE ODS_APP_USER.TEMP_WO_SUBJ_COUNT_WODEACTIVE */



CREATE TABLE RAX_APP_USER.TEMP_WO_SUBJ_COUNT_WODEACTIVE
(
 WORK_ORDER_ID                          NUMBER, 
 LID                                                  NUMBER, 
 WORK_ORDER_SUBJECT_COUNT  NUMBER,
 CLASS_DELIVER_TYPE                    VARCHAR2(50),
 WOMS_NODE                                  VARCHAR2(30)
)

&

/*-----------------------------------------------*/
/* TASK No. 57 */
/* Create IDX */



CREATE INDEX TEMP_WO_SUBCNT_WODEACT_IDX1 ON RAX_APP_USER.TEMP_WO_SUBJ_COUNT_WODEACTIVE
(WORK_ORDER_ID,LID,WOMS_NODE)
LOGGING
NOPARALLEL

&

/*-----------------------------------------------*/
/* TASK No. 58 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.TEMP_WO_SPECIALREQUEST CASCADE CONSTRAINTS */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.TEMP_WO_SPECIALREQUEST CASCADE CONSTRAINTS';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 59 */
/* CREATE TABLE ODS_APP_USER.TEMP_WO_SPECIALREQUEST */



CREATE TABLE RAX_APP_USER.TEMP_WO_SPECIALREQUEST
(
    WORK_ORDER_ID             NUMBER,
    LID                                     NUMBER,  
    SPECIAL_REQUEST           VARCHAR2(1),
    WOMS_NODE                    VARCHAR2(30)
)

&

/*-----------------------------------------------*/
/* TASK No. 60 */
/* Create IDX */



CREATE INDEX TEMP_WO_SPECIALREQUEST_IDX1 ON RAX_APP_USER.TEMP_WO_SPECIALREQUEST
(WORK_ORDER_ID,LID,WOMS_NODE)
LOGGING
NOPARALLEL

&

/*-----------------------------------------------*/
/* TASK No. 61 */
/* Drop Temp Table */

/* DROP TABLE  RAX_APP_USER.TEMP_WO_SESSIONS CASCADE CONSTRAINTS */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE  RAX_APP_USER.TEMP_WO_SESSIONS CASCADE CONSTRAINTS';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 62 */
/* CREATE TABLE ODS_APP_USER.TEMP_WO_SESSIONS */



----Get list of sessions who did not order anything and are only getting POS sheet


CREATE TABLE RAX_APP_USER.TEMP_WO_SESSIONS
(
 WORK_ORDER_ID  	NUMBER,
 LID                                    NUMBER,
 SESSION_ID     	VARCHAR2(30),
 WOMS_NODE   	VARCHAR2(30)
)

&

/*-----------------------------------------------*/
/* TASK No. 63 */
/* Create IDX */



CREATE INDEX TEMP_WO_SESSIONS_IDX1 ON RAX_APP_USER.TEMP_WO_SESSIONS
(WORK_ORDER_ID,LID,WOMS_NODE)
LOGGING
NOPARALLEL

&

/*-----------------------------------------------*/
/* TASK No. 64 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.TEMP_POS CASCADE CONSTRAINTS */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.TEMP_POS CASCADE CONSTRAINTS';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 65 */
/* CREATE TABLE ODS_APP_USER.TEMP_POS */



CREATE TABLE RAX_APP_USER.TEMP_POS
    (
    WORK_ORDER_ID  	                  NUMBER,
    LID                                                   NUMBER,
    UNDERCLASS_PRODUCT_CODE     VARCHAR2(200),  
    CLASS_DELIVERY                            VARCHAR2(200),
    PRODUCT_QTY                                NUMBER,
    PRODUCT_PRODUCED                    DATE,
    PRODUCT_SHIPPED                        DATE,
    WOMS_NODE                                  VARCHAR2(30)
    )

&

/*-----------------------------------------------*/
/* TASK No. 66 */
/* Create IDX */



CREATE INDEX TEMP_POS_IDX1 ON RAX_APP_USER.TEMP_POS
(WORK_ORDER_ID,LID,WOMS_NODE)
LOGGING
NOPARALLEL

&

/*-----------------------------------------------*/
/* TASK No. 67 */
/* Drop Temp Table */

/* Drop Table RAX_APP_USER.X1_WO_SHIPPED_TEMP CASCADE CONSTRAINTS */

BEGIN
    EXECUTE IMMEDIATE 'Drop Table RAX_APP_USER.X1_WO_SHIPPED_TEMP CASCADE CONSTRAINTS';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 68 */
/* Create Table ODS_APP_USER.X1_WO_SHIPPED_TEMP */



CREATE TABLE RAX_APP_USER.X1_WO_SHIPPED_TEMP
(
WORK_ORDER_ID NUMBER,
WOMS_NODE VARCHAR2(30),
LID   NUMBER,
STATUS  VARCHAR2(100)
)

&

/*-----------------------------------------------*/
/* TASK No. 69 */
/* Create IDX */



CREATE INDEX X1_WO_SHIPPED_TEMP_IX1 ON RAX_APP_USER.X1_WO_SHIPPED_TEMP
(WORK_ORDER_ID,LID,WOMS_NODE)
LOGGING
NOPARALLEL

&

/*-----------------------------------------------*/
/* TASK No. 70 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.X1_WO_PRODUCE_DT_TEMP CASCADE CONSTRAINTS */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.X1_WO_PRODUCE_DT_TEMP CASCADE CONSTRAINTS';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 71 */
/* Create Temp_Produce_DT Table */



CREATE TABLE RAX_APP_USER.X1_WO_PRODUCE_DT_TEMP
(
 WOMS_NODE                    	VARCHAR2(30),
 WORK_ORDER_ID            	NUMBER,
  LID                      		NUMBER,
  UNDERCLASS_PRODUCT_CODE  	VARCHAR2(200),
  PRODUCE_PRODUCED_DT          	DATE,
  PRODUCT_SHIPPED_DT                        DATE,
  STATUS_ID                                            NUMBER
)

&

/*-----------------------------------------------*/
/* TASK No. 72 */
/* Create IDX */



CREATE INDEX X1_WO_PRODUCE_DT_TEMP ON RAX_APP_USER.X1_WO_PRODUCE_DT_TEMP
(WORK_ORDER_ID,LID,WOMS_NODE)
LOGGING
NOPARALLEL

&

/*-----------------------------------------------*/
/* TASK No. 73 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 CASCADE CONSTRAINTS */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 CASCADE CONSTRAINTS';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 74 */
/* Create Temp3 Table (ODS_APP_USER.X1_WO_UNSHIPPED_TEMP3) */



CREATE TABLE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3
(
 PLATFORM_DETAIL        	VARCHAR2(30),
 WORK_ORDER_ID         	NUMBER,
 EVENT_REF_ID           	VARCHAR2(30),
 JOB_TYPE               	VARCHAR2(30),
 LID                    	NUMBER,
 ACCT_NAME              	     VARCHAR2(200),
 SHIP_PROPSL_RECEIVED      DATE,
 BATCH_ID               	     VARCHAR2(30),    
 WORK_ORDER_ALIAS_ID     VARCHAR2(30),
 SUBJECT_COUNT                   NUMBER,
 WORK_ORDER_FORM_PRT   DATE,
 RET                    	     VARCHAR2(100),
 RET_QTY                	  NUMBER,
 RET_PRT                	  DATE,
 PKG                    	  VARCHAR2(100),
 PKG_QTY               	  NUMBER,
 PKG_PRT                	  DATE,
 POS                    	  VARCHAR2(100),
 POS_QTY                	  NUMBER,
 POS_PRT                	  DATE,
 DIGITAL_MEDIA          	  VARCHAR2(100),
 DIGITAL_MEDIA_QTY         NUMBER,
 DIGITAL_MEDIA_PRT     	  DATE,
-- DIGITAL_MEDIA1          	  VARCHAR2(100),
-- DIGITAL_MEDIA1_QTY     NUMBER,
-- DIGITAL_MEDIA1_PRT     DATE,
-- DIGITAL_MEDIA2          	  VARCHAR2(100),
-- DIGITAL_MEDIA2_QTY     NUMBER,
-- DIGITAL_MEDIA2_PRT     DATE,
 LAMINATE               	   VARCHAR2(100),           
 LAMINATE_QTY           	   NUMBER,
 LAMINATE_PRT           	DATE,
 MAGNET                 	VARCHAR2(100),
 MAGNET_QTY             	NUMBER,
 MAGNET_PRT            	DATE,
 METALLIC               	VARCHAR2(100),
 METALLIC_QTY           	NUMBER,
 METALLIC_PRT           	DATE, 
 SPECIALITY             	VARCHAR2(100),  
 SPECIALITY_QTY         		NUMBER,
 SPECIALITY_PRODUCED  		DATE,
 INDIGO_PRODUCT              	VARCHAR2(100),
 INDIGO_PRODUCT_QTY           	NUMBER,
 INDIGO_PRODUCT_PRODUCED      	DATE,
-- INDIGO_PRODUCT1               	VARCHAR2(100),
-- INDIGO_PRODUCT1_QTY           	NUMBER,
-- INDIGO_PRODUCT1_PRODUCED      	DATE,
-- INDIGO_PRODUCT2               	VARCHAR2(100),
-- INDIGO_PRODUCT2_QTY           	NUMBER,
-- INDIGO_PRODUCT2_PRODUCED      	DATE,
 PROOF_PRODUCT          		VARCHAR2(100),
 PROOF_QTY              		NUMBER,
 PROOF_PRODUCED         		DATE,
 CLASS_DELIVERY         	VARCHAR2(100),
 CLASS                  	VARCHAR2(100),
 CLASS_QTY              	NUMBER,
 CLASS_PRT              	DATE,
 DID                    	VARCHAR2(100),
 DID_QTY                	NUMBER,
 DID_PRT                	DATE,
 DSSK                   	VARCHAR2(100), 
 DSSK_QTY               	NUMBER,
 DSSK_PRT               	DATE,
 EZP                    	VARCHAR2(100),
 EZP_QTY                	NUMBER,
 EZP_PRT                	DATE,
 POS618                             VARCHAR2(100),
 POS618_QTY                     NUMBER,
 POS618_PRT                     DATE,
 SPECIAL_REQUEST        	VARCHAR2(100), 
 WORK_ORDER_STATUS   VARCHAR2(100),
 PROCESSING_COMMENT  VARCHAR2(2000), 
 SHIP_GOAL_DATE         	DATE,
 WOMS_NODE              	VARCHAR2(30),
 DEACTIVATED_FLAG      	VARCHAR2(1)
)

&

/*-----------------------------------------------*/
/* TASK No. 75 */
/* Create IDX1 */



CREATE INDEX X1_WO_UNSHIPPED_TEMP3_IX1 ON RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3
(WORK_ORDER_ID,LID,WOMS_NODE)
LOGGING
NOPARALLEL

&

/*-----------------------------------------------*/
/* TASK No. 76 */
/* Create IDX2 */



CREATE INDEX X1_WO_UNSHIPPED_TEMP3_IX2 ON RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3
(WORK_ORDER_ID,WOMS_NODE)
LOGGING
NOPARALLEL

&

/*-----------------------------------------------*/
/* TASK No. 77 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.ONE_TO_MANY_X1_WO */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.ONE_TO_MANY_X1_WO';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 78 */
/* Create Temp Table */



CREATE TABLE RAX_APP_USER.ONE_TO_MANY_X1_WO
(
WORK_ORDER_ID   NUMBER,
LID             	           NUMBER,
WOMS_NODE          VARCHAR2(50),
CNT             	           NUMBER,
ATTR                       VARCHAR2(30)
)

&

/*-----------------------------------------------*/
/* TASK No. 79 */
/* Create IDX */



CREATE INDEX ONE_TO_MANY_X1_WO_IX1 ON RAX_APP_USER.ONE_TO_MANY_X1_WO
(WORK_ORDER_ID,LID,WOMS_NODE)
LOGGING
NOPARALLEL

&

/*-----------------------------------------------*/
/* TASK No. 80 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_DM */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_DM';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 81 */
/* Create Temp Table (ODS_APP_USER.UC_PRODUCT_CODE_DM) */



CREATE TABLE RAX_APP_USER.UC_PRODUCT_CODE_DM
(
 WORK_ORDER_ID NUMBER,
 WOMS_NODE VARCHAR2(50),
 LID       NUMBER,
 CLASS_DELIVER_TYPE VARCHAR2(50),
 UNDERCLASS_PRODUCT_CODE VARCHAR2(50),
 PRODUCE_QUANTITY NUMBER
)

&

/*-----------------------------------------------*/
/* TASK No. 82 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_INDIGO */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_INDIGO';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 83 */
/* Create Temp Table (ODS_APP_USER.UC_PRODUCT_CODE_INDIGO) */



CREATE TABLE RAX_APP_USER.UC_PRODUCT_CODE_INDIGO
(
 WORK_ORDER_ID NUMBER,
 WOMS_NODE VARCHAR2(50),
 LID       NUMBER,
 CLASS_DELIVER_TYPE VARCHAR2(50),
 UNDERCLASS_PRODUCT_CODE VARCHAR2(50),
 PRODUCE_QUANTITY NUMBER
)

&

/*-----------------------------------------------*/
/* TASK No. 84 */
/* Update Account Name - Replace Comma */



UPDATE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 
SET ACCT_NAME = REPLACE(ACCT_NAME,',','-')

&

/*-----------------------------------------------*/
/* TASK No. 85 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_618 */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_618';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 86 */
/* Create Temp Table -  (ODS_APP_USER.UC_PRODUCT_CODE_618) */



CREATE TABLE RAX_APP_USER.UC_PRODUCT_CODE_618
(
 WORK_ORDER_ID NUMBER,
 WOMS_NODE VARCHAR2(50),
 LID       NUMBER,
 CLASS_DELIVER_TYPE VARCHAR2(50),
 UNDERCLASS_PRODUCT_CODE VARCHAR2(50),
 PRODUCE_QUANTITY NUMBER
)

&

/*-----------------------------------------------*/
/* TASK No. 87 */
/* Insert Temp Table (Non Deactivated WO Lines) */



-- at least one or more orderlines has non-deactivated Status 
-- ie., WOD.DEACTIVATED_DATE IS NULL 

INSERT INTO RAX_APP_USER.TEMP_WORKORDER_DETAIL
SELECT DISTINCT WOD.WORK_ORDER_ID,APO.LIFETOUCH_ID AS LID,
                CASE 
                  WHEN APO.group_prod_delivery_type is null
                  THEN APO.comp_prod_delivery_type                  
                  ELSE APO.group_prod_delivery_type 
                END AS CLASS_DELIVER_TYPE,
                OMS.UNDERCLASS_PRODUCT_CODE, 
                SUM(WOD.PRODUCE_QUANTITY) as PRODUCE_QUANTITY,
                WOD.WOMS_NODE                
    FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1  TEMP,
         ODS_STAGE.WOMS_WORK_ORDER_DETAIL_STG WOD,         
         ODS_STAGE.WOMS_ITEM_ID_REFERENCE_STG ITEM,
         ODS_STAGE.WOMS_XREF_OMS_PROD_STG OMS,
         ODS_OWN.APO APO
         WHERE  1 = 1
         AND TEMP.WORK_ORDER_ID = WOD.WORK_ORDER_ID  
         AND TEMP.WOMS_NODE  = WOD.WOMS_NODE
         AND WOD.ITEM_ID_REFERENCE_ID = ITEM.ITEM_ID_REFERENCE_ID
         AND ITEM.XREF_OMS_PROD_ID = OMS.XREF_OMS_PROD_ID 
         AND WOD.APO_ID = APO.APO_ID
         AND WOD.DEACTIVATED_DATE IS NULL 
         AND ITEM.PRODUCIBLE_FLAG = 1     
         AND TEMP.LID = APO.LIFETOUCH_ID    
         AND WOD.ODS_CREATE_DATE >= (SELECT MIN(DATE_KEY) FROM MART.TIME
                                                                    WHERE FISCAL_YEAR = (SELECT FISCAL_YEAR FROM MART.TIME 
                                                                                                        WHERE DATE_KEY = TRUNC(SYSDATE))-1)
    GROUP BY WOD.WORK_ORDER_ID,
                      APO.LIFETOUCH_ID, 	
                      OMS.UNDERCLASS_PRODUCT_CODE, 
                      APO.group_prod_delivery_type,                   
                      APO.comp_prod_delivery_type,
                      WOD.WOMS_NODE

&

/*-----------------------------------------------*/
/* TASK No. 88 */
/* Insert Temp Table (WOD WO Deactivated) */



-- capture all detail, whether deactivated or not, for deactivated work orders

INSERT INTO RAX_APP_USER.TEMP_WOD_WODeactivated
SELECT DISTINCT WOD.WORK_ORDER_ID,APO.LIFETOUCH_ID AS LID,
                CASE WHEN APO.group_prod_delivery_type is null
                    THEN APO.comp_prod_delivery_type                  
                    ELSE APO.group_prod_delivery_type 
                END AS CLASS_DELIVER_TYPE,
                OMS.UNDERCLASS_PRODUCT_CODE, 
                SUM(WOD.PRODUCE_QUANTITY) as PRODUCE_QUANTITY,
                --WOD.DEACTIVATED_DATE,
                WOD.WOMS_NODE
    FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP,
         ODS_STAGE.WOMS_WORK_ORDER_DETAIL_STG WOD,         
         ODS_STAGE.WOMS_ITEM_ID_REFERENCE_STG ITEM,
         ODS_STAGE.WOMS_XREF_OMS_PROD_STG OMS,
         ODS_OWN.APO APO
         WHERE  1 = 1
         AND TEMP.WORK_ORDER_ID = WOD.WORK_ORDER_ID  
         AND TEMP.WOMS_NODE  = WOD.WOMS_NODE
         AND WOD.ITEM_ID_REFERENCE_ID = ITEM.ITEM_ID_REFERENCE_ID
         AND ITEM.XREF_OMS_PROD_ID = OMS.XREF_OMS_PROD_ID 
         AND WOD.APO_ID = APO.APO_ID
         AND WOD.DEACTIVATED_DATE IS NOT NULL 
         AND ITEM.PRODUCIBLE_FLAG = 1
         AND WOD.ODS_CREATE_DATE >= (SELECT MIN(DATE_KEY) FROM MART.TIME
                                                                    WHERE FISCAL_YEAR = (SELECT FISCAL_YEAR FROM MART.TIME 
                                                                                                        WHERE DATE_KEY = TRUNC(SYSDATE))-1)
    GROUP BY  WOD.WORK_ORDER_ID,
                       APO.LIFETOUCH_ID,
                       OMS.UNDERCLASS_PRODUCT_CODE, 
                       APO.group_prod_delivery_type,              
	 APO.comp_prod_delivery_type,
                      WOD.WOMS_NODE

&

/*-----------------------------------------------*/
/* TASK No. 89 */
/* Insert to Temp Table (TEMP_WO_DEACTIVE_BASED_ON_WOL) */



-- Get list of Workorders NOT DEACTIVATED but ALL orderlines have been deactivated...mark those as deactivated


INSERT INTO RAX_APP_USER.TEMP_WO_DEACTIVE_BASED_ON_WOL
SELECT 
                WOD.WORK_ORDER_ID,
                APO.LIFETOUCH_ID AS LID,
                WOD.WOMS_NODE,
                MAX(w.DEACTIVATED_DATE) AS WORK_ORDER_DEACTIVATION_DATE,
                'Y' as ALL_WORK_ORDER_LINES_DEACTIVE                                
    FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1  TEMP,
         ODS_STAGE.WOMS_WORK_ORDER_STG W,
         ODS_STAGE.WOMS_WORK_ORDER_DETAIL_STG WOD,         
         ODS_STAGE.WOMS_ITEM_ID_REFERENCE_STG ITEM,
         ODS_STAGE.WOMS_XREF_OMS_PROD_STG OMS,
         ODS_OWN.APO APO
         WHERE  1 = 1
         AND TEMP.WORK_ORDER_ID = W.WORK_ORDER_ID  
         AND TEMP.WOMS_NODE  = W.WOMS_NODE
         AND TEMP.WORK_ORDER_ID = WOD.WORK_ORDER_ID  
         AND TEMP.WOMS_NODE  = WOD.WOMS_NODE
         AND WOD.ITEM_ID_REFERENCE_ID = ITEM.ITEM_ID_REFERENCE_ID
         AND ITEM.XREF_OMS_PROD_ID = OMS.XREF_OMS_PROD_ID 
         AND WOD.APO_ID = APO.APO_ID
         AND WOD.DEACTIVATED_DATE IS NOT NULL    
         AND W.DEACTIVATED_DATE IS NULL          
         AND ITEM.PRODUCIBLE_FLAG = 1     
         AND TEMP.LID = APO.LIFETOUCH_ID   
         AND WOD.ODS_CREATE_DATE >= (SELECT MIN(DATE_KEY) FROM MART.TIME
                                                                    WHERE FISCAL_YEAR = (SELECT FISCAL_YEAR FROM MART.TIME 
                                                                                                        WHERE DATE_KEY = TRUNC(SYSDATE))-1)
         AND (TEMP.WORK_ORDER_ID,TEMP.LID,TEMP.WOMS_NODE) NOT IN (SELECT WORK_ORDER_ID,LID,WOMS_NODE FROM RAX_APP_USER.TEMP_WORKORDER_DETAIL) 
    GROUP BY  WOD.WORK_ORDER_ID,
              APO.LIFETOUCH_ID,
              WOD.WOMS_NODE,'Y'

&

/*-----------------------------------------------*/
/* TASK No. 90 */
/* Insert to Temp Tables (ODS_APP_USER.UC_PRODUCT_CODE.XXXXXXX) */



begin


INSERT INTO RAX_APP_USER.UC_PRODUCT_CODE_RET
  SELECT 
        TEMP.WORK_ORDER_ID,
        TEMP.WOMS_NODE,
        TEMP.LID,
        NVL(T1.CLASS_DELIVER_TYPE,T2.CLASS_DELIVER_TYPE) AS CLASS_DELIVER_TYPE,
        NVL(T1.UNDERCLASS_PRODUCT_CODE,T2.UNDERCLASS_PRODUCT_CODE) AS UNDERCLASS_PRODUCT_CODE,
        NVL(T1.PRODUCE_QUANTITY,T2.PRODUCE_QUANTITY)  AS PRODUCE_QUANTITY            
   FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP,
              RAX_APP_USER.TEMP_WORKORDER_DETAIL T1,
              RAX_APP_USER.TEMP_WOD_WODeactivated T2
   WHERE 1 = 1
        AND TEMP.WORK_ORDER_ID = T1.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T1.WOMS_NODE(+)
        AND TEMP.LID = T1.LID(+)
        AND TEMP.WORK_ORDER_ID = T2.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T2.WOMS_NODE(+)  
        AND TEMP.LID = T2.LID(+)
        AND T1.UNDERCLASS_PRODUCT_CODE(+) = 'RET' 
        AND T2.UNDERCLASS_PRODUCT_CODE(+) = 'RET';
        
        


INSERT INTO RAX_APP_USER.UC_PRODUCT_CODE_PKG
     SELECT 
        TEMP.WORK_ORDER_ID,
        TEMP.WOMS_NODE,
        TEMP.LID,
        NVL(T1.CLASS_DELIVER_TYPE,T2.CLASS_DELIVER_TYPE) AS CLASS_DELIVER_TYPE,
        NVL(T1.UNDERCLASS_PRODUCT_CODE,T2.UNDERCLASS_PRODUCT_CODE) AS UNDERCLASS_PRODUCT_CODE,
        NVL(T1.PRODUCE_QUANTITY,T2.PRODUCE_QUANTITY)  AS PRODUCE_QUANTITY            
        FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP,
              RAX_APP_USER.TEMP_WORKORDER_DETAIL T1,
              RAX_APP_USER.TEMP_WOD_WODeactivated T2
        WHERE TEMP.WORK_ORDER_ID = T1.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T1.WOMS_NODE(+)
        AND TEMP.LID = T1.LID(+)
        AND TEMP.WORK_ORDER_ID = T2.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T2.WOMS_NODE(+)  
        AND TEMP.LID = T2.LID(+)
        AND  T1.UNDERCLASS_PRODUCT_CODE(+)  IN ('PKG','SBP') 
        AND  T2.UNDERCLASS_PRODUCT_CODE(+)  IN ('PKG','SBP');
        
        

INSERT INTO RAX_APP_USER.UC_PRODUCT_CODE_DM_IC
     SELECT 
        TEMP.WORK_ORDER_ID,
        TEMP.WOMS_NODE,
        TEMP.LID,
        NVL(T1.CLASS_DELIVER_TYPE,T2.CLASS_DELIVER_TYPE) AS CLASS_DELIVER_TYPE,
        NVL(T1.UNDERCLASS_PRODUCT_CODE,T2.UNDERCLASS_PRODUCT_CODE) AS UNDERCLASS_PRODUCT_CODE,
        NVL(T1.PRODUCE_QUANTITY,T2.PRODUCE_QUANTITY)  AS PRODUCE_QUANTITY            
        FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP,
              RAX_APP_USER.TEMP_WORKORDER_DETAIL T1,
              RAX_APP_USER.TEMP_WOD_WODeactivated T2
        WHERE TEMP.WORK_ORDER_ID = T1.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T1.WOMS_NODE(+)
        AND TEMP.LID = T1.LID(+)
        AND TEMP.WORK_ORDER_ID = T2.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T2.WOMS_NODE(+)  
        AND TEMP.LID = T2.LID(+)
        AND T1.UNDERCLASS_PRODUCT_CODE(+)  IN ('IC') 
        AND T2.UNDERCLASS_PRODUCT_CODE(+)  IN ('IC');




INSERT INTO RAX_APP_USER.UC_PRODUCT_CODE_DM_IG
     SELECT 
        TEMP.WORK_ORDER_ID,
        TEMP.WOMS_NODE,
        TEMP.LID,
        NVL(T1.CLASS_DELIVER_TYPE,T2.CLASS_DELIVER_TYPE) AS CLASS_DELIVER_TYPE,
        NVL(T1.UNDERCLASS_PRODUCT_CODE,T2.UNDERCLASS_PRODUCT_CODE) AS UNDERCLASS_PRODUCT_CODE,
        NVL(T1.PRODUCE_QUANTITY,T2.PRODUCE_QUANTITY)  AS PRODUCE_QUANTITY            
        FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP,
              RAX_APP_USER.TEMP_WORKORDER_DETAIL T1,
              RAX_APP_USER.TEMP_WOD_WODeactivated T2
        WHERE TEMP.WORK_ORDER_ID = T1.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T1.WOMS_NODE(+)
        AND TEMP.LID = T1.LID(+)
        AND TEMP.WORK_ORDER_ID = T2.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T2.WOMS_NODE(+)  
        AND TEMP.LID = T2.LID(+)
        AND T1.UNDERCLASS_PRODUCT_CODE(+)  IN ('IG') 
        AND T2.UNDERCLASS_PRODUCT_CODE(+)  IN ('IG');
        



INSERT INTO RAX_APP_USER.UC_PRODUCT_CODE_DM
     SELECT 
        TEMP.WORK_ORDER_ID,
        TEMP.WOMS_NODE,
        TEMP.LID,
        NVL(T1.CLASS_DELIVER_TYPE,T2.CLASS_DELIVER_TYPE) AS CLASS_DELIVER_TYPE,
        NVL(T1.UNDERCLASS_PRODUCT_CODE,T2.UNDERCLASS_PRODUCT_CODE) AS UNDERCLASS_PRODUCT_CODE,
        NVL(T1.PRODUCE_QUANTITY,T2.PRODUCE_QUANTITY)  AS PRODUCE_QUANTITY            
        FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP,
              RAX_APP_USER.TEMP_WORKORDER_DETAIL T1,
              RAX_APP_USER.TEMP_WOD_WODeactivated T2
        WHERE TEMP.WORK_ORDER_ID = T1.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T1.WOMS_NODE(+)
        AND TEMP.LID = T1.LID(+)
        AND TEMP.WORK_ORDER_ID = T2.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T2.WOMS_NODE(+)  
        AND TEMP.LID = T2.LID(+)
        AND T1.UNDERCLASS_PRODUCT_CODE(+)  IN ('IC','IG') 
        AND T2.UNDERCLASS_PRODUCT_CODE(+)  IN ('IC','IG');




INSERT INTO RAX_APP_USER.UC_PRODUCT_CODE_LAMINATE
     SELECT 
        TEMP.WORK_ORDER_ID,
        TEMP.WOMS_NODE,
        TEMP.LID,
        NVL(T1.CLASS_DELIVER_TYPE,T2.CLASS_DELIVER_TYPE) AS CLASS_DELIVER_TYPE,
        NVL(T1.UNDERCLASS_PRODUCT_CODE,T2.UNDERCLASS_PRODUCT_CODE) AS UNDERCLASS_PRODUCT_CODE,
        NVL(T1.PRODUCE_QUANTITY,T2.PRODUCE_QUANTITY)  AS PRODUCE_QUANTITY            
        FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP,
              RAX_APP_USER.TEMP_WORKORDER_DETAIL T1,
              RAX_APP_USER.TEMP_WOD_WODeactivated T2
        WHERE TEMP.WORK_ORDER_ID = T1.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T1.WOMS_NODE(+)
        AND TEMP.LID = T1.LID(+)
        AND TEMP.WORK_ORDER_ID = T2.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T2.WOMS_NODE(+)  
        AND TEMP.LID = T2.LID(+)
        AND T1.UNDERCLASS_PRODUCT_CODE(+) IN ('HL','LC','LG','LP','LR','LT','LU','LX','LY','LZ')
        AND T2.UNDERCLASS_PRODUCT_CODE(+) IN ('HL','LC','LG','LP','LR','LT','LU','LX','LY','LZ');
        
        
        
INSERT INTO RAX_APP_USER.UC_PRODUCT_CODE_MAGNET
     SELECT 
        TEMP.WORK_ORDER_ID,
        TEMP.WOMS_NODE,
        TEMP.LID,
        NVL(T1.CLASS_DELIVER_TYPE,T2.CLASS_DELIVER_TYPE) AS CLASS_DELIVER_TYPE,
        NVL(T1.UNDERCLASS_PRODUCT_CODE,T2.UNDERCLASS_PRODUCT_CODE) AS UNDERCLASS_PRODUCT_CODE,
        NVL(T1.PRODUCE_QUANTITY,T2.PRODUCE_QUANTITY)  AS PRODUCE_QUANTITY            
        FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP,
              RAX_APP_USER.TEMP_WORKORDER_DETAIL T1,
              RAX_APP_USER.TEMP_WOD_WODeactivated T2
        WHERE TEMP.WORK_ORDER_ID = T1.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T1.WOMS_NODE(+)
        AND TEMP.LID = T1.LID(+)
        AND TEMP.WORK_ORDER_ID = T2.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T2.WOMS_NODE(+)  
        AND TEMP.LID = T2.LID(+)
        AND T1.UNDERCLASS_PRODUCT_CODE(+) IN ('HA','MA','ME','MI','MJ','MO','MV','MY','MZ')
        AND T2.UNDERCLASS_PRODUCT_CODE(+) IN ('HA','MA','ME','MI','MJ','MO','MV','MY','MZ');
        
        
INSERT INTO RAX_APP_USER.UC_PRODUCT_CODE_METALLIC
     SELECT 
        TEMP.WORK_ORDER_ID,
        TEMP.WOMS_NODE,
        TEMP.LID,
        NVL(T1.CLASS_DELIVER_TYPE,T2.CLASS_DELIVER_TYPE) AS CLASS_DELIVER_TYPE,
        NVL(T1.UNDERCLASS_PRODUCT_CODE,T2.UNDERCLASS_PRODUCT_CODE) AS UNDERCLASS_PRODUCT_CODE,
        NVL(T1.PRODUCE_QUANTITY,T2.PRODUCE_QUANTITY)  AS PRODUCE_QUANTITY            
        FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP,
              RAX_APP_USER.TEMP_WORKORDER_DETAIL T1,
              RAX_APP_USER.TEMP_WOD_WODeactivated T2
        WHERE TEMP.WORK_ORDER_ID = T1.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T1.WOMS_NODE(+)
        AND TEMP.LID = T1.LID(+)
        AND TEMP.WORK_ORDER_ID = T2.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T2.WOMS_NODE(+)  
        AND TEMP.LID = T2.LID(+)
        AND T1.UNDERCLASS_PRODUCT_CODE(+) IN ('ML','NC','NX')
        AND T2.UNDERCLASS_PRODUCT_CODE(+) IN ('ML','NC','NX');                              



INSERT INTO RAX_APP_USER.UC_PRODUCT_CODE_SPECIALITY
     SELECT 
        TEMP.WORK_ORDER_ID,
        TEMP.WOMS_NODE,
        TEMP.LID,
        NVL(T1.CLASS_DELIVER_TYPE,T2.CLASS_DELIVER_TYPE) AS CLASS_DELIVER_TYPE,
        NVL(T1.UNDERCLASS_PRODUCT_CODE,T2.UNDERCLASS_PRODUCT_CODE) AS UNDERCLASS_PRODUCT_CODE,
        NVL(T1.PRODUCE_QUANTITY,T2.PRODUCE_QUANTITY)  AS PRODUCE_QUANTITY            
        FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP,
              RAX_APP_USER.TEMP_WORKORDER_DETAIL T1,
              RAX_APP_USER.TEMP_WOD_WODeactivated T2
        WHERE TEMP.WORK_ORDER_ID = T1.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T1.WOMS_NODE(+)
        AND TEMP.LID = T1.LID(+)
        AND TEMP.WORK_ORDER_ID = T2.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T2.WOMS_NODE(+)  
        AND TEMP.LID = T2.LID(+)
        AND T1.UNDERCLASS_PRODUCT_CODE(+) IN ('SA','SZ')
        AND T2.UNDERCLASS_PRODUCT_CODE(+) IN ('SA','SZ');
        
        

INSERT INTO RAX_APP_USER.UC_PRODUCT_CODE_INDIGO
       SELECT 
       TEMP.WORK_ORDER_ID,
       TEMP.WOMS_NODE,
        TEMP.LID,
        NVL(T1.CLASS_DELIVER_TYPE,T2.CLASS_DELIVER_TYPE) AS CLASS_DELIVER_TYPE,
        NVL(T1.UNDERCLASS_PRODUCT_CODE,T2.UNDERCLASS_PRODUCT_CODE) AS UNDERCLASS_PRODUCT_CODE,
        NVL(T1.PRODUCE_QUANTITY,T2.PRODUCE_QUANTITY)  AS PRODUCE_QUANTITY            
       FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP,
             RAX_APP_USER.TEMP_WORKORDER_DETAIL T1,
              RAX_APP_USER.TEMP_WOD_WODeactivated T2
        WHERE TEMP.WORK_ORDER_ID = T1.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T1.WOMS_NODE(+)
        AND TEMP.LID = T1.LID(+)
        AND TEMP.WORK_ORDER_ID = T2.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T2.WOMS_NODE(+)  
        AND TEMP.LID = T2.LID(+)
        AND T1.UNDERCLASS_PRODUCT_CODE(+) IN ('642','643','FT','HG','NA','SC')
        AND T2.UNDERCLASS_PRODUCT_CODE(+) IN ('642','643','FT','HG','NA','SC');
        
        


INSERT INTO RAX_APP_USER.UC_PRODUCT_CODE_INDIGO_FT
        SELECT 
        TEMP.WORK_ORDER_ID,
        TEMP.WOMS_NODE,
        TEMP.LID,
        NVL(T1.CLASS_DELIVER_TYPE,T2.CLASS_DELIVER_TYPE) AS CLASS_DELIVER_TYPE,
        NVL(T1.UNDERCLASS_PRODUCT_CODE,T2.UNDERCLASS_PRODUCT_CODE) AS UNDERCLASS_PRODUCT_CODE,
        NVL(T1.PRODUCE_QUANTITY,T2.PRODUCE_QUANTITY)  AS PRODUCE_QUANTITY            
        FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP,
              RAX_APP_USER.TEMP_WORKORDER_DETAIL T1,
              RAX_APP_USER.TEMP_WOD_WODeactivated T2
        WHERE TEMP.WORK_ORDER_ID = T1.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T1.WOMS_NODE(+)
        AND TEMP.LID = T1.LID(+)
        AND TEMP.WORK_ORDER_ID = T2.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T2.WOMS_NODE(+)  
        AND TEMP.LID = T2.LID(+)
        AND T1.UNDERCLASS_PRODUCT_CODE(+) IN ('FT')
        AND T2.UNDERCLASS_PRODUCT_CODE(+) IN ('FT');



INSERT INTO RAX_APP_USER.UC_PRODUCT_CODE_INDIGO_NA
        SELECT 
        TEMP.WORK_ORDER_ID,
        TEMP.WOMS_NODE,
        TEMP.LID,
        NVL(T1.CLASS_DELIVER_TYPE,T2.CLASS_DELIVER_TYPE) AS CLASS_DELIVER_TYPE,
        NVL(T1.UNDERCLASS_PRODUCT_CODE,T2.UNDERCLASS_PRODUCT_CODE) AS UNDERCLASS_PRODUCT_CODE,
        NVL(T1.PRODUCE_QUANTITY,T2.PRODUCE_QUANTITY)  AS PRODUCE_QUANTITY            
        FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP,
              RAX_APP_USER.TEMP_WORKORDER_DETAIL T1,
              RAX_APP_USER.TEMP_WOD_WODeactivated T2
        WHERE TEMP.WORK_ORDER_ID = T1.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T1.WOMS_NODE(+)
        AND TEMP.LID = T1.LID(+)
        AND TEMP.WORK_ORDER_ID = T2.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T2.WOMS_NODE(+)  
        AND TEMP.LID = T2.LID(+)
        AND T1.UNDERCLASS_PRODUCT_CODE(+) IN ('NA')
        AND T2.UNDERCLASS_PRODUCT_CODE(+) IN ('NA');





        
INSERT INTO RAX_APP_USER.UC_PRODUCT_CODE_PROOF        
     SELECT 
        TEMP.WORK_ORDER_ID,
        TEMP.WOMS_NODE,
        TEMP.LID,
        NVL(T1.CLASS_DELIVER_TYPE,T2.CLASS_DELIVER_TYPE) AS CLASS_DELIVER_TYPE,
        NVL(T1.UNDERCLASS_PRODUCT_CODE,T2.UNDERCLASS_PRODUCT_CODE) AS UNDERCLASS_PRODUCT_CODE,
        NVL(T1.PRODUCE_QUANTITY,T2.PRODUCE_QUANTITY)  AS PRODUCE_QUANTITY            
        FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP,
              RAX_APP_USER.TEMP_WORKORDER_DETAIL T1,
              RAX_APP_USER.TEMP_WOD_WODeactivated T2
        WHERE TEMP.WORK_ORDER_ID = T1.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T1.WOMS_NODE(+)
        AND TEMP.LID = T1.LID(+)
        AND TEMP.WORK_ORDER_ID = T2.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T2.WOMS_NODE(+)  
        AND TEMP.LID = T2.LID(+)
        AND T1.UNDERCLASS_PRODUCT_CODE(+) IN ('601','602','603','604')
        AND T2.UNDERCLASS_PRODUCT_CODE(+) IN ('601','602','603','604');
        
        

INSERT INTO RAX_APP_USER.UC_PRODUCT_CODE_CLASS
     SELECT 
        TEMP.WORK_ORDER_ID,
        TEMP.WOMS_NODE,
        TEMP.LID,
        NVL(T1.CLASS_DELIVER_TYPE,T2.CLASS_DELIVER_TYPE) AS CLASS_DELIVER_TYPE,
        NVL(T1.UNDERCLASS_PRODUCT_CODE,T2.UNDERCLASS_PRODUCT_CODE) AS UNDERCLASS_PRODUCT_CODE,
        NVL(T1.PRODUCE_QUANTITY,T2.PRODUCE_QUANTITY)  AS PRODUCE_QUANTITY            
        FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP,
              RAX_APP_USER.TEMP_WORKORDER_DETAIL T1,
              RAX_APP_USER.TEMP_WOD_WODeactivated T2
        WHERE TEMP.WORK_ORDER_ID = T1.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T1.WOMS_NODE(+)
        AND TEMP.LID = T1.LID(+)
        AND TEMP.WORK_ORDER_ID = T2.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T2.WOMS_NODE(+)  
        AND TEMP.LID = T2.LID(+)
        AND T1.UNDERCLASS_PRODUCT_CODE(+) IN ('CMP','G08')
        AND T2.UNDERCLASS_PRODUCT_CODE(+) IN ('CMP','G08');
        
        
        
INSERT INTO RAX_APP_USER.UC_PRODUCT_CODE_DID                                
     SELECT 
        TEMP.WORK_ORDER_ID,
        TEMP.WOMS_NODE,
        TEMP.LID,
        NVL(T1.CLASS_DELIVER_TYPE,T2.CLASS_DELIVER_TYPE) AS CLASS_DELIVER_TYPE,
        NVL(T1.UNDERCLASS_PRODUCT_CODE,T2.UNDERCLASS_PRODUCT_CODE) AS UNDERCLASS_PRODUCT_CODE,
        NVL(T1.PRODUCE_QUANTITY,T2.PRODUCE_QUANTITY)  AS PRODUCE_QUANTITY            
        FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP,
              RAX_APP_USER.TEMP_WORKORDER_DETAIL T1,
              RAX_APP_USER.TEMP_WOD_WODeactivated T2
        WHERE TEMP.WORK_ORDER_ID = T1.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T1.WOMS_NODE(+)
        AND TEMP.LID = T1.LID(+)
        AND TEMP.WORK_ORDER_ID = T2.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T2.WOMS_NODE(+)  
        AND TEMP.LID = T2.LID(+)
        AND T1.UNDERCLASS_PRODUCT_CODE(+) IN ('DCP','DID')
        AND T2.UNDERCLASS_PRODUCT_CODE(+) IN ('DCP','DID');
        
        
        
INSERT INTO RAX_APP_USER.UC_PRODUCT_CODE_DSSK        
     SELECT 
        TEMP.WORK_ORDER_ID,
        TEMP.WOMS_NODE,
        TEMP.LID,
        NVL(T1.CLASS_DELIVER_TYPE,T2.CLASS_DELIVER_TYPE) AS CLASS_DELIVER_TYPE,
        NVL(T1.UNDERCLASS_PRODUCT_CODE,T2.UNDERCLASS_PRODUCT_CODE) AS UNDERCLASS_PRODUCT_CODE,
        NVL(T1.PRODUCE_QUANTITY,T2.PRODUCE_QUANTITY)  AS PRODUCE_QUANTITY            
        FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP,
              RAX_APP_USER.TEMP_WORKORDER_DETAIL T1,
              RAX_APP_USER.TEMP_WOD_WODeactivated T2
        WHERE TEMP.WORK_ORDER_ID = T1.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T1.WOMS_NODE(+)
        AND TEMP.LID = T1.LID(+)
        AND TEMP.WORK_ORDER_ID = T2.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T2.WOMS_NODE(+) 
        AND TEMP.LID = T2.LID(+) 
        AND T1.UNDERCLASS_PRODUCT_CODE(+) IN ('DSSK')
        AND T2.UNDERCLASS_PRODUCT_CODE(+) IN ('DSSK');
        
        
        
INSERT INTO RAX_APP_USER.UC_PRODUCT_CODE_EZP
     SELECT 
        TEMP.WORK_ORDER_ID,
        TEMP.WOMS_NODE,
        TEMP.LID,
        NVL(T1.CLASS_DELIVER_TYPE,T2.CLASS_DELIVER_TYPE) AS CLASS_DELIVER_TYPE,
        NVL(T1.UNDERCLASS_PRODUCT_CODE,T2.UNDERCLASS_PRODUCT_CODE) AS UNDERCLASS_PRODUCT_CODE,
        NVL(T1.PRODUCE_QUANTITY,T2.PRODUCE_QUANTITY)  AS PRODUCE_QUANTITY            
        FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP,
              RAX_APP_USER.TEMP_WORKORDER_DETAIL T1,
              RAX_APP_USER.TEMP_WOD_WODeactivated T2
        WHERE TEMP.WORK_ORDER_ID = T1.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T1.WOMS_NODE(+)
        AND TEMP.LID = T1.LID(+)
        AND TEMP.WORK_ORDER_ID = T2.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T2.WOMS_NODE(+)  
        AND TEMP.LID = T2.LID(+)
        AND T1.UNDERCLASS_PRODUCT_CODE(+) IN ('EZP')
        AND T2.UNDERCLASS_PRODUCT_CODE(+) IN ('EZP');       



INSERT INTO RAX_APP_USER.UC_PRODUCT_CODE_618
        SELECT 
        TEMP.WORK_ORDER_ID,
        TEMP.WOMS_NODE,
        TEMP.LID,
        NVL(T1.CLASS_DELIVER_TYPE,T2.CLASS_DELIVER_TYPE) AS CLASS_DELIVER_TYPE,
        NVL(T1.UNDERCLASS_PRODUCT_CODE,T2.UNDERCLASS_PRODUCT_CODE) AS UNDERCLASS_PRODUCT_CODE,
        NVL(T1.PRODUCE_QUANTITY,T2.PRODUCE_QUANTITY)  AS PRODUCE_QUANTITY            
        FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP,
              RAX_APP_USER.TEMP_WORKORDER_DETAIL T1,
              RAX_APP_USER.TEMP_WOD_WODeactivated T2
        WHERE TEMP.WORK_ORDER_ID = T1.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T1.WOMS_NODE(+)
        AND TEMP.LID = T1.LID(+)
        AND TEMP.WORK_ORDER_ID = T2.WORK_ORDER_ID(+)
        AND TEMP.WOMS_NODE = T2.WOMS_NODE(+)  
        AND TEMP.LID = T2.LID(+)
        AND T1.UNDERCLASS_PRODUCT_CODE(+) IN ('618')
        AND T2.UNDERCLASS_PRODUCT_CODE(+) IN ('618');         


end;

&

/*-----------------------------------------------*/
/* TASK No. 91 */
/* Update Processing Comment  at X1_WO_UNSHIPPED_TEMP1 */



MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 T
USING
    (
    SELECT WORK_ORDER_ID,WOMS_NODE,LISTAGG(INSTRUCTION, ' ...') WITHIN GROUP (ORDER BY INSTRUCTION) "INSTRUCTION"
    FROM
    (
    SELECT WOD.WORK_ORDER_ID,WOD.WOMS_NODE,WOD.INSTRUCTION
       FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 X1,
            ODS_STAGE.WOMS_WORK_ORDER_STG WO,
            ODS_STAGE.WOMS_WORK_ORDER_DETAIL_STG WOD
    WHERE 1 = 1
    AND X1.WORK_ORDER_ID = WO.WORK_ORDER_ID
    AND X1.WOMS_NODE = WO.WOMS_NODE
    AND WO.WORK_ORDER_ID = WOD.WORK_ORDER_ID
    AND WO.WOMS_NODE = WOD.WOMS_NODE
    AND WOD.INSTRUCTION IS NOT NULL
    AND WOD.ODS_CREATE_DATE >= (SELECT MIN(DATE_KEY) FROM MART.TIME
                                WHERE FISCAL_YEAR = (SELECT FISCAL_YEAR FROM MART.TIME 
                                                     WHERE DATE_KEY = TRUNC(SYSDATE))-1)
    GROUP BY WOD.WORK_ORDER_ID,WOD.WOMS_NODE,WOD.INSTRUCTION
    )
    GROUP BY WORK_ORDER_ID,WOMS_NODE
    )S
    ON (T.WORK_ORDER_ID = S.WORK_ORDER_ID AND
        T.WOMS_NODE = S.WOMS_NODE        
        )
        WHEN MATCHED THEN UPDATE
        SET
        T.PROCESSING_COMMENT = S.INSTRUCTION

&

/*-----------------------------------------------*/
/* TASK No. 92 */
/* Update Processing_Comment */



UPDATE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1
SET PROCESSING_COMMENT = REPLACE(PROCESSING_COMMENT,',','-')

&

/*-----------------------------------------------*/
/* TASK No. 93 */
/* Insert all to Temp2 Table */



INSERT INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2
SELECT
T1.PLATFORM_DETAIL          	,
T1.WORK_ORDER_ID            	,
T1.EVENT_REF_ID                 	,
T1.JOB_TYPE                 	    	,	
T1.LID                      		,
T1.ACCT_NAME                		,
T1.SHIP_PROPSL_RECEIVED     	,
T1.BATCH_ID                 		,
T1.WORK_ORDER_ALIAS_ID      	,
T1.SUBJECT_COUNT            	,
T1.WORK_ORDER_FORM_PRT      	,
'RET'                       		,
RET.PRODUCE_QUANTITY        	,
T1.RET_PRT                  		,
'PKG'                       		,
PKG.PRODUCE_QUANTITY        	,
T1.PKG_PRT                  		,
T1.POS                      		,
T1.POS_QTY                  		,
T1.POS_PRT                          	,
DM_IC.UNDERCLASS_PRODUCT_CODE     	,	
DM_IC.PRODUCE_QUANTITY                 	,
T1.DIGITAL_MEDIA1_PRT                		,
DM_IG.UNDERCLASS_PRODUCT_CODE     	,
DM_IG.PRODUCE_QUANTITY                 	,
T1.DIGITAL_MEDIA2_PRT                		,
LAMINATE.UNDERCLASS_PRODUCT_CODE   ,
LAMINATE.PRODUCE_QUANTITY                   ,
T1.LAMINATE_PRT                     	        ,
MAGNET.UNDERCLASS_PRODUCT_CODE      ,
MAGNET.PRODUCE_QUANTITY                      ,
T1.MAGNET_PRT                                             ,
METALLIC.UNDERCLASS_PRODUCT_CODE    ,
METALLIC.PRODUCE_QUANTITY                    ,
T1.METALLIC_PRT                                           ,
SPEC.UNDERCLASS_PRODUCT_CODE            ,
SPEC.PRODUCE_QUANTITY              		,
T1.SPECIALITY_PRODUCED              		,	
--INDIGO.UNDERCLASS_PRODUCT_CODE     	,
--INDIGO.PRODUCE_QUANTITY             	,
--T1.INDIGO_PRODUCED                  		,
INDIGO_FT.UNDERCLASS_PRODUCT_CODE     	,
INDIGO_FT.PRODUCE_QUANTITY              	,	
T1. INDIGO_PRODUCT1_PRODUCED		,
INDIGO_NA.UNDERCLASS_PRODUCT_CODE     	,
INDIGO_NA.PRODUCE_QUANTITY              	,	
T1.INDIGO_PRODUCT2_PRODUCED		,
PROOF.UNDERCLASS_PRODUCT_CODE       	,
PROOF.PRODUCE_QUANTITY              		,	
T1.PROOF_PRODUCED                  		,
T1.CLASS_DELIVERY                   		,
CLASS.UNDERCLASS_PRODUCT_CODE       	,
CLASS.PRODUCE_QUANTITY              		,
T1.CLASS_PRT                        		,  
DID.UNDERCLASS_PRODUCT_CODE         	,
DID.PRODUCE_QUANTITY                		,
T1.DID_PRT           			,
DSSK.UNDERCLASS_PRODUCT_CODE        	,
DSSK.PRODUCE_QUANTITY               		,
T1.DSSK_PRT          			,
EZP.UNDERCLASS_PRODUCT_CODE         	,
EZP.PRODUCE_QUANTITY               		,
T1.EZP_PRT           			,
POS618.UNDERCLASS_PRODUCT_CODE         	,
POS618.PRODUCE_QUANTITY               	,
T1.POS618_PRT           			,
T1.SPECIAL_REQUEST      			,
T1.WORK_ORDER_STATUS    		,
T1.PROCESSING_COMMENT   		,
T1.SHIP_GOAL_DATE       			,
T1.WOMS_NODE            			,
T1.DEACTIVATED_FLAG   
FROM
RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 T1,
RAX_APP_USER.UC_PRODUCT_CODE_RET RET,
RAX_APP_USER.UC_PRODUCT_CODE_PKG PKG,
RAX_APP_USER.UC_PRODUCT_CODE_DM_IC DM_IC,
RAX_APP_USER.UC_PRODUCT_CODE_DM_IG DM_IG,
RAX_APP_USER.UC_PRODUCT_CODE_LAMINATE LAMINATE,
RAX_APP_USER.UC_PRODUCT_CODE_MAGNET   MAGNET,
RAX_APP_USER.UC_PRODUCT_CODE_METALLIC METALLIC,
RAX_APP_USER.UC_PRODUCT_CODE_SPECIALITY SPEC,
--RAX_APP_USER.UC_PRODUCT_CODE_INDIGO  INDIGO,
RAX_APP_USER.UC_PRODUCT_CODE_INDIGO_FT   INDIGO_FT,
RAX_APP_USER.UC_PRODUCT_CODE_INDIGO_NA  INDIGO_NA,
RAX_APP_USER.UC_PRODUCT_CODE_PROOF   PROOF,
RAX_APP_USER.UC_PRODUCT_CODE_CLASS   CLASS,
RAX_APP_USER.UC_PRODUCT_CODE_DID     DID,
RAX_APP_USER.UC_PRODUCT_CODE_DSSK    DSSK,
RAX_APP_USER.UC_PRODUCT_CODE_EZP     EZP,
RAX_APP_USER.UC_PRODUCT_CODE_618     POS618
WHERE 1 = 1
      AND T1.WORK_ORDER_ID = RET.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = RET.WOMS_NODE(+)
      AND T1.LID = RET.LID(+)
      AND T1.WORK_ORDER_ID = PKG.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = PKG.WOMS_NODE(+)
      AND T1.LID = PKG.LID(+)
      AND T1.WORK_ORDER_ID = DM_IC.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = DM_IC.WOMS_NODE(+)
      AND T1.LID = DM_IC.LID(+)
      AND T1.WORK_ORDER_ID = DM_IG.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = DM_IG.WOMS_NODE(+)
      AND T1.LID = DM_IG.LID(+)
      AND T1.WORK_ORDER_ID = LAMINATE.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = LAMINATE.WOMS_NODE(+)
      AND T1.LID = LAMINATE.LID(+)
      AND T1.WORK_ORDER_ID = MAGNET.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = MAGNET.WOMS_NODE(+)
      AND T1.LID = MAGNET.LID(+)
      AND T1.WORK_ORDER_ID = METALLIC.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = METALLIC.WOMS_NODE(+)
      AND T1.LID = METALLIC.LID(+)
      AND T1.WORK_ORDER_ID = SPEC.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = SPEC.WOMS_NODE(+)
      AND T1.LID = SPEC.LID(+)
--   AND T1.WORK_ORDER_ID = INDIGO.WORK_ORDER_ID(+)
--   AND T1.WOMS_NODE = INDIGO.WOMS_NODE(+)
--   AND T1.LID = INDIGO.LID(+)
      AND T1.WORK_ORDER_ID = INDIGO_FT.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = INDIGO_FT.WOMS_NODE(+)
      AND T1.LID = INDIGO_FT.LID(+)
      AND T1.WORK_ORDER_ID = INDIGO_NA.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = INDIGO_NA.WOMS_NODE(+)
      AND T1.LID = INDIGO_NA.LID(+)
      AND T1.WORK_ORDER_ID = PROOF.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = PROOF.WOMS_NODE(+)
      AND T1.LID = PROOF.LID(+)
      AND T1.WORK_ORDER_ID = CLASS.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = CLASS.WOMS_NODE(+)
      AND T1.LID = CLASS.LID(+)
      AND T1.WORK_ORDER_ID = DID.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = DID.WOMS_NODE(+)
      AND T1.LID = DID.LID(+)
      AND T1.WORK_ORDER_ID = DSSK.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = DSSK.WOMS_NODE(+)
      AND T1.LID = DSSK.LID(+)
      AND T1.WORK_ORDER_ID = EZP.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = EZP.WOMS_NODE(+)
      AND T1.LID = EZP.LID(+)
      AND T1.WORK_ORDER_ID = POS618.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = POS618.WOMS_NODE(+)
      AND T1.LID = POS618.LID(+)

&

/*-----------------------------------------------*/
/* TASK No. 94 */
/* INSERT INTO ODS_APP_USER.TEMP_WORK_ORDER_SUBJECT_COUNT */



INSERT INTO RAX_APP_USER.TEMP_WORK_ORDER_SUBJECT_COUNT
    SELECT DISTINCT TEMP.WORK_ORDER_ID,
                TEMP.LID,
                COUNT(DISTINCT WOD.SESSION_ID) AS WORK_ORDER_SUBJECT_COUNT, 
                APO.COMP_PROD_DELIVERY_TYPE,  
                TEMP.WOMS_NODE
    FROM 
         ODS_STAGE.WOMS_WORK_ORDER_DETAIL_STG WOD,
         ODS_OWN.APO,
         RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP 
    WHERE 
           TEMP.WORK_ORDER_ID = WOD.WORK_ORDER_ID
    AND TEMP.WOMS_NODE = WOD.WOMS_NODE 
    AND TEMP.LID = APO.LIFETOUCH_ID
    AND WOD.APO_ID = APO.APO_ID
    AND WOD.DEACTIVATED_DATE IS NULL
    AND WOD.ODS_CREATE_DATE >= (SELECT MIN(DATE_KEY) FROM MART.TIME
                                                                    WHERE FISCAL_YEAR = (SELECT FISCAL_YEAR FROM MART.TIME 
                                                                                                        WHERE DATE_KEY = TRUNC(SYSDATE))-1)
    GROUP BY TEMP.WORK_ORDER_ID,TEMP.LID,APO.COMP_PROD_DELIVERY_TYPE,TEMP.WOMS_NODE

&

/*-----------------------------------------------*/
/* TASK No. 95 */
/* INSERT INTO ODS_APP_USER.TEMP_WO_SUBJ_COUNT_WODEACTIVE */



INSERT INTO RAX_APP_USER.TEMP_WO_SUBJ_COUNT_WODEACTIVE
SELECT DISTINCT TEMP.WORK_ORDER_ID,
             TEMP.LID,
             COUNT(DISTINCT WOD.SESSION_ID) AS WORK_ORDER_SUBJECT_COUNT,
             APO.COMP_PROD_DELIVERY_TYPE,
             TEMP.WOMS_NODE
             FROM 
             ODS_STAGE.WOMS_WORK_ORDER_DETAIL_STG WOD,
             ODS_OWN.APO,
             RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP
             WHERE 1 = 1
             AND TEMP.WORK_ORDER_ID = WOD.WORK_ORDER_ID
             AND TEMP.WOMS_NODE = WOD.WOMS_NODE
             AND WOD.APO_ID = APO.APO_ID
             AND TEMP.LID = APO.LIFETOUCH_ID
             AND WOD.DEACTIVATED_DATE IS NOT NULL
             AND WOD.ODS_CREATE_DATE >= (SELECT MIN(DATE_KEY) FROM MART.TIME
                                                                    WHERE FISCAL_YEAR = (SELECT FISCAL_YEAR FROM MART.TIME 
                                                                                                        WHERE DATE_KEY = TRUNC(SYSDATE))-1)
             GROUP BY TEMP.WORK_ORDER_ID,TEMP.LID,APO.COMP_PROD_DELIVERY_TYPE,TEMP.WOMS_NODE

&

/*-----------------------------------------------*/
/* TASK No. 96 */
/* INSERT INTO ODS_APP_USER.TEMP_WO_SPECIALREQUEST */



INSERT INTO RAX_APP_USER.TEMP_WO_SPECIALREQUEST TGT
     SELECT twd.WORK_ORDER_ID,
            twd.LID,
            'Y' AS SPECIAL_REQUEST,
            twd.WOMS_NODE 
     FROM 
        RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 twd,
        ODS_STAGE.WOMS_WORK_ORDER_DETAIL_STG WOD,
        ODS_OWN.APO APO
     WHERE 
            WOD.WORK_ORDER_ID = twd.WORK_ORDER_ID
        AND WOD.WOMS_NODE = twd.WOMS_NODE
        AND WOD.APO_ID = APO.APO_ID
        AND twd.LID = APO.LIFETOUCH_ID
        AND WOD.INSTRUCTION IS NOT NULL
        AND WOD.ODS_CREATE_DATE >= (SELECT MIN(DATE_KEY) FROM MART.TIME
                                                                    WHERE FISCAL_YEAR = (SELECT FISCAL_YEAR FROM MART.TIME 
                                                                                                        WHERE DATE_KEY = TRUNC(SYSDATE))-1)
     GROUP BY twd.WORK_ORDER_ID,twd.LID,twd.WOMS_NODE

&

/*-----------------------------------------------*/
/* TASK No. 97 */
/* INSERT INTO ODS_APP_USER.TEMP_WO_SESSIONS */



----Get list of sessions who did not order anything and are only getting POS sheet

INSERT INTO RAX_APP_USER.TEMP_WO_SESSIONS
SELECT
distinct WODD.work_order_id,TEMP1.LID,WODD.session_id,TEMP1.WOMS_NODE
FROM ODS_STAGE.WOMS_WORK_ORDER_DETAIL_STG WODD, 
          RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP1
         --,ODS_OWN.APO AP
WHERE (WODD.SESSION_ID||TEMP1.LID||WODD.WORK_ORDER_ID||TEMP1.WOMS_NODE) NOT IN 
                                        ( SELECT 
                                           DISTINCT WOD.SESSION_ID || twd.LID || WOD.WORK_ORDER_ID || twd.WOMS_NODE
                                           FROM 
                                                                        RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 twd,
                                                                        ODS_STAGE.WOMS_WORK_ORDER_DETAIL_STG WOD,
                                                                        ODS_STAGE.WOMS_ITEM_ID_REFERENCE_STG ITEM,
                                                                        ODS_STAGE.WOMS_XREF_OMS_PROD_STG OMS,
                                                                        ODS_OWN.APO APO 
                                                                    WHERE WOD.WORK_ORDER_ID = twd.WORK_ORDER_ID
                                                                    AND WOD.WOMS_NODE = twd.WOMS_NODE
                                                                    AND WOD.ITEM_ID_REFERENCE_ID = ITEM.ITEM_ID_REFERENCE_ID
                                                                    AND ITEM.XREF_OMS_PROD_ID = OMS.XREF_OMS_PROD_ID
                                                                    AND WOD.APO_ID = APO.APO_ID 
                                                                    AND twd.LID = APO.LIFETOUCH_ID
                                                                    AND OMS.UNDERCLASS_COMPONENT_CODE NOT IN ('P8L','P5L')
                                                                    AND WOD.DEACTIVATED_DATE IS NULL
         			    AND WOD.ODS_CREATE_DATE >= (SELECT MIN(DATE_KEY) FROM MART.TIME
                                                                    WHERE FISCAL_YEAR = (SELECT FISCAL_YEAR FROM MART.TIME 
                                                                                                        WHERE DATE_KEY = TRUNC(SYSDATE))-1)
                                                                 )
   AND WODD.WORK_ORDER_ID = TEMP1.WORK_ORDER_ID
   AND WODD.WOMS_NODE = TEMP1.WOMS_NODE
   --AND TEMP1.LID = AP.LIFETOUCH_ID
   --AND WODD.APO_ID = AP.APO_ID

&

/*-----------------------------------------------*/
/* TASK No. 98 */
/* INSERT INTO ODS_APP_USER.TEMP_POS */



INSERT INTO RAX_APP_USER.TEMP_POS
SELECT           
            WOD.WORK_ORDER_ID,
            twd.LID,
            OMS.UNDERCLASS_PRODUCT_CODE AS UNDERCLASS_PRODUCT_CODE,
            TWD.CLASS_DELIVERY,
            SUM(WOD.PRODUCE_QUANTITY) as PRODUCT_QTY,
            NULL PRODUCT_PRODUCED,
            NULL PRODUCT_SHIPPED,
            twd.WOMS_NODE    
    FROM 
    ODS_STAGE.WOMS_WORK_ORDER_DETAIL_STG WOD,
    ODS_STAGE.WOMS_ITEM_ID_REFERENCE_STG ITEM,
    ODS_STAGE.WOMS_XREF_OMS_PROD_STG OMS, 
    RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 twd,
    RAX_APP_USER.TEMP_WO_SESSIONS wox,
    ODS_OWN.APO APO
    	WHERE WOD.WORK_ORDER_ID = twd.WORK_ORDER_ID
     	AND WOD.WOMS_NODE = twd.WOMS_NODE
     	--AND OMS.UNDERCLASS_PRODUCT_CODE = 'PKG'
     	AND WOD.ITEM_ID_REFERENCE_ID = ITEM.ITEM_ID_REFERENCE_ID
     	AND ITEM.XREF_OMS_PROD_ID = OMS.XREF_OMS_PROD_ID
     	AND twd.POS IS NOT NULL 
     	AND OMS.UNDERCLASS_COMPONENT_CODE IN ('P3L','618','SBC','P8L','P5L')
     	AND WOD.WORK_ORDER_ID = wox.WORK_ORDER_ID 
     	AND WOD.SESSION_ID = wox.SESSION_ID
     	AND WOD.APO_ID = APO.APO_ID
     	AND twd.LID = APO.LIFETOUCH_ID
     	AND WOD.DEACTIVATED_DATE IS NULL
                     AND WOD.ODS_CREATE_DATE >= (SELECT MIN(DATE_KEY) FROM MART.TIME
                                                                    WHERE FISCAL_YEAR = (SELECT FISCAL_YEAR FROM MART.TIME 
                                                                                                        WHERE DATE_KEY = TRUNC(SYSDATE))-1)
    GROUP BY 
        WOD.WORK_ORDER_ID,
        twd.LID,
        oms.UNDERCLASS_PRODUCT_CODE, 
        twd.CLASS_DELIVERY,
        twd.WOMS_NODE

&

/*-----------------------------------------------*/
/* TASK No. 99 */
/* Insert DT columns to Temp Table */
/*+ PARALLEL(SH,12)*/



INSERT INTO RAX_APP_USER.X1_WO_PRODUCE_DT_TEMP
SELECT 
TEMP.WOMS_NODE,
TEMP.WORK_ORDER_ID,
TEMP.LID AS LID,
X.UNDERCLASS_PRODUCT_CODE AS UNDERCLASS_PRODUCT_CODE,
MAX(SH.STATUS_CHANGE_TS) AS PRODUCE_PRODUCED_DT,
MAX(sh.STATUS_CHANGE_TS) AS  PRODUCT_SHIPPED_DT,
SH.STATUS_ID
FROM 
RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP,
ODS_STAGE.WOMS_STATUS_HISTORY_STG SH,
ODS_STAGE.WOMS_WORK_ORDER_DETAIL_STG WOD,
ODS_STAGE.WOMS_ITEM_ID_REFERENCE_STG I,
ODS_STAGE.WOMS_XREF_OMS_PROD_STG X
WHERE  
    1 = 1 
AND TEMP.WORK_ORDER_ID = WOD.WORK_ORDER_ID
AND SH.WORK_ORDER_DETAIL_ID = WOD.WORK_ORDER_DETAIL_ID
AND I.ITEM_ID_REFERENCE_ID = WOD.ITEM_ID_REFERENCE_ID
AND X.XREF_OMS_PROD_ID = I.XREF_OMS_PROD_ID
AND SH.WOMS_NODE = WOD.WOMS_NODE
AND WOD.WOMS_NODE = TEMP.WOMS_NODE
AND SH.WORK_ORDER_ID IS NULL
AND I.PRODUCIBLE_FLAG = 1
AND SH.STATUS_ID IN (2)
AND WOD.DEACTIVATED_DATE IS NULL
AND WOD.ODS_CREATE_DATE >= (SELECT MIN(DATE_KEY) FROM MART.TIME
                                           WHERE FISCAL_YEAR = (SELECT FISCAL_YEAR FROM MART.TIME 
                                                               WHERE DATE_KEY = TRUNC(SYSDATE))-1)
AND SH.ODS_CREATE_DATE >= (SELECT MIN(DATE_KEY) FROM MART.TIME
                                           WHERE FISCAL_YEAR = (SELECT FISCAL_YEAR FROM MART.TIME 
                                                               WHERE DATE_KEY = TRUNC(SYSDATE))-1)
GROUP BY          
         TEMP.WOMS_NODE,
         TEMP.WORK_ORDER_ID,
         TEMP.LID,
         X.UNDERCLASS_PRODUCT_CODE,
         SH.STATUS_ID

&

/*-----------------------------------------------*/
/* TASK No. 100 */
/* Merge DT to Temp2 */



begin

MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
USING  
         (   
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE = 'RET'
    AND STATUS_ID = 2
           )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
            )          
    WHEN MATCHED THEN
    UPDATE 
    SET  
       TGT.RET_PRT   =  SRC.PRODUCE_PRODUCED_DT;
      
        

MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
      X1_WO_PRODUCE_DT_TEMP
      WHERE UNDERCLASS_PRODUCT_CODE IN ('PKG','SBP')
      AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.PKG = SRC.UNDERCLASS_PRODUCT_CODE
            )                  
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.PKG_PRT    = SRC.PRODUCE_PRODUCED_DT;



MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE  UNDERCLASS_PRODUCT_CODE IN ('POS')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             )                 
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.POS_PRT  = SRC.PRODUCE_PRODUCED_DT;
        



MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('IC')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.DIGITAL_MEDIA1 = SRC.UNDERCLASS_PRODUCT_CODE
             )             
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.DIGITAL_MEDIA1_PRT =  SRC.PRODUCE_PRODUCED_DT;





MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('IG')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.DIGITAL_MEDIA2 = SRC.UNDERCLASS_PRODUCT_CODE
             )             
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.DIGITAL_MEDIA2_PRT =  SRC.PRODUCE_PRODUCED_DT;






MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('HL','LC','LG','LP','LR','LT','LU','LX','LY','LZ')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.LAMINATE = SRC.UNDERCLASS_PRODUCT_CODE
           )               
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.LAMINATE_PRT  = SRC.PRODUCE_PRODUCED_DT;



MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('HA','MA','ME','MI','MJ','MO','MV','MY','MZ')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.MAGNET = SRC.UNDERCLASS_PRODUCT_CODE
            )            
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.MAGNET_PRT = SRC.PRODUCE_PRODUCED_DT;


MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('ML','NC','NX')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.METALLIC = SRC.UNDERCLASS_PRODUCT_CODE
            )                 
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.METALLIC_PRT = SRC.PRODUCE_PRODUCED_DT;


MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('SA','SZ')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.SPECIALITY = SRC.UNDERCLASS_PRODUCT_CODE
             )          
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.SPECIALITY_PRODUCED = SRC.PRODUCE_PRODUCED_DT;




 MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
 USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT AS PRODUCE_PRODUCED_DT,
     WOMS_NODE 
     FROM 
     X1_WO_PRODUCE_DT_TEMP
     WHERE UNDERCLASS_PRODUCT_CODE IN ('FT') 
     AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.INDIGO_PRODUCT1 = SRC.UNDERCLASS_PRODUCT_CODE
         )           
  WHEN MATCHED THEN
    UPDATE 
    SET  
       TGT.INDIGO_PRODUCT1_PRODUCED = SRC.PRODUCE_PRODUCED_DT;
       
       
       
       

 MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
 USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT AS PRODUCE_PRODUCED_DT,
     WOMS_NODE 
     FROM 
     X1_WO_PRODUCE_DT_TEMP
     WHERE UNDERCLASS_PRODUCT_CODE IN ('NA') 
     AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.INDIGO_PRODUCT2 = SRC.UNDERCLASS_PRODUCT_CODE
         )           
  WHEN MATCHED THEN
    UPDATE 
    SET  
       TGT.INDIGO_PRODUCT2_PRODUCED = SRC.PRODUCE_PRODUCED_DT;       








MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
     FROM 
     X1_WO_PRODUCE_DT_TEMP
     WHERE UNDERCLASS_PRODUCT_CODE IN ('601','602','603','604')
     AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.PROOF_PRODUCT = SRC.UNDERCLASS_PRODUCT_CODE
            )                
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.PROOF_PRODUCED = SRC.PRODUCE_PRODUCED_DT;



MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('CMP','G08')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.CLASS = SRC.UNDERCLASS_PRODUCT_CODE
            )              
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.CLASS_PRT = SRC.PRODUCE_PRODUCED_DT;



MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('DCP','DID')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.DID = SRC.UNDERCLASS_PRODUCT_CODE
            )              
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.DID_PRT  = SRC.PRODUCE_PRODUCED_DT;




MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('DSS')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
            AND TGT.WOMS_NODE = SRC.WOMS_NODE
            AND TGT.LID = SRC.LID
            )             
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.DSSK_PRT   = SRC.PRODUCE_PRODUCED_DT;




MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('EZP')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
            )             
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.EZP_PRT     = SRC.PRODUCE_PRODUCED_DT;



MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
     FROM 
     X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('618')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
            )             
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.POS618_PRT   = SRC.PRODUCE_PRODUCED_DT;




end;

&

/*-----------------------------------------------*/
/* TASK No. 101 */
/* Update Work Order From PRT Date */
/*+PARALLEL(SH,12)*/



MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
USING  
    (  
    SELECT      
    TEMP.WORK_ORDER_ID,
    TEMP.WOMS_NODE,
    TEMP.LID,    
    MAX(SH.STATUS_CHANGE_TS) AS WORK_ORDER_FORM_PRT
    FROM 
    RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 TEMP,
    ODS_STAGE.WOMS_STATUS_HISTORY_STG SH
    WHERE TEMP.WORK_ORDER_ID = SH.WORK_ORDER_ID
    AND SH.WOMS_NODE = TEMP.WOMS_NODE
    AND SH.STATUS_ID = 11
    AND SH.ODS_CREATE_DATE >= (SELECT MIN(DATE_KEY) FROM MART.TIME
                                                                    WHERE FISCAL_YEAR = (SELECT FISCAL_YEAR FROM MART.TIME 
                                                                                                        WHERE DATE_KEY = TRUNC(SYSDATE))-1)
    GROUP BY   
    TEMP.WORK_ORDER_ID,
    TEMP.WOMS_NODE,
    TEMP.LID 
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID     
          AND TGT.WOMS_NODE = SRC.WOMS_NODE
          AND TGT.LID = SRC.LID              
         )        
  WHEN MATCHED THEN
    UPDATE 
     SET  
        TGT.WORK_ORDER_FORM_PRT = SRC.WORK_ORDER_FORM_PRT

&

/*-----------------------------------------------*/
/* TASK No. 102 */
/* Merge POS,SUBJECT COUNT to Temp2 */



begin

MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
    USING  
    (  
     SELECT 
        TEMP.WORK_ORDER_ID,
        TEMP.WOMS_NODE,
        TEMP.LID                    
        FROM RAX_APP_USER.TEMP_WO_DEACTIVE_BASED_ON_WOL TEMP             
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
          AND TGT.WOMS_NODE = SRC.WOMS_NODE
          AND TGT.LID = SRC.LID
         )          
  WHEN MATCHED THEN
    UPDATE 
     SET  
          TGT.DEACTIVATED_FLAG =  'Y';


MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
    USING  
    (  
     SELECT 
        WORK_ORDER_ID,
        LID,
        PRODUCT_QTY,
        PRODUCT_PRODUCED AS POS_PRT,
        WOMS_NODE
     FROM 
     RAX_APP_USER.TEMP_POS
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
          AND TGT.WOMS_NODE = SRC.WOMS_NODE
          AND TGT.LID = SRC.LID
         )          
  WHEN MATCHED THEN
    UPDATE 
     SET  
          TGT.POS                   =  'POS',
          TGT.POS_QTY          =  SRC.PRODUCT_QTY,
          TGT.POS_PRT           =  SRC.POS_PRT;          





MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
    USING  
    (  
      SELECT
     X.WORK_ORDER_ID,
     X.LID,
     X.WOMS_NODE, 
     MAX(NVL(SUBJ1.WORK_ORDER_SUBJECT_COUNT,SUBJ2.WORK_ORDER_SUBJECT_COUNT)) AS SUBJECT_COUNT,
     NVL(SUBJ1.CLASS_DELIVER_TYPE,SUBJ2.CLASS_DELIVER_TYPE) AS CLASS_DELIVER_TYPE
     FROM 
	RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 X,
	RAX_APP_USER.TEMP_WORK_ORDER_SUBJECT_COUNT SUBJ1,
	RAX_APP_USER.TEMP_WO_SUBJ_COUNT_WODEACTIVE SUBJ2 
     WHERE 
            X.WORK_ORDER_ID = SUBJ1.WORK_ORDER_ID(+) 
    AND X.WOMS_NODE = SUBJ1.WOMS_NODE(+)
    AND X.LID = SUBJ1.LID(+)
    AND X.WORK_ORDER_ID = SUBJ2.WORK_ORDER_ID(+)
    AND X.WOMS_NODE = SUBJ2.WOMS_NODE(+)
    AND X.LID = SUBJ2.LID(+)
    GROUP BY 
    	X.WORK_ORDER_ID,
     	X.LID,
     	X.WOMS_NODE,
                     NVL(SUBJ1.CLASS_DELIVER_TYPE,SUBJ2.CLASS_DELIVER_TYPE)
    )SRC
      ON 
         (
          TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
          AND TGT.WOMS_NODE = SRC.WOMS_NODE
          AND TGT.LID = SRC.LID
         )          
  WHEN MATCHED THEN
    UPDATE 
     SET  
          TGT.SUBJECT_COUNT  =  SRC.SUBJECT_COUNT,
          TGT.CLASS_DELIVERY    = SRC.CLASS_DELIVER_TYPE;


MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TGT
    USING  
    (  
     SELECT
     WORK_ORDER_ID,
     LID,
     WOMS_NODE, 
     SPECIAL_REQUEST
     FROM 
        RAX_APP_USER.TEMP_WO_SPECIALREQUEST 
    )SRC
      ON (
          TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
          AND TGT.WOMS_NODE = SRC.WOMS_NODE
          AND TGT.LID = SRC.LID
         )          
  WHEN MATCHED THEN
    UPDATE 
     SET  
        TGT.SPECIAL_REQUEST = 'Y';



end;

&

/*-----------------------------------------------*/
/* TASK No. 103 */
/* UPDATE_POS618 */



begin

        UPDATE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2       
        SET POS = '618'
        WHERE POS_QTY IS NULL 
        AND POS618_QTY IS NOT NULL;


        COMMIT;

        
        UPDATE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2       
        SET POS_QTY =  POS618_QTY
        WHERE POS_QTY IS NULL 
        AND POS618_QTY IS NOT NULL;


        COMMIT;

        
        UPDATE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2
        SET POS_PRT =  POS618_PRT
        WHERE  POS = '618'
        AND POS618_PRT IS NOT NULL;

        
end;

&

/*-----------------------------------------------*/
/* TASK No. 104 */
/* Mark Flag for Lab Canceled Work Orders */



UPDATE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TEMP2
SET  TEMP2.DEACTIVATED_FLAG = 'Y'
WHERE TEMP2.WORK_ORDER_STATUS = 'Lab Canceled'

&

/*-----------------------------------------------*/
/* TASK No. 105 */
/* Insert to X1_WO_UNSHIPPED_HIST(X) */



MERGE INTO ODS_STAGE.X1_WO_UNSHIPPED_HIST TGT
    USING (
	SELECT
	PLATFORM_DETAIL	,
	WORK_ORDER_ID	,
	EVENT_REF_ID	,
	JOB_TYPE		,
	LID		,
	ACCT_NAME		,
	SHIP_PROPSL_RECEIVED	,
	BATCH_ID		,
	WORK_ORDER_ALIAS_ID	,
	SUBJECT_COUNT	,
	WORK_ORDER_FORM_PRT,
	RET		,
	RET_QTY		,
	RET_PRT		,
	PKG		,
	PKG_QTY		,
	PKG_PRT		,
	POS		,
	POS_QTY		,
	POS_PRT		,
	DIGITAL_MEDIA1	,
	DIGITAL_MEDIA1_QTY	,
	DIGITAL_MEDIA1_PRT	,
	DIGITAL_MEDIA2	,
	DIGITAL_MEDIA2_QTY	,
	DIGITAL_MEDIA2_PRT	,
	LAMINATE		,
	LAMINATE_QTY	,
	LAMINATE_PRT	,
	MAGNET		,
	MAGNET_QTY	,
	MAGNET_PRT	,
	METALLIC		,
	METALLIC_QTY	,
	METALLIC_PRT	,
	SPECIALITY		,
	SPECIALITY_QTY	,
	SPECIALITY_PRODUCED	,
	INDIGO_PRODUCT1                          ,
	INDIGO_PRODUCT1_QTY                 ,
	INDIGO_PRODUCT1_PRODUCED      ,
	INDIGO_PRODUCT2                          ,
	INDIGO_PRODUCT2_QTY                 ,
	INDIGO_PRODUCT2_PRODUCED      ,
	PROOF_PRODUCT	,
	PROOF_QTY		,
	PROOF_PRODUCED	,
	CLASS_DELIVERY	,
	CLASS		,
	CLASS_QTY	,
	CLASS_PRT	,
	DID	,
	DID_QTY	,
	DID_PRT	,
	DSSK	,
	DSSK_QTY	,
	DSSK_PRT	,
	EZP	,
	EZP_QTY	,
	EZP_PRT	,
	SPECIAL_REQUEST	,
	WORK_ORDER_STATUS	,
	PROCESSING_COMMENT	,
	SHIP_GOAL_DATE	,
	WOMS_NODE                    ,
	DEACTIVATED_FLAG         
                     FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2         
               )SRC
    ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
           AND TGT.WOMS_NODE = SRC.WOMS_NODE
           AND TGT.LID = SRC.LID
           )
  WHEN MATCHED THEN
    UPDATE 
    SET 
TGT.PLATFORM_DETAIL		=	SRC.PLATFORM_DETAIL	,
TGT.EVENT_REF_ID		=	SRC.EVENT_REF_ID	,
TGT.JOB_TYPE		=	SRC.JOB_TYPE	,
TGT.ACCT_NAME		=	SRC.ACCT_NAME		,
TGT.SHIP_PROPSL_RECEIVED	=	SRC.SHIP_PROPSL_RECEIVED	,
TGT.MAIL_RECEIVED                              =                   NULL                                                       ,
TGT.BATCH_ID		=	SRC.BATCH_ID		,
TGT.WORK_ORDER_ALIAS_ID	=	SRC.WORK_ORDER_ALIAS_ID	,
TGT.SUBJECT_COUNT		=	SRC.SUBJECT_COUNT	,
TGT.WORK_ORDER_FORM_PRT	=	SRC.WORK_ORDER_FORM_PRT	,
TGT.RET			=	SRC.RET		,
TGT.RET_QTY		=	SRC.RET_QTY	,
TGT.RET_PRT		=	SRC.RET_PRT	,
TGT.PKG			=	SRC.PKG		,
TGT.PKG_QTY		=	SRC.PKG_QTY	,
TGT.PKG_PRT		=	SRC.PKG_PRT	,
TGT.POS			=	SRC.POS		,
TGT.POS_QTY		=	SRC.POS_QTY	,
TGT.POS_PRT		=	SRC.POS_PRT	       ,
TGT.DIGITAL_MEDIA1          	=  	SRC.DIGITAL_MEDIA1              ,
TGT.DIGITAL_MEDIA1_QTY      	=  	SRC.DIGITAL_MEDIA1_QTY      ,
TGT.DIGITAL_MEDIA1_PRT      	=  	SRC.DIGITAL_MEDIA1_PRT      ,
TGT.DIGITAL_MEDIA2          	=  	SRC.DIGITAL_MEDIA2              ,
TGT.DIGITAL_MEDIA2_QTY      	=  	SRC.DIGITAL_MEDIA2_QTY      ,
TGT.DIGITAL_MEDIA2_PRT      	=  	SRC.DIGITAL_MEDIA2_PRT      ,
TGT.LAMINATE		=	SRC.LAMINATE		,
TGT.LAMINATE_QTY		=	SRC.LAMINATE_QTY		,
TGT.LAMINATE_PRT		=	SRC.LAMINATE_PRT		,
TGT.MAGNET		=	SRC.MAGNET		,
TGT.MAGNET_QTY		=	SRC.MAGNET_QTY	                     ,
TGT.MAGNET_PRT		=	SRC.MAGNET_PRT	                     ,
TGT.METALLIC		=	SRC.METALLIC		,
TGT.METALLIC_QTY		=	SRC.METALLIC_QTY	                     ,
TGT.METALLIC_PRT		=	SRC.METALLIC_PRT	                     ,
TGT.SPECIALITY		=	SRC.SPECIALITY		,
TGT.SPECIALITY_QTY		=	SRC.SPECIALITY_QTY	                     ,
TGT.SPECIALITY_PRODUCED	=	SRC.SPECIALITY_PRODUCED	,
TGT.INDIGO_PRODUCT1                        =                  SRC.INDIGO_PRODUCT1                        ,
TGT.INDIGO_PRODUCT1_QTY               =                  TGT.INDIGO_PRODUCT1_QTY                ,
TGT.INDIGO_PRODUCT1_PRODUCED    =                  TGT.INDIGO_PRODUCT1_PRODUCED    ,
TGT.INDIGO_PRODUCT2                        =                  TGT.INDIGO_PRODUCT2                         ,
TGT.INDIGO_PRODUCT2_QTY               =                   TGT.INDIGO_PRODUCT2_QTY                ,
TGT.INDIGO_PRODUCT2_PRODUCED   =                   TGT.INDIGO_PRODUCT2_PRODUCED     ,
TGT.PROOF_PRODUCT		=	SRC.PROOF_PRODUCT	                      ,
TGT.PROOF_QTY		=	SRC.PROOF_QTY		 ,
TGT.PROOF_PRODUCED		=	SRC.PROOF_PRODUCED	                      ,
TGT.CLASS_DELIVERY		=	SRC.CLASS_DELIVERY	,
TGT.CLASS			=	SRC.CLASS	                     ,
TGT.CLASS_QTY		=	SRC.CLASS_QTY	,
TGT.CLASS_PRT		=	SRC.CLASS_PRT	,
TGT.DID			=	SRC.DID	                     ,
TGT.DID_QTY		=	SRC.DID_QTY	,
TGT.DID_PRT		=	SRC.DID_PRT	,
TGT.DSSK			=	SRC.DSSK	                     ,
TGT.DSSK_QTY		=	SRC.DSSK_QTY	,
TGT.DSSK_PRT		=	SRC.DSSK_PRT	,
TGT.EZP			=	SRC.EZP	                     ,
TGT.EZP_QTY		=	SRC.EZP_QTY	,
TGT.EZP_PRT		=	SRC.EZP_PRT	,
TGT.SPECIAL_REQUEST		=	SRC.SPECIAL_REQUEST	,
TGT.WORK_ORDER_STATUS	=	SRC.WORK_ORDER_STATUS	,
TGT.PROCESSING_COMMENT	=	SRC.PROCESSING_COMMENT	,
TGT.SHIP_GOAL_DATE		=	SRC.SHIP_GOAL_DATE		,
TGT.CHANGE_FLAG           	=    	'U'			,
TGT.MANUAL_DEACTIVATED_FLAG       =                   SRC.DEACTIVATED_FLAG 		,
TGT.PENDING_CLASS_PRODUCT           =                   NULL                                  	 	,
TGT.MANUALLY_SHIPPED	                     =                   NULL                                   	,
TGT.ODS_MODIFY_DATE  		=    	SYSDATE                            	

  WHEN NOT MATCHED THEN
INSERT
(
TGT.PLATFORM_DETAIL	,
TGT.WORK_ORDER_ID	,
TGT.EVENT_REF_ID	,
TGT.JOB_TYPE	,
TGT.LID		,
TGT.ACCT_NAME	,
TGT.SHIP_PROPSL_RECEIVED	,
TGT.MAIL_RECEIVED                              ,
TGT.BATCH_ID		,
TGT.WORK_ORDER_ALIAS_ID	,
TGT.SUBJECT_COUNT		,
TGT.WORK_ORDER_FORM_PRT	,
TGT.RET		,
TGT.RET_QTY	,
TGT.RET_PRT	,
TGT.PKG		,
TGT.PKG_QTY	,
TGT.PKG_PRT	,
TGT.POS		,
TGT.POS_QTY	,
TGT.POS_PRT	,
TGT.DIGITAL_MEDIA1              ,
TGT.DIGITAL_MEDIA1_QTY     ,
TGT.DIGITAL_MEDIA1_PRT      ,
TGT.DIGITAL_MEDIA2              ,
TGT.DIGITAL_MEDIA2_QTY      ,
TGT.DIGITAL_MEDIA2_PRT      ,
TGT.LAMINATE	,
TGT.LAMINATE_QTY	,
TGT.LAMINATE_PRT	,
TGT.MAGNET	,
TGT.MAGNET_QTY	,
TGT.MAGNET_PRT	,
TGT.METALLIC	,
TGT.METALLIC_QTY	,
TGT.METALLIC_PRT	,
TGT.SPECIALITY	,
TGT.SPECIALITY_QTY	,
TGT.SPECIALITY_PRODUCED ,
TGT.INDIGO_PRODUCT1                          ,
TGT.INDIGO_PRODUCT1_QTY                  ,
TGT.INDIGO_PRODUCT1_PRODUCED      ,
TGT.INDIGO_PRODUCT2                          ,
TGT.INDIGO_PRODUCT2_QTY                  ,
TGT.INDIGO_PRODUCT2_PRODUCED      ,
TGT.PROOF_PRODUCT	,
TGT.PROOF_QTY	,
TGT.PROOF_PRODUCED	,
TGT.CLASS_DELIVERY	,
TGT.CLASS		,
TGT.CLASS_QTY	,
TGT.CLASS_PRT	,
TGT.DID		,
TGT.DID_QTY	,
TGT.DID_PRT	,
TGT.DSSK		,
TGT.DSSK_QTY	,
TGT.DSSK_PRT	,
TGT.EZP		,
TGT.EZP_QTY	,
TGT.EZP_PRT	,
TGT.SPECIAL_REQUEST	,
TGT.WORK_ORDER_STATUS	,
TGT.PROCESSING_COMMENT	,
TGT.SHIP_GOAL_DATE	,
TGT.WOMS_NODE             ,
TGT.CHANGE_FLAG	,
TGT.MANUAL_DEACTIVATED_FLAG  ,
TGT.PENDING_CLASS_PRODUCT,
TGT.MANUALLY_SHIPPED	,
TGT.ODS_CREATE_DATE  ,
TGT.ODS_MODIFY_DATE  
) VALUES
(
SRC.PLATFORM_DETAIL	,
SRC.WORK_ORDER_ID	,
SRC.EVENT_REF_ID	,
SRC.JOB_TYPE	,
SRC.LID		,
SRC.ACCT_NAME	,
SRC.SHIP_PROPSL_RECEIVED	,
NULL                                                        ,
SRC.BATCH_ID		,
SRC.WORK_ORDER_ALIAS_ID	,
SRC.SUBJECT_COUNT		,
SRC.WORK_ORDER_FORM_PRT	,
SRC.RET		,
SRC.RET_QTY	,
SRC.RET_PRT	,
SRC.PKG		,
SRC.PKG_QTY	,
SRC.PKG_PRT	,
SRC.POS		,
SRC.POS_QTY	,
SRC.POS_PRT	,
SRC.DIGITAL_MEDIA1               ,
SRC.DIGITAL_MEDIA1_QTY      ,
SRC.DIGITAL_MEDIA1_PRT      ,
SRC.DIGITAL_MEDIA2               ,
SRC.DIGITAL_MEDIA2_QTY      ,
SRC.DIGITAL_MEDIA2_PRT      ,
SRC.LAMINATE	,
SRC.LAMINATE_QTY	,
SRC.LAMINATE_PRT	,
SRC.MAGNET	,
SRC.MAGNET_QTY	,
SRC.MAGNET_PRT	,
SRC.METALLIC	,
SRC.METALLIC_QTY	,
SRC.METALLIC_PRT	,
SRC.SPECIALITY	,
SRC.SPECIALITY_QTY	,
SRC.SPECIALITY_PRODUCED	  ,
SRC.INDIGO_PRODUCT1                          ,
SRC.INDIGO_PRODUCT1_QTY                 ,
SRC.INDIGO_PRODUCT1_PRODUCED      ,
SRC.INDIGO_PRODUCT2                          ,
SRC.INDIGO_PRODUCT2_QTY                 ,
SRC.INDIGO_PRODUCT2_PRODUCED      ,
SRC.PROOF_PRODUCT	,
SRC.PROOF_QTY	,
SRC.PROOF_PRODUCED	,
SRC.CLASS_DELIVERY	,
SRC.CLASS		,
SRC.CLASS_QTY	,
SRC.CLASS_PRT	,
SRC.DID		,
SRC.DID_QTY	,
SRC.DID_PRT	,
SRC.DSSK		,
SRC.DSSK_QTY	,
SRC.DSSK_PRT	,
SRC.EZP		,
SRC.EZP_QTY	,
SRC.EZP_PRT	,
SRC.SPECIAL_REQUEST	,
SRC.WORK_ORDER_STATUS	,
SRC.PROCESSING_COMMENT	,
SRC.SHIP_GOAL_DATE	,
SRC.WOMS_NODE             ,
'I'		,
SRC.DEACTIVATED_FLAG ,
NULL                                   ,
NULL                                   ,
SYSDATE		,
SYSDATE                            
)

&

/*-----------------------------------------------*/
/* TASK No. 106 */
/* Update Mail Received Date at Target */



MERGE INTO ODS_STAGE.X1_WO_UNSHIPPED_HIST TGT
USING
(
SELECT 
DISTINCT 
WO.WORK_ORDER_ID,
WO.WOMS_NODE,
WO.LID,
WO.EVENT_REF_ID,
E.PLANT_RECEIPT_DATE,
E.PLANT_NAME 
FROM 
ODS_STAGE.X1_WO_UNSHIPPED_HIST WO,MART.EVENT E
WHERE WO.EVENT_REF_ID = E.JOB_NBR
)SRC
 ON (     
      	TGT.WORK_ORDER_ID  	    =   SRC.WORK_ORDER_ID  
      	AND TGT.WOMS_NODE         =   SRC.WOMS_NODE          
      	AND TGT.LID                          =  SRC.LID     
       )          
WHEN MATCHED THEN
 UPDATE 
 SET  
 TGT.MAIL_RECEIVED   =  SRC.PLANT_RECEIPT_DATE

&

/*-----------------------------------------------*/
/* TASK No. 107 */
/* Load to Temp3 Starts from this Prc Step */
/*-----------------------------------------------*/
/* TASK No. 108 */
/* Insert to Temp3 Table */



-- Load to Temp3 Starts from this Prc Step






INSERT INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3
SELECT
T1.PLATFORM_DETAIL              	,
T1.WORK_ORDER_ID                	,
T1.EVENT_REF_ID                     	,
T1.JOB_TYPE                             	,    
T1.LID                              	          	,
T1.ACCT_NAME                        	,
T1.SHIP_PROPSL_RECEIVED         	,
T1.BATCH_ID                         	,
T1.WORK_ORDER_ALIAS_ID          	,
T1.SUBJECT_COUNT                	,
T1.WORK_ORDER_FORM_PRT          	,
'RET'                               		,
RET.PRODUCE_QUANTITY            	,
T1.RET_PRT                          	,
'PKG'                               		,
PKG.PRODUCE_QUANTITY            	,
T1.PKG_PRT                          	,	
T1.POS                              		,
T1.POS_QTY                          	,
T1.POS_PRT                              	,
DM.UNDERCLASS_PRODUCT_CODE       ,    
DM.PRODUCE_QUANTITY                     	 ,
T1.DIGITAL_MEDIA1_PRT                       ,
LAMINATE.UNDERCLASS_PRODUCT_CODE   ,
LAMINATE.PRODUCE_QUANTITY                   ,
T1.LAMINATE_PRT                                 	        ,
MAGNET.UNDERCLASS_PRODUCT_CODE      ,
MAGNET.PRODUCE_QUANTITY                      ,
T1.MAGNET_PRT                                             ,
METALLIC.UNDERCLASS_PRODUCT_CODE    ,
METALLIC.PRODUCE_QUANTITY                    ,
T1.METALLIC_PRT                                           ,
SPEC.UNDERCLASS_PRODUCT_CODE            ,
SPEC.PRODUCE_QUANTITY                      	,
T1.SPECIALITY_PRODUCED                      	,    
INDIGO.UNDERCLASS_PRODUCT_CODE         	,
INDIGO.PRODUCE_QUANTITY                 	,
T1.INDIGO_PRODUCT1_PRODUCED        	,
PROOF.UNDERCLASS_PRODUCT_CODE           	,
PROOF.PRODUCE_QUANTITY                      	,    
T1.PROOF_PRODUCED                          		,
T1.CLASS_DELIVERY                           		,
CLASS.UNDERCLASS_PRODUCT_CODE           	,
CLASS.PRODUCE_QUANTITY                      	,
T1.CLASS_PRT                                		,  
DID.UNDERCLASS_PRODUCT_CODE             	,
DID.PRODUCE_QUANTITY                       	,
T1.DID_PRT                       		,
DSSK.UNDERCLASS_PRODUCT_CODE            	,
DSSK.PRODUCE_QUANTITY                       	,
T1.DSSK_PRT                      		,
EZP.UNDERCLASS_PRODUCT_CODE             	,
EZP.PRODUCE_QUANTITY                       	,
T1.EZP_PRT                       		,
POS618.UNDERCLASS_PRODUCT_CODE         	,
POS618.PRODUCE_QUANTITY               	,
T1.POS618_PRT           			,
T1.SPECIAL_REQUEST                  		,
T1.WORK_ORDER_STATUS            		,
T1.PROCESSING_COMMENT           		,
T1.SHIP_GOAL_DATE                   		,
T1.WOMS_NODE                        		,
T1.DEACTIVATED_FLAG   
FROM
RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 T1,
RAX_APP_USER.UC_PRODUCT_CODE_RET RET,
RAX_APP_USER.UC_PRODUCT_CODE_PKG PKG,
RAX_APP_USER.UC_PRODUCT_CODE_DM DM,
RAX_APP_USER.UC_PRODUCT_CODE_LAMINATE LAMINATE,
RAX_APP_USER.UC_PRODUCT_CODE_MAGNET   MAGNET,
RAX_APP_USER.UC_PRODUCT_CODE_METALLIC METALLIC,
RAX_APP_USER.UC_PRODUCT_CODE_SPECIALITY SPEC,
RAX_APP_USER.UC_PRODUCT_CODE_INDIGO  INDIGO,
RAX_APP_USER.UC_PRODUCT_CODE_PROOF   PROOF,
RAX_APP_USER.UC_PRODUCT_CODE_CLASS   CLASS,
RAX_APP_USER.UC_PRODUCT_CODE_DID     DID,
RAX_APP_USER.UC_PRODUCT_CODE_DSSK    DSSK,
RAX_APP_USER.UC_PRODUCT_CODE_EZP     EZP,
RAX_APP_USER.UC_PRODUCT_CODE_618     POS618
WHERE 1 = 1
      AND T1.WORK_ORDER_ID = RET.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = RET.WOMS_NODE(+)
      AND T1.LID = RET.LID(+)
      AND T1.WORK_ORDER_ID = PKG.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = PKG.WOMS_NODE(+)
      AND T1.LID = PKG.LID(+)
      AND T1.WORK_ORDER_ID = DM.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = DM.WOMS_NODE(+)
      AND T1.LID = DM.LID(+)
      AND T1.WORK_ORDER_ID = LAMINATE.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = LAMINATE.WOMS_NODE(+)
      AND T1.LID = LAMINATE.LID(+)
      AND T1.WORK_ORDER_ID = MAGNET.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = MAGNET.WOMS_NODE(+)
      AND T1.LID = MAGNET.LID(+)
      AND T1.WORK_ORDER_ID = METALLIC.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = METALLIC.WOMS_NODE(+)
      AND T1.LID = METALLIC.LID(+)
      AND T1.WORK_ORDER_ID = SPEC.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = SPEC.WOMS_NODE(+)
      AND T1.LID = SPEC.LID(+)
      AND T1.WORK_ORDER_ID = INDIGO.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = INDIGO.WOMS_NODE(+)
      AND T1.LID = INDIGO.LID(+)
      AND T1.WORK_ORDER_ID = PROOF.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = PROOF.WOMS_NODE(+)
      AND T1.LID = PROOF.LID(+)
      AND T1.WORK_ORDER_ID = CLASS.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = CLASS.WOMS_NODE(+)
      AND T1.LID = CLASS.LID(+)
      AND T1.WORK_ORDER_ID = DID.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = DID.WOMS_NODE(+)
      AND T1.LID = DID.LID(+)
      AND T1.WORK_ORDER_ID = DSSK.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = DSSK.WOMS_NODE(+)
      AND T1.LID = DSSK.LID(+)
      AND T1.WORK_ORDER_ID = EZP.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = EZP.WOMS_NODE(+)
      AND T1.LID = EZP.LID(+)
      AND T1.WORK_ORDER_ID = POS618.WORK_ORDER_ID(+)
      AND T1.WOMS_NODE = POS618.WOMS_NODE(+)
      AND T1.LID = POS618.LID(+)

&

/*-----------------------------------------------*/
/* TASK No. 109 */
/* Merge DT to Temp3 */



begin

MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
USING  
         (   
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE = 'RET'
    AND STATUS_ID = 2
           )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
            )          
    WHEN MATCHED THEN
    UPDATE 
    SET  
       TGT.RET_PRT   =  SRC.PRODUCE_PRODUCED_DT;
      
        

MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
      X1_WO_PRODUCE_DT_TEMP
      WHERE UNDERCLASS_PRODUCT_CODE IN ('PKG','SBP')
      AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.PKG = SRC.UNDERCLASS_PRODUCT_CODE
            )                  
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.PKG_PRT    = SRC.PRODUCE_PRODUCED_DT;



MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE  UNDERCLASS_PRODUCT_CODE IN ('POS')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             )                 
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.POS_PRT  = SRC.PRODUCE_PRODUCED_DT;
        



MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('IC')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.DIGITAL_MEDIA = SRC.UNDERCLASS_PRODUCT_CODE
             )             
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.DIGITAL_MEDIA_PRT =  SRC.PRODUCE_PRODUCED_DT;





MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('IG')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.DIGITAL_MEDIA = SRC.UNDERCLASS_PRODUCT_CODE
             )             
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.DIGITAL_MEDIA_PRT =  SRC.PRODUCE_PRODUCED_DT;






MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('HL','LC','LG','LP','LR','LT','LU','LX','LY','LZ')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.LAMINATE = SRC.UNDERCLASS_PRODUCT_CODE
           )               
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.LAMINATE_PRT  = SRC.PRODUCE_PRODUCED_DT;



MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('HA','MA','ME','MI','MJ','MO','MV','MY','MZ')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.MAGNET = SRC.UNDERCLASS_PRODUCT_CODE
            )            
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.MAGNET_PRT = SRC.PRODUCE_PRODUCED_DT;


MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('ML','NC','NX')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.METALLIC = SRC.UNDERCLASS_PRODUCT_CODE
            )                 
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.METALLIC_PRT = SRC.PRODUCE_PRODUCED_DT;


MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('SA','SZ')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.SPECIALITY = SRC.UNDERCLASS_PRODUCT_CODE
             )          
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.SPECIALITY_PRODUCED = SRC.PRODUCE_PRODUCED_DT;




 MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
 USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT AS PRODUCE_PRODUCED_DT,
     WOMS_NODE 
     FROM 
     X1_WO_PRODUCE_DT_TEMP
     WHERE UNDERCLASS_PRODUCT_CODE IN ('FT') 
     AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.INDIGO_PRODUCT = SRC.UNDERCLASS_PRODUCT_CODE
         )           
  WHEN MATCHED THEN
    UPDATE 
    SET  
       TGT.INDIGO_PRODUCT_PRODUCED = SRC.PRODUCE_PRODUCED_DT;
       
       
       
       

 MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
 USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT AS PRODUCE_PRODUCED_DT,
     WOMS_NODE 
     FROM 
     X1_WO_PRODUCE_DT_TEMP
     WHERE UNDERCLASS_PRODUCT_CODE IN ('NA') 
     AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.INDIGO_PRODUCT = SRC.UNDERCLASS_PRODUCT_CODE
         )           
  WHEN MATCHED THEN
    UPDATE 
    SET  
       TGT.INDIGO_PRODUCT_PRODUCED = SRC.PRODUCE_PRODUCED_DT;       








MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
     FROM 
     X1_WO_PRODUCE_DT_TEMP
     WHERE UNDERCLASS_PRODUCT_CODE IN ('601','602','603','604')
     AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.PROOF_PRODUCT = SRC.UNDERCLASS_PRODUCT_CODE
            )                
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.PROOF_PRODUCED = SRC.PRODUCE_PRODUCED_DT;



MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('CMP','G08')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.CLASS = SRC.UNDERCLASS_PRODUCT_CODE
            )              
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.CLASS_PRT = SRC.PRODUCE_PRODUCED_DT;



MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('DCP','DID')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
             AND TGT.DID = SRC.UNDERCLASS_PRODUCT_CODE
            )              
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.DID_PRT  = SRC.PRODUCE_PRODUCED_DT;




MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('DSS')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
            AND TGT.WOMS_NODE = SRC.WOMS_NODE
            AND TGT.LID = SRC.LID
            )             
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.DSSK_PRT   = SRC.PRODUCE_PRODUCED_DT;




MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
           FROM 
        X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('EZP')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
            )             
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.EZP_PRT     = SRC.PRODUCE_PRODUCED_DT;



MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
USING  
    (  
     SELECT    
     WORK_ORDER_ID,           
     LID,                              
     UNDERCLASS_PRODUCT_CODE,  
     PRODUCE_PRODUCED_DT,
     WOMS_NODE 
     FROM 
     X1_WO_PRODUCE_DT_TEMP
    WHERE UNDERCLASS_PRODUCT_CODE IN ('618')
    AND STATUS_ID = 2
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
             AND TGT.WOMS_NODE = SRC.WOMS_NODE
             AND TGT.LID = SRC.LID
            )             
  WHEN MATCHED THEN
    UPDATE 
     SET  
       TGT.POS618_PRT   = SRC.PRODUCE_PRODUCED_DT;


end;

&

/*-----------------------------------------------*/
/* TASK No. 110 */
/* Update Work Order From PRT Date (Temp3) */



MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
USING  
    (  
    SELECT         
    TEMP.WORK_ORDER_ID,
    TEMP.WOMS_NODE,
    TEMP.LID,    
    WORK_ORDER_FORM_PRT
    FROM 
    RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 TEMP    
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID     
          AND TGT.WOMS_NODE = SRC.WOMS_NODE
          AND TGT.LID = SRC.LID              
         )        
  WHEN MATCHED THEN
    UPDATE 
     SET  
        TGT.WORK_ORDER_FORM_PRT = SRC.WORK_ORDER_FORM_PRT

&

/*-----------------------------------------------*/
/* TASK No. 111 */
/* Merge POS,SUBJECT COUNT to Temp3 */



begin

MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
    USING  
    (  
     SELECT 
        TEMP.WORK_ORDER_ID,
        TEMP.WOMS_NODE,
        TEMP.LID                    
        FROM RAX_APP_USER.TEMP_WO_DEACTIVE_BASED_ON_WOL TEMP             
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
          AND TGT.WOMS_NODE = SRC.WOMS_NODE
          AND TGT.LID = SRC.LID
         )          
  WHEN MATCHED THEN
    UPDATE 
     SET  
          TGT.DEACTIVATED_FLAG =  'Y';


MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
    USING  
    (  
     SELECT 
        WORK_ORDER_ID,
        LID,
        PRODUCT_QTY,
        PRODUCT_PRODUCED AS POS_PRT,
        WOMS_NODE
     FROM 
     RAX_APP_USER.TEMP_POS
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
          AND TGT.WOMS_NODE = SRC.WOMS_NODE
          AND TGT.LID = SRC.LID
         )          
  WHEN MATCHED THEN
    UPDATE 
     SET  
          TGT.POS                   =  'POS',
          TGT.POS_QTY          =  SRC.PRODUCT_QTY,
          TGT.POS_PRT           =  SRC.POS_PRT;          





MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
    USING  
    (  
      SELECT
     X.WORK_ORDER_ID,
     X.LID,
     X.WOMS_NODE, 
     MAX(NVL(SUBJ1.WORK_ORDER_SUBJECT_COUNT,SUBJ2.WORK_ORDER_SUBJECT_COUNT)) AS SUBJECT_COUNT,
     NVL(SUBJ1.CLASS_DELIVER_TYPE,SUBJ2.CLASS_DELIVER_TYPE) AS CLASS_DELIVER_TYPE
     FROM 
	RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 X,
	RAX_APP_USER.TEMP_WORK_ORDER_SUBJECT_COUNT SUBJ1,
	RAX_APP_USER.TEMP_WO_SUBJ_COUNT_WODEACTIVE SUBJ2 
     WHERE 
            X.WORK_ORDER_ID = SUBJ1.WORK_ORDER_ID(+) 
    AND X.WOMS_NODE = SUBJ1.WOMS_NODE(+)
    AND X.LID = SUBJ1.LID(+)
    AND X.WORK_ORDER_ID = SUBJ2.WORK_ORDER_ID(+)
    AND X.WOMS_NODE = SUBJ2.WOMS_NODE(+)
    AND X.LID = SUBJ2.LID(+)
    GROUP BY 
    	X.WORK_ORDER_ID,
     	X.LID,
     	X.WOMS_NODE,
                     NVL(SUBJ1.CLASS_DELIVER_TYPE,SUBJ2.CLASS_DELIVER_TYPE)
    )SRC
      ON 
         (
          TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
          AND TGT.WOMS_NODE = SRC.WOMS_NODE
          AND TGT.LID = SRC.LID
         )          
  WHEN MATCHED THEN
    UPDATE 
     SET  
          TGT.SUBJECT_COUNT  =  SRC.SUBJECT_COUNT,
          TGT.CLASS_DELIVERY    = SRC.CLASS_DELIVER_TYPE;


MERGE INTO RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 TGT
    USING  
    (  
     SELECT
     WORK_ORDER_ID,
     LID,
     WOMS_NODE, 
     SPECIAL_REQUEST
     FROM 
        RAX_APP_USER.TEMP_WO_SPECIALREQUEST 
    )SRC
      ON (
          TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
          AND TGT.WOMS_NODE = SRC.WOMS_NODE
          AND TGT.LID = SRC.LID
         )          
  WHEN MATCHED THEN
    UPDATE 
     SET  
        TGT.SPECIAL_REQUEST = 'Y';



end;

&

/*-----------------------------------------------*/
/* TASK No. 112 */
/* UPDATE_POS618 */



begin

        UPDATE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3       
        SET POS = '618'
        WHERE POS_QTY IS NULL 
        AND POS618_QTY IS NOT NULL;


        COMMIT;

        
        UPDATE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3       
        SET POS_QTY =  POS618_QTY
        WHERE POS_QTY IS NULL 
        AND POS618_QTY IS NOT NULL;

   
        COMMIT;

        
        UPDATE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3
        SET POS_PRT =  POS618_PRT
        WHERE  POS = '618'
        AND POS618_PRT IS NOT NULL;

        
end;

&

/*-----------------------------------------------*/
/* TASK No. 113 */
/* Insert to Temp Table (ONE_TO_MANY_X1_WO - INDIGO) */



INSERT INTO RAX_APP_USER.ONE_TO_MANY_X1_WO
SELECT 
WORK_ORDER_ID,LID,WOMS_NODE,COUNT(*),'INDIGO'
FROM
    (
     SELECT 
     DISTINCT WORK_ORDER_ID,LID,WOMS_NODE,INDIGO_PRODUCT 
     FROM 
     RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3
     )
GROUP BY WORK_ORDER_ID,LID,WOMS_NODE
HAVING COUNT(*) > 1

&

/*-----------------------------------------------*/
/* TASK No. 114 */
/* Insert to Temp Table (ONE_TO_MANY_X1_WO - DIGITAL MEDIA) */



INSERT INTO ONE_TO_MANY_X1_WO
SELECT WORK_ORDER_ID,LID,WOMS_NODE,COUNT(*),'DIGITAL'
FROM
(
SELECT DISTINCT WORK_ORDER_ID,LID,WOMS_NODE,DIGITAL_MEDIA FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3
)
GROUP BY WORK_ORDER_ID,LID,WOMS_NODE
HAVING COUNT(*) > 1

&

/*-----------------------------------------------*/
/* TASK No. 115 */
/* Insert to Temp Table (ONE_TO_MANY_X1_WO - OTHER) */



insert into ONE_TO_MANY_X1_WO
( work_order_id
, woms_node
, lid
, attr
)
select work_order_id
, woms_node
, lid
, 'OTHER' as attr
FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3
WHERE (WORK_ORDER_ID,WOMS_NODE,LID)
    NOT IN (SELECT WORK_ORDER_ID,WOMS_NODE,LID FROM ONE_TO_MANY_X1_WO)
group by work_order_id
, woms_node
, lid
, 'OTHER'
having count(*) > 1

&

/*-----------------------------------------------*/
/* TASK No. 116 */
/* Insert to X1_WO_UNSHIPPED_HIST_X */



MERGE INTO ODS_STAGE.X1_WO_UNSHIPPED_HIST_X TGT
    USING (
    SELECT
    PLATFORM_DETAIL     		,
    WORK_ORDER_ID       		,
    EVENT_REF_ID        		,
    JOB_TYPE            		,
    LID                 		,
    ACCT_NAME           		,
    SHIP_PROPSL_RECEIVED    	,
    BATCH_ID                		,
    WORK_ORDER_ALIAS_ID     	,
    SUBJECT_COUNT           	,
    WORK_ORDER_FORM_PRT     	,
    RET                     		,
    RET_QTY        		,
    RET_PRT        		,
    PKG            		,
    PKG_QTY        		,
    PKG_PRT        		,
    POS            		,
    POS_QTY        		,
    POS_PRT        		,
    DIGITAL_MEDIA        		,
    DIGITAL_MEDIA_QTY    	,
    DIGITAL_MEDIA_PRT    		,    
    LAMINATE        		,
    LAMINATE_QTY    		,
    LAMINATE_PRT    		,
    MAGNET        		,
    MAGNET_QTY    		,
    MAGNET_PRT    		,
    METALLIC        		,
    METALLIC_QTY    		,
    METALLIC_PRT        		,
    SPECIALITY          		,
    SPECIALITY_QTY      		,
    SPECIALITY_PRODUCED 	,
    INDIGO_PRODUCT                          	,
    INDIGO_PRODUCT_QTY                     ,
    INDIGO_PRODUCT_PRODUCED         ,    
    PROOF_PRODUCT       		,
    PROOF_QTY           		,
    PROOF_PRODUCED      		,
    CLASS_DELIVERY      		,
    CLASS        		,
    CLASS_QTY    		,
    CLASS_PRT    		,
    DID          			,
    DID_QTY      		,
    DID_PRT      		,
    DSSK         		,
    DSSK_QTY     		,
    DSSK_PRT     		,
    EZP         	 		,
    EZP_QTY      		,
    EZP_PRT      		,
    SPECIAL_REQUEST      		,
    WORK_ORDER_STATUS    	,
    PROCESSING_COMMENT   	,
    SHIP_GOAL_DATE       		,
    WOMS_NODE            		,
    DEACTIVATED_FLAG         
    FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3  
    WHERE (WORK_ORDER_ID,WOMS_NODE,LID) 
    NOT IN (SELECT WORK_ORDER_ID,WOMS_NODE,LID FROM ONE_TO_MANY_X1_WO)     
               )SRC
    ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
           AND TGT.WOMS_NODE = SRC.WOMS_NODE
           AND TGT.LID = SRC.LID
           )
  WHEN MATCHED THEN
    UPDATE 
    SET 
TGT.PLATFORM_DETAIL             	=    SRC.PLATFORM_DETAIL     	,
TGT.EVENT_REF_ID                	=    SRC.EVENT_REF_ID          	,
TGT.JOB_TYPE                        	=    SRC.JOB_TYPE                   	,
TGT.ACCT_NAME                   	=    SRC.ACCT_NAME                	,
TGT.SHIP_PROPSL_RECEIVED        	=    SRC.SHIP_PROPSL_RECEIVED    	,
TGT.MAIL_RECEIVED               	=    NULL             		,
TGT.BATCH_ID                        	=    SRC.BATCH_ID        		,
TGT.WORK_ORDER_ALIAS_ID         	=    SRC.WORK_ORDER_ALIAS_ID    	,
TGT.SUBJECT_COUNT               	=    SRC.SUBJECT_COUNT    	,
TGT.WORK_ORDER_FORM_PRT         	=    SRC.WORK_ORDER_FORM_PRT    	,
TGT.RET                    		=    SRC.RET        		,
TGT.RET_QTY                		=    SRC.RET_QTY    ,
TGT.RET_PRT                		=    SRC.RET_PRT    ,
TGT.PKG                    		=    SRC.PKG            ,
TGT.PKG_QTY                		=    SRC.PKG_QTY    ,
TGT.PKG_PRT                		=    SRC.PKG_PRT    ,
TGT.POS                    		=    SRC.POS            ,
TGT.POS_QTY                		=    SRC.POS_QTY    ,
TGT.POS_PRT                		=    SRC.POS_PRT           	            	,
TGT.DIGITAL_MEDIA                  	=    SRC.DIGITAL_MEDIA              	,
TGT.DIGITAL_MEDIA_QTY              	=    SRC.DIGITAL_MEDIA_QTY     	,
TGT.DIGITAL_MEDIA_PRT              	=    SRC.DIGITAL_MEDIA_PRT      	,
TGT.LAMINATE                    	=    SRC.LAMINATE        		,
TGT.LAMINATE_QTY                	=    SRC.LAMINATE_QTY        	,
TGT.LAMINATE_PRT                	=    SRC.LAMINATE_PRT        	,
TGT.MAGNET                      	=    SRC.MAGNET        		,
TGT.MAGNET_QTY                  	=    SRC.MAGNET_QTY                         	,
TGT.MAGNET_PRT                  	=    SRC.MAGNET_PRT                         	,
TGT.METALLIC                    	=    SRC.METALLIC        		,
TGT.METALLIC_QTY                	=    SRC.METALLIC_QTY                         ,
TGT.METALLIC_PRT                	=    SRC.METALLIC_PRT                         ,
TGT.SPECIALITY                  	=    SRC.SPECIALITY        		,
TGT.SPECIALITY_QTY              	=    SRC.SPECIALITY_QTY                      ,
TGT.SPECIALITY_PRODUCED         	=    SRC.SPECIALITY_PRODUCED    	,
TGT.INDIGO_PRODUCT                  	=    SRC.INDIGO_PRODUCT                   ,
TGT.INDIGO_PRODUCT_QTY               	=    SRC.INDIGO_PRODUCT_QTY           ,
TGT.INDIGO_PRODUCT_PRODUCED    	=    SRC.INDIGO_PRODUCT_PRODUCED   ,
TGT.PROOF_PRODUCT            	=    SRC.PROOF_PRODUCT                        ,
TGT.PROOF_QTY                	=    SRC.PROOF_QTY         	     ,
TGT.PROOF_PRODUCED            	=    SRC.PROOF_PRODUCED                      ,
TGT.CLASS_DELIVERY            	=    SRC.CLASS_DELIVERY    	     ,
TGT.CLASS                    		=    SRC.CLASS                         	     ,
TGT.CLASS_QTY                	=    SRC.CLASS_QTY    		     ,
TGT.CLASS_PRT                		=    SRC.CLASS_PRT    	,
TGT.DID                    		=    SRC.DID                      ,
TGT.DID_QTY                		=    SRC.DID_QTY    	,
TGT.DID_PRT                		=    SRC.DID_PRT    	,
TGT.DSSK                    		=    SRC.DSSK                    ,
TGT.DSSK_QTY               		=    SRC.DSSK_QTY    	,
TGT.DSSK_PRT                		=    SRC.DSSK_PRT    	,
TGT.EZP                    		=    SRC.EZP                      ,
TGT.EZP_QTY                		=    SRC.EZP_QTY    	,
TGT.EZP_PRT                		=    SRC.EZP_PRT    	,
TGT.SPECIAL_REQUEST            	=    SRC.SPECIAL_REQUEST    	,
TGT.WORK_ORDER_STATUS        	=    SRC.WORK_ORDER_STATUS    	,
TGT.PROCESSING_COMMENT        	=    SRC.PROCESSING_COMMENT    	,
TGT.SHIP_GOAL_DATE            	=    SRC.SHIP_GOAL_DATE        	,
TGT.CHANGE_FLAG                   	=    'U'            		,
TGT.MANUAL_DEACTIVATED_FLAG       =    SRC.DEACTIVATED_FLAG         	,
TGT.PENDING_CLASS_PRODUCT           =    NULL                                           	,
TGT.MANUALLY_SHIPPED                       =    NULL                                       	,
TGT.ODS_MODIFY_DATE              	=    SYSDATE                                

  WHEN NOT MATCHED THEN
INSERT
(
TGT.PLATFORM_DETAIL    ,
TGT.WORK_ORDER_ID    ,
TGT.EVENT_REF_ID    ,
TGT.JOB_TYPE    ,
TGT.LID        ,
TGT.ACCT_NAME    ,
TGT.SHIP_PROPSL_RECEIVED    ,
TGT.MAIL_RECEIVED                  ,
TGT.BATCH_ID        ,
TGT.WORK_ORDER_ALIAS_ID    ,
TGT.SUBJECT_COUNT        ,
TGT.WORK_ORDER_FORM_PRT    ,
TGT.RET        ,
TGT.RET_QTY    ,
TGT.RET_PRT    ,
TGT.PKG        ,
TGT.PKG_QTY    ,
TGT.PKG_PRT    ,
TGT.POS        ,
TGT.POS_QTY    ,
TGT.POS_PRT    ,
TGT.DIGITAL_MEDIA              ,
TGT.DIGITAL_MEDIA_QTY     ,
TGT.DIGITAL_MEDIA_PRT      ,
TGT.LAMINATE    ,
TGT.LAMINATE_QTY    ,
TGT.LAMINATE_PRT    ,
TGT.MAGNET    ,
TGT.MAGNET_QTY    ,
TGT.MAGNET_PRT    ,
TGT.METALLIC    ,
TGT.METALLIC_QTY    ,
TGT.METALLIC_PRT    ,
TGT.SPECIALITY    ,
TGT.SPECIALITY_QTY    ,
TGT.SPECIALITY_PRODUCED ,
TGT.INDIGO_PRODUCT                          ,
TGT.INDIGO_PRODUCT_QTY                  ,
TGT.INDIGO_PRODUCT_PRODUCED      ,
TGT.PROOF_PRODUCT    ,
TGT.PROOF_QTY    ,
TGT.PROOF_PRODUCED    ,
TGT.CLASS_DELIVERY    ,
TGT.CLASS        ,
TGT.CLASS_QTY    ,
TGT.CLASS_PRT    ,
TGT.DID        ,
TGT.DID_QTY    ,
TGT.DID_PRT    ,
TGT.DSSK        ,
TGT.DSSK_QTY    ,
TGT.DSSK_PRT    ,
TGT.EZP        ,
TGT.EZP_QTY    ,
TGT.EZP_PRT    ,
TGT.SPECIAL_REQUEST    ,
TGT.WORK_ORDER_STATUS    ,
TGT.PROCESSING_COMMENT    ,
TGT.SHIP_GOAL_DATE    ,
TGT.WOMS_NODE             ,
TGT.CHANGE_FLAG    ,
TGT.MANUAL_DEACTIVATED_FLAG  ,
TGT.PENDING_CLASS_PRODUCT,
TGT.MANUALLY_SHIPPED    ,
TGT.ODS_CREATE_DATE  ,
TGT.ODS_MODIFY_DATE  
) VALUES
(
SRC.PLATFORM_DETAIL    ,
SRC.WORK_ORDER_ID    ,
SRC.EVENT_REF_ID    ,
SRC.JOB_TYPE    ,
SRC.LID        ,
SRC.ACCT_NAME    ,
SRC.SHIP_PROPSL_RECEIVED    ,
NULL            ,
SRC.BATCH_ID        ,
SRC.WORK_ORDER_ALIAS_ID    ,
SRC.SUBJECT_COUNT        ,
SRC.WORK_ORDER_FORM_PRT    ,
SRC.RET        ,
SRC.RET_QTY    ,
SRC.RET_PRT    ,
SRC.PKG        ,
SRC.PKG_QTY    ,
SRC.PKG_PRT    ,
SRC.POS        ,
SRC.POS_QTY    ,
SRC.POS_PRT    ,
SRC.DIGITAL_MEDIA               ,
SRC.DIGITAL_MEDIA_QTY      ,
SRC.DIGITAL_MEDIA_PRT      ,
SRC.LAMINATE    ,
SRC.LAMINATE_QTY    ,
SRC.LAMINATE_PRT    ,
SRC.MAGNET    ,
SRC.MAGNET_QTY    ,
SRC.MAGNET_PRT    ,
SRC.METALLIC    ,
SRC.METALLIC_QTY    ,
SRC.METALLIC_PRT    ,
SRC.SPECIALITY    ,
SRC.SPECIALITY_QTY    ,
SRC.SPECIALITY_PRODUCED      ,
SRC.INDIGO_PRODUCT                          ,
SRC.INDIGO_PRODUCT_QTY                 ,
SRC.INDIGO_PRODUCT_PRODUCED      ,
SRC.PROOF_PRODUCT    ,
SRC.PROOF_QTY    ,
SRC.PROOF_PRODUCED    ,
SRC.CLASS_DELIVERY    ,
SRC.CLASS        ,
SRC.CLASS_QTY    ,
SRC.CLASS_PRT    ,
SRC.DID        ,
SRC.DID_QTY    ,
SRC.DID_PRT    ,
SRC.DSSK        ,
SRC.DSSK_QTY    ,
SRC.DSSK_PRT    ,
SRC.EZP        ,
SRC.EZP_QTY    ,
SRC.EZP_PRT    ,
SRC.SPECIAL_REQUEST    ,
SRC.WORK_ORDER_STATUS    ,
SRC.PROCESSING_COMMENT    ,
SRC.SHIP_GOAL_DATE    ,
SRC.WOMS_NODE             ,
'I'        ,
SRC.DEACTIVATED_FLAG ,
NULL                                   ,
NULL                                   ,
SYSDATE        ,
SYSDATE                            
)

&

/*-----------------------------------------------*/
/* TASK No. 117 */
/* Insert to X1_WO_UNSHIPPED_HIST_X */



MERGE INTO ODS_STAGE.X1_WO_UNSHIPPED_HIST_X TGT
    USING (
    SELECT
    PLATFORM_DETAIL    ,
    WORK_ORDER_ID    ,
    EVENT_REF_ID    ,
    JOB_TYPE        ,
    LID        ,
    ACCT_NAME        ,
    SHIP_PROPSL_RECEIVED    ,
    BATCH_ID        ,
    WORK_ORDER_ALIAS_ID    ,
    SUBJECT_COUNT    ,
    WORK_ORDER_FORM_PRT,
    RET        ,
    RET_QTY        ,
    RET_PRT        ,
    PKG        ,
    PKG_QTY        ,
    PKG_PRT        ,
    POS        ,
    POS_QTY        ,
    POS_PRT        ,
    DIGITAL_MEDIA    ,
    DIGITAL_MEDIA_QTY    ,
    DIGITAL_MEDIA_PRT    ,    
    LAMINATE        ,
    LAMINATE_QTY    ,
    LAMINATE_PRT    ,
    MAGNET        ,
    MAGNET_QTY    ,
    MAGNET_PRT    ,
    METALLIC        ,
    METALLIC_QTY    ,
    METALLIC_PRT    ,
    SPECIALITY        ,
    SPECIALITY_QTY    ,
    SPECIALITY_PRODUCED    ,
    INDIGO_PRODUCT                          ,
    INDIGO_PRODUCT_QTY                 ,
    INDIGO_PRODUCT_PRODUCED      ,    
    PROOF_PRODUCT    ,
    PROOF_QTY        ,
    PROOF_PRODUCED    ,
    CLASS_DELIVERY    ,
    CLASS        ,
    CLASS_QTY    ,
    CLASS_PRT    ,
    DID    ,
    DID_QTY    ,
    DID_PRT    ,
    DSSK    ,
    DSSK_QTY    ,
    DSSK_PRT    ,
    EZP    ,
    EZP_QTY    ,
    EZP_PRT    ,
    SPECIAL_REQUEST    ,
    WORK_ORDER_STATUS    ,
    PROCESSING_COMMENT    ,
    SHIP_GOAL_DATE    ,
    WOMS_NODE                    ,
    DEACTIVATED_FLAG         
    FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3  
    WHERE (WORK_ORDER_ID,WOMS_NODE,LID,'INDIGO') 
              IN (SELECT WORK_ORDER_ID,WOMS_NODE,LID,ATTR FROM ONE_TO_MANY_X1_WO)     
               )SRC
    ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
           AND TGT.WOMS_NODE = SRC.WOMS_NODE
           AND TGT.LID = SRC.LID
           AND TGT.INDIGO_PRODUCT = SRC.INDIGO_PRODUCT 
           )
  WHEN MATCHED THEN
    UPDATE 
    SET 
TGT.PLATFORM_DETAIL        =    SRC.PLATFORM_DETAIL    ,
TGT.EVENT_REF_ID        =    SRC.EVENT_REF_ID    ,
TGT.JOB_TYPE        =    SRC.JOB_TYPE    ,
TGT.ACCT_NAME        =    SRC.ACCT_NAME        ,
TGT.SHIP_PROPSL_RECEIVED    =    SRC.SHIP_PROPSL_RECEIVED    ,
TGT.MAIL_RECEIVED                              =                   NULL             ,
TGT.BATCH_ID        =    SRC.BATCH_ID        ,
TGT.WORK_ORDER_ALIAS_ID    =    SRC.WORK_ORDER_ALIAS_ID    ,
TGT.SUBJECT_COUNT        =    SRC.SUBJECT_COUNT    ,
TGT.WORK_ORDER_FORM_PRT    =    SRC.WORK_ORDER_FORM_PRT    ,
TGT.RET            =    SRC.RET        ,
TGT.RET_QTY        =    SRC.RET_QTY    ,
TGT.RET_PRT        =    SRC.RET_PRT    ,
TGT.PKG            =    SRC.PKG        ,
TGT.PKG_QTY        =    SRC.PKG_QTY    ,
TGT.PKG_PRT        =    SRC.PKG_PRT    ,
TGT.POS            =    SRC.POS        ,
TGT.POS_QTY        =    SRC.POS_QTY    ,
TGT.POS_PRT        =    SRC.POS_PRT           ,
TGT.DIGITAL_MEDIA              =      SRC.DIGITAL_MEDIA              ,
TGT.DIGITAL_MEDIA_QTY          =      SRC.DIGITAL_MEDIA_QTY      ,
TGT.DIGITAL_MEDIA_PRT          =      SRC.DIGITAL_MEDIA_PRT      ,
TGT.LAMINATE        =    SRC.LAMINATE        ,
TGT.LAMINATE_QTY        =    SRC.LAMINATE_QTY        ,
TGT.LAMINATE_PRT        =    SRC.LAMINATE_PRT        ,
TGT.MAGNET        =    SRC.MAGNET        ,
TGT.MAGNET_QTY        =    SRC.MAGNET_QTY                         ,
TGT.MAGNET_PRT        =    SRC.MAGNET_PRT                         ,
TGT.METALLIC        =    SRC.METALLIC        ,
TGT.METALLIC_QTY        =    SRC.METALLIC_QTY                         ,
TGT.METALLIC_PRT        =    SRC.METALLIC_PRT                         ,
TGT.SPECIALITY        =    SRC.SPECIALITY        ,
TGT.SPECIALITY_QTY        =    SRC.SPECIALITY_QTY                         ,
TGT.SPECIALITY_PRODUCED    =    SRC.SPECIALITY_PRODUCED    ,
--TGT.INDIGO_PRODUCT1                        =                  SRC.INDIGO_PRODUCT               ,
TGT.INDIGO_PRODUCT_QTY               =                  SRC.INDIGO_PRODUCT_QTY                ,
TGT.INDIGO_PRODUCT_PRODUCED    =                  SRC.INDIGO_PRODUCT_PRODUCED    ,
TGT.PROOF_PRODUCT        =    SRC.PROOF_PRODUCT                          ,
TGT.PROOF_QTY        =    SRC.PROOF_QTY         ,
TGT.PROOF_PRODUCED        =    SRC.PROOF_PRODUCED                          ,
TGT.CLASS_DELIVERY        =    SRC.CLASS_DELIVERY    ,
TGT.CLASS            =    SRC.CLASS                         ,
TGT.CLASS_QTY        =    SRC.CLASS_QTY    ,
TGT.CLASS_PRT        =    SRC.CLASS_PRT    ,
TGT.DID            =    SRC.DID                         ,
TGT.DID_QTY        =    SRC.DID_QTY    ,
TGT.DID_PRT        =    SRC.DID_PRT    ,
TGT.DSSK            =    SRC.DSSK                         ,
TGT.DSSK_QTY        =    SRC.DSSK_QTY    ,
TGT.DSSK_PRT        =    SRC.DSSK_PRT    ,
TGT.EZP            =    SRC.EZP                         ,
TGT.EZP_QTY        =    SRC.EZP_QTY    ,
TGT.EZP_PRT        =    SRC.EZP_PRT    ,
TGT.SPECIAL_REQUEST        =    SRC.SPECIAL_REQUEST    ,
TGT.WORK_ORDER_STATUS    =    SRC.WORK_ORDER_STATUS    ,
TGT.PROCESSING_COMMENT    =    SRC.PROCESSING_COMMENT    ,
TGT.SHIP_GOAL_DATE        =    SRC.SHIP_GOAL_DATE        ,
TGT.CHANGE_FLAG               =        'U'            ,
TGT.MANUAL_DEACTIVATED_FLAG       =                   SRC.DEACTIVATED_FLAG         ,
TGT.PENDING_CLASS_PRODUCT           =                   NULL                                           ,
TGT.MANUALLY_SHIPPED                         =                   NULL                                       ,
TGT.ODS_MODIFY_DATE          =        SYSDATE                                

  WHEN NOT MATCHED THEN
INSERT
(
TGT.PLATFORM_DETAIL    ,
TGT.WORK_ORDER_ID    ,
TGT.EVENT_REF_ID    ,
TGT.JOB_TYPE    ,
TGT.LID        ,
TGT.ACCT_NAME    ,
TGT.SHIP_PROPSL_RECEIVED    ,
TGT.MAIL_RECEIVED                  ,
TGT.BATCH_ID        ,
TGT.WORK_ORDER_ALIAS_ID    ,
TGT.SUBJECT_COUNT        ,
TGT.WORK_ORDER_FORM_PRT    ,
TGT.RET        ,
TGT.RET_QTY    ,
TGT.RET_PRT    ,
TGT.PKG        ,
TGT.PKG_QTY    ,
TGT.PKG_PRT    ,
TGT.POS        ,
TGT.POS_QTY    ,
TGT.POS_PRT    ,
TGT.DIGITAL_MEDIA              ,
TGT.DIGITAL_MEDIA_QTY     ,
TGT.DIGITAL_MEDIA_PRT      ,
TGT.LAMINATE    ,
TGT.LAMINATE_QTY    ,
TGT.LAMINATE_PRT    ,
TGT.MAGNET    ,
TGT.MAGNET_QTY    ,
TGT.MAGNET_PRT    ,
TGT.METALLIC    ,
TGT.METALLIC_QTY    ,
TGT.METALLIC_PRT    ,
TGT.SPECIALITY    ,
TGT.SPECIALITY_QTY    ,
TGT.SPECIALITY_PRODUCED ,
TGT.INDIGO_PRODUCT                          ,
TGT.INDIGO_PRODUCT_QTY                  ,
TGT.INDIGO_PRODUCT_PRODUCED      ,
TGT.PROOF_PRODUCT    ,
TGT.PROOF_QTY    ,
TGT.PROOF_PRODUCED    ,
TGT.CLASS_DELIVERY    ,
TGT.CLASS        ,
TGT.CLASS_QTY    ,
TGT.CLASS_PRT    ,
TGT.DID        ,
TGT.DID_QTY    ,
TGT.DID_PRT    ,
TGT.DSSK        ,
TGT.DSSK_QTY    ,
TGT.DSSK_PRT    ,
TGT.EZP        ,
TGT.EZP_QTY    ,
TGT.EZP_PRT    ,
TGT.SPECIAL_REQUEST    ,
TGT.WORK_ORDER_STATUS    ,
TGT.PROCESSING_COMMENT    ,
TGT.SHIP_GOAL_DATE    ,
TGT.WOMS_NODE             ,
TGT.CHANGE_FLAG    ,
TGT.MANUAL_DEACTIVATED_FLAG  ,
TGT.PENDING_CLASS_PRODUCT,
TGT.MANUALLY_SHIPPED    ,
TGT.ODS_CREATE_DATE  ,
TGT.ODS_MODIFY_DATE  
) VALUES
(
SRC.PLATFORM_DETAIL    ,
SRC.WORK_ORDER_ID    ,
SRC.EVENT_REF_ID    ,
SRC.JOB_TYPE    ,
SRC.LID        ,
SRC.ACCT_NAME    ,
SRC.SHIP_PROPSL_RECEIVED    ,
NULL            ,
SRC.BATCH_ID        ,
SRC.WORK_ORDER_ALIAS_ID    ,
SRC.SUBJECT_COUNT        ,
SRC.WORK_ORDER_FORM_PRT    ,
SRC.RET        ,
SRC.RET_QTY    ,
SRC.RET_PRT    ,
SRC.PKG        ,
SRC.PKG_QTY    ,
SRC.PKG_PRT    ,
SRC.POS        ,
SRC.POS_QTY    ,
SRC.POS_PRT    ,
SRC.DIGITAL_MEDIA               ,
SRC.DIGITAL_MEDIA_QTY      ,
SRC.DIGITAL_MEDIA_PRT      ,
SRC.LAMINATE    ,
SRC.LAMINATE_QTY    ,
SRC.LAMINATE_PRT    ,
SRC.MAGNET    ,
SRC.MAGNET_QTY    ,
SRC.MAGNET_PRT    ,
SRC.METALLIC    ,
SRC.METALLIC_QTY    ,
SRC.METALLIC_PRT    ,
SRC.SPECIALITY    ,
SRC.SPECIALITY_QTY    ,
SRC.SPECIALITY_PRODUCED      ,
SRC.INDIGO_PRODUCT                          ,
SRC.INDIGO_PRODUCT_QTY                 ,
SRC.INDIGO_PRODUCT_PRODUCED      ,
SRC.PROOF_PRODUCT    ,
SRC.PROOF_QTY    ,
SRC.PROOF_PRODUCED    ,
SRC.CLASS_DELIVERY    ,
SRC.CLASS        ,
SRC.CLASS_QTY    ,
SRC.CLASS_PRT    ,
SRC.DID        ,
SRC.DID_QTY    ,
SRC.DID_PRT    ,
SRC.DSSK        ,
SRC.DSSK_QTY    ,
SRC.DSSK_PRT    ,
SRC.EZP        ,
SRC.EZP_QTY    ,
SRC.EZP_PRT    ,
SRC.SPECIAL_REQUEST    ,
SRC.WORK_ORDER_STATUS    ,
SRC.PROCESSING_COMMENT    ,
SRC.SHIP_GOAL_DATE    ,
SRC.WOMS_NODE             ,
'I'        ,
SRC.DEACTIVATED_FLAG ,
NULL                                   ,
NULL                                   ,
SYSDATE        ,
SYSDATE                            
)

&

/*-----------------------------------------------*/
/* TASK No. 118 */
/* Insert to X1_WO_UNSHIPPED_HIST_X */



MERGE INTO ODS_STAGE.X1_WO_UNSHIPPED_HIST_X TGT
    USING (
    SELECT
    PLATFORM_DETAIL    	,
    WORK_ORDER_ID    	,
    EVENT_REF_ID    	,
    JOB_TYPE        	,
    LID        		,
    ACCT_NAME        	,
    SHIP_PROPSL_RECEIVED    	,
    BATCH_ID        	     	,
    WORK_ORDER_ALIAS_ID    	,
    SUBJECT_COUNT    		,
    WORK_ORDER_FORM_PRT	,
    RET        			,
    RET_QTY        		,
    RET_PRT        		,
    PKG        			,
    PKG_QTY        		,
    PKG_PRT        		,	
    POS        			,
    POS_QTY        		,
    POS_PRT        		,
    DIGITAL_MEDIA    		,
    DIGITAL_MEDIA_QTY    	,
    DIGITAL_MEDIA_PRT    		,    
    LAMINATE        		,
    LAMINATE_QTY    		,
    LAMINATE_PRT    		,
    MAGNET        		,
    MAGNET_QTY    		,
    MAGNET_PRT    		,
    METALLIC        		,
    METALLIC_QTY    		,
    METALLIC_PRT    		,
    SPECIALITY        		,
    SPECIALITY_QTY    		,
    SPECIALITY_PRODUCED    	,
    INDIGO_PRODUCT                          	,
    INDIGO_PRODUCT_QTY                 	,
    INDIGO_PRODUCT_PRODUCED      	, 	   
    PROOF_PRODUCT    		,
    PROOF_QTY        		,
    PROOF_PRODUCED    		,
    CLASS_DELIVERY    		,
    CLASS        		,
    CLASS_QTY    		,
    CLASS_PRT    		,
    DID    			,
    DID_QTY    		,
    DID_PRT    		,
    DSSK    			,
    DSSK_QTY    		,
    DSSK_PRT    		,
    EZP    			,
    EZP_QTY    		,
    EZP_PRT    		,
    SPECIAL_REQUEST    		,
    WORK_ORDER_STATUS    	,
    PROCESSING_COMMENT    	,
    SHIP_GOAL_DATE    		,
    WOMS_NODE                    	,
    DEACTIVATED_FLAG        	 
    FROM RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3  
    WHERE (WORK_ORDER_ID,WOMS_NODE,LID,'DIGITAL') 
                  IN (SELECT WORK_ORDER_ID,WOMS_NODE,LID,ATTR FROM ONE_TO_MANY_X1_WO)     
               )SRC
    ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
           AND TGT.WOMS_NODE = SRC.WOMS_NODE
           AND TGT.LID = SRC.LID
           AND TGT.DIGITAL_MEDIA = SRC.DIGITAL_MEDIA 
           )
  WHEN MATCHED THEN
    UPDATE 
    SET 
TGT.PLATFORM_DETAIL            	=    SRC.PLATFORM_DETAIL    	,
TGT.EVENT_REF_ID                    	=    SRC.EVENT_REF_ID    	,
TGT.JOB_TYPE                	     	=    SRC.JOB_TYPE    		,
TGT.ACCT_NAME                	=    SRC.ACCT_NAME        	,
TGT.SHIP_PROPSL_RECEIVED        	=    SRC.SHIP_PROPSL_RECEIVED    	,
TGT.MAIL_RECEIVED                              =    NULL             		,
TGT.BATCH_ID                		=    SRC.BATCH_ID        		,
TGT.WORK_ORDER_ALIAS_ID               =    SRC.WORK_ORDER_ALIAS_ID    	,
TGT.SUBJECT_COUNT            	=    SRC.SUBJECT_COUNT    	,
TGT.WORK_ORDER_FORM_PRT        	=    SRC.WORK_ORDER_FORM_PRT    	,
TGT.RET                    		=    SRC.RET        		,
TGT.RET_QTY                		=    SRC.RET_QTY    		,
TGT.RET_PRT                		=    SRC.RET_PRT    		,
TGT.PKG                    		=    SRC.PKG        		,
TGT.PKG_QTY                		=    SRC.PKG_QTY   		,
TGT.PKG_PRT                		=    SRC.PKG_PRT    		,
TGT.POS                    		=    SRC.POS       		,
TGT.POS_QTY                		=    SRC.POS_QTY   		,
TGT.POS_PRT                		=    SRC.POS_PRT           		,
--TGT.DIGITAL_MEDIA1                  	=      SRC.DIGITAL_MEDIA              	,
TGT.DIGITAL_MEDIA_QTY              	=      SRC.DIGITAL_MEDIA_QTY      	,
TGT.DIGITAL_MEDIA_PRT              	=      SRC.DIGITAL_MEDIA_PRT      	,
TGT.LAMINATE                		=    SRC.LAMINATE        		,
TGT.LAMINATE_QTY                	=    SRC.LAMINATE_QTY        	,
TGT.LAMINATE_PRT                	=    SRC.LAMINATE_PRT        	,
TGT.MAGNET                		=    SRC.MAGNET        		,
TGT.MAGNET_QTY                	=    SRC.MAGNET_QTY                         	,
TGT.MAGNET_PRT                	=    SRC.MAGNET_PRT                         	,
TGT.METALLIC                		=    SRC.METALLIC        		,
TGT.METALLIC_QTY                	=    SRC.METALLIC_QTY                         ,
TGT.METALLIC_PRT                	=    SRC.METALLIC_PRT                         ,
TGT.SPECIALITY                	=    SRC.SPECIALITY        		,
TGT.SPECIALITY_QTY            	=    SRC.SPECIALITY_QTY                      ,
TGT.SPECIALITY_PRODUCED        	=    SRC.SPECIALITY_PRODUCED    	,
--TGT.INDIGO_PRODUCT1                     =    SRC.INDIGO_PRODUCT               	,
TGT.INDIGO_PRODUCT_QTY               	=    SRC.INDIGO_PRODUCT_QTY          ,
TGT.INDIGO_PRODUCT_PRODUCED    	=    SRC.INDIGO_PRODUCT_PRODUCED     ,
TGT.PROOF_PRODUCT            	=    SRC.PROOF_PRODUCT                          ,
TGT.PROOF_QTY                	=    SRC.PROOF_QTY         	      ,
TGT.PROOF_PRODUCED            	=    SRC.PROOF_PRODUCED                       ,
TGT.CLASS_DELIVERY            	=    SRC.CLASS_DELIVERY    	,
TGT.CLASS                    		=    SRC.CLASS                         	,
TGT.CLASS_QTY                	=    SRC.CLASS_QTY    		,
TGT.CLASS_PRT                		=    SRC.CLASS_PRT    		,
TGT.DID                    		=    SRC.DID                         	,
TGT.DID_QTY                		=    SRC.DID_QTY    		,
TGT.DID_PRT                		=    SRC.DID_PRT    		,
TGT.DSSK                    		=    SRC.DSSK                         	,
TGT.DSSK_QTY                		=    SRC.DSSK_QTY    		,
TGT.DSSK_PRT                		=    SRC.DSSK_PRT    		,
TGT.EZP                    		=    SRC.EZP                         	,
TGT.EZP_QTY                		=    SRC.EZP_QTY    		,
TGT.EZP_PRT                		=    SRC.EZP_PRT    		,
TGT.SPECIAL_REQUEST            	=    SRC.SPECIAL_REQUEST    	,
TGT.WORK_ORDER_STATUS        	=    SRC.WORK_ORDER_STATUS    	,
TGT.PROCESSING_COMMENT        	=    SRC.PROCESSING_COMMENT    	,
TGT.SHIP_GOAL_DATE            	=    SRC.SHIP_GOAL_DATE        	,
TGT.CHANGE_FLAG                   	=     'U'            		,
TGT.MANUAL_DEACTIVATED_FLAG       =     SRC.DEACTIVATED_FLAG         	,
TGT.PENDING_CLASS_PRODUCT           =     NULL                                           	,
TGT.MANUALLY_SHIPPED                       =     NULL                                       	,
TGT.ODS_MODIFY_DATE              	=     SYSDATE                               	 

  WHEN NOT MATCHED THEN
INSERT
(
TGT.PLATFORM_DETAIL    	,
TGT.WORK_ORDER_ID    		,
TGT.EVENT_REF_ID    		,
TGT.JOB_TYPE    		,
TGT.LID        			,
TGT.ACCT_NAME    		,
TGT.SHIP_PROPSL_RECEIVED    	,
TGT.MAIL_RECEIVED                  	,
TGT.BATCH_ID        		,
TGT.WORK_ORDER_ALIAS_ID    	,
TGT.SUBJECT_COUNT        	,
TGT.WORK_ORDER_FORM_PRT    	,
TGT.RET        		,
TGT.RET_QTY    		,
TGT.RET_PRT    		,
TGT.PKG        		,
TGT.PKG_QTY    		,
TGT.PKG_PRT    		,
TGT.POS        		,
TGT.POS_QTY    		,
TGT.POS_PRT    		,
TGT.DIGITAL_MEDIA              	,
TGT.DIGITAL_MEDIA_QTY     	,
TGT.DIGITAL_MEDIA_PRT      	,
TGT.LAMINATE    		,
TGT.LAMINATE_QTY    		,
TGT.LAMINATE_PRT    		,
TGT.MAGNET    		,
TGT.MAGNET_QTY    ,
TGT.MAGNET_PRT    ,
TGT.METALLIC    ,
TGT.METALLIC_QTY    ,
TGT.METALLIC_PRT    ,
TGT.SPECIALITY    ,
TGT.SPECIALITY_QTY    ,
TGT.SPECIALITY_PRODUCED ,
TGT.INDIGO_PRODUCT                          ,
TGT.INDIGO_PRODUCT_QTY                  ,
TGT.INDIGO_PRODUCT_PRODUCED      ,
TGT.PROOF_PRODUCT    ,
TGT.PROOF_QTY    ,
TGT.PROOF_PRODUCED    ,
TGT.CLASS_DELIVERY    ,
TGT.CLASS        ,
TGT.CLASS_QTY    ,
TGT.CLASS_PRT    ,
TGT.DID        ,
TGT.DID_QTY    ,
TGT.DID_PRT    ,
TGT.DSSK        ,
TGT.DSSK_QTY    ,
TGT.DSSK_PRT    ,
TGT.EZP        ,
TGT.EZP_QTY    ,
TGT.EZP_PRT    ,
TGT.SPECIAL_REQUEST    ,
TGT.WORK_ORDER_STATUS    ,
TGT.PROCESSING_COMMENT    ,
TGT.SHIP_GOAL_DATE    ,
TGT.WOMS_NODE             ,
TGT.CHANGE_FLAG    ,
TGT.MANUAL_DEACTIVATED_FLAG  ,
TGT.PENDING_CLASS_PRODUCT,
TGT.MANUALLY_SHIPPED    ,
TGT.ODS_CREATE_DATE  ,
TGT.ODS_MODIFY_DATE  
) VALUES
(
SRC.PLATFORM_DETAIL    ,
SRC.WORK_ORDER_ID    ,
SRC.EVENT_REF_ID    ,
SRC.JOB_TYPE    ,
SRC.LID        ,
SRC.ACCT_NAME    ,
SRC.SHIP_PROPSL_RECEIVED    ,
NULL            ,
SRC.BATCH_ID        ,
SRC.WORK_ORDER_ALIAS_ID    ,
SRC.SUBJECT_COUNT        ,
SRC.WORK_ORDER_FORM_PRT    ,
SRC.RET        ,
SRC.RET_QTY    ,
SRC.RET_PRT    ,
SRC.PKG        ,
SRC.PKG_QTY    ,
SRC.PKG_PRT    ,
SRC.POS        ,
SRC.POS_QTY    ,
SRC.POS_PRT    ,
SRC.DIGITAL_MEDIA               ,
SRC.DIGITAL_MEDIA_QTY      ,
SRC.DIGITAL_MEDIA_PRT      ,
SRC.LAMINATE    ,
SRC.LAMINATE_QTY    ,
SRC.LAMINATE_PRT    ,
SRC.MAGNET    ,
SRC.MAGNET_QTY    ,
SRC.MAGNET_PRT    ,
SRC.METALLIC    ,
SRC.METALLIC_QTY    ,
SRC.METALLIC_PRT    ,
SRC.SPECIALITY    ,
SRC.SPECIALITY_QTY    ,
SRC.SPECIALITY_PRODUCED      ,
SRC.INDIGO_PRODUCT                          ,
SRC.INDIGO_PRODUCT_QTY                 ,
SRC.INDIGO_PRODUCT_PRODUCED      ,
SRC.PROOF_PRODUCT    ,
SRC.PROOF_QTY    ,
SRC.PROOF_PRODUCED    ,
SRC.CLASS_DELIVERY    ,
SRC.CLASS        ,
SRC.CLASS_QTY    ,
SRC.CLASS_PRT    ,
SRC.DID        ,
SRC.DID_QTY    ,
SRC.DID_PRT    ,
SRC.DSSK        ,
SRC.DSSK_QTY    ,
SRC.DSSK_PRT    ,
SRC.EZP        ,
SRC.EZP_QTY    ,
SRC.EZP_PRT    ,
SRC.SPECIAL_REQUEST    ,
SRC.WORK_ORDER_STATUS    ,
SRC.PROCESSING_COMMENT    ,
SRC.SHIP_GOAL_DATE    ,
SRC.WOMS_NODE             ,
'I'        ,
SRC.DEACTIVATED_FLAG ,
NULL                                   ,
NULL                                   ,
SYSDATE        ,
SYSDATE                            
)

&

/*-----------------------------------------------*/
/* TASK No. 119 */
/* Update Mail Received Date at Target */



MERGE INTO ODS_STAGE.X1_WO_UNSHIPPED_HIST_X TGT
USING
(
SELECT 
DISTINCT 
WO.WORK_ORDER_ID,
WO.WOMS_NODE,
WO.LID,
WO.EVENT_REF_ID,
E.PLANT_RECEIPT_DATE,
E.PLANT_NAME 
FROM 
ODS_STAGE.X1_WO_UNSHIPPED_HIST_X WO,
MART.EVENT E
WHERE 
WO.EVENT_REF_ID = E.JOB_NBR
)SRC
 ON (     
      	TGT.WORK_ORDER_ID  	    =   SRC.WORK_ORDER_ID  
      	AND TGT.WOMS_NODE         =   SRC.WOMS_NODE          
      	AND TGT.LID                          =  SRC.LID     
       )          
WHEN MATCHED THEN
 UPDATE 
 SET  
 TGT.MAIL_RECEIVED   =  SRC.PLANT_RECEIPT_DATE

&

/*-----------------------------------------------*/
/* TASK No. 120 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1 */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP1';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 121 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2 */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP2';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 122 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.TEMP_WORKORDER_DETAIL */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.TEMP_WORKORDER_DETAIL';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 123 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.TEMP_WOD_WODEACTIVATED */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.TEMP_WOD_WODEACTIVATED';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 124 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.TEMP_WO_DEACTIVE_BASED_ON_WOL */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.TEMP_WO_DEACTIVE_BASED_ON_WOL';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 125 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_RET */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_RET';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 126 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_PKG */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_PKG';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 127 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_DM_IC */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_DM_IC';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 128 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_DM_IG */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_DM_IG';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 129 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_LAMINATE */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_LAMINATE';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 130 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_MAGNET */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_MAGNET';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 131 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_METALLIC */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_METALLIC';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 132 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_SPECIALITY */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_SPECIALITY';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 133 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_INDIGO_FT */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_INDIGO_FT';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 134 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_INDIGO_NA */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_INDIGO_NA';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 135 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_PROOF */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_PROOF';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 136 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_CLASS */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_CLASS';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 137 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_DID */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_DID';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 138 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_DSSK */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_DSSK';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 139 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_EZP */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_EZP';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 140 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.TEMP_WORK_ORDER_SUBJECT_COUNT CASCADE CONSTRAINTS */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.TEMP_WORK_ORDER_SUBJECT_COUNT CASCADE CONSTRAINTS';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 141 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.TEMP_WO_SUBJ_COUNT_WODEACTIVE CASCADE CONSTRAINTS */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.TEMP_WO_SUBJ_COUNT_WODEACTIVE CASCADE CONSTRAINTS';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 142 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.TEMP_WO_SPECIALREQUEST CASCADE CONSTRAINTS */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.TEMP_WO_SPECIALREQUEST CASCADE CONSTRAINTS';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 143 */
/* Drop Temp Table */

/* DROP TABLE  RAX_APP_USER.TEMP_WO_SESSIONS CASCADE CONSTRAINTS */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE  RAX_APP_USER.TEMP_WO_SESSIONS CASCADE CONSTRAINTS';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 144 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.TEMP_POS CASCADE CONSTRAINTS */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.TEMP_POS CASCADE CONSTRAINTS';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 145 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.X1_WO_PRODUCE_DT_TEMP CASCADE CONSTRAINTS */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.X1_WO_PRODUCE_DT_TEMP CASCADE CONSTRAINTS';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 146 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.ONE_TO_MANY_X1_WO */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.ONE_TO_MANY_X1_WO';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 147 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3 */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.X1_WO_UNSHIPPED_TEMP3';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 148 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_INDIGO */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_INDIGO';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 149 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_DM */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_DM';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 150 */
/* Drop Temp Table */

/* DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_618 */

BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE RAX_APP_USER.UC_PRODUCT_CODE_618';
    EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
    END;
    

&

/*-----------------------------------------------*/
/* TASK No. 151 */
/* Update Target - With Job Number from WOMS */



MERGE INTO ODS_STAGE.X1_WO_UNSHIPPED_HIST TGT
    USING  
    (  
    SELECT 
    J.JOB_NUMBER,J.SORT_ORDER,J.WORK_ORDER_ID,
    J.WOMS_NODE,X1.EVENT_REF_ID
    FROM ODS_STAGE.X1_WO_UNSHIPPED_HIST  X1,
               ODS_STAGE.WOMS_JOB_NUMBER_STG J
    WHERE 1 = 1  
    AND X1.WORK_ORDER_ID = J.WORK_ORDER_ID
    AND X1.WOMS_NODE = J.WOMS_NODE
    AND J.SORT_ORDER = 1  
    AND X1.WORK_ORDER_STATUS NOT IN ('Error')     
    AND X1.WORK_ORDER_ID not in (8910237,
6691164,
6691168,
6691169,
6691170,
6691165,
8910341,
6691167) 

    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
          AND TGT.WOMS_NODE = SRC.WOMS_NODE        
  
         )          
  WHEN MATCHED THEN
    UPDATE 
    SET  
    TGT.EVENT_REF_ID = NVL(SRC.JOB_NUMBER,SRC.EVENT_REF_ID)

&

/*-----------------------------------------------*/
/* TASK No. 152 */
/* Update Target_X - With Job Number from WOMS */



MERGE INTO ODS_STAGE.X1_WO_UNSHIPPED_HIST_X TGT
    USING  
    (  
    SELECT 
    X1.WORK_ORDER_ID,X1.EVENT_REF_ID,X1.WOMS_NODE
    FROM 
    ODS_STAGE.X1_WO_UNSHIPPED_HIST  X1        
    WHERE X1.WORK_ORDER_STATUS NOT IN ('Error')   
    AND X1.WORK_ORDER_ID NOT IN (8910237,
6691164,
6691168,
6691169,
6691170,
6691165,
8910341,
6691167)        
    
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
          AND TGT.WOMS_NODE = SRC.WOMS_NODE          
         )          
  WHEN MATCHED THEN
    UPDATE 
    SET  
    TGT.EVENT_REF_ID = SRC.EVENT_REF_ID

&

/*-----------------------------------------------*/
/* TASK No. 153 */
/* Copy to Shipped WO Hist by Status */



MERGE INTO ODS_STAGE.X1_WO_SHIPPED_HIST TGT
    USING (
	SELECT
	PLATFORM_DETAIL	,
	WORK_ORDER_ID	,
	EVENT_REF_ID	,
	JOB_TYPE		,
	LID		,
	ACCT_NAME		,
	SHIP_PROPSL_RECEIVED	,
 	MAIL_RECEIVED              	,
	BATCH_ID		,
	WORK_ORDER_ALIAS_ID	,
	SUBJECT_COUNT	,
	WORK_ORDER_FORM_PRT,
	RET		,
	RET_QTY		,
	RET_PRT		,
	PKG		,
	PKG_QTY		,
	PKG_PRT		,
	POS		,
	POS_QTY		,
	POS_PRT		,
	DIGITAL_MEDIA1                  ,
	DIGITAL_MEDIA1_QTY          ,
	DIGITAL_MEDIA1_PRT          ,
	DIGITAL_MEDIA2                  ,
	DIGITAL_MEDIA2_QTY          ,
	DIGITAL_MEDIA2_PRT          ,
	LAMINATE		,
	LAMINATE_QTY	,
	LAMINATE_PRT	,
	MAGNET		,
	MAGNET_QTY	,
	MAGNET_PRT	,
	METALLIC		,
	METALLIC_QTY	,
	METALLIC_PRT	,
	SPECIALITY		,
	SPECIALITY_QTY	,
	SPECIALITY_PRODUCED	,
	INDIGO_PRODUCT1                          ,
	INDIGO_PRODUCT1_QTY                 ,
	INDIGO_PRODUCT1_PRODUCED      ,
	INDIGO_PRODUCT2                          ,
	INDIGO_PRODUCT2_QTY                 ,
	INDIGO_PRODUCT2_PRODUCED      ,
	PROOF_PRODUCT	,
	PROOF_QTY		,
	PROOF_PRODUCED	,
	CLASS_DELIVERY	,
	CLASS		,
	CLASS_QTY	,
	CLASS_PRT	,
	DID	,
	DID_QTY	,
	DID_PRT	,
	DSSK	,
	DSSK_QTY	,
	DSSK_PRT	,
	EZP	,
	EZP_QTY	,
	EZP_PRT	,
	SPECIAL_REQUEST	,
	WORK_ORDER_STATUS	,
	PROCESSING_COMMENT	,
	SHIP_GOAL_DATE	,
	WOMS_NODE                    ,
	MANUAL_DEACTIVATED_FLAG         
                     FROM ODS_STAGE.X1_WO_UNSHIPPED_HIST 
                     WHERE WORK_ORDER_STATUS IN ('Shipped Acknowledged')
               )SRC
    ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
           AND TGT.WOMS_NODE = SRC.WOMS_NODE
           AND TGT.LID = SRC.LID
           )
  WHEN MATCHED THEN
    UPDATE 
    SET 
TGT.PLATFORM_DETAIL		=	SRC.PLATFORM_DETAIL	,
TGT.EVENT_REF_ID		=	SRC.EVENT_REF_ID	,
TGT.JOB_TYPE		=	SRC.JOB_TYPE	,
TGT.ACCT_NAME		=	SRC.ACCT_NAME		,
TGT.SHIP_PROPSL_RECEIVED	=	SRC.SHIP_PROPSL_RECEIVED	,
TGT.MAIL_RECEIVED              	=	SRC.MAIL_RECEIVED              	,
TGT.BATCH_ID		=	SRC.BATCH_ID		,
TGT.WORK_ORDER_ALIAS_ID	=	SRC.WORK_ORDER_ALIAS_ID	,
TGT.SUBJECT_COUNT		=	SRC.SUBJECT_COUNT	,
TGT.WORK_ORDER_FORM_PRT	=	SRC.WORK_ORDER_FORM_PRT	,
TGT.RET			=	SRC.RET	,
TGT.RET_QTY		=	SRC.RET_QTY	,
TGT.RET_PRT		=	SRC.RET_PRT	,
TGT.PKG			=	SRC.PKG	,
TGT.PKG_QTY		=	SRC.PKG_QTY	,
TGT.PKG_PRT		=	SRC.PKG_PRT	,
TGT.POS			=	SRC.POS	,
TGT.POS_QTY		=	SRC.POS_QTY	,
TGT.POS_PRT		=	SRC.POS_PRT	,
TGT.DIGITAL_MEDIA1          	=  	SRC.DIGITAL_MEDIA1          	,
TGT.DIGITAL_MEDIA1_QTY      	=  	SRC.DIGITAL_MEDIA1_QTY      	,
TGT.DIGITAL_MEDIA1_PRT      	=  	SRC.DIGITAL_MEDIA1_PRT      	,
TGT.DIGITAL_MEDIA2          	=  	SRC.DIGITAL_MEDIA2          	,
TGT.DIGITAL_MEDIA2_QTY      	=  	SRC.DIGITAL_MEDIA2_QTY      	,
TGT.DIGITAL_MEDIA2_PRT      	=  	SRC.DIGITAL_MEDIA2_PRT      	,
TGT.LAMINATE		=	SRC.LAMINATE		,
TGT.LAMINATE_QTY		=	SRC.LAMINATE_QTY		,
TGT.LAMINATE_PRT		=	SRC.LAMINATE_PRT		,
TGT.MAGNET		=	SRC.MAGNET		,
TGT.MAGNET_QTY		=	SRC.MAGNET_QTY	                     ,
TGT.MAGNET_PRT		=	SRC.MAGNET_PRT	                     ,
TGT.METALLIC		=	SRC.METALLIC		,
TGT.METALLIC_QTY		=	SRC.METALLIC_QTY	                     ,
TGT.METALLIC_PRT		=	SRC.METALLIC_PRT	                     ,
TGT.SPECIALITY		=	SRC.SPECIALITY		,
TGT.SPECIALITY_QTY		=	SRC.SPECIALITY_QTY	                     ,
TGT.SPECIALITY_PRODUCED	=	SRC.SPECIALITY_PRODUCED	,
TGT.INDIGO_PRODUCT1                        =                  SRC.INDIGO_PRODUCT1                        ,
TGT.INDIGO_PRODUCT1_QTY               =                  TGT.INDIGO_PRODUCT1_QTY                ,
TGT.INDIGO_PRODUCT1_PRODUCED    =                  TGT.INDIGO_PRODUCT1_PRODUCED    ,
TGT.INDIGO_PRODUCT2                        =                  TGT.INDIGO_PRODUCT2                         ,
TGT.INDIGO_PRODUCT2_QTY               =                   TGT.INDIGO_PRODUCT2_QTY                ,
TGT.INDIGO_PRODUCT2_PRODUCED   =                   TGT.INDIGO_PRODUCT2_PRODUCED     ,
TGT.PROOF_PRODUCT		=	SRC.PROOF_PRODUCT	                      ,
TGT.PROOF_QTY		=	SRC.PROOF_QTY		 ,
TGT.PROOF_PRODUCED		=	SRC.PROOF_PRODUCED	                      ,
TGT.CLASS_DELIVERY		=	SRC.CLASS_DELIVERY	,
TGT.CLASS			=	SRC.CLASS	                     ,
TGT.CLASS_QTY		=	SRC.CLASS_QTY	,
TGT.CLASS_PRT		=	SRC.CLASS_PRT	,
TGT.DID			=	SRC.DID	                     ,
TGT.DID_QTY		=	SRC.DID_QTY	,
TGT.DID_PRT		=	SRC.DID_PRT	,
TGT.DSSK			=	SRC.DSSK	                     ,
TGT.DSSK_QTY		=	SRC.DSSK_QTY	,
TGT.DSSK_PRT		=	SRC.DSSK_PRT		,
TGT.EZP			=	SRC.EZP	                     		,
TGT.EZP_QTY		=	SRC.EZP_QTY		,
TGT.EZP_PRT		=	SRC.EZP_PRT		,
TGT.SPECIAL_REQUEST		=	SRC.SPECIAL_REQUEST		,
TGT.WORK_ORDER_STATUS	=	SRC.WORK_ORDER_STATUS	,
TGT.PROCESSING_COMMENT	=	SRC.PROCESSING_COMMENT	,
TGT.SHIP_GOAL_DATE		=	SRC.SHIP_GOAL_DATE		,
TGT.CHANGE_FLAG           	=    	'U'			,
TGT.MANUAL_DEACTIVATED_FLAG       =                   SRC.MANUAL_DEACTIVATED_FLAG 	,
TGT.PENDING_CLASS_PRODUCT           =                   NULL                                   	,
TGT.MANUALLY_SHIPPED	                     =                   NULL                                  		 ,
TGT.ODS_MODIFY_DATE  		=    	SYSDATE                            

  WHEN NOT MATCHED THEN
INSERT
(
TGT.PLATFORM_DETAIL	,
TGT.WORK_ORDER_ID	,
TGT.EVENT_REF_ID	,
TGT.JOB_TYPE	,
TGT.LID		,
TGT.ACCT_NAME	,
TGT.SHIP_PROPSL_RECEIVED	,
TGT.MAIL_RECEIVED              	,
TGT.BATCH_ID		,
TGT.WORK_ORDER_ALIAS_ID	,
TGT.SUBJECT_COUNT		,
TGT.WORK_ORDER_FORM_PRT	,
TGT.RET		,
TGT.RET_QTY	,
TGT.RET_PRT	,
TGT.PKG		,
TGT.PKG_QTY	,
TGT.PKG_PRT	,
TGT.POS		,
TGT.POS_QTY	,
TGT.POS_PRT	,
TGT.DIGITAL_MEDIA1          ,
TGT.DIGITAL_MEDIA1_QTY      ,
TGT.DIGITAL_MEDIA1_PRT      ,
TGT.DIGITAL_MEDIA2              ,
TGT.DIGITAL_MEDIA2_QTY      ,
TGT.DIGITAL_MEDIA2_PRT      ,
TGT.LAMINATE	,
TGT.LAMINATE_QTY	,
TGT.LAMINATE_PRT	,
TGT.MAGNET	,
TGT.MAGNET_QTY	,
TGT.MAGNET_PRT	,
TGT.METALLIC	,
TGT.METALLIC_QTY	,
TGT.METALLIC_PRT	,
TGT.SPECIALITY	,
TGT.SPECIALITY_QTY	,
TGT.SPECIALITY_PRODUCED ,
TGT.INDIGO_PRODUCT1                          ,
TGT.INDIGO_PRODUCT1_QTY                  ,
TGT.INDIGO_PRODUCT1_PRODUCED      ,
TGT.INDIGO_PRODUCT2                          ,
TGT.INDIGO_PRODUCT2_QTY                  ,
TGT.INDIGO_PRODUCT2_PRODUCED      ,
TGT.PROOF_PRODUCT	,
TGT.PROOF_QTY	,
TGT.PROOF_PRODUCED	,
TGT.CLASS_DELIVERY	,
TGT.CLASS		,
TGT.CLASS_QTY	,
TGT.CLASS_PRT	,
TGT.DID		,
TGT.DID_QTY	,
TGT.DID_PRT	,
TGT.DSSK			,
TGT.DSSK_QTY		,
TGT.DSSK_PRT		,
TGT.EZP			,
TGT.EZP_QTY		,
TGT.EZP_PRT		,
TGT.SPECIAL_REQUEST		,
TGT.WORK_ORDER_STATUS	,
TGT.PROCESSING_COMMENT	,
TGT.SHIP_GOAL_DATE		,
TGT.WOMS_NODE             	,
TGT.CHANGE_FLAG		,
TGT.MANUAL_DEACTIVATED_FLAG  	,
TGT.PENDING_CLASS_PRODUCT	,
TGT.MANUALLY_SHIPPED		,
TGT.ODS_CREATE_DATE  		,
TGT.ODS_MODIFY_DATE  
) VALUES
(
SRC.PLATFORM_DETAIL		,
SRC.WORK_ORDER_ID		,
SRC.EVENT_REF_ID		,
SRC.JOB_TYPE		,
SRC.LID			,
SRC.ACCT_NAME		,
SRC.SHIP_PROPSL_RECEIVED	,
SRC.MAIL_RECEIVED              	,
SRC.BATCH_ID		,
SRC.WORK_ORDER_ALIAS_ID	,
SRC.SUBJECT_COUNT		,
SRC.WORK_ORDER_FORM_PRT	,
SRC.RET			,
SRC.RET_QTY		,
SRC.RET_PRT		,
SRC.PKG			,
SRC.PKG_QTY		,
SRC.PKG_PRT		,
SRC.POS			,
SRC.POS_QTY		,
SRC.POS_PRT		,
SRC.DIGITAL_MEDIA1          	,
SRC.DIGITAL_MEDIA1_QTY      	,
SRC.DIGITAL_MEDIA1_PRT      	,
SRC.DIGITAL_MEDIA2          	,
SRC.DIGITAL_MEDIA2_QTY      	,
SRC.DIGITAL_MEDIA2_PRT      	,
SRC.LAMINATE		,
SRC.LAMINATE_QTY		,
SRC.LAMINATE_PRT		,
SRC.MAGNET		,
SRC.MAGNET_QTY		,
SRC.MAGNET_PRT		,
SRC.METALLIC		,
SRC.METALLIC_QTY		,
SRC.METALLIC_PRT		,
SRC.SPECIALITY		,
SRC.SPECIALITY_QTY		,
SRC.SPECIALITY_PRODUCED	 ,
SRC.INDIGO_PRODUCT1                         ,
SRC.INDIGO_PRODUCT1_QTY                ,
SRC.INDIGO_PRODUCT1_PRODUCED    ,
SRC.INDIGO_PRODUCT2                        ,
SRC.INDIGO_PRODUCT2_QTY               ,
SRC.INDIGO_PRODUCT2_PRODUCED   ,
SRC.PROOF_PRODUCT		,
SRC.PROOF_QTY		,
SRC.PROOF_PRODUCED		,
SRC.CLASS_DELIVERY		,
SRC.CLASS			,
SRC.CLASS_QTY		,
SRC.CLASS_PRT		,
SRC.DID			,
SRC.DID_QTY		,
SRC.DID_PRT		,
SRC.DSSK			,
SRC.DSSK_QTY		,
SRC.DSSK_PRT		,
SRC.EZP			,
SRC.EZP_QTY		,
SRC.EZP_PRT		,
SRC.SPECIAL_REQUEST		,
SRC.WORK_ORDER_STATUS	,
SRC.PROCESSING_COMMENT	,
SRC.SHIP_GOAL_DATE		,
SRC.WOMS_NODE             	,
'I'			,
SRC.MANUAL_DEACTIVATED_FLAG 	,
NULL                                   	,
NULL                                   	,
SYSDATE			,
SYSDATE                            
)

&

/*-----------------------------------------------*/
/* TASK No. 154 */
/* Copy to Shipped WO Hist by Flag */



MERGE INTO ODS_STAGE.X1_WO_SHIPPED_HIST TGT
    USING (
	SELECT
	PLATFORM_DETAIL	,
	WORK_ORDER_ID	,
	EVENT_REF_ID	,
	JOB_TYPE		,
	LID		,
	ACCT_NAME		,
	SHIP_PROPSL_RECEIVED	,
	MAIL_RECEIVED                ,
	BATCH_ID		,
	WORK_ORDER_ALIAS_ID	,
	SUBJECT_COUNT	,
	WORK_ORDER_FORM_PRT,
	RET		,
	RET_QTY		,
	RET_PRT		,
	PKG		,
	PKG_QTY		,
	PKG_PRT		,
	POS		,
	POS_QTY		,
	POS_PRT		,
	DIGITAL_MEDIA1                  ,
	DIGITAL_MEDIA1_QTY          ,
	DIGITAL_MEDIA1_PRT          ,
	DIGITAL_MEDIA2                  ,
	DIGITAL_MEDIA2_QTY          ,
	DIGITAL_MEDIA2_PRT          ,
	LAMINATE		,
	LAMINATE_QTY	,
	LAMINATE_PRT	,
	MAGNET		,
	MAGNET_QTY	,
	MAGNET_PRT	,
	METALLIC		,
	METALLIC_QTY	,
	METALLIC_PRT	,
	SPECIALITY		,
	SPECIALITY_QTY	,
	SPECIALITY_PRODUCED	,
	INDIGO_PRODUCT1                          ,
	INDIGO_PRODUCT1_QTY                 ,
	INDIGO_PRODUCT1_PRODUCED      ,
	INDIGO_PRODUCT2                          ,
	INDIGO_PRODUCT2_QTY                 ,
	INDIGO_PRODUCT2_PRODUCED      ,
	PROOF_PRODUCT	,
	PROOF_QTY		,
	PROOF_PRODUCED	,
	CLASS_DELIVERY	,
	CLASS		,
	CLASS_QTY	,
	CLASS_PRT	,
	DID	,
	DID_QTY	,
	DID_PRT	,
	DSSK	,
	DSSK_QTY	,
	DSSK_PRT	,
	EZP	,
	EZP_QTY	,
	EZP_PRT	,
	SPECIAL_REQUEST	,
	WORK_ORDER_STATUS	,
	PROCESSING_COMMENT	,
	SHIP_GOAL_DATE	,
	WOMS_NODE                    ,
	MANUAL_DEACTIVATED_FLAG    ,
	PENDING_CLASS_PRODUCT        ,
	MANUALLY_SHIPPED       
                     FROM ODS_STAGE.X1_WO_UNSHIPPED_HIST 
                     WHERE MANUALLY_SHIPPED = 'Y'
               )SRC
    ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID 
           AND TGT.WOMS_NODE = SRC.WOMS_NODE
           AND TGT.LID = SRC.LID
           )
  WHEN MATCHED THEN
    UPDATE 
    SET 
TGT.PLATFORM_DETAIL		=	SRC.PLATFORM_DETAIL	,
TGT.EVENT_REF_ID		=	SRC.EVENT_REF_ID	,
TGT.JOB_TYPE		=	SRC.JOB_TYPE	,
TGT.ACCT_NAME		=	SRC.ACCT_NAME		,
TGT.SHIP_PROPSL_RECEIVED	=	SRC.SHIP_PROPSL_RECEIVED	,
TGT.MAIL_RECEIVED              	=	SRC.MAIL_RECEIVED              	,
TGT.BATCH_ID		=	SRC.BATCH_ID		,
TGT.WORK_ORDER_ALIAS_ID	=	SRC.WORK_ORDER_ALIAS_ID	,
TGT.SUBJECT_COUNT		=	SRC.SUBJECT_COUNT	,
TGT.WORK_ORDER_FORM_PRT	=	SRC.WORK_ORDER_FORM_PRT	,
TGT.RET			=	SRC.RET	,
TGT.RET_QTY		=	SRC.RET_QTY	,
TGT.RET_PRT		=	SRC.RET_PRT	,
TGT.PKG			=	SRC.PKG	,
TGT.PKG_QTY		=	SRC.PKG_QTY	,
TGT.PKG_PRT		=	SRC.PKG_PRT	,
TGT.POS			=	SRC.POS	,
TGT.POS_QTY		=	SRC.POS_QTY	,
TGT.POS_PRT		=	SRC.POS_PRT	,
TGT.DIGITAL_MEDIA1          	=  	SRC.DIGITAL_MEDIA1          	,
TGT.DIGITAL_MEDIA1_QTY      	=  	SRC.DIGITAL_MEDIA1_QTY      	,
TGT.DIGITAL_MEDIA1_PRT      	=  	SRC.DIGITAL_MEDIA1_PRT      	,
TGT.DIGITAL_MEDIA2          	=  	SRC.DIGITAL_MEDIA2          	,
TGT.DIGITAL_MEDIA2_QTY      	=  	SRC.DIGITAL_MEDIA2_QTY      	,
TGT.DIGITAL_MEDIA2_PRT      	=  	SRC.DIGITAL_MEDIA2_PRT      	,
TGT.LAMINATE		=	SRC.LAMINATE		,
TGT.LAMINATE_QTY		=	SRC.LAMINATE_QTY		,
TGT.LAMINATE_PRT		=	SRC.LAMINATE_PRT		,
TGT.MAGNET		=	SRC.MAGNET		,
TGT.MAGNET_QTY		=	SRC.MAGNET_QTY	                     ,
TGT.MAGNET_PRT		=	SRC.MAGNET_PRT	                     ,
TGT.METALLIC		=	SRC.METALLIC		,
TGT.METALLIC_QTY		=	SRC.METALLIC_QTY	                     ,
TGT.METALLIC_PRT		=	SRC.METALLIC_PRT	                     ,
TGT.SPECIALITY		=	SRC.SPECIALITY		,
TGT.SPECIALITY_QTY		=	SRC.SPECIALITY_QTY	                     ,
TGT.SPECIALITY_PRODUCED	=	SRC.SPECIALITY_PRODUCED	,
TGT.INDIGO_PRODUCT1                        =                  SRC.INDIGO_PRODUCT1                        ,
TGT.INDIGO_PRODUCT1_QTY               =                  TGT.INDIGO_PRODUCT1_QTY                ,
TGT.INDIGO_PRODUCT1_PRODUCED    =                  TGT.INDIGO_PRODUCT1_PRODUCED    ,
TGT.INDIGO_PRODUCT2                        =                  TGT.INDIGO_PRODUCT2                         ,
TGT.INDIGO_PRODUCT2_QTY               =                   TGT.INDIGO_PRODUCT2_QTY                ,
TGT.INDIGO_PRODUCT2_PRODUCED   =                   TGT.INDIGO_PRODUCT2_PRODUCED     ,
TGT.PROOF_PRODUCT		=	SRC.PROOF_PRODUCT	                      ,
TGT.PROOF_QTY		=	SRC.PROOF_QTY		 ,
TGT.PROOF_PRODUCED		=	SRC.PROOF_PRODUCED	                      ,
TGT.CLASS_DELIVERY		=	SRC.CLASS_DELIVERY	,
TGT.CLASS			=	SRC.CLASS	                     ,
TGT.CLASS_QTY		=	SRC.CLASS_QTY	,
TGT.CLASS_PRT		=	SRC.CLASS_PRT	,
TGT.DID			=	SRC.DID	                     ,
TGT.DID_QTY		=	SRC.DID_QTY	,
TGT.DID_PRT		=	SRC.DID_PRT	,
TGT.DSSK			=	SRC.DSSK	                     ,
TGT.DSSK_QTY		=	SRC.DSSK_QTY	,
TGT.DSSK_PRT		=	SRC.DSSK_PRT		,
TGT.EZP			=	SRC.EZP	                     		,
TGT.EZP_QTY		=	SRC.EZP_QTY		,
TGT.EZP_PRT		=	SRC.EZP_PRT		,
TGT.SPECIAL_REQUEST		=	SRC.SPECIAL_REQUEST		,
TGT.WORK_ORDER_STATUS	=	SRC.WORK_ORDER_STATUS	,
TGT.PROCESSING_COMMENT	=	SRC.PROCESSING_COMMENT	,
TGT.SHIP_GOAL_DATE		=	SRC.SHIP_GOAL_DATE		,
TGT.CHANGE_FLAG           	=    	'U'			,
TGT.MANUAL_DEACTIVATED_FLAG       =                   SRC.MANUAL_DEACTIVATED_FLAG 	,
TGT.PENDING_CLASS_PRODUCT           =                   SRC.PENDING_CLASS_PRODUCT           ,
TGT.MANUALLY_SHIPPED	                     =                   SRC.MANUALLY_SHIPPED                      ,              
TGT.ODS_MODIFY_DATE  		=    	SYSDATE                            

  WHEN NOT MATCHED THEN
INSERT
(
TGT.PLATFORM_DETAIL	,
TGT.WORK_ORDER_ID	,
TGT.EVENT_REF_ID	,
TGT.JOB_TYPE	,
TGT.LID		,
TGT.ACCT_NAME	,
TGT.SHIP_PROPSL_RECEIVED	,
TGT.MAIL_RECEIVED              	,
TGT.BATCH_ID		,
TGT.WORK_ORDER_ALIAS_ID	,
TGT.SUBJECT_COUNT		,
TGT.WORK_ORDER_FORM_PRT	,
TGT.RET		,
TGT.RET_QTY	,
TGT.RET_PRT	,
TGT.PKG		,
TGT.PKG_QTY	,
TGT.PKG_PRT	,
TGT.POS		,
TGT.POS_QTY	,
TGT.POS_PRT	,
TGT.DIGITAL_MEDIA1          ,
TGT.DIGITAL_MEDIA1_QTY      ,
TGT.DIGITAL_MEDIA1_PRT      ,
TGT.DIGITAL_MEDIA2              ,
TGT.DIGITAL_MEDIA2_QTY      ,
TGT.DIGITAL_MEDIA2_PRT      ,
TGT.LAMINATE	,
TGT.LAMINATE_QTY	,
TGT.LAMINATE_PRT	,
TGT.MAGNET	,
TGT.MAGNET_QTY	,
TGT.MAGNET_PRT	,
TGT.METALLIC	,
TGT.METALLIC_QTY	,
TGT.METALLIC_PRT	,
TGT.SPECIALITY	,
TGT.SPECIALITY_QTY	,
TGT.SPECIALITY_PRODUCED ,
TGT.INDIGO_PRODUCT1                          ,
TGT.INDIGO_PRODUCT1_QTY                  ,
TGT.INDIGO_PRODUCT1_PRODUCED      ,
TGT.INDIGO_PRODUCT2                          ,
TGT.INDIGO_PRODUCT2_QTY                  ,
TGT.INDIGO_PRODUCT2_PRODUCED      ,
TGT.PROOF_PRODUCT	,
TGT.PROOF_QTY	,
TGT.PROOF_PRODUCED	,
TGT.CLASS_DELIVERY	,
TGT.CLASS		,
TGT.CLASS_QTY	,
TGT.CLASS_PRT	,
TGT.DID		,
TGT.DID_QTY	,
TGT.DID_PRT	,
TGT.DSSK			,
TGT.DSSK_QTY		,
TGT.DSSK_PRT		,
TGT.EZP			,
TGT.EZP_QTY		,
TGT.EZP_PRT		,
TGT.SPECIAL_REQUEST		,
TGT.WORK_ORDER_STATUS	,
TGT.PROCESSING_COMMENT	,
TGT.SHIP_GOAL_DATE		,
TGT.WOMS_NODE             	,
TGT.CHANGE_FLAG		,
TGT.MANUAL_DEACTIVATED_FLAG  	,
TGT.PENDING_CLASS_PRODUCT	,
TGT.MANUALLY_SHIPPED		,
TGT.ODS_CREATE_DATE  		,
TGT.ODS_MODIFY_DATE  
) VALUES
(
SRC.PLATFORM_DETAIL		,
SRC.WORK_ORDER_ID		,
SRC.EVENT_REF_ID		,
SRC.JOB_TYPE		,
SRC.LID			,
SRC.ACCT_NAME		,
SRC.SHIP_PROPSL_RECEIVED	,
SRC.MAIL_RECEIVED              	,
SRC.BATCH_ID		,
SRC.WORK_ORDER_ALIAS_ID	,
SRC.SUBJECT_COUNT		,
SRC.WORK_ORDER_FORM_PRT	,
SRC.RET			,
SRC.RET_QTY		,
SRC.RET_PRT		,
SRC.PKG			,
SRC.PKG_QTY		,
SRC.PKG_PRT		,
SRC.POS			,
SRC.POS_QTY		,
SRC.POS_PRT		,
SRC.DIGITAL_MEDIA1          	,
SRC.DIGITAL_MEDIA1_QTY      	,
SRC.DIGITAL_MEDIA1_PRT      	,
SRC.DIGITAL_MEDIA2          	,
SRC.DIGITAL_MEDIA2_QTY      	,
SRC.DIGITAL_MEDIA2_PRT      	,
SRC.LAMINATE		,
SRC.LAMINATE_QTY		,
SRC.LAMINATE_PRT		,
SRC.MAGNET		,
SRC.MAGNET_QTY		,
SRC.MAGNET_PRT		,
SRC.METALLIC		,
SRC.METALLIC_QTY		,
SRC.METALLIC_PRT		,
SRC.SPECIALITY		,
SRC.SPECIALITY_QTY		,
SRC.SPECIALITY_PRODUCED	 ,
SRC.INDIGO_PRODUCT1                         ,
SRC.INDIGO_PRODUCT1_QTY                ,
SRC.INDIGO_PRODUCT1_PRODUCED    ,
SRC.INDIGO_PRODUCT2                        ,
SRC.INDIGO_PRODUCT2_QTY               ,
SRC.INDIGO_PRODUCT2_PRODUCED   ,
SRC.PROOF_PRODUCT		,
SRC.PROOF_QTY		,
SRC.PROOF_PRODUCED		,
SRC.CLASS_DELIVERY		,
SRC.CLASS			,
SRC.CLASS_QTY		,
SRC.CLASS_PRT		,
SRC.DID			,
SRC.DID_QTY		,
SRC.DID_PRT		,
SRC.DSSK			,
SRC.DSSK_QTY		,
SRC.DSSK_PRT		,
SRC.EZP			,
SRC.EZP_QTY		,
SRC.EZP_PRT		,
SRC.SPECIAL_REQUEST		,
SRC.WORK_ORDER_STATUS	,
SRC.PROCESSING_COMMENT	,
SRC.SHIP_GOAL_DATE		,
SRC.WOMS_NODE             	,
'I'			,
SRC.MANUAL_DEACTIVATED_FLAG 	,
SRC.PENDING_CLASS_PRODUCT           ,
SRC.MANUALLY_SHIPPED                       ,
SYSDATE			,
SYSDATE                            
)

&

/*-----------------------------------------------*/
/* TASK No. 155 */
/* Mark Manually Shipped WO in X1_WO_UNSHIPPED_HIST_X */



MERGE INTO ODS_STAGE.X1_WO_UNSHIPPED_HIST_X TGT
USING  
    (  
    SELECT         
    WORK_ORDER_ID,
    WOMS_NODE,
    LID,    
    MANUALLY_SHIPPED
    FROM 
    ODS_STAGE.X1_WO_UNSHIPPED_HIST     
    WHERE MANUALLY_SHIPPED IS NOT NULL
    )SRC
      ON (TGT.WORK_ORDER_ID = SRC.WORK_ORDER_ID     
          AND TGT.WOMS_NODE = SRC.WOMS_NODE
          AND TGT.LID = SRC.LID              
         )        
  WHEN MATCHED THEN
    UPDATE 
     SET  
        TGT.MANUALLY_SHIPPED = SRC.MANUALLY_SHIPPED

&

/*-----------------------------------------------*/
/* TASK No. 156 */
/* Delete from Unshipped WO Hist */



--Delete Shipped WO from Unshipped Hist Table
DELETE FROM ODS_STAGE.X1_WO_UNSHIPPED_HIST 
WHERE 1 = 1
AND  (WORK_ORDER_STATUS IN ('Shipped Acknowledged')  OR MANUALLY_SHIPPED = 'Y')
AND  (WORK_ORDER_ID,LID,WOMS_NODE) IN (SELECT 
                                                                              WORK_ORDER_ID,LID,WOMS_NODE 
                                                                              FROM ODS_STAGE.X1_WO_SHIPPED_HIST)

&

/*-----------------------------------------------*/
/* TASK No. 157 */
/* Delete from Unshipped Hist X Table */



--Delete Shipped WO from Unshipped Hist X Table
DELETE FROM ODS_STAGE.X1_WO_UNSHIPPED_HIST_X
WHERE 1 = 1
AND  (WORK_ORDER_STATUS IN ('Shipped Acknowledged')  OR MANUALLY_SHIPPED = 'Y')
AND  (WORK_ORDER_ID,LID,WOMS_NODE) IN (SELECT 
                                                                              WORK_ORDER_ID,LID,WOMS_NODE 
                                                                              FROM ODS_STAGE.X1_WO_SHIPPED_HIST)

&
