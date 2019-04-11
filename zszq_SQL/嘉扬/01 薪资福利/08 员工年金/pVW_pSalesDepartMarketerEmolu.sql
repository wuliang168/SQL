-- pVW_pSalesDepartMarketerEmolu
SELECT a.id as ID,a.IsPension as IsPension,a.Name as Name,a.Gender as Gender,a.Identification as Identification,
a.CompID as CompID,a.SupDepID as SupDepID,a.DepID as DepID,a.JobID as JobID,a.JoinDate as JoinDate,
a.LeaveDate as LeaveDate,a.Status as Status,a.AdminID as AdminID,a.SalaryPayID as SalaryPayID,
a.GrpPensionYearRest as GrpPensionYearRest,ROUND(a.GrpPensionYearRest/4,2) as EmpPensionYearRest,
a.GrpPensionTotal as GrpPensionTotal,a.EmpPensionTotal as EmpPensionTotal,a.GrpPensionFrozen as GrpPensionFrozen,a.Remark as Remark
FROM pSalesDepartMarketerEmolu a