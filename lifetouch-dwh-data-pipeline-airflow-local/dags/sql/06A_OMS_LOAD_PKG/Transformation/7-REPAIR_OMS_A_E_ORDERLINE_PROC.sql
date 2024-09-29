/* TASK No. 1 */
/* Fixup e$_order_line (order_header_oid) */

BEGIN  
   EXECUTE IMMEDIATE 'merge into E$_ORDER_LINE c 
                        using (
                        select c.order_header_oid,ODI_PK         
                        from 
                        E$_ORDER_LINE a
                        , ods_stage.OMS_ORDER_LINE_XR b
                        , ods_stage.OMS_ORDER_HEADER_XR c
                        where (1=1) 
                        and a.order_line_oid = b.order_line_oid 
                        and b.order_header_key = c.order_header_key(+)
                        and c.order_header_oid <> nvl(a.order_header_oid,-1)
                        --and A.ODI_ERR_MESS like ''%The column ORDER_HEADER_OID cannot be null.''
                        ) s on (c.ODI_PK = s.ODI_PK)
                        when matched then update
                        set 
                        c.order_header_oid = s.order_header_oid';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 2 */
/* Fixup E$_ORDER_LINE (ITEM_OID) */

BEGIN  
   EXECUTE IMMEDIATE 'merge into E$_ORDER_LINE c 
                        using (
                        select c.ITEM_oid,ODI_PK         
                        from 
                        E$_ORDER_LINE a
                        , ods_stage.OMS_ORDER_LINE_XR b 
                        , ods_own.ITEM c
                        where (1=1) 
                        and a.order_line_oid = b.order_line_oid 
                        and b.ITEM_KEY = c.ITEM_ID(+)
                        and c.ITEM_oid <> nvl(a.ITEM_oid,-1)
                        --and a.odi_err_mess like ''%The column ITEM_OID cannot be null.''
                        ) s on (c.ODI_PK = s.ODI_PK)
                        when matched then update
                        set 
                        c.ITEM_oid = s.ITEM_oid';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* Fix E$_ORDER_LINE (BUNDLE_PARENT_ORDER_LINE_OID) */

BEGIN  
   EXECUTE IMMEDIATE 'merge into E$_ORDER_LINE c 
                        using (
                            select 
                                c.ORDER_LINE_OID BUNDLE_PARENT_ORDER_LINE_OID
                                ,ODI_PK         
                            -- select *
                            from 
                                E$_ORDER_LINE a
                                , ods_stage.OMS_ORDER_LINE_XR b 
                                , ods_stage.OMS_ORDER_LINE_XR c
                            where (1=1) 
                                and a.order_line_oid = b.order_line_oid 
                                and b.BUNDLE_PARENT_ORDER_LINE_KEY = c.ORDER_LINE_KEY(+)
                                and c.ORDER_LINE_OID <> nvl(a.BUNDLE_PARENT_ORDER_LINE_OID,-1)
                        ) s on (c.ODI_PK = s.ODI_PK)
                        when matched then update
                        set 
                        c.BUNDLE_PARENT_ORDER_LINE_OID = s.BUNDLE_PARENT_ORDER_LINE_OID';  
EXCEPTION  
   WHEN OTHERS THEN  
      IF SQLCODE != -942 THEN  
         RAISE;  
      END IF;  
END;

&


/*-----------------------------------------------*/
