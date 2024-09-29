/* TASK No. 1 */
/* delete - Contact */

delete from b2b_own.contact

&


/*-----------------------------------------------*/
/* TASK No. 2 */
/* delete - PDK_Order */

delete from b2b_own.pdk_order

&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* delete - nextools_job_user */

delete from b2b_own.nextools_job_user

&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* delete - Picture_Day */

delete from b2b_own.picture_day

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* delete - Event */

delete from b2b_own.event

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* delete - APO */

delete from b2b_own.apo

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* delete - Booking */

delete from b2b_own.booking

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* delete apy */

delete from b2b_own.apy

&


/*-----------------------------------------------*/
/* TASK No. 9 */
/* delete - account */

delete from b2b_own.account

&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* delete - YB_APO_CONTACT */

delete from b2b_own.yb_apo_contact

&


/*-----------------------------------------------*/
/* TASK No. 11 */
/* delete - YB_LID_CONTACT */

DELETE FROM B2B_OWN.yb_lid_contact

&


/*-----------------------------------------------*/
/* TASK No. 12 */
/* delete - BOOK */

delete from b2b_own.book

&


/*-----------------------------------------------*/
/* TASK No. 13 */
/* delete - ENDSHEET */

delete from  b2b_own.endsheet

&


/*-----------------------------------------------*/
/* TASK No. 14 */
/* load account */

insert into b2b_own.account
(LIFETOUCH_ID 
,PARENT_LIFETOucH_ID                             
,ACCOUNT_NAME 
,ACCOUNT_ALIAS                                      
,NACAM_OVERALL_CLASS_NAME                           
,ENROLLMENT                                         
,ADDRESS_LINE1                                      
,ADDRESS_LINE2                                      
,CITY                                               
,STATE                                              
,COUNTRY                                            
,POSTAL_CODE                                        
,BUSINESS_PHONE
,category_name
,subcategory_name
,school_high_grade
,school_low_grade
,active_account_ind
,account_open_date
,account_closed_date
,county    
,web_address
,fax_number
,ship_to_address_line1
,ship_to_address_line2
,ship_to_address_line3
,ship_to_city
,ship_to_state
,ship_to_postal_code                                    
)
select a.LIFETOUCH_ID
,pa.lifetouch_id
,a.ACCOUNT_NAME 
,a.ACCOUNT_ALIAS                                      
,a.NACAM_OVERALL_CLASS_NAME                           
,a.ENROLLMENT                                         
,a.PHYSICAL_ADDRESS_LINE1                             
,a.PHYSICAL_ADDRESS_LINE2                             
,a.CITY                                               
,a.STATE                                              
,a.COUNTRY                                            
,a.POSTAL_CODE                                        
,a.BUSINESS_PHONE
,a.category_name
,a.subcategory_name
,a.school_high_grade
,a.school_low_grade
,a.active_account_ind
,a.account_open_date
,a.account_closed_date 
,a.county
,a.web_address
,a.fax_number
,a.ship_to_address_line1
,a.ship_to_address_line2
,a.ship_to_address_line3
,a.ship_to_city
,a.ship_to_state
,a.ship_to_postal_code                         
from ods_own.account a
, ods_own.account pa
where a.parent_account_oid = pa.account_oid(+)


&


/*-----------------------------------------------*/
/* TASK No. 15 */
/* load MART stuff (no time to get it to ODS) */

update
(
select target.lifetouch_id 
, target.mdr_pid as target_mdr_pid
, source.mdr_pid as source_mdr_pid
, target.school_open_day as target_school_open_day
, source.school_open_day as source_school_open_day
, target.school_close_day as target_school_close_day
, source.school_close_day as source_school_close_day
from b2b_own.account target
, mart.account source
where 1=1
and source.lifetouch_id = target.lifetouch_id
)
set target_mdr_pid = case when source_mdr_pid = 'Unknown' then null else source_mdr_pid end
, target_school_open_day = case when source_school_open_day in ('01/01','Unknown') then null else source_school_open_day end
, target_school_close_day = case when source_school_close_day in ('01/01','Unknown') then null else source_school_close_day end


&


/*-----------------------------------------------*/
/* TASK No. 16 */
/* load apy */

insert into b2b_own.apy
(lifetouch_id
, school_year
, sub_program_name
, booking_status
, projected_sales
, current_year_selling_methods
, business_unit_name
, area_name
, region_name
, territory_code
, sales_rep_first_name
, sales_rep_last_name
, sales_rep_email_address
, gross_cash
)
select a.lifetouch_id
, f.fiscal_year
, m.sub_program_name
, bs.booking_status_name
, round(sum(f.proj_transaction_amt 
  + (case when bs.booking_status_name in ('Rebooked', 'Not Rebooked', 'Lost',  'Closed') then f.shrink_transaction_amt 
     else 0 end)))
, apy.current_year_selling_methods
, ca.ams_business_unit_name as business_unit_name
, ca.area_name
, ca.region_name
, ca.territory_code
, e.first_name as sales_rep_first_name
, e.last_name as sales_rep_last_name
, le.email_address as sales_rep_email_address
, 0 as gross_cash
from mart.apy_booking_fact f
, mart.time t
, mart.account a
, mart.marketing m
, mart.x_booking_status bs
, mart.apy apy
, mart.current_assignment ca
, mart.employee e
, hr_own.law_employee le
where f.account_id = a.account_id
and f.marketing_id = m.marketing_id
and f.apy_booking_status_id = bs.x_booking_status_id
and t.date_key = trunc(sysdate)
and f.fiscal_year >= t.calendar_year
and f.account_id not in (0,-1) -- ignore the MART Unknown and NA accounts
and f.apy_id = apy.apy_id
and ca.lifetouch_id = a.lifetouch_id
and ca.program_id = m.program_id
and ca.sales_rep_employee_id = e.employee_id
And e.employee_code = le.employee(+)
And e.company_code = le.company(+)
group by a.lifetouch_id
, f.fiscal_year
, m.sub_program_name
, bs.booking_status_name
, apy.current_year_selling_methods
, ca.ams_business_unit_name 
, ca.area_name
, ca.region_name
, ca.territory_code
, e.first_name 
, e.last_name 
, le.email_address 
having sum(f.occurs) > 0

&


/*-----------------------------------------------*/
/* TASK No. 17 */
/* Load APY.GROSS_CASH */

merge into b2b_own.apy t using
(
select a.lifetouch_id
, m.sub_program_name
, f.school_year
, sum(payment_amt) as gross_cash
from mart.summary_fact f
, mart.account a
, mart.marketing m
, mart.time t
where f.account_id = a.account_id
and f.marketing_id = m.marketing_id
and t.date_key = trunc(sysdate)
and f.school_year >= t.calendar_year
and f.account_id not in (0,-1) -- ignore the MART Unknown and NA accounts
and m.program_name not in
('Preschool'
)
group by a.lifetouch_id
, m.sub_program_name
, f.school_year
having sum(payment_amt) <> 0
) s
on
(   s.lifetouch_id = t.lifetouch_id
and s.sub_program_name = t.sub_program_name
and s.school_year = t.school_year
)
when matched then update
set t.gross_cash = s.gross_cash

&


/*-----------------------------------------------*/
/* TASK No. 18 */
/* Load Booking Table */

