/* TASK No. 1 */
/* Drop flow table */

BEGIN  
   EXECUTE IMMEDIATE 'drop table RAX_APP_USER.I$_HEADER_CHARGE';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 

&


/*-----------------------------------------------*/
/* TASK No. 2 */
/* Create flow table I$ */

create table RAX_APP_USER.I$_HEADER_CHARGE
(
	HEADER_CHARGE_OID		NUMBER NULL,
	ODS_MODIFY_DATE		DATE NULL,
	EST_TAX_RATE		NUMBER NULL,
	EST_PRETAX_AMOUNT		NUMBER NULL,
	EST_TAX_AMOUNT		NUMBER NULL,
	IND_UPDATE		CHAR(1)
)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* Insert flow into I$ table */

/* DETECTION_STRATEGY = NOT_EXISTS */
 


  

BEGIN  
   EXECUTE IMMEDIATE 'insert into	RAX_APP_USER.I$_HEADER_CHARGE
						(
							HEADER_CHARGE_OID,
							EST_TAX_RATE,
							EST_PRETAX_AMOUNT,
							EST_TAX_AMOUNT,
							IND_UPDATE
						)
						select 
						HEADER_CHARGE_OID,
							EST_TAX_RATE,
							EST_PRETAX_AMOUNT,
							EST_TAX_AMOUNT,
							IND_UPDATE
						from (


						select 	 
							
							HEADER_CHARGE_EST_TAX.HEADER_CHARGE_OID HEADER_CHARGE_OID,
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
						when NVL(HEADER_CHARGE.tax_inclusive,''N'') != ''Y''
						then	case 
							when NVL(HEADER_CHARGE_EST_TAX.tax_amount,0) != 0  and HEADER_CHARGE.charge != 0
							then case
								when HEADER_CHARGE_EST_TAX.tax_amount < (HEADER_CHARGE_EST_TAX.tax_rate * HEADER_CHARGE.charge) - .01
								then (HEADER_CHARGE_EST_TAX.tax_amount / (HEADER_CHARGE.charge))
								else HEADER_CHARGE_EST_TAX.tax_rate
								end
							else 0
							end
							else
							case 
							when NVL(HEADER_CHARGE_EST_TAX.tax_amount,0) != 0  and HEADER_CHARGE.charge != 0
							then case
								when HEADER_CHARGE_EST_TAX.tax_amount < (HEADER_CHARGE_EST_TAX.tax_rate * (HEADER_CHARGE.charge/(1 + HEADER_CHARGE_EST_TAX.tax_rate))) - .01
								then (HEADER_CHARGE_EST_TAX.tax_amount / ((HEADER_CHARGE.charge) / (1 + HEADER_CHARGE_EST_TAX.tax_rate)))
								else HEADER_CHARGE_EST_TAX.tax_rate
								end
							else 0
							end
						end EST_TAX_RATE,
							HEADER_CHARGE_EST_TAX.PRETAX_SUBTOTAL EST_PRETAX_AMOUNT,
							HEADER_CHARGE_EST_TAX.TAX_AMOUNT EST_TAX_AMOUNT,

							''I'' IND_UPDATE

						from	SRM_OWN.HEADER_CHARGE_EST_TAX   HEADER_CHARGE_EST_TAX, ODS_OWN.HEADER_CHARGE   HEADER_CHARGE
						where	(1=1)
						And (HEADER_CHARGE_EST_TAX.HEADER_CHARGE_OID=HEADER_CHARGE.HEADER_CHARGE_OID)
						And (HEADER_CHARGE_EST_TAX.STATUS = ''Processed'')




						) S
						where NOT EXISTS 
							( select 1 from ODS_OWN.HEADER_CHARGE T
							where	T.HEADER_CHARGE_OID	= S.HEADER_CHARGE_OID 
								and ((T.EST_TAX_RATE = S.EST_TAX_RATE) or (T.EST_TAX_RATE IS NULL and S.EST_TAX_RATE IS NULL)) and
								((T.EST_PRETAX_AMOUNT = S.EST_PRETAX_AMOUNT) or (T.EST_PRETAX_AMOUNT IS NULL and S.EST_PRETAX_AMOUNT IS NULL)) and
								((T.EST_TAX_AMOUNT = S.EST_TAX_AMOUNT) or (T.EST_TAX_AMOUNT IS NULL and S.EST_TAX_AMOUNT IS NULL))
								)';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END; 

  
  

  

 


&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* Recycle previous errors */

