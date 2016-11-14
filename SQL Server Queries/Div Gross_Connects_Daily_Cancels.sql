SELECT											
MAT.Region
, MAT.SYSCORP
, MAT.PRIN
, MAT.AGNTFTAX
, MAT.DST_House
, MAT.DST_Cust
, cast(MAT.FME as date) as FME
, MAT.Entered_Date													
, cast(MAT.effective_date as date) as Effective_Date													
, cast(MAT.scheduled_date as date) as Scheduled_Date
, MAT.Account_Number
, HD.House_Number
, MAT.Order_Number
, MAT.Order_Status
, MAT.Activity													
, MAT.ActivityDetail
, MAT.Bus_Res
, MAT.B1
, MAT.HSI
, MAT.CDV
, MAT.HS
, MAT.Tier_B1
, MAT.Tier_HSI
, MAT.Tier_CDV
, MAT.Tier_HS
, MAT.MRC
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
--, MAT.DwellType
, MAT.DWELLCODE
, HD.Complex
, HD.City
, MAT.State
, HD.ZIPCODE													
, case when MAT.b1_flag is null and b1 is not null then 'V' else '' end +													
	case when MAT.hsi_flag is null and hsi is not null then 'D' else '' end +													
	case when MAT.cdv_flag is null and cdv is not null then 'T' else '' end +													
	case when MAT.HS_flag is null and HS is not null then 'H' else '' end as LOBMix													
,  MAT.B1_Flag
,  MAT.HSI_Flag
,  MAT.CDV_Flag
,  MAT.HS_Flag
, HD.Bulk_House													
, MAT.FME_OrderDate												
, case when day(MAT.entered_date) > 21 AND month(MAT.entered_date) <> 12 													
  then convert(varchar,month(MAT.entered_date)+1) + '/21/' + convert(varchar,year(MAT.entered_date)) 											
	when day(MAT.entered_date) > 21 AND month(MAT.entered_date) = 12 											
	then '1/21/' + convert(varchar,year(MAT.entered_date)+1) 											
	ELSE convert(varchar,month(MAT.entered_date)) + '/21/' + convert(varchar,year(MAT.entered_date)) 											
	END as FME2											
, isnull(case when NATIDS.CorpDept = 'E-Tail' then 'ETAIL'+ case when NATIDS.Notes like '%3rd%Party%' then ' 3rd Party' else '' end                                                                                                                                                                               
         when NATIDS.CorpDept = 'RETAIL/ETAIL' and NATIDS.LocalDept in ('BEST BUY','Retail','SEARS','WAL-MART','FRY''S ELECTRONICS','CONVERGYS','TRANSCOM', 'Leapfrog Dealer Program') then 'Retail'+ case when NATIDS.Notes like '%3rd%Party%' then ' 3rd Party' else '' end                                                                                                                                                        
         when NATIDS.CorpDept = 'RETAIL/ETAIL' and NATIDS.LocalDept not in ('BEST BUY','Retail','SEARS','WAL-MART','FRY''S ELECTRONICS','CONVERGYS','TRANSCOM', 'Leapfrog Dealer Program') then 'ETAIL' + case when NATIDS.Notes like '%3rd%Party%' then ' 3rd Party' else '' end                                                                                                                                                                        
         WHEN NATIDS.CorpDept like 'Call%Center'  and (NATIDS.LocalDept like '%coe%' or NATIDS.LocalDept like '%Inbound%') then NATIDS.LocalDept + case when NATIDS.Notes like '%3rd%Party%' then ' 3rd Party' else '' end                                                                                                                                                                                        
         WHEN NATIDS.CorpDept like 'Call%Center'  and NATIDS.LocalDept not like '%coe%' and NATIDS.LocalDept not like '%Inbound%' then NATIDS.LocalDept + case when NATIDS.Notes like '%3rd%Party%' then ' 3rd Party' else '' end                                                                                                                                                                                     
         when NATIDS.CorpDept = 'Outbound TMK' and NATIDS.LocalDept  = 'NORTH READING OTM' then NATIDS.LocalDept + case when NATIDS.Notes like '%3rd%Party%' then ' 3rd Party' else '' end                                                                                                                                                                                           
         when NATIDS.CorpDept = 'Outbound TMK' and NATIDS.LocalDept <> 'NORTH READING OTM' then NATIDS.notes                                                                                                                                                                                       
         when NATIDS.CorpDept = 'VERIZON' and MAT.effective_date < '10/22/2012' then 'Other' else NATIDS.CorpDept + case when NATIDS.Notes like '%3rd%Party%' then ' 3rd Party' else '' end                                                                                                                                                                            
         end,MAT.SalesChannelDetail) as SosDetail    
