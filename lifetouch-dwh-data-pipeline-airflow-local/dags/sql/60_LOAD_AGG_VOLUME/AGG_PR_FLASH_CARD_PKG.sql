/* TASK No. 1 */

/* NONE or SET VARIABLE STATEMENT FOUND, CHECK ODI TASK NO. 1 */




/*-----------------------------------------------*/
/* TASK No. 2 */
/* Delete <Target> Table before loading. */

DELETE  FROM MART.AGG_PR_FLASH_CARD_FACT


&


/*-----------------------------------------------*/
/* TASK No. 3 */
/* Load Target Table */

INSERT INTO MART.AGG_PR_FLASH_CARD_FACT
SELECT /*+PARALLEL(A,6)*/
A.Plant_Name,
'Consumer',
A.Sub_Program_Name,
A.Time_Frame,
A.Sort_Order,
NULL,
NULL,
Sum(A.Ordered_This_Year) As Ordered_This_Year,
Sum(A.Ordered_Last_Year) As Ordered_Last_Year,
Case 
When A.Time_Frame <> 'WTD(Curr)'
Then Sum(A.Ordered_This_Year) - Sum(A.Ordered_Last_Year)
When A.Time_Frame = 'WTD(Curr)'
Then Null
End Difference, 
Sum(A.Shipped_This_Year) As Shipped_This_Year,
Sum(A.Shipped_Last_Year) As Shipped_Last_Year,
Case 
When A.Time_Frame <> 'WTD(Curr)'
Then Sum(A.Shipped_This_Year) - Sum(Shipped_Last_Year)
When A.Time_Frame = 'WTD(Curr)'
Then Null
End Difference_1, 
Case 
When A.Time_Frame = 'YTD'  
Then Sum(A.Unshipped_This_Year) 
When A.Time_Frame <> 'YTD'
Then Null 
End Unshipped_This_Year,
Case 
When A.Time_Frame = 'YTD' 
Then Sum(A.Unshipped_Last_Year)
When A.Time_Frame <> 'YTD'
Then Null 
End Unshipped_Last_Year, 
Case 
When A.Time_Frame = 'YTD'
Then Sum(A.Unshipped_This_Year) - Sum(A.Unshipped_Last_Year) 
When Time_Frame <> 'YTD' Or Time_Frame = 'WTD(Curr)'
Then Null
End Difference_2,
TRUNC(SYSDATE)
From
(
-- Most Subprograms from Event Sales Fact (YTD)

Select Plant_Name,Sub_Program_Name,'YTD' As Time_Frame,1 AS Sort_Order,Sum(Total_Order) As Ordered_This_Year,Sum(0) As 

Ordered_Last_Year,Sum(Shipped_Order) As Shipped_This_Year,Sum(0) As Shipped_Last_Year,Sum(Unshipped_Order) As 

Unshipped_This_Year,Sum(0) As Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact
Where Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual))
Group By Plant_Name,Sub_Program_Name,'YTD',1
Union All
Select Plant_Name,Sub_Program_Name,'YTD' As Time_Frame,1 AS Sort_Order,Sum(0) As Ordered_This_Year,Sum(Total_Order) As 

Ordered_Last_Year,Sum(0) As Shipped_This_Year,Sum(Shipped_Order) As Shipped_Last_Year,Sum(0) As Unshipped_This_Year ,Sum

(Unshipped_Order) As Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact
Where Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual))
Group By Plant_Name,Sub_Program_Name,'YTD',1

Union All
--- WTD (Closed Week)

Select Plant_Name,Sub_Program_Name,'WTD(Closed)' As Time_Frame,2 AS Sort_Order,Sum(Total_Order) As Ordered_This_Year,Sum(0) 

As Ordered_Last_Year,Sum(Shipped_Order) As Shipped_This_Year,Sum(0) As Shipped_Last_Year,Sum(Unshipped_Order) As 

Unshipped_This_Year,Sum(0) As Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact
Where Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual)) - 1
Group By Plant_Name,Sub_Program_Name,'WTD(Closed)',2
Union All
Select Plant_Name,Sub_Program_Name,'WTD(Closed)' As Time_Frame,2 AS Sort_Order,Sum(0) As Ordered_This_Year,Sum(Total_Order) 

As Ordered_Last_Year,Sum(0) As Shipped_This_Year,Sum(Shipped_Order) As Shipped_Last_Year,Sum(0) As Unshipped_This_Year ,Sum

(Unshipped_Order) As Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact
Where Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual)) - 1
Group By Plant_Name,Sub_Program_Name,'WTD(Closed)',2

Union All

--- MTD

Select Plant_Name,Sub_Program_Name,'MTD(Closed)' As Time_Frame,5 AS Sort_Order,Sum(Total_Order) As Ordered_This_Year,Sum(0) As 

Ordered_Last_Year,Sum(Shipped_Order) As Shipped_This_Year,Sum(0) As Shipped_Last_Year,Sum(Unshipped_Order) As 

Unshipped_This_Year,Sum(0) As Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact
Where Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And Month_Number = (Select Month_Number-1 From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
Group By Plant_Name,Sub_Program_Name,'MTD(Closed)',5
Union All
Select Plant_Name,Sub_Program_Name,'MTD(Closed)' As Time_Frame,5 AS Sort_Order,Sum(0) As Ordered_This_Year,Sum(Total_Order) As 

Ordered_Last_Year,Sum(0) As Shipped_This_Year,Sum(Shipped_Order) As Shipped_Last_Year,Sum(0) As Unshipped_This_Year ,Sum

(Unshipped_Order) As Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact
Where Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And Month_Number = (Select Month_Number-1 From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
Group By Plant_Name,Sub_Program_Name,'MTD(Closed)',5


Union All
--- STD

Select Plant_Name,Sub_Program_Name,'STD' As Time_Frame,4 AS Sort_Order,Sum(Total_Order) As Ordered_This_Year,Sum(0) As 

Ordered_Last_Year,Sum(Shipped_Order) As Shipped_This_Year,Sum(0) As Shipped_Last_Year,Sum(Unshipped_Order) As 

Unshipped_This_Year,Sum(0) As Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact
Where Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And Season_Name = (Select Season_Name From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
And Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual)) 
Group By Plant_Name,Sub_Program_Name,'STD',4
Union All
Select Plant_Name,Sub_Program_Name,'STD' As Time_Frame,4 AS Sort_Order,Sum(0) As Ordered_This_Year,Sum(Total_Order) As 

Ordered_Last_Year,Sum(0) As Shipped_This_Year,Sum(Shipped_Order) As Shipped_Last_Year,Sum(0) As Unshipped_This_Year ,Sum

(Unshipped_Order) As Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact
Where Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And Season_Name = (Select Season_Name From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
And Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual))
Group By Plant_Name,Sub_Program_Name,'STD',4


Union All
--- Current Week

Select Plant_Name,Sub_Program_Name,'WTD(Curr)' As Time_Frame,3 AS Sort_Order,Sum(Total_Order) As Ordered_This_Year,Sum(0) As 

Ordered_Last_Year,Sum(Shipped_Order) As Shipped_This_Year,Sum(0) As Shipped_Last_Year,Sum(Unshipped_Order) As 

Unshipped_This_Year,Sum(0) As Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact
Where Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual)) 
Group By Plant_Name,Sub_Program_Name,'WTD(Curr)',3
Union All
Select Plant_Name,Sub_Program_Name,'WTD(Curr)' As Time_Frame,3 AS Sort_Order,Sum(0) As Ordered_This_Year,Sum(Total_Order) As 

Ordered_Last_Year,Sum(0) As Shipped_This_Year,Sum(Shipped_Order) As Shipped_Last_Year,Sum(0) As Unshipped_This_Year ,Sum

(Unshipped_Order) As Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact
Where Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual))
Group By Plant_Name,Sub_Program_Name,'WTD(Curr)',3


Union All

-- Prestige Seniors (YTD)

Select 
Plant_Name,
Case 
When Release_Category = 'Order' Then 'Senior Orders'
When Release_Category = 'Proof' Then 'Senior Proofs'
End Sub_Program_Name,
'YTD' As Time_Frame,
1 AS Sort_Order,
Sum(0) As Ordered_This_Year,Sum(0) As Ordered_Last_Year,
Sum(Release_Qty) As Shipped_This_Year,Sum(0) As Shipped_Last_Year,Sum(0) As Unshipped_This_Year,Sum(0) As Unshipped_Last_Year
From Mart.Agg_Senior_Volume_Fact
Where Release_Category In ('Order','Proof')
And Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And Fiscal_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
Group By
Plant_Name,
Case 
When Release_Category = 'Order' Then 'Senior Orders'
When Release_Category = 'Proof' Then 'Senior Proofs'
End,
'YTD',1
Union All
Select 
Plant_Name,
Case 
When Release_Category = 'Order' Then 'Senior Orders'
When Release_Category = 'Proof' Then 'Senior Proofs'
End Sub_Program_Name,
'YTD' As Time_Frame,
1 AS Sort_Order,
Sum(0) As Ordered_This_Year,Sum(0) As Ordered_Last_Year,
Sum(0) As Shipped_This_Year,Sum(Release_Qty) As Shipped_Last_Year,Sum(0) As Unshipped_This_Year,Sum(0) As Unshipped_Last_Year
From Mart.Agg_Senior_Volume_Fact
Where Release_Category In ('Order','Proof')
And Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And Fiscal_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
Group By
Plant_Name,
Case 
When Release_Category = 'Order' Then 'Senior Orders'
When Release_Category = 'Proof' Then 'Senior Proofs'
End,
'YTD',1

Union All

-- Prestige Seniors (WTD) Closed

Select 
Plant_Name,
Case 
When Release_Category = 'Order' Then 'Senior Orders'
When Release_Category = 'Proof' Then 'Senior Proofs'
End Sub_Program_Name,
'WTD(Closed)' As Time_Frame,
2 AS Sort_Order,
Sum(0) As Ordered_This_Year,Sum(0) As Ordered_Last_Year, 
Sum(Release_Qty) As Shipped_This_Year,Sum(0) As Shipped_Last_Year,Sum(0) As Unshipped_This_Year,Sum(0) As Unshipped_Last_Year
From Mart.Agg_Senior_Volume_Fact
Where Release_Category In ('Order','Proof')
And Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And Fiscal_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual)) - 1
Group By
Plant_Name,
Case 
When Release_Category = 'Order' Then 'Senior Orders'
When Release_Category = 'Proof' Then 'Senior Proofs'
End,
'WTD(Closed)',2
Union All
Select 
Plant_Name,
Case 
When Release_Category = 'Order' Then 'Senior Orders'
When Release_Category = 'Proof' Then 'Senior Proofs'
End Sub_Program_Name,
'WTD(Closed)' As Time_Frame,
2 AS Sort_Order,
Sum(0) As Ordered_This_Year,Sum(0) As Ordered_Last_Year,
Sum(0) As Shipped_This_Year,Sum(Release_Qty) As Shipped_Last_Year,Sum(0) As Unshipped_This_Year,Sum(0) As Unshipped_Last_Year
From Mart.Agg_Senior_Volume_Fact
Where Release_Category In ('Order','Proof')
And Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And Fiscal_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))- 1
Group By
Plant_Name,
Case 
When Release_Category = 'Order' Then 'Senior Orders'
When Release_Category = 'Proof' Then 'Senior Proofs'
End,
'WTD(Closed)',2


Union All

-- Prestige Seniors (MTD)

Select 
Plant_Name,
Case 
When Release_Category = 'Order' Then 'Senior Orders'
When Release_Category = 'Proof' Then 'Senior Proofs'
End Sub_Program_Name,
'MTD(Closed)' As Time_Frame,
5 AS Sort_Order,
Sum(0) As Ordered_This_Year,Sum(0) As Ordered_Last_Year, 
Sum(Release_Qty) As Shipped_This_Year,Sum(0) As Shipped_Last_Year,Sum(0) As Unshipped_This_Year,Sum(0) As Unshipped_Last_Year
From Mart.Agg_Senior_Volume_Fact
Where Release_Category In ('Order','Proof')
And Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And Month_Number = (Select Month_Number-1 From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
Group By
Plant_Name,
Case 
When Release_Category = 'Order' Then 'Senior Orders'
When Release_Category = 'Proof' Then 'Senior Proofs'
End,
'MTD(Closed)',5
Union All
Select 
Plant_Name,
Case 
When Release_Category = 'Order' Then 'Senior Orders'
When Release_Category = 'Proof' Then 'Senior Proofs'
End Sub_Program_Name,
'MTD(Closed)' As Time_Frame,
5 AS Sort_Order,
Sum(0) As Ordered_This_Year,Sum(0) As Ordered_Last_Year,
Sum(0) As Shipped_This_Year,Sum(Release_Qty) As Shipped_Last_Year,Sum(0) As Unshipped_This_Year,Sum(0) As Unshipped_Last_Year
From Mart.Agg_Senior_Volume_Fact
Where Release_Category In ('Order','Proof')
And Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And Month_Number = (Select Month_Number-1 From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
Group By
Plant_Name,
Case 
When Release_Category = 'Order' Then 'Senior Orders'
When Release_Category = 'Proof' Then 'Senior Proofs'
End,
'MTD(Closed)',5


Union All

-- Prestige Seniors (STD)

Select 
Plant_Name,
Case 
When Release_Category = 'Order' Then 'Senior Orders'
When Release_Category = 'Proof' Then 'Senior Proofs'
End Sub_Program_Name,
'STD' As Time_Frame,
4 AS Sort_Order,
Sum(0) As Ordered_This_Year,Sum(0) As Ordered_Last_Year, 
Sum(Release_Qty) As Shipped_This_Year,Sum(0) As Shipped_Last_Year,Sum(0) As Unshipped_This_Year,Sum(0) As Unshipped_Last_Year
From Mart.Agg_Senior_Volume_Fact
Where Release_Category In ('Order','Proof')
And Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And Season_Name = (Select Season_Name From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
And Fiscal_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
Group By
Plant_Name,
Case 
When Release_Category = 'Order' Then 'Senior Orders'
When Release_Category = 'Proof' Then 'Senior Proofs'
End,
'STD',4
Union All
Select 
Plant_Name,
Case 
When Release_Category = 'Order' Then 'Senior Orders'
When Release_Category = 'Proof' Then 'Senior Proofs'
End Sub_Program_Name,
'STD' As Time_Frame,
4 AS Sort_Order,
Sum(0) As Ordered_This_Year,Sum(0) As Ordered_Last_Year,
Sum(0) As Shipped_This_Year,Sum(Release_Qty) As Shipped_Last_Year,Sum(0) As Unshipped_This_Year,Sum(0) As Unshipped_Last_Year
From Mart.Agg_Senior_Volume_Fact
Where Release_Category In ('Order','Proof')
And Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And Season_Name = (Select Season_Name From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
And Fiscal_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
Group By
Plant_Name,
Case 
When Release_Category = 'Order' Then 'Senior Orders'
When Release_Category = 'Proof' Then 'Senior Proofs'
End,
'STD',4


Union All

-- Prestige Seniors (WTD)current

Select 
Plant_Name,
Case 
When Release_Category = 'Order' Then 'Senior Orders'
When Release_Category = 'Proof' Then 'Senior Proofs'
End Sub_Program_Name,
'WTD(Curr)' As Time_Frame,
3 AS Sort_Order,
Sum(0) As Ordered_This_Year,Sum(0) As Ordered_Last_Year, 
Sum(Release_Qty) As Shipped_This_Year,Sum(0) As Shipped_Last_Year,Sum(0) As Unshipped_This_Year,Sum(0) As Unshipped_Last_Year
From Mart.Agg_Senior_Volume_Fact
Where Release_Category In ('Order','Proof')
And Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And Fiscal_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
Group By
Plant_Name,
Case 
When Release_Category = 'Order' Then 'Senior Orders'
When Release_Category = 'Proof' Then 'Senior Proofs'
End,
'WTD(Curr)',3
Union All
Select 
Plant_Name,
Case 
When Release_Category = 'Order' Then 'Senior Orders'
When Release_Category = 'Proof' Then 'Senior Proofs'
End Sub_Program_Name,
'WTD(Curr)' As Time_Frame,
3 AS Sort_Order,
Sum(0) As Ordered_This_Year,Sum(0) As Ordered_Last_Year,
Sum(0) As Shipped_This_Year,Sum(Release_Qty) As Shipped_Last_Year,Sum(0) As Unshipped_This_Year,Sum(0) As Unshipped_Last_Year
From Mart.Agg_Senior_Volume_Fact
Where Release_Category In ('Order','Proof')
And Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And Fiscal_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
Group By
Plant_Name,
Case 
When Release_Category = 'Order' Then 'Senior Orders'
When Release_Category = 'Proof' Then 'Senior Proofs'
End,
'WTD(Curr)',3


Union All

-- Sportography (YTD)

Select                     
          'Chattanooga' As Plant_Name 
          ,Case
                      When Jobs.Workflow = 2 And Jobs.Workflow_Sub_Type = 14 
                      Then 'Sportography - Web Orders'
                      When Jobs.Workflow = 2 
                      Then 'Sportography - Orders' 
                      End  Sub_Program_Name
          ,'YTD' As Time_Frame                  
          ,1 AS Sort_Order   
          ,Sum(0) As Ordered_This_Year,Sum(0) As Ordered_Last_Year                       
          ,Count(Osi.Order_Id) As  Shipped_This_Year
          ,Sum(0) As Shipped_Last_Year
          ,Sum(0) As Unshipped_This_Year
          ,Sum(0) As Unshipped_Last_Year                                              
From 
     Ods_Stage.Prof_Jobs_Stg   Jobs,
     Ods_Stage.Prof_Orders_Stg Orders,
     Ods_Stage.Prof_Order_Subject_Info_Stg Osi,
     (Select Distinct Fiscal_Year,Sat_Production_Week_Number From Mart.Time T)T
Where 1 = 1
And Jobs.Job_Id = Orders.Job_Id(+)
And Orders.Order_Id = Osi.Order_Id(+)        
And Jobs.Workflow = 2 
And Jobs.Workflow_Sub_Type In(4,5) 
And (T.Fiscal_Year,T.Sat_Production_Week_Number,Jobs.Job_Number) In  
         (
          Select Time.Fiscal_Year,Time.Sat_Production_Week_Number,Job_Number 
          From Ods_Stage.Prof_Shipping_Stg Shipping,
               Ods_Stage.Prof_Shipped_Stg Shipped,
               Mart.Time Time
          Where Shipping.Shipped_Id = Shipped.Shipped_Id
                And Trunc(Shipped.Date_Shipped) = Time.Date_Key
                And (Shipped.Shipped_Id <> 10)
                And Time.Fiscal_Year In ((SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))
                And Time.Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select 

Trunc(Sysdate) From Dual))
         )
Group By  'Chattanooga'
          ,Case
                      When Jobs.Workflow = 2 And Jobs.Workflow_Sub_Type = 14 
                      Then 'Sportography - Web Orders'
                      When Jobs.Workflow = 2 
                      Then 'Sportography - Orders' 
                      End      
          ,'YTD',1                               
          ,T.Fiscal_Year
          ,Jobs.Workflow
          ,Jobs.Job_Type
   
Union All


Select                     
          'Chattanooga' As Plant_Name 
          ,Case
                      When Jobs.Workflow = 2 And Jobs.Workflow_Sub_Type = 14 
                      Then 'Sportography - Web Orders'
                      When Jobs.Workflow = 2 
                      Then 'Sportography - Orders' 
                      End  Sub_Program_Name
          ,'YTD' As Time_Frame   
          ,1 AS Sort_Order                      
          ,Sum(0) As Ordered_This_Year,Sum(0) As Ordered_Last_Year                             
          ,Sum(0) As  Shipped_This_Year
          ,Count(Osi.Order_Id)As Shipped_Last_Year
          ,Sum(0) As Unshipped_This_Year
          ,Sum(0) As Unshipped_Last_Year                                              
From 
     Ods_Stage.Prof_Jobs_Stg   Jobs,
     Ods_Stage.Prof_Orders_Stg Orders,
     Ods_Stage.Prof_Order_Subject_Info_Stg Osi,
     (Select Distinct Fiscal_Year,Sat_Production_Week_Number From Mart.Time T)T
Where 1 = 1
And Jobs.Job_Id = Orders.Job_Id(+)
And Orders.Order_Id = Osi.Order_Id(+)        
And Jobs.Workflow = 2 
And Jobs.Workflow_Sub_Type In(4,5) 
And (T.Fiscal_Year,T.Sat_Production_Week_Number,Jobs.Job_Number) In  
         (
          Select Time.Fiscal_Year,Time.Sat_Production_Week_Number,Job_Number 
          From Ods_Stage.Prof_Shipping_Stg Shipping,
               Ods_Stage.Prof_Shipped_Stg Shipped,
               Mart.Time Time
          Where Shipping.Shipped_Id = Shipped.Shipped_Id
                And Trunc(Shipped.Date_Shipped) = Time.Date_Key
                And (Shipped.Shipped_Id <> 10)
                And Time.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR -1 FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
                And Time.Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select 

Trunc(Sysdate) From Dual))
         )