insert into b2b_own.booking
(booking_id
,lifetouch_id
,sub_program_name
,selling_method
,territory_code
,school_year
,sales_rep_first_name
,sales_rep_last_name
, business_unit_name
, area_name
, region_name
, sales_rep_email_address
, booking_status
, lost_reason_text
)
SELECT bo.booking_id
, bo.lifetouch_id
, sp.sub_program_name
, sm.selling_method
, ca.territory_code
, bo.school_year
, e.first_name AS sales_rep_first_name
, e.last_name AS sales_rep_last_name
, ca.ams_business_unit_name as business_unit_name
, ca.area_name
, ca.region_name
, le.email_address as sales_rep_email_address
, mbo.booking_status
, bo.lost_reason_text
  FROM ods_own.booking_opportunity bo,
       ods_own.ACCOUNT acct,
       ods_own.sub_program sp,
       ods_own.selling_method sm,
       mart.current_assignment ca,
       MART.EMPLOYEE e,
       hr_own.law_employee le,
       mart.booking_opp mbo,
       mart.time t,
       ODS_OWN.PROGRAM p
 WHERE bo.account_oid = acct.account_oid
   AND bo.selling_method_oid = sm.selling_method_oid(+)
   -- Current Assignment Joins
   AND    bo.lifetouch_id = ca.lifetouch_id
   AND SP.PROGRAM_OID = P.PROGRAM_OID
   AND p.program_id = ca.program_id
   and CA.SALES_REP_EMPLOYEE_ID = E.EMPLOYEE_ID
   --
   AND    t.date_key = trunc(sysdate)
   AND bo.sub_program_oid = sp.sub_program_oid
   AND bo.school_year >= (t.calendar_year - 1)
   AND ca.active_ind = 'A'
   AND bo.booking_id = mbo.booking_id
   AND bo.school_year = mbo.fiscal_year
   AND bo.booking_status <> 'Inactive'
   And e.employee_code = le.employee(+)
   And e.company_code = le.company(+)

&


/*-----------------------------------------------*/
/* TASK No. 19 */
/* Load APO Table */

insert into b2b_own.apo
( apo_id
, booking_id
, lifetouch_id
, sub_program_name
, selling_method
, territory_code
, school_year
, sales_rep_first_name
, sales_rep_last_name
, operations_rep
, names_uploaded
, online_orders
, area_name 
, region_name 
, business_unit_name
, terr_manager_first_name 
, terr_manager_last_name 
, sales_rep_email_address 
, student_yb_pose_sel_deadline 
, image_access_product_ind
, parent_notify_status
, language
, lpip_job_number
, first_photo_date
, yb_cover_received_date
, yb_finalized_date
, booking_sub_program
, book_offering
, signing_info
)
SELECT a.apo_id,
       bo.booking_id,
       a.lifetouch_id,
       sp.sub_program_name,
       a.selling_method,
       a.territory_code,
       a.school_year,
       CASE
           WHEN NVL (e.first_name, 'Unknown') = 'Unknown'
           THEN
               CASE
                   WHEN REGEXP_SUBSTR (a.sales_rep_name, '[^,]+$')
                            IS NOT NULL
                   THEN
                       REGEXP_SUBSTR (a.sales_rep_name, '[^, ]+$')
                   ELSE
                       e.first_name
               END
           ELSE
               e.first_name
       END                      AS sales_rep_first_name,
       CASE
           WHEN NVL (e.last_name, 'Unknown') = 'Unknown'
           THEN
               CASE
                   WHEN REGEXP_SUBSTR (a.sales_rep_name, '[^,]+') IS NOT NULL
                   THEN
                       REGEXP_SUBSTR (a.sales_rep_name, '[^, ]+')
                   ELSE
                       e.last_name
               END
           ELSE
               e.last_name
       END                      AS sales_rep_last_name,
       a.operations_rep_name    AS operations_rep,
       a.names_qty              AS names_uploaded,
       a.online_order_qty       AS online_orders,
       o.area_name,
       o.region_name,
       o.ams_business_unit_name,
       o.manager_first_name,
       o.manager_last_name,
       CASE
           WHEN NVL (e.sales_rep_email_address, 'Unknown') = 'Unknown'
           THEN
               CASE
                   WHEN a.sales_rep_email IS NOT NULL THEN a.sales_rep_email
                   ELSE e.sales_rep_email_address
               END
           ELSE
               e.sales_rep_email_address
       END                      AS sales_rep_email_address,
       mapo.student_yb_pose_sel_deadline,
       mapo.image_access_product_ind,
       a.parent_notify_status,
       NULL,
       a.lpip_job_number,
       NULL,
       a.cover_received,
       a.finalized_date,
       mapo.booking_sub_program,
       a.book_offering,
       a.SIGNING_INFO
  FROM ods_own.apo                  a,
       ods_own.ACCOUNT              acct,
       ods_own.sub_program          sp,
       ods_own.booking_opportunity  bo,
       ods_own.source_system        ss,
       mart.organization            o,
       mart.apo                     mapo,
       mart.time                    t,
       --ods_own.apo_tag tag,
        (SELECT emp.first_name,
                emp.last_name,
                ca.lifetouch_id,
                p.program_oid,
                sp.sub_program_oid,
                emp.employee_code,
                le.email_address     AS sales_rep_email_address
           FROM mart.employee            emp,
                mart.current_assignment  ca,
                hr_own.law_employee      le,
                ods_own.program          p,
                ods_own.sub_program      sp
          WHERE     p.program_id = ca.program_id(+)
                AND ca.sales_rep_employee_id = emp.employee_id(+)
                AND emp.employee_code = le.employee(+)
                AND emp.company_code = le.company(+)
                AND sp.program_oid = p.program_oid
                AND ca.active_ind = 'A') e
 WHERE a.account_oid = acct.account_oid
   AND a.sub_program_oid = sp.sub_program_oid
   AND a.booking_opp_oid = bo.booking_opportunity_oid(+)
   AND a.source_system_oid = ss.source_system_oid
   AND a.lifetouch_id = e.lifetouch_id(+)
   AND a.sub_program_oid = e.sub_program_oid(+)
   and a.territory_code = o.territory_code(+)
   and a.apo_id = mapo.apo_code(+)
   AND ss.source_system_short_name NOT IN ('ODS', 'LPIP')
and t.date_key = trunc(sysdate)
   AND a.school_year >= t.calendar_year
   AND a.status = 'Active'
 --and a.apo_oid = tag.apo_oid(+)
  -- and tag.tag_group(+) = 'Language'

&


/*-----------------------------------------------*/
/* TASK No. 20 */
/* populate first_photo_date for seniors */

MERGE INTO b2b_own.apo t
USING
 (select apo.apo_id, min(picture_date) as first_photo_date
 from ods_own.capture_session cs, ods_own.apo apo
, ods_own.sub_program sp, ods_own.program p
where cs.apo_oid = apo.apo_oid
and apo.sub_program_oid = sp.sub_program_oid
and sp.program_oid = p.program_oid
and p.program_name = 'Senior/Studio Style'
group by apo.apo_id, apo.school_year) s
 ON  (s.apo_id = t.apo_id)      
 WHEN MATCHED THEN
 UPDATE
 SET t.first_photo_date = s.first_photo_date

&


/*-----------------------------------------------*/
/* TASK No. 21 */
/* populate language tag group in apo */

MERGE INTO b2b_own.apo t
   USING (SELECT  at.tag, apo.apo_id
        FROM (
        SELECT max(apo_tag_oid) as apo_tag_oid, apo_oid         
        FROM ods_own.apo_tag 
        where tag_group = 'Language' 
        group by apo_oid
        order by apo_tag_oid
         ) m, ods_own.apo_tag at, ods_own.apo apo
        WHERE at.apo_oid = m.apo_oid
        and at.apo_tag_oid = m.apo_tag_oid
        and apo.apo_oid = at.apo_oid) src
   ON  (src.apo_id = t.apo_id)      
   WHEN MATCHED THEN
      UPDATE
         SET t.language = src.tag

&


/*-----------------------------------------------*/
/* TASK No. 22 */
/* Load Event Table */

