USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEMPInsHFChangeSubmit]
-- skydatarefresh eSP_pEMPInsHFChangeSubmit
    @EID int, 
    @BID int,
    @InsHFChangeType int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 五险一金员工调整(基于员工的EID)
-- @EID为EID信息，表示员工的EID
-- 入职：1；转移：2；离职：3；退休：4
*/
Begin

    -- 员工社保或公积金基数为空，无法递交!
    --If Exists(Select 1 From pEMPInsHFChange_register Where ISNULL(EID,BID)=ISNULL(@EID,@BID) and InsHFChangeType=@InsHFChangeType
    --and (EMPInsBase is NULL or EMPHFBase is NULL) and @InsHFChangeType in (1,2))
    --Begin
    --    Set @RetVal = 950210
    --    Return @RetVal
    --End

    -- 员工社保或公积金归属部门为空，无法递交!
    If Exists(Select 1 From pEMPInsHFChange_register Where ISNULL(EID,BID)=ISNULL(@EID,@BID) and InsHFChangeType=@InsHFChangeType
    and (EMPInsDepart is NULL or EMPHousingFundDepart is NULL) and @InsHFChangeType in (1,2))
    Begin
        Set @RetVal = 950220
        Return @RetVal
    End

    -- 员工社保或公积金缴纳地为空，无法递交!
    --If Exists(Select 1 From pEMPInsHFChange_register Where ISNULL(EID,BID)=ISNULL(@EID,@BID) and InsHFChangeType=@InsHFChangeType
    --and (EMPInsLoc is NULL or EMPHFLoc is NULL) and @InsHFChangeType in (1,2))
    --Begin
    --    Set @RetVal = 950230
    --    Return @RetVal
    --End

    -- 员工社保或公积金起缴时间为空，无法递交!
    --If Exists(Select 1 From pEMPInsHFChange_register Where ISNULL(EID,BID)=ISNULL(@EID,@BID) and InsHFChangeType=@InsHFChangeType
    --and (EMPInsDate is NULL or EMPHFDate is NULL) and @InsHFChangeType in (1,2))
    --Begin
    --    Set @RetVal = 950240
    --    Return @RetVal
    --End

    -- 员工社保或公积金止缴时间为空，无法递交!
    --If Exists(Select 1 From pEMPInsHFChange_register Where ISNULL(EID,BID)=ISNULL(@EID,@BID) and InsHFChangeType=@InsHFChangeType
    --and (EMPInsEndDate is NULL or EMPHFEndDate is NULL) and @InsHFChangeType=3)
    --Begin
    --    Set @RetVal = 950250
    --    Return @RetVal
    --End

    -- 员工社保公积金回缴金额为空，无法递交!
    --If Exists(Select 1 From pEMPInsHFChange_register Where ISNULL(EID,BID)=ISNULL(@EID,@BID) and InsHFChangeType=@InsHFChangeType
    --and EMPInsHFBack is NULL and @InsHFChangeType=3)
    --Begin
    --    Set @RetVal = 950260
    --    Return @RetVal
    --End


    Begin TRANSACTION

    -- 更新pEMPInsHFChange_register
    update pEMPInsHFChange_register
    set Submit=1,SubmitTime=GETDATE()
    where ISNULL(EID,BID)=ISNULL(@EID,@BID) and InsHFChangeType=@InsHFChangeType 

    -- 更新pEMPInsurance
    ---- 入职；转移
    update a
    set a.EMPInsuranceBase=ISNULL(b.EMPInsBase,a.EMPInsuranceBase),a.EMPEndowBase=ISNULL(b.EMPEndowBase,b.EMPInsBase),a.EMPMedicalBase=ISNULL(b.EMPMedicalBase,b.EMPInsBase),
    a.EMPUnemployBase=ISNULL(b.EMPUnemployBase,b.EMPInsBase),a.EMPMaternityBase=ISNULL(b.EMPMaternityBase,b.EMPInsBase),a.EMPInjuryBase=ISNULL(b.EMPInjuryBase,b.EMPInsBase),
    a.EMPInsuranceDate=ISNULL(b.EMPInsDate,a.EMPInsuranceBase),a.EMPMedicalDate=ISNULL(b.EMPInsDate,a.EMPMedicalDate),
    a.InsRatioLocID=ISNULL(b.EMPInsRatioLocID,a.InsRatioLocID),a.EMPInsuranceDepart=ISNULL(b.EMPInsDepart,a.EMPInsuranceDepart)
    from pEMPInsurance a,pEMPInsHFChange_register b
    where ISNULL(b.EID,b.BID)=ISNULL(@EID,@BID) and b.InsHFChangeType=@InsHFChangeType 
    and ISNULL(a.EID,a.BID)=ISNULL(b.EID,b.BID) and @InsHFChangeType in (1,2)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 更新pEMPHousingFund
    ---- 入职；转移
    update a
    set a.EMPHousingFundBase=ISNULL(b.EMPHFBase,a.EMPHousingFundBase),a.EMPHousingFundDate=ISNULL(b.EMPHFDate,a.EMPHousingFundDate),
    a.HFRatioLocID=b.EMPHFRatioLocID,a.EMPHousingFundDepart=b.EMPHousingFundDepart
    from pEMPHousingFund a,pEMPInsHFChange_register b
    where ISNULL(b.EID,b.BID)=ISNULL(@EID,@BID) and b.InsHFChangeType=@InsHFChangeType 
    and ISNULL(a.EID,a.BID)=ISNULL(b.EID,b.BID) and @InsHFChangeType in (1,2)
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 归档pEMPInsHFChange_all
    insert into pEMPInsHFChange_all(EID,BID,CompID,DepID1st,DepID2nd,JobID,JobTitle,EMPInsBase,EMPEndowBase,EMPMedicalBase,EMPUnemployBase,EMPMaternityBase,EMPInjuryBase,
    EMPHFBase,EMPInsHFBack,InsHFChangeType,EMPInsDate,EMPInsEndDate,EMPInsLoc_Orig,EMPInsLoc,EMPInsDepart_Orig,EMPInsDepart,EMPHFDate,EMPHFEndDate,
    EMPHFLoc_Orig,EMPHFLoc,EMPHFDepart_Orig,EMPHousingFundDepart,InsHFStatusType,Remark,Submit,SubmitTime)
    select EID,BID,CompID,DepID1st,DepID2nd,JobID,JobTitle,EMPInsBase,EMPEndowBase,EMPMedicalBase,EMPUnemployBase,EMPMaternityBase,EMPInjuryBase,
    EMPHFBase,EMPInsHFBack,InsHFChangeType,EMPInsDate,EMPInsEndDate,EMPInsLoc_Orig,EMPInsLoc,EMPInsDepart_Orig,EMPInsDepart,
    EMPHFDate,EMPHFEndDate,EMPHFLoc_Orig,EMPHFLoc,EMPHFDepart_Orig,EMPHousingFundDepart,InsHFStatusType,Remark,Submit,SubmitTime
    from pEMPInsHFChange_register
    where ISNULL(EID,BID)=ISNULL(@EID,@BID) and InsHFChangeType=@InsHFChangeType
    -- 异常流程
    If @@Error<>0
    Goto ErrM

    -- 删除pEMPInsHFChange_register
    delete from pEMPInsHFChange_register 
    where ISNULL(EID,BID)=ISNULL(@EID,@BID) and InsHFChangeType=@InsHFChangeType
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