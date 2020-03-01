-------- pVW_pYear_ScoreRanking_all --------
---- 总部部门负责人 ----
---- isRanking=1
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,d.Ranking AS Ranking
,(CASE WHEN c.TotalRankNum=1 THEN 'B' 
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.2,0) THEN 'A' 
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 'B'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 'C'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0) THEN 'D'
END) as RankLevel,
(CASE WHEN c.TotalRankNum=1 THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.05,1) THEN 1.5
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1) and ROUND(c.TotalRankNum*0.05,1)*2 THEN 1.4
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*2 and ROUND(c.TotalRankNum*0.05,1)*3 THEN 1.3
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*3 and ROUND(c.TotalRankNum*0.2,0) THEN 1.25
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) THEN 1.1
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) THEN 1.0
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 0.9
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) THEN 0.8
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 0.7
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) THEN 0.6
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) and ROUND(c.TotalRankNum*1,0) THEN 0.5
END) as RankRatio
FROM pYear_Score_all a
LEFT join (select Score_Type1,COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1=1 and Score_Status=9 GROUP by Score_Type1) as b on a.Score_Type1=b.Score_Type1
LEFT join (select Score_Type1,COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1=1 and Score_Status=9 AND ISNULL(isRanking, 0)=1 GROUP by Score_Type1) as c on a.Score_Type1=c.Score_Type1
LEFT join (select EID,rank() OVER (partition BY Score_Type1 ORDER BY ScoreYear DESC) as Ranking from pYear_Score where Score_Type1=1 and Score_Status=9 AND ISNULL(isRanking, 0)=1) as d on a.EID=d.EID
WHERE a.Score_Status=9 AND a.Score_Type1=1 AND ISNULL(a.isRanking,0)=1
---- isRanking=NULL
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,NULL AS Ranking
,NULL as RankLevel,NULL as RankRatio
FROM pYear_Score_all a
LEFT join (select Score_Type1,COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1=1 and Score_Status=9 GROUP by Score_Type1) as b on a.Score_Type1=b.Score_Type1
LEFT join (select Score_Type1,COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1=1 and Score_Status=9 AND ISNULL(isRanking, 0)=1 GROUP by Score_Type1) as c on a.Score_Type1=c.Score_Type1
WHERE a.Score_Status=9 AND a.Score_Type1=1 AND ISNULL(a.isRanking,0)=0


---- 总部部门副职 ----
---- isRanking=1
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,d.Ranking AS Ranking
,(CASE WHEN c.TotalRankNum=1 THEN 'B'
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.2,0) THEN 'A' 
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 'B'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 'C'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0) THEN 'D'
END) as RankLevel,
(CASE WHEN c.TotalRankNum=1 THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.05,1) THEN 1.5
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1) and ROUND(c.TotalRankNum*0.05,1)*2 THEN 1.4
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*2 and ROUND(c.TotalRankNum*0.05,1)*3 THEN 1.3
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*3 and ROUND(c.TotalRankNum*0.2,0) THEN 1.25
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) THEN 1.1
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) THEN 1.0
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 0.9
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) THEN 0.8
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 0.7
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) THEN 0.6
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) and ROUND(c.TotalRankNum*1,0) THEN 0.5
END) as RankRatio
FROM pYear_Score_all a
LEFT join (select Score_Type1,COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1=2 and Score_Status=9 GROUP by Score_Type1) as b on a.Score_Type1=b.Score_Type1
LEFT join (select Score_Type1,COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1=2 and Score_Status=9 AND ISNULL(isRanking, 0)=1 GROUP by Score_Type1) as c on a.Score_Type1=c.Score_Type1
LEFT join (select EID,rank() OVER (partition BY Score_Type1 ORDER BY ScoreYear DESC) as Ranking from pYear_Score where Score_Type1=2 and Score_Status=9 AND ISNULL(isRanking, 0)=1) as d on a.EID=d.EID
WHERE a.Score_Status=9 AND a.Score_Type1=2 AND ISNULL(a.isRanking,0)=1
---- isRanking=NULL
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,NULL AS Ranking
,NULL as RankLevel,NULL as RankRatio
FROM pYear_Score_all a
LEFT join (select Score_Type1,COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1=2 and Score_Status=9 GROUP by Score_Type1) as b on a.Score_Type1=b.Score_Type1
LEFT join (select Score_Type1,COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1=2 and Score_Status=9 AND ISNULL(isRanking, 0)=1 GROUP by Score_Type1) as c on a.Score_Type1=c.Score_Type1
WHERE a.Score_Status=9 AND a.Score_Type1=2 AND ISNULL(a.isRanking,0)=0


