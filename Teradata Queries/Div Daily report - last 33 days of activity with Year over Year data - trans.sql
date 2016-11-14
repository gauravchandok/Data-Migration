 SELECT d.Scenario AS Yr
, CASE m.Region_Name 
    WHEN 'GREATER BOSTON REGION' THEN 'GBR'
    WHEN 'WESTERN NEW ENGLAND REGION' THEN 'WNE'
    WHEN 'FREEDOM REGION' THEN 'FRE'  
    WHEN 'BELTWAY REGION' THEN 'BLT'
    WHEN 'KEYSTONE REGION' THEN 'KEY'
    END AS Region
, CAST(CAST(d.report_date AS FORMAT 'YYYY-MM-DD') AS VARCHAR(10)) AS "Date"
, l."Fiscal Mo Wk Num" AS Wk  
, CAST(d."Week Ending" AS VARCHAR(10)) AS "Week Ending"
, CASE WHEN d.report_date > CURRENT_DATE - 22 THEN 'L21' end AS L21
, CASE WHEN d.currfmeflag = 'Y' THEN 'CurrFME' end AS CurrFME
, CASE 
    WHEN m.product_mix LIKE '%video/hsd%' AND m.product_mix NOT LIKE '%cdv%' THEN 'VD'
    WHEN m.product_mix LIKE '%video/hsd/cdv%' THEN 'VDT'
    WHEN m.product_mix LIKE '%video%' THEN 'V'
    WHEN m.product_mix LIKE '%hsd%' THEN 'D'
    ELSE 'Other' end AS LOBMix
, Activity
, CASE ActivityDetail
    WHEN 'new connect' THEN 'Connect'
    WHEN 'full disconnect' THEN 'Disconnect'
    ELSE ActivityDetail end AS ActivityDetail
, CASE 
    WHEN m.activity = 'Connect' THEN ''
    WHEN m.activitydetail = 'downgrade' THEN 'Downgrade'
    WHEN m.Disco_Reason_Rollup_Group_Nm  =  'Non Pay' THEN 'NonPay'
    WHEN  m.Disco_Reason_Rollup_Group_Nm  = 'Moved' THEN 'Move/Trans'
    ELSE 'Other' end AS DiscoReason
, NULL AS Competitor
, CASE
        WHEN M.ACTIVITY = 'DISCONNECT'  AND M.DISCO_REASON_ROLLUP_group_NM NOT LIKE '%moved%'  THEN ''
        WHEN s.SalesChannel = 'Inbound Sales' THEN 'Inbound'
        WHEN s.SalesChannel = 'E-Tail' THEN 'Etail'
        WHEN s.SalesChannel = 'Billing & Collections' THEN 'Care'
        WHEN s.SalesChannel = '3rd Party Outsourcer' THEN 'Care'
        WHEN s.SalesChannel = 'Repair' THEN 'Care'
        WHEN s.SalesChannel = 'Retention' THEN 'Retention'
        WHEN s.SalesChannel = 'Retail' THEN 'Retail'
        WHEN s.SalesChannel = 'Front Counter' THEN  'Service Ctr'
        WHEN s.SalesChannelRollUp = 'Verizon' THEN  'All Other'
        WHEN s.SalesChannelRollUp = 'Store In Store' THEN 'All Other'
        ELSE COALESCE(s.SalesChannelRollUp,'All Other')
  END AS Channel
, CASE 
    WHEN m.disco_reason_rollup_nm LIKE '%transfer%' THEN 'Transfer'
    end AS Transfer
, CASE 
    WHEN m.activity = 'Connect' THEN 'C'
    WHEN m.final_disconnect_type = 'NonPay' THEN 'NP'
    WHEN m.final_disconnect_type = 'Voluntary' THEN 'Vol'
    end AS "NP-Vol"
, CASE 
    WHEN m.ActivityDetail = 'new connect' THEN 'C'
    WHEN m.activity = 'disconnect' AND (m.activitydetail = 'downgrade' OR m.disco_reason_rollup_group_nm IN ('non pay', 'moved')) THEN 'Vol'
    ELSE 'Other' End AS ComptrendGroup
, CASE COALESCE(m.demo_fiber,0)
    WHEN 0 THEN 'NonFiber'
    ELSE 'Fiber' end AS Fiber
, r.Level_1 AS Level_1    
, CASE m.Dwell_Type_Group_Biller 
    WHEN 'commercial' THEN 'BUS'
    WHEN 'MDU' THEN 'MDU'
    ELSE 'SFU' END AS DwellType
, CAST(d.FME AS VARCHAR(10)) AS FME
, SUM(m.b1) AS B1
, SUM(m.hsi) AS HSI
, SUM(m.cdv) AS CDV
, SUM(m.hs) AS XH
, SUM (CASE WHEN Activity = 'Connect' THEN 1 ELSE -1 END) AS Customer
, SUM(CASE WHEN m.total_mrc_amt BETWEEN 10 AND 300 THEN 1 end) AS MRC_Count
, SUM(CASE WHEN m.total_mrc_amt BETWEEN 10 AND 300 THEN m.total_mrc_amt end) AS MRC_Revenue
, NULL AS NP_Risk
FROM ndw_ned_temp.vw_dateswithpy d
JOIN ebi_nsd_views.NSD_MASTER_DAILY_ACTIVITY_NO_M_SG m
    ON d.actual_date = m.effective_date
