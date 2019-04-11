-- 员工明细
select a.Date as Date,d.DepAbbr as DepAbbr,b.SalaryPayID as SalaryPayID,a.EID as EID,c.Name as Name,a.SalaryPerMM as SalaryPerMM,
a.BackPayTotal as BackPayTotal,a.AllowanceBTTotal as AllowanceBTTotal,a.FestivalFeeTotal as FestivalFeeTotal,a.GeneralBonus as GeneralBonus,
a.DeductionBTTotal as DeductionBTTotal,a.TotalPayAmount as TotalPayAmount,a.OneTimeAnnualBonus as OneTimeAnnualBonus,
(ISNULL(a.HousingFundEMP,0)+ISNULL(a.EndowInsEMP,0)+ISNULL(a.MedicalInsEMP,0)+ISNULL(a.UnemployInsEMP,0)+ISNULL(a.FundInsEMPPlusTotal,0)) as FundInsEMP,
a.PersonalIncomeTax as PersonalIncomeTax,a.OneTimeAnnualBonusTax as OneTimeAnnualBonusTax,a.AllowanceATTotal as AllowanceATTotal,a.DeductionATTotal as DeductionATTotal,
a.PensionEMPBT as PensionEMPBT,a.PensionEMP as PensionEMP,a.FinalPayingAmount as FinalPayingAmount,d.xOrder as DepxOrder,0 as NamexOrder
from pEmployeeEmolu_all a,pEmployeeEmolu b,eEmployee c,oDepartment d
where a.EID=b.EID and a.EID=c.EID and dbo.eFN_getdepid(c.DepID)=d.DepID

-- 部门汇总
Union
select a.Date,d.DepAbbr+N' 汇总',b.SalaryPayID,NULL,NULL,SUM(a.SalaryPerMM),SUM(a.BackPayTotal),SUM(a.AllowanceBTTotal),SUM(a.FestivalFeeTotal),
SUM(a.GeneralBonus),SUM(a.DeductionBTTotal),SUM(a.TotalPayAmount),SUM(a.OneTimeAnnualBonus),
SUM(ISNULL(a.HousingFundEMP,0)+ISNULL(a.EndowInsEMP,0)+ISNULL(a.MedicalInsEMP,0)+ISNULL(a.UnemployInsEMP,0)+ISNULL(a.FundInsEMPPlusTotal,0)),SUM(a.PersonalIncomeTax),
SUM(a.OneTimeAnnualBonusTax),SUM(a.AllowanceATTotal),SUM(a.DeductionATTotal),SUM(a.PensionEMPBT),SUM(a.PensionEMP),SUM(a.FinalPayingAmount),d.xOrder,1
from pEmployeeEmolu_all a,pEmployeeEmolu b,eEmployee c,oDepartment d
where a.EID=b.EID and a.EID=c.EID and dbo.eFN_getdepid(c.DepID)=d.DepID
group by a.Date,d.DepAbbr,b.SalaryPayID,d.xOrder

-- 发薪类型汇总
Union
select NULL,N'总计',b.SalaryPayID,NULL,NULL,SUM(a.SalaryPerMM),SUM(a.BackPayTotal),SUM(a.AllowanceBTTotal),SUM(a.FestivalFeeTotal),SUM(a.GeneralBonus),
SUM(a.DeductionBTTotal),SUM(a.TotalPayAmount),SUM(a.OneTimeAnnualBonus),
SUM(ISNULL(a.HousingFundEMP,0)+ISNULL(a.EndowInsEMP,0)+ISNULL(a.MedicalInsEMP,0)+ISNULL(a.UnemployInsEMP,0)+ISNULL(a.FundInsEMPPlusTotal,0)),SUM(a.PersonalIncomeTax),
SUM(a.OneTimeAnnualBonusTax),SUM(a.AllowanceATTotal),SUM(a.DeductionATTotal),SUM(a.PensionEMPBT),SUM(a.PensionEMP),SUM(a.FinalPayingAmount),99999999999,2
from pEmployeeEmolu_all a,pEmployeeEmolu b,eEmployee c,oDepartment d
where a.EID=b.EID and a.EID=c.EID and dbo.eFN_getdepid(c.DepID)=d.DepID
group by b.SalaryPayID