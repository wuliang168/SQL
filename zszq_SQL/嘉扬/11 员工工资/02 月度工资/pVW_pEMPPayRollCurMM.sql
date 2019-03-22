-- pVW_pEMPPayRollHRLCurMM

select 
-- 工资发放月份
b.Date as PayRollMonth,
-- 员工
a.EID as EID,
-- 基本工资：固定工资(考核工资)+保代津贴+保代补贴
--- 转正前后工资计算
---- 未转正人员或者已转正但转正月份和发薪月份相同，固定工资80%(未包含考核工资)
ISNULL(a.SalaryPerMM,0)+ISNULL(a.SponsorAllowance,0)+ISNULL(a.CheckUpSalary,0) as SalaryTotal,
-- 补发总额
(select BTATPay from pEMPBTATPayPerMM where EID=a.EID and BTATPayType in (1,2,3,4,5,6,7) and DATEDIFF(MM,Date,b.Date)=0) as BackPayBTTotal,
-- 补贴总额
(select BTATPay from pEMPBTATPayPerMM where EID=a.EID and BTATPayType in (8,9,10,11,12) and DATEDIFF(MM,Date,b.Date)=0) as AllowanceBTTotal,
-- 过节费总额
(select FestivalFee from pEMPFestivalFeePerMM where EID=a.EID and DATEDIFF(MM,Date,b.Date)=0) as FestivalFeeBTTotal,
-- 其他奖金
NULL as GeneralBonus,
-- 考核扣款总额
(select BTATPay from pEMPBTATPayPerMM where EID=a.EID and BTATPayType in (13,14,15) and DATEDIFF(MM,Date,b.Date)=0) as DeductionBTTotal,
-- 应发工资：固定工资+保代津贴+补发工资+税前补贴+过节费+奖金-税前扣款
NULL as TotalPayAmount,
-- 一次性奖金
NULL as OneTimeAnnualBonus,
-- 公积金(个人)
(select ISNULL(HousingFundEMP,0) from pEMPHousingFundPerMM where EID=a.EID and DATEDIFF(MM,Date,b.Date)=0) as HousingFundEMP,
-- 养老保险(个人)
(select ISNULL(EndowInsEMP,0) from pEMPInsurancePerMM where EID=a.EID and DATEDIFF(MM,Date,b.Date)=0) as EndowInsEMP,
-- 医疗保险(个人)
(select ISNULL(MedicalInsEMP,0) from pEMPInsurancePerMM where EID=a.EID and DATEDIFF(MM,Date,b.Date)=0) as MedicalInsEMP,
-- 失业保险(个人)
(select ISNULL(UnemployInsEMP,0) from pEMPInsurancePerMM where EID=a.EID and DATEDIFF(MM,Date,b.Date)=0) as UnemployInsEMP,
-- 五险一金补缴(个人)
---- 社保补缴
(select ISNULL(EndowInsEMPPlus,0)+ISNULL(MedicalInsEMPPlus,0)+ISNULL(UnemployInsEMPPlus,0) 
from pEMPInsurancePerMM where EID=a.EID and DATEDIFF(MM,Date,b.Date)=0)
---- 公积金补缴
+(select ISNULL(HousingFundEMPPlus,0) from pEMPHousingFundPerMM where EID=a.EID and DATEDIFF(MM,Date,b.Date)=0) as FundInsEMPPlusTotal,
-- 专项附加扣除
(select ISNULL(ChildEdu,0)+ISNULL(ContEdu,0)+ISNULL(CritiIll,0)+ISNULL(HousLoanInte,0)+ISNULL(HousRent,0)+ISNULL(SuppElder,0) 
from pPITSpclMinusPerMM where EID=a.EID and DATEDIFF(MM,Date,b.Date)=0) as PITSpclMinusTotal,
-- 应税额：固定工资+保代津贴+补发工资+税前补贴+过节费+奖金-税前扣款-五险一金-专项附加扣除
NULL as TotalTaxAmount,
-- 个人所得税总计
NULL as PersonalIncomeTax,
-- 一次性奖金税
NULL as OneTimeAnnualBonusTax,
-- 税后补贴合计
NULL as AllowanceATTotal,
-- 税后扣款合计
NULL as DeductionATTotal,
-- 个税手续费返还
--as TaxFeeReturnAT,
-- 企业年金(个人)
NULL as PensionEMP,
-- 企业年金(个人)抵税额
NULL as PensionEMPBT,
-- 实发工资
NULL as FinalPayingAmount,
-- 备注
NULL as Remark
from pVW_pEMPEmolu a,pSalaryPerMonth b
where a.Status in (1,2,3) and a.SalaryPayID not in (6,8,17,18)
and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0