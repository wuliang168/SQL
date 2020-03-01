-- pVW_pYear_ScoreEachSumL

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pYear_ScoreEachSumL]
AS

-------- 总部部门负责人(Score_Type1：1)
-------- 履职情况胜任素质 测评总分计算 --------
-- EachLType=110,           -- 总部部门负责人 主要领导测评
-- EachLType=120,           -- 总部部门负责人 分管领导测评
-- EachLType=125,           -- 总部部门负责人 360度评价 其他领导测评
-- EachLType=130,           -- 总部部门负责人 360度评价 一级部门负责人互评
-- EachLType=140,           -- 总部部门负责人 360度评价 部门员工评测
--
select a.EID,
a.EachLType,SUM(a.ScoreTotal) as EachLSUM,COUNT(a.ScoreTotal) as EachLCOUNT,
AVG(a.ScoreTotal*a.Modulus*1.0/100) as EachLAVG,a.Modulus,
b.Weight1 as EachLWeight
from pYear_ScoreEachL a,pYear_Score b
where a.Score_Type1=1 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,a.EachLType,a.Modulus,b.Weight1


-------- 总部部门副职(Score_Type1：2)
-------- 履职情况胜任素质 测评总分计算 --------
-- EachLType=205,           -- 总部部门副职 主要领导测评
-- EachLType=210,           -- 总部部门副职 分管领导测评
-- EachLType=220,           -- 总部部门副职 部门负责人测评
-- EachLType=240,           -- 总部部门副职 360度评价 部门员工测评
--
union
select a.EID,
a.EachLType,SUM(a.ScoreTotal) as EachLSUM,COUNT(a.ScoreTotal) as EachLCOUNT,
AVG(a.ScoreTotal*a.Modulus*1.0/100) as EachLAVG,a.Modulus,
b.Weight1 as EachLWeight
from pYear_ScoreEachL a,pYear_Score b
where a.Score_Type1=2 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,a.EachLType,a.Modulus,b.Weight1


-------- 总部部门助理(Score_Type1：36)
-------- 履职情况胜任素质 测评总分计算 --------
-- EachLType=215,           -- 总部部门助理 分管领导测评
-- EachLType=225,           -- 总部部门助理 部门负责人测评
-- EachLType=245,           -- 总部部门助理 360度评价 部门员工测评
--
union
select a.EID,
a.EachLType,SUM(a.ScoreTotal) as EachLSUM,COUNT(a.ScoreTotal) as EachLCOUNT,
AVG(a.ScoreTotal*a.Modulus*1.0/100) as EachLAVG,a.Modulus,
b.Weight1 as EachLWeight
from pYear_ScoreEachL a,pYear_Score b
where a.Score_Type1=2 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,a.EachLType,a.Modulus,b.Weight1


-------- 一级分支机构负责人(Score_Type1：31)
-------- 履职情况胜任素质 测评总分计算 --------
-- EachLType=310,         -- 一级分支机构负责人 主要领导测评
-- EachLType=320,         -- 一级分支机构负责人 分管领导评测
-- EachLType=330,         -- 一级分支机构负责人 360度评价 一级分支机构负责人互评
-- EachLType=340,         -- 一级分支机构负责人 360度评价 一级分支机构下属员工评测
--
union
select a.EID,
a.EachLType,SUM(a.ScoreTotal) as EachLSUM,COUNT(a.ScoreTotal) as EachLCOUNT,
AVG(a.ScoreTotal*a.Modulus*1.0/100) as EachLAVG,a.Modulus,
b.Weight1 as EachLWeight
from pYear_ScoreEachL a,pYear_Score b
where a.Score_Type1=31 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,a.EachLType,a.Modulus,b.Weight1


-------- 一级分支机构副职及二级分支机构经理室(Score_Type1：32)
-------- 履职情况胜任素质 测评总分计算 --------
-- EachLType=410,         -- 一级分支机构副职及二级分支机构经理室 分管领导评测
-- EachLType=420,         -- 一级分支机构副职及二级分支机构经理室 一级分支机构负责人评测
-- EachLType=440,         -- 一级分支机构副职及二级分支机构经理室 360度评价 部门人员评测
--
union
select a.EID,
a.EachLType,SUM(a.ScoreTotal) as EachLSUM,COUNT(a.ScoreTotal) as EachLCOUNT,
AVG(a.ScoreTotal*a.Modulus*1.0/100) as EachLAVG,a.Modulus,
b.Weight1 as EachLWeight
from pYear_ScoreEachL a,pYear_Score b
where a.Score_Type1=32 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,a.EachLType,a.Modulus,b.Weight1


-------- 子公司部门负责人胜任素质 (Score_Type1：10) --------
-- EachLType=610,         -- 子公司部门负责人 子公司总经理测评
-- EachLType=620,         -- 子公司部门负责人 子公司分管领导测评
-- EachLType=630,         -- 子公司部门负责人 子公司部门负责人互评
-- EachLType=640,         -- 子公司部门负责人 子公司部门员工评测
--
union
select a.EID,
a.EachLType,SUM(a.ScoreTotal) as EachLSUM,COUNT(a.ScoreTotal) as EachLCOUNT,
AVG(a.ScoreTotal*a.Modulus*1.0/100) as EachLAVG,a.Modulus,
b.Weight1 as EachLWeight
from pYear_ScoreEachL a,pYear_Score b
where a.Score_Type1=10 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,a.EachLType,a.Modulus,b.Weight1


-------- 子公司部门副职胜任素质 (Score_Type1：30) --------
-- EachLType=710,         -- 子公司部门负责人 子公司分管领导测评
-- EachLType=720,         -- 子公司部门负责人 子公司部门负责人测评
-- EachLType=730,         -- 子公司部门负责人 子公司部门员工测评
--
union
select a.EID,
a.EachLType,SUM(a.ScoreTotal) as EachLSUM,COUNT(a.ScoreTotal) as EachLCOUNT,
AVG(a.ScoreTotal*a.Modulus*1.0/100) as EachLAVG,a.Modulus,
b.Weight1 as EachLWeight
from pYear_ScoreEachL a,pYear_Score b
where a.Score_Type1=30 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,a.EachLType,a.Modulus,b.Weight1

GO