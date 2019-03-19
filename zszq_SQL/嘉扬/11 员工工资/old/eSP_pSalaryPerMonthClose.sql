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

    Declare @Date smalldatetime
    select @Date=Date from pSalaryPerMonth where ID=@ID

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

    -- 插入月度工资流程的交通费历史表项pEmployeeTraffic_all
    insert into pEmployeeTraffic_all(EID,Date,TrafficAllowance,SalaryContact,Remark)
    select a.EID,a.Date,a.TrafficAllowance,a.SalaryContact,a.Remark
    from pEmployeeTraffic a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的年金历史表项pEmployeePension_all
    insert into pEmployeePension_all(EID,Date,PensionEMPBT,PensionEMPAT,GrpPensionPerMM,GrpPensionMonthTotal,GrpPensionMonthRest,SalaryContact,Remark)
    select a.EID,a.Date,a.PensionEMPBT,a.PensionEMPAT,a.GrpPensionPerMM,a.GrpPensionMonthTotal,a.GrpPensionMonthRest,a.SalaryContact,a.Remark
    from pEmployeePension a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的五险一金历史表项pEmployeeEmoluFundIns_all
    insert into pEmployeeEmoluFundIns_all(EID,Date,HousingFundEMP,HousingFundGRP,EndowInsEMP,EndowInsGRP,
    MedicalInsEMP,MedicalInsGRP,UnemployInsEMP,UnemployInsGRP,MaternityInsGRP,InjuryInsGRP,
    HousingFundEMPPlus,HousingFundGRPPlus,EndowInsEMPPlus,EndowInsGRPPlus,MedicalInsEMPPlus,MedicalInsGRPPlus,
    UnemployInsEMPPlus,UnemployInsGRPPlus,MaternityInsGRPPlus,InjuryInsGRPPlus,HousingFundOverEMP,HousingFundOverGRP,
    FundInsEMPTotal,FundInsGRPTotal,FundInsEMPPlusTotal,FundInsGRPPlusTotal,SalaryContact,Remark)
    select a.EID,a.Date,a.HousingFundEMP,a.HousingFundGRP,a.EndowInsEMP,a.EndowInsGRP,
    a.MedicalInsEMP,a.MedicalInsGRP,a.UnemployInsEMP,a.UnemployInsGRP,a.MaternityInsGRP,a.InjuryInsGRP,
    a.HousingFundEMPPlus,a.HousingFundGRPPlus,a.EndowInsEMPPlus,a.EndowInsGRPPlus,a.MedicalInsEMPPlus,a.MedicalInsGRPPlus,
    a.UnemployInsEMPPlus,a.UnemployInsGRPPlus,a.MaternityInsGRPPlus,a.InjuryInsGRPPlus,a.HousingFundOverEMP,a.HousingFundOverGRP,
    a.FundInsEMPTotal,a.FundInsGRPTotal,a.FundInsEMPPlusTotal,a.FundInsGRPPlusTotal,a.SalaryContact,a.Remark
    from pEmployeeEmoluFundIns a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的奖金分配历史表项pEmployeeEmoluBonus_all
    insert into pEmployeeEmoluBonus_all(EID,Date,BonusTotalMM,GeneralBonus,OneTimeAnnualBonus,SalaryContact,Remark)
    select a.EID,a.Date,a.BonusTotalMM,a.GeneralBonus,a.OneTimeAnnualBonus,a.SalaryContact,a.Remark
    from pEmployeeEmoluBonus a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的过节费分配历史表项pEmployeeEmoluFestivalFee_all
    insert into pEmployeeEmoluFestivalFee_all(EID,Date,FestivalFeeType1,FestivalFee1,FestivalFeeType2,FestivalFee2,
    FestivalFeeType3,FestivalFee3,FestivalFeeTotal,SalaryContact,Remark)
    select a.EID,a.Date,a.FestivalFeeType1,a.FestivalFee1,a.FestivalFeeType2,a.FestivalFee2,
    a.FestivalFeeType3,a.FestivalFee3,a.FestivalFeeTotal,a.SalaryContact,a.Remark
    from pEmployeeEmoluFestivalFee a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的补发工资分配历史表项pEmployeeEmoluBackPay_all
    insert into pEmployeeEmoluBackPay_all(EID,Date,ProbationBackPay,NewStaffBackPay,AppointBackPay,AppraisalBackPay,
    ToSponsorBackPay,OvertimeBackPay,TransPostBackPay,BackPayTotal,SalaryContact,Remark)
    select a.EID,a.Date,a.ProbationBackPay,a.NewStaffBackPay,a.AppointBackPay,a.AppraisalBackPay,
    a.ToSponsorBackPay,a.OvertimeBackPay,a.TransPostBackPay,a.BackPayTotal,a.SalaryContact,a.Remark
    from pEmployeeEmoluBackPay a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的税前补贴分配历史表项pEmployeeEmoluAllowanceBT_all
    insert into pEmployeeEmoluAllowanceBT_all(EID,Date,SponsorAllowanceBT,DirverAllowanceBT,ComplAllowanceBT,
    RegFinMGAllowanceBT,SalesMGAllowanceBT,CommAllowanceBT,CommAllowancePlus,AllowanceBTTotal,SalaryContact,Remark)
    select a.EID,a.Date,a.SponsorAllowanceBT,a.DirverAllowanceBT,a.ComplAllowanceBT,
    a.RegFinMGAllowanceBT,a.SalesMGAllowanceBT,a.CommAllowanceBT,a.CommAllowancePlus,a.AllowanceBTTotal,a.SalaryContact,a.Remark
    from pEmployeeEmoluAllowanceBT a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的税前扣款分配历史表项pEmployeeEmoluDeductionBT_all
    insert into pEmployeeEmoluDeductionBT_all(EID,Date,SickDeductionDays,SickDeductionBT,CompassDeductionDays,CompassDeductionBT,PunishDeductionBT,
    OthersDeductionBT,DeductionBTTotal,SalaryContact,Remark)
    select a.EID,a.Date,a.SickDeductionDays,a.SickDeductionBT,a.CompassDeductionDays,a.CompassDeductionBT,a.PunishDeductionBT,
    a.OthersDeductionBT,a.DeductionBTTotal,a.SalaryContact,a.Remark
    from pEmployeeEmoluDeductionBT a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的税后扣款分配历史表项pEmployeeEmoluDeductionAT_all
    insert into pEmployeeEmoluDeductionAT_all(EID,Date,ComputerDeductionAT,TaxDeductionAT,OthersDeductionAT,
    DeductionATTotal,SalaryContact,Remark)
    select a.EID,a.Date,a.ComputerDeductionAT,a.TaxDeductionAT,a.OthersDeductionAT,
    a.DeductionATTotal,a.SalaryContact,a.Remark
    from pEmployeeEmoluDeductionAT a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的税后补贴分配历史表项pEmployeeEmoluAllowanceAT_all
    insert into pEmployeeEmoluAllowanceAT_all(EID,Date,CommAllowanceAT,CommAllowancePlus,
    AllowanceATOthers,AllowanceATTotal,SalaryContact,Remark)
    select a.EID,a.Date,a.CommAllowanceAT,a.CommAllowancePlus,a.AllowanceATOthers,
    a.AllowanceATTotal,a.SalaryContact,a.Remark
    from pEmployeeEmoluAllowanceAT a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的税务调整分配历史表项pEmployeeEmoluTax_all
    insert into pEmployeeEmoluTax_all(EID,Date,TaxDeductionModifAT,TaxFeeReturnAT,TaxAllowanceAT,
    DonationRebateBT,SalaryContact,Remark)
    select a.EID,a.Date,a.TaxDeductionModifAT,a.TaxFeeReturnAT,a.TaxAllowanceAT,
    a.DonationRebateBT,a.SalaryContact,a.Remark
    from pEmployeeEmoluTax a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入月度工资流程的简表历史表项pEmployeeEmolu_all
    insert into pEmployeeEmolu_all(EID,Date,SalaryPerMM,BackPayTotal,AllowanceBTTotal,FestivalFeeTotal,GeneralBonus,
    DeductionBTTotal,TotalPayAmount,OneTimeAnnualBonus,HousingFundEMP,EndowInsEMP,MedicalInsEMP,UnemployInsEMP,FundInsEMPPlusTotal,
    PersonalIncomeTax,OneTimeAnnualBonusTax,AllowanceATTotal,DeductionATTotal,PensionEMPBT,PensionEMP,FinalPayingAmount)
    select a.EID,a.Date,a.SalaryPerMM,a.BackPayTotal,a.AllowanceBTTotal,a.FestivalFeeTotal,a.GeneralBonus,a.DeductionBTTotal,
    a.TotalPayAmount,a.OneTimeAnnualBonus,a.HousingFundEMP,a.EndowInsEMP,a.MedicalInsEMP,a.UnemployInsEMP,a.FundInsEMPPlusTotal,
    a.PersonalIncomeTax,a.OneTimeAnnualBonusTax,a.AllowanceATTotal,a.DeductionATTotal,a.PensionEMPBT,a.PensionEMP,a.FinalPayingAmount
    from pVW_EmployeeEmoluPerMMSimple a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新月度工资流程的通讯费
    update a
    set a.CommAllowance=ISNULL(ISNULL(b.CommAllowanceBT,c.CommAllowanceAT),a.CommAllowance),
    a.CommAllowancePlus=ISNULL(b.CommAllowancePlus,c.CommAllowancePlus)
    from pEmployeeComm a,pEmployeeEmoluAllowanceBT b,pEmployeeEmoluAllowanceAT c
    where a.EID=b.EID and a.EID=c.EID
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    -- 插入通讯费历史表项pEmployeeComm_all
    insert into pEmployeeComm_all(EID,Date,CommAllowance,CommAllowancePlus)
    select a.EID,a.Date,a.CommAllowance,a.CommAllowancePlus
    from pEmployeeComm a
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新月度工资流程的月度工资税前总额、月度个人所得税总额、月度工资税后总额，月度福利总额，月度通讯费总额
    update pSalaryPerMonth
    set TotalPayAmtTotalMM=(select SUM(TotalPayAmount) from pVW_EmployeeEmoluPerMMSimple),
    PersIncomeTaxTotalMM=(select SUM(PersonalIncomeTax) from pVW_EmployeeEmoluPerMMSimple),
    FinalPayingAmtTotalMM=(select SUM(FinalPayingAmount) from pVW_EmployeeEmoluPerMMSimple),
    FestivalFeeTotalMM=(select SUM(FestivalFeeTotal) from pVW_EmployeeEmoluPerMMSimple),
    CommAllowanceTotalMM=(select SUM(CommAllowance)+SUM(CommAllowancePlus) from pEmployeeComm)
    where ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入奖金历史表项pEmpEmoluBonusAll
    insert into pEmpEmoluBonusAll(EID,BonusYear,BonusType,BonusAmount,BonusDepID,BonusMonth1,BonusAmount1,
    BonusMonth2,BonusAmount2,BonusMonth3,BonusAmount3,BonusMonth4,BonusAmount4,BonusMonth5,BonusAmount5,
    BonusMonth6,BonusAmount6,BonusMonth7,BonusAmount7,BonusMonth8,BonusAmount8,BonusMonth9,BonusAmount9,
    BonusMonth10,BonusAmount10,BonusMonth11,BonusAmount11,BonusMonth12,BonusAmount12,Remark,Submit,SubmitBy,SubmitTime)
    select a.EID,a.BonusYear,a.BonusType,a.BonusAmount,a.BonusDepID,a.BonusMonth1,a.BonusAmount1,a.BonusMonth2,
    a.BonusAmount2,a.BonusMonth3,a.BonusAmount3,a.BonusMonth4,a.BonusAmount4,a.BonusMonth5,a.BonusAmount5,
    a.BonusMonth6,a.BonusAmount6,a.BonusMonth7,a.BonusAmount7,a.BonusMonth8,a.BonusAmount8,a.BonusMonth9,a.BonusAmount9,
    a.BonusMonth10,BonusAmount10,a.BonusMonth11,a.BonusAmount11,a.BonusMonth12,a.BonusAmount12,a.Remark,a.Submit,a.SubmitBy,a.SubmitTime
    from pEmpEmoluBonusAdd a
    where DATEDIFF(mm,a.BonusMonth1,@Date)>1 and DATEDIFF(mm,a.BonusMonth2,@Date)>1 and DATEDIFF(mm,a.BonusMonth3,@Date)>1
    and DATEDIFF(mm,a.BonusMonth4,@Date)>1 and DATEDIFF(mm,a.BonusMonth5,@Date)>1 and DATEDIFF(mm,a.BonusMonth6,@Date)>1
    and DATEDIFF(mm,a.BonusMonth7,@Date)>1 and DATEDIFF(mm,a.BonusMonth8,@Date)>1 and DATEDIFF(mm,a.BonusMonth9,@Date)>1
    and DATEDIFF(mm,a.BonusMonth10,@Date)>1 and DATEDIFF(mm,a.BonusMonth11,@Date)>1 and DATEDIFF(mm,a.BonusMonth12,@Date)>1
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 更新月度部门工资流程状态
    update a
    set a.IsSubmit=1
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


    -- 删除已原奖金表项pEmpEmoluBonusAdd
    delete from pEmpEmoluBonusAdd
    where DATEDIFF(mm,BonusMonth1,@Date)>1 and DATEDIFF(mm,BonusMonth2,@Date)>1 and DATEDIFF(mm,BonusMonth3,@Date)>1
    and DATEDIFF(mm,BonusMonth4,@Date)>1 and DATEDIFF(mm,BonusMonth5,@Date)>1 and DATEDIFF(mm,BonusMonth6,@Date)>1
    and DATEDIFF(mm,BonusMonth7,@Date)>1 and DATEDIFF(mm,BonusMonth8,@Date)>1 and DATEDIFF(mm,BonusMonth9,@Date)>1
    and DATEDIFF(mm,BonusMonth10,@Date)>1 and DATEDIFF(mm,BonusMonth11,@Date)>1 and DATEDIFF(mm,BonusMonth12,@Date)>1
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 删除交通费表项
    delete from pEmployeeTraffic
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除年金表项
    delete from pEmployeePension
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除五险一金表项
    delete from pEmployeeEmoluFundIns
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除奖金分配表项
    delete from pEmployeeEmoluBonus
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除过节费表项
    delete from pEmployeeEmoluFestivalFee
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除补发工资表项
    delete from pEmployeeEmoluBackPay
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除税前补贴表项
    delete from pEmployeeEmoluAllowanceBT
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除税前扣款表项
    delete from pEmployeeEmoluDeductionBT
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除税后扣款表项
    delete from pEmployeeEmoluDeductionAT
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除税后扣款表项
    delete from pEmployeeEmoluAllowanceAT
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除税务调整表项
    delete from pEmployeeEmoluTax
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除通讯费表项
    delete from pEmployeeComm
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