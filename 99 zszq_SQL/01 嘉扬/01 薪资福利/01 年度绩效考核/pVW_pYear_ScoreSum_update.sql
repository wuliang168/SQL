-- pVW_pYear_ScoreSum_update

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pYear_ScoreSum_update]
AS
/*
将所有考核类型的结果统一计算，替换原有问题的各个计算视图
所有类型考核阶段均会有一个得分，将该得分合计计算，就是最终考核得分
*/

--------- 总部部门负责人 --------
-- 1-总部部门负责人
-- Score_Status=0              自评
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
NULL as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=1 and a.Score_Status=0
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- Score_Status=1              履职胜任考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(select SUM(EachLAVG) from pVW_pYear_ScoreEachSumL_update where EID=a.EID)*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=1 and a.Score_Status=1
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- Score_Status=2              战略企划部考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(select ScoreTotal from pVW_pFDAppraiseResultSum where DepID=a.Score_DepID and ScoreTotal is not NULL)*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=1 and a.Score_Status=4
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
--------- 总部部门副职 --------
-- Score_Status=1              履职胜任考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(select SUM(EachLAVG) from pVW_pYear_ScoreEachSumL_update where EID=a.EID)*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=2 and a.Score_Status=1 and a.Score_DepID<>737
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- 2-总部部门副职
-- Score_Status=4               战略企划部考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(select ScoreTotal from pVW_pFDAppraiseResultSum where DepID=a.Score_DepID and ScoreTotal is not NULL)*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=2 and a.Score_Status=4
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- 2-总部部门副职
-- Score_Status=99               合规总监考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)+ISNULL(a.Score2,0)*ISNULL(b.Weight2,100)+ISNULL(a.Score3,0)*ISNULL(b.Weight3,100))/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=2 and a.Score_Status=99
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
and a.Score_DepID=737
--------- 总部普通员工 --------
-- 4-总部普通员工
-- Score_Status=1              互评考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(select SUM(EachNAVG) from pVW_pYear_ScoreEachSumN_update where EID=a.EID)*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=4 and a.Score_Status=1
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- Score_Status=99             总部部门负责人考核
union
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)+ISNULL(a.Score2,0)+ISNULL(a.Score3,0)+a.Score4+a.Score5+a.Score6+a.Score7)*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=4 and a.Score_Status=99 and a.Score_DepID<>737
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- 4-总部合规部门普通员工
-- Score_Status=99             合规总监考核
union
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)+ISNULL(a.Score2,0)*ISNULL(b.Weight2,100)+ISNULL(a.Score3,0)*ISNULL(b.Weight3,100))/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=4 and a.Score_Status=99 and a.Score_DepID=737
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
------ 一级分支机构负责人 ------
-- 31-一级分支机构负责人
-- Score_Status=1               履职胜任考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(select SUM(EachLAVG) from pVW_pYear_ScoreEachSumL_update where EID=a.EID)*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=31 and a.Score_Status=1
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- Score_Status=2               网点运营管理总部考核(经营业绩指标)
union
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)+ISNULL(a.Score2,0)*ISNULL(b.Weight2,100)+ISNULL(a.Score3,0)*ISNULL(b.Weight3,100))/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=31 and a.Score_Status=4
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- Score_Status=3               法律合规部考核(合规管理有效性)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)+ISNULL(a.Score2,0)*ISNULL(b.Weight2,100)+ISNULL(a.Score3,0)*ISNULL(b.Weight3,100))/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=31 and a.Score_Status=3
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
------ 一级分支机构副职及二级分支机构经理室成员 ------
-- 32-一级分支机构副职及二级分支机构经理室成员
-- Score_Status=1              履职胜任考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(select SUM(EachLAVG) from pVW_pYear_ScoreEachSumL_update where EID=a.EID)*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=32 and a.Score_Status=1
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- Score_Status=2               网点运营管理总部考核(经营业绩指标)
union
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)+ISNULL(a.Score2,0)*ISNULL(b.Weight2,100)+ISNULL(a.Score3,0)*ISNULL(b.Weight3,100))/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=32 and a.Score_Status=4
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- Score_Status=3               法律合规部考核(合规管理有效性)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)+ISNULL(a.Score2,0)*ISNULL(b.Weight2,100)+ISNULL(a.Score3,0)*ISNULL(b.Weight3,100))/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=32 and a.Score_Status=3
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
--------- 分支机构普通员工 --------
-- 33-分支机构普通员工
-- Score_Status=1              互评考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(select SUM(EachNAVG) from pVW_pYear_ScoreEachSumN_update where EID=a.EID)*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=33 and a.Score_Status=1
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- Score_Status=2               二级分支机构负责人考核(工作业绩、工作态度、工作能力和合规风控性)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)+ISNULL(a.Score2,0)+ISNULL(a.Score3,0)+a.Score4+a.Score5+a.Score6+a.Score7)*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=33 and a.Score_Status=2
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- Score_Status=99               一级分支机构负责人考核(工作业绩、工作态度、工作能力和合规风控性)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)+ISNULL(a.Score2,0)+ISNULL(a.Score3,0)+a.Score4+a.Score5+a.Score6+a.Score7)*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=33 and a.Score_Status=99
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
--------- 分支机构区域财务经理 --------
-- 17-分支机构区域财务经理
-- Score_Status=2               分支机构负责人考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,NULL,
AVG((ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)+ISNULL(a.Score2,0)*ISNULL(b.Weight2,100)+ISNULL(a.Score3,0)*ISNULL(b.Weight3,100))/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100) as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=17 and a.Score_Status=2
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
group by a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status
-- Score_Status=3               计划财务部负责人考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)+ISNULL(a.Score2,0)*ISNULL(b.Weight2,100)+ISNULL(a.Score3,0)*ISNULL(b.Weight3,100))/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=17 and a.Score_Status=3
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- Score_Status=99               财务总监考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)+ISNULL(a.Score2,0)*ISNULL(b.Weight2,100)+ISNULL(a.Score3,0)*ISNULL(b.Weight3,100))/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=17 and a.Score_Status=99
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
--------- 综合会计 --------
-- 19-综合会计
-- Score_Status=2               分支机构负责人考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,NULL,
AVG((ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)+ISNULL(a.Score2,0)*ISNULL(b.Weight2,100)+ISNULL(a.Score3,0)*ISNULL(b.Weight3,100))/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100) as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=19 and a.Score_Status=2
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
group by a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status
-- Score_Status=3               区域财务经理考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)+ISNULL(a.Score2,0)*ISNULL(b.Weight2,100)+ISNULL(a.Score3,0)*ISNULL(b.Weight3,100))/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=19 and a.Score_Status=3
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- Score_Status=99               计划财务部经理考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)+ISNULL(a.Score2,0)*ISNULL(b.Weight2,100)+ISNULL(a.Score3,0)*ISNULL(b.Weight3,100))/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=19 and a.Score_Status=99
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
--------- 分支机构合规专员 --------
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)+ISNULL(a.Score2,0)*ISNULL(b.Weight2,100)+ISNULL(a.Score3,0)*ISNULL(b.Weight3,100))/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=14 and a.Score_Status=99
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
--------- 兼职合规管理 --------
-- 35-兼职合规管理
-- Score_Status=7               法律合规部负责人考核(兼合规管理)
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type2=35 and a.Score_Status=7
and a.EID=b.EID and a.Score_Type2=b.Score_Type2 and a.Score_Status=b.Score_Status
--------- 子公司部门负责人 --------
-- 10-子公司部门负责人
-- Score_Status=1              履职胜任考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(select SUM(EachLAVG) from pVW_pYear_ScoreEachSumL_update where EID=a.EID)*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=10 and a.Score_Status=1
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- Score_Status=2              子公司总经理助理考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)+ISNULL(a.Score2,0)*ISNULL(b.Weight2,100)+ISNULL(a.Score3,0)*ISNULL(b.Weight3,100))/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=10 and a.Score_Status=2
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- Score_Status=3              子公司常务副总经理考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)+ISNULL(a.Score2,0)*ISNULL(b.Weight2,100)+ISNULL(a.Score3,0)*ISNULL(b.Weight3,100))/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=10 and a.Score_Status=3
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- Score_Status=99              子公司总经理考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)+ISNULL(a.Score2,0)*ISNULL(b.Weight2,100)+ISNULL(a.Score3,0)*ISNULL(b.Weight3,100))/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=10 and a.Score_Status=99 and a.Score_DepID<>666
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- Score_Status=99              合规总监考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)+ISNULL(a.Score2,0)*ISNULL(b.Weight2,100)+ISNULL(a.Score3,0)*ISNULL(b.Weight3,100))/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=10 and a.Score_Status=99 and a.Score_DepID=666
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
--------- 子公司部门副职 --------
-- 30-子公司部门副职
-- Score_Status=1              履职胜任考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(select SUM(EachLAVG) from pVW_pYear_ScoreEachSumL_update where EID=a.EID)*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=30 and a.Score_Status=1
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- Score_Status=2               子公司部门负责人考核(部门年度工作计划和履职情况)
union
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)+ISNULL(a.Score2,0)*ISNULL(b.Weight2,100)+ISNULL(a.Score3,0)*ISNULL(b.Weight3,100))/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=30 and a.Score_Status=2
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- Score_Status=99               子公司分管领导考核(部门年度工作计划和履职情况)
union
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)+ISNULL(a.Score2,0)*ISNULL(b.Weight2,100)+ISNULL(a.Score3,0)*ISNULL(b.Weight3,100))/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=30 and a.Score_Status=99 and a.Score_DepID<>666
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- Score_Status=99               子公司分管领导考核(部门年度工作计划和履职情况)
union
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)+ISNULL(a.Score2,0)*ISNULL(b.Weight2,100)+ISNULL(a.Score3,0)*ISNULL(b.Weight3,100))/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=30 and a.Score_Status=99 and a.Score_DepID=666
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
--------- 子公司普通员工 --------
-- 11-子公司普通员工
-- Score_Status=1              互评考核
UNION
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(select SUM(EachNAVG) from pVW_pYear_ScoreEachSumN_update where EID=a.EID)*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=11 and a.Score_Status=1
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- Score_Status=99             子公司部门负责人考核
union
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)+ISNULL(a.Score2,0)+ISNULL(a.Score3,0)+a.Score4+a.Score5+a.Score6+a.Score7)*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=11 and a.Score_Status=99 and a.Score_DepID not in (542,666)
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status
-- 11-子公司合规风控部门普通员工
-- Score_Status=99             子公司合规总监考核
union
select a.EID,a.Score_DepID,a.Score_Type1,a.Score_Type2,a.Score_Status,a.Score_EID,
(ISNULL(a.Score1,0)*ISNULL(b.Weight1,100)+ISNULL(a.Score2,0)*ISNULL(b.Weight2,100)+ISNULL(a.Score3,0)*ISNULL(b.Weight3,100))/100*ISNULL(b.Modulus,100)/100*ISNULL(b.ComplModulus,100)/100 as ScoreTotal
from pYear_Score a,pVW_pYear_ScoreType_update b
WHERE a.Score_Type1=11 and a.Score_Status=99 and a.Score_DepID in (542,666)
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.Score_Status=b.Score_Status

Go