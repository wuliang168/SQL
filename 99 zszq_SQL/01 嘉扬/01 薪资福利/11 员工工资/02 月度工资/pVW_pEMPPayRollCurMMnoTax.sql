-- pVW_pEMPPayRollCurMMnoTax

select 
-- 工资发放月份
b.Date as PayRollMonth,
-- HRLID
a.HRLID as HRLID,
-- 员工
a.EID as EID,
-- 基本工资：固定工资(考核工资)+保代津贴+保代补贴
--- 转正前后工资计算
---- 未转正人员或者已转正但转正月份和发薪月份相同，固定工资80%(未包含考核工资)
ISNULL(a.SalaryPerMM,0)+ISNULL(a.SponsorAllowance,0)+ISNULL(a.CheckUpSalary,0) as SalaryTotal,
-- 补发总额
ISNULL((select ISNULL(BTATPay,0) from pEMPBTATPayPerMM where EID=a.EID and BTATPayType in (1,2,3,4,5,6,7) and DATEDIFF(MM,Date,b.Date)=0),0) as BackPayBTTotal,
-- 补贴总额
ISNULL((select ISNULL(BTATPay,0) from pEMPBTATPayPerMM where EID=a.EID and BTATPayType in (8,9,10,11,12) and DATEDIFF(MM,Date,b.Date)=0),0)
---- 通讯费
+ ISNULL((select ISNULL(CommAllowanceTotal,0) from pEMPCommPerMM where EID=a.EID and CommAllowanceType in (4,5,6) and DATEDIFF(MM,Date,b.Date)=0),0) as AllowanceBTTotal,
-- 过节费总额
ISNULL((select ISNULL(FestivalFee,0) from pEMPFestivalFeePerMM where EID=a.EID and DATEDIFF(MM,Date,b.Date)=0),0)
+ISNULL((select SUM(ISNULL(MonthExpense,0)) from pMonthExpensePerMM where EID=a.EID and MonthExpenseType in (8,9,10,11,12,13,14,15,20,21,22,23) and DATEDIFF(MM,Month,b.Date)=0),0)
as FestivalFeeBTTotal,
-- 其他奖金
ISNULL((select SUM(ISNULL(MonthExpense,0)) from pMonthExpensePerMM where EID=a.EID and MonthExpenseType in (1,2,3,4,5,6,19) and DATEDIFF(MM,Month,b.Date)=0),0)
+ISNULL((select ISNULL(ProjectBonus,0) from pProjectBonusHRPerEMP where DATEDIFF(MM,PBDISMonth,b.Date)=0 and EID=a.EID and PBDISPayType=1),0) as GeneralBonus,
-- 考核扣款总额
ISNULL((select ISNULL(BTATPay,0) from pEMPBTATPayPerMM where EID=a.EID and BTATPayType in (13,14,15) and DATEDIFF(MM,Date,b.Date)=0),0) as DeductionBTTotal,
-- 一次性奖金
ISNULL((select ISNULL(ProjectBonus,0) from pProjectBonusHRPerEMP where DATEDIFF(MM,PBDISMonth,b.Date)=0 and EID=a.EID and PBDISPayType=2),0) as OneTimeAnnualBonus,
-- 公积金(个人)
ISNULL((select HousingFundEMP from pEMPHousingFundPerMM where EID=a.EID and DATEDIFF(MM,Month,b.Date)=0),0)
+ISNULL((select HousingFundEMP from pEMPHousingFundPerMM_all where EID=a.EID and DATEDIFF(MM,Month,b.Date)=0),0)  as HousingFundEMP,
-- 养老保险(个人)
ISNULL((select EndowInsEMP from pEMPInsurancePerMM where EID=a.EID and DATEDIFF(MM,Month,b.Date)=0),0)
+ISNULL((select EndowInsEMP from pEMPInsurancePerMM_all where EID=a.EID and DATEDIFF(MM,Month,b.Date)=0),0) as EndowInsEMP,
-- 医疗保险(个人)
ISNULL((select MedicalInsEMP from pEMPInsurancePerMM where EID=a.EID and DATEDIFF(MM,Month,b.Date)=0),0)
+ISNULL((select MedicalInsEMP from pEMPInsurancePerMM_all where EID=a.EID and DATEDIFF(MM,Month,b.Date)=0),0) as MedicalInsEMP,
-- 失业保险(个人)
ISNULL((select UnemployInsEMP from pEMPInsurancePerMM where EID=a.EID and DATEDIFF(MM,Month,b.Date)=0),0)
+ISNULL((select UnemployInsEMP from pEMPInsurancePerMM_all where EID=a.EID and DATEDIFF(MM,Month,b.Date)=0),0) as UnemployInsEMP,
-- 五险一金补缴(个人)
---- 社保补缴
ISNULL((select ISNULL(EndowInsEMPPlus,0)+ISNULL(MedicalInsEMPPlus,0)+ISNULL(UnemployInsEMPPlus,0) 
from pEMPInsurancePerMM where EID=a.EID and DATEDIFF(MM,Month,b.Date)=0),0)
+ISNULL((select ISNULL(EndowInsEMPPlus,0)+ISNULL(MedicalInsEMPPlus,0)+ISNULL(UnemployInsEMPPlus,0) 
from pEMPInsurancePerMM_all where EID=a.EID and DATEDIFF(MM,Month,b.Date)=0),0)
---- 公积金补缴
+ISNULL((select ISNULL(HousingFundEMPPlus,0) from pEMPHousingFundPerMM where EID=a.EID and DATEDIFF(MM,Month,b.Date)=0),0)
+ISNULL((select ISNULL(HousingFundEMPPlus,0) from pEMPHousingFundPerMM_all where EID=a.EID and DATEDIFF(MM,Month,b.Date)=0),0) as FundInsEMPPlusTotal,
-- 专项附加扣除
ISNULL((select ISNULL(ChildEdu,0)+ISNULL(ContEdu,0)+ISNULL(CritiIll,0)+ISNULL(HousLoanInte,0)+ISNULL(HousRent,0)+ISNULL(SuppElder,0) 
from pPITSpclMinusPerMM where EID=a.EID and DATEDIFF(MM,Date,b.Date)=0),0) as PITSpclMinusTotal,
-- 税后补贴合计
---- 通讯费
ISNULL((select CommAllowanceTotal from pEMPCommPerMM where EID=a.EID and CommAllowanceType=1 and DATEDIFF(MM,Date,b.Date)=0),0)
+ISNULL((select MonthExpense from pMonthExpensePerMM where EID=a.EID and MonthExpenseType=16 and DATEDIFF(MM,Month,b.Date)=0),0) as AllowanceATTotal,
-- 税后扣款合计
ISNULL((select ISNULL(BTATPay,0) from pEMPBTATPayPerMM where EID=a.EID and BTATPayType in (16,17,18) and DATEDIFF(MM,Date,b.Date)=0),0) as DeductionATTotal,
-- 个税手续费返还
ISNULL((select ISNULL(BTATPay,0) from pEMPBTATPayPerMM where EID=a.EID and BTATPayType in (19) and DATEDIFF(MM,Date,b.Date)=0),0) as TaxFeeReturnAT,
-- 企业年金(个人)
ISNULL((select ISNULL(EmpPensionPerMMBTax,0)+ISNULL(EmpPensionPerMMATax,0) from pEmpPensionPerMM_register where EID=a.EID and DATEDIFF(MM,PensionMonth,b.Date)=0),0) as PensionEMP,
-- 企业年金(个人)抵税额
ISNULL((select ISNULL(EmpPensionPerMMBTax,0) from pEmpPensionPerMM_register where EID=a.EID and DATEDIFF(MM,PensionMonth,b.Date)=0),0) as PensionEMPBT,
-- 捐款抵税额
ISNULL((select ISNULL(BTATPay,0) from pEMPBTATPayPerMM where EID=a.EID and BTATPayType=24 and DATEDIFF(MM,Date,b.Date)=0),0) as DonationBT,
-- 备注
NULL as Remark
from pVW_pEMPEmolu a,pSalaryPerMonth b
where a.Status in (1,2,3) and a.SalaryPayID not in (6,8,17,18)
and ISNULL(b.Submit,0)=1 and ISNULL(b.Closed,0)=0