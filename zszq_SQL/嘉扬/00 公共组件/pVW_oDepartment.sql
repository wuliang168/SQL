-- pVW_oDepartment

select a.DepID as DepID,dbo.eFN_getdepid1st(a.DepID) as DepID1st,dbo.eFN_getdepid2nd(DepID) as DepID2nd,a.Title as Title,a.DepAbbr as DepAbbr,a.DepType as DepType,
a.DepGrade as DepGrade,a.Director as Director,a.Director2 as Director2,
(case when a.DepType in (2,3) then a.Director else (select ISNULL(Director,Director2) from oDepartment where DepID=dbo.eFN_getdepid1st(a.DepID)) end) as KPIYYReportTo,
a.isDisabled as isDisabled,a.DepEmp as DepEmp,a.depKpi as DepKPI,a.DepPensionContact as DepPensionContact,a.DepSalaryContact as DepSalaryContact,a.DepInsHFContact as DepInsHFContact,a.xOrder as xOrder
from oDepartment a