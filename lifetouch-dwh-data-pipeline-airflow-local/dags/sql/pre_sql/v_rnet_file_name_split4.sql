-- Refresh Variable LIFETOUCH_PROJECT.v_rnet_file_name_split4:
-- SELECT 'SALESODS_'||(CASE WHEN '#LIFETOUCH_PROJECT.v_rnet_corp_acct_ind' = 'Y' THEN 'NSS' ELSE 'TER' END)||'_'||'#LIFETOUCH_PROJECT.v_rnet_currency_type'||'_'||'#LIFETOUCH_PROJECT.v_rnet_load_date'||'.txt'
-- FROM DUAL
SELECT 'SALESODS_'||(CASE WHEN :v_rnet_corp_acct_ind = 'Y' THEN 'NSS' ELSE 'TER' END)||'_'|| :v_rnet_currency_type ||'_'|| :v_rnet_load_date
FROM DUAL