INSERT INTO B2B_OWN.EVENT (EVENT_REF_ID,
                           LIFETOUCH_ID,
                           APO_ID,
                           SUB_PROGRAM_NAME,
                           SELLING_METHOD,
                           TERRITORY_CODE,
                           SCHOOL_YEAR,
                           EVENT_TYPE,
                           PHOTOGRAPHY_DATE,
                           END_PHOTOGRAPHY_DATE,
                           SHIP_DATE,
                           YB_COVER_ENDSHEET_DEADLINE,
                           YB_COVER_DEADLINE_SATISFIED,
                           YB_FINAL_PAGE_DEADLINE,
                           YB_PAGE_DEADLINE_SATISFIED,
                           YB_ARRIVAL_DATE,
	      FINAL_QUANTITY_DEADLINE,
	      ADDITIONAL_PAGE_DEADLINE2,
	      ADDITIONAL_PAGE_DEADLINE3,
	      ADDITIONAL_PAGE_DEADLINE4,
	      EXTRA_COVERAGE_DEADLINE,
	      ENHANCEMENT_DEADLINE,
	      FIRST_PAGE_DEADLINE_PP,
	      ADDITIONAL_PAGE_DEADLINE2_PP,
	      ADDITIONAL_PAGE_DEADLINE3_PP,
	      EXTRA_COVERAGE_DEADLINE_PP,
	      FINAL_PAGE_DEADLINE_PP,
	      FOW_EVENT_IMAGE_COMPLETE)
   SELECT EVENT_REF_ID,
          LIFETOUCH_ID,
          APO_ID,
          SUB_PROGRAM_NAME,
          SELLING_METHOD,
          TERRITORY_CODE,
          SCHOOL_YEAR,
          EVENT_TYPE,
          PHOTOGRAPHY_DATE,
          END_PHOTOGRAPHY_DATE,
          SHIP_DATE,
          YB_COVER_ENDSHEET_DEADLINE,
          YB_COVER_DEADLINE_SATISFIED,
          YB_FINAL_PAGE_DEADLINE,
          YB_PAGE_DEADLINE_SATISFIED,
          YB_ARRIVAL_DATE,
          FINAL_QUANTITY_DEADLINE,
	      ADDITIONAL_PAGE_DEADLINE2,
	      ADDITIONAL_PAGE_DEADLINE3,
	      ADDITIONAL_PAGE_DEADLINE4,
	      EXTRA_COVERAGE_DEADLINE,
	      ENHANCEMENT_DEADLINE,
	      FIRST_PAGE_DEADLINE_PP,
	      ADDITIONAL_PAGE_DEADLINE2_PP,
	      ADDITIONAL_PAGE_DEADLINE3_PP,
	      EXTRA_COVERAGE_DEADLINE_PP,
	      FINAL_PAGE_DEADLINE_PP,
	      FOW_EVENT_IMAGE_COMPLETE
     FROM (SELECT E.EVENT_REF_ID,
                  E.LIFETOUCH_ID,
                  ACCT.ENROLLMENT,
                  (CASE
                      WHEN SS.SOURCE_SYSTEM_SHORT_NAME IN ('LPIP', 'ODS')
                      THEN
                         NULL
                      ELSE
                         A.APO_ID
                   END)
                     AS APO_ID,
                  (CASE
                      WHEN SP.SUB_PROGRAM_NAME IS NULL
                      THEN
                         M.SUB_PROGRAM_NAME
                      ELSE
                         SP.SUB_PROGRAM_NAME
                   END)
                     AS SUB_PROGRAM_NAME,
                  E.SELLING_METHOD,
                  E.TERRITORY_CODE,
                  E.SCHOOL_YEAR,
                  E.EVENT_TYPE,
                  E.PHOTOGRAPHY_DATE,
                  E.VISION_PHOTO_DATE_B     AS END_PHOTOGRAPHY_DATE,
                  SS.SOURCE_SYSTEM_SHORT_NAME,
                  E.VISION_COMMIT_DATE,
                  E.SHIP_DATE,
                  E.COVER_ENDSHEET_DEADLINE AS YB_COVER_ENDSHEET_DEADLINE,
                  CASE
                     WHEN (E.COVER_ENDSHEET_DEADLINE - A.COVER_RECEIVED) >= 0
                     THEN
                        'TRUE'
                     ELSE
                        'FALSE'
                  END
                     AS YB_COVER_DEADLINE_SATISFIED,
                  E.FINAL_PAGE_DEADLINE     AS YB_FINAL_PAGE_DEADLINE,
                  CASE
                     WHEN (E.FINAL_PAGE_DEADLINE - A.FINALIZED_DATE) >= 0
                     THEN
                        'TRUE'
                     ELSE
                        'FALSE'
                  END
                     AS YB_PAGE_DEADLINE_SATISFIED,
                     e.yb_arrival_date,
	e.FINAL_QUANTITY_DEADLINE,
	e.ADDITIONAL_PAGE_DEADLINE2,
	e.ADDITIONAL_PAGE_DEADLINE3,
	e.ADDITIONAL_PAGE_DEADLINE4,
	e.EXTRA_COVERAGE_DEADLINE,
	e.ENHANCEMENT_DEADLINE,
	e.FIRST_PAGE_DEADLINE_PP,
	e.ADDITIONAL_PAGE_DEADLINE2_PP,
	e.ADDITIONAL_PAGE_DEADLINE3_PP,
	e.EXTRA_COVERAGE_DEADLINE_PP,
	e.FINAL_PAGE_DEADLINE_PP,
	e.FOW_EVENT_IMAGE_COMPLETE
             FROM ODS_OWN.EVENT         E,
                  ODS_OWN.ACCOUNT       ACCT,
                  ODS_OWN.APO           A,
                  ODS_OWN.SUB_PROGRAM   SP,
                  MART.MARKETING        M,
                  MART.TIME             T,
                  ODS_OWN.SOURCE_SYSTEM SS
            WHERE     E.LIFETOUCH_ID = ACCT.LIFETOUCH_ID
                  AND E.APO_OID = A.APO_OID(+)
                  AND A.SOURCE_SYSTEM_OID = SS.SOURCE_SYSTEM_OID(+)
                  AND A.SUB_PROGRAM_OID = SP.SUB_PROGRAM_OID(+)
                  AND E.DW_MARKETING_CODE = M.MARKETING_CODE(+)
                  AND T.DATE_KEY = TRUNC (SYSDATE)
                  AND A.STATUS(+) = 'Active'
                  AND E.SCHOOL_YEAR >= T.CALENDAR_YEAR)
    WHERE (   (APO_ID IS NOT NULL OR SOURCE_SYSTEM_SHORT_NAME = 'LPIP')
           OR (    APO_ID IS NULL
               AND NVL (VISION_COMMIT_DATE, '01-JAN-1900') != '01-JAN-1900'))

&


/*-----------------------------------------------*/
/* TASK No. 23 */
/* Populate YB Page Submitted Elements */

MERGE INTO B2B_OWN.EVENT T
     USING (  SELECT SUB.EVENT_REF_ID, MAX (P.YB_MODIFIED_ON) LAST_MODIFIED
                FROM (  SELECT EVENT_REF_ID,
                               COUNT (*)   AS CT,
                               SUM (SUBMITTED) AS SUBMITTED
                          FROM (  SELECT DISTINCT
                                         SUBMITTED.EVENT_REF_ID,
                                         SUBMITTED.PAGE_NUMBER,
                                         SUBMITTED.SUBMITTED
                                    FROM (SELECT BE.EVENT_REF_ID,
                                                 P.PAGE_NUMBER,
                                                 NVL (P.SUBMITTED, 0) AS SUBMITTED,
                                                 P.YB_MODIFIED_ON
                                            FROM ODS_OWN.BOOK_EVENT BE,
                                                 ODS_OWN.PAGE P
                                           WHERE P.BOOK_EVENT_OID =
                                                    BE.BOOK_EVENT_OID) SUBMITTED,
                                         (  SELECT BE.EVENT_REF_ID,
                                                   P.PAGE_NUMBER,
                                                   MAX (P.YB_MODIFIED_ON)
                                                      YB_MODIFIED_ON
                                              FROM ODS_OWN.BOOK_EVENT BE,
                                                   ODS_OWN.PAGE P
                                             WHERE P.BOOK_EVENT_OID =
                                                      BE.BOOK_EVENT_OID
                                          GROUP BY BE.EVENT_REF_ID, P.PAGE_NUMBER)
                                         LATEST
                                   WHERE     SUBMITTED.EVENT_REF_ID =
                                                LATEST.EVENT_REF_ID
                                         AND SUBMITTED.PAGE_NUMBER =
                                                LATEST.PAGE_NUMBER
                                         AND SUBMITTED.YB_MODIFIED_ON =
                                                LATEST.YB_MODIFIED_ON
                                ORDER BY SUBMITTED.EVENT_REF_ID,
                                         SUBMITTED.PAGE_NUMBER)
                        HAVING COUNT (*) = SUM (SUBMITTED)
                      GROUP BY EVENT_REF_ID) SUB,
                     ODS_OWN.BOOK_EVENT BE,
                     ODS_OWN.PAGE     P
               WHERE     SUB.EVENT_REF_ID = BE.EVENT_REF_ID
                     AND BE.BOOK_EVENT_OID = P.BOOK_EVENT_OID
            GROUP BY SUB.EVENT_REF_ID) S
        ON (T.EVENT_REF_ID = S.EVENT_REF_ID)
