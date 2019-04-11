-- pVW_pYearMDSalaryModifyEMP

-- 非虚拟部门员工
---- 总部
------ 非财富、投资银行
select a.EID as EID,a.Badge as Badge,a.Name as Name,b.DepID as SupDepID,b.DepID as DepID,a.JobID as JobID,
b.Director as Director,c.HighLevel as Education,c.HighDegree as Degree,
ROUND(DATEDIFF(mm, d.JoinDate, GETDATE()) / 12.00 + ISNULL(d.Cyear_adjust, 0), 2) as ServingAge,
ROUND(ISNULL(c.workyear_adjust, 0) + ROUND(DATEDIFF(mm, c.WorkBeginDate, GETDATE()) / 12.00, 2), 2) as Seniority,
(select Date from pYear_Process where ID=f.pYear_ID) as pYear,f.ScoreYear as ScoreYear,f.Ranking as Ranking,f.RankLevel as RankLevel,
e.MDID as MDID,e.SalaryPerMM as SalaryPerMM
from eEmployee a,pVW_pYearMDSalaryModifyDep b,eDetails c,eStatus d,pEmployeeEmolu e,pYear_Score_all f
where a.Status not in (4,5) and dbo.eFN_getdepid1st(a.DepID)=b.DepID and dbo.eFN_getdeptype(a.DepID)=1
and a.EID=c.EID and a.EID=d.EID and a.EID=e.EID 
and a.EID=f.EID and f.Score_Status=9
and f.Score_Type1 not in (14,17,24,5)
------ 财富
UNION
select a.EID as EID,a.Badge as Badge,a.Name as Name,b.DepID as SupDepID,dbo.eFN_getdepid1st(a.DepID) as DepID,a.JobID as JobID,
b.Director as Director,c.HighLevel as Education,c.HighDegree as Degree,
ROUND(DATEDIFF(mm, d.JoinDate, GETDATE()) / 12.00 + ISNULL(d.Cyear_adjust, 0), 2) as ServingAge,
ROUND(ISNULL(c.workyear_adjust, 0) + ROUND(DATEDIFF(mm, c.WorkBeginDate, GETDATE()) / 12.00, 2), 2) as Seniority,
(select Date from pYear_Process where ID=f.pYear_ID) as pYear,f.ScoreYear as ScoreYear,f.Ranking as Ranking,f.RankLevel as RankLevel,
e.MDID as MDID,e.SalaryPerMM as SalaryPerMM
from eEmployee a,pVW_pYearMDSalaryModifyDep b,eDetails c,eStatus d,pEmployeeEmolu e,pYear_Score_all f
where a.Status not in (4,5) and dbo.eFN_getdepadmin(dbo.eFN_getdepid1st(a.DepID))=b.DepID and b.DepID=715
and a.EID=c.EID and a.EID=d.EID and a.EID=e.EID 
and a.EID=f.EID and f.Score_Status=9
and f.Score_Type1 not in (14,17,19,20,24,5)
------ 投资银行
UNION
select a.EID as EID,a.Badge as Badge,a.Name as Name,b.DepID as SupDepID,dbo.eFN_getdepid1st(a.DepID) as DepID,a.JobID as JobID,
b.Director as Director,c.HighLevel as Education,c.HighDegree as Degree,
ROUND(DATEDIFF(mm, d.JoinDate, GETDATE()) / 12.00 + ISNULL(d.Cyear_adjust, 0), 2) as ServingAge,
ROUND(ISNULL(c.workyear_adjust, 0) + ROUND(DATEDIFF(mm, c.WorkBeginDate, GETDATE()) / 12.00, 2), 2) as Seniority,
(select Date from pYear_Process where ID=f.pYear_ID) as pYear,f.ScoreYear as ScoreYear,f.Ranking as Ranking,f.RankLevel as RankLevel,
e.MDID as MDID,e.SalaryPerMM as SalaryPerMM
from eEmployee a,pVW_pYearMDSalaryModifyDep b,eDetails c,eStatus d,pEmployeeEmolu e,pYear_Score_all f
where a.Status not in (4,5) and dbo.eFN_getdepadmin(dbo.eFN_getdepid1st(a.DepID))=b.DepID and b.DepID=695
and a.EID=c.EID and a.EID=d.EID and a.EID=e.EID 
and a.EID=f.EID and f.Score_Status=9
and f.Score_Type1 not in (14,17,19,20,24,5)
---- 分支机构
UNION
select a.EID as EID,a.Badge as Badge,a.Name as Name,b.DepID as SupDepID,a.DepID as DepID,a.JobID as JobID,
b.Director as Director,c.HighLevel as Education,c.HighDegree as Degree,
ROUND(DATEDIFF(mm, d.JoinDate, GETDATE()) / 12.00 + ISNULL(d.Cyear_adjust, 0), 2) as ServingAge,
ROUND(ISNULL(c.workyear_adjust, 0) + ROUND(DATEDIFF(mm, c.WorkBeginDate, GETDATE()) / 12.00, 2), 2) as Seniority,
(select Date from pYear_Process where ID=f.pYear_ID) as pYear,f.ScoreYear as ScoreYear,f.Ranking as Ranking,f.RankLevel as RankLevel,
e.MDID as MDID,e.SalaryPerMM as SalaryPerMM
from eEmployee a,pVW_pYearMDSalaryModifyDep b,eDetails c,eStatus d,pEmployeeEmolu e,pYear_Score_all f
where a.Status not in (4,5) and dbo.eFN_getdepid1st(a.DepID)=b.DepID and dbo.eFN_getdeptype(a.DepID) in (2,3)
and a.EID=c.EID and a.EID=d.EID and a.EID=e.EID 
and a.EID=f.EID and f.Score_Status=9
and f.Score_Type1 not in (14,17,24,5)
---- 资管
UNION
select a.EID as EID,a.Badge as Badge,a.Name as Name,b.DepID as SupDepID,dbo.eFN_getdepid1st(a.DepID) as DepID,a.JobID as JobID,
b.Director as Director,c.HighLevel as Education,c.HighDegree as Degree,
ROUND(DATEDIFF(mm, d.JoinDate, GETDATE()) / 12.00 + ISNULL(d.Cyear_adjust, 0), 2) as ServingAge,
ROUND(ISNULL(c.workyear_adjust, 0) + ROUND(DATEDIFF(mm, c.WorkBeginDate, GETDATE()) / 12.00, 2), 2) as Seniority,
(select Date from pYear_Process where ID=f.pYear_ID) as pYear,f.ScoreYear as ScoreYear,f.Ranking as Ranking,f.RankLevel as RankLevel,
e.MDID as MDID,e.SalaryPerMM as SalaryPerMM
from eEmployee a,pVW_pYearMDSalaryModifyDep b,eDetails c,eStatus d,pEmployeeEmolu e,pYear_Score_all f
where a.Status not in (4,5) and dbo.eFN_getcompid(a.DepID)=13 and b.DepID=393
and a.EID=c.EID and a.EID=d.EID and a.EID=e.EID 
and a.EID=f.EID and f.Score_Status=9
and f.Score_Type1 not in (14,17,19,20,24,5)
---- 资本
UNION
select a.EID as EID,a.Badge as Badge,a.Name as Name,b.DepID as SupDepID,dbo.eFN_getdepid1st(a.DepID) as DepID,a.JobID as JobID,
b.Director as Director,c.HighLevel as Education,c.HighDegree as Degree,
ROUND(DATEDIFF(mm, d.JoinDate, GETDATE()) / 12.00 + ISNULL(d.Cyear_adjust, 0), 2) as ServingAge,
ROUND(ISNULL(c.workyear_adjust, 0) + ROUND(DATEDIFF(mm, c.WorkBeginDate, GETDATE()) / 12.00, 2), 2) as Seniority,
(select Date from pYear_Process where ID=f.pYear_ID) as pYear,f.ScoreYear as ScoreYear,f.Ranking as Ranking,f.RankLevel as RankLevel,
e.MDID as MDID,e.SalaryPerMM as SalaryPerMM
from eEmployee a,pVW_pYearMDSalaryModifyDep b,eDetails c,eStatus d,pEmployeeEmolu e,pYear_Score_all f
where a.Status not in (4,5) and dbo.eFN_getcompid(a.DepID)=12 and b.DepID=392
and a.EID=c.EID and a.EID=d.EID and a.EID=e.EID 
and a.EID=f.EID and f.Score_Status=9
and f.Score_Type1 not in (14,17,19,20,24,5)

