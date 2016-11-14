--Gronk:
SELECT DISTINCT 
Region,
Account_Number,
fme,
Effective_Date,
Order_Status,
Activity,
Bus_Res,
B1,
HSI,
CDV,
HS
FROM DOR.dbo.Master_Activity_Table_noSG Master_Activity_Table_noSG
 WHERE Region = 'WNE'
  AND fme = '2016-03-21 00:00:00'
  AND Order_Status = 'Completed'