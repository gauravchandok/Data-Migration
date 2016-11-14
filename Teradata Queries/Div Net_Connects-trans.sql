SELECT
MAT.REGION_CODE AS Region
, MAT.SYSCORP
, MAT.PRIN
, MAT.AGNTFTAX
--, DST_House
--, DST_Cust
, MAT.MONTH_END_DT AS FME
, MAT.SERVICE_ORDER_CREATED_DATE AS Entered_Date
, MAT.EFFECTIVE_DATE													
, MAT.SCHEDULED_DATE
, MAT.ACCOUNT_NUMBER
, MAT.HOUSE_NUMBER
, MAT.ORDER_NUM AS Order_Number
, MAT.ORDER_STATUS
, MAT.ACTIVITY
, MAT.ACTIVITYDETAIL
, MAT.CUSTOMER_TYPE AS Bus_Res	

, CASE WHEN COALESCE(B1_MONTHLY_FLAG, '0')  <> 'S' THEN B1  END AS B1													
, CASE WHEN COALESCE(HSI_MONTHLY_FLAG,'0') <> 'S' THEN HSI END AS HSI													
, CASE WHEN COALESCE(CDV_MONTHLY_FLAG, '0') <> 'S' THEN CDV END AS CDV													
, CASE WHEN COALESCE(HS_MONTHLY_FLAG, '0')  <> 'S' THEN HS  END AS HS		

, MAT.B1_TIER												
, MAT.HSI_TIER									
, MAT.CDV_TIER											
, MAT.HS_TIER
, MAT.TOTAL_MRC_AMT AS MRC

, MAT.DMA_NAME
--, CA.HHP
--, CA.Size_Group
  
, CASE WHEN MAT.DEMO_FIBER = 1 THEN 'Fiber' ELSE 'NonFiber' END AS Fiber

--, MAT.TriplePlayPackage
--, MAT.PackageName
--, MAT.PackageCodes

, MAT.SALES_REP_ID AS SalesID
, MAT.OP_ID AS OprID

, SCLV.SalesChannelDetail
, SCLV.SalesChannel
, SCLV.SalesChannelRollUp

--, MAT.SalesLKPTable													
, MAT.SOURCE_DISCONNECT_CODE AS DiscoCode
, MAT.DISCO_REASON_ROLLUP_NM AS DiscoReason
, MAT.DISCO_REASON_ROLLUP_GROUP_NM AS DiscoSubReason
, MAT.SAMOTO_CD AS SaMoto
, MAT.CMCST_SUPER_SEG AS SuperSegment
, MAT.DEMO_INCOME_CODE AS IncomeCode
, MAT.ETHNICITY_CODE AS Ethnicity
, MAT.DWELL_TYPE_GROUP_BILLER AS DwellType
--, MAT.DWELLCODE

, MAT.COMPLEX_CD AS Complex
, MAT.CITY
, MAT.STATE

, MAT.ZIP AS ZIPCODE													
, MAT.PRODUCT_MIX
												
, CASE WHEN COALESCE(B1_MONTHLY_FLAG, '0')  <> 'S' THEN B1_MONTHLY_FLAG  END AS B1_Flag													
, CASE WHEN COALESCE(HSI_MONTHLY_FLAG, '0') <> 'S' THEN HSI_MONTHLY_FLAG END AS HSI_Flag													
, CASE WHEN COALESCE(CDV_MONTHLY_FLAG, '0') <> 'S' THEN CDV_MONTHLY_FLAG END AS CDV_Flag													
, CASE WHEN COALESCE(HS_MONTHLY_FLAG, '0')  <> 'S' THEN HS_MONTHLY_FLAG  END AS HS_Flag													

--, HD.Bulk_House

--, MAT.FME_OrderDate

, CASE WHEN EXTRACT (DAY FROM MAT.SCHEDULED_DATE) > 21 AND EXTRACT (MONTH FROM MAT.SCHEDULED_DATE) <> 12 													
THEN CAST((EXTRACT (MONTH FROM MAT.SCHEDULED_DATE)+1 ) AS VARCHAR(5)) ||  '/21/' || CAST(EXTRACT(YEAR FROM MAT.SCHEDULED_DATE ) AS VARCHAR(5))										
WHEN EXTRACT (DAY FROM MAT.SCHEDULED_DATE) > 21 AND EXTRACT (MONTH FROM MAT.SCHEDULED_DATE) = 12 											
THEN '1/21/' || CAST((EXTRACT (YEAR FROM MAT.SCHEDULED_DATE)+1 ) AS VARCHAR(5)) 											
ELSE CAST((EXTRACT (MONTH FROM MAT.SCHEDULED_DATE) ) AS VARCHAR(5)) ||  '/21/' || CAST(EXTRACT(YEAR FROM MAT.SCHEDULED_DATE ) AS VARCHAR(5))										
END AS FMEScheduledDate

--, isnull(case													
--		when natids.CorpDept = 'E-Tail' then 'ETAIL'	+ case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end											
--		when natids.CorpDept = 'RETAIL/ETAIL' and natids.LocalDept in ('BEST BUY','Retail','SEARS','WAL-MART','FRY''S ELECTRONICS','CONVERGYS','TRANSCOM', 'Leapfrog Dealer Program') then 'Retail'		+ case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end										
--		when natids.CorpDept = 'RETAIL/ETAIL' and natids.LocalDept not in ('BEST BUY','Retail','SEARS','WAL-MART','FRY''S ELECTRONICS','CONVERGYS','TRANSCOM', 'Leapfrog Dealer Program') then 'ETAIL'	+ case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end											
--		WHEN natids.CorpDept = 'Call Center'  and (natids.LocalDept like '%coe%' or natids.LocalDept like '%Inbound%') then natids.LocalDept + case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end												
--		WHEN natids.CorpDept = 'Call Center'  and natids.LocalDept not like '%coe%' and natids.LocalDept not like '%Inbound%' then natids.LocalDept + case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end												
--		when natids.CorpDept = 'Outbound TMK' and natids.LocalDept  = 'NORTH READING OTM' then natids.LocalDept + case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end												
--		when natids.CorpDept = 'Outbound TMK' and natids.LocalDept <> 'NORTH READING OTM' then natids.notes 												
--		when natids.CorpDept = 'VERIZON'	  and MAT.effective_date < '10/22/2012' then 'Other' else natids.CorpDept + case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end 											
--	  end,MAT.SalesChannelDetail) AS SosDetail													

, SCLV.CUSTOMCHANNEL AS Custom_SOS
, SCLV.CUSTOMDETAIL AS Detail_SOS
, SCLV.CUSTOMCARE AS Detail_Care


, MAT.DISCO_REASON_ROLLUP_NM AS DISCO_GROUP
, MAT.DISCO_REASON_ROLLUP_GROUP_NM AS DISCO_SUBGROUP

FROM EBI_NSD_VIEWS.NSD_MASTER_DAILY_ACTIVITY MAT
JOIN EBI_NSD_VIEWS.SALESCHANNEL_LOOKUP_V SCLV
	ON MAT.FINAL_SALES_CHANNEL= SCLV.SALESCHANNELDETAIL

WHERE MAT.MONTH_END_DT = '2016-02-21'
AND MAT.DIVISION_NAME= 'NORTHEAST DIVISION'
AND MAT.Activity = 'Connect'















