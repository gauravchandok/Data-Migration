--Homes Passed:
SELECT HDS.FME
, HDS.Region
, REG.DMA_NAME
, CASE WHEN CMT.Fiber_Date IS NOT NULL THEN 'Fiber' ELSE 'NonFiber' END AS Fiber
, CASE WHEN CMT.IncomeCode IN ('<15K', '15-20K', '20-30K') THEN 'Low (<30k)'
  WHEN CMT.IncomeCode IN ('30-40K', '40-50K', '50-75K') THEN 'Med (30-75K)' ELSE 'High >75K' END AS Income
, CASE WHEN DT.DwellType = 'COM' THEN 'BUS'
  WHEN CA.[Exclude Final] = 0 THEN 'MDU' ELSE 'SFU' END AS Dwell
, REG.Level_1
, REG.Top_Cities
, COUNT (HDS.HOUSE_NUMBER) AS HHP
, SUM (NDWADS.B1) AS B1
, SUM (NDWADS.HSI) AS HSI
, SUM (NDWADS.CDV) AS CDV
, SUM (NDWADS.HOME_SEC) AS XH
FROM ((((DOR.dbo.House_Data_Snap HDS
  LEFT OUTER JOIN DOR.dbo.Complex_Attributes CA
  ON (HDS.Region = CA.region)
     AND (HDS.SYSCORP = CA.syscorp)
     AND (HDS.COMPLEX = CA.complex_Code))
  LEFT OUTER JOIN DOR.dbo.NDW_Account_Detail_Snap NDWADS
  ON     (HDS.FME = NDWADS.FME)
    AND (HDS.SYSCORP = NDWADS.SysCorp)
    AND (HDS.HOUSE_NUMBER = NDWADS.House_Number))
  LEFT OUTER JOIN DOR.dbo.tbl_Region REG
  ON     (REG.SysCorp = HDS.SYSCORP)
    AND (REG.Prin = HDS.PRIN)
    AND (REG.AgntFTAX = HDS.AGNTFTAX))
  LEFT OUTER JOIN DOR.dbo.tbl_COMET_Data CMT
  ON (CMT.SYSCORP = HDS.SYSCORP) 
    AND (CMT.HOUSE_NUMBER = HDS.HOUSE_NUMBER))
  LEFT OUTER JOIN DOR.dbo.tbl_DwellType DT
  ON (DT.SYSCORP = HDS.SYSCORP) AND (DT.DwellCode = HDS.DWELLCODE)
WHERE (HDS.FME > getdate () - 30) AND (HDS.VideoServiceable = '1') 
AND HDS.Region = 'KEY'
AND HDS.prin <> 0
GROUP BY HDS.FME
, HDS.Region
, CASE WHEN CMT.Fiber_Date IS NOT NULL THEN 'Fiber' ELSE 'NonFiber' END
, REG.DMA_NAME
, REG.Level_1
, REG.Top_Cities
, CASE WHEN CMT.IncomeCode IN ('<15K', '15-20K', '20-30K') THEN 'Low (<30k)'
  WHEN CMT.IncomeCode IN ('30-40K', '40-50K', '50-75K') THEN 'Med (30-75K)' ELSE 'High >75K'END
, CASE WHEN DT.DwellType = 'COM' THEN 'BUS'
  WHEN CA.[Exclude Final] = 0 THEN 'MDU' ELSE 'SFU' END



