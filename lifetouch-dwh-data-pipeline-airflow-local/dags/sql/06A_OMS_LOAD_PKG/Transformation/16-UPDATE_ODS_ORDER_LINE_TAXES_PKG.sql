/* TASK No. 1 */
/* Set vID */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */
/* Drop flow table */

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_ORDER_LINE255001';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_ORDER_LINE255001
(
	ORDER_LINE_OID	NUMBER NULL,
	EST_TAX_AMOUNT	NUMBER NULL,
	ODS_MODIFY_DATE	DATE NULL,
	EST_TAX_RATE	NUMBER NULL,
	EST_PRETAX_AMOUNT	NUMBER NULL
	,IND_UPDATE		char(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  

BEGIN  
   EXECUTE IMMEDIATE 'insert into	RAX_APP_USER.I$_ORDER_LINE255001
						(
							ORDER_LINE_OID,
							EST_TAX_AMOUNT,
							EST_TAX_RATE,
							EST_PRETAX_AMOUNT,
							IND_UPDATE
						)
						select 
						ORDER_LINE_OID,
							EST_TAX_AMOUNT,
							EST_TAX_RATE,
							EST_PRETAX_AMOUNT,
							IND_UPDATE
						from (


						select 	 
							
							OLET.ORDER_LINE_OID ORDER_LINE_OID,
							OLET.TAX_AMOUNT EST_TAX_AMOUNT,
							/*
						This code would normally just move the estimated tax rate from ORDER_LINE_EST_TAX to ORDER_LINE.  However, in the case where the 
						taxable amount is different than the order amount (this happens with Illinois orders), then we want to recalculate the tax rate so 
						that it reflects what the tax rate would be against the entire order.
									Order Amount           $100
									Taxable Amount         $10
									Tax Amount             $0.80
									Original Tax Rate      0.08
									Recalculated Tax Rate  0.008  ($0.80 / $100)
						*/
						case 
						when NVL(ORDER_LINE.tax_inclusive_ind,''N'') != ''Y''
						then	case 
							when NVL(OLET.tax_amount,0) != 0
							then case
								when OLET.tax_amount < (OLET.tax_rate * (ORDER_LINE.ordered_quantity * ORDER_LINE.list_price)) - .01
								then (OLET.tax_amount / (ORDER_LINE.ordered_quantity * ORDER_LINE.list_price))
								else OLET.tax_rate
								end
							else 0
							end
							else
							case 
							when NVL(OLET.tax_amount,0) != 0
							then case
								when OLET.tax_amount < (OLET.tax_rate * ((ORDER_LINE.ordered_quantity * ORDER_LINE.list_price)/(1 + OLET.tax_rate))) - .01
								then (OLET.tax_amount / ((ORDER_LINE.ordered_quantity * ORDER_LINE.list_price) / (1 + OLET.tax_rate)))
								else OLET.tax_rate
								end
							else 0
							end
						end EST_TAX_RATE,
							OLET.PRETAX_SUBTOTAL EST_PRETAX_AMOUNT,

							''I'' IND_UPDATE

						from	SRM_OWN.ORDER_LINE_EST_TAX   OLET, ODS_OWN.ORDER_LINE   ORDER_LINE
						where	(1=1)
						And (OLET.ORDER_LINE_OID=ORDER_LINE.ORDER_LINE_OID)
						And (OLET.STATUS = ''Processed'')
						And (OLET.LAST_UPDATED >= sysdate -2)
						And (OLET.ORDER_LINE_OID NOT IN (1019316667,
						1040942147,
						1040439814,
						1040465690,
						1040439777,
						1040439788,
						1040834832,
						1040835021,
						1040835045,
						1040835062,
						1040835017,
						1040834454,
						1040741534,
						1040741751,
						1040741655,
						1040741592,
						1040741816,
						1040691045,
						1040691297,
						1040690888,
						1040691191,
						1040690488,
						1040691298,
						1040690473,
						1040690760,
						1040690604,
						1040679355,
						1040596636,
						1040596929,
						1040596504,
						1040510245,
						1040528573,
						1040528469,
						1040528730,
						1040528408,
						1040515007,
						1040526758,
						1040784029,
						1040784527,
						1040784035,
						1040895844,
						1040895956,
						1542053097
						))

						) S
						where NOT EXISTS 
							( select 1 from ODS_OWN.ORDER_LINE T
							where	T.ORDER_LINE_OID	= S.ORDER_LINE_OID 
								and ((T.EST_TAX_AMOUNT = S.EST_TAX_AMOUNT) or (T.EST_TAX_AMOUNT IS NULL and S.EST_TAX_AMOUNT IS NULL)) and
								((T.EST_TAX_RATE = S.EST_TAX_RATE) or (T.EST_TAX_RATE IS NULL and S.EST_TAX_RATE IS NULL)) and
								((T.EST_PRETAX_AMOUNT = S.EST_PRETAX_AMOUNT) or (T.EST_PRETAX_AMOUNT IS NULL and S.EST_PRETAX_AMOUNT IS NULL))
								)';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;


  
  

  



&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Recycle previous errors */

BEGIN  
   EXECUTE IMMEDIATE 'insert into RAX_APP_USER.I$_ORDER_LINE255001
						(
							ORDER_LINE_OID,
							EST_TAX_AMOUNT,
							EST_TAX_RATE,
							EST_PRETAX_AMOUNT,
							IND_UPDATE
						)
						select	DISTINCT ORDER_LINE_OID,
							EST_TAX_AMOUNT,
							EST_TAX_RATE,
							EST_PRETAX_AMOUNT,
							''I'' IND_UPDATE
						from	RAX_APP_USER.E$_ORDER_LINE255001 E
						where 	not exists (
								select	''?''
								from	RAX_APP_USER.I$_ORDER_LINE255001 T
								where			T.ORDER_LINE_OID=E.ORDER_LINE_OID
								)
						and	E.ODI_ORIGIN	= ''(255001)ODS_Project.UPDATE_ODS_ORDER_LINE_TAX_INT''
						and	E.ODI_ERR_TYPE	= ''F''';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Create Index on flow table */

create index	RAX_APP_USER.I$_ORDER_LINE_IDX255001
on		RAX_APP_USER.I$_ORDER_LINE255001 (ORDER_LINE_OID)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Merge Rows */

merge into	ODS_OWN.ORDER_LINE T
using	RAX_APP_USER.I$_ORDER_LINE255001 S
on	(
		T.ORDER_LINE_OID=S.ORDER_LINE_OID
	)
when matched
then update set
	T.EST_TAX_AMOUNT	= S.EST_TAX_AMOUNT,
	T.EST_TAX_RATE	= S.EST_TAX_RATE,
	T.EST_PRETAX_AMOUNT	= S.EST_PRETAX_AMOUNT
	,   T.ODS_MODIFY_DATE	= sysdate
when not matched
then insert
	(
	T.EST_TAX_AMOUNT,
	T.EST_TAX_RATE,
	T.EST_PRETAX_AMOUNT
	
	)
values
	(
	S.EST_TAX_AMOUNT,
	S.EST_TAX_RATE,
	S.EST_PRETAX_AMOUNT
	
	)

&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 9 */
/* Update_OLET_Status */

BEGIN  
   EXECUTE IMMEDIATE 'merge into srm_own.order_line_est_tax T
						using
						(select
								a.ORDER_LINE_OID--,a.*,b.*
							from
								srm_own.order_line_est_tax a, ODS_OWN.ORDER_LINE   b
							where    (1=1)
								And (a.status=''Processed'')
								And (a.ORDER_LINE_OID = b.ORDER_LINE_OID)
								And (a.TAX_AMOUNT = NVL(b.EST_TAX_AMOUNT,-1))
								And (a.PRETAX_SUBTOTAL = NVL(b.EST_PRETAX_AMOUNT,-1))
							) S
						on    (
							T.ORDER_LINE_OID=S.ORDER_LINE_OID
							)
						when matched
						then update set
							T.updated_by = ''UPDATE_ODS_ORDER_LINE_TAX_INT'',
							T.status = ''Complete'',
							T.last_updated = SYSDATE';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 

&


/*-----------------------------------------------*/
