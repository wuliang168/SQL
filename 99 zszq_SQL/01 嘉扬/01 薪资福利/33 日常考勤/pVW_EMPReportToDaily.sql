-- pVW_EMPReportToDaily
---- 总部
------ 不含法律合规部
select a.EID as EID,dbo.eFN_getdepid1st(a.DepID) as Dep1st,dbo.eFN_getdepid2nd(a.DepID) as Dep2nd,
ISNULL(dbo.eFN_getdepdirector(dbo.eFN_getdepid1st(a.DepID)),dbo.eFN_getdepdirector2(dbo.eFN_getdepid1st(a.DepID))) as ReportToDaily
from eEmployee a
where dbo.eFN_getdeptype(a.DepID)=1 and a.status not in (4,5) and a.DepID not in (780,349,785)
and dbo.eFN_getdepid1st(a.DepID)<>737 and EID not in (1269,1319)
------ 法律合规部(737)(邱星敏:1177)
UNION
select a.EID as EID,dbo.eFN_getdepid1st(a.DepID) as Dep1st,dbo.eFN_getdepid2nd(a.DepID) as Dep2nd,1177 as ReportToDaily
from eEmployee a
where dbo.eFN_getdeptype(a.DepID)=1 and a.status not in (4,5) and a.DepID not in (780,349,785)
and (dbo.eFN_getdepid1st(a.DepID)=737 or EID in (1269,1319))
---- 资管
UNION
select a.EID as EID,dbo.eFN_getdepid1st(a.DepID) as Dep1st,dbo.eFN_getdepid2nd(a.DepID) as Dep2nd,
ISNULL(dbo.eFN_getdepdirector(dbo.eFN_getdepid1st(a.DepID)),dbo.eFN_getdepdirector2(dbo.eFN_getdepid1st(a.DepID))) as ReportToDaily
from eEmployee a
where a.status not in (4,5) and a.CompID=13
---- 资本
UNION
select a.EID as EID,dbo.eFN_getdepid1st(a.DepID) as Dep1st,dbo.eFN_getdepid2nd(a.DepID) as Dep2nd,dbo.eFN_getdepdirector2(dbo.eFN_getdepid1st(a.DepID)) as ReportToDaily
from eEmployee a
where a.status not in (4,5) and a.CompID=12
---- 分支机构
UNION
select a.EID as EID,dbo.eFN_getdepid1st(a.DepID) as Dep1st,dbo.eFN_getdepid2nd(a.DepID) as Dep2nd,
dbo.eFN_getdepdirector(a.DepID) as ReportToDaily
from eEmployee a
where dbo.eFN_getdeptype(a.DepID) in (2,3) and a.status not in (4,5)