
/*-----------------------------------------------*/
/* TASK No. 4 */
/* Drop work table */

-- drop table RAX_APP_USER.C$_0TAG_GROUP_STG 

-- &


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Create work table */

-- create table RAX_APP_USER.C$_0TAG_GROUP_STG
-- (
-- 	C1_ID	NUMBER(19) NULL,
-- 	C2_NAME	VARCHAR2(255) NULL,
-- 	C3_ACTIVE_FLAG	NUMBER(1) NULL,
-- 	C4_CREATED_BY	VARCHAR2(255) NULL,
-- 	C5_UPDATED_BY	VARCHAR2(255) NULL,
-- 	C6_DATE_CREATED	TIMESTAMP(6) NULL,
-- 	C7_LAST_UPDATED	TIMESTAMP(6) NULL
-- )
-- NOLOGGING

-- &

DECLARE create_query CLOB;  
   BEGIN  
      BEGIN  
         EXECUTE IMMEDIATE 'drop table RAX_APP_USER.C$_0TAG_GROUP_STG';  
      EXCEPTION  
         WHEN OTHERS THEN NULL;  
      END;  
      create_query := 'create table RAX_APP_USER.C$_0TAG_GROUP_STG
(
	C1_ID	NUMBER(19) NULL,
	C2_NAME	VARCHAR2(255) NULL,
	C3_ACTIVE_FLAG	NUMBER(1) NULL,
	C4_CREATED_BY	VARCHAR2(255) NULL,
	C5_UPDATED_BY	VARCHAR2(255) NULL,
	C6_DATE_CREATED	TIMESTAMP(6) NULL,
	C7_LAST_UPDATED	TIMESTAMP(6) NULL
)';  
      EXECUTE IMMEDIATE create_query;  
   END;  