---- 子公司部门行政负责人 ----
---- isRanking=1
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,d.Ranking AS Ranking
,(CASE WHEN c.TotalRankNum=1 THEN 'B' 
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.2,0) THEN 'A' 
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 'B'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 'C'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0) THEN 'D'
END) as RankLevel,
(CASE WHEN c.TotalRankNum=1 THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.05,1) THEN 1.5
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1) and ROUND(c.TotalRankNum*0.05,1)*2 THEN 1.4
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*2 and ROUND(c.TotalRankNum*0.05,1)*3 THEN 1.3
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*3 and ROUND(c.TotalRankNum*0.2,0) THEN 1.25
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) THEN 1.1
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) THEN 1.0
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 0.9
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) THEN 0.8
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 0.7
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) THEN 0.6
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) and ROUND(c.TotalRankNum*1,0) THEN 0.5
END) as RankRatio
FROM pYear_Score_all a
LEFT join (select Score_Type1,COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1=10 and Score_Status=9 GROUP by Score_Type1) as b on a.Score_Type1=b.Score_Type1
LEFT join (select Score_Type1,COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1=10 and Score_Status=9 AND ISNULL(isRanking, 0)=1 GROUP by Score_Type1) as c on a.Score_Type1=c.Score_Type1
LEFT join (select EID,rank() OVER (partition BY Score_Type1 ORDER BY ScoreYear DESC) as Ranking from pYear_Score where Score_Type1=10 and Score_Status=9 AND ISNULL(isRanking, 0)=1) as d on a.EID=d.EID
WHERE a.Score_Status=9 AND a.Score_Type1=10 AND ISNULL(a.isRanking,0)=1
---- isRanking=NULL
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,NULL AS Ranking
,NULL as RankLevel,NULL as RankRatio
FROM pYear_Score_all a
LEFT join (select Score_Type1,COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1=10 and Score_Status=9 GROUP by Score_Type1) as b on a.Score_Type1=b.Score_Type1
LEFT join (select Score_Type1,COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1=10 and Score_Status=9 AND ISNULL(isRanking, 0)=1 GROUP by Score_Type1) as c on a.Score_Type1=c.Score_Type1
WHERE a.Score_Status=9 AND a.Score_Type1=10 AND ISNULL(a.isRanking,0)=0


---- 子公司部门副职 ----
---- isRanking=1
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,d.Ranking AS Ranking
,(CASE WHEN c.TotalRankNum=1 THEN 'B'
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.2,0) THEN 'A' 
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 'B'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 'C'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0) THEN 'D'
END) as RankLevel,
(CASE WHEN c.TotalRankNum=1 THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.05,1) THEN 1.5
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1) and ROUND(c.TotalRankNum*0.05,1)*2 THEN 1.4
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*2 and ROUND(c.TotalRankNum*0.05,1)*3 THEN 1.3
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*3 and ROUND(c.TotalRankNum*0.2,0) THEN 1.25
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) THEN 1.1
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) THEN 1.0
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 0.9
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) THEN 0.8
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 0.7
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) THEN 0.6
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) and ROUND(c.TotalRankNum*1,0) THEN 0.5
END) as RankRatio
FROM pYear_Score_all a
LEFT join (select Score_Type1,COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1=30 and Score_Status=9 GROUP by Score_Type1) as b on a.Score_Type1=b.Score_Type1
LEFT join (select Score_Type1,COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1=30 and Score_Status=9 AND ISNULL(isRanking, 0)=1 GROUP by Score_Type1) as c on a.Score_Type1=c.Score_Type1
LEFT join (select EID,rank() OVER (partition BY Score_Type1 ORDER BY ScoreYear DESC) as Ranking from pYear_Score where Score_Type1=30 and Score_Status=9 AND ISNULL(isRanking, 0)=1) as d on a.EID=d.EID
WHERE a.Score_Status=9 AND a.Score_Type1=2 AND ISNULL(a.isRanking,0)=1
---- isRanking=NULL
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,NULL AS Ranking
,NULL as RankLevel,NULL as RankRatio
FROM pYear_Score_all a
LEFT join (select Score_Type1,COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1=30 and Score_Status=9 GROUP by Score_Type1) as b on a.Score_Type1=b.Score_Type1
LEFT join (select Score_Type1,COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1=30 and Score_Status=9 AND ISNULL(isRanking, 0)=1 GROUP by Score_Type1) as c on a.Score_Type1=c.Score_Type1
WHERE a.Score_Status=9 AND a.Score_Type1=30 AND ISNULL(a.isRanking,0)=0


