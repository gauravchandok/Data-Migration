SELECT HDS.MONTH_END_DT AS FME
, HDS.REGION_CODE AS REGION
, MAT.DMA_NAME
, CASE WHEN MAT.DEMO_FIBER = 1 THEN 'Fiber' ELSE 'NonFiber' END AS Fiber
, CASE WHEN  MAT.DEMO_INCOME_CODE IN ('<15K', '15-25K', '25-35K') THEN 'Low (<30k)'
	WHEN  MAT.DEMO_INCOME_CODE IN ('35-50K', '50-75K') THEN 'Med (30-75K)'
	ELSE 'High >75K'
END AS Income

, CASE
    WHEN MAT.DWELL_TYPE_GROUP_BILLER = 'COMMERCIAL' THEN 'BUSINESS'
    WHEN MAT.DWELL_TYPE_GROUP_BILLER = 'MDU' THEN 'MDU'
   WHEN MAT.DWELL_TYPE_GROUP_BILLER = 'SFU' THEN 'SFU'
   ELSE MAT.DWELL_TYPE_GROUP_BILLER
END AS Dwell
, MAT.DEMO_COMP_FOOTPRINT
--, R.Level_1
--, R.Top_Cities
--, CASE 
--		WHEN COMT.FiOS is not null and COMT.RCN is not null  then 'FiOS&RCN'
--		WHEN COMT.FiOS is not null then 'FiOS'
--		WHEN COMT.[U-verse] is not null and HDS.region <> 'KEY' then 'Frontier'
--		when COMT.RCN is not null and CMT.Fiber <> 'Fiber' then 'RCN'
--		when CMT.Fiber = 'Fiber' and HDS.Region <> 'WNE' then 'FiOS'
--		when CMT.Fiber = 'Fiber' and HDS.Region = 'WNE' then 'Frontier'
--		when HDS.Region = 'WNE' and COMT.[Other] in ('VTEL') then COMT.[Other]
--		when HDS.Region = 'blt' and COMT.[Other] in ('Lumos Networks','nDanville') then COMT.[Other]
--		when HDS.Region = 'fre' and COMT.[Other] in ('Cablevision','Service Electric Cable') then COMT.[Other]
--		when HDS.Region = 'gbr' and COMT.[Other] in ('TDS Fiber') then COMT.[Other]
--		when HDS.Region = 'key' and COMT.[Other] in ('Blue Ridge','Zito Media','KCI','Service Electric Cable','Atlantic Broadband') then COMT.[Other]
--		when HDS.Region = 'wne' and COMT.[Other] in ('TVC','BT') then COMT.[Other]
--		when COMT.Other is not null then 'Other'
--		else 'No Overbuilder'
--		end as Competitor

, COUNT (HDS.HOUSE_NUMBER) AS HHP
, SUM (MAT.B1) 
, SUM (MAT.HSI)
, SUM (MAT.CDV)
, SUM (MAT.HS) AS XH
FROM
(SELECT MAT.REGION_CODE, MAT.MONTH_END_DT, MAT.HOUSE_NUMBER, MAT.SYSCORP, MAT.COMPLEX_CD, 
MAT.PRIN, MAT.AGNTFTAX, MAT.STATE, MAT.ACCOUNT_NUMBER
FROM EBI_NSD_VIEWS.NSD_MASTER_DAILY_ACTIVITY MAT
JOIN NDW_BASE_VIEWS.LOCATION_HIST LH
ON MAT.LOCATION_ID = LH.LOCATION_ID
WHERE MAT.MONTH_END_DT = (SELECT ADD_MONTHS (MAX(MONTH_END_DT),-1) FROM EBI_NSD_VIEWS.NSD_MASTER_DAILY_ACTIVITY)
		AND MAT.SYSCORP NOT IN
				(1620,1691,1729,1925,6101,6104,9504,9508,9509,9513,9517,9526,9527,
				9530,9531,9540,9565,9568,9574,9575,20001,3402)
AND LH.VIDEO_SERVICABILITY_IND <>'N'
) HDS
LEFT OUTER JOIN EBI_NSD_VIEWS.NSD_MASTER_DAILY_ACTIVITY MAT
ON HDS.ACCOUNT_NUMBER= MAT.ACCOUNT_NUMBER
WHERE MAT.DIVISION_NAME= 'NORTHEAST DIVISION'
GROUP BY 
HDS.MONTH_END_DT
, HDS.REGION_CODE
, MAT.DMA_NAME
, CASE WHEN MAT.DEMO_FIBER = 1 THEN 'Fiber' ELSE 'NonFiber' END
, CASE WHEN  MAT.DEMO_INCOME_CODE IN ('<15K', '15-25K', '25-35K') THEN 'Low (<30k)'
	WHEN  MAT.DEMO_INCOME_CODE IN ('35-50K', '50-75K') THEN 'Med (30-75K)'
	ELSE 'High >75K' END
, CASE
  WHEN MAT.DWELL_TYPE_GROUP_BILLER = 'COMMERCIAL' THEN 'BUSINESS'
  WHEN MAT.DWELL_TYPE_GROUP_BILLER = 'MDU' THEN 'MDU'
  WHEN MAT.DWELL_TYPE_GROUP_BILLER = 'SFU' THEN 'SFU'
  ELSE MAT.DWELL_TYPE_GROUP_BILLER
END
, MAT.DEMO_COMP_FOOTPRINT