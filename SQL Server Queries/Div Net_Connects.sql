SELECT
	  MAT.Region
    , MAT.SYSCORP
    , MAT.PRIN
    , MAT.AGNTFTAX
    , DST_House
    , DST_Cust
    , CAST(FME AS date) AS FME
    , Entered_Date
    , CAST(effective_date AS date) AS Effective_Date													
	, CAST(scheduled_date AS date) AS Scheduled_Date
  , MAT.Account_Number
  , MAT.House_Number
  , MAT.Order_Number
  , MAT.Order_Status
  , MAT.Activity
  , MAT.ActivityDetail
  , MAT.Bus_Res													
	, CASE WHEN isnull(MAT.b1_flag,'')  <> 'Sidegrade' THEN MAT.B1  END AS B1													
	, CASE WHEN isnull(MAT.hsi_flag,'') <> 'Sidegrade' THEN MAT.hsi END AS HSI													
	, CASE WHEN isnull(MAT.cdv_flag,'') <> 'Sidegrade' THEN MAT.cdv END AS CDV													
	, CASE WHEN isnull(MAT.hs_flag,'')  <> 'Sidegrade' THEN MAT.hs  END AS HS													
	, MAT.Tier_B1													
	, MAT.Tier_HSI													
	, MAT.Tier_CDV													
	, MAT.Tier_HS													
	, MAT.MRC	
  , REG.DMA_NAME
  , CA.HHP
  , CA.Size_Group