---- 分公司/一级营业部负责人 ----
---- isRanking=1
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,d.Ranking AS Ranking
,(CASE WHEN c.TotalRankNum=1 THEN 'B' 
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.2,0) THEN 'A' 
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 'B'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 'C'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0) THEN 'D'
END) as RankLevel,
(CASE WHEN c.TotalRankNum=1 THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.05,1) THEN 1.5
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1) and ROUND(c.TotalRankNum*0.05,1)*2 THEN 1.4
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*2 and ROUND(c.TotalRankNum*0.05,1)*3 THEN 1.3
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*3 and ROUND(c.TotalRankNum*0.2,0) THEN 1.25
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) THEN 1.1
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) THEN 1.0
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 0.9
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) THEN 0.8
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 0.7
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) THEN 0.6
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) and ROUND(c.TotalRankNum*1,0) THEN 0.5
END) as RankRatio
FROM pYear_Score_all a
LEFT join (select COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1 IN (24,5) and Score_Status=9) as b on a.Score_Type1 IN (24,5) 
LEFT join (select COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1 IN (24,5) and Score_Status=9 AND ISNULL(isRanking, 0)=1) as c on a.Score_Type1 IN (24,5) 
LEFT join (select EID,rank() OVER (ORDER BY ScoreYear DESC) as Ranking from pYear_Score where Score_Type1 IN (24,5) and Score_Status=9 AND ISNULL(isRanking, 0)=1) as d on a.EID=d.EID
WHERE a.Score_Status=9 AND a.Score_Type1 IN (24,5) AND ISNULL(a.isRanking,0)=1
---- isRanking=NULL
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,NULL AS Ranking
,NULL as RankLevel,NULL as RankRatio
FROM pYear_Score_all a
LEFT join (select COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1 IN (24,5) and Score_Status=9) as b on a.Score_Type1 IN (24,5) 
LEFT join (select COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1 IN (24,5) and Score_Status=9 AND ISNULL(isRanking, 0)=1) as c on a.Score_Type1 IN (24,5) 
WHERE a.Score_Status=9 AND a.Score_Type1 IN (24,5) AND ISNULL(a.isRanking,0)=0


