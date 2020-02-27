-- pVW_pYearMDSalaryModifyEMP

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pYearMDSalaryModifyEMP]
AS

-- 非虚拟部门员工
---- 总部
------ 非财富、投资银行
select a.EID as EID,a.Badge as Badge,a.Name as Name,b.DepID as SupDepID,a.DepID as DepID,a.JobID as JobID,
b.Director as Director,a.HighLevel as Education,a.HighDegree as Degree,
ROUND(DATEDIFF(mm, a.JoinDate, GETDATE()) / 12.00 + ISNULL(a.Cyear_adjust, 0), 2) as ServingAge,
ROUND(ISNULL(a.workyear_adjust, 0) + ROUND(DATEDIFF(mm, a.WorkBeginDate, GETDATE()) / 12.00, 2), 2) as Seniority,
(select Date from pYear_Process where ID=e.pYear_ID) as pYear,e.ScoreYear as ScoreYear,e.Ranking as Ranking,e.RankLevel as RankLevel,
d.MDID as MDID,c.SalaryPerMM as SalaryPerMM
from eVW_employee a
left join pVW_pYearMDSalaryModifyDep b on dbo.eFN_getdepid1st(a.DepID)=b.DepID and dbo.eFN_getdepadmin(b.DepID) not in (811,695)
inner join pEMPSalary c on a.EID=c.EID
inner join pEMPAdminIDMD d on a.EID=d.EID
inner join pVW_pYear_ScoreResult_All e on e.Score_Status=99 and e.Score_Type1 in (1,2,4)
and a.EID=e.EID and e.pYear_ID=(select MAX(ID) from pYear_Process where ISNULL(Closed,0)=1)
------ 财富管理总部
UNION
select a.EID as EID,a.Badge as Badge,a.Name as Name,b.DepID as SupDepID,a.DepID as DepID,a.JobID as JobID,
b.Director as Director,a.HighLevel as Education,a.HighDegree as Degree,
ROUND(DATEDIFF(mm, a.JoinDate, GETDATE()) / 12.00 + ISNULL(a.Cyear_adjust, 0), 2) as ServingAge,
ROUND(ISNULL(a.workyear_adjust, 0) + ROUND(DATEDIFF(mm, a.WorkBeginDate, GETDATE()) / 12.00, 2), 2) as Seniority,
(select Date from pYear_Process where ID=e.pYear_ID) as pYear,e.ScoreYear as ScoreYear,e.Ranking as Ranking,e.RankLevel as RankLevel,
d.MDID as MDID,c.SalaryPerMM as SalaryPerMM
from eVW_employee a
left join pVW_pYearMDSalaryModifyDep b on dbo.eFN_getdepadmin(dbo.eFN_getdepid1st(a.DepID))=b.DepID and b.DepID=811
inner join pEMPSalary c on a.EID=c.EID
inner join pEMPAdminIDMD d on a.EID=d.EID
inner join pVW_pYear_ScoreResult_All e on e.Score_Status=99 and e.Score_Type1 in (1,2,4)
and a.EID=e.EID and e.pYear_ID=(select MAX(ID) from pYear_Process where ISNULL(Closed,0)=1)
------ 投资银行
UNION
select a.EID as EID,a.Badge as Badge,a.Name as Name,b.DepID as SupDepID,a.DepID as DepID,a.JobID as JobID,
b.Director as Director,a.HighLevel as Education,a.HighDegree as Degree,
ROUND(DATEDIFF(mm, a.JoinDate, GETDATE()) / 12.00 + ISNULL(a.Cyear_adjust, 0), 2) as ServingAge,
ROUND(ISNULL(a.workyear_adjust, 0) + ROUND(DATEDIFF(mm, a.WorkBeginDate, GETDATE()) / 12.00, 2), 2) as Seniority,
(select Date from pYear_Process where ID=e.pYear_ID) as pYear,e.ScoreYear as ScoreYear,e.Ranking as Ranking,e.RankLevel as RankLevel,
d.MDID as MDID,c.SalaryPerMM as SalaryPerMM
from eVW_employee a
left join pVW_pYearMDSalaryModifyDep b on dbo.eFN_getdepadmin(dbo.eFN_getdepid1st(a.DepID))=b.DepID and b.DepID=695
inner join pEMPSalary c on a.EID=c.EID
inner join pEMPAdminIDMD d on a.EID=d.EID
inner join pVW_pYear_ScoreResult_All e on e.Score_Status=99 and e.Score_Type1 in (1,2,4)
and a.EID=e.EID and e.pYear_ID=(select MAX(ID) from pYear_Process where ISNULL(Closed,0)=1)
---- 分支机构
UNION
select a.EID as EID,a.Badge as Badge,a.Name as Name,b.DepID as SupDepID,a.DepID as DepID,a.JobID as JobID,
b.Director as Director,a.HighLevel as Education,a.HighDegree as Degree,
ROUND(DATEDIFF(mm, a.JoinDate, GETDATE()) / 12.00 + ISNULL(a.Cyear_adjust, 0), 2) as ServingAge,
ROUND(ISNULL(a.workyear_adjust, 0) + ROUND(DATEDIFF(mm, a.WorkBeginDate, GETDATE()) / 12.00, 2), 2) as Seniority,
(select Date from pYear_Process where ID=e.pYear_ID) as pYear,e.ScoreYear as ScoreYear,e.Ranking as Ranking,e.RankLevel as RankLevel,
d.MDID as MDID,c.SalaryPerMM as SalaryPerMM
from eVW_employee a
left join pVW_pYearMDSalaryModifyDep b on dbo.eFN_getdepid1st(a.DepID)=b.DepID
inner join pEMPSalary c on a.EID=c.EID
inner join pEMPAdminIDMD d on a.EID=d.EID
inner join pVW_pYear_ScoreResult_All e on e.Score_Status=99 and e.Score_Type1 in (32,33)
and a.EID=e.EID and e.pYear_ID=(select MAX(ID) from pYear_Process where ISNULL(Closed,0)=1)
---- 资管
UNION
select a.EID as EID,a.Badge as Badge,a.Name as Name,b.DepID as SupDepID,a.DepID as DepID,a.JobID as JobID,
b.Director as Director,a.HighLevel as Education,a.HighDegree as Degree,
ROUND(DATEDIFF(mm, a.JoinDate, GETDATE()) / 12.00 + ISNULL(a.Cyear_adjust, 0), 2) as ServingAge,
ROUND(ISNULL(a.workyear_adjust, 0) + ROUND(DATEDIFF(mm, a.WorkBeginDate, GETDATE()) / 12.00, 2), 2) as Seniority,
(select Date from pYear_Process where ID=e.pYear_ID) as pYear,e.ScoreYear as ScoreYear,e.Ranking as Ranking,e.RankLevel as RankLevel,
d.MDID as MDID,c.SalaryPerMM as SalaryPerMM
from eVW_employee a
left join pVW_pYearMDSalaryModifyDep b on b.DepID=393
inner join pEMPSalary c on a.EID=c.EID
inner join pEMPAdminIDMD d on a.EID=d.EID
inner join pVW_pYear_ScoreResult_All e on e.Score_Status=99 and e.Score_Type1 in (10,30,11)
and a.EID=e.EID and e.pYear_ID=(select MAX(ID) from pYear_Process where ISNULL(Closed,0)=1)
---- 资本
UNION
select a.EID as EID,a.Badge as Badge,a.Name as Name,b.DepID as SupDepID,a.DepID as DepID,a.JobID as JobID,
b.Director as Director,a.HighLevel as Education,a.HighDegree as Degree,
ROUND(DATEDIFF(mm, a.JoinDate, GETDATE()) / 12.00 + ISNULL(a.Cyear_adjust, 0), 2) as ServingAge,
ROUND(ISNULL(a.workyear_adjust, 0) + ROUND(DATEDIFF(mm, a.WorkBeginDate, GETDATE()) / 12.00, 2), 2) as Seniority,
(select Date from pYear_Process where ID=e.pYear_ID) as pYear,e.ScoreYear as ScoreYear,e.Ranking as Ranking,e.RankLevel as RankLevel,
d.MDID as MDID,c.SalaryPerMM as SalaryPerMM
from eVW_employee a
left join pVW_pYearMDSalaryModifyDep b on b.DepID=392
inner join pEMPSalary c on a.EID=c.EID
inner join pEMPAdminIDMD d on a.EID=d.EID
inner join pVW_pYear_ScoreResult_All e on e.Score_Status=99 and e.Score_Type1 in (10,30,11)
and a.EID=e.EID and e.pYear_ID=(select MAX(ID) from pYear_Process where ISNULL(Closed,0)=1)

