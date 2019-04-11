-- pVW_PensionPerMM
-- 非投理顾员工
---- 未关闭数据
select a.PensionMonth as PensionMonth,b.Name as Name,d.Certno as Identification,b.CompID as CompID,dbo.eFN_getdepid1st(b.DepID) as DepID1,dbo.eFN_getdepid2nd(b.DepID) as DepID2,
dbo.eFN_getdepid3th(b.DepID) as DepID3,e.DepType as DepType,b.JobID as JobID,b.Status as Status,c.SalaryPayID as SalaryPayID,a.GrpPensionPerMM as GrpPensionPerMM,
a.EmpPensionPerMMBTax as EmpPensionPerMMBTax,a.EmpPensionPerMMATax as EmpPensionPerMMATax,a.GrpPensionMonthTotal as GrpPensionMonthTotal,a.GrpPensionMonthRest as GrpPensionMonthRest,
a.EmpPensionMonthTotal as EmpPensionMonthTotal,a.EmpPensionMonthRest as EmpPensionMonthRest,a.Remark as Remark
from pEmpPensionPerMM_register a,eEmployee b,pEmployeeEmolu c,eDetails d,oDepartment e
where a.EID=b.EID and a.EID=c.EID and a.EID=d.EID and b.DepID=e.DepID
---- 已关闭数据
UNION
select a.PensionMonth as PensionMonth,b.Name as Name,d.Certno as Identification,b.CompID as CompID,dbo.eFN_getdepid1st(b.DepID) as DepID1,dbo.eFN_getdepid2nd(b.DepID) as DepID2,
dbo.eFN_getdepid3th(b.DepID) as DepID3,e.DepType as DepType,b.JobID as JobID,b.Status as Status,c.SalaryPayID as SalaryPayID,a.GrpPensionPerMM as GrpPensionPerMM,
a.EmpPensionPerMMBTax as EmpPensionPerMMBTax,a.EmpPensionPerMMATax as EmpPensionPerMMATax,a.GrpPensionMonthTotal as GrpPensionMonthTotal,a.GrpPensionMonthRest as GrpPensionMonthRest,
a.EmpPensionMonthTotal as EmpPensionMonthTotal,a.EmpPensionMonthRest as EmpPensionMonthRest,a.Remark as Remark
from pEmpPensionPerMM_all a,eEmployee b,pEmployeeEmolu c,eDetails d,oDepartment e
where a.EID=b.EID and a.EID=c.EID and a.EID=d.EID and b.DepID=e.DepID

-- 投理顾员工
---- 未关闭数据
UNION
select a.PensionMonth as PensionMonth,a.Name as Name,a.Identification as Identification,11 as CompID,a.SupDepID as DepID1,a.DepID as DepID2,NULL as DepID3,b.DepType as DepTyep,
a.JobID as JobID,a.Status as Status,a.SalaryPayID as SalaryPayID,a.GrpPensionPerMM as GrpPensionPerMM,a.EmpPensionPerMMBTax as EmpPensionPerMMBTax,
a.EmpPensionPerMMATax as EmpPensionPerMMATax,a.GrpPensionMonthTotal as GrpPensionMonthTotal,a.GrpPensionMonthRest as GrpPensionMonthRest,
a.EmpPensionMonthTotal as EmpPensionMonthTotal,a.EmpPensionMonthRest as EmpPensionMonthRest,a.Remark as Remark
from pSDMarketerPensionPerMM_register a,oDepartment b
where ISNULL(a.DepID,a.SupDepID)=b.DepID
---- 已关闭数据
UNION
select a.PensionMonth as PensionMonth,a.Name as Name,a.Identification as Identification,11 as CompID,a.SupDepID as DepID1,a.DepID as DepID2,NULL as DepID3,b.DepType as DepTyep,
a.JobID as JobID,a.Status as Status,a.SalaryPayID as SalaryPayID,a.GrpPensionPerMM as GrpPensionPerMM,a.EmpPensionPerMMBTax as EmpPensionPerMMBTax,
a.EmpPensionPerMMATax as EmpPensionPerMMATax,a.GrpPensionMonthTotal as GrpPensionMonthTotal,a.GrpPensionMonthRest as GrpPensionMonthRest,
a.EmpPensionMonthTotal as EmpPensionMonthTotal,a.EmpPensionMonthRest as EmpPensionMonthRest,a.Remark as Remark
from pSDMarketerPensionPerMM_all a,oDepartment b
where ISNULL(a.DepID,a.SupDepID)=b.DepID