---- 分公司/一级营业部副职及二级营业部经理室成员 ----
---- isRanking=1
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,d.Ranking AS Ranking
,(CASE WHEN c.TotalRankNum=1 THEN 'B'
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.2,0) THEN 'A' 
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 'B'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 'C'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0) THEN 'D'
END) as RankLevel,
(CASE WHEN c.TotalRankNum=1 THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.05,1) THEN 1.5
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1) and ROUND(c.TotalRankNum*0.05,1)*2 THEN 1.4
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*2 and ROUND(c.TotalRankNum*0.05,1)*3 THEN 1.3
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*3 and ROUND(c.TotalRankNum*0.2,0) THEN 1.25
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) THEN 1.1
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) THEN 1.0
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 0.9
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) THEN 0.8
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 0.7
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) THEN 0.6
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) and ROUND(c.TotalRankNum*1,0) THEN 0.5
END) as RankRatio
FROM pYear_Score_all a
LEFT join (select COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1 IN (25,6,7) and Score_Status=9) as b on a.Score_Type1 IN (25,6,7) 
LEFT join (select COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1 IN (25,6,7) and Score_Status=9 AND ISNULL(isRanking, 0)=1) as c on a.Score_Type1 IN (25,6,7) 
LEFT join (select EID,rank() OVER (ORDER BY ScoreYear DESC) as Ranking from pYear_Score where Score_Type1 IN (25,6,7) and Score_Status=9 AND ISNULL(isRanking, 0)=1) as d on a.EID=d.EID
WHERE a.Score_Status=9 AND a.Score_Type1 IN (25,6,7) AND ISNULL(a.isRanking,0)=1
---- isRanking=NULL
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,NULL AS Ranking
,NULL as RankLevel,NULL as RankRatio
FROM pYear_Score_all a
LEFT join (select COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1 IN (25,6,7) and Score_Status=9) as b on a.Score_Type1 IN (25,6,7) 
LEFT join (select COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1 IN (25,6,7) and Score_Status=9 AND ISNULL(isRanking, 0)=1) as c on a.Score_Type1 IN (25,6,7) 
WHERE a.Score_Status=9 AND a.Score_Type1 IN (25,6,7) AND ISNULL(a.isRanking,0)=0


---- 总部普通员工(4) ----
---- isRanking=1
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,d.Ranking AS Ranking
,(CASE WHEN c.TotalRankNum=1 THEN 'B'
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.2,0) THEN 'A' 
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 'B'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 'C'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0) THEN 'D'
END) as RankLevel,
(CASE WHEN c.TotalRankNum=1 THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.05,1) THEN 1.5
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1) and ROUND(c.TotalRankNum*0.05,1)*2 THEN 1.4
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*2 and ROUND(c.TotalRankNum*0.05,1)*3 THEN 1.3
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*3 and ROUND(c.TotalRankNum*0.2,0) THEN 1.25
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) THEN 1.1
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) THEN 1.0
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 0.9
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) THEN 0.8
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 0.7
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) THEN 0.6
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) and ROUND(c.TotalRankNum*1,0) THEN 0.5
END) as RankRatio
FROM pYear_Score_all a
LEFT join (select Score_DepID,COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1=4 and Score_Status=9 GROUP BY Score_DepID) as b on a.Score_DepID=b.Score_DepID 
LEFT join (select Score_DepID,COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1=4 and Score_Status=9 AND ISNULL(isRanking, 0)=1 GROUP BY Score_DepID) as c on a.Score_DepID=c.Score_DepID
LEFT join (select EID,rank() OVER (partition BY Score_DepID ORDER BY ScoreYear DESC) as Ranking from pYear_Score where Score_Type1=4 and Score_Status=9 AND ISNULL(isRanking, 0)=1) as d on a.EID=d.EID
WHERE a.Score_Status=9 AND a.Score_Type1=4 AND ISNULL(a.isRanking,0)=1
---- isRanking=NULL
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,NULL AS Ranking
,NULL as RankLevel,NULL as RankRatio
FROM pYear_Score_all a
LEFT join (select Score_DepID,COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1=4 and Score_Status=9 GROUP BY Score_DepID) as b on a.Score_DepID=b.Score_DepID 
LEFT join (select Score_DepID,COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1=4 and Score_Status=9 AND ISNULL(isRanking, 0)=1 GROUP BY Score_DepID) as c on a.Score_DepID=c.Score_DepID
WHERE a.Score_Status=9 AND a.Score_Type1=4 AND ISNULL(a.isRanking,0)=0


