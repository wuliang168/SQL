-- pVW_pFDAppraiseResult

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pFDAppraiseResult]
AS

---- 服务支持 10%
select a.pYear_ID,a.DepID,a.Director,AVG(ScoreTotal) as ScoreTotal,0.1 as Modulus,NULL as FDAppraiseEID,N'服务支持' as FDAppraiseTitle,1 as xOrder
from pFDAppraise a
where a.Status in (1,2) and a.FDAppraiseType in (3,15,16) and a.DepID<>737
group by a.pYear_ID,a.DepID,a.Director

---- 班子其他成员 20%
UNION
select a.pYear_ID,a.DepID,a.Director,SUM(a.ScoreTotal)/COUNT(a.ScoreTotal)*5 as ScoreTotal,0.2 as Modulus,NULL as FDAppraiseEID,N'班子其他成员' as FDAppraiseTitle,2 as xOrder
from pFDAppraise a
where a.Status in (6) and a.FDAppraiseType in (8,9,10,17,18) and a.DepID<>737
group by a.pYear_ID,a.DepID,a.Director

---- 分管领导 20%
UNION
select a.pYear_ID,a.DepID,a.Director,SUM(ScoreTotal) as ScoreTotal,0.2 as Modulus,a.FDAppraiseEID as FDAppraiseEID,N'分管领导' as FDAppraiseTitle,3 as xOrder
from pFDAppraise a
where a.Status in (4) and a.FDAppraiseType in (8,9,10,17,18) and a.DepID<>737
group by a.pYear_ID,a.DepID,a.Director,a.FDAppraiseEID
------ 合规总监 100%
UNION
select a.pYear_ID,a.DepID,a.Director,SUM(ScoreTotal) as ScoreTotal,1 as Modulus,a.FDAppraiseEID as FDAppraiseEID,N'合规总监' as FDAppraiseTitle,3 as xOrder
from pFDAppraise a
where a.Status in (4) and a.FDAppraiseType in (8,9,10,17,18) and a.DepID=737
group by a.pYear_ID,a.DepID,a.Director,a.FDAppraiseEID

---- 主要领导
------ 董事长 25%
UNION
select a.pYear_ID,a.DepID,a.Director,ScoreTotal as ScoreTotal,0.25 as Modulus,a.FDAppraiseEID as FDAppraiseEID,N'董事长' as FDAppraiseTitle,6 as xOrder
from pFDAppraise a
where a.Status in (5) and a.FDAppraiseType=21 and a.FDAppraiseEID=1022 and a.DepID<>737

------ 书记 12.5%
UNION
select a.pYear_ID,a.DepID,a.Director,SUM(ScoreTotal) as ScoreTotal,0.125 as Modulus,a.FDAppraiseEID as FDAppraiseEID,N'党委书记' as FDAppraiseTitle,5 as xOrder
from pFDAppraise a
where a.Status in (5) and a.FDAppraiseType in (8,9,10,17,18) and a.FDAppraiseEID=5587 and a.DepID<>737
group by a.pYear_ID,a.DepID,a.Director,a.FDAppraiseEID

------ 总裁 12.5%
UNION
select a.pYear_ID,a.DepID,a.Director,SUM(ScoreTotal) as ScoreTotal,0.125 as Modulus,a.FDAppraiseEID as FDAppraiseEID,N'总裁' as FDAppraiseTitle,4 as xOrder
from pFDAppraise a
where a.Status in (5) and a.FDAppraiseType in (8,9,10,17,18) and a.FDAppraiseEID=5014 and a.DepID<>737
group by a.pYear_ID,a.DepID,a.Director,a.FDAppraiseEID

---- 业务部门
UNION
select a.pYear_ID,a.DepID,a.Director,ScoreTotal as ScoreTotal,1 as Modulus,a.FDAppraiseEID as FDAppraiseEID,N'效率指标' as FDAppraiseTitle,7 as xOrder
from pFDAppraise a
where a.Status=10 and a.FDAppraiseType=21

---- 质量系数
------ 达标要求
UNION
select distinct a.pYear_ID,a.DepID,a.Director,100 as ScoreTotal,0.2 as Modulus,NULL as FDAppraiseEID,N'达标要求' as FDAppraiseTitle,11 as xOrder
from pFDAppraise a

------ 工作规划
UNION
select distinct a.pYear_ID,a.DepID,a.Director,100 as ScoreTotal,0.2 as Modulus,NULL as FDAppraiseEID,N'工作规划' as FDAppraiseTitle,12 as xOrder
from pFDAppraise a

------ 安全管理
UNION
select distinct a.pYear_ID,a.DepID,a.Director,AVG(ScoreTotal) as ScoreTotal,0.4 as Modulus,NULL as FDAppraiseEID,N'安全管理' as FDAppraiseTitle,13 as xOrder
from pFDAppraise a
where a.Status=3 and a.FDAppraiseType=13 and a.FDAppraiseEID not in (1190,1366)
group by a.pYear_ID,a.DepID,a.Director

------ 党风廉政
UNION
select distinct a.pYear_ID,a.DepID,a.Director,ScoreTotal as ScoreTotal,0.2 as Modulus,a.FDAppraiseEID as FDAppraiseEID,N'党风廉政' as FDAppraiseTitle,14 as xOrder
from pFDAppraise a
where a.Status=3 and a.FDAppraiseType=14

------ 业务部门
UNION
select distinct a.pYear_ID,a.DepID,a.Director,ScoreTotal as ScoreTotal,1 as Modulus,a.FDAppraiseEID as FDAppraiseEID,N'质量系数' as FDAppraiseTitle,15 as xOrder
from pFDAppraise a
where a.Status=10 and a.FDAppraiseType=22

Go