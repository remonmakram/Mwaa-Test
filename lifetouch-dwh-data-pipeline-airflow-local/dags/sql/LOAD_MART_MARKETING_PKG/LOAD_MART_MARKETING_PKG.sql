/* TASK No. 1 */
/* Load MART.MARKETING Table. */

MERGE INTO MART.MARKETING TGT
USING  
(                                                             
   SELECT SUB_PROGRAM_ID,PROGRAM_ID,
          SUB_PROGRAM_OID,PROGRAM_OID,
          SUB_PROGRAM_NAME,PROGRAM_NAME 
          FROM                               
       (SELECT SUB_PROGRAM.SUB_PROGRAM_ID,PROGRAM.PROGRAM_ID,
                  SUB_PROGRAM.SUB_PROGRAM_OID,PROGRAM.PROGRAM_OID,
                   SUB_PROGRAM.SUB_PROGRAM_NAME,PROGRAM.PROGRAM_NAME 
                   FROM ODS_OWN.PROGRAM,
                              ODS_OWN.SUB_PROGRAM
                   WHERE SUB_PROGRAM.PROGRAM_OID = PROGRAM.PROGRAM_OID
                   AND PROGRAM.PROGRAM_ID IS NOT NULL
                   AND SUB_PROGRAM.SUB_PROGRAM_ID IS NOT NULL   
                   AND  SUB_PROGRAM.SUB_PROGRAM_OID <> -1  
                   ORDER BY PROGRAM.PROGRAM_NAME                                                                        
       )S                
      WHERE NOT EXISTS 
       ( SELECT 1 FROM MART.MARKETING  M
              WHERE M.SUB_PROGRAM_OID = S.SUB_PROGRAM_OID
       ))SRC ON (TGT.SUB_PROGRAM_OID = SRC.SUB_PROGRAM_OID)
   
 WHEN NOT MATCHED THEN 
 INSERT (
            TGT.MARKETING_ID,   
            TGT.MARKETING_CODE,
            TGT.MARKETING_CODE_NAME,
            TGT.MARKETING_GROUP_ID,     
            TGT.MARKETING_GROUP_NAME,  
            TGT.SUB_PROGRAM_ID,         
            TGT.SUB_PROGRAM_NAME,       
            TGT.PROGRAM_ID,             
            TGT.PROGRAM_NAME,           
            TGT.SALES_LINE_ID,          
            TGT.SALES_LINE_NAME,        
            TGT.DIVISION_ID,            
            TGT.DIVISION_NAME,          
            TGT.ORIG_PROGRAM_NAME,      
            TGT.ORIG_SUB_PROGRAM_NAME,  
            TGT.LT_PROGRAM_KEY,         
            TGT.LT_SUB_PROGRAM_KEY,     
            TGT.ALL_COLOR,      
            TGT.SUB_PROGRAM_OID
       )    
       VALUES( ODS.MARKETING_ID_SEQ.NEXTVAL,
               'Unk'||SRC.SUB_PROGRAM_ID||'-'||SRC.PROGRAM_ID,
               NULL,
               NULL,
               NULL,
               SRC.SUB_PROGRAM_ID,
               SRC.SUB_PROGRAM_NAME,
               SRC.PROGRAM_ID,
               SRC.PROGRAM_NAME,
               '99999',
               'UNKNOWN',
               NULL,
               NULL,
               NULL,
               NULL,
               NULL,
               NULL,
               NULL,
               SRC.SUB_PROGRAM_OID
             )




&


/*-----------------------------------------------*/
