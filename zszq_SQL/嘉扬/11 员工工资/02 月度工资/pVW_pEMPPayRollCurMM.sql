-- pVW_pEMPPayRollCurMM

select 
-- 工资发放月份
a.PayRollMonth as PayRollMonth,
-- HRLID
a.HRLID as HRLID,
-- 员工
a.EID as EID,
-- 基本工资：固定工资(考核工资)+保代津贴+保代补贴
--- 转正前后工资计算
---- 未转正人员或者已转正但转正月份和发薪月份相同，固定工资80%(未包含考核工资)
a.SalaryTotal as SalaryTotal,
-- 补发总额
a.BackPayBTTotal as BackPayBTTotal,
-- 补贴总额
a.AllowanceBTTotal as AllowanceBTTotal,
-- 过节费总额
a.FestivalFeeBTTotal as FestivalFeeBTTotal,
-- 其他奖金
a.GeneralBonus as GeneralBonus,
-- 考核扣款总额
a.DeductionBTTotal as DeductionBTTotal,
-- 应发工资：固定工资+保代津贴+补发工资+税前补贴+过节费+奖金-税前扣款
a.SalaryTotal+a.BackPayBTTotal+a.FestivalFeeBTTotal+a.GeneralBonus-a.DeductionBTTotal as TotalPayAmount,
-- 一次性奖金
a.OneTimeAnnualBonus as OneTimeAnnualBonus,
-- 公积金(个人)
a.HousingFundEMP as HousingFundEMP,
-- 养老保险(个人)
a.EndowInsEMP as EndowInsEMP,
-- 医疗保险(个人)
a.MedicalInsEMP as MedicalInsEMP,
-- 失业保险(个人)
a.UnemployInsEMP as UnemployInsEMP,
-- 五险一金补缴(个人)
---- 社保补缴
a.FundInsEMPPlusTotal as FundInsEMPPlusTotal,
-- 专项附加扣除
a.PITSpclMinusTotal as PITSpclMinusTotal,
-- 应税额：应发工资-五险一金-专项附加扣除-年金(个人)抵税额
a.SalaryTotal+a.BackPayBTTotal+a.FestivalFeeBTTotal+a.GeneralBonus-a.DeductionBTTotal
-a.HousingFundEMP-a.MedicalInsEMP-a.UnemployInsEMP-a.FundInsEMPPlusTotal-a.PITSpclMinusTotal as TotalTaxAmount,
-- 个人所得税总计
dbo.CFN_GETMAX(dbo.eFN_getPersonalIncomeTax(dbo.CFN_GETMAX(ISNULL((select TotalTaxAmountYY from pVW_pEMPPayRollYY_all where DATEDIFF(mm,PayRollMonth,a.PayRollMonth)=1 and EID=a.EID),0)
+a.SalaryTotal+a.BackPayBTTotal+a.FestivalFeeBTTotal+a.GeneralBonus-a.DeductionBTTotal
-a.HousingFundEMP-a.EndowInsEMP-a.MedicalInsEMP-a.UnemployInsEMP-a.FundInsEMPPlusTotal-a.PITSpclMinusTotal-a.PensionEMPBT
-ISNULL((select ISNULL(TaxBase,0) from oCD_TaxRateType where ID=1),0),0),2)
-ISNULL((select ISNULL(PersonalIncomeTaxYY,0) from pVW_pEMPPayRollYY_all where DATEDIFF(mm,PayRollMonth,a.PayRollMonth)=1 and EID=a.EID),0),0) as PersonalIncomeTax,
-- 一次性奖金税
dbo.eFN_getPersonalIncomeTax(a.OneTimeAnnualBonus,3) as OneTimeAnnualBonusTax,
-- 税后补贴合计
---- 通讯费
a.AllowanceATTotal as AllowanceATTotal,
-- 税后扣款合计
a.DeductionATTotal as DeductionATTotal,
-- 个税手续费返还
a.TaxFeeReturnAT as TaxFeeReturnAT,
-- 企业年金(个人)
a.PensionEMP as PensionEMP,
-- 企业年金(个人)抵税额
a.PensionEMPBT as PensionEMPBT,
-- 实发工资
---- 应发工资-个人所得税+税后补贴合计-税后扣款合计+个税手续费返还-企业年金(个人)
a.SalaryTotal+a.BackPayBTTotal+a.FestivalFeeBTTotal+a.GeneralBonus-a.DeductionBTTotal
-a.HousingFundEMP-a.EndowInsEMP-a.MedicalInsEMP-a.UnemployInsEMP-a.FundInsEMPPlusTotal
+a.AllowanceATTotal-a.DeductionATTotal+a.TaxFeeReturnAT-a.PensionEMP as FinalPayingAmount,
-- 备注
a.Remark as Remark
from pVW_pEMPPayRollCurMMnoTax a