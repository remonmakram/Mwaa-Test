/*-----------------------------------------------*/
/* TASK No. 2 */
/* drop report table */

BEGIN
    EXECUTE IMMEDIATE 'drop table RAX_APP_USER.actuate_counting_fee_new_stage';
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

create table RAX_APP_USER.actuate_counting_fee_new_stage as
SELECT company_name
, decode(country_name,NULL,'.',country_name) country_name
, ams_business_unit_name
, area_name
, region_name
, territory_name
, territory_code
, bank_code, serial_nbr
, job_nbr
, cashtxn_amt
, cashtxn_date
, deposit_date
, photography_date
, case when ship_date = to_date('19000101','YYYYMMDD') then null else ship_date end as ship_date
, sellingmethod_desc
, count_fee_perc
 , DECODE (sellingmethod_desc,
               'PrePay', 'P',
               'Spec', 'S',
               'Proof', 'F'
              ) sellingmethodcode
, (DECODE (sellingmethod_desc,
                'PrePay', DECODE (SIGN (deposit_date - photography_date - 11),
                                  -1, 'Yes',
                                  'No'
                                 ),
                'Spec', DECODE (SIGN (deposit_date - ship_date - 41),
                                -1, 'Yes',
                                'No'
                               ),
                'Proof', CASE
                   WHEN ship_date= to_date('19000101','YYYYMMDD')
                      THEN 'NA'
                   ELSE 'Yes'
                END
               )
       ) AS count_fee_flag
,       (DECODE (sellingmethod_desc,
                'PrePay', (deposit_date - photography_date + 1),
                'Spec', (deposit_date - ship_date + 1),
                'Proof', 1,
                0
               )
       ) AS days_to_bank
, (DECODE (sellingmethod_desc,
                'PrePay', DECODE (SIGN (deposit_date - photography_date - 11),
                                  -1, cashtxn_amt * count_fee_perc,
                                  0
                                 ),
                'Spec', DECODE (SIGN (deposit_date - ship_date - 41),
                                -1, cashtxn_amt * count_fee_perc,
                                0
                               ),
                'Proof', CASE WHEN ship_date = to_date('19000101','YYYYMMDD')
                   THEN 0
                   ELSE cashtxn_amt * count_fee_perc
                END)
       ) AS count_fee_amt
