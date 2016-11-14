select											
		  a.Region, a.SYSCORP, a.PRIN, a.AGNTFTAX, DST_House, DST_Cust, cast(FME as date) as FME, Entered_Date													
		, cast(effective_date as date) as Effective_Date													
		, cast(scheduled_date as date) as Scheduled_Date, Account_Number, h.House_Number, Order_Number, Order_Status, Activity													
		, ActivityDetail, Bus_Res, B1, HSI, CDV, HS, Tier_B1, Tier_HSI, Tier_CDV, Tier_HS, MRC, ca.HHP, ca.Size_Group, TriplePlayPackage, PackageName, PackageCodes													
		, SalesID, OprID, a.SalesChannelDetail, a.SalesChannel, a.SalesChannelRollUp, a.SalesLKPTable													
		, DiscoCode, DiscoReason, DiscoSubReason, SaMoto, SuperSegment, IncomeCode													
		, Ethnicity, DwellType, a.DWELLCODE, h.Complex, h.City, a.State, h.ZIPCODE, r.DMA_Name													
		, case when b1_flag is null and b1 is not null then 'V' else '' end +													
		case when hsi_flag is null and hsi is not null then 'D' else '' end +													
		case when cdv_flag is null and cdv is not null then 'T' else '' end +													
		case when HS_flag is null and HS is not null then 'H' else '' end as LOBMix													
		,  B1_Flag,  HSI_Flag,  CDV_Flag,  HS_Flag, h.Bulk_House													
		, FME_OrderDate												
		, case when day(entered_date) > 21 AND month(entered_date) <> 12 													
				then convert(varchar,month(entered_date)+1) + '/21/' + convert(varchar,year(entered_date)) 											
				when day(entered_date) > 21 AND month(entered_date) = 12 											
				then '1/21/' + convert(varchar,year(entered_date)+1) 											
				ELSE convert(varchar,month(entered_date)) + '/21/' + convert(varchar,year(entered_date)) 											
				END as FME2											
		, isnull(case													
			when natids.CorpDept = 'E-Tail' then 'ETAIL'	+ case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end											
			when natids.CorpDept = 'RETAIL/ETAIL' and natids.LocalDept in ('BEST BUY','Retail','SEARS','WAL-MART','FRY''S ELECTRONICS','CONVERGYS','TRANSCOM', 'Leapfrog Dealer Program') then 'Retail'		+ case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end										
			when natids.CorpDept = 'RETAIL/ETAIL' and natids.LocalDept not in ('BEST BUY','Retail','SEARS','WAL-MART','FRY''S ELECTRONICS','CONVERGYS','TRANSCOM', 'Leapfrog Dealer Program') then 'ETAIL'	+ case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end											
			WHEN natids.CorpDept = 'Call Center'  and (natids.LocalDept like '%coe%' or natids.LocalDept like '%Inbound%') then natids.LocalDept + case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end												
			WHEN natids.CorpDept = 'Call Center'  and natids.LocalDept not like '%coe%' and natids.LocalDept not like '%Inbound%' then natids.LocalDept + case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end												
			when natids.CorpDept = 'Outbound TMK' and natids.LocalDept  = 'NORTH READING OTM' then natids.LocalDept + case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end												
			when natids.CorpDept = 'Outbound TMK' and natids.LocalDept <> 'NORTH READING OTM' then natids.notes 												
			when natids.CorpDept = 'VERIZON'	  and a.effective_date < '10/22/2012' then 'Other' else natids.CorpDept + case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end 											
		  end,a.SalesChannelDetail) as SosDetail													
		, s.dioncustom as Custom_SOS
    , s.DionCustomCare as Detail_Care
		, s.DionCustomDetail as Detail_SOS

												
		FROM Master_Activity_Table_All a
    left join tbl_Region r on a.SYSCORP = r.SysCorp
    and a.PRIN = r.Prin
    and a.AGNTFTAX = r.AgntFTAX
    left join House_Data h on a.House_Number = h.HOUSE_NUMBER
  left join Complex_Attributes ca on h.Region = ca.region
  AND h.SYSCORP = ca.syscorp
  AND h.COMPLEX = ca.complex_Code
		left join vw_NationalSalesIDs natids on a.SalesID = natids.natsalesid													
		left join (select distinct BeginningSalesRepID, EndingSalesRepID, LocalDept, CorpDept, Notes													
					, LEFT(corpsysprin,4) as SysCorp, RIGHT(corpsysprin,4) as Prin										
					from tbl_DivSOSLkp_temp where BillingSystem = 3) x										
			on a.SYSCORP = x.SysCorp and a.PRIN = x.Prin and a.SalesID = x.BeginningSalesRepID												
		left join tbl_Sales_Channel_Lookup s on isnull(case													
													when natids.CorpDept = 'E-Tail' then 'ETAIL'	+ case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end	
													when natids.CorpDept = 'RETAIL/ETAIL' and natids.LocalDept in ('BEST BUY','Retail','SEARS','WAL-MART','FRY''S ELECTRONICS','CONVERGYS','TRANSCOM', 'Leapfrog Dealer Program') then 'Retail'		+ case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end
													when natids.CorpDept = 'RETAIL/ETAIL' and natids.LocalDept not in ('BEST BUY','Retail','SEARS','WAL-MART','FRY''S ELECTRONICS','CONVERGYS','TRANSCOM', 'Leapfrog Dealer Program') then 'ETAIL'	+ case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end	
													WHEN natids.CorpDept = 'Call Center'  and (natids.LocalDept like '%coe%' or natids.LocalDept like '%Inbound%') then natids.LocalDept + case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end		
													WHEN natids.CorpDept = 'Call Center'  and natids.LocalDept not like '%coe%' and natids.LocalDept not like '%Inbound%' then natids.LocalDept + case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end		
													when natids.CorpDept = 'Outbound TMK' and natids.LocalDept  = 'NORTH READING OTM' then natids.LocalDept + case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end		
													when natids.CorpDept = 'Outbound TMK' and natids.LocalDept <> 'NORTH READING OTM' then natids.notes 		
													when natids.CorpDept = 'VERIZON'		 and a.effective_date < '10/22/2012' then 'Other' else natids.CorpDept + case when natids.Notes like '%3rd%Party%' then ' 3rd Party' else '' end 
												  end,a.SalesChannelDetail) = s.SalesChannelDetail			
		left join tbl_discomap d on a.syscorp = d.syscorp and a.rc_discoreason = d.reasoncode													
		WHERE fme_orderdate = '2016-02-21'													
		AND Activity = 'Connect'