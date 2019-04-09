-- pVW_pEMPPayRollMM_Sheet

-- 员工明细
select a.PayRollMonth as PayRollMonth,d.DepAbbr as DepAbbr,b.SalaryPayID as SalaryPayID,a.EID as EID,a.HRLID as HRLID,c.Name as Name,a.SalaryTotal as SalaryTotal,
a.BackPayBTTotal as BackPayBTTotal,a.AllowanceBTTotal as AllowanceBTTotal,a.FestivalFeeBTTotal as FestivalFeeBTTotal,a.GeneralBonus as GeneralBonus,
a.DeductionBTTotal as DeductionBTTotal,a.TotalPayAmount as TotalPayAmount,a.OneTimeAnnualBonus as OneTimeAnnualBonus,
(ISNULL(a.HousingFundEMP,0)+ISNULL(a.EndowInsEMP,0)+ISNULL(a.MedicalInsEMP,0)+ISNULL(a.UnemployInsEMP,0)+ISNULL(a.FundInsEMPPlusTotal,0)) as FundInsEMP,
a.PITSpclMinusTotal as PITSpclMinusTotal,a.TotalTaxAmount as TotalTaxAmount,a.PersonalIncomeTax as PersonalIncomeTax,a.OneTimeAnnualBonusTax as OneTimeAnnualBonusTax,
a.AllowanceATTotal as AllowanceATTotal,a.DeductionATTotal as DeductionATTotal,a.TaxFeeReturnAT as TaxFeeReturnAT,
a.PensionEMPBT as PensionEMPBT,a.PensionEMP as PensionEMP,a.FinalPayingAmount as FinalPayingAmount,d.xOrder as DepxOrder,0 as NamexOrder,e.Xorder as JobXorder
from pVW_pEMPPayRollCurMM a,pEmployeeEmolu b,eEmployee c,oDepartment d,oJob e
where a.EID=b.EID and a.EID=c.EID and dbo.eFN_getdepid(c.DepID)=d.DepID and c.JobID=e.JobID

-- 部门汇总
Union
select a.PayRollMonth,d.DepAbbr+N' 汇总',b.SalaryPayID,NULL,NULL,NULL,SUM(a.SalaryTotal),SUM(a.BackPayBTTotal),SUM(a.AllowanceBTTotal),SUM(a.FestivalFeeBTTotal),
SUM(a.GeneralBonus),SUM(a.DeductionBTTotal),SUM(a.TotalPayAmount),SUM(a.OneTimeAnnualBonus),
SUM(ISNULL(a.HousingFundEMP,0)+ISNULL(a.EndowInsEMP,0)+ISNULL(a.MedicalInsEMP,0)+ISNULL(a.UnemployInsEMP,0)+ISNULL(a.FundInsEMPPlusTotal,0)),
SUM(a.PITSpclMinusTotal),SUM(a.TotalTaxAmount),SUM(a.PersonalIncomeTax),SUM(a.OneTimeAnnualBonusTax),
SUM(a.AllowanceATTotal),SUM(a.DeductionATTotal),SUM(a.TaxFeeReturnAT),SUM(a.PensionEMPBT),SUM(a.PensionEMP),SUM(a.FinalPayingAmount),d.xOrder,1,NULL
from pVW_pEMPPayRollCurMM a,pEmployeeEmolu b,eEmployee c,oDepartment d
where a.EID=b.EID and a.EID=c.EID and dbo.eFN_getdepid(c.DepID)=d.DepID
group by a.PayRollMonth,d.DepAbbr,b.SalaryPayID,d.xOrder

-- 发薪类型汇总
Union
select NULL,N'总计',b.SalaryPayID,NULL,NULL,NULL,SUM(a.SalaryTotal),SUM(a.BackPayBTTotal),SUM(a.AllowanceBTTotal),SUM(a.FestivalFeeBTTotal),SUM(a.GeneralBonus),
SUM(a.DeductionBTTotal),SUM(a.TotalPayAmount),SUM(a.OneTimeAnnualBonus),
SUM(ISNULL(a.HousingFundEMP,0)+ISNULL(a.EndowInsEMP,0)+ISNULL(a.MedicalInsEMP,0)+ISNULL(a.UnemployInsEMP,0)+ISNULL(a.FundInsEMPPlusTotal,0)),
SUM(a.PITSpclMinusTotal),SUM(a.TotalTaxAmount),SUM(a.PersonalIncomeTax),SUM(a.OneTimeAnnualBonusTax),
SUM(a.AllowanceATTotal),SUM(a.DeductionATTotal),SUM(a.TaxFeeReturnAT),SUM(a.PensionEMPBT),SUM(a.PensionEMP),SUM(a.FinalPayingAmount),99999999999,2,NULL
from pVW_pEMPPayRollCurMM a,pEmployeeEmolu b,eEmployee c,oDepartment d
where a.EID=b.EID and a.EID=c.EID and dbo.eFN_getdepid(c.DepID)=d.DepID
group by b.SalaryPayID