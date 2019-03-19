-- 员工明细
select a.Date as Date,d.DepAbbr as DepAbbr,b.SalaryPayID as SalaryPayID,a.EID as EID,c.Name as Name,a.HousingFundEMP as HousingFundEMP,
a.EndowInsEMP as EndowInsEMP,a.MedicalInsEMP as MedicalInsEMP,a.UnemployInsEMP as UnemployInsEMP,a.FundInsEMPPlusTotal as FundInsEMPPlusTotal,
(ISNULL(a.HousingFundEMP,0)+ISNULL(a.EndowInsEMP,0)+ISNULL(a.MedicalInsEMP,0)+ISNULL(a.UnemployInsEMP,0)+ISNULL(a.FundInsEMPPlusTotal,0)) as FundInsEMP,
b.InsuranceLoc as InsuranceLoc,b.HousingFundLoc as HousingFundLoc,d.xOrder as DepxOrder,0 as NamexOrder
from pEmployeeEmolu_all a,pEmployeeEmolu b,eEmployee c,oDepartment d
where a.EID=b.EID and a.EID=c.EID and dbo.eFN_getdepid(c.DepID)=d.DepID

-- 部门汇总
Union
select a.Date,d.DepAbbr+N' 汇总',b.SalaryPayID,NULL,NULL,
SUM(a.HousingFundEMP),SUM(a.EndowInsEMP),SUM(a.MedicalInsEMP),SUM(a.UnemployInsEMP),SUM(a.FundInsEMPPlusTotal),
SUM(ISNULL(a.HousingFundEMP,0)+ISNULL(a.EndowInsEMP,0)+ISNULL(a.MedicalInsEMP,0)+ISNULL(a.UnemployInsEMP,0)+ISNULL(a.FundInsEMPPlusTotal,0)),
NULL,NULL,d.xOrder,1
from pEmployeeEmolu_all a,pEmployeeEmolu b,eEmployee c,oDepartment d
where a.EID=b.EID and a.EID=c.EID and dbo.eFN_getdepid(c.DepID)=d.DepID
group by a.Date,d.DepAbbr,b.SalaryPayID,d.xOrder

-- 发薪类型汇总
Union
select NULL,N'总计',b.SalaryPayID,NULL,NULL,
SUM(a.HousingFundEMP),SUM(a.EndowInsEMP),SUM(a.MedicalInsEMP),SUM(a.UnemployInsEMP),SUM(a.FundInsEMPPlusTotal),
SUM(ISNULL(a.HousingFundEMP,0)+ISNULL(a.EndowInsEMP,0)+ISNULL(a.MedicalInsEMP,0)+ISNULL(a.UnemployInsEMP,0)+ISNULL(a.FundInsEMPPlusTotal,0)),
NULL,NULL,99999999999,2
from pEmployeeEmolu_all a,pEmployeeEmolu b,eEmployee c,oDepartment d
where a.EID=b.EID and a.EID=c.EID and dbo.eFN_getdepid(c.DepID)=d.DepID
group by b.SalaryPayID