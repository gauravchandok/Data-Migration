SELECT d.Scenario AS Yr
, m.Region AS Region
, cast (d.FME AS VARCHAR) AS FME
, CASE
	WHEN m.PackageCategoryRollup IN ('Blast Plus', 'Internet Plus') THEN 'Low2P'
	WHEN m.LOBMix_noXH = 'VD' THEN 'High2P'
	WHEN m.LOBMix_noXH IN ('V', 'D', 'VDT') THEN m.LOBMix_noXH
	ELSE 'Other' END AS LOBMix
, m.Activity
, m.ActivityDetail
, m.DiscoReson_wDGRD AS DiscoReason
, case 
	when t.FiOS is not null then 'FiOS'
	when t.[U-verse] is not null and m.region <> 'KEY' then 'Frontier'
	when t.RCN is not null and m.Fiber <> 'Fiber' then 'RCN'
	when m.Fiber = 'Fiber' and m.Region <> 'WNE' then 'FiOS'
	when m.Fiber = 'Fiber' and m.Region = 'WNE' then 'Frontier'
	when m.Region = 'blt' and t.[Other] in ('Lumos Networks','BCCTV') then t.[Other]
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
	WHEN m.SalesChannel = 'Front Counter' THEN 'Service Ctr'
	WHEN m.SalesChannelRollUp = 'Verizon' THEN 'All Other'
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
, SUM (m.B1) AS B1
, SUM (m.HSI) AS HSI
, SUM (m.CDV) AS CDV
, SUM (m.HS) AS XH
, sum (CASE WHEN Activity = 'Connect' THEN 1 ELSE -1 END) AS Customer
FROM (DOR.dbo.Master_Activity_Table_noSG m
INNER JOIN (
			SELECT Dates.Date AS [Actual_Date],Dates.Date AS [Report_Date],'CY' AS Scenario,
				   Dates.FME,Dates.[Fiscal Year],Dates.Quarter,Dates.[Fiscal Month],dates.[Week Ending], 
				   CASE WHEN Dates.FME = cf.FME THEN 'Y' ELSE 'N' END AS CurrFMEflag
			  FROM DOR.dbo.Dates Dates
				, dor.dbo.tbl_CurFME cf
			 WHERE (Dates.Date < getdate () - 1)
				   AND Dates.[FME] IN (SELECT DISTINCT TOP 36 Dates.[FME]
										 FROM DOR.dbo.Dates Dates
										WHERE (Dates.[FME] <= getdate () + 30)
									   ORDER BY Dates.[FME] DESC)
	                           
			Union All

			SELECT Dates.[Date] AS [Actual Date],DATEADD (Day, 365, Dates.Date) AS [Report Date],
				   case 
					when DATEADD (Day, 365, Dates.Date) < CAST(GETDATE() as date) then 'PY'
					when Dates.[Date] = dateadd(d,0,dateadd(yyyy,-1,Dates_PY.[Date])) then 'PYFuture'
				   end AS Scenario,
				   Dates_PY.FME,Dates_PY.[Fiscal Year],Dates_PY.Quarter,Dates_PY.[Fiscal Month],
				   dates_py.[Week Ending], CASE WHEN Dates_PY.FME = cf.FME THEN 'Y' ELSE 'N' END AS CurrFMEflag		   
			  FROM    DOR.dbo.Dates Dates
				   INNER JOIN DOR.dbo.Dates Dates_PY ON (Dates.Date = Dates_PY.[Prior Year Same Date]) 
				, dor.dbo.tbl_CurFME cf
			 WHERE (Dates.Date <= (select MAX([Prior Year Same Date]) as lastday 
									 from dor.dbo.Dates d, dor.dbo.vw_MTDCurFME v 
									 where d.FME = v.FME))
				AND Dates_PY.[FME] IN (SELECT DISTINCT TOP 36 Dates.[FME]
											FROM DOR.dbo.Dates Dates
										   WHERE (Dates.[FME] <= getdate () + 30)
										  ORDER BY Dates.[FME] DESC)
			) d
	ON (m.Effective_Date = d.Actual_Date))
