-- 员工明细
select a.Date as Date,d.DepAbbr as DepAbbr,b.SalaryPayID as SalaryPayID,a.EID as EID,c.Name as Name,a.SalaryPerMM as SalaryPerMM,
a.BackPayTotal as BackPayTotal,a.AllowanceBTTotal as AllowanceBTTotal,a.FestivalFeeTotal as FestivalFeeTotal,a.GeneralBonus as GeneralBonus,
a.DeductionBTTotal as DeductionBTTotal,a.TotalPayAmount as TotalPayAmount,a.OneTimeAnnualBonus as OneTimeAnnualBonus,a.HousingFundEMP as HousingFundEMP,
a.EndowInsEMP as EndowInsEMP,a.MedicalInsEMP as MedicalInsEMP,a.UnemployInsEMP as UnemployInsEMP,a.FundInsEMPPlusTotal as FundInsEMPPlusTotal,
(ISNULL(a.HousingFundEMP,0)+ISNULL(a.EndowInsEMP,0)+ISNULL(a.MedicalInsEMP,0)+ISNULL(a.UnemployInsEMP,0)+ISNULL(a.FundInsEMPPlusTotal,0)) as FundInsEMP,
b.InsuranceLoc as InsuranceLoc,b.HousingFundLoc as HousingFundLoc,
a.PersonalIncomeTax as PersonalIncomeTax,a.OneTimeAnnualBonusTax as OneTimeAnnualBonusTax,a.AllowanceATTotal as AllowanceATTotal,a.DeductionATTotal as DeductionATTotal,
a.PensionEMPBT as PensionEMPBT,a.PensionEMP as PensionEMP,a.FinalPayingAmount as FinalPayingAmount,d.xOrder as DepxOrder,0 as NamexOrder
from pEmployeeEmolu_all a,pEmployeeEmolu b,eEmployee c,oDepartment d
where a.EID=b.EID and a.EID=c.EID and dbo.eFN_getdepid(c.DepID)=d.DepID