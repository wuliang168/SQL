-------- pVW_pYear_ScoreRankingRule --------

---- 排名组数>5且排名<20% 或者 排名组数<5且考核评分>95 ----
select pYear_ID,DepScoreType,DepScoreTypeCount,0.3 as RankLevA,0.4 as RankLevB,0.3 as RankLevC,NULL as RankLevD,NULL as RankLevE
from pYear_DepScore a
where (DepScoreTypeCount>5 and DepScoreRanking*1.00/DepScoreTypeCount<0.2)
or (DepScoreTypeCount<5 and DepScoreYear>95)
---- 排名组数>5且排名>20%且<90% 或者 排名组数<5且考核评分<95且>85 或者 专项排名组 ----
------ 业务部门
UNION
select pYear_ID,DepScoreType,DepScoreTypeCount,0.2 as RankLevA,0.4 as RankLevB,0.3 as RankLevC,0.1 as RankLevD,NULL as RankLevE
from pYear_DepScore a
where ((DepScoreTypeCount>5 and DepScoreRanking*1.00/DepScoreTypeCount<0.9 and DepScoreRanking*1.00/DepScoreTypeCount>0.2)
or (DepScoreTypeCount<5 and DepScoreYear>85 and DepScoreYear<95)) and DepScoreType=1
------ 职能部门
UNION
select pYear_ID,DepScoreType,DepScoreTypeCount,0.2 as RankLevA,0.4 as RankLevB,0.3 as RankLevC,0.2 as RankLevD,NULL as RankLevE
where ((DepScoreTypeCount>5 and DepScoreRanking*1.00/DepScoreTypeCount<0.9 and DepScoreRanking*1.00/DepScoreTypeCount>0.2)
or (DepScoreTypeCount<5 and DepScoreYear>85 and DepScoreYear<95)) and DepScoreType=2
------ 专项排名组
UNION
select pYear_ID,DepScoreType,DepScoreTypeCount,0 as RankLevA,0.4 as RankLevB,0.5 as RankLevC,0.1 as RankLevD,NULL as RankLevE
from pYear_DepScore a
where DepScoreType=3
---- 排名组数>5且排名>90% 或者 排名组数<5且考核评分<85 ----
------ 业务部门
UNION
select pYear_ID,DepScoreType,DepScoreTypeCount,0 as RankLevA,0.4 as RankLevB,0.4 as RankLevC,0.2 as RankLevD,NULL as RankLevE
from pYear_DepScore a
where ((DepScoreTypeCount>5 and DepScoreRanking*1.00/DepScoreTypeCount>0.9)
or (DepScoreTypeCount<5 and DepScoreYear<85)) and DepScoreType=1
------ 职能部门
UNION
select pYear_ID,DepScoreType,DepScoreTypeCount,0 as RankLevA,0.4 as RankLevB,0.5 as RankLevC,0.1 as RankLevD,NULL as RankLevE
from pYear_DepScore a
where ((DepScoreTypeCount>5 and DepScoreRanking*1.00/DepScoreTypeCount>0.9)
or (DepScoreTypeCount<5 and DepScoreYear<85)) and DepScoreType=1