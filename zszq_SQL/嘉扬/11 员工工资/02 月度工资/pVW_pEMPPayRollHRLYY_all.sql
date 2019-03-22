-- pVW_pEMPPayRollHRLYY_all

select 
-- 工资发放月份
a.pay_date as PayRollMonth,
-- EMP_CODE
a.emp_code as EMP_Code,
-- 员工
(select EID from eEmployee where HRLID=a.emp_code and Status not in (4,5)) as EID,
-- 应发工资：固定工资+保代津贴+补发工资+税前补贴+过节费+奖金-税前扣款
(select ROUND(SUM(ISNULL(AC_01,0)),2) from pEMPPayRollHRLPerMM_all where DATEDIFF(mm,pay_date,a.pay_date)>=0 and emp_code=a.emp_code) as TotalPayAmountYY,
-- 五险一金合计(含补缴)(个人)
(select SUM(ISNULL(SB_04,0))+SUM(ISNULL(SB_01,0))+SUM(ISNULL(SB_02,0))+SUM(ISNULL(SB_03,0))+SUM(ISNULL(SB_07,0))+SUM(ISNULL(SB_06,0))
+SUM(ISNULL(SB_10,0))+SUM(ISNULL(SB_09,0)) from pEMPPayRollHRLPerMM_all where DATEDIFF(mm,pay_date,a.pay_date)>=0 and emp_code=a.emp_code) as FundInsEMPTotalYY,
-- 专项附加扣除
ISNULL(a.OTHER_10001,0)+ISNULL(a.OTHER_10002,0)+ISNULL(a.OTHER_10003,0)+ISNULL(a.OTHER_10004,0)+ISNULL(a.OTHER_10005,0)+ISNULL(a.OTHER_10006,0) as PITSpclMinusTotal,
-- 应税额：固定工资+保代津贴+补发工资+税前补贴+过节费+奖金-税前扣款-五险一金-专项附加扣除
(select SUM(ISNULL(AC_01,0))-SUM(ISNULL(SA_07,0))-(SUM(ISNULL(SB_04,0))+SUM(ISNULL(SB_01,0))+SUM(ISNULL(SB_02,0))+SUM(ISNULL(SB_03,0))+SUM(ISNULL(SB_07,0))+SUM(ISNULL(SB_06,0))
+SUM(ISNULL(SB_10,0))+SUM(ISNULL(SB_09,0)))-(ISNULL(a.OTHER_10001,0)+ISNULL(a.OTHER_10002,0)+ISNULL(a.OTHER_10003,0)+ISNULL(a.OTHER_10004,0)+ISNULL(a.OTHER_10005,0)+ISNULL(a.OTHER_10006,0))
-SUM(ISNULL(tax_deduction,0)) from pEMPPayRollHRLPerMM_all where DATEDIFF(mm,pay_date,a.pay_date)>=0 and emp_code=a.emp_code) as TotalTaxAmountYY,
-- 个人所得税总计
dbo.eFN_getPersonalIncomeTax((select SUM(ISNULL(AC_01,0))-SUM(ISNULL(SA_07,0))-(SUM(ISNULL(SB_04,0))+SUM(ISNULL(SB_01,0))+SUM(ISNULL(SB_02,0))+SUM(ISNULL(SB_03,0))+SUM(ISNULL(SB_07,0))+SUM(ISNULL(SB_06,0))
+SUM(ISNULL(SB_10,0))+SUM(ISNULL(SB_09,0)))-(ISNULL(a.OTHER_10001,0)+ISNULL(a.OTHER_10002,0)+ISNULL(a.OTHER_10003,0)+ISNULL(a.OTHER_10004,0)+ISNULL(a.OTHER_10005,0)+ISNULL(a.OTHER_10006,0)) 
-SUM(ISNULL(tax_deduction,0)) from pEMPPayRollHRLPerMM_all where DATEDIFF(mm,pay_date,a.pay_date)>=0 and emp_code=a.emp_code),2) as PersonalIncomeTaxYY,
-- 一次性奖金
ISNULL(a.SA_11,0) as OneTimeAnnualBonus,
-- 一次性奖金税
dbo.eFN_getPersonalIncomeTax(ISNULL(a.SA_11,0),3) as OneTimeAnnualBonusTax,
-- 备注
NULL as Remark
from pEMPPayRollHRLPerMM_all a
group by a.pay_date,a.emp_code,a.OTHER_10001,a.OTHER_10002,a.OTHER_10003,a.OTHER_10004,a.OTHER_10005,a.OTHER_10006,a.SA_11