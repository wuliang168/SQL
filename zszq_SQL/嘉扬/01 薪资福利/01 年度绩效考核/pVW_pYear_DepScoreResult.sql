-- pVW_pYear_DepScoreResult

USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER VIEW [dbo].[pVW_pYear_DepScoreResult]
AS

-- 年度考核部门统计汇总
select distinct a.pYear_ID as pYear_ID,a.Score_DepID as Score_DepID,Score_EID as Score_EID,
Score_Type1,Score_Status,Submit
from pYear_Score a
where a.Score_Status not in (0,1,7) and a.Score_Type1 in (4,11,33) and a.Score_DepID is not NULL

--UNION
--select a.pYear_ID as pYear_ID,a.Score_DepID as Score_DepID,COUNT(a.Score_DepID) as TotalNum,COUNT(a.isRanking) as TotalRankNum,
--(select COUNT(Score_DepID) from pYear_Score where Score_Status=0 and Score_Type1 in (4,11,29,12,13) and Score_DepID=a.Score_DepID group by Score_DepID) as DepTotalNum,
--(select COUNT(isRanking) from pYear_Score where Score_Status=0 and Score_Type1 in (4,11,29,12,13) and Score_DepID=a.Score_DepID group by Score_DepID) as DepTotalRankNum,
--(select COUNT(Submit)/COUNT(ISNULL(Submit,1)) from pYear_Score where Score_Status=9 and Score_Type1 in (4,11,29,12,13) and Score_DepID=a.Score_DepID group by Score_DepID) as DepSbumitStatus,
--(select distinct Score_EID from pYear_Score where Score_Status=9 and Score_Type1 in (4,11,29,12,13) and Score_DepID=a.Score_DepID group by Score_DepID,Score_EID) as DepSbumitEID
--from pYear_Score_all a
--where a.Score_Status=0
--group by a.pYear_ID,a.Score_DepID

Go