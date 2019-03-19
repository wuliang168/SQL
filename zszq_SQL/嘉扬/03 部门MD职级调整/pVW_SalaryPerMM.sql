select a.EID as EID,b.Badge as Badge,b.Name as Name,b.DepID as DepID,dbo.eFN_getdepid1(b.DepID) as SupDepID,
b.JobID as JobID,a.MDID as MDID,a.SalaryPerMM as SalaryPerMM,c.xorder as xOrderDep,d.xorder as xOrderJob
from pEmployeeEmolu as a
inner join eemployee as b on a.EID=b.EID
inner join odepartment as c on b.DepID=c.DepID
inner join oJob as d on b.JobID=d.JobID
where b.Status not in (4,5)