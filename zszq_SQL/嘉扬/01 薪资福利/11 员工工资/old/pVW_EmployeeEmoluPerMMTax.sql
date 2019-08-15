-- pVW_EmployeeEmoluPerMMTax

-- 应税额：应发工资-五险一金(个人)-五险一金补缴(个人)-企业年金抵税额-捐款额-个税免征额+公积金超额(个人)+公积金超额(公司)+实物福利
select a.Date as Date,a.EID as EID,
-- 普通奖金税
(dbo.eFN_getPersonalIncomeTax(
    -- 捐款额不能超过申报的应纳税所得额30%
    (case when ISNULL(a.DonationRebateBT,0)>=ROUND((ISNULL(a.TotalPayAmount,0)-ISNULL(a.FundInsEMPTotal,0)-ISNULL(a.FundInsEMPPlusTotal,0)-ISNULL(a.PensionEMPBT,0)
    +ISNULL(a.FundEmpOver,0)+ISNULL(a.FundGRPOver,0)
    --+ISNULL(a.BenefitsInKind,0)
    )*0.3,2) 
    then ROUND((ISNULL(a.TotalPayAmount,0)-ISNULL(a.FundInsEMPTotal,0)-ISNULL(a.FundInsEMPPlusTotal,0)-ISNULL(a.PensionEMPBT,0)
    +ISNULL(a.FundEmpOver,0)+ISNULL(a.FundGRPOver,0)
    --+ISNULL(a.BenefitsInKind,0)
    )*0.7,2)
    else ISNULL(a.TotalPayAmount,0)-ISNULL(a.FundInsEMPTotal,0)-ISNULL(a.FundInsEMPPlusTotal,0)-ISNULL(a.PensionEMPBT,0)-ISNULL(a.DonationRebateBT,0)
    +ISNULL(a.FundEmpOver,0)+ISNULL(a.FundGRPOver,0)
    --+ISNULL(a.BenefitsInKind,0)
    end)-
    -- 本国和非本国员工
    (select TaxBase from oCD_TaxBaseType where ID=(case when l.country=41 then 1 else 2 end)),2)) as PersonalIncomeTax,
-- 一次性奖金税
(case when ISNULL(a.TotalPayAmount,0)-ISNULL(a.PensionEMPBT,0)-ISNULL(a.FundInsEMPTotal,0)-ISNULL(a.FundInsEMPPlusTotal,0)>=
(select TaxBase from oCD_TaxBaseType where ID=(case when l.country=41 then 1 else 2 end)) 
then dbo.eFN_getPersonalIncomeTax(ROUND(ISNULL(a.OneTimeAnnualBonus,0)/12,2),2)
else dbo.eFN_getPersonalIncomeTax(ROUND(ISNULL(a.OneTimeAnnualBonus,0)-((select TaxBase from oCD_TaxBaseType where ID=(case when l.country=41 then 1 else 2 end))-
(ISNULL(a.TotalPayAmount,0)-ISNULL(a.PensionEMPBT,0)-ISNULL(a.FundInsEMPTotal,0)-ISNULL(a.FundInsEMPPlusTotal,0)
+ISNULL(a.FundEmpOver,0)+ISNULL(a.FundGRPOver,0)
--+ISNULL(a.BenefitsInKind,0)
)),2),2) 
end) as OneTimeAnnualBonusTax
from pVW_EmployeeEmoluPerMMnoTax a
inner join eDetails as l on a.EID=l.EID