,       (cashtxn_date - deposit_date) AS days_depdate_keydate
,        Fiscal_Year
  FROM (SELECT  /*+parallel(event,6) parallel(apo,6) parallel(event_payment,6) parallel(deposit,6) use_hash(APO,EVENT_PAYMENT,DEPOSIT)*/
                organization_4.organization_name AS company_name,
                 NULL AS country_name,
                 organization_3.organization_name AS ams_business_unit_name,
                 organization_2.organization_name AS area_name,
                 organization_1.organization_name AS region_name,
                 ORGANIZATION.organization_name AS territory_name,
                 event.territory_code, bank_account.bank_code,
                 deposit.sequence_number AS serial_nbr,
                 event.event_ref_id AS job_nbr,
                 SUM (event_payment.payment_amount) AS cashtxn_amt,
                 event_payment.payment_date AS cashtxn_date,
                 deposit.deposit_date, event.photography_date,
                 event.ship_date, event.selling_method AS sellingmethod_desc,
                 CASE
                    WHEN bank_code LIKE '%564'
                       THEN .004
                    WHEN bank_code LIKE '%572'
                       THEN .004
                    WHEN bank_code LIKE 'CP77%'
                       THEN .004
                    WHEN bank_code LIKE 'MP77%'
                       THEN .004
                    ELSE .012
                 END AS count_fee_perc,
                t2.fiscal_year AS Fiscal_Year
            FROM ods_own.org_relationship org_relationship_3,
                 ods_own.ORGANIZATION organization_4,
                 ods_own.ORGANIZATION organization_3,
                 ods_own.org_relationship org_relationship_2,
                 ods_own.ORGANIZATION organization_2,
                 ods_own.org_relationship org_relationship_1,
                 ods_own.ORGANIZATION organization_1,
                 ods_own.org_relationship org_relationship,
                 ods_own.ORGANIZATION ORGANIZATION,
                 ods_own.event event,
                 ods_own.event_payment event_payment,
                 ods_own.deposit deposit,
                 ods_own.bank_account bank_account,
                 ods_own.apo,
                 ods_own.sub_program,
                 ods_own.program,
                 mart.time t,
                 mart.time t2
           WHERE (org_relationship_3.parent_organization_oid =
                                               organization_4.organization_oid
                 )
             AND (organization_3.organization_oid =
                                     org_relationship_3.child_organization_oid
                 )
             AND (org_relationship_2.parent_organization_oid =
                                               organization_3.organization_oid
                 )
             AND (organization_2.organization_oid =
                                     org_relationship_2.child_organization_oid
                 )
             AND (org_relationship_1.parent_organization_oid =
                                               organization_2.organization_oid
                 )
             AND (organization_1.organization_oid =
                                     org_relationship_1.child_organization_oid
                 )
             AND (org_relationship.parent_organization_oid =
                                               organization_1.organization_oid
                 )
             AND (org_relationship.child_organization_oid =
                                                 ORGANIZATION.organization_oid
                 )
             AND (ORGANIZATION.org_code = event.territory_code)
               
             AND (event_payment.event_oid = event.event_oid)
             AND (event_payment.deposit_oid = deposit.deposit_oid)
             AND (deposit.bank_account_oid = bank_account.bank_account_oid)
             AND ods_own.apo.apo_oid(+) = ods_own.event.apo_oid

             AND ods_own.sub_program.sub_program_oid(+) =
                                                   ods_own.apo.sub_program_oid
             AND ods_own.program.program_oid(+) =
                                               ods_own.sub_program.program_oid
             AND (ORGANIZATION.org_type_level = 6)
             AND (organization_1.org_type_level = 5)
             AND (organization_2.org_type_level = 4)
             AND (organization_3.org_type_level = 3)
             AND (organization_4.org_type_level = 2)
             AND t.date_key = trunc(sysdate) - 6
             AND event_payment.ods_create_date >= t.fiscal_year_begin_date - interval '1' year
             AND event_payment.ods_create_date <= t.fiscal_year_end_date 
             AND trunc(event_payment.ods_create_date) = t2.date_key
             --AND cashtxn_code = 1
             AND ods_own.deposit.entry_type NOT IN ('CORRECTION', 'NSF')
             AND NVL (ods_own.program.program_name, 'NULL VALUE') <>
                                                                 'Money Trans'
             AND SUBSTR (bank_code, 1, 3) NOT IN ('NSS', 'JF0')
             AND SUBSTR (bank_code, 5, 1) = ' '
     --  and event.event_ref_id ='EVT2HR44F'
              AND event_payment.territory_account_type IN
                               ('Underclass', 'SpecialEvents', 'RemindTheX')
        GROUP BY organization_4.organization_name,
                 --  country_name,
                 organization_3.organization_name,
                 organization_2.organization_name,
                 organization_1.organization_name,
                 ORGANIZATION.organization_name,
                 event.territory_code,
                 bank_code,
                 deposit.sequence_number,
                 event.event_ref_id,
                 event_payment.payment_date,
                 deposit_date,
                 photography_date,
                 ship_date,
                 event.selling_method,
                 t2.fiscal_year,
                 CASE
                    WHEN bank_code LIKE '%564'
                       THEN .004
                    WHEN bank_code LIKE '%572'
                       THEN .004
                    WHEN bank_code LIKE 'CP77%'
                       THEN .004
                    WHEN bank_code LIKE 'MP77%'
                       THEN .004
                    ELSE .012
                 END)
 WHERE cashtxn_amt <> 0
AND area_name not like '%Canada%'

&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* grant permission */

grant select on rax_app_user.actuate_counting_fee_new_stage to ODS_SELECT_ROLE ,MART_USER

