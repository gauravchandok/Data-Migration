SELECT d.Scenario AS Yr, m.Region AS Region, cast (d.[Report_Date] AS VARCHAR) AS [Date]
	, Dates.[Fiscal Mo Wk Num] AS Wk, cast (d.[Week Ending] AS VARCHAR) AS [Week Ending]
	, CASE WHEN d.[Report_Date] > getdate () - 22 THEN 'L21' END AS L21
	, CASE WHEN d.CurrFMEflag = 'Y' THEN 'CurrFME' END AS CurrFME
	, CASE
		WHEN m.LOBMix_DP = 'VD_Low'  THEN 'Low2P' 
		WHEN m.LOBMix_noXH = 'VD'  THEN 'High2P'
		WHEN m.LOBMix_noXH IN ('V', 'D', 'VDT') THEN m.LOBMix_noXH
		ELSE 'Other' END AS LOBMix
	, m.Activity, m.ActivityDetail, m.DiscoReson_wDGRD AS DiscoReason
	,  case 
		when t.FiOS is not null and t.RCN is not null  then 'FiOS&RCN'
		when t.FiOS is not null then 'FiOS'
		when t.[U-verse] is not null and m.region <> 'KEY' then 'Frontier'
		when t.RCN is not null and m.Fiber <> 'Fiber' then 'RCN'
		when m.Fiber = 'Fiber' and m.Region <> 'WNE' then 'FiOS'
		when m.Fiber = 'Fiber' and m.Region = 'WNE' then 'Frontier'
		when m.Region = 'WNE' and t.[Other] in ('VTEL') then t.[Other]
		when m.Region = 'blt' and t.[Other] in ('Lumos Networks','nDanville') then t.[Other]
		when m.Region = 'fre' and t.[Other] in ('Cablevision','Service Electric Cable') then t.[Other]
		when m.Region = 'gbr' and t.[Other] in ('TDS Fiber') then t.[Other]
		when m.Region = 'key' and t.[Other] in ('Blue Ridge','Zito Media','KCI','Service Electric Cable','Atlantic Broadband') then t.[Other]
		when m.Region = 'wne' and t.[Other] in ('TVC','BT') then t.[Other]
		when t.Other is not null then 'Other'
		else 'No Overbuilder'
		end as Competitor

	, CASE
		WHEN m.DiscoReason IN ('Competitive','NonPay','Other','Price/Value') THEN ''
		WHEN m.SalesChannel = 'Inbound Sales' THEN 'Inbound' 
		WHEN m.SalesChannel = 'E-Tail' THEN 'Etail'
		WHEN m.SalesChannel = 'Billing & Collections' THEN 'Care'
		WHEN m.SalesChannel = '3rd Party Outsourcer' THEN 'Care'
		WHEN m.SalesChannel = 'Repair' THEN 'Care'
		WHEN m.SalesChannel = 'Retention' THEN 'Retention'
		WHEN m.SalesChannel = 'Retail' THEN 'Retail' 
		WHEN m.SalesChannel = 'Front Counter' THEN  'Service Ctr'
		WHEN m.SalesChannelRollUp = 'Verizon' THEN  'All Other'
		WHEN m.SalesChannelRollUp = 'Store In Store' THEN 'All Other'
		ELSE m.SalesChannelRollUp END AS Channel
	, CASE WHEN m.DiscoSubReason = 'Transfer' THEN 'Transfer' END AS [Transfer]
	, CASE
		WHEN m.Activity = 'Connect' THEN 'C'
		WHEN m.DiscoReson_wDGRD = 'nonPay' THEN 'NP'
		ELSE 'Vol' END AS [NP-Vol]
	, case 
		when m.ActivityDetail = 'connect' then 'C'
		when m.activity = 'disconnect' and m.DiscoReson_wDGRD not in ('downgrade','nonpay','move/trans') then 'Vol'
		else 'Other' End as ComptrendGroup
	, m.Fiber, m.Level_1, m.DwellType AS DwellType
	, cast (d.FME AS varchar(10)) AS FME
	, SUM (m.B1) AS B1
	, SUM (m.HSI) AS HSI
	, SUM (m.CDV) AS CDV
	, SUM (m.HS) AS XH
	, sum (CASE WHEN Activity = 'Connect' THEN 1 ELSE -1 END) AS Customer
	, sum (CASE WHEN m.MRC_Finance BETWEEN 10 AND 300 THEN 1 END) AS MRC_Count 
	, sum (CASE WHEN m.MRC_Finance BETWEEN 10 AND 300 THEN m.MRC_Finance END) AS MRC_Revenue
	, case 
		when np.NPDecile between 0 and 2 then 'High'
		when np.NPDecile between 3 and 6 then 'Med'
		when np.NPDecile between 7 and 9 then 'Low'
					else 'Med'
	  end as NP_Risk
	FROM (DOR.dbo.Master_Activity_Table_noSG m
	INNER JOIN DOR.dbo.vw_DatesWithPY d
		ON (m.Effective_Date = d.Actual_Date))
	INNER JOIN DOR.dbo.Dates Dates 
		ON (Dates.[Date] = d.Report_Date)
	left join Competitive.dbo.competitive_threat t
		on m.CensusBlock = t.CensusBlock

	left join dor.[dbo].[NonPay_Deciles] np
		on m.CensusBlock = np.fullfipsid
	WHERE d.[Report_Date] >= getdate () - 35
	GROUP BY m.Activity, m.ActivityDetail
	, CASE
		WHEN m.DiscoReason IN ('Competitive','NonPay','Other','Price/Value') THEN ''
		WHEN m.SalesChannel = 'Inbound Sales' THEN 'Inbound' 
		WHEN m.SalesChannel = 'E-Tail' THEN 'Etail'
		WHEN m.SalesChannel = 'Billing & Collections' THEN 'Care'
		WHEN m.SalesChannel = '3rd Party Outsourcer' THEN 'Care'
		WHEN m.SalesChannel = 'Repair' THEN 'Care'
		WHEN m.SalesChannel = 'Retention' THEN 'Retention'
		WHEN m.SalesChannel = 'Retail' THEN 'Retail' 
		WHEN m.SalesChannel = 'Front Counter' THEN  'Service Ctr'
		WHEN m.SalesChannelRollUp = 'Verizon' THEN  'All Other'
		WHEN m.SalesChannelRollUp = 'Store In Store' THEN 'All Other'
		ELSE m.SalesChannelRollUp END
	, CASE WHEN m.DiscoSubReason = 'Transfer' THEN 'Transfer' END
	, CASE
		WHEN m.LOBMix_DP = 'VD_Low'  THEN 'Low2P' 
		WHEN m.LOBMix_noXH = 'VD' THEN 'High2P'
		WHEN m.LOBMix_noXH IN ('V', 'D', 'VDT') THEN m.LOBMix_noXH
		ELSE 'Other' END
	, m.Fiber, m.Level_1, Dates.[Fiscal Mo Wk Num]
	, CASE WHEN d.CurrFMEflag = 'Y' THEN 'CurrFME' END
	, cast (d.[Report_Date] AS VARCHAR)
	, cast (d.FME AS varchar(10))
	, CASE WHEN d.[Report_Date] > getdate () - 22 THEN 'L21' END
	, d.Scenario, m.Region
	, CASE
		WHEN m.Activity = 'Connect' THEN 'C'
		WHEN m.activity = 'disconnect' and m.DiscoReson_wDGRD = 'nonPay' THEN 'NP'
		ELSE 'Vol' END
	, m.DwellType, m.DiscoReson_wDGRD, cast (d.[Week Ending] AS VARCHAR)
	,  case 
		when t.FiOS is not null and t.RCN is not null  then 'FiOS&RCN'
		when t.FiOS is not null then 'FiOS'
		when t.[U-verse] is not null and m.region <> 'KEY' then 'Frontier'
		when t.RCN is not null and m.Fiber <> 'Fiber' then 'RCN'
		when m.Fiber = 'Fiber' and m.Region <> 'WNE' then 'FiOS'
		when m.Fiber = 'Fiber' and m.Region = 'WNE' then 'Frontier'
		when m.Region = 'WNE' and t.[Other] in ('VTEL') then t.[Other]
		when m.Region = 'blt' and t.[Other] in ('Lumos Networks','nDanville') then t.[Other]
		when m.Region = 'fre' and t.[Other] in ('Cablevision','Service Electric Cable') then t.[Other]
		when m.Region = 'gbr' and t.[Other] in ('TDS Fiber') then t.[Other]
		when m.Region = 'key' and t.[Other] in ('Blue Ridge','Zito Media','KCI','Service Electric Cable','Atlantic Broadband') then t.[Other]
		when m.Region = 'wne' and t.[Other] in ('TVC','BT') then t.[Other]
		when t.Other is not null then 'Other'
		else 'No Overbuilder'
		end

	, case 
		when m.ActivityDetail = 'connect' then 'C'
		when m.DiscoReson_wDGRD not in ('downgrade','nonpay','move/trans') then 'Vol'
		else 'Other' End
	, case 
		when np.NPDecile between 0 and 2 then 'High'
		when np.NPDecile between 3 and 6 then 'Med'
		when np.NPDecile between 7 and 9 then 'Low'
					else 'Med'
	  end