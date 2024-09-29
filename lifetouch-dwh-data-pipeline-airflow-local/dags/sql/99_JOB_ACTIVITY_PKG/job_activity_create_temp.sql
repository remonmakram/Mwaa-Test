

/*-----------------------------------------------*/
/* TASK No. 5 */
/* drop report table */



BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.actuate_jaf_jobstatus';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 



&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* create report table */

create table RAX_APP_USER.actuate_jaf_jobstatus as
SELECT
 o.TERRITORY_CODE,
 o.TERRITORY_NAME,
 o.REGION_NAME,
 o.AREA_NAME,
 o.COMPANY_name,
 o.country_name,
 evt.job_nbr,
 evt.marketing_code,
 substr(evt.job_nbr,1,4) subterritorycode,
 a.lifetouch_id,
 a.account_name,
 a.address_line_1,
 a.CITY,
 a.STATE, 
 a.postal_code,
 a.county,
 a.district_name,
 evt.SELLING_METHOD_name,
 evt.PLANT_CODE,
 evt.PHOTOGRAPHY_DATE,
 decode(to_char(evt.SHIP_DATE,'YYYY/MM/DD'),'1900/01/01',null,evt.SHIP_DATE)  SHIP_DATE, 
 decode(evt.CMSN_STATUS_code,'Unknown',' ', evt.cmsn_status_code) cmsn_status_code,
 esf.grosscash,
 esf.schoolcomm,
 esf.salestaxamt,
 esf.cashretainedamt,
 esf.expectedcashamt,
 esf.chargebackamt,
 esf.shippedpackageqty,
 esf.paidpackageqty,
 esf.shotqty,
 esf.territorycmsnamt,
 esf.territoryearningsamt,
 esf.xnopurchaseqty,
 esf.proof_poses,
 esf.proof_qty,
 m.sub_program_name
 ,o.AMS_BUSINESS_UNIT_NAME
FROM
   event evt,
   organization o,
   account a,
   time t,
   marketing m,
   (select fiscal_year from time where date_key = trunc(to_date(:v_data_export_run_date_trigger_table_refresh,'yyyymmdd') - 7)) cfy,
  (select
     esf.event_id,
     esf.account_id,
     esf.job_ticket_org_id,
     sum(nvl(esf.transaction_amt,0)) grosscash,
     sum(nvl(esf.est_acct_cmsn_amt,0) + nvl(esf.acct_cmsn_paid_amt,0)) schoolcomm,
     sum(nvl(esf.order_sales_tax_amt,0)) salestaxamt,
     sum(nvl(esf.transaction_amt,0) - nvl(esf.est_acct_cmsn_amt,0) - nvl(esf.acct_cmsn_paid_amt,0) - nvl(esf.order_sales_tax_amt,0)) cashretainedamt,
     sum(nvl(esf.perfect_order_sales_amt,0)) expectedcashamt,
     sum(nvl(esf.territory_chargeback_amt,0)) chargebackamt,
     sum(nvl(esf.shipped_order_qty,0)) shippedpackageqty,
     sum(nvl(esf.calculated_paid_order_qty,0)) paidpackageqty,
     sum(DECODE(TO_CHAR(esf.Ship_Date,'MM/DD/YYYY'),'01/01/1900',NVL(esf.Unpaid_Order_Qty,0)+NVL(esf.Calculated_Paid_Order_Qty,0)+NVL(esf.X_No_Purchase_Qty,0),
                NVL(esf.Shipped_Order_Qty,0)+NVL(esf.X_No_Purchase_Qty,0))) as shotqty,
     sum(nvl(esf.territory_cmsn_amt,0)) territorycmsnamt,
     sum(nvl(esf.territory_cmsn_amt,0) - nvl(esf.territory_chargeback_amt,0)) territoryearningsamt,
     sum(nvl(esf.x_no_purchase_qty,0)) xnopurchaseqty,
     sum(esf.image_qty) proof_poses,
     sum(esf.proof_qty) proof_qty
  from
    event_sales_fact esf,
    event e,
    (select fiscal_year from time where date_key = trunc(to_date(:v_data_export_run_date_trigger_table_refresh,'yyyymmdd') - 7)) cfy
  where 
    esf.event_id = e.event_id and
    e.school_year in (cfy.fiscal_year, cfy.fiscal_year - 1) and
    esf.oldbiz_ind = 'N'
  group by 
    esf.event_id,
     esf.account_id,
     esf.job_ticket_org_id) esf
WHERE
    esf.event_id = evt.event_id and
    esf.account_id = a.account_id and
    esf.job_ticket_org_id = o.organization_id and
    m.marketing_code = evt.marketing_code and
    evt.prejob_ind = 'N' AND
    evt.active_ind = 'A' and
    evt.SELLING_METHOD_name <> 'Unknown' and
    evt.ship_date = t.date_key and
    evt.sub_program_name <> 'Yearbook' and
    t.fiscal_year in (-1,cfy.fiscal_year)    -- school_year value minus 1 gives us carry over jobs from prior year and unshipped jobs




&
