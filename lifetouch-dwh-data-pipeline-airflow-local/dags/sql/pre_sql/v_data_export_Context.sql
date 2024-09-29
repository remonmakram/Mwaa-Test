select
  CASE
   WHEN 'CHICO' = 'DEV' THEN 'Minneapolis'
   WHEN 'CHICO' = 'CHESAPEAKE' THEN 'Chesapeake'
   WHEN 'CHICO' = 'CHICO' THEN 'Chico'
   WHEN 'CHICO' = 'MNPLS' THEN 'Minneapolis'
   WHEN 'CHICO' = 'WINNIPEG' THEN 'Winnipeg'
   WHEN 'CHICO' = 'CHATTANOOGA' THEN 'Chattanooga'
   WHEN 'CHICO' = 'CENTRAL' THEN 'Central'
   WHEN 'CHICO' = 'MUNCIE'  THEN  'Muncie'
   WHEN 'CHICO' = 'SHAKOPEE' THEN  'Shakopee'    
   ELSE 'Oops'
  END
from dual
