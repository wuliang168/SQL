-- pVW_pYear_DepScoreResult

-- 年度考核部门统计汇总
select a.pYear_ID as pYear_ID,a.Score_DepID as Score_DepID,COUNT(a.Score_DepID) as TotalNum,COUNT(a.isRanking) as TotalRankNum,
(select COUNT(Score_DepID) from pYear_Score where Score_Status=0 and Score_Type1 in (4,11,29,12,13) and Score_DepID=a.Score_DepID group by Score_DepID) as DepTotalNum,
(select COUNT(isRanking) from pYear_Score where Score_Status=0 and Score_Type1 in (4,11,29,12,13) and Score_DepID=a.Score_DepID group by Score_DepID) as DepTotalRankNum,
(select COUNT(Submit)/COUNT(ISNULL(Submit,1)) from pYear_Score where Score_Status=9 and Score_Type1 in (4,11,29,12,13) and Score_DepID=a.Score_DepID group by Score_DepID) as DepSbumitStatus,
(select distinct Score_EID from pYear_Score where Score_Status=9 and Score_Type1 in (4,11,29,12,13) and Score_DepID=a.Score_DepID group by Score_DepID,Score_EID) as DepSbumitEID
from pYear_Score a
where a.Score_Status=0
group by a.pYear_ID,a.Score_DepID

UNION
select a.pYear_ID as pYear_ID,a.Score_DepID as Score_DepID,COUNT(a.Score_DepID) as TotalNum,COUNT(a.isRanking) as TotalRankNum,
(select COUNT(Score_DepID) from pYear_Score where Score_Status=0 and Score_Type1 in (4,11,29,12,13) and Score_DepID=a.Score_DepID group by Score_DepID) as DepTotalNum,
(select COUNT(isRanking) from pYear_Score where Score_Status=0 and Score_Type1 in (4,11,29,12,13) and Score_DepID=a.Score_DepID group by Score_DepID) as DepTotalRankNum,
(select COUNT(Submit)/COUNT(ISNULL(Submit,1)) from pYear_Score where Score_Status=9 and Score_Type1 in (4,11,29,12,13) and Score_DepID=a.Score_DepID group by Score_DepID) as DepSbumitStatus,
(select distinct Score_EID from pYear_Score where Score_Status=9 and Score_Type1 in (4,11,29,12,13) and Score_DepID=a.Score_DepID group by Score_DepID,Score_EID) as DepSbumitEID
from pYear_Score_all a
where a.Score_Status=0
group by a.pYear_ID,a.Score_DepID