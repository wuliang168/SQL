-- pVW_pYear_ScoreEachSumN
-- 4-总部普通员工
select a.EID,
SUM(a.ScoreTotal) AS EachNSUM,COUNT(a.ScoreTotal) as EachNCOUNT,AVG(a.ScoreTotal) AS EachNAVG,b.Weight1 as EachNWeight
from pYear_ScoreEachN a,pYear_Score b
where a.Score_Type1=4 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,b.Weight1

-- 11-子公司普通员工
UNION
select a.EID,
SUM(a.ScoreTotal) AS EachNSUM,COUNT(a.ScoreTotal) as EachNCOUNT,AVG(a.ScoreTotal) AS EachNAVG,b.Weight1 as EachNWeight
from pYear_ScoreEachN a,pYear_Score b
where a.Score_Type1=11 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,b.Weight1

-- 33-一级分支机构普通员工
UNION
select a.EID,
SUM(a.ScoreTotal) AS EachNSUM,COUNT(a.ScoreTotal) as EachNCOUNT,AVG(a.ScoreTotal) AS EachNAVG,b.Weight1 as EachNWeight
from pYear_ScoreEachN a,pYear_Score b
where a.Score_Type1=33 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,b.Weight1

-- 34-二级分支机构普通员工
UNION
select a.EID,
SUM(a.ScoreTotal) AS EachNSUM,COUNT(a.ScoreTotal) as EachNCOUNT,AVG(a.ScoreTotal) AS EachNAVG,b.Weight1 as EachNWeight
from pYear_ScoreEachN a,pYear_Score b
where a.Score_Type1=34 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,b.Weight1