WHEN MATCHED
THEN
   UPDATE SET
      T.YB_PAGE_SUBMITTED_DATE = S.LAST_MODIFIED,
      T.YB_PAGE_DEADLINE_SATISFIED = 'TRUE'

&


/*-----------------------------------------------*/
/* TASK No. 24 */
/* Populate Sales Rep Name in Event */

MERGE INTO b2b_own.event dst
   USING (SELECT e.first_name, e.last_name, ca.lifetouch_id,
                 p.program_oid, sp.sub_program_oid,
                 sp.sub_program_name
            FROM mart.employee e,
                 mart.current_assignment ca,
                 ods_own.program p,
                 ods_own.sub_program sp
           WHERE p.program_id = ca.program_id(+)
             AND ca.sales_rep_employee_id = e.employee_id(+)
             AND sp.program_oid = p.program_oid
             AND ca.active_ind = 'A'
             AND e.active_ind = 'A') src
   ON (    src.lifetouch_id = dst.lifetouch_id
       AND src.sub_program_name = dst.sub_program_name)
   WHEN MATCHED THEN
      UPDATE
         SET dst.sales_rep_first_name = src.first_name,
             dst.sales_rep_last_name = src.last_name

&


/*-----------------------------------------------*/
/* TASK No. 25 */
/* Populate YBPay Attributes */

merge into b2b_own.event t
using
(
select to_char(nj.jobcode) as event_ref_id
, nj.ybpayactivationdate
, nj.ybpayclosedate
, case when sysdate between nj.ybpayactivationdate and nvl(nj.ybpayclosedate, sysdate + 1) then 'A' else 'I' end as active_ind
from ods.nxtl_job nj
where nj.ybpayactivationdate is not null
or nj.ybpayclosedate is not null
) s
on (s.event_ref_id = t.event_ref_id)
when matched then update
set t.YBPAY_ACTIVE_IND = s.active_ind
, t.YBPAY_ACTIVE_DATE = s.ybpayactivationdate
, t.YBPAY_CLOSE_DATE = s.ybpayclosedate


&


/*-----------------------------------------------*/
/* TASK No. 26 */
/* Populate YBPay Attributes FOW jobs */

merge into b2b_own.event t
using
(
select e.event_ref_id
, nj.ybpayactivationdate
, nj.ybpayclosedate
, case when sysdate between nj.ybpayactivationdate and nvl(nj.ybpayclosedate, sysdate + 1) then 'A' else 'I' end as active_ind
from ods.nxtl_job nj, ods_own.apo apo, b2b_own.event e
where (nj.ybpayactivationdate is not null
or nj.ybpayclosedate is not null)
and nj.jobcode = apo.lpip_job_number
and e.apo_id = apo.apo_id
) s
on (s.event_ref_id = t.event_ref_id)
when matched then update
set t.YBPAY_ACTIVE_IND = s.active_ind
, t.YBPAY_ACTIVE_DATE = s.ybpayactivationdate
, t.YBPAY_CLOSE_DATE = s.ybpayclosedate


&


/*-----------------------------------------------*/
/* TASK No. 27 */
/* Populate YB Final Quantity Deadline */

merge into b2b_own.event t
using
(
select to_char(ch.job_number) as event_ref_id
, case when lpip_codes.date_value is not null then lpip_codes.date_value else ch.copy_due_date end as yb_final_qty_deadline
from ods.lpip_contract_header_curr ch
, ods.lpip_programs_curr p
,
(
select mc.pub_year
, substr(mc.code,1,1) as order_type
, max(mc.date_value) as date_value
, max(mc.text_value) as text_value
from ods.lpip_misc_codes mc
, mart.time t
where trunc(sysdate) = t.date_key
and mc.code_type = 'FCDEAD'
and mc.pub_year >= t.calendar_year
group by mc.pub_year
, substr(mc.code,1,1) 
) lpip_codes
where ch.program_id = p.program_id
and ch.pub_year = lpip_codes.pub_year
and p.order_type = lpip_codes.order_type
) s
on (s.event_ref_id = t.event_ref_id)
when matched then update
set t.yb_final_qty_deadline = s.yb_final_qty_deadline
where t.yb_final_qty_deadline is null


&


/*-----------------------------------------------*/
/* TASK No. 28 */
/* Populate YB_Final_QTY_Deadline where null */

UPDATE b2b_own.event
   SET yb_final_qty_deadline = final_quantity_deadline
 WHERE yb_final_qty_deadline IS NULL AND final_quantity_deadline IS NOT NULL

&


/*-----------------------------------------------*/
/* TASK No. 29 */
/* Populate YB Tracking number */

MERGE INTO B2B_OWN.EVENT d
     USING (  SELECT event_ref_id,
                     LISTAGG (tracking_no, ',') WITHIN GROUP (ORDER BY 1)
                         AS tracking_no
                FROM (SELECT DISTINCT e.event_ref_id, s.tracking_no
                        FROM ODS_OWN.EVENT        e,
                             ODS_OWN.ORDER_HEADER oh,
                             ODS_OWN.ORDER_LINE   ol,
                             ODS_OWN.SHIPMENT_LINE sl,
                             ODS_OWN.SHIPMENT     s
                       WHERE     e.EVENT_OID = oh.EVENT_OID
                             AND oh.ORDER_HEADER_OID = ol.ORDER_HEADER_OID
                             AND ol.ORDER_LINE_OID = sl.ORDER_LINE_OID
                             AND sl.SHIPMENT_OID = s.SHIPMENT_OID
                             AND oh.ORDER_TYPE IN
                                     ('YBYearbook_Order',
                                      'YBExtraBkSpec_Order',
                                      'YBCompliment_Order')
                             AND e.ship_date IS NOT NULL
                             AND e.school_year >= 2020)
            GROUP BY event_ref_id) s
        ON (d.event_ref_id = s.event_ref_id)
WHEN MATCHED
THEN
    UPDATE SET d.tracking_number = s.tracking_no

&


/*-----------------------------------------------*/
/* TASK No. 30 */
/* Populate YB Copies and Arrival Date */

MERGE INTO B2B_OWN.EVENT d
     USING (SELECT event_ref_id, e.YB_COPIES, e.YB_ARRIVAL_DATE
              FROM ods_own.event e, ods_own.apo a, ODS_OWN.SUB_PROGRAM sp
             WHERE     e.APO_OID = a.APO_OID
                   AND a.SUB_PROGRAM_OID = sp.SUB_PROGRAM_OID
                   AND a.SCHOOL_YEAR >= 2020
                   AND sp.SUB_PROGRAM_NAME = 'Yearbook') s
        ON (d.event_ref_id = s.event_ref_id)
WHEN MATCHED
THEN
    UPDATE SET
        d.yb_copies = s.yb_copies,
        d.yb_expected_arrival_date = s.yb_arrival_date

&


/*-----------------------------------------------*/
/* TASK No. 31 */
/* Populate YB Complimentary and Spec Copies */

MERGE INTO B2B_OWN.EVENT d
     USING (  SELECT e.event_ref_id,
                     SUM (
                         CASE oh.ORDER_TYPE
                             WHEN 'YBCompliment_Order' THEN ol.ordered_quantity
                         END)
                         AS comp,
                     SUM (
                         CASE oh.ORDER_TYPE
                             WHEN 'YBExtraBkSpec_Order'
                             THEN
                                 ol.ordered_quantity
                         END)
                         AS spec
                FROM ods_own.event       e,
                     ods_own.apo         a,
                     ODS_OWN.SUB_PROGRAM sp,
                     ods_own.order_header oh,
                     ods_own.order_line  ol,
                     ODS_OWN.ITEM        i
               WHERE     e.APO_OID = a.APO_OID
                     AND a.SUB_PROGRAM_OID = sp.SUB_PROGRAM_OID
                     AND e.EVENT_OID = oh.EVENT_OID
                     AND oh.ORDER_HEADER_OID = ol.ORDER_HEADER_OID
                     AND ol.ITEM_OID = i.ITEM_OID
                     AND a.SCHOOL_YEAR >= 2020
                     AND sp.SUB_PROGRAM_NAME = 'Yearbook'
                     AND i.DESCRIPTION = 'Yearbook'
                 --    AND e.EVENT_REF_ID = 'EVTTN7HZB'
            GROUP BY e.event_ref_id) s
        ON (d.event_ref_id = s.event_ref_id)
