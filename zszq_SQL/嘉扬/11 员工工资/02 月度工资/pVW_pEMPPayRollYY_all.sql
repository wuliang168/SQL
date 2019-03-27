-- pVW_pEMPPayRollYY_all

select 
-- 工资发放月份
a.PayRollMonth as PayRollMonth,
-- EMP_CODE
a.EMP_Code as EMP_Code,
-- 员工
a.EID as EID,
-- 应发工资：固定工资+保代津贴+补发工资+税前补贴+过节费+奖金-税前扣款
(select SUM(ISNULL(SalaryTotal,0))+SUM(ISNULL(BackPayBTTotal,0))+SUM(ISNULL(AllowanceBTTotal,0))+SUM(ISNULL(FestivalFeeBTTotal,0))+SUM(ISNULL(GeneralBonus,0))+SUM(ISNULL(DeductionBTTotal,0))
from pEMPPayRollPerMM_all where DATEDIFF(mm,PayRollMonth,a.PayRollMonth)>=0 and DATEDIFF(YY,PayRollMonth,a.PayRollMonth)=0 and EID=a.EID) as TotalPayAmountYY,
-- 五险一金合计(含补缴)(个人)
(select SUM(ISNULL(HousingFundEMP,0))+SUM(ISNULL(EndowInsEMP,0))+SUM(ISNULL(MedicalInsEMP,0))+SUM(ISNULL(UnemployInsEMP,0))+SUM(ISNULL(FundInsEMPPlusTotal,0))
from pEMPPayRollPerMM_all where DATEDIFF(mm,PayRollMonth,a.PayRollMonth)>=0 and DATEDIFF(YY,PayRollMonth,a.PayRollMonth)=0 and EID=a.EID) as FundInsEMPTotalYY,
-- 专项附加扣除
ISNULL(a.PITSpclMinusTotal,0) as PITSpclMinusTotal,
-- 应税额：固定工资+保代津贴+补发工资+税前补贴+过节费+奖金-税前扣款-五险一金-专项附加扣除
(select SUM(ISNULL(TotalTaxAmount,0)) from pEMPPayRollPerMM_all 
where DATEDIFF(mm,PayRollMonth,a.PayRollMonth)>=0 and DATEDIFF(YY,PayRollMonth,a.PayRollMonth)=0 and EID=a.EID) as TotalTaxAmountYY,
-- 个人所得税总计
dbo.eFN_getPersonalIncomeTax((select SUM(ISNULL(TotalTaxAmount,0)) 
from pEMPPayRollPerMM_all where DATEDIFF(mm,PayRollMonth,a.PayRollMonth)>=0 and DATEDIFF(YY,PayRollMonth,a.PayRollMonth)=0 and EID=a.EID),2) as PersonalIncomeTaxYY,
-- 一次性奖金
ISNULL(a.OneTimeAnnualBonus,0) as OneTimeAnnualBonus,
-- 一次性奖金税
dbo.eFN_getPersonalIncomeTax(ISNULL(a.OneTimeAnnualBonus,0),3) as OneTimeAnnualBonusTax,
-- 备注
NULL as Remark
from pEMPPayRollPerMM_all a
group by a.PayRollMonth,a.emp_code,a.EID,a.PITSpclMinusTotal,a.OneTimeAnnualBonus