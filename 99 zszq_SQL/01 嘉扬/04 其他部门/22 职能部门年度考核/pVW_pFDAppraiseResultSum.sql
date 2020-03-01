-- pVW_pFDAppraiseResultSum

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pFDAppraiseResultSum]
AS

---- 最终总分
------ 职能部门 (非审计、风险)
select distinct a.pYear_ID,a.DepID,a.Director,
(select SUM(ScoreTotal*Modulus) from pVW_pFDAppraiseResult where Director=a.Director and DepID=a.DepID and xOrder in (1,2,3,4,5,6))* 
(select SUM(ScoreTotal*Modulus) from pVW_pFDAppraiseResult where Director=a.Director and DepID=a.DepID and xOrder in (11,12,13,14))/100
as ScoreTotal,1 as pFDAppraiseDepType
from pVW_pFDAppraiseResult a
where a.DepID not in (358,359) and a.xOrder not in (7,15)
------ 职能部门 (审计、风险)
UNION
select distinct a.pYear_ID,a.DepID,a.Director,
(select SUM(ScoreTotal*Modulus) from pVW_pFDAppraiseResult where Director=a.Director and DepID=a.DepID and xOrder in (1,2,3,4,5,6))/0.9* 
(select SUM(ScoreTotal*Modulus) from pVW_pFDAppraiseResult where Director=a.Director and DepID=a.DepID and xOrder in (11,12,13,14))/100
as ScoreTotal,1 as pFDAppraiseDepType
from pVW_pFDAppraiseResult a
where a.DepID in (358,359) and a.xOrder not in (7,15)
------ 业务/投行部门 
--UNION
--select distinct a.pYear_ID,a.DepID,a.Director,
--(select ScoreTotal from pVW_pFDAppraiseResult where Director=a.Director and DepID=a.DepID and xOrder in (7))* 
--(select ScoreTotal from pVW_pFDAppraiseResult where Director=a.Director and DepID=a.DepID and xOrder in (15))/100
--as ScoreTotal
--from pVW_pFDAppraiseResult a
--where a.xOrder in (7,15)
UNION
select a.pYear_ID,a.DepID,a.Director,ScoreTotal
from pFDAppraise a
where FDAppraiseType=21 and FDAppraiseEID is NULL


Go