USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[eSP_pEMPTrgtRspCntrMMPTSubmit]
-- skydatarefresh eSP_pEMPTrgtRspCntrMMPTSubmit
    @EID int,
    @RetVal int=0 Output
As
/*
-- Create By wuliang E004205
-- 业务考核部门负责人考核递交程序
-- @EID 为业务考核递交部门负责人对应EID
-- @Status为业务考核递交阶段
*/
Begin

    -- 业务考核评语为空，无法递交！
    ---- 主管部门审核人考核意见
    IF Exists(select 1 from pEMPTrgtRspCntrMM a where a.PT=@EID and a.CommPT is NULL)
    Begin
        Set @RetVal=930550
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新pEMPTrgtRspCntrKPIMM
    ---- 部门审核人业务考核递交
    update a
    set a.SubmitPT=1,a.DatePT=GETDATE()
    from pEMPTrgtRspCntrMM a
    where a.PT=@EID and ISNULL(a.SubmitPT,0)=0
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 部门业务考核递交
    update a
    set a.IsSubmit=1,a.SubmitTime=GETDATE()
    from pTrgtRspCntrDep a
    where a.ReportTo=@EID and a.TRCLev=1
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