Group By  'Chattanooga'
          ,Case
                      When Jobs.Workflow = 2 And Jobs.Workflow_Sub_Type = 14 
                      Then 'Sportography - Web Orders'
                      When Jobs.Workflow = 2 
                      Then 'Sportography - Orders' 
                      End    
          ,'YTD',1                                  
          ,T.Fiscal_Year
          ,Jobs.Workflow
          ,Jobs.Job_Type     


Union All

-- Sportography (WTD)

Select                     
          'Chattanooga' As Plant_Name 
          ,Case
                      When Jobs.Workflow = 2 And Jobs.Workflow_Sub_Type = 14 
                      Then 'Sportography - Web Orders'
                      When Jobs.Workflow = 2 
                      Then 'Sportography - Orders' 
                      End  Sub_Program_Name
          ,'WTD(Closed)' As Time_Frame
          ,2 AS Sort_Order       
          ,Sum(0) As Ordered_This_Year,Sum(0) As Ordered_Last_Year   
          ,Count(Osi.Order_Id) As  Shipped_This_Year
          ,Sum(0) As Shipped_Last_Year
          ,Sum(0) As Unshipped_This_Year
          ,Sum(0) As Unshipped_Last_Year                                              
From 
     Ods_Stage.Prof_Jobs_Stg   Jobs,
     Ods_Stage.Prof_Orders_Stg Orders,
     Ods_Stage.Prof_Order_Subject_Info_Stg Osi,
     (Select Distinct Fiscal_Year,Sat_Production_Week_Number From Mart.Time T)T
Where 1 = 1
And Jobs.Job_Id = Orders.Job_Id(+)
And Orders.Order_Id = Osi.Order_Id(+)        
And Jobs.Workflow = 2 
And Jobs.Workflow_Sub_Type In(4,5) 
And (T.Fiscal_Year,T.Sat_Production_Week_Number,Jobs.Job_Number) In  
         (
          Select Time.Fiscal_Year,Time.Sat_Production_Week_Number,Job_Number 
          From Ods_Stage.Prof_Shipping_Stg Shipping,
               Ods_Stage.Prof_Shipped_Stg Shipped,
               Mart.Time Time
          Where Shipping.Shipped_Id = Shipped.Shipped_Id
                And Trunc(Shipped.Date_Shipped) = Time.Date_Key
                And (Shipped.Shipped_Id <> 10)
                And Time.Fiscal_Year In ((SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))
                And Time.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select 

Trunc(Sysdate) From Dual)) - 1
         )
Group By  'Chattanooga'
          ,Case
                      When Jobs.Workflow = 2 And Jobs.Workflow_Sub_Type = 14 
                      Then 'Sportography - Web Orders'
                      When Jobs.Workflow = 2 
                      Then 'Sportography - Orders' 
                      End
          ,'WTD(Closed)',2                                                           
          ,T.Fiscal_Year
          ,Jobs.Workflow
          ,Jobs.Job_Type
   

Union All

Select                     
          'Chattanooga' As Plant_Name 
          ,Case
                      When Jobs.Workflow = 2 And Jobs.Workflow_Sub_Type = 14 
                      Then 'Sportography - Web Orders'
                      When Jobs.Workflow = 2 
                      Then 'Sportography - Orders' 
                      End  Sub_Program_Name
          ,'WTD(Closed)' As Time_Frame
          ,2 AS Sort_Order 
          ,Sum(0) As Ordered_This_Year,Sum(0) As Ordered_Last_Year                               
          ,Sum(0) As  Shipped_This_Year
          ,Count(Osi.Order_Id)As Shipped_Last_Year
          ,Sum(0) As Unshipped_This_Year
          ,Sum(0) As Unshipped_Last_Year                                              
From 
     Ods_Stage.Prof_Jobs_Stg   Jobs,
     Ods_Stage.Prof_Orders_Stg Orders,
     Ods_Stage.Prof_Order_Subject_Info_Stg Osi,
     (Select Distinct Fiscal_Year,Sat_Production_Week_Number From Mart.Time T)T
Where 1 = 1
And Jobs.Job_Id = Orders.Job_Id(+)
And Orders.Order_Id = Osi.Order_Id(+)        
And Jobs.Workflow = 2 
And Jobs.Workflow_Sub_Type In(4,5) 
And (T.Fiscal_Year,T.Sat_Production_Week_Number,Jobs.Job_Number) In  
         (
          Select Time.Fiscal_Year,Time.Sat_Production_Week_Number,Job_Number 
          From Ods_Stage.Prof_Shipping_Stg Shipping,
               Ods_Stage.Prof_Shipped_Stg Shipped,
               Mart.Time Time
          Where Shipping.Shipped_Id = Shipped.Shipped_Id
                And Trunc(Shipped.Date_Shipped) = Time.Date_Key
                And (Shipped.Shipped_Id <> 10)
                And Time.Fiscal_Year IN (SELECT DISTINCT FISCAL_YEAR -1 FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
                And Time.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select 

Trunc(Sysdate) From Dual)) - 1
         )
Group By  'Chattanooga'
          ,Case
                      When Jobs.Workflow = 2 And Jobs.Workflow_Sub_Type = 14 
                      Then 'Sportography - Web Orders'
                      When Jobs.Workflow = 2 
                      Then 'Sportography - Orders' 
                      End
          ,'WTD(Closed)',2                                                  
          ,T.Fiscal_Year
          ,Jobs.Workflow
          ,Jobs.Job_Type 
          

Union All

-- Sportography (MTD)
-- AND MONTH_NUMBER = (SELECT MONTH_NUMBER FROM TIME WHERE DATE_KEY = (SELECT TRUNC(SYSDATE) FROM DUAL))

Select                     
          'Chattanooga' As Plant_Name 
          ,Case
                      When Jobs.Workflow = 2 And Jobs.Workflow_Sub_Type = 14 
                      Then 'Sportography - Web Orders'
                      When Jobs.Workflow = 2 
                      Then 'Sportography - Orders' 
                      End  Sub_Program_Name
          ,'MTD(Closed)' As Time_Frame
          ,5 AS Sort_Order       
          ,Sum(0) As Ordered_This_Year,Sum(0) As Ordered_Last_Year   
          ,Count(Osi.Order_Id) As  Shipped_This_Year
          ,Sum(0) As Shipped_Last_Year
          ,Sum(0) As Unshipped_This_Year
          ,Sum(0) As Unshipped_Last_Year                                              
From 
     Ods_Stage.Prof_Jobs_Stg   Jobs,
     Ods_Stage.Prof_Orders_Stg Orders,
     Ods_Stage.Prof_Order_Subject_Info_Stg Osi,
     (Select Distinct Fiscal_Year,Month_Number From Mart.Time T)T
Where 1 = 1
And Jobs.Job_Id = Orders.Job_Id(+)
And Orders.Order_Id = Osi.Order_Id(+)        
And Jobs.Workflow = 2 
And Jobs.Workflow_Sub_Type In(4,5) 
And (T.Fiscal_Year,T.Month_Number,Jobs.Job_Number) In  
         (
          Select Time.Fiscal_Year,Time.Month_Number,Job_Number 
          From Ods_Stage.Prof_Shipping_Stg Shipping,
               Ods_Stage.Prof_Shipped_Stg Shipped,
               Mart.Time Time
          Where Shipping.Shipped_Id = Shipped.Shipped_Id
                And Trunc(Shipped.Date_Shipped) = Time.Date_Key
                And (Shipped.Shipped_Id <> 10)
                And Time.Fiscal_Year In ((SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))
                And Time.Month_Number = (Select Month_Number-1 From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
         )
Group By  'Chattanooga'
          ,Case
                      When Jobs.Workflow = 2 And Jobs.Workflow_Sub_Type = 14 
                      Then 'Sportography - Web Orders'
                      When Jobs.Workflow = 2 
                      Then 'Sportography - Orders' 
                      End
          ,'MTD(Closed)',5                                                           
          ,T.Fiscal_Year
          ,Jobs.Workflow
          ,Jobs.Job_Type
   

Union All

Select                     
          'Chattanooga' As Plant_Name 
          ,Case
                      When Jobs.Workflow = 2 And Jobs.Workflow_Sub_Type = 14 
                      Then 'Sportography - Web Orders'
                      When Jobs.Workflow = 2 
                      Then 'Sportography - Orders' 
                      End  Sub_Program_Name
          ,'MTD(Closed)' As Time_Frame
          ,5 AS Sort_Order 
          ,Sum(0) As Ordered_This_Year,Sum(0) As Ordered_Last_Year                               
          ,Sum(0) As  Shipped_This_Year
          ,Count(Osi.Order_Id)As Shipped_Last_Year
          ,Sum(0) As Unshipped_This_Year
          ,Sum(0) As Unshipped_Last_Year                                              
From 
     Ods_Stage.Prof_Jobs_Stg   Jobs,
     Ods_Stage.Prof_Orders_Stg Orders,
     Ods_Stage.Prof_Order_Subject_Info_Stg Osi,
     (Select Distinct Fiscal_Year,Month_Number From Mart.Time T)T
Where 1 = 1
And Jobs.Job_Id = Orders.Job_Id(+)
And Orders.Order_Id = Osi.Order_Id(+)        
And Jobs.Workflow = 2 
And Jobs.Workflow_Sub_Type In(4,5) 
And (T.Fiscal_Year,T.Month_Number,Jobs.Job_Number) In  
         (
          Select Time.Fiscal_Year,Time.Month_Number,Job_Number 
          From Ods_Stage.Prof_Shipping_Stg Shipping,
               Ods_Stage.Prof_Shipped_Stg Shipped,
               Mart.Time Time
          Where Shipping.Shipped_Id = Shipped.Shipped_Id
                And Trunc(Shipped.Date_Shipped) = Time.Date_Key
                And (Shipped.Shipped_Id <> 10)
                And Time.Fiscal_Year In (SELECT DISTINCT FISCAL_YEAR - 1 FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
                And Time.Month_Number = (Select Month_Number-1 From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
         )
Group By  'Chattanooga'
          ,Case
                      When Jobs.Workflow = 2 And Jobs.Workflow_Sub_Type = 14 
                      Then 'Sportography - Web Orders'
                      When Jobs.Workflow = 2 
                      Then 'Sportography - Orders' 
                      End
          ,'MTD(Closed)',5                                                  
          ,T.Fiscal_Year
          ,Jobs.Workflow
          ,Jobs.Job_Type        
Union All
          
-- Sportography (STD)

Select                     
          'Chattanooga' As Plant_Name 
          ,Case
                      When Jobs.Workflow = 2 And Jobs.Workflow_Sub_Type = 14 
                      Then 'Sportography - Web Orders'
                      When Jobs.Workflow = 2 
                      Then 'Sportography - Orders' 
                      End  Sub_Program_Name
          ,'STD' As Time_Frame         
          ,4 AS Sort_Order            
          ,Sum(0) As Ordered_This_Year,Sum(0) As Ordered_Last_Year                       
          ,Count(Osi.Order_Id) As  Shipped_This_Year
          ,Sum(0) As Shipped_Last_Year
          ,Sum(0) As Unshipped_This_Year
          ,Sum(0) As Unshipped_Last_Year                                              
From 
     Ods_Stage.Prof_Jobs_Stg   Jobs,
     Ods_Stage.Prof_Orders_Stg Orders,
     Ods_Stage.Prof_Order_Subject_Info_Stg Osi,
     (Select Distinct Fiscal_Year,Season_Name From Mart.Time T)T
Where 1 = 1
And Jobs.Job_Id = Orders.Job_Id(+)
And Orders.Order_Id = Osi.Order_Id(+)        
And Jobs.Workflow = 2 
And Jobs.Workflow_Sub_Type In(4,5) 
And (T.Fiscal_Year,T.Season_Name,Jobs.Job_Number) In  
         (
          Select Time.Fiscal_Year,Time.Season_Name,Job_Number 
          From Ods_Stage.Prof_Shipping_Stg Shipping,
               Ods_Stage.Prof_Shipped_Stg Shipped,
               Mart.Time Time
          Where Shipping.Shipped_Id = Shipped.Shipped_Id
                And Trunc(Shipped.Date_Shipped) = Time.Date_Key
                And (Shipped.Shipped_Id <> 10)
                And Time.Fiscal_Year In ((SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))
                And Time.Season_Name = (Select Season_Name From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
                And Time.Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select 

Trunc(Sysdate) From Dual))
         )
Group By  'Chattanooga'
          ,Case
                      When Jobs.Workflow = 2 And Jobs.Workflow_Sub_Type = 14 
                      Then 'Sportography - Web Orders'
                      When Jobs.Workflow = 2 
                      Then 'Sportography - Orders' 
                      End                                     
          ,'STD',4
          ,T.Fiscal_Year
          ,Jobs.Workflow
          ,Jobs.Job_Type
          
   
Union All


Select                     
          'Chattanooga' As Plant_Name 
          ,Case
                      When Jobs.Workflow = 2 And Jobs.Workflow_Sub_Type = 14 
                      Then 'Sportography - Web Orders'
                      When Jobs.Workflow = 2 
                      Then 'Sportography - Orders' 
                      End  Sub_Program_Name
          ,'STD' As Time_Frame  
          ,4 AS Sort_Order                       
          ,Sum(0) As Ordered_This_Year,Sum(0) As Ordered_Last_Year                             
          ,Sum(0) As  Shipped_This_Year
          ,Count(Osi.Order_Id)As Shipped_Last_Year
          ,Sum(0) As Unshipped_This_Year
          ,Sum(0) As Unshipped_Last_Year                                              
From 
     Ods_Stage.Prof_Jobs_Stg   Jobs,
     Ods_Stage.Prof_Orders_Stg Orders,
     Ods_Stage.Prof_Order_Subject_Info_Stg Osi,
     (Select Distinct Fiscal_Year,Season_Name From Mart.Time T)T
Where 1 = 1
And Jobs.Job_Id = Orders.Job_Id(+)
And Orders.Order_Id = Osi.Order_Id(+)        
And Jobs.Workflow = 2 
And Jobs.Workflow_Sub_Type In(4,5) 
And (T.Fiscal_Year,T.Season_Name,Jobs.Job_Number) In  
         (
          Select Time.Fiscal_Year,Time.Season_Name,Job_Number 
          From Ods_Stage.Prof_Shipping_Stg Shipping,
               Ods_Stage.Prof_Shipped_Stg Shipped,
               Mart.Time Time
          Where Shipping.Shipped_Id = Shipped.Shipped_Id
                And Trunc(Shipped.Date_Shipped) = Time.Date_Key
                And (Shipped.Shipped_Id <> 10)
                And Time.Fiscal_Year In (SELECT DISTINCT FISCAL_YEAR - 1 FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
                And Time.Season_Name = (Select Season_Name From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
                And Time.Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select 

Trunc(Sysdate) From Dual))
         )
Group By  'Chattanooga'
          ,Case
                      When Jobs.Workflow = 2 And Jobs.Workflow_Sub_Type = 14 
                      Then 'Sportography - Web Orders'
                      When Jobs.Workflow = 2 
                      Then 'Sportography - Orders' 
                      End
          ,'STD',4                                      
          ,T.Fiscal_Year
          ,Jobs.Workflow
          ,Jobs.Job_Type              

Union All

-- Sportography (WTD - Curr)

Select                     
          'Chattanooga' As Plant_Name 
          ,Case
                      When Jobs.Workflow = 2 And Jobs.Workflow_Sub_Type = 14 
                      Then 'Sportography - Web Orders'
                      When Jobs.Workflow = 2 
                      Then 'Sportography - Orders' 
                      End  Sub_Program_Name
          ,'WTD(Curr)' As Time_Frame  
          ,3 AS Sort_Order     
          ,Sum(0) As Ordered_This_Year,Sum(0) As Ordered_Last_Year   
          ,Count(Osi.Order_Id) As  Shipped_This_Year
          ,Sum(0) As Shipped_Last_Year
          ,Sum(0) As Unshipped_This_Year
          ,Sum(0) As Unshipped_Last_Year                                              
From 
     Ods_Stage.Prof_Jobs_Stg   Jobs,
     Ods_Stage.Prof_Orders_Stg Orders,
     Ods_Stage.Prof_Order_Subject_Info_Stg Osi,
     (Select Distinct Fiscal_Year,Sat_Production_Week_Number From Mart.Time T)T
Where 1 = 1
And Jobs.Job_Id = Orders.Job_Id(+)
And Orders.Order_Id = Osi.Order_Id(+)        
And Jobs.Workflow = 2 
And Jobs.Workflow_Sub_Type In(4,5) 
And (T.Fiscal_Year,T.Sat_Production_Week_Number,Jobs.Job_Number) In  
         (
          Select Time.Fiscal_Year,Time.Sat_Production_Week_Number,Job_Number 
          From Ods_Stage.Prof_Shipping_Stg Shipping,
               Ods_Stage.Prof_Shipped_Stg Shipped,
               Mart.Time Time
          Where Shipping.Shipped_Id = Shipped.Shipped_Id
                And Trunc(Shipped.Date_Shipped) = Time.Date_Key
                And (Shipped.Shipped_Id <> 10)
                And Time.Fiscal_Year In ((SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)))
                And Time.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select 

Trunc(Sysdate) From Dual))
         )
