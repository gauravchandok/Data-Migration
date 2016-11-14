SELECT HDS.FME
, HDS.Region
, R.DMA_NAME
, CASE WHEN CMT.Fiber_Date IS NOT NULL THEN 'Fiber' ELSE 'NonFiber' END AS Fiber
, CASE 
	WHEN CMT.IncomeCode IN ('<15K', '15-20K', '20-30K') THEN 'Low (<30k)'
    WHEN CMT.IncomeCode IN ('30-40K', '40-50K', '50-75K') THEN 'Med (30-75K)'
    ELSE 'High >75K' 
END AS Income
, CASE
    WHEN DWT.DwellType = 'COM' THEN 'BUS'
    WHEN CA.[Exclude Final] = 0 THEN 'MDU'
    ELSE 'SFU'
END AS Dwell
, R.Level_1
, R.Top_Cities
, case 
		when COMT.FiOS is not null and COMT.RCN is not null  then 'FiOS&RCN'
		when COMT.FiOS is not null then 'FiOS'
		when COMT.[U-verse] is not null and HDS.region <> 'KEY' then 'Frontier'
		when COMT.RCN is not null and CMT.Fiber <> 'Fiber' then 'RCN'
		when CMT.Fiber = 'Fiber' and HDS.Region <> 'WNE' then 'FiOS'
		when CMT.Fiber = 'Fiber' and HDS.Region = 'WNE' then 'Frontier'
		when HDS.Region = 'WNE' and COMT.[Other] in ('VTEL') then COMT.[Other]
		when HDS.Region = 'blt' and COMT.[Other] in ('Lumos Networks','nDanville') then COMT.[Other]
		when HDS.Region = 'fre' and COMT.[Other] in ('Cablevision','Service Electric Cable') then COMT.[Other]
		when HDS.Region = 'gbr' and COMT.[Other] in ('TDS Fiber') then COMT.[Other]
		when HDS.Region = 'key' and COMT.[Other] in ('Blue Ridge','Zito Media','KCI','Service Electric Cable','Atlantic Broadband') then COMT.[Other]
		when HDS.Region = 'wne' and COMT.[Other] in ('TVC','BT') then COMT.[Other]
		when COMT.Other is not null then 'Other'
		else 'No Overbuilder'
		end as Competitor
, COUNT (HDS.HOUSE_NUMBER) AS HHP
, SUM (AWS.B1) AS B1
, SUM (AWS.HSI) AS HSI
, SUM (AWS.CDV) AS CDV
, SUM (AWS.HOME_SEC) AS XH
FROM (
		select HDS.region, HDS.fme, HDS.house_number, HDS.syscorp, HDS.complex, HDS.dwellcode, HDS.prin, HDS.AGNTFTAX, HDS.[STATE]
		from dor.dbo.House_Data_Snap HDS
		WHERE (HDS.FME = (select dateadd(m,-1,(fme)) from dor.dbo.tbl_CurFME))
		AND (HDS.SYSCORP NOT IN
				(1620,1691,1729,1925,6101,6104,9504,9508,9509,9513,9517,9526,9527,
				9530,9531,9540,9565,9568,9574,9575,20001,3402))
		AND (HDS.VideoServiceable = '1')
		) HDS
LEFT OUTER JOIN DOR.dbo.Complex_Attributes CA
    ON     HDS.Region = CA.region
        AND HDS.SYSCORP = CA.syscorp
        AND HDS.COMPLEX = CA.complex_Code
LEFT OUTER JOIN DOR.dbo.Account_Weekly_Snapshot_FME AWS
    ON HDS.SYSCORP = AWS.SysCorp
    AND HDS.HOUSE_NUMBER = AWS.House_Number
LEFT OUTER JOIN DOR.dbo.tbl_Region R
ON     R.SysCorp = HDS.SYSCORP
    AND R.Prin = HDS.PRIN
    AND R.AgntFTAX = HDS.AGNTFTAX
LEFT OUTER JOIN DOR.dbo.tbl_COMET_Data CMT
    ON CMT.SYSCORP = HDS.SYSCORP
	AND CMT.HOUSE_NUMBER = HDS.HOUSE_NUMBER
LEFT OUTER JOIN DOR.dbo.tbl_DwellType DWT
    ON DWT.SYSCORP = HDS.SYSCORP
	AND DWT.DwellCode = HDS.DWELLCODE
left join Competitive.dbo.competitive_threat COMT
	on CMT.fullfipsid = COMT.CensusBlock
GROUP BY HDS.FME
, HDS.Region
, R.DMA_NAME
, CASE WHEN CMT.Fiber_Date IS NOT NULL THEN 'Fiber' ELSE 'NonFiber' END 
, CASE 
	WHEN CMT.IncomeCode IN ('<15K', '15-20K', '20-30K') THEN 'Low (<30k)'
    WHEN CMT.IncomeCode IN ('30-40K', '40-50K', '50-75K') THEN 'Med (30-75K)'
    ELSE 'High >75K' 
END
, CASE
    WHEN DWT.DwellType = 'COM' THEN 'BUS'
    WHEN CA.[Exclude Final] = 0 THEN 'MDU'
    ELSE 'SFU'
END 
, R.Level_1
, R.Top_Cities
, case 
		when COMT.FiOS is not null and COMT.RCN is not null  then 'FiOS&RCN'
		when COMT.FiOS is not null then 'FiOS'
		when COMT.[U-verse] is not null and HDS.region <> 'KEY' then 'Frontier'
		when COMT.RCN is not null and CMT.Fiber <> 'Fiber' then 'RCN'
		when CMT.Fiber = 'Fiber' and HDS.Region <> 'WNE' then 'FiOS'
		when CMT.Fiber = 'Fiber' and HDS.Region = 'WNE' then 'Frontier'
		when HDS.Region = 'WNE' and COMT.[Other] in ('VTEL') then COMT.[Other]
		when HDS.Region = 'blt' and COMT.[Other] in ('Lumos Networks','nDanville') then COMT.[Other]
		when HDS.Region = 'fre' and COMT.[Other] in ('Cablevision','Service Electric Cable') then COMT.[Other]
		when HDS.Region = 'gbr' and COMT.[Other] in ('TDS Fiber') then COMT.[Other]
		when HDS.Region = 'key' and COMT.[Other] in ('Blue Ridge','Zito Media','KCI','Service Electric Cable','Atlantic Broadband') then COMT.[Other]
		when HDS.Region = 'wne' and COMT.[Other] in ('TVC','BT') then COMT.[Other]
		when COMT.Other is not null then 'Other'
		else 'No Overbuilder'
		end