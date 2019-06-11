USE [zszq]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER Procedure [dbo].[eSP_pEMPTrgtRspCntrMMRTSubmit]
-- skydatarefresh eSP_pEMPTrgtRspCntrMMRTSubmit
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
    ---- 主管部门负责人考核意见
    IF Exists(select 1 from pEMPTrgtRspCntrKPIMM a,pEMPTrgtRspCntrMM b,pVW_TrgtRspCntrReportTo c
    where a.KPIID=b.KPIID and b.SubmitSelf=1 and b.SubmitRT is NULL
    and c.ReportTo=@EID and a.EID=c.EID
    and a.CommRT is NULL)
    Begin
        Set @RetVal=930550
        Return @RetVal
    End


    Begin TRANSACTION

    -- 更新pEMPTrgtRspCntrKPIMM
    ---- 部门负责人业务考核递交
    update a
    set a.SubmitRT=1,a.DateRT=GETDATE()
    from pEMPTrgtRspCntrMM a,pVW_TrgtRspCntrReportTo b
    where b.ReportTo=@EID and a.EID=b.EID and ISNULL(a.SubmitRT,0)=0
    -- 异常流程
    If @@Error<>0
    Goto ErrM
    ---- 部门业务考核递交
    update a
    set a.IsSubmit=1,a.SubmitTime=GETDATE()
    from pTrgtRspCntrDep a
    where a.ReportTo=@EID and a.TRCLev=2
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