JOIN ndw_ned_temp.dates l
    ON d.actual_date = l."date"
LEFT JOIN ndw_ned_temp.tbl_region r
    ON CAST(m.syscorp AS INT) = r.syscorp
    AND COALESCE(CAST(m.prin AS INT),0) = r.prin
    AND CAST(m.agntftax AS INT) = r.agntftax
LEFT JOIN EBI_NSD_VIEWS.SALESCHANNEL_LOOKUP_V s
    ON m.final_sales_channel = s.saleschanneldetail
WHERE d.report_date >= CURRENT_DATE - 35
AND m.order_status = 'completed'
AND m.division_name = 'northeast division'
GROUP BY 
   CAST(CAST(d.report_date AS FORMAT 'YYYY-MM-DD') AS VARCHAR(10))
, d.Scenario 
, l."Fiscal Mo Wk Num" 
, CAST(d."Week Ending" AS VARCHAR(10))
, CASE WHEN d.report_date > CURRENT_DATE - 22 THEN 'L21' end 
, CASE WHEN d.currfmeflag = 'Y' THEN 'CurrFME' end 
, CASE m.Region_Name
    WHEN 'GREATER BOSTON REGION' THEN 'GBR'
    WHEN 'WESTERN NEW ENGLAND REGION' THEN 'WNE'
    WHEN 'FREEDOM REGION' THEN 'FRE'
    WHEN 'BELTWAY REGION' THEN 'BLT'
    WHEN 'KEYSTONE REGION' THEN 'KEY'
    END 
, CASE WHEN Activity = 'Connect' THEN 'Connect'                                
      WHEN activity = 'disconnect' AND Final_Disconnect_Type = 'nonPay' THEN 'NonPay'                            
      ELSE 'Voluntary' end 
,CASE WHEN d.actual_date - m.service_order_created_date >= 25 AND m.Scheduled_Date IS NULL THEN 'Y'                                 
      WHEN m.scheduled_date - m.Effective_Date  < -2 THEN 'Y'                            
ELSE 'N' end 
, CASE ActivityDetail
    WHEN 'new connect' THEN 'Connect'
    WHEN 'full disconnect' THEN 'Disconnect'
    ELSE ActivityDetail end , Activity
, CASE
        WHEN M.ACTIVITY = 'DISCONNECT'  AND M.DISCO_REASON_ROLLUP_group_NM NOT LIKE '%moved%'  THEN ''
        WHEN s.SalesChannel = 'Inbound Sales' THEN 'Inbound' 
        WHEN s.SalesChannel = 'E-Tail' THEN 'Etail'
        WHEN s.SalesChannel = 'Billing & Collections' THEN 'Care'
        WHEN s.SalesChannel = '3rd Party Outsourcer' THEN 'Care'
        WHEN s.SalesChannel = 'Repair' THEN 'Care'
        WHEN s.SalesChannel = 'Retention' THEN 'Retention'
        WHEN s.SalesChannel = 'Retail' THEN 'Retail' 
        WHEN s.SalesChannel = 'Front Counter' THEN  'Service Ctr'
        WHEN s.SalesChannelRollUp = 'Verizon' THEN  'All Other'
        WHEN s.SalesChannelRollUp = 'Store In Store' THEN 'All Other'
        ELSE COALESCE(s.SalesChannelRollUp,'All Other')
  END 
  , CASE COALESCE(m.demo_fiber,0)
    WHEN 0 THEN 'NonFiber'
    ELSE 'Fiber' end
, d.FME
, CASE 
    WHEN m.activity = 'Connect' THEN ''
    WHEN m.activitydetail = 'downgrade' THEN 'Downgrade'
    WHEN m.Disco_Reason_Rollup_Group_Nm  =  'Non Pay' THEN 'NonPay'
    WHEN  m.Disco_Reason_Rollup_Group_Nm  = 'Moved' THEN 'Move/Trans'
    ELSE 'Other' end 
, CASE 
    WHEN m.disco_reason_rollup_nm LIKE '%transfer%' THEN 'Transfer'
    end 
, CASE 
    WHEN m.activity = 'Connect' THEN 'C'
    WHEN m.final_disconnect_type = 'NonPay' THEN 'NP'
    WHEN m.final_disconnect_type = 'Voluntary' THEN 'Vol'
    end
, CASE 
    WHEN m.ActivityDetail = 'new connect' THEN 'C'
    WHEN m.activity = 'disconnect' AND (m.activitydetail = 'downgrade' OR m.disco_reason_rollup_group_nm IN ('non pay', 'moved')) THEN 'Vol'
    ELSE 'Other' End
, CASE m.Dwell_Type_Group_Biller 
    WHEN 'commercial' THEN 'BUS'
    WHEN 'MDU' THEN 'MDU'
    ELSE 'SFU' END 
, CASE 
    WHEN m.product_mix LIKE '%video/hsd%' AND m.product_mix NOT LIKE '%cdv%' THEN 'VD'
    WHEN m.product_mix LIKE '%video/hsd/cdv%' THEN 'VDT'
    WHEN m.product_mix LIKE '%video%' THEN 'V'
    WHEN m.product_mix LIKE '%hsd%' THEN 'D'
    ELSE 'Other' end 
, r.Level_1

