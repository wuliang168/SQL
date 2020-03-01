-- pVW_pEMPPayRollMM_Summ

-- 发薪类型汇总
select a.PayRollMonth as PayRollMonth,d.DepAbbr as DepAbbr,b.SalaryPayID as SalaryPayID,NULL as EID,NULL as Name,NULL as HRLID,
SUM(a.SalaryTotal) as SalaryTotal,SUM(a.BackPayBTTotal) as BackPayBTTotal,SUM(a.AllowanceBTTotal) as AllowanceBTTotal,
SUM(a.FestivalFeeBTTotal) as FestivalFeeBTTotal,SUM(a.GeneralBonus) as GeneralBonus,SUM(a.DeductionBTTotal) as DeductionBTTotal,
SUM(a.TotalPayAmount) as TotalPayAmount,SUM(a.OneTimeAnnualBonus) as OneTimeAnnualBonus,
SUM(ISNULL(a.HousingFundEMP,0)+ISNULL(a.EndowInsEMP,0)+ISNULL(a.MedicalInsEMP,0)+ISNULL(a.UnemployInsEMP,0)+ISNULL(a.FundInsEMPPlusTotal,0)) as FundInsEMP,
SUM(a.PITSpclMinusTotal) as PITSpclMinusTotal,SUM(a.PersonalIncomeTax) as PersonalIncomeTax,SUM(a.OneTimeAnnualBonusTax) as OneTimeAnnualBonusTax,
SUM(a.AllowanceATTotal) as AllowanceATTotal,SUM(a.DeductionATTotal) as DeductionATTotal,
SUM(a.PensionEMPBT) as PensionEMPBT,SUM(a.PensionEMP) as PensionEMP,SUM(a.FinalPayingAmount) as FinalPayingAmount,
d.xOrder as DepxOrder,2 as NamexOrder
from pVW_pEMPPayRollCurMM a,pEmployeeEmolu b,eEmployee c,oDepartment d
where a.EID=b.EID and a.EID=c.EID and dbo.eFN_getdepid(c.DepID)=d.DepID
group by a.PayRollMonth,d.DepAbbr,b.SalaryPayID,d.xOrder