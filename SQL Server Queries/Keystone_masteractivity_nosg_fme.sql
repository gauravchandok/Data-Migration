SELECT
MATNOMSG.Region
, MATNOMSG.SYSCORP
, MATNOMSG.PRIN
, MATNOMSG.AGNTFTAX
, MATNOMSG.DST_House
, MATNOMSG.DST_Cust
, MATNOMSG.fme
, MATNOMSG.Effective_Date
, MATNOMSG.Account_Number
, MATNOMSG.House_Number
, MATNOMSG.Activity
, MATNOMSG.ActivityDetail
, MATNOMSG.Bus_Res
, MATNOMSG.B1
, MATNOMSG.HSI
, MATNOMSG.CDV
, MATNOMSG.HS
, MATNOMSG.SalesID
, MATNOMSG.OprID
, MATNOMSG.SalesChannelDetail
, MATNOMSG.SalesChannel
, MATNOMSG.SalesChannelRollUp
, MATNOMSG.SalesLKPTable
, MATNOMSG.DiscoCode
, MATNOMSG.DiscoReason
, MATNOMSG.DiscoSubReason
, MATNOMSG.SaMoto
, MATNOMSG.Fiber
, MATNOMSG.Competitors
, MATNOMSG.SuperSegment
, MATNOMSG.IncomeCode
, MATNOMSG.Ethnicity
, MATNOMSG.DwellType
, MATNOMSG.DWELLCODE
, MATNOMSG.Complex
, MATNOMSG.City
, MATNOMSG.State
, MATNOMSG.ZIPCODE
, MATNOMSG.LOBMix
, MATNOMSG.B1_Flag
, MATNOMSG.HSI_Flag
, MATNOMSG.CDV_Flag
, MATNOMSG.HS_Flag
, MATNOMSG.Bulk_House
, MATNOMSG.Level_1
, CASE WHEN  ((MATNOMSG.SalesChannel = '3rd Party Outsourcer') OR (MATNOMSG.SalesChannel = 'Billing & Collections')
  OR (MATNOMSG.SalesChannel = 'Repair') OR (MATNOMSG.SalesChannel = 'Call Center Unknown')) THEN 'Billing & Repair'
  WHEN MATNOMSG.SalesChannel = 'Inbound Sales' THEN 'Inbound Sales'
  WHEN MATNOMSG.SalesChannel = 'In-House DSR' THEN 'In House'
  WHEN MATNOMSG.SalesChannel = 'Front Counter' THEN 'Cable Store'
  WHEN MATNOMSG.SalesChannel = 'Contract DSR' THEN 'Contractor'
  WHEN MATNOMSG.SalesChannel = 'Commercial' THEN 'Commercial'
WHEN MATNOMSG.SalesChannel = 'Retention' THEN 'Retention'ELSE 'Other' 
END AS [SalesChannel]
, CASE WHEN MATNOMSG.ActivityDetail = 'Downgrade' THEN 'Downgrade'
  WHEN MATNOMSG.DiscoSubReason = 'Move' THEN 'Move'
  WHEN MATNOMSG.DiscoSubReason = 'Transfer' THEN 'Transfer'
  WHEN MATNOMSG.DiscoSubReason = 'DBS' THEN 'DBS'
  WHEN MATNOMSG.DiscoSubReason = 'VERIZON FIOS' THEN 'FIOS'
  WHEN ((MATNOMSG.DiscoSubReason = 'AT&T U-VERSE' OR (MATNOMSG.DiscoSubReason = 'Other Competitive')
  OR (MATNOMSG.DiscoSubReason = 'Port Out'))) THEN 'Other Competitive'
  WHEN MATNOMSG.DiscoSubReason = 'Price/Value' THEN 'Cost/Value'
  WHEN MATNOMSG.DiscoSubReason = 'NonPay' THEN 'Non-Pay' ELSE 'Other' 
  END AS [DiscoReasonRegion]
, CASE WHEN MATNOMSG.ZIPCODE IN ('15201', '15206', '15217', '15218', '15224', '15215', '15203', '15204', 
'15205','15207', '15208', '15210', '15211', '15212', '15214', '15216', '15219', '15220', '15221', 
'15226', '15227', '15233', '15234', '15235', '15202', '15209', '15223', '15228', '15236', '15237', 
'15239', '15241', '15243', '15108', '15146', '15102', '15136', '15120', '15101', '15143', '15106', 
'15147', '15017', '15116', '15137', '15104', '15145', '15126', '15367', '15112', '15330', '15148', 
'15046', '15035', '15018', '15031', '15056', '15064', '15075', '15082', '15091', '15225', '15261', 
'15275', '15363') THEN 'DISRUPT'
  WHEN MATNOMSG.ZIPCODE IN ('15222', '15025', '15026', '15378') THEN 'WINOVER'
  WHEN MATNOMSG.ZIPCODE IN ('15057', '15037', '15090', '15131', '15024', '15332', '15342', '15350') THEN 'MAINTAIN'
  WHEN MATNOMSG.ZIPCODE IN ( '15213', '15232', '15229', '15238', '15317', '15122', '15071', '15129', '15139', '15085', '15142', '15051', '15055', '15276', '15321', '15615')
  THEN 'PROTECT'
END AS STRATEGIES
FROM dor.dbo.Master_Activity_Table_noSG MATNOMSG
WHERE MATNOMSG.Region= 'key'
AND MATNOMSG.fme= '9/21/15'
