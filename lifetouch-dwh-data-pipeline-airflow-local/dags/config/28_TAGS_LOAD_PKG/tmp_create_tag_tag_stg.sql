
/*-----------------------------------------------*/
/* TASK No. 22 */
/* Drop work table */

-- drop table RAX_APP_USER.C$_0TAG_TAG_STG 

-- &


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Create work table */

-- create table RAX_APP_USER.C$_0TAG_TAG_STG
-- (
-- 	C1_ID	NUMBER(19) NULL,
-- 	C2_GROUP_ID	NUMBER(19) NULL,
-- 	C3_NAME	VARCHAR2(255) NULL,
-- 	C4_SEQUENCE	NUMBER(10) NULL,
-- 	C5_ACTIVE_FLAG	NUMBER(1) NULL,
-- 	C6_CREATED_BY	VARCHAR2(255) NULL,
-- 	C7_UPDATED_BY	VARCHAR2(255) NULL,
-- 	C8_DATE_CREATED	TIMESTAMP(6) NULL,
-- 	C9_LAST_UPDATED	TIMESTAMP(6) NULL
-- )
-- NOLOGGING

-- &


DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0TAG_TAG_STG';  
      EXCEPTION  
         WHEN OTHERS THEN NULL;  
      END;  
      create_query := 'create table RAX_APP_USER.C$_0TAG_TAG_STG
(
	C1_ID	NUMBER(19) NULL,
	C2_GROUP_ID	NUMBER(19) NULL,
	C3_NAME	VARCHAR2(255) NULL,
	C4_SEQUENCE	NUMBER(10) NULL,
	C5_ACTIVE_FLAG	NUMBER(1) NULL,
	C6_CREATED_BY	VARCHAR2(255) NULL,
	C7_UPDATED_BY	VARCHAR2(255) NULL,
	C8_DATE_CREATED	TIMESTAMP(6) NULL,
	C9_LAST_UPDATED	TIMESTAMP(6) NULL
)';  
      EXECUTE IMMEDIATE create_query;  
   END;  