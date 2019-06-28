-- pVW_pYear_Score_bk
---- pYear_Score
select EID,pYear_ID,Score_Status,Score_Type1,Score_Type2,Score_EID,Score_DepID,Score1,Score2,Score3,Score4,Score5,Score6,Score7,Score8,
ScoreTotal,ScoreEach,ScoreSTG1,ScoreSTG2,ScoreSTG3,ScoreSTG4,ScoreSTG5,ScoreCompl,ScoreParty,Weight1,Weight2,Weight3,Modulus,
TotalNum,TotalRankNum,ScoreYear,isRanking,Ranking,RankLevel,Remark
from pYear_Score

---- pYear_Score_bk
UNION
select EID,pYear_ID,Score_Status,Score_Type1,Score_Type2,Score_EID,Score_DepID,Score1,Score2,Score3,Score4,Score5,Score6,Score7,Score8,
ScoreTotal,ScoreEach,ScoreSTG1,ScoreSTG2,ScoreSTG3,ScoreSTG4,ScoreSTG5,ScoreCompl,ScoreParty,Weight1,Weight2,Weight3,Modulus,
TotalNum,TotalRankNum,ScoreYear,isRanking,Ranking,RankLevel,Remark
from pYear_Score_bk