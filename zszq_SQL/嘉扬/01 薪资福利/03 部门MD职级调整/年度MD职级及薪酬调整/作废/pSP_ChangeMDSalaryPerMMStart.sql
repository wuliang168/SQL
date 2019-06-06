USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[pSP_ChangeMDSalaryPerMMStart]
-- skydatarefresh pSP_ChangeMDSalaryPerMMStart
    @ID int,
    @URID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- MD职级及薪酬变更登记表的处理程序
-- @URID 为workshop操作账号的ID，前台通过 {U_URID} 全局参数获取
*/
Begin

    -- 数据还未确认!
    If Exists(Select 1 From pChangeMDSalaryPerMM_register Where ID=@ID And Isnull(Submit,0)=0)
    Begin
        Set @RetVal = 910020
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新pEmployeeEmolu的MDID、SalaryPerMM、SponsorAllowance、SalaryPayID和CheckUpSalary
    Update a
    Set a.MDID=ISNULL(b.MDIDtoModify,a.MDID),a.SalaryPerMM=ISNULL(b.SalaryPerMMCity,a.SalaryPerMM),
    a.SponsorAllowance=ISNULL(b.SponsorAllowancetoModify,a.SponsorAllowance),a.CheckUpSalary=ISNULL(b.CheckUpSalarytoModify,a.CheckUpSalary),
    a.SalaryPayID=b.SalaryPayID
    From pEmployeeEmolu a,pChangeMDSalaryPerMM_register b
    Where a.EID=b.EID and b.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新pEMPSalary(后续替代pEmployeeEmolu)
    Update a
    Set a.SalaryPerMM=ISNULL(b.SalaryPerMMCity,a.SalaryPerMM),
    a.SponsorAllowance=ISNULL(b.SponsorAllowancetoModify,a.SponsorAllowance),a.CheckUpSalary=ISNULL(b.CheckUpSalarytoModify,a.CheckUpSalary),
    a.SalaryPayID=b.SalaryPayID
    From pEMPSalary a,pChangeMDSalaryPerMM_register b
    Where a.EID=b.EID and b.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新pEMPAdminIDMD(后续替代pEmployeeEmolu)
    Update a
    Set a.MDID=ISNULL(b.MDIDtoModify,a.MDID)
    From pEMPAdminIDMD a,pChangeMDSalaryPerMM_register b
    Where a.EID=b.EID and b.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 插入MD职级变更登记表pChangeMDSalaryPerMM_all
    insert into pChangeMDSalaryPerMM_all (EID,MDID,SalaryPerMM,SponsorAllowance,CheckUpSalary,
    MDIDtoModify,SalaryPerMMtoModify,SalaryPayID,MDSalaryModifyReason,WorkCityRatio,SalaryPerMMCity,SponsorAllowancetoModify,CheckUpSalarytoModify,
    EffectiveDate,Submit,SubmitBy,SubmitTime)
    select a.EID,a.MDID,a.SalaryPerMM,a.SponsorAllowance,a.CheckUpSalary,
    a.MDIDtoModify,a.SalaryPerMMtoModify,a.SalaryPayID,a.MDSalaryModifyReason,a.WorkCityRatio,a.SalaryPerMMCity,a.SponsorAllowancetoModify,a.CheckUpSalarytoModify,
    a.EffectiveDate,a.Submit,a.SubmitBy,a.SubmitTime
    from pChangeMDSalaryPerMM_register a
    where id=@id
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除登记表
    delete from pChangeMDSalaryPerMM_register where id=@id
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