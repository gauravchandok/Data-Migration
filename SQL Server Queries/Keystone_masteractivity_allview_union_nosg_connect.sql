--SQLs Example
--DFW:
SELECT 
m.Region
, m.SYSCORP
, m.PRIN
, m.AGNTFTAX
, m.DST_House
, m.DST_Cust
, m.FME
, m.Entered_Date
, m.Effective_Date
, m.Scheduled_Date
, m.Account_Number
, m.House_Number
, m.Order_Number
, m.Order_Status
, m.Activity
, m.ActivityDetail
, m.Bus_Res
, m.B1
, m.HSI
, m.CDV
, m.HS
, m.TriplePlayPackage
, m.PackageName
, m.PackageCodes
, m.SalesID
, m.OprID
, m.SalesChannelDetail
, m.SalesChannel
, m.SalesChannelRollUp
, m.SalesLKPTable
, m.DiscoCode
, m.DiscoReason
, m.DiscoSubReason
, m.SaMoto
, m.SuperSegment
, m.IncomeCode
, m.Ethnicity
, m.DwellType
, m.DWELLCODE
, m.Complex
, m.City
, m.State
, m.ZIPCODE
, m.LOBMix
, m.B1_Flag
, m.HSI_Flag
, m.CDV_Flag
, m.HS_Flag
, m.Bulk_House
, m.FME_OrderDate
, CASE 
  WHEN  ((m.SalesChannel = '3rd Party Outsourcer') OR (m.SalesChannel = 'Billing & Collections') OR (m.SalesChannel = 'Repair') 
    OR (m.SalesChannel = 'Call Center Unknown')) THEN 'Billing & Repair'
  WHEN m.SalesChannel = 'Inbound Sales' THEN 'Inbound Sales'
  WHEN m.SalesChannel = 'In-House DSR' THEN 'In House'
  WHEN m.SalesChannel = 'Front Counter' THEN 'Cable Store'
  WHEN m.SalesChannel = 'Contract DSR' THEN 'Contractor'
  WHEN m.SalesChannel = 'Commercial' THEN 'Commercial'
  WHEN m.SalesChannel = 'Retention' THEN 'Retention' ELSE 'Other' END AS [SalesChannel]
--, [Region SOS roll-up].[DFW SOS]  -- will add lookup field to the tbl_Saleschannel_Lookup
FROM dor.dbo.Master_Activity_Table_All_View m
WHERE (((m.Region)='key') 
AND ((m.Entered_Date) Between '08/22/2015' And '09/21/2015') 
AND ((m.Order_Status)in ('cancelled','pending')) 
AND ((m.Activity)='connect'))

UNION

SELECT 
sg.Region
, sg.SYSCORP
, sg.PRIN
, sg.AGNTFTAX
, sg.DST_House
, sg.DST_Cust
, sg.FME
, sg.Entered_Date
, sg.Effective_Date
, sg.Scheduled_Date
, sg.Account_Number
, sg.House_Number
, sg.Order_Number
, ' ' AS [Order_Status]
, sg.Activity
, sg.ActivityDetail
, sg.Bus_Res
, sg.B1, sg.HSI
, sg.CDV, sg.HS
, sg.TriplePlayPackage
, sg.PackageName
, sg.PackageCodes
, sg.SalesID
, sg.OprID
, sg.SalesChannelDetail
, sg.SalesChannel
, sg.SalesChannelRollUp
, sg.SalesLKPTable
, sg.DiscoCode
, sg.DiscoReason
, sg.DiscoSubReason
, sg.SaMoto
, sg.SuperSegment
, sg.IncomeCode
, sg.Ethnicity
, sg.DwellType
, sg.DWELLCODE
, sg.Complex
, sg.City
, sg.State
, sg.ZIPCODE
, sg.LOBMix
, sg.B1_Flag
, sg.HSI_Flag
, sg.CDV_Flag
, sg.HS_Flag
, sg.Bulk_House
, ' ' AS [FME_OrderDate]
, CASE 
  WHEN  ((sg.SalesChannel = '3rd Party Outsourcer') OR (sg.SalesChannel = 'Billing & Collections') OR (sg.SalesChannel = 'Repair')) THEN 'Billing & Repair'
  WHEN sg.SalesChannel = 'Inbound Sales' THEN 'Inbound Sales'
  WHEN sg.SalesChannel = 'In-House DSR' THEN 'In House'
  WHEN sg.SalesChannel = 'Front Counter' THEN 'Cable Store'
  WHEN sg.SalesChannel = 'Contract DSR' THEN 'Contractor'
  WHEN sg.SalesChannel = 'Commercial' THEN 'Commercial'
  WHEN sg.SalesChannel = 'Retention' THEN 'Retention' ELSE 'Other' END AS [SalesChannel]
--, [Region SOS roll-up].[DFW SOS]  -- will add lookup field to the tbl_Saleschannel_Lookup
FROM dor.dbo.Master_Activity_Table_noSG sg
WHERE sg.Region='key'
AND sg.Entered_Date Between '08/22/2015' And '09/21/2015' 
AND sg.Activity = 'connect'
