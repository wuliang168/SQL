-- pVW_pEpidemicSuitationLoc_all

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pEpidemicSuitationLoc_all]
AS

select a.EID,a.BID,a.Name,a.ESTDATE,a.CompID as CompID,a.DepID as DepID,a.DepID1st,a.DepID2nd,
(case when ISNULL(a.BID,a.EID) is not NULL then b.DepType else dbo.eFN_getdeptype(a.DepID) end) as DepType,
a.ReportTo,a.EpidemicType,a.IsReturn,a.IsDS,a.IsDSC,a.GLBDate,a.GLEDate,a.Position,a.ESTReturnDate,a.ESTWorkDate,
a.Submit,a.SubmitBy,a.SubmitTime,
(case when ISNULL(a.BID,a.EID) is not NULL then b.JobxOrder else 999999999999999 end) as jobxorder
from pEpidemicSuitationLoc_all a
left join pVW_employee b on ISNULL(a.BID,a.EID)=ISNULL(b.BID,b.EID)
where DATEDIFF(dd,a.ESTDATE,GETDATE())=0

Go