-- pVW_pMonthKPIReportTo

select b.Badge as Badge,B.Name as Name,b.CompID as CompID,
dbo.eFN_getdepid1st(b.DepID) as DepID1st,dbo.eFN_getdepid2nd(b.DepID) as DepID2nd,a.KPIDepID,
a.jobid,ISNULL(c.Director,c.Director2) as KPIReportTo
from pEmployee_Register a,pVW_Employee b,oDepartment c
where a.EID=b.EID and a.kpidepid=c.DepID