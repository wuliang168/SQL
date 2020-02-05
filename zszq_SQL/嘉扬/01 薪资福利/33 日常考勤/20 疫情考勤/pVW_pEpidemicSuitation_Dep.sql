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
GETDATE() as ESDATE,ISNULL(a.Director,a.Director2) AS ApproverID, a.CompID as CompID,a.depid AS DepID,a.depid AS DepID1st,NULL AS DepID2nd,
(select Name from eEmployee where EID=ISNULL(a.Director,a.Director2)) as approver,a.xOrder,
(case when (select COUNT(Name) from pEpidemicSuitation where ReportTo=ISNULL(a.Director,a.Director2) and DATEDIFF(DD,GETDATE(),ESDATE)=0)>0 then 1 else 0 end) as SubmitStatus,
(select COUNT(ReportTo) from pEpidemicSuitation where ReportTo=ISNULL(a.Director,a.Director2) and DATEDIFF(DD,GETDATE(),ESDATE)=0) as DepCount
FROM oDepartment a
WHERE ISNULL(a.IsDisabled,0)=0 and ISNULL(a.ISOU,0)=0
and a.DepID not in (349) and a.DepType=1 and a.DepGrade=1
and ISNULL(dbo.eFN_getdepadmin(a.DepID),0)<>695 and a.DepID not in (780,669,811,792,702,360,361,669,789,383)
and ISNULL(a.Director,a.Director2) is not NULL
------ 公司领导
UNION
SELECT DISTINCT
GETDATE() as ESDATE,5256 AS ApproverID, a.CompID as CompID,a.depid AS DepID,a.depid AS DepID1st,NULL AS DepID2nd,
N'吴亮' as approver,a.xOrder,
(case when (select COUNT(Name) from pEpidemicSuitation where ReportTo=5256 and DATEDIFF(DD,GETDATE(),ESDATE)=0)>0 then 1 else 0 end) as SubmitStatus,
(select COUNT(ReportTo) from pEpidemicSuitation where ReportTo=5256 and DATEDIFF(DD,GETDATE(),ESDATE)=0) as DepCount
FROM oDepartment a
WHERE a.DepID in (349)
------ 投行
UNION
SELECT DISTINCT
GETDATE() as ESDATE,(select Director from oDepartment where DepID=683) AS ApproverID, a.CompID as CompID,a.depid AS DepID,a.depid AS DepID1st,NULL AS DepID2nd,
(select Name from eEmployee where EID=ISNULL(a.Director,a.Director2)) as approver,a.xOrder,
(case when (select COUNT(Name) from pEpidemicSuitation where ReportTo=(select Director from oDepartment where DepID=683) and DATEDIFF(DD,GETDATE(),ESDATE)=0)>0 then 1 else 0 end) as SubmitStatus,
(select COUNT(ReportTo) from pEpidemicSuitation where ReportTo=(select Director from oDepartment where DepID=683) and DATEDIFF(DD,GETDATE(),ESDATE)=0) as DepCount
FROM oDepartment a
WHERE a.DepID=695
---- 资管
UNION
SELECT DISTINCT
GETDATE() as ESDATE,ISNULL(a.Director,a.Director2) AS ApproverID, a.CompID as CompID,a.depid AS DepID,a.depid AS DepID1st,NULL AS DepID2nd,
(select Name from eEmployee where EID=ISNULL(a.Director,a.Director2)) as approver,a.xOrder,
(case when (select COUNT(Name) from pEpidemicSuitation where ReportTo=ISNULL(a.Director,a.Director2) and DATEDIFF(DD,GETDATE(),ESDATE)=0)>0 then 1 else 0 end) as SubmitStatus,
(select COUNT(ReportTo) from pEpidemicSuitation where ReportTo=ISNULL(a.Director,a.Director2) and DATEDIFF(DD,GETDATE(),ESDATE)=0) as DepCount
FROM oDepartment a
WHERE ISNULL(a.IsDisabled,0)=0 and ISNULL(a.ISOU,0)=0
and a.CompID=13 and a.DepGrade=1 and a.DepID not in (682,704,671,762,793,801,800)
---- 资本
UNION
SELECT DISTINCT
GETDATE() as ESDATE,ISNULL(a.Director,a.Director2) AS ApproverID, a.CompID as CompID,a.depid AS DepID,a.depid AS DepID1st,NULL AS DepID2nd,
(select Name from eEmployee where EID=ISNULL(a.Director,a.Director2)) as approver,a.xOrder,
(case when (select COUNT(Name) from pEpidemicSuitation where ReportTo=ISNULL(a.Director,a.Director2) and DATEDIFF(DD,GETDATE(),ESDATE)=0)>0 then 1 else 0 end) as SubmitStatus,
(select COUNT(ReportTo) from pEpidemicSuitation where ReportTo=ISNULL(a.Director,a.Director2) and DATEDIFF(DD,GETDATE(),ESDATE)=0) as DepCount
FROM oDepartment a
WHERE a.DepID=392
---- 分支机构
------ 提交
UNION
SELECT DISTINCT
GETDATE() as ESDATE,ISNULL(a.Director,a.Director2) AS ApproverID, a.CompID as CompID,a.depid AS DepID,dbo.eFN_getdepid1st(a.depid) AS DepID1st,dbo.eFN_getdepid2nd(a.depid) AS DepID2nd,
(select Name from eEmployee where EID=ISNULL(a.Director,a.Director2)) as approver,a.xOrder,
(case when (select COUNT(Name) from pEpidemicSuitation where ReportTo=ISNULL(a.Director,a.Director2) and DATEDIFF(DD,GETDATE(),ESDATE)=0)>0 then 1 else 0 end) as SubmitStatus,
(select COUNT(ReportTo) from pEpidemicSuitation where ReportTo=ISNULL(a.Director,a.Director2) and DATEDIFF(DD,GETDATE(),ESDATE)=0) as DepCount
FROM oDepartment a
WHERE ISNULL(a.IsDisabled,0)=0 and ISNULL(a.ISOU,0)=0
and a.DepType in (2,3) and a.DepID not in (444,629,460,652,398,427,451,479,723,728,417)

Go