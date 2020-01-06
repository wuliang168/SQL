-- pVW_pYear_ScoreResult
-- 年度考核结果统计汇总

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pYear_ScoreResult]
AS

select distinct a.EID as EID,a.pYear_ID as pYear_ID,a.Score_Status as Score_Status,b.Score_StatusTitle as Score_StatusTitle,
a.Score_Type1 as Score_Type1,a.Score_Type2 as Score_Type2,a.Score_EID as Score_EID,a.Score_DepID as Score_DepID,
a.Score1 as Score1,a.Score2 as Score2,a.Score3 as Score3,a.Score4 as Score4,a.Score5 as Score5,a.Score6 as Score6,a.Score7 as Score7,a.Score8 as Score8,a.ScoreTotal as ScoreTotal,
a.ScoreEach as ScoreEach,a.ScoreSTG1 as ScoreSTG1,a.ScoreSTG2 as ScoreSTG2,a.ScoreSTG3 as ScoreSTG3,a.ScoreSTG4 as ScoreSTG4,a.ScoreSTG5 as ScoreSTG5,
a.ScoreCompl as ScoreCompl,a.ScoreParty as ScoreParty,
a.TotalNum as TotalNum,a.TotalRankNum as TotalRankNum,a.ScoreYear as ScoreYear,a.isRanking as isRanking,a.Ranking as Ranking,a.RankLevel as RankLevel,a.Initialized,a.Submit
from pYear_Score a,pVW_pYear_ScoreType b
where a.Score_Status not in (0,1) and a.EID=b.EID and a.Score_Status=b.Score_Status
--where a.Score_Status=(select MAX(Score_Status) from pYear_Score where ISNULL(Initialized,0)=1 and EID=a.EID and Score_Status<>7) and a.EID=b.EID and a.Score_Status=b.Score_Status

Go