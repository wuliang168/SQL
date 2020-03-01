-------- pVW_pYear_ScoreRankingNew --------
---- oDepartment中添加业务部门和职能部门类型 ----

---- 业务部门 ----
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,d.Ranking AS Ranking
,(CASE
WHEN b.Ranking*1.00/a.TotalRankNum <=c.RankLevA THEN 'A'
WHEN b.Ranking*1.00/a.TotalRankNum>RankLevA AND b.Ranking*1.00/a.TotalRankNum<=RankLevA+RankLevB THEN 'B'
WHEN b.Ranking*1.00/a.TotalRankNum>RankLevA+RankLevB AND b.Ranking*1.00/a.TotalRankNum<=RankLevA+RankLevB+RankLevC THEN 'C'
WHEN b.Ranking*1.00/a.TotalRankNum>RankLevA+RankLevB+RankLevC AND b.Ranking*1.00/a.TotalRankNum<=RankLevA+RankLevB+RankLevC+ISNULL(RankLevD,0) THEN 'D'
END) as RankLevel
FROM pYear_Score a,pVW_pYear_ScoreSum b,pVW_pYear_ScoreRankingRule c,oDepartment d
WHERE a.Score_Status=99 AND a.Score_Type1 in (33,4,11)
AND a.Score_Type1=b.Score_Type1 AND a.Score_Status=b.Score_Status AND a.Score_EID=b.Score_EID
AND c.DepScoreType=2 AND c.DepScoreType=d.DepType
AND a.Score_DepID=d.DepID and c.DepID=d.DepID

---- 职能部门 ----
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,d.Ranking AS Ranking
,(CASE
WHEN b.Ranking*1.00/a.TotalRankNum <=c.RankLevA THEN 'A'
WHEN b.Ranking*1.00/a.TotalRankNum>RankLevA AND b.Ranking*1.00/a.TotalRankNum<=RankLevA+RankLevB THEN 'B'
WHEN b.Ranking*1.00/a.TotalRankNum>RankLevA+RankLevB AND b.Ranking*1.00/a.TotalRankNum<=RankLevA+RankLevB+RankLevC THEN 'C'
WHEN b.Ranking*1.00/a.TotalRankNum>RankLevA+RankLevB+RankLevC AND b.Ranking*1.00/a.TotalRankNum<=RankLevA+RankLevB+RankLevC+ISNULL(RankLevD,0) THEN 'D'
END) as RankLevel
FROM pYear_Score a,pVW_pYear_ScoreSum b,pVW_pYear_ScoreRankingRule c,oDepartment d
WHERE a.Score_Status=99 AND a.Score_Type1 in (4,11)
AND a.Score_Type1=b.Score_Type1 AND a.Score_Status=b.Score_Status AND a.Score_EID=b.Score_EID
AND c.DepScoreType=2 AND c.DepScoreType=d.DepType
AND a.Score_DepID=d.DepID and c.DepID=d.DepID

---- 专项排名组 ----
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,d.Ranking AS Ranking
,(CASE
WHEN b.Ranking*1.00/a.TotalRankNum <=c.RankLevA THEN 'A'
WHEN b.Ranking*1.00/a.TotalRankNum>RankLevA AND b.Ranking*1.00/a.TotalRankNum<=RankLevA+RankLevB THEN 'B'
WHEN b.Ranking*1.00/a.TotalRankNum>RankLevA+RankLevB AND b.Ranking*1.00/a.TotalRankNum<=RankLevA+RankLevB+RankLevC THEN 'C'
WHEN b.Ranking*1.00/a.TotalRankNum>RankLevA+RankLevB+RankLevC AND b.Ranking*1.00/a.TotalRankNum<=RankLevA+RankLevB+RankLevC+ISNULL(RankLevD,0) THEN 'D'
END) as RankLevel
FROM pYear_Score a,pVW_pYear_ScoreSum b,pVW_pYear_ScoreRankingRule c
WHERE a.Score_Status=99 AND a.Score_Type1 in (1,2,36,10,31,32,14,17,19)
AND a.Score_Type1=b.Score_Type1 AND a.Score_Status=b.Score_Status AND a.Score_EID=b.Score_EID
AND c.DepScoreType=3