, NATIDS.CorpDept 
, NATIDS.LocalDept
, NATIDS.Notes                                                                                                                                                                                                           
, SCL.dioncustom as Custom_SOS                                                                                                                                                                                                  
, SCL.DionCustomDetail as Detail_SOS
, SCL.DionCustomCare as Detail_Care

FROM Master_Activity_Table_All MAT
left join tbl_Region REG 
on MAT.SYSCORP = REG.SysCorp
    and MAT.PRIN = REG.Prin
    and MAT.AGNTFTAX = REG.AgntFTAX
left join House_Data HD 
on MAT.House_Number = HD.HOUSE_NUMBER
left join Complex_Attributes CA 
on HD.Region = CA.region
  AND HD.SYSCORP = CA.syscorp
  AND HD.COMPLEX = CA.complex_Code
left join vw_NationalSalesIDs NATIDS
on MAT.SalesID = NATIDS.natsalesid													
left join (select distinct BeginningSalesRepID, EndingSalesRepID, LocalDept, CorpDept, Notes													
, LEFT(corpsysprin,4) as SysCorp, RIGHT(corpsysprin,4) as Prin from tbl_DivSOSLkp_temp where BillingSystem = 3) X										
on MAT.SYSCORP = X.SysCorp 
and MAT.PRIN = X.Prin 
and MAT.SalesID = X.BeginningSalesRepID												
left join tbl_Sales_Channel_Lookup SCL on isnull(case                                                                                                                                                                                                         
  when NATIDS.CorpDept = 'E-Tail' then 'ETAIL'+ case when NATIDS.Notes like '%3rd%Party%' then ' 3rd Party' else '' end              
  when NATIDS.CorpDept = 'RETAIL/ETAIL' and NATIDS.LocalDept in ('BEST BUY','Retail','SEARS','WAL-MART','FRY''S ELECTRONICS','CONVERGYS','TRANSCOM', 'Leapfrog Dealer Program') then 'Retail'+ case when NATIDS.Notes like '%3rd%Party%' then ' 3rd Party' else '' end
  when NATIDS.CorpDept = 'RETAIL/ETAIL' and NATIDS.LocalDept not in ('BEST BUY','Retail','SEARS','WAL-MART','FRY''S ELECTRONICS','CONVERGYS','TRANSCOM', 'Leapfrog Dealer Program') then 'ETAIL'+ case when NATIDS.Notes like '%3rd%Party%' then ' 3rd Party' else '' end                
  WHEN NATIDS.CorpDept like 'Call%Center'  and (NATIDS.LocalDept like '%coe%' or NATIDS.LocalDept like '%Inbound%') then NATIDS.LocalDept + case when NATIDS.Notes like '%3rd%Party%' then ' 3rd Party' else '' end                        
  WHEN NATIDS.CorpDept like 'Call%Center'  and NATIDS.LocalDept not like '%coe%' and NATIDS.LocalDept not like '%Inbound%' then NATIDS.LocalDept + case when NATIDS.Notes like '%3rd%Party%' then ' 3rd Party' else '' end                            
  when NATIDS.CorpDept = 'Outbound TMK' and NATIDS.LocalDept  = 'NORTH READING OTM' then NATIDS.LocalDept + case when NATIDS.Notes like '%3rd%Party%' then ' 3rd Party' else '' end                                
  when NATIDS.CorpDept = 'Outbound TMK' and NATIDS.LocalDept <> 'NORTH READING OTM' then NATIDS.notes                       
  when NATIDS.CorpDept = 'VERIZON'  and MAT.effective_date < '10/22/2012' then 'Other' else NATIDS.CorpDept + case when NATIDS.Notes like '%3rd%Party%' then ' 3rd Party' else '' end 
  end,MAT.SalesChannelDetail) = SCL.SalesChannelDetail                                      
left join tbl_discomap d 
on MAT.syscorp = d.syscorp 
and MAT.rc_discoreason = d.reasoncode													
WHERE MAT.fme = '2016-08-21'													
AND MAT.Activity = 'Connect'