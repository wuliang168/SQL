-- pVW_pYear_ScoreSum

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pYear_ScoreSum]
AS

--------- 总部部门负责人 --------
-- 1-总部部门负责人
-- Score_Status=2              战略企划部考核(部门年度工作计划)
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1 as ScoreTotal,NULL as ScoreEach,NULL as ScoreCompl,
a.Score1*ISNULL(a.Weight1,100)/100*ISNULL(a.Modulus,100)/100 as ScoreSTG1,NULL as ScoreSTG2,NULL as ScoreSTG3,
NULL as ScoreYear
from pYear_Score a
WHERE a.Score_Type1=1 and a.Score_Status=2
UNION
-- Score_Status=99              最终年度考核
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
NULL as ScoreTotal,NULL as ScoreEach,a.ScoreCompl as ScoreCompl,
a.ScoreSTG1 as ScoreSTG1,a.ScoreSTG2 as ScoreSTG2,a.ScoreSTG3 as ScoreSTG3,
((a.Score1*a.Weight1/100+a.Score2*a.Weight2/100)*ISNULL(a.Modulus,100)/100
+ISNULL(a.ScoreEach,0)+ISNULL(a.ScoreSTG1,0)+ISNULL(a.ScoreSTG2,0)+ISNULL(a.ScoreSTG3,0))
*(1-ISNULL(a.ScoreCompl/a.ScoreCompl*(select Modulus*1.00/100 from pYear_Score where EID=a.EID and Score_Status=7),0))+ISNULL(a.ScoreCompl,0) as ScoreYear
from pYear_Score a
WHERE a.Score_Type1=1 and a.Score_Status=99
--------- 总部部门副职 --------
-- 2-总部部门副职
-- Score_Status=2               总部部门负责人考核(部门年度工作计划)
union
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1 as ScoreTotal,NULL as ScoreEach,NULL as ScoreCompl,
a.Score1*ISNULL(a.Weight1,100)/100*ISNULL(a.Modulus,100)/100 as ScoreSTG1,NULL as ScoreSTG2,NULL as ScoreSTG3,
NULL as ScoreYear
from pYear_Score a
WHERE a.Score_Type1=2 and a.Score_Status=2
-- Score_Status=99               分管领导考核(部门年度工作计划)
union
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1 as ScoreTotal,NULL as ScoreEach,a.ScoreCompl as ScoreCompl,
a.ScoreSTG1 as ScoreSTG1,a.ScoreSTG2 as ScoreSTG2,a.ScoreSTG3 as ScoreSTG3,
((a.Score1*a.Weight1/100+a.Score2*a.Weight2/100)*ISNULL(a.Modulus,100)/100
+ISNULL(a.ScoreEach,0)+ISNULL(a.ScoreSTG1,0)+ISNULL(a.ScoreSTG2,0)+ISNULL(a.ScoreSTG3,0))
*(1-ISNULL(a.ScoreCompl/a.ScoreCompl*(select Modulus*1.00/100 from pYear_Score where EID=a.EID and Score_Status=7),0))+ISNULL(a.ScoreCompl,0) as ScoreYear
from pYear_Score a
WHERE a.Score_Type1=2 and a.Score_Status=99
--------- 总部部门助理 --------
-- 36-总部部门助理
-- Score_Status=2              总部部门负责人考核(部门年度工作计划)
union
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1 as ScoreTotal,NULL as ScoreEach,NULL as ScoreCompl,
a.Score1*ISNULL(a.Weight1,100)/100*ISNULL(a.Modulus,100)/100 as ScoreSTG1,NULL as ScoreSTG2,NULL as ScoreSTG3,
NULL as ScoreYear
from pYear_Score a
WHERE a.Score_Type1=36 and a.Score_Status=2
-- Score_Status=99               分管领导考核(部门年度工作计划)
union
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1 as ScoreTotal,NULL as ScoreEach,a.ScoreCompl as ScoreCompl,
a.ScoreSTG1 as ScoreSTG1,a.ScoreSTG2 as ScoreSTG2,a.ScoreSTG3 as ScoreSTG3,
((a.Score1*a.Weight1/100+a.Score2*a.Weight2/100)*ISNULL(a.Modulus,100)/100
+ISNULL(a.ScoreEach,0)+ISNULL(a.ScoreSTG1,0)+ISNULL(a.ScoreSTG2,0)+ISNULL(a.ScoreSTG3,0))
*(1-ISNULL(a.ScoreCompl/a.ScoreCompl*(select Modulus*1.00/100 from pYear_Score where EID=a.EID and Score_Status=7),0))+ISNULL(a.ScoreCompl,0) as ScoreYear
from pYear_Score a
WHERE a.Score_Type1=36 and a.Score_Status=99
--------- 总部部普通员工 --------
-- 4-总部部普通员工
-- Score_Status=99             总部部门负责人考核
union
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1+a.Score2+a.Score3+a.Score4+a.Score5+a.Score6+a.Score7 as ScoreTotal,NULL as ScoreEach,a.ScoreCompl as ScoreCompl,
a.ScoreSTG1 as ScoreSTG1,a.ScoreSTG2 as ScoreSTG2,a.ScoreSTG3 as ScoreSTG3,
((a.Score1+a.Score2+a.Score3+a.Score4+a.Score5+a.Score6+a.Score7)*ISNULL(a.Weight1,100)/100*ISNULL(a.Modulus,100)/100
+ISNULL(a.ScoreEach,0)+ISNULL(a.ScoreSTG1,0)+ISNULL(a.ScoreSTG2,0)+ISNULL(a.ScoreSTG3,0))
*(1-ISNULL(a.ScoreCompl/a.ScoreCompl*(select Modulus*1.00/100 from pYear_Score where EID=a.EID and Score_Status=7),0))+ISNULL(a.ScoreCompl,0) as ScoreYear
from pYear_Score a
WHERE a.Score_Type1=4 and a.Score_Status=99
------ 一级分支机构负责人 ------
-- 31-一级分支机构负责人
-- Score_Status=2               网点运营管理总部考核(经营业绩指标)
union
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1 as ScoreTotal,NULL as ScoreEach,NULL as ScoreCompl,
a.Score1*ISNULL(a.Weight1,100)/100*ISNULL(a.Modulus,100)/100 as ScoreSTG1,NULL as ScoreSTG2,NULL as ScoreSTG3,
NULL as ScoreYear
from pYear_Score a
WHERE a.Score_Type1=31 and a.Score_Status=2
-- Score_Status=3               法律合规部考核(合规管理有效性)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1 as ScoreTotal,NULL as ScoreEach,NULL as ScoreCompl,
NULL as ScoreSTG1,a.Score1*ISNULL(a.Weight1,100)/100*ISNULL(a.Modulus,100)/100 as ScoreSTG2,NULL as ScoreSTG3,
NULL as ScoreYear
from pYear_Score a
WHERE a.Score_Type1=31 and a.Score_Status=3
-- Score_Status=99               最终年度考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
NULL as ScoreTotal,NULL as ScoreEach,a.ScoreCompl as ScoreCompl,
a.ScoreSTG1 as ScoreSTG1,a.ScoreSTG2 as ScoreSTG2,a.ScoreSTG3 as ScoreSTG3,
((a.Score1*a.Weight1/100+a.Score2*a.Weight2/100)*ISNULL(a.Modulus,100)/100
+ISNULL(a.ScoreEach,0)+ISNULL(a.ScoreSTG1,0)+ISNULL(a.ScoreSTG2,0)+ISNULL(a.ScoreSTG3,0))
*(1-ISNULL(a.ScoreCompl/a.ScoreCompl*(select Modulus*1.00/100 from pYear_Score where EID=a.EID and Score_Status=7),0))+ISNULL(a.ScoreCompl,0) as ScoreYear
from pYear_Score a
WHERE a.Score_Type1=31 and a.Score_Status=99
------ 一级分支机构副职及二级分支机构经理室成员 ------
-- 32-一级分支机构副职及二级分支机构经理室成员
-- Score_Status=2               分公司负责人考核(工作任务目标50%、合规管理有效性10%)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1*ISNULL(a.Weight1,100)/100+a.Score2*ISNULL(a.Weight2,0)/100 as ScoreTotal,NULL as ScoreEach,NULL as ScoreCompl,
(a.Score1*ISNULL(a.Weight1,100)/100+a.Score2*ISNULL(a.Weight2,100)/100)*ISNULL(a.Modulus,100)/100 as ScoreSTG1,NULL as ScoreSTG2,NULL as ScoreSTG3,
NULL as ScoreYear
from pYear_Score a
WHERE a.Score_Type1=32 and a.Score_Status=2
-- Score_Status=99               分管领导考核(工作任务目标50%、合规管理有效性10%)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1*ISNULL(a.Weight1,100)/100+a.Score2*ISNULL(a.Weight2,0)/100 as ScoreTotal,NULL as ScoreEach,a.ScoreCompl as ScoreCompl,
a.ScoreSTG1 as ScoreSTG1,a.ScoreSTG2 as ScoreSTG2,a.ScoreSTG3 as ScoreSTG3,
((a.Score1*a.Weight1/100+a.Score2*a.Weight2/100)*ISNULL(a.Modulus,100)/100
+ISNULL(a.ScoreEach,0)+ISNULL(a.ScoreSTG1,0)+ISNULL(a.ScoreSTG2,0)+ISNULL(a.ScoreSTG3,0))
*(1-ISNULL(a.ScoreCompl/a.ScoreCompl*(select Modulus*1.00/100 from pYear_Score where EID=a.EID and Score_Status=7),0))+ISNULL(a.ScoreCompl,0) as ScoreYear
from pYear_Score a
WHERE a.Score_Type1=32 and a.Score_Status=99
--------- 分支机构普通员工 --------
-- 33-分支机构普通员工
-- Score_Status=2               二级分支机构负责人考核(工作业绩、工作态度、工作能力和合规风控性)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1+a.Score2+a.Score3+a.Score4+a.Score5+a.Score6+a.Score7 as ScoreTotal,NULL as ScoreEach,NULL as ScoreCompl,
(a.Score1+a.Score2+a.Score3)*ISNULL(a.Weight1,100)/100*ISNULL(a.Modulus,100)/100 as ScoreSTG1,NULL as ScoreSTG2,NULL as ScoreSTG3,
NULL as ScoreYear
from pYear_Score a
WHERE a.Score_Type1=33 and a.Score_Status=2
-- Score_Status=99               一级分支机构负责人考核(工作业绩、工作态度、工作能力和合规风控性)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1+a.Score2+a.Score3+a.Score4+a.Score5+a.Score6+a.Score7 as ScoreTotal,NULL as ScoreEach,a.ScoreCompl as ScoreCompl,
a.ScoreSTG1 as ScoreSTG1,a.ScoreSTG2 as ScoreSTG2,a.ScoreSTG3 as ScoreSTG3,
((a.Score1+a.Score2+a.Score3+a.Score4+a.Score5+a.Score6+a.Score7)*ISNULL(a.Weight1,100)/100*ISNULL(a.Modulus,100)/100
+ISNULL(a.ScoreEach,0)+ISNULL(a.ScoreSTG1,0)+ISNULL(a.ScoreSTG2,0)+ISNULL(a.ScoreSTG3,0))
*(1-ISNULL(a.ScoreCompl/a.ScoreCompl*(select Modulus*1.00/100 from pYear_Score where EID=a.EID and Score_Status=7),0))+ISNULL(a.ScoreCompl,0) as ScoreYear
from pYear_Score a
WHERE a.Score_Type1=33 and a.Score_Status=99
--------- 分支机构区域财务经理 --------
-- 17-分支机构区域财务经理
-- Score_Status=2               分支机构负责人考核(岗位工作完成情况60%和专业技术考核40%)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1*a.Weight1/100+a.Score2*a.Weight2/100 as ScoreTotal,NULL as ScoreEach,NULL as ScoreCompl,
(a.Score1*a.Weight1/100+a.Score2*a.Weight2/100)*ISNULL(a.Modulus,100)/100 as ScoreSTG1,NULL as ScoreSTG2,NULL as ScoreSTG3,
NULL as ScoreYear
from pYear_Score a
WHERE a.Score_Type1=17 and a.Score_Status=2
-- Score_Status=3               计划财务部负责人考核(岗位工作完成情况60%和专业技术考核40%)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1*a.Weight1/100+a.Score2*a.Weight2/100 as ScoreTotal,NULL as ScoreEach,NULL as ScoreCompl,
NULL as ScoreSTG1,(a.Score1*a.Weight1/100+a.Score2*a.Weight2/100)*ISNULL(a.Modulus,100)/100 as ScoreSTG2,NULL as ScoreSTG3,
NULL as ScoreYear
from pYear_Score a
WHERE a.Score_Type1=17 and a.Score_Status=3
-- Score_Status=99               财务总监考核(岗位工作完成情况60%和专业技术考核40%)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1*a.Weight1/100+a.Score2*a.Weight2/100 as ScoreTotal,NULL as ScoreEach,a.ScoreCompl as ScoreCompl,
a.ScoreSTG1 as ScoreSTG1,a.ScoreSTG2 as ScoreSTG2,a.ScoreSTG3 as ScoreSTG3,
((a.Score1*a.Weight1/100+a.Score2*a.Weight2/100)*ISNULL(a.Modulus,100)/100
+ISNULL(a.ScoreEach,0)+ISNULL(a.ScoreSTG1,0)+ISNULL(a.ScoreSTG2,0)+ISNULL(a.ScoreSTG3,0))
*(1-ISNULL(a.ScoreCompl/a.ScoreCompl*(select Modulus*1.00/100 from pYear_Score where EID=a.EID and Score_Status=7),0))+ISNULL(a.ScoreCompl,0) as ScoreYear
from pYear_Score a
WHERE a.Score_Type1=17 and a.Score_Status=99
--------- 综合会计 --------
-- 19-综合会计
-- Score_Status=2               分支机构负责人考核(岗位工作完成情况60%和专业技术考核40%)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1*a.Weight1/100+a.Score2*a.Weight2/100 as ScoreTotal,NULL as ScoreEach,NULL as ScoreCompl,
(a.Score1*a.Weight1/100+a.Score2*a.Weight2/100)*ISNULL(a.Modulus,100)/100 as ScoreSTG1,NULL as ScoreSTG2,NULL as ScoreSTG3,
NULL as ScoreYear
from pYear_Score a
WHERE a.Score_Type1=19 and a.Score_Status=2
-- Score_Status=3               区域财务经理考核(岗位工作完成情况60%和专业技术考核40%)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1*a.Weight1/100+a.Score2*a.Weight2/100 as ScoreTotal,NULL as ScoreEach,NULL as ScoreCompl,
NULL as ScoreSTG1,(a.Score1*ISNULL(a.Weight1,100)/100+a.Score2*ISNULL(a.Weight2,100)/100)*ISNULL(a.Modulus,100)/100 as ScoreSTG2,NULL as ScoreSTG3,
NULL as ScoreYear
from pYear_Score a
WHERE a.Score_Type1=19 and a.Score_Status=3
-- Score_Status=99               计划财务部经理考核(岗位工作完成情况60%和专业技术考核40%)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1*a.Weight1/100+a.Score2*a.Weight2/100 as ScoreTotal,NULL as ScoreEach,a.ScoreCompl as ScoreCompl,
a.ScoreSTG1 as ScoreSTG1,a.ScoreSTG2 as ScoreSTG2,a.ScoreSTG3 as ScoreSTG3,
((a.Score1*a.Weight1/100+a.Score2*a.Weight2/100)*ISNULL(a.Modulus,100)/100
+ISNULL(a.ScoreEach,0)+ISNULL(a.ScoreSTG1,0)+ISNULL(a.ScoreSTG2,0)+ISNULL(a.ScoreSTG3,0))
*(1-ISNULL(a.ScoreCompl/a.ScoreCompl*(select Modulus*1.00/100 from pYear_Score where EID=a.EID and Score_Status=7),0))+ISNULL(a.ScoreCompl,0) as ScoreYear
from pYear_Score a
WHERE a.Score_Type1=19 and a.Score_Status=99
--------- 兼职合规管理 --------
-- 35-兼职合规管理
-- Score_Status=7               法律合规部负责人考核(兼合规管理)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,
a.Score1 as ScoreTotal,NULL as ScoreEach,a.ScoreTotal*a.Weight1/100*ISNULL(a.Modulus,100)/100 as ScoreCompl,
NULL as ScoreSTG1,NULL as ScoreSTG2,NULL as ScoreSTG3,
NULL as ScoreYear
from pYear_Score a
WHERE a.Score_Type2=35 and a.Score_Status=7

Go