-- 营业部经理(虚拟部门)(DepID:736)
-- 分公司负责人(Score_Type1: 24)、营业部负责人(Score_Type1: 5)
UNION
select a.EID as EID,a.Badge as Badge,a.Name as Name,b.DepID as SupDepID,a.DepID as DepID,a.JobID as JobID,
b.Director as Director,c.HighLevel as Education,c.HighDegree as Degree,
ROUND(DATEDIFF(mm, d.JoinDate, GETDATE()) / 12.00 + ISNULL(d.Cyear_adjust, 0), 2) as ServingAge,
ROUND(ISNULL(c.workyear_adjust, 0) + ROUND(DATEDIFF(mm, c.WorkBeginDate, GETDATE()) / 12.00, 2), 2) as Seniority,
(select Date from pYear_Process where ID=f.pYear_ID) as pYear,f.ScoreYear as ScoreYear,f.Ranking as Ranking,f.RankLevel as RankLevel,
e.MDID as MDID,e.SalaryPerMM as SalaryPerMM
from eEmployee a,pVW_pYearMDSalaryModifyDep b,eDetails c,eStatus d,pEmployeeEmolu e,pYear_Score_all f
where a.Status not in (4,5) and b.DepID=736
and a.EID=c.EID and a.EID=d.EID and a.EID=e.EID 
and a.EID=f.EID and f.Score_Status=9
and f.Score_Type1 in (24,5)

