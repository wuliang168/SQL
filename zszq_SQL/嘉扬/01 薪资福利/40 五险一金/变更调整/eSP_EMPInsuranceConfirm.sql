USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_EMPInsuranceConfirm]
-- skydatarefresh eSP_EMPInsuranceConfirm
    @ID int, 
    @URID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 员工变更确认(社会保险)(基于员工的ID)
-- @ID为ID信息，表示员工的EID或者BID
*/
Begin

    -- 员工五险一金的社保基数为空！
    If Exists(Select 1 From pEMPInsurance_register Where ID=@ID and EMPInsuranceBase is NULL and EMPEndowBase is NULL 
    and EMPMedicalBase is NULL and EMPUnemployBase is NULL and EMPMaternityBase is NULL and EMPInjuryBase is NULL)
    Begin
        Set @RetVal = 930111
        Return @RetVal
    End

    -- 员工五险一金的社保发放地为空！
    If Exists(Select 1 From pEMPInsurance_register Where ID=@ID and InsRatioLocID is NULL)
    Begin
        Set @RetVal = 930112
        Return @RetVal
    End


    Begin TRANSACTION

    -- 添加pEMPInsurance_register
    update a
    set a.EMPInsuranceBase=ISNULL(b.EMPInsuranceBase,a.EMPInsuranceBase),a.EMPEndowBase=ISNULL(ISNULL(b.EMPEndowBase,a.EMPEndowBase),a.EMPInsuranceBase),
    a.EMPMedicalBase=ISNULL(ISNULL(b.EMPMedicalBase,a.EMPMedicalBase),a.EMPInsuranceBase),a.EMPUnemployBase=ISNULL(ISNULL(b.EMPUnemployBase,a.EMPUnemployBase),a.EMPInsuranceBase),
    a.EMPMaternityBase=ISNULL(ISNULL(b.EMPMaternityBase,a.EMPMaternityBase),a.EMPInsuranceBase),a.EMPInjuryBase=ISNULL(ISNULL(b.EMPInjuryBase,a.EMPInjuryBase),a.EMPInsuranceBase),
    a.EMPInsuranceDate=ISNULL(b.EMPInsuranceDate,a.EMPInsuranceDate),a.EMPMedicalDate=ISNULL(b.EMPMedicalDate,a.EMPMedicalDate),
    a.InsRatioLocID=ISNULL(b.InsRatioLocID,a.InsRatioLocID),a.EMPInsuranceLoc=ISNULL(b.EMPInsuranceLoc,a.EMPInsuranceLoc),
    a.IsPostRetirement=ISNULL(b.IsPostRetirement,a.IsPostRetirement),a.IsLeave=ISNULL(b.IsLeave,a.IsLeave),a.Isabandon=ISNULL(b.Isabandon,a.Isabandon)
    from pEMPInsurance a,pEMPInsurance_register b
    where b.ID=@ID and ISNULL(a.EID,a.BID)=ISNULL(b.EID,b.BID)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 拷贝到pEMPInsurance_all
    insert into pEMPInsurance_all(EID,BID,EMPInsuranceBase,EMPEndowBase,EMPMedicalBase,EMPUnemployBase,EMPMaternityBase,EMPInjuryBase,
    EMPInsuranceDate,EMPMedicalDate,EMPInsuranceLoc,InsRatioLocID,EMPInsuranceDepart,IsPostRetirement,IsLeave,Isabandon,Submit,Submitby,SubmitTime)
    select a.EID,a.BID,a.EMPInsuranceBase,a.EMPEndowBase,a.EMPMedicalBase,a.EMPUnemployBase,a.EMPMaternityBase,a.EMPInjuryBase,
    a.EMPInsuranceDate,a.EMPMedicalDate,a.EMPInsuranceLoc,a.InsRatioLocID,a.EMPInsuranceDepart,a.IsPostRetirement,a.IsLeave,a.Isabandon,a.Submit,a.Submitby,a.SubmitTime
    from pEMPInsurance_register a
    where a.ID=@ID
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除pEMPInsurance_register
    delete from pEMPInsurance_register where ID=@ID
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