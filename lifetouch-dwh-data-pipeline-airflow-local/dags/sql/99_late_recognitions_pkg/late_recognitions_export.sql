/*-----------------------------------------------*/
/* TASK No. 10 */
/* Insert new rows */

/* SOURCE CODE */


select
	LATE_RECOGNITIONS.SCHOOL_YEAR	   SCHOOL_YEAR,
	LATE_RECOGNITIONS.GL_TRANSACTION_DETAIL_OID	   GL_TRANSACTION_DETAIL_OID,
	LATE_RECOGNITIONS.SUB_PROGRAM_NAME	   SUB_PROGRAM_NAME,
	LATE_RECOGNITIONS.APO_ID	   APO_ID,
	LATE_RECOGNITIONS.EVENT_REF_ID	   EVENT_REF_ID,
	LATE_RECOGNITIONS.TERRITORY_CODE	   TERRITORY_CODE,
	LATE_RECOGNITIONS.RECOGNIZED_DATE	   RECOGNIZED_DATE,
	LATE_RECOGNITIONS.POSTED_AMOUNT	   POSTED_AMOUNT,
	LATE_RECOGNITIONS.APO_TYPE_NAME	   APO_TYPE_NAME,
	LATE_RECOGNITIONS.GL_ACCOUNT	   GL_ACCOUNT,
	LATE_RECOGNITIONS.GL_SUB_ACCOUNT	   GL_SUB_ACCOUNT,
	LATE_RECOGNITIONS.GL_ACCOUNTING_UNIT	   GL_ACCOUNTING_UNIT,
	LATE_RECOGNITIONS.GL_DESCRIPTION	   GL_DESCRIPTION,
	LATE_RECOGNITIONS.TRANSMIT_DATE	   TRANSMIT_DATE,
	LATE_RECOGNITIONS.PROFIT_CENTER	   PROFIT_CENTER
from	RAX_APP_USER.LATE_RECOGNITIONS   LATE_RECOGNITIONS
where
	(1=1)


