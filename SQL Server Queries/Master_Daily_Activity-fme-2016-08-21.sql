SELECT fme
, CASE WHEN activity = 'disconnect' THEN - COUNT(account_number) ELSE COUNT(account_number) end AS Accts
, LOBMix
, Activity, ActivityDetail
, LastSos
FROM dor.dbo.Master_Activity_Summary
WHERE fme = '2016-08-21'
GROUP BY fme, LOBMix, Activity, ActivityDetail, LastSoS