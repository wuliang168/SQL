USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[eSP_pEMPTrgtRspCntrMMSelfSubmit]
-- skydatarefresh eSP_pEMPTrgtRspCntrMMSelfSubmit
    @EID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 业务考核员工考核递交程序
-- @EID 为业务考核递交员工对应EID
-- @Status为业务考核递交阶段
*/
Begin

    -- 业务考核财务实际值为空，无法递交！
    IF Exists(select 1 from pEMPTrgtRspCntrKPIMM a,pEMPTrgtRspCntrMM b
    where b.EID=@EID and a.KPIID=b.KPIID and b.SubmitSelf is NULL
    and a.TRCTargetValue is not NULL and a.TRCActualValue is NULL)
    Begin
        Set @RetVal=930530
        Return @RetVal
    End

    -- 业务考核非财务实际值为空，无法递交！
    IF Exists(select 1 from pEMPTrgtRspCntrKPIMM a,pEMPTrgtRspCntrMM b
    where b.EID=@EID and a.KPIID=b.KPIID and b.SubmitSelf is NULL
    and a.TRCTarget is not NULL and a.TRCActualTarget is NULL)
    Begin
        Set @RetVal=930535
        Return @RetVal
    End

    -- 业务考核达成率为空，无法递交！
    IF Exists(select 1 from pEMPTrgtRspCntrKPIMM a,pEMPTrgtRspCntrMM b
    where b.EID=@EID and a.KPIID=b.KPIID and b.SubmitSelf is NULL
    and a.TRCTargetValue is NULL and a.TRCAchRate is NULL)
    Begin
        Set @RetVal=930540
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新pEMPTrgtRspCntrKPIMM
    ---- 本人业务考核递交
    update a
    set a.SubmitSelf=1,a.DateSelf=GETDATE()
    from pEMPTrgtRspCntrMM a
    where a.EID=@EID and ISNULL(a.SubmitSelf,0)=0
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 本人业务考核递交
    update a
    set a.IsSubmit=1,a.SubmitTime=GETDATE()
    from pTrgtRspCntrDep a
    where a.ReportTo=@EID and a.TRCLev=0
    -- 异常流程
    If @@Error<>0
    Goto ErrM


    -- 更新员工目标任务协议表项pEMPTrgtRspCntr_KPI
    update a
    set a.TRCTarget=b.TRCTarget,a.TRCActualTarget=b.TRCActualTarget,a.TRCActualValue=b.TRCActualValue,
    a.TRCAchRate=b.TRCAchRate,a.TRCAchDate=(select DATEADD(q,TRCQTR,TRCYear) from pTrgtRspCntr_Process where ID=b.ProcessID)
    from pEMPTrgtRspCntr_KPI a,pEMPTrgtRspCntrKPIMM b
    where a.KPIID=b.KPIID and a.TRCKPI=b.TRCKPI and b.EID=@EID and a.EID=b.EID 
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