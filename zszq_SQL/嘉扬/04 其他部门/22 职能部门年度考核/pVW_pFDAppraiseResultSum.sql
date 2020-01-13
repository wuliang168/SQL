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
select a.pYear_ID,a.DepID,a.Director,SUM(ScoreTotal*Modulus) as ScoreTotal
from pVW_pFDAppraiseResult a
group by a.pYear_ID,a.DepID,a.Director

Go