INNER JOIN DOR.dbo.Dates Dates ON (Dates.[Date] = d.Report_Date)
left join Competitive.dbo.competitive_threat t
	on m.CensusBlock = t.CensusBlock
WHERE Dates.[FME] IN (SELECT DISTINCT TOP 12 Dates.[FME]
					FROM DOR.dbo.Dates Dates
				WHERE (Dates.[FME] <= getdate ())
				ORDER BY Dates.[FME] DESC)
GROUP BY
d.Scenario 
, m.Region 
, cast (d.FME AS VARCHAR) 
, CASE
	WHEN m.PackageCategoryRollup IN ('Blast Plus', 'Internet Plus') THEN 'Low2P'
	WHEN m.LOBMix_noXH = 'VD' THEN 'High2P'
	WHEN m.LOBMix_noXH IN ('V', 'D', 'VDT') THEN m.LOBMix_noXH
	ELSE 'Other' END 
, m.Activity
, m.ActivityDetail
, m.DiscoReson_wDGRD 
, case 
	when t.FiOS is not null then 'FiOS'
	when t.[U-verse] is not null and m.region <> 'KEY' then 'Frontier'
	when t.RCN is not null and m.Fiber <> 'Fiber' then 'RCN'
	when m.Fiber = 'Fiber' and m.Region <> 'WNE' then 'FiOS'
	when m.Fiber = 'Fiber' and m.Region = 'WNE' then 'Frontier'
	when m.Region = 'blt' and t.[Other] in ('Lumos Networks','BCCTV') then t.[Other]
	when m.Region = 'fre' and t.[Other] in ('Cablevision','Service Electric Cable') then t.[Other]
	when m.Region = 'gbr' and t.[Other] in ('TDS Fiber') then t.[Other]
	when m.Region = 'key' and t.[Other] in ('Blue Ridge','Zito Media','KCI','Service Electric Cable','Atlantic Broadband') then t.[Other]
	when m.Region = 'wne' and t.[Other] in ('TVC','BT') then t.[Other]
	when t.Other is not null then 'Other'
	else 'No Overbuilder'
	end 
, CASE
	WHEN m.DiscoReason IN ('Competitive','NonPay','Other','Price/Value') THEN ''
	WHEN m.SalesChannel = 'Inbound Sales' THEN 'Inbound'
	WHEN m.SalesChannel = 'E-Tail' THEN 'Etail'
	WHEN m.SalesChannel = 'Billing & Collections' THEN 'Care'
	WHEN m.SalesChannel = '3rd Party Outsourcer' THEN 'Care'
	WHEN m.SalesChannel = 'Repair' THEN 'Care'
	WHEN m.SalesChannel = 'Retention' THEN 'Retention'
	WHEN m.SalesChannel = 'Retail' THEN 'Retail'
	WHEN m.SalesChannel = 'Front Counter' THEN 'Service Ctr'
	WHEN m.SalesChannelRollUp = 'Verizon' THEN 'All Other'
	WHEN m.SalesChannelRollUp = 'Store In Store' THEN 'All Other'
	ELSE m.SalesChannelRollUp END 
, CASE WHEN m.DiscoSubReason = 'Transfer' THEN 'Transfer' END 
, CASE
	WHEN m.Activity = 'Connect' THEN 'C'
	WHEN m.DiscoReson_wDGRD = 'nonPay' THEN 'NP'
	ELSE 'Vol' END 
, m.Fiber, m.Level_1, m.DwellType
, case 
	when m.ActivityDetail = 'connect' then 'C'
	when m.activity = 'disconnect' and m.DiscoReson_wDGRD not in ('downgrade','nonpay','move/trans') then 'Vol'
	else 'Other' End