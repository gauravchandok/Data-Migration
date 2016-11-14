SELECT calls.Region,
       d.Scenario,
       cast (d.[Week Ending] AS VARCHAR) AS [Week Ending],
       d.CurrFMEflag,
       calls.Call_Type,
       SUM (calls.Total_In_House_Calls) AS Calls
  FROM (DOR.dbo.Dates Dates
        INNER JOIN DOR.dbo.vw_DatesWithPY d ON (Dates.[Date] = d.Report_Date))
       INNER JOIN Volumes.dbo.calls calls
          ON (calls.Call_Date = d.Actual_Date)
 WHERE Dates.[Week Ending] IN (SELECT DISTINCT TOP 12 Dates.[Week Ending]
                                 FROM DOR.dbo.Dates Dates
                                WHERE (Dates.[Week Ending] <= getdate ())
                               ORDER BY Dates.[Week Ending] DESC)
GROUP BY d.Scenario,
         d.CurrFMEflag,
         calls.Region,
         calls.Call_Type,
         cast (d.[Week Ending] AS VARCHAR)