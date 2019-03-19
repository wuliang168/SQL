select a.Date as Date,a.EID as EID,
-- 基本工资：固定工资(考核工资)+保代津贴+保代补贴
ISNULL(a.SalaryPerMM,0) as SalaryPerMM,
-- 补发工资
ISNULL(a.BackPayTotal,0) as BackPayTotal,
-- 税前补贴
ISNULL(a.AllowanceBTTotal,0) as AllowanceBTTotal,
-- 过节费
ISNULL(a.FestivalFeeTotal,0) as FestivalFeeTotal,
-- 奖金
ISNULL(a.GeneralBonus,0) as GeneralBonus,
-- 税前扣款
ISNULL(a.DeductionBTTotal,0) as DeductionBTTotal,
-- 应发工资：固定工资+保代津贴+补发工资+税前补贴+过节费+奖金-税前扣款
ISNULL(a.TotalPayAmount,0) as TotalPayAmount,
-- 一次性奖金
ISNULL(a.OneTimeAnnualBonus,0) as OneTimeAnnualBonus,
-- 公积金(个人)
ISNULL(a.HousingFundEMP,0) as HousingFundEMP,
-- 养老保险(个人)
ISNULL(a.EndowInsEMP,0) as EndowInsEMP,
-- 医疗保险(个人)
ISNULL(a.MedicalInsEMP,0) as MedicalInsEMP,
-- 失业保险(个人)
ISNULL(a.UnemployInsEMP,0) as UnemployInsEMP,
-- 五险一金补缴(个人)
ISNULL(a.FundInsEMPPlusTotal,0) as FundInsEMPPlusTotal,
-- 应税额：固定工资+保代津贴+补发工资+税前补贴+过节费+奖金-税前扣款-五险一金(个人)-五险一金补缴(个人)-企业年金抵税额-个税免征额+公积金超额(个人)+公积金超额(公司)+实物福利
ISNULL(b.PersonalIncomeTax,0) as PersonalIncomeTax,
-- 一次性奖金税
ISNULL(b.OneTimeAnnualBonusTax,0) as OneTimeAnnualBonusTax,
-- 税后补贴
ISNULL(a.AllowanceATTotal,0) as AllowanceATTotal,
-- 税后扣款
ISNULL(a.DeductionATTotal,0) as DeductionATTotal,
-- 企业年金(个人)抵税额
ISNULL(a.PensionEMPBT,0) as PensionEMPBT,
-- 企业年金(个人)
ISNULL(a.PensionEMP,0) as PensionEMP,
-- 实发工资：应发工资+税后补贴+一次性奖金-五险一金(个人)-五险一金补缴(个人)-企业年金(个人)-税后扣款-个人所得税-一次性奖金税+个税扣款调整+个税手续费返还+个税补贴调整
(ISNULL(a.TotalPayAmount,0)+ISNULL(a.AllowanceATTotal,0)+ISNULL(a.OneTimeAnnualBonus,0)-ISNULL(a.FundInsEMPTotal,0)
-ISNULL(a.FundInsEMPPlusTotal,0)-ISNULL(a.PensionEMP,0)-ISNULL(a.DeductionATTotal,0)-ISNULL(b.PersonalIncomeTax,0)-ISNULL(b.OneTimeAnnualBonusTax,0)
+ISNULL(a.TaxDeductionModifAT,0)+ ISNULL(a.TaxFeeReturnAT,0)+ISNULL(a.TaxAllowanceAT,0)) as FinalPayingAmount
from pVW_EmployeeEmoluPerMMnoTax a
inner join pVW_EmployeeEmoluPerMMTax as b on a.EID=b.EID