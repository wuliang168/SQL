-- pVW_PensionUpdate
-- 非投理顾员工
select a.IsPension as IsPension,b.Name as Name,c.Certno as Identification,b.CompID as CompID,dbo.eFN_getdepid1st(b.DepID) as DepID1,dbo.eFN_getdepid2nd(b.DepID) as DepID2,
dbo.eFN_getdepid3th(b.DepID) as DepID3,d.DepType as DepType,b.JobID as JobID,b.Status as Status,e.JoinDate as JoinDate,e.LeaDate as LeaDate,a.SalaryPayID as SalaryPayID,
f.Xorder as Xorder
from pEmployeeEmolu a,eEmployee b,eDetails c,oDepartment d,eStatus e,oJob f
where a.EID=b.EID and a.EID=c.EID and b.DepID=d.DepID and a.EID=e.EID and b.JobID=f.JobID

-- 投理顾员工
UNION
select a.IsPension as IsPension,a.Name as Name,a.Identification as Identification,11 as CompID,a.SupDepID as DepID1,a.DepID as DepID2,NULL as DepID3,b.DepType as DepTyep
,a.JobID as JobID,a.Status as Status,a.JoinDate as JoinDate,a.LeaveDate as LeaDate,a.SalaryPayID as SalaryPayID,b.Xorder*10000+4030 as Xorder
from pSalesDepartMarketerEmolu a,oDepartment b
where ISNULL(a.DepID,a.SupDepID)=b.DepID