CREATE TABLE RAX_APP_USER.subject_activity_stage
    (	"SUBJECT_APO_OID" NUMBER NOT NULL ENABLE, 
	"ACCOUNT_ID" NUMBER NOT NULL ENABLE, 
	"SUBJECT_ID" NUMBER NOT NULL ENABLE, 
	"APO_ID" NUMBER NOT NULL ENABLE, 
	"MARKETING_ID" NUMBER NOT NULL ENABLE, 
	"JOB_TICKET_ORG_ID" NUMBER NOT NULL ENABLE, 
	"ASSIGNMENT_ID" NUMBER NOT NULL ENABLE, 
	"ASSIGNMENT_EFFECTIVE_DATE" DATE NOT NULL ENABLE, 
	"TRANS_DATE" DATE NOT NULL ENABLE, 
	"PHOTOGRAPHY_DATE" DATE NOT NULL ENABLE, 
	"PIPELINE_STATUS_ID" NUMBER NOT NULL ENABLE, 
	"YEARBOOK_STATUS_NAME" VARCHAR2(20) NOT NULL ENABLE, 
	"SUBJECT_JUNK_ID" NUMBER NOT NULL ENABLE, 
	"SUBJECT_ACTIVITY_JUNK_ID" NUMBER NOT NULL ENABLE, 
	"ORDER_DATE" DATE NOT NULL ENABLE, 
	"SECOND_PHOTOGRAPHY_DATE" DATE NOT NULL ENABLE, 
	"SECOND_ORDER_DATE" DATE NOT NULL ENABLE, 
	"IMAGE_QTY" NUMBER NOT NULL ENABLE, 
	"ORDERED_IMAGE_QTY" NUMBER NOT NULL ENABLE, 
	"OCCURS" NUMBER NOT NULL ENABLE, 
	"RECIPE_QTY" NUMBER NOT NULL ENABLE, 
	"ORDERED_RECIPE_QTY" NUMBER NOT NULL ENABLE, 
	"PRICE_AMOUNT" NUMBER, 
	"PAID_ORDER_QTY" NUMBER
   )

   CREATE TABLE RAX_APP_USER.subject_activity_stage2
  (	"SUBJECT_ACTIVITY_CURR_ID" NUMBER NOT NULL ENABLE, 
	"SUBJECT_APO_OID" NUMBER NOT NULL ENABLE, 
	"RECORD_STATUS" VARCHAR2(10) NOT NULL ENABLE, 
	"ACCOUNT_ID" NUMBER NOT NULL ENABLE, 
	"SUBJECT_ID" NUMBER NOT NULL ENABLE, 
	"APO_ID" NUMBER NOT NULL ENABLE, 
	"MARKETING_ID" NUMBER NOT NULL ENABLE, 
	"JOB_TICKET_ORG_ID" NUMBER NOT NULL ENABLE, 
	"ASSIGNMENT_ID" NUMBER NOT NULL ENABLE, 
	"ASSIGNMENT_EFFECTIVE_DATE" DATE NOT NULL ENABLE, 
	"TRANS_DATE" DATE NOT NULL ENABLE, 
	"PHOTOGRAPHY_DATE" DATE NOT NULL ENABLE, 
	"PIPELINE_STATUS_ID" NUMBER NOT NULL ENABLE, 
	"YEARBOOK_STATUS_NAME" VARCHAR2(20) NOT NULL ENABLE, 
	"SUBJECT_JUNK_ID" NUMBER NOT NULL ENABLE, 
	"SUBJECT_ACTIVITY_JUNK_ID" NUMBER NOT NULL ENABLE, 
	"ORDER_DATE" DATE NOT NULL ENABLE, 
	"SECOND_PHOTOGRAPHY_DATE" DATE NOT NULL ENABLE, 
	"SECOND_ORDER_DATE" DATE NOT NULL ENABLE, 
	"IMAGE_QTY" NUMBER NOT NULL ENABLE, 
	"ORDERED_IMAGE_QTY" NUMBER NOT NULL ENABLE, 
	"OCCURS" NUMBER NOT NULL ENABLE, 
	"RECIPE_QTY" NUMBER NOT NULL ENABLE, 
	"ORDERED_RECIPE_QTY" NUMBER NOT NULL ENABLE, 
	"PRICE_AMOUNT" NUMBER, 
	"PAID_ORDER_QTY" NUMBER
   )