-- pVW_pEMPPayRollHRLMM_all

select 
-- 工资发放月份
a.pay_date as PayRollMonth,
-- EMP_CODE
a.emp_code,
-- 员工
(select EID from eEmployee where HRLID=a.emp_code and Status not in (4,5)) as EID,
-- 基本工资：固定工资(考核工资)+保代津贴+保代补贴
--- 转正前后工资计算
---- 未转正人员或者已转正但转正月份和发薪月份相同，固定工资80%(未包含考核工资)
ISNULL(a.SA_01,0)+ISNULL(a.SA_02,0)+ISNULL(a.SA_03,0) as SalaryTotal,
-- 补发总额
ISNULL(a.SA_04,0) as BackPayBTTotal,
-- 补贴总额
ISNULL(a.SA_06,0) as AllowanceBTTotal,
-- 补发&补贴总额
ISNULL(a.SA_04,0)+ISNULL(a.SA_06,0) as BackPayAlowBTTotal,
-- 过节费总额
ISNULL(a.OTHER_02,0) as FestivalFeeBTTotal,
-- 其他奖金
ISNULL(a.SA_15,0) as GeneralBonus,
-- 考核扣款总额
ISNULL(a.SA_07,0) as DeductionBTTotal,
-- 应发工资：固定工资+保代津贴+补发工资+税前补贴+过节费+奖金-税前扣款
ISNULL(a.AC_01,0) as TotalPayAmount,
-- 一次性奖金
ISNULL(a.SA_11,0) as OneTimeAnnualBonus,
-- 公积金(个人)
ISNULL(a.SB_04,0) as HousingFundEMP,
-- 养老保险(个人)
ISNULL(a.SB_01,0) as EndowInsEMP,
-- 医疗保险(个人)
ISNULL(a.SB_02,0) as MedicalInsEMP,
-- 失业保险(个人)
ISNULL(a.SB_03,0) as UnemployInsEMP,
-- 五险一金补缴(个人)
ISNULL(a.SB_07,0)+ISNULL(a.SB_06,0)+ISNULL(a.SB_10,0)+ISNULL(a.SB_09,0) as FundInsEMPPlusTotal,
-- 五险一金合计(含补缴)(个人)
ISNULL(a.SB_04,0)+ISNULL(a.SB_01,0)+ISNULL(a.SB_02,0)+ISNULL(a.SB_03,0)+ISNULL(a.SB_07,0)+ISNULL(a.SB_06,0)+ISNULL(a.SB_10,0)+ISNULL(a.SB_09,0) as FundInsEMPTotal,
-- 专项附加扣除
ISNULL(a.OTHER_10001,0)+ISNULL(a.OTHER_10002,0)+ISNULL(a.OTHER_10003,0)+ISNULL(a.OTHER_10004,0)+ISNULL(a.OTHER_10005,0)+ISNULL(a.OTHER_10006,0) as PITSpclMinusTotal,
-- 应税额：固定工资+保代津贴+补发工资+税前补贴+过节费+奖金-税前扣款-五险一金-专项附加扣除
ISNULL(a.AC_02,0) as TotalTaxAmount,
-- 个人所得税总计
ISNULL(a.TX_IIT,0) as PersonalIncomeTax,
-- 一次性奖金税
ISNULL(a.TX_bit,0) as OneTimeAnnualBonusTax,
-- 税后补贴合计
ISNULL(a.OTHER_03,0) as AllowanceATTotal,
-- 税后扣款合计
ISNULL(a.SA_09,0) as DeductionATTotal,
-- 个税手续费返还
--as TaxFeeReturnAT,
-- 企业年金(个人)
ISNULL(a.SA_34,0) as PensionEMP,
-- 企业年金(个人)抵税额
ISNULL(a.SA_35,0) as PensionEMPBT,
-- 实发工资
ISNULL(a.net,0) as FinalPayingAmount,
-- 备注
NULL as Remark
from pEMPPayRollHRLPerMM_all a