Group By  'Chattanooga'
          ,Case
                      When Jobs.Workflow = 2 And Jobs.Workflow_Sub_Type = 14 
                      Then 'Sportography - Web Orders'
                      When Jobs.Workflow = 2 
                      Then 'Sportography - Orders' 
                      End
          ,'WTD(Curr)',3                                                           
          ,T.Fiscal_Year
          ,Jobs.Workflow
          ,Jobs.Job_Type
   

Union All

Select                     
          'Chattanooga' As Plant_Name 
          ,Case
                      When Jobs.Workflow = 2 And Jobs.Workflow_Sub_Type = 14 
                      Then 'Sportography - Web Orders'
                      When Jobs.Workflow = 2 
                      Then 'Sportography - Orders' 
                      End  Sub_Program_Name
          ,'WTD(Curr)' As Time_Frame 
          ,3 AS Sort_Order
          ,Sum(0) As Ordered_This_Year,Sum(0) As Ordered_Last_Year                               
          ,Sum(0) As  Shipped_This_Year
          ,Count(Osi.Order_Id)As Shipped_Last_Year
          ,Sum(0) As Unshipped_This_Year
          ,Sum(0) As Unshipped_Last_Year                                              
From 
     Ods_Stage.Prof_Jobs_Stg   Jobs,
     Ods_Stage.Prof_Orders_Stg Orders,
     Ods_Stage.Prof_Order_Subject_Info_Stg Osi,
     (Select Distinct Fiscal_Year,Sat_Production_Week_Number From Mart.Time T)T
Where 1 = 1
And Jobs.Job_Id = Orders.Job_Id(+)
And Orders.Order_Id = Osi.Order_Id(+)        
And Jobs.Workflow = 2 
And Jobs.Workflow_Sub_Type In(4,5) 
And (T.Fiscal_Year,T.Sat_Production_Week_Number,Jobs.Job_Number) In  
         (
          Select Time.Fiscal_Year,Time.Sat_Production_Week_Number,Job_Number 
          From Ods_Stage.Prof_Shipping_Stg Shipping,
               Ods_Stage.Prof_Shipped_Stg Shipped,
               Mart.Time Time
          Where Shipping.Shipped_Id = Shipped.Shipped_Id
                And Trunc(Shipped.Date_Shipped) = Time.Date_Key
                And (Shipped.Shipped_Id <> 10)
                And Time.Fiscal_Year In (SELECT DISTINCT FISCAL_YEAR - 1 FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
                And Time.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select 

Trunc(Sysdate) From Dual))
         )
Group By  'Chattanooga'
          ,Case
                      When Jobs.Workflow = 2 And Jobs.Workflow_Sub_Type = 14 
                      Then 'Sportography - Web Orders'
                      When Jobs.Workflow = 2 
                      Then 'Sportography - Orders' 
                      End
          ,'WTD(Curr)',3                                                  
          ,T.Fiscal_Year
          ,Jobs.Workflow
          ,Jobs.Job_Type 

                    
Union All

-- NGP Proofs (Next Gen) - YTD  

Select  
  A.Plant_Name
, A.Sub_Program_Name || ' - Proof' As Sub_Program_Name
, 'YTD' As Time_Frame
, 1 AS Sort_Order
, Sum(A.Proof_X_Order) As Ordered_This_Year,Sum(0) As Ordered_Last_Year,Sum(A.Proof_X_Shipped_Order) As 

Shipped_This_Year,Sum(0) As Shipped_Last_Year,Sum(A.Proof_X_Unshipped_Order) As Unshipped_This_Year,Sum(0) As 

Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact A
Where 1 = 1   
And A.Sub_Program_Name In ('Fall Individuals','Spring Individuals','Underclass Grads')
And A.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And A.Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual))
Group By
A.Plant_Name,
A.Sub_Program_Name,
'YTD',1

Union All

Select  
  A.Plant_Name
, A.Sub_Program_Name || ' - Proof'  As Sub_Program_Name
, 'YTD' As Time_Frame
, 1 AS Sort_Order
, Sum(0) As Ordered_This_Year,Sum(A.Proof_X_Order) As Ordered_Last_Year,Sum(0) As Shipped_This_Year,Sum

(A.Proof_X_Shipped_Order) As Shipped_Last_Year,Sum(0) As Unshipped_This_Year,Sum(A.Proof_X_Unshipped_Order) As 

Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact A
Where 1 = 1   
And A.Sub_Program_Name In ('Fall Individuals','Spring Individuals','Underclass Grads')
And A.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And A.Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual))
Group By
A.Plant_Name,
A.Sub_Program_Name,
'YTD',1

Union All

-- NGP Proofs (Next Gen) - WTD Closed

Select  
  A.Plant_Name
, A.Sub_Program_Name || ' - Proof' As Sub_Program_Name
, 'WTD(Closed)' As Time_Frame
, 2 AS Sort_Order
, Sum(A.Proof_X_Order) As Ordered_This_Year,Sum(0) As Ordered_Last_Year,Sum(A.Proof_X_Shipped_Order) As 

Shipped_This_Year,Sum(0) As Shipped_Last_Year,Sum(A.Proof_X_Unshipped_Order) As Unshipped_This_Year,Sum(0) As 

Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact A
Where 1 = 1   
And A.Sub_Program_Name In ('Fall Individuals','Spring Individuals','Underclass Grads')
And A.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And A.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual)) - 1
Group By
A.Plant_Name,
A.Sub_Program_Name,
'WTD(Closed)', 2

Union All

Select  
  A.Plant_Name
, A.Sub_Program_Name || ' - Proof'  As Sub_Program_Name
, 'WTD(Closed)' As Time_Frame
, 2 AS Sort_Order
, Sum(0) As Ordered_This_Year,Sum(A.Proof_X_Order) As Ordered_Last_Year,Sum(0) As Shipped_This_Year,Sum

(A.Proof_X_Shipped_Order) As Shipped_Last_Year,Sum(0) As Unshipped_This_Year,Sum(A.Proof_X_Unshipped_Order) As 

Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact A
Where 1 = 1   
And A.Sub_Program_Name In ('Fall Individuals','Spring Individuals','Underclass Grads')
And A.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And A.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual)) - 1 
Group By
A.Plant_Name,
A.Sub_Program_Name,
'WTD(Closed)',2


Union All

-- NGP Proofs (Next Gen) - MTD

Select  
  A.Plant_Name
, A.Sub_Program_Name || ' - Proof' As Sub_Program_Name
, 'MTD(Closed)' As Time_Frame
, 5 AS Sort_Order
, Sum(A.Proof_X_Order) As Ordered_This_Year,Sum(0) As Ordered_Last_Year,Sum(A.Proof_X_Shipped_Order) As 

Shipped_This_Year,Sum(0) As Shipped_Last_Year,Sum(A.Proof_X_Unshipped_Order) As Unshipped_This_Year,Sum(0) As 

Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact A
Where 1 = 1   
And A.Sub_Program_Name In ('Fall Individuals','Spring Individuals','Underclass Grads')
And A.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And A.Month_Number = (Select Month_Number-1 From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
Group By
A.Plant_Name,
A.Sub_Program_Name,
'MTD(Closed)',5

Union All

Select  
  A.Plant_Name
, A.Sub_Program_Name || ' - Proof'  As Sub_Program_Name
, 'MTD(Closed)' As Time_Frame
, 5 AS Sort_Order
, Sum(0) As Ordered_This_Year,Sum(A.Proof_X_Order) As Ordered_Last_Year,Sum(0) As Shipped_This_Year,Sum

(A.Proof_X_Shipped_Order) As Shipped_Last_Year,Sum(0) As Unshipped_This_Year,Sum(A.Proof_X_Unshipped_Order) As 

Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact A
Where 1 = 1   
And A.Sub_Program_Name In ('Fall Individuals','Spring Individuals','Underclass Grads')
And A.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And A.Month_Number = (Select Month_Number-1 From Time Where Date_Key = (Select Trunc(Sysdate) From Dual)) 
Group By
A.Plant_Name,
A.Sub_Program_Name,
'MTD(Closed)',5


Union All

-- NGP Proofs (Next Gen) - STD

Select  
  A.Plant_Name
, A.Sub_Program_Name || ' - Proof' As Sub_Program_Name
, 'STD' As Time_Frame
, 4 AS Sort_Order
, Sum(A.Proof_X_Order) As Ordered_This_Year,Sum(0) As Ordered_Last_Year,Sum(A.Proof_X_Shipped_Order) As 

Shipped_This_Year,Sum(0) As Shipped_Last_Year,Sum(A.Proof_X_Unshipped_Order) As Unshipped_This_Year,Sum(0) As 

Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact A
Where 1 = 1   
And A.Sub_Program_Name In ('Fall Individuals','Spring Individuals','Underclass Grads')
And A.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And A.Season_Name = (Select Season_Name From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
And A.Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual))
Group By
A.Plant_Name,
A.Sub_Program_Name,
'STD',4

Union All

Select  
  A.Plant_Name
, A.Sub_Program_Name || ' - Proof'  As Sub_Program_Name
, 'STD' As Time_Frame
, 4 AS Sort_Order
, Sum(0) As Ordered_This_Year,Sum(A.Proof_X_Order) As Ordered_Last_Year,Sum(0) As Shipped_This_Year,Sum

(A.Proof_X_Shipped_Order) As Shipped_Last_Year,Sum(0) As Unshipped_This_Year,Sum(A.Proof_X_Unshipped_Order) As 

Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact A
Where 1 = 1   
And A.Sub_Program_Name In ('Fall Individuals','Spring Individuals','Underclass Grads')
And A.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And A.Season_Name = (Select Season_Name From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
And A.Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual)) 
Group By
A.Plant_Name,
A.Sub_Program_Name,
'STD',4

Union All

-- NGP Proofs (Next Gen) - WTD Curr

Select  
  A.Plant_Name
, A.Sub_Program_Name || ' - Proof' As Sub_Program_Name
, 'WTD(Curr)' As Time_Frame
, 3 AS Sort_Order
, Sum(A.Proof_X_Order) As Ordered_This_Year,Sum(0) As Ordered_Last_Year,Sum(A.Proof_X_Shipped_Order) As 

Shipped_This_Year,Sum(0) As Shipped_Last_Year,Sum(A.Proof_X_Unshipped_Order) As Unshipped_This_Year,Sum(0) As 

Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact A
Where 1 = 1   
And A.Sub_Program_Name In ('Fall Individuals','Spring Individuals','Underclass Grads')
And A.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And A.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual))
Group By
A.Plant_Name,
A.Sub_Program_Name,
'WTD(Curr)',3

Union All

Select  
  A.Plant_Name
, A.Sub_Program_Name || ' - Proof'  As Sub_Program_Name
, 'WTD(Curr)' As Time_Frame
, 3 AS Sort_Order
, Sum(0) As Ordered_This_Year,Sum(A.Proof_X_Order) As Ordered_Last_Year,Sum(0) As Shipped_This_Year,Sum

(A.Proof_X_Shipped_Order) As Shipped_Last_Year,Sum(0) As Unshipped_This_Year,Sum(A.Proof_X_Unshipped_Order) As 

Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact A
Where 1 = 1   
And A.Sub_Program_Name In ('Fall Individuals','Spring Individuals','Underclass Grads')
And A.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And A.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual)) 
Group By
A.Plant_Name,
A.Sub_Program_Name,
'WTD(Curr)',3


Union All

-- Non Buyer POS (YTD)

Select  
  A.Plant_Name
, A.Sub_Program_Name || ' - Non Buyer POS' As Sub_Program_Name
, 'YTD' As Time_Frame
, 1 AS Sort_Order
, Sum(A.X_Order) As Ordered_This_Year,Sum(0) As Ordered_Last_Year,Sum(A.X_Shipped_Order) As Shipped_This_Year,Sum(0) As 