BEGIN  
   EXECUTE IMMEDIATE 'insert into RAX_APP_USER.I$_HEADER_CHARGE
						(
							HEADER_CHARGE_OID,
							EST_TAX_RATE,
							EST_PRETAX_AMOUNT,
							EST_TAX_AMOUNT,
							IND_UPDATE
						)
						select 	HEADER_CHARGE_OID,
							EST_TAX_RATE,
							EST_PRETAX_AMOUNT,
							EST_TAX_AMOUNT,
							''I''	IND_UPDATE
						from 	RAX_APP_USER.E$_HEADER_CHARGE
						where 	(HEADER_CHARGE_OID, ROWID)  in ( 
								select	HEADER_CHARGE_OID,MAX(ROWID)
								from RAX_APP_USER.E$_HEADER_CHARGE E
								where not exists (select 1  
									from	RAX_APP_USER.I$_HEADER_CHARGE T
									where	T.HEADER_CHARGE_OID = E.HEADER_CHARGE_OID)
								and	E.ODI_ORIGIN	= ''(309001)ODS_Project. UPDATE_ODS_HEADER_CHARGE_TAX_INT''
								and	E.ODI_ERR_TYPE	= ''F''
								group by E.HEADER_CHARGE_OID
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
/* Create Index on flow table */

create index	RAX_APP_USER.I$_HEADER_CHARGE_IDX
on		RAX_APP_USER.I$_HEADER_CHARGE (HEADER_CHARGE_OID)
NOLOGGING

&


/*-----------------------------------------------*/
/* TASK No. 6 */
/* Analyze integration table */



begin
    dbms_stats.gather_table_stats(
	ownname => 'RAX_APP_USER',
	tabname => 'I$_HEADER_CHARGE',
	estimate_percent => dbms_stats.auto_sample_size
    );
end;



&


/*-----------------------------------------------*/
/* TASK No. 7 */
/* Flag rows for update */

/* DETECTION_STRATEGY = NOT_EXISTS */


update	RAX_APP_USER.I$_HEADER_CHARGE
set	IND_UPDATE = 'U'
where	(HEADER_CHARGE_OID)
	in	(
		select	HEADER_CHARGE_OID
		from	ODS_OWN.HEADER_CHARGE
		)



&


/*-----------------------------------------------*/
/* TASK No. 8 */
/* Flag useless rows */

/* DETECTION_STRATEGY = NOT_EXISTS */

/* Command skipped due to chosen DETECTION_STRATEGY */



/*-----------------------------------------------*/
/* TASK No. 9 */
/* Update existing rows */

/* DETECTION_STRATEGY = NOT_EXISTS */
update	ODS_OWN.HEADER_CHARGE T
set 	
	(
	T.EST_TAX_RATE,
	T.EST_PRETAX_AMOUNT,
	T.EST_TAX_AMOUNT
	) =
		(
		select	S.EST_TAX_RATE,
			S.EST_PRETAX_AMOUNT,
			S.EST_TAX_AMOUNT
		from	RAX_APP_USER.I$_HEADER_CHARGE S
		where	T.HEADER_CHARGE_OID	=S.HEADER_CHARGE_OID
	    	 )
	,   T.ODS_MODIFY_DATE = sysdate

where	(HEADER_CHARGE_OID)
	in	(
		select	HEADER_CHARGE_OID
		from	RAX_APP_USER.I$_HEADER_CHARGE
		where	IND_UPDATE = 'U'
		)




&


/*-----------------------------------------------*/
/* TASK No. 10 */
/* Commit transaction */

/*commit*/


/*-----------------------------------------------*/
/* TASK No. 11 */
/* Update_HEADER_Charge_Status */

BEGIN  
   EXECUTE IMMEDIATE 'merge into srm_own.header_charge_est_tax T
						using
							(select
								a.HEADER_CHARGE_OID--,a.*,b.*
							from
								srm_own.header_charge_est_tax a, ODS_OWN.HEADER_CHARGE   b
							where    (1=1)
								And (a.status=''Processed'')
								And (a.HEADER_CHARGE_OID = b.HEADER_CHARGE_OID)
								And (a.TAX_AMOUNT = nvl(b.EST_TAX_AMOUNT,-1))
								And (a.PRETAX_SUBTOTAL = nvl(b.EST_PRETAX_AMOUNT,-1))
						and rownum <= 1000000
							) S
						on    (
							T.HEADER_CHARGE_OID=S.HEADER_CHARGE_OID
							)
						when matched
						then update set
							T.updated_by = ''UPDATE_ODS_HEADER_CHARGE_TAX_INT'',
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
