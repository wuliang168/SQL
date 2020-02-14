-- pVW_pEpidemicSuitation_Dep

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pEpidemicSuitation_Dep]
AS

---- 在岗统计
SELECT DISTINCT
GETDATE() as ESDATE,a.approverID AS ApproverID, a.CompID as CompID,a.depid AS DepID,a.DepID1st AS DepID1st,a.DepID2nd AS DepID2nd,
(select Name from eEmployee where EID=a.approverID) as approver,(select xorder from oDepartment where DepID=a.DepID) as xOrder,
(case when a.ApproverID=(select distinct ReportTo from pEpidemicSuitation 
where DATEDIFF(DD,GETDATE(),ESDATE)=0 and ISNULL(Submit,0)=1 and ReportTo=a.ApproverID) then 1 when a.SubmitType=3 then 2 else 0 end) as SubmitStatus,
(case when a.ApproverID=(select distinct ReportTo from pEpidemicSuitationLoc_all
    where DATEDIFF(DD,GETDATE(),ESTDATE)=0 and ISNULL(Submit,0)=1 and ReportTo=a.ApproverID) then 1 else 0 end) as LocSubmitStatus
FROM pEpidemicSuitation_Dep a

Go