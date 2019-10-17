USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_EMPInsuranceAdd]
-- skydatarefresh eSP_EMPInsuranceAdd
    @ID int, 
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 添加员工(社会保险)(基于员工的EID或BID)
-- @ID为EID信息，表示员工的EID或者BID
*/
Begin

    -- 员工已存在，无法新增该员工!
    If Exists(Select 1 From pEMPInsurance_register Where ISNULL(EID,BID)=(select ISNULL(EID,BID) from pEMPInsurance where ID=@ID))
    Begin
        Set @RetVal = 930390
        Return @RetVal
    End


    Begin TRANSACTION

    -- 添加pEMPInsurance_register
    insert into pEMPInsurance_register(EID,BID,EMPInsuranceBase,EMPEndowBase,EMPMedicalBase,EMPUnemployBase,EMPMaternityBase,EMPInjuryBase,
    EMPInsuranceDate,EMPMedicalDate,EMPInsuranceLoc,EMPInsuranceDepart,InsRatioLocID,IsPostRetirement,IsLeave,Isabandon)
    select a.EID,a.BID,a.EMPInsuranceBase,a.EMPEndowBase,a.EMPMedicalBase,a.EMPUnemployBase,a.EMPMaternityBase,a.EMPInjuryBase,
    a.EMPInsuranceDate,a.EMPMedicalDate,a.EMPInsuranceLoc,a.EMPInsuranceDepart,a.InsRatioLocID,a.IsPostRetirement,a.IsLeave,a.Isabandon
    from pEMPInsurance a
    where a.ID=@ID
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