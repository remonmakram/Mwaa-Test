/*-----------------------------------------------*/
/* TASK No. 17 */
/* UPDATE ODS_APP_USER.KREPORT_DATA_FEED  */

UPDATE 
	RAX_APP_USER.KREPORT_DATA_FEED 
SET 
	TRANSMIT_DATE = sysdate
WHERE (1=1)
	and TRANSMIT_DATE is null


&


/*-----------------------------------------------*/