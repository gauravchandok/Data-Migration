SELECT
MATNOMSG.REGION_NAME
, MATNOMSG.REGION_CODE
, MATNOMSG.SYSCORP
, MATNOMSG.PRIN
, MATNOMSG.AGNTFTAX
--, MATNOMSG.DST_House
--, MATNOMSG.DST_Cust
, MATNOMSG.MONTH_END_DT AS fme
, MATNOMSG.EFFECTIVE_DATE
, MATNOMSG.ACCOUNT_NUMBER
, MATNOMSG.HOUSE_NUMBER
, MATNOMSG.ACTIVITY
, MATNOMSG.ACTIVITYDETAIL
, MATNOMSG.CUSTOMER_TYPE AS Bus_Res
, MATNOMSG.B1
, MATNOMSG.HSI
, MATNOMSG.CDV
, MATNOMSG.HS
, MATNOMSG.SALES_REP_ID AS SalesID
, MATNOMSG.OP_ID AS OprID

,SCLV.SALESCHANNEL
, SCLV.SALESCHANNELDETAIL AS SalesChannelDetail
, SCLV.SALESCHANNELROLLUP AS SalesChannelRollUp
--, MATNOMSG.SalesLKPTable
, MATNOMSG.SOURCE_DISCONNECT_CODE AS DiscoCode
, MATNOMSG.DISCO_REASON_ROLLUP_NM AS DiscoReason
, MATNOMSG.DISCO_REASON_ROLLUP_GROUP_NM AS DiscoSubReason
, MATNOMSG.SAMOTO_CD AS SaMoto
--, MATNOMSG.Fiber
, MATNOMSG.DEMO_COMP_FOOTPRINT AS Competitors
, MATNOMSG.CMCST_SUPER_SEG AS SuperSegment
, MATNOMSG.DEMO_INCOME_CODE AS IncomeCode
, MATNOMSG.ETHNICITY_CODE AS Ethnicity
, MATNOMSG.DWELL_TYPE_GROUP_BILLER AS DwellType
--, MATNOMSG.DWELLCODE
, MATNOMSG.COMPLEX_CD AS Complex
, MATNOMSG.CITY
, MATNOMSG.STATE
, MATNOMSG.ZIP AS ZIPCODE
, MATNOMSG.PRODUCT_MIX AS LOBMix
, MATNOMSG.B1_MONTHLY_FLAG AS B1_Flag
, MATNOMSG.HSI_MONTHLY_FLAG AS HSI_Flag
, MATNOMSG.CDV_MONTHLY_FLAG AS CDV_Flag
, MATNOMSG.HS_MONTHLY_FLAG AS HS_Flag
--, MATNOMSG.Bulk_House
--, MATNOMSG.Level_1
, CASE WHEN  ((SCLV.SalesChannel = '3rd Party Outsourcer') OR (SCLV.SalesChannel = 'Billing & Collections')
  OR (SCLV.SalesChannel = 'Repair') OR (SCLV.SalesChannel = 'Call Center Unknown')) THEN 'Billing & Repair'
  WHEN SCLV.SalesChannel = 'Inbound Sales' THEN 'Inbound Sales'
  WHEN SCLV.SalesChannel = 'In-House DSR' THEN 'In House'
  WHEN SCLV.SalesChannel = 'Front Counter' THEN 'Cable Store'
  WHEN SCLV.SalesChannel = 'Contract DSR' THEN 'Contractor'
  WHEN SCLV.SalesChannel = 'Commercial' THEN 'Commercial'
WHEN SCLV.SalesChannel = 'Retention' THEN 'Retention'ELSE 'Other' 
END AS SalesChannel_T
, CASE WHEN MATNOMSG.ActivityDetail = 'Downgrade' THEN 'Downgrade'
  WHEN DiscoSubReason = 'Move' THEN 'Move'
  WHEN DiscoSubReason = 'Transfer' THEN 'Transfer'
  WHEN DiscoSubReason = 'DBS' THEN 'DBS'
  WHEN DiscoSubReason = 'VERIZON FIOS' THEN 'FIOS'
  WHEN ((DiscoSubReason = 'AT&T U-VERSE' OR (DiscoSubReason = 'Other Competitive')
  OR (DiscoSubReason = 'Port Out'))) THEN 'Other Competitive'
--  WHEN MATNOMSG.DiscoSubReason = 'Price/Value' THEN 'Cost/Value'
  WHEN DiscoSubReason = 'NonPay' THEN 'Non-Pay' ELSE 'Other' 
  END AS DiscoReasonRegion
, CASE WHEN ZIPCODE IN ('15201', '15206', '15217', '15218', '15224', '15215', '15203', '15204', 
'15205','15207', '15208', '15210', '15211', '15212', '15214', '15216', '15219', '15220', '15221', 
'15226', '15227', '15233', '15234', '15235', '15202', '15209', '15223', '15228', '15236', '15237', 
'15239', '15241', '15243', '15108', '15146', '15102', '15136', '15120', '15101', '15143', '15106', 
'15147', '15017', '15116', '15137', '15104', '15145', '15126', '15367', '15112', '15330', '15148', 
'15046', '15035', '15018', '15031', '15056', '15064', '15075', '15082', '15091', '15225', '15261', 
'15275', '15363') THEN 'DISRUPT'
  WHEN ZIPCODE IN ('15222', '15025', '15026', '15378') THEN 'WINOVER'
  WHEN ZIPCODE IN ('15057', '15037', '15090', '15131', '15024', '15332', '15342', '15350') THEN 'MAINTAIN'
  WHEN ZIPCODE IN ( '15213', '15232', '15229', '15238', '15317', '15122', '15071', '15129', '15139', '15085', '15142', '15051', '15055', '15276', '15321', '15615')
  THEN 'PROTECT'
END AS STRATEGIES
FROM EBI_NSD_VIEWS.NSD_MASTER_DAILY_ACTIVITY_NO_M_SG MATNOMSG
	LEFT JOIN EBI_NSD_VIEWS.SALESCHANNEL_LOOKUP_V SCLV
    ON MATNOMSG.FINAL_SALES_CHANNEL= SCLV.SALESCHANNELDETAIL

WHERE MATNOMSG.REGION_CODE= 'key'
AND MATNOMSG.MONTH_END_DT= TO_DATE('2015-09-21','YYYY-MM-DD')