BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.pending_acm_checks_stage';
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
/* TASK No. 3 */
/* create report table */

create table RAX_APP_USER.pending_acm_checks_stage as
select apo.territory_code
, p.program_name
, apo.selling_method
, apo.lifetouch_id
, apo.apo_id
, to_char(ae.act_comm_finalized_date,'MM/DD/YYYY') as finalized_date
, to_char(acpr.request_date,'MM/DD/YYYY') as request_date
, acpr.payment_amount
from srm_own.apo_extension ae
, ods_own.apo
, ods_own.acct_comm_pmt_req acpr
, ods_own.sub_program sp
, ods_own.program p
where 1=1
and apo.apo_oid = ae.apo_oid
and apo.apo_oid = acpr.apo_oid
and not exists
(
select 1
from ods_own.account_commission ac
where 1=1
and acpr.acct_comm_pmt_req_id = ac.acct_comm_pmt_req_id
and ac.ods_create_date < trunc(sysdate)
)
and apo.sub_program_oid = sp.sub_program_oid
and sp.program_oid = p.program_oid
and ae.act_comm_finalized in ('Pending','Finalized')
and trunc(ae.act_comm_finalized_date) = trunc(acpr.request_date)
and acpr.approval_status not in ('Declined')
and acpr.payment_request_type in ('StandardCheck','PrepaymentCheck')  
--and ae.act_comm_finalized_date between trunc(sysdate - 30) and trunc(sysdate) -- removed SODS-1379
order by apo.territory_code
, p.program_name
, apo.selling_method
, apo.lifetouch_id