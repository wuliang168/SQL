-- pVW_pMonthKPIReportTo

---- 考核部门与本部门相同(主要针对合规风控)
select a.EID as EID,b.Badge as Badge,B.Name as Name,b.CompID as CompID,
dbo.eFN_getdepid1st(b.DepID) as DepID1st,dbo.eFN_getdepid2nd(b.DepID) as DepID2nd,a.KPIDepID as KPIDepID,a.jobid as JobID,
(case 
-- 二级部门，且非二级部门负责人
when dbo.eFN_getdepid2nd(b.DepID)=b.DepID and a.EID<>ISNULL(dbo.eFN_getdepdirector(b.DepID),0) 
then ISNULL(ISNULL(dbo.eFN_getdepdirector(b.DepID),dbo.eFN_getdepdirector(dbo.eFN_getdepid1st(b.DepID))),dbo.eFN_getdepdirector2(dbo.eFN_getdepid1st(b.DepID)))
-- 二级部门，且是二级部门负责人
when dbo.eFN_getdepid2nd(b.DepID)=b.DepID and a.EID=ISNULL(dbo.eFN_getdepdirector(b.DepID),0) 
then ISNULL(dbo.eFN_getdepdirector(dbo.eFN_getdepid1st(b.DepID)),dbo.eFN_getdepdirector2(dbo.eFN_getdepid1st(b.DepID)))
-- 一级部门，且非一级部门负责人
when dbo.eFN_getdepid1st(b.DepID)=b.DepID and a.EID<>ISNULL(dbo.eFN_getdepdirector(b.DepID),0) 
then ISNULL(dbo.eFN_getdepdirector(b.DepID),dbo.eFN_getdepdirector2(b.DepID))
-- 一级部门，且是一级部门负责人
else dbo.eFN_getdepdirector2(dbo.eFN_getdepid1st(b.DepID)) 
end) as KPIReportTo,a.pStatus as pStatus
from pEmployee_Register a,pVW_Employee b
where a.EID=b.EID and a.KPIDepID<>737

---- 考核部门与本部门不相同(主要针对合规风控)
UNION
select a.EID as EID,b.Badge as Badge,B.Name as Name,b.CompID as CompID,
dbo.eFN_getdepid1st(b.DepID) as DepID1st,dbo.eFN_getdepid2nd(b.DepID) as DepID2nd,a.KPIDepID as KPIDepID,a.jobid as JobID,
dbo.eFN_getdepdirector(a.DepID) as KPIReportTo,a.pStatus as pStatus
from pEmployee_Register a,pVW_Employee b
where a.EID=b.EID and a.KPIDepID=737