WHEN MATCHED
THEN
    UPDATE SET d.yb_complimentary_copies = s.comp, d.yb_extra_copies = s.spec

&


/*-----------------------------------------------*/
/* TASK No. 32 */
/* Populate YB Totals Copies */

UPDATE B2B_OWN.EVENT e
   SET e.YB_TOTAL_COPIES_SHIPPED =
             NVL (e.YB_COPIES, 0)
           + NVL (e.YB_COMPLIMENTARY_COPIES, 0)
           + NVL (e.YB_EXTRA_COPIES, 0)

&


/*-----------------------------------------------*/
/* TASK No. 33 */
/* Load Picture_Day Table */

insert into b2b_own.picture_day
(picture_day_oid
,event_ref_id
,booking_id
,picture_day_date
,arrival_time
,start_time
,end_time
,est_subjects
,cameras_needed
,location
,status
)
  SELECT
  pd.picture_day_oid,
  e.event_ref_id,
  CAST (NULL AS NUMBER) AS booking_id   ,
  pd.picture_day_date,
  pd.arrival_time    ,
  pd.start_time      ,
  pd.end_time        ,
  pd.est_subjects    ,
  pd.cameras_needed  ,
  pd.LOCATION        ,
  pd.status
  FROM ods_own.picture_day pd
, b2b_own.event e
  WHERE pd.event_ref_id = e.event_ref_id

&


/*-----------------------------------------------*/
/* TASK No. 34 */
/* Load Table Contact from AMS */

INSERT INTO b2b_own.contact
            (contact_oid, lifetouch_id, ams_role_name, first_name,
             last_name, work_phone, email_address, salutation,
             logged_into_lifetouch_portal, account_key, contact_key,
             title_name, source_system_name, yb_advisor_ind,
             cell_phone, fax_phone, home_phone)
   SELECT c.contact_oid, a.lifetouch_id, r.role_name, c.first_name,
          c.last_name, c.work_phone, c.email_address, c.salutation,
          CAST ('N' AS VARCHAR2 (1)) AS logged_into_lifetouch_portal,
          axr.lt_partner_key AS account_key, cxr.contact_key, c.title_name,
          ss.source_system_short_name, (CASE WHEN r.role_name = 'Yearbook Advisor' THEN 'Y' Else 'N' End ) as yb_advisor_ind, c.cell_phone, c.fax_phone, c.home_phone
     FROM ods_own.ACCOUNT a,
          ods_own.contact_role cr,
          ods_own.contact c,
          ods_own.ROLE r,
          ods_stage.ams_contact_xr cxr,
          ods_stage.ams_account_xr axr,
          ods_own.source_system ss
    WHERE 1 = 1
      AND a.account_oid = c.account_oid
      AND cr.contact_oid = c.contact_oid
      AND cr.role_oid = r.role_oid
      AND a.account_oid = axr.account_oid
      AND c.contact_oid = cxr.contact_oid
      AND c.source_system_oid = ss.source_system_oid
      AND ss.source_system_short_name = 'AMS'
      AND r.role_name IN
             ('Primary Contact', 'Picture Day Contact',
              'EDT Coordinator', 'Yearbook Advisor', 'Lead Secretary', 'Portal Contact')
      AND a.lifetouch_id IN (
             SELECT lifetouch_id
               FROM b2b_own.booking
             UNION
             SELECT lifetouch_id
               FROM b2b_own.apo
             UNION
             SELECT lifetouch_id
               FROM b2b_own.event
             UNION
             SELECT parent_lifetouch_id
               FROM b2b_own.account
             )

&


/*-----------------------------------------------*/
/* TASK No. 35 */
/* Load Table Contact from MDR */

INSERT INTO b2b_own.contact
            (contact_oid, lifetouch_id, ams_role_name, first_name,
             last_name, work_phone, email_address, salutation,
             logged_into_lifetouch_portal, account_key, contact_key,
             title_name, source_system_name, yb_advisor_ind,
             cell_phone, fax_phone, home_phone)
   SELECT c.contact_oid, a.lifetouch_id,  '.', c.first_name,
          c.last_name, c.work_phone, c.email_address, c.salutation,
          CAST ('N' AS VARCHAR2 (1)) AS logged_into_lifetouch_portal,
          0 AS account_key, 0 as contact_key, c.title_name, ss.source_system_short_name,
          (CASE WHEN r.role_name = 'Yearbook Advisor' THEN 'Y' Else 'N' End ) as yb_advisor_ind,
          null as cell_phone, null as fax_phone, null as home_phone
     FROM ods_own.ACCOUNT a,
          ods_own.contact_role cr,
          ods_own.contact c,
          ods_own.role r,
          ods_own.source_system ss
     WHERE 1=1
      AND a.account_oid = c.account_oid
      AND c.source_system_oid = ss.source_system_oid
      AND ss.source_system_short_name = 'MDR'
      AND c.contact_oid = cr.contact_oid(+)
      AND cr.role_oid = r.role_oid(+)
      AND a.lifetouch_id IN (
             SELECT lifetouch_id
               FROM b2b_own.booking
             UNION
             SELECT lifetouch_id
               FROM b2b_own.apo
             UNION
             SELECT lifetouch_id
               FROM b2b_own.event
             UNION
             SELECT parent_lifetouch_id
               FROM b2b_own.account
             )

&


/*-----------------------------------------------*/
/* TASK No. 36 */
/* Populate Logged_into_Lifetouch_Portal in Contact */

merge into b2b_own.contact t
using
(
select c.contact_oid
, c.ams_role_name 
, count(*) as host_portal_login_count
, max(activity_date) as last_host_portal_login_date
from b2b_own.contact c
, ods_own.host_portal_audit hp
, ods_own.account a
where 1=1
and c.email_address = hp.user_id
and c.lifetouch_id = a.lifetouch_id
and a.account_oid = hp.account_oid
and hp.activity_type = 'Login'
and hp.activity_date > trunc(sysdate) - 365
group by c.contact_oid
, c.ams_role_name
) s
on
( t.contact_oid = s.contact_oid
and t.ams_role_name = s.ams_role_name
)
when matched then update
set t.host_portal_login_count = s.host_portal_login_count
, t.last_host_portal_login_date = s.last_host_portal_login_date
, t.logged_into_lifetouch_portal = 'Y'

&


/*-----------------------------------------------*/
/* TASK No. 37 */
/* Populate yb_role_name in contact */

merge into b2b_own.contact t
using (
 select c.contact_oid,   substr( ur.role_name, 0, instr(ur.role_name, '-')-1) as yb_role_name from ods_own.host_portal_audit hpa, ods_own.user_account_principal uap
    , ods_own.user_role ur, ods_own.account a, b2b_own.contact c
    where hpa.user_account_principal_oid = uap.user_account_principal_oid
    and hpa.account_oid = ur.account_oid
    and ur.account_oid = a.account_oid
    and ur.user_account_principal_oid = uap.user_account_principal_oid
    and ur.scheme = 'SYIDM' and substr( ur.role_name, 0, instr(ur.role_name, '-')-1) IN ('YB_CHOICE_ADVISER', 'YB_CHOICE_GLOBAL', 'YB_CHOICE_TERRITORY')
    and c.lifetouch_id = a.lifetouch_id
    and c.email_address = hpa.user_id
    group by c.contact_oid,  ur.role_name
)s
on (s.contact_oid = t.contact_oid)
when matched then update
set t.yb_role_name = s.yb_role_name

&


/*-----------------------------------------------*/
/* TASK No. 38 */
/* load nextools_job_user */

