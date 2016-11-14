SELECT DISTINCT
MATNOMSG.Region,
MATNOMSG.SIK,
MATNOMSG.LOBMix_noXH,
MATNOMSG.Activity,
MATNOMSG.ActivityDetail,
MATNOMSG.Account_Number,
MATNOMSG.fme,
--Dates.Friday_Week_Ending,
MATNOMSG.SalesChannel,
MATNOMSG.SalesChannelRollUp,
MATNOMSG.SalesID,
WID.MAIN_GROUP,
WID.SUB_GROUP,
WID.JOB_FUNC_NME,
WID.JOB_TTL_NME,
WID.PERNR,
WID.CSG_REP,
WID.EMP_NAME,
WID.SUP_NAME,
WID.MGR_NAME,
WID.DIR_NAME,
MATNOMSG.PackageName,
MATNOMSG.X1
  FROM (DOR.dbo.Master_Activity_Table_noSG MATNOMSG
        INNER JOIN DOR.dbo.Dates Dates
           ON (MATNOMSG.Effective_Date = Dates.[Date]))
       INNER JOIN WNE.dbo.WNE_IDS_2 WID
          ON (MATNOMSG.SalesID = WID.CSG_REP)
           WHERE    
          MATNOMSG.Region = 'WNE'
       AND MATNOMSG.Activity = 'Connect'
       AND MATNOMSG.fme between '2016-01-21 00:00:00' and'2016-05-21 00:00:00' 
       and WID.RGN_CDE = 'WNE'