Shipped_Last_Year,Sum(A.X_Unshipped_Order) As Unshipped_This_Year,Sum(0) As Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact A
Where 1 = 1   
And A.Sub_Program_Name In ('Fall Individuals','Spring Individuals','Underclass Grads','Sports')
And A.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And A.Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual))
Group By
A.Plant_Name,
A.Sub_Program_Name,
'YTD',1

Union All

Select  
  A.Plant_Name
, A.Sub_Program_Name || ' - Non Buyer POS'  As Sub_Program_Name
, 'YTD' As Time_Frame
, 1 AS Sort_Order
, Sum(0) As Ordered_This_Year,Sum(A.X_Order) As Ordered_Last_Year,Sum(0) As Shipped_This_Year,Sum(A.X_Shipped_Order) As 

Shipped_Last_Year,Sum(0) As Unshipped_This_Year,Sum(A.X_Unshipped_Order) As Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact A
Where 1 = 1   
And A.Sub_Program_Name In ('Fall Individuals','Spring Individuals','Underclass Grads','Sports')
And A.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And A.Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual)) 
Group By
A.Plant_Name,
A.Sub_Program_Name,
'YTD',1

Union All

-- Non Buyer POS (WTD Closed)

Select  
  A.Plant_Name
, A.Sub_Program_Name || ' - Non Buyer POS' As Sub_Program_Name
, 'WTD(Closed)' As Time_Frame
, 2 AS Sort_Order
, Sum(A.X_Order) As Ordered_This_Year,Sum(0) As Ordered_Last_Year,Sum(A.X_Shipped_Order) As Shipped_This_Year,Sum(0) As 

Shipped_Last_Year,Sum(A.X_Unshipped_Order) As Unshipped_This_Year,Sum(0) As Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact A
Where 1 = 1   
And A.Sub_Program_Name In ('Fall Individuals','Spring Individuals','Underclass Grads','Sports')
And A.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And A.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual)) - 1
Group By
A.Plant_Name,
A.Sub_Program_Name,
'WTD(Closed)',2

Union All

Select  
  A.Plant_Name
, A.Sub_Program_Name || ' - Non Buyer POS'  As Sub_Program_Name
, 'WTD(Closed)' As Time_Frame
, 2 AS Sort_Order
, Sum(0) As Ordered_This_Year,Sum(A.X_Order) As Ordered_Last_Year,Sum(0) As Shipped_This_Year,Sum(A.X_Shipped_Order) As 

Shipped_Last_Year,Sum(0) As Unshipped_This_Year,Sum(A.X_Unshipped_Order) As Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact A
Where 1 = 1   
And A.Sub_Program_Name In ('Fall Individuals','Spring Individuals','Underclass Grads','Sports')
And A.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And A.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual)) - 1 
Group By
A.Plant_Name,
A.Sub_Program_Name,
'WTD(Closed)',2


Union All

-- Non Buyer POS (MTD)

Select  
  A.Plant_Name
, A.Sub_Program_Name || ' - Non Buyer POS' As Sub_Program_Name
, 'MTD(Closed)' As Time_Frame
, 5 AS Sort_Order
, Sum(A.X_Order) As Ordered_This_Year,Sum(0) As Ordered_Last_Year,Sum(A.X_Shipped_Order) As Shipped_This_Year,Sum(0) As 

Shipped_Last_Year,Sum(A.X_Unshipped_Order) As Unshipped_This_Year,Sum(0) As Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact A
Where 1 = 1   
And A.Sub_Program_Name In ('Fall Individuals','Spring Individuals','Underclass Grads','Sports')
And A.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And A.Month_Number = (Select Month_Number-1 From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
Group By
A.Plant_Name,
A.Sub_Program_Name,
'MTD(Closed)',5

Union All

Select  
  A.Plant_Name
, A.Sub_Program_Name || ' - Non Buyer POS'  As Sub_Program_Name
, 'MTD(Closed)' As Time_Frame
, 5 AS Sort_Order
, Sum(0) As Ordered_This_Year,Sum(A.X_Order) As Ordered_Last_Year,Sum(0) As Shipped_This_Year,Sum(A.X_Shipped_Order) As 

Shipped_Last_Year,Sum(0) As Unshipped_This_Year,Sum(A.X_Unshipped_Order) As Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact A
Where 1 = 1   
And A.Sub_Program_Name In ('Fall Individuals','Spring Individuals','Underclass Grads','Sports')
And A.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And A.Month_Number = (Select Month_Number-1 From Time Where Date_Key = (Select Trunc(Sysdate) From Dual)) 
Group By
A.Plant_Name,
A.Sub_Program_Name,
'MTD(Closed)',5

Union All

-- Non Buyer POS (STD)

Select  
  A.Plant_Name
, A.Sub_Program_Name || ' - Non Buyer POS' As Sub_Program_Name
, 'STD' As Time_Frame
, 4 AS Sort_Order
, Sum(A.X_Order) As Ordered_This_Year,Sum(0) As Ordered_Last_Year,Sum(A.X_Shipped_Order) As Shipped_This_Year,Sum(0) As 

Shipped_Last_Year,Sum(A.X_Unshipped_Order) As Unshipped_This_Year,Sum(0) As Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact A
Where 1 = 1   
And A.Sub_Program_Name In ('Fall Individuals','Spring Individuals','Underclass Grads','Sports')
And A.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And A.Season_Name = (Select Season_Name From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
And A.Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual))
Group By
A.Plant_Name,
A.Sub_Program_Name,
'STD',4

Union All

Select  
  A.Plant_Name
, A.Sub_Program_Name || ' - Non Buyer POS'  As Sub_Program_Name
, 'STD' As Time_Frame
, 4 AS Sort_Order
, Sum(0) As Ordered_This_Year,Sum(A.X_Order) As Ordered_Last_Year,Sum(0) As Shipped_This_Year,Sum(A.X_Shipped_Order) As 

Shipped_Last_Year,Sum(0) As Unshipped_This_Year,Sum(A.X_Unshipped_Order) As Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact A
Where 1 = 1   
And A.Sub_Program_Name In ('Fall Individuals','Spring Individuals','Underclass Grads','Sports')
And A.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And A.Season_Name = (Select Season_Name From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
And A.Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual)) 
Group By
A.Plant_Name,
A.Sub_Program_Name,
'STD',4


Union All

-- Non Buyer POS (WTD Curr)

Select  
  A.Plant_Name
, A.Sub_Program_Name || ' - Non Buyer POS' As Sub_Program_Name
, 'WTD(Curr)' As Time_Frame
, 3 AS Sort_Order
, Sum(A.X_Order) As Ordered_This_Year,Sum(0) As Ordered_Last_Year,Sum(A.X_Shipped_Order) As Shipped_This_Year,Sum(0) As 

Shipped_Last_Year,Sum(A.X_Unshipped_Order) As Unshipped_This_Year,Sum(0) As Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact A
Where 1 = 1   
And A.Sub_Program_Name In ('Fall Individuals','Spring Individuals','Underclass Grads','Sports')
And A.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And A.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual))
Group By
A.Plant_Name,
A.Sub_Program_Name,
'WTD(Curr)',3

Union All

Select  
  A.Plant_Name
, A.Sub_Program_Name || ' - Non Buyer POS'  As Sub_Program_Name
, 'WTD(Curr)' As Time_Frame
, 3 AS Sort_Order
, Sum(0) As Ordered_This_Year,Sum(A.X_Order) As Ordered_Last_Year,Sum(0) As Shipped_This_Year,Sum(A.X_Shipped_Order) As 

Shipped_Last_Year,Sum(0) As Unshipped_This_Year,Sum(A.X_Unshipped_Order) As Unshipped_Last_Year
From Mart.Agg_Pr_Prod_Volumetrics_Fact A
Where 1 = 1   
And A.Sub_Program_Name In ('Fall Individuals','Spring Individuals','Underclass Grads','Sports')
And A.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And A.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From 

Dual)) 
Group By
A.Plant_Name,
A.Sub_Program_Name,
'WTD(Curr)',3            
UNION ALL
SELECT DISTINCT PLANT_NAME,SUB_PROGRAM_NAME,'YTD' as Time_Frame,1 as Sort_Order, 
                SUM(0) AS ORDERED_THIS_YEAR,SUM(0) AS ORDERED_LAST_YEAR,SUM(0) AS SHIPPED_THIS_YEAR,SUM(0) AS 

SHIPPED_LAST_YEAR,
                SUM(0) AS UNSHIPPED_THIS_YEAR,SUM(0) AS UNSHIPPED_LAST_YEAR
From Mart.Agg_Pr_Prod_Volumetrics_Fact
GROUP BY PLANT_NAME,SUB_PROGRAM_NAME,'YTD',1
UNION ALL
SELECT DISTINCT PLANT_NAME,SUB_PROGRAM_NAME,'WTD(Closed)' as Time_Frame,2 as Sort_Order, 
                SUM(0) AS ORDERED_THIS_YEAR,SUM(0) AS ORDERED_LAST_YEAR,SUM(0) AS SHIPPED_THIS_YEAR,SUM(0) AS 

SHIPPED_LAST_YEAR,
                SUM(0) AS UNSHIPPED_THIS_YEAR,SUM(0) AS UNSHIPPED_LAST_YEAR
From Mart.Agg_Pr_Prod_Volumetrics_Fact
GROUP BY PLANT_NAME,SUB_PROGRAM_NAME,'WTD(Closed)',2
UNION ALL
SELECT DISTINCT PLANT_NAME,SUB_PROGRAM_NAME,'WTD(Curr)' as Time_Frame,3 as Sort_Order, 
                SUM(0) AS ORDERED_THIS_YEAR,SUM(0) AS ORDERED_LAST_YEAR,SUM(0) AS SHIPPED_THIS_YEAR,SUM(0) AS 

SHIPPED_LAST_YEAR,
                SUM(0) AS UNSHIPPED_THIS_YEAR,SUM(0) AS UNSHIPPED_LAST_YEAR
From Mart.Agg_Pr_Prod_Volumetrics_Fact
GROUP BY PLANT_NAME,SUB_PROGRAM_NAME,'WTD(Curr)',3
UNION ALL
SELECT DISTINCT PLANT_NAME,SUB_PROGRAM_NAME,'STD' as Time_Frame,4 as Sort_Order,
                SUM(0) AS ORDERED_THIS_YEAR,SUM(0) AS ORDERED_LAST_YEAR,SUM(0) AS SHIPPED_THIS_YEAR,SUM(0) AS 

SHIPPED_LAST_YEAR,
                SUM(0) AS UNSHIPPED_THIS_YEAR,SUM(0) AS UNSHIPPED_LAST_YEAR
From Mart.Agg_Pr_Prod_Volumetrics_Fact
GROUP BY PLANT_NAME,SUB_PROGRAM_NAME,'STD',4
UNION ALL
SELECT DISTINCT PLANT_NAME,SUB_PROGRAM_NAME,'MTD(Closed)' as Time_Frame,5 as Sort_Order,
                SUM(0) AS ORDERED_THIS_YEAR,SUM(0) AS ORDERED_LAST_YEAR,SUM(0) AS SHIPPED_THIS_YEAR,SUM(0) AS 

SHIPPED_LAST_YEAR,
                SUM(0) AS UNSHIPPED_THIS_YEAR,SUM(0) AS UNSHIPPED_LAST_YEAR 
From Mart.Agg_Pr_Prod_Volumetrics_Fact
GROUP BY PLANT_NAME,SUB_PROGRAM_NAME,'MTD(Closed)',5


UNION ALL

-- Jolesch Commencement Orders
-- YTD

SELECT SHIPPING.PLANT_NAME,'Jolesch Commencement Orders' AS SUB_PROGRAM_NAME,'YTD' AS TIME_FRAME,1 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,COUNT(*) AS Shipped_This_Year,SUM(0) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM ODS.INF_HJ_ORDERS ORD,ODS.INF_EVENT E,RAX_APP_USER.COMM_PROF_SHIPPING_STG SHIPPING
WHERE ORD.EVENTID = E.ID
AND ORD.HJ_ORDER = SHIPPING.ORDER_NUMBER
AND SHIPPING.SHIPPED_ID IN (SELECT SHIPPED_ID FROM RAX_APP_USER.COMM_PROF_SHIPPED_STG s,MART.TIME t 
                                   WHERE  
                                   trunc(s.Date_Shipped) = t.date_key
                                   and t.fiscal_year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
                                   and t.sat_production_week_number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
                            )
Group By SHIPPING.PLANT_NAME,'Jolesch Commencement Orders','YTD',1

UNION ALL

SELECT SHIPPING.PLANT_NAME,'Jolesch Commencement Orders' AS SUB_PROGRAM_NAME,'YTD' AS TIME_FRAME,1 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,SUM(0) AS Shipped_This_Year,COUNT(*) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM ODS.INF_HJ_ORDERS ORD,ODS.INF_EVENT E,RAX_APP_USER.COMM_PROF_SHIPPING_STG SHIPPING
WHERE ORD.EVENTID = E.ID
AND ORD.HJ_ORDER = SHIPPING.ORDER_NUMBER
AND SHIPPING.SHIPPED_ID IN (SELECT SHIPPED_ID FROM RAX_APP_USER.COMM_PROF_SHIPPED_STG s,MART.TIME t 
                                   WHERE  
                                   trunc(s.Date_Shipped) = t.date_key
                                   and t.fiscal_year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))- 1
                                   and t.sat_production_week_number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
                            )
Group By SHIPPING.PLANT_NAME,'Jolesch Commencement Orders','YTD',1

UNION ALL

-- WTD(Closed)

SELECT SHIPPING.PLANT_NAME,'Jolesch Commencement Orders' AS SUB_PROGRAM_NAME,'WTD(Closed)' AS TIME_FRAME,2 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,COUNT(*) AS Shipped_This_Year,SUM(0) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM ODS.INF_HJ_ORDERS ORD,ODS.INF_EVENT E,RAX_APP_USER.COMM_PROF_SHIPPING_STG SHIPPING
WHERE ORD.EVENTID = E.ID
AND ORD.HJ_ORDER = SHIPPING.ORDER_NUMBER
AND SHIPPING.SHIPPED_ID IN (SELECT SHIPPED_ID FROM RAX_APP_USER.COMM_PROF_SHIPPED_STG s,MART.TIME t 
                                   WHERE  
                                   trunc(s.Date_Shipped) = t.date_key
                                   AND T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
                                   And T.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual)) - 1
                            )
Group By SHIPPING.PLANT_NAME,'Jolesch Commencement Orders','WTD(Closed)',2

UNION ALL


SELECT SHIPPING.PLANT_NAME,'Jolesch Commencement Orders' AS SUB_PROGRAM_NAME,'WTD(Closed)' AS TIME_FRAME,2 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,SUM(0) AS Shipped_This_Year,COUNT(*) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM ODS.INF_HJ_ORDERS ORD,ODS.INF_EVENT E,RAX_APP_USER.COMM_PROF_SHIPPING_STG SHIPPING
WHERE ORD.EVENTID = E.ID
AND ORD.HJ_ORDER = SHIPPING.ORDER_NUMBER
AND SHIPPING.SHIPPED_ID IN (SELECT SHIPPED_ID FROM RAX_APP_USER.COMM_PROF_SHIPPED_STG s,MART.TIME t 
                                   WHERE  
                                   trunc(s.Date_Shipped) = t.date_key
                                   AND T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
                                   And T.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual)) - 1
                            )
Group By SHIPPING.PLANT_NAME,'Jolesch Commencement Orders','WTD(Closed)',2

UNION ALL

-- MTD(Closed)

SELECT SHIPPING.PLANT_NAME,'Jolesch Commencement Orders' AS SUB_PROGRAM_NAME,'MTD(Closed)' AS TIME_FRAME,5 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,COUNT(*)  AS Shipped_This_Year,SUM(0)AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM ODS.INF_HJ_ORDERS ORD,ODS.INF_EVENT E,RAX_APP_USER.COMM_PROF_SHIPPING_STG SHIPPING
WHERE ORD.EVENTID = E.ID
AND ORD.HJ_ORDER = SHIPPING.ORDER_NUMBER
AND SHIPPING.SHIPPED_ID IN (SELECT SHIPPED_ID FROM RAX_APP_USER.COMM_PROF_SHIPPED_STG s,MART.TIME t 
                                   WHERE  
                                   trunc(s.Date_Shipped) = t.date_key
                                   AND T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
	             And T.Month_Number = (Select Month_Number-1 From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
                            )
Group By SHIPPING.PLANT_NAME,'Jolesch Commencement Orders','MTD(Closed)',5

UNION ALL

SELECT SHIPPING.PLANT_NAME,'Jolesch Commencement Orders' AS SUB_PROGRAM_NAME,'MTD(Closed)' AS TIME_FRAME,5 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,SUM(0) AS Shipped_This_Year,COUNT(*) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM ODS.INF_HJ_ORDERS ORD,ODS.INF_EVENT E,RAX_APP_USER.COMM_PROF_SHIPPING_STG SHIPPING
WHERE ORD.EVENTID = E.ID
AND ORD.HJ_ORDER = SHIPPING.ORDER_NUMBER
AND SHIPPING.SHIPPED_ID IN (SELECT SHIPPED_ID FROM RAX_APP_USER.COMM_PROF_SHIPPED_STG s,MART.TIME t 
                                   WHERE  
                                   trunc(s.Date_Shipped) = t.date_key
                                   AND T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))- 1
                                   And T.Month_Number = (Select Month_Number-1 From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
                            )
