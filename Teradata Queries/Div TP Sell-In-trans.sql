SELECT
MATNOSG.REGION_CODE AS REGION
,MATNOSG.WEEK_END_DT
, PRODUCT_MIX AS LOBMix_noXH
,CASE
	WHEN SCLV.SALESCHANNEL = 'Billing & Collections' THEN 'Care'
	WHEN SCLV.SALESCHANNEL = '3rd Party Outsourcer' THEN  'Care'
	WHEN SCLV.SALESCHANNEL = 'Repair' THEN 'Care'
	WHEN SCLV.SALESCHANNEL = 'Inbound Sales' THEN 'Inbound'
	WHEN SCLV.SALESCHANNEL = 'Retention' THEN 'Retention'
	WHEN SCLV.SALESCHANNEL  IN ('Retail','Verizon', 'Store in Store', 'E-Tail') THEN 'All Other'
	WHEN SCLV.SALESCHANNEL = 'Front Counter' THEN 'Service Ctr'
ELSE SCLV.SALESCHANNELROLLUP END AS SalesChannel_wCallCtrDetail
--,case when isnull(MATNOSG.[Contract],'')  = 'Y' then 'Y' else 'N' end as [Contract]

--,case when MATNOSG.Package_Category = 'Pref/Perf' and Tier_B1 = 'Dig_Tier' and Tier_HSI = 'Blast' then 'Pref/Blast'
--	  when MATNOSG.Package_Category = 'Starter/Perf' and Tier_B1 = 'Starter' and Tier_HSI = 'Blast' then 'Starter/Blast'
--else MATNOSG.Package_Category end as Package_Category_Modified
--,case when (case when MATNOSG.Package_Category = 'Pref/Perf' and Tier_B1 = 'Dig_Tier' and Tier_HSI = 'Blast' then 'Pref/Blast'
--	  when MATNOSG.Package_Category = 'Starter/Perf' and Tier_B1 = 'Starter' and Tier_HSI = 'Blast' then 'Starter/Blast'
--else MATNOSG.Package_Category end) IN ('Pref/Perf', 'Starter/Perf', 'Pref/Blast', 'Starter/Blast') then 'Y' else 'N' end as DP_Eligible
,COUNT (MATNOSG.ACCOUNT_NUMBER) AS Subs

FROM EBI_NSD_VIEWS.NSD_MASTER_DAILY_ACTIVITY_NO_M_SG MATNOSG
JOIN EBI_NSD_VIEWS.SALESCHANNEL_LOOKUP_V SCLV
	ON MATNOSG.FINAL_SALES_CHANNEL= SCLV.SALESCHANNELDETAIL

WHERE  MATNOSG.WEEK_END_DT IN 
				(SELECT WEEK_END_DT FROM 
																	( SELECT W.WEEK_END_DT, ROW_NUMBER() OVER (PARTITION BY PART ORDER BY WEEK_END_DT DESC) AS RANKING
																		FROM ( SELECT DISTINCT WEEK_END_DT, 'MONTH' AS PART
																							FROM EBI_NSD_VIEWS.NSD_MASTER_DAILY_ACTIVITY_NO_M_SG 
																							WHERE WEEK_END_DT<=CURRENT_DATE + 30)W )X 
																	WHERE RANKING<=4)

AND MATNOSG.ACTIVITYDETAIL= 'NEW CONNECT'
AND MATNOSG.PRODUCT_MIX IN ('VIDEO/HSD/CDV', 'VIDEO/HSD')
--DOUBLE CHECK THE ABOVE
AND MATNOSG.CUSTOMER_TYPE = 'RESIDENTIAL'
AND PRODUCT_MIX NOT LIKE '%XH%'

GROUP BY
MATNOSG.REGION_CODE
,MATNOSG.WEEK_END_DT
, PRODUCT_MIX
,CASE
	WHEN SCLV.SALESCHANNEL = 'Billing & Collections' THEN 'Care'
	WHEN SCLV.SALESCHANNEL = '3rd Party Outsourcer' THEN  'Care'
	WHEN SCLV.SALESCHANNEL = 'Repair' THEN 'Care'
	WHEN SCLV.SALESCHANNEL = 'Inbound Sales' THEN 'Inbound'
	WHEN SCLV.SALESCHANNEL = 'Retention' THEN 'Retention'
	WHEN SCLV.SALESCHANNEL  IN ('Retail','Verizon', 'Store in Store', 'E-Tail') THEN 'All Other'
	WHEN SCLV.SALESCHANNEL = 'Front Counter' THEN 'Service Ctr'
ELSE SCLV.SALESCHANNELROLLUP END