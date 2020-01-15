-- pVW_pYear_ScoreEachSumN_update

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pYear_ScoreEachSumN_update]
AS

-- 4-总部普通员工
select a.EID,
SUM(a.ScoreTotal) AS EachNSUM,COUNT(a.ScoreTotal) as EachNCOUNTReal,
(select COUNT(Score_EID) from pYear_ScoreEachN where EID=a.EID) as EachNCOUNTExpt,
AVG(a.ScoreTotal) AS EachNAVG
from pYear_ScoreEachN a
where a.Score_Type1=4 and ISNULL(a.Submit,0)=1
group by a.EID

-- 11-子公司普通员工
UNION
select a.EID,
SUM(a.ScoreTotal) AS EachNSUM,COUNT(a.ScoreTotal) as EachNCOUNTReal,
(select COUNT(Score_EID) from pYear_ScoreEachN where EID=a.EID) as EachNCOUNTExpt,
AVG(a.ScoreTotal) AS EachNAVG
from pYear_ScoreEachN a
where a.Score_Type1=11 and ISNULL(a.Submit,0)=1
group by a.EID

-- 33-分支机构普通员工
UNION
select a.EID,
SUM(a.ScoreTotal) AS EachNSUM,COUNT(a.ScoreTotal) as EachNCOUNTReal,
(select COUNT(Score_EID) from pYear_ScoreEachN where EID=a.EID) as EachNCOUNTExpt,
AVG(a.ScoreTotal) AS EachNAVG
from pYear_ScoreEachN a
where a.Score_Type1=33 and ISNULL(a.Submit,0)=1
group by a.EID

GO