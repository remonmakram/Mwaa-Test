BEGIN
  EXECUTE IMMEDIATE 'drop table sfly_coupon_v2_tmp';
EXCEPTION
  WHEN OTHERS THEN
   IF SQLCODE != -942 THEN
     RAISE;
   END IF;
END;

&

create table sfly_coupon_v2_tmp as
SELECT DISTINCT tmp.subject_first_name,
       tmp.cust_email_address,
       tmp.payment_voucher_id,
       TO_CHAR (tmp.audit_create_date, 'MM/DD/YYYY')     AS audit_create_date,
       acct.STATE,
       a.SCHOOL_YEAR,
       sp.SUB_PROGRAM_NAME                               AS sub_program,
       tmp.order_type,
       TO_CHAR(e.photography_date,'MM/DD/YYYY') AS photography_date
  FROM rax_app_user.sfly_coupon_mlt_v2_tmp  tmp,
       ods_own.event                        e,
       ods_own.apo                          a,
       ods_own.sub_program                  sp,
       ods_own.ACCOUNT                      acct
 WHERE     1 = 1
       AND tmp.job_number = E.EVENT_REF_ID
       AND e.apo_oid = a.apo_oid
       AND a.account_oid = acct.account_oid
       AND a.sub_program_oid = sp.sub_program_oid

&

grant select on sfly_coupon_v2_tmp to ods_select_role