insert into b2b_own.nextools_job_user
( job_user_id
, event_ref_id
, book_type
, year_code
, job_user_type
, role_rank
, role_code
, start_date
, last_sign_in
, sign_in_count
, is_active
, legal_accepted
, first_name
, last_name
, login_name
, email_address
, page_access_type
, account_principal_id
, invitation_id
, is_user_managed
)
select ju.jobuserid as job_user_id
, j.jobcode as event_ref_id
, b.name as book_type
, b.yearcode as year_code
, jut.description as job_user_type
, jut.rolerank as role_rank
, jut.rolecode as role_code
, ju.STARTDATE as start_date
, ju.LASTSIGNIN as last_sign_in
, ju.SIGNINCOUNT as sign_in_count
, ju.ISACTIVE as is_active
, ju.LEGALACCEPTED as legal_accepted
, ju.FIRSTNAME as first_name
, ju.LASTNAME as last_name
, ju.LOGINNAME as login_name
, ju.EMAILADDRESS as email_address
, ju.PAGEACCESSTYPE as page_access_type
, ju.ACCOUNTPRINCIPALID as account_principal_id
, ju.INVITATIONID as invitation_id
, ju.ISUSERMANAGED as is_user_managed
from ods.nxtl_book b
, ods.nxtl_job j
, ods.nxtl_jobuser ju
, ods.nxtl_jobusertype jut
, b2b_own.event e
where ju.jobid = j.jobid
and ju.active_ind = 'A'
and j.active_ind = 'A'
and to_char(j.jobcode) = e.event_ref_id
and j.bookid = b.bookid(+)
and ju.jobusertypeid = jut.jobusertypeid(+)


&


/*-----------------------------------------------*/
/* TASK No. 39 */
/* insert nextools_job_user from EVT jobs */

insert into b2b_own.nextools_job_user
( job_user_id
, event_ref_id
, book_type
, year_code
, job_user_type
, role_rank
, role_code
, start_date
, last_sign_in
, sign_in_count
, is_active
, legal_accepted
, first_name
, last_name
, login_name
, email_address
, page_access_type
, account_principal_id
, invitation_id
, is_user_managed
)
select ju.jobuserid as job_user_id
, j.jobcode as event_ref_id
, b.name as book_type
, b.yearcode as year_code
, jut.description as job_user_type
, jut.rolerank as role_rank
, jut.rolecode as role_code
, ju.STARTDATE as start_date
, ju.LASTSIGNIN as last_sign_in
, ju.SIGNINCOUNT as sign_in_count
, ju.ISACTIVE as is_active
, ju.LEGALACCEPTED as legal_accepted
, ju.FIRSTNAME as first_name
, ju.LASTNAME as last_name
, ju.LOGINNAME as login_name
, ju.EMAILADDRESS as email_address
, ju.PAGEACCESSTYPE as page_access_type
, ju.ACCOUNTPRINCIPALID as account_principal_id
, ju.INVITATIONID as invitation_id
, ju.ISUSERMANAGED as is_user_managed
from ods.nxtl_book b
, ods.nxtl_job j
, ods.nxtl_jobuser ju
, ods.nxtl_jobusertype jut
, b2b_own.apo a
where ju.jobid = j.jobid
and ju.active_ind = 'A'
and j.active_ind = 'A'
and to_char(j.jobcode) = a.lpip_job_number
and j.bookid = b.bookid(+)
and ju.jobusertypeid = jut.jobusertypeid(+)
and not exists (select 1 from b2b_own.nextools_job_user nju where nju.job_user_id = ju.jobuserid)


&


/*-----------------------------------------------*/
/* TASK No. 40 */
/* Load PDK_Orders Table */

insert into b2b_own.pdk_order
(ORDER_LINE_OID    
,shipment_line_oid        
,PDK_NUMBER                                         
,EVENT_REF_ID                              
,PART_NUMBER                                        
,SHIPDATE                                           
,QTYORDER
,QTYSHIP                                            
,TRACKING_NO                                        
,SHIP_VIA                                           
,SLIPSHEET                                          
,SLPSHTQTY                                          
,SHIPMETHOD                                         
,REPORT_SHIPPED_IND                                 
,ORDER_NO                                  
,ORDER_STATUS                                       
,ITEM_DESCRIPTION                                   
,SHIPMENT_NO                                        
,FIRST_NAME                                         
,LAST_NAME                                          
,ORDER_TYPE
, address_line1
, address_line2
, city
, state
, postal_code                                         
,COUNTRY                                            
,ITEM_ID                                            
,APO_ID                   
)
 SELECT ol.order_line_oid,
sl.shipment_line_oid,
         e.pdk_number,
         e.event_ref_id,
         (CASE WHEN i.sub_class = 'Fold' THEN ' ' ELSE i.manufacturer_item END)
            AS part_number,
         MAX (
            CASE
               WHEN s.status = '1400' THEN s.actual_shipment_date
               ELSE NULL
            END)
            AS shipdate,
         SUM (ol.ordered_quantity) AS qtyorder,
         SUM (sl.shipped_quantity) AS qtyship,
         s.tracking_no,
         s.ship_via,
         (CASE
             WHEN i.sub_class = 'SlipSheet' THEN i.manufacturer_item
             ELSE NULL
          END)
            AS slipsheet,
         SUM (
            CASE
               WHEN i.sub_class = 'SlipSheet' THEN ol.ordered_quantity
               ELSE 0
            END)
            AS slpshtqty,
         oh.scac || ' ' || oh.carrier_service_code AS shipmethod,
         MAX (CASE WHEN s.status = '1400' THEN 'Y' ELSE 'N' END)
            AS report_shipped_ind,
         oh.order_no,
         MAX (oh.order_status) order_status,
         MAX (i.description) item_description,
         MAX (
            CASE
               WHEN TRIM (s.status) <> '9000' THEN s.shipment_no
               ELSE NULL
            END)
            shipment_no,
         p.first_name AS first_name,
         p.last_name AS last_name,
         ot.order_type,
         p.address_line1,
         p.address_line2,
         p.city,
         p.state,
         p.zip_code,
         p.country,
         i.item_id,
         apo.apo_id
    FROM ods_own.order_type ot,
         ods_own.order_header oh,
         ods_own.order_line ol,
         ods_own.item i,
         ods_own.apo,
         ods_own.ACCOUNT a,
         ods_own.event e,
         ods_own.shipment_line sl,
         ods_own.shipment s,
         ods_own.person_info p,
         ods_own.data_center dc,
         b2b_own.event oe
   WHERE     (1 = 1)
         AND ot.order_type IN ('PDK_Order', 'FRN_Order', 'pFRN_Order')
         AND oh.order_type_oid = ot.order_type_oid
         AND oh.order_bucket <> 'CANCELLED'
         AND ol.order_header_oid = oh.order_header_oid
         AND i.item_oid = ol.item_oid
         AND apo.apo_oid = oh.apo_oid
         AND a.account_oid = apo.account_oid
         AND e.event_ref_id = oh.event_ref_id
         AND ol.order_line_oid = sl.order_line_oid(+)
         AND sl.shipment_oid = s.shipment_oid(+)
AND sl.shipped_quantity > 0
         AND s.person_info_oid = p.person_info_oid(+)
         AND e.event_ref_id = oe.event_ref_id
         --and p.first_name is not null
         --and p.last_name is not null
AND   oh.order_date >= ADD_MONTHS (TRUNC (SYSDATE), -12)
AND   oh.ods_create_date >= ADD_MONTHS (TRUNC (SYSDATE), -12)
AND   ol.ods_create_date >= ADD_MONTHS (TRUNC (SYSDATE), -12)
GROUP BY ol.order_line_oid,
sl.shipment_line_oid,
e.pdk_number,
         e.event_ref_id,
         (CASE
             WHEN i.sub_class = 'Fold' THEN ' '
             ELSE i.manufacturer_item
          END),
         s.tracking_no,
         s.ship_via,
         (CASE
             WHEN i.sub_class = 'SlipSheet' THEN i.manufacturer_item
             ELSE NULL
          END),
         oh.scac || ' ' || oh.carrier_service_code,
         (CASE
             WHEN i.sub_class = 'Fold' THEN ' '
             ELSE i.manufacturer_item
          END),
         oh.order_no,
         p.first_name,
         p.last_name,
         p.address_line1,
         p.address_line2,
         p.city,
         p.state,
         p.zip_code,
         ot.order_type,
         p.country,
         i.item_id,
         apo.apo_id
  HAVING SUM (ol.ordered_quantity) <> 0