-- 合规专员(虚拟部门)(DepID:732)
-- 营业部合规风控专员(Score_Type1: 14)
UNION
select a.EID as EID,a.Badge as Badge,a.Name as Name,b.DepID as SupDepID,a.DepID as DepID,a.JobID as JobID,
b.Director as Director,c.HighLevel as Education,c.HighDegree as Degree,
ROUND(DATEDIFF(mm, d.JoinDate, GETDATE()) / 12.00 + ISNULL(d.Cyear_adjust, 0), 2) as ServingAge,
ROUND(ISNULL(c.workyear_adjust, 0) + ROUND(DATEDIFF(mm, c.WorkBeginDate, GETDATE()) / 12.00, 2), 2) as Seniority,
(select Date from pYear_Process where ID=f.pYear_ID) as pYear,f.ScoreYear as ScoreYear,f.Ranking as Ranking,f.RankLevel as RankLevel,
e.MDID as MDID,e.SalaryPerMM as SalaryPerMM
from eEmployee a,pVW_pYearMDSalaryModifyDep b,eDetails c,eStatus d,pEmployeeEmolu e,pYear_Score_all f
where a.Status not in (4,5) and b.DepID=732
and a.EID=c.EID and a.EID=d.EID and a.EID=e.EID 
and a.EID=f.EID and f.Score_Status=9
and f.Score_Type1 in (14)

-- 区域财务(虚拟部门)(DepID:733)
-- 区域财务经理(Score_Type1: 17)
UNION                      
select a.EID as EID,a.Badge as Badge,a.Name as Name,b.DepID as SupDepID,a.DepID as DepID,a.JobID as JobID,
b.Director as Director,c.HighLevel as Education,c.HighDegree as Degree,
ROUND(DATEDIFF(mm, d.JoinDate, GETDATE()) / 12.00 + ISNULL(d.Cyear_adjust, 0), 2) as ServingAge,
ROUND(ISNULL(c.workyear_adjust, 0) + ROUND(DATEDIFF(mm, c.WorkBeginDate, GETDATE()) / 12.00, 2), 2) as Seniority,
(select Date from pYear_Process where ID=f.pYear_ID) as pYear,f.ScoreYear as ScoreYear,f.Ranking as Ranking,f.RankLevel as RankLevel,
e.MDID as MDID,e.SalaryPerMM as SalaryPerMM
from eEmployee a,pVW_pYearMDSalaryModifyDep b,eDetails c,eStatus d,pEmployeeEmolu e,pYear_Score_all f
where a.Status not in (4,5) and b.DepID=733
and a.EID=c.EID and a.EID=d.EID and a.EID=e.EID 
and a.EID=f.EID and f.Score_Status=9
and f.Score_Type1 in (17)