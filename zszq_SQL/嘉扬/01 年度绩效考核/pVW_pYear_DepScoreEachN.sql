-- pVW_pYear_DepScoreEachN
select pYear_ID as pYear_ID,Score_DepID as Score_DepID,COUNT(Score_DepID) as TotalNum,COUNT(Submit) as TotalScoreEachNNum
from pYear_Score
where Score_Status=1 and Score_Type1 in (4,11,29,12,13)
group by pYear_ID,Score_DepID