-- 营业部经理(虚拟部门)(DepID:736)
-- 一级分支机构负责人(Score_Type1: 31)
UNION
select a.EID as EID,a.Badge as Badge,a.Name as Name,b.DepID as SupDepID,a.DepID as DepID,a.JobID as JobID,
b.Director as Director,a.HighLevel as Education,a.HighDegree as Degree,
ROUND(DATEDIFF(mm, a.JoinDate, GETDATE()) / 12.00 + ISNULL(a.Cyear_adjust, 0), 2) as ServingAge,
ROUND(ISNULL(a.workyear_adjust, 0) + ROUND(DATEDIFF(mm, a.WorkBeginDate, GETDATE()) / 12.00, 2), 2) as Seniority,
(select Date from pYear_Process where ID=e.pYear_ID) as pYear,e.ScoreYear as ScoreYear,e.Ranking as Ranking,e.RankLevel as RankLevel,
d.MDID as MDID,c.SalaryPerMM as SalaryPerMM
from eVW_employee a
left join pVW_pYearMDSalaryModifyDep b on b.DepID=736
inner join pEMPSalary c on a.EID=c.EID
inner join pEMPAdminIDMD d on a.EID=d.EID
inner join pVW_pYear_ScoreResult_All e on e.Score_Status=99 and e.Score_Type1=31
and a.EID=e.EID and e.pYear_ID=(select MAX(ID) from pYear_Process where ISNULL(Closed,0)=1)

