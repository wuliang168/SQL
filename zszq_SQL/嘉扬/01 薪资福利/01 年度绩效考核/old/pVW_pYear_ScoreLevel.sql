-------- pVW_pYear_ScoreLevel --------
-- TotalRankNum: =1
select a.eid as EID,a.KpiDep as DEPID,a.ranking as RANKING,
'B' AS pYearLevel,
a.totalRankNum as TotalRankNum
from pYear_Score a
where a.totalranknum=1

-- TotalRankNum: >1
UNION
select a.eid as EID,a.KpiDep as DEPID,a.ranking as RANKING,
CASE 
WHEN a.ranking between 0 and ROUND(a.totalranknum*0.2,0) THEN 'A' 
WHEN a.ranking between ROUND(a.totalranknum*0.2,0) and ROUND(a.totalranknum*0.2,0)+ROUND(a.totalranknum*0.4,0) THEN 'B'
WHEN a.ranking between ROUND(a.totalranknum*0.2,0)+ROUND(a.totalranknum*0.4,0) and ROUND(a.totalranknum*1,0)-ROUND(a.totalranknum*0.1,0) THEN 'C'
WHEN a.ranking between ROUND(a.totalranknum*1,0)-ROUND(a.totalranknum*0.1,0) and ROUND(a.totalranknum*1,0) THEN 'D'
END as pYearLevel,
a.totalRankNum as TotalRankNum
from pYear_Score a
where a.totalranknum > 1