Group By SHIPPING.PLANT_NAME,'Jolesch Commencement Orders','MTD(Closed)',5

UNION ALL
-- Season To Date(STD)

SELECT SHIPPING.PLANT_NAME,'Jolesch Commencement Orders' AS SUB_PROGRAM_NAME,'STD' AS TIME_FRAME,4 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,COUNT(*) AS Shipped_This_Year,SUM(0) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM ODS.INF_HJ_ORDERS ORD,ODS.INF_EVENT E,RAX_APP_USER.COMM_PROF_SHIPPING_STG SHIPPING
WHERE ORD.EVENTID = E.ID
AND ORD.HJ_ORDER = SHIPPING.ORDER_NUMBER
AND SHIPPING.SHIPPED_ID IN (SELECT SHIPPED_ID FROM RAX_APP_USER.COMM_PROF_SHIPPED_STG s,MART.TIME t 
                                   WHERE  
                                   trunc(s.Date_Shipped) = t.date_key
                                   AND T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
	              And T.Season_Name = (Select Season_Name From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
                                   And T.Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
                            )
Group By SHIPPING.PLANT_NAME,'Jolesch Commencement Orders','STD',4

UNION ALL

SELECT SHIPPING.PLANT_NAME,'Jolesch Commencement Orders' AS SUB_PROGRAM_NAME,'STD' AS TIME_FRAME,4 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,SUM(0) AS Shipped_This_Year,COUNT(*) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM ODS.INF_HJ_ORDERS ORD,ODS.INF_EVENT E,RAX_APP_USER.COMM_PROF_SHIPPING_STG SHIPPING
WHERE ORD.EVENTID = E.ID
AND ORD.HJ_ORDER = SHIPPING.ORDER_NUMBER
AND SHIPPING.SHIPPED_ID IN (SELECT SHIPPED_ID FROM RAX_APP_USER.COMM_PROF_SHIPPED_STG s,MART.TIME t 
                                   WHERE  
                                   trunc(s.Date_Shipped) = t.date_key
	             AND T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))- 1
	             AND T.Season_Name = (Select Season_Name From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
	             AND T.Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual)) 
                            )
Group By SHIPPING.PLANT_NAME,'Jolesch Commencement Orders','STD',4

UNION ALL

--WTD(Curr)

SELECT SHIPPING.PLANT_NAME,'Jolesch Commencement Orders' AS SUB_PROGRAM_NAME,'WTD(Curr)' AS TIME_FRAME,3 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,COUNT(*) AS Shipped_This_Year,SUM(0) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM ODS.INF_HJ_ORDERS ORD,ODS.INF_EVENT E,RAX_APP_USER.COMM_PROF_SHIPPING_STG SHIPPING
WHERE ORD.EVENTID = E.ID
AND ORD.HJ_ORDER = SHIPPING.ORDER_NUMBER
AND SHIPPING.SHIPPED_ID IN (SELECT SHIPPED_ID FROM RAX_APP_USER.COMM_PROF_SHIPPED_STG s,MART.TIME t 
                                   WHERE  
                                   trunc(s.Date_Shipped) = t.date_key
	              And T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
                                   And T.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
                            )
Group By SHIPPING.PLANT_NAME,'Jolesch Commencement Orders','WTD(Curr)',3

UNION ALL

SELECT SHIPPING.PLANT_NAME,'Jolesch Commencement Orders' AS SUB_PROGRAM_NAME,'WTD(Curr)' AS TIME_FRAME,3 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,SUM(0) AS Shipped_This_Year,COUNT(*) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM ODS.INF_HJ_ORDERS ORD,ODS.INF_EVENT E,RAX_APP_USER.COMM_PROF_SHIPPING_STG SHIPPING
WHERE ORD.EVENTID = E.ID
AND ORD.HJ_ORDER = SHIPPING.ORDER_NUMBER
AND SHIPPING.SHIPPED_ID IN (SELECT SHIPPED_ID FROM RAX_APP_USER.COMM_PROF_SHIPPED_STG s,MART.TIME t 
                                   WHERE  
                                   trunc(s.Date_Shipped) = t.date_key
	             and T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
                                   And T.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
                            )
Group By SHIPPING.PLANT_NAME,'Jolesch Commencement Orders','WTD(Curr)',3


UNION ALL

-- Jolesch Commencement Proofsets
-- YTD


SELECT J.PLANT_NAME,'Jolesch Commencement Proofsets' AS SUB_PROGRAM_NAME,'YTD' AS TIME_FRAME,1 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,SUM(J.NUMMAILERS) AS Shipped_This_Year,SUM(0) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM RAX_APP_USER.COMM_JOLESCHMAILERS_STG J,MART.TIME T
WHERE 1 = 1 
AND TRUNC(J.DATESHIPPED) = T.DATE_KEY
AND T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And T.Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
Group By J.PLANT_NAME,'Jolesch Commencement Proofsets','YTD',1

UNION ALL

SELECT J.PLANT_NAME,'Jolesch Commencement Proofsets' AS SUB_PROGRAM_NAME,'YTD' AS TIME_FRAME,1 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,SUM(0) AS Shipped_This_Year,SUM(J.NUMMAILERS) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM RAX_APP_USER.COMM_JOLESCHMAILERS_STG J,MART.TIME T
WHERE 1 = 1
AND TRUNC(J.DATESHIPPED) = T.DATE_KEY
AND T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And T.Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
Group By J.PLANT_NAME,'Jolesch Commencement Proofsets','YTD',1

UNION ALL

-- WTD(Closed)

SELECT J.PLANT_NAME,'Jolesch Commencement Proofsets' AS SUB_PROGRAM_NAME,'WTD(Closed)' AS TIME_FRAME,2 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,SUM(J.NUMMAILERS) AS Shipped_This_Year,SUM(0) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM RAX_APP_USER.COMM_JOLESCHMAILERS_STG J,MART.TIME T
WHERE 1 = 1
AND TRUNC(J.DATESHIPPED) = T.DATE_KEY
AND T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And T.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual)) - 1
Group By J.PLANT_NAME,'Jolesch Commencement Proofsets','WTD(Closed)',2

UNION ALL


SELECT J.PLANT_NAME,'Jolesch Commencement Proofsets' AS SUB_PROGRAM_NAME,'WTD(Closed)' AS TIME_FRAME,2 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,SUM(0) AS Shipped_This_Year,SUM(J.NUMMAILERS) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM RAX_APP_USER.COMM_JOLESCHMAILERS_STG J,MART.TIME T
WHERE 1 = 1
AND TRUNC(J.DATESHIPPED) = T.DATE_KEY
AND T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And T.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual)) - 1
Group By J.PLANT_NAME,'Jolesch Commencement Proofsets','WTD(Closed)',2

UNION ALL

-- MTD(Closed)

SELECT J.PLANT_NAME,'Jolesch Commencement Proofsets' AS SUB_PROGRAM_NAME,'MTD(Closed)' AS TIME_FRAME,5 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,SUM(J.NUMMAILERS)  AS Shipped_This_Year,SUM(0)AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM RAX_APP_USER.COMM_JOLESCHMAILERS_STG J,MART.TIME T
WHERE  1 = 1
AND TRUNC(J.DATESHIPPED) = T.DATE_KEY
AND T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And T.Month_Number = (Select Month_Number-1 From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
Group By J.PLANT_NAME,'Jolesch Commencement Proofsets','MTD(Closed)',5

UNION ALL

SELECT J.PLANT_NAME,'Jolesch Commencement Proofsets' AS SUB_PROGRAM_NAME,'MTD(Closed)' AS TIME_FRAME,5 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,SUM(0) AS Shipped_This_Year,SUM(J.NUMMAILERS) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM RAX_APP_USER.COMM_JOLESCHMAILERS_STG J,MART.TIME T
WHERE 1 = 1
AND TRUNC(J.DATESHIPPED) = T.DATE_KEY
AND T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))- 1
And T.Month_Number = (Select Month_Number-1 From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
Group By J.PLANT_NAME,'Jolesch Commencement Proofsets','MTD(Closed)',5

UNION ALL
-- Season To Date(STD)

SELECT J.PLANT_NAME,'Jolesch Commencement Proofsets' AS SUB_PROGRAM_NAME,'STD' AS TIME_FRAME,4 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,SUM(J.NUMMAILERS) AS Shipped_This_Year,SUM(0) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM RAX_APP_USER.COMM_JOLESCHMAILERS_STG J,MART.TIME T
WHERE 1 = 1
AND TRUNC(J.DATESHIPPED) = T.DATE_KEY
AND T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And T.Season_Name = (Select Season_Name From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
And T.Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
Group By J.PLANT_NAME,'Jolesch Commencement Proofsets','STD',4

UNION ALL

SELECT J.PLANT_NAME,'Jolesch Commencement Proofsets' AS SUB_PROGRAM_NAME,'STD' AS TIME_FRAME,4 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,SUM(0) AS Shipped_This_Year,SUM(J.NUMMAILERS) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM RAX_APP_USER.COMM_JOLESCHMAILERS_STG J,MART.TIME T
WHERE 1 = 1
AND TRUNC(J.DATESHIPPED) = T.DATE_KEY
AND T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))- 1
And T.Season_Name = (Select Season_Name From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
And T.Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
Group By J.PLANT_NAME,'Jolesch Commencement Proofsets','STD',4

UNION ALL

--WTD(Curr)

SELECT J.PLANT_NAME,'Jolesch Commencement Proofsets' AS SUB_PROGRAM_NAME,'WTD(Curr)' AS TIME_FRAME,3 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,SUM(J.NUMMAILERS) AS Shipped_This_Year,SUM(0) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM RAX_APP_USER.COMM_JOLESCHMAILERS_STG J,MART.TIME T
WHERE 1 = 1
AND TRUNC(J.DATESHIPPED) = T.DATE_KEY
AND T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
AND T.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
Group By J.PLANT_NAME,'Jolesch Commencement Proofsets','WTD(Curr)',3

UNION ALL

SELECT  J.PLANT_NAME,'Jolesch Commencement Proofsets' AS SUB_PROGRAM_NAME,'WTD(Curr)' AS TIME_FRAME,3 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,SUM(0) AS Shipped_This_Year,SUM(J.NUMMAILERS) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM RAX_APP_USER.COMM_JOLESCHMAILERS_STG J,MART.TIME T
WHERE 1 = 1
AND TRUNC(J.DATESHIPPED) = T.DATE_KEY
and T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And T.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
Group By J.PLANT_NAME,'Jolesch Commencement Proofsets','WTD(Curr)',3

UNION ALL

-- Sportography Web Orders
-- YTD


SELECT 'Chattanooga' AS PLANT_NAME,'Sportography Web Orders' AS SUB_PROGRAM_NAME,'YTD' AS TIME_FRAME,1 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,COUNT(Orders.order_id) AS Shipped_This_Year,SUM(0) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM 
           ODS_STAGE.PROF_JOBS_STG jobs
          ,ODS_STAGE.PROF_ORDERS_STG orders
WHERE jobs.job_id=Orders.Job_ID 
AND  jobs.Workflow IN (1) AND jobs.account_id NOT IN(27)   
AND  jobs.workflow_Sub_type NOT IN (1,13)  
AND  jobs.job_number IN  
                         (SELECT job_number FROM ods_stage.prof_shipping_stg  
                          WHERE shipped_id IN  
                                  (SELECT     Shipped_Id  FROM      ods_stage.prof_shipped_stg s,mart.time t 
                                   WHERE      (s.Shipped_Id <> 10)AND 
                                    trunc(s.Date_Shipped) = t.date_key
                                    and t.fiscal_year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
                                    and t.sat_production_week_number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
                                    ) )
Group By 'Chattanooga','Sportography Web Orders','YTD',1


UNION ALL

SELECT 'Chattanooga' AS PLANT_NAME,'Sportography Web Orders' AS SUB_PROGRAM_NAME,'YTD' AS TIME_FRAME,1 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,SUM(0) AS Shipped_This_Year,COUNT(Orders.order_id) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM 
           ODS_STAGE.PROF_JOBS_STG jobs
          ,ODS_STAGE.PROF_ORDERS_STG orders
WHERE jobs.job_id=Orders.Job_ID 
AND  jobs.Workflow IN (1) AND jobs.account_id NOT IN(27)   
AND  jobs.workflow_Sub_type NOT IN (1,13)  
AND  jobs.job_number IN  
                         (SELECT job_number FROM ods_stage.prof_shipping_stg  
                          WHERE shipped_id IN  
                                  (SELECT     Shipped_Id  FROM      ods_stage.prof_shipped_stg s,mart.time t 
                                   WHERE      (s.Shipped_Id <> 10)AND 
                                    trunc(s.Date_Shipped) = t.date_key
                                    and t.fiscal_year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))- 1
                                    and t.sat_production_week_number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
                                    ) )
Group By 'Chattanooga','Sportography Web Orders','YTD',1


UNION ALL

-- WTD(Closed)

SELECT 'Chattanooga' AS PLANT_NAME,'Sportography Web Orders' AS SUB_PROGRAM_NAME,'WTD(Closed)' AS TIME_FRAME,2 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,COUNT(Orders.order_id) AS Shipped_This_Year,SUM(0) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM 
           ODS_STAGE.PROF_JOBS_STG jobs
          ,ODS_STAGE.PROF_ORDERS_STG orders
WHERE jobs.job_id=Orders.Job_ID 
AND  jobs.Workflow IN (1) AND jobs.account_id NOT IN(27)   
AND  jobs.workflow_Sub_type NOT IN (1,13)  
AND  jobs.job_number IN  
                         (SELECT job_number FROM ods_stage.prof_shipping_stg  
                          WHERE shipped_id IN  
                                  (SELECT     Shipped_Id  FROM      ods_stage.prof_shipped_stg s,mart.time t 
                                   WHERE      (s.Shipped_Id <> 10)AND 
                                    trunc(s.Date_Shipped) = t.date_key
                                    AND T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
                                    And T.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual)) - 1
                                    ))
Group By 'Chattanooga','Sportography Web Orders','WTD(Closed)',2

UNION ALL


SELECT 'Chattanooga' AS PLANT_NAME,'Sportography Web Orders' AS SUB_PROGRAM_NAME,'WTD(Closed)' AS TIME_FRAME,2 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,SUM(0) AS Shipped_This_Year,COUNT(Orders.order_id) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM 
           ODS_STAGE.PROF_JOBS_STG jobs
          ,ODS_STAGE.PROF_ORDERS_STG orders
WHERE jobs.job_id=Orders.Job_ID 
AND  jobs.Workflow IN (1) AND jobs.account_id NOT IN(27)   
AND  jobs.workflow_Sub_type NOT IN (1,13)  
AND  jobs.job_number IN  
                         (SELECT job_number FROM ods_stage.prof_shipping_stg  
                          WHERE shipped_id IN  
                                  (SELECT     Shipped_Id  FROM      ods_stage.prof_shipped_stg s,mart.time t 
                                   WHERE      (s.Shipped_Id <> 10)AND 
                                    trunc(s.Date_Shipped) = t.date_key
                                    AND T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
                                    And T.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual)) - 1
                                    ) )
Group By 'Chattanooga','Sportography Web Orders','WTD(Closed)',2


UNION ALL

-- MTD(Closed)

SELECT 'Chattanooga' AS PLANT_NAME,'Sportography Web Orders' AS SUB_PROGRAM_NAME,'MTD(Closed)' AS TIME_FRAME,5 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,COUNT(Orders.order_id)  AS Shipped_This_Year,SUM(0)AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM 
           ODS_STAGE.PROF_JOBS_STG jobs
          ,ODS_STAGE.PROF_ORDERS_STG orders
