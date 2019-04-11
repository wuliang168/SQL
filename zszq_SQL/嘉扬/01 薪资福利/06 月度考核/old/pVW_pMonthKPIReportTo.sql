-- pVW_pMonthKPIReportTo

select a.EID as EID,b.Badge as Badge,B.Name as Name,b.CompID as CompID,
dbo.eFN_getdepid1st(b.DepID) as DepID1st,dbo.eFN_getdepid2nd(b.DepID) as DepID2nd,a.KPIDepID as KPIDepID,
a.jobid as JobID,ISNULL(c.Director,c.Director2) as KPIReportTo,a.pStatus as pStatus
from pEmployee_Register a,pVW_Employee b,oDepartment c
where a.EID=b.EID and a.kpidepid=c.DepID and c.DepID not in (359)

-- 风险管理部(359)
UNION
select a.EID as EID,b.Badge as Badge,B.Name as Name,b.CompID as CompID,
dbo.eFN_getdepid1st(b.DepID) as DepID1st,dbo.eFN_getdepid2nd(b.DepID) as DepID2nd,a.KPIDepID as KPIDepID,a.jobid as JobID,
(case when dbo.eFN_getdepid2nd(b.DepID)=b.DepID and a.EID<>dbo.eFN_getdepdirector(b.DepID) then dbo.eFN_getdepdirector(b.DepID) 
when dbo.eFN_getdepid2nd(b.DepID)=b.DepID and a.EID=dbo.eFN_getdepdirector(b.DepID) then dbo.eFN_getdepdirector(dbo.eFN_getdepid1st(b.DepID))  
else dbo.eFN_getdepdirector2(dbo.eFN_getdepid1st(b.DepID)) end) as KPIReportTo,a.pStatus as pStatus
from pEmployee_Register a,pVW_Employee b
where a.EID=b.EID and a.kpidepid=359