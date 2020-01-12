-- pVW_pYear_ScoreEachSumL_update

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pYear_ScoreEachSumL_update]
AS

-------- 总部部门负责人(Score_Type1：1)
-------- 履职情况胜任素质 测评总分计算 --------
select a.EID,
a.EachLType,SUM(a.ScoreTotal) as EachLSUM,COUNT(a.ScoreTotal) as EachLCOUNT,
AVG(a.ScoreTotal*b.Modulus*1.0/100) as EachLAVG,b.Modulus
from pYear_ScoreEachL a,pVW_pYear_ScoreEachL_update b
where a.Score_Type1=1 and ISNULL(a.Submit,0)=1
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.EachLType=b.EachLType
group by a.EID,a.EachLType,b.Modulus


-------- 总部部门副职(Score_Type1：2)
-------- 履职情况胜任素质 测评总分计算 --------
union
select a.EID,
a.EachLType,SUM(a.ScoreTotal) as EachLSUM,COUNT(a.ScoreTotal) as EachLCOUNT,
AVG(a.ScoreTotal*b.Modulus*1.0/100) as EachLAVG,b.Modulus
from pYear_ScoreEachL a,pVW_pYear_ScoreEachL_update b
where a.Score_Type1=2 and ISNULL(a.Submit,0)=1
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.EachLType=b.EachLType
group by a.EID,a.EachLType,b.Modulus


-------- 一级分支机构负责人(Score_Type1：31)
-------- 履职情况胜任素质 测评总分计算 --------
union
select a.EID,
a.EachLType,SUM(a.ScoreTotal) as EachLSUM,COUNT(a.ScoreTotal) as EachLCOUNT,
AVG(a.ScoreTotal*b.Modulus*1.0/100) as EachLAVG,b.Modulus
from pYear_ScoreEachL a,pVW_pYear_ScoreEachL_update b
where a.Score_Type1=31 and ISNULL(a.Submit,0)=1
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.EachLType=b.EachLType
group by a.EID,a.EachLType,b.Modulus


-------- 一级分支机构副职及二级分支机构经理室(Score_Type1：32)
union
select a.EID,
a.EachLType,SUM(a.ScoreTotal) as EachLSUM,COUNT(a.ScoreTotal) as EachLCOUNT,
AVG(a.ScoreTotal*b.Modulus*1.0/100) as EachLAVG,b.Modulus
from pYear_ScoreEachL a,pVW_pYear_ScoreEachL_update b
where a.Score_Type1=32 and ISNULL(a.Submit,0)=1
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.EachLType=b.EachLType
group by a.EID,a.EachLType,b.Modulus


-------- 子公司部门负责人胜任素质 (Score_Type1：10) --------
union
select a.EID,
a.EachLType,SUM(a.ScoreTotal) as EachLSUM,COUNT(a.ScoreTotal) as EachLCOUNT,
AVG(a.ScoreTotal*b.Modulus*1.0/100) as EachLAVG,b.Modulus
from pYear_ScoreEachL a,pVW_pYear_ScoreEachL_update b
where a.Score_Type1=10 and ISNULL(a.Submit,0)=1
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.EachLType=b.EachLType
group by a.EID,a.EachLType,b.Modulus


-------- 子公司部门副职胜任素质 (Score_Type1：30) --------
union
select a.EID,
a.EachLType,SUM(a.ScoreTotal) as EachLSUM,COUNT(a.ScoreTotal) as EachLCOUNT,
AVG(a.ScoreTotal*b.Modulus*1.0/100) as EachLAVG,b.Modulus
from pYear_ScoreEachL a,pVW_pYear_ScoreEachL_update b
where a.Score_Type1=30 and ISNULL(a.Submit,0)=1
and a.EID=b.EID and a.Score_Type1=b.Score_Type1 and a.EachLType=b.EachLType
group by a.EID,a.EachLType,b.Modulus

GO