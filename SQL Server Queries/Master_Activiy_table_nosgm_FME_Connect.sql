SELECT
m.NewRegion, m.Region, m.Level_1, m.SYSCORP, m.PRIN, m.AGNTFTAX, m.SPA, m.DST_House, m.DST_Cust, m.fme, m.Effective_Date
, m.Account_Number, m.House_Number, m.Order_Number, m.Order_Status, m.Activity, m.ActivityDetail, m.Bus_Res, m.Entered_Date
, m.Scheduled_Date, m.PackageName, m.PackageCodes, m.SIK, m.Package_Category, m.PackageCategoryRollup, m.B1, m.HSI, m.CDV
, m.HS, m.MRC, m.MRC_Finance, m.Tier_B1, m.Tier_HSI, m.Tier_CDV, m.Tier_HS, m.X1, m.TriplePlayPackage, m.Discount_Code
, m.Cust_Discount_Code, m.Campaign_Code, m.SalesID, m.OprID, m.SalesChannelDetail, m.SalesChannelGroup, m.SalesChannel
, m.SalesChannelRollUp, m.SalesLKPTable, m.DiscoCode, m.DiscoCodeDescription, m.DiscoReason, m.DiscoSubReason, m.DiscoReson_wDGRD
, m.LOBMix_noXH, m.LOBMix_DP, m.Income_Level, m.SaMoto, m.Fiber, m.Fiber_Date, m.Competitors, m.LocalOverbuilder, m.CensusBlock
, m.C3_Fiber, m.SuperSegment, m.IncomeCode, m.Ethnicity, m.MedianAge, m.Active_Tenure, m.DwellType, m.MDU_Conn_Type
, m.MDU_Start_Year, m.MDU_Size_Group, m.DWELLCODE, m.Complex, m.City, m.State, m.ZIPCODE, m.LOBMix, m.B1_Flag, m.HSI_Flag
, m.CDV_Flag, m.HS_Flag, m.Bulk_House, m.RC_DiscoDate, m.RC_DiscoCode, m.RC_DiscoDesc, m.RC_DiscoSubGroup, m.RC_DiscoGroup
, m.RC_House_Number, m.RC_Restart, m.RC_SameAccount, m.RC_SameHouse, m.RC_Process, m.LOBMix_PriorToActivity, m.[CONTRACT]
, m.FME_OrderDate
FROM dor.dbo.Master_Activity_Table_nosg m
WHERE PackageCodes IS NOT NULL
AND FME = '2016-08-21'
AND activitydetail = 'connect'



