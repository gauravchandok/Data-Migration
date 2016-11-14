SELECT MATNOSG.region
,MATNOSG.LOBMix_noXH
,DTPY.Report_Date
,DTPY.Scenario
,sum(case when isnull(X1,0) = 'Y' then 1 else 0 end) as X1_Connects
,sum(isnull(MATNOSG.B1,0)) as B1_Connects
from dor.dbo.Master_Activity_Table_noSG MATNOSG
join DOR.dbo.vw_DatesWithPY DTPY 
  ON MATNOSG.Effective_Date = DTPY.Actual_Date                                     
join dor.dbo.dates DT on DTPY.Report_Date = DT.Date                                      
where MATNOSG.activity = 'Connect'
and isnull(MATNOSG.B1,0)<>0
and DTPY.CurrFMEflag = 'Y'
and DTPY.Scenario <> 'PYFuture'
and MATNOSG.bus_res = 'RESIDENTIAL'
group by region
,DTPY.Report_Date
,DTPY.Scenario
,MATNOSG.LOBMix_noXH
order by DTPY.Report_Date