WHERE jobs.job_id=Orders.Job_ID 
AND  jobs.Workflow IN (1) AND jobs.account_id NOT IN(27)   
AND  jobs.workflow_Sub_type NOT IN (1,13)  
AND  jobs.job_number IN  
                         (SELECT job_number FROM ods_stage.prof_shipping_stg  
                          WHERE shipped_id IN  
                                  (SELECT     Shipped_Id  FROM      ods_stage.prof_shipped_stg s,mart.time t 
                                   WHERE      (s.Shipped_Id <> 10)AND 
                                    trunc(s.Date_Shipped) = t.date_key
                                    AND T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
                                    And T.Month_Number = (Select Month_Number-1 From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
                                    ) )
Group By 'Chattanooga','Sportography Web Orders','MTD(Closed)',5

UNION ALL

SELECT 'Chattanooga' AS PLANT_NAME,'Sportography Web Orders' AS SUB_PROGRAM_NAME,'MTD(Closed)' AS TIME_FRAME,5 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,SUM(0) AS Shipped_This_Year,COUNT(Orders.order_id) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM 
           ODS_STAGE.PROF_JOBS_STG jobs
          ,ODS_STAGE.PROF_ORDERS_STG orders
WHERE jobs.job_id=Orders.Job_ID 
AND  jobs.Workflow IN (1) AND jobs.account_id NOT IN(27)   
AND  jobs.workflow_Sub_type NOT IN (1,13)  
AND  jobs.job_number IN  
                         (SELECT job_number FROM ods_stage.prof_shipping_stg  
                          WHERE shipped_id IN  
                                  (SELECT     Shipped_Id  FROM      ods_stage.prof_shipped_stg s,mart.time t 
                                   WHERE      (s.Shipped_Id <> 10)AND 
                                    trunc(s.Date_Shipped) = t.date_key
                                    AND T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))- 1
                                    And T.Month_Number = (Select Month_Number-1 From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
                                    ) )
Group By 'Chattanooga','Sportography Web Orders','MTD(Closed)',5

UNION ALL
-- Season To Date(STD)

SELECT 'Chattanooga' AS PLANT_NAME,'Sportography Web Orders' AS SUB_PROGRAM_NAME,'STD' AS TIME_FRAME,4 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,COUNT(Orders.order_id) AS Shipped_This_Year,SUM(0) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM 
           ODS_STAGE.PROF_JOBS_STG jobs
          ,ODS_STAGE.PROF_ORDERS_STG orders
WHERE jobs.job_id=Orders.Job_ID 
AND  jobs.Workflow IN (1) AND jobs.account_id NOT IN(27)   
AND  jobs.workflow_Sub_type NOT IN (1,13)  
AND  jobs.job_number IN  
                         (SELECT job_number FROM ods_stage.prof_shipping_stg  
                          WHERE shipped_id IN  
                                  (SELECT     Shipped_Id  FROM      ods_stage.prof_shipped_stg s,mart.time t 
                                   WHERE      (s.Shipped_Id <> 10)AND 
                                    trunc(s.Date_Shipped) = t.date_key
                                    AND T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
                                    AND T.Season_Name = (Select Season_Name From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
                                    AND T.Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
                                    ) )
Group By 'Chattanooga','Sportography Web Orders','STD',4


UNION ALL

SELECT 'Chattanooga' AS PLANT_NAME,'Sportography Web Orders' AS SUB_PROGRAM_NAME,'STD' AS TIME_FRAME,4 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,SUM(0) AS Shipped_This_Year,COUNT(Orders.order_id) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM 
           ODS_STAGE.PROF_JOBS_STG jobs
          ,ODS_STAGE.PROF_ORDERS_STG orders
WHERE jobs.job_id=Orders.Job_ID 
AND  jobs.Workflow IN (1) AND jobs.account_id NOT IN(27)   
AND  jobs.workflow_Sub_type NOT IN (1,13)  
AND  jobs.job_number IN  
                         (SELECT job_number FROM ods_stage.prof_shipping_stg  
                          WHERE shipped_id IN  
                                  (SELECT     Shipped_Id  FROM      ods_stage.prof_shipped_stg s,mart.time t 
                                   WHERE      (s.Shipped_Id <> 10)AND 
                                    trunc(s.Date_Shipped) = t.date_key
                                    AND T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))- 1
                                    And T.Season_Name = (Select Season_Name From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
                                    And T.Sat_Production_Week_Number < (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual)) 
                                    ) )
Group By 'Chattanooga','Sportography Web Orders','STD',4


UNION ALL

--WTD(Curr)

SELECT 'Chattanooga' AS PLANT_NAME,'Sportography Web Orders' AS SUB_PROGRAM_NAME,'WTD(Curr)' AS TIME_FRAME,3 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,COUNT(Orders.order_id) AS Shipped_This_Year,SUM(0) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM 
           ODS_STAGE.PROF_JOBS_STG jobs
          ,ODS_STAGE.PROF_ORDERS_STG orders
WHERE jobs.job_id=Orders.Job_ID 
AND  jobs.Workflow IN (1) AND jobs.account_id NOT IN(27)   
AND  jobs.workflow_Sub_type NOT IN (1,13)  
AND  jobs.job_number IN  
                         (SELECT job_number FROM ods_stage.prof_shipping_stg  
                          WHERE shipped_id IN  
                                  (SELECT     Shipped_Id  FROM      ods_stage.prof_shipped_stg s,mart.time t 
                                   WHERE      (s.Shipped_Id <> 10)AND 
                                    trunc(s.Date_Shipped) = t.date_key
                                    And T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
                                    And T.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
                                    ) )
Group By 'Chattanooga','Sportography Web Orders','WTD(Curr)',3


UNION ALL

SELECT 'Chattanooga' AS PLANT_NAME,'Sportography Web Orders' AS SUB_PROGRAM_NAME,'WTD(Curr)' AS TIME_FRAME,3 as SORT_ORDER,
SUM(0) AS Ordered_This_Year,SUM(0) AS Ordered_Last_Year,SUM(0) AS Shipped_This_Year,COUNT(Orders.order_id) AS Shipped_Last_Year,
SUM(0) AS Unshipped_This_Year,SUM(0) AS Unshipped_Last_Year
FROM 
           ODS_STAGE.PROF_JOBS_STG jobs
          ,ODS_STAGE.PROF_ORDERS_STG orders
WHERE jobs.job_id=Orders.Job_ID 
AND  jobs.Workflow IN (1) AND jobs.account_id NOT IN(27)   
AND  jobs.workflow_Sub_type NOT IN (1,13)  
AND  jobs.job_number IN  
                         (SELECT job_number FROM ods_stage.prof_shipping_stg  
                          WHERE shipped_id IN  
                                  (SELECT     Shipped_Id  FROM      ods_stage.prof_shipped_stg s,mart.time t 
                                   WHERE      (s.Shipped_Id <> 10)AND 
                                    trunc(s.Date_Shipped) = t.date_key
                                    And T.Fiscal_Year = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
                                    And T.Sat_Production_Week_Number = (Select Sat_Production_Week_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
                                    ) )
Group By 'Chattanooga','Sportography Web Orders','WTD(Curr)',3

)A
Where A.Plant_Name Not In ('Charlotte')
Group By A.Plant_Name,'Consumer',A.Sub_Program_Name,A.Time_Frame,A.Sort_Order,NULL,NULL,TRUNC(SYSDATE)
Order By A.Plant_Name,A.Sub_Program_Name,A.Sort_Order

&


/*-----------------------------------------------*/
/* TASK No. 4 */
/* Load Target Table */

INSERT INTO MART.AGG_PR_FLASH_CARD_FACT
SELECT  /*+Parallel(A,6)*/
      PROCESSING_LAB,
      'Service Item',
      NULL,  
      TIME_FRAME,
      SORT_ORDER,            
      ITEM_ID,
      DESCRIPTION,
      NVL(SUM(ORDERED_QTY_THIS_YEAR),0),
      SUM(ORDERED_QTY_LAST_YEAR),
      NVL(SUM(ORDERED_QTY_THIS_YEAR),0) - SUM(ORDERED_QTY_LAST_YEAR), 
      NVL(SUM(SHIPPED_QTY_THIS_YEAR),0),      
      SUM(SHIPPED_QTY_LAST_YEAR),
      NVL(SUM(SHIPPED_QTY_THIS_YEAR),0) - SUM(SHIPPED_QTY_LAST_YEAR),
      NULL,
      NULL,
      NULL,
      TRUNC(SYSDATE)             
FROM
(
SELECT  
     'YTD' AS TIME_FRAME,
     1 AS SORT_ORDER,
     EVENT.PROCESSING_LAB,     
     TIME.FISCAL_YEAR,
     ITEM.ITEM_ID,ITEM.DESCRIPTION,                      
CASE 
WHEN ITEM.ITEM_ID IN ('650','651','652','653','770','771','772',
                       '773','774','776','777','793','794','795',
                       '796','901','902','660','696','679','904','610')
        THEN GSI.SERVICE_ITEM_QTY   
WHEN ITEM.ITEM_ID IN ('341','342','343','615','601','604','618','501','633',
                       '634','635','636','637','312','602','603','648') 
        THEN GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY 
WHEN ITEM.ITEM_ID IN ('623','624','625','626','627','628','638','639','640',
                      '641','642','645','646','647','643','644')
        THEN (GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY)+GSI.ADDITIONAL_QTY
WHEN ITEM.ITEM_ID IN ('620','621','622','111','112','113','100','121','122')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * GSI.ADDITIONAL_QTY )
WHEN ITEM.ITEM_ID IN ('510','511','512','513','514','515','520','521','522',
                      '523','524','525','530','531','532')
        THEN (GSI.SERVICE_ITEM_QTY*NVL(APO.ROOM_QTY,1))
WHEN ITEM.ITEM_ID IN ('649','677','797','920','921') THEN (GSI.SHIPPED_ITEM_QTY)
END  ORDERED_QTY_THIS_YEAR,      
0 AS ORDERED_QTY_LAST_YEAR,                                 
CASE 
WHEN ITEM.ITEM_ID IN ('650','651','652','653','770','771','772',
                       '773','774','776','777','793','794','795',
                       '796','901','902','660','696','679','904','610')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN GSI.SERVICE_ITEM_QTY   
WHEN ITEM.ITEM_ID IN ('341','342','343','615','601','604','618','501','633',
                       '634','635','636','637','312','602','603','648') 
        AND GSI.SHIPPED_ITEM_QTY >0 THEN GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY 
WHEN ITEM.ITEM_ID IN ('623','624','625','626','627','628','638','639','640',
                      '641','642','645','646','647','643','644')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY)+GSI.ADDITIONAL_QTY 
WHEN ITEM.ITEM_ID IN ('620','621','622','111','112','113','100','121','122')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * GSI.ADDITIONAL_QTY )
WHEN ITEM.ITEM_ID IN ('510','511','512','513','514','515','520','521','522',
                      '523','524','525','530','531','532')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY* NVL(APO.ROOM_QTY,1))
WHEN ITEM.ITEM_ID IN ('649','677','797','920','921') 
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SHIPPED_ITEM_QTY)        
END  SHIPPED_QTY_THIS_YEAR,
0 AS SHIPPED_QTY_LAST_YEAR                                          
FROM ODS.GDT_SERVICE_ITEM_CURR GSI,  
     ODS_OWN.ITEM,
     ODS_OWN.EVENT,
     MART.TIME,
     ODS_OWN.APO
WHERE
1 = 1 
AND GSI.SERVICE_ITEM_CODE = ITEM.ITEM_ID
AND TRUNC(GSI.EFFECTIVE_DATE) = TIME.DATE_KEY
AND GSI.JOB_NBR = EVENT.EVENT_REF_ID
AND EVENT.APO_OID = APO.APO_OID(+)
AND GSI.FISCAL_YEAR = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And TIME.SAT_PRODUCTION_WEEK_NUMBER < (Select Sat_Production_Week_Number From Time 
                                       Where Date_Key = (Select Trunc(Sysdate) From Dual))

UNION ALL
---------- WTD(Closed)
select  
     'WTD(Closed)' AS TIME_FRAME,
     2 AS SORT_ORDER,
     EVENT.PROCESSING_LAB,
     TIME.FISCAL_YEAR,
     ITEM.ITEM_ID,ITEM.DESCRIPTION,                      
CASE 
WHEN ITEM.ITEM_ID IN ('650','651','652','653','770','771','772',
                       '773','774','776','777','793','794','795',
                       '796','901','902','660','696','679','904','610')
        THEN GSI.SERVICE_ITEM_QTY   
WHEN ITEM.ITEM_ID IN ('341','342','343','615','601','604','618','501','633',
                       '634','635','636','637','312','602','603','648') 
        THEN GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY 
WHEN ITEM.ITEM_ID IN ('623','624','625','626','627','628','638','639','640',
                      '641','642','645','646','647','643','644')
        THEN (GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY)+GSI.ADDITIONAL_QTY
WHEN ITEM.ITEM_ID IN ('620','621','622','111','112','113','100','121','122')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * GSI.ADDITIONAL_QTY )
WHEN ITEM.ITEM_ID IN ('510','511','512','513','514','515','520','521','522',
                      '523','524','525','530','531','532')
        THEN (GSI.SERVICE_ITEM_QTY*NVL(APO.ROOM_QTY,1))
WHEN ITEM.ITEM_ID IN ('649','677','797','920','921') THEN (GSI.SHIPPED_ITEM_QTY)
END  ORDERED_QTY_THIS_YEAR,   
0 AS ORDERED_QTY_LAST_YEAR,                                    
CASE 
WHEN ITEM.ITEM_ID IN ('650','651','652','653','770','771','772',
                       '773','774','776','777','793','794','795',
                       '796','901','902','660','696','679','904','610')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN GSI.SERVICE_ITEM_QTY   
WHEN ITEM.ITEM_ID IN ('341','342','343','615','601','604','618','501','633',
                       '634','635','636','637','312','602','603','648') 
        AND GSI.SHIPPED_ITEM_QTY >0 THEN GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY 
WHEN ITEM.ITEM_ID IN ('623','624','625','626','627','628','638','639','640',
                      '641','642','645','646','647','643','644')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY)+GSI.ADDITIONAL_QTY 
WHEN ITEM.ITEM_ID IN ('620','621','622','111','112','113','100','121','122')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * GSI.ADDITIONAL_QTY )
WHEN ITEM.ITEM_ID IN ('510','511','512','513','514','515','520','521','522',
                      '523','524','525','530','531','532')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY* NVL(APO.ROOM_QTY,1))
WHEN ITEM.ITEM_ID IN ('649','677','797','920','921') 
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SHIPPED_ITEM_QTY)
END  SHIPPED_QTY_THIS_YEAR,
0 AS SHIPPED_QTY_LAST_YEAR                                        
FROM ODS.GDT_SERVICE_ITEM_CURR GSI,  
     ODS_OWN.ITEM,
     ODS_OWN.EVENT,
     MART.TIME,
     ODS_OWN.APO
WHERE
1 = 1 
AND GSI.SERVICE_ITEM_CODE = ITEM.ITEM_ID
AND TRUNC(GSI.EFFECTIVE_DATE) = TIME.DATE_KEY
AND GSI.JOB_NBR = EVENT.EVENT_REF_ID
AND EVENT.APO_OID = APO.APO_OID(+)
AND GSI.FISCAL_YEAR = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And TIME.SAT_PRODUCTION_WEEK_NUMBER = (Select Sat_Production_Week_Number From Time Where Date_Key = 
                                              (Select Trunc(Sysdate) From Dual)) - 1

UNION ALL
---------- WeekToDate(Open)
select  
     'WTD(Open)' AS TIME_FRAME,
     3 AS SORT_ORDER,
     EVENT.PROCESSING_LAB,
     TIME.FISCAL_YEAR,
     ITEM.ITEM_ID,ITEM.DESCRIPTION,                      
CASE 
WHEN ITEM.ITEM_ID IN ('650','651','652','653','770','771','772',
                       '773','774','776','777','793','794','795',
                       '796','901','902','660','696','679','904','610')
        THEN GSI.SERVICE_ITEM_QTY   
WHEN ITEM.ITEM_ID IN ('341','342','343','615','601','604','618','501','633',
                       '634','635','636','637','312','602','603','648') 
        THEN GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY 
WHEN ITEM.ITEM_ID IN ('623','624','625','626','627','628','638','639','640',
                      '641','642','645','646','647','643','644')
        THEN (GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY)+GSI.ADDITIONAL_QTY
WHEN ITEM.ITEM_ID IN ('620','621','622','111','112','113','100','121','122')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * GSI.ADDITIONAL_QTY )
WHEN ITEM.ITEM_ID IN ('510','511','512','513','514','515','520','521','522',
                      '523','524','525','530','531','532')
        THEN (GSI.SERVICE_ITEM_QTY*NVL(APO.ROOM_QTY,1))