, CASE ISNULL(CMT.Fiber_Date,'') WHEN '' THEN 'NonFiber' ELSE 'Fiber' END AS Fiber
, MAT.TriplePlayPackage
  , MAT.PackageName
  , MAT.PackageCodes
  , MAT.SalesID
  , MAT.OprID
  , MAT.SalesChannelDetail
  , MAT.SalesChannel
  , MAT.SalesChannelRollUp
  , MAT.SalesLKPTable													
	, MAT.DiscoCode
  , MAT.DiscoReason
  , MAT.DiscoSubReason
  , MAT.SaMoto
  , MAT.SuperSegment
  , MAT.IncomeCode
  , MAT.Ethnicity
  , DwellType
  , MAT.DWELLCODE
  , HD.Complex
  , HD.City
  , MAT.State
  , HD.ZIPCODE													
	, CASE WHEN MAT.b1_flag IS NULL AND MAT.b1 IS NOT NULL THEN 'V' ELSE '' END +													
	CASE WHEN MAT.hsi_flag IS NULL AND MAT.hsi IS NOT NULL THEN 'D' ELSE '' END +													
	CASE WHEN MAT.cdv_flag IS NULL AND MAT.cdv IS NOT NULL then 'T' else '' end +													
	CASE WHEN MAT.HS_flag IS NULL AND MAT.HS IS NOT NULL THEN 'H' ELSE '' END AS LOBMix													
	, CASE WHEN isnull(MAT.b1_flag,'')  <> 'Sidegrade' THEN MAT.B1_Flag  END AS B1_Flag													
	, CASE WHEN isnull(MAT.hsi_flag,'') <> 'Sidegrade' THEN MAT.HSI_Flag END AS HSI_Flag													
	, CASE WHEN isnull(MAT.cdv_flag,'') <> 'Sidegrade' THEN MAT.CDV_Flag END AS CDV_Flag													
	, CASE WHEN isnull(MAT.hs_flag,'')  <> 'Sidegrade' THEN MAT.HS_Flag  END AS HS_Flag													
	, HD.Bulk_House
  , MAT.FME_OrderDate													
	, CASE WHEN DAY(MAT.scheduled_date) > 21 AND MONTH(MAT.scheduled_date) <> 12 													
	        THEN CONVERT(varchar,MONTH(MAT.scheduled_date)+1) + '/21/' + CONVERT(varchar,YEAR(MAT.scheduled_date)) 													
	        WHEN DAY(MAT.scheduled_date) > 21 AND MONTH(MAT.scheduled_date) = 12 													
	        THEN '1/21/' + CONVERT(varchar,YEAR(MAT.scheduled_date)+1) 													
	        ELSE CONVERT(varchar,MONTH(MAT.scheduled_date)) + '/21/' + CONVERT(varchar,YEAR(MAT.scheduled_date)) 													
	        END AS FMEScheduledDate													
	, isnull(case													
		when natids.CorpDept = 'E-Tail' then 'ETAIL'	+ case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end											
		when natids.CorpDept = 'RETAIL/ETAIL' and natids.LocalDept in ('BEST BUY','Retail','SEARS','WAL-MART','FRY''S ELECTRONICS','CONVERGYS','TRANSCOM', 'Leapfrog Dealer Program') then 'Retail'		+ case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end										
		when natids.CorpDept = 'RETAIL/ETAIL' and natids.LocalDept not in ('BEST BUY','Retail','SEARS','WAL-MART','FRY''S ELECTRONICS','CONVERGYS','TRANSCOM', 'Leapfrog Dealer Program') then 'ETAIL'	+ case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end											
		WHEN natids.CorpDept = 'Call Center'  and (natids.LocalDept like '%coe%' or natids.LocalDept like '%Inbound%') then natids.LocalDept + case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end												
		WHEN natids.CorpDept = 'Call Center'  and natids.LocalDept not like '%coe%' and natids.LocalDept not like '%Inbound%' then natids.LocalDept + case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end												
		when natids.CorpDept = 'Outbound TMK' and natids.LocalDept  = 'NORTH READING OTM' then natids.LocalDept + case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end												
		when natids.CorpDept = 'Outbound TMK' and natids.LocalDept <> 'NORTH READING OTM' then natids.notes 												
		when natids.CorpDept = 'VERIZON'	  and MAT.effective_date < '10/22/2012' then 'Other' else natids.CorpDept + case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end 											
	  end,MAT.SalesChannelDetail) AS SosDetail													
	, SCL.dioncustom AS Custom_SOS													
	, SCL.DionCustomDetail AS Detail_SOS
  , SCL.DionCustomCare AS Detail_Care
	, D.discogroup AS RC_DiscoGroup													
	, D.discosubgroup AS RC_DiscoSubGroup
  
  FROM Master_Activity_Table_All MAT
  LEFT JOIN tbl_Region REG 
  ON MAT.SYSCORP = REG.SysCorp
  AND MAT.PRIN = REG.Prin
  AND MAT.AGNTFTAX = REG.AgntFTAX
  LEFT JOIN House_Data HD 
  ON MAT.House_Number = HD.HOUSE_NUMBER
  LEFT JOIN Complex_Attributes CA 
  ON HD.Region = CA.region
  AND HD.SYSCORP = CA.syscorp
  AND HD.COMPLEX = CA.complex_Code
	LEFT JOIN vw_NationalSalesIDs NATIDS 
  ON MAT.SalesID = NATIDS.natsalesid													
	LEFT JOIN (SELECT DISTINCT BeginningSalesRepID, EndingSalesRepID, LocalDept, CorpDept, Notes, LEFT(corpsysprin,4) AS SysCorp, RIGHT(corpsysprin,4) AS Prin										
				FROM tbl_DivSOSLkp_temp WHERE BillingSystem = 3) X										
	ON MAT.SYSCORP = X.SysCorp 
  AND MAT.PRIN = X.Prin 
  AND MAT.SalesID = X.BeginningSalesRepID												
	LEFT JOIN tbl_Sales_Channel_Lookup SCL 
  ON ISNULL(CASE													
												when natids.CorpDept = 'E-Tail' then 'ETAIL'	+ case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end	
												when natids.CorpDept = 'RETAIL/ETAIL' and natids.LocalDept in ('BEST BUY','Retail','SEARS','WAL-MART','FRY''S ELECTRONICS','CONVERGYS','TRANSCOM', 'Leapfrog Dealer Program') then 'Retail'		+ case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end
												when natids.CorpDept = 'RETAIL/ETAIL' and natids.LocalDept not in ('BEST BUY','Retail','SEARS','WAL-MART','FRY''S ELECTRONICS','CONVERGYS','TRANSCOM', 'Leapfrog Dealer Program') then 'ETAIL'	+ case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end	
												WHEN natids.CorpDept = 'Call Center'  and (natids.LocalDept like '%coe%' or natids.LocalDept like '%Inbound%') then natids.LocalDept + case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end		
												WHEN natids.CorpDept = 'Call Center'  and natids.LocalDept not like '%coe%' and natids.LocalDept not like '%Inbound%' then natids.LocalDept + case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end		
												when natids.CorpDept = 'Outbound TMK' and natids.LocalDept  = 'NORTH READING OTM' then natids.LocalDept + case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end		
												when natids.CorpDept = 'Outbound TMK' and natids.LocalDept <> 'NORTH READING OTM' then natids.notes 		
												when natids.CorpDept = 'VERIZON'		 and MAT.effective_date < '10/22/2012' then 'Other' else natids.CorpDept + case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end 
											  end,MAT.SalesChannelDetail) = SCL.SalesChannelDetail			
	LEFT JOIN tbl_discomap D 
  ON MAT.syscorp = D.syscorp 
  AND MAT.rc_discoreason = D.reasoncode													
  LEFT JOIN tbl_COMET_Data CMT 
  ON MAT.House_Number = CMT.HOUSE_NUMBER
  WHERE MAT.fme = '2016-02-21' 													
	AND MAT.Activity = 'Connect'