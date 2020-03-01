-- pVW_PensionUpdate

-- 非投理顾员工
select a.PensionYear as PensionYear,a.IsPension as IsPension,a.EID as EID,a.BID as BID,b.Name as Name,b.identification as Identification,
b.CompID as CompID,b.DepID1st as DepID1,b.DepID2nd as DepID2,b.DepType as DepType,b.JobTitle as JobTitle,b.Status as Status,
b.JoinDate as JoinDate,b.LeaDate as LeaDate,c.SalaryPayID as SalaryPayID,b.JobXorder as Xorder,a.IsSubmit as IsSubmit,a.IsClosed as IsClosed
from pPensionUpdatePerEmp a,pVW_Employee b,pEMPSalary c
where ISNULL(a.EID,a.BID)=ISNULL(b.EID,b.BID) and ISNULL(a.EID,a.BID)=ISNULL(C.EID,C.BID)