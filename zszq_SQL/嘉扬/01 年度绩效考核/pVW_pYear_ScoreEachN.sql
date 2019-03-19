-- pVW_pYear_ScoreEachN
-- 4-总部普通员工
select a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.KPIDepID=b.KPIDepID and a.perole=4 and b.perole=4 and a.EID<>b.EID
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)

-- 11-子公司普通员工
UNION
select a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.KPIDepID=b.KPIDepID and a.perole=11 and b.perole=11 and a.EID<>b.EID
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)


-- 29-分公司普通员工
UNION
select a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.KPIDepID=b.KPIDepID and a.perole=29 and b.perole=29 and a.EID<>b.EID
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)


-- 12-一级营业部普通员工
UNION
select a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.KPIDepID=b.KPIDepID and a.perole=12 and b.perole=12 and a.EID<>b.EID
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)


-- 13-二级营业部普通员工
UNION
select a.EID as EID,a.perole as Score_Type1,b.EID as Score_EID
from pEmployee_register a,pEmployee_register b,eEmployee c,eEmployee d
where a.KPIDepID=b.KPIDepID and a.perole=13 and b.perole=13 and a.EID<>b.EID
and a.EID=c.EID and b.EID=d.EID and c.Status not in (4,5) and d.Status not in (4,5)