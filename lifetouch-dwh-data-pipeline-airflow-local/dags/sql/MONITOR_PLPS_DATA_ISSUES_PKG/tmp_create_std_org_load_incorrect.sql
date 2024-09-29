BEGIN
   EXECUTE IMMEDIATE 'drop table std_org_load_incorrect';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;

&

CREATE TABLE std_org_load_incorrect AS
 SELECT *
  FROM STD_ORGANIZATION
 WHERE     mgr_no <> SUBSTR (std_org, 21, 3)
    AND SUBSTR (std_org, 7, 5) = 'V0001'
      -- AND SUBSTR (std_org, 7, 5) <>  'V0001'
       AND mgr_no NOT IN (199,
                          999,
                          919,
                          969)