/* TASK No. 1 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 2 */




/*-----------------------------------------------*/
/* TASK No. 3 */

/* SELECT STATEMENT FOUND, CHECK ODI TASK NO. 3 */




/*-----------------------------------------------*/
/* TASK No. 4 */

-- OdiStartScen "-SCEN_NAME=99_SFLY_MLT_COUPON_PKG"

-- &


-- /*-----------------------------------------------*/
-- /* TASK No. 5 */

-- Email OK


-- OdiSendMail "-MAILHOST=LTIVRS1.LIFETOUCH.NET" "-FROM=ODI_EMAIL-PROD@Lifetouch.com" "-SUBJECT=99_SFLY_MLT_COUPON_MAIN_PKG Completed Successfully" "-TO=:v_noerror_email_to"
-- Data Center - :v_US_data_center

-- 99_SFLY_MLT_COUPON_MAIN_PKG Completed Successfully!!

-- &


/*-----------------------------------------------*/

-- Email Not OK

-- OdiSendMail "-MAILHOST=LTIVRS1.LIFETOUCH.NET" "-FROM=ODI_EMAIL-<%=odiRef.getSession( ""CONTEXT_NAME"" )%>@Lifetouch.com" "-SUBJECT=99_SFLY_MLT_COUPON_PKG FAILED" "-TO=#v_error_email_to"
-- Data Center - #v_US_data_center

-- 99_SFLY_MLT_COUPON_PKG FAILED!!
