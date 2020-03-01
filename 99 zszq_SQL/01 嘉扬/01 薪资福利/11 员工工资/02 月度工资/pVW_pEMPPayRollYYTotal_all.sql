-- pVW_pEMPPayRollYYTotal_all

select YEAR(PayRollMonth) as PayRollYear,EID,EMP_Code,SUM(SalaryTotal) as SalaryTotalY,SUM(BackPayAlowBTTotal) as BackPayAlowBTTotalY,
SUM(FestivalFeeBTTotal) as FestivalFeeBTTotalY,SUM(GeneralBonus) as GeneralBonusY,SUM(DeductionBTTotal) as DeductionBTTotalY,SUM(TotalPayAmount) as TotalPayAmountY,
SUM(OneTimeAnnualBonus) as OneTimeAnnualBonusY,SUM(HousingFundEMP) as HousingFundEMPY,SUM(EndowInsEMP) as EndowInsEMPY,SUM(MedicalInsEMP) as MedicalInsEMPY,
SUM(UnemployInsEMP) as UnemployInsEMPY,SUM(FundInsEMPPlusTotal) as FundInsEMPPlusTotalY,SUM(FundInsEMPTotal) as FundInsEMPTotalY,SUM(PITSpclMinusTotal) as PITSpclMinusTotalY,
SUM(TotalTaxAmount) as TotalTaxAmountY,SUM(PersonalIncomeTax) as PersonalIncomeTaxY,SUM(OneTimeAnnualBonusTax) as OneTimeAnnualBonusTaxY,SUM(AllowanceATTotal) as AllowanceATTotalY,
SUM(DeductionATTotal) as DeductionATTotalY,SUM(TaxFeeReturnAT) as TaxFeeReturnATY,SUM(PensionEMP) as PensionEMPY,SUM(PensionEMPBT) as PensionEMPBTY,
SUM(FinalPayingAmount) as FinalPayingAmountY, SUM(TotalPayAmount)+SUM(OneTimeAnnualBonus) as PayRollATTotalY
from PEMPPAYROLLPERMM_ALL
group by YEAR(PayrollMonth),EID,EMP_Code