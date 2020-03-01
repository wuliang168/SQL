-- pVW_EmployeeEmoluPerMMnoTax
select c.Date as Date,a.EID as EID,
-- 基本工资：固定工资(考核工资)+保代津贴+保代补贴
--- 转正前后工资计算
---- 未转正人员或者已转正但转正月份和发薪月份相同，固定工资80%(未包含考核工资)
((CASE When ISNULL(a.IsAppraised,0)=0 or DATEDIFF(mm,a.AppraisedDate,GETDATE())<1 
then (ISNULL(a.SalaryPerMM,0)-ISNULL(a.CheckUpSalary,0))*0.8+ISNULL(a.CheckUpSalary,0)
---- 其他已转正人员，固定工资100%   
else ISNULL(a.SalaryPerMM,0) end)+ISNULL(a.SponsorAllowance,0)+ISNULL(g.SponsorAllowanceBT,0)) as SalaryPerMM,
-- 补发工资+
ISNULL(f.BackPayTotal,0) as BackPayTotal,
-- 税前补贴
ISNULL(g.AllowanceBTTotal,0) as AllowanceBTTotal,
-- 过节费
ISNULL(e.FestivalFee,0) as FestivalFeeTotal,
-- 实物福利
--ISNULL(e.BenefitsInKind,0) as BenefitsInKind,
-- 奖金
ISNULL(d.GeneralBonus,0) as GeneralBonus,
-- 税前扣款
ISNULL(h.DeductionBTTotal,0) as DeductionBTTotal,
-- 应发工资：固定工资+保代津贴+补发工资+税前补贴+过节费+奖金-税前扣款
((CASE When ISNULL(a.IsAppraised,0)=0 or DATEDIFF(mm,a.AppraisedDate,GETDATE())<1 
then (ISNULL(a.SalaryPerMM,0)-ISNULL(a.CheckUpSalary,0))*0.8+ISNULL(a.CheckUpSalary,0)
else ISNULL(a.SalaryPerMM,0) end)+ISNULL(a.SponsorAllowance,0)+ISNULL(g.SponsorAllowanceBT,0)+ISNULL(f.BackPayTotal,0)+ISNULL(g.AllowanceBTTotal,0)
+ISNULL(e.FestivalFee,0)+ISNULL(d.GeneralBonus,0)-ISNULL(h.DeductionBTTotal,0)) as TotalPayAmount,
-- 一次性奖金
ISNULL(d.OneTimeAnnualBonus,0) as OneTimeAnnualBonus,
-- 公积金(个人)
ISNULL(a.HousingFundEMP,0) as HousingFundEMP,
-- 养老保险(个人)
ISNULL(a.EndowInsEMP,0) as EndowInsEMP,
-- 医疗保险(个人)
ISNULL(a.MedicalInsEMP,0) as MedicalInsEMP,
-- 失业保险(个人)
ISNULL(a.UnemployInsEMP,0) as UnemployInsEMP,
-- 五险一金合计(个人)
ISNULL(a.HousingFundEMP,0)+ISNULL(a.EndowInsEMP,0)+ISNULL(a.MedicalInsEMP,0)+ISNULL(a.UnemployInsEMP,0) as FundInsEMPTotal,
-- 五险一金补缴(个人)
ISNULL(c.FundInsEMPPlusTotal,0) as FundInsEMPPlusTotal,
-- 公积金超额(个人)
ISNULL(a.HousingFundOverEMP,0) as FundEmpOver,
-- 公积金超额(公司)
ISNULL(a.HousingFundOverGRP,0) as FundGRPOver,
-- 税后补贴
ISNULL(j.AllowanceATTotal,0) as AllowanceATTotal,
-- 税后扣款
ISNULL(i.DeductionATTotal,0) as DeductionATTotal,
-- 企业年金(个人)抵税额
ISNULL(b.PensionEMPBT,0) as PensionEMPBT,
-- 企业年金(个人)
(ISNULL(b.PensionEMPAT,0)+ISNULL(b.PensionEMPBT,0)) as PensionEMP,
-- 个税扣款调整
ISNULL(k.TaxDeductionModifAT,0) as TaxDeductionModifAT,
-- 个税手续费返还
ISNULL(k.TaxFeeReturnAT,0) as TaxFeeReturnAT,
-- 个税补贴调整
ISNULL(k.TaxAllowanceAT,0) as TaxAllowanceAT,
-- 捐款额
ISNULL(k.DonationRebateBT,0) as DonationRebateBT
from pEmployeeEmolu a
left join pEmployeePension as b on a.EID=b.EID
inner join pEmployeeEmoluFundIns as c on a.EID=c.EID
left join pEmployeeEmoluBonus as d on a.EID=d.EID
left join pEMPFestivalFeePerMM as e on a.EID=e.EID
left join pEmployeeEmoluBackPay as f on a.EID=f.EID
left join pEmployeeEmoluAllowanceBT as g on a.EID=g.EID
left join pEmployeeEmoluDeductionBT as h on a.EID=h.EID
left join pEmployeeEmoluDeductionAT as i on a.EID=i.EID
left join pEmployeeEmoluAllowanceAT as j on a.EID=j.EID
left join pEmployeeEmoluTax as k on a.EID=k.EID
inner join eDetails as l on a.EID=l.EID