-- pVW_pYear_ScoreResult_All

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pYear_ScoreResult_All]
AS

---- pYear_Score
select distinct EID,pYear_ID,Score_Status,Score_Type1,Score_Type2,Score_DepID,
ScoreEach,ScoreSTG1,ScoreSTG2,ScoreSTG3,ScoreSTG4,ScoreSTG5,ScoreCompl,ScoreParty,Weight1,Weight2,Weight3,Modulus,
TotalNum,TotalRankNum,ScoreYear,isRanking,Ranking,RankLevel,Remark
from pYear_Score
where Score_Status=99

---- pYear_Score_all
UNION
select distinct EID,pYear_ID,Score_Status,Score_Type1,Score_Type2,Score_DepID,
ScoreEach,ScoreSTG1,ScoreSTG2,ScoreSTG3,ScoreSTG4,ScoreSTG5,ScoreCompl,ScoreParty,Weight1,Weight2,Weight3,Modulus,
TotalNum,TotalRankNum,ScoreYear,isRanking,Ranking,RankLevel,Remark
from pYear_Score_all
where Score_Status=99

Go