&


/*-----------------------------------------------*/
/* TASK No. 41 */
/* Populate YB_APO_CONTACT */

Begin
-- User Profile
INSERT INTO b2b_own.yb_apo_contact (APO_ID,
                                    BOOK_OID,
                                    ACCOUNT_PRINCIPAL_ID,
                                    FIRST_NAME,
                                    LAST_NAME,
                                    CONTACT_EMAIL_ADDRESS,
                                    ROLE_NAME,
                                    PRIMARY_ADVISOR,
                                    COUNTRY)
    SELECT b.APO_ID,
           b.book_oid,
           uap.ACCOUNT_PRINCIPAL_ID,
           UP.FIRST_NAME,
           UP.LAST_NAME,
           UP.CONTACT_EMAIL_ADDRESS,
           SUBSTR (ur.ROLE_NAME, 6, 255)                 AS role_name,
--
--   9/10/2019 Primary Advisor is at LID level
--
--           CASE
--              WHEN UP.contact_email_address = b.advisor_email THEN 'Y'
--               ELSE ''
--           END                                           AS primary_advisor,
   NULL AS primary_advisor,
           acct.COUNTRY
      FROM ods_own.user_role               ur,
           ods_own.user_account_principal  uap,
           ods_own.user_profile            UP,
           ods_own.book                    b,
           ods_own.account acct
     WHERE     ur.USER_ACCOUNT_PRINCIPAL_OID = uap.USER_ACCOUNT_PRINCIPAL_OID
           AND uap.USER_PROFILE_OID = UP.USER_PROFILE_OID
           AND SUBSTR (ur.SCHEME, 8, 16) = b.APO_ID
and b.ACCOUNT_OID = acct.ACCOUNT_OID
           AND ur.role_name LIKE 'ROLE:%'
           AND apo_id NOT LIKE 'QA%';
-- Invitations
INSERT INTO b2b_own.yb_apo_contact (APO_ID,
                                    BOOK_OID,
                                    ACCOUNT_PRINCIPAL_ID,
                                    CONTACT_EMAIL_ADDRESS,
                                    ROLE_NAME,
                                    PRIMARY_ADVISOR,
                                    invitation_url,
                                    invitation_date,
                                    country)
    SELECT b.APO_ID,
       b.book_oid,
       uap.ACCOUNT_PRINCIPAL_ID,
       ui.PROFILE_EMAIL_ADDRESS         AS contact_email_address,
       SUBSTR (ur.ROLE_NAME, 6, 255)    AS role_name,
--       CASE
--           WHEN Ui.profile_email_address = b.advisor_email THEN 'Y'
--           ELSE ''
--       END                              AS primary_advisor,
       NULL as primary_advisor,
       CASE acct.country
           WHEN 'USA'
           THEN
                  'https://als.lifetouch.com/account-login-service/createAccount?invitationId='
               || uI.INVITATION_IDENTIFIER
           WHEN 'Canada'
           THEN
                  'https://als.lifetouch.ca/account-login-service/createAccount?invitationId='
               || uI.INVITATION_IDENTIFIER
           ELSE
               ''
       END                              AS INVITATION_URL,
       ods_own.ui.audit_create_date as invitation_date,
       acct.COUNTRY
  FROM ods_own.user_role               ur,
       ods_own.user_account_principal  uap,
       ODS_OWN.USER_INVITATION         ui,
       ods_own.book                    b,
       ods_own.account                 acct
 WHERE     ur.USER_ACCOUNT_PRINCIPAL_OID = uap.USER_ACCOUNT_PRINCIPAL_OID
       AND uap.USER_ACCOUNT_PRINCIPAL_OID = ui.USER_ACCOUNT_PRINCIPAL_OID
       AND SUBSTR (ur.SCHEME, 8, 16) = b.APO_ID
       AND b.ACCOUNT_OID = acct.ACCOUNT_OID
       AND ur.role_name LIKE 'ROLE:%'
       AND apo_id NOT LIKE 'QA%';
-- Last Login
MERGE INTO b2b_own.yb_apo_contact d
     USING (  SELECT al.book_oid,
                     al.ACCOUNT_PRINCIPAL_ID,
                     MAX (al.activity_date)     AS last_login
                FROM ODS_OWN.YB_WEBSITE_ACTIVITY_LOG al
               WHERE al.ACTIVITY_TYPE = 'ACCESS_YEARBOOK'
            GROUP BY al.book_oid, al.ACCOUNT_PRINCIPAL_ID) s
        ON (    d.book_oid = s.book_oid
            AND d.ACCOUNT_PRINCIPAL_ID = s.ACCOUNT_PRINCIPAL_ID)
WHEN MATCHED
THEN
    UPDATE SET d.last_login = s.last_login;
END;


&


/*-----------------------------------------------*/
/* TASK No. 42 */
/* Update YB_APO_CONTACT.Login_count */

MERGE INTO B2B_OWN.YB_APO_CONTACT t
     USING (  SELECT c.ACCOUNT_PRINCIPAL_ID, c.APO_ID, COUNT (*) AS login_count
                FROM B2B_OWN.YB_APO_CONTACT         c,
                     ods_own.book                   b,
                     ods_own.yb_website_activity_log l,
                     ods_own.apo                    a
               WHERE     c.ACCOUNT_PRINCIPAL_ID = l.ACCOUNT_PRINCIPAL_ID
                     AND c.APO_ID = a.APO_ID
                     AND a.APO_OID = b.APO_OID
                     AND l.BOOK_OID = b.BOOK_OID
                     AND l.ACTIVITY_TYPE = 'ACCESS_YEARBOOK'
            GROUP BY c.ACCOUNT_PRINCIPAL_ID, c.APO_ID) s
        ON (    t.ACCOUNT_PRINCIPAL_ID = s.ACCOUNT_PRINCIPAL_ID
            AND t.apo_id = s.apo_id)
WHEN MATCHED
THEN
    UPDATE SET t.login_count = s.login_count

&


/*-----------------------------------------------*/
/* TASK No. 43 */
/* Populate YB_LID_CONTACT */

INSERT INTO B2B_OWN.YB_LID_CONTACT (LIFETOUCH_ID,
                                    ACCOUNT_PRINCIPAL_ID,
                                    FIRST_NAME,
                                    LAST_NAME,
                                    CONTACT_EMAIL_ADDRESS,
                                    ROLE_NAME,
                                    PRIMARY_ADVISOR,
                                    COUNTRY)
    SELECT DISTINCT acct.LIFETOUCH_ID,
           uap.ACCOUNT_PRINCIPAL_ID,
           UP.FIRST_NAME,
           UP.LAST_NAME,
           UP.CONTACT_EMAIL_ADDRESS,
           'YEARBOOK_ADVISER'     AS ROLE_NAME,
           'Y',
           acct.COUNTRY
      FROM ods_own.apo                     a,
           ods_own.account                 acct,
           ods_own.user_role               ur,
           ods_own.USER_ACCOUNT_PRINCIPAL  uap,
           ods_own.USER_PROFILE            UP
     WHERE     a.account_oid = acct.account_oid
           AND acct.account_oid = ur.account_oid
           AND ur.USER_ACCOUNT_PRINCIPAL_OID = uap.USER_ACCOUNT_PRINCIPAL_OID
           AND uap.USER_PROFILE_OID = UP.USER_PROFILE_OID
           AND ur.ROLE_NAME LIKE 'YEARBOOK_ADVISER%'
           AND ur.SCHEME = 'YEARBOOK'
           AND a.APO_OID IN (SELECT apo_oid FROM ods_own.book)

&


/*-----------------------------------------------*/
/* TASK No. 44 */
/* Update YB_LID_Contact Last_Login */

