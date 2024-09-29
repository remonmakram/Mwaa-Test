/* TASK No. 1 */
/* merge into ODS_OWN.EVENT t */

merge into ODS_OWN.EVENT t
using (
select
    E.EVENT_OID
    ,case 
        when sp.SUB_PROGRAM_NAME='Yearbook' then 0
        when apo.SCHOOL_YEAR >= 2015 and TS.END_DATE <> to_date('20160624','YYYYMMDD') and apo.ODS_CREATE_DATE >= TS.BEGIN_DATE and apo.ODS_CREATE_DATE <= TS.END_DATE and  TS.TAX_INCLUSIVE_FLAG is not null THEN TS.TAX_INCLUSIVE_FLAG 
        when apo.SCHOOL_YEAR <= 2016 and TS.END_DATE = to_date('20160624','YYYYMMDD')  /*and apo.ODS_CREATE_DATE >= TS.BEGIN_DATE and apo.ODS_CREATE_DATE <= TS.END_DATE*/ and TS.TAX_INCLUSIVE_FLAG is not null THEN TS.TAX_INCLUSIVE_FLAG 
        else nvl(apo_ti.MIN_TAX_INCLUSIVE,1)
    end NEW_PRICES_TAX_INCLUSIVE
--,acc.LIFETOUCH_ID
--,apo.ODS_CREATE_DATE
--,TS.BEGIN_DATE
--,TS.END_DATE
--,TS.TAX_INCLUSIVE_FLAG  TS_TAX_INCLUSIVE_FLAG
--    ,E.PRICES_TAX_INCLUSIVE 
--    ,apo_ti.apo_oid
--    ,E.EVENT_REF_ID
--    ,apo_ti.MIN_TAX_INCLUSIVE
--    ,ACC.STATE
--    ,APO.SCHOOL_YEAR
--    ,sp.SUB_PROGRAM_NAME
--    ,e.*
from
    ODS_OWN.EVENT e
    ,(select
        APO.APO_OID
        ,min(PS.TAX_INCLUSIVE) MIN_TAX_INCLUSIVE
        ,max(PS.TAX_INCLUSIVE) MAX_TAX_INCLUSIVE
    from
        ODS_OWN.APO apo
        ,ODS_OWN.PRICE_PROGRAM pp
        ,ODS_OWN.PP_PRICE_SET ppx
        ,ODS_OWN.PRICE_SET ps
        ,ODS_OWN.PRICE_SET_SKU pss
    where (1=1)
        and APO.PRICE_PROGRAM_OID=PP.PRICE_PROGRAM_OID
        and PPX.PRICE_PROGRAM_OID=PP.PRICE_PROGRAM_OID
        and PS.PRICE_SET_OID=PPX.PRICE_SET_OID
        and PSS.PRICE_SET_OID=PS.PRICE_SET_OID
        and PSS.AMOUNT <> 0
    group by 
         APO.APO_OID
    ) apo_ti
    ,ODS_OWN.APO apo
    ,ODS_OWN.ACCOUNT acc
    ,RAX_APP_USER.PS_TAX_STATE_STG TS
    ,ODS_OWN.SUB_PROGRAM sp
where (1=1)
    and APO.ACCOUNT_OID=ACC.ACCOUNT_OID
    and APO.SUB_PROGRAM_OID=SP.SUB_PROGRAM_OID
    and acc.STATE = TS.STATE_CODE(+)
    and E.APO_OID=APO_TI.APO_OID(+)
    and E.APO_OID=APO.APO_OID
    and APO.SCHOOL_YEAR >= 2015
    and E.PRICES_TAX_INCLUSIVE <> 
    case 
        when sp.SUB_PROGRAM_NAME='Yearbook' then 0
        when apo.SCHOOL_YEAR >= 2015 and TS.END_DATE <> to_date('20160624','YYYYMMDD') and apo.ODS_CREATE_DATE >= TS.BEGIN_DATE and apo.ODS_CREATE_DATE <= TS.END_DATE and  TS.TAX_INCLUSIVE_FLAG is not null THEN TS.TAX_INCLUSIVE_FLAG 
        when apo.SCHOOL_YEAR <= 2016 and TS.END_DATE = to_date('20160624','YYYYMMDD')  /*and apo.ODS_CREATE_DATE >= TS.BEGIN_DATE and apo.ODS_CREATE_DATE <= TS.END_DATE*/ and TS.TAX_INCLUSIVE_FLAG is not null THEN TS.TAX_INCLUSIVE_FLAG 
        else nvl(apo_ti.MIN_TAX_INCLUSIVE,1)
    end
) s
on (t.EVENT_OID = s.EVENT_OID)
when matched then update set
t.PRICES_TAX_INCLUSIVE = s.NEW_PRICES_TAX_INCLUSIVE
,T.ODS_MODIFY_DATE = sysdate


&


/*-----------------------------------------------*/
