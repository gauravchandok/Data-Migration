SELECT
MATNOMSG.REGION_NAME AS Region
--, m.Level_1 (NA)
, MATNOMSG.SYSCORP AS SYSCORP
, MATNOMSG.PRIN AS PRIN
, MATNOMSG.AGNTFTAX AS AGNTFTAX
, CASE WHEN SUBSTR( MATNOMSG.ACCOUNT_NUMBER,1,1)=8 THEN SUBSTR( MATNOMSG.ACCOUNT_NUMBER,1,4) END AS SYS_CSG
, CASE WHEN SUBSTR( MATNOMSG.ACCOUNT_NUMBER,1,1) =8 THEN SUBSTR( MATNOMSG.ACCOUNT_NUMBER,5,2)||'00' END AS PRIN_CSG
, CASE WHEN SUBSTR( MATNOMSG.ACCOUNT_NUMBER,1,1) =8 THEN SUBSTR( MATNOMSG.ACCOUNT_NUMBER,7,3)||'0' END AS AGNT_CSG
, CASE WHEN SUBSTR( MATNOMSG.ACCOUNT_NUMBER,1,1) <>8 THEN SUBSTR( MATNOMSG.ACCOUNT_NUMBER,1,5) END AS CORP_DST
, CASE WHEN SUBSTR( MATNOMSG.ACCOUNT_NUMBER,1,1) <>8 THEN SUBSTR( MATNOMSG.ACCOUNT_NUMBER,6,6) END AS HOUSE_DST
, CASE WHEN SUBSTR( MATNOMSG.ACCOUNT_NUMBER,1,1) <>8 THEN SUBSTR( MATNOMSG.ACCOUNT_NUMBER,12,2) END AS CUST_DST
, CASE WHEN SUBSTR( MATNOMSG.ACCOUNT_NUMBER,1,1) =8 THEN (SUBSTR( MATNOMSG.account_number,1,6)||'00'||SUBSTR( MATNOMSG.account_number,7,3)||'0') END AS SPA_CSG
, MATNOMSG.MONTH_END_DT AS fme
, MATNOMSG.EFFECTIVE_DATE AS Effective_Date
, MATNOMSG.ACCOUNT_NUMBER AS Account_Number
, MATNOMSG.HOUSE_NUMBER AS House_Number
, MATNOMSG.ORDER_NUM AS Order_Number
, MATNOMSG.ORDER_STATUS AS Order_Status
, MATNOMSG.ACTIVITY AS Activity
, MATNOMSG.ACTIVITYDETAIL AS ActivityDetail
, MATNOMSG.CUSTOMER_TYPE AS Bus_Res
, MATNOMSG.SERVICE_ORDER_CREATED_DATE AS Entered_Date
, MATNOMSG.SCHEDULED_DATE AS Scheduled_Date
--, m.PackageName (NA)
--, m.PackageCodes (NA)
, MATNOMSG.ORDER_IS_SIK_IND AS SIK
--, m.Package_Category (NA)
 --, m.PackageCategoryRollup (NA)
 , MATNOMSG.B1 AS B1 
