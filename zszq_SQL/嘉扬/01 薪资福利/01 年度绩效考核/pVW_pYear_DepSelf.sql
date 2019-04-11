-- pVW_pYear_DepSelf
select pYear_ID as pYear_ID,Score_DepID as Score_DepID,COUNT(Score_DepID) as TotalNum,COUNT(Submit) as TotalSelfNum
from pYear_Score
where Score_Status=0
group by pYear_ID,Score_DepID