---- 子公司普通员工(11) ----
---- isRanking=1
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,d.Ranking AS Ranking
,(CASE WHEN c.TotalRankNum=1 THEN 'B'
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.2,0) THEN 'A' 
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 'B'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 'C'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0) THEN 'D'
END) as RankLevel,
(CASE WHEN c.TotalRankNum=1 THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.05,1) THEN 1.5
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1) and ROUND(c.TotalRankNum*0.05,1)*2 THEN 1.4
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*2 and ROUND(c.TotalRankNum*0.05,1)*3 THEN 1.3
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*3 and ROUND(c.TotalRankNum*0.2,0) THEN 1.25
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) THEN 1.1
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) THEN 1.0
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 0.9
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) THEN 0.8
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 0.7
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) THEN 0.6
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) and ROUND(c.TotalRankNum*1,0) THEN 0.5
END) as RankRatio
FROM pYear_Score_all a
LEFT join (select Score_DepID,COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1=11 and Score_Status=9 GROUP BY Score_DepID) as b on a.Score_DepID=b.Score_DepID 
LEFT join (select Score_DepID,COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1=11 and Score_Status=9 AND ISNULL(isRanking, 0)=1 GROUP BY Score_DepID) as c on a.Score_DepID=c.Score_DepID
LEFT join (select EID,rank() OVER (partition BY Score_DepID ORDER BY ScoreYear DESC) as Ranking from pYear_Score where Score_Type1=11 and Score_Status=9 AND ISNULL(isRanking, 0)=1) as d on a.EID=d.EID
WHERE a.Score_Status=9 AND a.Score_Type1=11 AND ISNULL(a.isRanking,0)=1
---- isRanking=NULL
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,NULL AS Ranking
,NULL as RankLevel,NULL as RankRatio
FROM pYear_Score_all a
LEFT join (select Score_DepID,COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1=11 and Score_Status=9 GROUP BY Score_DepID) as b on a.Score_DepID=b.Score_DepID 
LEFT join (select Score_DepID,COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1=11 and Score_Status=9 AND ISNULL(isRanking, 0)=1 GROUP BY Score_DepID) as c on a.Score_DepID=c.Score_DepID
WHERE a.Score_Status=9 AND a.Score_Type1=11 AND ISNULL(a.isRanking,0)=0


---- 分公司、一级营业部及二级营业部普通员工(29,12,13) ----
---- isRanking=1
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,d.Ranking AS Ranking
,(CASE WHEN c.TotalRankNum=1 THEN 'B'
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.2,0) THEN 'A' 
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 'B'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 'C'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0) THEN 'D'
END) as RankLevel,
(CASE WHEN c.TotalRankNum=1 THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.05,1) THEN 1.5
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1) and ROUND(c.TotalRankNum*0.05,1)*2 THEN 1.4
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*2 and ROUND(c.TotalRankNum*0.05,1)*3 THEN 1.3
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*3 and ROUND(c.TotalRankNum*0.2,0) THEN 1.25
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) THEN 1.1
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) THEN 1.0
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 0.9
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) THEN 0.8
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 0.7
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) THEN 0.6
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) and ROUND(c.TotalRankNum*1,0) THEN 0.5
END) as RankRatio
FROM pYear_Score_all a
LEFT join (select dbo.eFN_getdepid1st(Score_DepID) as Score_SupDepID,COUNT(Score_Type1) as TotalNum 
from pYear_Score where Score_Type1 IN (12,29,13) and Score_Status=9 GROUP BY dbo.eFN_getdepid1st(Score_DepID)) 
as b on dbo.eFN_getdepid1st(a.Score_DepID)=b.Score_SupDepID 
LEFT join (select dbo.eFN_getdepid1st(Score_DepID) as Score_SupDepID,COUNT(Score_Type1) as TotalRankNum 
from pYear_Score where Score_Type1 IN (12,29,13) and Score_Status=9 AND ISNULL(isRanking, 0)=1 GROUP BY dbo.eFN_getdepid1st(Score_DepID)) 
as c on dbo.eFN_getdepid1st(a.Score_DepID)=c.Score_SupDepID
LEFT join (select EID,rank() OVER (partition BY dbo.eFN_getDEPID1(Score_DepID) ORDER BY ScoreYear DESC) as Ranking 
from pYear_Score where Score_Type1 IN (12,29,13) and Score_Status=9 AND ISNULL(isRanking, 0)=1) 
as d on a.EID=d.EID
WHERE a.Score_Status=9 AND a.Score_Type1 IN (12,29,13) AND ISNULL(a.isRanking,0)=1
---- isRanking=NULL
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,NULL AS Ranking
,NULL as RankLevel,NULL as RankRatio
FROM pYear_Score_all a
LEFT join (select dbo.eFN_getdepid1st(Score_DepID) as Score_SupDepID,COUNT(Score_Type1) as TotalNum 
from pYear_Score where Score_Type1 IN (12,29,13) and Score_Status=9 GROUP BY dbo.eFN_getdepid1st(Score_DepID)) 
as b on dbo.eFN_getdepid1st(a.Score_DepID)=b.Score_SupDepID 
LEFT join (select dbo.eFN_getdepid1st(Score_DepID) as Score_SupDepID,COUNT(Score_Type1) as TotalRankNum 
from pYear_Score where Score_Type1 IN (12,29,13) and Score_Status=9 AND ISNULL(isRanking, 0)=1 GROUP BY dbo.eFN_getdepid1st(Score_DepID)) 
as c on dbo.eFN_getdepid1st(a.Score_DepID)=c.Score_SupDepID
WHERE a.Score_Status=9 AND a.Score_Type1 IN (12,29,13) AND ISNULL(a.isRanking,0)=0


