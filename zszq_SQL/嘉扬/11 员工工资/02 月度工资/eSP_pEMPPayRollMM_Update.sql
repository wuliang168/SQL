USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEMPPayRollMM_Update]
-- skydatarefresh eSP_pEMPPayRollMM_Update
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 月度工资更新eHR(2019以后工资数据)
*/
Begin


    Begin TRANSACTION

    -- 添加到pEMPPayRollPerMM_all
    insert into pEMPPayRollPerMM_all(EID,EMP_Code,PayRollMonth,SalaryTotal,BackPayBTTotal,AllowanceBTTotal,BackPayAlowBTTotal,
    FestivalFeeBTTotal,GeneralBonus,DeductionBTTotal,TotalPayAmount,OneTimeAnnualBonus,
    HousingFundEMP,EndowInsEMP,MedicalInsEMP,UnemployInsEMP,FundInsEMPPlusTotal,FundInsEMPTotal,PITSpclMinusTotal,
    TotalTaxAmount,PersonalIncomeTax,OneTimeAnnualBonusTax,AllowanceATTotal,DeductionATTotal,TaxFeeReturnAT,PensionEMP,PensionEMPBT,FinalPayingAmount)
    select a.EID,a.EMP_Code,a.PayRollMonth,a.SalaryTotal,a.BackPayBTTotal,a.AllowanceBTTotal,a.BackPayAlowBTTotal,
    a.FestivalFeeBTTotal,a.GeneralBonus,a.DeductionBTTotal,a.TotalPayAmount,a.OneTimeAnnualBonus,
    a.HousingFundEMP,a.EndowInsEMP,a.MedicalInsEMP,a.UnemployInsEMP,a.FundInsEMPPlusTotal,a.FundInsEMPTotal,a.PITSpclMinusTotal,
    a.TotalTaxAmount,a.PersonalIncomeTax,a.OneTimeAnnualBonusTax,a.AllowanceATTotal,a.DeductionATTotal,a.TaxFeeReturnAT,a.PensionEMP,a.PensionEMPBT,a.FinalPayingAmount
    from pVW_pEMPPayRollHRLMM_ALL a
    where a.PayRollMonth not in (select PayRollMonth from pEMPPayRollPerMM_all)
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 递交
    COMMIT TRANSACTION

    -- 正常处理流程
    Set @Retval = 0
    Return @Retval

    -- 异常处理流程
    ErrM:
    ROLLBACK TRANSACTION
    Set @Retval = -1
    Return @Retval

End