, MATNOMSG.HSI AS HSI
, MATNOMSG.CDV AS CDV
, MATNOMSG.HS AS HS
, MATNOMSG.TOTAL_MRC_AMT AS MRC
--, m.MRC_Finance(NA) NEED TO CIRCLE BACK WITH JOE
, MATNOMSG.B1_TIER AS Tier_B1
, MATNOMSG.HSI_TIER AS Tier_HSI
, MATNOMSG.CDV_TIER AS Tier_CDV
, MATNOMSG.HS_TIER AS Tier_HS
, MATNOMSG.X1_PLATFORM_IND AS X1
--, m.TriplePlayPackage(NA)
--, m.Discount_Code (NA)
--, m.Cust_Discount_Code(NA)
--, m.Campaign_Code(NA)
, MATNOMSG.SALES_REP_ID AS SalesID
, MATNOMSG.OP_ID AS OprID
,MATNOMSG.FINAL_SALES_CHANNEL AS SALESCHANNELDETAIL
,SC.SALESCHANNELGROUP
,SC.SALESCHANNEL
,SC.SALESCHANNELROLLUP
--, m.SalesLKPTable (NA)
, MATNOMSG.SOURCE_DISCONNECT_CODE AS DiscoCode
, MATNOMSG.DISCONNECT_REASON_CD AS DiscoCodeDescription
, MATNOMSG.DISCO_REASON_ROLLUP_NM AS DiscoReason
, MATNOMSG.DISCO_REASON_ROLLUP_GROUP_NM AS DiscoSubReason
--, m.DiscoReson_wDGRD (NA)
, MATNOMSG.PRODUCT_MIX AS LOBMix_noXH
--, m.LOBMix_DP (NA)
--, m.Income_Level (NA)
, MATNOMSG.SAMOTO_CD AS SaMoto
--, m.Fiber (NA)
, MATNOMSG.DEMO_FIBER
, MATNOMSG.DEMO_COMP_FOOTPRINT AS Competitors
--, m.LocalOverbuilder
--, m.CensusBlock
--, m.C3_Fiber
, MATNOMSG.CMCST_SUPER_SEG AS SuperSegment
, MATNOMSG.DEMO_INCOME_CODE AS IncomeCode
, MATNOMSG.ETHNICITY_CODE AS Ethnicity
--, m.MedianAge (NA)
, MATNOMSG.TENURE_BY_DAYS AS Active_Tenure
, MATNOMSG.DWELL_TYPE_GROUP_BILLER AS DwellType
--, m.MDU_Conn_Type
--, m.MDU_Start_Year
--, m.MDU_Size_Group
--, m.DWELLCODE (NA)

, MATNOMSG.COMPLEX_CD AS COMPLEX
, MATNOMSG.CITY AS CITY
, MATNOMSG.STATE AS STATE
, MATNOMSG.ZIP AS ZIP
, MATNOMSG.PRODUCT_MIX AS LOBMix
, MATNOMSG.B1_MONTHLY_FLAG AS B1_Flag
, MATNOMSG.HSI_MONTHLY_FLAG AS HSI_Flag
, MATNOMSG.CDV_MONTHLY_FLAG AS CDV_Flag
, MATNOMSG.HS_MONTHLY_FLAG AS HS_Flag
--, m.Bulk_House(NA)
--, m.RC_DiscoDate (MOVE_NDW)
--, m.RC_DiscoCode(MOVE_NDW)
--, m.RC_DiscoDesc(MOVE_NDW)
--, m.RC_DiscoSubGroup(MOVE_NDW)
--, m.RC_DiscoGroup(MOVE_NDW)
--, m.RC_House_Number(MOVE_NDW)
--, m.RC_Restart(MOVE_NDW)
--, m.RC_SameAccount(MOVE_NDW)
--, m.RC_SameHouse(MOVE_NDW)
--, m.RC_Process(MOVE_NDW)
--, m.LOBMix_PriorToActivity(MOVE_NDW)
--, m.[CONTRACT] (NA)
--, m.FME_OrderDate (NA)
FROM EBI_NSD_VIEWS.NSD_MASTER_DAILY_ACTIVITY_NO_M_SG AS MATNOMSG
LEFT JOIN EBI_NSD_VIEWS.SALESCHANNEL_LOOKUP_V SC
    ON MATNOMSG.FINAL_SALES_CHANNEL= SC.SALESCHANNELDETAIL
WHERE MATNOMSG.MONTH_END_DT = TO_DATE('08/21/2016','MM/DD/YYYY')
AND MATNOMSG.ACTIVITYDETAIL = 'NEW CONNECT'
AND DIVISION_NAME = 'NORTHEAST DIVISION'


--AND PackageCodes IS NOT NULL