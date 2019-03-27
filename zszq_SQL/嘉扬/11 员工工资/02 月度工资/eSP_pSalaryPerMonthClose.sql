USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pSalaryPerMonthClose]
-- skydatarefresh eSP_pSalaryPerMonthClose
    @ID int,
    @URID int,  
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 月度工资流程关闭程序
-- @ID 为月度工资流程对应ID
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin


    -- 月度工资流程未开启!
    If Exists(Select 1 From pSalaryPerMonth Where ID=@ID and Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 930094
        Return @RetVal
    End

    -- 月度工资流程已关闭!
    If Exists(Select 1 From pSalaryPerMonth Where ID=@ID and ISNULL(Closed,0)=1)
    Begin
        Set @RetVal = 930093
        Return @RetVal
    End

    Begin TRANSACTION


    -- 通讯费
    insert into pEMPCommPerMM_all(EID,Date,CommAllowance,CommAllowanceTotal,CommAllowanceType,SalaryContact,Remark,JoinDate)
    select EID,Date,CommAllowance,CommAllowanceTotal,CommAllowanceType,SalaryContact,Remark,JoinDate
    from pEMPCommPerMM
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 过节费
    insert into pEMPFestivalFeePerMM_all(EID,Date,FestivalFeeType,FestivalFee,SalaryContact,Remark)
    select EID,Date,FestivalFeeType,FestivalFee,SalaryContact,Remark
    from pEMPFestivalFeePerMM
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 税前税后费用
    insert into pEMPBTATPayPerMM_all(EID,Date,BTATPayType,BTATPay,SalaryContact,Remark)
    select EID,Date,BTATPayType,BTATPay,SalaryContact,Remark
    from pEMPBTATPayPerMM
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 专项附加扣除项
    insert into pPITSpclMinusPerMM_all(EID,Date,ChildEdu,ContEdu,CritiIll,HousLoanInte,HousRent,SuppElder,SalaryContact,Remark)
    select EID,Date,ChildEdu,ContEdu,CritiIll,HousLoanInte,HousRent,SuppElder,SalaryContact,Remark
    from pPITSpclMinusPerMM
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 月度工资明细
    insert into pEMPPayRollPerMM_all(PayRollMonth,EID,EMP_Code,SalaryTotal,BackPayBTTotal,AllowanceBTTotal,FestivalFeeBTTotal,
    GeneralBonus,DeductionBTTotal,TotalPayAmount,OneTimeAnnualBonus,HousingFundEMP,EndowInsEMP,MedicalInsEMP,UnemployInsEMP,FundInsEMPPlusTotal,
    PITSpclMinusTotal,TotalTaxAmount,PersonalIncomeTax,OneTimeAnnualBonusTax,AllowanceATTotal,DeductionATTotal,TaxFeeReturnAT,
    PensionEMPBT,PensionEMP,FinalPayingAmount,Remark)
    select PayRollMonth,EID,EMP_Code,SalaryTotal,BackPayBTTotal,AllowanceBTTotal,FestivalFeeBTTotal,GeneralBonus,DeductionBTTotal,
    TotalPayAmount,OneTimeAnnualBonus,HousingFundEMP,EndowInsEMP,MedicalInsEMP,UnemployInsEMP,FundInsEMPPlusTotal,PITSpclMinusTotal,TotalTaxAmount,
    PersonalIncomeTax,OneTimeAnnualBonusTax,AllowanceATTotal,DeductionATTotal,TaxFeeReturnAT,PensionEMPBT,PensionEMP,FinalPayingAmount,Remark
    from pVW_pEMPPayRollHRLCurMM
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除
    delete from pEMPCommPerMM
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    delete from pEMPFestivalFeePerMM
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    delete from pEMPBTATPayPerMM
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    delete from pPITSpclMinusPerMM
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 更新月度部门工资流程状态
    update a
    set a.IsClosed=1
    from pDepSalaryPerMonth a,pSalaryPerMonth b
    where a.Date=b.Date and b.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新月度工资流程状态
    update pSalaryPerMonth
    set Closed=1,ClosedBy=@URID,ClosedTime=GETDATE()
    where ID=@ID
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