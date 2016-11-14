SELECT MATNOSG.Region
,DT.[Week Ending]
,MATNOSG.LOBMix_noXH
,case
	when MATNOSG.SalesChannel = 'Billing & Collections' then 'Care'
	when MATNOSG.SalesChannel = '3rd Party Outsourcer' then  'Care'
	when MATNOSG.SalesChannel = 'Repair' then 'Care'
	when MATNOSG.SalesChannel = 'Inbound Sales' then 'Inbound'
	when MATNOSG.SalesChannel = 'Retention' then 'Retention'
	when MATNOSG.SalesChannel IN ('Retail','Verizon', 'Store in Store', 'E-Tail') then 'All Other'
	when MATNOSG.SalesChannel = 'Front Counter' then 'Service Ctr'
else MATNOSG.SalesChannelRollUp end as SalesChannel_wCallCtrDetail
,case when isnull(MATNOSG.[Contract],'')  = 'Y' then 'Y' else 'N' end as [Contract]
,case when MATNOSG.Package_Category = 'Pref/Perf' and Tier_B1 = 'Dig_Tier' and Tier_HSI = 'Blast' then 'Pref/Blast'
	  when MATNOSG.Package_Category = 'Starter/Perf' and Tier_B1 = 'Starter' and Tier_HSI = 'Blast' then 'Starter/Blast'
else MATNOSG.Package_Category end as Package_Category_Modified
,case when (case when MATNOSG.Package_Category = 'Pref/Perf' and Tier_B1 = 'Dig_Tier' and Tier_HSI = 'Blast' then 'Pref/Blast'
	  when MATNOSG.Package_Category = 'Starter/Perf' and Tier_B1 = 'Starter' and Tier_HSI = 'Blast' then 'Starter/Blast'
else MATNOSG.Package_Category end) IN ('Pref/Perf', 'Starter/Perf', 'Pref/Blast', 'Starter/Blast') then 'Y' else 'N' end as DP_Eligible

,COUNT (MATNOSG.Account_Number) AS Subs
FROM DOR.dbo.Master_Activity_Table_noSG MATNOSG
JOIN DOR.dbo.Dates DT 
ON MATNOSG.Effective_Date = DT.Date
left join dor.dbo.tbl_PackageGrouping pg on MATNOSG.PackageName = pg.PackageName
where  DT.[Week Ending] in (select distinct top 4 [Week Ending]
							from dor.dbo.dates
							where [Week Ending] < getdate()
							order by [Week Ending] desc)
AND (MATNOSG.ActivityDetail = 'Connect')
and MATNOSG.LOBMix_noXH in ('VDT', 'VD')
AND (MATNOSG.Bus_Res = 'Residential')
---and MATNOSG.Account_Number = '0950816776907'
GROUP BY  MATNOSG.Region
,DT.[Week Ending]
,MATNOSG.LOBMix_noXH
,case when MATNOSG.LOBMix like '%V%' then 'Y' else 'N' end
,case
	when MATNOSG.SalesChannel = 'Billing & Collections' then 'Care'
	when MATNOSG.SalesChannel = '3rd Party Outsourcer' then  'Care'
	when MATNOSG.SalesChannel = 'Repair' then 'Care'
	when MATNOSG.SalesChannel = 'Inbound Sales' then 'Inbound'
	when MATNOSG.SalesChannel = 'Retention' then 'Retention'
	when MATNOSG.SalesChannel IN ('Retail','Verizon', 'Store in Store', 'E-Tail') then 'All Other'
	when MATNOSG.SalesChannel = 'Front Counter' then 'Service Ctr'
else MATNOSG.SalesChannelRollUp end
,case when isnull(MATNOSG.[Contract],'')  = 'Y' then 'Y' else 'N' end
,case when MATNOSG.Package_Category = 'Pref/Perf' and Tier_B1 = 'Dig_Tier' and Tier_HSI = 'Blast' then 'Pref/Blast'
	  when MATNOSG.Package_Category = 'Starter/Perf' and Tier_B1 = 'Starter' and Tier_HSI = 'Blast' then 'Starter/Blast'
else MATNOSG.Package_Category end
,case when (case when MATNOSG.Package_Category = 'Pref/Perf' and Tier_B1 = 'Dig_Tier' and Tier_HSI = 'Blast' then 'Pref/Blast'
	  when MATNOSG.Package_Category = 'Starter/Perf' and Tier_B1 = 'Starter' and Tier_HSI = 'Blast' then 'Starter/Blast'
else MATNOSG.Package_Category end) IN ('Pref/Perf', 'Starter/Perf', 'Pref/Blast', 'Starter/Blast') then 'Y' else 'N' end