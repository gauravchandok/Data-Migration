SELECT											
MAT.REGION_CODE AS Region
, MAT.SYSCORP
, MAT.PRIN
, MAT.AGNTFTAX
--, MAT.DST_House
--, MAT.DST_Cust
, MAT.MONTH_END_DT AS FME
, MAT.SERVICE_ORDER_CREATED_DATE AS Entered_Date											
, MAT. EFFECTIVE_DATE AS Effective_Date													
, MAT.SCHEDULED_DATE AS Scheduled_Date
, MAT.ACCOUNT_NUMBER
, MAT.HOUSE_NUMBER
, MAT.ORDER_NUM AS Order_Number
, MAT.ORDER_STATUS
, MAT.ACTIVITY												
, MAT.ACTIVITYDETAIL
, MAT.CUSTOMER_TYPE AS Bus_Res
, MAT.B1
, MAT.HSI
, MAT.CDV
, MAT.HS
, MAT.B1_TIER
, MAT.HSI_TIER
, MAT.CDV_TIER
, MAT.HS_TIER
, MAT.TOTAL_MRC_AMT AS MRC
--, MAT.TriplePlayPackage
--, MAT.PackageName
--, MAT.PackageCodes													
, MAT.SALES_REP_ID AS SalesID
, MAT.OP_ID AS OprID

, SCLV.SALESCHANNELDETAIL
, SCLV.SALESCHANNEL
, SCLV.SALESCHANNELROLLUP

, SCLV.CUSTOMCHANNEL                                                                                                                                                                                              
, SCLV.CUSTOMDETAIL
, SCLV.CUSTOMCARE

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
, PRODUCT_MIX												
,  MAT.B1_MONTHLY_FLAG AS B1_Flag
,  MAT.HSI_MONTHLY_FLAG AS HSI_Flag
,  MAT.CDV_MONTHLY_FLAG AS CDV_Flag
,  MAT.HS_MONTHLY_FLAG AS HS_Flag
--, HD.Bulk_House													
--, MAT.FME_OrderDate												

, CASE WHEN EXTRACT (DAY FROM MAT.SERVICE_ORDER_CREATED_DATE) > 21 AND EXTRACT (MONTH FROM MAT.SERVICE_ORDER_CREATED_DATE) <> 12 													
THEN CAST((EXTRACT (MONTH FROM MAT.SERVICE_ORDER_CREATED_DATE)+1 ) AS VARCHAR(5)) ||  '/21/' || CAST(EXTRACT(YEAR FROM MAT.SERVICE_ORDER_CREATED_DATE ) AS VARCHAR(5))										
WHEN EXTRACT (DAY FROM MAT.SERVICE_ORDER_CREATED_DATE) > 21 AND EXTRACT (MONTH FROM MAT.SERVICE_ORDER_CREATED_DATE) = 12 											
THEN '1/21/' || CAST((EXTRACT (YEAR FROM MAT.SERVICE_ORDER_CREATED_DATE)+1 ) AS VARCHAR(5)) 											
ELSE CAST((EXTRACT (MONTH FROM MAT.SERVICE_ORDER_CREATED_DATE) ) AS VARCHAR(5)) ||  '/21/' || CAST(EXTRACT(YEAR FROM MAT.SERVICE_ORDER_CREATED_DATE ) AS VARCHAR(5))										
END AS FME2											

--, isnull(case when NATIDS.CorpDept = 'E-Tail' then 'ETAIL'+ case when NATIDS.Notes like '%3rd%Party%' then ' 3rd Party' else '' end                                                                                                                                                                               
 --        when NATIDS.CorpDept = 'RETAIL/ETAIL' and NATIDS.LocalDept in ('BEST BUY','Retail','SEARS','WAL-MART','FRY''S ELECTRONICS','CONVERGYS','TRANSCOM', 'Leapfrog Dealer Program') then 'Retail'+ case when NATIDS.Notes like '%3rd%Party%' then ' 3rd Party' else '' end                                                                                                                                                        
--         when NATIDS.CorpDept = 'RETAIL/ETAIL' and NATIDS.LocalDept not in ('BEST BUY','Retail','SEARS','WAL-MART','FRY''S ELECTRONICS','CONVERGYS','TRANSCOM', 'Leapfrog Dealer Program') then 'ETAIL' + case when NATIDS.Notes like '%3rd%Party%' then ' 3rd Party' else '' end                                                                                                                                                                        
--         WHEN NATIDS.CorpDept like 'Call%Center'  and (NATIDS.LocalDept like '%coe%' or NATIDS.LocalDept like '%Inbound%') then NATIDS.LocalDept + case when NATIDS.Notes like '%3rd%Party%' then ' 3rd Party' else '' end                                                                                                                                                                                        
--         WHEN NATIDS.CorpDept like 'Call%Center'  and NATIDS.LocalDept not like '%coe%' and NATIDS.LocalDept not like '%Inbound%' then NATIDS.LocalDept + case when NATIDS.Notes like '%3rd%Party%' then ' 3rd Party' else '' end                                                                                                                                                                                     
--         when NATIDS.CorpDept = 'Outbound TMK' and NATIDS.LocalDept  = 'NORTH READING OTM' then NATIDS.LocalDept + case when NATIDS.Notes like '%3rd%Party%' then ' 3rd Party' else '' end                                                                                                                                                                                           
 --        when NATIDS.CorpDept = 'Outbound TMK' and NATIDS.LocalDept <> 'NORTH READING OTM' then NATIDS.notes                                                                                                                                                                                       
--         when NATIDS.CorpDept = 'VERIZON' and MAT.effective_date < '10/22/2012' then 'Other' else NATIDS.CorpDept + case when NATIDS.Notes like '%3rd%Party%' then ' 3rd Party' else '' end                                                                                                                                                                            
--         end,MAT.SalesChannelDetail) as SosDetail    
--, NATIDS.CorpDept 
--, NATIDS.LocalDept
--, NATIDS.Notes                                                                                                                                                                                                           


FROM EBI_NSD_VIEWS.NSD_MASTER_DAILY_ACTIVITY MAT
JOIN EBI_NSD_VIEWS.SALESCHANNEL_LOOKUP_V SCLV
ON MAT.FINAL_SALES_CHANNEL= SCLV.SALESCHANNELDETAIL

WHERE MAT.DIVISION_NAME= 'NORTHEAST DIVISION'
AND MAT.MONTH_END_DT = '2016-08-21'
--TO_DATE('08--21-2016', 'MM/DD/YYYY')						
AND MAT.ACTIVITY = 'Connect'
AND BILLER_SOURCE= 'C'