---- 区域财务经理(17) ----
---- isRanking=1
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,d.Ranking AS Ranking
,(CASE WHEN c.TotalRankNum=1 THEN 'B' 
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.2,0) THEN 'A' 
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 'B'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 'C'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0) THEN 'D'
END) as RankLevel,
(CASE WHEN c.TotalRankNum=1 THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.05,1) THEN 1.5
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1) and ROUND(c.TotalRankNum*0.05,1)*2 THEN 1.4
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*2 and ROUND(c.TotalRankNum*0.05,1)*3 THEN 1.3
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*3 and ROUND(c.TotalRankNum*0.2,0) THEN 1.25
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) THEN 1.1
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) THEN 1.0
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 0.9
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) THEN 0.8
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 0.7
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) THEN 0.6
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) and ROUND(c.TotalRankNum*1,0) THEN 0.5
END) as RankRatio
FROM pYear_Score_all a
LEFT join (select COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1=17 and Score_Status=9) as b on a.Score_Type1=17 
LEFT join (select COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1=17 and Score_Status=9 AND ISNULL(isRanking, 0)=1) as c on a.Score_Type1=17 
LEFT join (select EID,rank() OVER (partition BY Score_Type1 ORDER BY ScoreYear DESC) as Ranking from pYear_Score where Score_Type1=17 and Score_Status=9 AND ISNULL(isRanking, 0)=1) as d on a.EID=d.EID
WHERE a.Score_Status=9 AND a.Score_Type1=17 AND ISNULL(a.isRanking,0)=1
---- isRanking=NULL
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,NULL AS Ranking
,NULL as RankLevel,NULL as RankRatio
FROM pYear_Score_all a
LEFT join (select COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1=17 and Score_Status=9) as b on a.Score_Type1=17 
LEFT join (select COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1=17 and Score_Status=9 AND ISNULL(isRanking, 0)=1) as c on a.Score_Type1=17 
WHERE a.Score_Status=9 AND a.Score_Type1=17 AND ISNULL(a.isRanking,0)=0


