-- pVW_pYear_ScoreEachN
-- 4-总部普通员工
select a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.kpidepidyy=b.kpidepidyy and a.Score_Type1=4 and b.Score_Type1=4 and a.EID<>b.EID
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

-- 11-子公司普通员工
UNION
select a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.kpidepidyy=b.kpidepidyy and a.Score_Type1=11 and b.Score_Type1=11 and a.EID<>b.EID
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

-- 33-一级分支机构普通员工
UNION
select a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.kpidepidyy=b.kpidepidyy and a.Score_Type1=33 and b.Score_Type1=33 and a.EID<>b.EID
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

-- 34-二级分支机构普通员工
UNION
select a.EID as EID,a.Score_Type1 as Score_Type1,b.EID as Score_EID
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.kpidepidyy=b.kpidepidyy and a.Score_Type1=34 and b.Score_Type1=34 and a.EID<>b.EID
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)