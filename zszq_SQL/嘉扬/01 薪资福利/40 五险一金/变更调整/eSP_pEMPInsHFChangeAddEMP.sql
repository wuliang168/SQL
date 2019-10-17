USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEMPInsHFChangeAddEMP]
-- skydatarefresh eSP_pEMPInsHFChangeAddEMP
    @EID int, 
    @BID int, 
    @InsHFChangeType int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 五险一金员工调整(基于员工的EID)
-- @EID为EID信息，表示员工的EID
*/
Begin

    -- 员工已存在，无法新增该员工!
    If Exists(Select 1 From pEMPInsHFChange_register Where ISNULL(EID,BID)=ISNULL(@EID,@BID) and InsHFChangeType=@InsHFChangeType)
    Begin
        Set @RetVal = 930390
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新pEMPInsHFChange_register
    insert into pEMPInsHFChange_register(EID,BID,CompID,DepID1st,DepID2nd,JobTitle,InsHFChangeType,
    EMPInsBase,EMPEndowBase,EMPMedicalBase,EMPUnemployBase,EMPMaternityBase,EMPInjuryBase,EMPHFBase,EMPInsDate,EMPHFDate,
    EMPInsDepart,EMPInsRatioLocID,EMPHousingFundDepart,EMPHFRatioLocID,EMPInsDepart_Orig,EMPInsRatioLocID_Orig,EMPHFDepart_Orig,EMPHFRatioLocID_Orig)
    select @EID,@BID,(select CompID from pVW_employee where ISNULL(EID,BID)=ISNULL(@EID,@BID)),(select DepID1st from pVW_employee where ISNULL(EID,BID)=ISNULL(@EID,@BID)),
    (select DepID2nd from pVW_employee where ISNULL(EID,BID)=ISNULL(@EID,@BID)),(select JobTitle from pVW_employee where ISNULL(EID,BID)=ISNULL(@EID,@BID)),@InsHFChangeType,
    (case when @InsHFChangeType=3 then (select EMPInsuranceBase from pEMPInsurance where ISNULL(EID,BID)=ISNULL(@EID,@BID)) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPEndowBase from pEMPInsurance where ISNULL(EID,BID)=ISNULL(@EID,@BID)) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPMedicalBase from pEMPInsurance where ISNULL(EID,BID)=ISNULL(@EID,@BID)) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPUnemployBase from pEMPInsurance where ISNULL(EID,BID)=ISNULL(@EID,@BID)) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPMaternityBase from pEMPInsurance where ISNULL(EID,BID)=ISNULL(@EID,@BID)) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPInjuryBase from pEMPInsurance where ISNULL(EID,BID)=ISNULL(@EID,@BID)) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPHousingFundBase from pEMPHousingFund where ISNULL(EID,BID)=ISNULL(@EID,@BID)) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPInsuranceDate from pEMPInsurance where ISNULL(EID,BID)=ISNULL(@EID,@BID)) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPHousingFundDate from pEMPHousingFund where ISNULL(EID,BID)=ISNULL(@EID,@BID)) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPInsuranceDepart from pEMPInsurance where ISNULL(EID,BID)=ISNULL(@EID,@BID)) else NULL end),
    (case when @InsHFChangeType=3 then (select InsRatioLocID from pEMPInsurance where ISNULL(EID,BID)=ISNULL(@EID,@BID)) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPHousingFundDepart from pEMPHousingFund where ISNULL(EID,BID)=ISNULL(@EID,@BID)) else NULL end),
    (case when @InsHFChangeType=3 then (select HFRatioLocID from pEMPHousingFund where ISNULL(EID,BID)=ISNULL(@EID,@BID)) else NULL end),
    (case when @InsHFChangeType=2 then (select EMPInsuranceDepart from pEMPInsurance where ISNULL(EID,BID)=ISNULL(@EID,@BID)) else NULL end),
    (case when @InsHFChangeType=2 then (select InsRatioLocID from pEMPInsurance where ISNULL(EID,BID)=ISNULL(@EID,@BID)) else NULL end),
    (case when @InsHFChangeType=2 then (select EMPHousingFundDepart from pEMPHousingFund where ISNULL(EID,BID)=ISNULL(@EID,@BID)) else NULL end),
    (case when @InsHFChangeType=2 then (select HFRatioLocID from pEMPHousingFund where ISNULL(EID,BID)=ISNULL(@EID,@BID)) else NULL end)
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