MERGE INTO b2b_own.yb_lid_contact d
     USING (  SELECT acct.LIFETOUCH_ID,
                     al.ACCOUNT_PRINCIPAL_ID,
                     MAX (al.activity_date)     AS last_login
                FROM ODS_OWN.YB_WEBSITE_ACTIVITY_LOG al,
                     ods_own.book                   b,
                     ods_own.account                acct
               WHERE     al.BOOK_OID = b.BOOK_OID
                     AND b.ACCOUNT_OID = acct.ACCOUNT_OID
                     AND al.ACTIVITY_TYPE = 'ACCESS_YEARBOOK'
            GROUP BY acct.LIFETOUCH_ID, al.ACCOUNT_PRINCIPAL_ID) s
        ON (    d.lifetouch_id = s.lifetouch_id
            AND d.ACCOUNT_PRINCIPAL_ID = s.ACCOUNT_PRINCIPAL_ID)
WHEN MATCHED
THEN
    UPDATE SET d.last_login = s.last_login

&


/*-----------------------------------------------*/
/* TASK No. 45 */
/* Update YB_LID_Contact - Login_Count */

MERGE INTO B2B_OWN.YB_LID_CONTACT t
     USING (  SELECT c.ACCOUNT_PRINCIPAL_ID, a.lifetouch_id, COUNT (*) AS login_count
                FROM B2B_OWN.YB_LID_CONTACT         c,
                     ods_own.book                   b,
                     ods_own.yb_website_activity_log l,
                     ods_own.apo                    a
               WHERE     c.ACCOUNT_PRINCIPAL_ID = l.ACCOUNT_PRINCIPAL_ID
                     AND c.LIFETOUCH_ID = a.LIFETOUCH_ID
                     AND a.APO_OID = b.APO_OID
                     AND l.BOOK_OID = b.BOOK_OID
                     AND l.ACTIVITY_TYPE = 'ACCESS_YEARBOOK'
            GROUP BY c.ACCOUNT_PRINCIPAL_ID, a.lifetouch_id) s
        ON (    t.ACCOUNT_PRINCIPAL_ID = s.ACCOUNT_PRINCIPAL_ID
            AND t.lifetouch_id = s.lifetouch_id)
WHEN MATCHED
THEN
    UPDATE SET t.login_count = s.login_count

&


/*-----------------------------------------------*/
/* TASK No. 46 */
/* Insert Invitations into YB_LID_Contact */

INSERT INTO B2B_OWN.YB_LID_CONTACT (lifetouch_id,
                                    ACCOUNT_PRINCIPAL_ID,
                                    contact_email_address,
                                    role_name,
                                    primary_advisor,
                                    country,
                                    invitation_date,
                                    invitation_url)
    SELECT acct.LIFETOUCH_ID,
           uap.ACCOUNT_PRINCIPAL_ID,
           ui.PROFILE_EMAIL_ADDRESS,
           'YEARBOOK_ADVISOR'
               AS ROLE_NAME,
           'Y'
               AS primary_advisor,
           acct.COUNTRY,
           ui.AUDIT_CREATE_DATE
               AS invitation_date,
           CASE acct.country
               WHEN 'USA'
               THEN
                      'https://als.lifetouch.com/account-login-service/createAccount?invitationId='
                   || uI.INVITATION_IDENTIFIER
               WHEN 'Canada'
               THEN
                      'https://als.lifetouch.ca/account-login-service/createAccount?invitationId='
                   || uI.INVITATION_IDENTIFIER
               ELSE
                   ''
           END
               AS INVITATION_URL
      FROM ODS_OWN.USER_INVITATION         ui,
           ODS_OWN.USER_ROLE               ur,
           ODS_OWN.USER_ACCOUNT_PRINCIPAL  uap,
           ods_own.account                 acct
     WHERE     ui.USER_ACCOUNT_PRINCIPAL_OID = ur.USER_ACCOUNT_PRINCIPAL_OID
           AND ur.USER_ACCOUNT_PRINCIPAL_OID = uap.USER_ACCOUNT_PRINCIPAL_OID
           AND ur.ACCOUNT_OID = acct.ACCOUNT_OID
           AND ur.SCHEME = 'YEARBOOK'
           AND ur.ROLE_NAME LIKE 'YEARBOOK_ADVISER%'

&


/*-----------------------------------------------*/
/* TASK No. 47 */
/* Load Book with Cover data */

MERGE INTO B2B_OWN.BOOK d
     USING (  SELECT be.EVENT_REF_ID,
                     b.BOOK_OID,
                     b.YEARBOOK_NAME,
                     c.STATUS
                         AS cover_status,
                     MAX (cca.PROOF_UPLOAD_DATE)
                         AS cover_proof_upload_date,
                     COUNT (*)
                         AS cover_proof_number
                FROM ODS_OWN.CUSTOM_COVER_ASSET cca,
                     ODS_OWN.BOOK_ASSETS       ba,
                     ODS_OWN.BOOK              b,
                     ODS_OWN.BOOK_EVENT        be,
                     ODS_OWN.COVER             c
               WHERE     cca.BOOK_ASSETS_OID = ba.BOOK_ASSETS_OID
                     AND ba.BOOK_OID = b.BOOK_OID
                     AND b.BOOK_OID = be.BOOK_OID
                     AND b.BOOK_OID = c.BOOK_OID
                     AND ba.ASSET_TYPE = 'COVER_PROOF'
            GROUP BY be.EVENT_REF_ID,
                     b.book_oid,
                     b.YEARBOOK_NAME,
                     c.STATUS) s
        ON (s.book_oid = d.book_oid)
WHEN MATCHED
THEN
    UPDATE SET d.event_ref_id = s.event_ref_id,
               d.yearbook_name = s.yearbook_name,
               d.cover_status = s.cover_status,
               d.cover_proof_upload_date = s.cover_proof_upload_date,
               d.cover_proof_number = s.cover_proof_number
WHEN NOT MATCHED
THEN
    INSERT     (EVENT_REF_ID,
                BOOK_OID,
                YEARBOOK_NAME,
                COVER_STATUS,
                COVER_PROOF_UPLOAD_DATE,
                COVER_PROOF_NUMBER)
        VALUES (s.EVENT_REF_ID,
                s.BOOK_OID,
                s.YEARBOOK_NAME,
                s.COVER_STATUS,
                s.COVER_PROOF_UPLOAD_DATE,
                s.COVER_PROOF_NUMBER)

&


/*-----------------------------------------------*/
/* TASK No. 48 */
/* Load Endsheet */

INSERT INTO b2b_own.endsheet (ENDSHEET_OID,
                              BOOK_OID,
                              ENDSHEET_PROOF_UPLOAD_DATE,
                              ENDSHEET_PROOF_NUMBER,
                              ENDSHEET_SIDE,
                              ENDSHEET_STATUS)
    (  SELECT e.ENDSHEET_OID,
              b.BOOK_OID,
              MAX (cea.PROOF_UPLOAD_DATE)     AS endsheet_proof_upload_date,
              COUNT (*)                       AS endsheet_proof_number,
              e.SIDE                          AS endsheet_side,
              e.STATUS                        AS endsheet_status
         FROM ods_own.book                 b,
              ODS_OWN.BOOK_ASSETS          ba,
              ODS_OWN.CUSTOM_ENDSHEET_ASSET cea,
              ODS_OWN.ENDSHEET             e
        WHERE     b.BOOK_OID = ba.BOOK_OID
              AND ba.BOOK_ASSETS_OID = cea.BOOK_ASSETS_OID
              AND cea.ENDSHEET_OID = e.ENDSHEET_OID
              AND ba.ASSET_TYPE = 'ENDSHEET_PROOF'
     GROUP BY e.ENDSHEET_OID,
              b.BOOK_OID,
              e.SIDE,
              e.STATUS)

&


/*-----------------------------------------------*/
/* TASK No. 49 */
/* Load Book with Endsheet */

MERGE INTO b2b_own.book d
     USING (SELECT e.BOOK_OID, e.EVENT_REF_ID
              FROM B2B_OWN.ENDSHEET e, ods_own.book_event be, ods_own.event e
             WHERE e.BOOK_OID = be.BOOK_OID AND be.EVENT_OID = e.EVENT_OID) s
        ON (s.book_oid = d.book_oid)
WHEN NOT MATCHED
THEN
    INSERT     (book_oid, event_ref_id)
        VALUES (s.book_oid, s.event_ref_id)


&


/*-----------------------------------------------*/