WHEN ITEM.ITEM_ID IN ('649','677','797','920','921') THEN (GSI.SHIPPED_ITEM_QTY)
END  ORDERED_QTY_THIS_YEAR, 
0 AS ORDERED_QTY_LAST_YEAR,                                      
CASE 
WHEN ITEM.ITEM_ID IN ('650','651','652','653','770','771','772',
                       '773','774','776','777','793','794','795',
                       '796','901','902','660','696','679','904','610')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN GSI.SERVICE_ITEM_QTY   
WHEN ITEM.ITEM_ID IN ('341','342','343','615','601','604','618','501','633',
                       '634','635','636','637','312','602','603','648') 
        AND GSI.SHIPPED_ITEM_QTY >0 THEN GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY 
WHEN ITEM.ITEM_ID IN ('623','624','625','626','627','628','638','639','640',
                      '641','642','645','646','647','643','644')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY)+GSI.ADDITIONAL_QTY 
WHEN ITEM.ITEM_ID IN ('620','621','622','111','112','113','100','121','122')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * GSI.ADDITIONAL_QTY )
WHEN ITEM.ITEM_ID IN ('510','511','512','513','514','515','520','521','522',
                      '523','524','525','530','531','532')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY* NVL(APO.ROOM_QTY,1))
WHEN ITEM.ITEM_ID IN ('649','677','797','920','921') 
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SHIPPED_ITEM_QTY)
END  SHIPPED_QTY_THIS_YEAR,
0 AS SHIPPED_QTY_LAST_YEAR                                       
FROM ODS.GDT_SERVICE_ITEM_CURR GSI,  
     ODS_OWN.ITEM,
     ODS_OWN.EVENT,
     MART.TIME,
     ODS_OWN.APO
WHERE
1 = 1 
AND GSI.SERVICE_ITEM_CODE = ITEM.ITEM_ID
AND TRUNC(GSI.EFFECTIVE_DATE) = TIME.DATE_KEY
AND GSI.JOB_NBR = EVENT.EVENT_REF_ID
AND EVENT.APO_OID = APO.APO_OID(+)
AND GSI.FISCAL_YEAR = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And TIME.SAT_PRODUCTION_WEEK_NUMBER = (Select Sat_Production_Week_Number From Time 
                                       Where Date_Key = (Select Trunc(Sysdate) From Dual))


UNION ALL
---------- SeasonToDate(STD)
select  
     'STD' AS TIME_FRAME,
     4 AS SORT_ORDER,
     EVENT.PROCESSING_LAB,
     TIME.FISCAL_YEAR,
     ITEM.ITEM_ID,ITEM.DESCRIPTION,                      
CASE 
WHEN ITEM.ITEM_ID IN ('650','651','652','653','770','771','772',
                       '773','774','776','777','793','794','795',
                       '796','901','902','660','696','679','904','610')
        THEN GSI.SERVICE_ITEM_QTY   
WHEN ITEM.ITEM_ID IN ('341','342','343','615','601','604','618','501','633',
                       '634','635','636','637','312','602','603','648') 
        THEN GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY 
WHEN ITEM.ITEM_ID IN ('623','624','625','626','627','628','638','639','640',
                      '641','642','645','646','647','643','644')
        THEN (GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY)+GSI.ADDITIONAL_QTY
WHEN ITEM.ITEM_ID IN ('620','621','622','111','112','113','100','121','122')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * GSI.ADDITIONAL_QTY )
WHEN ITEM.ITEM_ID IN ('510','511','512','513','514','515','520','521','522',
                      '523','524','525','530','531','532')
        THEN (GSI.SERVICE_ITEM_QTY*NVL(APO.ROOM_QTY,1))
WHEN ITEM.ITEM_ID IN ('649','677','797','920','921') THEN (GSI.SHIPPED_ITEM_QTY)
END  ORDERED_QTY_THIS_YEAR, 
0 AS ORDERED_QTY_LAST_YEAR,                                      
CASE 
WHEN ITEM.ITEM_ID IN ('650','651','652','653','770','771','772',
                       '773','774','776','777','793','794','795',
                       '796','901','902','660','696','679','904','610')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN GSI.SERVICE_ITEM_QTY   
WHEN ITEM.ITEM_ID IN ('341','342','343','615','601','604','618','501','633',
                       '634','635','636','637','312','602','603','648') 
        AND GSI.SHIPPED_ITEM_QTY >0 THEN GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY 
WHEN ITEM.ITEM_ID IN ('623','624','625','626','627','628','638','639','640',
                      '641','642','645','646','647','643','644')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY)+GSI.ADDITIONAL_QTY 
WHEN ITEM.ITEM_ID IN ('620','621','622','111','112','113','100','121','122')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * GSI.ADDITIONAL_QTY )
WHEN ITEM.ITEM_ID IN ('510','511','512','513','514','515','520','521','522',
                      '523','524','525','530','531','532')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY* NVL(APO.ROOM_QTY,1))
WHEN ITEM.ITEM_ID IN ('649','677','797','920','921') 
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SHIPPED_ITEM_QTY)
END  SHIPPED_QTY_THIS_YEAR,
0 AS SHIPPED_QTY_LAST_YEAR                                         
FROM ODS.GDT_SERVICE_ITEM_CURR GSI,  
     ODS_OWN.ITEM,
     ODS_OWN.EVENT,
     MART.TIME,
     ODS_OWN.APO
WHERE
1 = 1 
AND GSI.SERVICE_ITEM_CODE = ITEM.ITEM_ID
AND TRUNC(GSI.EFFECTIVE_DATE) = TIME.DATE_KEY
AND GSI.JOB_NBR = EVENT.EVENT_REF_ID
AND EVENT.APO_OID = APO.APO_OID(+)
AND GSI.FISCAL_YEAR = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And TIME.Season_Name = (Select Season_Name From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
And TIME.SAT_PRODUCTION_WEEK_NUMBER < (Select Sat_Production_Week_Number From Time 
                                       Where Date_Key = (Select Trunc(Sysdate) From Dual))


UNION ALL
---------- MonthToDate(MTD)
select  
     'MTD(Closed)' AS TIME_FRAME,
     5 AS SORT_ORDER,
     EVENT.PROCESSING_LAB,
     --GSI.PLANT_CODE,
     --TIME.SEASON_NAME,
     TIME.FISCAL_YEAR,
     --TIME.FISCAL_WEEK_NUMBER,
     --TIME.SAT_PRODUCTION_WEEK_NUMBER,
     ITEM.ITEM_ID,ITEM.DESCRIPTION,                      
CASE 
WHEN ITEM.ITEM_ID IN ('650','651','652','653','770','771','772',
                       '773','774','776','777','793','794','795',
                       '796','901','902','660','696','679','904','610')
        THEN GSI.SERVICE_ITEM_QTY   
WHEN ITEM.ITEM_ID IN ('341','342','343','615','601','604','618','501','633',
                       '634','635','636','637','312','602','603','648') 
        THEN GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY 
WHEN ITEM.ITEM_ID IN ('623','624','625','626','627','628','638','639','640',
                      '641','642','645','646','647','643','644')
        THEN (GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY)+GSI.ADDITIONAL_QTY
WHEN ITEM.ITEM_ID IN ('620','621','622','111','112','113','100','121','122')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * GSI.ADDITIONAL_QTY )
WHEN ITEM.ITEM_ID IN ('510','511','512','513','514','515','520','521','522',
                      '523','524','525','530','531','532')
        THEN (GSI.SERVICE_ITEM_QTY*NVL(APO.ROOM_QTY,1))
WHEN ITEM.ITEM_ID IN ('649','677','797','920','921') THEN (GSI.SHIPPED_ITEM_QTY)
END  ORDERED_QTY_THIS_YEAR,
0 AS ORDERED_QTY_LAST_YEAR,                                       
CASE 
WHEN ITEM.ITEM_ID IN ('650','651','652','653','770','771','772',
                       '773','774','776','777','793','794','795',
                       '796','901','902','660','696','679','904','610')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN GSI.SERVICE_ITEM_QTY   
WHEN ITEM.ITEM_ID IN ('341','342','343','615','601','604','618','501','633',
                       '634','635','636','637','312','602','603','648') 
        AND GSI.SHIPPED_ITEM_QTY >0 THEN GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY 
WHEN ITEM.ITEM_ID IN ('623','624','625','626','627','628','638','639','640',
                      '641','642','645','646','647','643','644')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY)+GSI.ADDITIONAL_QTY 
WHEN ITEM.ITEM_ID IN ('620','621','622','111','112','113','100','121','122')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * GSI.ADDITIONAL_QTY )
WHEN ITEM.ITEM_ID IN ('510','511','512','513','514','515','520','521','522',
                      '523','524','525','530','531','532')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY* NVL(APO.ROOM_QTY,1))
WHEN ITEM.ITEM_ID IN ('649','677','797','920','921') 
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SHIPPED_ITEM_QTY)
END  SHIPPED_QTY_THIS_YEAR,
0 AS SHIPPED_QTY_LAST_YEAR                                        
FROM ODS.GDT_SERVICE_ITEM_CURR GSI,  
     ODS_OWN.ITEM,
     ODS_OWN.EVENT,
     MART.TIME,
     ODS_OWN.APO
WHERE
1 = 1 
AND GSI.SERVICE_ITEM_CODE = ITEM.ITEM_ID
AND TRUNC(GSI.EFFECTIVE_DATE) = TIME.DATE_KEY
AND GSI.JOB_NBR = EVENT.EVENT_REF_ID
AND EVENT.APO_OID = APO.APO_OID(+)
AND GSI.FISCAL_YEAR = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And TIME.Month_Number = (Select Month_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))-1

UNION ALL
--- Dummy Fill

SELECT /*+ PARALLEL(GSI,24) */
     DISTINCT 
     B.TIME_FRAME,     
     B.SORT_ORDER,
     EVENT.PROCESSING_LAB,     
     TIME.FISCAL_YEAR,    
     ITEM.ITEM_ID,ITEM.DESCRIPTION,                      
     0 AS ORDERED_QTY_THIS_YEAR,                                       
     0 AS SHIPPED_QTY_THIS_YEAR,
     0 AS ORDERED_QTY_LAST_YEAR,
     0 AS SHIPPED_QTY_LAST_YEAR                                        
FROM ODS.GDT_SERVICE_ITEM_CURR GSI,  
     ODS_OWN.ITEM,
     ODS_OWN.EVENT,
     MART.TIME     
     ,(SELECT 'YTD' AS TIME_FRAME,1 AS SORT_ORDER FROM DUAL
      UNION ALL 
      SELECT 'WTD(Closed)'AS TIME_FRAME,2 AS SORT_ORDER FROM DUAL
      UNION ALL 
      SELECT 'WTD(Open)' AS TIME_FRAME,3 AS SORT_ORDER FROM DUAL
      UNION ALL 
      SELECT 'STD'AS TIME_FRAME,4 AS SORT_ORDER FROM DUAL
      UNION ALL 
      SELECT 'MTD(Closed)'AS TIME_FRAME,5 AS SORT_ORDER FROM DUAL      
      )B      
WHERE
1 = 1 
AND GSI.SERVICE_ITEM_CODE = ITEM.ITEM_ID
AND TRUNC(GSI.EFFECTIVE_DATE) = TIME.DATE_KEY
AND GSI.JOB_NBR = EVENT.EVENT_REF_ID
AND GSI.FISCAL_YEAR = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE))
And TIME.SAT_PRODUCTION_WEEK_NUMBER <= (Select Sat_Production_Week_Number From Time 
                                       Where Date_Key = (Select Trunc(Sysdate) From Dual))

-------------------------
-- Previous Year Metrics
-------------------------

UNION ALL

SELECT  
     'YTD' AS TIME_FRAME,
     1 AS SORT_ORDER,
     EVENT.PROCESSING_LAB,
     TIME.FISCAL_YEAR,
     ITEM.ITEM_ID,ITEM.DESCRIPTION, 
     0 AS ORDERED_QTY_THIS_YEAR,                     
CASE 
WHEN ITEM.ITEM_ID IN ('650','651','652','653','770','771','772',
                       '773','774','776','777','793','794','795',
                       '796','901','902','660','696','679','904','610')
        THEN GSI.SERVICE_ITEM_QTY   
WHEN ITEM.ITEM_ID IN ('341','342','343','615','601','604','618','501','633',
                       '634','635','636','637','312','602','603','648') 
        THEN GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY 
WHEN ITEM.ITEM_ID IN ('623','624','625','626','627','628','638','639','640',
                      '641','642','645','646','647','643','644')
        THEN (GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY)+GSI.ADDITIONAL_QTY
WHEN ITEM.ITEM_ID IN ('620','621','622','111','112','113','100','121','122')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * GSI.ADDITIONAL_QTY )
WHEN ITEM.ITEM_ID IN ('510','511','512','513','514','515','520','521','522',
                      '523','524','525','530','531','532')
        THEN (GSI.SERVICE_ITEM_QTY*NVL(APO.ROOM_QTY,1))
WHEN ITEM.ITEM_ID IN ('649','677','797','920','921') THEN (GSI.SHIPPED_ITEM_QTY)
END  ORDERED_QTY_LAST_YEAR,  
0 AS SHIPPED_QTY_THIS_YEAR,                                     
CASE 
WHEN ITEM.ITEM_ID IN ('650','651','652','653','770','771','772',
                       '773','774','776','777','793','794','795',
                       '796','901','902','660','696','679','904','610')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN GSI.SERVICE_ITEM_QTY   
WHEN ITEM.ITEM_ID IN ('341','342','343','615','601','604','618','501','633',
                       '634','635','636','637','312','602','603','648') 
        AND GSI.SHIPPED_ITEM_QTY >0 THEN GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY 
WHEN ITEM.ITEM_ID IN ('623','624','625','626','627','628','638','639','640',
                      '641','642','645','646','647','643','644')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY)+GSI.ADDITIONAL_QTY 
WHEN ITEM.ITEM_ID IN ('620','621','622','111','112','113','100','121','122')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * GSI.ADDITIONAL_QTY )
WHEN ITEM.ITEM_ID IN ('510','511','512','513','514','515','520','521','522',
                      '523','524','525','530','531','532')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY* NVL(APO.ROOM_QTY,1))
WHEN ITEM.ITEM_ID IN ('649','677','797','920','921') 
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SHIPPED_ITEM_QTY)        
END  SHIPPED_QTY_LAST_YEAR
                                          
FROM ODS.GDT_SERVICE_ITEM_CURR GSI,  
     ODS_OWN.ITEM,
     ODS_OWN.EVENT,
     MART.TIME,
     ODS_OWN.APO
WHERE
1 = 1 
AND GSI.SERVICE_ITEM_CODE = ITEM.ITEM_ID
AND TRUNC(GSI.EFFECTIVE_DATE) = TIME.DATE_KEY
AND GSI.JOB_NBR = EVENT.EVENT_REF_ID
AND EVENT.APO_OID = APO.APO_OID(+)
AND GSI.FISCAL_YEAR = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And TIME.SAT_PRODUCTION_WEEK_NUMBER < (Select Sat_Production_Week_Number From Time 
                                       Where Date_Key = (Select Trunc(Sysdate) From Dual))

UNION ALL
---------- WTD(Closed)
select  
     'WTD(Closed)' AS TIME_FRAME,
     2 AS SORT_ORDER,
     EVENT.PROCESSING_LAB,
     TIME.FISCAL_YEAR,
     ITEM.ITEM_ID,ITEM.DESCRIPTION,
     0 AS ORDERED_QTY_THIS_YEAR,                      
CASE 
WHEN ITEM.ITEM_ID IN ('650','651','652','653','770','771','772',
                       '773','774','776','777','793','794','795',
                       '796','901','902','660','696','679','904','610')
        THEN GSI.SERVICE_ITEM_QTY   
WHEN ITEM.ITEM_ID IN ('341','342','343','615','601','604','618','501','633',
                       '634','635','636','637','312','602','603','648') 
        THEN GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY 
WHEN ITEM.ITEM_ID IN ('623','624','625','626','627','628','638','639','640',
                      '641','642','645','646','647','643','644')
        THEN (GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY)+GSI.ADDITIONAL_QTY
WHEN ITEM.ITEM_ID IN ('620','621','622','111','112','113','100','121','122')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * GSI.ADDITIONAL_QTY )
WHEN ITEM.ITEM_ID IN ('510','511','512','513','514','515','520','521','522',
                      '523','524','525','530','531','532')
        THEN (GSI.SERVICE_ITEM_QTY*NVL(APO.ROOM_QTY,1))
WHEN ITEM.ITEM_ID IN ('649','677','797','920','921') THEN (GSI.SHIPPED_ITEM_QTY)
END  ORDERED_QTY_LAST_YEAR,
0 AS SHIPPED_QTY_THIS_YEAR,                                       
CASE 
WHEN ITEM.ITEM_ID IN ('650','651','652','653','770','771','772',
                       '773','774','776','777','793','794','795',
                       '796','901','902','660','696','679','904','610')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN GSI.SERVICE_ITEM_QTY   
