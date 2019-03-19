-- pVW_pYear_ScoreEachSumN
-- 4-总部普通员工
select a.EID,
SUM(a.ScoreTotal) AS EachNSubSUM,COUNT(a.ScoreTotal) as EachNSubCOUNT,AVG(a.ScoreTotal) AS EachNSubAVG,b.Weight1 as EachNWeight
from pYear_ScoreEachN a,pYear_Score b
where a.Score_Type1=4 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,b.Weight1

-- 11-子公司普通员工
UNION
select a.EID,
SUM(a.ScoreTotal) AS EachNSubSUM,COUNT(a.ScoreTotal) as EachNSubCOUNT,AVG(a.ScoreTotal) AS EachNSubAVG,b.Weight1 as EachNWeight
from pYear_ScoreEachN a,pYear_Score b
where a.Score_Type1=11 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,b.Weight1

-- 29-分公司普通员工
UNION
select a.EID,
SUM(a.ScoreTotal) AS EachNSubSUM,COUNT(a.ScoreTotal) as EachNSubCOUNT,AVG(a.ScoreTotal) AS EachNSubAVG,b.Weight1 as EachNWeight
from pYear_ScoreEachN a,pYear_Score b
where a.Score_Type1=29 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,b.Weight1

-- 12-一级营业部普通员工
UNION
select a.EID,
SUM(a.ScoreTotal) AS EachNSubSUM,COUNT(a.ScoreTotal) as EachNSubCOUNT,AVG(a.ScoreTotal) AS EachNSubAVG,b.Weight1 as EachNWeight
from pYear_ScoreEachN a,pYear_Score b
where a.Score_Type1=12 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,b.Weight1

-- 13-二级营业部普通员工
UNION
select a.EID,
SUM(a.ScoreTotal) AS EachNSubSUM,COUNT(a.ScoreTotal) as EachNSubCOUNT,AVG(a.ScoreTotal) AS EachNSubAVG,b.Weight1 as EachNWeight
from pYear_ScoreEachN a,pYear_Score b
where a.Score_Type1=13 and a.EID=b.EID and b.Score_Status=1 and ISNULL(a.Submit,0)=1
group by a.EID,b.Weight1