---- 综合会计(19) ----
---- isRanking=1
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,d.Ranking AS Ranking
,(CASE WHEN c.TotalRankNum=1 THEN 'B' 
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.2,0) THEN 'A' 
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 'B'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 'C'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0) THEN 'D'
END) as RankLevel,
(CASE WHEN c.TotalRankNum=1 THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.05,1) THEN 1.5
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1) and ROUND(c.TotalRankNum*0.05,1)*2 THEN 1.4
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*2 and ROUND(c.TotalRankNum*0.05,1)*3 THEN 1.3
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*3 and ROUND(c.TotalRankNum*0.2,0) THEN 1.25
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) THEN 1.1
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) THEN 1.0
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 0.9
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) THEN 0.8
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 0.7
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) THEN 0.6
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) and ROUND(c.TotalRankNum*1,0) THEN 0.5
END) as RankRatio
FROM pYear_Score_all a
LEFT join (select COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1=19 and Score_Status=9) as b on a.Score_Type1=19 
LEFT join (select COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1=19 and Score_Status=9 AND ISNULL(isRanking, 0)=1) as c on a.Score_Type1=19
LEFT join (select EID,rank() OVER (partition BY Score_Type1 ORDER BY ScoreYear DESC) as Ranking from pYear_Score where Score_Type1=19 and Score_Status=9 AND ISNULL(isRanking, 0)=1) as d on a.EID=d.EID
WHERE a.Score_Status=9 AND a.Score_Type1=19 AND ISNULL(a.isRanking,0)=1
---- isRanking=NULL
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,NULL AS Ranking
,NULL as RankLevel,NULL as RankRatio
FROM pYear_Score_all a
LEFT join (select COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1=19 and Score_Status=9) as b on a.Score_Type1=19 
LEFT join (select COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1=19 and Score_Status=9 AND ISNULL(isRanking, 0)=1) as c on a.Score_Type1=19
WHERE a.Score_Status=9 AND a.Score_Type1=19 AND ISNULL(a.isRanking,0)=0


---- 营业部合规风控专员(14) ----
---- isRanking=1
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,d.Ranking AS Ranking
,(CASE WHEN c.TotalRankNum=1 THEN 'B' 
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.2,0) THEN 'A' 
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 'B'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 'C'
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0) THEN 'D'
END) as RankLevel,
(CASE WHEN c.TotalRankNum=1 THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between 0 and ROUND(c.TotalRankNum*0.05,1) THEN 1.5
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1) and ROUND(c.TotalRankNum*0.05,1)*2 THEN 1.4
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*2 and ROUND(c.TotalRankNum*0.05,1)*3 THEN 1.3
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.05,1)*3 and ROUND(c.TotalRankNum*0.2,0) THEN 1.25
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) THEN 1.2
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) THEN 1.1
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.2,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) THEN 1.0
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.3,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) THEN 0.9
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.4,0) and ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) THEN 0.8
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*0.2,0)+ROUND(c.TotalRankNum*0.55,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) THEN 0.7
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.1,0) and ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) THEN 0.6
WHEN c.TotalRankNum>1 and d.Ranking between ROUND(c.TotalRankNum*1,0)-ROUND(c.TotalRankNum*0.05,0) and ROUND(c.TotalRankNum*1,0) THEN 0.5
END) as RankRatio
FROM pYear_Score_all a
LEFT join (select COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1=14 and Score_Status=9) as b on a.Score_Type1=14 
LEFT join (select COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1=14 and Score_Status=9 AND ISNULL(isRanking, 0)=1) as c on a.Score_Type1=14
LEFT join (select EID,rank() OVER (partition BY Score_Type1 ORDER BY ScoreYear DESC) as Ranking from pYear_Score where Score_Type1=14 and Score_Status=9 AND ISNULL(isRanking, 0)=1) as d on a.EID=d.EID
WHERE a.Score_Status=9 AND a.Score_Type1=14 AND ISNULL(a.isRanking,0)=1
---- isRanking=NULL
UNION
SELECT a.EID as EID,a.Score_DepID as Score_DepID,a.Score_Type1 as Score_Type1,b.TotalNum as TotalNum,c.TotalRankNum AS TotalRankNum,a.isRanking as isRanking,NULL AS Ranking
,NULL as RankLevel,NULL as RankRatio
FROM pYear_Score_all a
LEFT join (select COUNT(Score_Type1) as TotalNum from pYear_Score where Score_Type1=14 and Score_Status=9) as b on a.Score_Type1=14 
LEFT join (select COUNT(Score_Type1) as TotalRankNum from pYear_Score where Score_Type1=14 and Score_Status=9 AND ISNULL(isRanking, 0)=1) as c on a.Score_Type1=14
WHERE a.Score_Status=9 AND a.Score_Type1=14 AND ISNULL(a.isRanking,0)=0