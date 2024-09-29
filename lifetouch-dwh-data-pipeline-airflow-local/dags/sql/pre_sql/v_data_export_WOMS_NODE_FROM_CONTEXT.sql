select
  CASE
   WHEN 'MNPLS' = 'DEV' THEN 'Minneapolis'
   WHEN 'MNPLS' = 'CHESAPEAKE' THEN 'Chesapeake'
   WHEN 'MNPLS' = 'CHICO' THEN 'Chico'
   WHEN 'MNPLS' = 'MNPLS' THEN 'Minneapolis'
   WHEN 'MNPLS' = 'WINNIPEG' THEN 'Winnipeg'
   WHEN 'MNPLS' = 'CHATTANOOGA' THEN 'Chattanooga'
   ELSE 'Oops'
  END
from dual
