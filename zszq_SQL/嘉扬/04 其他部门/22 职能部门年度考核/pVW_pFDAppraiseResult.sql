-- pVW_pFDAppraiseResult

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pFDAppraiseResult]
AS

---- 服务支持 20%
select a.pYear_ID,a.DepID,a.Director,AVG(ScoreTotal) as ScoreTotal,0.2 as Modulus,NULL as FDAppraiseEID,N'服务支持' as FDAppraiseTitle,1 as xOrder
from pFDAppraise a
where a.Status in (1,2) and a.FDAppraiseType in (3,15,16)
group by a.pYear_ID,a.DepID,a.Director

---- 分管领导 30%
UNION
select a.pYear_ID,a.DepID,a.Director,SUM(ScoreTotal) as ScoreTotal,0.3 as Modulus,a.FDAppraiseEID as FDAppraiseEID,N'分管领导' as FDAppraiseTitle,2 as xOrder
from pFDAppraise a
where a.Status in (4) and a.FDAppraiseType in (8,9,10,17,18)
group by a.pYear_ID,a.DepID,a.Director,a.FDAppraiseEID

---- 主要领导
------ 董事长 25%
UNION
select a.pYear_ID,a.DepID,a.Director,SUM(ScoreTotal) as ScoreTotal,0.25 as Modulus,a.FDAppraiseEID as FDAppraiseEID,N'董事长' as FDAppraiseTitle,5 as xOrder
from pFDAppraise a
where a.Status in (5) and a.FDAppraiseType in (8,9,10,17,18) and a.FDAppraiseEID=1022
group by a.pYear_ID,a.DepID,a.Director,a.FDAppraiseEID

------ 书记 12.5%
UNION
select a.pYear_ID,a.DepID,a.Director,SUM(ScoreTotal) as ScoreTotal,0.125 as Modulus,a.FDAppraiseEID as FDAppraiseEID,N'党委书记' as FDAppraiseTitle,4 as xOrder
from pFDAppraise a
where a.Status in (5) and a.FDAppraiseType in (8,9,10,17,18) and a.FDAppraiseEID=5587
group by a.pYear_ID,a.DepID,a.Director,a.FDAppraiseEID

------ 总裁 12.5%
UNION
select a.pYear_ID,a.DepID,a.Director,SUM(ScoreTotal) as ScoreTotal,0.125 as Modulus,a.FDAppraiseEID as FDAppraiseEID,N'总裁' as FDAppraiseTitle,3 as xOrder
from pFDAppraise a
where a.Status in (5) and a.FDAppraiseType in (8,9,10,17,18) and a.FDAppraiseEID=5014
group by a.pYear_ID,a.DepID,a.Director,a.FDAppraiseEID

Go