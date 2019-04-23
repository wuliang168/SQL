USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  Procedure [dbo].[eSP_pEMPTrgtRspCntrMMSubmit]
-- skydatarefresh eSP_pEMPTrgtRspCntrMMSubmit
    @Status int,
    @EID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 业务考核递交程序
-- @EID 为业务考核递交员工对应EID
-- @Status为业务考核递交阶段
*/
Begin

    -- 业务考核目标值为空，无法递交！
    IF Exists(select 1 from pEMPTrgtRspCntrKPIMM a,pVW_TrgtRspCntrReportTo b 
    where b.ReportTo=@EID and a.EID=b.EID and @Status=1 
    and a.TRCTargetValue is not NULL and a.TRCActualValue is NULL)
    Begin
        Set @RetVal=930530
        Return @RetVal
    End

    -- 业务考核目标达成率为空，无法递交！
    IF Exists(select 1 from pEMPTrgtRspCntrKPIMM a,pVW_TrgtRspCntrReportTo b 
    where b.ReportTo=@EID and a.EID=b.EID and @Status=1 
    and a.TRCAchRate is NULL)
    Begin
        Set @RetVal=930540
        Return @RetVal
    End

    -- 业务考核评语为空，无法递交！
    IF Exists(select 1 from pEMPTrgtRspCntrKPIMM a,pVW_TrgtRspCntrReportTo b 
    where b.ReportTo=@EID and a.EID=b.EID and @Status=2 
    and a.CommRT is NULL)
    Begin
        Set @RetVal=930550
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新pEMPTrgtRspCntrKPIMM
    ---- 本人业务考核递交
    update a
    set a.SubmitSelf=1,a.Status=2
    from pEMPTrgtRspCntrKPIMM a
    where a.EID=@EID and @Status=1
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 部门负责人业务考核递交
    update a
    set a.IsSubmit=1
    from pTrgtRspCntrDep a
    where a.ReportTo=@EID and @Status=2
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