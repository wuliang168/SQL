-- pVW_PensionUpdate

-- 非投理顾员工
select a.IsPension as IsPension,b.Name as Name,d.Certno as Identification,b.CompID as CompID,b.DepID1st as DepID1,b.DepID2nd as DepID2,
b.DepType as DepType,b.JobTitle as JobTitle,b.Status as Status,b.JoinDate as JoinDate,b.LeaDate as LeaDate,c.SalaryPayID as SalaryPayID,
b.JobXorder as Xorder
from pPensionUpdatePerEmp a,pVW_Employee b,pEmployeeEmolu c,eDetails d
where a.EID=b.EID and a.EID=C.EID and a.EID=d.EID

-- 投理顾员工
UNION
select a.IsPension as IsPension,a.Name as Name,a.Identification as Identification,11 as CompID,a.SupDepID as DepID1,a.DepID as DepID2,b.DepType as DepTyep,
(select JobAbbr from oJob where JobID=a.JobID) as JobTitle,a.Status as Status,a.JoinDate as JoinDate,c.LeaveDate as LeaDate,c.SalaryPayID as SalaryPayID,b.Xorder*10000+4030 as Xorder
from pPensionUpdatePerSDM a,oDepartment b,pSalesDepartMarketerEmolu c
where ISNULL(a.DepID,a.SupDepID)=b.DepID and a.Identification=c.Identification