-- 合规专员(虚拟部门)(DepID:732)
-- 分支机构合规风控专员(Score_Type1: 14)
UNION
select a.EID as EID,a.Badge as Badge,a.Name as Name,b.DepID as SupDepID,a.DepID as DepID,a.JobID as JobID,
b.Director as Director,a.HighLevel as Education,a.HighDegree as Degree,
ROUND(DATEDIFF(mm, a.JoinDate, GETDATE()) / 12.00 + ISNULL(a.Cyear_adjust, 0), 2) as ServingAge,
ROUND(ISNULL(a.workyear_adjust, 0) + ROUND(DATEDIFF(mm, a.WorkBeginDate, GETDATE()) / 12.00, 2), 2) as Seniority,
(select Date from pYear_Process where ID=e.pYear_ID) as pYear,e.ScoreYear as ScoreYear,e.Ranking as Ranking,e.RankLevel as RankLevel,
d.MDID as MDID,c.SalaryPerMM as SalaryPerMM
from eVW_employee a
left join pVW_pYearMDSalaryModifyDep b on b.DepID=732
inner join pEMPSalary c on a.EID=c.EID
inner join pEMPAdminIDMD d on a.EID=d.EID
inner join pVW_pYear_ScoreResult_All e on e.Score_Status=99 and e.Score_Type1=14 
and a.EID=e.EID and e.pYear_ID=(select MAX(ID) from pYear_Process where ISNULL(Closed,0)=1)

-- 区域财务(虚拟部门)(DepID:733)
-- 分支机构区域财务经理(Score_Type1: 17)
UNION
select a.EID as EID,a.Badge as Badge,a.Name as Name,b.DepID as SupDepID,a.DepID as DepID,a.JobID as JobID,
b.Director as Director,a.HighLevel as Education,a.HighDegree as Degree,
ROUND(DATEDIFF(mm, a.JoinDate, GETDATE()) / 12.00 + ISNULL(a.Cyear_adjust, 0), 2) as ServingAge,
ROUND(ISNULL(a.workyear_adjust, 0) + ROUND(DATEDIFF(mm, a.WorkBeginDate, GETDATE()) / 12.00, 2), 2) as Seniority,
(select Date from pYear_Process where ID=e.pYear_ID) as pYear,e.ScoreYear as ScoreYear,e.Ranking as Ranking,e.RankLevel as RankLevel,
d.MDID as MDID,c.SalaryPerMM as SalaryPerMM
from eVW_employee a
left join pVW_pYearMDSalaryModifyDep b on b.DepID=733
inner join pEMPSalary c on a.EID=c.EID
inner join pEMPAdminIDMD d on a.EID=d.EID
inner join pVW_pYear_ScoreResult_All e on e.Score_Status=99 and e.Score_Type1=17 
and a.EID=e.EID and e.pYear_ID=(select MAX(ID) from pYear_Process where ISNULL(Closed,0)=1)

Go