-- pVW_pYear_ScoreResult_All

---- pYear_Score
select distinct EID,pYear_ID,Score_Status,Score_Type1,Score_Type2,Score_DepID,
ScoreEach,ScoreSTG1,ScoreSTG2,ScoreSTG3,ScoreSTG4,ScoreSTG5,ScoreCompl,ScoreParty,Weight1,Weight2,Weight3,Modulus,
TotalNum,TotalRankNum,ScoreYear,isRanking,Ranking,RankLevel,Remark
from pYear_Score
where Score_Status=9

---- pYear_Score_all
UNION
select distinct EID,pYear_ID,Score_Status,Score_Type1,Score_Type2,Score_DepID,
ScoreEach,ScoreSTG1,ScoreSTG2,ScoreSTG3,ScoreSTG4,ScoreSTG5,ScoreCompl,ScoreParty,Weight1,Weight2,Weight3,Modulus,
TotalNum,TotalRankNum,ScoreYear,isRanking,Ranking,RankLevel,Remark
from pYear_Score_all
where Score_Status=9