WHEN ITEM.ITEM_ID IN ('341','342','343','615','601','604','618','501','633',
                       '634','635','636','637','312','602','603','648') 
        AND GSI.SHIPPED_ITEM_QTY >0 THEN GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY 
WHEN ITEM.ITEM_ID IN ('623','624','625','626','627','628','638','639','640',
                      '641','642','645','646','647','643','644')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY)+GSI.ADDITIONAL_QTY 
WHEN ITEM.ITEM_ID IN ('620','621','622','111','112','113','100','121','122')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * GSI.ADDITIONAL_QTY )
WHEN ITEM.ITEM_ID IN ('510','511','512','513','514','515','520','521','522',
                      '523','524','525','530','531','532')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY* NVL(APO.ROOM_QTY,1))
WHEN ITEM.ITEM_ID IN ('649','677','797','920','921') 
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SHIPPED_ITEM_QTY)
END  SHIPPED_QTY_LAST_YEAR                                       
FROM ODS.GDT_SERVICE_ITEM_CURR GSI,  
     ODS_OWN.ITEM,
     ODS_OWN.EVENT,
     MART.TIME,
     ODS_OWN.APO
WHERE
1 = 1 
AND GSI.SERVICE_ITEM_CODE = ITEM.ITEM_ID
AND TRUNC(GSI.EFFECTIVE_DATE) = TIME.DATE_KEY
AND GSI.JOB_NBR = EVENT.EVENT_REF_ID
AND EVENT.APO_OID = APO.APO_OID(+)
AND GSI.FISCAL_YEAR = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And TIME.SAT_PRODUCTION_WEEK_NUMBER = (Select Sat_Production_Week_Number From Time Where Date_Key = 
                                              (Select Trunc(Sysdate) From Dual)) - 1

UNION ALL
---------- WeekToDate(Open)
select  
     'WTD(Open)' AS TIME_FRAME,
     3 AS SORT_ORDER,
     EVENT.PROCESSING_LAB,
     TIME.FISCAL_YEAR,
     ITEM.ITEM_ID,ITEM.DESCRIPTION,
     0 AS ORDERED_QTY_THIS_YEAR,                     
CASE 
WHEN ITEM.ITEM_ID IN ('650','651','652','653','770','771','772',
                       '773','774','776','777','793','794','795',
                       '796','901','902','660','696','679','904','610')
        THEN GSI.SERVICE_ITEM_QTY   
WHEN ITEM.ITEM_ID IN ('341','342','343','615','601','604','618','501','633',
                       '634','635','636','637','312','602','603','648') 
        THEN GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY 
WHEN ITEM.ITEM_ID IN ('623','624','625','626','627','628','638','639','640',
                      '641','642','645','646','647','643','644')
        THEN (GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY)+GSI.ADDITIONAL_QTY
WHEN ITEM.ITEM_ID IN ('620','621','622','111','112','113','100','121','122')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * GSI.ADDITIONAL_QTY )
WHEN ITEM.ITEM_ID IN ('510','511','512','513','514','515','520','521','522',
                      '523','524','525','530','531','532')
        THEN (GSI.SERVICE_ITEM_QTY*NVL(APO.ROOM_QTY,1))
WHEN ITEM.ITEM_ID IN ('649','677','797','920','921') THEN (GSI.SHIPPED_ITEM_QTY)
END  ORDERED_QTY_LAST_YEAR,
0 AS SHIPPED_QTY_THIS_YEAR,                                     
CASE 
WHEN ITEM.ITEM_ID IN ('650','651','652','653','770','771','772',
                       '773','774','776','777','793','794','795',
                       '796','901','902','660','696','679','904','610')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN GSI.SERVICE_ITEM_QTY   
WHEN ITEM.ITEM_ID IN ('341','342','343','615','601','604','618','501','633',
                       '634','635','636','637','312','602','603','648') 
        AND GSI.SHIPPED_ITEM_QTY >0 THEN GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY 
WHEN ITEM.ITEM_ID IN ('623','624','625','626','627','628','638','639','640',
                      '641','642','645','646','647','643','644')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY)+GSI.ADDITIONAL_QTY 
WHEN ITEM.ITEM_ID IN ('620','621','622','111','112','113','100','121','122')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * GSI.ADDITIONAL_QTY )
WHEN ITEM.ITEM_ID IN ('510','511','512','513','514','515','520','521','522',
                      '523','524','525','530','531','532')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY* NVL(APO.ROOM_QTY,1))
WHEN ITEM.ITEM_ID IN ('649','677','797','920','921') 
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SHIPPED_ITEM_QTY)
END  SHIPPED_QTY_LAST_YEAR                                       
FROM ODS.GDT_SERVICE_ITEM_CURR GSI,  
     ODS_OWN.ITEM,
     ODS_OWN.EVENT,
     MART.TIME,
     ODS_OWN.APO
WHERE
1 = 1 
AND GSI.SERVICE_ITEM_CODE = ITEM.ITEM_ID
AND TRUNC(GSI.EFFECTIVE_DATE) = TIME.DATE_KEY
AND GSI.JOB_NBR = EVENT.EVENT_REF_ID
AND EVENT.APO_OID = APO.APO_OID(+)
AND GSI.FISCAL_YEAR = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And TIME.SAT_PRODUCTION_WEEK_NUMBER = (Select Sat_Production_Week_Number From Time 
                                       Where Date_Key = (Select Trunc(Sysdate) From Dual))


UNION ALL
---------- SeasonToDate(STD)
select  
     'STD' AS TIME_FRAME,
     4 AS SORT_ORDER,
     EVENT.PROCESSING_LAB,
     TIME.FISCAL_YEAR,
     ITEM.ITEM_ID,ITEM.DESCRIPTION,
     0 AS ORDERED_QTY_THIS_YEAR,                      
CASE 
WHEN ITEM.ITEM_ID IN ('650','651','652','653','770','771','772',
                       '773','774','776','777','793','794','795',
                       '796','901','902','660','696','679','904','610')
        THEN GSI.SERVICE_ITEM_QTY   
WHEN ITEM.ITEM_ID IN ('341','342','343','615','601','604','618','501','633',
                       '634','635','636','637','312','602','603','648') 
        THEN GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY 
WHEN ITEM.ITEM_ID IN ('623','624','625','626','627','628','638','639','640',
                      '641','642','645','646','647','643','644')
        THEN (GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY)+GSI.ADDITIONAL_QTY
WHEN ITEM.ITEM_ID IN ('620','621','622','111','112','113','100','121','122')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * GSI.ADDITIONAL_QTY )
WHEN ITEM.ITEM_ID IN ('510','511','512','513','514','515','520','521','522',
                      '523','524','525','530','531','532')
        THEN (GSI.SERVICE_ITEM_QTY*NVL(APO.ROOM_QTY,1))
WHEN ITEM.ITEM_ID IN ('649','677','797','920','921') THEN (GSI.SHIPPED_ITEM_QTY)
END  ORDERED_QTY_LAST_YEAR,
0 AS SHIPPED_QTY_THIS_YEAR,                                       
CASE 
WHEN ITEM.ITEM_ID IN ('650','651','652','653','770','771','772',
                       '773','774','776','777','793','794','795',
                       '796','901','902','660','696','679','904','610')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN GSI.SERVICE_ITEM_QTY   
WHEN ITEM.ITEM_ID IN ('341','342','343','615','601','604','618','501','633',
                       '634','635','636','637','312','602','603','648') 
        AND GSI.SHIPPED_ITEM_QTY >0 THEN GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY 
WHEN ITEM.ITEM_ID IN ('623','624','625','626','627','628','638','639','640',
                      '641','642','645','646','647','643','644')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY)+GSI.ADDITIONAL_QTY 
WHEN ITEM.ITEM_ID IN ('620','621','622','111','112','113','100','121','122')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * GSI.ADDITIONAL_QTY )
WHEN ITEM.ITEM_ID IN ('510','511','512','513','514','515','520','521','522',
                      '523','524','525','530','531','532')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY* NVL(APO.ROOM_QTY,1))
WHEN ITEM.ITEM_ID IN ('649','677','797','920','921') 
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SHIPPED_ITEM_QTY)
END  SHIPPED_QTY_LAST_YEAR                                         
FROM ODS.GDT_SERVICE_ITEM_CURR GSI,  
     ODS_OWN.ITEM,
     ODS_OWN.EVENT,
     MART.TIME,
     ODS_OWN.APO
WHERE
1 = 1 
AND GSI.SERVICE_ITEM_CODE = ITEM.ITEM_ID
AND TRUNC(GSI.EFFECTIVE_DATE) = TIME.DATE_KEY
AND GSI.JOB_NBR = EVENT.EVENT_REF_ID
AND EVENT.APO_OID = APO.APO_OID(+)
AND GSI.FISCAL_YEAR = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And TIME.Season_Name = (Select Season_Name From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))
And TIME.SAT_PRODUCTION_WEEK_NUMBER < (Select Sat_Production_Week_Number From Time 
                                       Where Date_Key = (Select Trunc(Sysdate) From Dual))


UNION ALL
---------- MonthToDate(MTD)
select  
     'MTD(Closed)' AS TIME_FRAME,
     5 AS SORT_ORDER,
     EVENT.PROCESSING_LAB,
     TIME.FISCAL_YEAR,
     ITEM.ITEM_ID,ITEM.DESCRIPTION,
     0 AS ORDERED_QTY_THIS_YEAR,                      
CASE 
WHEN ITEM.ITEM_ID IN ('650','651','652','653','770','771','772',
                       '773','774','776','777','793','794','795',
                       '796','901','902','660','696','679','904','610')
        THEN GSI.SERVICE_ITEM_QTY   
WHEN ITEM.ITEM_ID IN ('341','342','343','615','601','604','618','501','633',
                       '634','635','636','637','312','602','603','648') 
        THEN GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY 
WHEN ITEM.ITEM_ID IN ('623','624','625','626','627','628','638','639','640',
                      '641','642','645','646','647','643','644')
        THEN (GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY)+GSI.ADDITIONAL_QTY
WHEN ITEM.ITEM_ID IN ('620','621','622','111','112','113','100','121','122')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * GSI.ADDITIONAL_QTY )
WHEN ITEM.ITEM_ID IN ('510','511','512','513','514','515','520','521','522',
                      '523','524','525','530','531','532')
        THEN (GSI.SERVICE_ITEM_QTY*NVL(APO.ROOM_QTY,1))
WHEN ITEM.ITEM_ID IN ('649','677','797','920','921') THEN (GSI.SHIPPED_ITEM_QTY)
END  ORDERED_QTY_LAST_YEAR,
0 AS SHIPPED_QTY_THIS_YEAR,                                      
CASE 
WHEN ITEM.ITEM_ID IN ('650','651','652','653','770','771','772',
                       '773','774','776','777','793','794','795',
                       '796','901','902','660','696','679','904','610')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN GSI.SERVICE_ITEM_QTY   
WHEN ITEM.ITEM_ID IN ('341','342','343','615','601','604','618','501','633',
                       '634','635','636','637','312','602','603','648') 
        AND GSI.SHIPPED_ITEM_QTY >0 THEN GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY 
WHEN ITEM.ITEM_ID IN ('623','624','625','626','627','628','638','639','640',
                      '641','642','645','646','647','643','644')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * EVENT.CAPTURE_SESSION_QTY)+GSI.ADDITIONAL_QTY 
WHEN ITEM.ITEM_ID IN ('620','621','622','111','112','113','100','121','122')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY * GSI.ADDITIONAL_QTY )
WHEN ITEM.ITEM_ID IN ('510','511','512','513','514','515','520','521','522',
                      '523','524','525','530','531','532')
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SERVICE_ITEM_QTY* NVL(APO.ROOM_QTY,1))
WHEN ITEM.ITEM_ID IN ('649','677','797','920','921') 
        AND GSI.SHIPPED_ITEM_QTY >0 THEN (GSI.SHIPPED_ITEM_QTY)
END  SHIPPED_QTY_LAST_YEAR                                        
FROM ODS.GDT_SERVICE_ITEM_CURR GSI,  
     ODS_OWN.ITEM,
     ODS_OWN.EVENT,
     MART.TIME,
     ODS_OWN.APO
WHERE
1 = 1 
AND GSI.SERVICE_ITEM_CODE = ITEM.ITEM_ID
AND TRUNC(GSI.EFFECTIVE_DATE) = TIME.DATE_KEY
AND GSI.JOB_NBR = EVENT.EVENT_REF_ID
AND EVENT.APO_OID = APO.APO_OID(+)
AND GSI.FISCAL_YEAR = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And TIME.Month_Number = (Select Month_Number From Time Where Date_Key = (Select Trunc(Sysdate) From Dual))-1

UNION ALL
--- Dummy Fills

SELECT /*+ PARALLEL(GSI,24) */
     DISTINCT 
     B.TIME_FRAME,     
     B.SORT_ORDER,
     EVENT.PROCESSING_LAB,    
     TIME.FISCAL_YEAR,    
     ITEM.ITEM_ID,ITEM.DESCRIPTION,                      
     0 AS ORDERED_QTY_THIS_YEAR,                                       
     0 AS SHIPPED_QTY_THIS_YEAR,
     0 AS ORDERED_QTY_LAST_YEAR,
     0 AS SHIPPED_QTY_LAST_YEAR                                        
FROM ODS.GDT_SERVICE_ITEM_CURR GSI,  
     ODS_OWN.ITEM,
     ODS_OWN.EVENT,
     MART.TIME     
     ,(SELECT 'YTD' AS TIME_FRAME,1 AS SORT_ORDER FROM DUAL
      UNION ALL 
      SELECT 'WTD(Closed)'AS TIME_FRAME,2 AS SORT_ORDER FROM DUAL
      UNION ALL 
      SELECT 'WTD(Open)' AS TIME_FRAME,3 AS SORT_ORDER FROM DUAL
      UNION ALL 
      SELECT 'STD'AS TIME_FRAME,4 AS SORT_ORDER FROM DUAL
      UNION ALL 
      SELECT 'MTD(Closed)'AS TIME_FRAME,5 AS SORT_ORDER FROM DUAL      
      )B      
WHERE
1 = 1 
AND GSI.SERVICE_ITEM_CODE = ITEM.ITEM_ID
AND TRUNC(GSI.EFFECTIVE_DATE) = TIME.DATE_KEY
AND GSI.JOB_NBR = EVENT.EVENT_REF_ID
AND GSI.FISCAL_YEAR = (SELECT DISTINCT FISCAL_YEAR FROM MART.TIME WHERE DATE_KEY = TRUNC(SYSDATE)) - 1
And TIME.SAT_PRODUCTION_WEEK_NUMBER <= (Select Sat_Production_Week_Number From Time 
                                       Where Date_Key = (Select Trunc(Sysdate) From Dual))

)A
GROUP BY
      PROCESSING_LAB,
      'Service Item',
      NULL,  
      TIME_FRAME,
      SORT_ORDER,            
      ITEM_ID,
      DESCRIPTION
ORDER BY ITEM_ID,PROCESSING_LAB,SORT_ORDER

&


/*-----------------------------------------------*/
/* TASK No. 5 */
/* Update CDC Load Status */

UPDATE ODS.DW_CDC_LOAD_STATUS
SET LAST_CDC_COMPLETION_DATE=TO_DATE(
             SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS')
WHERE DW_TABLE_NAME=:v_cdc_load_table_name

&


-- /*-----------------------------------------------*/
-- /* TASK No. 6 */
-- /* Insert Audit Record */

-- INSERT INTO ODS_ETL_OWNER.DW_CDC_LOAD_STATUS_AUDIT
-- (TABLE_NAME,
-- SESS_NO,                      
-- SESS_NAME,                    
-- SCEN_VERSION,                 
-- SESS_BEG,                     
-- ORIG_LAST_CDC_COMPLETION_DATE,
-- OVERLAP,
-- CREATE_DATE              
-- )
-- values (
-- :v_cdc_load_table_name,
-- :v_sess_no,
-- 'AGG_PR_FLASH_CARD_PKG',
-- '009',
-- TO_DATE(
--              SUBSTR(:v_sess_beg, 1, 19), 'RRRR-MM-DD HH24:MI:SS'),
-- TO_DATE (SUBSTR (:v_cdc_load_date_ODS_DM, 1, 19),
--                            'YYYY-MM-DD HH24:MI:SS'
--                           ),
-- :v_cdc_overlap,
-- SYSDATE)



-- &


/*-----------------------------------------------*/
