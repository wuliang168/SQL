-- pVW_pEpidemicSuitation_Dep

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pEpidemicSuitation_Dep]
AS

---- 总部
SELECT DISTINCT
GETDATE() as ESDATE,b.approverID AS ApproverID, a.CompID as CompID,a.depid AS DepID,b.DepID1st AS DepID1st,b.DepID2nd AS DepID2nd,
(select Name from eEmployee where EID=b.approverID) as approver,a.xOrder,
(case when (select COUNT(Name) from pEpidemicSuitation where ReportTo=b.approverID and DATEDIFF(DD,GETDATE(),ESDATE)=0)>0 and b.SubmitStatus=1 then 1 when b.SubmitStatus=3 then 2 else 0 end) as SubmitStatus,
(select COUNT(ReportTo) from pEpidemicSuitation where ReportTo=b.approverID and DATEDIFF(DD,GETDATE(),ESDATE)=0) as DepCount
FROM oDepartment a,pEpidemicSuitation_Dep b
WHERE a.DepID=b.DepID
and b.SubmitStatus in (1,3)

Go