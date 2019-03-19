-- 发薪类型汇总
select a.Date as Date,d.DepAbbr as DepAbbr,b.SalaryPayID as SalaryPayID,NULL as EID,NULL as Name,SUM(a.HousingFundEMP) as HousingFundEMP,
SUM(a.EndowInsEMP) as EndowInsEMP,SUM(a.MedicalInsEMP) as MedicalInsEMP,SUM(a.UnemployInsEMP) as UnemployInsEMP,SUM(a.FundInsEMPPlusTotal) as FundInsEMPPlusTotal,
SUM(ISNULL(a.HousingFundEMP,0)+ISNULL(a.EndowInsEMP,0)+ISNULL(a.MedicalInsEMP,0)+ISNULL(a.UnemployInsEMP,0)+ISNULL(a.FundInsEMPPlusTotal,0)) as FundInsEMP,
NULL as InsuranceLoc,NULL as HousingFundLoc,d.xOrder as DepxOrder,2 as NamexOrder
from pEmployeeEmolu_all a,pEmployeeEmolu b,eEmployee c,oDepartment d
where a.EID=b.EID and a.EID=c.EID and dbo.eFN_getdepid(c.DepID)=d.DepID
group by a.Date,d.DepAbbr,b.SalaryPayID,d.xOrder