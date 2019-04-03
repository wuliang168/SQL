USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEMPInsHFChangeAddEMP]
-- skydatarefresh eSP_pEMPInsHFChangeAddEMP
    @EID int, 
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
    If Exists(Select 1 From pEMPInsHFChange_register Where EID=@EID and InsHFChangeType=@InsHFChangeType)
    Begin
        Set @RetVal = 930390
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新pEMPInsHFChange_register
    insert into pEMPInsHFChange_register(EID,CompID,DepID1st,DepID2nd,JobID,InsHFChangeType,
    EMPInsBase,EMPEndowBase,EMPMedicalBase,EMPUnemployBase,EMPMaternityBase,EMPInjuryBase,EMPHFBase,EMPInsDate,EMPHFDate,
    EMPInsDepart,EMPInsLoc,EMPHFDepart,EMPHFLoc,EMPInsDepart_Orig,EMPInsLoc_Orig,EMPHFDepart_Orig,EMPHFLoc_Orig)
    select @EID,(select CompID from eEmployee where EID=@EID),(select dbo.eFN_getdepid1st(DepID) from eEmployee where EID=@EID),
    (select dbo.eFN_getdepid2nd(DepID) from eEmployee where EID=@EID),(select JobID from eEmployee where EID=@EID),@InsHFChangeType,
    (case when @InsHFChangeType=3 then (select EMPInsuranceBase from pEMPInsurance where EID=@EID) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPEndowBase from pEMPInsurance where EID=@EID) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPMedicalBase from pEMPInsurance where EID=@EID) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPUnemployBase from pEMPInsurance where EID=@EID) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPMaternityBase from pEMPInsurance where EID=@EID) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPInjuryBase from pEMPInsurance where EID=@EID) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPHousingFundBase from pEMPHousingFund where EID=@EID) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPInsuranceDate from pEMPInsurance where EID=@EID) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPHousingFundDate from pEMPHousingFund where EID=@EID) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPInsuranceDepart from pEMPInsurance where EID=@EID) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPInsuranceLoc from pEMPInsurance where EID=@EID) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPHousingFundDepart from pEMPHousingFund where EID=@EID) else NULL end),
    (case when @InsHFChangeType=3 then (select EMPHousingFundLoc from pEMPHousingFund where EID=@EID) else NULL end),
    (case when @InsHFChangeType=2 then (select EMPInsuranceDepart from pEMPInsurance where EID=@EID) else NULL end),
    (case when @InsHFChangeType=2 then (select EMPInsuranceLoc from pEMPInsurance where EID=@EID) else NULL end),
    (case when @InsHFChangeType=2 then (select EMPHousingFundDepart from pEMPHousingFund where EID=@EID) else NULL end),
    (case when @InsHFChangeType=2 then (select EMPHousingFundLoc from pEMPHousingFund where EID=@EID) else NULL end)
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