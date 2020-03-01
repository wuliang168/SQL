-- pVW_eBG_Change

select a.EID as EID,b.CompID as CompID,b.DepID as DepID,b.DepID1st as DepID1st,b.DepID2nd as DepID2nd,b.JobTitle as JobTitle,
1 as ChangeType
from eBG_Education_Change a,pVW_Employee b
where a.EID=b.EID

UNION
select a.EID as EID,b.CompID as CompID,b.DepID as DepID,b.DepID1st as DepID1st,b.DepID2nd as DepID2nd,b.JobTitle as JobTitle,
2 as ChangeType
from eBG_Working_Change a,pVW_Employee b
where a.EID=b.EID

UNION
select a.EID as EID,b.CompID as CompID,b.DepID as DepID,b.DepID1st as DepID1st,b.DepID2nd as DepID2nd,b.JobTitle as JobTitle,
3 as ChangeType
from eBG_Family_Change a,pVW_Employee b
where a.EID=b.EID

UNION
select a.EID as EID,b.CompID as CompID,b.DepID as DepID,b.DepID1st as DepID1st,b.DepID2nd as DepID2nd,b.JobTitle as JobTitle,
4 as ChangeType
from eBG_Emergency_Change a,pVW_Employee b
where a.EID=b.EID